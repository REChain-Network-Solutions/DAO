<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-colored-posts-title">
  {if $sub_view == "edit" || $sub_view == "add"}
    <div class="admin-form-layout mx-auto w-full admin-form-layout-wide flex max-w-[64rem] flex-col gap-6">
  {/if}
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-colored-posts-title" class="text-2xl font-semibold">
        {if $sub_view == "edit"}
          {__("Edit Pattern")}
        {elseif $sub_view == "add"}
          {__("Add New Pattern")}
        {else}
          {__("Colored Posts")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "edit"}
          {__("Update the background and text colors of this pattern.")}
        {elseif $sub_view == "add"}
          {__("Create a new colored posts pattern.")}
        {else}
          {__("Manage the colored backgrounds users can pick for their posts.")}
        {/if}
      </p>
    </div>

    {if $sub_view == ""}
      <a href="{$system['system_url']}/{$control_panel['url']}/colored_posts/add" class="btn btn-primary">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Add New Pattern")}
      </a>
    {else}
      <a href="{$system['system_url']}/{$control_panel['url']}/colored_posts" class="btn btn-outline">
        <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        {__("Go Back")}
      </a>
    {/if}
  </header>

  {if $sub_view == ""}
    {if $rows}
      <section class="grid grid-cols-1 gap-3 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 2xl:grid-cols-6" aria-label="{__("Colored Posts")}">
        {foreach $rows as $row}
          <article class="card min-w-0 border border-base-300 bg-base-100 p-2 shadow-none">
            <div class="flex aspect-[4/3] items-center justify-center overflow-hidden rounded-[10px] bg-base-200 bg-cover bg-center p-3 text-center" {if $row['type'] == "color"}style="background-image: linear-gradient(45deg, {$row['background_color_1']}, {$row['background_color_2']});"{else}style="background-image: url({$system['system_uploads']}/{$row['background_image']})"{/if}>
              <span class="text-sm font-semibold" style="color: {$row['text_color']};">{__("Hello World")}</span>
            </div>
            <div class="flex min-w-0 items-center justify-between gap-1 ps-1 pt-2">
              <div class="flex min-w-0 items-center gap-2">
                <span class="badge badge-soft badge-sm min-w-0 gap-1 rounded-full" title="{if $row['type'] == "color"}{__("Background Color")}{else}{__("Background Image")}{/if}">
                  <span class="{if $row['type'] == "color"}icon-[tabler--color-swatch]{else}icon-[tabler--photo]{/if} size-3.5 shrink-0" aria-hidden="true"></span>
                  <span class="truncate">{if $row['type'] == "color"}{__("Background Color")}{else}{__("Background Image")}{/if}</span>
                </span>
                <span class="text-base-content/50 shrink-0 text-xs">#{number_format($row['pattern_id'])}</span>
              </div>
              <div class="dropdown relative inline-flex [--placement:bottom-end]">
                <button id="pattern-actions-{$row['pattern_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {__("Pattern")} #{number_format($row['pattern_id'])}">
                  <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                </button>
                <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="pattern-actions-{$row['pattern_id']}">
                  <li>
                    <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/colored_posts/edit/{$row['pattern_id']}">
                      <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                      {__("Edit")}
                    </a>
                  </li>
                  <li>
                    <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="pattern" data-id="{$row['pattern_id']}">
                      <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                      {__("Delete")}
                    </button>
                  </li>
                </ul>
              </div>
            </div>
          </article>
        {/foreach}
      </section>
    {else}
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-colored-posts-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--palette] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-colored-posts-empty-title">{__("No patterns yet")}</h2>
        <p>{__("Add your first pattern to let users color their posts.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/colored_posts/add" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Pattern")}
        </a>
      </section>
    {/if}

  {elseif $sub_view == "edit" || $sub_view == "add"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/colored_posts.php?do={if $sub_view == "edit"}edit&amp;id={$data['pattern_id']}{else}add{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="pattern-details-title">
          <h2 id="pattern-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Pattern Details")}</h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="pattern-type-label">
            <div class="label-text" id="pattern-type-label">{__("Pattern Type")}</div>
            <div class="admin-setting-control flex min-w-0 flex-wrap items-center gap-4">
              <label class="inline-flex items-center gap-2" for="pattern_type_color">
                <input type="radio" name="type" id="pattern_type_color" value="color" class="radio radio-primary js_pattern-type" {if $sub_view == "add"}checked{/if}{if $sub_view == "edit" && $data['type'] == "color"}checked{/if}>
                <span class="label-text">{__("Background Color")}</span>
              </label>
              <label class="inline-flex items-center gap-2" for="pattern_type_image">
                <input type="radio" name="type" id="pattern_type_image" value="image" class="radio radio-primary js_pattern-type" {if $sub_view == "edit" && $data['type'] == "image"}checked{/if}>
                <span class="label-text">{__("Background Image")}</span>
              </label>
            </div>
          </div>

          <div id="js_pattern-type-color" {if $sub_view == "edit" && $data['type'] == "image"}class="hidden"{/if}>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="pattern-background-color-1">{__("Background Color 1")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <div class="admin-settings-colorpicker js_colorpicker">
                  <input type="text" class="input w-full js_pattern-background-color-1" name="background_color_1" id="pattern-background-color-1" value="{if $sub_view == "edit"}{$data['background_color_1']}{else}#FF00FF{/if}">
                  <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['background_color_1']}{else}#FF00FF{/if}" aria-label="{__("Background Color 1")}">
                </div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="pattern-background-color-2">{__("Background Color 2")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <div class="admin-settings-colorpicker js_colorpicker">
                  <input type="text" class="input w-full js_pattern-background-color-2" name="background_color_2" id="pattern-background-color-2" value="{if $sub_view == "edit"}{$data['background_color_2']}{else}#3A3AD7{/if}">
                  <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['background_color_2']}{else}#3A3AD7{/if}" aria-label="{__("Background Color 2")}">
                </div>
              </div>
            </div>
          </div>

          <div id="js_pattern-type-image" {if $sub_view == "add" || ($sub_view == "edit" && $data['type'] == "color")}class="hidden"{/if}>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="pattern-background-image-label">
              <div class="label-text" id="pattern-background-image-label">{__("Background Image")}</div>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if $sub_view == "edit" && $data['background_image'] != ''}
                  {include file='__x_image.tpl' _x_name="background_image" _x_value=$data['background_image'] _x_input_id="pattern-background-image" _x_fit="contain"}
                {else}
                  {include file='__x_image.tpl' _x_name="background_image" _x_input_id="pattern-background-image" _x_fit="contain"}
                {/if}
              </div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="pattern-text-color">{__("Text Color")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <div class="admin-settings-colorpicker js_colorpicker">
                <input type="text" class="input w-full js_pattern-text-color" name="text_color" id="pattern-text-color" value="{if $sub_view == "edit"}{$data['text_color']}{else}#000000{/if}">
                <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['text_color']}{else}#000000{/if}" aria-label="{__("Text Color")}">
              </div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <div class="label-text">{__("Preview")}</div>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if $sub_view == "edit" && $data['type'] == "image"}
                <div class="post-colored-preview flex min-h-72 items-center justify-center overflow-hidden rounded-[10px] bg-cover bg-center p-7 text-center js_pattern-preview" style="background-image: url({$system['system_uploads']}/{$data['background_image']})">
                  <h2 class="m-0 text-xl font-semibold leading-8" style="color: {$data['text_color']};">
                    {__("Hello World")}
                  </h2>
                </div>
              {else}
                <div class="post-colored-preview flex min-h-72 items-center justify-center overflow-hidden rounded-[10px] bg-cover bg-center p-7 text-center js_pattern-preview" style="background-image: linear-gradient(45deg, {if $sub_view == "edit"}{$data['background_color_1']}{else}#FF00FF{/if}, {if $sub_view == "edit"}{$data['background_color_2']}{else}#3A3AD7{/if});">
                  <h2 class="m-0 text-xl font-semibold leading-8" style="color: {if $sub_view == "edit"}{$data['text_color']}{else}#000000{/if};">
                    {__("Hello World")}
                  </h2>
                </div>
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
