<?php

use Shopware\Models\Customer\Address;

/**
 * This is mostly a copy of the shopware checkout controller.
 * Requests to checkout/shippingPayment and checkout/confirm are forwarded to this controller
 * The confirm and shippingMethod actions are merged together since we only have a single page.
 *
 * Class Shopware_Controllers_Frontend_OnePageCheckout
 */
class Shopware_Controllers_Frontend_OnePageCheckout extends Enlight_Controller_Action
{
    /** @var \Shopware_Controllers_Frontend_Checkout $checkout */
    protected $checkout;

    /** @var sAdmin $admin */
    private $admin;
    /** @var sBasket $basket */
    private $basket;
    /** @var sSession session */
    private $session;

    public function preDispatch()
    {
        if ($this->Request()->getActionName() == 'payment' ||
            $this->Request()->getActionName() == 'finish')
        {
            // use checkout params from last request
            if (isset($this->session['checkoutParams']) && $this->session['checkoutParams']) {
                $this->Request()->setParams(
                    $this->session['checkoutParams'],
                    $this->Request()->getParams()
                );
            }
        }
        else if ($this->Request()->getActionName() == 'confirm') {
            $this->admin = Shopware()->Modules()->Admin();
            $this->basket = Shopware()->Modules()->Basket();
            $this->session = Shopware()->Session();
            $this->checkout = $this->Request()->getParam('checkoutController');
        }
    }

    public function postDispatch()
    {
        // trigger the original checkout PostDispatch event manually
        if ($this->checkout) {
            $args = new Enlight_Controller_ActionEventArgs(array(
                'subject'  => $this->checkout,
                'request'  => $this->Request(),
                'response' => $this->Response()
            ));

            Shopware()->Events()->notify(
                'Enlight_Controller_Action_PostDispatch_Frontend_Checkout',
                $args
            );

            if ($this->Request()->isSecure()) {

                Shopware()->Events()->notify(
                    'Enlight_Controller_Action_PostDispatchSecure_Frontend_Checkout',
                    $args
                );
            }
        }
    }

    /**
     * Update cart quantity and forward to the confirm page
     * @throws Enlight_Exception
     */
    public function changeQuantityAction()
    {
        if ($this->Request()->getParam('sArticle') && $this->Request()->getParam('sQuantity')) {
            $this->View()->sBasketInfo = Shopware()->Modules()->Basket()->sUpdateArticle(
                $this->Request()->getParam('sArticle'),
                $this->Request()->getParam('sQuantity')
            );
        }

        return $this->forward('confirm', 'checkout', null, ['isXHR' => true]);
    }

    /**
     * Loads the confirm page and runs the login / register action when not logged in.
     * Saves and validates shipping and payment on each request when logged in.
     * @throws Enlight_Exception
     * @throws Exception
     */
    public function confirmAction()
    {
        if ($this->basket->sCountBasket() < 1) {
            return $this->redirect(['controller' => 'checkout', 'action' => 'cart']);
        }

        $this->setView($this->checkout->View());
        $this->Request()->setParam('opc_dispatched', true);
        $this->Request()->setControllerName('checkout');

        // Load current and all shipping methods
        $this->View()->sCountry = $this->checkout->getSelectedCountry();
        $this->View()->sState = $this->checkout->getSelectedState();

        // We might change the shop context here so we need to initialize it again
        $this->get('shopware_storefront.context_service')->initializeShopContext();

        $this->View()->sBasket = $this->checkout->getBasket();
        $this->View()->sLaststock = $this->basket->sCheckBasketQuantities();
        $this->View()->sShippingcosts = $this->View()->sBasket['sShippingcosts'];
        $this->View()->sShippingcostsDifference = $this->View()->sBasket['sShippingcostsDifference'];
        $this->View()->sAmount = $this->View()->sBasket['sAmount'];
        $this->View()->sAmountWithTax = $this->View()->sBasket['sAmountWithTax'];
        $this->View()->sAmountTax = $this->View()->sBasket['sAmountTax'];
        $this->View()->sAmountNet = $this->View()->sBasket['AmountNetNumeric'];
        $this->View()->sPremiums = $this->checkout->getPremiums();
        $this->View()->sNewsletter = isset($this->session['sNewsletter']) ? $this->session['sNewsletter'] : null;
        $this->View()->sComment = isset($this->session['sComment']) ? $this->session['sComment'] : null;
        $this->View()->sShowEsdNote = $this->checkout->getEsdNote();
        $this->View()->sDispatchNoOrder = $this->checkout->getDispatchNoOrder();
        $this->View()->sPayments = $this->admin->sGetPaymentMeans();
        $this->View()->sTargetAction = 'confirm';
        $this->View()->sTarget = 'checkout';

        if (empty($this->View()->sUserLoggedIn)) {
            $this->View()->showNoAccount = true;
            $this->View()->sRegisterFinished = false;
            $this->View()->showShippingPaymentStep = false;
            $this->View()->showConfirmStep = false;
            $this->View()->sDispatch = $this->checkout->getSelectedDispatch();
            $this->View()->sDispatches = $this->checkout->getDispatches($this->View()->sFormData['payment']);

            $params = [
                'sTarget' => 'checkout',
                'sTargetAction' => 'confirm',
                'showNoAccount' => true,
                'forceSecure' => true
            ];

            if ($this->Request()->isPost()) {
                // handle login and register forms
                if ($this->Request()->getParam('registerAction')) {
                    $this->forward('saveRegister', 'register', null, $params);

                } else if ($this->Request()->getParam('loginAction')) {
                    $this->forward('login', 'account', null, $params);
                }
            } else {
                // run the register/index action to populate forms
                $this->forward('index', 'register', null, $params);
            }
        } else {
            $this->View()->showNoAccount = false;
            $this->View()->sRegisterFinished = !empty($this->session['sRegisterFinished']);
            $this->View()->showShippingPaymentStep = true;
            $this->View()->showConfirmStep = true;

            // load payment class, set form defaults
            $this->View()->sFormData = array('payment' => $this->View()->sUserData['additional']['user']['paymentID']);
            $getPaymentDetails = $this->admin->sGetPaymentMeanById($this->View()->sFormData['payment']);

            $paymentClass = $this->admin->sInitiatePaymentClass($getPaymentDetails);
            if ($paymentClass instanceof \ShopwarePlugin\PaymentMethods\Components\BasePaymentMethod) {
                $data = $paymentClass->getCurrentPaymentDataAsArray(Shopware()->Session()->sUserId);
                if (!empty($data)) {
                    $this->View()->sFormData += $data;
                }
            }

            // save shipping method and payment selection
            if ($this->Request()->isPost()) {
                $this->saveShippingPayment();

                $values = $this->Request()->getPost();
                $values['payment'] = $this->Request()->getPost('payment');
                $values['isPost'] = true;
                $this->View()->sFormData = $values;
            }

            // set selected dispatch
            $this->View()->sDispatch = $this->checkout->getSelectedDispatch();
            $this->View()->sDispatches = $this->checkout->getDispatches($this->View()->sFormData['payment']);

            if ($this->Request()->getParam('isXHR')) {
                // on ajax shipping method change, return the shipping payment area template only
                return $this->View()->loadTemplate('frontend/opc/shipping_payment_confirm.tpl');
            }

            // check if selected payment was validated
            $payment = $this->checkout->getSelectedPayment();
            if (array_key_exists('validation', $payment) && !empty($payment['validation'])) {
                return;
            }

            $this->View()->sPayment = $payment;
            $userData = $this->View()->sUserData;
            $userData["additional"]["payment"] = $this->View()->sPayment;

            // order is valid
            $this->checkout->saveTemporaryOrder();

            $sOrderVariables = $this->View()->getAssign();
            $sOrderVariables['sBasketView'] = $sOrderVariables['sBasket'];
            $sOrderVariables['sBasket'] = $this->checkout->getBasket(false);

            $this->session['sOrderVariables'] = new ArrayObject($sOrderVariables, ArrayObject::ARRAY_AS_PROPS);

            $agbChecked = $this->Request()->getParam('sAGB');
            if (!empty($agbChecked)) {
                $this->View()->assign('sAGBChecked', true);
            }

            $this->View()->assign('hasMixedArticles', $this->basketHasMixedArticles($this->View()->sBasket));
            $this->View()->assign('hasServiceArticles', $this->basketHasServiceArticles($this->View()->sBasket));

            if (Shopware()->Config()->get('showEsdWarning')) {
                $this->View()->assign('hasEsdArticles', $this->basketHasEsdArticles($this->View()->sBasket));
            }

            $serviceChecked = $this->Request()->getParam('serviceAgreementChecked');
            if (!empty($serviceChecked)) {
                $this->View()->assign('serviceAgreementChecked', true);
            }

            $esdChecked = $this->Request()->getParam('esdAgreementChecked');
            if (!empty($esdChecked)) {
                $this->View()->assign('esdAgreementChecked', true);
            }

            $errors = $this->Request()->getParam('agreementErrors');
            if (!empty($errors)) {
                $this->View()->assign('agreementErrors', $errors);
            }

            $voucherErrors = $this->Request()->getParam('voucherErrors');
            if (!empty($voucherErrors)) {
                $this->View()->assign('sVoucherError', $voucherErrors);
            }

            if (empty($activeBillingAddressId = $this->session->offsetGet('checkoutBillingAddressId'))) {
                $activeBillingAddressId = $userData['additional']['user']['default_billing_address_id'];
            }

            if (empty($activeShippingAddressId = $this->session->offsetGet('checkoutShippingAddressId'))) {
                $activeShippingAddressId = $userData['additional']['user']['default_shipping_address_id'];
            }

            $this->View()->assign('activeBillingAddressId', $activeBillingAddressId);
            $this->View()->assign('activeShippingAddressId', $activeShippingAddressId);

            $this->View()->assign('invalidBillingAddress', !$this->isValidAddress($activeBillingAddressId));
            $this->View()->assign('invalidShippingAddress', !$this->isValidAddress($activeShippingAddressId));

            if ($this->Request()->isPost()) {
                $this->session['checkoutParams'] = [
                    'sAGB' => $this->View()->sAGBChecked
                ];

                if ($payment['embediframe'] || $payment['action']) {
                    $this->redirect(['controller' => 'checkout', 'action' => 'payment']);
                }
            }
        }
    }

    /**
     * Execute original saveShippingPaymentAction but clear the redirect and forwards after it
     * @throws Zend_Controller_Response_Exception
     */
    public function saveShippingPayment()
    {
        $code = $this->Response()->getHttpResponseCode();
        $this->checkout->saveShippingPaymentAction();

        if ($this->Response()->isRedirect()) {
            $this->Response()->clearHeader('Location');
            $this->Response()->setHttpResponseCode($code);
        }

        $this->Request()->setDispatched(true);
    }

    /**
     * Validates the given address id with current shop configuration
     *
     * @param $addressId
     * @return bool
     */
    private function isValidAddress($addressId)
    {
        $address = $this->get('models')->find(Address::class, $addressId);

        return $this->get('shopware_account.address_validator')->isValid($address);
    }

    /**
     * Helper function that iterates through the basket articles.
     * If checks if the basket has a normal article e.g. not an esd article
     * and not a article with the service attribute is set to true.
     *
     * @param array $basket
     * @return bool
     */
    private function basketHasMixedArticles($basket)
    {
        $config = Shopware()->Config();
        $attrName = $config->serviceAttrField;

        if (!isset($basket['content'])) {
            return false;
        }

        foreach ($basket['content'] as $article) {
            if ($article['modus'] == 4 || $article['esd']) {
                continue;
            }

            $serviceAttr = $article['additional_details'][$attrName];
            if (empty($attrName) || ($serviceAttr && $serviceAttr != 'false')) {
                continue;
            }

            return true;
        }

        return false;
    }

    /**
     * Helper function that checks whether or not the given basket has an esd article in it.
     *
     * @param array $basket
     * @return bool
     */
    private function basketHasEsdArticles($basket)
    {
        if (!isset($basket['content'])) {
            return false;
        }

        foreach ($basket['content'] as $article) {
            if ($article['esd']) {
                return true;
            }
        }

        return false;
    }

    /**
     * Helper function that iterates through the basket articles.
     * It checks if an article is a service article by comparing its attributes
     * with the plugin config serviceAttrField value.
     *
     * @param array $basket
     * @return bool
     */
    private function basketHasServiceArticles($basket)
    {
        $config = Shopware()->Config();

        if (!$config->offsetExists('serviceAttrField')) {
            return false;
        }

        $attrName = $config->serviceAttrField;
        if (empty($attrName) || !isset($basket['content'])) {
            return false;
        }

        foreach ($basket['content'] as $article) {
            $serviceAttr = $article['additional_details'][$attrName];

            if ($serviceAttr && $serviceAttr != 'false') {
                return true;
            }
        }
        return false;
    }
}