<!-- toolbar -->
<div class="relative z-20 flex items-center gap-3">

  <div class="flex h-12 min-w-0 flex-1 items-center rounded-2xl bg-base-100 pe-1.5 focus-within:ring-1 focus-within:ring-primary">
    <form class="js_search-form min-w-0 grow" data-handle="movies" role="search">
      <label class="input h-11 w-full border-0 bg-transparent px-4 shadow-none outline-none!">
        <span class="icon-[tabler--search] my-auto me-3 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
        <input type="search" class="grow" name="query" placeholder='{__("Movies, genres, stars...")}' aria-label='{__("Search for movies")}' {if $view == "search"}value="{$query}"{/if}>
      </label>
    </form>
    {if $genres}
      <span class="h-6 w-px shrink-0 bg-base-300" aria-hidden="true"></span>
      <div class="dropdown relative ms-1.5 inline-flex shrink-0 [--placement:bottom-end]">
        <button id="movies-genres-filter" type="button" class="dropdown-toggle flex size-9 items-center justify-center rounded-xl text-base-content/60 transition hover:bg-base-content/10 hover:text-base-content" aria-haspopup="menu" aria-expanded="false" aria-label='{__("Genres")}'>
          <span class="icon-[tabler--adjustments-horizontal] size-5" aria-hidden="true"></span>
        </button>
        <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 min-w-52 overflow-y-auto p-1" role="menu" aria-labelledby="movies-genres-filter">
          <a class="dropdown-item{if $view != "genre"} dropdown-active{else} text-inherit!{/if}" role="menuitem" href="{$system['system_url']}/movies">{__("All Genres")}</a>
          {foreach $genres as $_genre}
            <a class="dropdown-item{if $view == "genre" && $genre['genre_id'] == $_genre['genre_id']} dropdown-active{else} text-inherit!{/if}" role="menuitem" href="{$system['system_url']}/movies/genre/{$_genre['genre_id']}/{$_genre['genre_url']}">{__($_genre['genre_name'])}</a>
          {/foreach}
        </div>
      </div>
    {/if}
  </div>

</div>
<!-- toolbar -->
