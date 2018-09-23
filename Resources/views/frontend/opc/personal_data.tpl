<div class="checkout--section checkout--personal-data">
    <div class="panel has--border is--rounded">
        <div class="panel--title checkout--step-title is--underline">
            <span class="icon">1</span>
            <span class="text">
                {s name="ProfileHeadline" namespace="frontend/account/profile"}{/s}
            </span>
        </div>
        <div class="panel--body is--wide">
            {if $sUserLoggedIn}
                {include file="frontend/opc/partials/logged-in.tpl"}
            {else}
                <div class="checkout--personal-data--body">
                    <div class="checkout--personal-data--forms">
                        {* Login form *}
                        {block name='frontend_register_index_login'}
                            {include file="frontend/opc/partials/form-login.tpl"}
                        {/block}

                        {* Register form *}
                        {block name='frontend_register_index_registration'}
                            {include file="frontend/opc/partials/form-register.tpl"}
                        {/block}
                    </div>

                    {* Register advantages *}
                    <div class="checkout--register--advantages">
                        {block name='frontend_register_index_advantages'}
                            {include file="frontend/opc/partials/register-advantages.tpl"}
                        {/block}
                    </div>
                </div>
            {/if}
        </div>
    </div>
</div>