<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-blacklist-title">
  {if $sub_view == "add"}
    <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
  {/if}

  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-blacklist-title" class="text-2xl font-semibold">
        {if $sub_view == "add"}{__("Add to Blacklist")}{else}{__("Blacklist")}{/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "add"}
          {__("Block an IP address, email provider, or username from your community.")}
        {else}
          {__("Manage the IP addresses, email providers, and usernames blocked from your community.")}
        {/if}
      </p>
    </div>

    <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
      {if $sub_view == ""}
        <a href="{$system['system_url']}/{$control_panel['url']}/blacklist/add" class="btn btn-primary">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New")}
        </a>
      {else}
        <a href="{$system['system_url']}/{$control_panel['url']}/blacklist" class="btn btn-outline">
          <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
          {__("Go Back")}
        </a>
      {/if}
    </div>
  </header>

  {if $sub_view == ""}
    <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-error icon-[tabler--ban] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Total Entries")}">{__("Total Entries")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['total']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-warning icon-[tabler--world-off] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Blocked IPs")}">{__("Blocked IPs")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['ip']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-info icon-[tabler--mail-off] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Email Providers")}">{__("Email Providers")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['email']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-neutral icon-[tabler--user-off] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Usernames")}">{__("Usernames")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['username']|number_format}</p>
        </div>
      </article>
    </div>

    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Blacklist")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table js_dataTable admin-list-table">
            <thead>
              <tr>
                <th>{__("Entry")}</th>
                <th>{__("Type")}</th>
                <th>{__("Added")}</th>
                <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td data-order="{$row['node_id']}">
                    <div class="admin-list-identity flex min-w-0 items-center gap-3">
                      <span class="flex size-[38px] shrink-0 items-center justify-center rounded-md border border-base-300 bg-base-200">
                        {if $row['node_type'] == "ip"}
                          <span class="icon-[tabler--world-off] text-base-content/60 size-5" aria-hidden="true"></span>
                        {elseif $row['node_type'] == "email"}
                          <span class="icon-[tabler--mail-off] text-base-content/60 size-5" aria-hidden="true"></span>
                        {else}
                          <span class="icon-[tabler--user-off] text-base-content/60 size-5" aria-hidden="true"></span>
                        {/if}
                      </span>
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{$row['node_value']}">{$row['node_value']}</span>
                        <span class="admin-list-id text-xs">#{$row['node_id']|number_format}</span>
                      </span>
                    </div>
                  </td>
                  <td>
                    {if $row['node_type'] == "ip"}
                      <span class="badge badge-soft badge-error badge-sm rounded-full">{__("IP Address")}</span>
                    {elseif $row['node_type'] == "email"}
                      <span class="badge badge-soft badge-info badge-sm rounded-full">{__("Email Provider")}</span>
                    {else}
                      <span class="badge badge-soft badge-sm rounded-full">{__("Username")}</span>
                    {/if}
                  </td>
                  <td><span class="js_moment" data-time="{$row['created_time']}">{$row['created_time']}</span></td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="blacklist-actions-{$row['node_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['node_value']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="blacklist-actions-{$row['node_id']}">
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="blacklist_node" data-id="{$row['node_id']}">
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
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-blacklist-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--shield-check] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-blacklist-empty-title">{__("No blacklist entries yet")}</h2>
        <p>{__("Add an entry to block an IP address, email provider, or username.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/blacklist/add" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New")}
        </a>
      </section>
    {/if}

  {elseif $sub_view == "add"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/blacklist.php?do=add">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="blacklist-entry-title">
          <h2 id="blacklist-entry-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            <span class="icon-[tabler--ban] size-5" aria-hidden="true"></span>
            {__("Blacklist Entry")}
          </h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="blacklist-type-label">
            <div class="label-text" id="blacklist-type-label">{__("Type")}</div>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <div class="flex flex-wrap items-center gap-x-6 gap-y-3">
                <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                  <input type="radio" name="node_type" id="blacklist-type-ip" value="ip" class="radio radio-primary" checked aria-describedby="blacklist-type-help">
                  <label class="label-text cursor-pointer" for="blacklist-type-ip">{__("IP Address")}</label>
                </div>
                <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                  <input type="radio" name="node_type" id="blacklist-type-email" value="email" class="radio radio-primary" aria-describedby="blacklist-type-help">
                  <label class="label-text cursor-pointer" for="blacklist-type-email">{__("Email Provider")}</label>
                </div>
                <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                  <input type="radio" name="node_type" id="blacklist-type-username" value="username" class="radio radio-primary" aria-describedby="blacklist-type-help">
                  <label class="label-text cursor-pointer" for="blacklist-type-username">{__("Username")}</label>
                </div>
              </div>
              <div id="blacklist-type-help" class="admin-setting-help text-sm leading-relaxed">{__("Choose what you want to block.")}</div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="blacklist-value">{__("Value")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="node_value" id="blacklist-value" aria-describedby="blacklist-value-help" autocomplete="off">
              <div id="blacklist-value-help" class="admin-setting-help text-sm leading-relaxed">
                {__("Enter the exact value to block. Examples: 192.168.1.25, gmail.com, or superadmin.")}
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
  {/if}

  {if $sub_view == "add"}
    </div>
  {/if}
</section>
