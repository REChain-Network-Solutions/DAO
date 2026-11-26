<!-- game card -->
<div class="group/game min-w-0">
  <a class="relative block aspect-[16/10] overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-300" href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}" aria-label="{$_game['title']}">
    <img class="size-full object-cover transition-transform duration-500 group-hover/game:scale-105" src="{$_game['thumbnail']}" alt="" loading="lazy">
    <span class="pointer-events-none absolute inset-0 bg-black/0 transition-colors duration-300 group-hover/game:bg-black/40" aria-hidden="true"></span>
    <span class="pointer-events-none absolute start-1/2 top-1/2 flex size-12 -translate-x-1/2 -translate-y-1/2 scale-90 items-center justify-center rounded-full bg-black/20 text-white opacity-0 backdrop-blur-sm transition duration-300 group-hover/game:scale-100 group-hover/game:bg-black/25 group-hover/game:opacity-100 rtl:translate-x-1/2" aria-hidden="true">
      <span class="icon-[tabler--player-play-filled] size-5"></span>
    </span>
  </a>
  <div class="mt-3 min-w-0">
    <a class="block truncate text-[15px] font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}" title="{$_game['title']}">{$_game['title']}</a>
    <div class="mt-1 flex items-center gap-1.5 text-[13px] text-base-content/60">
      <span class="min-w-0 truncate" title="{if $_game['genres_list']}{__($_game['genres_list'][0]['genre_name'])}{else}{__("Games")}{/if}">{if $_game['genres_list']}{__($_game['genres_list'][0]['genre_name'])}{else}{__("Games")}{/if}</span>
      <span aria-hidden="true">&middot;</span>
      <span class="flex shrink-0 items-center gap-1 font-medium text-base-content/70">
        <span class="icon-[tabler--users] size-4" aria-hidden="true"></span>
        {$_game['players_text']}
      </span>
    </div>
  </div>
</div>
<!-- game card -->
