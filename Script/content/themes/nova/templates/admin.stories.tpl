{if $sub_view == ""}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-stories-title">
    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-stories-title" class="text-2xl font-semibold">{__("Stories")}</h1>
        <p class="text-base-content/60 text-sm">{__("Activity of the stories that are live right now, their features, limits and music.")}</p>
      </div>
      <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
        <a href="{$system['system_url']}/{$control_panel['url']}/stories/list" class="btn btn-outline">
          <span class="icon-[tabler--list] size-4" aria-hidden="true"></span>
          {__("List Stories")}
        </a>
      </div>
    </header>

    <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-info icon-[tabler--history-toggle] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Active Stories")}">{__("Active Stories")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['stories']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-info icon-[tabler--users] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Members With Stories")}">{__("Members With Stories")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['authors']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-success icon-[tabler--eye] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Views")}">{__("Views")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['views']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-success icon-[tabler--mood-smile] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Reactions")}">{__("Reactions")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['reactions']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-success icon-[tabler--message] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Replies")}">{__("Replies")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['replies']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-info icon-[tabler--star] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Highlights")}">{__("Highlights")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['highlights']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-info icon-[tabler--music] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Music Tracks")}">{__("Music Tracks")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['music']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-warning icon-[tabler--flag] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Reported Stories")}">{__("Reported Stories")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['reports']|number_format}</p>
        </div>
      </article>
    </div>

    <div class="admin-settings-panel js_admin-settings-panel" id="General">
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=stories">
        <div class="admin-settings-layout block">
          <div class="admin-settings-form flex min-w-0 flex-col gap-4">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
                <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                  <span class="icon-[tabler--history-toggle] size-5" aria-hidden="true"></span>
                  {__("General")}
                </h2>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="24_hours" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="stories_enabled">{__("Stories")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="stories_enabled-help">{__("Stories are photos, videos and texts that only last 24 hours")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="stories_enabled" id="stories_enabled" {if $system['stories_enabled']}checked{/if} aria-describedby="stories_enabled-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="memories" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="stories_archive_enabled">{__("Stories Archive")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="stories_archive_enabled-help">
                      {__("Keep stories after 24 hours in a private archive only their owner can see")}
                      <br>
                      {__("When off, expired stories and their files are deleted, except the stories saved in highlights")}
                    </div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="stories_archive_enabled" id="stories_archive_enabled" {if $system['stories_archive_enabled']}checked{/if} aria-describedby="stories_archive_enabled-help">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="stories_design">{__("Stories Design")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <select class="select w-full" name="stories_design" id="stories_design" aria-describedby="stories_design-help">
                      <option value="circles" {if $system['stories_design'] != "cards"}selected{/if}>{__("Circles")}</option>
                      <option value="cards" {if $system['stories_design'] == "cards"}selected{/if}>{__("Cards")}</option>
                    </select>
                    <div id="stories_design-help" class="admin-setting-help text-sm leading-relaxed">{__("How stories look on the newsfeed, round pictures or tall cards with a preview of the story")}</div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="stories_duration">{__("Story Duration")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="stories_duration" id="stories_duration" value="{$system['stories_duration']}" inputmode="numeric" aria-describedby="stories_duration-help">
                    <div id="stories_duration-help" class="admin-setting-help text-sm leading-relaxed">{__("How long a photo or text story stays on screen, in seconds")}</div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="stories_video_max_duration">{__("Max Video Length")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="stories_video_max_duration" id="stories_video_max_duration" value="{$system['stories_video_max_duration']}" inputmode="numeric" aria-describedby="stories_video_max_duration-help">
                    <div id="stories_video_max_duration-help" class="admin-setting-help text-sm leading-relaxed">{__("The longest video a member can post and how long it plays, in seconds, 0 for no limit")}</div>
                  </div>
                </div>
              </div>
            </section>

            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
                <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                  <span class="icon-[tabler--sparkles] size-5" aria-hidden="true"></span>
                  {__("Features")}
                </h2>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="posts_colored" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="stories_text_enabled">{__("Text Stories")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="stories_text_enabled-help">{__("Allow stories made of text on a coloured background")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="stories_text_enabled" id="stories_text_enabled" {if $system['stories_text_enabled']}checked{/if} aria-describedby="stories_text_enabled-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="smile" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="stories_reactions_enabled">{__("Reactions")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="stories_reactions_enabled-help">{__("Allow members to react to stories")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="stories_reactions_enabled" id="stories_reactions_enabled" {if $system['stories_reactions_enabled']}checked{/if} aria-describedby="stories_reactions_enabled-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="chat" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="stories_replies_enabled">{__("Replies")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="stories_replies_enabled-help">{__("Allow members to reply to stories, replies are sent as chat messages")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="stories_replies_enabled" id="stories_replies_enabled" {if $system['stories_replies_enabled']}checked{/if} aria-describedby="stories_replies_enabled-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="polls" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="stories_polls_enabled">{__("Polls")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="stories_polls_enabled-help">{__("Allow poll stickers on stories")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="stories_polls_enabled" id="stories_polls_enabled" {if $system['stories_polls_enabled']}checked{/if} aria-describedby="stories_polls_enabled-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="star" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="stories_highlights_enabled">{__("Highlights")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="stories_highlights_enabled-help">{__("Allow members to keep stories on their profile after 24 hours")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="stories_highlights_enabled" id="stories_highlights_enabled" {if $system['stories_highlights_enabled']}checked{/if} aria-describedby="stories_highlights_enabled-help">
                  </div>
                </div>
              </div>
            </section>

            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
                <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                  <span class="icon-[tabler--music] size-5" aria-hidden="true"></span>
                  {__("Music")}
                </h2>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="audios" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="stories_music_enabled">{__("Stories Music")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="stories_music_enabled-help">{__("Allow members to add music to their stories")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="stories_music_enabled" id="stories_music_enabled" {if $system['stories_music_enabled']}checked{/if} aria-describedby="stories_music_enabled-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="media-player" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="stories_music_library_enabled">{__("Music Library")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="stories_music_library_enabled-help">{__("Offer the tracks you uploaded to the music library")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="stories_music_library_enabled" id="stories_music_library_enabled" {if $system['stories_music_library_enabled']}checked{/if} aria-describedby="stories_music_library_enabled-help">
                  </div>
                </div>
              </div>
            </section>

            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
                <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                  <span class="icon-[tabler--brand-apple] size-5" aria-hidden="true"></span>
                  {__("iTunes")}
                </h2>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="trending" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="stories_music_itunes_enabled">{__("iTunes Search")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="stories_music_itunes_enabled-help">
                      {__("Let members search millions of songs and use their 30 seconds previews, no setup needed")}
                      <br>
                      {__("Previews are streamed from Apple and linked to Apple Music, they are not licensed as story soundtracks")}
                      <br>
                      {__("You are responsible for this use, check Apple terms and the music rights rules in your country before enabling it")}
                    </div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="stories_music_itunes_enabled" id="stories_music_itunes_enabled" {if $system['stories_music_itunes_enabled']}checked{/if} aria-describedby="stories_music_itunes_enabled-help">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="stories_music_itunes_country">{__("Store Country")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="stories_music_itunes_country" id="stories_music_itunes_country" value="{$system['stories_music_itunes_country']}" maxlength="2" autocomplete="off" aria-describedby="stories_music_itunes_country-help">
                    <div id="stories_music_itunes_country-help" class="admin-setting-help text-sm leading-relaxed">{__("The two letters country code of the store to search, for example US, GB or EG")}</div>
                  </div>
                </div>
              </div>
            </section>

            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-6">
                <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                  <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                  <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
                </div>
                <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                  <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                </div>
              </div>
            </section>
          </div>
        </div>
      </form>
    </div>
  </section>

{elseif $sub_view == "list"}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-stories-title">
    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-stories-title" class="text-2xl font-semibold">{__("List Stories")}</h1>
        <p class="text-base-content/60 text-sm">{if $status == "archived"}{__("Stories older than 24 hours kept in the archive or in highlights, newest first.")}{else}{__("Every story that is live right now, newest first.")}{/if}</p>
      </div>
    </header>

    <div>
      <nav class="tabs admin-settings-nav admin-form-tabs" aria-label="{__("Status")}">
        <a class="tab{if $status == "active"} tab-active{/if}" href="{$system['system_url']}/{$control_panel['url']}/stories/list" {if $status == "active"}aria-current="page"{/if}>
          <span class="icon-[tabler--history-toggle] size-4" aria-hidden="true"></span>{__("Active")}
        </a>
        <a class="tab{if $status == "archived"} tab-active{/if}" href="{$system['system_url']}/{$control_panel['url']}/stories/list?status=archived" {if $status == "archived"}aria-current="page"{/if}>
          <span class="icon-[tabler--archive] size-4" aria-hidden="true"></span>{__("Archived")}
        </a>
      </nav>
    </div>

    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{if $status == "archived"}{__("Archived")}{else}{__("Active")}{/if}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("Story")}</th>
                <th>{__("Member")}</th>
                <th>{__("Audience")}</th>
                <th>{__("Views")}</th>
                <th>{__("Reactions")}</th>
                <th>{__("Replies")}</th>
                <th>{__("Posted")}</th>
                <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    {if $status == "active"}
                      {assign var="story_url" value="`$system['system_url']`/?story=`$row['story_id']`"}
                    {else}
                      {assign var="story_url" value=$row['media']}
                    {/if}
                    <a class="flex min-w-0 items-center gap-3" {if $story_url}href="{$story_url}" target="_blank"{/if}>
                      <span class="flex h-14 w-9 shrink-0 items-center justify-center overflow-hidden rounded-lg bg-base-200 text-base-content/60">
                        {if $row['preview']}
                          <img class="size-full object-cover" src="{$row['preview']}" alt="" loading="lazy">
                        {elseif $row['type'] == "video"}
                          <span class="icon-[tabler--video] size-5" aria-hidden="true"></span>
                        {else}
                          <span class="icon-[tabler--typography] size-5" aria-hidden="true"></span>
                        {/if}
                      </span>
                      <span class="flex min-w-0 flex-col gap-1">
                        <span class="admin-list-name text-sm font-semibold">#{$row['story_id']}</span>
                        <span class="flex flex-wrap gap-1">
                          {if $row['type'] == "photo"}<span class="badge badge-soft badge-sm rounded-full">{__("Photo")}</span>
                          {elseif $row['type'] == "video"}<span class="badge badge-soft badge-sm rounded-full">{__("Video")}</span>
                          {else}<span class="badge badge-soft badge-sm rounded-full">{__("Text")}</span>{/if}
                          {if $row['is_ads']}<span class="badge badge-soft badge-warning badge-sm rounded-full">{__("Ads")}</span>{/if}
                          {if $row['highlighted']}<span class="badge badge-soft badge-info badge-sm rounded-full">{__("Highlight")}</span>{/if}
                        </span>
                      </span>
                    </a>
                  </td>
                  <td>
                    <a class="flex min-w-0 items-center gap-3" href="{$system['system_url']}/{$row['user_name']}" target="_blank">
                      <img class="size-9 shrink-0 rounded-full object-cover" src="{$row['user_picture']}" alt="" loading="lazy">
                      <span class="admin-list-name max-w-48 truncate text-sm font-semibold" title="{$row['user_firstname']} {$row['user_lastname']}">{$row['user_firstname']} {$row['user_lastname']}</span>
                    </a>
                  </td>
                  <td>
                    {if $row['privacy'] == "public"}{__("Public")}
                    {elseif $row['privacy'] == "friends"}{__("Friends")}
                    {else}{__("Close Friends")}{/if}
                  </td>
                  <td>{$row['views_count']|number_format}</td>
                  <td>{$row['reactions_count']|number_format}</td>
                  <td>{$row['replies_count']|number_format}</td>
                  <td><span class="js_moment" data-time="{$row['time']}">{$row['time']}</span></td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="stories-actions-{$row['story_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} #{$row['story_id']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="stories-actions-{$row['story_id']}">
                        {if $story_url}
                          <li>
                            <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$story_url}">
                              <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
                              {__("View")}
                            </a>
                          </li>
                        {/if}
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="story" data-id="{$row['story_id']}">
                            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                            {__("Delete")}
                          </button>
                        </li>
                      </ul>
                    </div>
                  </td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
      </section>
      {if $pager}
        <div class="admin-list-pager">{$pager}</div>
      {/if}
    {else}
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--{if $status == "archived"}archive{else}history-toggle{/if}] size-6" aria-hidden="true"></span>
        </div>
        {if $status == "archived"}
          <h2>{__("No archived stories")}</h2>
          <p>{__("Stories show up here after 24 hours when the stories archive is on or when they are saved in highlights.")}</p>
        {else}
          <h2>{__("No active stories")}</h2>
          <p>{__("Stories members post will show up here for 24 hours.")}</p>
        {/if}
      </section>
    {/if}
  </section>

{else}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-stories-title">
    {if $sub_view == "add_music" || $sub_view == "edit_music"}
      <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
    {/if}

    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-stories-title" class="text-2xl font-semibold">
          {if $sub_view == "add_music"}{__("Add New Track")}{elseif $sub_view == "edit_music"}{__("Edit Track")}{else}{__("Music Library")}{/if}
        </h1>
        <p class="text-base-content/60 text-sm">
          {if $sub_view == "add_music"}{__("Upload a track you have the rights to use.")}{elseif $sub_view == "edit_music"}{__("Update this track, its audio file and its cover.")}{else}{__("The tracks members can add to their stories.")}{/if}
        </p>
      </div>

      <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
        {if $sub_view == "add_music" || $sub_view == "edit_music"}
          <a href="{$system['system_url']}/{$control_panel['url']}/stories/music" class="btn btn-outline">
            <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
            {__("Go Back")}
          </a>
        {else}
          <a href="{$system['system_url']}/{$control_panel['url']}/stories/add_music" class="btn btn-primary">
            <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
            {__("Add New Track")}
          </a>
        {/if}
      </div>
    </header>

    {if $sub_view == "add_music" || $sub_view == "edit_music"}
      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/stories.php?do={if $sub_view == "edit_music"}edit_music&amp;id={$data['music_id']}{else}add_music{/if}">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="grid min-w-0 gap-5 md:grid-cols-2">
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="stories-music-title">{__("Title")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input class="input w-full" name="title" id="stories-music-title" maxlength="250" value="{if $sub_view == "edit_music"}{$data['title']}{/if}" autocomplete="off">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="stories-music-artist">{__("Artist")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input class="input w-full" name="artist" id="stories-music-artist" maxlength="250" value="{if $sub_view == "edit_music"}{$data['artist']}{/if}" autocomplete="off">
                </div>
              </div>
            </div>

            <div class="grid min-w-0 gap-5 md:grid-cols-2">
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <span class="label-text">{__("Audio File")}</span>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if $sub_view == "edit_music"}
                    {include file='__x_image.tpl' _x_name="source" _x_value=$data['source'] _x_handle="x-audio" _x_type="audio" _x_label=__("Audio File")}
                    <audio class="js_audio block h-9 w-full max-w-xs" controls preload="none" src="{$system['system_uploads']}/{$data['source']}"></audio>
                  {else}
                    {include file='__x_image.tpl' _x_name="source" _x_handle="x-audio" _x_type="audio" _x_label=__("Audio File")}
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed">{__("Allowed types")}: {$system['audio_extensions']}</div>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <span class="label-text">{__("Cover")}</span>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if $sub_view == "edit_music"}
                    {include file='__x_image.tpl' _x_name="cover" _x_value=$data['cover'] _x_label=__("Cover")}
                  {else}
                    {include file='__x_image.tpl' _x_name="cover" _x_label=__("Cover")}
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed">{__("A square image, optional.")}</div>
                </div>
              </div>
            </div>
          </div>

          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </section>
      </form>
    {else}
      {if !$system['stories_music_enabled']}
        <div class="alert alert-soft alert-warning" role="status">{__("Stories music is disabled, enable it from the stories settings")}</div>
      {/if}

      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Music Library")}">
        <div class="js-flyonui-datatable-toolbar border-base-300 flex items-center justify-between gap-3 border-b px-5 py-3 max-md:flex-wrap">
          <form class="input max-w-60" action="{$system['system_url']}/{$control_panel['url']}/stories/music" method="get" role="search">
            <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
            <input type="search" class="grow" name="query" id="admin-stories-music-query" value="{$query}" placeholder="{__("Search")}" title="{__("Search by Title or Artist")}" aria-label="{__("Search by Title or Artist")}" autocomplete="off">
          </form>
        </div>
        {if $rows}
          <div class="admin-list-table-wrap w-full overflow-x-auto">
            <table class="table admin-list-table">
              <thead>
                <tr>
                  <th>{__("Track")}</th>
                  <th>{__("Preview")}</th>
                  <th>{__("Source")}</th>
                  <th>{__("Uses")}</th>
                  <th>{__("Status")}</th>
                  <th>{__("Added")}</th>
                  <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
                </tr>
              </thead>
              <tbody>
                {foreach $rows as $row}
                  <tr>
                    <td>
                      <div class="flex min-w-0 items-center gap-3">
                        <span class="flex size-10 shrink-0 items-center justify-center overflow-hidden rounded-lg bg-base-200 text-base-content/60">
                          {if $row['cover']}
                            <img class="size-full object-cover" src="{$row['cover']}" alt="" loading="lazy">
                          {else}
                            <span class="icon-[tabler--music] size-5" aria-hidden="true"></span>
                          {/if}
                        </span>
                        <span class="min-w-0">
                          <span class="admin-list-name block max-w-56 truncate text-sm font-semibold" title="{$row['title']|escape:'html'}">{$row['title']|escape:'html'}</span>
                          <span class="block max-w-56 truncate text-xs text-base-content/60" title="{$row['artist']|escape:'html'}">{$row['artist']|escape:'html'}</span>
                        </span>
                      </div>
                    </td>
                    <td>
                      <audio class="js_audio block h-9 w-56" controls preload="none" src="{$row['source']}"></audio>
                    </td>
                    <td>
                      {if $row['provider'] == "library"}<span class="badge badge-soft badge-primary badge-sm rounded-full">{__("Library")}</span>
                      {else}<span class="badge badge-soft badge-sm rounded-full">{__("iTunes")}</span>{/if}
                    </td>
                    <td>{$row['uses']|number_format}</td>
                    <td>
                      {if $row['enabled']}<span class="badge badge-soft badge-success badge-sm rounded-full">{__("Active")}</span>
                      {else}<span class="badge badge-soft badge-error badge-sm rounded-full">{__("Disabled")}</span>{/if}
                    </td>
                    <td>{$row['time']|date_format:"%e %B %Y"}</td>
                    <td class="admin-list-actions-column w-14 text-end">
                      <div class="dropdown relative inline-flex [--placement:bottom-end]">
                        <button id="stories-music-actions-{$row['music_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['title']|escape:'html'}">
                          <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                        </button>
                        <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="stories-music-actions-{$row['music_id']}">
                          {if $row['provider'] == "library"}
                            <li>
                              <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/stories/edit_music/{$row['music_id']}">
                                <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                                {__("Edit")}
                              </a>
                            </li>
                          {/if}
                          <li>
                            <form class="js_ajax-forms contents" data-url="admin/stories.php?do={if $row['enabled']}disable_music{else}enable_music{/if}&amp;id={$row['music_id']}">
                              <button type="submit" class="dropdown-item px-2" role="menuitem">
                                <span class="{if $row['enabled']}icon-[tabler--eye-off]{else}icon-[tabler--eye]{/if} size-4" aria-hidden="true"></span>
                                {if $row['enabled']}{__("Disable")}{else}{__("Enable")}{/if}
                              </button>
                            </form>
                          </li>
                          <li>
                            <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="story_music" data-id="{$row['music_id']}">
                              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                              {__("Delete")}
                            </button>
                          </li>
                        </ul>
                      </div>
                    </td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        {else}
          <div class="admin-list-empty flex min-h-[300px] flex-col items-center justify-center px-6 py-10 text-center">
            <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
              <span class="icon-[tabler--music] size-6" aria-hidden="true"></span>
            </div>
            <h2>{__("No tracks yet")}</h2>
            <p>{__("Upload tracks, songs members pick from iTunes will show up here too.")}</p>
          </div>
        {/if}
      </section>
      {if $pager}
        <div class="admin-list-pager">{$pager}</div>
      {/if}
    {/if}

    {if $sub_view == "add_music" || $sub_view == "edit_music"}
      </div>
    {/if}
  </section>
{/if}
