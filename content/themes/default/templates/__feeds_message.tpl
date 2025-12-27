<li>
  <div class="conversation clearfix {if (isset($is_me) && $is_me) || $message['user_id'] == $user->_data['user_id']}right{/if}" id="{$message['message_id']}">
    {if (!isset($is_me) || !$is_me) && $message['user_id'] != $user->_data['user_id']}
      <div class="conversation-user">
        <a href="{$system['system_url']}/{$message['user_name']}">
          <img src="{$message['user_picture']}" alt="">
        </a>
      </div>
    {/if}
    <div class="conversation-body {if $system['chat_translation_enabled']}js_chat-translator{/if}">
      <!-- message -->
      {if !is_empty($message['message'])}
        <!-- text -->
        <div class="clearfix">
          <span class="text {if (isset($is_me) && $is_me) || $message['user_id'] == $user->_data['user_id']}js_chat-color-me{/if}">
            {$message['message']}
          </span>
        </div>
        <!-- text -->
      {/if}
      {if $message['image']}
        <!-- image -->
        <div class="{if $message['message'] != ''}mt5{/if}">
          <span class="text-link js_lightbox-nodata " data-image="{$system['system_uploads']}/{$message['image']}">
            <img class="img-fluid img-wrapper" src="{$system['system_uploads']}/{$message['image']}">
          </span>
        </div>
        <!-- image -->
      {/if}
      {if $message['video']}
        <!-- video -->
        <div class="{if $message['message'] != ''}mt5{/if}">
          <video class="video-wrapper" src="{$system['system_uploads']}/{$message['video']}" controls></video>
        </div>
        <!-- video -->
      {/if}
      {if $message['voice_note']}
        <!-- voice note -->
        <div class="{if $message['message'] != ''}mt5{/if}">
          <audio class="js_audio" id="audio-{$message['message_id']}" controls preload="auto" style="width: 100%; min-width: 120px;">
            <source src="{$system['system_uploads']}/{$message['voice_note']}" type="audio/mpeg">
            <source src="{$system['system_uploads']}/{$message['voice_note']}" type="audio/mp3">
            {__("Your browser does not support HTML5 audio")}
          </audio>
        </div>
        <!-- voice note -->
      {/if}
      {if $message['post']}
        <!-- product -->
        <div>
          <a class="chat-product" href="{$system['system_url']}/posts/{$message['post']['post_id']}">
            <div class="chat-product-image">
              <img src="{$system['system_uploads']}/{$message['post']['photos'][0]['source']}">
            </div>
            <div class="chat-product-info">
              <div class="chat-product-title">{$message['post']['product']['name']}</div>
              <div class="chat-product-price">{$message['post']['product']['price_formatted']}</div>
            </div>
          </a>
        </div>
        <!-- product -->
      {/if}
      <!-- message -->

      <!-- message time -->
      <div class="time js_moment" data-time="{$message['time']}">
        {$message['time']}
      </div>
      <!-- message time -->

      {if $system['chat_translation_enabled']}
        <!-- message translation -->
        <div class="translate">
          {__("Tap to translate")}
        </div>
        <!-- message translation -->
      {/if}

      <!-- seen status -->
      {if $conversation['last_seen_message_id'] == $message['message_id']}
        <div class="seen">
          {__("Seen by")} <span class="js_seen-name-list">{$conversation['seen_name_list']}</span>
        </div>
      {/if}
      <!-- seen status -->
    </div>
  </div>
</li>