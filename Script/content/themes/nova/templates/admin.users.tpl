<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-users-title">
  {if $sub_view != "edit"}
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-users-title" class="text-2xl font-semibold">
        {if $sub_view == "edit"}
          {$data['user_fullname']}
        {elseif $sub_view == "admins"}
          {__("Admins")}
        {elseif $sub_view == "moderators"}
          {__("Moderators")}
        {elseif $sub_view == "online"}
          {__("Online")}
        {elseif $sub_view == "banned"}
          {__("Banned")}
        {elseif $sub_view == "not_activated"}
          {__("Not Activated")}
        {elseif $sub_view == "pending"}
          {__("Pending")}
        {elseif $sub_view == "find"}
          {__("Find")}
        {elseif $sub_view == "stats"}
          {__("Stats")}
        {elseif $sub_view == "" && $cug}
          {__($cug['user_group_title']|capitalize)}
        {elseif $sub_view == "" && $ncug}
          {__("Default")}
        {else}
          {__("Users")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "edit"}
          {__("Review this account and update profile, privacy, and access settings.")}
        {elseif $sub_view == "admins"}
          {__("Administrators who can manage the control panel.")}
        {elseif $sub_view == "moderators"}
          {__("Moderators with limited control panel access.")}
        {elseif $sub_view == "online"}
          {__("Accounts that are currently online.")}
        {elseif $sub_view == "banned"}
          {__("Accounts that are banned from the website.")}
        {elseif $sub_view == "not_activated"}
          {__("Accounts waiting to activate their email or phone.")}
        {elseif $sub_view == "pending"}
          {__("Accounts waiting for admin approval.")}
        {elseif $sub_view == "find"}
          {__("Search results for username, name, email, or phone.")}
        {elseif $sub_view == "stats"}
          {__("Compare accounts by posts published in a date range.")}
        {elseif $sub_view == "" && ($cug || $ncug)}
          {__("Accounts in this users group.")}
        {else}
          {__("Manage members, approvals, and account access.")}
        {/if}
      </p>
    </div>

    {if $sub_view == "" || $sub_view == "admins" || $sub_view == "moderators" || $sub_view == "banned" || $sub_view == "stats" || $sub_view == "find" || $sub_view == "edit"}
      <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
        {if $sub_view == "" && ($cug || $ncug)}
          <a href="{$system['system_url']}/{$control_panel['url']}/users" class="btn btn-outline">
            <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
            {__("Go Back")}
          </a>
        {/if}
        {if $sub_view == ""}
          <button type="button" class="js_modal btn btn-primary" data-url="#export-csv" data-options='{ "handle": "users" }'>
            <span class="icon-[tabler--file-spreadsheet] size-4" aria-hidden="true"></span>
            {__("Export CSV")}
          </button>
        {elseif $sub_view == "admins"}
          <button type="button" class="js_modal btn btn-primary" data-url="#export-csv" data-options='{ "handle": "admins" }'>
            <span class="icon-[tabler--file-spreadsheet] size-4" aria-hidden="true"></span>
            {__("Export CSV")}
          </button>
        {elseif $sub_view == "moderators"}
          <button type="button" class="js_modal btn btn-primary" data-url="#export-csv" data-options='{ "handle": "moderators" }'>
            <span class="icon-[tabler--file-spreadsheet] size-4" aria-hidden="true"></span>
            {__("Export CSV")}
          </button>
        {elseif $sub_view == "banned"}
          <a href="{$system['system_url']}/{$control_panel['url']}/blacklist" class="btn btn-outline">
            <span class="icon-[tabler--ban] size-4" aria-hidden="true"></span>
            {__("Manage Banned IPs")}
          </a>
        {elseif $sub_view == "stats"}
          <a href="{$system['system_url']}/{$control_panel['url']}/users/stats" class="btn btn-outline">
            <span class="icon-[tabler--refresh] size-4" aria-hidden="true"></span>
            {__("Reset")}
          </a>
          <button type="button" class="js_modal btn btn-primary" data-url="#export-csv" data-options='{ "handle": "users_stats", "from": "{$from}", "to": "{$to}" }'>
            <span class="icon-[tabler--file-spreadsheet] size-4" aria-hidden="true"></span>
            {__("Export CSV")}
          </button>
        {elseif $sub_view == "find" || $sub_view == "edit"}
          <a href="{$system['system_url']}/{$control_panel['url']}/users" class="btn btn-outline">
            <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
            {__("Go Back")}
          </a>
        {/if}
      </div>
    {/if}
  </header>
  {/if}

  {if $sub_view == "" || $sub_view == "admins" || $sub_view == "moderators" || $sub_view == "online" || $sub_view == "banned" || $sub_view == "not_activated" || $sub_view == "pending" || $sub_view == "find"}

    {if $sub_view == ""}
      <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-info icon-[tabler--users] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Users")}">{__("Users")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['users']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-warning icon-[tabler--clock] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Pending Users")}">{__("Pending Users")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['pending']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-neutral icon-[tabler--mail] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Not Activated")}">{__("Not Activated")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['not_activated']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-error icon-[tabler--ban] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Banned")}">{__("Banned")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['banned']|number_format}</p>
          </div>
        </article>
      </div>
    {/if}

    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Users")}">
      <div class="js-flyonui-datatable-toolbar border-base-300 flex items-center justify-between gap-3 border-b px-5 py-3 max-md:flex-wrap">
        <form class="input max-w-60" action="{$system['system_url']}/{$control_panel['url']}/users/find" method="get" role="search">
          <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
          <input type="search" class="grow" name="query" id="admin-users-query" value="{if $query}{$query}{/if}" placeholder="{__("Search")}" title="{__("Search by Username, First Name, Last Name, Email or Phone")}" aria-label="{__("Search by Username, First Name, Last Name, Email or Phone")}" autocomplete="off">
        </form>
      </div>
      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("User")}</th>
                <th>{__("Username")}</th>
                <th>{__("Joined")}</th>
                <th>{__("Activated")}</th>
                <th>{__("Approved")}</th>
                <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/{$row['user_name']}">
                      <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['user_picture']}" alt="" width="30" height="30" loading="lazy">
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{$row['user_firstname']} {$row['user_lastname']}">{$row['user_firstname']} {$row['user_lastname']}</span>
                        <span class="admin-list-id text-xs">#{$row['user_id']}</span>
                      </span>
                    </a>
                  </td>
                  <td>
                    <a href="{$system['system_url']}/{$row['user_name']}" target="_blank">{$row['user_name']}</a>
                  </td>
                  <td>{$row['user_registered']|date_format:"%e %B %Y"}</td>
                  <td>
                    {if $row['user_activated']}
                      <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Yes")}</span>
                    {else}
                      <span class="badge badge-soft badge-sm rounded-full">{__("No")}</span>
                    {/if}
                  </td>
                  <td>
                    {if $row['user_approved']}
                      <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Yes")}</span>
                    {else}
                      <span class="badge badge-soft badge-sm rounded-full">{__("No")}</span>
                    {/if}
                  </td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="user-actions-{$row['user_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['user_firstname']} {$row['user_lastname']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="user-actions-{$row['user_id']}">
                        {if $sub_view == "pending"}
                          <li>
                            <button type="button" class="dropdown-item px-2 js_user-approve" role="menuitem" data-id="{$row['user_id']}">
                              <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
                              {__("Approve")}
                            </button>
                          </li>
                        {/if}
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/users/edit/{$row['user_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="user" data-id="{$row['user_id']}">
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
        <div class="admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none admin-list-empty-inline min-h-60 border-0 bg-transparent" aria-labelledby="admin-users-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--users] size-6" aria-hidden="true"></span>
          </div>
          <h2 id="admin-users-empty-title">{__("No users found")}</h2>
          <p>{__("Try another search or open a different users list.")}</p>
        </div>
      {/if}
    </section>

  {elseif $sub_view == "stats"}

    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Users Stats")}">
      <div class="js-flyonui-datatable-toolbar border-base-300 flex items-center justify-between gap-3 border-b px-5 py-3 max-md:flex-wrap">
        <form class="input max-w-60 js_search-forms" method="get" role="search">
          <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
          <input type="search" class="grow" name="query" id="admin-users-stats-query" value="{$query}" placeholder="{__("Search")}" title="{__("Search by Username, First Name, Last Name, Email or Phone")}" aria-label="{__("Search by Username, First Name, Last Name, Email or Phone")}" autocomplete="off">
        </form>
        <form class="admin-list-range-inline flex flex-wrap items-center gap-2" action="{$system['system_url']}/{$control_panel['url']}/users/stats" method="get">
          <input type="date" class="input" name="from" value="{$from}" aria-label="{__("From")}" required>
          <input type="date" class="input" name="to" value="{$to}" aria-label="{__("To")}" required>
          <button type="submit" class="btn btn-outline h-9 min-h-9">
            <span class="icon-[tabler--filter] size-4" aria-hidden="true"></span>
            {__("Filter")}
          </button>
        </form>
      </div>
      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("User")}</th>
                <th>{__("Username")}</th>
                <th>{__("Date Range")}</th>
                <th>{__("Posts Count")}</th>
                <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/{$row['user_name']}">
                      <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['user_picture']}" alt="" width="30" height="30" loading="lazy">
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{$row['user_firstname']} {$row['user_lastname']}">{$row['user_firstname']} {$row['user_lastname']}</span>
                        <span class="admin-list-id text-xs">#{$row['user_id']}</span>
                      </span>
                    </a>
                  </td>
                  <td>
                    <a href="{$system['system_url']}/{$row['user_name']}" target="_blank">{$row['user_name']}</a>
                  </td>
                  <td>
                    {if $from && $to}
                      {$from|date_format:"%e %b %Y"} - {$to|date_format:"%e %b %Y"}
                    {else}
                      {__("All Time")}
                    {/if}
                  </td>
                  <td>{$row['posts_count']}</td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="user-stats-actions-{$row['user_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['user_firstname']} {$row['user_lastname']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="user-stats-actions-{$row['user_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/users/edit/{$row['user_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="user" data-id="{$row['user_id']}">
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
        <div class="admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none admin-list-empty-inline min-h-60 border-0 bg-transparent" aria-labelledby="admin-users-stats-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--chart-bar] size-6" aria-hidden="true"></span>
          </div>
          <h2 id="admin-users-stats-empty-title">{__("No users found")}</h2>
          <p>{__("Try another search or a different date range.")}</p>
        </div>
      {/if}
    </section>

  {elseif $sub_view == "edit"}

    <header class="admin-user-hero flex min-w-0 flex-col gap-5 border-b border-base-300 pb-5 sm:flex-row sm:items-center sm:justify-between" aria-labelledby="admin-users-title">
      <div class="admin-user-hero-identity flex min-w-0 items-center gap-4">
        <a class="admin-user-summary-photo size-16 shrink-0 overflow-hidden rounded-full border border-base-300 bg-base-200 focus-visible:outline-2 focus-visible:outline-offset-2" href="{$system['system_url']}/{$data['user_name']}" target="_blank" aria-label="{__("View Profile")}: {$data['user_fullname']}">
          <img src="{$data['user_picture']}" alt="{$data['user_fullname']}">
        </a>
        <div class="min-w-0">
          <h1 id="admin-users-title" class="m-0 truncate text-2xl font-semibold" title="{$data['user_fullname']}">
            <a class="text-inherit hover:underline focus-visible:underline focus-visible:outline-none" href="{$system['system_url']}/{$data['user_name']}" target="_blank">{$data['user_fullname']}</a>
          </h1>
          <div class="admin-user-hero-meta mt-1 flex min-w-0 flex-wrap items-center gap-2">
            <a class="admin-user-summary-handle truncate" href="{$system['system_url']}/{$data['user_name']}" target="_blank" title="@{$data['user_name']}">@{$data['user_name']}</a>
            {if $data['user_banned']}
              <span class="badge badge-soft badge-error badge-sm rounded-full">{__("Banned")}</span>
            {elseif $data['user_activated']}
              <span class="badge badge-soft badge-success badge-sm rounded-full admin-user-hero-badge is-active">{__("Active")}</span>
            {else}
              <span class="badge badge-soft badge-warning badge-sm rounded-full">{__("Not Activated")}</span>
            {/if}
            {if $data['user_verified']}
              <span class="badge badge-soft badge-info badge-sm rounded-full admin-user-hero-badge is-verified">
                <span class="icon-[tabler--rosette-discount-check] size-3.5" aria-hidden="true"></span>
                {__("Verified")}
              </span>
            {/if}
          </div>
        </div>
      </div>
      <div class="admin-user-hero-actions flex shrink-0 flex-wrap items-center gap-2">
        <a class="btn btn-outline" href="{$system['system_url']}/{$control_panel['url']}/users">
          <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
          {__("Go Back")}
        </a>
      </div>
    </header>

    <div class="admin-user-edit grid w-full gap-6">
      <div class="admin-user-edit-aside flex min-w-0 flex-col gap-4 lg:sticky lg:top-[5.5rem]">
      <aside class="admin-user-summary flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6" aria-label="{__("Account summary")}">
        <div class="admin-user-sidebar-heading flex min-w-0 items-center gap-3">
          <div class="admin-user-sidebar-heading-icon flex size-8 shrink-0 items-center justify-center rounded-md border border-base-300 bg-base-100">
            <span class="icon-[tabler--address-book] size-4" aria-hidden="true"></span>
          </div>
          <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug">{__("Account Details")}</h2>
        </div>
        <ul class="admin-user-summary-list grid gap-3">
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--id] size-3.5" aria-hidden="true"></span>{__("User ID")}</span>
            <span class="admin-user-summary-value flex items-center justify-end gap-1">
              <span>{$data['user_id']}</span>
              <button type="button" class="admin-user-copy-button js_clipboard" data-clipboard-text="{$data['user_id']}" title="{__("Copy")}" aria-label="{__("Copy")} {__("User ID")}">
                <span class="js-clipboard-default icon-[tabler--copy] size-3.5" aria-hidden="true"></span>
                <span class="js-clipboard-success icon-[tabler--check] hidden size-3.5 text-success" aria-hidden="true"></span>
              </button>
            </span>
          </li>
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--calendar] size-3.5" aria-hidden="true"></span>{__("Joined")}</span>
            <span class="admin-user-summary-value">{$data['user_registered']|date_format:"%e %B %Y"}</span>
          </li>
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--login] size-3.5" aria-hidden="true"></span>{__("Last Login")}</span>
            <span class="admin-user-summary-value">{$data['user_last_seen']|date_format:"%e %B %Y"}</span>
          </li>
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--user-share] size-3.5" aria-hidden="true"></span>{__("Referrer")}</span>
            {if $data['user_referrer']}
              <span class="admin-user-summary-value">
                <a class="admin-user-referrer" href="{$system['system_url']}/{$data['user_referrer']['user_name']}" target="_blank">
                  <img class="admin-list-avatar size-[22px] shrink-0 rounded-full object-cover" src="{$data['user_referrer']['user_picture']}" alt="" width="22" height="22" loading="lazy">
                  <span>{$data['user_referrer']['user_fullname']}</span>
                </a>
              </span>
            {else}
              <span class="admin-user-summary-value">{__("None")}</span>
            {/if}
          </li>
          {if $system['friends_enabled']}
            <li>
              <span class="admin-user-summary-label"><span class="icon-[tabler--users] size-3.5" aria-hidden="true"></span>{__("Friends")}</span>
              <span class="admin-user-summary-value">{$data['friends']|number_format}</span>
            </li>
          {/if}
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--user-plus] size-3.5" aria-hidden="true"></span>{__("Followings")}</span>
            <span class="admin-user-summary-value">{$data['followings']|number_format}</span>
          </li>
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--user-check] size-3.5" aria-hidden="true"></span>{__("Followers")}</span>
            <span class="admin-user-summary-value">{$data['followers']|number_format}</span>
          </li>
          <li>
            <span class="admin-user-summary-label"><span class="icon-[tabler--file-text] size-3.5" aria-hidden="true"></span>{__("Posts")}</span>
            <span class="admin-user-summary-value">{$data['posts_count']|number_format}</span>
          </li>
        </ul>
        <div class="admin-user-summary-actions grid gap-2 border-t border-base-300 pt-5">
          <a class="btn btn-outline w-full" href="{$system['system_url']}/{$data['user_name']}" target="_blank">
            <span class="icon-[tabler--arrow-up-right] size-4" aria-hidden="true"></span>
            {__("View Profile")}
          </a>
          {if $user->_is_admin && $data['user_id'] != $user->_data['user_id']}
            <button type="button" class="btn btn-outline w-full js_login-as" data-id="{$data['user_id']}" data-handle="connect">
              <span class="icon-[tabler--login] size-4" aria-hidden="true"></span>
              {__("Login As")}
            </button>
          {/if}
        </div>
      </aside>

      <section class="admin-user-danger flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6" aria-labelledby="admin-user-danger-title">
        <div class="admin-user-sidebar-heading flex min-w-0 items-center gap-3">
          <div class="admin-user-sidebar-heading-icon is-danger flex size-8 shrink-0 items-center justify-center rounded-md border bg-base-100">
            <span class="icon-[tabler--alert-triangle] size-4" aria-hidden="true"></span>
          </div>
          <h2 id="admin-user-danger-title" class="admin-user-danger-title m-0 text-sm font-semibold leading-snug text-error">{__("Danger Zone")}</h2>
        </div>
        <p class="admin-setting-help m-0 text-sm leading-relaxed">{__("Resetting info, deleting posts or this account cannot be undone.")}</p>
        <div class="admin-user-summary-actions grid gap-2">
          <button type="button" class="btn w-full text-error admin-user-danger-action js_admin-deleter" data-handle="user_profile" data-id="{$data['user_id']}" data-confirm-title="{__("Reset User")}" data-delete-message="{__("All profile info except name, gender, country and birthdate will be cleared. Are you sure?")}">
            <span class="icon-[tabler--restore] size-4" aria-hidden="true"></span>
            {__("Reset User")}
          </button>
          <button type="button" class="btn w-full text-error admin-user-danger-action js_admin-deleter" data-handle="user_posts" data-id="{$data['user_id']}" data-delete-message="{__("Are you sure you want to delete all posts?")}">
            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
            {__("Delete Posts")}
          </button>
          <button type="button" class="btn w-full text-error admin-user-danger-action js_admin-deleter" data-handle="user" data-id="{$data['user_id']}" data-redirect="{$system['system_url']}/{$control_panel['url']}/users">
            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
            {__("Delete User")}
          </button>
        </div>
      </section>
      </div>

      <div class="admin-user-edit-main flex min-w-0 flex-col gap-6">
      <nav class="tabs admin-settings-nav admin-user-edit-nav" role="tablist" aria-label="{__("User Settings")}" aria-orientation="horizontal">
        <button type="button" id="users-tab-account" class="tab active-tab:tab-active active" data-tab="#account" aria-controls="account" role="tab" aria-selected="true"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("Account")}</button>
        <button type="button" id="users-tab-profile" class="tab active-tab:tab-active" data-tab="#profile" aria-controls="profile" role="tab" aria-selected="false"><span class="icon-[tabler--user] size-4" aria-hidden="true"></span>{__("Profile")}</button>
        <button type="button" id="users-tab-privacy" class="tab active-tab:tab-active" data-tab="#privacy" aria-controls="privacy" role="tab" aria-selected="false"><span class="icon-[tabler--lock] size-4" aria-hidden="true"></span>{__("Privacy")}</button>
        <button type="button" id="users-tab-security" class="tab active-tab:tab-active" data-tab="#security" aria-controls="security" role="tab" aria-selected="false"><span class="icon-[tabler--shield] size-4" aria-hidden="true"></span>{__("Security")}</button>
        {if $system['packages_enabled']}
          <button type="button" id="users-tab-membership" class="tab active-tab:tab-active" data-tab="#membership" aria-controls="membership" role="tab" aria-selected="false"><span class="icon-[tabler--id] size-4" aria-hidden="true"></span>{__("Membership")}</button>
        {/if}
        {if $system['wallet_enabled'] || $system['points_enabled']}
          <button type="button" id="users-tab-extra" class="tab active-tab:tab-active" data-tab="#extra" aria-controls="extra" role="tab" aria-selected="false"><span class="icon-[tabler--box] size-4" aria-hidden="true"></span>{__("Extra")}</button>
        {/if}
      </nav>

      <div id="account" class="admin-settings-panel js_admin-settings-panel" role="tabpanel" aria-labelledby="users-tab-account" tabindex="0">
        <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/users.php?id={$data['user_id']}&do=edit_account">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-account-status-title">
              <h2 id="user-account-status-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Account Status")}</h2>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  <span class="icon-[tabler--rosette-discount-check] size-6" aria-hidden="true"></span>
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="user_verified">{__("Verified User")}</label>
                  <div id="user_verified-help" class="admin-setting-help text-sm leading-relaxed">{__("If enabled this user will have a verified badge")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="user_verified" id="user_verified" {if $data['user_verified']}checked{/if} aria-describedby="user_verified-help">
                </div>
              </div>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  <span class="icon-[tabler--ban] size-6" aria-hidden="true"></span>
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="user_banned">{__("Banned")}</label>
                  <div id="user_banned-help" class="admin-setting-help text-sm leading-relaxed">{__("If enabled this user will not be able to access the website")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="user_banned" id="user_banned" {if $data['user_banned']}checked{/if} aria-describedby="user_banned-help">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_banned_message">{__("Ban Message")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <textarea class="textarea w-full" name="user_banned_message" id="user_banned_message" rows="3" aria-describedby="user_banned_message-help">{$data['user_banned_message']}</textarea>
                  <div id="user_banned_message-help" class="admin-setting-help text-sm leading-relaxed">{__("The message that is presented on this profile, if empty 404 error will be used instead")}</div>
                </div>
              </div>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  <span class="icon-[tabler--circle-check] size-6" aria-hidden="true"></span>
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="user_activated">{__("Account Activated")}</label>
                  <div id="user_activated-help" class="admin-setting-help text-sm leading-relaxed">
                    {if !$system['activation_enabled']}
                      {__("Account activation disabled from your system")} <a target="_blank" href="{$system['system_url']}/{$control_panel['url']}/settings/registration">{__("Registration Settings")}</a>
                    {else}
                      {if $system['activation_type'] == "email"}
                        {__("Account activation enabled from your system settings by")} {__("Email")}
                      {else}
                        {__("Account activation enabled from your system settings by")} {__("SMS")}
                      {/if}
                    {/if}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="user_activated" id="user_activated" {if $data['user_activated']}checked{/if} aria-describedby="user_activated-help">
                </div>
              </div>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  <span class="icon-[tabler--flag] size-6" aria-hidden="true"></span>
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="user_started">{__("Getting Started")}</label>
                  <div id="user_started-help" class="admin-setting-help text-sm leading-relaxed">{__("If enabled user will see the getting started page")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="user_started" id="user_started" {if $data['user_started']}checked{/if} aria-describedby="user_started-help">
                </div>
              </div>

              {if $system['two_factor_enabled'] && $data['user_two_factor_enabled']}
                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    <span class="icon-[tabler--shield-lock] size-6" aria-hidden="true"></span>
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="user_two_factor_enabled">{__("Two-Factor Authentication")}</label>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="user_two_factor_enabled" id="user_two_factor_enabled" {if $data['user_two_factor_enabled']}checked{/if}>
                  </div>
                </div>
              {/if}

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  <span class="icon-[tabler--device-desktop] size-6" aria-hidden="true"></span>
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="user_demo">{__("Demo Account")}</label>
                  <div id="user_demo-help" class="admin-setting-help text-sm leading-relaxed">{__("If demo mode enabled this user will not be able to do anything")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="user_demo" id="user_demo" {if $data['user_demo']}checked{/if} aria-describedby="user_demo-help">
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-account-details-title">
              <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
                <h2 id="user-account-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Account Details")}</h2>
                {if $user->_is_admin && $data['user_id'] != $user->_data['user_id']}
                  <button type="button" class="btn btn-outline btn-sm js_login-as" data-id="{$data['user_id']}" data-handle="connect">
                    <span class="icon-[tabler--login] size-4" aria-hidden="true"></span>
                    {__("Login As")}
                  </button>
                {/if}
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_group">{__("User Group")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="user_group" id="user_group" aria-describedby="user_group-help">
                    <option value="1" {if $data['user_group'] == '1'}selected{/if}>{__("Administrators")}</option>
                    <option value="2" {if $data['user_group'] == '2'}selected{/if}>{__("Moderators")}</option>
                    <option value="3" {if $data['user_group'] == '3' && !$data['user_group_custom']}selected{/if}>{__("Users")}</option>
                    {foreach $data['user_groups'] as $user_group}
                      <option value="cusg_{$user_group['user_group_id']}" {if $data['user_group_custom'] == $user_group['user_group_id']}selected{/if}>{$user_group['user_group_title']}</option>
                    {/foreach}
                  </select>
                  <div id="user_group-help" class="admin-setting-help text-sm leading-relaxed">{__("If user subscribed to a package so this package permissions will be used instead")}</div>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_name">{__("Username")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="user_name" id="user_name" value="{$data['user_name']}" autocomplete="off">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_email">{__("Email Address")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="user_email" id="user_email" value="{$data['user_email']}" autocomplete="off">
                </div>
              </div>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  <span class="icon-[tabler--mail-check] size-6" aria-hidden="true"></span>
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="user_email_verified">{__("Email Verified")}</label>
                  <div id="user_email_verified-help" class="admin-setting-help text-sm leading-relaxed">{__("If enabled this email address will be marked as verified")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="user_email_verified" id="user_email_verified" {if $data['user_email_verified']}checked{/if} aria-describedby="user_email_verified-help">
                </div>
              </div>

              {if ($system['activation_enabled'] && $system['activation_type'] == "sms") || ($system['two_factor_enabled'] && $system['two_factor_type'] == "sms")}
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="user_phone">{__("Phone Number")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="user_phone" id="user_phone" value="{$data['user_phone']}" aria-describedby="user_phone-help" autocomplete="off">
                    <div id="user_phone-help" class="admin-setting-help text-sm leading-relaxed">{__("Phone number (eg. +905...)")}</div>
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    <span class="icon-[tabler--device-mobile-check] size-6" aria-hidden="true"></span>
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="user_phone_verified">{__("Phone Verified")}</label>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="user_phone_verified" id="user_phone_verified" {if $data['user_phone_verified']}checked{/if}>
                  </div>
                </div>
              {/if}

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_password">{__("Password")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="password" class="input w-full" name="user_password" id="user_password" autocomplete="new-password">
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

      <div id="profile" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="users-tab-profile" tabindex="0">
        <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/users.php?id={$data['user_id']}&do=edit_profile">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-profile-basic-title">
              <h2 id="user-profile-basic-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--user] size-5" aria-hidden="true"></span>{__("Basic")}</h2>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_firstname">{__("First Name")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input class="input w-full" name="user_firstname" id="user_firstname" value="{$data['user_firstname']}" autocomplete="off">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_lastname">{__("Last Name")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input class="input w-full" name="user_lastname" id="user_lastname" value="{$data['user_lastname']}" autocomplete="off">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_gender">{__("I am")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="user_gender" id="user_gender">
                    <option value="none">{__("Select Sex")}:</option>
                    {foreach $genders as $gender}
                      <option {if $data['user_gender'] == $gender['gender_id']}selected{/if} value="{$gender['gender_id']}">{$gender['gender_name']}</option>
                    {/foreach}
                  </select>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_relationship">{__("Relationship Status")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="user_relationship" id="user_relationship">
                    <option value="none">{__("Select Relationship")}</option>
                    <option {if $data['user_relationship'] == "single"}selected{/if} value="single">{__("Single")}</option>
                    <option {if $data['user_relationship'] == "relationship"}selected{/if} value="relationship">{__("In a relationship")}</option>
                    <option {if $data['user_relationship'] == "married"}selected{/if} value="married">{__("Married")}</option>
                    <option {if $data['user_relationship'] == "complicated"}selected{/if} value="complicated">{__("It's complicated")}</option>
                    <option {if $data['user_relationship'] == "separated"}selected{/if} value="separated">{__("Separated")}</option>
                    <option {if $data['user_relationship'] == "divorced"}selected{/if} value="divorced">{__("Divorced")}</option>
                    <option {if $data['user_relationship'] == "widowed"}selected{/if} value="widowed">{__("Widowed")}</option>
                  </select>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_country">{__("Country")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="user_country" id="user_country">
                    <option value="none">{__("Select Country")}</option>
                    {foreach $countries as $country}
                      <option {if $data['user_country'] == $country['country_id']}selected{/if} value="{$country['country_id']}">{$country['country_name_with_flag']}</option>
                    {/foreach}
                  </select>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_website">{__("Website")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="user_website" id="user_website" value="{$data['user_website']}" autocomplete="off">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <div class="label-text">{__("Birthdate")}</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-user-birthdate grid grid-cols-3 gap-2">
                    <select class="select w-full" name="birth_month" aria-label="{__("Select Month")}">
                      <option value="none">{__("Select Month")}</option>
                      <option {if $data['user_birthdate_parsed']['month'] == '1'}selected{/if} value="1">{__("Jan")}</option>
                      <option {if $data['user_birthdate_parsed']['month'] == '2'}selected{/if} value="2">{__("Feb")}</option>
                      <option {if $data['user_birthdate_parsed']['month'] == '3'}selected{/if} value="3">{__("Mar")}</option>
                      <option {if $data['user_birthdate_parsed']['month'] == '4'}selected{/if} value="4">{__("Apr")}</option>
                      <option {if $data['user_birthdate_parsed']['month'] == '5'}selected{/if} value="5">{__("May")}</option>
                      <option {if $data['user_birthdate_parsed']['month'] == '6'}selected{/if} value="6">{__("Jun")}</option>
                      <option {if $data['user_birthdate_parsed']['month'] == '7'}selected{/if} value="7">{__("Jul")}</option>
                      <option {if $data['user_birthdate_parsed']['month'] == '8'}selected{/if} value="8">{__("Aug")}</option>
                      <option {if $data['user_birthdate_parsed']['month'] == '9'}selected{/if} value="9">{__("Sep")}</option>
                      <option {if $data['user_birthdate_parsed']['month'] == '10'}selected{/if} value="10">{__("Oct")}</option>
                      <option {if $data['user_birthdate_parsed']['month'] == '11'}selected{/if} value="11">{__("Nov")}</option>
                      <option {if $data['user_birthdate_parsed']['month'] == '12'}selected{/if} value="12">{__("Dec")}</option>
                    </select>
                    <select class="select w-full" name="birth_day" aria-label="{__("Select Day")}">
                      <option value="none">{__("Select Day")}</option>
                      {for $i=1 to 31}
                        <option {if $data['user_birthdate_parsed']['day'] == $i}selected{/if} value="{$i}">{$i}</option>
                      {/for}
                    </select>
                    <select class="select w-full" name="birth_year" aria-label="{__("Select Year")}">
                      <option value="none">{__("Select Year")}</option>
                      {for $i=1905 to 2015}
                        <option {if $data['user_birthdate_parsed']['year'] == $i}selected{/if} value="{$i}">{$i}</option>
                      {/for}
                    </select>
                  </div>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_biography">{__("About Me")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <textarea class="textarea w-full" name="user_biography" id="user_biography" rows="4">{$data['user_biography']}</textarea>
                </div>
              </div>

              {if $custom_fields['basic']}
                {include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
              {/if}
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-profile-work-title">
              <h2 id="user-profile-work-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--briefcase] size-5" aria-hidden="true"></span>{__("Work")}</h2>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_work_title">{__("Work Title")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="user_work_title" id="user_work_title" value="{$data['user_work_title']}" autocomplete="off">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_work_place">{__("Work Place")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="user_work_place" id="user_work_place" value="{$data['user_work_place']}" autocomplete="off">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_work_url">{__("Work Website")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="user_work_url" id="user_work_url" value="{$data['user_work_url']}" autocomplete="off">
                </div>
              </div>

              {if $custom_fields['work']}
                {include file='__custom_fields.tpl' _custom_fields=$custom_fields['work'] _registration=false}
              {/if}
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-profile-location-title">
              <h2 id="user-profile-location-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--map-pin] size-5" aria-hidden="true"></span>{__("Location")}</h2>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_current_city">{__("Current City")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="user_current_city" id="user_current_city" value="{$data['user_current_city']}" autocomplete="off">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_hometown">{__("Hometown")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="user_hometown" id="user_hometown" value="{$data['user_hometown']}" autocomplete="off">
                </div>
              </div>

              {if $custom_fields['location']}
                {include file='__custom_fields.tpl' _custom_fields=$custom_fields['location'] _registration=false}
              {/if}
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-profile-education-title">
              <h2 id="user-profile-education-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--school] size-5" aria-hidden="true"></span>{__("Education")}</h2>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_edu_school">{__("School")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="user_edu_school" id="user_edu_school" value="{$data['user_edu_school']}" autocomplete="off">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_edu_major">{__("Major")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="user_edu_major" id="user_edu_major" value="{$data['user_edu_major']}" autocomplete="off">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="user_edu_class">{__("Class")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="user_edu_class" id="user_edu_class" value="{$data['user_edu_class']}" autocomplete="off">
                </div>
              </div>

              {if $custom_fields['education']}
                {include file='__custom_fields.tpl' _custom_fields=$custom_fields['education'] _registration=false}
              {/if}
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-profile-social-title">
              <h2 id="user-profile-social-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--share] size-5" aria-hidden="true"></span>{__("Social Links")}</h2>

              <div class="admin-social-fields grid min-w-0 gap-5 md:grid-cols-2">
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="facebook">{__("Facebook Profile URL")}</label>
                  <div class="admin-setting-control join w-full min-w-0">
                    <span class="join-item flex min-w-10 shrink-0 items-center justify-center border border-e-0 border-base-300 bg-base-200 w-11 px-0 text-base-content/70 [[data-theme=admin-dark]_&]:border-base-content/30"><span class="icon-[tabler--brand-facebook] size-4" aria-hidden="true"></span></span>
                    <input type="text" class="input join-item min-w-0 flex-1" name="facebook" id="facebook" value="{$data['user_social_facebook']}" autocomplete="off">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="twitter">{__("X Profile URL")}</label>
                  <div class="admin-setting-control join w-full min-w-0">
                    <span class="join-item flex min-w-10 shrink-0 items-center justify-center border border-e-0 border-base-300 bg-base-200 w-11 px-0 text-base-content/70 [[data-theme=admin-dark]_&]:border-base-content/30"><span class="icon-[tabler--brand-x] size-4" aria-hidden="true"></span></span>
                    <input type="text" class="input join-item min-w-0 flex-1" name="twitter" id="twitter" value="{$data['user_social_twitter']}" autocomplete="off">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="youtube">{__("YouTube Profile URL")}</label>
                  <div class="admin-setting-control join w-full min-w-0">
                    <span class="join-item flex min-w-10 shrink-0 items-center justify-center border border-e-0 border-base-300 bg-base-200 w-11 px-0 text-base-content/70 [[data-theme=admin-dark]_&]:border-base-content/30"><span class="icon-[tabler--brand-youtube] size-4" aria-hidden="true"></span></span>
                    <input type="text" class="input join-item min-w-0 flex-1" name="youtube" id="youtube" value="{$data['user_social_youtube']}" autocomplete="off">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="instagram">{__("Instagram Profile URL")}</label>
                  <div class="admin-setting-control join w-full min-w-0">
                    <span class="join-item flex min-w-10 shrink-0 items-center justify-center border border-e-0 border-base-300 bg-base-200 w-11 px-0 text-base-content/70 [[data-theme=admin-dark]_&]:border-base-content/30"><span class="icon-[tabler--brand-instagram] size-4" aria-hidden="true"></span></span>
                    <input type="text" class="input join-item min-w-0 flex-1" name="instagram" id="instagram" value="{$data['user_social_instagram']}" autocomplete="off">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="linkedin">{__("LinkedIn Profile URL")}</label>
                  <div class="admin-setting-control join w-full min-w-0">
                    <span class="join-item flex min-w-10 shrink-0 items-center justify-center border border-e-0 border-base-300 bg-base-200 w-11 px-0 text-base-content/70 [[data-theme=admin-dark]_&]:border-base-content/30"><span class="icon-[tabler--brand-linkedin] size-4" aria-hidden="true"></span></span>
                    <input type="text" class="input join-item min-w-0 flex-1" name="linkedin" id="linkedin" value="{$data['user_social_linkedin']}" autocomplete="off">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="vkontakte">{__("Vkontakte Profile URL")}</label>
                  <div class="admin-setting-control join w-full min-w-0">
                    <span class="join-item flex min-w-10 shrink-0 items-center justify-center border border-e-0 border-base-300 bg-base-200 w-11 px-0 text-base-content/70 [[data-theme=admin-dark]_&]:border-base-content/30"><span class="icon-[tabler--brand-vk] size-4" aria-hidden="true"></span></span>
                    <input type="text" class="input join-item min-w-0 flex-1" name="vkontakte" id="vkontakte" value="{$data['user_social_vkontakte']}" autocomplete="off">
                  </div>
                </div>
              </div>
            </div>

            {if $custom_fields['other']}
              <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-profile-other-title">
                <h2 id="user-profile-other-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--list-details] size-5" aria-hidden="true"></span>{__("Other")}</h2>
                {include file='__custom_fields.tpl' _custom_fields=$custom_fields['other'] _registration=false}
              </div>
            {/if}

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

      <div id="privacy" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="users-tab-privacy" tabindex="0">
        <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/users.php?id={$data['user_id']}&do=edit_privacy">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-privacy-preferences-title">
              <h2 id="user-privacy-preferences-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--adjustments] size-5" aria-hidden="true"></span>{__("Preferences")}</h2>
              <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
                {if $system['chat_enabled']}
                  <div class="flex items-center gap-4 p-4 js_admin-setting-switch">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--message] size-5"></span>
                    </span>
                    <div class="min-w-0 grow">
                      <label class="block text-sm font-medium" for="user_chat_enabled">{__("Chat Enabled")}</label>
                      <div id="user_chat_enabled-help" class="admin-setting-help mt-0.5 text-sm leading-relaxed">{__("If chat disabled you will appear offline and will no see who is online too")}</div>
                    </div>
                    <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="user_chat_enabled" id="user_chat_enabled" {if $data['user_chat_enabled']}checked{/if} aria-describedby="user_chat_enabled-help">
                  </div>
                {/if}
                <div class="flex items-center gap-4 p-4 js_admin-setting-switch">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--mail] size-5"></span>
                  </span>
                  <div class="min-w-0 grow">
                    <label class="block text-sm font-medium" for="user_newsletter_enabled">{__("Email you with our newsletter")}</label>
                    <div id="user_newsletter_enabled-help" class="admin-setting-help mt-0.5 text-sm leading-relaxed">{__("From time to time we send newsletter email to all of our members")}</div>
                  </div>
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="user_newsletter_enabled" id="user_newsletter_enabled" {if $data['user_newsletter_enabled']}checked{/if} aria-describedby="user_newsletter_enabled-help">
                </div>
                {if $system['tips_enabled']}
                  <div class="flex items-center gap-4 p-4 js_admin-setting-switch">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--coin] size-5"></span>
                    </span>
                    <div class="min-w-0 grow">
                      <label class="block text-sm font-medium" for="user_tips_enabled">{__("Tips Enabled")}</label>
                      <div id="user_tips_enabled-help" class="admin-setting-help mt-0.5 text-sm leading-relaxed">{__("Allow the send tips button on your profile")}</div>
                    </div>
                    <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="user_tips_enabled" id="user_tips_enabled" {if $data['user_tips_enabled']}checked{/if} aria-describedby="user_tips_enabled-help">
                  </div>
                {/if}
                <div class="flex items-center gap-4 p-4 js_admin-setting-switch">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--eye-off] size-5"></span>
                  </span>
                  <div class="min-w-0 grow">
                    <label class="block text-sm font-medium" for="user_suggestions_hidden">{if $system['friends_enabled']}{__("Hide from friends suggestions list")}{else}{__("Hide from followings suggestions list")}{/if}</label>
                    <div id="user_suggestions_hidden-help" class="admin-setting-help mt-0.5 text-sm leading-relaxed">{__("Enable this option to hide your profile from the suggestions list")}</div>
                  </div>
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="user_suggestions_hidden" id="user_suggestions_hidden" {if $data['user_suggestions_hidden']}checked{/if} aria-describedby="user_suggestions_hidden-help">
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-privacy-general-title">
              <h2 id="user-privacy-general-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--adjustments-horizontal] size-5" aria-hidden="true"></span>{__("General")}</h2>
              <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--message-circle] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_chat">{__("Who can message you?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_chat" id="user_privacy_chat">
                    <option {if $data['user_privacy_chat'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $data['user_privacy_chat'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $data['user_privacy_chat'] == "me"}selected{/if} value="me">{__("No One")}</option>
                  </select>
                </div>
                {if $system['pokes_enabled']}
                  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--hand-finger] size-5"></span>
                    </span>
                    <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_poke">{__("Who can poke you?")}</label>
                    <select class="select w-full shrink-0 sm:w-48" name="user_privacy_poke" id="user_privacy_poke">
                      <option {if $data['user_privacy_poke'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                      <option {if $data['user_privacy_poke'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                      <option {if $data['user_privacy_poke'] == "me"}selected{/if} value="me">{__("No One")}</option>
                    </select>
                  </div>
                {/if}
                {if $system['gifts_enabled']}
                  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--gift] size-5"></span>
                    </span>
                    <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_gifts">{__("Who can send you gifts?")}</label>
                    <select class="select w-full shrink-0 sm:w-48" name="user_privacy_gifts" id="user_privacy_gifts">
                      <option {if $data['user_privacy_gifts'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                      <option {if $data['user_privacy_gifts'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                      <option {if $data['user_privacy_gifts'] == "me"}selected{/if} value="me">{__("No One")}</option>
                    </select>
                  </div>
                {/if}
                {if $system['wall_posts_enabled']}
                  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--layout-list] size-5"></span>
                    </span>
                    <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_wall">{__("Who can post on your wall?")}</label>
                    <select class="select w-full shrink-0 sm:w-48" name="user_privacy_wall" id="user_privacy_wall">
                      <option {if $data['user_privacy_wall'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                      <option {if $data['user_privacy_wall'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                      <option {if $data['user_privacy_wall'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                    </select>
                  </div>
                {/if}
                {if $system['collaborative_posts_enabled']}
                  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--users-plus] size-5"></span>
                    </span>
                    <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_collaborative">{__("Who can tag you in collaborative posts?")}</label>
                    <select class="select w-full shrink-0 sm:w-48" name="user_privacy_collaborative" id="user_privacy_collaborative">
                      <option {if $data['user_privacy_collaborative'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                      <option {if $data['user_privacy_collaborative'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                      <option {if $data['user_privacy_collaborative'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                    </select>
                  </div>
                {/if}
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-privacy-profile-title">
              <h2 id="user-privacy-profile-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--user-circle] size-5" aria-hidden="true"></span>{__("Profile")}</h2>
              <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--gender-bigender] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_gender">{__("Who can see your gender?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_gender" id="user_privacy_gender">
                    <option {if $data['user_privacy_gender'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $data['user_privacy_gender'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $data['user_privacy_gender'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                {if $system['relationship_info_enabled']}
                  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--heart] size-5"></span>
                    </span>
                    <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_relationship">{__("Who can see your relationship?")}</label>
                    <select class="select w-full shrink-0 sm:w-48" name="user_privacy_relationship" id="user_privacy_relationship">
                      <option {if $data['user_privacy_relationship'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                      <option {if $data['user_privacy_relationship'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                      <option {if $data['user_privacy_relationship'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                    </select>
                  </div>
                {/if}
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--cake] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_birthdate">{__("Who can see your birthdate?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_birthdate" id="user_privacy_birthdate">
                    <option {if $data['user_privacy_birthdate'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $data['user_privacy_birthdate'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $data['user_privacy_birthdate'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--id-badge-2] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_basic">{__("Who can see your basic info?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_basic" id="user_privacy_basic">
                    <option {if $data['user_privacy_basic'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $data['user_privacy_basic'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $data['user_privacy_basic'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                {if $system['work_info_enabled']}
                  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--briefcase] size-5"></span>
                    </span>
                    <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_work">{__("Who can see your work info?")}</label>
                    <select class="select w-full shrink-0 sm:w-48" name="user_privacy_work" id="user_privacy_work">
                      <option {if $data['user_privacy_work'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                      <option {if $data['user_privacy_work'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                      <option {if $data['user_privacy_work'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                    </select>
                  </div>
                {/if}
                {if $system['location_info_enabled']}
                  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--map-pin] size-5"></span>
                    </span>
                    <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_location">{__("Who can see your location info?")}</label>
                    <select class="select w-full shrink-0 sm:w-48" name="user_privacy_location" id="user_privacy_location">
                      <option {if $data['user_privacy_location'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                      <option {if $data['user_privacy_location'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                      <option {if $data['user_privacy_location'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                    </select>
                  </div>
                {/if}
                {if $system['education_info_enabled']}
                  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--school] size-5"></span>
                    </span>
                    <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_education">{__("Who can see your education info?")}</label>
                    <select class="select w-full shrink-0 sm:w-48" name="user_privacy_education" id="user_privacy_education">
                      <option {if $data['user_privacy_education'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                      <option {if $data['user_privacy_education'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                      <option {if $data['user_privacy_education'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                    </select>
                  </div>
                {/if}
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--dots] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_other">{__("Who can see your other info?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_other" id="user_privacy_other">
                    <option {if $data['user_privacy_other'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $data['user_privacy_other'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $data['user_privacy_other'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                {if $system['friends_enabled']}
                  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--users] size-5"></span>
                    </span>
                    <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_friends">{__("Who can see your friends?")}</label>
                    <select class="select w-full shrink-0 sm:w-48" name="user_privacy_friends" id="user_privacy_friends">
                      <option {if $data['user_privacy_friends'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                      <option {if $data['user_privacy_friends'] == "friends"}selected{/if} value="friends">{__("Friends")}</option>
                      <option {if $data['user_privacy_friends'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                    </select>
                  </div>
                {/if}
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--user-heart] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_followers">{__("Who can see your followers/followings?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_followers" id="user_privacy_followers">
                    <option {if $data['user_privacy_followers'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $data['user_privacy_followers'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $data['user_privacy_followers'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                {if $system['monetization_enabled']}
                  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--crown] size-5"></span>
                    </span>
                    <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_subscriptions">{__("Who can see your subscriptions?")}</label>
                    <select class="select w-full shrink-0 sm:w-48" name="user_privacy_subscriptions" id="user_privacy_subscriptions">
                      <option {if $data['user_privacy_subscriptions'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                      <option {if $data['user_privacy_subscriptions'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                      <option {if $data['user_privacy_subscriptions'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                    </select>
                  </div>
                {/if}
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-privacy-content-title">
              <h2 id="user-privacy-content-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--photo] size-5" aria-hidden="true"></span>{__("Content")}</h2>
              <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--photo] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_photos">{__("Who can see your photos?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_photos" id="user_privacy_photos">
                    <option {if $data['user_privacy_photos'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $data['user_privacy_photos'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $data['user_privacy_photos'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                {if $system['pages_enabled']}
                  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--flag] size-5"></span>
                    </span>
                    <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_pages">{__("Who can see your liked pages?")}</label>
                    <select class="select w-full shrink-0 sm:w-48" name="user_privacy_pages" id="user_privacy_pages">
                      <option {if $data['user_privacy_pages'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                      <option {if $data['user_privacy_pages'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                      <option {if $data['user_privacy_pages'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                    </select>
                  </div>
                {/if}
                {if $system['groups_enabled']}
                  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--users-group] size-5"></span>
                    </span>
                    <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_groups">{__("Who can see your joined groups?")}</label>
                    <select class="select w-full shrink-0 sm:w-48" name="user_privacy_groups" id="user_privacy_groups">
                      <option {if $data['user_privacy_groups'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                      <option {if $data['user_privacy_groups'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                      <option {if $data['user_privacy_groups'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                    </select>
                  </div>
                {/if}
                {if $system['events_enabled']}
                  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                      <span class="icon-[tabler--calendar-event] size-5"></span>
                    </span>
                    <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_events">{__("Who can see your joined events?")}</label>
                    <select class="select w-full shrink-0 sm:w-48" name="user_privacy_events" id="user_privacy_events">
                      <option {if $data['user_privacy_events'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                      <option {if $data['user_privacy_events'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                      <option {if $data['user_privacy_events'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                    </select>
                  </div>
                {/if}
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

      <div id="security" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="users-tab-security" tabindex="0">
        {if !$user->_data['user_demo'] && $data['sessions']}
          <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-labelledby="admin-user-sessions-title">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3 border-b border-base-300 px-6 py-4">
              <h2 id="admin-user-sessions-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug">{__("Active Sessions")}</h2>
              <button type="button" class="btn btn-soft btn-error btn-sm js_admin-deleter" data-handle="user_sessions" data-id="{$data['user_id']}" data-confirm-title="{__("End All Sessions")}" data-delete-message="{__("Are you sure you want to end all sessions of this user?")}">
                <span class="icon-[tabler--logout] size-4" aria-hidden="true"></span>
                {__("End All Sessions")}
              </button>
            </div>
            <div class="admin-list-table-wrap w-full overflow-x-auto">
              <table class="table js_dataTable admin-list-table">
                <thead>
                  <tr>
                    <th>{__("ID")}</th>
                    <th>{__("Browser")}</th>
                    <th>{__("OS")}</th>
                    <th>{__("Date")}</th>
                    <th>{__("IP")}</th>
                    <th>{__("Location")}</th>
                    <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
                  </tr>
                </thead>
                <tbody>
                  {foreach $data['sessions'] as $session}
                    <tr>
                      <td>{$session@iteration}</td>
                      <td>{$session['user_browser']}</td>
                      <td>{$session['user_os']}</td>
                      <td><span class="js_moment" data-time="{$session['session_date']}">{$session['session_date']}</span></td>
                      <td>{$session['user_ip']}</td>
                      <td>{$session['user_location']}</td>
                      <td class="admin-list-actions-column w-14 text-end">
                        <div class="dropdown relative inline-flex [--placement:bottom-end]">
                          <button id="session-actions-{$session['session_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$session['user_browser']}">
                            <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                          </button>
                          <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="session-actions-{$session['session_id']}">
                            <li>
                              <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="session" data-id="{$session['session_id']}">
                                <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                                {__("End Session")}
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
          <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-user-sessions-empty-title">
            <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
              <span class="icon-[tabler--shield] size-6" aria-hidden="true"></span>
            </div>
            <h2 id="admin-user-sessions-empty-title">{__("No sessions")}</h2>
            <p>{__("There are no active sessions for this account.")}</p>
          </section>
        {/if}
      </div>

      {if $system['packages_enabled']}
        <div id="membership" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="users-tab-membership" tabindex="0">
          <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/users.php?id={$data['user_id']}&do=edit_membership">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              {if $data['user_subscribed']}
                <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-membership-details-title">
                  <div class="admin-membership-heading flex flex-wrap items-start justify-between gap-4">
                    <div class="grid gap-1">
                      <h2 id="user-membership-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                        <span class="icon-[tabler--id] size-5" aria-hidden="true"></span>
                        {__("Package Details")}
                      </h2>
                      <p class="admin-setting-help m-0 text-sm leading-relaxed">{__("Current membership and included promotion usage.")}</p>
                    </div>
                    {if $data['period'] == "life" || $data['subscription_timeleft'] > 0}
                      <span class="badge badge-soft badge-success rounded-full">{__("Active")}</span>
                    {else}
                      <span class="badge badge-soft badge-error rounded-full">{__("Expired")}</span>
                    {/if}
                  </div>

                  <div class="admin-membership-summary" aria-label="{__("Package Details")}">
                    <div class="admin-membership-summary-item">
                      <span class="admin-membership-summary-icon"><span class="icon-[tabler--package] size-4.5" aria-hidden="true"></span></span>
                      <div class="admin-membership-summary-content">
                        <span class="admin-user-summary-label">{__("Package")}</span>
                        <strong>{$data['name']}</strong>
                        <span class="admin-setting-help text-sm">{print_money($data['price'])} {if $data['period'] == "life"}{__("Life Time")}{else}{__("per")} {if $data['period_num'] != '1'}{$data['period_num']}{/if} {__($data['period']|ucfirst)}{/if}</span>
                      </div>
                    </div>
                    <div class="admin-membership-summary-item">
                      <span class="admin-membership-summary-icon"><span class="icon-[tabler--calendar-check] size-4.5" aria-hidden="true"></span></span>
                      <div class="admin-membership-summary-content">
                        <span class="admin-user-summary-label">{__("Subscription Date")}</span>
                        <strong>{$data['user_subscription_date']|date_format:"%e %B %Y"}</strong>
                      </div>
                    </div>
                    <div class="admin-membership-summary-item">
                      <span class="admin-membership-summary-icon"><span class="icon-[tabler--calendar-clock] size-4.5" aria-hidden="true"></span></span>
                      <div class="admin-membership-summary-content">
                        <span class="admin-user-summary-label">{__("Expiration Date")}</span>
                        <strong>
                          {if $data['period'] == "life"}
                            {__("Life Time")}
                          {else}
                            {$data['subscription_end']|date_format:"%e %B %Y"}
                          {/if}
                        </strong>
                        {if $data['period'] != "life"}
                          <span class="admin-setting-help text-sm">{if $data['subscription_timeleft'] > 0}{__("Remaining")} {$data['subscription_timeleft']} {__("Days")}{else}{__("Expired")}{/if}</span>
                        {/if}
                      </div>
                    </div>
                  </div>

                  <div class="admin-membership-usage grid gap-5" aria-label="{__("Package usage")}">
                    <div class="admin-user-progress">
                      <div class="admin-user-progress-label"><span>{__("Boosted Posts")}</span><strong>{$data['user_boosted_posts']}/{$data['boost_posts']}</strong></div>
                      <div class="admin-user-progress-track" role="progressbar" aria-label="{__("Boosted Posts")}" aria-valuemin="0" aria-valuemax="{if $data['boost_posts'] > 0}{$data['boost_posts']}{else}1{/if}" aria-valuenow="{$data['user_boosted_posts']}">
                        <span style="width: {if $data['boost_posts'] == 0}0{elseif $data['user_boosted_posts'] >= $data['boost_posts']}100{else}{($data['user_boosted_posts']/$data['boost_posts'])*100}{/if}%"></span>
                      </div>
                    </div>
                    <div class="admin-user-progress">
                      <div class="admin-user-progress-label"><span>{__("Boosted Pages")}</span><strong>{$data['user_boosted_pages']}/{$data['boost_pages']}</strong></div>
                      <div class="admin-user-progress-track" role="progressbar" aria-label="{__("Boosted Pages")}" aria-valuemin="0" aria-valuemax="{if $data['boost_pages'] > 0}{$data['boost_pages']}{else}1{/if}" aria-valuenow="{$data['user_boosted_pages']}">
                        <span style="width: {if $data['boost_pages'] == 0}0{elseif $data['user_boosted_pages'] >= $data['boost_pages']}100{else}{($data['user_boosted_pages']/$data['boost_pages'])*100}{/if}%"></span>
                      </div>
                    </div>
                    <div class="admin-user-progress">
                      <div class="admin-user-progress-label"><span>{__("Boosted Groups")}</span><strong>{$data['user_boosted_groups']}/{$data['boost_groups']}</strong></div>
                      <div class="admin-user-progress-track" role="progressbar" aria-label="{__("Boosted Groups")}" aria-valuemin="0" aria-valuemax="{if $data['boost_groups'] > 0}{$data['boost_groups']}{else}1{/if}" aria-valuenow="{$data['user_boosted_groups']}">
                        <span style="width: {if $data['boost_groups'] == 0}0{elseif $data['user_boosted_groups'] >= $data['boost_groups']}100{else}{($data['user_boosted_groups']/$data['boost_groups'])*100}{/if}%"></span>
                      </div>
                    </div>
                    <div class="admin-user-progress">
                      <div class="admin-user-progress-label"><span>{__("Boosted Events")}</span><strong>{$data['user_boosted_events']}/{$data['boost_events']}</strong></div>
                      <div class="admin-user-progress-track" role="progressbar" aria-label="{__("Boosted Events")}" aria-valuemin="0" aria-valuemax="{if $data['boost_events'] > 0}{$data['boost_events']}{else}1{/if}" aria-valuenow="{$data['user_boosted_events']}">
                        <span style="width: {if $data['boost_events'] == 0}0{elseif $data['user_boosted_events'] >= $data['boost_events']}100{else}{($data['user_boosted_events']/$data['boost_events'])*100}{/if}%"></span>
                      </div>
                    </div>
                  </div>

                  <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                    <button type="button" class="btn btn-outline js_admin-deleter" data-handle="user_package" data-id="{$data['user_id']}">{__("Unsubscribe")}</button>
                  </div>
                </div>
              {else}
                <div class="admin-settings-section flex flex-col gap-4 p-6" aria-labelledby="user-membership-details-title">
                  <div class="admin-membership-empty-icon flex size-11 items-center justify-center rounded-full bg-base-200">
                    <span class="icon-[tabler--id-off] size-5" aria-hidden="true"></span>
                  </div>
                  <div class="grid gap-1">
                    <h2 id="user-membership-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug">{__("No active membership")}</h2>
                    <p class="admin-setting-help m-0 text-sm leading-relaxed">{__("Select a package below to add membership benefits to this account.")}</p>
                  </div>
                </div>
              {/if}

              <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-membership-upgrade-title">
                <h2 id="user-membership-upgrade-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                  <span class="icon-[tabler--refresh] size-5" aria-hidden="true"></span>
                  {__("Update Package")}
                </h2>

                {if $packages}
                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                    <label class="label-text" for="package">{__("Select Package")}</label>
                    <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                      <select class="select w-full" name="package" id="package">
                      {foreach $packages as $package}
                        <option value="{$package['package_id']}" {if $data['user_package'] == $package['package_id']}selected{/if}>
                          {$package['name']} ({print_money($package['price'])}
                          {if $package['period'] == "life"}{__("Life Time")}{else}{__("per")} {if $package['period_num'] != '1'}{$package['period_num']}{/if} {__($package['period']|ucfirst)}{/if})
                        </option>
                      {/foreach}
                      </select>
                    </div>
                  </div>
                {else}
                  <div class="alert alert-warning" role="status">{__("No packages are available.")}</div>
                {/if}
              </div>

              <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
                <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                  <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                  <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
                </div>
                <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                  <button type="submit" class="btn btn-primary" {if !$packages}disabled{/if}>{__("Save Changes")}</button>
                </div>
              </div>
            </section>
          </form>
        </div>
      {/if}

      {if $system['wallet_enabled'] || $system['points_enabled']}
        <div id="extra" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="users-tab-extra" tabindex="0">
          <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/users.php?id={$data['user_id']}&do=edit_extra">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              {if $system['affiliates_enabled']}
                <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-extra-affiliates-title">
                  <h2 id="user-extra-affiliates-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Affiliates")}</h2>

                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon">
                      {include file='__svg_icons.tpl' icon="affiliates" class="admin-setting-glyph" width="32px" height="32px"}
                    </div>
                    <div>
                      <label class="admin-setting-label block text-sm font-medium leading-normal" for="custom_affiliates_system">{__("Custom Affiliates System")}</label>
                      <div id="custom_affiliates_system-help" class="admin-setting-help text-sm leading-relaxed">{__("Enable it to override the default affiliates system")}</div>
                    </div>
                    <div class="text-end">
                      <input type="checkbox" class="switch switch-primary" name="custom_affiliates_system" id="custom_affiliates_system" {if $data['custom_affiliates_system']}checked{/if} aria-describedby="custom_affiliates_system-help">
                    </div>
                  </div>

                  {include file='_affiliates_levels.tpl' _affiliate=$data _editor=true}
                </div>
              {/if}

              {if $system['points_enabled']}
                <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-extra-points-title">
                  <h2 id="user-extra-points-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Points")}</h2>

                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                    <label class="label-text" for="user_points">{__("Points Balance")}</label>
                    <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                      <input class="input w-full" name="user_points" id="user_points" value="{$data['user_points']}" autocomplete="off">
                    </div>
                  </div>
                </div>
              {/if}

              {if $system['wallet_enabled']}
                <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-extra-wallet-title">
                  <h2 id="user-extra-wallet-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Wallet")}</h2>

                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                    <label class="label-text" for="user_wallet_balance">{__("Wallet Balance")}</label>
                    <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                      <input type="text" class="input w-full" placeholder="0.00" min="1.00" max="1000" name="user_wallet_balance" id="user_wallet_balance" value="{$data['user_wallet_balance']}" autocomplete="off">
                    </div>
                  </div>
                </div>
              {/if}

              {if $system['market_enabled']}
                <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-extra-market-title">
                  <h2 id="user-extra-market-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Marketplace")}</h2>

                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                    <div class="label-text">{__("Marketplace Balance")}</div>
                    <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                      <span class="badge badge-soft badge-primary badge-sm rounded-full">{print_money($data['user_market_balance'])}</span>
                    </div>
                  </div>
                </div>
              {/if}

              {if $system['funding_enabled']}
                <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-extra-funding-title">
                  <h2 id="user-extra-funding-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Funding")}</h2>

                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                    <div class="label-text">{__("Funding Balance")}</div>
                    <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                      <span class="badge badge-soft badge-primary badge-sm rounded-full">{print_money($data['user_funding_balance'])}</span>
                    </div>
                  </div>
                </div>
              {/if}

              {if $system['monetization_enabled']}
                <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-extra-monetization-title">
                  <h2 id="user-extra-monetization-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Monetization")}</h2>

                  {if $data['can_monetize_content']}
                    <div class="admin-setting-switch js_admin-setting-switch">
                      <div class="admin-setting-icon">
                        {include file='__svg_icons.tpl' icon="monetization" class="admin-setting-glyph" width="32px" height="32px"}
                      </div>
                      <div>
                        <label class="admin-setting-label block text-sm font-medium leading-normal" for="user_monetization_enabled">{__("Monetization")}</label>
                        <div id="user_monetization_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Enable or disable monetization for your content")}</div>
                      </div>
                      <div class="text-end">
                        <input type="checkbox" class="switch switch-primary" name="user_monetization_enabled" id="user_monetization_enabled" {if $data['user_monetization_enabled']}checked{/if} aria-describedby="user_monetization_enabled-help">
                      </div>
                    </div>
                    <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                      <div class="label-text">{__("Monetization Balance")}</div>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <span class="badge badge-soft badge-primary badge-sm rounded-full">{print_money($data['user_monetization_balance'])}</span>
                      </div>
                    </div>
                  {else}
                    <div class="alert alert-error alert-danger" role="status">{__("This user is not eligible for monetization")}</div>
                  {/if}
                </div>
                {if $data['can_monetize_content']}
                  <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-plans-title">
                    <div class="grid gap-1">
                      <h2 id="user-plans-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--credit-card] size-5" aria-hidden="true"></span>{__("Payment Plans")}</h2>
                      <p class="admin-setting-help m-0 text-sm leading-relaxed">{__("Plans people can choose to support this profile.")}</p>
                    </div>
                    {include file='__monetization_plans.tpl' _node_id=$data['user_id'] _node_type='profile'}
                  </div>
                {/if}
              {/if}

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
      </div>
    </div>

  {/if}
</section>
