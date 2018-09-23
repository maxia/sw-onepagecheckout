;(function ($) {
    'use strict';

    $.plugin('onePageCheckout', {

        defaults: {
            loginPanelTitleSelector: '.checkout--personal-data .register--existing-customer > .panel--title',
            loginPanelBodySelector: '.checkout--personal-data .register--existing-customer > .panel--body',
            registerPanelTitleSelector: '.checkout--personal-data .register--content .register--personal > .panel--title',
            registerPanelBodySelector: '.checkout--personal-data .register--content .register--personal .register--form',

            confirmFormSelector: '#confirm--form',
            quantityFormSelector: '.checkout--confirm .product--table form',

            shippingPaymentConfirmSectionSelector: '.checkout--shipping-payment-confirm',
            shippingPaymentSectionSelector: '.checkout--shipping-payment',
            confirmSectionSelector: '.checkout--confirm',

            shippingPaymentInputSelector: '.checkout--shipping-payment input.auto_submit[type=radio]'
        },


        init: function () {
            this.applyDataAttributes();

            this.initLoginRegister();
            this.initAjaxShippingPayment();
            this.initAjaxQuantity();
        },

        /**
         * Initializes register/login panel toggle using swCollapsePanel
         */
        initLoginRegister: function() {
            StateManager.addPlugin(this.opts.loginPanelTitleSelector, 'swCollapsePanel');
            StateManager.addPlugin(this.opts.registerPanelTitleSelector, 'swCollapsePanel');
        },


        reinitializeSections: function() {
            $.publish('plugin/onePageCheckout/initSections', [ this ]);

            var $container = this.$el.find(this.opts.shippingPaymentConfirmSectionSelector);
            $container.find('input[type="submit"][form], button[form]').swFormPolyfill();
            $container.find('select:not([data-no-fancy-select="true"])').swSelectboxReplacement();

            /*
            StateManager.addPlugin(this.opts.shippingPaymentConfirmSectionSelector + ' input[type="number"]', 'numberInput');
            StateManager.addPlugin(this.opts.shippingPaymentConfirmSectionSelector + ' .number-input-apply-button', 'cartApplyButton');
            */
            StateManager.addPlugin(this.opts.shippingPaymentConfirmSectionSelector + ' *[data-preloader-button="true"]', 'swPreloaderButton');

            this.initAjaxShippingPayment();
            this.initAjaxQuantity();
        },

        /**
         * Reloads the payment and overview section when the payment selection changes
         */
        initAjaxShippingPayment: function() {
            var me = this,
                $container = this.$el.find(this.opts.shippingPaymentConfirmSectionSelector),
                $form = $container.find(this.opts.confirmFormSelector),
                $inputs = $container.find(this.opts.shippingPaymentInputSelector),
                $confirmSection = this.$el.find(this.opts.confirmSectionSelector),
                $shippingPaymentSection = this.$el.find(this.opts.shippingPaymentSectionSelector),
                url = $form.attr('action');

            // submit radio buttons together with confirm form
            $shippingPaymentSection.find('.payment--method-list input, .dispatch--method-list input')
                .attr('form', $form.attr('id').replace('#', ''));

            $inputs.on('change', function() {
                $confirmSection.addClass('checkout--section--disabled');
                $shippingPaymentSection.addClass('checkout--section--disabled');
                $.loadingIndicator.open({
                    openOverlay: false
                });

                var data = $form.serialize() + '&isXHR=1';

                $.ajax({
                    type: "POST",
                    url: url,
                    data: data,
                    success: function(res) {
                        $container.replaceWith(res);

                        $.publish('plugin/onePageCheckout/shippingPaymentChanged', [ me, data]);
                        me.reinitializeSections();

                        $.loadingIndicator.close();
                        window.picturefill();
                    }
                });
            });
        },

        initAjaxQuantity: function() {
            var me = this,
                $container = this.$el.find(this.opts.shippingPaymentConfirmSectionSelector),
                $forms = $container.find(this.opts.quantityFormSelector),
                $confirmForm = $container.find(this.opts.confirmFormSelector),
                $confirmSection = this.$el.find(this.opts.confirmSectionSelector),
                $shippingPaymentSection = this.$el.find(this.opts.shippingPaymentSectionSelector);

            $forms.on('submit', function() {
                var $form = $(this);

                $confirmSection.addClass('checkout--section--disabled');
                $shippingPaymentSection.addClass('checkout--section--disabled');
                $.loadingIndicator.open({
                    openOverlay: false
                });

                var data = $confirmForm.serialize() + '&' + $form.serialize() + '&isXHR=1';

                $.ajax({
                    type: "POST",
                    url: $form.attr('action'),
                    data: data,
                    success: function(res) {
                        $container.replaceWith(res);

                        $.publish('plugin/onePageCheckout/quantityChanged', [ me, data ]);
                        me.reinitializeSections();

                        $.loadingIndicator.close();
                        window.picturefill();

                    }
                });

                return false;
            });
        },

        destroy: function () {
            var me = this;

            me._destroy();
        }
    });
})(jQuery);

jQuery(document).ready(function() {
    window.StateManager.addPlugin('div[data-onepagecheckout="true"]', 'onePageCheckout');
});