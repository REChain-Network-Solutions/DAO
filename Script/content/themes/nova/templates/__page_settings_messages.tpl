<section class="card flex h-[75vh] min-h-[32rem] flex-row overflow-hidden rounded-3xl border border-base-300 bg-base-100 shadow-none">

  <!-- threads -->
  <div class="{if $conversation}hidden lg:flex{else}flex{/if} h-full min-h-0 w-full shrink-0 flex-col border-e border-base-300 lg:w-72 xl:w-80">
    <div class="flex shrink-0 items-center gap-2 px-4 pb-3 pt-4">
      <h2 class="card-title min-w-0 grow text-lg">{__("Messages")}</h2>
      {if !$spage['page_messages_enabled']}
        <a class="badge badge-soft badge-warning rounded-full" href="{$system['system_url']}/pages/{$spage['page_name']}/settings" title='{__("Messages are turned off")}'>{__("Off")}</a>
      {/if}
    </div>
    <div class="js_page-inbox min-h-0 flex-1 overflow-y-auto px-2 pb-2" data-page-id="{$spage['page_id']}">
      {if $conversations['data']}
        <ul class="m-0 flex list-none flex-col gap-1 p-0">
          {foreach $conversations['data'] as $_conversation}
            {include file='__feeds_conversation.tpl' conversation=$_conversation _active_cid=$conversation['conversation_id']}
          {/foreach}
        </ul>
        {if $conversations['has_more']}
          <!-- see-more -->
          <div class="see-more js_see-more mx-1 mt-2 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-2.5 text-xs font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="page_conversations" data-id="{$spage['page_id']}">
            <span>{__("Load Older Threads")}</span>
            <div class="loading loading-spinner loading-sm hidden"></div>
          </div>
          <!-- see-more -->
        {/if}
      {else}
        {include file='_no_data.tpl' _empty_icon="icon-[tabler--message-circle-off]" _empty_title=__("No messages")}
      {/if}
    </div>
  </div>
  <!-- threads -->

  <!-- conversation -->
  <div class="js_conversation-container {if $conversation}flex{else}hidden lg:flex{/if} min-h-0 min-w-0 flex-1 flex-col overflow-hidden">
    {if $conversation}
      {include file='ajax.chat.conversation.tpl'}
    {else}
      <div class="flex h-full min-h-0 flex-col items-center justify-center bg-linear-to-b from-base-200/40 to-base-100">
        {include file='_no_data.tpl' _empty_icon="icon-[tabler--message-circle]" _empty_title=__("No Conversation Selected") _empty_text=__("Choose a thread to reply as your page")}
      </div>
    {/if}
  </div>
  <!-- conversation -->

</section>
