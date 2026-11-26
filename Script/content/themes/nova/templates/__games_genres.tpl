{if $genres}
  <!-- genres dropdown -->
  <div class="dropdown relative z-20 flex w-full sm:hidden [--placement:bottom-start] [--strategy:absolute]">
    <button id="games-genres-dropdown" type="button" class="dropdown-toggle flex h-11 w-full items-center gap-3 rounded-2xl bg-base-100 px-4 text-sm font-medium text-base-content transition hover:bg-base-300" aria-haspopup="menu" aria-expanded="false">
      <span class="icon-[tabler--category-2] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
      <span class="min-w-0 grow truncate text-start" title="{if $view == "genre"}{__($genre['genre_name'])}{else}{__("Genres")}{/if}">{if $view == "genre"}{__($genre['genre_name'])}{else}{__("Genres")}{/if}</span>
      <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
    </button>
    <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 w-full overflow-y-auto p-1" role="menu" aria-labelledby="games-genres-dropdown">
      <a class="dropdown-item{if $view != "genre"} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$system['system_url']}/games">{__("All")}</a>
      {foreach $genres as $_genre}
        <a class="dropdown-item{if $view == "genre" && $genre['genre_id'] == $_genre['genre_id']} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$system['system_url']}/games/genre/{$_genre['genre_id']}/{$_genre['genre_url']}">
          <span class="truncate" title="{__($_genre['genre_name'])}">{__($_genre['genre_name'])}</span>
        </a>
      {/foreach}
    </div>
  </div>
  <!-- genres dropdown -->

  <!-- genres -->
  <div class="js_chips flex items-center gap-2.5 max-sm:hidden" role="navigation" aria-label='{__("Genres")}'>

    <div class="js_chips-strip flex min-w-0 flex-1 items-center gap-2.5 overflow-hidden scroll-smooth [-webkit-mask-image:linear-gradient(to_right,#000_calc(100%-4rem),transparent)] [mask-image:linear-gradient(to_right,#000_calc(100%-4rem),transparent)] rtl:[-webkit-mask-image:linear-gradient(to_left,#000_calc(100%-4rem),transparent)] rtl:[mask-image:linear-gradient(to_left,#000_calc(100%-4rem),transparent)]">
      <a class="flex h-11 shrink-0 items-center rounded-2xl px-6 text-sm font-medium transition {if $view == ""}bg-primary text-primary-content!{else}bg-base-100 text-base-content! hover:bg-base-300{/if}" href="{$system['system_url']}/games" {if $view == ""}aria-current="page"{/if}>{__("All")}</a>
      {foreach $genres as $_genre}
        <a class="flex h-11 shrink-0 items-center rounded-2xl px-6 text-sm font-medium transition {if $view == "genre" && $genre['genre_id'] == $_genre['genre_id']}bg-primary text-primary-content!{else}bg-base-100 text-base-content! hover:bg-base-300{/if}" href="{$system['system_url']}/games/genre/{$_genre['genre_id']}/{$_genre['genre_url']}" {if $view == "genre" && $genre['genre_id'] == $_genre['genre_id']}aria-current="page"{/if}>{__($_genre['genre_name'])}</a>
      {/foreach}
    </div>

    <!-- arrows -->
    <div class="js_chips-nav flex shrink-0 items-center gap-2 max-sm:hidden data-[scrollable=false]:hidden" data-scrollable="false">
      <button type="button" class="js_chips-prev flex h-11 w-12 items-center justify-center rounded-2xl bg-base-100 text-base-content transition hover:bg-base-300 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Previous")}'>
        <span class="icon-[tabler--chevron-left] size-5 rtl:rotate-180" aria-hidden="true"></span>
      </button>
      <button type="button" class="js_chips-next flex h-11 w-12 items-center justify-center rounded-2xl bg-base-100 text-base-content transition hover:bg-base-300 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Next")}'>
        <span class="icon-[tabler--chevron-right] size-5 rtl:rotate-180" aria-hidden="true"></span>
      </button>
    </div>
    <!-- arrows -->

  </div>
  <!-- genres -->
{/if}
