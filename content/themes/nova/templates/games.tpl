{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  {if $view == "game"}

    {include file='__games_game.tpl'}

  {else}

    <!-- page heading -->
    {if $view == "genre"}
      {include file='__page_header.tpl' _title=__($genre['genre_name']) _text=__($genre['genre_description']) _image="games.svg"}
    {elseif $view == "played"}
      {include file='__page_header.tpl' _title=__("Your Games") _text=__($system['system_description_games']) _image="games.svg"}
    {else}
      {include file='__page_header.tpl' _title=__("Games") _text=__($system['system_description_games']) _image="games.svg"}
    {/if}
    <!-- page heading -->

    <div class="mt-6 grid grid-cols-[minmax(0,1fr)] gap-6 lg:grid-cols-[15rem_minmax(0,1fr)] lg:gap-8 lg:items-start">

      <aside class="min-w-0 relative z-10 lg:sticky lg:top-24">
        {include file='__games_rail.tpl'}
      </aside>

      <div class="relative isolate flex min-w-0 flex-col gap-7">

        {include file='__games_toolbar.tpl'}

        {if $home}

          {include file='__games_hero.tpl'}

          <div class="relative z-10 flex min-w-0 flex-col gap-7">
            {include file='__games_genres.tpl'}

            {if $ads}
              <div class="flex flex-col gap-4">
                {include file='_ads.tpl'}
              </div>
            {/if}

            {include file='__games_row.tpl' _title=__("Recommended for you") _icon="icon-[tabler--flame]" _link="`$system['system_url']`/games?filter=popular" _games=$row_popular}
            {include file='__games_row.tpl' _title=__("Recently Added") _icon="icon-[tabler--sparkles]" _link="" _games=$row_recent}
            {if $user->_logged_in}
              {include file='__games_row.tpl' _title=__("Your Games") _icon="icon-[tabler--history]" _link="`$system['system_url']`/games/played" _games=$row_played}
            {/if}
            {foreach $genre_rows as $_row}
              {include file='__games_row.tpl' _title=__($_row['genre']['genre_name']) _icon="icon-[tabler--device-gamepad-2]" _link="`$system['system_url']`/games/genre/`$_row['genre']['genre_id']`/`$_row['genre']['genre_url']`" _games=$_row['games']}
            {/foreach}
          </div>

        {else}

          {include file='__games_genres.tpl'}

          {if $ads}
            <div class="flex flex-col gap-4">
              {include file='_ads.tpl'}
            </div>
          {/if}

          {if $view == "search"}
            <section class="flex min-w-0 flex-col gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-100 p-4 sm:flex-row sm:items-center sm:justify-between sm:px-5" aria-labelledby="games-search-title">
              <div class="flex min-w-0 items-center gap-3.5">
                <span class="flex size-11 shrink-0 items-center justify-center rounded-2xl bg-primary/10 text-primary" aria-hidden="true">
                  <span class="icon-[tabler--search] size-5"></span>
                </span>
                <div class="min-w-0">
                  <h2 class="text-base font-semibold" id="games-search-title">{__("Search Results")}</h2>
                  <p class="mt-1 text-sm leading-relaxed break-words text-base-content/60">
                    {__("Search for")} <span class="font-medium text-base-content">&ldquo;{$query}&rdquo;</span>
                  </p>
                </div>
              </div>
              <div class="flex shrink-0 items-center gap-2.5 self-start rounded-xl bg-primary/10 px-3.5 py-2 text-primary sm:self-center">
                <span class="icon-[tabler--device-gamepad-2] size-4" aria-hidden="true"></span>
                <span class="text-lg leading-none font-bold tabular-nums">{$total}</span>
                <span class="text-xs font-medium">{__("Games")}</span>
              </div>
            </section>
          {/if}

          <!-- games -->
          {if $games}
            <ul class="grid grid-cols-1 gap-x-4 gap-y-7 sm:grid-cols-2 xl:grid-cols-3">
              {foreach $games as $_game}
                <li class="min-w-0">
                  {include file='__games_card.tpl' _game=$_game}
                </li>
              {/foreach}
            </ul>

            {if $pager}
              <div class="mt-2">{$pager}</div>
            {/if}
          {else}
            <div class="card border border-base-300 bg-base-100 shadow-none">
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--device-gamepad-2]"}
            </div>
          {/if}
          <!-- games -->

        {/if}

      </div>

    </div>

  {/if}

</div>
<!-- page content -->

{include file='_footer.tpl'}
