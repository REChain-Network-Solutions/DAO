<!-- browse -->
<div class="flex flex-col gap-7">

  <nav class="flex flex-col gap-1 max-lg:flex-row max-lg:flex-nowrap max-lg:gap-2 max-lg:overflow-x-auto max-lg:pb-1 max-lg:[scrollbar-width:none] max-lg:[&::-webkit-scrollbar]:hidden" aria-label='{__("Browse")}'>
    <a class="flex h-11 shrink-0 items-center gap-3 rounded-2xl px-3.5 text-sm transition max-sm:h-auto max-sm:min-w-0 max-sm:flex-1 max-sm:shrink max-sm:flex-col max-sm:justify-center max-sm:gap-1 max-sm:px-1 max-sm:py-2.5 max-sm:text-xs {if $view == "" && !$filter}bg-primary/10 font-semibold text-primary! hover:bg-primary/15{else}font-medium text-base-content! hover:bg-base-300{/if}" href="{$system['system_url']}/movies" {if $view == "" && !$filter}aria-current="page"{/if}>
      <span class="icon-[tabler--home] size-5 shrink-0{if !($view == "" && !$filter)} text-base-content/60{/if}" aria-hidden="true"></span>
      <span class="max-w-full truncate" title="{__("All Movies")}">{__("All Movies")}</span>
    </a>
    <a class="flex h-11 shrink-0 items-center gap-3 rounded-2xl px-3.5 text-sm transition max-sm:h-auto max-sm:min-w-0 max-sm:flex-1 max-sm:shrink max-sm:flex-col max-sm:justify-center max-sm:gap-1 max-sm:px-1 max-sm:py-2.5 max-sm:text-xs {if $filter == "trending"}bg-primary/10 font-semibold text-primary! hover:bg-primary/15{else}font-medium text-base-content! hover:bg-base-300{/if}" href="{$system['system_url']}/movies?filter=trending" {if $filter == "trending"}aria-current="page"{/if}>
      <span class="icon-[tabler--flame] size-5 shrink-0{if !($filter == "trending")} text-base-content/60{/if}" aria-hidden="true"></span>
      <span class="max-w-full truncate" title="{__("Trending")}">{__("Trending")}</span>
    </a>
    <a class="flex h-11 shrink-0 items-center gap-3 rounded-2xl px-3.5 text-sm transition max-sm:h-auto max-sm:min-w-0 max-sm:flex-1 max-sm:shrink max-sm:flex-col max-sm:justify-center max-sm:gap-1 max-sm:px-1 max-sm:py-2.5 max-sm:text-xs {if $filter == "free"}bg-primary/10 font-semibold text-primary! hover:bg-primary/15{else}font-medium text-base-content! hover:bg-base-300{/if}" href="{$system['system_url']}/movies?filter=free" {if $filter == "free"}aria-current="page"{/if}>
      <span class="icon-[tabler--gift] size-5 shrink-0{if !($filter == "free")} text-base-content/60{/if}" aria-hidden="true"></span>
      <span class="max-w-full truncate" title="{__("Free")}">{__("Free")}</span>
    </a>
    <a class="flex h-11 shrink-0 items-center gap-3 rounded-2xl px-3.5 text-sm transition max-sm:h-auto max-sm:min-w-0 max-sm:flex-1 max-sm:shrink max-sm:flex-col max-sm:justify-center max-sm:gap-1 max-sm:px-1 max-sm:py-2.5 max-sm:text-xs {if $filter == "paid"}bg-primary/10 font-semibold text-primary! hover:bg-primary/15{else}font-medium text-base-content! hover:bg-base-300{/if}" href="{$system['system_url']}/movies?filter=paid" {if $filter == "paid"}aria-current="page"{/if}>
      <span class="icon-[tabler--lock] size-5 shrink-0{if !($filter == "paid")} text-base-content/60{/if}" aria-hidden="true"></span>
      <span class="max-w-full truncate" title="{__("Paid")}">{__("Paid")}</span>
    </a>
  </nav>

  {if $rail_movies}
    <!-- most viewed -->
    <section class="flex flex-col gap-3 max-lg:hidden" aria-labelledby="movies-rail-title">
      <h2 class="flex items-center gap-2.5 px-1 text-sm font-semibold text-base-content/70" id="movies-rail-title">
        <span class="icon-[tabler--device-tv] size-5 shrink-0" aria-hidden="true"></span>
        {__("Most Viewed")}
      </h2>
      {foreach $rail_movies as $_movie}
        <a class="group/rail relative block aspect-[16/10] overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[3rem] bg-base-300" href="{$system['system_url']}/movie/{$_movie['movie_id']}/{$_movie['movie_url']}" aria-label="{$_movie['title']}">
          <img class="absolute inset-0 size-full object-cover transition-transform duration-500 group-hover/rail:scale-105" src="{$_movie['poster']}" alt="" loading="lazy">
          <span class="pointer-events-none absolute inset-0 bg-linear-to-t from-black/85 via-black/30 to-black/45" aria-hidden="true"></span>
          <span class="absolute inset-x-3 top-3 line-clamp-2 text-sm font-semibold text-white" title="{$_movie['title']}">{$_movie['title']}</span>
          <span class="absolute inset-x-3 bottom-3 flex items-center justify-between gap-2">
            <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-black/20 text-white backdrop-blur-sm transition group-hover/rail:bg-black/25" aria-hidden="true">
              <span class="icon-[tabler--player-play-filled] size-3"></span>
            </span>
            <span class="flex min-w-0 items-center overflow-hidden rounded-full text-[11px] font-medium text-white backdrop-blur-md">
              {if $_movie['duration_text']}
                <span class="bg-white/15 px-2.5 py-1">{$_movie['duration_text']}</span>
              {/if}
              <span class="bg-white/25 px-2.5 py-1">{$_movie['views_text']}</span>
            </span>
          </span>
        </a>
      {/foreach}
    </section>
    <!-- most viewed -->
  {/if}

</div>
<!-- browse -->
