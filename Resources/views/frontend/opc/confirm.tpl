
<div class="checkout--section checkout--confirm confirm--content{if !$showConfirmStep} checkout--section--disabled{/if}">

    {* Additional feature which can be enabled / disabled in the base configuration *}
    {if {config name=commentvoucherarticle}||{config name=bonussystem} && {config name=bonus_system_active} && {config name=displaySlider}}
        {block name="frontend_checkout_confirm_additional_features"}
            <div class="panel has--border additional--features">
                {block name="frontend_checkout_confirm_additional_features_headline"}
                    <div class="panel--title is--underline">
                        {s name="ConfirmHeadlineAdditionalOptions"}{/s}
                    </div>
                {/block}

                {block name="frontend_checkout_confirm_additional_features_content"}
                    <div class="panel--body is--wide block-group">

                        {* Additional feature - Add voucher *}
                        {block name="frontend_checkout_confirm_additional_features_add_voucher"}
                            <div class="feature--group block">
                                <div class="feature--voucher">
                                    <form method="post" action="{url action='addVoucher' sTargetAction=$sTargetAction}" class="table--add-voucher add-voucher--form">
                                        {block name='frontend_checkout_table_footer_left_add_voucher_agb'}
                                            {if !{config name='IgnoreAGB'}}
                                                <input type="hidden" class="agb-checkbox" name="sAGB"
                                                       value="{if $sAGBChecked}1{else}0{/if}"/>
                                            {/if}
                                        {/block}

                                        {block name='frontend_checkout_confirm_add_voucher_field'}
                                            <input type="text" class="add-voucher--field block" name="sVoucher" placeholder="{"{s name='CheckoutFooterAddVoucherLabelInline' namespace='frontend/checkout/cart_footer'}{/s}"|escape}" />
                                        {/block}

                                        {block name='frontend_checkout_confirm_add_voucher_button'}
                                            <button type="submit" class="add-voucher--button btn is--primary is--small block">
                                                <i class="icon--arrow-right"></i>
                                            </button>
                                        {/block}
                                    </form>
                                </div>

                                {* Additional feature - Add product using the sku *}
                                {block name="frontend_checkout_confirm_additional_features_add_product"}
                                    <div class="feature--add-product">
                                        <form method="post" action="{url action='addArticle' sTargetAction=$sTargetAction}" class="table--add-product add-product--form block-group">

                                            {block name='frontend_checkout_confirm_add_product_field'}
                                                <input name="sAdd" class="add-product--field block" type="text" placeholder="{s name='CheckoutFooterAddProductPlaceholder' namespace='frontend/checkout/cart_footer_left'}{/s}" />
                                            {/block}

                                            {block name='frontend_checkout_confirm_add_product_button'}
                                                <button type="submit" class="add-product--button btn is--primary is--small block">
                                                    <i class="icon--arrow-right"></i>
                                                </button>
                                            {/block}
                                        </form>
                                    </div>
                                {/block}
                            </div>
                        {/block}

                        {* Additional customer comment for the order *}
                        {block name='frontend_checkout_confirm_comment'}
                            <div class="feature--user-comment block">
                                <textarea class="user-comment--field" rows="5" cols="20" placeholder="{s name="ConfirmPlaceholderComment" namespace="frontend/checkout/confirm"}{/s}" data-pseudo-text="true" data-selector=".user-comment--hidden">{$sComment|escape}</textarea>
                            </div>
                        {/block}
                    </div>
                {/block}
            </div>
        {/block}
    {/if}

    {* Premiums articles *}
    {block name='frontend_checkout_confirm_premiums'}
        {if $sPremiums && {config name=premiumarticles}}
            {include file='frontend/checkout/premiums.tpl'}
        {/if}
    {/block}

    {block name='frontend_checkout_confirm_product_table'}
        <div class="panel has--border">
            {block name='frontend_checkout_shipping_payment_headline'}
                <div class="confirm--headline panel--title is--underline checkout--step-title">
                    <span class="icon">3</span>
                    <span class="text">
                        Bestellübersicht
                    </span>
                </div>
            {/block}

            <div class="panel--body is--rounded is--wide">
                <div class="product--table">
                    {* Product table header *}
                    {block name='frontend_checkout_confirm_confirm_head'}
                        {include file="frontend/checkout/confirm_header.tpl"}
                    {/block}

                    {block name='frontend_checkout_confirm_item_before'}{/block}

                    {* Basket items *}
                    {block name='frontend_checkout_confirm_item_outer'}
                        {foreach $sBasket.content as $sBasketItem}
                            {block name='frontend_checkout_confirm_item'}
                                {include file='frontend/opc/partials/confirm_item.tpl' isLast=$sBasketItem@last}
                            {/block}
                        {/foreach}
                    {/block}

                    {block name='frontend_checkout_confirm_item_after'}{/block}

                    {* Table footer *}
                    {block name='frontend_checkout_confirm_confirm_footer'}
                        {include file="frontend/checkout/confirm_footer.tpl"}
                    {/block}
                </div>
            </div>
        </div>

        {block name='frontend_checkout_confirm_form'}
            <form id="confirm--form" method="post" action="{url controller='checkout' action='finish'}">

                {* AGB and Revocation *}
                {block name='frontend_checkout_confirm_tos_panel'}
                    {include file="frontend/opc/partials/confirm-tos.tpl"}
                {/block}

                {* Table actions *}
                {block name='frontend_checkout_confirm_confirm_table_actions'}
                    <div class="product--table table--actions actions--bottom">
                        <div class="main--actions">
                            {if $sLaststock.hideBasket}
                                {block name='frontend_checkout_confirm_stockinfo'}
                                    {include file="frontend/_includes/messages.tpl" type="error" content="{s name='ConfirmErrorStock' namespace="frontend/checkout/confirm"}{/s}"}
                                {/block}
                            {elseif ($invalidBillingAddress || $invalidShippingAddress)}
                                {block name='frontend_checkout_confirm_addressinfo'}
                                    {include file="frontend/_includes/messages.tpl" type="error" content="{s name='ConfirmErrorInvalidAddress' namespace="frontend/checkout/confirm"}{/s}"}
                                {/block}
                            {else}
                                {block name='frontend_checkout_confirm_submit'}
                                    {* Submit order button *}
                                    {if $sPayment.embediframe || $sPayment.action}
                                        <button type="submit" class="btn is--primary is--large right is--icon-right" form="confirm--form" data-preloader-button="true">
                                            {s name='ConfirmDoPayment' namespace="frontend/checkout/confirm"}{/s}<i class="icon--arrow-right"></i>
                                        </button>
                                    {else}
                                        <button type="submit" class="btn is--primary is--large right is--icon-right" form="confirm--form" data-preloader-button="true">
                                            {s name='ConfirmActionSubmit' namespace="frontend/checkout/confirm"}{/s}<i class="icon--arrow-right"></i>
                                        </button>
                                    {/if}
                                {/block}
                            {/if}
                        </div>
                    </div>
                {/block}
            </form>
        {/block}

    {/block}
</div>