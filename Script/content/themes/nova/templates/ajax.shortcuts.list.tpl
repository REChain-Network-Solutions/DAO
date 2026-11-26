{if $shortcuts}
  <ul class="flex flex-col">
    {foreach $shortcuts as $_shortcut}
      {include file='__shortcut_row.tpl'}
    {/foreach}
  </ul>
  {if count($shortcuts) >= $system['max_results']}
    {include file='__modal_see_more.tpl' _get="shortcuts" _query=$query}
  {/if}
{elseif $query != ''}
  {include file='_no_data.tpl' _empty_compact=true _empty_icon="icon-[tabler--search]" _empty_title=__("No results found")}
{else}
  {include file='_no_data.tpl' _empty_compact=true _empty_icon="icon-[tabler--bolt]" _empty_title=__("No shortcuts yet")}
{/if}
