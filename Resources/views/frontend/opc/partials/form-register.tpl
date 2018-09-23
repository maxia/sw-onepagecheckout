
<div class="register--content" id="registration" data-register="true">

    {block name='frontend_register_index_dealer_register'}
        {* Included for compatibility reasons *}
    {/block}

    {block name='frontend_register_index_cgroup_header'}
        {if $register.personal.sValidation}
            {* Include information related to registration for other customergroups then guest, this block get overridden by b2b essentials plugin *}
            {* todo: supplier register form *}
            {*
            <div class="panel register--supplier">
                <h2 class="panel--title is--underline">{$sShopname|escapeHtml} {s name='RegisterHeadlineSupplier' namespace='frontend/register/index'}{/s}</h2>

                <div class="panel--body is--wide">
                    <p class="is--bold">{s name='RegisterInfoSupplier3' namespace='frontend/register/index'}{/s}</p>

                    <h3 class="is--bold">{s name='RegisterInfoSupplier4' namespace='frontend/register/index'}{/s}</h3>
                    <p>{s name='RegisterInfoSupplier5' namespace='frontend/register/index'}{/s}</p>

                    <h3 class="is--bold">{s name='RegisterInfoSupplier6' namespace='frontend/register/index'}{/s}</h3>
                    <p>{s name='RegisterInfoSupplier7' namespace='frontend/register/index'}{/s}</p>
                </div>
            </div>
            *}
        {/if}
    {/block}

    {block name='frontend_register_index_form'}
        <div class="panel register--personal">
            <h2 class="panel--title is--underline{if $errors.occurred} is--active{/if}"
                id="register-panel-title"
                data-closesiblings="true"
                data-collapsetarget="#register-panel-body"
                href="#register-panel-body">
                {if isset($fieldset_title) && !empty($fieldset_title)}{$fieldset_title}{else}{s name='RegisterPersonalMarketingHeadline' namespace="frontend/register/personal_fieldset"}{/s}{/if}
            </h2>

            <form method="post" action="{url controller=checkout action=confirm registerAction="true"}"
                  class="panel register--form{if $errors.occurred} is--collapsed{/if}"
                  id="register-panel-body">
                {block name='frontend_register_index_form_personal_fieldset'}
                    {include file="frontend/register/error_message.tpl" error_messages=$errors.personal}
                    {include file="frontend/opc/partials/personal_fieldset.tpl" form_data=$register.personal error_flags=$errors.personal}
                {/block}

                {block name='frontend_register_index_form_billing_fieldset'}
                    {include file="frontend/register/error_message.tpl" error_messages=$errors.billing}
                    {include file="frontend/opc/partials/billing_fieldset.tpl" form_data=$register.billing error_flags=$errors.billing country_list=$countryList}
                {/block}

                {block name='frontend_register_index_form_shipping_fieldset'}
                    {include file="frontend/register/error_message.tpl" error_messages=$errors.shipping}
                    {include file="frontend/opc/partials/shipping_fieldset.tpl" form_data=$register.shipping error_flags=$errors.shipping country_list=$countryList}
                {/block}

                {* Privacy checkbox *}
                {if !$update}
                    {if {config name=ACTDPRCHECK}}
                        {block name='frontend_register_index_input_privacy'}
                            <div class="register--privacy">
                                <input name="register[personal][dpacheckbox]" type="checkbox" id="dpacheckbox"{if $form_data.dpacheckbox} checked="checked"{/if} required="required" aria-required="true" value="1" class="chkbox is--required" />
                                <label for="dpacheckbox" class="chklabel{if isset($errors.personal.dpacheckbox)} has--error{/if}">{s name='RegisterLabelDataCheckbox'}{/s}</label>
                            </div>
                        {/block}
                    {/if}
                {/if}

                {block name='frontend_register_index_form_required'}
                    {* Required fields hint *}
                    <div class="register--required-info required_fields">
                        {s name='RegisterPersonalRequiredText' namespace='frontend/register/personal_fieldset'}{/s}
                    </div>
                {/block}

                {block name='frontend_register_index_form_submit'}
                    {* Submit button *}
                    <div class="register--action">
                        <button type="submit" class="register--submit btn is--primary is--large is--icon-right" name="Submit">{s name="RegisterIndexNewActionSubmit" namespace="frontend/register/index"}{/s} <i class="icon--arrow-right"></i></button>
                    </div>
                {/block}
            </form>
        </div>
    {/block}
</div>