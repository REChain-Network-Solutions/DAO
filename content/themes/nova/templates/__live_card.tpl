{$_live_title = $post['live']['live_title']|default:''}
{$_live_locked = ($post['needs_payment'] || $post['needs_subscription'] || $post['needs_pro_package'] || $post['needs_age_verification'] || !$post['live'])}
{$_live_now = ($post['live'] && !$post['live']['live_ended'])}
{$_live_lightbox = ($_live_now && !$_live_locked && $user->_logged_in)}
<li class="group flex min-w-0 flex-col">
  {if $_live_lightbox}
    <div class="js_lightbox-live relative block aspect-video cursor-pointer overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-neutral-950" data-id="{$post['post_id']}" role="button" tabindex="0" aria-label="{if $_live_title}{$_live_title}{else}{__("Live")}{/if}">
  {else}
    <a class="relative block aspect-video overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-neutral-950" href="{$system['system_url']}/posts/{$post['post_id']}" aria-label="{if $_live_title}{$_live_title}{else}{__("Live")}{/if}">
  {/if}
    {if $_live_locked}
      <span class="absolute inset-0 flex flex-col items-center justify-center gap-2 bg-linear-to-br from-base-300 to-base-200 text-base-content/60" aria-hidden="true">
        <span class="icon-[tabler--lock] size-8"></span>
      </span>
    {elseif $post['live']['video_thumbnail']}
      <img class="size-full object-cover transition-transform duration-500 group-hover:scale-105{if !$_live_now} grayscale-[40%]{/if}" src="{$system['system_uploads']}/{$post['live']['video_thumbnail']}" alt="" loading="lazy">
    {else}
      <img class="size-full scale-125 object-cover opacity-50 blur-3xl" src="{$post['post_author_picture']}" alt="" loading="lazy" aria-hidden="true">
    {/if}
    <span class="pointer-events-none absolute inset-0 bg-linear-to-t from-black/60 via-transparent to-black/30" aria-hidden="true"></span>
    {if $post['live']['category_name']}
      <span class="absolute bottom-3 start-3 rounded-full bg-black/50 px-2.5 py-0.5 text-[11px] font-medium text-white backdrop-blur-sm">{__($post['live']['category_name'])}</span>
    {/if}
    {if $_live_now}
      {if $post['live']}
        <span class="absolute end-3 bottom-3 inline-flex items-center gap-1 rounded-full bg-black/50 px-2.5 py-0.5 text-[11px] font-medium text-white backdrop-blur-sm">
          <span class="icon-[tabler--eye] size-3.5" aria-hidden="true"></span>
          {$post['live']['live_viewers']} {__("Watching")}
        </span>
      {/if}
      <span class="pointer-events-none absolute start-1/2 {if $_live_locked}top-3/4{else}top-1/2{/if} grid -translate-x-1/2 -translate-y-1/2 place-items-center transition duration-300 group-hover:scale-105 rtl:translate-x-1/2">
        <span class="absolute inset-0 animate-ping rounded-full bg-white/30 [animation-duration:2s]" aria-hidden="true"></span>
        <span class="relative inline-flex items-center gap-1.5 rounded-full bg-white px-4 py-2 text-xs font-semibold whitespace-nowrap text-neutral-900 shadow-lg">
          <span class="icon-[tabler--broadcast] size-4 text-error" aria-hidden="true"></span>
          {__("Join Live")}
        </span>
      </span>
    {else}
      <span class="pointer-events-none absolute start-1/2 {if $_live_locked}top-3/4{else}top-1/2{/if} inline-flex -translate-x-1/2 -translate-y-1/2 items-center gap-1.5 rounded-full bg-black/60 px-4 py-2 text-xs font-semibold whitespace-nowrap text-white/80 ring-1 ring-white/15 backdrop-blur-sm rtl:translate-x-1/2">
        <span class="icon-[tabler--broadcast-off] size-4" aria-hidden="true"></span>
        {__("Live Ended")}
      </span>
    {/if}
  {if $_live_lightbox}
    </div>
  {else}
    </a>
  {/if}

  <div class="mt-3 flex min-w-0 gap-3">
    <a class="shrink-0" href="{$post['post_author_url']}">
      <img class="size-9 rounded-full object-cover" src="{$post['post_author_picture']}" alt="" loading="lazy">
    </a>
    <div class="min-w-0 grow">
      <a class="line-clamp-2 text-sm font-semibold leading-snug text-base-content! hover:text-primary!" href="{$system['system_url']}/posts/{$post['post_id']}" title="{if $_live_title}{$_live_title}{else}{__("Live")}{/if}">
        {if $_live_title}{$_live_title}{else}{__("Live")}{/if}
      </a>
      <div class="mt-0.5 flex min-w-0 items-center gap-1 text-xs text-base-content/60">
        <span class="js_user-popover min-w-0 truncate" data-type="{$post['user_type']}" data-uid="{$post['user_id']}" title="{$post['post_author_name']}">
          <a class="text-base-content/60! hover:text-primary!" href="{$post['post_author_url']}">{$post['post_author_name']}</a>
        </span>
        <span aria-hidden="true">·</span>
        <span class="js_moment shrink-0" data-time="{$post['time']}">{$post['time']}</span>
      </div>
    </div>
  </div>
</li>
