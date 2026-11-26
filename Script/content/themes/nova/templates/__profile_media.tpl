{if $_kind == 'photo'}
  <li class="min-w-0 overflow-hidden bg-base-200{if !$_small} rounded-box{/if}">
    <div class="pg_photo relative">
      <a class="js_lightbox block aspect-square overflow-hidden focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" href="{$system['system_url']}/photos/{$photo['photo_id']}" data-id="{$photo['photo_id']}" data-image="{$system['system_uploads']}/{$photo['source']}" data-context="{$_context}" aria-label='{__("Photo")}'>
        <img class="size-full object-cover{if $photo['blur']} blur-xl{/if}{if $_small} transition-transform duration-300 hover:scale-105{/if}" src="{$system['system_uploads']}/{$photo['source']}" alt="" loading="lazy">
      </a>
      {if !$_small && ($_manage || $photo['manage'])}
        <div class="absolute end-2 top-2 flex gap-1">
          <button class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full bg-base-100 text-base-content js_delete-photo" type="button" data-id="{$photo['photo_id']}" aria-label='{__("Delete")}'>
            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
          </button>
          {if $_can_pin}
            <button type="button" class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full bg-base-100 text-base-content [&.pinned]:bg-primary [&.pinned]:text-primary-content {if $photo['pinned']}js_unpin-photo pinned{else}js_pin-photo{/if}" data-id="{$photo['photo_id']}" aria-label='{__("Pin")}'>
              <span class="icon-[tabler--pin] size-4" aria-hidden="true"></span>
            </button>
          {/if}
        </div>
      {/if}
    </div>
  </li>
{elseif $_kind == 'album'}
  <li class="min-w-0">
    <a class="group relative isolate block pt-3 text-white! focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" href="{$system['system_url']}/{$album['path']}/album/{$album['album_id']}" aria-label="{__($album['title'])}">
      <!-- album stack -->
      <span class="absolute inset-x-[10%] top-0 -z-10 h-6 rounded-t-box bg-base-content/10 transition-transform duration-300 group-hover:-translate-y-1" aria-hidden="true"></span>
      <span class="absolute inset-x-[5%] top-1.5 -z-10 h-6 rounded-t-box bg-base-content/20 transition-transform duration-300 group-hover:-translate-y-0.5" aria-hidden="true"></span>
      <!-- album stack -->

      <!-- album cover -->
      <span class="relative block aspect-square overflow-hidden rounded-box bg-base-200 shadow-sm">
        {if $album['cover']['source']}
          <img class="size-full object-cover transition-transform duration-500 group-hover:scale-105{if $album['cover']['blur']} blur-xl{/if}" src="{$album['cover']['source']}" alt="" loading="lazy">
        {else}
          <span class="flex size-full items-center justify-center text-base-content/40"><span class="icon-[tabler--photo] size-8" aria-hidden="true"></span></span>
        {/if}
        <span class="pointer-events-none absolute inset-0 bg-linear-to-t from-black/75 via-black/10 to-transparent" aria-hidden="true"></span>
        <span class="absolute start-3 top-3 inline-flex h-7 items-center gap-1.5 rounded-full bg-black/40 px-2.5 text-xs font-semibold backdrop-blur-sm">
          <span class="icon-[tabler--photo] size-3.5" aria-hidden="true"></span>
          {$album['photos_count']} {__("photos")}
        </span>
        <span class="absolute end-3 top-3 flex size-7 items-center justify-center rounded-full bg-black/40 backdrop-blur-sm">
          {if $album['privacy'] == 'me'}
            <span class="icon-[tabler--lock] size-4" role="img" aria-label='{__("Only Me")}'></span>
          {elseif $album['privacy'] == 'friends'}
            <span class="icon-[tabler--users] size-4" role="img" aria-label='{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}'></span>
          {elseif $album['privacy'] == 'public'}
            <span class="icon-[tabler--world] size-4" role="img" aria-label='{__("Public")}'></span>
          {elseif $album['privacy'] == 'custom'}
            <span class="icon-[tabler--settings] size-4" role="img" aria-label='{__("Custom People")}'></span>
          {/if}
        </span>
        <span class="absolute inset-x-0 bottom-0 block truncate p-3 text-sm font-semibold" title="{__($album['title'])}">{__($album['title'])}</span>
      </span>
      <!-- album cover -->
    </a>
  </li>
{elseif $_kind == 'video'}
  <li class="group min-w-0">
    {capture assign="_video_src"}{if $video['source_240p']}{$video['source_240p']}{elseif $video['source_360p']}{$video['source_360p']}{elseif $video['source_480p']}{$video['source_480p']}{elseif $video['source_720p']}{$video['source_720p']}{elseif $video['source_1080p']}{$video['source_1080p']}{elseif $video['source_1440p']}{$video['source_1440p']}{elseif $video['source_2160p']}{$video['source_2160p']}{else}{$video['source']}{/if}{/capture}
    {if $_is_reel}
      <a class="relative block overflow-hidden rounded-box bg-base-200 aspect-[9/16]" href="{$system['system_url']}/reels/{$video['post_id']}" aria-label='{__("Reel")}'>
        {if $video['thumbnail']}
          <img class="size-full object-cover" src="{$system['system_uploads']}/{$video['thumbnail']}" alt="" loading="lazy">
        {else}
          <video class="pointer-events-none size-full object-cover" src="{$system['system_uploads']}/{$_video_src}#t=0.1" preload="metadata" muted playsinline aria-hidden="true"></video>
        {/if}
        <span class="pointer-events-none absolute inset-0 flex items-center justify-center">
          <span class="flex size-10 items-center justify-center rounded-full bg-black/60 text-white"><span class="icon-[tabler--player-play-filled] size-5" aria-hidden="true"></span></span>
        </span>
      </a>
    {else}
      {$_video_portrait = ($video['width'] && $video['height'] && $video['height'] > $video['width'])}
      <div class="js_lightbox-video relative block aspect-video cursor-pointer overflow-hidden rounded-box bg-base-300" data-id="{$video['post_id']}" role="button" tabindex="0" aria-label='{__("Video")}'>
        {if $video['thumbnail']}
          {if $_video_portrait}
            <img class="pointer-events-none absolute inset-0 size-full scale-110 object-cover opacity-60 blur-2xl" src="{$system['system_uploads']}/{$video['thumbnail']}" alt="" loading="lazy" aria-hidden="true">
          {/if}
          <img class="relative size-full {if $_video_portrait}object-contain{else}object-cover{/if} transition-transform duration-500 group-hover:scale-105" src="{$system['system_uploads']}/{$video['thumbnail']}" alt="" loading="lazy">
        {else}
          {if $_video_portrait}
            <video class="pointer-events-none absolute inset-0 size-full scale-110 object-cover opacity-60 blur-2xl" src="{$system['system_uploads']}/{$_video_src}#t=1" preload="metadata" muted playsinline aria-hidden="true"></video>
          {/if}
          <video class="pointer-events-none relative size-full {if $_video_portrait}object-contain{else}object-cover{/if}" src="{$system['system_uploads']}/{$_video_src}#t=1" preload="metadata" muted playsinline aria-hidden="true"></video>
        {/if}
        <span class="pointer-events-none absolute inset-0 bg-linear-to-t from-black/60 via-transparent to-transparent" aria-hidden="true"></span>
        <span class="pointer-events-none absolute start-1/2 top-1/2 flex size-12 -translate-x-1/2 -translate-y-1/2 scale-90 items-center justify-center rounded-full bg-primary text-primary-content opacity-0 shadow-lg transition duration-300 group-hover:scale-100 group-hover:opacity-100 [@media(hover:none)]:scale-100 [@media(hover:none)]:opacity-100 rtl:translate-x-1/2" aria-hidden="true">
          <span class="icon-[tabler--player-play-filled] size-5"></span>
        </span>
        {if $video['category_name']}
          <a class="absolute start-3 top-3 z-10 max-w-[60%] truncate rounded-full bg-black/50 px-2.5 py-0.5 text-[11px] font-medium text-white! backdrop-blur-sm transition-colors hover:bg-black/70" href="{$system['system_url']}/watch/category/{$video['category_id']}/{$video['category_url']}" title="{__($video['category_name'])}">{__($video['category_name'])}</a>
        {/if}
        <span class="absolute bottom-3 start-3 flex items-center gap-1 rounded-full bg-black/50 px-2 py-0.5 text-[11px] font-medium text-white backdrop-blur-sm">
          <span class="icon-[tabler--eye] size-3.5" aria-hidden="true"></span>
          {$video['views']}
        </span>
        <span class="js_video-duration absolute bottom-3 end-3 hidden rounded-md bg-black/70 px-1.5 py-0.5 font-mono text-[11px] font-semibold text-white tabular-nums" data-src="{$system['system_uploads']}/{$video['source']}" dir="ltr"></span>
      </div>
    {/if}
  </li>
{/if}
