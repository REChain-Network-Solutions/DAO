<article class="js_dating-card absolute inset-0 touch-pan-y select-none rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] text-white shadow-xl transition-transform duration-300 will-change-transform" data-id="{$card['user_id']}" data-name="{$card['name']}">
  <div class="absolute inset-0 overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-neutral">
    <span class="pointer-events-none absolute inset-x-0 top-0 z-10 h-1/4 bg-linear-to-b from-black/45 to-transparent" aria-hidden="true"></span>
    <!-- photos -->
    {foreach $card['photos'] as $_photo}
      <img class="js_dating-photo pointer-events-none absolute inset-0 size-full object-cover{if !$_photo@first} hidden{/if}" src="{$_photo}" alt="" draggable="false" {if !$_photo@first}loading="lazy"{/if}>
    {/foreach}
    {if count($card['photos']) > 1}
      <div class="absolute inset-x-6 top-4 z-20 flex gap-1" aria-hidden="true">
        {foreach $card['photos'] as $_photo}
          <span class="js_dating-photo-dot h-1 flex-1 rounded-full bg-white/40 data-[active=true]:bg-white" {if $_photo@first}data-active="true"{/if}></span>
        {/foreach}
      </div>
      <button type="button" class="js_dating-photo-prev absolute inset-y-0 start-0 z-10 w-1/3" aria-label='{__("Previous photo")}'></button>
      <button type="button" class="js_dating-photo-next absolute inset-y-0 end-0 z-10 w-1/3" aria-label='{__("Next photo")}'></button>
    {/if}
    <!-- photos -->

    <!-- stamps -->
    <span class="js_dating-stamp-like pointer-events-none absolute start-6 top-24 z-20 -rotate-12 rounded-xl border-4 border-success px-3 py-1 text-2xl font-black uppercase tracking-wider text-success opacity-0" aria-hidden="true">{__("Like")}</span>
    <span class="js_dating-stamp-pass pointer-events-none absolute end-6 top-24 z-20 rotate-12 rounded-xl border-4 border-error px-3 py-1 text-2xl font-black uppercase tracking-wider text-error opacity-0" aria-hidden="true">{__("Nope")}</span>
    <span class="js_dating-stamp-super pointer-events-none absolute inset-x-0 bottom-40 z-20 mx-auto w-fit -rotate-6 rounded-xl border-4 border-info px-3 py-1 text-2xl font-black uppercase tracking-wider text-info opacity-0" aria-hidden="true">{__("Super Like")}</span>
    <!-- stamps -->

    <!-- info -->
    <div class="pointer-events-none absolute inset-x-0 bottom-0 z-10 bg-linear-to-t from-black/90 via-black/50 to-transparent px-6 pb-14 pt-28">
      <p class="flex items-center gap-1.5 text-sm font-medium text-white/90">
        <span class="size-2 shrink-0 rounded-full {if $card['online']}bg-emerald-400{else}bg-white/40{/if}" aria-hidden="true"></span>
        {if $card['online']}{__("Active")}{else}{__("Offline")}{/if}
        {if $card['verified']}
          {include file='__badge.tpl' _badge="verified" _badge_type="user" _badge_size=16}
        {/if}
      </p>
      <div class="mt-1.5 flex items-center justify-between gap-3">
        <h3 class="min-w-0 truncate text-3xl font-bold tracking-tight" title="{$card['name']}">{$card['name']}{if $card['age']}<span class="font-normal">, {$card['age']}</span>{/if}</h3>
        {if $card['distance'] || $card['city']}
          <span class="inline-flex max-w-[45%] shrink-0 items-center gap-1 rounded-full border border-white/20 bg-white/15 px-2 py-0.5 text-[11px] font-normal backdrop-blur-md" title="{if $card['distance']}{$card['distance']} {if $system['system_distance'] == "mile"}{__("miles away")}{else}{__("km away")}{/if}{else}{$card['city']}{/if}">
            <span class="icon-[tabler--map-pin-filled] size-3 shrink-0" aria-hidden="true"></span>
            <span class="truncate">{if $card['distance']}{$card['distance']} {if $system['system_distance'] == "mile"}{__("ML")}{else}{__("KM")}{/if}{else}{$card['city']}{/if}</span>
          </span>
        {/if}
      </div>
      {if $card['shared']}
        <p class="mt-1.5 flex items-center gap-1.5 text-xs font-normal text-white/75">
          <span class="icon-[tabler--sparkles] size-3.5 shrink-0" aria-hidden="true"></span>
          {$card['shared']} {if $card['shared'] == 1}{__("interest in common")}{else}{__("interests in common")}{/if}
        </p>
      {/if}
    </div>
    <!-- info -->
  </div>

  <!-- score -->
  <div class="pointer-events-none absolute start-5 top-9 z-20 flex flex-col items-start gap-1.5">
    {include file='__dating_score.tpl' _score=$card['match'] _size="lg"}
  </div>
  {if $card['super_liked_me']}
    <div class="pointer-events-none absolute inset-x-24 top-9 z-20 flex justify-center">
      <span class="inline-flex items-center gap-1.5 rounded-full border border-white/25 bg-black/35 px-3 py-1.5 text-sm font-medium text-white shadow-lg shadow-black/20 backdrop-blur-md">
        <span class="icon-[tabler--star-filled] size-4 text-sky-400" aria-hidden="true"></span>
        <span class="truncate">{__("Super liked you")}</span>
      </span>
    </div>
  {/if}
  <!-- score -->

  <!-- menu -->
  <div class="dropdown absolute end-5 top-9 z-20 inline-flex [--placement:bottom-end]">
    <button type="button" class="dropdown-toggle heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full border border-white/25 bg-black/35 shadow-lg shadow-black/20 backdrop-blur-md text-white hover:bg-black/50" aria-haspopup="menu" aria-expanded="false" aria-label='{__("More")}'>
      <span class="icon-[tabler--dots] size-4" aria-hidden="true"></span>
    </button>
    <ul class="dropdown-menu dropdown-open:opacity-100 hidden min-w-48 text-base-content" role="menu">
      <li><button type="button" class="dropdown-item js_modal" data-url="data/report.php?do=create&handle=user&id={$card['user_id']}"><span class="icon-[tabler--flag] size-4" aria-hidden="true"></span>{__("Report")}</button></li>
      <li><button type="button" class="dropdown-item text-error js_block-user" data-uid="{$card['user_id']}"><span class="icon-[tabler--ban] size-4" aria-hidden="true"></span>{__("Block")}</button></li>
    </ul>
  </div>
  <!-- menu -->

  <!-- details -->
  <div class="js_dating-card-detail hidden">
    <!-- backdrop -->
    <div class="pointer-events-none absolute inset-0 -z-10 overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[3rem] bg-base-100" aria-hidden="true">
      <img class="absolute inset-0 size-full scale-110 object-cover opacity-40 blur-2xl" src="{$card['photos'][0]}" alt="">
      <span class="absolute inset-0 bg-linear-to-t from-base-100 via-base-100/85 to-base-100/40"></span>
    </div>
    <!-- backdrop -->

    <!-- heading -->
    <div class="flex items-center gap-5">
      <span class="relative shrink-0">
        <img class="size-24 rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] object-cover shadow-xl" src="{$card['photos'][0]}" alt="">
        {if $card['online']}
          <span class="absolute -bottom-1 -end-1 size-5 rounded-full border-[3px] border-base-100 bg-success" title='{__("Active")}'></span>
        {/if}
      </span>
      <div class="min-w-0 grow">
        <div class="flex items-center gap-2">
          <h3 class="min-w-0 truncate text-3xl font-bold tracking-tight" title="{$card['name']}">{$card['name']}</h3>
          {if $card['verified']}
            {include file='__badge.tpl' _badge="verified" _badge_type="user" _badge_size=22}
          {/if}
        </div>
        <ul class="mt-2 flex flex-wrap items-center gap-x-4 gap-y-1 text-sm text-base-content/70">
          {if $card['age']}
            <li class="flex items-center gap-1.5">
              <span class="icon-[tabler--cake] size-4 shrink-0" aria-hidden="true"></span>
              {$card['age']} {__("years old")}
            </li>
          {/if}
          {if $card['gender_name'] && !$system['genders_disabled']}
            <li class="flex items-center gap-1.5">
              <span class="icon-[tabler--user] size-4 shrink-0" aria-hidden="true"></span>
              {$card['gender_name']}
            </li>
          {/if}
          {if $card['city']}
            <li class="flex min-w-0 items-center gap-1.5">
              <span class="icon-[tabler--map-pin] size-4 shrink-0" aria-hidden="true"></span>
              <span class="truncate" title="{$card['city']}">{$card['city']}</span>
            </li>
          {/if}
        </ul>
      </div>
    </div>
    <!-- heading -->

    {if $card['bio']}
      <!-- about -->
      <div>
        <h4 class="flex items-center gap-2 text-lg font-semibold">
          <span class="icon-[tabler--user-heart] size-5 text-base-content/60" aria-hidden="true"></span>
          {__("About")}
        </h4>
        <p class="mt-2 whitespace-pre-line text-base-content/80">{$card['bio']}</p>
      </div>
      <!-- about -->
    {/if}

    {if $card['interests']}
      <!-- interests -->
      <div>
        <h4 class="flex items-center gap-2 text-lg font-semibold">
          <span class="icon-[tabler--sparkles] size-5 text-base-content/60" aria-hidden="true"></span>
          {__("Interests")}
        </h4>
        <div class="mt-3 flex flex-wrap gap-2">
          {foreach $card['interests'] as $_interest}
            <span class="inline-flex items-center gap-1.5 rounded-full px-4 py-2 text-sm font-medium backdrop-blur-md {if $_interest['shared']}bg-primary/20{else}bg-base-content/10{/if}">
              <span aria-hidden="true">{$_interest['icon']}</span>
              {__($_interest['title'])}
              {if $_interest['shared']}<span class="icon-[tabler--circle-check-filled] size-4 text-primary" aria-hidden="true"></span>{/if}
            </span>
          {/foreach}
        </div>
      </div>
      <!-- interests -->
    {/if}
  </div>
  <!-- details -->
</article>
