<!-- browse -->
<div class="flex flex-col gap-7">

  <nav class="flex flex-col gap-1 max-lg:flex-row max-lg:flex-nowrap max-lg:gap-2 max-lg:overflow-x-auto max-lg:pb-1 max-lg:[scrollbar-width:none] max-lg:[&::-webkit-scrollbar]:hidden" aria-label='{__("Browse")}'>
    <a class="flex h-11 shrink-0 items-center gap-3 rounded-2xl px-3.5 text-sm transition max-sm:h-auto max-sm:min-w-0 max-sm:flex-1 max-sm:shrink max-sm:flex-col max-sm:justify-center max-sm:gap-1 max-sm:px-1 max-sm:py-2.5 max-sm:text-xs {if $view == "" && !$filter}bg-primary/10 font-semibold text-primary! hover:bg-primary/15{else}font-medium text-base-content! hover:bg-base-300{/if}" href="{$system['system_url']}/games" {if $view == "" && !$filter}aria-current="page"{/if}>
      <span class="icon-[tabler--home] size-5 shrink-0{if !($view == "" && !$filter)} text-base-content/60{/if}" aria-hidden="true"></span>
      <span class="max-w-full truncate" title="{__("All Games")}">{__("All Games")}</span>
    </a>
    <a class="flex h-11 shrink-0 items-center gap-3 rounded-2xl px-3.5 text-sm transition max-sm:h-auto max-sm:min-w-0 max-sm:flex-1 max-sm:shrink max-sm:flex-col max-sm:justify-center max-sm:gap-1 max-sm:px-1 max-sm:py-2.5 max-sm:text-xs {if $filter == "popular"}bg-primary/10 font-semibold text-primary! hover:bg-primary/15{else}font-medium text-base-content! hover:bg-base-300{/if}" href="{$system['system_url']}/games?filter=popular" {if $filter == "popular"}aria-current="page"{/if}>
      <span class="icon-[tabler--flame] size-5 shrink-0{if !($filter == "popular")} text-base-content/60{/if}" aria-hidden="true"></span>
      <span class="max-w-full truncate" title="{__("Popular")}">{__("Popular")}</span>
    </a>
    {if $user->_logged_in}
      <a class="flex h-11 shrink-0 items-center gap-3 rounded-2xl px-3.5 text-sm transition max-sm:h-auto max-sm:min-w-0 max-sm:flex-1 max-sm:shrink max-sm:flex-col max-sm:justify-center max-sm:gap-1 max-sm:px-1 max-sm:py-2.5 max-sm:text-xs {if $view == "played"}bg-primary/10 font-semibold text-primary! hover:bg-primary/15{else}font-medium text-base-content! hover:bg-base-300{/if}" href="{$system['system_url']}/games/played" {if $view == "played"}aria-current="page"{/if}>
        <span class="icon-[tabler--history] size-5 shrink-0{if !($view == "played")} text-base-content/60{/if}" aria-hidden="true"></span>
        <span class="max-w-full truncate" title="{__("Your Games")}">{__("Your Games")}</span>
      </a>
    {/if}
  </nav>

  {if $rail_games}
    <!-- most viewed -->
    <section class="flex flex-col gap-3 max-lg:hidden" aria-labelledby="games-rail-title">
      <h2 class="flex items-center gap-2.5 px-1 text-sm font-semibold text-base-content/70" id="games-rail-title">
        <span class="icon-[tabler--device-gamepad-2] size-5 shrink-0" aria-hidden="true"></span>
        {__("Most Played")}
      </h2>
      {foreach $rail_games as $_game}
        <a class="group/rail relative block aspect-[16/10] overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[3rem] bg-base-300" href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}" aria-label="{$_game['title']}">
          <img class="absolute inset-0 size-full object-cover transition-transform duration-500 group-hover/rail:scale-105" src="{$_game['thumbnail']}" alt="" loading="lazy">
          <span class="pointer-events-none absolute inset-0 bg-linear-to-t from-black/85 via-black/30 to-black/45" aria-hidden="true"></span>
          <span class="absolute inset-x-3 top-3 line-clamp-2 text-sm font-semibold text-white" title="{$_game['title']}">{$_game['title']}</span>
          <span class="absolute inset-x-3 bottom-3 flex items-center justify-between gap-2">
            <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-black/20 text-white backdrop-blur-sm transition group-hover/rail:bg-black/25" aria-hidden="true">
              <span class="icon-[tabler--player-play-filled] size-3"></span>
            </span>
            <span class="flex min-w-0 items-center overflow-hidden rounded-full text-[11px] font-medium text-white backdrop-blur-md">
              {if $_game['genres_list']}
                <span class="bg-white/15 px-2.5 py-1">{__($_game['genres_list'][0]['genre_name'])}</span>
              {/if}
              <span class="bg-white/25 px-2.5 py-1">{$_game['players_text']}</span>
            </span>
          </span>
        </a>
      {/foreach}
    </section>
    <!-- most viewed -->
  {/if}

</div>
<!-- browse -->
