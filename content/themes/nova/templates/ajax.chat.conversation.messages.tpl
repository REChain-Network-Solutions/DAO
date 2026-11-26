{if $conversation['total_messages'] >= $system['max_results']}
  <!-- see-more -->
  <div class="see-more js_see-more mb-3 flex cursor-pointer items-center justify-center gap-2 rounded-full bg-base-200 px-3 py-2 text-xs font-semibold transition-colors hover:bg-primary/5 hover:text-primary" data-id={$conversation['conversation_id']} data-get="{if $conversation['as_page']}page_messages{else}messages{/if}">
    <span>{__("Loading Older Messages")}</span>
    <div class="loading loading-spinner loading-sm hidden"></div>
  </div>
  <!-- see-more -->
{/if}

<ul class="m-0 mt-auto flex list-none flex-col gap-3 p-0">
  {include file='ajax.chat.messages.tpl' messages=$conversation['messages']}
</ul>
