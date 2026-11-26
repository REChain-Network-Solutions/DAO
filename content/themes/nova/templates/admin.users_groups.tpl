<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-users-groups-title">
  {if $sub_view == "edit" || $sub_view == "add"}
    <div class="admin-form-layout mx-auto w-full admin-form-layout-wide flex max-w-[64rem] flex-col gap-6">
  {/if}
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-users-groups-title" class="text-2xl font-semibold">
        {if $sub_view == "edit"}
          {__("Edit Group")}
        {elseif $sub_view == "add"}
          {__("Add New Group")}
        {else}
          {__("Users Groups")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "edit"}
          {__("Update this group title and the permissions it uses.")}
        {elseif $sub_view == "add"}
          {__("Create a custom users group and assign its permissions.")}
        {else}
          {__("System and custom groups that control who can do what.")}
        {/if}
      </p>
    </div>

    {if $sub_view == ""}
      <a href="{$system['system_url']}/{$control_panel['url']}/users_groups/add" class="btn btn-primary">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Add New Group")}
      </a>
    {else}
      <a href="{$system['system_url']}/{$control_panel['url']}/users_groups" class="btn btn-outline">
        <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        {__("Go Back")}
      </a>
    {/if}
  </header>

  {if $sub_view == ""}
    <div class="admin-list-stack flex flex-col gap-8">
      <section class="admin-list-group flex min-w-0 flex-col gap-3" aria-labelledby="admin-system-groups-title">
        <div class="admin-list-group-heading grid gap-1">
          <h2 id="admin-system-groups-title" class="admin-list-group-title m-0 flex items-center gap-2 text-base font-semibold leading-snug">
            <span class="icon-[tabler--shield-lock] size-4.5" aria-hidden="true"></span>
            {__("System Groups")}
          </h2>
          <p class="admin-list-group-note m-0 text-sm">{__("Built-in groups that ship with the system and cannot be deleted.")}</p>
        </div>
        <div class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none">
          <div class="admin-list-table-wrap w-full overflow-x-auto">
            <table class="table admin-list-table">
              <thead>
                <tr>
                  <th>{__("Group")}</th>
                  <th class="admin-list-perms-column">{__("Permissions")}</th>
                  <th class="admin-list-count-column">{__("Users Count")}</th>
                  <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>
                    <div class="admin-list-identity flex min-w-0 items-center gap-3">
                      <span class="admin-list-icon flex size-[34px] shrink-0 items-center justify-center rounded-full border border-base-300 bg-base-200" aria-hidden="true">
                        <span class="icon-[tabler--shield-check] size-4.5"></span>
                      </span>
                      <div class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{__("Admins")}">{__("Admins")}</span>
                        <span class="admin-list-id text-xs">#1</span>
                      </div>
                    </div>
                  </td>
                  <td>
                    <span class="badge badge-soft badge-error badge-sm gap-1 rounded-full">
                      <span class="icon-[tabler--key] size-3.5" aria-hidden="true"></span>
                      {__("Admins Permissions")}
                    </span>
                  </td>
                  <td>
                    <span class="admin-list-inline inline-flex items-center gap-1.5">
                      <span class="icon-[tabler--users] size-4 opacity-60" aria-hidden="true"></span>
                      {$counters['admins_count']|number_format}
                    </span>
                  </td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="system-group-actions-admins" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {__("Admins")}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="system-group-actions-admins">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/users/admins">
                            <span class="icon-[tabler--users] size-4" aria-hidden="true"></span>
                            {__("List Accounts")}
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
                        <span class="icon-[tabler--shield-half] size-4.5"></span>
                      </span>
                      <div class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{__("Moderators")}">{__("Moderators")}</span>
                        <span class="admin-list-id text-xs">#2</span>
                      </div>
                    </div>
                  </td>
                  <td>
                    <span class="badge badge-soft badge-warning badge-sm gap-1 rounded-full">
                      <span class="icon-[tabler--key] size-3.5" aria-hidden="true"></span>
                      {__("Moderators Permissions")}
                    </span>
                  </td>
                  <td>
                    <span class="admin-list-inline inline-flex items-center gap-1.5">
                      <span class="icon-[tabler--users] size-4 opacity-60" aria-hidden="true"></span>
                      {$counters['moderators_count']|number_format}
                    </span>
                  </td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="system-group-actions-moderators" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {__("Moderators")}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="system-group-actions-moderators">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/users/moderators">
                            <span class="icon-[tabler--users] size-4" aria-hidden="true"></span>
                            {__("List Accounts")}
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
                        <span class="admin-list-name truncate text-sm font-semibold" title="{__("Users")}">{__("Users")}</span>
                        <span class="admin-list-id text-xs">#3</span>
                      </div>
                    </div>
                  </td>
                  <td>
                    <a class="badge badge-soft badge-info badge-sm gap-1 rounded-full" href="{$system['system_url']}/{$control_panel['url']}/permissions_groups/edit/users">
                      <span class="icon-[tabler--key] size-3.5" aria-hidden="true"></span>
                      {__("Users Permissions")}
                    </a>
                  </td>
                  <td>
                    <span class="admin-list-inline inline-flex items-center gap-1.5">
                      <span class="icon-[tabler--users] size-4 opacity-60" aria-hidden="true"></span>
                      {$counters['users_count']|number_format}
                    </span>
                  </td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="system-group-actions-users" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {__("Users")}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="system-group-actions-users">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/users?ncug=true">
                            <span class="icon-[tabler--users] size-4" aria-hidden="true"></span>
                            {__("List Accounts")}
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
        <section class="admin-list-group flex min-w-0 flex-col gap-3" aria-labelledby="admin-custom-groups-title">
          <div class="admin-list-group-heading grid gap-1">
            <h2 id="admin-custom-groups-title" class="admin-list-group-title m-0 flex items-center gap-2 text-base font-semibold leading-snug">
              <span class="icon-[tabler--users-group] size-4.5" aria-hidden="true"></span>
              {__("Custom Groups")}
            </h2>
            <p class="admin-list-group-note m-0 text-sm">{__("Groups you created, each linked to a permissions group.")}</p>
          </div>
          <div class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none">
            <div class="admin-list-table-wrap w-full overflow-x-auto">
              <table class="table js_dataTable admin-list-table">
                <thead>
                  <tr>
                    <th>{__("Group")}</th>
                    <th class="admin-list-perms-column">{__("Permissions")}</th>
                    <th class="admin-list-count-column">{__("Users Count")}</th>
                    <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
                  </tr>
                </thead>
                <tbody>
                  {foreach $rows as $row}
                    <tr>
                      <td>
                        <div class="admin-list-identity flex min-w-0 items-center gap-3">
                          <span class="admin-list-icon flex size-[34px] shrink-0 items-center justify-center rounded-full border border-base-300 bg-base-200" aria-hidden="true">
                            <span class="icon-[tabler--users-group] size-4.5"></span>
                          </span>
                          <div class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                            <span class="admin-list-name truncate text-sm font-semibold" title="{$row['user_group_title']}">{$row['user_group_title']}</span>
                            <span class="admin-list-id text-xs">#{$row['user_group_id']}</span>
                          </div>
                        </div>
                      </td>
                      <td>
                        <a class="badge badge-soft badge-primary badge-sm gap-1 rounded-full" href="{$system['system_url']}/{$control_panel['url']}/permissions_groups/edit/{$row['permissions_group_id']}">
                          <span class="icon-[tabler--key] size-3.5" aria-hidden="true"></span>
                          {$row['permissions_group_title']}
                        </a>
                      </td>
                      <td>
                        <span class="admin-list-inline inline-flex items-center gap-1.5">
                          <span class="icon-[tabler--users] size-4 opacity-60" aria-hidden="true"></span>
                          {$row['users_count']|number_format}
                        </span>
                      </td>
                      <td class="admin-list-actions-column w-14 text-end">
                        <div class="dropdown relative inline-flex [--placement:bottom-end]">
                          <button id="user-group-actions-{$row['user_group_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['user_group_title']}">
                            <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                          </button>
                          <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="user-group-actions-{$row['user_group_id']}">
                            <li>
                              <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/users?cug={$row['user_group_id']}">
                                <span class="icon-[tabler--users] size-4" aria-hidden="true"></span>
                                {__("List Accounts")}
                              </a>
                            </li>
                            <li>
                              <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/users_groups/edit/{$row['user_group_id']}">
                                <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                                {__("Edit")}
                              </a>
                            </li>
                            <li>
                              <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="user_group" data-id="{$row['user_group_id']}">
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
        <section class="admin-list-group flex min-w-0 flex-col gap-3" aria-labelledby="admin-custom-groups-empty-title">
          <div class="admin-list-group-heading grid gap-1">
            <h2 class="admin-list-group-title m-0 flex items-center gap-2 text-base font-semibold leading-snug">
              <span class="icon-[tabler--users-group] size-4.5" aria-hidden="true"></span>
              {__("Custom Groups")}
            </h2>
            <p class="admin-list-group-note m-0 text-sm">{__("Groups you created, each linked to a permissions group.")}</p>
          </div>
          <div class="card admin-list-empty flex min-h-[260px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none">
            <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
              <span class="icon-[tabler--users-group] size-6" aria-hidden="true"></span>
            </div>
            <h3 id="admin-custom-groups-empty-title">{__("No custom groups yet")}</h3>
            <p>{__("Add a custom group when you need permissions beyond Admins, Moderators, and Users.")}</p>
            <a href="{$system['system_url']}/{$control_panel['url']}/users_groups/add" class="btn btn-primary btn-sm">
              <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
              {__("Add New Group")}
            </a>
          </div>
        </section>
      {/if}
    </div>

  {elseif $sub_view == "edit" || $sub_view == "add"}
      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/users_groups.php?do={if $sub_view == "edit"}edit&amp;id={$data['user_group_id']}{else}add{/if}">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="user-group-details-title">
            <h2 id="user-group-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Group Details")}</h2>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="user-group-title">{__("Group Title")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input class="input w-full" name="title" id="user-group-title" value="{if $sub_view == "edit"}{$data['user_group_title']}{/if}" autocomplete="off">
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="user-group-permissions">{__("Group Permissions")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="permissions_group" id="user-group-permissions" aria-describedby="user-group-permissions-help">
                  <option value="none">{__("Select permissions group")}</option>
                  {if $sub_view == "edit"}
                    {foreach $data['permissions_groups'] as $group}
                      <option {if $data['permissions_group_id'] == $group['permissions_group_id']}selected{/if} value="{$group['permissions_group_id']}">{$group['permissions_group_title']}</option>
                    {/foreach}
                  {else}
                    {foreach $permissions_groups as $group}
                      <option value="{$group['permissions_group_id']}">{$group['permissions_group_title']}</option>
                    {/foreach}
                  {/if}
                </select>
                <div id="user-group-permissions-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("You can manage permissions from")} <a href="{$system['system_url']}/{$control_panel['url']}/permissions_groups">{__("Permissions Groups")}</a>
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
    </div>
  {/if}
</section>
