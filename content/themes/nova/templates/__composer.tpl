{assign var="_video" value=false}
{assign var="_file" value=false}
{assign var="_paid" value=false}
{assign var="_color" value=false}
{if $_context == "chat"}
  {assign var="_composer_handle" value="chat"}
  {assign var="_send_class" value="js_post-message"}
  {assign var="_voice" value=$system['voice_notes_chat_enabled']}
  {assign var="_photo" value=$system['chat_photos_enabled']}
  {if $system['chat_videos_enabled'] && $user->_data['can_upload_videos']}
    {assign var="_video" value=true}
  {/if}
  {if $system['chat_files_enabled'] && $user->_data['can_upload_files']}
    {assign var="_file" value=true}
  {/if}
  {if $user->_data['can_monetize_content'] && ($_monetize_cid || $_monetize_handlebars)}
    {assign var="_paid" value=true}
  {/if}
  {if $_colors}
    {assign var="_color" value=true}
  {/if}
{else}
  {assign var="_composer_handle" value="comment"}
  {if $_context == "reply"}
    {assign var="_send_class" value="js_post-reply"}
  {else}
    {assign var="_send_class" value="js_post-comment"}
  {/if}
  {assign var="_voice" value=$system['voice_notes_comments_enabled']}
  {assign var="_photo" value=$system['comments_photos_enabled']}
{/if}
{if $_size == "lg"}
  {assign var="_btn" value="button--icon-only rounded-full size-10"}
  {assign var="_icon" value="size-5"}
{else}
  {assign var="_btn" value="button--sm button--icon-only rounded-full size-9"}
  {assign var="_icon" value="size-4.5"}
{/if}
<div class="x-form js_composer voice-recording-wrapper group/composer relative{if $_form_invisible} invisible{/if} {$_class} [&_.x-uploader]:relative [&_.x-uploader]:cursor-pointer [&_.x-uploader]:overflow-hidden [&_.x-uploader>input[type=file]]:absolute [&_.x-uploader>input[type=file]]:inset-0 [&_.x-uploader>input[type=file]]:z-10 [&_.x-uploader>input[type=file]]:size-full [&_.x-uploader>input[type=file]]:cursor-pointer [&_.x-uploader>input[type=file]]:opacity-0" data-handle="{$_composer_handle}">
  {if $_composer_handle == 'chat'}
    <div class="js_chat-reply-bar mb-2 hidden items-stretch gap-2.5 rounded-xl bg-base-200/70 py-1.5 ps-2 pe-1.5">
      <span class="w-0.5 shrink-0 rounded-full bg-primary" aria-hidden="true"></span>
      <div class="min-w-0 grow self-center">
        <div class="flex min-w-0 items-center gap-1 text-[11px] font-semibold text-primary"><span class="icon-[tabler--arrow-back-up] size-3 shrink-0" aria-hidden="true"></span><span class="js_chat-reply-name truncate"></span></div>
        <div class="js_chat-reply-snippet block truncate text-xs text-base-content/65"></div>
      </div>
      <button type="button" class="heroui button button--ghost button--sm button--icon-only size-6 rounded-full shrink-0 self-center text-base-content/55 hover:text-base-content js_chat-reply-cancel" title="{__("Cancel")}" aria-label="{__("Cancel")}">
        <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
      </button>
    </div>
    <div class="js_chat-product-bar mb-2 hidden items-center gap-2.5 rounded-xl bg-base-200/70 p-1.5">
      <img class="js_chat-product-image size-10 shrink-0 rounded-lg bg-base-200 object-cover" alt="">
      <div class="min-w-0 grow">
        <div class="js_chat-product-name truncate text-xs font-semibold text-base-content"></div>
        <div class="js_chat-product-price text-xs font-semibold text-primary"></div>
      </div>
      <button type="button" class="heroui button button--ghost button--sm button--icon-only size-6 rounded-full shrink-0 text-base-content/55 hover:text-base-content js_chat-product-cancel" title="{__("Cancel")}" aria-label="{__("Cancel")}">
        <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
      </button>
    </div>
  {/if}
  <!-- attachments -->
  <div class="{if $_composer_handle == 'chat'}chat-attachments{else}comment-attachments{/if} attachments mb-2 hidden">
    <ul class="flex gap-2 {if $_composer_handle == 'chat'}overflow-x-auto pb-1 [&>li]:shrink-0 [&>[data-upload-id]:not([data-document])]:w-36!{else}flex-wrap{/if}">
      <li class="js_loading w-full">
        <div class="progress x-progress h-1.5 w-full overflow-hidden rounded-full bg-base-300">
          <div class="progress-bar h-full w-0 bg-primary" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
        </div>
      </li>
    </ul>
  </div>
  <!-- attachments -->

  <!-- composer -->
  <div class="flex items-end gap-1.5 group-data-[state]/composer:hidden">
    {capture name="composer_attach"}{if $_photo || $_video || $_file || $_paid || $_color}
      <div class="x-form-tools-attach flex shrink-0{if $_composer_handle != 'chat'} {if $_size == 'lg'}mb-1{else}mb-0.5{/if}{/if}">
        <div class="dropdown relative inline-flex [--offset:8] {if $_composer_handle == 'chat'}[--placement:top-start]{else}[--placement:top-end]{/if} [--strategy:fixed]">
          <button type="button" class="dropdown-toggle heroui button button--ghost {if $_composer_handle == 'chat'}{$_btn}{else}button--sm button--icon-only size-7.5 rounded-full{/if} text-base-content/70 hover:text-primary" aria-haspopup="menu" aria-expanded="false" title='{__("Attach")}' aria-label='{__("Attach")}'>
            <span class="icon-[tabler--plus] {if $_composer_handle == 'chat'}{$_icon}{else}size-5{/if}" aria-hidden="true"></span>
          </button>
          <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-56 max-w-[calc(100vw-2rem)] rounded-2xl border border-base-300 bg-base-100 p-2 shadow-lg" role="menu">
            {if $_photo}
              <div class="dropdown-close dropdown-item grid overflow-hidden rounded-xl p-0!">
                <span class="js_x-uploader flex w-full items-center gap-3 px-3 py-2.5 text-sm font-medium" data-handle="{$_composer_handle}"{if $_composer_handle == 'chat'} data-multiple="true"{/if}>
                  <span class="icon-[tabler--photo] size-5 shrink-0 text-success" aria-hidden="true"></span>{if $_composer_handle == 'chat'}{__("Photos")}{else}{__("Photo")}{/if}
                </span>
              </div>
            {/if}
            {if $_video}
              <div class="dropdown-close dropdown-item grid overflow-hidden rounded-xl p-0!">
                <span class="js_x-uploader flex w-full items-center gap-3 px-3 py-2.5 text-sm font-medium" data-handle="{$_composer_handle}" data-type="video" data-multiple="true">
                  <span class="icon-[tabler--video] size-5 shrink-0 text-error" aria-hidden="true"></span>{__("Videos")}
                </span>
              </div>
            {/if}
            {if $_file}
              <div class="dropdown-close dropdown-item grid overflow-hidden rounded-xl p-0!">
                <span class="js_x-uploader flex w-full items-center gap-3 px-3 py-2.5 text-sm font-medium" data-handle="{$_composer_handle}" data-type="file" data-multiple="true">
                  <span class="icon-[tabler--paperclip] size-5 shrink-0 text-info" aria-hidden="true"></span>{__("Files")}
                </span>
              </div>
            {/if}
            {if $_paid}
              {if $_monetize_handlebars}{literal}{{#conversation_id}}{{^page_id}}{/literal}{/if}
              <button type="button" class="js_modal dropdown-close dropdown-item flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium" data-static="true" data-size="publisher" data-url="chat/publisher.php?cid={if $_monetize_handlebars}{literal}{{conversation_id}}{/literal}{else}{$_monetize_cid}{/if}">
                <span class="icon-[tabler--currency-dollar] size-5 shrink-0 text-warning" aria-hidden="true"></span>{__("Paid Message")}
              </button>
              {if $_monetize_handlebars}{literal}{{/page_id}}{{/conversation_id}}{/literal}{/if}
            {/if}
            {if $_color}
              <button type="button" class="x-form-tools-colors js_chat-colors-menu-toggle dropdown-close dropdown-item flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium{if $_colors_handlebars} {literal}{{^conversation_id}}{/literal}hidden{literal}{{/conversation_id}}{/literal}{/if}">
                <span class="icon-[tabler--palette] size-5 shrink-0 text-info" aria-hidden="true"></span>{__("Chat Color")}
              </button>
            {/if}
          </div>
        </div>
      </div>
    {/if}{/capture}
    {if $_composer_handle == 'chat'}{$smarty.capture.composer_attach}{/if}

    <div class="relative flex {if $_size == 'lg'}min-h-10{else}min-h-9{/if} min-w-0 grow items-end {if $_composer_handle == 'chat'}rounded-3xl{else}rounded-[0.75rem]{/if} border border-base-300 bg-base-200/60 ps-4 pe-1 transition-colors focus-within:border-primary/50 focus-within:bg-base-100">
      <textarea dir="auto" rows="1" class="js_autosize {if $_composer_handle == 'comment'}js_mentions {/if}{$_send_class} block max-h-40 {if $_size == 'lg'}py-[9px]{else}py-[7px]{/if} w-full resize-none border-0 bg-transparent ps-0 pe-2 text-sm leading-5 max-md:text-base text-base-content outline-none placeholder:text-base-content/50" placeholder='{if $_context == "chat"}{__("Write a message")}{elseif $_context == "reply"}{__("Write a Reply")}{else}{__("Write a comment")}{/if}'></textarea>
      {if $_composer_handle != 'chat'}{$smarty.capture.composer_attach}{/if}
      <span class="flex shrink-0 {if $_size == 'lg'}mb-1{else}mb-0.5{/if}">{include file='__emoji_trigger.tpl' _gifs=$user->_data['can_send_gifs']}</span>
    </div>

    {if $_voice}
      <div class="grid shrink-0 *:[grid-area:1/1]">
        <button type="button" class="js_voice-start heroui button button--ghost {$_btn} text-base-content/70 transition-[color,background-color,opacity,scale,rotate,visibility] duration-300 ease-[cubic-bezier(0.34,1.56,0.64,1)] hover:text-primary motion-reduce:transition-none group-has-[textarea:not(:placeholder-shown),[data-upload-id],[data-gif-item]]/composer:invisible group-has-[textarea:not(:placeholder-shown),[data-upload-id],[data-gif-item]]/composer:rotate-45 group-has-[textarea:not(:placeholder-shown),[data-upload-id],[data-gif-item]]/composer:scale-50 group-has-[textarea:not(:placeholder-shown),[data-upload-id],[data-gif-item]]/composer:opacity-0 group-has-[textarea:not(:placeholder-shown),[data-upload-id],[data-gif-item]]/composer:duration-150 group-has-[textarea:not(:placeholder-shown),[data-upload-id],[data-gif-item]]/composer:ease-in" title='{__("Record")}' aria-label='{__("Record")}'>
          <span class="icon-[tabler--microphone] {$_icon}" aria-hidden="true"></span>
        </button>
        <button type="button" class="{$_send_class} js_composer-send{if $_composer_handle == 'chat'} js_chat-color-me{/if} heroui button button--primary {$_btn} invisible -rotate-45 scale-50 opacity-0 transition-[color,background-color,opacity,scale,rotate,visibility] duration-150 ease-in motion-reduce:transition-none group-has-[textarea:not(:placeholder-shown),[data-upload-id],[data-gif-item]]/composer:visible group-has-[textarea:not(:placeholder-shown),[data-upload-id],[data-gif-item]]/composer:rotate-0 group-has-[textarea:not(:placeholder-shown),[data-upload-id],[data-gif-item]]/composer:scale-100 group-has-[textarea:not(:placeholder-shown),[data-upload-id],[data-gif-item]]/composer:opacity-100 group-has-[textarea:not(:placeholder-shown),[data-upload-id],[data-gif-item]]/composer:duration-300 group-has-[textarea:not(:placeholder-shown),[data-upload-id],[data-gif-item]]/composer:ease-[cubic-bezier(0.34,1.56,0.64,1)]" title='{__("Send")}' aria-label='{__("Send")}'>
          <span class="icon-[tabler--send] {$_icon}" aria-hidden="true"></span>
        </button>
      </div>
    {else}
      <button type="button" class="{$_send_class} js_composer-send{if $_composer_handle == 'chat'} js_chat-color-me{/if} heroui button button--primary {$_btn} shrink-0" title='{__("Send")}' aria-label='{__("Send")}'>
        <span class="icon-[tabler--send] {$_icon}" aria-hidden="true"></span>
      </button>
    {/if}
  </div>
  <!-- composer -->

  {if $_voice}
    <!-- voice recording -->
    <div class="hidden items-center gap-1.5 group-data-[state]/composer:flex">
      <button type="button" class="js_voice-cancel heroui button button--ghost {$_btn} shrink-0 text-error group-data-[state=processing]/composer:invisible" title='{__("Cancel")}' aria-label='{__("Cancel")}'>
        <span class="icon-[tabler--trash] {$_icon}" aria-hidden="true"></span>
      </button>
      <div class="flex {if $_size == 'lg'}h-10{else}h-9{/if} min-w-0 grow items-center gap-2 {if $_composer_handle == 'chat'}rounded-3xl{else}rounded-[0.75rem]{/if} bg-base-200/60 px-4 text-sm">
        <span class="size-2.5 shrink-0 animate-pulse rounded-full bg-error group-data-[state=processing]/composer:hidden" aria-hidden="true"></span>
        <span class="js_voice-timer font-medium tabular-nums group-data-[state=processing]/composer:hidden">00:00</span>
        <span class="hidden text-base-content/60 group-data-[state=processing]/composer:inline">{__("Processing")}<span class="loading loading-dots loading-xs ms-1 align-middle" aria-hidden="true"></span></span>
      </div>
      <button type="button" class="js_voice-stop{if $_composer_handle == 'chat'} js_chat-color-me{/if} heroui button button--primary {$_btn} shrink-0 group-data-[state=processing]/composer:pointer-events-none" title='{__("Send")}' aria-label='{__("Send")}'>
        <span class="icon-[tabler--send] {$_icon} group-data-[state=processing]/composer:hidden" aria-hidden="true"></span>
        <span class="loading loading-spinner loading-sm hidden group-data-[state=processing]/composer:inline-block" aria-hidden="true"></span>
      </button>
    </div>
    <!-- voice recording -->
  {/if}
</div>
