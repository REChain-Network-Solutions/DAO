<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-countries-title">
  {if $sub_view == "edit" || $sub_view == "add"}
    <div class="admin-form-layout mx-auto w-full admin-form-layout-wide flex max-w-[64rem] flex-col gap-6">
  {/if}
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-countries-title" class="text-2xl font-semibold">
        {if $sub_view == "edit"}
          {__("Edit Country")}
        {elseif $sub_view == "add"}
          {__("Add New Country")}
        {else}
          {__("Countries")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "edit"}
          {__("Update the availability and details of this country.")}
        {elseif $sub_view == "add"}
          {__("Add a country and choose how visitors can use it.")}
        {else}
          {__("Manage the countries available across your website.")}
        {/if}
      </p>
    </div>

    {if $sub_view == ""}
      <a href="{$system['system_url']}/{$control_panel['url']}/countries/add" class="btn btn-primary">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Add New Country")}
      </a>
    {else}
      <a href="{$system['system_url']}/{$control_panel['url']}/countries" class="btn btn-outline">
        <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        {__("Go Back")}
      </a>
    {/if}
  </header>

  {if $sub_view == ""}
    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Countries")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table js_dataTable admin-list-table">
            <thead>
              <tr>
                <th>{__("Country")}</th>
                <th>{__("Code")}</th>
                <th>{__("Phone")}</th>
                <th>{__("VAT")}</th>
                <th>{__("Order")}</th>
                <th>{__("Default")}</th>
                <th>{__("Enabled")}</th>
                <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <div class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                      <span class="admin-list-name truncate text-sm font-semibold" title="{$row['country_name']}">{if $row['country_flag']}{$row['country_flag']} {/if}{$row['country_name']}</span>
                      <span class="admin-list-id text-xs">#{number_format($row['country_id'])}</span>
                    </div>
                  </td>
                  <td>{$row['country_code']}</td>
                  <td>{$row['phone_code']}</td>
                  <td>{$row['country_vat']}</td>
                  <td>{$row['country_order']}</td>
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
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="country-actions-{$row['country_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['country_name']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="country-actions-{$row['country_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/countries/edit/{$row['country_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          {if $row['default']}
                            <button type="button" class="dropdown-item px-2 admin-list-delete-disabled cursor-not-allowed opacity-50" role="menuitem" disabled aria-describedby="default-country-delete-help-{$row['country_id']}">
                              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                              <span>
                                {__("Delete")}
                                <span id="default-country-delete-help-{$row['country_id']}" class="admin-list-action-note mt-0.5 block text-[11px] font-normal leading-snug whitespace-normal">{__("The default country cannot be deleted")}</span>
                              </span>
                            </button>
                          {else}
                            <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="country" data-id="{$row['country_id']}">
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
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-countries-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--world] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-countries-empty-title">{__("No countries yet")}</h2>
        <p>{__("Add your first country to make it available to your website.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/countries/add" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Country")}
        </a>
      </section>
    {/if}

  {elseif $sub_view == "edit" || $sub_view == "add"}
      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/countries.php?do={if $sub_view == "edit"}edit&amp;id={$data['country_id']}{else}add{/if}">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="country-status-title">
            <h2 id="country-status-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Country Status")}</h2>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                <span class="icon-[tabler--star] size-6" aria-hidden="true"></span>
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="default">{__("Default")}</label>
                <div id="default-help" class="admin-setting-help text-sm leading-relaxed">{__("Make it the default country of the site")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary" name="default" id="default" {if $sub_view == "edit" && $data['default']}checked{/if} aria-describedby="default-help">
              </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                <span class="icon-[tabler--world] size-6" aria-hidden="true"></span>
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="enabled">{__("Enabled")}</label>
                <div id="enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Make it enbaled so the user can select it")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary" name="enabled" id="enabled" {if $sub_view == "edit" && $data['enabled']}checked{/if} aria-describedby="enabled-help">
              </div>
            </div>
          </div>

          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="country-details-title">
            <h2 id="country-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Country Details")}</h2>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="country-name">{__("Country Name")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="country_name" id="country-name" value="{if $sub_view == "edit"}{$data['country_name']}{/if}" autocomplete="off">
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="country-code">{__("Country Code")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="country_code" id="country-code" value="{if $sub_view == "edit"}{$data['country_code']}{/if}" aria-describedby="country-code-help" autocomplete="off">
                <div id="country-code-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Country Code, For Example: us, sa or fr")}
                </div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="country-flag">{__("Native Emoji")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="country_flag" id="country-flag" value="{if $sub_view == "edit"}{$data['country_flag']}{/if}" maxlength="16" aria-describedby="country-flag-help" autocomplete="off">
                <div id="country-flag-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("You can get it from here")} <a target="_blank" href="https://getemoji.com/">https://getemoji.com/</a>
                </div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="country-phone">{__("Phone Code")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="phone_code" id="country-phone" value="{if $sub_view == "edit"}{$data['phone_code']}{/if}" aria-describedby="country-phone-help" autocomplete="off">
                <div id="country-phone-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Phone Code, For Example: +1, +44 or +971")}
                </div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="country-vat">{__("VAT Percentage")} (%)</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="country_vat" id="country-vat" value="{if $sub_view == "edit"}{$data['country_vat']}{/if}" aria-describedby="country-vat-help" autocomplete="off">
                <div id="country-vat-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Country VAT Percentage")}
                </div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="country-order">{__("Order")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="country_order" id="country-order" value="{if $sub_view == "edit"}{$data['country_order']}{/if}" autocomplete="off">
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
