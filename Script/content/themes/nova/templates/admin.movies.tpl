<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-movies-title">
  {if in_array($sub_view, ["add_movie", "edit_movie", "add_genre", "edit_genre"])}
    <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
  {/if}

  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-movies-title" class="text-2xl font-semibold">
        {if $sub_view == "add_movie"}{__("Add New Movie")}
        {elseif $sub_view == "edit_movie"}{__("Edit Movie")}
        {elseif $sub_view == "genres"}{__("Movie Genres")}
        {elseif $sub_view == "add_genre"}{__("Add New Genre")}
        {elseif $sub_view == "edit_genre"}{__("Edit Genre")}
        {else}{__("Movies")}{/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "add_movie"}{__("Add a movie to your library and configure how viewers can access it.")}
        {elseif $sub_view == "edit_movie"}{__("Update this movie's media, details, and access settings.")}
        {elseif $sub_view == "genres"}{__("Organize the genres available across your movie library.")}
        {elseif $sub_view == "add_genre"}{__("Create a genre for organizing your movie library.")}
        {elseif $sub_view == "edit_genre"}{__("Update this genre and its position in the movie directory.")}
        {else}{__("Manage your movie library, sources, access, and genres.")}{/if}
      </p>
    </div>

    <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
      {if $sub_view == ""}
        <a href="{$system['system_url']}/{$control_panel['url']}/movies/add_movie" class="btn btn-primary"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Movie")}</a>
      {elseif $sub_view == "genres"}
        <a href="{$system['system_url']}/{$control_panel['url']}/movies/add_genre" class="btn btn-primary"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Genre")}</a>
      {elseif $sub_view == "add_movie" || $sub_view == "edit_movie"}
        <a href="{$system['system_url']}/{$control_panel['url']}/movies" class="btn btn-outline"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
      {elseif $sub_view == "add_genre" || $sub_view == "edit_genre"}
        <a href="{$system['system_url']}/{$control_panel['url']}/movies/genres" class="btn btn-outline"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
      {/if}
    </div>
  </header>

  {if $sub_view == ""}
    <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-info icon-[tabler--movie] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Total Movies")}">{__("Total Movies")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['movies']|number_format}</p></div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-success icon-[tabler--coin] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Paid Movies")}">{__("Paid Movies")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['paid']|number_format}</p></div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-warning icon-[tabler--ticket-off] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Free Movies")}">{__("Free Movies")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['free']|number_format}</p></div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-neutral icon-[tabler--category] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Genres")}">{__("Genres")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['genres']|number_format}</p></div>
      </article>
    </div>

    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Movies")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table js_dataTable admin-list-table">
            <thead><tr><th>{__("Movie")}</th><th>{__("Source")}</th><th>{__("Release")}</th><th>{__("Views")}</th><th>{__("Access")}</th><th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th></tr></thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/movie/{$row['movie_id']}/{$row['movie_url']}">
                      <img class="admin-list-avatar size-[42px] shrink-0 rounded-md border border-base-300 object-cover" src="{$row['poster']}" alt="" width="42" height="42" loading="lazy">
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5"><span class="admin-list-name truncate text-sm font-semibold" title="{$row['title']}">{$row['title']}</span><span class="admin-list-id text-xs">#{$row['movie_id']}</span></span>
                    </a>
                  </td>
                  <td>
                    {if $row['source_type'] == "youtube"}<span class="badge badge-soft badge-error badge-sm rounded-full">{__("YouTube")}</span>
                    {elseif $row['source_type'] == "vimeo"}<span class="badge badge-soft badge-info badge-sm rounded-full">{__("Vimeo")}</span>
                    {elseif $row['source_type'] == "link"}<span class="badge badge-soft badge-sm rounded-full">{__("Link")}</span>
                    {elseif $row['source_type'] == "uploaded"}<span class="badge badge-soft badge-success badge-sm rounded-full">{__("Uploaded")}</span>
                    {else}<span class="badge badge-soft badge-sm rounded-full">{$row['source_type']}</span>{/if}
                  </td>
                  <td>{if $row['release_year']}<span class="tabular-nums">{$row['release_year']}</span>{else}<span class="text-base-content/50">{__("N/A")}</span>{/if}</td>
                  <td><span class="tabular-nums">{$row['views']|number_format}</span></td>
                  <td>{if $row['is_paid']}<span class="badge badge-soft badge-success badge-sm rounded-full">{__("Paid")}</span>{else}<span class="badge badge-soft badge-sm rounded-full">{__("Free")}</span>{/if}</td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="movie-actions-{$row['movie_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['title']}"><span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span></button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="movie-actions-{$row['movie_id']}">
                        <li><a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/movie/{$row['movie_id']}/{$row['movie_url']}"><span class="icon-[tabler--arrow-up-right] size-4" aria-hidden="true"></span>{__("View Movie")}</a></li>
                        <li><a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/movies/edit_movie/{$row['movie_id']}"><span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>{__("Edit")}</a></li>
                        <li><button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="movie" data-id="{$row['movie_id']}"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Delete")}</button></li>
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
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-movies-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200"><span class="icon-[tabler--movie-off] size-6" aria-hidden="true"></span></div>
        <h2 id="admin-movies-empty-title">{__("No movies yet")}</h2>
        <p>{__("Add your first movie to start building the library.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/movies/add_movie" class="btn btn-primary btn-sm"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Movie")}</a>
      </section>
    {/if}

  {elseif $sub_view == "add_movie" || $sub_view == "edit_movie"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/movies.php?do={if $sub_view == "edit_movie"}edit_movie&amp;id={$data['movie_id']}{else}add_movie{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="movie-media-title">
          <h2 id="movie-media-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--video] size-5" aria-hidden="true"></span>{__("Movie Media")}</h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="movie-source-url">{__("Movie Source")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="source_url" id="movie-source-url" value="{if $sub_view == "edit_movie" && $data['source_type'] != "uploaded"}{$data['source']}{/if}" aria-describedby="movie-source-url-help" autocomplete="off">
              <div id="movie-source-url-help" class="admin-setting-help text-sm leading-relaxed">{__("From YouTube, Vimeo or site.com/movie.mp4")}</div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <span class="label-text" id="movie-upload-label">{__("Or Upload Movie")}</span>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if $sub_view == "edit_movie" && $data['source_type'] == "uploaded"}
                {include file='__x_image.tpl' _x_name="source_upload" _x_value=$data['source'] _x_handle="x-video" _x_type="video"}
              {else}
                {include file='__x_image.tpl' _x_name="source_upload" _x_handle="x-video" _x_type="video"}
              {/if}
              <div class="admin-setting-help text-sm leading-relaxed">
                {__("Maximum file size is")} {$system['max_video_size']/1024}{__("MB")} {__("and allowed extensions are")} ({$system['video_extensions']})<br>
                {__("You can change the")} <a target="_blank" href="{$system['system_url']}/{$control_panel['url']}/settings/uploads">{__("Uploads Settings")}</a>
              </div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <span class="label-text" id="movie-poster-label">{__("Poster")}</span>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if $sub_view == "edit_movie"}
                {include file='__x_image.tpl' _x_name="poster" _x_value=$data['poster'] _x_fit="contain"}
              {else}
                {include file='__x_image.tpl' _x_name="poster" _x_fit="contain"}
              {/if}
            </div>
          </div>
        </div>

        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="movie-details-title">
          <h2 id="movie-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--movie] size-5" aria-hidden="true"></span>{__("Movie Details")}</h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="movie-title">{__("Movie Title")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input type="text" class="input w-full" name="title" id="movie-title" value="{if $sub_view == "edit_movie"}{$data['title']}{/if}" autocomplete="off"></div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="movie-description">{__("Description")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><textarea class="textarea w-full" name="description" id="movie-description" rows="4">{if $sub_view == "edit_movie"}{$data['description']}{/if}</textarea></div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="movie-imdb">{__("IMDB")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="imdb_url" id="movie-imdb" value="{if $sub_view == "edit_movie"}{$data['imdb_url']}{/if}" aria-describedby="movie-imdb-help" autocomplete="off">
              <div id="movie-imdb-help" class="admin-setting-help text-sm leading-relaxed">{__("IMDB Link, Example:")} <a target="_blank" href="https://www.imdb.com/title/tt0111161">https://www.imdb.com/title/tt0111161</a></div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="movie-stars">{__("Movie Stars")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <textarea class="textarea w-full" name="stars" id="movie-stars" rows="3" aria-describedby="movie-stars-help">{if $sub_view == "edit_movie"}{$data['stars']}{/if}</textarea>
              <div id="movie-stars-help" class="admin-setting-help text-sm leading-relaxed">{__("Separated by a comma (,) Example: Tom Hanks, Julia Roberts, Jim Carrey")}</div>
            </div>
          </div>
          <div class="grid min-w-0 gap-5 md:grid-cols-2">
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="movie-release-year">{__("Release Year")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input type="number" class="input w-full" name="release_year" id="movie-release-year" value="{if $sub_view == "edit_movie"}{$data['release_year']}{/if}" aria-describedby="movie-release-year-help"><div id="movie-release-year-help" class="admin-setting-help text-sm leading-relaxed">{__("Movie release year, Example: 1995")}</div></div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="movie-duration">{__("Duration")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input type="number" class="input w-full" name="duration" id="movie-duration" value="{if $sub_view == "edit_movie"}{$data['duration']}{/if}" aria-describedby="movie-duration-help"><div id="movie-duration-help" class="admin-setting-help text-sm leading-relaxed">{__("Movie duration in minutes, Example: 120")}</div></div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="movie-genres">{__("Genres")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select h-auto min-h-32 w-full py-2" multiple name="movie_genres[]" id="movie-genres">
                {if $sub_view == "edit_movie"}
                  {foreach $data['movies_genres'] as $genre}<option {if in_array($genre['genre_id'], $data['genres'])}selected{/if} value="{$genre['genre_id']}">{__($genre['genre_name'])}</option>{/foreach}
                {else}
                  {foreach $genres as $genre}<option value="{$genre['genre_id']}">{__($genre['genre_name'])}</option>{/foreach}
                {/if}
              </select>
            </div>
          </div>
        </div>

        {if $licence_monetization && $licence_module_installed}
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="movie-access-title">
            <h2 id="movie-access-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--coin] size-5" aria-hidden="true"></span>{__("Access & Pricing")}</h2>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon"><span class="icon-[tabler--coin] size-6" aria-hidden="true"></span></div>
              <div><label class="admin-setting-label block text-sm font-medium leading-normal" for="is_paid">{__("Paid")}</label><div id="is-paid-help" class="admin-setting-help text-sm leading-relaxed">{__("If you enable this option, users will have to pay to watch this movie.")}</div></div>
              <div class="text-end"><input type="checkbox" class="switch switch-primary" name="is_paid" id="is_paid" {if $sub_view == "edit_movie" && $data['is_paid']}checked{/if} aria-describedby="is-paid-help"></div>
            </div>
            <div class="grid min-w-0 gap-5 md:grid-cols-2">
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="movie-price">{__("Price")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input type="text" class="input w-full" name="price" id="movie-price" value="{if $sub_view == "edit_movie"}{$data['price']}{/if}" inputmode="decimal" aria-describedby="movie-price-help"><div id="movie-price-help" class="admin-setting-help text-sm leading-relaxed">{__("How much user should pay to watch this movie, Example: 10")}</div></div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="movie-availability">{__("Availability")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input type="number" class="input w-full" name="available_for" id="movie-availability" value="{if $sub_view == "edit_movie"}{$data['available_for']}{/if}" aria-describedby="movie-availability-help"><div id="movie-availability-help" class="admin-setting-help text-sm leading-relaxed">{__("How many days user can watch this movie after purchase, Example: 30 (0 for unlimited)")}</div></div>
              </div>
            </div>
          </div>
        {else}
          <div class="admin-settings-section p-6">{include file='__licence_lock.tpl' _mini=true _title={__("Paid Movies")}}</div>
        {/if}

        <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
          <div class="admin-settings-feedback w-full min-w-0" aria-live="polite"><div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div><div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div></div>
          <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2"><button type="submit" class="btn btn-primary">{__("Save Changes")}</button></div>
        </div>
      </section>
    </form>

  {elseif $sub_view == "genres"}
    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Movie Genres")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table js_dataTable admin-list-table">
            <thead><tr><th>{__("Genre")}</th><th>{__("Description")}</th><th>{__("Order")}</th><th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th></tr></thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td><span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5"><span class="admin-list-name truncate text-sm font-semibold" title="{$row['genre_name']}">{__($row['genre_name'])}</span><span class="admin-list-id text-xs">#{$row['genre_id']}</span></span></td>
                  <td>{$row['genre_description']|truncate:70}</td>
                  <td><span class="badge badge-soft badge-primary badge-sm rounded-full">{$row['genre_order']}</span></td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="genre-actions-{$row['genre_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['genre_name']}"><span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span></button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="genre-actions-{$row['genre_id']}">
                        <li><a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/movies/edit_genre/{$row['genre_id']}"><span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>{__("Edit")}</a></li>
                        <li><button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="movie_genre" data-id="{$row['genre_id']}"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Delete")}</button></li>
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
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-movie-genres-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200"><span class="icon-[tabler--category] size-6" aria-hidden="true"></span></div>
        <h2 id="admin-movie-genres-empty-title">{__("No genres yet")}</h2>
        <p>{__("Add a genre to organize movies in the library.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/movies/add_genre" class="btn btn-primary btn-sm"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Genre")}</a>
      </section>
    {/if}

  {elseif $sub_view == "add_genre" || $sub_view == "edit_genre"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/movies.php?do={if $sub_view == "edit_genre"}edit_genre&amp;id={$data['genre_id']}{else}add_genre{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="movie-genre-details-title">
          <h2 id="movie-genre-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--category] size-5" aria-hidden="true"></span>{__("Genre Details")}</h2>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="movie-genre-name">{__("Name")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input type="text" class="input w-full" name="genre_name" id="movie-genre-name" value="{if $sub_view == "edit_genre"}{$data['genre_name']}{/if}" autocomplete="off"></div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="movie-genre-description">{__("Description")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><textarea class="textarea w-full" name="genre_description" id="movie-genre-description" rows="4">{if $sub_view == "edit_genre"}{$data['genre_description']}{/if}</textarea></div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="movie-genre-order">{__("Order")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input class="input w-full" name="genre_order" id="movie-genre-order" value="{if $sub_view == "edit_genre"}{$data['genre_order']}{/if}" inputmode="numeric"><div class="admin-setting-help text-sm leading-relaxed">{__("Lower numbers appear first.")}</div></div>
          </div>
        </div>
        <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
          <div class="admin-settings-feedback w-full min-w-0" aria-live="polite"><div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div><div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div></div>
          <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2"><button type="submit" class="btn btn-primary">{__("Save Changes")}</button></div>
        </div>
      </section>
    </form>
  {/if}

  {if in_array($sub_view, ["add_movie", "edit_movie", "add_genre", "edit_genre"])}
    </div>
  {/if}
</section>
