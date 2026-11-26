<!-- movie -->
<div class="relative isolate flex min-w-0 flex-col gap-7 p-4 text-base-content sm:p-6 xl:p-8">

  <!-- backdrop -->
  <div class="pointer-events-none absolute inset-0 -z-10 overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[3rem] bg-base-200" aria-hidden="true">
    <img class="absolute inset-0 size-full scale-110 object-cover blur-3xl" src="{$movie['poster']}" alt="">
    <span class="absolute inset-0 bg-linear-to-b from-base-200/80 via-base-200/90 to-base-200 to-85% dark:from-base-200/55 dark:via-base-200/80"></span>
  </div>
  <!-- backdrop -->

  <!-- breadcrumb -->
  <nav class="breadcrumbs min-w-0 self-start rounded-2xl bg-base-100/70 p-1.5 text-sm ring-1 ring-inset ring-base-content/5 backdrop-blur-md" aria-label='{__("Breadcrumb")}'>
    <ol class="min-w-0 p-0">
      <li class="shrink-0">
        <a class="h-10 gap-2 rounded-xl px-2 font-medium text-base-content/70! transition-colors hover:bg-base-300 hover:text-base-content!" href="{$system['system_url']}/movies">
          <span class="flex size-7 items-center justify-center rounded-lg bg-primary/10 text-primary" aria-hidden="true">
            <span class="icon-[tabler--movie] size-4"></span>
          </span>
          {__("Movies")}
        </a>
      </li>
      {if $movie['genres_list']}
        <li class="breadcrumbs-separator max-sm:hidden rtl:rotate-180" aria-hidden="true"><span class="icon-[tabler--chevron-right] size-3.5"></span></li>
        <li class="min-w-0 max-sm:hidden">
          <a class="h-10 min-w-0 rounded-xl px-2 text-base-content/60! transition-colors hover:bg-base-300 hover:text-base-content!" href="{$system['system_url']}/movies/genre/{$movie['genres_list'][0]['genre_id']}/{$movie['genres_list'][0]['genre_url']}">
            <span class="max-w-40 truncate" title="{__($movie['genres_list'][0]['genre_name'])}">{__($movie['genres_list'][0]['genre_name'])}</span>
          </a>
        </li>
      {/if}
      <li class="breadcrumbs-separator rtl:rotate-180" aria-hidden="true"><span class="icon-[tabler--chevron-right] size-3.5"></span></li>
      <li class="min-w-0 pe-3 font-semibold" aria-current="page">
        <span class="max-w-[min(22rem,45vw)] truncate" title="{$movie['title']}">{$movie['title']}</span>
      </li>
    </ol>
  </nav>
  <!-- breadcrumb -->

  <!-- movie heading -->
  <section aria-labelledby="movie-title">
    <div class="flex flex-col gap-6 sm:flex-row sm:items-end xl:gap-8">
      <img class="aspect-[2/3] w-32 shrink-0 self-start rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-black/20 object-contain shadow-xl sm:w-40 xl:w-48" src="{$movie['poster']}" alt="{$movie['title']}">
      <div class="flex min-w-0 flex-1 flex-col gap-4">
        <div class="flex flex-wrap items-center gap-2">
          {if $movie['duration_text']}
            <span class="rounded-2xl bg-base-100/60 px-3 py-1.5 text-xs font-medium backdrop-blur-md sm:text-sm">{$movie['duration_text']}</span>
          {/if}
          {if $movie['release_year']}
            <span class="rounded-2xl bg-base-100/60 px-3 py-1.5 text-xs font-medium backdrop-blur-md sm:text-sm">{$movie['release_year']}</span>
          {/if}
          <span class="flex items-center gap-1.5 rounded-2xl bg-base-100/60 px-3 py-1.5 text-xs font-medium backdrop-blur-md sm:text-sm">
            <span class="icon-[tabler--eye] size-3.5" aria-hidden="true"></span>
            {$movie['views_text']}
          </span>
          {if $movie['is_paid']}
            <span class="flex items-center gap-1.5 rounded-2xl bg-error px-3 py-1.5 text-xs font-medium text-error-content sm:text-sm">
              <span class="icon-[tabler--lock] size-4" aria-hidden="true"></span>
              {__("Paid")}
            </span>
          {/if}
        </div>
        <h1 class="max-w-2xl text-2xl font-bold tracking-tight break-words sm:text-3xl xl:text-4xl" id="movie-title">{$movie['title']}</h1>
        {if $movie['can_watch']}
          <a class="group/watch mt-1 inline-flex w-fit items-center gap-3.5 rounded-full text-base-content! focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-primary" href="#movie-player">
            <span class="flex size-12 shrink-0 items-center justify-center rounded-full bg-base-content/10 backdrop-blur-sm transition group-hover/watch:bg-base-content/15 sm:size-14" aria-hidden="true">
              <span class="icon-[tabler--player-play-filled] size-5"></span>
            </span>
            <span class="text-base font-bold">{__("Watch now")}</span>
          </a>
        {/if}
      </div>
    </div>
  </section>
  <!-- movie heading -->

  {if $movie['genres_list']}
    <!-- genres -->
    <nav class="flex flex-wrap gap-2.5" aria-label='{__("Genres")}'>
      {foreach $movie['genres_list'] as $_genre}
        <a class="flex min-h-11 items-center rounded-2xl bg-base-100/70 px-6 py-2 text-sm font-medium text-base-content! backdrop-blur-md transition hover:bg-base-300" href="{$system['system_url']}/movies/genre/{$_genre['genre_id']}/{$_genre['genre_url']}">{__($_genre['genre_name'])}</a>
      {/foreach}
    </nav>
    <!-- genres -->
  {/if}

  <!-- player -->
  <section class="flex scroll-mt-24 flex-col gap-4" id="movie-player" aria-labelledby="movie-player-title">
    <h2 class="flex items-center gap-2.5 text-lg font-semibold" id="movie-player-title">
      <span class="icon-[tabler--player-play] size-5 text-base-content/60" aria-hidden="true"></span>
      {__("Watch now")}
    </h2>
    {if $movie['can_watch']}
      <div class="overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-black">
        {if $movie['source_type'] == "youtube"}
          {if $system['smart_yt_player']}
            <div class="youtube-player js_youtube-player relative aspect-video cursor-pointer overflow-hidden bg-black [&>iframe]:size-full" data-id="{get_youtube_id($movie['source'])}">
              <img class="size-full object-cover" src="https://i.ytimg.com/vi/{get_youtube_id($movie['source'])}/hqdefault.jpg" alt="">
              <button type="button" class="play absolute inset-0 flex items-center justify-center text-white focus-visible:outline-2 focus-visible:-outline-offset-4 focus-visible:outline-white" aria-label='{__("Watch now")}'>
                <span class="flex size-16 items-center justify-center rounded-full bg-white/20 backdrop-blur-sm transition hover:bg-white/25" aria-hidden="true"><span class="icon-[tabler--player-play-filled] size-6"></span></span>
              </button>
            </div>
          {elseif $system['disable_yt_player']}
            <div class="plyr__video-embed js_video-plyr-youtube" data-plyr-provider="youtube" data-plyr-embed-id="{get_youtube_id($movie['source'])}"></div>
          {else}
            <div class="aspect-video [&>iframe]:size-full">
              <iframe src="https://www.youtube.com/embed/{get_youtube_id($movie['source'])}" title="{$movie['title']}" frameborder="0" allow="autoplay; fullscreen" allowfullscreen referrerpolicy="strict-origin-when-cross-origin"></iframe>
            </div>
          {/if}
        {elseif $movie['source_type'] == "vimeo"}
          <div class="aspect-video [&>iframe]:size-full">
            <iframe src="https://player.vimeo.com/video/{get_vimeo_id($movie['source'])}" title="{$movie['title']}" frameborder="0" allow="autoplay; fullscreen" allowfullscreen referrerpolicy="strict-origin-when-cross-origin"></iframe>
          </div>
        {elseif $movie['source_type'] == "link"}
          <video class="js_video-plyr w-full" id="video-{$movie['movie_id']}" playsinline controls preload="false">
            <source src="{$movie['source']}" type="video/mp4">
            <source src="{$movie['source']}" type="video/webm">
          </video>
        {elseif $movie['source_type'] == "uploaded"}
          <video class="js_video-plyr w-full" id="video-{$movie['movie_id']}" playsinline controls preload="false">
            <source src="{$system['system_uploads']}/{$movie['source']}" type="video/mp4">
            <source src="{$system['system_uploads']}/{$movie['source']}" type="video/webm">
          </video>
        {/if}
      </div>
    {else}
      <!-- need payment -->
      <div class="relative isolate flex min-h-72 flex-col items-center justify-center gap-5 overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-300 px-5 py-10 text-center text-white sm:aspect-video">
        <img class="pointer-events-none absolute inset-0 size-full scale-110 object-cover blur-2xl" src="{$movie['poster']}" alt="" aria-hidden="true">
        <span class="pointer-events-none absolute inset-0 bg-black/70" aria-hidden="true"></span>
        <span class="relative flex size-16 items-center justify-center rounded-full bg-white/20 backdrop-blur-sm" aria-hidden="true">
          <span class="icon-[tabler--lock] size-7"></span>
        </span>
        <span class="relative text-lg font-semibold">{__("PAID CONTENT")}</span>
        {if $licence_monetization && is_file('includes/assets/js/core/payments.js')}
          <button type="button" class="js_modal heroui button button--primary relative h-auto min-h-12 max-w-full rounded-[1rem] px-6 py-3 whitespace-normal {if !$user->_logged_in}js_login{/if}" {if $user->_logged_in}  data-url="#payment" data-options='{ "handle": "movies", "id": {$movie['movie_id']}, "price": {$movie['price']}, "vat": "{get_payment_vat_value($movie['price'])}", "fees": "{get_payment_fees_value($movie['price'])}", "total": "{get_payment_total_value($movie['price'])}", "total_printed": "{get_payment_total_value($movie['price'], true)}" }' {/if}>
            <span class="icon-[tabler--credit-card] size-4" aria-hidden="true"></span>
            {__("PAY")} {print_money($movie['price'])} {__("TO WATCH FOR")} {$movie['available_for']} {__("DAYS")}
          </button>
        {/if}
      </div>
      <!-- need payment -->
    {/if}
  </section>
  <!-- player -->

  <div class="grid gap-7 xl:grid-cols-[minmax(0,1fr)_16rem] xl:items-start">

    <!-- description -->
    <section class="flex min-w-0 flex-col gap-5" aria-labelledby="movie-description-title">
      <h2 class="flex items-center gap-2.5 text-lg font-semibold" id="movie-description-title">
        <span class="icon-[tabler--align-left] size-5 text-base-content/60" aria-hidden="true"></span>
        {__("Description")}
      </h2>
      {if $movie['description']}
        <div class="max-w-prose text-sm leading-7 break-words text-base-content/70 [&_p]:mb-3">{$movie['description']}</div>
      {/if}
      {if $movie['stars']}
        <div class="flex flex-col gap-2">
          <span class="text-sm font-semibold">{__("Stars")}</span>
          <div class="flex flex-wrap gap-2">
            {foreach split($movie['stars'], ',') as $_star}
              {if trim($_star)}
                <span class="rounded-2xl bg-base-100/70 px-3 py-2 text-sm text-base-content/70 backdrop-blur-md">
                  {trim($_star)}
                </span>
              {/if}
            {/foreach}
          </div>
        </div>
      {/if}
      <div class="flex flex-wrap items-center gap-3 pt-1">
        <span class="text-sm font-semibold">{__("Share")}</span>
        <div class="flex flex-wrap items-center gap-2">
          {include file='__social_share.tpl' _link="{$system['system_url']}/movie/{$movie['movie_id']}/{$movie['movie_url']}"}
        </div>
      </div>
    </section>
    <!-- description -->

    <!-- details -->
    <aside class="flex flex-col gap-6">
      <div class="overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-100/70 p-2 backdrop-blur-md">
        <ul class="text-sm">
          <li class="flex items-center justify-between gap-3 px-5 py-3.5">
            <span class="text-base-content/60">{__("Release")}</span>
            <span class="font-medium">{if $movie['release_year']}{$movie['release_year']}{else}{__("N/A")}{/if}</span>
          </li>
          <li class="flex items-center justify-between gap-3 px-5 py-3.5">
            <span class="text-base-content/60">{__("Duration")}</span>
            <span class="font-medium">{if $movie['duration_text']}{$movie['duration_text']}{else}{__("N/A")}{/if}</span>
          </li>
          <li class="flex items-center justify-between gap-3 px-5 py-3.5">
            <span class="text-base-content/60">{__("Views")}</span>
            <span class="font-medium">{$movie['views']}</span>
          </li>
          {if $movie['imdb_url']}
            <li class="px-5 py-3.5">
              <a class="heroui button button--tertiary button--sm w-full rounded-[1rem] border-0 bg-warning text-warning-content hover:bg-warning/90" href="{$movie['imdb_url']}" target="_blank" rel="noopener">
                <span class="icon-[tabler--star-filled] size-4" aria-hidden="true"></span>
                {__("IMDB")}
              </a>
            </li>
          {/if}
        </ul>
      </div>
      {include file='_ads.tpl'}
    </aside>
    <!-- details -->

  </div>

  {include file='__movies_row.tpl' _title=__("More Like This") _icon="icon-[tabler--stack-2]" _link="" _movies=$related}

</div>
<!-- movie -->
