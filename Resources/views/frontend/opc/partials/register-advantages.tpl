
<div class="register--advantages block">
    <h2 class="panel--title">{s name='RegisterInfoAdvantagesTitle'}{/s}</h2>
    {block name='frontend_index_content_advantages_list'}
        <ul class="list--unordered is--checked register--advantages-list">
            {block name='frontend_index_content_advantages_entry1'}
                <li class="register--advantages-entry">
                    {s name='RegisterInfoAdvantagesEntry1' namespace="frontend/register/index"}{/s}
                </li>
            {/block}

            {block name='frontend_index_content_advantages_entry2'}
                <li class="register--advantages-entry">
                    {s name='RegisterInfoAdvantagesEntry2' namespace="frontend/register/index"}{/s}
                </li>
            {/block}

            {block name='frontend_index_content_advantages_entry3'}
                <li class="register--advantages-entry">
                    {s name='RegisterInfoAdvantagesEntry3' namespace="frontend/register/index"}{/s}
                </li>
            {/block}

            {block name='frontend_index_content_advantages_entry4'}
            {/block}
        </ul>
    {/block}
</div>