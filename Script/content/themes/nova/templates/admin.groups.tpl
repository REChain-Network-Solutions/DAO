<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-groups-title">
  {if $sub_view == "add_category" || $sub_view == "edit_category"}
    <div class="admin-form-layout mx-auto w-full admin-form-layout-wide flex max-w-[64rem] flex-col gap-6">
  {/if}

  {if $sub_view != "edit_group"}
    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-groups-title" class="text-2xl font-semibold">
          {if $sub_view == "find"}
            {__("Find")}
          {elseif $sub_view == "categories"}
            {__("Categories")}
          {elseif $sub_view == "add_category"}
            {__("Add New Category")}
          {elseif $sub_view == "edit_category"}
            {__("Edit Category")}
          {else}
            {__("Groups")}
          {/if}
        </h1>
        <p class="text-base-content/60 text-sm">
          {if $sub_view == "find"}
            {__("Search results for group web address or title.")}
          {elseif $sub_view == "categories"}
            {__("Organize groups into categories visitors can browse.")}
          {elseif $sub_view == "add_category"}
            {__("Add a category and choose where it sits in the tree.")}
          {elseif $sub_view == "edit_category"}
            {__("Update this category name, parent, and order.")}
          {else}
            {__("Manage groups, privacy, and membership.")}
          {/if}
        </p>
      </div>

      {if $sub_view == "find" || $sub_view == "categories" || $sub_view == "add_category" || $sub_view == "edit_category"}
        <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
          {if $sub_view == "find"}
            <a href="{$system['system_url']}/{$control_panel['url']}/groups" class="btn btn-outline">
              <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
              {__("Go Back")}
            </a>
          {elseif $sub_view == "categories"}
            <a href="{$system['system_url']}/{$control_panel['url']}/groups/add_category" class="btn btn-primary">
              <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
              {__("Add New Category")}
            </a>
          {else}
            <a href="{$system['system_url']}/{$control_panel['url']}/groups/categories" class="btn btn-outline">
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
          <span class="admin-stat-icon is-info icon-[tabler--users-group] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Groups")}">{__("Groups")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['groups']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-info icon-[tabler--world] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Public")}">{__("Public")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['public']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-warning icon-[tabler--lock-open] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Closed")}">{__("Closed")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['closed']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-neutral icon-[tabler--lock] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Secret")}">{__("Secret")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['secret']|number_format}</p>
          </div>
        </article>
      </div>
    {/if}

    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Groups")}">
      <div class="js-flyonui-datatable-toolbar border-base-300 flex items-center justify-between gap-3 border-b px-5 py-3 max-md:flex-wrap">
        <form class="input max-w-60" action="{$system['system_url']}/{$control_panel['url']}/groups/find" method="get" role="search">
          <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
          <input type="search" class="grow" name="query" id="admin-groups-query" value="{if $query}{$query}{/if}" placeholder="{__("Search")}" title="{__("Search by Group Web Address or Title")}" aria-label="{__("Search by Group Web Address or Title")}" autocomplete="off">
        </form>
      </div>
      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("Group")}</th>
                <th>{__("Username")}</th>
                <th>{__("Admin")}</th>
                <th>{__("Privacy")}</th>
                <th>{__("Members")}</th>
                <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/groups/{$row['group_name']}">
                      <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['group_picture']}" alt="" width="30" height="30" loading="lazy">
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{$row['group_title']}">{$row['group_title']}</span>
                        <span class="admin-list-id text-xs">#{$row['group_id']}</span>
                      </span>
                    </a>
                  </td>
                  <td>
                    <a href="{$system['system_url']}/groups/{$row['group_name']}" target="_blank">{$row['group_name']}</a>
                  </td>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/{$row['user_name']}">
                      <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['user_picture']}" alt="" width="30" height="30" loading="lazy">
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{if $system['show_usernames_enabled']}{$row['user_name']}{else}{$row['user_firstname']} {$row['user_lastname']}{/if}">{if $system['show_usernames_enabled']}{$row['user_name']}{else}{$row['user_firstname']} {$row['user_lastname']}{/if}</span>
                      </span>
                    </a>
                  </td>
                  <td>
                    {if $row['group_privacy'] == "public"}
                      <span class="badge badge-soft badge-success badge-sm rounded-full"><span class="icon-[tabler--world] size-3.5" aria-hidden="true"></span>{__("Public")}</span>
                    {elseif $row['group_privacy'] == "closed"}
                      <span class="badge badge-soft badge-warning badge-sm rounded-full"><span class="icon-[tabler--lock-open] size-3.5" aria-hidden="true"></span>{__("Closed")}</span>
                    {elseif $row['group_privacy'] == "secret"}
                      <span class="badge badge-soft badge-sm rounded-full"><span class="icon-[tabler--lock] size-3.5" aria-hidden="true"></span>{__("Secret")}</span>
                    {/if}
                  </td>
                  <td>{$row['group_members']|number_format}</td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="group-actions-{$row['group_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['group_title']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="group-actions-{$row['group_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/groups/edit_group/{$row['group_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="group" data-id="{$row['group_id']}">
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
        <div class="admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none admin-list-empty-inline min-h-60 border-0 bg-transparent" aria-labelledby="admin-groups-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--users-group] size-6" aria-hidden="true"></span>
          </div>
          <h2 id="admin-groups-empty-title">{__("No groups found")}</h2>
          <p>{__("Try another search or open a different groups list.")}</p>
        </div>
      {/if}
    </section>

  {elseif $sub_view == "edit_group"}

    <header class="admin-group-hero flex min-w-0 flex-col gap-5 border-b border-base-300 pb-5 sm:flex-row sm:items-center sm:justify-between" aria-labelledby="admin-groups-title">
      <div class="admin-group-hero-identity flex min-w-0 items-center gap-4">
        <a class="admin-group-summary-photo size-16 shrink-0 overflow-hidden rounded-full border border-base-300 bg-base-200 focus-visible:outline-2 focus-visible:outline-offset-2" href="{$system['system_url']}/groups/{$data['group_name']}" target="_blank" aria-label="{__("View Group")}: {$data['group_title']}">
          <img src="{$data['group_picture']}" alt="{$data['group_title']}">
        </a>
        <div class="min-w-0">
          <h1 id="admin-groups-title" class="m-0 truncate text-2xl font-semibold" title="{$data['group_title']}">
            <a class="text-inherit hover:underline focus-visible:underline focus-visible:outline-none" href="{$system['system_url']}/groups/{$data['group_name']}" target="_blank">{$data['group_title']}</a>
          </h1>
          <div class="admin-group-hero-meta mt-1 flex min-w-0 flex-wrap items-center gap-2">
            <a class="admin-group-summary-handle truncate" href="{$system['system_url']}/groups/{$data['group_name']}" target="_blank" title="@{$data['group_name']}">@{$data['group_name']}</a>
            {if $data['group_privacy'] == "public"}
              <span class="badge badge-soft badge-success badge-sm rounded-full admin-group-hero-badge">
                <span class="icon-[tabler--world] size-3.5" aria-hidden="true"></span>
                {__("Public")}
              </span>
            {elseif $data['group_privacy'] == "closed"}
              <span class="badge badge-soft badge-warning badge-sm rounded-full admin-group-hero-badge">
                <span class="icon-[tabler--lock-open] size-3.5" aria-hidden="true"></span>
                {__("Closed")}
              </span>
            {elseif $data['group_privacy'] == "secret"}
              <span class="badge badge-soft badge-sm rounded-full admin-group-hero-badge">
                <span class="icon-[tabler--lock] size-3.5" aria-hidden="true"></span>
                {__("Secret")}
              </span>
            {/if}
          </div>
        </div>
      </div>
      <div class="admin-group-hero-actions flex shrink-0 flex-wrap items-center gap-2">
        <a class="btn btn-outline" href="{$system['system_url']}/{$control_panel['url']}/groups">
          <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
          {__("Go Back")}
        </a>
      </div>
    </header>

    <div class="admin-group-edit grid w-full gap-6">
      <div class="admin-group-edit-aside flex min-w-0 flex-col gap-4 lg:sticky lg:top-[5.5rem]">
        <aside class="admin-group-summary flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6" aria-label="{__("Group summary")}">
          <div class="admin-group-sidebar-heading flex min-w-0 items-center gap-3">
            <div class="admin-group-sidebar-heading-icon flex size-8 shrink-0 items-center justify-center rounded-md border border-base-300 bg-base-100">
              <span class="icon-[tabler--users-group] size-4" aria-hidden="true"></span>
            </div>
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug">{__("Group Details")}</h2>
          </div>
          <ul class="admin-group-summary-list grid gap-3">
            <li>
              <span class="admin-group-summary-label"><span class="icon-[tabler--id] size-3.5" aria-hidden="true"></span>{__("Group ID")}</span>
              <span class="admin-group-summary-value flex items-center justify-end gap-1">
                <span>{$data['group_id']}</span>
                <button type="button" class="admin-user-copy-button js_clipboard" data-clipboard-text="{$data['group_id']}" title="{__("Copy")}" aria-label="{__("Copy")} {__("Group ID")}">
                  <span class="js-clipboard-default icon-[tabler--copy] size-3.5" aria-hidden="true"></span>
                  <span class="js-clipboard-success icon-[tabler--check] hidden size-3.5 text-success" aria-hidden="true"></span>
                </button>
              </span>
            </li>
            <li>
              <span class="admin-group-summary-label"><span class="icon-[tabler--calendar] size-3.5" aria-hidden="true"></span>{__("Created")}</span>
              <span class="admin-group-summary-value">{$data['group_date']|date_format:"%e %B %Y"}</span>
            </li>
            <li>
              <span class="admin-group-summary-label"><span class="icon-[tabler--lock] size-3.5" aria-hidden="true"></span>{__("Privacy")}</span>
              <span class="admin-group-summary-value">
                {if $data['group_privacy'] == "public"}
                  {__("Public")}
                {elseif $data['group_privacy'] == "closed"}
                  {__("Closed")}
                {elseif $data['group_privacy'] == "secret"}
                  {__("Secret")}
                {/if}
              </span>
            </li>
            <li>
              <span class="admin-group-summary-label"><span class="icon-[tabler--users] size-3.5" aria-hidden="true"></span>{__("Members")}</span>
              <span class="admin-group-summary-value">{$data['group_members']|number_format}</span>
            </li>
            <li>
              <span class="admin-group-summary-label"><span class="icon-[tabler--user] size-3.5" aria-hidden="true"></span>{__("Created By")}</span>
              <span class="admin-group-summary-value">
                <a class="admin-user-referrer" href="{$system['system_url']}/{$control_panel['url']}/users/edit/{$data['user_id']}">
                  <img class="admin-list-avatar size-[22px] shrink-0 rounded-full object-cover" src="{$data['user_picture']}" alt="" width="22" height="22" loading="lazy">
                  <span>{if $system['show_usernames_enabled']}{$data['user_name']}{else}{$data['user_firstname']} {$data['user_lastname']}{/if}</span>
                </a>
              </span>
            </li>
          </ul>
          <div class="admin-group-summary-actions grid gap-2 border-t border-base-300 pt-5">
            <a class="btn btn-outline w-full" href="{$system['system_url']}/groups/{$data['group_name']}" target="_blank">
              <span class="icon-[tabler--arrow-up-right] size-4" aria-hidden="true"></span>
              {__("View Group")}
            </a>
            <a class="btn btn-outline w-full" href="{$system['system_url']}/groups/{$data['group_name']}/settings" target="_blank">
              <span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>
              {__("Settings")}
            </a>
          </div>
        </aside>

        <section class="admin-group-danger flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6" aria-labelledby="admin-group-danger-title">
          <div class="admin-group-sidebar-heading flex min-w-0 items-center gap-3">
            <div class="admin-group-sidebar-heading-icon is-danger flex size-8 shrink-0 items-center justify-center rounded-md border bg-base-100">
              <span class="icon-[tabler--alert-triangle] size-4" aria-hidden="true"></span>
            </div>
            <h2 id="admin-group-danger-title" class="admin-group-danger-title m-0 text-sm font-semibold leading-snug text-error">{__("Danger Zone")}</h2>
          </div>
          <p class="admin-setting-help m-0 text-sm leading-relaxed">{__("Deleting posts or this group cannot be undone.")}</p>
          <div class="admin-group-summary-actions grid gap-2">
            <button type="button" class="btn w-full text-error admin-group-danger-action js_admin-deleter" data-handle="group_posts" data-id="{$data['group_id']}" data-delete-message="{__("Are you sure you want to delete all posts?")}">
              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
              {__("Delete Posts")}
            </button>
            <button type="button" class="btn w-full text-error admin-group-danger-action js_admin-deleter" data-handle="group" data-id="{$data['group_id']}" data-redirect="{$system['system_url']}/{$control_panel['url']}/groups">
              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
              {__("Delete Group")}
            </button>
          </div>
        </section>
      </div>

      <div class="admin-group-edit-main flex min-w-0 flex-col gap-6">
        <nav class="tabs admin-settings-nav admin-group-edit-nav" role="tablist" aria-label="{__("Group Settings")}" aria-orientation="horizontal">
          <button type="button" id="groups-tab-settings" class="tab active-tab:tab-active active" data-tab="#group_settings" aria-controls="group_settings" role="tab" aria-selected="true"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("Settings")}</button>
          {if $system['monetization_enabled']}
            <button type="button" id="groups-tab-monetization" class="tab active-tab:tab-active" data-tab="#group_monetization" aria-controls="group_monetization" role="tab" aria-selected="false"><span class="icon-[tabler--coins] size-4" aria-hidden="true"></span>{__("Monetization")}</button>
          {/if}
        </nav>

        <div id="group_settings" class="admin-settings-panel js_admin-settings-panel" role="tabpanel" aria-labelledby="groups-tab-settings" tabindex="0">
          <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/groups.php?do=edit_group&edit=settings&id={$data['group_id']}">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="group-details-title">
                <h2 id="group-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Group Details")}</h2>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="group-title">{__("Name Your Group")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input class="input w-full" name="title" id="group-title" value="{$data['group_title']}" autocomplete="off">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="username">{__("Group Username")}</label>
                  <div class="admin-setting-control join w-full min-w-0" dir="ltr">
                    <span class="join-item hidden max-w-64 sm:flex min-w-10 shrink-0 items-center justify-center border border-e-0 border-base-300 bg-base-200 px-3 text-sm text-base-content/60 [[data-theme=admin-dark]_&]:border-base-content/30">
                      <span class="truncate whitespace-nowrap" title="{$system['system_url']}/groups/">{$system['system_url']}/groups/</span>
                    </span>
                    <input type="text" class="input join-item min-w-0 flex-1" name="username" id="username" value="{$data['group_name']}" autocomplete="off">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="privacy">{__("Select Privacy")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <select class="select w-full" name="privacy" id="privacy" aria-describedby="privacy-help">
                      <option {if $data['group_privacy'] == "public"}selected{/if} value="public">{__("Public Group")}</option>
                      <option {if $data['group_privacy'] == "closed"}selected{/if} value="closed">{__("Closed Group")}</option>
                      <option {if $data['group_privacy'] == "secret"}selected{/if} value="secret">{__("Secret Group")}</option>
                    </select>
                    <div id="privacy-help" class="admin-setting-help text-sm leading-relaxed">
                      {__("Note: Change group privacy to public will approve any pending join requests")}
                    </div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="category">{__("Category")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <select class="select w-full" name="category" id="category">
                      {foreach $data['categories'] as $category}
                        {include file='__categories.recursive_options.tpl' data_category=$data['group_category']}
                      {/foreach}
                    </select>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="country">{__("Country")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <select class="select w-full" name="country" id="country">
                      <option value="none">{__("Select Country")}</option>
                      {foreach $data['countries'] as $country}
                        <option value="{$country['country_id']}" {if $data['group_country'] == $country['country_id']}selected{/if}>{$country['country_name_with_flag']}</option>
                      {/foreach}
                    </select>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="language">{__("Language")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <select class="select w-full" name="language" id="language">
                      <option value="none">{__("Select Language")}</option>
                      {foreach $languages as $language}
                        <option value="{$language['language_id']}" {if $data['group_language'] == $language['language_id']}selected{/if}>{$language['title']}</option>
                      {/foreach}
                    </select>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="description">{__("About")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <textarea class="textarea w-full" name="description" id="description" rows="5">{$data['group_description']}</textarea>
                  </div>
                </div>

                {if $custom_fields['basic']}
                  {include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
                {/if}
              </div>

              <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="group-publishing-title">
                <h2 id="group-publishing-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Publishing")}</h2>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    <span class="icon-[tabler--message-chatbot] size-6" aria-hidden="true"></span>
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="chatbox_enabled">{__("Chat Box")}</label>
                    <div id="chatbox_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Enable chat box for this group")}</div>
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
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="group_publish_enabled">{__("Members Can Publish Posts?")}</label>
                    <div id="group_publish_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Members can publish posts or only group admins")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="group_publish_enabled" id="group_publish_enabled" {if $data['group_publish_enabled']}checked{/if} aria-describedby="group_publish_enabled-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    <span class="icon-[tabler--circle-check] size-6" aria-hidden="true"></span>
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="group_publish_approval_enabled">{__("Post Approval")}</label>
                    <div id="group_publish_approval_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                      {__("All posts must be approved by a group admin")}
                      <br>
                      {__("Note: Disable it will approve any pending posts")}
                    </div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="group_publish_approval_enabled" id="group_publish_approval_enabled" {if $data['group_publish_approval_enabled']}checked{/if} aria-describedby="group_publish_approval_enabled-help">
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

        {if $system['monetization_enabled']}
          <div id="group_monetization" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="groups-tab-monetization" tabindex="0">
            {if $data['can_monetize_content']}
              <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/groups.php?do=edit_group&edit=monetization&id={$data['group_id']}">
                <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
                  <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="group-monetization-title">
                    <h2 id="group-monetization-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Monetization")}</h2>

                    <div class="admin-setting-switch js_admin-setting-switch">
                      <div class="admin-setting-icon">
                        {include file='__svg_icons.tpl' icon="monetization" class="admin-setting-glyph" width="32px" height="32px"}
                      </div>
                      <div>
                        <label class="admin-setting-label block text-sm font-medium leading-normal" for="group_monetization_enabled">{__("Monetization")}</label>
                        <div id="group_monetization_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Enable or disable monetization for your content")}</div>
                      </div>
                      <div class="text-end">
                        <input type="checkbox" class="switch switch-primary" name="group_monetization_enabled" id="group_monetization_enabled" {if $data['group_monetization_enabled']}checked{/if} aria-describedby="group_monetization_enabled-help">
                      </div>
                    </div>
                  </div>
                  <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="group-plans-title">
                    <div class="grid gap-1">
                      <h2 id="group-plans-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--credit-card] size-5" aria-hidden="true"></span>{__("Payment Plans")}</h2>
                      <p class="admin-setting-help m-0 text-sm leading-relaxed">{__("Plans people can choose to support this group.")}</p>
                    </div>
                    {include file='__monetization_plans.tpl' _node_id=$data['group_id'] _node_type='group'}
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
              <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
                <div class="admin-settings-section flex flex-col gap-5 p-6">
                  <div class="alert alert-error alert-danger" role="status">{__("This group super admin is not eligible for monetization")}</div>
                </div>
              </section>
            {/if}
          </div>
        {/if}
      </div>
    </div>

  {elseif $sub_view == "categories"}

    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Categories")}">
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
                {include file='__categories.recursive_rows.tpl' _url="groups" _handle="group_category" _style="admin-list"}
              {/foreach}
            </tbody>
          </table>
        </div>
      </section>
    {else}
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-groups-categories-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--category] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-groups-categories-empty-title">{__("No categories yet")}</h2>
        <p>{__("Add your first category so groups can be organized.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/groups/add_category" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Category")}
        </a>
      </section>
    {/if}

  {elseif $sub_view == "add_category" || $sub_view == "edit_category"}

    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/groups.php?do={if $sub_view == "edit_category"}edit_category&amp;id={$data['category_id']}{else}add_category{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="group-category-details-title">
          <h2 id="group-category-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Category Details")}</h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="category_name">{__("Name")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input class="input w-full" name="category_name" id="category_name" value="{if $sub_view == "edit_category"}{$data['category_name']}{/if}" autocomplete="off">
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="category_description">{__("Description")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <textarea class="textarea w-full" name="category_description" id="category_description" rows="3">{if $sub_view == "edit_category"}{$data['category_description']}{/if}</textarea>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="category_parent_id">{__("Parent Category")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full" name="category_parent_id" id="category_parent_id">
                <option value="0">{__("Set as a Parent Category")}</option>
                {if $sub_view == "edit_category"}
                  {foreach $data["categories"] as $category}
                    {include file='__categories.recursive_options.tpl' data_category=$data['category_parent_id']}
                  {/foreach}
                {else}
                  {foreach $categories as $category}
                    {include file='__categories.recursive_options.tpl'}
                  {/foreach}
                {/if}
              </select>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="category_order">{__("Order")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input class="input w-full" name="category_order" id="category_order" value="{if $sub_view == "edit_category"}{$data['category_order']}{/if}" autocomplete="off">
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
