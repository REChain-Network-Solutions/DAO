{include file='__modal_header.tpl' _icon="icon-[tabler--bolt]" _title=__("Get More From Dating")}
<div class="modal__body flex flex-col gap-3">
  <!-- super likes -->
  <div class="relative overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-base-100 p-5 text-base-content dark:border-0 dark:bg-slate-950 dark:text-white">
    <span class="pointer-events-none absolute -end-10 -top-10 size-36 rounded-full bg-sky-500/20 blur-2xl dark:bg-sky-500/30" aria-hidden="true"></span>
    <div class="relative flex items-center gap-3">
      <span class="inline-flex size-11 shrink-0 items-center justify-center rounded-full border border-sky-500/20 bg-sky-500/10 dark:border-white/10 dark:bg-white/5" aria-hidden="true">
        <span class="icon-[tabler--star-filled] size-5 text-sky-500 dark:text-sky-400"></span>
      </span>
      <div class="min-w-0 grow">
        <div class="truncate text-lg font-semibold">{__("Super Likes")}</div>
        <p class="truncate text-xs text-base-content/60 dark:text-white/60" title="{__("Stand out and get noticed first")}">{__("Stand out and get noticed first")}</p>
      </div>
      <span class="shrink-0 rounded-full border border-sky-500/20 bg-sky-500/10 px-2.5 py-1 text-xs font-medium text-sky-600 dark:border-white/10 dark:bg-white/5 dark:text-sky-300">{__("You have")} {$dating_balance['super_likes']}</span>
    </div>
    {if $dating_paid && $system['dating_super_likes_price'] > 0 && $system['dating_super_likes_pack'] > 0}
      <div class="relative mt-5 flex items-center justify-between gap-3 rounded-2xl border border-base-300 bg-base-200/60 py-2.5 ps-4 pe-2.5 dark:border-white/10 dark:bg-white/5">
        <div class="min-w-0">
          <div class="text-lg font-bold leading-tight">{print_money($system['dating_super_likes_price'])}</div>
          <div class="truncate text-xs text-base-content/60 dark:text-white/60">{$system['dating_super_likes_pack']} {__("Super Likes")}</div>
        </div>
        <button type="button" class="inline-flex h-8 shrink-0 cursor-pointer items-center gap-1.5 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] px-3.5 text-xs font-semibold transition-colors disabled:opacity-60 bg-slate-950 text-white hover:bg-slate-800 dark:bg-white dark:text-slate-950 dark:hover:bg-white/90 js_dating-buy" data-item="super_likes">
          <span class="icon-[tabler--shopping-cart] size-3.5" aria-hidden="true"></span>
          {__("Buy Now")}
        </button>
      </div>
    {else}
      <div class="relative mt-5 rounded-2xl border border-base-300 bg-base-200/60 px-4 py-3 text-center text-sm text-base-content/60 dark:border-white/10 dark:bg-white/5 dark:text-white/60">{__("Not for sale")}</div>
    {/if}
  </div>
  <!-- super likes -->

  <!-- boost -->
  <div class="relative overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-base-100 p-5 text-base-content dark:border-0 dark:bg-slate-950 dark:text-white">
    <span class="pointer-events-none absolute -end-10 -top-10 size-36 rounded-full bg-fuchsia-500/20 blur-2xl dark:bg-fuchsia-500/30" aria-hidden="true"></span>
    <div class="relative flex items-center gap-3">
      <span class="inline-flex size-11 shrink-0 items-center justify-center rounded-full border border-fuchsia-500/20 bg-fuchsia-500/10 dark:border-white/10 dark:bg-white/5" aria-hidden="true">
        <span class="icon-[tabler--bolt-filled] size-5 text-fuchsia-500 dark:text-fuchsia-400"></span>
      </span>
      <div class="min-w-0 grow">
        <div class="truncate text-lg font-semibold">{__("Boost")}</div>
        <p class="truncate text-xs text-base-content/60 dark:text-white/60" title="{__("Be one of the top profiles for")} {$system['dating_boost_minutes']} {__("minutes")}">{__("Be one of the top profiles for")} {$system['dating_boost_minutes']} {__("minutes")}</p>
      </div>
      {if $dating_balance['boosts'] > 0 && !$dating_balance['boosted']}
        <span class="shrink-0 rounded-full border border-fuchsia-500/20 bg-fuchsia-500/10 px-2.5 py-1 text-xs font-medium text-fuchsia-600 dark:border-white/10 dark:bg-white/5 dark:text-fuchsia-300">{__("You have")} {$dating_balance['boosts']}</span>
      {/if}
    </div>
    {if $dating_balance['boosted']}
      <div class="relative mt-5 rounded-2xl border border-fuchsia-500/20 bg-fuchsia-500/10 px-4 py-3 text-center text-sm font-medium text-fuchsia-600 dark:border-white/10 dark:bg-white/5 dark:text-fuchsia-300"><span class="icon-[tabler--rocket] me-1 size-4 align-text-bottom" aria-hidden="true"></span>{__("Your profile is boosted now")}</div>
    {elseif $dating_balance['boosts'] > 0}
      <div class="relative mt-5 flex items-center justify-between gap-3 rounded-2xl border border-base-300 bg-base-200/60 py-2.5 ps-4 pe-2.5 dark:border-white/10 dark:bg-white/5">
        <div class="min-w-0">
          <div class="text-lg font-bold leading-tight">{__("Free")}</div>
          <div class="truncate text-xs text-base-content/60 dark:text-white/60">{__("Included in your plan")}</div>
        </div>
        <button type="button" class="inline-flex h-8 shrink-0 cursor-pointer items-center gap-1.5 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] px-3.5 text-xs font-semibold transition-colors disabled:opacity-60 bg-slate-950 text-white hover:bg-slate-800 dark:bg-white dark:text-slate-950 dark:hover:bg-white/90 js_dating-buy" data-item="boost">
          <span class="icon-[tabler--bolt] size-3.5" aria-hidden="true"></span>
          {__("Boost Now")}
        </button>
      </div>
    {elseif $dating_paid && $system['dating_boost_price'] > 0}
      <div class="relative mt-5 flex items-center justify-between gap-3 rounded-2xl border border-base-300 bg-base-200/60 py-2.5 ps-4 pe-2.5 dark:border-white/10 dark:bg-white/5">
        <div class="min-w-0">
          <div class="text-lg font-bold leading-tight">{print_money($system['dating_boost_price'])}</div>
          <div class="truncate text-xs text-base-content/60 dark:text-white/60">{$system['dating_boost_minutes']} {__("minutes")}</div>
        </div>
        <button type="button" class="inline-flex h-8 shrink-0 cursor-pointer items-center gap-1.5 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] px-3.5 text-xs font-semibold transition-colors disabled:opacity-60 bg-slate-950 text-white hover:bg-slate-800 dark:bg-white dark:text-slate-950 dark:hover:bg-white/90 js_dating-buy" data-item="boost">
          <span class="icon-[tabler--bolt] size-3.5" aria-hidden="true"></span>
          {__("Boost Now")}
        </button>
      </div>
    {else}
      <div class="relative mt-5 rounded-2xl border border-base-300 bg-base-200/60 px-4 py-3 text-center text-sm text-base-content/60 dark:border-white/10 dark:bg-white/5 dark:text-white/60">{__("Not for sale")}</div>
    {/if}
  </div>
  <!-- boost -->

  {if $dating_upgrade}
    <!-- upgrade -->
    <a class="relative flex items-center gap-3 overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-transparent bg-linear-to-r from-warning/25 via-base-100 to-accent/25 p-5 text-base-content! transition-opacity dark:border-amber-400/30 dark:from-amber-950 dark:via-slate-950 dark:to-slate-950 dark:text-white! hover:opacity-90" href="{$system['system_url']}/packages">
      <span class="inline-flex size-11 shrink-0 items-center justify-center rounded-full bg-accent text-accent-content dark:bg-linear-to-br dark:from-amber-300 dark:to-amber-500 dark:text-slate-950" aria-hidden="true">
        <span class="icon-[tabler--crown] size-5"></span>
      </span>
      <span class="min-w-0 grow">
        <span class="block truncate text-lg font-semibold">{__("Upgrade Your Plan")}</span>
        <span class="block text-xs text-base-content/60 dark:text-white/60">{__("Unlimited swipes, see who liked you, undo and more")}</span>
      </span>
      <span class="inline-flex h-8 shrink-0 items-center rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] bg-accent px-3.5 text-xs font-semibold text-accent-content dark:bg-white dark:text-slate-950">{__("Upgrade")}</span>
    </a>
    <!-- upgrade -->
  {/if}
  {if $user->_is_admin && (!$dating_paid || $system['dating_super_likes_price'] <= 0 || $system['dating_boost_price'] <= 0)}
    <a class="flex items-center gap-3 rounded-xl border border-dashed border-base-300 p-4 text-sm text-base-content! transition-colors hover:bg-base-200/60" href="{$system['system_url']}/admincp/dating/settings">
      <span class="icon-[tabler--settings] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
      <span class="min-w-0 grow">{if !$dating_paid}{__("Enable the wallet to sell super likes and boosts")}{else}{__("Set the prices in the dating settings to sell super likes and boosts")}{/if}</span>
      <span class="icon-[tabler--chevron-right] size-5 shrink-0 text-base-content/50 rtl:rotate-180" aria-hidden="true"></span>
    </a>
  {/if}
  {if $dating_paid}
    <p class="flex items-center justify-center gap-1.5 text-xs text-base-content/60">
      <span class="icon-[tabler--wallet] size-4" aria-hidden="true"></span>
      {__("Your wallet balance")}: <strong class="text-base-content">{print_money($user->_data['user_wallet_balance'])}</strong>
    </p>
  {/if}
</div>
