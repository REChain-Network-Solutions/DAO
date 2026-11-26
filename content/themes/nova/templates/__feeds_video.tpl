{$_video_title = $post['text']|strip_tags|trim}
{$_video_portrait = ($post['video']['width'] && $post['video']['height'] && $post['video']['height'] > $post['video']['width'])}
{$_video_locked = ($post['needs_payment'] || $post['needs_subscription'] || $post['needs_pro_package'] || $post['needs_age_verification'])}
<li class="group flex min-w-0 flex-col">
  {if !$_video_locked}
    <div class="js_lightbox-video relative block aspect-video cursor-pointer overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-300" data-id="{$post['post_id']}" role="button" tabindex="0" aria-label="{if $_video_title}{$_video_title|truncate:90}{else}{__("Video")}{/if}">
  {else}
    <a class="relative block aspect-video overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-300" href="{$system['system_url']}/posts/{$post['post_id']}" aria-label="{if $_video_title}{$_video_title|truncate:90}{else}{__("Video")}{/if}">
  {/if}
    {if $_video_locked}
      <span class="absolute inset-0 flex flex-col items-center justify-center gap-2 bg-linear-to-br from-base-300 to-base-200 text-base-content/60" aria-hidden="true">
        <span class="icon-[tabler--lock] size-8"></span>
      </span>
    {elseif $post['video']['thumbnail']}
      {if $_video_portrait}
        <img class="pointer-events-none absolute inset-0 size-full scale-110 object-cover opacity-60 blur-2xl" src="{$system['system_uploads']}/{$post['video']['thumbnail']}" alt="" loading="lazy" aria-hidden="true">
      {/if}
      <img class="relative size-full {if $_video_portrait}object-contain{else}object-cover{/if} transition-transform duration-500 group-hover:scale-105" src="{$system['system_uploads']}/{$post['video']['thumbnail']}" alt="" loading="lazy">
    {else}
      {if $_video_portrait}
        <video class="pointer-events-none absolute inset-0 size-full scale-110 object-cover opacity-60 blur-2xl" src="{$system['system_uploads']}/{$post['video']['source']}#t=1" preload="metadata" muted playsinline aria-hidden="true"></video>
      {/if}
      <video class="pointer-events-none relative size-full {if $_video_portrait}object-contain{else}object-cover{/if}" src="{$system['system_uploads']}/{$post['video']['source']}#t=1" preload="metadata" muted playsinline aria-hidden="true"></video>
    {/if}
    <span class="pointer-events-none absolute inset-0 bg-linear-to-t from-black/60 via-transparent to-transparent" aria-hidden="true"></span>
    {if !$_video_locked}
      <span class="pointer-events-none absolute start-1/2 top-1/2 flex size-12 -translate-x-1/2 -translate-y-1/2 scale-90 items-center justify-center rounded-full bg-primary text-primary-content opacity-0 shadow-lg transition duration-300 group-hover:scale-100 group-hover:opacity-100 [@media(hover:none)]:scale-100 [@media(hover:none)]:opacity-100 rtl:translate-x-1/2" aria-hidden="true">
        <span class="icon-[tabler--player-play-filled] size-5"></span>
      </span>
    {/if}
    {if $post['video']['category_name']}
      <a class="absolute start-3 top-3 z-10 rounded-full bg-black/50 px-2.5 py-0.5 text-[11px] font-medium text-white! backdrop-blur-sm transition-colors hover:bg-black/70" href="{$system['system_url']}/watch/category/{$post['video']['category_id']}/{$post['video']['category_url']}">{__($post['video']['category_name'])}</a>
    {/if}
    <span class="absolute bottom-3 start-3 flex items-center gap-1 rounded-full bg-black/50 px-2 py-0.5 text-[11px] font-medium text-white backdrop-blur-sm">
      <span class="icon-[tabler--eye] size-3.5" aria-hidden="true"></span>
      {$post['video']['views']}
    </span>
    {if !$_video_locked}
      <span class="js_video-duration absolute bottom-3 end-3 hidden rounded-md bg-black/70 px-1.5 py-0.5 font-mono text-[11px] font-semibold text-white tabular-nums" data-src="{$system['system_uploads']}/{$post['video']['source']}" {if !$post['video']['width'] && $post['manage_post']}data-video-id="{$post['video']['video_id']}" {/if}dir="ltr"></span>
    {/if}
  {if !$_video_locked}</div>{else}</a>{/if}

  <div class="mt-3 flex min-w-0 gap-3">
    <a class="shrink-0" href="{$post['post_author_url']}">
      <img class="size-9 rounded-full object-cover" src="{$post['post_author_picture']}" alt="" loading="lazy">
    </a>
    <div class="min-w-0 grow">
      <a class="line-clamp-2 text-sm font-semibold leading-snug text-base-content! hover:text-primary!" href="{$system['system_url']}/posts/{$post['post_id']}" title="{if $_video_title}{$_video_title}{else}{__("Video")}{/if}">
        {if $_video_title}{$_video_title|truncate:120}{else}{__("Video")}{/if}
      </a>
      <div class="mt-0.5 flex min-w-0 items-center gap-1 text-xs text-base-content/60">
        <span class="js_user-popover min-w-0 truncate" data-type="{$post['user_type']}" data-uid="{$post['user_id']}" title="{$post['post_author_name']}">
          <a class="text-base-content/60! hover:text-primary!" href="{$post['post_author_url']}">{$post['post_author_name']}</a>
        </span>
        <span aria-hidden="true">·</span>
        <a class="shrink-0 text-base-content/60! hover:text-primary!" href="{$system['system_url']}/posts/{$post['post_id']}"><span class="js_moment" data-time="{$post['time']}">{$post['time']}</span></a>
      </div>
    </div>
  </div>
</li>
