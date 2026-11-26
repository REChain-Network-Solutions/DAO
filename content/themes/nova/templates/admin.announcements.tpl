<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-announcements-title">
  {if $sub_view == "add" || $sub_view == "edit"}
    <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
  {/if}

  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-announcements-title" class="text-2xl font-semibold">
        {if $sub_view == "add"}
          {__("Add Announcement")}
        {elseif $sub_view == "edit"}
          {__("Edit Announcement")}
        {else}
          {__("Announcements")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "add"}
          {__("Create a message and choose when it appears on the newsfeed.")}
        {elseif $sub_view == "edit"}
          {__("Update the message, appearance, and publishing window.")}
        {else}
          {__("Create and schedule messages that appear at the top of the newsfeed.")}
        {/if}
      </p>
    </div>

    <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
      {if $sub_view == ""}
        <a href="{$system['system_url']}/{$control_panel['url']}/announcements/add" class="btn btn-primary">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add Announcement")}
        </a>
      {else}
        <a href="{$system['system_url']}/{$control_panel['url']}/announcements" class="btn btn-outline">
          <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
          {__("Go Back")}
        </a>
      {/if}
    </div>
  </header>

  {if $sub_view == ""}
    <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-neutral icon-[tabler--speakerphone] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Total Announcements")}">{__("Total Announcements")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['total']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-success icon-[tabler--broadcast] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Active")}">{__("Active")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['active']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-info icon-[tabler--calendar-time] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Scheduled")}">{__("Scheduled")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['scheduled']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-warning icon-[tabler--calendar-off] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Expired")}">{__("Expired")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['expired']|number_format}</p>
        </div>
      </article>
    </div>

    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Announcements")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table js_dataTable admin-list-table">
            <thead>
              <tr>
                <th>{__("Announcement")}</th>
                <th>{__("Type")}</th>
                <th>{__("Schedule")}</th>
                <th>{__("Status")}</th>
                <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td data-order="{$row['announcement_id']}">
                    <div class="admin-list-identity flex min-w-0 items-center gap-3">
                      <span class="flex size-[38px] shrink-0 items-center justify-center rounded-md border border-base-300 bg-base-200">
                        {if $row['type'] == "success"}
                          <span class="icon-[tabler--circle-check] text-success size-5" aria-hidden="true"></span>
                        {elseif $row['type'] == "warning"}
                          <span class="icon-[tabler--alert-triangle] text-warning size-5" aria-hidden="true"></span>
                        {elseif $row['type'] == "danger"}
                          <span class="icon-[tabler--alert-circle] text-error size-5" aria-hidden="true"></span>
                        {else}
                          <span class="icon-[tabler--info-circle] text-info size-5" aria-hidden="true"></span>
                        {/if}
                      </span>
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <a class="admin-list-name truncate text-sm font-semibold" href="{$system['system_url']}/{$control_panel['url']}/announcements/edit/{$row['announcement_id']}" title="{$row['name']|escape:'html'}">{$row['name']|escape:'html'}</a>
                        <span class="admin-list-id truncate text-xs" title="{if $row['title']}{$row['title']|escape:'html'}{else}#{$row['announcement_id']|number_format}{/if}">{if $row['title']}{$row['title']|escape:'html'}{else}#{$row['announcement_id']|number_format}{/if}</span>
                      </span>
                    </div>
                  </td>
                  <td>
                    {if $row['type'] == "success"}
                      <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Success")}</span>
                    {elseif $row['type'] == "warning"}
                      <span class="badge badge-soft badge-warning badge-sm rounded-full">{__("Warning")}</span>
                    {elseif $row['type'] == "danger"}
                      <span class="badge badge-soft badge-error badge-sm rounded-full">{__("Danger")}</span>
                    {else}
                      <span class="badge badge-soft badge-info badge-sm rounded-full">{__("Info")}</span>
                    {/if}
                  </td>
                  <td data-order="{$row['start_date']}">
                    <div class="grid gap-1 text-sm">
                      <span class="admin-list-inline flex items-center gap-1.5 whitespace-nowrap"><span class="icon-[tabler--calendar-event] text-base-content/50 size-4" aria-hidden="true"></span>{$row['start_date']|date_format:"%e %b %Y, %H:%M"}</span>
                      <span class="admin-list-inline text-base-content/60 flex items-center gap-1.5 whitespace-nowrap"><span class="icon-[tabler--calendar-check] size-4" aria-hidden="true"></span>{$row['end_date']|date_format:"%e %b %Y, %H:%M"}</span>
                    </div>
                  </td>
                  <td>
                    {if $row['status'] == "active"}
                      <span class="badge badge-soft badge-success badge-sm gap-1 rounded-full"><span class="icon-[tabler--broadcast] size-3.5" aria-hidden="true"></span>{__("Active")}</span>
                    {elseif $row['status'] == "scheduled"}
                      <span class="badge badge-soft badge-info badge-sm gap-1 rounded-full"><span class="icon-[tabler--clock] size-3.5" aria-hidden="true"></span>{__("Scheduled")}</span>
                    {else}
                      <span class="badge badge-soft badge-warning badge-sm gap-1 rounded-full"><span class="icon-[tabler--calendar-off] size-3.5" aria-hidden="true"></span>{__("Expired")}</span>
                    {/if}
                  </td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="announcement-actions-{$row['announcement_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['name']|escape:'html'}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="announcement-actions-{$row['announcement_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/announcements/edit/{$row['announcement_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="announcement" data-id="{$row['announcement_id']}">
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
    {else}
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-announcements-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--speakerphone] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-announcements-empty-title">{__("No announcements yet")}</h2>
        <p>{__("Create an announcement to share an important message on the newsfeed.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/announcements/add" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add Announcement")}
        </a>
      </section>
    {/if}

  {elseif $sub_view == "add" || $sub_view == "edit"}
    <form class="js_ajax-forms admin-settings-form js_announcement-form flex min-w-0 flex-col gap-4" data-url="admin/announcements.php?do={if $sub_view == "edit"}edit&amp;id={$data['announcement_id']}{else}add{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="announcement-details-title">
          <h2 id="announcement-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            <span class="icon-[tabler--speakerphone] size-5" aria-hidden="true"></span>
            {__("Announcement Details")}
          </h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="announcement-name">{__("Name")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="name" id="announcement-name" value="{if $sub_view == "edit"}{$data['name']|escape:'html'}{/if}" aria-describedby="announcement-name-help" autocomplete="off" required>
              <div id="announcement-name-help" class="admin-setting-help text-sm leading-relaxed">{__("Used only in the admin panel to identify this announcement.")}</div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="announcement-title">{__("Title")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full js_announcement-title" name="title" id="announcement-title" value="{if $sub_view == "edit"}{$data['title']|escape:'html'}{/if}" aria-describedby="announcement-title-help" autocomplete="off">
              <div id="announcement-title-help" class="admin-setting-help text-sm leading-relaxed">{__("Shown above the announcement message. Leave it empty for a message without a title.")}</div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="announcement-type">{__("Type")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full js_announcement-type" name="type" id="announcement-type" aria-describedby="announcement-type-help">
                <option value="success" {if $sub_view == "edit" && $data['type'] == "success"}selected{/if}>{__("Success")}</option>
                <option value="warning" {if $sub_view == "edit" && $data['type'] == "warning"}selected{/if}>{__("Warning")}</option>
                <option value="danger" {if $sub_view == "edit" && $data['type'] == "danger"}selected{/if}>{__("Danger")}</option>
                <option value="info" {if $sub_view == "edit" && $data['type'] == "info"}selected{/if}>{__("Info")}</option>
              </select>
              <div id="announcement-type-help" class="admin-setting-help text-sm leading-relaxed">{__("Choose the visual tone that matches the message.")}</div>
            </div>
          </div>
        </div>

        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="announcement-content-title">
          <h2 id="announcement-content-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            <span class="icon-[tabler--align-left] size-5" aria-hidden="true"></span>
            {__("Content")}
          </h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="announcement-content">{__("Message")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <textarea class="textarea w-full js_wysiwyg-advanced js_announcement-content" id="announcement-content" rows="10" name="code">{if $sub_view == "edit"}{$data['code']}{/if}</textarea>
              <div class="admin-setting-help text-sm leading-relaxed">{__("Use the editor Preview command to inspect advanced HTML and embedded content.")}</div>
            </div>
          </div>
        </div>

        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="announcement-schedule-title">
          <h2 id="announcement-schedule-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            <span class="icon-[tabler--calendar-time] size-5" aria-hidden="true"></span>
            {__("Schedule")}
          </h2>

          <div class="grid min-w-0 grid-cols-1 gap-5 sm:grid-cols-2">
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="announcement-start-date">{__("Start Date")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="datetime-local" class="input w-full" name="start_date" id="announcement-start-date" value="{if $sub_view == "edit"}{$data['start_date']|date_format:"%Y-%m-%dT%H:%M"}{/if}" aria-describedby="announcement-schedule-help" required>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="announcement-end-date">{__("End Date")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="datetime-local" class="input w-full" name="end_date" id="announcement-end-date" value="{if $sub_view == "edit"}{$data['end_date']|date_format:"%Y-%m-%dT%H:%M"}{/if}" aria-describedby="announcement-schedule-help" required>
              </div>
            </div>
          </div>
          <div id="announcement-schedule-help" class="admin-setting-help text-sm leading-relaxed">{__("Times use the server clock. Your current server datetime is")}: {$date} (UTC)</div>
        </div>

        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="announcement-preview-title">
          <div class="flex min-w-0 items-center justify-between gap-3">
            <h2 id="announcement-preview-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              <span class="icon-[tabler--eye] size-5" aria-hidden="true"></span>
              {__("Live Preview")}
            </h2>
            <span class="badge badge-soft badge-sm rounded-full">{__("Preview only")}</span>
          </div>

          <div class="js_announcement-preview flex items-start gap-3 rounded-box border border-success/20 bg-success/10 p-3 sm:p-4" role="presentation">
            <div class="min-w-0 grow self-center [overflow-wrap:anywhere]">
              <div class="js_announcement-preview-title font-semibold text-base-content"{if $sub_view != "edit" || !$data['title']} style="display: none"{/if}>{if $sub_view == "edit"}{$data['title']|escape:'html'}{/if}</div>
              <div class="js_announcement-preview-body text-sm text-base-content/70 [&_a]:link [&_a]:link-primary">{__("Your announcement message will appear here.")}</div>
            </div>
            <span class="btn btn-text btn-circle btn-sm pointer-events-none shrink-0 text-base-content/60" aria-hidden="true">
              <span class="icon-[tabler--x] size-4"></span>
            </span>
          </div>
          <div class="admin-setting-help text-sm leading-relaxed">{__("Scripts, embedded styles, and inline actions are removed from this preview only.")}</div>
        </div>

        <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
          <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
            <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
            <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
          </div>
          <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
            <button type="submit" class="btn btn-primary">
              <span class="icon-[tabler--device-floppy] size-4" aria-hidden="true"></span>
              {if $sub_view == "add"}{__("Create Announcement")}{else}{__("Save Changes")}{/if}
            </button>
          </div>
        </div>
      </section>
    </form>
  {/if}

  {if $sub_view == "add" || $sub_view == "edit"}
    </div>
  {/if}
</section>
