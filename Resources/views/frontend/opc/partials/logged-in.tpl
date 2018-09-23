
{block name='frontend_checkout_confirm_information_wrapper'}
    <div class="panel logout-panel">
        <div class="panel--body is--wide">
            <p class="is--strong">Sie sind angemeldet. <a href="{url controller=account action=logout}">Abmelden</a></p>
        </div>
    </div>

    <div class="panel--group block-group information--panel-wrapper" data-panel-auto-resizer="true">

        {block name='frontend_checkout_confirm_information_addresses'}

            {if $activeBillingAddressId == $activeShippingAddressId}

                {* Equal Billing & Shipping *}
                {block name='frontend_checkout_confirm_information_addresses_equal'}
                    <div class="information--panel-item information--panel-address">

                        {block name='frontend_checkout_confirm_information_addresses_equal_panel'}
                            <div class="panel block information--panel">

                                {block name='frontend_checkout_confirm_information_addresses_equal_panel_title'}
                                    <div class="panel--title is--underline">
                                        {s name='ConfirmAddressEqualTitle' namespace="frontend/checkout/confirm"}{/s}
                                    </div>
                                {/block}

                                {block name='frontend_checkout_confirm_information_addresses_equal_panel_body'}
                                    <div class="panel--body is--wide">

                                        {block name='frontend_checkout_confirm_information_addresses_equal_panel_billing'}
                                            <div class="billing--panel">
                                                {if $sUserData.billingaddress.company}
                                                    <span class="address--company is--bold">{$sUserData.billingaddress.company|escapeHtml}</span>{if $sUserData.billingaddress.department|escapeHtml}<br /><span class="address--department is--bold">{$sUserData.billingaddress.department|escapeHtml}</span>{/if}
                                                    <br />
                                                {/if}

                                                <span class="address--salutation">{$sUserData.billingaddress.salutation|salutation}</span>
                                                {if {config name="displayprofiletitle"}}
                                                    <span class="address--title">{$sUserData.billingaddress.title|escapeHtml}</span><br/>
                                                {/if}
                                                <span class="address--firstname">{$sUserData.billingaddress.firstname|escapeHtml}</span> <span class="address--lastname">{$sUserData.billingaddress.lastname|escapeHtml}</span><br/>
                                                <span class="address--street">{$sUserData.billingaddress.street|escapeHtml}</span><br />
                                                {if $sUserData.billingaddress.additional_address_line1}<span class="address--additional-one">{$sUserData.billingaddress.additional_address_line1|escapeHtml}</span><br />{/if}
                                                {if $sUserData.billingaddress.additional_address_line2}<span class="address--additional-two">{$sUserData.billingaddress.additional_address_line2|escapeHtml}</span><br />{/if}
                                                {if {config name=showZipBeforeCity}}
                                                    <span class="address--zipcode">{$sUserData.billingaddress.zipcode|escapeHtml}</span> <span class="address--city">{$sUserData.billingaddress.city|escapeHtml}</span>
                                                {else}
                                                    <span class="address--city">{$sUserData.billingaddress.city|escapeHtml}</span> <span class="address--zipcode">{$sUserData.billingaddress.zipcode|escapeHtml}</span>
                                                {/if}<br />
                                                {if $sUserData.additional.state.name}<span class="address--statename">{$sUserData.additional.state.name|escapeHtml}</span><br />{/if}
                                                <span class="address--countryname">{$sUserData.additional.country.countryname|escapeHtml}</span>

                                                {block name="frontend_checkout_confirm_information_addresses_equal_panel_billing_invalid_data"}
                                                    {if $invalidBillingAddress}
                                                        {include file='frontend/_includes/messages.tpl' type="warning" content="{s name='ConfirmAddressInvalidAddress' namespace="frontend/checkout/confirm"}{/s}"}
                                                    {else}
                                                        {block name="frontend_checkout_confirm_information_addresses_equal_panel_billing_set_as_default"}
                                                            {if $activeBillingAddressId != $sUserData.additional.user.default_billing_address_id || $activeShippingAddressId != $sUserData.additional.user.default_shipping_address_id}
                                                                <div class="set-default">
                                                                    <input type="checkbox" name="setAsDefaultAddress" id="set_as_default" value="1" /> <label for="set_as_default">{s name="ConfirmUseForFutureOrders" namespace="frontend/checkout/confirm"}{/s}</label>
                                                                </div>
                                                            {/if}
                                                        {/block}
                                                    {/if}
                                                {/block}
                                            </div>
                                        {/block}

                                        {block name='frontend_checkout_confirm_information_addresses_equal_panel_shipping'}
                                        {/block}
                                    </div>

                                    {block name='frontend_checkout_confirm_information_addresses_equal_panel_actions'}
                                        <div class="panel--actions is--wide">
                                            {block name="frontend_checkout_confirm_information_addresses_equal_panel_actions_change"}
                                                <div class="address--actions-change">
                                                    {block name='frontend_checkout_confirm_information_addresses_equal_panel_shipping_change_address'}
                                                        <a href="{url controller=address action=edit id=$activeBillingAddressId sTarget=checkout sTargetAction=confirm}"
                                                           data-address-editor="true"
                                                           data-id="{$activeBillingAddressId}"
                                                           data-sessionKey="checkoutBillingAddressId,checkoutShippingAddressId"
                                                           data-title="{s name="ConfirmAddressSelectButton" namespace="frontend/checkout/confirm"}Change address{/s}"
                                                           title="{s name="ConfirmAddressSelectButton" namespace="frontend/checkout/confirm"}Change address{/s}"
                                                           class="btn">
                                                            {s name="ConfirmAddressSelectButton" namespace="frontend/checkout/confirm"}Change address{/s}
                                                        </a>
                                                    {/block}

                                                    {block name='frontend_checkout_confirm_information_addresses_equal_panel_shipping_add_address'}
                                                        <a href="{url controller=address}"
                                                           class="btn choose-different-address"
                                                           data-address-selection="true"
                                                           data-sessionKey="checkoutShippingAddressId"
                                                           data-id="{$activeShippingAddressId}"
                                                           title="{s name="ConfirmAddressChooseDifferentShippingAddress" namespace="frontend/checkout/confirm"}{/s}">
                                                            {s name="ConfirmAddressChooseDifferentShippingAddress" namespace="frontend/checkout/confirm"}{/s}
                                                        </a>
                                                    {/block}
                                                </div>
                                            {/block}
                                            {block name="frontend_checkout_confirm_information_addresses_equal_panel_actions_select_address"}
                                                <a href="{url controller=address}"
                                                   title="{s name="ConfirmAddressSelectLink" namespace="frontend/checkout/confirm"}{/s}"
                                                   data-address-selection="true"
                                                   data-sessionKey="checkoutBillingAddressId,checkoutShippingAddressId"
                                                   data-id="{$activeBillingAddressId}">
                                                    {s name="ConfirmAddressSelectLink" namespace="frontend/checkout/confirm"}{/s}
                                                </a>
                                            {/block}
                                        </div>
                                    {/block}
                                {/block}
                            </div>
                        {/block}
                    </div>
                {/block}

            {else}

                {* Separate Billing & Shipping *}
                {block name='frontend_checkout_confirm_information_addresses_billing'}
                    <div class="information--panel-item information--panel-item-billing">
                        {* Billing address *}
                        {block name='frontend_checkout_confirm_information_addresses_billing_panel'}
                            <div class="panel information--panel billing--panel">

                                {* Headline *}
                                {block name='frontend_checkout_confirm_information_addresses_billing_panel_title'}
                                    <div class="panel--title is--underline">
                                        {s name="ConfirmHeaderBilling" namespace="frontend/checkout/confirm"}{/s}
                                    </div>
                                {/block}

                                {* Content *}
                                {block name='frontend_checkout_confirm_information_addresses_billing_panel_body'}
                                    <div class="panel--body is--wide">
                                        {if $sUserData.billingaddress.company}
                                        <span class="address--company is--bold">{$sUserData.billingaddress.company|escapeHtml}</span>{if $sUserData.billingaddress.department}<br /><span class="address--department is--bold">{$sUserData.billingaddress.department|escapeHtml}</span>{/if}
                                            <br />
                                        {/if}
                                        <span class="address--salutation">{$sUserData.billingaddress.salutation|salutation}</span>
                                        {if {config name="displayprofiletitle"}}
                                            <span class="address--title">{$sUserData.billingaddress.title|escapeHtml}</span><br/>
                                        {/if}
                                        <span class="address--firstname">{$sUserData.billingaddress.firstname|escapeHtml}</span> <span class="address--lastname">{$sUserData.billingaddress.lastname|escapeHtml}</span><br />
                                        <span class="address--street">{$sUserData.billingaddress.street|escapeHtml}</span><br />
                                        {if $sUserData.billingaddress.additional_address_line1}<span class="address--additional-one">{$sUserData.billingaddress.additional_address_line1|escapeHtml}</span><br />{/if}
                                        {if $sUserData.billingaddress.additional_address_line2}<span class="address--additional-two">{$sUserData.billingaddress.additional_address_line2|escapeHtml}</span><br />{/if}
                                        {if {config name=showZipBeforeCity}}
                                            <span class="address--zipcode">{$sUserData.billingaddress.zipcode|escapeHtml}</span> <span class="address--city">{$sUserData.billingaddress.city|escapeHtml}</span>
                                        {else}
                                            <span class="address--city">{$sUserData.billingaddress.city|escapeHtml}</span> <span class="address--zipcode">{$sUserData.billingaddress.zipcode|escapeHtml}</span>
                                        {/if}<br />
                                        {if $sUserData.additional.state.name}<span class="address--statename">{$sUserData.additional.state.name|escapeHtml}</span><br />{/if}
                                        <span class="address--countryname">{$sUserData.additional.country.countryname|escapeHtml}</span>

                                        {block name="frontend_checkout_confirm_information_addresses_billing_panel_body_invalid_data"}
                                            {if $invalidBillingAddress}
                                                {include file='frontend/_includes/messages.tpl' type="warning" content="{s name='ConfirmAddressInvalidBillingAddress'}{/s}"}
                                            {else}
                                                {block name="frontend_checkout_confirm_information_addresses_billing_panel_body_set_as_default"}
                                                    {if $activeBillingAddressId != $sUserData.additional.user.default_billing_address_id}
                                                        <div class="set-default">
                                                            <input type="checkbox" name="setAsDefaultBillingAddress" id="set_as_default_billing" value="1" /> <label for="set_as_default_billing">{s name="ConfirmUseForFutureOrders" namespace="frontend/checkout/confirm"}{/s}</label>
                                                        </div>
                                                    {/if}
                                                {/block}
                                            {/if}
                                        {/block}
                                    </div>
                                {/block}

                                {* Action buttons *}
                                {block name="frontend_checkout_confirm_information_addresses_billing_panel_actions"}
                                    <div class="panel--actions is--wide">
                                        {block name="frontend_checkout_confirm_information_addresses_billing_panel_actions_change"}
                                            <div class="address--actions-change">
                                                {block name="frontend_checkout_confirm_information_addresses_billing_panel_actions_change_address"}
                                                    <a href="{url controller=address action=edit id=$activeBillingAddressId sTarget=checkout sTargetAction=confirm}"
                                                       data-address-editor="true"
                                                       data-sessionKey="checkoutBillingAddressId"
                                                       data-id="{$activeBillingAddressId}"
                                                       data-title="{s name="ConfirmAddressSelectButton" namespace="frontend/checkout/confirm"}Change address{/s}"
                                                       title="{s name="ConfirmAddressSelectButton" namespace="frontend/checkout/confirm"}Change address{/s}"
                                                       class="btn">
                                                        {s name="ConfirmAddressSelectButton" namespace="frontend/checkout/confirm"}Change address{/s}
                                                    </a>
                                                {/block}
                                            </div>
                                        {/block}
                                        {block name="frontend_checkout_confirm_information_addresses_billing_panel_actions_select_address"}
                                            <a href="{url controller=address}"
                                               data-address-selection="true"
                                               data-sessionKey="checkoutBillingAddressId"
                                               data-id="{$activeBillingAddressId}"
                                               title="{s name="ConfirmAddressSelectLink" namespace="frontend/checkout/confirm"}{/s}">
                                                {s name="ConfirmAddressSelectLink" namespace="frontend/checkout/confirm"}{/s}
                                            </a>
                                        {/block}
                                    </div>
                                {/block}
                            </div>
                        {/block}
                    </div>
                {/block}

                {block name='frontend_checkout_confirm_information_addresses_shipping'}
                    <div class="information--panel-item information--panel-item-shipping">
                        {block name='frontend_checkout_confirm_information_addresses_shipping_panel'}
                            <div class="panel information--panel shipping--panel">

                                {* Headline *}
                                {block name='frontend_checkout_confirm_information_addresses_shipping_panel_title'}
                                    <div class="panel--title is--underline">
                                        {s name="ConfirmHeaderShipping" namespace="frontend/checkout/confirm"}{/s}
                                    </div>
                                {/block}

                                {* Content *}
                                {block name='frontend_checkout_confirm_information_addresses_shipping_panel_body'}
                                    <div class="panel--body is--wide">
                                        {if $sUserData.shippingaddress.company}
                                            <span class="address--company is--bold">{$sUserData.shippingaddress.company|escapeHtml}</span>{if $sUserData.shippingaddress.department}<br /><span class="address--department is--bold">{$sUserData.shippingaddress.department|escapeHtml}</span>{/if}
                                            <br />
                                        {/if}

                                        <span class="address--salutation">{$sUserData.shippingaddress.salutation|salutation}</span>
                                        {if {config name="displayprofiletitle"}}
                                            <span class="address--title">{$sUserData.shippingaddress.title|escapeHtml}</span><br/>
                                        {/if}
                                        <span class="address--firstname">{$sUserData.shippingaddress.firstname|escapeHtml}</span> <span class="address--lastname">{$sUserData.shippingaddress.lastname|escapeHtml}</span><br/>
                                        <span class="address--street">{$sUserData.shippingaddress.street|escapeHtml}</span><br />
                                        {if $sUserData.shippingaddress.additional_address_line1}<span class="address--additional-one">{$sUserData.shippingaddress.additional_address_line1|escapeHtml}</span><br />{/if}
                                        {if $sUserData.shippingaddress.additional_address_line2}<span class="address--additional-one">{$sUserData.shippingaddress.additional_address_line2|escapeHtml}</span><br />{/if}
                                        {if {config name=showZipBeforeCity}}
                                            <span class="address--zipcode">{$sUserData.shippingaddress.zipcode|escapeHtml}</span> <span class="address--city">{$sUserData.shippingaddress.city|escapeHtml}</span>
                                        {else}
                                            <span class="address--city">{$sUserData.shippingaddress.city|escapeHtml}</span> <span class="address--zipcode">{$sUserData.shippingaddress.zipcode|escapeHtml}</span>
                                        {/if}<br />
                                        {if $sUserData.additional.stateShipping.name}<span class="address--statename">{$sUserData.additional.stateShipping.name|escapeHtml}</span><br />{/if}
                                        <span class="address--countryname">{$sUserData.additional.countryShipping.countryname|escapeHtml}</span>

                                        {block name="frontend_checkout_confirm_information_addresses_shipping_panel_body_invalid_data"}
                                            {if $invalidShippingAddress}
                                                {include file='frontend/_includes/messages.tpl' type="warning" content="{s name='ConfirmAddressInvalidShippingAddress' namespace="frontend/checkout/confirm"}{/s}"}
                                            {else}
                                                {block name="frontend_checkout_confirm_information_addresses_shipping_panel_body_set_as_default"}
                                                    {if $activeShippingAddressId != $sUserData.additional.user.default_shipping_address_id}
                                                        <div class="set-default">
                                                            <input type="checkbox" name="setAsDefaultShippingAddress" id="set_as_default_shipping" value="1" /> <label for="set_as_default_shipping">{s name="ConfirmUseForFutureOrders" namespace="frontend/checkout/confirm"}{/s}</label>
                                                        </div>
                                                    {/if}
                                                {/block}
                                            {/if}
                                        {/block}
                                    </div>
                                {/block}

                                {* Action buttons *}
                                {block name="frontend_checkout_confirm_information_addresses_shipping_panel_actions"}
                                    <div class="panel--actions is--wide">
                                        {block name="frontend_checkout_confirm_information_addresses_shipping_panel_actions_change"}
                                            <div class="address--actions-change">
                                                {block name="frontend_checkout_confirm_information_addresses_shipping_panel_actions_change_address"}
                                                    <a href="{url controller=address action=edit id=$activeShippingAddressId sTarget=checkout sTargetAction=confirm}"
                                                       title="{s name="ConfirmAddressSelectButton" namespace="frontend/checkout/confirm"}Change address{/s}"
                                                       data-title="{s name="ConfirmAddressSelectButton" namespace="frontend/checkout/confirm"}Change address{/s}"
                                                       data-address-editor="true"
                                                       data-id="{$activeShippingAddressId}"
                                                       data-sessionKey="checkoutShippingAddressId"
                                                       class="btn">
                                                        {s name="ConfirmAddressSelectButton" namespace="frontend/checkout/confirm"}Change address{/s}
                                                    </a>
                                                {/block}
                                            </div>
                                        {/block}
                                        {block name="frontend_checkout_confirm_information_addresses_shipping_panel_actions_select_address"}
                                            <a href="{url controller=address}"
                                               data-address-selection="true"
                                               data-sessionKey="checkoutShippingAddressId"
                                               data-id="{$activeShippingAddressId}"
                                               title="{s name="ConfirmAddressSelectLink" namespace="frontend/checkout/confirm"}{/s}">
                                                {s name="ConfirmAddressSelectLink" namespace="frontend/checkout/confirm"}{/s}
                                            </a>
                                        {/block}
                                    </div>
                                {/block}
                            </div>
                        {/block}
                    </div>
                {/block}
            {/if}
        {/block}
    </div>
{/block}