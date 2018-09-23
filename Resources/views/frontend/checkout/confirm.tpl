{extends file="parent:frontend/checkout/confirm.tpl"}

{* Step box *}
{block name='frontend_index_navigation_categories_top'}
    {if !$theme.checkoutHeader}
        {$smarty.block.parent}
    {/if}
    {*include file="frontend/register/steps.tpl" sStepActive="finished"*}
{/block}

{* Main content *}
{block name='frontend_index_content'}
    {include file="frontend/opc/index.tpl"}
{/block}
