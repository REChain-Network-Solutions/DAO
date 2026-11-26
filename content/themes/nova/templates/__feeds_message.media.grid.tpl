{assign var="_count" value=$_items|count}
<div class="chat-message-media js_chat-media grid w-72 max-w-full gap-0.5 overflow-hidden rounded-2xl border border-base-300/70 bg-base-100 {if $_count == 1}grid-cols-1{else}grid-cols-2{/if}">
  {foreach $_items as $_item}
    {assign var="_index" value=$_item@index}
    {assign var="_source" value="{$system['system_uploads']}/{$_item['source']}"}
    {if $_count == 1}
      {assign var="_tile" value=""}
    {elseif $_count == 3 && $_index == 0}
      {assign var="_tile" value="row-span-2"}
    {else}
      {assign var="_tile" value="aspect-square"}
    {/if}
    {if $_count > 4 && $_index > 3}
      {assign var="_tile" value="$_tile hidden js_chat-media-hidden"}
    {/if}
    {if $_item['media_type'] == 'video'}
      <span class="js_lightbox-nodata relative block cursor-pointer overflow-hidden bg-black {$_tile}" data-video="{$_source}"{if $_item['media_id']} data-download="{$system['system_url']}/downloads.php?type=message_media&id={$_item['media_id']}"{/if} data-gallery="true">
        <video class="block w-full {if $_count == 1}max-h-80{else}size-full object-cover{/if}" src="{$_source}#t=0.1" preload="metadata" muted playsinline></video>
        {if $_count > 4 && $_index == 3}
          <span class="js_chat-media-more absolute inset-0 z-10 flex items-center justify-center bg-black/55 text-2xl font-semibold text-white" role="button" aria-label='{__("Show all")}'>+{$_count - 4}</span>
        {/if}
        <span class="js_chat-media-play pointer-events-none absolute inset-0 flex items-center justify-center">
          <span class="flex size-11 items-center justify-center rounded-full bg-black/55 text-white backdrop-blur-sm"><span class="icon-[tabler--player-play-filled] size-5" aria-hidden="true"></span></span>
        </span>
      </span>
    {else}
      <span class="js_lightbox-nodata relative block cursor-pointer overflow-hidden bg-base-200 {$_tile}" data-image="{$_source}"{if $_item['media_id']} data-download="{$system['system_url']}/downloads.php?type=message_media&id={$_item['media_id']}"{/if} data-gallery="true">
        <img class="block w-full {if $_count == 1}max-h-80 object-cover{else}size-full object-cover{/if}" src="{$_source}" alt="" loading="lazy">
        {if $_count > 4 && $_index == 3}
          <span class="js_chat-media-more absolute inset-0 z-10 flex items-center justify-center bg-black/55 text-2xl font-semibold text-white" role="button" aria-label='{__("Show all")}'>+{$_count - 4}</span>
        {/if}
      </span>
    {/if}
  {/foreach}
</div>
