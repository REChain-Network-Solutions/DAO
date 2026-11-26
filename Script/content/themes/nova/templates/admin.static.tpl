<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-static-title">
  {if $sub_view == "edit" || $sub_view == "add"}
    <div class="admin-form-layout mx-auto w-full admin-form-layout-wide flex max-w-[64rem] flex-col gap-6">
  {/if}
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-static-title" class="text-2xl font-semibold">
        {if $sub_view == "edit"}
          {$data['page_title']}
        {elseif $sub_view == "add"}
          {__("Add New Page")}
        {else}
          {__("Static Pages")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "edit"}
          {__("Update the page content, address, and menu placement.")}
        {elseif $sub_view == "add"}
          {__("Create a new static page for your website.")}
        {else}
          {__("Manage the static pages of your website.")}
        {/if}
      </p>
    </div>

    {if $sub_view == ""}
      <a href="{$system['system_url']}/{$control_panel['url']}/static/add" class="btn btn-primary">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Add New Page")}
      </a>
    {else}
      <a href="{$system['system_url']}/{$control_panel['url']}/static" class="btn btn-outline">
        <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        {__("Go Back")}
      </a>
    {/if}
  </header>

  {if $sub_view == ""}
    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Static Pages")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table js_dataTable admin-list-table">
            <thead>
              <tr>
                <th>{__("Page Title")}</th>
                <th>{__("Is Redirect")}</th>
                <th>{__("In Footer")}</th>
                <th>{__("In Sidebar")}</th>
                <th>{__("Order")}</th>
                <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <div class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                      <a class="admin-list-name truncate text-sm font-semibold" target="_blank" href="{$row['url']}" title="{$row['page_title']}">{$row['page_title']}</a>
                      <span class="admin-list-id text-xs">#{number_format($row['page_id'])}</span>
                    </div>
                  </td>
                  <td>
                    {if $row['page_is_redirect']}
                      <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Yes")}</span>
                    {else}
                      <span class="badge badge-soft badge-sm rounded-full">{__("No")}</span>
                    {/if}
                  </td>
                  <td>
                    {if $row['page_in_footer']}
                      <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Yes")}</span>
                    {else}
                      <span class="badge badge-soft badge-sm rounded-full">{__("No")}</span>
                    {/if}
                  </td>
                  <td>
                    {if $row['page_in_sidebar']}
                      <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Yes")}</span>
                    {else}
                      <span class="badge badge-soft badge-sm rounded-full">{__("No")}</span>
                    {/if}
                  </td>
                  <td>{$row['page_order']}</td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="static-actions-{$row['page_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['page_title']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="static-actions-{$row['page_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/static/edit/{$row['page_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="static_page" data-id="{$row['page_id']}">
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
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-static-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--file] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-static-empty-title">{__("No pages yet")}</h2>
        <p>{__("Add your first static page to make it available on your website.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/static/add" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Page")}
        </a>
      </section>
    {/if}

  {elseif $sub_view == "edit" || $sub_view == "add"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/static.php?do={if $sub_view == "edit"}edit&amp;id={$data['page_id']}{else}add{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="static-details-title">
          <h2 id="static-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Page Details")}</h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="static-title">{__("Page Title")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="page_title" id="static-title" value="{if $sub_view == "edit"}{$data['page_title']}{/if}" autocomplete="off">
            </div>
          </div>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="js_page-is-redirect">{__("Redirect Link")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="js_page-is-redirect-help">{__("Enable this option if you want to create a page that redirects to an external link")}</div>
            </div>
            <div class="text-end">
              <input type="checkbox" class="switch switch-primary" name="page_is_redirect" id="js_page-is-redirect" {if $sub_view == "edit" && $data['page_is_redirect']}checked{/if} aria-describedby="js_page-is-redirect-help">
            </div>
          </div>

          <div id="js_page-redirect" {if $sub_view == "add" || ($sub_view == "edit" && !$data['page_is_redirect'])}class="hidden"{/if}>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="static-redirect-url">{__("Redirect URL")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="page_redirect_url" id="static-redirect-url" value="{if $sub_view == "edit"}{$data['page_redirect_url']}{/if}" autocomplete="off">
                <div class="admin-setting-help text-sm leading-relaxed">{__("The URL to redirect to")}</div>
              </div>
            </div>
          </div>

          <div id="js_page-not-redirect" {if $sub_view == "edit" && $data['page_is_redirect']}class="hidden"{/if}>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="static-url">{__("Web Address")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <div class="join w-full min-w-0" dir="ltr">
                  <span class="join-item hidden min-w-10 max-w-64 shrink-0 items-center border border-e-0 border-base-300 bg-base-200 px-3 text-sm text-base-content/60 sm:flex">
                    <span class="truncate whitespace-nowrap" title="{$system['system_url']}/static/">{$system['system_url']}/static/</span>
                  </span>
                  <input type="text" class="input join-item min-w-0 flex-1" name="page_url" id="static-url" value="{if $sub_view == "edit"}{$data['page_url']}{/if}" autocomplete="off">
                </div>
                <div class="admin-setting-help text-sm leading-relaxed">{__("Valid web address must be a-z0-9_.")}</div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="static-text">{__("Page Content")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea class="textarea w-full js_wysiwyg-advanced" name="page_text" id="static-text">{if $sub_view == "edit"}{$data['page_text']}{/if}</textarea>
              </div>
            </div>
          </div>
        </div>

        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="static-placement-title">
          <h2 id="static-placement-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Menu Placement")}</h2>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="page_in_footer">{__("Add to Footer Menu")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="page_in_footer-help">{__("Show the page in the footer menu")}</div>
            </div>
            <div class="text-end">
              <input type="checkbox" class="switch switch-primary" name="page_in_footer" id="page_in_footer" {if $sub_view == "edit" && $data['page_in_footer']}checked{/if} aria-describedby="page_in_footer-help">
            </div>
          </div>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="page_in_sidebar">{__("Add to Sidebar Menu")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="page_in_sidebar-help">{__("Show the page in the sidebar menu")}</div>
            </div>
            <div class="text-end">
              <input type="checkbox" class="switch switch-primary" name="page_in_sidebar" id="page_in_sidebar" {if $sub_view == "edit" && $data['page_in_sidebar']}checked{/if} aria-describedby="page_in_sidebar-help">
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="static-icon-label">
            <div class="label-text" id="static-icon-label">{__("Sidebar Icon")}</div>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if $sub_view == "edit" && $data['page_icon'] != ''}
                {include file='__x_image.tpl' _x_name="page_icon" _x_value=$data['page_icon'] _x_fit="contain"}
              {else}
                {include file='__x_image.tpl' _x_name="page_icon" _x_fit="contain"}
              {/if}
              <div class="admin-setting-help text-sm leading-relaxed">{__("The perfect size for your icon (width: 48px & height: 48px)")}</div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="static-order">{__("Order")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="page_order" id="static-order" value="{if $sub_view == "edit"}{$data['page_order']}{/if}" autocomplete="off">
              <div class="admin-setting-help text-sm leading-relaxed">{__("The order of the page in the footer/sidebar menu")}</div>
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
  {if $sub_view == "edit" || $sub_view == "add"}
    </div>
  {/if}
</section>
