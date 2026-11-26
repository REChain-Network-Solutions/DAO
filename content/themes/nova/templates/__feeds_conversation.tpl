<li class="feeds-item group/thread {if !$conversation['seen']}unread{/if}{if $_active_cid && $_active_cid == $conversation['conversation_id']} is-active{/if}" data-last-message="{$conversation['last_message_id']}">
  {if $conversation['as_page']}
  <a class="data-container flex items-center gap-3 rounded-2xl px-3 py-2.5 text-base-content! transition-colors hover:bg-base-200/70 group-[.is-active]/thread:bg-primary/8 group-[.is-active]/thread:hover:bg-primary/8" data-cid="{$conversation['conversation_id']}" data-name="{$conversation['name']}" data-name-list="{$conversation['name_list']}" href="{$system['system_url']}/pages/{$conversation['page_name']}/settings/messages?cid={$conversation['conversation_id']}">
  {else}
  <a class="data-container js_chat-start flex items-center gap-3 rounded-2xl px-3 py-2.5 text-base-content! transition-colors hover:bg-base-200/70 group-[.is-active]/thread:bg-primary/8 group-[.is-active]/thread:hover:bg-primary/8" {if $conversation['user_id']}data-uid="{$conversation['user_id']}" {/if} {if $conversation['page_id']}data-page-id="{$conversation['page_id']}" {/if} data-cid="{$conversation['conversation_id']}" data-name="{$conversation['name']}" data-name-list="{$conversation['name_list']}" data-link="{$conversation['link']}" href="{$system['system_url']}/messages/{$conversation['conversation_id']}" {if $conversation['picture']}data-picture="{$conversation['picture']}" {/if} {if $conversation['is_chatbox']}data-chat-box="true" {/if} {if $conversation['multiple_recipients']} data-multiple="true" {/if}>
  {/if}
    <span class="data-avatar relative flex size-12 shrink-0 overflow-hidden rounded-full bg-base-200">
      {if $conversation['picture']}
        <img class="size-full object-cover" src="{$conversation['picture']}" alt="{$conversation['name']}">
      {else}
        <span class="left-avatar h-full w-1/2 bg-cover bg-center" style="background-image: url('{$conversation['picture_left']}')"></span>
        <span class="right-avatar h-full w-1/2 border-s-2 border-base-100 bg-cover bg-center" style="background-image: url('{$conversation['picture_right']}')"></span>
      {/if}
    </span>
    <span class="data-content min-w-0 grow text-sm">
      <span class="flex items-center gap-2">
        <span class="name min-w-0 grow truncate font-semibold group-[.unread]/thread:font-bold" title="{$conversation['name']}">{$conversation['name']}</span>
        {if $conversation['search_message'] || $conversation['last_message']}
          <span class="time js_moment shrink-0 text-[11px] text-base-content/45 group-[.unread]/thread:font-semibold group-[.unread]/thread:text-primary" data-time="{if $conversation['search_message']}{$conversation['search_message']['time']}{else}{$conversation['last_message']['time']}{/if}">{if $conversation['search_message']}{$conversation['search_message']['time']}{else}{$conversation['last_message']['time']}{/if}</span>
        {/if}
      </span>
      <span class="flex items-center gap-2">
        {if $conversation['search_message']}
          <span class="text mt-0.5 flex min-w-0 grow items-center gap-1 text-[13px] text-base-content/60">
            <span class="icon-[tabler--search] size-3.5 shrink-0 text-primary" aria-hidden="true"></span>
            <span class="truncate" title="{$conversation['search_message']['message_orginal']}">{$conversation['search_message']['message_orginal']}</span>
          </span>
        {else}
          <span class="text mt-0.5 block min-w-0 grow truncate text-[13px] text-base-content/60 group-[.unread]/thread:font-medium group-[.unread]/thread:text-base-content" title="{if $conversation['last_message']['image'] != ''} {__("Photo")} {elseif $conversation['last_message']['video'] != ''} {__("Video")} {elseif $conversation['last_message']['media']['files_count'] > 0} {if $conversation['last_message']['media']['files_count'] > 1}{$conversation['last_message']['media']['files_count']} {__("Files")}{else}{__("File")}{/if} {elseif $conversation['last_message']['voice_note'] != ''} {__("Voice Message")} {elseif !empty($conversation['last_message']['gif'])} GIF {elseif $conversation['last_message']['post']} {__("Product")} {elseif $conversation['last_message']['call']} {if $conversation['last_message']['call']['status'] == 'missed' && $conversation['last_message']['user_id'] != $user->_data['user_id']}{if $conversation['last_message']['call']['is_video']}{__("Missed video call")}{else}{__("Missed audio call")}{/if}{elseif $conversation['last_message']['call']['is_video']}{__("Video call")}{else}{__("Audio call")}{/if} {elseif $conversation['last_message']['message'] != ''} {$conversation['last_message']['message_orginal']} {/if}">
            {if ($conversation['last_message']['media']['photos_count'] > 0 || $conversation['last_message']['media']['videos_count'] > 0) && $conversation['last_message']['media']['files_count'] > 0}
              <span class="icon-[tabler--paperclip] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>{$conversation['last_message']['media']['photos_count'] + $conversation['last_message']['media']['videos_count'] + $conversation['last_message']['media']['files_count']} {__("Media")}
            {elseif $conversation['last_message']['media']['photos_count'] > 0 && $conversation['last_message']['media']['videos_count'] > 0}
              <span class="icon-[tabler--photo-video] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>{$conversation['last_message']['media']['photos_count'] + $conversation['last_message']['media']['videos_count']} {__("Media")}
            {elseif $conversation['last_message']['media']['photos_count'] > 1}
              <span class="icon-[tabler--photo] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>{$conversation['last_message']['media']['photos_count']} {__("Photos")}
            {elseif $conversation['last_message']['media']['videos_count'] > 1}
              <span class="icon-[tabler--video] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>{$conversation['last_message']['media']['videos_count']} {__("Videos")}
            {elseif $conversation['last_message']['media']['files_count'] > 1}
              <span class="icon-[tabler--paperclip] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>{$conversation['last_message']['media']['files_count']} {__("Files")}
            {elseif $conversation['last_message']['image'] != ''}
              <span class="icon-[tabler--photo] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>{__("Photo")}
            {elseif $conversation['last_message']['video'] != ''}
              <span class="icon-[tabler--video] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>{__("Video")}
            {elseif $conversation['last_message']['media']['files_count'] > 0}
              <span class="icon-[tabler--paperclip] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>{__("File")}
            {elseif $conversation['last_message']['voice_note'] != ''}
              <span class="icon-[tabler--microphone] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>{__("Voice Message")}
            {elseif !empty($conversation['last_message']['gif'])}
              <span class="icon-[tabler--gif] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>GIF
            {elseif $conversation['last_message']['post']}
              <span class="icon-[tabler--shopping-cart] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>{__("Product")}
            {elseif $conversation['last_message']['call']}
              {if $conversation['last_message']['call']['status'] == 'missed' && $conversation['last_message']['user_id'] != $user->_data['user_id']}
                <span class="text-error"><span class="icon-[tabler--phone-x] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>{if $conversation['last_message']['call']['is_video']}{__("Missed video call")}{else}{__("Missed audio call")}{/if}</span>
              {elseif $conversation['last_message']['call']['is_video']}
                <span class="icon-[tabler--video] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>{__("Video call")}
              {else}
                <span class="icon-[tabler--phone] me-1 inline-block size-3.5 align-text-bottom" aria-hidden="true"></span>{__("Audio call")}
              {/if}
            {elseif $conversation['last_message']['message'] != ''}
              {$conversation['last_message']['message_orginal']}
            {/if}
          </span>
        {/if}
        <span class="hidden size-2.5 shrink-0 rounded-full bg-primary group-[.unread]/thread:block" aria-hidden="true"></span>
      </span>
    </span>
  </a>
</li>
