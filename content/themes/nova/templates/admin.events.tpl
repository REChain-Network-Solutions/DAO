<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-events-title">
  {if $sub_view == "add_category" || $sub_view == "edit_category"}
  <div class="admin-form-layout mx-auto w-full admin-form-layout-wide flex max-w-[64rem] flex-col gap-6">
  {/if}
  {if $sub_view != "edit_event"}
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-events-title" class="text-2xl font-semibold">
        {if $sub_view == "find"}
          {__("Find")}
        {elseif $sub_view == "categories"}
          {__("Categories")}
        {elseif $sub_view == "add_category"}
          {__("Add New Category")}
        {elseif $sub_view == "edit_category"}
          {$data['category_name']}
        {else}
          {__("Events")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "find"}
          {__("Search results for event title.")}
        {elseif $sub_view == "categories"}
          {__("Organize the categories available to events.")}
        {elseif $sub_view == "add_category"}
          {__("Create a new event category.")}
        {elseif $sub_view == "edit_category"}
          {__("Update this event category.")}
        {else}
          {__("Manage events, their admins, and attendance.")}
        {/if}
      </p>
    </div>

    {if $sub_view != ""}
    <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
      {if $sub_view == "categories"}
        <a href="{$system['system_url']}/{$control_panel['url']}/events/add_category" class="btn btn-primary">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Category")}
        </a>
      {elseif $sub_view == "find"}
        <a href="{$system['system_url']}/{$control_panel['url']}/events" class="btn btn-outline">
          <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
          {__("Go Back")}
        </a>
      {elseif $sub_view == "add_category" || $sub_view == "edit_category"}
        <a href="{$system['system_url']}/{$control_panel['url']}/events/categories" class="btn btn-outline">
          <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
          {__("Go Back")}
        </a>
      {/if}
    </div>
    {/if}
  </header>
  {/if}

  {if $sub_view == "" || $sub_view == "find"}

    {if $sub_view == ""}
      <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-info icon-[tabler--calendar-event] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Total Events")}">{__("Total Events")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['events']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-warning icon-[tabler--clock] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Upcoming")}">{__("Upcoming")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['upcoming']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-error icon-[tabler--wifi] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Online")}">{__("Online")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['online']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-neutral icon-[tabler--category] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Categories")}">{__("Categories")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['categories']|number_format}</p>
          </div>
        </article>
      </div>
    {/if}

    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Events")}">
      <div class="js-flyonui-datatable-toolbar border-base-300 flex items-center justify-between gap-3 border-b px-5 py-3 max-md:flex-wrap">
        <form class="input max-w-60" action="{$system['system_url']}/{$control_panel['url']}/events/find" method="get" role="search">
          <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
          <input type="search" class="grow" name="query" id="admin-events-query" value="{if $query}{$query}{/if}" placeholder="{__("Search")}" title="{__("Search by Event Title")}" aria-label="{__("Search by Event Title")}" autocomplete="off">
        </form>
      </div>
      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("Event")}</th>
                <th>{__("Admin")}</th>
                <th>{__("Privacy")}</th>
                <th>{__("Start Date")}</th>
                <th>{__("Going")}</th>
                <th>{__("Interested")}</th>
                <th>{__("Invited")}</th>
                <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/events/{$row['event_id']}">
                      <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['event_picture']}" alt="" width="30" height="30" loading="lazy">
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{$row['event_title']}">{$row['event_title']}</span>
                        <span class="admin-list-id text-xs">#{$row['event_id']}</span>
                      </span>
                    </a>
                  </td>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/{$row['user_name']}">
                      <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['user_picture']}" alt="" width="30" height="30" loading="lazy">
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{$row['user_firstname']} {$row['user_lastname']}">{if $system['show_usernames_enabled']}{$row['user_name']}{else}{$row['user_firstname']} {$row['user_lastname']}{/if}</span>
                      </span>
                    </a>
                  </td>
                  <td>
                    {if $row['event_privacy'] == "public"}
                      <span class="badge badge-soft badge-info badge-sm rounded-full">{__("Public")}</span>
                    {elseif $row['event_privacy'] == "closed"}
                      <span class="badge badge-soft badge-warning badge-sm rounded-full">{__("Closed")}</span>
                    {elseif $row['event_privacy'] == "secret"}
                      <span class="badge badge-soft badge-sm rounded-full">{__("Secret")}</span>
                    {/if}
                  </td>
                  <td>{$row['event_start_date']|date_format:"%e %b %Y"}</td>
                  <td>{$row['event_going']}</td>
                  <td>{$row['event_interested']}</td>
                  <td>{$row['event_invited']}</td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="event-actions-{$row['event_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['event_title']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="event-actions-{$row['event_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/events/edit_event/{$row['event_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="event" data-id="{$row['event_id']}">
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
        {if $pager}
          <div class="admin-list-pager">{$pager}</div>
        {/if}
      {else}
        <div class="admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none admin-list-empty-inline min-h-60 border-0 bg-transparent" aria-labelledby="admin-events-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--calendar-event] size-6" aria-hidden="true"></span>
          </div>
          <h2 id="admin-events-empty-title">{__("No events found")}</h2>
          <p>{__("Try another search or check back later.")}</p>
        </div>
      {/if}
    </section>

  {elseif $sub_view == "edit_event"}

    <header class="admin-user-hero flex min-w-0 flex-col gap-5 border-b border-base-300 pb-5 sm:flex-row sm:items-center sm:justify-between" aria-labelledby="admin-events-title">
      <div class="admin-user-hero-identity flex min-w-0 items-center gap-4">
        <a class="admin-user-summary-photo size-16 shrink-0 overflow-hidden rounded-full border border-base-300 bg-base-200 focus-visible:outline-2 focus-visible:outline-offset-2" href="{$system['system_url']}/events/{$data['event_id']}" target="_blank" aria-label="{__("View Event")}: {$data['event_title']}">
          <img src="{$data['event_picture']}" alt="{$data['event_title']}">
        </a>
        <div class="min-w-0">
          <h1 id="admin-events-title" class="m-0 truncate text-2xl font-semibold" title="{$data['event_title']}">
            <a class="text-inherit hover:underline focus-visible:underline focus-visible:outline-none" href="{$system['system_url']}/events/{$data['event_id']}" target="_blank">{$data['event_title']}</a>
          </h1>
          <div class="admin-user-hero-meta mt-1 flex min-w-0 flex-wrap items-center gap-2">
            <span class="admin-user-summary-handle truncate" title="#{$data['event_id']}">#{$data['event_id']}</span>
            {if $data['event_privacy'] == "public"}
              <span class="badge badge-soft badge-info badge-sm rounded-full">{__("Public")}</span>
            {elseif $data['event_privacy'] == "closed"}
              <span class="badge badge-soft badge-warning badge-sm rounded-full">{__("Closed")}</span>
            {elseif $data['event_privacy'] == "secret"}
              <span class="badge badge-soft badge-sm rounded-full">{__("Secret")}</span>
            {/if}
            {if $data['event_is_online']}
              <span class="badge badge-soft badge-info badge-sm rounded-full admin-user-hero-badge">
                <span class="icon-[tabler--wifi] size-3.5" aria-hidden="true"></span>
                {__("Online")}
              </span>
            {else}
              <span class="badge badge-soft badge-sm rounded-full admin-user-hero-badge">
                <span class="icon-[tabler--map-pin] size-3.5" aria-hidden="true"></span>
                {__("In Person")}
              </span>
            {/if}
          </div>
        </div>
      </div>
      <div class="admin-user-hero-actions flex shrink-0 flex-wrap items-center gap-2">
        <a class="btn btn-outline" href="{$system['system_url']}/{$control_panel['url']}/events">
          <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
          {__("Go Back")}
        </a>
      </div>
    </header>

    <div class="admin-user-edit grid w-full gap-6">
      <div class="admin-user-edit-aside flex min-w-0 flex-col gap-4 lg:sticky lg:top-[5.5rem]">
      <aside class="admin-user-summary flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6" aria-label="{__("Event summary")}">
        <div class="admin-user-sidebar-heading flex min-w-0 items-center gap-3">
          <div class="admin-user-sidebar-heading-icon flex size-8 shrink-0 items-center justify-center rounded-md border border-base-300 bg-base-100">
            <span class="icon-[tabler--calendar-event] size-4" aria-hidden="true"></span>
          </div>
          <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug">{__("Event Details")}</h2>
        </div>
        <ul class="admin-user-summary-list grid gap-3">
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--id] size-3.5" aria-hidden="true"></span>{__("Event ID")}</span>
            <span class="admin-user-summary-value flex items-center justify-end gap-1">
              <span>{$data['event_id']}</span>
              <button type="button" class="admin-user-copy-button js_clipboard" data-clipboard-text="{$data['event_id']}" title="{__("Copy")}" aria-label="{__("Copy")} {__("Event ID")}">
                <span class="js-clipboard-default icon-[tabler--copy] size-3.5" aria-hidden="true"></span>
                <span class="js-clipboard-success icon-[tabler--check] hidden size-3.5 text-success" aria-hidden="true"></span>
              </button>
            </span>
          </li>
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--calendar] size-3.5" aria-hidden="true"></span>{__("Start Date")}</span>
            <span class="admin-user-summary-value">{$data['event_start_date']|date_format:"%e %b %Y, %H:%M"}</span>
          </li>
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--calendar] size-3.5" aria-hidden="true"></span>{__("End Date")}</span>
            <span class="admin-user-summary-value">{$data['event_end_date']|date_format:"%e %b %Y, %H:%M"}</span>
          </li>
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--user-check] size-3.5" aria-hidden="true"></span>{__("Going")}</span>
            <span class="admin-user-summary-value">{$data['event_going']|number_format}</span>
          </li>
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--star] size-3.5" aria-hidden="true"></span>{__("Interested")}</span>
            <span class="admin-user-summary-value">{$data['event_interested']|number_format}</span>
          </li>
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--mail] size-3.5" aria-hidden="true"></span>{__("Invited")}</span>
            <span class="admin-user-summary-value">{$data['event_invited']|number_format}</span>
          </li>
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--user] size-3.5" aria-hidden="true"></span>{__("Admin")}</span>
            <span class="admin-user-summary-value">
              <a class="admin-user-referrer" href="{$system['system_url']}/{$data['user_name']}" target="_blank">
                <img class="admin-list-avatar size-[22px] shrink-0 rounded-full object-cover" src="{$data['user_picture']}" alt="" width="22" height="22" loading="lazy">
                <span>{if $system['show_usernames_enabled']}{$data['user_name']}{else}{$data['user_firstname']} {$data['user_lastname']}{/if}</span>
              </a>
            </span>
          </li>
        </ul>
        <div class="admin-user-summary-actions grid gap-2 border-t border-base-300 pt-5">
          <a class="btn btn-outline w-full" href="{$system['system_url']}/events/{$data['event_id']}" target="_blank">
            <span class="icon-[tabler--arrow-up-right] size-4" aria-hidden="true"></span>
            {__("View Event")}
          </a>
          <a class="btn btn-outline w-full" href="{$system['system_url']}/events/{$data['event_id']}/settings" target="_blank">
            <span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>
            {__("Settings")}
          </a>
        </div>
      </aside>

      <section class="admin-user-danger flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6" aria-labelledby="admin-event-danger-title">
        <div class="admin-user-sidebar-heading flex min-w-0 items-center gap-3">
          <div class="admin-user-sidebar-heading-icon is-danger flex size-8 shrink-0 items-center justify-center rounded-md border bg-base-100">
            <span class="icon-[tabler--alert-triangle] size-4" aria-hidden="true"></span>
          </div>
          <h2 id="admin-event-danger-title" class="admin-user-danger-title m-0 text-sm font-semibold leading-snug text-error">{__("Danger Zone")}</h2>
        </div>
        <p class="admin-setting-help m-0 text-sm leading-relaxed">{__("Deleting posts or this event cannot be undone.")}</p>
        <div class="admin-user-summary-actions grid gap-2">
          <button type="button" class="btn w-full text-error admin-user-danger-action js_admin-deleter" data-handle="event_posts" data-id="{$data['event_id']}" data-delete-message="{__("Are you sure you want to delete all posts?")}">
            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
            {__("Delete Posts")}
          </button>
          <button type="button" class="btn w-full text-error admin-user-danger-action js_admin-deleter" data-handle="event" data-id="{$data['event_id']}" data-redirect="{$system['system_url']}/{$control_panel['url']}/events">
            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
            {__("Delete Event")}
          </button>
        </div>
      </section>
      </div>

      <div class="admin-user-edit-main flex min-w-0 flex-col gap-6">
      <form class="js_ajax-forms flex min-w-0 flex-col gap-6" data-url="admin/events.php?do=edit_event&id={$data['event_id']}">
        <nav class="tabs admin-settings-nav admin-user-edit-nav" role="tablist" aria-label="{__("Event Settings")}" aria-orientation="horizontal">
          <button type="button" id="events-tab-info" class="tab active-tab:tab-active active" data-tab="#event-info" aria-controls="event-info" role="tab" aria-selected="true"><span class="icon-[tabler--calendar-event] size-4" aria-hidden="true"></span>{__("Event Info")}</button>
          <button type="button" id="events-tab-options" class="tab active-tab:tab-active" data-tab="#event-options" aria-controls="event-options" role="tab" aria-selected="false"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("Options")}</button>
        </nav>

        <div id="event-info" class="admin-settings-panel js_admin-settings-panel" role="tabpanel" aria-labelledby="events-tab-info" tabindex="0">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="event-info-details-title">
              <h2 id="event-info-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--calendar-event] size-5" aria-hidden="true"></span>{__("Event Details")}</h2>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="event_title">{__("Name Your Event")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="title" id="event_title" value="{$data['event_title']}" autocomplete="off">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="event_start_date">{__("Start Date")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="datetime-local" class="input w-full" name="start_date" id="event_start_date" value="{$data['event_start_date']}">
                  <div class="admin-setting-help text-sm leading-relaxed">{__("Your current server datetime is")}: {$date} (UTC)</div>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="event_end_date">{__("End Date")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="datetime-local" class="input w-full" name="end_date" id="event_end_date" value="{$data['event_end_date']}">
                  <div class="admin-setting-help text-sm leading-relaxed">{__("Your current server datetime is")}: {$date} (UTC)</div>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="event_is_online">{__("Event Type")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="is_online" id="event_is_online">
                    <option {if $data['event_is_online'] == 0}selected{/if} value="0">{__("In Person")}</option>
                    <option {if $data['event_is_online'] == 1}selected{/if} value="1">{__("Online")}</option>
                  </select>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="event_privacy">{__("Select Privacy")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="privacy" id="event_privacy">
                    <option {if $data['event_privacy'] == "public"}selected{/if} value="public">{__("Public Event")}</option>
                    <option {if $data['event_privacy'] == "closed"}selected{/if} value="closed">{__("Closed Event")}</option>
                    <option {if $data['event_privacy'] == "secret"}selected{/if} value="secret">{__("Secret Event")}</option>
                  </select>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="event_category">{__("Category")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="category" id="event_category">
                    {foreach $data['categories'] as $category}
                      {include file='__categories.recursive_options.tpl' data_category=$data['event_category']}
                    {/foreach}
                  </select>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="event_location">{__("Location")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full js_geocomplete" name="location" id="event_location" value="{$data['event_location']}" autocomplete="off">
                  <input type="hidden" name="latitude" data-geo="lat" value="{$data['event_latitude']}">
                  <input type="hidden" name="longitude" data-geo="lng" value="{$data['event_longitude']}">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="event_country">{__("Country")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="country" id="event_country">
                    <option value="none">{__("Select Country")}</option>
                    {foreach $data['countries'] as $country}
                      <option value="{$country['country_id']}" {if $data['event_country'] == $country['country_id']}selected{/if}>{$country['country_name_with_flag']}</option>
                    {/foreach}
                  </select>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="event_language">{__("Language")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="language" id="event_language">
                    <option value="none">{__("Select Language")}</option>
                    {foreach $languages as $language}
                      <option value="{$language['language_id']}" {if $data['event_language'] == $language['language_id']}selected{/if}>{$language['title']}</option>
                    {/foreach}
                  </select>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="event_description">{__("About")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <textarea class="textarea w-full" name="description" id="event_description" rows="4">{$data['event_description']}</textarea>
                </div>
              </div>

              <!-- custom fields -->
              {if $custom_fields['basic']}
                {include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
              {/if}
              <!-- custom fields -->
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
        </div>

        <div id="event-options" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="events-tab-options" tabindex="0">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="event-options-title">
              <h2 id="event-options-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--settings] size-5" aria-hidden="true"></span>{__("Event Options")}</h2>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  <span class="icon-[tabler--message-circle] size-6" aria-hidden="true"></span>
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chatbox_enabled">{__("Chat Box")}</label>
                  <div id="chatbox_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Enable chat box for this event")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="chatbox_enabled" id="chatbox_enabled" {if $data['chatbox_enabled']}checked{/if} aria-describedby="chatbox_enabled-help">
                </div>
              </div>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  <span class="icon-[tabler--pencil] size-6" aria-hidden="true"></span>
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="event_publish_enabled">{__("Members Can Publish Posts?")}</label>
                  <div id="event_publish_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Members can publish posts or only event admin")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="event_publish_enabled" id="event_publish_enabled" {if $data['event_publish_enabled']}checked{/if} aria-describedby="event_publish_enabled-help">
                </div>
              </div>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  <span class="icon-[tabler--circle-check] size-6" aria-hidden="true"></span>
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="event_publish_approval_enabled">{__("Post Approval")}</label>
                  <div id="event_publish_approval_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                    {__("All posts must be approved by the event admin")}<br>
                    ({__("Note: Disable it will approve any pending posts")})
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="event_publish_approval_enabled" id="event_publish_approval_enabled" {if $data['event_publish_approval_enabled']}checked{/if} aria-describedby="event_publish_approval_enabled-help">
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
        </div>
      </form>
      </div>
    </div>

  {elseif $sub_view == "categories"}

    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Events Categories")}">
      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("Title")}</th>
                <th>{__("Description")}</th>
                <th>{__("Order")}</th>
                <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                {include file='__categories.recursive_rows.tpl' _url="events" _handle="event_category"}
              {/foreach}
            </tbody>
          </table>
        </div>
      {else}
        <div class="admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none admin-list-empty-inline min-h-60 border-0 bg-transparent" aria-labelledby="admin-events-categories-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--category] size-6" aria-hidden="true"></span>
          </div>
          <h2 id="admin-events-categories-empty-title">{__("No categories found")}</h2>
          <p>{__("Add your first category to organize events.")}</p>
        </div>
      {/if}
    </section>

  {elseif $sub_view == "add_category"}

    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/events.php?do=add_category">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="event-category-add-title">
          <h2 id="event-category-add-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("New Category")}</h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="category_name">{__("Name")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="category_name" id="category_name" autocomplete="off">
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="category_description">{__("Description")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <textarea class="textarea w-full" name="category_description" id="category_description" rows="3"></textarea>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="category_parent_id">{__("Parent Category")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full" name="category_parent_id" id="category_parent_id">
                <option value="0">{__("Set as a Parent Category")}</option>
                {foreach $categories as $category}
                  {include file='__categories.recursive_options.tpl'}
                {/foreach}
              </select>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="category_order">{__("Order")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="category_order" id="category_order" autocomplete="off">
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
    </div>

  {elseif $sub_view == "edit_category"}

    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/events.php?do=edit_category&id={$data['category_id']}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="event-category-edit-title">
          <h2 id="event-category-edit-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Edit Category")}</h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="category_name">{__("Name")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="category_name" id="category_name" value="{$data['category_name']}" autocomplete="off">
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="category_description">{__("Description")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <textarea class="textarea w-full" name="category_description" id="category_description" rows="3">{$data['category_description']}</textarea>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="category_parent_id">{__("Parent Category")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full" name="category_parent_id" id="category_parent_id">
                <option value="0">{__("Set as a Parent Category")}</option>
                {foreach $data["categories"] as $category}
                  {include file='__categories.recursive_options.tpl' data_category=$data['category_parent_id']}
                {/foreach}
              </select>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="category_order">{__("Order")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="category_order" id="category_order" value="{$data['category_order']}" autocomplete="off">
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
    </div>

  {/if}
</section>
