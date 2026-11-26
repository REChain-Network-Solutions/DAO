<!-- game -->
<div class="relative isolate flex min-w-0 flex-col gap-7 p-4 text-base-content sm:p-6 xl:p-8">

  <!-- backdrop -->
  <div class="pointer-events-none absolute inset-0 -z-10 overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[3rem] bg-base-200" aria-hidden="true">
    <img class="absolute inset-0 size-full scale-110 object-cover blur-3xl" src="{$game['thumbnail']}" alt="">
    <span class="absolute inset-0 bg-linear-to-b from-base-200/80 via-base-200/90 to-base-200 to-85% dark:from-base-200/55 dark:via-base-200/80"></span>
  </div>
  <!-- backdrop -->

  <!-- breadcrumb -->
  <nav class="breadcrumbs min-w-0 self-start rounded-2xl bg-base-100/70 p-1.5 text-sm ring-1 ring-inset ring-base-content/5 backdrop-blur-md" aria-label='{__("Breadcrumb")}'>
    <ol class="min-w-0 p-0">
      <li class="shrink-0">
        <a class="h-10 gap-2 rounded-xl px-2 font-medium text-base-content/70! transition-colors hover:bg-base-300 hover:text-base-content!" href="{$system['system_url']}/games">
          <span class="flex size-7 items-center justify-center rounded-lg bg-primary/10 text-primary" aria-hidden="true">
            <span class="icon-[tabler--device-gamepad-2] size-4"></span>
          </span>
          {__("Games")}
        </a>
      </li>
      {if $game['genres_list']}
        <li class="breadcrumbs-separator max-sm:hidden rtl:rotate-180" aria-hidden="true"><span class="icon-[tabler--chevron-right] size-3.5"></span></li>
        <li class="min-w-0 max-sm:hidden">
          <a class="h-10 min-w-0 rounded-xl px-2 text-base-content/60! transition-colors hover:bg-base-300 hover:text-base-content!" href="{$system['system_url']}/games/genre/{$game['genres_list'][0]['genre_id']}/{$game['genres_list'][0]['genre_url']}">
            <span class="max-w-40 truncate" title="{__($game['genres_list'][0]['genre_name'])}">{__($game['genres_list'][0]['genre_name'])}</span>
          </a>
        </li>
      {/if}
      <li class="breadcrumbs-separator rtl:rotate-180" aria-hidden="true"><span class="icon-[tabler--chevron-right] size-3.5"></span></li>
      <li class="min-w-0 pe-3 font-semibold" aria-current="page">
        <span class="max-w-[min(22rem,45vw)] truncate" title="{$game['title']}">{$game['title']}</span>
      </li>
    </ol>
  </nav>
  <!-- breadcrumb -->

  <!-- game heading -->
  <section aria-labelledby="game-title">
    <div class="flex flex-col gap-6 sm:flex-row sm:items-end xl:gap-8">
      <img class="aspect-[16/10] w-56 shrink-0 self-start rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-black/20 object-cover shadow-xl sm:w-64 xl:w-72" src="{$game['thumbnail']}" alt="{$game['title']}">
      <div class="flex min-w-0 flex-1 flex-col gap-4">
        <div class="flex flex-wrap items-center gap-2">
          <span class="flex items-center gap-1.5 rounded-2xl bg-base-100/60 px-3 py-1.5 text-xs font-medium backdrop-blur-md sm:text-sm">
            <span class="icon-[tabler--users] size-3.5" aria-hidden="true"></span>
            {$game['players_text']} {__("Players")}
          </span>
        </div>
        <h1 class="max-w-2xl text-2xl font-bold tracking-tight break-words sm:text-3xl xl:text-4xl" id="game-title">{$game['title']}</h1>
        <a class="group/play mt-1 inline-flex w-fit items-center gap-3.5 rounded-full text-base-content! focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-primary" href="#game-player">
          <span class="flex size-12 shrink-0 items-center justify-center rounded-full bg-base-content/10 backdrop-blur-sm transition group-hover/play:bg-base-content/15 sm:size-14" aria-hidden="true">
            <span class="icon-[tabler--player-play-filled] size-5"></span>
          </span>
          <span class="text-base font-bold">{__("Play now")}</span>
        </a>
      </div>
    </div>
  </section>
  <!-- game heading -->

  {if $game['genres_list']}
    <!-- genres -->
    <nav class="flex flex-wrap gap-2.5" aria-label='{__("Genres")}'>
      {foreach $game['genres_list'] as $_genre}
        <a class="flex min-h-11 items-center rounded-2xl bg-base-100/70 px-6 py-2 text-sm font-medium text-base-content! backdrop-blur-md transition hover:bg-base-300" href="{$system['system_url']}/games/genre/{$_genre['genre_id']}/{$_genre['genre_url']}">{__($_genre['genre_name'])}</a>
      {/foreach}
    </nav>
    <!-- genres -->
  {/if}

  <!-- player -->
  <section class="flex scroll-mt-24 flex-col gap-4" id="game-player" aria-labelledby="game-player-title">
    <div class="flex flex-wrap items-center justify-between gap-3">
      <h2 class="flex items-center gap-2.5 text-lg font-semibold" id="game-player-title">
        <span class="icon-[tabler--player-play] size-5 text-base-content/60" aria-hidden="true"></span>
        {__("Play now")}
      </h2>
      <button type="button" class="js_game-fullscreen heroui button button--tertiary button--sm shrink-0 rounded-[1rem] border-0 bg-base-100/70 text-base-content backdrop-blur-md hover:bg-base-300">
        <span class="icon-[tabler--maximize] size-4" aria-hidden="true"></span>
        {__("Full Screen")}
      </button>
    </div>
    <div class="overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-black">
      <div class="aspect-video [&>iframe]:size-full">
        <iframe src="{$game['source']}" id="game-area" title="{$game['title']}" frameborder="0" allow="fullscreen; autoplay; gamepad" allowfullscreen></iframe>
      </div>
    </div>
  </section>
  <!-- player -->

  <div class="grid gap-7 xl:grid-cols-[minmax(0,1fr)_16rem] xl:items-start">

    <!-- description -->
    <section class="flex min-w-0 flex-col gap-5" aria-labelledby="game-description-title">
      <h2 class="flex items-center gap-2.5 text-lg font-semibold" id="game-description-title">
        <span class="icon-[tabler--align-left] size-5 text-base-content/60" aria-hidden="true"></span>
        {__("Description")}
      </h2>
      {if $game['description']}
        <div class="max-w-prose text-sm leading-7 break-words text-base-content/70 [&_p]:mb-3">{$game['description']}</div>
      {/if}
      <div class="flex flex-wrap items-center gap-3 pt-1">
        <span class="text-sm font-semibold">{__("Share")}</span>
        <div class="flex flex-wrap items-center gap-2">
          {include file='__social_share.tpl' _link="{$system['system_url']}/games/{$game['game_id']}/{$game['title_url']}"}
        </div>
      </div>
    </section>
    <!-- description -->

    <!-- details -->
    <aside class="flex flex-col gap-6">
      <div class="overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-100/70 p-2 backdrop-blur-md">
        <ul class="text-sm">
          <li class="flex items-center justify-between gap-3 px-5 py-3.5">
            <span class="text-base-content/60">{__("Players")}</span>
            <span class="font-medium">{$game['players']}</span>
          </li>
          <li class="flex items-center justify-between gap-3 px-5 py-3.5">
            <span class="text-base-content/60">{__("Genres")}</span>
            <span class="min-w-0 truncate font-medium" title="{if $game['genres_list']}{__($game['genres_list'][0]['genre_name'])}{else}{__("N/A")}{/if}">{if $game['genres_list']}{__($game['genres_list'][0]['genre_name'])}{else}{__("N/A")}{/if}</span>
          </li>
        </ul>
      </div>
      {include file='_ads.tpl'}
    </aside>
    <!-- details -->

  </div>

  {include file='__games_row.tpl' _title=__("More Like This") _icon="icon-[tabler--stack-2]" _link="" _games=$related}

</div>
<!-- game -->
