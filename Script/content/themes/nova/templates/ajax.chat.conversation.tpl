<div class="flex min-h-0 min-w-0 flex-1 overflow-hidden">

  <!-- chat -->
  <div class="card panel-messages flex min-h-0 min-w-0 flex-1 flex-col overflow-hidden rounded-none border-0 bg-base-100 shadow-none" data-cid="{$conversation['conversation_id']}" data-color="{$conversation['color']}" data-chat-price="{$conversation['chat_price']}" data-call-price="{$conversation['call_price']}" {if $conversation['as_page']}data-as-page="{$conversation['page_id']}"{/if}>

    <!-- header -->
    <div class="flex h-18 shrink-0 items-center gap-3 border-b border-base-300 bg-base-100 px-4 sm:px-5">
      {if $conversation['as_page']}
        <a class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full -ms-1 lg:hidden" href="{$system['system_url']}/pages/{$conversation['page_name']}/settings/messages" title='{__("Back To Messages")}' aria-label='{__("Back To Messages")}'>
          <span class="icon-[tabler--chevron-left] size-5 rtl:rotate-180" aria-hidden="true"></span>
        </a>
      {else}
        <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full -ms-1 lg:hidden" data-bs-toggle="sg-offcanvas" title='{__("Back To Messages")}' aria-label='{__("Back To Messages")}'>
          <span class="icon-[tabler--chevron-left] size-5 rtl:rotate-180" aria-hidden="true"></span>
        </button>
      {/if}
      <span class="relative shrink-0">
        {if $conversation['picture']}
          <span class="flex size-11 overflow-hidden rounded-full bg-base-200">
            <img class="size-full object-cover" src="{$conversation['picture']}" alt="">
          </span>
        {elseif $conversation['picture_left']}
          <span class="flex size-11 overflow-hidden rounded-full bg-base-200">
            <span class="h-full w-1/2 bg-cover bg-center" style="background-image: url('{$conversation['picture_left']}')"></span>
            <span class="h-full w-1/2 border-s-2 border-base-100 bg-cover bg-center" style="background-image: url('{$conversation['picture_right']}')"></span>
          </span>
        {/if}
        {if !$conversation['multiple_recipients'] && !$conversation['node_id'] && $conversation['user_is_online']}
          <span class="absolute bottom-0 end-0 size-3 rounded-full border-2 border-base-100 bg-success" aria-hidden="true"></span>
        {/if}
      </span>
      <div class="min-w-0 grow">
        <div class="js_chat-title truncate font-semibold leading-tight [&_a]:text-base-content! [&_a:hover]:text-primary!" title="{$conversation['name']}">
          {if $conversation['node_id'] && !$conversation['as_page']}
            <a href="{$system['system_url']}/{$conversation['link']}">{$conversation['name']}</a>
          {elseif !$conversation['multiple_recipients']}
            {$conversation['name_html']}
          {else}
            <span title="{$conversation['name_list']}">{$conversation['name']}</span>
          {/if}
        </div>
        <div class="js_chat-subtitle mt-0.5 truncate text-xs text-base-content/55" title="{if $conversation['as_page']}{$conversation['page_title']}{elseif $conversation['page_id']}{__("Page")}{elseif $conversation['node_id'] || $conversation['multiple_recipients']}{$conversation['name_list']}{elseif $conversation['user_is_online']}{__("Online")}{/if}">
          {if $conversation['as_page']}
            <span class="inline-flex items-center gap-1"><span class="icon-[tabler--flag] size-3.5" aria-hidden="true"></span>{$conversation['page_title']}</span>
          {elseif $conversation['page_id']}
            {__("Page")}
          {elseif $conversation['node_id'] || $conversation['multiple_recipients']}
            {$conversation['name_list']}
          {elseif $conversation['user_is_online']}
            <span class="font-medium text-success">{__("Online")}</span>
          {elseif $conversation['user_last_seen']}
            {__("Active")} <span class="js_moment" data-time="{$conversation['user_last_seen']}">{$conversation['user_last_seen']}</span>
          {/if}
        </div>
      </div>
      <div class="flex shrink-0 items-center gap-0.5">
        {if !$conversation['multiple_recipients'] && !$conversation['node_id']}
          {if $system['audio_call_enabled']}
            <button type="button" class="heroui button button--ghost button--icon-only size-10 rounded-full text-base-content/70 hover:text-primary js_chat-call-start" data-type="audio" data-uid="{$conversation['user_id']}" data-name="{$conversation['name']}" data-picture="{$conversation['picture']}" title='{__("Audio Call")}' aria-label='{__("Audio Call")}'>
              <span class="icon-[tabler--phone] size-5" aria-hidden="true"></span>
            </button>
          {/if}
          {if $system['video_call_enabled']}
            <button type="button" class="heroui button button--ghost button--icon-only size-10 rounded-full text-base-content/70 hover:text-primary js_chat-call-start" data-type="video" data-uid="{$conversation['user_id']}" data-name="{$conversation['name']}" data-picture="{$conversation['picture']}" title='{__("Video Call")}' aria-label='{__("Video Call")}'>
              <span class="icon-[tabler--video] size-5" aria-hidden="true"></span>
            </button>
          {/if}
        {/if}
        {if $conversation['as_page']}
        {elseif !$conversation['node_id'] || $conversation['page_id']}
          <button type="button" class="heroui button button--ghost button--icon-only size-10 rounded-full text-base-content/70 hover:text-error js_delete-conversation" title='{__("Delete Conversation")}' aria-label='{__("Delete Conversation")}'>
            <span class="icon-[tabler--trash] size-5" aria-hidden="true"></span>
          </button>
        {else}
          <button type="button" class="heroui button button--ghost button--icon-only size-10 rounded-full text-base-content/70 hover:text-error js_leave-conversation" title='{__("Leave")}' aria-label='{__("Leave")}'>
            <span class="icon-[tabler--logout] size-5" aria-hidden="true"></span>
          </button>
        {/if}
        {if $conversation_profile}
          <button type="button" class="heroui button button--ghost button--icon-only size-10 rounded-full text-base-content/70 hover:text-primary js_chat-profile-toggle" title='{__("Info")}' aria-label='{__("Info")}'>
            <span class="icon-[tabler--info-circle] size-5" aria-hidden="true"></span>
          </button>
        {/if}
      </div>
    </div>
    <!-- header -->

    {include file='__chat_pin.tpl'}
    <!-- messages -->
    <div class="chat-conversations js_scroller flex min-h-0 flex-1 flex-col overflow-y-auto bg-linear-to-b from-base-200/40 to-base-100 px-4 py-4 sm:px-6" data-slimScroll-height="100%" data-slimScroll-start="bottom">
      {include file='ajax.chat.conversation.messages.tpl'}
    </div>
    <!-- messages -->

    <div class="shrink-0">
      {if $conversation['page_id'] && !$conversation['as_page'] && !$conversation['page_messages_enabled']}
        <div class="border-t border-base-300 px-4 py-4 text-center text-sm text-base-content/60">{__("This page is not receiving messages")}</div>
      {elseif $conversation['node_id']}
        {include file='__chat_composer.tpl' _layout="page" _show_typing=true _colors=false}
      {else}
        {include file='__chat_composer.tpl' _layout="page" _show_typing=true _monetize_cid=$conversation['conversation_id'] _colors=true}
      {/if}
    </div>
  </div>
  <!-- chat -->

  {if $conversation_profile}
    {include file='__chat_profile.tpl' _profile=$conversation_profile}
  {/if}

</div>
