<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-games-title">
  {if $sub_view == "add" || $sub_view == "edit" || $sub_view == "add_genre" || $sub_view == "edit_genre"}
    <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
  {/if}

  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-games-title" class="text-2xl font-semibold">
        {if $sub_view == "find"}{__("Find Games")}
        {elseif $sub_view == "genres"}{__("Game Genres")}
        {elseif $sub_view == "add"}{__("Add New Game")}
        {elseif $sub_view == "edit"}{__("Edit Game")}
        {elseif $sub_view == "add_genre"}{__("Add New Genre")}
        {elseif $sub_view == "edit_genre"}{__("Edit Genre")}
        {else}{__("Games")}{/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "find"}{__("Search results for game names and descriptions.")}
        {elseif $sub_view == "genres"}{__("Organize games into genres that are easy to browse.")}
        {elseif $sub_view == "add"}{__("Add a game to the library and place it under its genres.")}
        {elseif $sub_view == "edit"}{__("Update this game details, genres, and thumbnail.")}
        {elseif $sub_view == "add_genre"}{__("Create a genre to group games in the games directory.")}
        {elseif $sub_view == "edit_genre"}{__("Update this genre and its position in the games directory.")}
        {else}{__("Manage your games library, genres, and players.")}{/if}
      </p>
    </div>

    <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
      {if $sub_view == ""}
        <a href="{$system['system_url']}/{$control_panel['url']}/games/add" class="btn btn-primary"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Game")}</a>
      {elseif $sub_view == "find"}
        <a href="{$system['system_url']}/{$control_panel['url']}/games" class="btn btn-outline"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
      {elseif $sub_view == "genres"}
        <a href="{$system['system_url']}/{$control_panel['url']}/games/add_genre" class="btn btn-primary"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Genre")}</a>
      {elseif $sub_view == "add" || $sub_view == "edit"}
        <a href="{$system['system_url']}/{$control_panel['url']}/games" class="btn btn-outline"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
      {elseif $sub_view == "add_genre" || $sub_view == "edit_genre"}
        <a href="{$system['system_url']}/{$control_panel['url']}/games/genres" class="btn btn-outline"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
      {/if}
    </div>
  </header>

  {if $sub_view == "" || $sub_view == "find"}
    {if $sub_view == ""}
      <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-info icon-[tabler--device-gamepad-2] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Total Games")}">{__("Total Games")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['games']|number_format}</p></div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-neutral icon-[tabler--tags] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Genres")}">{__("Genres")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['genres']|number_format}</p></div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-success icon-[tabler--users] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Players")}">{__("Players")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['players']|number_format}</p></div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-warning icon-[tabler--player-play] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Played Games")}">{__("Played Games")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['played']|number_format}</p></div>
        </article>
      </div>
    {/if}

    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Games")}">
      <div class="js-flyonui-datatable-toolbar flex items-center justify-between gap-3 border-b border-base-300 px-5 py-3 max-md:flex-wrap">
        <form class="input max-w-72" action="{$system['system_url']}/{$control_panel['url']}/games/find" method="get" role="search">
          <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
          <input type="search" class="grow" name="query" id="admin-games-query" value="{if $query}{$query}{/if}" placeholder="{__("Search")}" title="{__("Search by Game Name or Description")}" aria-label="{__("Search by Game Name or Description")}" autocomplete="off">
        </form>
      </div>

      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead><tr><th>{__("Game")}</th><th>{__("Genres")}</th><th>{__("Players")}</th><th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th></tr></thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/games/{$row['game_id']}/{$row['title_url']}">
                      <img class="admin-list-avatar size-[38px] shrink-0 rounded-md border border-base-300 object-cover" src="{$row['thumbnail']}" alt="" width="38" height="38" loading="lazy">
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5"><span class="admin-list-name truncate text-sm font-semibold" title="{$row['title']}">{$row['title']}</span><span class="admin-list-id text-xs">#{$row['game_id']}</span></span>
                    </a>
                  </td>
                  <td>
                    <div class="flex max-w-64 flex-wrap items-center gap-1">
                      {foreach $row['genres_list'] as $genre}
                        {if $genre@index < 3}<span class="badge badge-soft badge-primary badge-sm rounded-full">{__($genre)}</span>{/if}
                      {foreachelse}
                        <span class="text-base-content/60">{__("N/A")}</span>
                      {/foreach}
                      {if count($row['genres_list']) > 3}<span class="badge badge-soft badge-sm rounded-full">+{count($row['genres_list']) - 3}</span>{/if}
                    </div>
                  </td>
                  <td><span class="tabular-nums">{$row['players']|number_format}</span></td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="game-actions-{$row['game_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['title']}"><span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span></button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="game-actions-{$row['game_id']}">
                        <li><a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/games/{$row['game_id']}/{$row['title_url']}"><span class="icon-[tabler--arrow-up-right] size-4" aria-hidden="true"></span>{__("View Game")}</a></li>
                        <li><a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/games/edit/{$row['game_id']}"><span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>{__("Edit")}</a></li>
                        <li><button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="game" data-id="{$row['game_id']}"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Delete")}</button></li>
                      </ul>
                    </div>
                  </td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
        {if $pager}<div class="admin-list-pager">{$pager}</div>{/if}
      {else}
        <div class="admin-list-empty admin-list-empty-inline flex min-h-64 flex-col items-center justify-center px-6 py-10 text-center" aria-labelledby="admin-games-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200"><span class="icon-[tabler--device-gamepad-2] size-6" aria-hidden="true"></span></div>
          <h2 id="admin-games-empty-title">{__("No games found")}</h2>
          <p>{if $sub_view == "find"}{__("Try another game name or description.")}{else}{__("Games you add to the library will appear here.")}{/if}</p>
          {if $sub_view != "find"}<a href="{$system['system_url']}/{$control_panel['url']}/games/add" class="btn btn-primary btn-sm"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Game")}</a>{/if}
        </div>
      {/if}
    </section>

  {elseif $sub_view == "genres"}
    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Game Genres")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead><tr><th>{__("Genre")}</th><th>{__("Description")}</th><th>{__("Order")}</th><th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th></tr></thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td><span class="admin-list-group-title text-sm font-semibold">{__($row['genre_name'])}</span></td>
                  <td>{$row['genre_description']|truncate:50}</td>
                  <td><span class="badge badge-soft badge-primary badge-sm rounded-full">{$row['genre_order']}</span></td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="genre-actions-{$row['genre_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['genre_name']}"><span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span></button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="genre-actions-{$row['genre_id']}">
                        <li><a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/games/edit_genre/{$row['genre_id']}"><span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>{__("Edit")}</a></li>
                        <li><button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="game_genre" data-id="{$row['genre_id']}"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Delete")}</button></li>
                      </ul>
                    </div>
                  </td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
      </section>
    {else}
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-game-genres-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200"><span class="icon-[tabler--tags-off] size-6" aria-hidden="true"></span></div>
        <h2 id="admin-game-genres-empty-title">{__("No genres yet")}</h2>
        <p>{__("Add a genre to organize games in the directory.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/games/add_genre" class="btn btn-primary btn-sm"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Genre")}</a>
      </section>
    {/if}

  {elseif $sub_view == "add" || $sub_view == "edit"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/games.php?do={if $sub_view == "edit"}edit&amp;id={$data['game_id']}{else}add{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="game-details-title">
          <h2 id="game-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--device-gamepad-2] size-5" aria-hidden="true"></span>{__("Game Details")}</h2>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="game-title">{__("Name")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input class="input w-full" name="title" id="game-title" value="{if $sub_view == "edit"}{$data['title']}{/if}" autocomplete="off"></div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="game-description">{__("Description")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><textarea class="textarea w-full" name="description" id="game-description" rows="4">{if $sub_view == "edit"}{$data['description']}{/if}</textarea></div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="game-genres-label">
            <div class="label-text" id="game-genres-label">{__("Genres")}</div>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <div class="grid min-w-0 gap-1 sm:grid-cols-2">
                {if $sub_view == "edit"}
                  {foreach $data['games_genres'] as $genre}
                    <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                      <input type="checkbox" class="checkbox checkbox-primary" name="game_genres[]" id="game-genre-{$genre['genre_id']}" value="{$genre['genre_id']}" {if in_array($genre['genre_id'], $data['genres'])}checked{/if}>
                      <label class="label-text" for="game-genre-{$genre['genre_id']}">{__($genre['genre_name'])}</label>
                    </div>
                  {foreachelse}
                    <div class="admin-setting-help text-sm leading-relaxed">{__("You have to add genres first")} <a class="link link-primary" href="{$system['system_url']}/{$control_panel['url']}/games/add_genre">{__("Add New Genre")}</a></div>
                  {/foreach}
                {else}
                  {foreach $genres as $genre}
                    <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                      <input type="checkbox" class="checkbox checkbox-primary" name="game_genres[]" id="game-genre-{$genre['genre_id']}" value="{$genre['genre_id']}">
                      <label class="label-text" for="game-genre-{$genre['genre_id']}">{__($genre['genre_name'])}</label>
                    </div>
                  {foreachelse}
                    <div class="admin-setting-help text-sm leading-relaxed">{__("You have to add genres first")} <a class="link link-primary" href="{$system['system_url']}/{$control_panel['url']}/games/add_genre">{__("Add New Genre")}</a></div>
                  {/foreach}
                {/if}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="game-source">{__("Game Source")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <textarea class="textarea w-full" name="source" id="game-source" rows="3">{if $sub_view == "edit"}{$data['source']}{/if}</textarea>
              <div class="admin-setting-help text-sm leading-relaxed">{__("The source link of your embedded game")}</div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="game-thumbnail-label">
            <div class="label-text" id="game-thumbnail-label">{__("Thumbnail")}</div>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if $sub_view == "edit" && $data['thumbnail'] != ''}
                {include file='__x_image.tpl' _x_name="thumbnail" _x_value=$data['thumbnail'] _x_fit="contain"}
              {else}
                {include file='__x_image.tpl' _x_name="thumbnail" _x_fit="contain"}
              {/if}
            </div>
          </div>
        </div>
        <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
          <div class="admin-settings-feedback w-full min-w-0" aria-live="polite"><div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div><div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div></div>
          <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2"><button type="submit" class="btn btn-primary">{__("Save Changes")}</button></div>
        </div>
      </section>
    </form>

  {elseif $sub_view == "add_genre" || $sub_view == "edit_genre"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/games.php?do={if $sub_view == "edit_genre"}edit_genre&amp;id={$data['genre_id']}{else}add_genre{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="game-genre-details-title">
          <h2 id="game-genre-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--tags] size-5" aria-hidden="true"></span>{__("Genre Details")}</h2>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="game-genre-name">{__("Name")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input class="input w-full" name="genre_name" id="game-genre-name" value="{if $sub_view == "edit_genre"}{$data['genre_name']}{/if}" autocomplete="off"></div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="game-genre-description">{__("Description")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><textarea class="textarea w-full" name="genre_description" id="game-genre-description" rows="4">{if $sub_view == "edit_genre"}{$data['genre_description']}{/if}</textarea></div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="game-genre-order">{__("Order")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input class="input w-full" name="genre_order" id="game-genre-order" value="{if $sub_view == "edit_genre"}{$data['genre_order']}{/if}" inputmode="numeric"><div class="admin-setting-help text-sm leading-relaxed">{__("Lower numbers appear first.")}</div></div>
          </div>
        </div>
        <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
          <div class="admin-settings-feedback w-full min-w-0" aria-live="polite"><div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div><div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div></div>
          <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2"><button type="submit" class="btn btn-primary">{__("Save Changes")}</button></div>
        </div>
      </section>
    </form>
  {/if}

  {if $sub_view == "add" || $sub_view == "edit" || $sub_view == "add_genre" || $sub_view == "edit_genre"}
    </div>
  {/if}
</section>
