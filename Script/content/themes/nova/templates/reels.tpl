{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div id="reels" class="js_reels group/reels relative flex h-dvh w-full overflow-hidden bg-black text-white" data-tab="{$tab}" data-cursor="{$cursor}" data-pinned="{$pinned}" data-muted="true">

  <!-- side menu -->
  <aside class="hidden w-56 shrink-0 flex-col gap-1 p-3 lg:flex">
    <div class="mb-3 flex items-center gap-2">
      <a class="js_reels-back flex size-10 items-center justify-center rounded-full text-white! transition-colors hover:bg-white/10" href="{$system['system_url']}" aria-label='{__("Back")}'>
        <i class="icon-[tabler--arrow-left] size-6 rtl:rotate-180" aria-hidden="true"></i>
      </a>
      <h1 class="text-xl font-bold">{__("Reels")}</h1>
    </div>
    <a class="flex items-center gap-3 rounded-field px-3 py-2.5 text-sm font-semibold text-white! transition-colors hover:bg-white/10 {if $tab == 'for_you'}bg-white/10{/if}" href="{$system['system_url']}/reels">
      <i class="icon-[tabler--star] size-5 shrink-0" aria-hidden="true"></i>
      <span class="truncate" title='{__("For You")}'>{__("For You")}</span>
    </a>
    {if $user->_logged_in}
      <a class="flex items-center gap-3 rounded-field px-3 py-2.5 text-sm font-semibold text-white! transition-colors hover:bg-white/10 {if $tab == 'following'}bg-white/10{/if}" href="{$system['system_url']}/reels?tab=following">
        <i class="icon-[tabler--users] size-5 shrink-0" aria-hidden="true"></i>
        <span class="truncate" title='{__("Following")}'>{__("Following")}</span>
      </a>
    {/if}
  </aside>
  <!-- side menu -->

  <!-- stage -->
  <div class="relative min-w-0 flex-1">

    <!-- top bar -->
    <div class="pointer-events-none absolute inset-x-0 top-0 z-30 flex items-center bg-linear-to-b from-black/50 to-transparent px-2 pt-[calc(env(safe-area-inset-top)+0.5rem)] pb-6 lg:hidden">
      <a class="js_reels-back pointer-events-auto flex size-10 shrink-0 items-center justify-center rounded-full text-white!" href="{$system['system_url']}" aria-label='{__("Back")}'>
        <i class="icon-[tabler--chevron-left] size-7 rtl:rotate-180" aria-hidden="true"></i>
      </a>
      <div class="pointer-events-auto flex min-w-0 flex-1 items-center justify-center gap-5 pe-10 text-base font-semibold text-shadow-sm">
        {if $user->_logged_in}
          <a class="text-white! {if $tab != 'following'}opacity-60{/if}" href="{$system['system_url']}/reels?tab=following">{__("Following")}</a>
          <a class="text-white! {if $tab != 'for_you'}opacity-60{/if}" href="{$system['system_url']}/reels">{__("For You")}</a>
        {else}
          <span>{__("Reels")}</span>
        {/if}
      </div>
    </div>
    <!-- top bar -->

    {if $posts}
      <!-- reels -->
      <div class="js_reels-stream h-full snap-y snap-mandatory overflow-y-auto overscroll-y-contain [scrollbar-width:none]! [&::-webkit-scrollbar]:hidden!">
        {foreach $posts as $post}
          {include file='__feeds_reel.tpl' _iteration=$post@iteration}
        {/foreach}
      </div>
      <!-- reels -->

      <!-- loader -->
      <div class="js_reels-loader pointer-events-none absolute inset-x-0 bottom-3 z-30 hidden justify-center not-[.hidden]:flex">
        <span class="loading loading-spinner loading-sm"></span>
      </div>
      <!-- loader -->

      <!-- unmute hint -->
      <button type="button" class="js_reels-unmute absolute start-1/2 top-[calc(env(safe-area-inset-top)+4rem)] z-30 hidden -translate-x-1/2 items-center gap-2 not-[.hidden]:flex rounded-full bg-black/60 px-4 py-2 text-sm font-semibold text-white rtl:translate-x-1/2 lg:top-6">
        <i class="icon-[tabler--volume-off] size-5" aria-hidden="true"></i>
        {__("Tap to unmute")}
      </button>
      <!-- unmute hint -->

      <!-- arrows -->
      <div class="absolute end-6 top-1/2 z-30 hidden -translate-y-1/2 flex-col gap-3 lg:flex">
        <button type="button" class="js_reels-prev flex size-11 items-center justify-center rounded-full bg-white/10 text-white transition-colors hover:bg-white/20 disabled:pointer-events-none disabled:opacity-30" aria-label='{__("Previous")}'>
          <i class="icon-[tabler--chevron-up] size-6" aria-hidden="true"></i>
        </button>
        <button type="button" class="js_reels-next flex size-11 items-center justify-center rounded-full bg-white/10 text-white transition-colors hover:bg-white/20 disabled:pointer-events-none disabled:opacity-30" aria-label='{__("Next")}'>
          <i class="icon-[tabler--chevron-down] size-6" aria-hidden="true"></i>
        </button>
      </div>
      <!-- arrows -->
    {else}
      <div class="flex h-full flex-col items-center justify-center">
        {include file='_no_data.tpl' _empty_icon="icon-[tabler--movie]"}
        {if $tab == 'following'}
          <a class="heroui button button--primary rounded-full" href="{$system['system_url']}/reels">{__("For You")}</a>
        {/if}
      </div>
    {/if}

  </div>
  <!-- stage -->

  <!-- comments -->
  <div id="reels-comments" class="overlay fixed inset-x-0 bottom-0 z-40 hidden h-[72dvh] translate-y-full flex-col rounded-t-4xl bg-base-100 pb-[env(safe-area-inset-bottom)] text-base-content transition-transform duration-300 [--body-scroll:true] [--has-autofocus:false] [--tab-accessibility-limited:false] not-[.hidden]:flex overlay-open:translate-y-0 lg:static lg:z-auto lg:h-full lg:w-[26rem] lg:shrink-0 lg:translate-y-0 lg:rounded-none lg:border-s lg:border-base-content/10 lg:pb-0 lg:transition-none" role="dialog" tabindex="-1" aria-label='{__("Comments")}' data-overlay-options='{ "backdropClasses": "overlay-backdrop fixed inset-0 z-30 bg-black/40 transition duration-200 lg:hidden" }'>
    <div class="js_reels-comments-drag shrink-0 touch-none border-b border-base-content/10 lg:touch-auto">
      <div class="mx-auto mt-2.5 h-1 w-10 rounded-full bg-base-content/20 lg:hidden"></div>
      <div class="flex items-center gap-2 px-5 py-2.5">
        <h2 class="min-w-0 flex-1 text-base font-semibold">{__("Comments")} <span class="js_reels-comments-count text-base-content/55"></span></h2>
        <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full" data-overlay="#reels-comments" aria-label='{__("Close")}'>
          <span class="icon-[tabler--x] size-5" aria-hidden="true"></span>
        </button>
      </div>
    </div>
    <div class="js_reels-comments-body min-h-0 flex-1 overflow-y-auto overscroll-contain"></div>
  </div>
  <!-- comments -->

</div>
<!-- page content -->

{if $user->_logged_in}
  <!-- live updates -->
  <div class="js_live-requests hidden" data-last-id="{$user->_data['user_live_requests_lastid']}"></div>
  <div class="js_live-messages hidden" data-last-message="{$user->_data['user_live_messages_lastid']}"></div>
  <div class="js_live-notifications hidden" data-last-id="{$user->_data['user_live_notifications_lastid']}"></div>
  <!-- live updates -->
{/if}

{include file='_footer.tpl'}
