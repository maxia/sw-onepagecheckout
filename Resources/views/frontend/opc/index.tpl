{* Register page in checkout-mode *}
<div class="content checkout--opc-container" data-onepagecheckout="true">
    <div class="checkout--info-header">
        <h1>Bestellung</h1>
        <p>Bitte füllen Sie die nachfolgenden Felder aus, um die Bestellung abzuschließen.</p>
    </div>

    {include file="frontend/opc/personal_data.tpl"}
    {include file="frontend/opc/shipping_payment_confirm.tpl"}

    {* Benefit and services footer *}
    {block name="frontend_checkout_footer"}
    {/block}

    {block name="frontend_index_header_javascript_jquery_lib" append}
        <div class="pp--approval-url is--hidden">{$PaypalPlusApprovalUrl}</div>
        {if $sUserData.additional.payment.id == $PayPalPaymentId && $PaypalPlusApprovalUrl}
            {include file="frontend/payment_paypal_plus/js-payment_wall.tpl"}
        {/if}
    {/block}
</div>
