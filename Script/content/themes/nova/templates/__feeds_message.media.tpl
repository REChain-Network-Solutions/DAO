{if $message['media']['photos']}
  <!-- photos -->
  <div class="chat-message-media flex w-64 max-w-full flex-col gap-1">
    {foreach $message['media']['photos'] as $photo}
      <span class="js_lightbox-nodata block cursor-pointer overflow-hidden rounded-2xl border border-base-300/70 bg-base-200" data-image="{$system['system_uploads']}/{$photo['source']}">
        <img class="block max-h-80 w-full object-cover" src="{$system['system_uploads']}/{$photo['source']}" alt="" loading="lazy">
      </span>
    {/foreach}
  </div>
  <!-- photos -->
{/if}
{if $message['media']['video']}
  <!-- video -->
  <div class="chat-message-media w-80 max-w-full overflow-hidden rounded-2xl bg-black [&_.plyr]:rounded-2xl">
    {assign var="video" value=$message['media']['video']}
    <video class="video-wrapper js_video-plyr block w-full" controls preload="metadata">
      <source src="{$system['system_uploads']}/{$video['source']}" type="video/mp4">
    </video>
  </div>
  <!-- video -->
{/if}
{if $message['media']['audio']}
  <!-- audio -->
  <div class="chat-message-media w-72 max-w-full">
    <audio class="js_audio block h-10 w-full" id="audio-{$message['message_id']}" controls preload="metadata">
      <source src="{$system['system_uploads']}/{$message['media']['audio']['source']}" type="audio/mpeg">
      <source src="{$system['system_uploads']}/{$message['media']['audio']['source']}" type="audio/mp3">
      {__("Your browser does not support HTML5 audio")}
    </audio>
  </div>
  <!-- audio -->
{/if}
{if $message['media']['file']}
  <!-- file -->
  <div class="chat-message-media w-64 max-w-full">
    {include file='__file_card.tpl' _file=$message['media']['file'] _href="{if $system['mask_file_path_enabled']}{$system['system_url']}/downloads.php?type=message&id={$message['media']['file']['media_id']}{else}{$system['system_uploads']}/{$message['media']['file']['source']}{/if}"}
  </div>
  <!-- file -->
{/if}
