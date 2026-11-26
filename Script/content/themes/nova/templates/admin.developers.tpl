<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-developers-title">
  {if $sub_view == "" || $sub_view == "add_category" || $sub_view == "edit_category"}
    <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
  {/if}

  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-developers-title" class="text-2xl font-semibold">
        {if $sub_view == "apps"}{__("Apps")}
        {elseif $sub_view == "categories"}{__("Categories")}
        {elseif $sub_view == "add_category"}{__("Add New Category")}
        {elseif $sub_view == "edit_category"}{__("Edit Category")}
        {else}{__("Developers")}{/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "apps"}{__("Review developer apps and their credentials.")}
        {elseif $sub_view == "categories"}{__("Organize apps into categories.")}
        {elseif $sub_view == "add_category"}{__("Create a category for developer apps.")}
        {elseif $sub_view == "edit_category"}{__("Update this category and its position.")}
        {else}{__("Turn developer apps and the share plugin on or off.")}{/if}
      </p>
    </div>

    {if $sub_view != "" && $sub_view != "apps"}
    <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
      {if $sub_view == "categories"}
        <a href="{$system['system_url']}/{$control_panel['url']}/developers/add_category" class="btn btn-primary">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Category")}
        </a>
      {elseif $sub_view == "add_category" || $sub_view == "edit_category"}
        <a href="{$system['system_url']}/{$control_panel['url']}/developers/categories" class="btn btn-outline">
          <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
          {__("Go Back")}
        </a>
      {/if}
    </div>
    {/if}
  </header>

  {if $sub_view == ""}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/developers.php?do=settings">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="developers-settings-title">
          <h2 id="developers-settings-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            <span class="icon-[tabler--stack-2] size-5" aria-hidden="true"></span>
            {__("Settings")}
          </h2>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="developers" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="developers_apps_enabled">{__("Developers Apps")}</label>
              <div id="developers_apps_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                {__("Turn the developers apps On and Off")}<br>
                {__("Developers apps will allow other developers to use your system APIs like login with and get user info")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" class="switch switch-primary" name="developers_apps_enabled" id="developers_apps_enabled" {if $system['developers_apps_enabled']}checked{/if} aria-describedby="developers_apps_enabled-help">
            </div>
          </div>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="share_plugin" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="developers_share_enabled">{__("Share Plugin")}</label>
              <div id="developers_share_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the share plugin On and Off")}</div>
            </div>
            <div class="text-end">
              <input type="checkbox" class="switch switch-primary" name="developers_share_enabled" id="developers_share_enabled" {if $system['developers_share_enabled']}checked{/if} aria-describedby="developers_share_enabled-help">
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

  {elseif $sub_view == "apps"}
    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Apps")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table js_dataTable admin-list-table">
            <thead>
              <tr>
                <th>{__("App Name")}</th>
                <th>{__("User")}</th>
                <th>{__("App ID")}</th>
                <th>{__("App Secret")}</th>
                <th>{__("Created")}</th>
                <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/developers/edit/{$row['app_auth_id']}">
                      {if $row['app_icon']}
                        <img class="admin-list-avatar size-[30px] shrink-0 rounded-md border border-base-300 object-cover" src="{$system['system_uploads']}/{$row['app_icon']}" alt="" width="30" height="30" loading="lazy">
                      {else}
                        <span class="flex size-[30px] shrink-0 items-center justify-center rounded-md border border-base-300 bg-base-200">
                          <span class="icon-[tabler--apps] text-base-content/60 size-4" aria-hidden="true"></span>
                        </span>
                      {/if}
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{$row['app_name']}">{$row['app_name']}</span>
                        <span class="admin-list-id text-xs">#{$row['app_id']}</span>
                      </span>
                    </a>
                  </td>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-2.5" target="_blank" href="{$system['system_url']}/{$row['user_name']}">
                      <img class="admin-list-avatar size-[28px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['user_picture']}" alt="" width="28" height="28" loading="lazy">
                      <span class="admin-list-name max-w-48 truncate text-sm" title="{if $system['show_usernames_enabled']}{$row['user_name']}{else}{$row['user_firstname']} {$row['user_lastname']}{/if}">
                        {if $system['show_usernames_enabled']}{$row['user_name']}{else}{$row['user_firstname']} {$row['user_lastname']}{/if}
                      </span>
                    </a>
                  </td>
                  <td>
                    <span class="font-mono text-xs [overflow-wrap:anywhere]">{$row['app_auth_id']}</span>
                  </td>
                  <td>
                    <span class="font-mono text-xs [overflow-wrap:anywhere]" title="{$row['app_auth_secret']}">{$row['app_auth_secret']}</span>
                  </td>
                  <td>{$row['app_date']|date_format:"%e %B %Y"}</td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="app-actions-{$row['app_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['app_name']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="app-actions-{$row['app_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/developers/edit/{$row['app_auth_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_developers-delete-app" role="menuitem" data-id="{$row['app_auth_id']}">
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
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-developers-apps-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--apps] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-developers-apps-empty-title">{__("No apps yet")}</h2>
        <p>{__("Developer apps will appear here.")}</p>
      </section>
    {/if}

  {elseif $sub_view == "categories"}
    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Categories")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("Category")}</th>
                <th>{__("Description")}</th>
                <th>{__("Order")}</th>
                <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                {include file='__categories.recursive_rows.tpl' _url="developers" _handle="apps_category" _style="admin-list"}
              {/foreach}
            </tbody>
          </table>
        </div>
      </section>
    {else}
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-developers-categories-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--category] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-developers-categories-empty-title">{__("No categories yet")}</h2>
        <p>{__("Add a category to organize apps.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/developers/add_category" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Category")}
        </a>
      </section>
    {/if}

  {elseif $sub_view == "add_category" || $sub_view == "edit_category"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/developers.php?do={if $sub_view == "edit_category"}edit_category&amp;id={$data['category_id']}{else}add_category{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="developers-category-details-title">
          <h2 id="developers-category-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            <span class="icon-[tabler--category] size-5" aria-hidden="true"></span>
            {__("Category Details")}
          </h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="developers-category-name">{__("Name")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input class="input w-full" name="category_name" id="developers-category-name" value="{if $sub_view == "edit_category"}{$data['category_name']}{/if}" autocomplete="off">
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="developers-category-description">{__("Description")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <textarea class="textarea w-full" name="category_description" id="developers-category-description" rows="4">{if $sub_view == "edit_category"}{$data['category_description']}{/if}</textarea>
            </div>
          </div>

          <div class="grid min-w-0 gap-5 md:grid-cols-2">
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="developers-category-parent">{__("Parent Category")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="category_parent_id" id="developers-category-parent">
                  <option value="0">{__("Set as a Parent Category")}</option>
                  {if $sub_view == "edit_category"}
                    {foreach $data['categories'] as $category}{include file='__categories.recursive_options.tpl' data_category=$data['category_parent_id']}{/foreach}
                  {else}
                    {foreach $categories as $category}{include file='__categories.recursive_options.tpl'}{/foreach}
                  {/if}
                </select>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="developers-category-order">{__("Order")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input class="input w-full" name="category_order" id="developers-category-order" value="{if $sub_view == "edit_category"}{$data['category_order']}{/if}" inputmode="numeric">
                <div class="admin-setting-help text-sm leading-relaxed">{__("Lower numbers appear first.")}</div>
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

  {if $sub_view == "" || $sub_view == "add_category" || $sub_view == "edit_category"}
    </div>
  {/if}
</section>
