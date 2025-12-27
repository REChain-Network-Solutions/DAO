<li class="feeds-item {if !$conversation['seen']}unread{/if}" data-last-message="{$conversation['last_message_id']}">
  <a class="data-container js_chat-start" {if $conversation['user_id']}data-uid="{$conversation['user_id']}" {/if} data-cid="{$conversation['conversation_id']}" data-name="{$conversation['name']}" data-name-list="{$conversation['name_list']}" data-link="{$conversation['link']}" href="{$system['system_url']}/messages/{$conversation['conversation_id']}" {if $conversation['picture']}data-picture="{$conversation['picture']}" {/if} {if $conversation['node_id']}data-chat-box="true" {/if} {if $conversation['multiple_recipients']} data-multiple="true" {/if}>
    <div class="data-avatar">
      {if $conversation['picture']}
        <img src="{$conversation['picture']}" alt="{$conversation['name']}">
      {else}
        <div class="left-avatar" style="background-image: url('{$conversation['picture_left']}')"></div>
        <div class="right-avatar" style="background-image: url('{$conversation['picture_right']}')"></div>
      {/if}
    </div>
    <div class="data-content">
      {if $conversation['last_message']['image'] != ''}
        <div class="float-end">
          <img class="data-img" src="{$system['system_uploads']}/{$conversation['last_message']['image']}" alt="">
        </div>
      {/if}
      <div><span class="name">{$conversation['name']}</span></div>
      <div class="text">
        {if $conversation['last_message']['image'] != ''}
          <i class="fa fa-file-image"></i> {__("Photo")}
        {elseif $conversation['last_message']['video'] != ''}
          <i class="fa fa-file-video"></i> {__("Video")}
        {elseif $conversation['last_message']['voice_note'] != ''}
          <i class="fas fa-microphone"></i> {__("Voice Message")}
        {elseif $conversation['last_message']['post']}
          <i class="fas fa-shopping-cart"></i> {__("Product")}
        {elseif $conversation['last_message']['message'] != ''}
          {$conversation['last_message']['message_orginal']}
        {/if}
      </div>
      <div class="time js_moment" data-time="{$conversation['last_message']['time']}">{$conversation['last_message']['time']}</div>
    </div>
  </a>
</li>