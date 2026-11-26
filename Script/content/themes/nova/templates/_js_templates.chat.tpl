    <!-- Noty Notification -->
    {if $system['noty_notifications_enabled']}
      <script id="toast-notification" type="text/template">
        <a href="{literal}{{url}}{/literal}" class="toast flex w-80 max-w-[calc(100vw-1.5rem)] items-start gap-3 rounded-box border border-base-300 bg-base-100 p-3 text-sm text-base-content! shadow-lg transition-colors hover:bg-base-200" role="alert" aria-live="assertive" aria-atomic="true">
          <img class="size-10 shrink-0 rounded-full object-cover" src="{literal}{{image}}{/literal}" alt="" />
          <div class="min-w-0 flex-1 self-center line-clamp-3 break-words">{literal}{{message}}{/literal}</div>
          <button class="heroui button button--ghost button--sm button--icon-only size-6 rounded-full shrink-0 js_dismiss-alert" type="button" aria-label='{__("Close")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
        </a>
      </script>
    {/if}
    <!-- Noty Notification -->

    <!-- Chat -->

    <script id="chat-box-new" type="text/template">
      <div class="chat-widget chat-box opened fresh group/widget fixed bottom-0 z-40 flex w-[330px] max-[970px]:hidden flex-col overflow-hidden rounded-t-2xl border border-base-300 bg-base-100 shadow-2xl transition-[translate] duration-200 ease-out motion-reduce:transition-none min-[1200px]:[html:has(.chat-sidebar:is(:hover,:has(:focus-visible),:has(.dropdown.open)))_&]:-translate-x-[calc(17rem-4.7rem)] min-[1200px]:[html:has(.chat-sidebar:is(:hover,:has(:focus-visible),:has(.dropdown.open)))_&]:delay-100 min-[1200px]:rtl:[html:has(.chat-sidebar:is(:hover,:has(:focus-visible),:has(.dropdown.open)))_&]:translate-x-[calc(17rem-4.7rem)]">
        <!-- head -->
        <div class="chat-widget-head flex h-14 cursor-pointer items-center gap-2 px-4">
          <div class="chat-user-card min-w-0 grow">
            <div class="name truncate text-sm font-semibold" title="{__("New Message")}">{__("New Message")}</div>
          </div>
          <div class="chat-head-btns flex shrink-0 items-center">
            <button type="button" class="chat-head-btn heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full js_chat-box-close" title='{__("Close")}' aria-label='{__("Close")}'>
              <span class="icon-[tabler--x] size-5 pointer-events-none" aria-hidden="true"></span>
            </button>
          </div>
        </div>
        <!-- head -->
        <!-- content -->
        <div class="chat-widget-content border-t border-base-300">
          <div class="chat-to js_autocomplete-tags relative flex min-h-12 cursor-text flex-wrap items-center gap-1.5 border-b border-base-300 px-4 py-2">
            <div class="to text-sm text-base-content/60">{__("To")}:</div>
            <ul class="tags contents [&_li]:inline-flex [&_li]:items-center [&_li]:gap-0.5 [&_li]:rounded-full [&_li]:bg-primary/10 [&_li]:py-0.5 [&_li]:ps-2.5 [&_li]:pe-0.5 [&_li]:text-xs [&_li]:font-medium [&_li]:text-primary"></ul>
            <div class="typeahead min-w-16 grow [&_.dropdown-menu]:inset-x-3 [&_.dropdown-menu]:absolute [&_.dropdown-menu]:top-full [&_.dropdown-menu]:z-50 [&_.dropdown-menu]:mt-1 [&_.dropdown-menu]:max-h-72 [&_.dropdown-menu]:overflow-y-auto [&_.dropdown-menu]:border [&_.dropdown-menu]:border-base-300 [&_.dropdown-menu]:p-0 [&_.dropdown-menu]:text-sm [&_.dropdown-menu]:opacity-100 [&_.dropdown-menu]:shadow-lg [&_.dropdown-menu:empty]:hidden">
              <input type="text" size="1" autofocus class="min-w-16 border-0 bg-transparent text-sm outline-none max-md:text-base">
            </div>
          </div>
          <div class="chat-conversations js_scroller h-74 overflow-x-hidden overflow-y-auto px-3 py-3" data-slimScroll-height="296px"></div>
          {include file='__chat_composer.tpl' _show_typing=false _form_invisible=true}
        </div>
        <!-- content -->
      </div>
    </script>

    <script id="chat-box" type="text/template">
      <div class="chat-widget chat-box opened group/widget fixed bottom-0 z-40 flex w-[330px] max-[970px]:hidden flex-col overflow-hidden rounded-t-2xl border border-base-300 bg-base-100 shadow-2xl transition-[translate] duration-200 ease-out motion-reduce:transition-none min-[1200px]:[html:has(.chat-sidebar:is(:hover,:has(:focus-visible),:has(.dropdown.open)))_&]:-translate-x-[calc(17rem-4.7rem)] min-[1200px]:[html:has(.chat-sidebar:is(:hover,:has(:focus-visible),:has(.dropdown.open)))_&]:delay-100 min-[1200px]:rtl:[html:has(.chat-sidebar:is(:hover,:has(:focus-visible),:has(.dropdown.open)))_&]:translate-x-[calc(17rem-4.7rem)]" id="{literal}{{chat_key_value}}{/literal}" {literal}{{#conversation_id}}{/literal}data-cid="{literal}{{conversation_id}}{/literal}" {literal}{{/conversation_id}}{/literal} {literal}{{#user_id}}{/literal}data-uid="{literal}{{user_id}}{/literal}" {literal}{{/user_id}}{/literal} {literal}{{#page_id}}{/literal}data-page-id="{literal}{{page_id}}{/literal}" {literal}{{/page_id}}{/literal}>
        <!-- head -->
        <div class="chat-widget-head flex cursor-pointer items-center gap-2.5 px-3 py-2.5">
          <!-- user-card -->
          <a class="chat-user-card js_chat-box-status offline group/status flex min-w-0 grow items-center gap-2.5 text-base-content!" href="{$system['system_url']}/{literal}{{link}}{/literal}" title="{literal}{{name_list}}{/literal}">
            {literal}{{^multiple}}{/literal}
            <div class="avatar relative size-9 shrink-0">
              <img class="size-9 rounded-full object-cover" src="{literal}{{picture}}{/literal}">
              <i class="online-status absolute bottom-0 end-0 size-2.5 rounded-full bg-success ring-2 ring-base-100 group-[.offline]/status:hidden"></i>
            </div>
            {literal}{{/multiple}}{/literal}
            {literal}{{#multiple}}{/literal}
            <div class="js_chat-group-avatar flex size-9 shrink-0 items-center justify-center overflow-hidden rounded-full bg-base-200 text-base-content/50">
              <span class="icon-[tabler--users] size-4.5" aria-hidden="true"></span>
            </div>
            {literal}{{/multiple}}{/literal}
            <div class="name min-w-0 leading-tight">
              <span class="js_chat-title block truncate text-sm font-semibold" title="{literal}{{name}}{/literal}">{literal}{{name}}{/literal}</span>
              {literal}{{^multiple}}{/literal}
              {literal}{{#page_id}}{/literal}
              <span class="mt-0.5 block truncate text-[11px] text-base-content/50">{__("Page")}</span>
              {literal}{{/page_id}}{/literal}
              {literal}{{^page_id}}{/literal}
              <span class="mt-0.5 block truncate text-[11px]">
                <span class="text-success group-[.offline]/status:hidden">{__("Online")}</span>
                <span class="hidden text-base-content/50 group-[.offline]/status:inline">{__("Offline")}</span>
              </span>
              {literal}{{/page_id}}{/literal}
              {literal}{{/multiple}}{/literal}
              {literal}{{#multiple}}{/literal}
              <span class="js_chat-subtitle mt-0.5 block truncate text-[11px] text-base-content/50" title="{literal}{{name_list}}{/literal}">{literal}{{name_list}}{/literal}</span>
              {literal}{{/multiple}}{/literal}
            </div>
          </a>
          <!-- user-card -->

          <!-- label -->
          <span class="badge badge-error badge-sm js_chat-box-label shrink-0 rounded-full empty:hidden"></span>
          <!-- label -->

          <!-- buttons-->
          <div class="chat-head-btns flex shrink-0 items-center gap-0.5">
            <!-- video/audio calls (not multiple) -->
            {literal}{{^multiple}}{{^page_id}}{/literal}
            {if $system['audio_call_enabled'] && $user->_data['can_start_audio_call']}
              <button type="button" class="chat-head-btn heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full js_chat-call-start" data-type="audio" data-uid="{literal}{{user_id}}{/literal}" data-name="{literal}{{name_list}}{/literal}" data-picture="{literal}{{picture}}{/literal}" title='{__("Audio Call")}' aria-label='{__("Audio Call")}'>
                <span class="icon-[tabler--phone] size-4 pointer-events-none" aria-hidden="true"></span>
              </button>
            {/if}
            {if $system['video_call_enabled'] && $user->_data['can_start_video_call']}
              <button type="button" class="chat-head-btn heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full js_chat-call-start" data-type="video" data-uid="{literal}{{user_id}}{/literal}" data-name="{literal}{{name_list}}{/literal}" data-picture="{literal}{{picture}}{/literal}" title='{__("Video Call")}' aria-label='{__("Video Call")}'>
                <span class="icon-[tabler--video] size-4 pointer-events-none" aria-hidden="true"></span>
              </button>
            {/if}
            {literal}{{/page_id}}{{/multiple}}{/literal}
            <!-- video/audio calls (not multiple) -->
            <button type="button" class="chat-head-btn heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full" title='{__("Minimize")}' aria-label='{__("Minimize")}'>
              <span class="icon-[tabler--minus] size-4 pointer-events-none group-[:not(.opened)]/widget:hidden" aria-hidden="true"></span>
              <span class="icon-[tabler--chevron-up] size-4 pointer-events-none hidden group-[:not(.opened)]/widget:block" aria-hidden="true"></span>
            </button>
            <button type="button" class="chat-head-btn heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full js_chat-box-close" title='{__("Close")}' aria-label='{__("Close")}'>
              <span class="icon-[tabler--x] size-4 pointer-events-none" aria-hidden="true"></span>
            </button>
          </div>
          <!-- buttons-->
        </div>
        <!-- head -->
        <!-- content -->
        <div class="chat-widget-content border-t border-base-300">
          <div class="flex h-[345px] flex-col">
            <div class="js_chat-pin-wrap shrink-0"></div>
            <div class="chat-conversations js_scroller flex min-h-0 flex-1 flex-col overflow-x-hidden overflow-y-auto px-3 py-3" data-slimScroll-height="100%" data-slimScroll-start="bottom">
              <ul class="m-0 mt-auto flex list-none flex-col gap-3 p-0"></ul>
            </div>
          </div>
          {include file='__chat_composer.tpl' _show_typing=true _monetize_handlebars=true _colors=true _colors_handlebars=true}
        </div>
        <!-- content -->
      </div>
    </script>

    <script id="chat-message" type="text/template">
      <li class="group/msg [&.chat-cont]:-mt-2">
        <div class="conversation clearfix flex items-end gap-2 right ms-auto flex-row-reverse" id="{literal}{{id}}{/literal}" data-copy="{literal}{{copy}}{/literal}">
          <div class="conversation-body flex min-w-0 max-w-[75%] in-[.chat-widget]:max-w-full flex-col gap-1 items-end">
            {literal}{{#reply_name}}{/literal}
            <button type="button" class="js_chat-reply-jump -mb-3 flex min-w-0 max-w-64 items-stretch gap-2.5 rounded-xl bg-base-200/70 pt-1.5 pb-4 ps-2 pe-3 text-start transition-colors hover:bg-base-200 ms-auto" data-id="{literal}{{reply_id}}{/literal}">
              <span class="w-0.5 shrink-0 rounded-full bg-primary" aria-hidden="true"></span>
              <span class="min-w-0">
                <span class="flex min-w-0 items-center gap-1 text-[11px] font-semibold text-primary"><span class="icon-[tabler--arrow-back-up] size-3 shrink-0" aria-hidden="true"></span><span class="truncate" title="{literal}{{reply_name}}{/literal}">{literal}{{reply_name}}{/literal}</span></span>
                <span class="block truncate text-xs text-base-content/65" title="{literal}{{reply_snippet}}{/literal}">{literal}{{reply_snippet}}{/literal}</span>
              </span>
            </button>
            {literal}{{/reply_name}}{/literal}
            <div class="relative flex min-w-0 max-w-full items-center gap-0.5 flex-row-reverse">
              <div class="chat-message-bubble flex min-w-0 flex-col items-end gap-1">
                {literal}{{#message}}{/literal}
                <div class="clearfix">
                  <span class="text inline-block max-w-full break-words rounded-2xl px-3.5 py-2 text-sm leading-relaxed js_chat-color-me rounded-ee-md bg-primary text-primary-content group-[.chat-cont]/msg:rounded-se-md" dir="auto" {literal}{{#color}}{/literal}style="background-color: {literal}{{color}}{/literal}" {literal}{{/color}}{/literal}>
                    {literal}{{{message}}}{/literal}
                  </span>
                </div>
                {literal}{{/message}}{/literal}
                {literal}{{#image}}{/literal}
                <div class="chat-message-media w-64 max-w-full">
                  <span class="js_lightbox-nodata block cursor-pointer overflow-hidden rounded-2xl border border-base-300/70 bg-base-200" data-image="{$system['system_uploads']}/{literal}{{image}}{/literal}">
                    <img alt="" class="block max-h-80 w-full object-cover" src="{$system['system_uploads']}/{literal}{{image}}{/literal}">
                  </span>
                </div>
                {literal}{{/image}}{/literal}
                {literal}{{#video}}{/literal}
                <div class="chat-message-media w-80 max-w-full overflow-hidden rounded-2xl bg-black">
                  <video class="video-wrapper js_video-plyr block w-full" controls preload="metadata">
                    <source src="{$system['system_uploads']}/{literal}{{video}}{/literal}" type="video/mp4">
                  </video>
                </div>
                {literal}{{/video}}{/literal}
                {literal}{{#voice_note}}{/literal}
                <div class="chat-message-media w-72 max-w-full">
                  <audio class="js_audio block h-10 w-full" id="audio-{literal}{{id}}{/literal}" controls preload="metadata">
                    <source src="{$system['system_uploads']}/{literal}{{voice_note}}{/literal}" type="audio/mpeg">
                    <source src="{$system['system_uploads']}/{literal}{{voice_note}}{/literal}" type="audio/mp3">
                    {__("Your browser does not support HTML5 audio")}
                  </audio>
                </div>
                {literal}{{/voice_note}}{/literal}
              </div>
              <div class="chat-message-actions flex shrink-0 items-center gap-0.5 opacity-100 transition-opacity md:opacity-0 md:group-hover/msg:opacity-100 md:group-focus-within/msg:opacity-100 md:has-[.dropdown.open]:opacity-100">
                <div class="reactions-wrapper relative">
                  <button type="button" class="heroui button button--ghost button--sm button--icon-only size-6 rounded-full text-base-content/60 hover:text-primary" title="{__("React")}" aria-label="{__("React")}">
                    <span class="reaction-btn-icon inline-flex size-4"><span class="icon-[tabler--mood-smile] size-4" aria-hidden="true"></span></span>
                  </button>
                  {include file='__reactions_container.tpl' _handle="message"}
                </div>
                <button type="button" class="heroui button button--ghost button--sm button--icon-only size-6 rounded-full text-base-content/60 hover:text-primary js_reply-message" data-id="{literal}{{id}}{/literal}" data-name="{literal}{{name}}{/literal}" data-snippet="{literal}{{copy}}{/literal}" title="{__("Reply")}" aria-label="{__("Reply")}">
                  <span class="icon-[tabler--arrow-back-up] size-4" aria-hidden="true"></span>
                </button>
                <div class="dropdown relative inline-flex [--offset:4] [--placement:top-end]">
                  <button type="button" class="dropdown-toggle heroui button button--ghost button--sm button--icon-only size-6 rounded-full text-base-content/60 hover:text-primary dropdown-open:bg-base-content/10 dropdown-open:text-base-content" aria-haspopup="menu" aria-expanded="false" title="{__("More")}" aria-label="{__("More")}">
                    <span class="icon-[tabler--dots] size-4" aria-hidden="true"></span>
                  </button>
                  <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-40 rounded-box border border-base-content/10 bg-base-100 p-1 shadow-xl" role="menu">
                    {literal}{{#copy}}{/literal}<button type="button" class="dropdown-close dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-start text-[13px] font-medium text-base-content! js_copy-message" role="menuitem"><span class="icon-[tabler--copy] size-4 shrink-0 text-base-content/55" aria-hidden="true"></span><span>{__("Copy")}</span></button>{literal}{{/copy}}{/literal}
                    <button type="button" class="dropdown-close dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-start text-[13px] font-medium text-base-content! js_pin-message" role="menuitem"><span class="icon-[tabler--pin] size-4 shrink-0 text-base-content/55" aria-hidden="true"></span><span>{__("Pin")}</span></button>
                    <div class="-mx-1 my-1 border-t border-base-content/10" role="separator"></div>
                    <button type="button" class="dropdown-close dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-start text-[13px] font-medium text-error! hover:bg-error/10! focus-visible:bg-error/10! js_delete-message" role="menuitem"><span class="icon-[tabler--trash] size-4 shrink-0" aria-hidden="true"></span><span>{__("Remove")}</span></button>
                  </div>
                </div>
              </div>
            </div>
            <div class="conversation-meta flex flex-wrap items-center justify-end gap-x-2 gap-y-1 px-1 text-[11px] leading-4 text-base-content/45 group-[.chat-more]/msg:hidden group-[.chat-more]/msg:has-[.seen,.chat-paid-badge]:flex">
              <div class="time js_moment group-[.chat-more]/msg:hidden" data-time="{literal}{{time}}{/literal}">{literal}{{time}}{/literal}</div>
            </div>
          </div>
        </div>
      </li>
    </script>

    <script id="chat-calling" type="text/template">
      {include file='__chat_call.tpl' _incoming=false}
    </script>

    <script id="chat-ringing" type="text/template">
      {include file='__chat_call.tpl' _incoming=true}
    </script>

    <script id="chat-colors-menu" type="text/template">
      <div class="chat-colors-menu absolute bottom-full start-2 z-50 mb-2 hidden w-52 rounded-box border border-base-300 bg-base-100 p-2 shadow-lg">
        <div class="js_scroller grid grid-cols-5 gap-1" data-slimScroll-height="180">
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#5e72e4" style="color: #5e72e4;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#0ba05d" style="color: #0ba05d;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#ed9e6a" style="color: #ed9e6a;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#a085e2" style="color: #a085e2;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#01a5a5" style="color: #01a5a5;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#2b87ce" style="color: #2b87ce;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#ff72d2" style="color: #ff72d2;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#c9605e" style="color: #c9605e;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#056bba" style="color: #056bba;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#fc9cde" style="color: #fc9cde;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#70a0e0" style="color: #70a0e0;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#f2812b" style="color: #f2812b;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#8ec96c" style="color: #8ec96c;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#f33d4c" style="color: #f33d4c;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#aa2294" style="color: #aa2294;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#0e71ea" style="color: #0e71ea;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#b582af" style="color: #b582af;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#a1ce79" style="color: #a1ce79;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#56c4c5" style="color: #56c4c5;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#f9a722" style="color: #f9a722;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#f9c270" style="color: #f9c270;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#609b41" style="color: #609b41;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#51bcbc" style="color: #51bcbc;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#008484" style="color: #008484;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
          <div class="item js_chat-color flex size-8 cursor-pointer items-center justify-center rounded-full hover:bg-base-200" data-color="#5462a5" style="color: #5462a5;">
            <span class="icon-[tabler--circle-filled] size-5" aria-hidden="true"></span>
          </div>
        </div>
      </div>
    </script>

    <script id="chat-attachments-item" type="text/template">
      <li class="item deletable relative size-16 overflow-hidden rounded-lg" data-src="{literal}{{src}}{/literal}">
        <img alt="" class="size-full object-cover" src="{literal}{{image_path}}{/literal}">
        <button class="heroui button button--tertiary button--sm button--icon-only size-6 rounded-full absolute end-0.5 top-0.5 js_chat-attachment-remover" type="button" title='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
      </li>
    </script>

    <script id="conversation-loading" type="text/template">
      <div class="flex min-h-0 min-w-0 flex-1 overflow-hidden" aria-busy="true">
        <div class="card panel-messages flex min-h-0 min-w-0 flex-1 flex-col overflow-hidden rounded-none border-0 bg-base-100 shadow-none">
          <span class="sr-only">{__("Loading")}</span>
          <!-- header -->
          <div class="flex h-18 shrink-0 items-center gap-3 border-b border-base-300 bg-base-100 px-4 sm:px-5">
            <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full -ms-1 lg:hidden" data-bs-toggle="sg-offcanvas" title='{__("Back To Messages")}' aria-label='{__("Back To Messages")}'>
              <span class="icon-[tabler--chevron-left] size-5 rtl:rotate-180" aria-hidden="true"></span>
            </button>
            <span class="relative shrink-0">
              {literal}{{#picture}}{/literal}
              <span class="flex size-11 overflow-hidden rounded-full bg-base-200">
                <img class="size-full object-cover" src="{literal}{{picture}}{/literal}" alt="">
              </span>
              {literal}{{/picture}}{/literal}
              {literal}{{^picture}}{/literal}
              <span class="skeleton skeleton-animated size-11 rounded-full"></span>
              {literal}{{/picture}}{/literal}
            </span>
            <div class="min-w-0 grow">
              <div class="truncate font-semibold leading-tight" title="{literal}{{name}}{/literal}">{literal}{{name}}{/literal}</div>
              <div class="skeleton skeleton-animated mt-1.5 h-3 w-24 rounded-full"></div>
            </div>
            <div class="flex shrink-0 items-center gap-1.5">
              <span class="skeleton skeleton-animated size-9 rounded-full"></span>
              <span class="skeleton skeleton-animated size-9 rounded-full"></span>
              <span class="skeleton skeleton-animated size-9 rounded-full"></span>
            </div>
          </div>
          <!-- header -->
          <!-- messages -->
          <div class="chat-conversations flex min-h-0 flex-1 flex-col overflow-hidden bg-linear-to-b from-base-200/40 to-base-100 px-4 py-4 sm:px-6">
            <div class="mt-auto flex flex-col gap-3">
              <div class="flex items-end gap-2">
                <span class="skeleton skeleton-animated size-8 shrink-0 rounded-full"></span>
                <span class="skeleton skeleton-animated h-10 w-40 rounded-2xl rounded-es-md"></span>
              </div>
              <div class="flex items-end justify-end">
                <span class="skeleton skeleton-animated h-10 w-56 rounded-2xl rounded-ee-md"></span>
              </div>
              <div class="flex items-end gap-2">
                <span class="skeleton skeleton-animated size-8 shrink-0 rounded-full"></span>
                <span class="skeleton skeleton-animated h-16 w-64 max-w-[70%] rounded-2xl rounded-es-md"></span>
              </div>
              <div class="flex items-end justify-end">
                <span class="skeleton skeleton-animated h-10 w-32 rounded-2xl rounded-ee-md"></span>
              </div>
              <div class="flex items-end gap-2">
                <span class="skeleton skeleton-animated size-8 shrink-0 rounded-full"></span>
                <span class="skeleton skeleton-animated h-10 w-48 rounded-2xl rounded-es-md"></span>
              </div>
            </div>
          </div>
          <!-- messages -->
          <div class="shrink-0">
            <div class="chat-form border-t border-base-300 bg-base-100 px-3 py-3 sm:px-4">
              <div class="flex items-end gap-1.5">
                <span class="skeleton skeleton-animated size-10 shrink-0 rounded-full"></span>
                <span class="skeleton skeleton-animated h-10 min-w-0 grow rounded-3xl"></span>
                <span class="skeleton skeleton-animated size-10 shrink-0 rounded-full"></span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </script>
    <!-- Chat -->
