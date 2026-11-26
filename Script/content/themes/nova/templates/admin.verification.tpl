<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-verification-title">
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-verification-title" class="text-2xl font-semibold">
        {if $sub_view == "users"}
          {__("Verified Users")}
        {elseif $sub_view == "pages"}
          {__("Verified Pages")}
        {else}
          {__("Verification Requests")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "users"}
          {__("Accounts carrying the verified badge.")}
        {elseif $sub_view == "pages"}
          {__("Pages carrying the verified badge.")}
        {else}
          {__("Review the documents members submitted, then verify or decline.")}
        {/if}
      </p>
    </div>

    {if $sub_view == "users" || $sub_view == "pages"}
      <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
        <a href="{$system['system_url']}/{$control_panel['url']}/verification" class="btn btn-outline">
          <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
          {__("Go Back")}
        </a>
      </div>
    {/if}
  </header>

  {if $sub_view == ""}

    <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-3 lg:gap-5">
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-warning icon-[tabler--inbox] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Pending Requests")}">{__("Pending Requests")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['requests']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-info icon-[tabler--rosette-discount-check] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Verified Users")}">{__("Verified Users")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['users']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-success icon-[tabler--flag] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Verified Pages")}">{__("Verified Pages")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['pages']|number_format}</p>
        </div>
      </article>
    </div>

    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 p-5 shadow-none lg:p-6" aria-label="{__("Verification Requests")}">
        <div class="admin-verification-queue">
          {foreach $rows as $row}
            <!-- verification request -->
            <div class="admin-verification-row" data-request-id="{$row['request_id']}">
              <div class="flex flex-wrap items-center gap-3">

                <!-- node -->
                <div class="admin-verification-node">
                  {if $row['node_type'] == "user"}
                    <a target="_blank" href="{$system['system_url']}/{$row['user_name']}">
                      <img class="admin-verification-avatar" src="{$row['user_picture']}" alt="" width="48" height="48" loading="lazy">
                    </a>
                  {elseif $row['node_type'] == "page"}
                    <a target="_blank" href="{$system['system_url']}/pages/{$row['page_name']}">
                      <img class="admin-verification-avatar" src="{$row['page_picture']}" alt="" width="48" height="48" loading="lazy">
                    </a>
                  {/if}
                  <div class="ms-3 min-w-0">
                    {if $row['node_type'] == "user"}
                      <a class="truncate text-sm font-semibold" target="_blank" href="{$system['system_url']}/{$row['user_name']}" title="{if $system['show_usernames_enabled']}{$row['user_name']}{else}{$row['user_firstname']} {$row['user_lastname']}{/if}">
                        {if $system['show_usernames_enabled']}{$row['user_name']}{else}{$row['user_firstname']} {$row['user_lastname']}{/if}
                      </a>
                      <div class="text-base-content/60 truncate text-xs" title="{if $system['show_usernames_enabled']}{$row['user_firstname']} {$row['user_lastname']}{else}@{$row['user_name']}{/if}">
                        {if $system['show_usernames_enabled']}{$row['user_firstname']} {$row['user_lastname']}{else}@{$row['user_name']}{/if}
                      </div>
                    {elseif $row['node_type'] == "page"}
                      <a class="truncate text-sm font-semibold" target="_blank" href="{$system['system_url']}/pages/{$row['page_name']}" title="{$row['page_title']}">
                        {$row['page_title']}
                      </a>
                      <div class="text-base-content/60 truncate text-xs" title="@{$row['page_name']}">@{$row['page_name']}</div>
                    {/if}
                  </div>
                </div>
                <!-- node -->

                <!-- type & time -->
                <div class="admin-verification-meta max-md:hidden">
                  <div>
                    {if $row['node_type'] == "page"}
                      <span class="badge badge-soft badge-info badge-sm rounded-full">{__("Page")}</span>
                    {else}
                      <span class="badge badge-soft badge-primary badge-sm rounded-full">{__("User")}</span>
                    {/if}
                  </div>
                  <div class="text-base-content/60 mt-1 text-xs">{$row['time']|date_format:"%e %B %Y"}</div>
                </div>
                <!-- type & time -->

                <!-- documents -->
                <div class="admin-verification-docs">
                  {if $row['photo'] || $row['passport']}
                    {if $row['photo']}
                      <button type="button" class="admin-verification-thumb js_admin-verification-documents" title='{__("View Verification Documents")}' aria-label="{__("View Verification Documents")}" data-photo="{if $row['photo']}{$system['system_uploads']}/{$row['photo']}{/if}" data-passport="{if $row['passport']}{$system['system_uploads']}/{$row['passport']}{/if}" data-message="{$row['message']}"{if $row['node_type'] == 'page'} data-business-website="{$row['business_website']}" data-business-address="{$row['business_address']}"{/if} data-handle="{$row['node_type']}" data-node-id="{$row['node_id']}" data-request-id="{$row['request_id']}">
                        <img src="{$system['system_uploads']}/{$row['photo']}" alt="" width="48" height="48" loading="lazy">
                      </button>
                    {/if}
                    {if $row['passport']}
                      <button type="button" class="admin-verification-thumb js_admin-verification-documents" title='{__("View Verification Documents")}' aria-label="{__("View Verification Documents")}" data-photo="{if $row['photo']}{$system['system_uploads']}/{$row['photo']}{/if}" data-passport="{if $row['passport']}{$system['system_uploads']}/{$row['passport']}{/if}" data-message="{$row['message']}"{if $row['node_type'] == 'page'} data-business-website="{$row['business_website']}" data-business-address="{$row['business_address']}"{/if} data-handle="{$row['node_type']}" data-node-id="{$row['node_id']}" data-request-id="{$row['request_id']}">
                        <img src="{$system['system_uploads']}/{$row['passport']}" alt="" width="48" height="48" loading="lazy">
                      </button>
                    {/if}
                  {else}
                    <button type="button" class="btn btn-text btn-circle btn-sm js_admin-verification-documents" title='{__("View Verification Documents")}' aria-label="{__("View Verification Documents")}" data-message="{$row['message']}" data-handle="{$row['node_type']}" data-node-id="{$row['node_id']}" data-request-id="{$row['request_id']}">
                      <span class="icon-[tabler--paperclip] size-5" aria-hidden="true"></span>
                    </button>
                  {/if}
                  {if $row['message']}
                    <span class="admin-verification-message max-xl:hidden" title='{$row['message']}'>{$row['message']}</span>
                  {/if}
                </div>
                <!-- documents -->

                <!-- actions -->
                <div class="admin-verification-actions">
                  <button type="button" class="btn btn-outline btn-error btn-sm js_admin-unverify" data-handle="{$row['node_type']}" data-id="{$row['node_id']}">
                    <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
                    {__("Decline")}
                  </button>
                  <button type="button" class="btn btn-primary btn-sm js_admin-verify" data-handle="{$row['node_type']}" data-id="{$row['node_id']}">
                    <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
                    {__("Verify")}
                  </button>
                </div>
                <!-- actions -->

              </div>
            </div>
            <!-- verification request -->
          {/foreach}
        </div>
        {if $pager}
          <div class="admin-list-pager mt-4">{$pager}</div>
        {/if}
      </section>
    {else}
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-verification-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--inbox] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-verification-empty-title">{__("No pending requests")}</h2>
        <p>{__("Every verification request has been reviewed.")}</p>
      </section>
    {/if}

  {elseif $sub_view == "users"}

    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Verified Users")}">
      <!-- search form -->
      <div class="js-flyonui-datatable-toolbar border-base-300 flex items-center justify-between gap-3 border-b px-5 py-3 max-md:flex-wrap">
        <form class="input max-w-60" action="{$system['system_url']}/{$control_panel['url']}/verification/users" method="get" role="search">
          <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
          <input type="search" class="grow" name="query" id="admin-verified-users-query" value="{$query}" placeholder="{__("Search")}" title="{__("Search by Username, First Name, Last Name or Email")}" aria-label="{__("Search by Username, First Name, Last Name or Email")}" autocomplete="off">
        </form>
      </div>
      <!-- search form -->

      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("User")}</th>
                <th>{__("Username")}</th>
                <th>{__("Joined")}</th>
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
                    <span class="badge badge-soft badge-info badge-sm gap-1 rounded-full">
                      <span class="icon-[tabler--rosette-discount-check] size-3.5" aria-hidden="true"></span>
                      {$row['user_name']}
                    </span>
                  </td>
                  <td>{$row['user_registered']|date_format:"%e %B %Y"}</td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="verified-user-actions-{$row['user_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} #{$row['user_id']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="verified-user-actions-{$row['user_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/{$row['user_name']}">
                            <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
                            {__("View")}
                          </a>
                        </li>
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
        <div class="admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none admin-list-empty-inline min-h-60 border-0 bg-transparent" aria-labelledby="admin-verified-users-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--rosette-discount-check] size-6" aria-hidden="true"></span>
          </div>
          <h2 id="admin-verified-users-empty-title">
            {if $query}
              {__("No users found")}
            {else}
              {__("No verified users yet")}
            {/if}
          </h2>
          <p>
            {if $query}
              {__("Try another username, name or email.")}
            {else}
              {__("Approve a verification request to add the badge to an account.")}
            {/if}
          </p>
        </div>
      {/if}
    </section>

  {elseif $sub_view == "pages"}

    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Verified Pages")}">
      <!-- search form -->
      <div class="js-flyonui-datatable-toolbar border-base-300 flex items-center justify-between gap-3 border-b px-5 py-3 max-md:flex-wrap">
        <form class="input max-w-60" action="{$system['system_url']}/{$control_panel['url']}/verification/pages" method="get" role="search">
          <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
          <input type="search" class="grow" name="query" id="admin-verified-pages-query" value="{$query}" placeholder="{__("Search")}" title="{__("Search by Page Title or Username")}" aria-label="{__("Search by Page Title or Username")}" autocomplete="off">
        </form>
      </div>
      <!-- search form -->

      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("Page")}</th>
                <th>{__("Username")}</th>
                <th>{__("Likes")}</th>
                <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/pages/{$row['page_name']}">
                      <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['page_picture']}" alt="" width="30" height="30" loading="lazy">
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{$row['page_title']}">{$row['page_title']}</span>
                        <span class="admin-list-id text-xs">#{$row['page_id']}</span>
                      </span>
                    </a>
                  </td>
                  <td>
                    <span class="badge badge-soft badge-info badge-sm gap-1 rounded-full">
                      <span class="icon-[tabler--rosette-discount-check] size-3.5" aria-hidden="true"></span>
                      {$row['page_name']}
                    </span>
                  </td>
                  <td class="tabular-nums">{$row['page_likes']|number_format}</td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="verified-page-actions-{$row['page_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} #{$row['page_id']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="verified-page-actions-{$row['page_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/pages/{$row['page_name']}">
                            <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
                            {__("View")}
                          </a>
                        </li>
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/pages/edit_page/{$row['page_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="page" data-id="{$row['page_id']}">
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
        <div class="admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none admin-list-empty-inline min-h-60 border-0 bg-transparent" aria-labelledby="admin-verified-pages-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--flag] size-6" aria-hidden="true"></span>
          </div>
          <h2 id="admin-verified-pages-empty-title">
            {if $query}
              {__("No pages found")}
            {else}
              {__("No verified pages yet")}
            {/if}
          </h2>
          <p>
            {if $query}
              {__("Try another page title or username.")}
            {else}
              {__("Approve a verification request to add the badge to a page.")}
            {/if}
          </p>
        </div>
      {/if}
    </section>

  {/if}
</section>
