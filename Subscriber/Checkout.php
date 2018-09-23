<?php

namespace OnePageCheckout\Subscriber;
use Enlight\Event\SubscriberInterface;

class Checkout implements SubscriberInterface
{
    public static function getSubscribedEvents()
    {
        return [
            'Enlight_Controller_Action_PreDispatch_Frontend_Checkout' => 'preDispatchCheckout',
            'Enlight_Controller_Action_PostDispatch_Frontend_Account' => 'postDispatchAccount',
            'Enlight_Controller_Dispatcher_ControllerPath_Frontend_Onepagecheckout' => 'onController',
        ];
    }

    private $pluginDir;
    /** @var sSession session */
    private $session;

    public function __construct($pluginDir)
    {
        $this->pluginDir = $pluginDir;
        $this->session = Shopware()->Session();
    }

    /**
     * Registers the OnePageCheckout controller
     * @return string
     */
    public function onController()
    {
        return $this->pluginDir . 'Controllers/Frontend/OnePageCheckout.php';
    }

    /**
     * Forwards shippingPayment and confirm actions to our custom controller
     * @param \Enlight_Controller_ActionEventArgs $args
     */
    public function preDispatchCheckout(\Enlight_Controller_ActionEventArgs $args)
    {
        $controller = $args->getSubject();
        $request = $controller->Request();
        $action = $request->getActionName();

        if ($action == 'confirm') {
            return $controller->forward(
                'confirm',
                'onepagecheckout',
                null,
                [ 'checkoutController' => $controller ]
            );

        } else if ($action == 'shippingPayment') {
            $controller->redirect(['controller' => 'checkout', 'action' => 'confirm']);
            $request->setDispatched(true);

        } else if ($action == 'payment' || $action == 'finish') {

            // set request params from last request
            $params = isset($this->session['checkoutParams'])
                ? $this->session['checkoutParams']
                : [];

            $request->setParams($params, $request->getParams());
        }
    }

    /**
     * Renames error messages array when login was called through our checkout controller.
     * Loads the confirm page when account/payment action has checkout as its target.
     * @param \Enlight_Controller_ActionEventArgs $args
     */
    public function postDispatchAccount(\Enlight_Controller_ActionEventArgs $args)
    {
        $controller = $args->getSubject();
        $request = $controller->Request();

        if ($request->getParam('opc_dispatched') && $controller->View()->sErrorMessages) {
            $this->renameFormData($args->getSubject()->View(), 'login');

        } else if ($request->getActionName() == 'payment' && $request->getParam('sTarget') == 'checkout') {
            $controller->forward(
                'confirm',
                'checkout'
            );
        }
    }

    protected function renameFormData(&$view, $prefix)
    {
        $prefix = ucfirst($prefix);

        if (isset($view->sErrorMessages)) {
            $view->{'s'.$prefix.'ErrorMessages'} = $view->sErrorMessages;
            unset($view->sErrorMessages);
        }

        if (isset($view->sErrorFlag)) {
            $view->{'s'.$prefix.'ErrorFlag'} = $view->sErrorFlag;
            unset($view->sErrorFlag);
        }

        if (isset($view->sFormData)) {
            $view->{'s'.$prefix.'FormData'} = $view->sFormData;
            unset($view->sFormData);
        }
    }
}