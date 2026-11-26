<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-currencies-title">
  {if $sub_view == "edit" || $sub_view == "add"}
    <div class="admin-form-layout mx-auto w-full admin-form-layout-wide flex max-w-[64rem] flex-col gap-6">
  {/if}
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-currencies-title" class="text-2xl font-semibold">
        {if $sub_view == "edit"}
          {__("Edit Currency")}
        {elseif $sub_view == "add"}
          {__("Add New Currency")}
        {else}
          {__("Currencies")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "edit"}
          {__("Update the availability and details of this currency.")}
        {elseif $sub_view == "add"}
          {__("Add a currency and choose how it is displayed.")}
        {else}
          {__("Manage the currencies available across your website.")}
        {/if}
      </p>
    </div>

    {if $sub_view == ""}
      <a href="{$system['system_url']}/{$control_panel['url']}/currencies/add" class="btn btn-primary">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Add New Currency")}
      </a>
    {else}
      <a href="{$system['system_url']}/{$control_panel['url']}/currencies" class="btn btn-outline">
        <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        {__("Go Back")}
      </a>
    {/if}
  </header>

  {if $sub_view == ""}
    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Currencies")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table js_dataTable admin-list-table">
            <thead>
              <tr>
                <th>{__("Currency")}</th>
                <th>{__("Code")}</th>
                <th>{__("Symbol")}</th>
                <th>{__("Dir")}</th>
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
                      <span class="admin-list-name truncate text-sm font-semibold" title="{$row['name']}">{$row['name']}</span>
                      <span class="admin-list-id text-xs">#{number_format($row['currency_id'])}</span>
                    </div>
                  </td>
                  <td>{$row['code']}</td>
                  <td>{$row['symbol']}</td>
                  <td>
                    <span class="badge badge-soft badge-sm rounded-full">{if $row['dir'] == "right"}{__("Right")}{else}{__("Left")}{/if}</span>
                  </td>
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
                      <button id="currency-actions-{$row['currency_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['name']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="currency-actions-{$row['currency_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/currencies/edit/{$row['currency_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          {if $row['default']}
                            <button type="button" class="dropdown-item px-2 admin-list-delete-disabled cursor-not-allowed opacity-50" role="menuitem" disabled aria-describedby="default-currency-delete-help-{$row['currency_id']}">
                              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                              <span>
                                {__("Delete")}
                                <span id="default-currency-delete-help-{$row['currency_id']}" class="admin-list-action-note mt-0.5 block text-[11px] font-normal leading-snug whitespace-normal">{__("The default currency cannot be deleted")}</span>
                              </span>
                            </button>
                          {else}
                            <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="currency" data-id="{$row['currency_id']}">
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
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-currencies-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--currency-dollar] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-currencies-empty-title">{__("No currencies yet")}</h2>
        <p>{__("Add your first currency to make it available to your website.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/currencies/add" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Currency")}
        </a>
      </section>
    {/if}

  {elseif $sub_view == "edit" || $sub_view == "add"}
      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/currencies.php?do={if $sub_view == "edit"}edit&amp;id={$data['currency_id']}{else}add{/if}">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="currency-status-title">
            <h2 id="currency-status-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Currency Status")}</h2>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                <span class="icon-[tabler--currency-dollar] size-6" aria-hidden="true"></span>
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

          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="currency-details-title">
            <h2 id="currency-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Currency Details")}</h2>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="currency-name">{__("Currency Name")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="name" id="currency-name" value="{if $sub_view == "edit"}{$data['name']}{/if}" aria-describedby="currency-name-help" autocomplete="off">
                <div id="currency-name-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Currency name, For Example: U.S. Dollar, Euro or Pound Sterling")}
                </div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="currency-code">{__("Currency Code")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="code" id="currency-code" value="{if $sub_view == "edit"}{$data['code']}{/if}" aria-describedby="currency-code-help" autocomplete="off">
                <div id="currency-code-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Currency code, For Example: USD, EUR or GBP")}
                </div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="currency-symbol">{__("Currency Symbol")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="symbol" id="currency-symbol" value="{if $sub_view == "edit"}{$data['symbol']}{/if}" aria-describedby="currency-symbol-help" autocomplete="off">
                <div id="currency-symbol-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Currency symbol, For Example: $, € or £")}
                </div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="currency-dir">{__("Currency Symbol Direction")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="dir" id="currency-dir" aria-describedby="currency-dir-help">
                  <option value="left" {if $sub_view == "edit" && $data['dir'] == "left"}selected{/if}>{__("Left")}</option>
                  <option value="right" {if $sub_view == "edit" && $data['dir'] == "right"}selected{/if}>{__("Right")}</option>
                </select>
                <div id="currency-dir-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Where to add the currency symbol relative to the money value")}
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
