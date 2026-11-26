<!-- plan -->
<section class="flex flex-col gap-4">
  {assign var="_super_likes" value=$user->dating_feature_available('super_likes')}
  {assign var="_boosts" value=$user->dating_feature_available('boosts')}
  {if $_super_likes || $_boosts}
    <div class="grid {if $_super_likes && $_boosts}grid-cols-2{/if} gap-4">
      {if $_super_likes}
        <button type="button" class="js_modal group relative flex min-w-0 cursor-pointer flex-col overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border-0 bg-base-100 p-5 text-start text-base-content ring-1 ring-inset ring-base-content/5 dark:bg-slate-950 dark:text-white dark:ring-0" data-url="dating/purchase.php?do=store">
          <span class="pointer-events-none absolute -end-10 -top-10 size-32 rounded-full bg-sky-500/20 blur-2xl dark:bg-sky-500/30" aria-hidden="true"></span>
          <span class="relative flex items-center justify-between">
            <span class="inline-flex size-11 items-center justify-center rounded-full border border-sky-500/20 bg-sky-500/10 dark:border-white/10 dark:bg-white/5">
              <span class="icon-[tabler--star-filled] size-5 text-sky-500 dark:text-sky-400" aria-hidden="true"></span>
            </span>
            <span class="inline-flex size-9 items-center justify-center rounded-full border border-base-300 bg-base-200/60 text-base-content/60 transition-colors group-hover:bg-base-200 group-hover:text-base-content dark:border-white/10 dark:bg-white/5 dark:text-white/70 dark:group-hover:bg-white/15 dark:group-hover:text-white">
              <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
            </span>
          </span>
          <span class="relative mt-6 truncate text-lg font-semibold"><span class="js_dating-super-likes">{$dating_balance['super_likes']}</span> {__("Super Likes")}</span>
          <span class="relative mt-0.5 text-xs font-medium text-sky-600 dark:text-sky-400">{__("Get More")}</span>
        </button>
      {/if}
      {if $_boosts}
        <button type="button" class="js_modal group relative flex min-w-0 cursor-pointer flex-col overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border-0 bg-base-100 p-5 text-start text-base-content ring-1 ring-inset ring-base-content/5 dark:bg-slate-950 dark:text-white dark:ring-0" data-url="dating/purchase.php?do=store">
          <span class="pointer-events-none absolute -end-10 -top-10 size-32 rounded-full bg-fuchsia-500/20 blur-2xl dark:bg-fuchsia-500/30" aria-hidden="true"></span>
          <span class="relative flex items-center justify-between">
            <span class="inline-flex size-11 items-center justify-center rounded-full border border-fuchsia-500/20 bg-fuchsia-500/10 dark:border-white/10 dark:bg-white/5">
              <span class="icon-[tabler--bolt-filled] size-5 text-fuchsia-500 dark:text-fuchsia-400" aria-hidden="true"></span>
            </span>
            <span class="inline-flex size-9 items-center justify-center rounded-full border border-base-300 bg-base-200/60 text-base-content/60 transition-colors group-hover:bg-base-200 group-hover:text-base-content dark:border-white/10 dark:bg-white/5 dark:text-white/70 dark:group-hover:bg-white/15 dark:group-hover:text-white">
              <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
            </span>
          </span>
          <span class="relative mt-6 truncate text-lg font-semibold">{if $dating_balance['boosted']}{__("Boosted")}{else}{$dating_balance['boosts']} {__("Boosts")}{/if}</span>
          <span class="relative mt-0.5 text-xs font-medium text-fuchsia-600 dark:text-fuchsia-400">{if $dating_balance['boosted']}{__("Your profile is on top")}{else}{__("Get More")}{/if}</span>
        </button>
      {/if}
    </div>
  {/if}
  <div class="relative flex flex-wrap items-center gap-3 overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-transparent bg-linear-to-r from-warning/25 via-base-100 to-accent/25 p-5 text-base-content dark:border-amber-400/30 dark:from-amber-950 dark:via-slate-950 dark:to-slate-950 dark:text-white">
    <span class="inline-flex size-11 shrink-0 items-center justify-center rounded-full bg-accent text-accent-content dark:bg-linear-to-br dark:from-amber-300 dark:to-amber-500 dark:text-slate-950" aria-hidden="true">
      <span class="icon-[tabler--crown] size-5"></span>
    </span>
    <div class="min-w-0 grow basis-32">
      <div class="flex items-center gap-2">
        <span class="truncate text-lg font-semibold">{__("Dating")}</span>
        <span class="shrink-0 rounded-md bg-accent px-1.5 py-0.5 text-[10px] font-bold uppercase tracking-wider text-accent-content dark:bg-amber-400 dark:text-slate-950">{if $system['packages_enabled'] && $user->_data['user_subscribed']}{__("Premium")}{else}{__("Free")}{/if}</span>
      </div>
      <p class="truncate text-xs text-base-content/60 dark:text-white/70">
        {if $dating_balance['unlimited']}
          {__("Unlimited")} {__("swipes today")}
        {else}
          <strong class="js_dating-swipes-left text-accent dark:text-amber-300">{$dating_balance['swipes_left']}</strong> {__("swipes left today")}
        {/if}
      </p>
    </div>
    {if $dating_upgrade}
      <a class="heroui button button--primary [--button-bg:var(--color-accent)] [--button-bg-hover:color-mix(in_oklab,var(--color-accent)_90%,black)] [--button-bg-pressed:color-mix(in_oklab,var(--color-accent)_90%,black)] [--button-fg:var(--color-accent-content)] button--sm shrink-0 px-3.5 text-xs rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] dark:border-0 dark:bg-white dark:text-slate-950! dark:hover:bg-white/90" href="{$system['system_url']}/packages">{__("Upgrade")}</a>
    {/if}
  </div>
</section>
<!-- plan -->
