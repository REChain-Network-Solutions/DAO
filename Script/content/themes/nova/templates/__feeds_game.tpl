{if $_tpl != "list"}
  <li class="group flex min-w-0 flex-col">
    <a class="relative block aspect-video overflow-hidden rounded-2xl bg-base-200" href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}" aria-label="{$_game['title']}">
      <img class="size-full object-cover transition-transform duration-500 group-hover:scale-105" alt="" src="{$_game['thumbnail']}" loading="lazy">
      <span class="pointer-events-none absolute inset-0 bg-linear-to-t from-black/70 via-black/10 to-transparent opacity-0 transition-opacity duration-300 group-hover:opacity-100" aria-hidden="true"></span>
      <span class="pointer-events-none absolute start-1/2 top-1/2 flex size-12 -translate-x-1/2 -translate-y-1/2 scale-90 items-center justify-center rounded-full bg-primary text-primary-content opacity-0 shadow-lg transition duration-300 group-hover:scale-100 group-hover:opacity-100 rtl:translate-x-1/2" aria-hidden="true">
        <span class="icon-[tabler--player-play-filled] size-5"></span>
      </span>
    </a>
    <div class="mt-3 flex items-center gap-3">
      <div class="min-w-0 grow">
        <a class="block truncate font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}" title="{$_game['title']}">{$_game['title']}</a>
        {if $_game['played']}
          <span class="mt-0.5 flex items-center gap-1 text-xs text-base-content/60">
            <span class="icon-[tabler--clock] size-3.5 shrink-0" aria-hidden="true"></span>
            <span>{__("Played")} <span class="js_moment" data-time="{$_game['last_played_time']}">{$_game['last_played_time']}</span></span>
          </span>
        {/if}
      </div>
      <a class="heroui button button--tertiary text-base-content button--sm shrink-0 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}">{__("Play")}</a>
    </div>
  </li>
{elseif $_tpl == "list"}
  <li class="feeds-item flex items-center gap-3 border-b border-base-300 px-4 py-3 last:border-0">
    <a class="shrink-0" href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}">
      <img class="{if $_small}size-10{else}size-12{/if} rounded-box object-cover" src="{$_game['thumbnail']}" alt="{$_game['title']}">
    </a>
    <div class="min-w-0 flex-1">
      <span class="name block min-w-0">
        <a class="block truncate font-medium text-base-content! hover:text-primary!" href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}" title="{$_game['title']}">{$_game['title']}</a>
      </span>
    </div>
    <div class="ms-auto flex shrink-0 flex-wrap items-center gap-2">
      <a class="heroui button button--primary button--sm" href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}">{__("Play")}</a>
    </div>
  </li>
{/if}
