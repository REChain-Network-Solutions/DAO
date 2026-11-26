<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-stickers-title">
  {if $sub_view == "edit" || $sub_view == "add"}
    <div class="admin-form-layout mx-auto w-full admin-form-layout-wide flex max-w-[64rem] flex-col gap-6">
  {/if}
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-stickers-title" class="text-2xl font-semibold">
        {if $sub_view == "edit"}
          {__("Edit Sticker")}
        {elseif $sub_view == "add"}
          {__("Add New Sticker")}
        {else}
          {__("Stickers")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "edit"}
          {__("Replace or remove this sticker image.")}
        {elseif $sub_view == "add"}
          {__("Upload a sticker to make it available in chat.")}
        {else}
          {__("Manage the stickers available in chat.")}
        {/if}
      </p>
    </div>

    {if $sub_view == ""}
      <a href="{$system['system_url']}/{$control_panel['url']}/stickers/add" class="btn btn-primary">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Add New Sticker")}
      </a>
    {else}
      <a href="{$system['system_url']}/{$control_panel['url']}/stickers" class="btn btn-outline">
        <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        {__("Go Back")}
      </a>
    {/if}
  </header>

  {if $sub_view == ""}
    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Stickers")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table js_dataTable admin-list-table min-w-0!">
            <thead>
              <tr>
                <th>{__("Sticker")}</th>
                <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <div class="admin-list-identity flex min-w-0 items-center gap-3">
                      <img class="admin-list-avatar size-12 shrink-0 rounded-md border border-base-300 object-contain p-1" src="{$system['system_uploads']}/{$row['image']}" alt="" width="48" height="48" loading="lazy">
                      <div class="admin-list-identity-text grid min-w-0 gap-0.5">
                        <span class="admin-list-id text-xs">#{number_format($row['sticker_id'])}</span>
                      </div>
                    </div>
                  </td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="sticker-actions-{$row['sticker_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {__("Sticker")} #{number_format($row['sticker_id'])}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="sticker-actions-{$row['sticker_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/stickers/edit/{$row['sticker_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="sticker" data-id="{$row['sticker_id']}">
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
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-stickers-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--hand-love-you] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-stickers-empty-title">{__("No stickers yet")}</h2>
        <p>{__("Add your first sticker to make it available in chat.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/stickers/add" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Sticker")}
        </a>
      </section>
    {/if}

  {elseif $sub_view == "edit" || $sub_view == "add"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/stickers.php?do={if $sub_view == "edit"}edit&amp;id={$data['sticker_id']}{else}add{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="sticker-image-title">
          <h2 id="sticker-image-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Sticker Image")}</h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="sticker-image-label">
            <div class="label-text" id="sticker-image-label">{__("Image")}</div>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if $sub_view == "edit" && $data['image'] != ''}
                {include file='__x_image.tpl' _x_name="image" _x_value=$data['image'] _x_fit="contain"}
              {else}
                {include file='__x_image.tpl' _x_name="image" _x_fit="contain"}
              {/if}
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
