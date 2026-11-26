<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-permissions-groups-title">
  {if $sub_view == "edit" || $sub_view == "add"}
    <div class="admin-form-layout mx-auto w-full admin-form-layout-wide flex max-w-[64rem] flex-col gap-6">
  {/if}
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-permissions-groups-title" class="text-2xl font-semibold">
        {if $sub_view == "edit"}
          {__("Edit Group")}
        {elseif $sub_view == "add"}
          {__("Add New Group")}
        {else}
          {__("Permissions Groups")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "edit"}
          {if $data['edit_mods']}
            {__("Choose which control panel areas moderators can manage.")}
          {else}
            {__("Update this permissions group and the modules it can use.")}
          {/if}
        {elseif $sub_view == "add"}
          {__("Create a permissions group for custom users groups.")}
        {else}
          {__("System and custom permission sets used by users groups.")}
        {/if}
      </p>
    </div>

    {if $sub_view == ""}
      <a href="{$system['system_url']}/{$control_panel['url']}/permissions_groups/add" class="btn btn-primary">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Add New Group")}
      </a>
    {else}
      <a href="{$system['system_url']}/{$control_panel['url']}/permissions_groups" class="btn btn-outline">
        <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        {__("Go Back")}
      </a>
    {/if}
  </header>

  {if $sub_view == ""}
    <div class="admin-list-stack flex flex-col gap-8">
      <section class="admin-list-group flex min-w-0 flex-col gap-3" aria-labelledby="admin-system-permissions-title">
        <div class="admin-list-group-heading grid gap-1">
          <h2 id="admin-system-permissions-title" class="admin-list-group-title m-0 flex items-center gap-2 text-base font-semibold leading-snug">
            <span class="icon-[tabler--shield-lock] size-4.5" aria-hidden="true"></span>
            {__("System Permissions Groups")}
          </h2>
          <p class="admin-list-group-note m-0 text-sm">{__("Built-in permission sets used by the system groups.")}</p>
        </div>
        <div class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none">
          <div class="admin-list-table-wrap w-full overflow-x-auto">
            <table class="table admin-list-table min-w-0!">
              <thead>
                <tr>
                  <th>{__("Group")}</th>
                  <th class="admin-list-type-column">{__("Type")}</th>
                  <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>
                    <div class="admin-list-identity flex min-w-0 items-center gap-3">
                      <span class="admin-list-icon flex size-[34px] shrink-0 items-center justify-center rounded-full border border-base-300 bg-base-200" aria-hidden="true">
                        <span class="icon-[tabler--shield-half] size-4.5"></span>
                      </span>
                      <div class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{__("Moderators Permissions")}">{__("Moderators Permissions")}</span>
                        <span class="admin-list-id text-xs">mods</span>
                      </div>
                    </div>
                  </td>
                  <td>
                    <span class="badge badge-soft badge-error badge-sm gap-1 rounded-full">
                      <span class="icon-[tabler--shield-lock] size-3.5" aria-hidden="true"></span>
                      {__("System")}
                    </span>
                  </td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="system-perm-actions-mods" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {__("Moderators Permissions")}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="system-perm-actions-mods">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/permissions_groups/edit/mods">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                      </ul>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td>
                    <div class="admin-list-identity flex min-w-0 items-center gap-3">
                      <span class="admin-list-icon flex size-[34px] shrink-0 items-center justify-center rounded-full border border-base-300 bg-base-200" aria-hidden="true">
                        <span class="icon-[tabler--users] size-4.5"></span>
                      </span>
                      <div class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{__("Users Permissions")}">{__("Users Permissions")}</span>
                        <span class="admin-list-id text-xs">users</span>
                      </div>
                    </div>
                  </td>
                  <td>
                    <span class="badge badge-soft badge-error badge-sm gap-1 rounded-full">
                      <span class="icon-[tabler--shield-lock] size-3.5" aria-hidden="true"></span>
                      {__("System")}
                    </span>
                  </td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="system-perm-actions-users" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {__("Users Permissions")}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="system-perm-actions-users">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/permissions_groups/edit/users">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                      </ul>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td>
                    <div class="admin-list-identity flex min-w-0 items-center gap-3">
                      <span class="admin-list-icon flex size-[34px] shrink-0 items-center justify-center rounded-full border border-base-300 bg-base-200" aria-hidden="true">
                        <span class="icon-[tabler--rosette-discount-check] size-4.5"></span>
                      </span>
                      <div class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{__("Verified Permissions")}">{__("Verified Permissions")}</span>
                        <span class="admin-list-id text-xs">verified</span>
                      </div>
                    </div>
                  </td>
                  <td>
                    <span class="badge badge-soft badge-error badge-sm gap-1 rounded-full">
                      <span class="icon-[tabler--shield-lock] size-3.5" aria-hidden="true"></span>
                      {__("System")}
                    </span>
                  </td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="system-perm-actions-verified" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {__("Verified Permissions")}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="system-perm-actions-verified">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/permissions_groups/edit/verified">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                      </ul>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>

      {if $rows}
        <section class="admin-list-group flex min-w-0 flex-col gap-3" aria-labelledby="admin-custom-permissions-title">
          <div class="admin-list-group-heading grid gap-1">
            <h2 id="admin-custom-permissions-title" class="admin-list-group-title m-0 flex items-center gap-2 text-base font-semibold leading-snug">
              <span class="icon-[tabler--key] size-4.5" aria-hidden="true"></span>
              {__("Custom Permissions Groups")}
            </h2>
            <p class="admin-list-group-note m-0 text-sm">{__("Permission sets you created for custom users groups.")}</p>
          </div>
          <div class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none">
            <div class="admin-list-table-wrap w-full overflow-x-auto">
              <table class="table js_dataTable admin-list-table min-w-0!">
                <thead>
                  <tr>
                    <th>{__("Group")}</th>
                    <th data-orderable="false" class="admin-list-type-column">{__("Type")}</th>
                    <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
                  </tr>
                </thead>
                <tbody>
                  {foreach $rows as $row}
                    <tr>
                      <td>
                        <div class="admin-list-identity flex min-w-0 items-center gap-3">
                          <span class="admin-list-icon flex size-[34px] shrink-0 items-center justify-center rounded-full border border-base-300 bg-base-200" aria-hidden="true">
                            <span class="icon-[tabler--key] size-4.5"></span>
                          </span>
                          <div class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                            <span class="admin-list-name truncate text-sm font-semibold" title="{$row['permissions_group_title']}">{$row['permissions_group_title']}</span>
                            <span class="admin-list-id text-xs">#{$row['permissions_group_id']}</span>
                          </div>
                        </div>
                      </td>
                      <td>
                        <span class="badge badge-soft badge-info badge-sm gap-1 rounded-full">
                          <span class="icon-[tabler--pencil] size-3.5" aria-hidden="true"></span>
                          {__("Custom")}
                        </span>
                      </td>
                      <td class="admin-list-actions-column w-14 text-end">
                        <div class="dropdown relative inline-flex [--placement:bottom-end]">
                          <button id="perm-group-actions-{$row['permissions_group_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['permissions_group_title']}">
                            <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                          </button>
                          <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="perm-group-actions-{$row['permissions_group_id']}">
                            <li>
                              <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/permissions_groups/edit/{$row['permissions_group_id']}">
                                <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                                {__("Edit")}
                              </a>
                            </li>
                            <li>
                              <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="permissions_group" data-id="{$row['permissions_group_id']}">
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
          </div>
        </section>
      {else}
        <section class="admin-list-group flex min-w-0 flex-col gap-3" aria-labelledby="admin-custom-permissions-empty-title">
          <div class="admin-list-group-heading grid gap-1">
            <h2 class="admin-list-group-title m-0 flex items-center gap-2 text-base font-semibold leading-snug">
              <span class="icon-[tabler--key] size-4.5" aria-hidden="true"></span>
              {__("Custom Permissions Groups")}
            </h2>
            <p class="admin-list-group-note m-0 text-sm">{__("Permission sets you created for custom users groups.")}</p>
          </div>
          <div class="card admin-list-empty flex min-h-[260px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none">
            <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
              <span class="icon-[tabler--key] size-6" aria-hidden="true"></span>
            </div>
            <h3 id="admin-custom-permissions-empty-title">{__("No custom permissions yet")}</h3>
            <p>{__("Add a custom permissions group when you need access beyond the system defaults.")}</p>
            <a href="{$system['system_url']}/{$control_panel['url']}/permissions_groups/add" class="btn btn-primary btn-sm">
              <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
              {__("Add New Group")}
            </a>
          </div>
        </section>
      {/if}
    </div>

  {elseif $sub_view == "edit" && isset($data.edit_mods) && $data.edit_mods}
      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/permissions_groups.php?do=edit_mods">
      <nav class="tabs admin-settings-nav admin-form-tabs" role="tablist" aria-label="{__("Moderators Permissions")}" aria-orientation="horizontal">
        <button type="button" id="perm-mods-tab-general" class="tab active-tab:tab-active active" data-tab="#perm-mods-general" aria-controls="perm-mods-general" role="tab" aria-selected="true"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("General")}</button>
        <button type="button" id="perm-mods-tab-users" class="tab active-tab:tab-active" data-tab="#perm-mods-users" aria-controls="perm-mods-users" role="tab" aria-selected="false"><span class="icon-[tabler--users] size-4" aria-hidden="true"></span>{__("Users")}</button>
        <button type="button" id="perm-mods-tab-modules" class="tab active-tab:tab-active" data-tab="#perm-mods-modules" aria-controls="perm-mods-modules" role="tab" aria-selected="false"><span class="icon-[tabler--apps] size-4" aria-hidden="true"></span>{__("Modules")}</button>
        <button type="button" id="perm-mods-tab-money" class="tab active-tab:tab-active" data-tab="#perm-mods-money" aria-controls="perm-mods-money" role="tab" aria-selected="false"><span class="icon-[tabler--coins] size-4" aria-hidden="true"></span>{__("Money")}</button>
        <button type="button" id="perm-mods-tab-tools" class="tab active-tab:tab-active" data-tab="#perm-mods-tools" aria-controls="perm-mods-tools" role="tab" aria-selected="false"><span class="icon-[tabler--tool] size-4" aria-hidden="true"></span>{__("Tools")}</button>
        <button type="button" id="perm-mods-tab-developers" class="tab active-tab:tab-active" data-tab="#perm-mods-developers" aria-controls="perm-mods-developers" role="tab" aria-selected="false"><span class="icon-[tabler--code] size-4" aria-hidden="true"></span>{__("Developers")}</button>
        <button type="button" id="perm-mods-tab-site" class="tab active-tab:tab-active" data-tab="#perm-mods-site" aria-controls="perm-mods-site" role="tab" aria-selected="false"><span class="icon-[tabler--palette] size-4" aria-hidden="true"></span>{__("Site")}</button>
      </nav>

      <div id="perm-mods-general" class="admin-settings-panel js_admin-settings-panel" role="tabpanel" aria-labelledby="perm-mods-tab-general" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Group Info")}</h2>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="permissions-group-title">{__("Group Title")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
            <input class="input w-full" name="title" id="permissions-group-title" value="{$data['permissions_group_title']}" readonly>
            </div>
            </div>
            </div>
        </section>
      </div>

      <div id="perm-mods-users" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="perm-mods-tab-users" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Users Permissions")}</h2>
            <button type="button" class="btn btn-outline btn-sm js_admin-toggle-all" data-label-enable="{__("Enable all")}" data-label-disable="{__("Disable all")}">
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            <span class="js_admin-toggle-all-label">{__("Enable all")}</span>
            </button>
            </div>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="groups" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_users_permission">{__("Users")}</label>
            <div id="mods_users_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Users")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_users_permission" id="mods_users_permission" {if $system['mods_users_permission']}checked{/if} aria-describedby="mods_users_permission-help">
            </div>
            </div>

            </div>
        </section>
      </div>

      <div id="perm-mods-modules" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="perm-mods-tab-modules" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Modules Permissions")}</h2>
            <button type="button" class="btn btn-outline btn-sm js_admin-toggle-all" data-label-enable="{__("Enable all")}" data-label-disable="{__("Disable all")}">
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            <span class="js_admin-toggle-all-label">{__("Enable all")}</span>
            </button>
            </div>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="newsfeed" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_posts_permission">{__("Posts")}</label>
            <div id="mods_posts_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Posts")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_posts_permission" id="mods_posts_permission" {if $system['mods_posts_permission']}checked{/if} aria-describedby="mods_posts_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="pages" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_pages_permission">{__("Pages")}</label>
            <div id="mods_pages_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Pages")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_pages_permission" id="mods_pages_permission" {if $system['mods_pages_permission']}checked{/if} aria-describedby="mods_pages_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="groups" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_groups_permission">{__("Groups")}</label>
            <div id="mods_groups_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Groups")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_groups_permission" id="mods_groups_permission" {if $system['mods_groups_permission']}checked{/if} aria-describedby="mods_groups_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="events" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_events_permission">{__("Events")}</label>
            <div id="mods_events_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Events")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_events_permission" id="mods_events_permission" {if $system['mods_events_permission']}checked{/if} aria-describedby="mods_events_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="blogs" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_blogs_permission">{__("Blogs")}</label>
            <div id="mods_blogs_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Blogs")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_blogs_permission" id="mods_blogs_permission" {if $system['mods_blogs_permission']}checked{/if} aria-describedby="mods_blogs_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="offers" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_offers_permission">{__("Offers")}</label>
            <div id="mods_offers_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Offers")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_offers_permission" id="mods_offers_permission" {if $system['mods_offers_permission']}checked{/if} aria-describedby="mods_offers_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="jobs" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_jobs_permission">{__("Jobs")}</label>
            <div id="mods_jobs_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Jobs")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_jobs_permission" id="mods_jobs_permission" {if $system['mods_jobs_permission']}checked{/if} aria-describedby="mods_jobs_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="courses" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_courses_permission">{__("Courses")}</label>
            <div id="mods_courses_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Courses")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_courses_permission" id="mods_courses_permission" {if $system['mods_courses_permission']}checked{/if} aria-describedby="mods_courses_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="forums" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_forums_permission">{__("Forums")}</label>
            <div id="mods_forums_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Forums")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_forums_permission" id="mods_forums_permission" {if $system['mods_forums_permission']}checked{/if} aria-describedby="mods_forums_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="movies" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_movies_permission">{__("Movies")}</label>
            <div id="mods_movies_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Movies")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_movies_permission" id="mods_movies_permission" {if $system['mods_movies_permission']}checked{/if} aria-describedby="mods_movies_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="games" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_games_permission">{__("Games")}</label>
            <div id="mods_games_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Games")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_games_permission" id="mods_games_permission" {if $system['mods_games_permission']}checked{/if} aria-describedby="mods_games_permission-help">
            </div>
            </div>

            </div>
        </section>
      </div>

      <div id="perm-mods-money" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="perm-mods-tab-money" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Money Permissions")}</h2>
            <button type="button" class="btn btn-outline btn-sm js_admin-toggle-all" data-label-enable="{__("Enable all")}" data-label-disable="{__("Disable all")}">
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            <span class="js_admin-toggle-all-label">{__("Enable all")}</span>
            </button>
            </div>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="ads" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_ads_permission">{__("Ads System")}</label>
            <div id="mods_ads_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Ads System")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_ads_permission" id="mods_ads_permission" {if $system['mods_ads_permission']}checked{/if} aria-describedby="mods_ads_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="wallet" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_wallet_permission">{__("Wallet")}</label>
            <div id="mods_wallet_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Wallet Section")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_wallet_permission" id="mods_wallet_permission" {if $system['mods_wallet_permission']}checked{/if} aria-describedby="mods_wallet_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="pro" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_pro_permission">{__("Pro System")}</label>
            <div id="mods_pro_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Pro System")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_pro_permission" id="mods_pro_permission" {if $system['mods_pro_permission']}checked{/if} aria-describedby="mods_pro_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="affiliates" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_affiliates_permission">{__("Affiliates System")}</label>
            <div id="mods_affiliates_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Affiliates System")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_affiliates_permission" id="mods_affiliates_permission" {if $system['mods_affiliates_permission']}checked{/if} aria-describedby="mods_affiliates_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="points" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_points_permission">{__("Points System")}</label>
            <div id="mods_points_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Points System")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_points_permission" id="mods_points_permission" {if $system['mods_points_permission']}checked{/if} aria-describedby="mods_points_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="market" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_marketplace_permission">{__("Marketplace System")}</label>
            <div id="mods_marketplace_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Marketplace System")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_marketplace_permission" id="mods_marketplace_permission" {if $system['mods_marketplace_permission']}checked{/if} aria-describedby="mods_marketplace_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="funding" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_funding_permission">{__("Funding System")}</label>
            <div id="mods_funding_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Funding System")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_funding_permission" id="mods_funding_permission" {if $system['mods_funding_permission']}checked{/if} aria-describedby="mods_funding_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="monetization" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_monetization_permission">{__("Monetization System")}</label>
            <div id="mods_monetization_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Monetization System")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_monetization_permission" id="mods_monetization_permission" {if $system['mods_monetization_permission']}checked{/if} aria-describedby="mods_monetization_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="friends" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_dating_permission">{__("Dating")}</label>
            <div id="mods_dating_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Dating")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_dating_permission" id="mods_dating_permission" {if $system['mods_dating_permission']}checked{/if} aria-describedby="mods_dating_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="24_hours" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_stories_permission">{__("Stories")}</label>
            <div id="mods_stories_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Stories")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_stories_permission" id="mods_stories_permission" {if $system['mods_stories_permission']}checked{/if} aria-describedby="mods_stories_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="tips" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_tips_permission">{__("Tips System")}</label>
            <div id="mods_tips_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Tips System")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_tips_permission" id="mods_tips_permission" {if $system['mods_tips_permission']}checked{/if} aria-describedby="mods_tips_permission-help">
            </div>
            </div>

            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Payments Permissions")}</h2>
            <button type="button" class="btn btn-outline btn-sm js_admin-toggle-all" data-label-enable="{__("Enable all")}" data-label-disable="{__("Disable all")}">
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            <span class="js_admin-toggle-all-label">{__("Enable all")}</span>
            </button>
            </div>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="payments" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_payments_permission">{__("Payments")}</label>
            <div id="mods_payments_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Payments Section")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_payments_permission" id="mods_payments_permission" {if $system['mods_payments_permission']}checked{/if} aria-describedby="mods_payments_permission-help">
            </div>
            </div>

            </div>
        </section>
      </div>

      <div id="perm-mods-tools" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="perm-mods-tab-tools" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Tools Permissions")}</h2>
            <button type="button" class="btn btn-outline btn-sm js_admin-toggle-all" data-label-enable="{__("Enable all")}" data-label-disable="{__("Disable all")}">
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            <span class="js_admin-toggle-all-label">{__("Enable all")}</span>
            </button>
            </div>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="report" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_reports_permission">{__("Reports")}</label>
            <div id="mods_reports_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Reports")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_reports_permission" id="mods_reports_permission" {if $system['mods_reports_permission']}checked{/if} aria-describedby="mods_reports_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="block" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_blacklist_permission">{__("Blacklist")}</label>
            <div id="mods_blacklist_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Blacklist")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_blacklist_permission" id="mods_blacklist_permission" {if $system['mods_blacklist_permission']}checked{/if} aria-describedby="mods_blacklist_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="verification" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_verifications_permission">{__("Verifications")}</label>
            <div id="mods_verifications_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Verifications")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_verifications_permission" id="mods_verifications_permission" {if $system['mods_verifications_permission']}checked{/if} aria-describedby="mods_verifications_permission-help">
            </div>
            </div>

            </div>
        </section>
      </div>

      <div id="perm-mods-developers" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="perm-mods-tab-developers" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Developers Permissions")}</h2>
            <button type="button" class="btn btn-outline btn-sm js_admin-toggle-all" data-label-enable="{__("Enable all")}" data-label-disable="{__("Disable all")}">
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            <span class="js_admin-toggle-all-label">{__("Enable all")}</span>
            </button>
            </div>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="developers" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_developers_permission">{__("Developers Options")}</label>
            <div id="mods_developers_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Developers Options")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_developers_permission" id="mods_developers_permission" {if $system['mods_developers_permission']}checked{/if} aria-describedby="mods_developers_permission-help">
            </div>
            </div>

            </div>
        </section>
      </div>

      <div id="perm-mods-site" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="perm-mods-tab-site" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Customization Permissions")}</h2>
            <button type="button" class="btn btn-outline btn-sm js_admin-toggle-all" data-label-enable="{__("Enable all")}" data-label-disable="{__("Disable all")}">
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            <span class="js_admin-toggle-all-label">{__("Enable all")}</span>
            </button>
            </div>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="design" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_customization_permission">{__("Customization")}</label>
            <div id="mods_customization_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Customization Section")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_customization_permission" id="mods_customization_permission" {if $system['mods_customization_permission']}checked{/if} aria-describedby="mods_customization_permission-help">
            </div>
            </div>

            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Reach Permissions")}</h2>
            <button type="button" class="btn btn-outline btn-sm js_admin-toggle-all" data-label-enable="{__("Enable all")}" data-label-disable="{__("Disable all")}">
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            <span class="js_admin-toggle-all-label">{__("Enable all")}</span>
            </button>
            </div>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="newsletter" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="mods_reach_permission">{__("Reach")}</label>
            <div id="mods_reach_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Manage Reach Section")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="mods_reach_permission" id="mods_reach_permission" {if $system['mods_reach_permission']}checked{/if} aria-describedby="mods_reach_permission-help">
            </div>
            </div>

            </div>
        </section>
      </div>

      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-actions flex flex-col items-stretch gap-3 p-6">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="button" class="btn btn-outline btn-sm me-auto js_admin-toggle-all" data-scope="form" data-label-enable="{__("Enable all permissions")}" data-label-disable="{__("Disable all permissions")}">
                <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
                <span class="js_admin-toggle-all-label">{__("Enable all permissions")}</span>
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
        </div>
      </section>
      </form>
    </div>

  {elseif $sub_view == "edit" || $sub_view == "add"}
      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/permissions_groups.php?do={if $sub_view == "edit"}edit&amp;id={$data['permissions_group_id']}{else}add{/if}">
      <nav class="tabs admin-settings-nav admin-form-tabs" role="tablist" aria-label="{__("Group Permissions")}" aria-orientation="horizontal">
        <button type="button" id="perm-group-tab-general" class="tab active-tab:tab-active active" data-tab="#perm-group-general" aria-controls="perm-group-general" role="tab" aria-selected="true"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("General")}</button>
        <button type="button" id="perm-group-tab-registration" class="tab active-tab:tab-active" data-tab="#perm-group-registration" aria-controls="perm-group-registration" role="tab" aria-selected="false"><span class="icon-[tabler--user-plus] size-4" aria-hidden="true"></span>{__("Registration")}</button>
        <button type="button" id="perm-group-tab-modules" class="tab active-tab:tab-active" data-tab="#perm-group-modules" aria-controls="perm-group-modules" role="tab" aria-selected="false"><span class="icon-[tabler--apps] size-4" aria-hidden="true"></span>{__("Modules")}</button>
        <button type="button" id="perm-group-tab-content" class="tab active-tab:tab-active" data-tab="#perm-group-content" aria-controls="perm-group-content" role="tab" aria-selected="false"><span class="icon-[tabler--article] size-4" aria-hidden="true"></span>{__("Content")}</button>
        <button type="button" id="perm-group-tab-ai" class="tab active-tab:tab-active" data-tab="#perm-group-ai" aria-controls="perm-group-ai" role="tab" aria-selected="false"><span class="icon-[tabler--sparkles] size-4" aria-hidden="true"></span>{__("AI")}</button>
        <button type="button" id="perm-group-tab-communication" class="tab active-tab:tab-active" data-tab="#perm-group-communication" aria-controls="perm-group-communication" role="tab" aria-selected="false"><span class="icon-[tabler--message] size-4" aria-hidden="true"></span>{__("Communication")}</button>
        <button type="button" id="perm-group-tab-uploads" class="tab active-tab:tab-active" data-tab="#perm-group-uploads" aria-controls="perm-group-uploads" role="tab" aria-selected="false"><span class="icon-[tabler--upload] size-4" aria-hidden="true"></span>{__("Uploads")}</button>
        <button type="button" id="perm-group-tab-money" class="tab active-tab:tab-active" data-tab="#perm-group-money" aria-controls="perm-group-money" role="tab" aria-selected="false"><span class="icon-[tabler--coins] size-4" aria-hidden="true"></span>{__("Money")}</button>
      </nav>

      <div id="perm-group-general" class="admin-settings-panel js_admin-settings-panel" role="tabpanel" aria-labelledby="perm-group-tab-general" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Group Info")}</h2>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="permissions-group-title">{__("Group Title")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
            <input class="input w-full" name="title" id="permissions-group-title" value="{if $sub_view == "edit"}{$data['permissions_group_title']}{/if}">
            </div>
            </div>
            </div>
        </section>
      </div>

      <div id="perm-group-registration" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="perm-group-tab-registration" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Registration Permissions")}</h2>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="invitation" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="invitation_permission">{__("Invitation")}</label>
            <div id="invitation_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Generate Invitation Codes")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="invitation_permission" id="invitation_permission" {if $sub_view == "edit" && $data['invitation_permission']}checked{/if} aria-describedby="invitation_permission-help">
            </div>
            </div>

            </div>
        </section>
      </div>

      <div id="perm-group-modules" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="perm-group-tab-modules" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Modules Permissions")}</h2>
            <button type="button" class="btn btn-outline btn-sm js_admin-toggle-all" data-label-enable="{__("Enable all")}" data-label-disable="{__("Disable all")}">
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            <span class="js_admin-toggle-all-label">{__("Enable all")}</span>
            </button>
            </div>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="pages" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="pages_permission">{__("Pages")}</label>
            <div id="pages_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Create Pages")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="pages_permission" id="pages_permission" {if $sub_view == "edit" && $data['pages_permission']}checked{/if} aria-describedby="pages_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="groups" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="groups_permission">{__("Groups")}</label>
            <div id="groups_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Create Groups")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="groups_permission" id="groups_permission" {if $sub_view == "edit" && $data['groups_permission']}checked{/if} aria-describedby="groups_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="events" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="events_permission">{__("Events")}</label>
            <div id="events_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Create Events")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="events_permission" id="events_permission" {if $sub_view == "edit" && $data['events_permission']}checked{/if} aria-describedby="events_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="reels" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="reels_permission">{__("Reels")}</label>
            <div id="reels_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Add Reels")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="reels_permission" id="reels_permission" {if $sub_view == "edit" && $data['reels_permission']}checked{/if} aria-describedby="reels_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="videos" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="watch_permission">{__("Videos")}</label>
            <div id="watch_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Watch Videos")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="watch_permission" id="watch_permission" {if $sub_view == "edit" && $data['watch_permission']}checked{/if} aria-describedby="watch_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="blogs" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="blogs_permission">{__("Blogs")} <span class="badge badge-soft badge-primary badge-sm rounded-full align-middle">{__("Write")}</span></label>
            <div id="blogs_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Write Blogs")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="blogs_permission" id="blogs_permission" {if $sub_view == "edit" && $data['blogs_permission']}checked{/if} aria-describedby="blogs_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="blogs" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="blogs_permission_read">{__("Blogs")} <span class="badge badge-soft badge-sm rounded-full align-middle">{__("Read")}</span></label>
            <div id="blogs_permission_read-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Read Blogs")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="blogs_permission_read" id="blogs_permission_read" {if $sub_view == "edit" && $data['blogs_permission_read']}checked{/if} aria-describedby="blogs_permission_read-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="market" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="market_permission">{__("Market")}</label>
            <div id="market_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Sell Products")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="market_permission" id="market_permission" {if $sub_view == "edit" && $data['market_permission']}checked{/if} aria-describedby="market_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="offers" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="offers_permission">{__("Offers")} <span class="badge badge-soft badge-primary badge-sm rounded-full align-middle">{__("Write")}</span></label>
            <div id="offers_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Create Offers")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="offers_permission" id="offers_permission" {if $sub_view == "edit" && $data['offers_permission']}checked{/if} aria-describedby="offers_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="offers" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="offers_permission_read">{__("Offers")} <span class="badge badge-soft badge-sm rounded-full align-middle">{__("Read")}</span></label>
            <div id="offers_permission_read-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Read Offers")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="offers_permission_read" id="offers_permission_read" {if $sub_view == "edit" && $data['offers_permission_read']}checked{/if} aria-describedby="offers_permission_read-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="jobs" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="jobs_permission">{__("Jobs")}</label>
            <div id="jobs_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Create Jobs")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="jobs_permission" id="jobs_permission" {if $sub_view == "edit" && $data['jobs_permission']}checked{/if} aria-describedby="jobs_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="courses" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="courses_permission">{__("Courses")}</label>
            <div id="courses_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Create courses")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="courses_permission" id="courses_permission" {if $sub_view == "edit" && $data['courses_permission']}checked{/if} aria-describedby="courses_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="forums" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="forums_permission">{__("Forums")}</label>
            <div id="forums_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Add Threads/Replies")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="forums_permission" id="forums_permission" {if $sub_view == "edit" && $data['forums_permission']}checked{/if} aria-describedby="forums_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="movies" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="movies_permission">{__("Movies")}</label>
            <div id="movies_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Watch Movies")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="movies_permission" id="movies_permission" {if $sub_view == "edit" && $data['movies_permission']}checked{/if} aria-describedby="movies_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="games" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="games_permission">{__("Games")}</label>
            <div id="games_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Play Games")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="games_permission" id="games_permission" {if $sub_view == "edit" && $data['games_permission']}checked{/if} aria-describedby="games_permission-help">
            </div>
            </div>

            </div>
        </section>
      </div>

      <div id="perm-group-content" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="perm-group-tab-content" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Posts Permissions")}</h2>
            <button type="button" class="btn btn-outline btn-sm js_admin-toggle-all" data-label-enable="{__("Enable all")}" data-label-disable="{__("Disable all")}">
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            <span class="js_admin-toggle-all-label">{__("Enable all")}</span>
            </button>
            </div>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="newsfeed" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="posts_permission">{__("Posts")}</label>
            <div id="posts_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Publish Posts")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="posts_permission" id="posts_permission" {if $sub_view == "edit" && $data['posts_permission']}checked{/if} aria-describedby="posts_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="comments" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="comments_permission">{__("Comments")}</label>
            <div id="comments_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Comment and Reply")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="comments_permission" id="comments_permission" {if $sub_view == "edit" && $data['comments_permission']}checked{/if} aria-describedby="comments_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="schedule" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="schedule_posts_permission">{__("Schedule Posts")}</label>
            <div id="schedule_posts_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Schedule Posts")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="schedule_posts_permission" id="schedule_posts_permission" {if $sub_view == "edit" && $data['schedule_posts_permission']}checked{/if} aria-describedby="schedule_posts_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="spy" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="anonymous_posts_permission">{__("Anonymous Posts")}</label>
            <div id="anonymous_posts_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Add Anonymous Posts")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="anonymous_posts_permission" id="anonymous_posts_permission" {if $sub_view == "edit" && $data['anonymous_posts_permission']}checked{/if} aria-describedby="anonymous_posts_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="collaborative" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="collaborative_posts_permission">{__("Collaborative Posts")}</label>
            <div id="collaborative_posts_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Add Collaborative Posts")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="collaborative_posts_permission" id="collaborative_posts_permission" {if $sub_view == "edit" && $data['collaborative_posts_permission']}checked{/if} aria-describedby="collaborative_posts_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="html" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="rich_text_posts_permission">{__("Rich Text Posts")}</label>
            <div id="rich_text_posts_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Add Rich Text Posts")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="rich_text_posts_permission" id="rich_text_posts_permission" {if $sub_view == "edit" && $data['rich_text_posts_permission']}checked{/if} aria-describedby="rich_text_posts_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="posts_colored" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="colored_posts_permission">{__("Colored Posts")}</label>
            <div id="colored_posts_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Add Colored Posts")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="colored_posts_permission" id="colored_posts_permission" {if $sub_view == "edit" && $data['colored_posts_permission']}checked{/if} aria-describedby="colored_posts_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="smile" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="activity_posts_permission">{__("Feelings/Activity Posts")}</label>
            <div id="activity_posts_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Add Feelings/Activity Posts")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="activity_posts_permission" id="activity_posts_permission" {if $sub_view == "edit" && $data['activity_posts_permission']}checked{/if} aria-describedby="activity_posts_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="polls" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="polls_posts_permission">{__("Polls Posts")}</label>
            <div id="polls_posts_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Add Polls Posts")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="polls_posts_permission" id="polls_posts_permission" {if $sub_view == "edit" && $data['polls_posts_permission']}checked{/if} aria-describedby="polls_posts_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="map" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="geolocation_posts_permission">{__("Geolocation Posts")}</label>
            <div id="geolocation_posts_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Add Geolocation Posts")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="geolocation_posts_permission" id="geolocation_posts_permission" {if $sub_view == "edit" && $data['geolocation_posts_permission']}checked{/if} aria-describedby="geolocation_posts_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="gif" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="gif_posts_permission">{__("GIF Posts")}</label>
            <div id="gif_posts_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Add GIF Posts")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="gif_posts_permission" id="gif_posts_permission" {if $sub_view == "edit" && $data['gif_posts_permission']}checked{/if} aria-describedby="gif_posts_permission-help">
            </div>
            </div>

            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Stories Permissions")}</h2>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="24_hours" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="stories_permission">{__("Stories")}</label>
            <div id="stories_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Add Stories")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="stories_permission" id="stories_permission" {if $sub_view == "edit" && $data['stories_permission']}checked{/if} aria-describedby="stories_permission-help">
            </div>
            </div>

            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Features Permissions")}</h2>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="gifts" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="gifts_permission">{__("Gifts")}</label>
            <div id="gifts_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Send Gifts")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="gifts_permission" id="gifts_permission" {if $sub_view == "edit" && $data['gifts_permission']}checked{/if} aria-describedby="gifts_permission-help">
            </div>
            </div>

            </div>
        </section>
      </div>

      <div id="perm-group-ai" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="perm-group-tab-ai" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("AI Permissions")}</h2>
            <button type="button" class="btn btn-outline btn-sm js_admin-toggle-all" data-label-enable="{__("Enable all")}" data-label-disable="{__("Disable all")}">
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            <span class="js_admin-toggle-all-label">{__("Enable all")}</span>
            </button>
            </div>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="ai_post" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="ai_posts_permission">{__("AI Posts")}</label>
            <div id="ai_posts_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can generate posts using AI")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="ai_posts_permission" id="ai_posts_permission" {if $sub_view == "edit" && $data['ai_posts_permission']}checked{/if} aria-describedby="ai_posts_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="ai_blog" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="ai_blogs_permission">{__("AI Blogs")}</label>
            <div id="ai_blogs_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can generate blogs using AI")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="ai_blogs_permission" id="ai_blogs_permission" {if $sub_view == "edit" && $data['ai_blogs_permission']}checked{/if} aria-describedby="ai_blogs_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="ai_image" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="ai_images_permission">{__("AI Images")}</label>
            <div id="ai_images_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can generate images using AI")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="ai_images_permission" id="ai_images_permission" {if $sub_view == "edit" && $data['ai_images_permission']}checked{/if} aria-describedby="ai_images_permission-help">
            </div>
            </div>

            </div>
        </section>
      </div>

      <div id="perm-group-communication" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="perm-group-tab-communication" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Chat Permissions")}</h2>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="audio_call" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="audio_call_permission">{__("Audio Call")}</label>
            <div id="audio_call_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Make Audio Calls")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="audio_call_permission" id="audio_call_permission" {if $sub_view == "edit" && $data['audio_call_permission']}checked{/if} aria-describedby="audio_call_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="video_call" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="video_call_permission">{__("Video Call")}</label>
            <div id="video_call_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Make Video Calls")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="video_call_permission" id="video_call_permission" {if $sub_view == "edit" && $data['video_call_permission']}checked{/if} aria-describedby="video_call_permission-help">
            </div>
            </div>

            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Live Permissions")}</h2>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="live" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="live_permission">{__("Live")}</label>
            <div id="live_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Go Live")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="live_permission" id="live_permission" {if $sub_view == "edit" && $data['live_permission']}checked{/if} aria-describedby="live_permission-help">
            </div>
            </div>

            </div>
        </section>
      </div>

      <div id="perm-group-uploads" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="perm-group-tab-uploads" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Uploads Permissions")}</h2>
            <button type="button" class="btn btn-outline btn-sm js_admin-toggle-all" data-label-enable="{__("Enable all")}" data-label-disable="{__("Disable all")}">
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            <span class="js_admin-toggle-all-label">{__("Enable all")}</span>
            </button>
            </div>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="videos" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="videos_upload_permission">{__("Videos Upload")}</label>
            <div id="videos_upload_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Upload Videos")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="videos_upload_permission" id="videos_upload_permission" {if $sub_view == "edit" && $data['videos_upload_permission']}checked{/if} aria-describedby="videos_upload_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="audios" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="audios_upload_permission">{__("Audio Upload")}</label>
            <div id="audios_upload_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Upload Audio")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="audios_upload_permission" id="audios_upload_permission" {if $sub_view == "edit" && $data['audios_upload_permission']}checked{/if} aria-describedby="audios_upload_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="files" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="files_upload_permission">{__("Files Upload")}</label>
            <div id="files_upload_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Upload Files")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="files_upload_permission" id="files_upload_permission" {if $sub_view == "edit" && $data['files_upload_permission']}checked{/if} aria-describedby="files_upload_permission-help">
            </div>
            </div>

            </div>
        </section>
      </div>

      <div id="perm-group-money" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="perm-group-tab-money" tabindex="0">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-settings-section-header flex flex-wrap items-center justify-between gap-3">
            <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Money Permissions")}</h2>
            <button type="button" class="btn btn-outline btn-sm js_admin-toggle-all" data-label-enable="{__("Enable all")}" data-label-disable="{__("Disable all")}">
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            <span class="js_admin-toggle-all-label">{__("Enable all")}</span>
            </button>
            </div>

            
            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="ads" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="ads_permission">{__("Ads")}</label>
            <div id="ads_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Create Ads")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="ads_permission" id="ads_permission" {if $sub_view == "edit" && $data['ads_permission']}checked{/if} aria-describedby="ads_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="funding" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="funding_permission">{__("Funding")}</label>
            <div id="funding_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Raise Funding")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="funding_permission" id="funding_permission" {if $sub_view == "edit" && $data['funding_permission']}checked{/if} aria-describedby="funding_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="monetization" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="monetization_permission">{__("Monetization")}</label>
            <div id="monetization_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Monetize Content")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="monetization_permission" id="monetization_permission" {if $sub_view == "edit" && $data['monetization_permission']}checked{/if} aria-describedby="monetization_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="friends" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="dating_permission">{__("Dating")}</label>
            <div id="dating_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Use Dating")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="dating_permission" id="dating_permission" {if $sub_view == "edit" && $data['dating_permission']}checked{/if} aria-describedby="dating_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="tips" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="tips_permission">{__("Tips")}</label>
            <div id="tips_permission-help" class="admin-setting-help text-sm leading-relaxed">{__("Can Receive Tips")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="tips_permission" id="tips_permission" {if $sub_view == "edit" && $data['tips_permission']}checked{/if} aria-describedby="tips_permission-help">
            </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch" data-toggle-all="skip">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="affiliates" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="custom_affiliates_system">{__("Custom Affiliates System")}</label>
            <div id="custom_affiliates_system-help" class="admin-setting-help text-sm leading-relaxed">{__("Enable it to override the default affiliates system")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="custom_affiliates_system" id="custom_affiliates_system" {if $sub_view == "edit" && $data['custom_affiliates_system']}checked{/if} aria-describedby="custom_affiliates_system-help">
            </div>
            </div>

            {if $sub_view == "edit"}
            {include file='_affiliates_levels.tpl' _affiliate=$data _editor=true}
            {else}
            {include file='_affiliates_levels.tpl' _affiliate=$system _editor=true}
            {/if}

            <div class="admin-setting-separator" role="presentation"></div>

            <div class="admin-setting-switch js_admin-setting-switch" data-toggle-all="skip">
            <div class="admin-setting-icon">
            {include file='__svg_icons.tpl' icon="points" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
            <label class="admin-setting-label block text-sm font-medium leading-normal" for="custom_points_system">{__("Custom Points System")}</label>
            <div id="custom_points_system-help" class="admin-setting-help text-sm leading-relaxed">{__("Enable it to override the default points system")}</div>
            </div>
            <div class="text-end">
            <input type="checkbox" class="switch switch-primary" name="custom_points_system" id="custom_points_system" {if $sub_view == "edit" && $data['custom_points_system']}checked{/if} aria-describedby="custom_points_system-help">
            </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="points_per_currency">{__("Points")}/{print_money("1.00")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
            <input type="text" class="input w-full" name="points_per_currency" id="points_per_currency" value="{if $sub_view == "edit"}{$data['points_per_currency']}{else}{$system['points_per_currency']}{/if}" aria-describedby="points_per_currency-help" autocomplete="off">
            <div id="points_per_currency-help" class="admin-setting-help text-sm leading-relaxed">{__("How much points eqaul to")} {print_money("1")}</div>
            </div>
            </div>

            </div>
        </section>
      </div>

      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-actions flex flex-col items-stretch gap-3 p-6">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="button" class="btn btn-outline btn-sm me-auto js_admin-toggle-all" data-scope="form" data-label-enable="{__("Enable all permissions")}" data-label-disable="{__("Disable all permissions")}">
                <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
                <span class="js_admin-toggle-all-label">{__("Enable all permissions")}</span>
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
        </div>
      </section>
      </form>
    </div>
  {/if}
</section>
