<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-reactions-title">
  {if $sub_view == "edit"}
    <div class="admin-form-layout mx-auto w-full admin-form-layout-wide flex max-w-[64rem] flex-col gap-6">
  {/if}
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-reactions-title" class="text-2xl font-semibold">
        {if $sub_view == "edit"}
          {__("Edit Reaction")}
        {else}
          {__("Reactions")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "edit"}
          {__("Update the title, color and image of this reaction.")}
        {else}
          {__("Manage the reactions users can leave on posts.")}
        {/if}
      </p>
    </div>

    {if $sub_view == "edit"}
      <a href="{$system['system_url']}/{$control_panel['url']}/reactions" class="btn btn-outline">
        <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        {__("Go Back")}
      </a>
    {/if}
  </header>

  {if $sub_view == ""}
    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Reactions")}">
      <div class="admin-list-table-wrap w-full overflow-x-auto">
        <table class="table js_dataTable admin-list-table">
          <thead>
            <tr>
              <th>{__("Reaction")}</th>
              <th>{__("Action")}</th>
              <th>{__("Order")}</th>
              <th>{__("Enabled")}</th>
              <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
            </tr>
          </thead>
          <tbody>
            {foreach $rows as $row}
              <tr>
                <td>
                  <div class="admin-list-identity flex min-w-0 items-center gap-3">
                    <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-contain p-1" src="{$row['image_url']}" alt="" width="30" height="30" loading="lazy">
                    <div class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                      <span class="admin-list-name truncate text-sm font-semibold" style="color: {$row['color']};" title="{$row['title']}">{$row['title']}</span>
                      <span class="admin-list-id text-xs">#{number_format($row['reaction_id'])}</span>
                    </div>
                  </div>
                </td>
                <td>
                  <span class="badge badge-soft badge-sm rounded-full">{$row['reaction']}</span>
                </td>
                <td>{$row['reaction_order']}</td>
                <td>
                  {if $row['enabled']}
                    <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Yes")}</span>
                  {else}
                    <span class="badge badge-soft badge-sm rounded-full">{__("No")}</span>
                  {/if}
                </td>
                <td class="admin-list-actions-column w-14 text-end">
                  <div class="dropdown relative inline-flex [--placement:bottom-end]">
                    <button id="reaction-actions-{$row['reaction_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['title']}">
                      <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                    </button>
                    <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="reaction-actions-{$row['reaction_id']}">
                      <li>
                        <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/reactions/edit/{$row['reaction_id']}">
                          <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                          {__("Edit")}
                        </a>
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

  {elseif $sub_view == "edit"}
      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/reactions.php?do=edit&amp;id={$data['reaction_id']}">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="reaction-details-title">
            <h2 id="reaction-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Reaction Details")}</h2>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <div class="label-text">{__("Action")}</div>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <span class="badge badge-soft badge-primary badge-sm w-fit rounded-full">{$data['reaction']}</span>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="reaction-title">{__("Title")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="title" id="reaction-title" value="{$data['title']}" autocomplete="off">
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="reaction-color">{__("Color")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <div class="admin-settings-colorpicker js_colorpicker">
                  <input type="text" class="input w-full" name="color" id="reaction-color" value="{$data['color']}">
                  <input type="color" class="admin-settings-color-swatch" value="{$data['color']}" aria-label="{__("Color")}">
                </div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="reaction-image-label">
              <div class="label-text" id="reaction-image-label">{__("Image")}</div>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if $data['image'] == ''}
                  {include file='__x_image.tpl' _x_name="image" _x_fit="contain"}
                {else}
                  {include file='__x_image.tpl' _x_name="image" _x_value=$data['image'] _x_fit="contain"}
                {/if}
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="reaction-order">{__("Order")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="reaction_order" id="reaction-order" value="{$data['reaction_order']}" autocomplete="off">
              </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                <span class="icon-[tabler--mood-smile] size-6" aria-hidden="true"></span>
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="enabled">{__("Enabled")}</label>
                <div id="enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Make it enbaled so the user can select it")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary" name="enabled" id="enabled" {if $data['enabled']}checked{/if} aria-describedby="enabled-help">
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
