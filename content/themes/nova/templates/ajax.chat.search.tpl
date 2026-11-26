{if $conversations}
  <ul class="m-0 flex list-none flex-col gap-1 p-0">
    {foreach $conversations as $_conversation}
      {include file='__feeds_conversation.tpl' conversation=$_conversation _active_cid=$active_cid}
    {/foreach}
  </ul>
  {if $has_more}
    <!-- see-more -->
    <div class="see-more js_see-more mx-1 mt-2 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-2.5 text-xs font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="conversations_search" data-query="{$query|escape:'html'}" data-filter="{$filter}">
      <span>{__("Load Older Threads")}</span>
      <div class="loading loading-spinner loading-sm hidden"></div>
    </div>
    <!-- see-more -->
  {/if}
{else}
  {include file='_no_data.tpl' _empty_icon="icon-[tabler--search-off]" _empty_title=__("No data to show")}
{/if}
