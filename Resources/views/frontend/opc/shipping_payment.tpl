<div class="checkout--section checkout--shipping-payment confirm--outer-container content--confirm{if !$showShippingPaymentStep} checkout--section--disabled{/if}">

    {* Payment and shipping information *}
    <div class="shipping-payment--information">

        <div class="panel has--border is--rounded">

            {block name='frontend_checkout_shipping_payment_headline'}
                <div class="shipping-payment--headline panel--title is--underline checkout--step-title">
                    <span class="icon">2</span>
                    <span class="text">
                        Zahlungsart und Versand
                    </span>
                </div>
            {/block}

            {block name='frontend_checkout_payment_content'}{/block}

            {block name='frontend_checkout_shipping_payment_content'}
                <div class="panel--body is--wide block-group">

                    {* Error messages *}
                    {block name='frontend_checkout_confirm_error_messages'}
                        {include file="frontend/checkout/error_messages.tpl"}
                    {/block}

                    {block name='frontend_account_payment_error_messages'}
                        {include file="frontend/register/error_message.tpl" error_messages=$sErrorMessages}
                    {/block}

                    {* Payment method *}
                    <div class="confirm--inner-container block">
                        {block name='frontend_checkout_shipping_payment_core_payment_fields'}
                            {include file='frontend/opc/partials/change_payment.tpl' form_data=$sFormData error_flags=$sErrorFlag payment_means=$sPaymentMeans}
                        {/block}
                    </div>

                    {* Shipping method *}
                    {if $sDispatches}
                        <div class="confirm--inner-container block">
                            {block name='frontend_checkout_shipping_payment_core_shipping_fields'}
                                {include file="frontend/opc/partials/change_shipping.tpl"}
                            {/block}
                        </div>
                    {/if}
                </div>
            {/block}
        </div>
    </div>
</div>