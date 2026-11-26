{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  {if $view == "movie"}

    {include file='__movies_movie.tpl'}

  {else}

    <!-- page heading -->
    {if $view == "genre"}
      {include file='__page_header.tpl' _title=__($genre['genre_name']) _text=__($genre['genre_description']) _image="movies.svg"}
    {else}
      {include file='__page_header.tpl' _title=__("Movies") _text=__($system['system_description_movies']) _image="movies.svg"}
    {/if}
    <!-- page heading -->

    <div class="mt-6 grid grid-cols-[minmax(0,1fr)] gap-6 lg:grid-cols-[15rem_minmax(0,1fr)] lg:gap-8 lg:items-start">

      <aside class="min-w-0 lg:sticky lg:top-24">
        {include file='__movies_rail.tpl'}
      </aside>

      <div class="flex min-w-0 flex-col gap-7">

        {include file='__movies_toolbar.tpl'}

        {if $home}

          {include file='__movies_hero.tpl'}

          {include file='__movies_genres.tpl'}

          {if $ads}
            <div class="flex flex-col gap-4">
              {include file='_ads.tpl'}
            </div>
          {/if}

          {include file='__movies_row.tpl' _title=__("Trending Now") _icon="icon-[tabler--flame]" _link="`$system['system_url']`/movies?filter=trending" _movies=$row_trending}
          {include file='__movies_row.tpl' _title=__("Recently Added") _icon="icon-[tabler--sparkles]" _link="" _movies=$row_recent}
          {foreach $genre_rows as $_row}
            {include file='__movies_row.tpl' _title=__($_row['genre']['genre_name']) _icon="icon-[tabler--movie]" _link="`$system['system_url']`/movies/genre/`$_row['genre']['genre_id']`/`$_row['genre']['genre_url']`" _movies=$_row['movies']}
          {/foreach}

        {else}

          {include file='__movies_genres.tpl'}

          {if $ads}
            <div class="flex flex-col gap-4">
              {include file='_ads.tpl'}
            </div>
          {/if}

          {if $view == "search"}
            <section class="flex min-w-0 flex-col gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-100 p-4 sm:flex-row sm:items-center sm:justify-between sm:px-5" aria-labelledby="movies-search-title">
              <div class="flex min-w-0 items-center gap-3.5">
                <span class="flex size-11 shrink-0 items-center justify-center rounded-2xl bg-primary/10 text-primary" aria-hidden="true">
                  <span class="icon-[tabler--search] size-5"></span>
                </span>
                <div class="min-w-0">
                  <h2 class="text-base font-semibold" id="movies-search-title">{__("Search Results")}</h2>
                  <p class="mt-1 text-sm leading-relaxed break-words text-base-content/60">
                    {__("Search for")} <span class="font-medium text-base-content">&ldquo;{$query}&rdquo;</span>
                  </p>
                </div>
              </div>
              <div class="flex shrink-0 items-center gap-2.5 self-start rounded-xl bg-primary/10 px-3.5 py-2 text-primary sm:self-center">
                <span class="icon-[tabler--movie] size-4" aria-hidden="true"></span>
                <span class="text-lg leading-none font-bold tabular-nums">{$total}</span>
                <span class="text-xs font-medium">{__("Movies")}</span>
              </div>
            </section>
          {/if}

          <!-- movies -->
          {if $movies}
            <ul class="grid grid-cols-2 gap-x-4 gap-y-7 sm:grid-cols-3 xl:grid-cols-5">
              {foreach $movies as $_movie}
                <li class="min-w-0">
                  {include file='__movies_card.tpl' _movie=$_movie}
                </li>
              {/foreach}
            </ul>

            {if $pager}
              <div class="mt-2">{$pager}</div>
            {/if}
          {else}
            <div class="card border border-base-300 bg-base-100 shadow-none">
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--movie]"}
            </div>
          {/if}
          <!-- movies -->

        {/if}

      </div>

    </div>

  {/if}

</div>
<!-- page content -->

{include file='_footer.tpl'}
