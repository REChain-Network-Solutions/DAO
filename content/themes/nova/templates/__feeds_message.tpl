<li class="group/msg [&.chat-cont]:-mt-2" data-uid="{$message['user_id']}">
  {if isset($is_me)}
    {assign var="is_mine" value=$is_me}
  {elseif $conversation['as_page']}
    {assign var="is_mine" value=!empty($message['page_id'])}
  {else}
    {assign var="is_mine" value=(empty($message['page_id']) && $message['user_id'] == $user->_data['user_id'])}
  {/if}
  <div class="conversation clearfix flex items-end gap-2 {if $is_mine}right ms-auto flex-row-reverse{/if}" id="{$message['message_id']}" data-copy="{$message['message_orginal_decoded']|escape:'html'}">
    {if !$is_mine}
      <div class="conversation-user shrink-0 group-[.chat-more]/msg:invisible">
        <a href="{$system['system_url']}/{if $message['page_id']}pages/{$message['page_name']}{else}{$message['user_name']}{/if}">
          <img class="size-8 rounded-full object-cover ring-2 ring-base-100" src="{$message['user_picture']}" alt="">
        </a>
      </div>
    {/if}
    <div class="conversation-body flex min-w-0 max-w-[75%] in-[.chat-widget]:max-w-full flex-col gap-1 {if $is_mine}items-end{else}items-start{/if} {if $system['chat_translation_enabled'] && !is_empty($message['message'])}js_chat-translator{/if}">
      {if $message['reply']}
        <button type="button" class="js_chat-reply-jump -mb-3 flex min-w-0 max-w-64 items-stretch gap-2.5 rounded-xl bg-base-200/70 pt-1.5 pb-4 ps-2 pe-3 text-start transition-colors hover:bg-base-200 {if $is_mine}ms-auto{/if}" data-id="{$message['reply']['message_id']}">
          <span class="w-0.5 shrink-0 rounded-full bg-primary" aria-hidden="true"></span>
          <span class="min-w-0">
            {if $message['reply']['user_fullname']}
              <span class="flex min-w-0 items-center gap-1 text-[11px] font-semibold text-primary"><span class="icon-[tabler--arrow-back-up] size-3 shrink-0" aria-hidden="true"></span><span class="truncate" title="{$message['reply']['user_fullname']}">{$message['reply']['user_fullname']}</span></span>
            {/if}
            <span class="block truncate text-xs text-base-content/65" title="{$message['reply']['snippet']|escape:'html'}">{$message['reply']['snippet']|escape:'html'}</span>
          </span>
        </button>
      {/if}
      <div class="relative flex min-w-0 max-w-full items-center gap-0.5 {if $is_mine}flex-row-reverse{/if}">
        <div class="chat-message-bubble flex min-w-0 flex-col gap-1 {if $is_mine}items-end{else}items-start{/if}">
          <!-- message -->
          {if $message['call']}
            <!-- call -->
            {if ($message['call']['is_video'] && $system['video_call_enabled']) || (!$message['call']['is_video'] && $system['audio_call_enabled'])}
              {assign var="_call_back" value=true}
            {else}
              {assign var="_call_back" value=false}
            {/if}
            <button type="button" class="chat-message-call flex max-w-full items-center gap-2.5 rounded-2xl py-2 ps-2 pe-4 text-start transition-colors disabled:cursor-default {if $_call_back}js_chat-call-start{/if} {if $is_mine}js_chat-color-me rounded-ee-md bg-primary text-primary-content group-[.chat-cont]/msg:rounded-se-md enabled:hover:opacity-90{else}rounded-es-md border border-base-300/70 bg-base-100 text-base-content group-[.chat-cont]/msg:rounded-ss-md enabled:hover:bg-base-200{/if}" data-type="{if $message['call']['is_video']}video{else}audio{/if}" {if $is_mine}data-uid="{$message['call']['to_user_id']}" data-name="{$message['call']['to_user_fullname']|escape:'html'}" data-picture="{$message['call']['to_user_picture']}"{else}data-uid="{$message['user_id']}" data-name="{$message['user_fullname']|escape:'html'}" data-picture="{$message['user_picture']}"{/if} {if $_call_back}title='{__("Call back")}'{else}disabled{/if}>
              <span class="flex size-8 shrink-0 items-center justify-center rounded-full {if $message['call']['status'] == 'missed' && !$is_mine}bg-error text-error-content{elseif $is_mine}bg-white/20{else}bg-base-200 text-base-content/70{/if}" aria-hidden="true">
                {if $message['call']['is_video']}
                  {if $message['call']['status'] == 'completed'}<span class="icon-[tabler--video] size-4"></span>{else}<span class="icon-[tabler--video-off] size-4"></span>{/if}
                {else}
                  {if $message['call']['status'] != 'completed'}<span class="icon-[tabler--phone-x] size-4"></span>{elseif $is_mine}<span class="icon-[tabler--phone-outgoing] size-4"></span>{else}<span class="icon-[tabler--phone-incoming] size-4"></span>{/if}
                {/if}
              </span>
              <span class="flex min-w-0 flex-col">
                <span class="whitespace-nowrap text-[13px] leading-5 font-semibold">
                  {if $message['call']['status'] == 'missed' && !$is_mine}
                    {if $message['call']['is_video']}{__("Missed video call")}{else}{__("Missed audio call")}{/if}
                  {else}
                    {if $message['call']['is_video']}{__("Video call")}{else}{__("Audio call")}{/if}
                  {/if}
                </span>
                <span class="whitespace-nowrap text-xs leading-4 tabular-nums {if $is_mine}opacity-75{else}text-base-content/60{/if}">
                  {if $message['call']['status'] == 'completed'}
                    {$message['call']['duration_formatted']}
                  {elseif $message['call']['status'] == 'declined'}
                    {__("Declined")}
                  {elseif $is_mine}
                    {__("No answer")}
                  {elseif $_call_back}
                    {__("Tap to call back")}
                  {/if}
                </span>
              </span>
            </button>
            <!-- call -->
          {/if}
          {if $message['story']}
            <!-- story -->
            <div class="chat-message-media flex flex-col gap-1.5 {if $is_mine}items-end{else}items-start{/if} {if !is_empty($message['message'])}-mb-5{/if}">
              <span class="flex items-center gap-1 text-xs text-base-content/60">
                <span class="icon-[tabler--arrow-back-up] size-3.5 shrink-0" aria-hidden="true"></span>
                {if $is_mine}{__("You replied to their story")}{else}{__("Replied to your story")}{/if}
              </span>
              {if $message['story']['unavailable']}
                <span class="flex h-24 w-28 flex-col items-center justify-center gap-1.5 rounded-2xl bg-base-200 px-2 text-center text-xs text-base-content/60">
                  <span class="icon-[tabler--history-off] size-5" aria-hidden="true"></span>
                  {__("Story unavailable")}
                </span>
              {else}
                <button type="button" class="js_story-open relative block h-48 w-28 overflow-hidden rounded-2xl bg-linear-to-br from-primary to-accent text-white transition hover:brightness-95 active:scale-[0.98]" data-story-id="{$message['story']['story_id']}" title='{__("Tap to view")}' aria-label='{__("Tap to view")}'>
                  {if $message['story']['thumbnail']}
                    <img class="size-full object-cover" src="{$message['story']['thumbnail']}" alt="" loading="lazy">
                  {else}
                    <span class="absolute inset-0 flex items-center justify-center"><span class="icon-[tabler--history-toggle] size-6" aria-hidden="true"></span></span>
                  {/if}
                </button>
              {/if}
            </div>
            <!-- story -->
          {/if}
          {if !is_empty($message['message'])}
            <!-- text -->
            <div class="clearfix {if $message['story']}relative z-10{/if}">
              <span class="text inline-block max-w-full break-words rounded-2xl px-3.5 py-2 text-sm leading-relaxed {if $is_mine}js_chat-color-me rounded-ee-md bg-primary text-primary-content group-[.chat-cont]/msg:rounded-se-md{else}rounded-es-md group-[.chat-cont]/msg:rounded-ss-md border border-base-300/70 bg-base-100 text-base-content{/if}" dir="auto">
                {$message['message']}
              </span>
            </div>
            <!-- text -->
          {/if}
          {if $message['media']['items']}
            <!-- media -->
            {include file='__feeds_message.media.grid.tpl' _items=$message['media']['items']}
            <!-- media -->
          {/if}
          {if !empty($message['gif'])}
            <!-- gif -->
            <div class="chat-message-media">
              <img class="block max-h-60 w-60 max-w-full rounded-2xl bg-base-200 object-cover" src="{$message['gif']}" alt="GIF" loading="lazy">
            </div>
            <!-- gif -->
          {/if}
          {if $message['is_paid'] != '1' && $message['media']['files']}
            <!-- files -->
            <div class="chat-message-media flex w-64 max-w-full flex-col gap-1.5">
              {foreach $message['media']['files'] as $_file}
                {include file='__file_card.tpl' _file=$_file _href="{if $system['mask_file_path_enabled']}{$system['system_url']}/downloads.php?type=message&id={$_file['media_id']}{else}{$system['system_uploads']}/{$_file['source']}{/if}"}
              {/foreach}
            </div>
            <!-- files -->
          {/if}
          {if $message['voice_note']}
            <!-- voice note -->
            <div class="chat-message-media w-72 max-w-full">
              <audio class="js_audio block h-10 w-full" id="audio-{$message['message_id']}" controls preload="metadata">
                <source src="{$system['system_uploads']}/{$message['voice_note']}" type="audio/mpeg">
                <source src="{$system['system_uploads']}/{$message['voice_note']}" type="audio/mp3">
                {__("Your browser does not support HTML5 audio")}
              </audio>
            </div>
            <!-- voice note -->
          {/if}
          {if $message['post']}
            <!-- product -->
            <div class="chat-message-media w-64 max-w-full">
              <a class="chat-product flex w-full items-center gap-3 overflow-hidden rounded-2xl border border-base-300 bg-base-100 p-1.5 transition-colors hover:bg-base-200" href="{$system['system_url']}/posts/{$message['post']['post_id']}">
                <div class="chat-product-image size-14 shrink-0 overflow-hidden rounded-xl bg-base-200">
                  <img class="size-full object-cover" src="{$system['system_uploads']}/{$message['post']['photos'][0]['source']}" alt="" loading="lazy">
                </div>
                <div class="chat-product-info min-w-0 pe-2">
                  <div class="chat-product-title truncate text-sm font-semibold text-base-content" title="{$message['post']['product']['name']}">{$message['post']['product']['name']}</div>
                  <div class="chat-product-price text-xs font-semibold text-primary">{$message['post']['product']['price_formatted']}</div>
                </div>
              </a>
            </div>
            <!-- product -->
          {/if}
          {if $message['is_paid'] == '1'}
            {if $message['can_get_details']}
              {include file='__feeds_message.media.tpl'}
            {elseif $message['needs_payment']}
              {include file='_need_payment_message.tpl' message_id=$message['message_id'] price=$message['message_price'] discounted_price=$message['message_price_discounted'] paid_text=$message['paid_text'] paid_image=$message['paid_image']}
            {/if}
          {/if}
          <!-- message -->
        </div>
        <div class="chat-message-actions flex shrink-0 items-center gap-0.5 opacity-100 transition-opacity md:opacity-0 md:group-hover/msg:opacity-100 md:group-focus-within/msg:opacity-100 md:has-[.dropdown.open]:opacity-100">
          <div class="reactions-wrapper relative {if $message['i_react']}js_unreact-message{/if}" data-reaction="{$message['i_reaction']}">
            <button type="button" class="heroui button button--ghost button--sm button--icon-only size-6 rounded-full text-base-content/60 hover:text-primary" title="{__("React")}" aria-label="{__("React")}">
              {if $message['i_react']}
                <span class="reaction-btn-icon inline-flex size-4">{include file='__reaction_emojis.tpl' _reaction=$message['i_reaction']}</span>
              {else}
                <span class="reaction-btn-icon inline-flex size-4"><span class="icon-[tabler--mood-smile] size-4" aria-hidden="true"></span></span>
              {/if}
            </button>
            {include file='__reactions_container.tpl' _handle="message"}
          </div>
          <button type="button" class="heroui button button--ghost button--sm button--icon-only size-6 rounded-full text-base-content/60 hover:text-primary js_reply-message" data-id="{$message['message_id']}" data-name="{$message['user_fullname']|escape:'html'}" data-snippet="{if $message['message_orginal_decoded']}{$message['message_orginal_decoded']|escape:'html'}{else}{__("Message")}{/if}" title="{__("Reply")}" aria-label="{__("Reply")}">
            <span class="icon-[tabler--arrow-back-up] size-4" aria-hidden="true"></span>
          </button>
          <div class="dropdown relative inline-flex [--offset:4] {if $is_mine}[--placement:top-end]{else}[--placement:top-start]{/if}">
            <button type="button" class="dropdown-toggle heroui button button--ghost button--sm button--icon-only size-6 rounded-full text-base-content/60 hover:text-primary dropdown-open:bg-base-content/10 dropdown-open:text-base-content" aria-haspopup="menu" aria-expanded="false" title="{__("More")}" aria-label="{__("More")}">
              <span class="icon-[tabler--dots] size-4" aria-hidden="true"></span>
            </button>
            <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-40 rounded-box border border-base-content/10 bg-base-100 p-1 shadow-xl" role="menu">
              {if $message['message_orginal_decoded']}
                <button type="button" class="dropdown-close dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-start text-[13px] font-medium text-base-content! js_copy-message" role="menuitem"><span class="icon-[tabler--copy] size-4 shrink-0 text-base-content/55" aria-hidden="true"></span><span>{__("Copy")}</span></button>
              {/if}
              {if $conversation['pinned_message_id'] == $message['message_id']}
                <button type="button" class="dropdown-close dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-start text-[13px] font-medium text-base-content! js_unpin-message" role="menuitem" data-cid="{$conversation['conversation_id']}"><span class="icon-[tabler--pinned-off] size-4 shrink-0 text-base-content/55" aria-hidden="true"></span><span>{__("Unpin")}</span></button>
              {else}
                <button type="button" class="dropdown-close dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-start text-[13px] font-medium text-base-content! js_pin-message" role="menuitem"><span class="icon-[tabler--pin] size-4 shrink-0 text-base-content/55" aria-hidden="true"></span><span>{__("Pin")}</span></button>
              {/if}
              <div class="-mx-1 my-1 border-t border-base-content/10" role="separator"></div>
              {if $is_mine}
                <button type="button" class="dropdown-close dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-start text-[13px] font-medium text-error! hover:bg-error/10! focus-visible:bg-error/10! js_delete-message" role="menuitem"><span class="icon-[tabler--trash] size-4 shrink-0" aria-hidden="true"></span><span>{__("Remove")}</span></button>
              {else}
                <button type="button" class="js_modal dropdown-close dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-start text-[13px] font-medium text-error! hover:bg-error/10! focus-visible:bg-error/10!" role="menuitem" data-url="data/report.php?do=create&handle=message&id={$message['message_id']}"><span class="icon-[tabler--flag] size-4 shrink-0" aria-hidden="true"></span><span>{__("Report")}</span></button>
              {/if}
            </div>
          </div>
        </div>
      </div>

      {if $message['reactions_total_count'] > 0}
        <div class="js_chat-reactions-stats js_modal" data-url="posts/who_reacts.php?message_id={$message['message_id']}">
          <div class="reactions-stats flex cursor-pointer items-center">
            {foreach $message['reactions'] as $reaction_type => $reaction_count}
              {if $reaction_count > 0}
                <div class="reactions-stats-item relative -ms-1 flex rounded-full bg-base-100 p-px ring-1 ring-base-100 first:ms-0" style="z-index: {10 - $reaction_count@iteration};">
                  <div class="inline-emoji no_animation inline-flex size-4">
                    {include file='__reaction_emojis.tpl' _reaction=$reaction_type}
                  </div>
                </div>
              {/if}
            {/foreach}
            <span class="ps-1 text-[11px] text-base-content/60">{$message['reactions_total_count_formatted']}</span>
          </div>
        </div>
      {/if}

      <!-- message time + paid badge -->
      <div class="conversation-meta flex flex-wrap items-center gap-x-2 gap-y-1 px-1 text-[11px] leading-4 text-base-content/45 group-[.chat-more]/msg:hidden group-[.chat-more]/msg:has-[.seen,.chat-paid-badge]:flex {if $is_mine}justify-end{/if}">
        <div class="time js_moment group-[.chat-more]/msg:hidden" data-time="{$message['time']}">{$message['time']}</div>
        {if $message['sender_fullname']}
          <span class="truncate" title="{__("Replied by")} {$message['sender_fullname']}">{__("Replied by")} {$message['sender_fullname']}</span>
        {/if}
        {if $message['is_paid'] == '1' && $message['can_get_details']}
          <span class="chat-paid-badge badge badge-soft badge-warning h-5 gap-1 rounded-full px-1.5 text-[10px] font-semibold">
            <span class="icon-[tabler--coin] size-3" aria-hidden="true"></span>{print_money($message['message_price'])}
          </span>
        {/if}
        {if $conversation['last_seen_message_id'] == $message['message_id']}
          <span class="seen inline-flex items-center gap-1 text-primary">
            <span class="icon-[tabler--checks] size-3.5" aria-hidden="true"></span>{__("Seen by")} <span class="js_seen-name-list">{$conversation['seen_name_list']}</span>
          </span>
        {/if}
      </div>
      <!-- message time + paid badge -->

      {if $system['chat_translation_enabled'] && !is_empty($message['message'])}
        <!-- message translation -->
        <div class="translate cursor-pointer px-1 text-[11px] font-medium text-primary hover:underline">
          {__("Tap to translate")}
        </div>
        <!-- message translation -->
      {/if}
    </div>
  </div>
</li>
