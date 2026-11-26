<li class="js_dating-grid-card{if $_matched} js_dating-match{/if} group relative aspect-[3/4] text-white" data-id="{$card['user_id']}" data-name="{$card['name']}">
  <!-- photo -->
  <div class="absolute inset-0 overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-neutral">
    <img class="absolute inset-0 size-full object-cover transition-transform duration-300 group-hover:scale-105" src="{if $_matched}{$card['photo']}{else}{$card['photos'][0]}{/if}" alt="" loading="lazy">
    <span class="absolute inset-x-0 top-0 h-1/4 bg-linear-to-b from-black/45 to-transparent" aria-hidden="true"></span>
    <span class="absolute inset-x-0 bottom-0 h-2/3 bg-linear-to-t from-black/85 via-black/40 to-transparent" aria-hidden="true"></span>
  </div>
  <!-- photo -->

  <!-- badges -->
  {if $card['match'] !== null}
    <div class="absolute start-3 top-3 z-10 flex h-8 items-center">
      {include file='__dating_score.tpl' _score=$card['match']}
    </div>
  {/if}
  {if !$_matched && $card['super_liked_me']}
    <div class="pointer-events-none absolute inset-x-16 top-3 z-10 flex h-8 items-center justify-center">
      <span class="inline-flex items-center gap-1.5 rounded-full border border-white/25 bg-black/35 px-2.5 py-1 text-xs font-medium text-white shadow-lg shadow-black/20 backdrop-blur-md">
        <span class="icon-[tabler--star-filled] size-3.5 text-sky-400" aria-hidden="true"></span>
        <span class="truncate">{__("Super Like")}</span>
      </span>
    </div>
  {/if}
  <!-- badges -->

  <!-- menu -->
  <div class="dropdown absolute end-3 top-3 z-20 inline-flex [--placement:bottom-end]">
    <button type="button" class="dropdown-toggle heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full border border-white/25 bg-black/35 shadow-lg shadow-black/20 backdrop-blur-md text-white hover:bg-black/50" aria-haspopup="menu" aria-expanded="false" aria-label='{__("More")}'>
      <span class="icon-[tabler--dots] size-4" aria-hidden="true"></span>
    </button>
    <ul class="dropdown-menu dropdown-open:opacity-100 hidden min-w-48" role="menu">
      <li><button type="button" class="dropdown-item js_modal" data-url="data/report.php?do=create&handle=user&id={$card['user_id']}"><span class="icon-[tabler--flag] size-4" aria-hidden="true"></span>{__("Report")}</button></li>
      {if $_matched}
        <li><button type="button" class="dropdown-item js_dating-unmatch" data-id="{$card['user_id']}"><span class="icon-[tabler--heart-off] size-4" aria-hidden="true"></span>{__("Unmatch")}</button></li>
        <li><button type="button" class="dropdown-item text-error js_dating-unmatch" data-id="{$card['user_id']}" data-block="true"><span class="icon-[tabler--ban] size-4" aria-hidden="true"></span>{__("Unmatch & Block")}</button></li>
      {else}
        <li><button type="button" class="dropdown-item text-error js_block-user" data-uid="{$card['user_id']}"><span class="icon-[tabler--ban] size-4" aria-hidden="true"></span>{__("Block")}</button></li>
      {/if}
    </ul>
  </div>
  <!-- menu -->

  <!-- info -->
  <div class="absolute inset-x-0 bottom-0 z-10 flex flex-col p-4">
    <p class="flex items-center gap-1.5 text-xs font-normal text-white/85">
      <span class="size-1.5 shrink-0 rounded-full {if $card['online']}bg-emerald-400{else}bg-white/40{/if}" aria-hidden="true"></span>
      {if $card['online']}{__("Active")}{else}{__("Offline")}{/if}
    </p>
    <div class="mt-0.5 flex items-center justify-between gap-2">
      <div class="flex min-w-0 items-center gap-1.5">
        {if $_matched}
          <a class="min-w-0 truncate text-lg font-semibold text-white! hover:underline" href="{$system['system_url']}/{$card['user_name']}" title="{$card['fullname']}">{$card['name']}{if $card['age']}<span class="font-normal">, {$card['age']}</span>{/if}</a>
        {else}
          <h3 class="min-w-0 truncate text-lg font-semibold" title="{$card['name']}">{$card['name']}{if $card['age']}<span class="font-normal">, {$card['age']}</span>{/if}</h3>
        {/if}
        {if $card['verified']}
          {include file='__badge.tpl' _badge="verified" _badge_type="user" _badge_size=16}
        {/if}
      </div>
      {if !$_matched && ($card['distance'] || $card['city'])}
        <span class="inline-flex max-w-[45%] shrink-0 items-center gap-1 rounded-full border border-white/20 bg-white/15 px-2 py-0.5 text-[11px] font-normal backdrop-blur-md" title="{if $card['distance']}{$card['distance']} {if $system['system_distance'] == "mile"}{__("miles away")}{else}{__("km away")}{/if}{else}{$card['city']}{/if}">
          <span class="icon-[tabler--map-pin-filled] size-3 shrink-0" aria-hidden="true"></span>
          <span class="truncate">{if $card['distance']}{$card['distance']} {if $system['system_distance'] == "mile"}{__("ML")}{else}{__("KM")}{/if}{else}{$card['city']}{/if}</span>
        </span>
      {/if}
    </div>
    {if $_matched}
      <p class="mt-0.5 truncate text-xs font-normal text-white/75" title="{$card['time']|date_format:'%e %B %Y'}">{__("Matched")} <span class="js_moment" data-time="{$card['time']}">{$card['time']}</span></p>
    {elseif $card['message']}
      <p class="mt-1.5 line-clamp-2 rounded-xl bg-white/15 px-2.5 py-1.5 text-xs backdrop-blur-sm" title="{$card['message']}">{$card['message']}</p>
    {elseif $card['shared']}
      <p class="mt-0.5 truncate text-xs font-normal text-white/75">{$card['shared']} {if $card['shared'] == 1}{__("interest in common")}{else}{__("interests in common")}{/if}</p>
    {/if}
    {if $_matched && ($card['distance'] || $card['city'])}
      <span class="inline-flex mt-1.5 max-w-full self-start items-center gap-1 rounded-full border border-white/20 bg-white/15 px-2 py-0.5 text-[11px] font-normal backdrop-blur-md" title="{if $card['distance']}{$card['distance']} {if $system['system_distance'] == "mile"}{__("miles away")}{else}{__("km away")}{/if}{else}{$card['city']}{/if}">
        <span class="icon-[tabler--map-pin-filled] size-3 shrink-0" aria-hidden="true"></span>
        <span class="truncate">{if $card['distance']}{$card['distance']} {if $system['system_distance'] == "mile"}{__("ML")}{else}{__("KM")}{/if}{else}{$card['city']}{/if}</span>
      </span>
    {/if}
    <div class="mt-3 flex items-center justify-center gap-2.5">
      {if $_matched}
        {if $system['chat_enabled']}
          <button type="button" class="heroui button button--tertiary button--icon-only rounded-full size-11 border-0 bg-linear-to-b from-fuchsia-400 to-violet-600 text-white shadow-lg shadow-violet-600/40 transition-transform hover:scale-110 js_chat-start" data-uid="{$card['user_id']}" data-name="{$card['fullname']}" data-link="{$card['user_name']}" data-picture="{$card['picture']}" title='{__("Message")}' aria-label='{__("Message")}'>
            <span class="icon-[tabler--message-circle-filled] size-5" aria-hidden="true"></span>
          </button>
        {else}
          <a class="heroui button button--tertiary button--icon-only rounded-full size-11 border-0 bg-linear-to-b from-fuchsia-400 to-violet-600 text-white shadow-lg shadow-violet-600/40 transition-transform hover:scale-110 text-white!" href="{$system['system_url']}/{$card['user_name']}" title='{__("View Profile")}' aria-label='{__("View Profile")}'>
            <span class="icon-[tabler--user-filled] size-5" aria-hidden="true"></span>
          </a>
        {/if}
      {else}
        <button type="button" class="heroui button button--tertiary button--icon-only rounded-full size-10 border-0 bg-linear-to-b from-sky-400 to-blue-500 shadow-blue-500/40 text-white shadow-lg transition-transform hover:scale-110 js_dating-grid-swipe" data-action="pass" title='{__("Pass")}' aria-label='{__("Pass")}'>
          <span class="icon-[tabler--x] size-5" aria-hidden="true"></span>
        </button>
        <button type="button" class="heroui button button--tertiary button--icon-only rounded-full size-10 border-0 bg-linear-to-b from-rose-400 to-red-500 shadow-red-500/40 text-white shadow-lg transition-transform hover:scale-110 js_dating-grid-swipe" data-action="like" title='{__("Like")}' aria-label='{__("Like")}'>
          <span class="icon-[tabler--heart-filled] size-5" aria-hidden="true"></span>
        </button>
        {if $user->dating_feature_available('super_likes')}
          <button type="button" class="heroui button button--tertiary button--icon-only rounded-full size-10 border-0 bg-linear-to-b from-amber-300 to-orange-400 shadow-orange-400/40 text-white shadow-lg transition-transform hover:scale-110 js_dating-grid-swipe" data-action="super" title='{__("Super Like")}' aria-label='{__("Super Like")}'>
            <span class="icon-[tabler--star-filled] size-5" aria-hidden="true"></span>
          </button>
        {/if}
      {/if}
    </div>
  </div>
  <!-- info -->
</li>
