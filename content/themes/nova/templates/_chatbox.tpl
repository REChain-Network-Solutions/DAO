<div class="card panel-messages flex min-h-0 flex-col overflow-hidden border border-base-300 bg-base-100 shadow-none" data-cid="{$_node['chatbox_conversation']['conversation_id']}">
  <div class="flex items-center gap-3 border-b border-base-300 px-4 py-3">
    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
      <span class="icon-[tabler--messages] size-5"></span>
    </span>
    <h2 class="text-lg font-semibold">{__("Chatbox")}</h2>
  </div>
  {if ($_node_type == "group" && $_node['i_joined'] == "approved") || ($_node_type == "event" && ($event['i_joined']['is_going'] || $event['i_joined']['is_interested']))}
    {include file='__chat_pin.tpl' conversation=$_node['chatbox_conversation']}
    <div class="chat-conversations js_scroller min-h-0 flex-1 px-4 py-3" data-slimScroll-height="420px" data-slimScroll-start="bottom">
      {include file='ajax.chat.conversation.messages.tpl' conversation=$_node['chatbox_conversation']}
    </div>
    {include file='__chat_composer.tpl' _show_typing=true}
  {else}
    {capture assign="_chatbox_locked"}{__("Join the")} {__($_node_type)} {__("to join the chatbox")}{/capture}
    {include file='_no_data.tpl' _empty_icon="icon-[tabler--message-circle-off]" _empty_title=$_chatbox_locked}
  {/if}
</div>
