{if !is_empty($message['message'])}
  <!-- text -->
  <span class="inline-block max-w-full rounded-2xl px-3.5 py-2 text-sm leading-relaxed break-words {if $_is_reporter}rounded-ee-md bg-primary text-primary-content{else}rounded-es-md border border-base-300/70 bg-base-100 text-base-content{/if}" dir="auto">{$message['message']}</span>
  <!-- text -->
{/if}
{if $message['media']['items']}
  <!-- media -->
  {assign var="_photos" value=[]}
  {foreach $message['media']['items'] as $_item}
    {if $_item['media_type'] == 'video'}
      <div class="w-72 max-w-full overflow-hidden rounded-2xl bg-black [&_.plyr]:rounded-2xl">
        <video class="video-wrapper js_video-plyr block w-full" controls preload="metadata">
          <source src="{$system['system_uploads']}/{$_item['source']}" type="video/mp4">
        </video>
      </div>
    {else}
      {append var="_photos" value=$_item}
    {/if}
  {/foreach}
  {if $_photos}
    {assign var="_count" value=$_photos|count}
    <div class="grid max-w-full gap-0.5 overflow-hidden rounded-2xl border border-base-300/70 bg-base-100 {if $_count == 1}w-60 grid-cols-1{elseif $_count == 2 || $_count == 4}w-60 grid-cols-2{else}w-72 grid-cols-3{/if}">
      {foreach $_photos as $_photo}
        <a class="block overflow-hidden bg-base-200 {if $_count > 1}aspect-square{/if}" target="_blank" href="{$system['system_uploads']}/{$_photo['source']}">
          <img class="block w-full object-cover {if $_count == 1}max-h-60{else}size-full{/if}" src="{$system['system_uploads']}/{$_photo['source']}" alt="" loading="lazy">
        </a>
      {/foreach}
    </div>
  {/if}
  <!-- media -->
{/if}
{if $message['media']['files']}
  <!-- files -->
  <div class="flex w-64 max-w-full flex-col gap-1.5">
    {foreach $message['media']['files'] as $_file}
      {include file='__file_card.tpl' _file=$_file _href="{if $system['mask_file_path_enabled']}{$system['system_url']}/downloads.php?type=message&id={$_file['media_id']}{else}{$system['system_uploads']}/{$_file['source']}{/if}"}
    {/foreach}
  </div>
  <!-- files -->
{/if}
{if $message['voice_note']}
  <!-- voice note -->
  <audio class="block h-10 w-72 max-w-full" controls preload="metadata">
    <source src="{$system['system_uploads']}/{$message['voice_note']}" type="audio/mpeg">
  </audio>
  <!-- voice note -->
{elseif $message['media']['audio']}
  <!-- audio -->
  <audio class="block h-10 w-72 max-w-full" controls preload="metadata">
    <source src="{$system['system_uploads']}/{$message['media']['audio']['source']}" type="audio/mpeg">
  </audio>
  <!-- audio -->
{/if}
{if $message['post']}
  <!-- product -->
  <a class="flex w-64 max-w-full items-center gap-3 rounded-2xl border border-base-300 bg-base-100 p-1.5 transition-colors hover:bg-base-200" target="_blank" href="{$system['system_url']}/posts/{$message['post']['post_id']}">
    {if $message['post']['photos'][0]['source']}
      <img class="size-12 shrink-0 rounded-xl object-cover" src="{$system['system_uploads']}/{$message['post']['photos'][0]['source']}" alt="" loading="lazy">
    {/if}
    <span class="min-w-0 pe-2">
      <span class="block truncate text-sm font-semibold" title="{if $message['post']['product']['name']}{$message['post']['product']['name']}{else}{__("Post")} #{$message['post']['post_id']}{/if}">{if $message['post']['product']['name']}{$message['post']['product']['name']}{else}{__("Post")} #{$message['post']['post_id']}{/if}</span>
      {if $message['post']['product']['price_formatted']}
        <span class="block text-xs font-semibold text-primary">{$message['post']['product']['price_formatted']}</span>
      {/if}
    </span>
  </a>
  <!-- product -->
{/if}
