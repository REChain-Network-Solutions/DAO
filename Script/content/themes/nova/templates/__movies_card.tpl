<!-- movie card -->
<div class="group/movie min-w-0">
  <a class="relative block aspect-[2/3] overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-300" href="{$system['system_url']}/movie/{$_movie['movie_id']}/{$_movie['movie_url']}" aria-label="{$_movie['title']}">
    <img class="size-full object-cover transition-transform duration-500 group-hover/movie:scale-105" src="{$_movie['poster']}" alt="" loading="lazy">
    <span class="pointer-events-none absolute inset-0 bg-black/0 transition-colors duration-300 group-hover/movie:bg-black/40" aria-hidden="true"></span>
    {if $_movie['is_paid']}
      <span class="absolute end-2 top-2 flex items-center gap-1 rounded-xl bg-error px-2 py-1 text-[11px] font-medium text-error-content">
        <span class="icon-[tabler--lock] size-3" aria-hidden="true"></span>
        {__("Paid")}
      </span>
    {/if}
    <span class="pointer-events-none absolute start-1/2 top-1/2 flex size-12 -translate-x-1/2 -translate-y-1/2 scale-90 items-center justify-center rounded-full bg-black/20 text-white opacity-0 backdrop-blur-sm transition duration-300 group-hover/movie:scale-100 group-hover/movie:opacity-100 group-hover/movie:bg-black/25 rtl:translate-x-1/2" aria-hidden="true">
      <span class="icon-[tabler--player-play-filled] size-5"></span>
    </span>
  </a>
  <div class="mt-3 min-w-0">
    <a class="block truncate text-[15px] font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/movie/{$_movie['movie_id']}/{$_movie['movie_url']}" title="{$_movie['title']}">{$_movie['title']}</a>
    <div class="mt-1 flex items-center gap-1.5 text-[13px] text-base-content/60">
      <span>{if $_movie['release_year']}{$_movie['release_year']}{else}{__("N/A")}{/if}</span>
      <span aria-hidden="true">&middot;</span>
      <span class="flex items-center gap-1 font-medium text-base-content/70">
        <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
        {$_movie['views_text']}
      </span>
    </div>
  </div>
</div>
<!-- movie card -->
