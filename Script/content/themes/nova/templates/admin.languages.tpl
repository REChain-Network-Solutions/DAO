<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-languages-title">
  {if $sub_view == "edit" || $sub_view == "add"}
    <div class="admin-form-layout mx-auto w-full admin-form-layout-wide flex max-w-[64rem] flex-col gap-6">
  {/if}
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-languages-title" class="text-2xl font-semibold">
        {if $sub_view == "edit"}
          {__("Edit Language")}
        {elseif $sub_view == "add"}
          {__("Add New Language")}
        {else}
          {__("Languages")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "edit"}
          {__("Update the availability and identity of this language.")}
        {elseif $sub_view == "add"}
          {__("Add a language and choose how visitors can use it.")}
        {else}
          {__("Manage the languages available across your website.")}
        {/if}
      </p>
    </div>

    {if $sub_view == ""}
      <a href="{$system['system_url']}/{$control_panel['url']}/languages/add" class="btn btn-primary">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Add New Language")}
      </a>
    {else}
      <a href="{$system['system_url']}/{$control_panel['url']}/languages" class="btn btn-outline">
        <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        {__("Go Back")}
      </a>
    {/if}
  </header>

  {if $sub_view == ""}
    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Languages")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table js_dataTable admin-list-table">
            <thead>
              <tr>
                <th>{__("Language")}</th>
                <th>{__("Code")}</th>
                <th>{__("Order")}</th>
                <th>{__("Default")}</th>
                <th>{__("Enabled")}</th>
                <th>{__("Direction")}</th>
                <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <div class="admin-list-identity flex min-w-0 items-center gap-3">
                      {if $row['flag']}
                        <img class="admin-language-flag size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['flag']}" alt="" width="30" height="30" loading="lazy">
                      {else}
                        <span class="admin-language-flag size-[30px] shrink-0 rounded-full border border-base-300 object-cover admin-language-flag-fallback" aria-hidden="true">
                          <span class="icon-[tabler--flag] size-3.5"></span>
                        </span>
                      {/if}
                      <div class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{$row['title']}">{$row['title']}</span>
                        <span class="admin-list-id text-xs">#{number_format($row['language_id'])}</span>
                      </div>
                    </div>
                  </td>
                  <td>{$row['code']}</td>
                  <td>{$row['language_order']}</td>
                  <td>
                    {if $row['default']}
                      <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Yes")}</span>
                    {else}
                      <span class="badge badge-soft badge-sm rounded-full">{__("No")}</span>
                    {/if}
                  </td>
                  <td>
                    {if $row['enabled']}
                      <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Yes")}</span>
                    {else}
                      <span class="badge badge-soft badge-sm rounded-full">{__("No")}</span>
                    {/if}
                  </td>
                  <td>
                    <span class="badge badge-soft badge-sm rounded-full">{$row['dir']}</span>
                  </td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="language-actions-{$row['language_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['title']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="language-actions-{$row['language_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/languages/edit/{$row['language_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          {if $row['default']}
                            <button type="button" class="dropdown-item px-2 admin-list-delete-disabled cursor-not-allowed opacity-50" role="menuitem" disabled aria-describedby="default-language-delete-help-{$row['language_id']}">
                              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                              <span>
                                {__("Delete")}
                                <span id="default-language-delete-help-{$row['language_id']}" class="admin-list-action-note mt-0.5 block text-[11px] font-normal leading-snug whitespace-normal">{__("The default language cannot be deleted")}</span>
                              </span>
                            </button>
                          {else}
                            <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="language" data-id="{$row['language_id']}">
                              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                              {__("Delete")}
                            </button>
                          {/if}
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
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-languages-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--language] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-languages-empty-title">{__("No languages yet")}</h2>
        <p>{__("Add your first language to make it available to your website.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/languages/add" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Language")}
        </a>
      </section>
    {/if}

  {elseif $sub_view == "edit" || $sub_view == "add"}
      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/languages.php?do={if $sub_view == "edit"}edit&amp;id={$data['language_id']}{else}add{/if}">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="language-status-title">
            <h2 id="language-status-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Language Status")}</h2>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                <span class="icon-[tabler--star] size-6" aria-hidden="true"></span>
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="default">{__("Default")}</label>
                <div id="default-help" class="admin-setting-help text-sm leading-relaxed">{__("Make it the default language of the site")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary" name="default" id="default" {if $sub_view == "edit" && $data['default']}checked{/if} aria-describedby="default-help">
              </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                <span class="icon-[tabler--language] size-6" aria-hidden="true"></span>
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="enabled">{__("Enabled")}</label>
                <div id="enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Make it enbaled so the user can translate the site to it")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary" name="enabled" id="enabled" {if $sub_view == "edit" && $data['enabled']}checked{/if} aria-describedby="enabled-help">
              </div>
            </div>
          </div>

          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="language-details-title">
            <h2 id="language-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Language Details")}</h2>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="language-code">{__("Code")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="code" id="language-code" value="{if $sub_view == "edit"}{$data['code']}{/if}" aria-describedby="language-code-help" autocomplete="off">
                <div id="language-code-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Language country_code, For Example: en_us, ar_sa or fr_fr")}
                </div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="language-title">{__("Native Name")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="title" id="language-title" value="{if $sub_view == "edit"}{$data['title']}{/if}" aria-describedby="language-title-help" autocomplete="off">
                <div id="language-title-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("The native name of this language")}
                </div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="language-flag-label">
              <div class="label-text" id="language-flag-label">{__("Flag")}</div>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if $sub_view == "edit" && $data['flag'] != ''}
                  {include file='__x_image.tpl' _x_name="flag" _x_value=$data['flag'] _x_fit="contain"}
                {else}
                  {include file='__x_image.tpl' _x_name="flag" _x_fit="contain"}
                {/if}
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="language-dir">{__("Direction")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="dir" id="language-dir" aria-describedby="language-dir-help">
                  <option value="LTR" {if $sub_view == "edit" && $data['dir'] == "LTR"}selected{/if}>LTR</option>
                  <option value="RTL" {if $sub_view == "edit" && $data['dir'] == "RTL"}selected{/if}>RTL</option>
                </select>
                <div id="language-dir-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("The direction of this language 'Left To Right' or 'Right To Left'")}
                </div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="language-order">{__("Order")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="language_order" id="language-order" value="{if $sub_view == "edit"}{$data['language_order']}{/if}" autocomplete="off">
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
