<!-- reel -->
<section class="reel-container js_reel group/reel relative flex h-full snap-start snap-always items-center justify-center lg:gap-4" data-id="{$post['post_id']}" data-reel-id="{$post['reel']['reel_id']}" data-source="{$system['system_uploads']}/{$post['reel']['source']}" {if $post['reel']['source_240p']}data-source-240="{$system['system_uploads']}/{$post['reel']['source_240p']}" {/if}{if $post['reel']['source_360p']}data-source-360="{$system['system_uploads']}/{$post['reel']['source_360p']}" {/if}{if $post['reel']['source_480p']}data-source-480="{$system['system_uploads']}/{$post['reel']['source_480p']}" {/if}{if $post['reel']['source_720p']}data-source-720="{$system['system_uploads']}/{$post['reel']['source_720p']}" {/if}{if $post['reel']['source_1080p']}data-source-1080="{$system['system_uploads']}/{$post['reel']['source_1080p']}" {/if}>

  <!-- video -->
  <div class="js_reel-frame absolute inset-0 overflow-hidden bg-black lg:relative lg:inset-auto lg:aspect-[9/16] lg:h-[calc(100%-2rem)] lg:max-w-[calc(100%-4.5rem)] lg:rounded-box">
    <div class="js_reel-slot pointer-events-none absolute inset-0"></div>
    {if $post['reel']['thumbnail']}
      <img class="pointer-events-none absolute inset-0 size-full object-contain transition-opacity duration-200 group-data-[playing=true]/reel:opacity-0" src="{$system['system_uploads']}/{$post['reel']['thumbnail']}" alt="" {if $_iteration != 1}loading="lazy" {/if}>
    {/if}
    <div class="js_reel-surface absolute inset-0 z-10 cursor-pointer touch-pan-y select-none [-webkit-touch-callout:none]"></div>

    <!-- indicators -->
    <div class="pointer-events-none absolute inset-0 z-10 m-auto hidden size-16 items-center justify-center rounded-full bg-black/45 group-data-[paused=true]/reel:flex">
      <i class="icon-[tabler--player-play-filled] size-8" aria-hidden="true"></i>
    </div>
    <div class="pointer-events-none absolute inset-x-0 top-[calc(env(safe-area-inset-top)+4rem)] z-10 hidden justify-center group-data-[fast=true]/reel:flex lg:top-4">
      <span class="flex items-center gap-1.5 rounded-full bg-black/60 px-3 py-1.5 text-sm font-semibold"><i class="icon-[tabler--player-track-next-filled] size-4 rtl:rotate-180" aria-hidden="true"></i>2x</span>
    </div>
    <div class="js_reel-heart pointer-events-none absolute inset-0 z-10 m-auto flex size-24 items-center justify-center opacity-0">
      <i class="icon-[tabler--heart-filled] size-24 text-white drop-shadow-lg" aria-hidden="true"></i>
    </div>
    <!-- indicators -->

    <!-- mute -->
    <button type="button" class="js_reels-mute absolute end-3 top-[calc(env(safe-area-inset-top)+3.75rem)] z-20 flex size-10 items-center justify-center rounded-full bg-black/35 text-white transition-colors hover:bg-black/55 lg:start-3 lg:end-auto lg:top-3" aria-label='{__("Mute")}'>
      <i class="icon-[tabler--volume-off] hidden size-5 group-data-[muted=true]/reels:inline-block" aria-hidden="true"></i>
      <i class="icon-[tabler--volume] size-5 group-data-[muted=true]/reels:hidden" aria-hidden="true"></i>
    </button>
    <!-- mute -->

    <!-- details -->
    <div class="pointer-events-none absolute inset-x-0 bottom-0 z-10 h-56 bg-linear-to-t from-black/70 to-transparent"></div>
    <div class="pointer-events-none absolute inset-x-0 bottom-0 z-20 flex flex-col gap-2 ps-4 pe-16 pb-[calc(env(safe-area-inset-bottom)+1rem)] lg:pe-4 lg:pb-4">
      <div class="pointer-events-auto flex max-w-full items-center gap-2.5 self-start">
        {if $post['is_anonymous']}
          <div class="flex size-9 shrink-0 items-center justify-center rounded-full bg-white/20">
            <i class="icon-[tabler--spy] size-5" aria-hidden="true"></i>
          </div>
          <span class="truncate text-sm font-semibold" title='{__("Anonymous")}'>{__("Anonymous")}</span>
        {else}
          <a class="block size-9 shrink-0 rounded-full border border-white/70 bg-cover bg-center" href="{$post['post_author_url']}" style="background-image:url({$post['post_author_picture']});" aria-label="{$post['post_author_name']}"></a>
          <a class="truncate text-sm font-semibold text-white! text-shadow-sm hover:underline" href="{$post['post_author_url']}" title="{$post['post_author_name']}">{$post['post_author_name']}</a>
          {if $post['post_author_verified']}
            {include file='__badge.tpl' _badge="verified" _badge_type=$post['user_type']}
          {/if}
        {/if}
      </div>
      {if $post['text']}
        <div class="js_reel-caption pointer-events-auto text-shadow-sm has-[[aria-expanded=true]]:max-h-[40dvh] has-[[aria-expanded=true]]:overflow-y-auto has-[[aria-expanded=true]]:overscroll-contain [&_.js\_readmore-toggle]:text-white! [&_a]:font-semibold [&_a]:text-white!">
          <div class="post-text js_readmore cursor-pointer text-start text-sm wrap-break-word text-white" data-lines="2" dir="auto" title="{$post['text_plain']}">{$post['text']}</div>
        </div>
      {/if}
    </div>
    <!-- details -->

    <!-- progress -->
    <div class="pointer-events-none absolute inset-x-0 bottom-0 z-20 h-0.5 bg-white/25">
      <div class="js_reel-progress h-full w-0 bg-white"></div>
    </div>
    <!-- progress -->
  </div>
  <!-- video -->

  <!-- actions -->
  <div class="absolute end-2 bottom-[calc(env(safe-area-inset-bottom)+1.25rem)] z-20 flex flex-col items-center gap-3 text-center text-xs font-medium text-white lg:static lg:mb-4 lg:self-end">

    <!-- reactions -->
    <div class="flex flex-col items-center gap-0.5">
      {if $user->_logged_in}
        <div class="action-btn unselectable reactions-wrapper cursor-pointer {if $post['i_react']}js_unreact-post{/if}" data-reaction="{$post['i_reaction']}">
          <!-- reaction-btn -->
          <div class="reaction-btn flex size-10 items-center justify-center rounded-full bg-black/35 transition-colors hover:bg-black/55 lg:bg-white/10 lg:hover:bg-white/20">
            {if !$post['i_react']}
              <div class="reaction-btn-icon inline-flex">
                <span class="icon-[tabler--mood-smile] size-5" aria-hidden="true"></span>
              </div>
            {else}
              <div class="reaction-btn-icon inline-flex">
                <div class="inline-emoji no_animation inline-flex size-6">
                  {include file='__reaction_emojis.tpl' _reaction=$post['i_reaction']}
                </div>
              </div>
            {/if}
          </div>
          <!-- reaction-btn -->

          {include file='__reactions_container.tpl' _handle="post"}
        </div>
        <span class="js_modal js_reel-reactions-count cursor-pointer text-shadow-sm" data-url="posts/who_reacts.php?post_id={$post['post_id']}">{$post['reactions_total_count_formatted']}</span>
      {else}
        <button type="button" class="js_login flex size-10 items-center justify-center rounded-full bg-black/35 transition-colors hover:bg-black/55 lg:bg-white/10 lg:hover:bg-white/20" aria-label='{__("React")}'>
          <i class="icon-[tabler--mood-smile] size-5" aria-hidden="true"></i>
        </button>
        <span class="text-shadow-sm">{$post['reactions_total_count_formatted']}</span>
      {/if}
    </div>
    <!-- reactions -->

    <!-- comments -->
    <div class="flex flex-col items-center gap-0.5">
      <button type="button" class="js_reel-comments flex size-10 items-center justify-center rounded-full bg-black/35 transition-colors hover:bg-black/55 lg:bg-white/10 lg:hover:bg-white/20" aria-label='{__("Comments")}'>
        <i class="icon-[tabler--message-circle] size-5" aria-hidden="true"></i>
      </button>
      <span class="js_reel-comments-count text-shadow-sm">{$post['comments_formatted']}</span>
    </div>
    <!-- comments -->

    <!-- share -->
    {if $post['privacy'] == "public" || ($post['in_group'] && $post['group_privacy'] == "public") || ($post['in_event'] && $post['event_privacy'] == "public")}
      <div class="flex flex-col items-center gap-0.5">
        {if $user->_logged_in}
          <button type="button" class="js_modal flex size-10 items-center justify-center rounded-full bg-black/35 transition-colors hover:bg-black/55 lg:bg-white/10 lg:hover:bg-white/20" data-url="posts/share.php?do=create&post_id={$post['post_id']}" aria-label='{__("Share")}'>
            <i class="icon-[tabler--share-3] size-5" aria-hidden="true"></i>
          </button>
          <span class="js_modal cursor-pointer text-shadow-sm" data-url="posts/who_shares.php?post_id={$post['post_id']}">{$post['shares_formatted']}</span>
        {else}
          <button type="button" class="js_login flex size-10 items-center justify-center rounded-full bg-black/35 transition-colors hover:bg-black/55 lg:bg-white/10 lg:hover:bg-white/20" aria-label='{__("Share")}'>
            <i class="icon-[tabler--share-3] size-5" aria-hidden="true"></i>
          </button>
          <span class="text-shadow-sm">{$post['shares_formatted']}</span>
        {/if}
      </div>
    {/if}
    <!-- share -->

    {if $user->_logged_in}
      <!-- save -->
      <button type="button" class="{if $post['i_save']}js_unsave-post{else}js_save-post{/if} flex size-10 items-center justify-center rounded-full bg-black/35 transition-colors hover:bg-black/55 lg:bg-white/10 lg:hover:bg-white/20" data-id="{$post['post_id']}">
        <i class="icon-[tabler--bookmark] size-5 in-[.js\_unsave-post]:hidden" aria-hidden="true"></i>
        <i class="icon-[tabler--bookmark-filled] hidden size-5 in-[.js\_unsave-post]:inline-block" aria-hidden="true"></i>
        <span class="sr-only">{if $post['i_save']}{__("Unsave Post")}{else}{__("Save Post")}{/if}</span>
      </button>
      <!-- save -->

      <!-- menu -->
      <div class="post js_reel-menu" data-id="{$post['post_id']}">
        {include file='__feeds_post.menu.tpl' _post=$post _reel=true}
      </div>
      <!-- menu -->
    {/if}

  </div>
  <!-- actions -->

</section>
<!-- reel -->
