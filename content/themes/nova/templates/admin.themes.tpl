{if $sub_view == ""}
<section class="admin-settings-page admin-themes-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-themes-title">
  <header class="admin-themes-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-themes-title" class="text-2xl font-semibold">{__("Themes")}</h1>
      <p class="text-base-content/60 text-sm">{__("Manage the themes available across your website.")}</p>
    </div>
    <a href="{$system['system_url']}/{$control_panel['url']}/themes/add" class="btn btn-primary">
      <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
      {__("Add New Theme")}
    </a>
  </header>
    {if $rows}
      <section class="admin-themes-grid" aria-label="{__("Themes")}">
        {foreach $rows as $row}
          <article class="admin-theme-card card border border-base-300 bg-base-100{if $row['default']} is-default{/if}">
            <div class="admin-theme-card-visual">
              <div class="admin-theme-card-hero">
                {if $row['thumbnail_exists']}
                  <img class="admin-theme-card-media" src="{$system['system_url']}/content/themes/{$row['name']}/thumbnail.png" alt="{$row['title']|default:$row['name']} {__("theme preview")}" loading="lazy">
                {else}
                  <div class="admin-theme-card-media admin-theme-card-media-fallback" role="img" aria-label="{__("Preview unavailable")}">
                    <span class="icon-[tabler--photo-off] size-8" aria-hidden="true"></span>
                  </div>
                {/if}
              </div>
              <div class="admin-theme-card-shade" aria-hidden="true"></div>

              <div class="admin-theme-card-overlay">
                <div class="admin-theme-card-id">
                  <span class="admin-theme-card-id-bar{if $row['default']} is-default{elseif $row['enabled']} is-selectable{/if}" aria-hidden="true"></span>
                  <span>#{number_format($row['theme_id'])}</span>
                </div>
                <h2 class="admin-theme-card-title" title="{$row['title']|default:$row['name']}">{$row['title']|default:$row['name']}</h2>
                <div class="admin-theme-card-chips">
                  <span class="admin-theme-card-chip{if $row['default']} is-on{/if}">{__("Default")}</span>
                  <span class="admin-theme-card-chip{if $row['enabled']} is-on{/if}">{__("Selectable")}</span>
                </div>
              </div>
            </div>

            <div class="admin-theme-card-body">
              <div class="admin-theme-card-actions">
                <a class="btn btn-outline btn-sm admin-theme-card-action" href="{$system['system_url']}/{$control_panel['url']}/themes/edit/{$row['theme_id']}" aria-label="{__("Edit & Customize")} {$row['title']|default:$row['name']}">
                  <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                  {__("Edit & Customize")}
                </a>
                {if $row['default']}
                  <button type="button" class="btn btn-outline btn-sm admin-theme-card-action admin-theme-card-action-delete" disabled aria-label="{__("The default theme cannot be deleted")}" title="{__("The default theme cannot be deleted")}">
                    <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                    {__("Delete")}
                  </button>
                {else}
                  <button type="button" class="btn btn-outline btn-sm admin-theme-card-action admin-theme-card-action-delete js_admin-deleter" data-handle="theme" data-id="{$row['theme_id']}" aria-label="{__("Delete")} {$row['title']|default:$row['name']}">
                    <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                    {__("Delete")}
                  </button>
                {/if}
              </div>
            </div>
          </article>
        {/foreach}
      </section>
    {else}
      <section class="card admin-themes-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-themes-empty-title">
        <div class="admin-themes-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--layout-grid-add] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-themes-empty-title">{__("No themes yet")}</h2>
        <p>{__("Add your first theme to make it available to your website.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/themes/add" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Theme")}
        </a>
      </section>
    {/if}
</section>

{else}
  {if $sub_view == "edit"}
    {assign var="theme_folder" value=$data['name']}
  {else}
    {assign var="theme_folder" value=$system['theme']}
  {/if}
  <form class="js_ajax-forms admin-settings-page admin-themes-page" data-url="admin/themes.php?do={if $sub_view == "edit"}edit&amp;id={$data['theme_id']}{else}add{/if}" aria-labelledby="admin-themes-title">
    <div class="admin-settings-heading grid gap-1.5">
      <div class="admin-themes-heading flex items-start justify-between gap-4">
        <div class="grid gap-1.5">
          <h1 id="admin-themes-title" class="text-2xl font-semibold">{if $sub_view == "edit"}{__("Edit Theme")}{else}{__("Add New Theme")}{/if}</h1>
          <p class="text-base-content/60 text-sm">{if $sub_view == "edit"}{__("Update this theme's identity, appearance, landing page, and custom CSS.")}{else}{__("Register a theme folder and set its appearance, landing page, and custom CSS.")}{/if}</p>
        </div>
        <a href="{$system['system_url']}/{$control_panel['url']}/themes" class="btn btn-outline">
          <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
          {__("Go Back")}
        </a>
      </div>
    </div>
    <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Theme Settings")}" aria-orientation="vertical">
      <button type="button" id="theme-tab-general" class="tab active-tab:tab-active active" data-tab="#theme-general" aria-controls="theme-general" role="tab" aria-selected="true"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("General")}</button>
      <button type="button" id="theme-tab-appearance" class="tab active-tab:tab-active" data-tab="#theme-appearance" aria-controls="theme-appearance" role="tab" aria-selected="false"><span class="icon-[tabler--layout] size-4" aria-hidden="true"></span>{__("Appearance")}</button>
      <button type="button" id="theme-tab-landing" class="tab active-tab:tab-active" data-tab="#theme-landing" aria-controls="theme-landing" role="tab" aria-selected="false"><span class="icon-[tabler--home] size-4" aria-hidden="true"></span>{__("Landing")}</button>
      <button type="button" id="theme-tab-colors" class="tab active-tab:tab-active" data-tab="#theme-customization" aria-controls="theme-customization" role="tab" aria-selected="false"><span class="icon-[tabler--palette] size-4" aria-hidden="true"></span>{__("Customization")}</button>
      <button type="button" id="theme-tab-css" class="tab active-tab:tab-active" data-tab="#theme-css" aria-controls="theme-css" role="tab" aria-selected="false"><span class="icon-[tabler--code] size-4" aria-hidden="true"></span>{__("Custom CSS")}</button>
    </nav>

    <div id="theme-general" class="admin-settings-panel js_admin-settings-panel" role="tabpanel" aria-labelledby="theme-tab-general" tabindex="0">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="theme-status-title">
              <h2 id="theme-status-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Theme Status")}</h2>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  <span class="icon-[tabler--star] size-6" aria-hidden="true"></span>
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="default">{__("Default")}</label>
                  <div id="default-help" class="admin-setting-help text-sm leading-relaxed">{__("Make it the default theme of the site")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="default" id="default" {if $sub_view == "edit" && $data['default']}checked{/if} aria-describedby="default-help">
                </div>
              </div>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  <span class="icon-[tabler--users] size-6" aria-hidden="true"></span>
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="enabled">{__("Selectable")}</label>
                  <div id="enabled-help" class="admin-setting-help text-sm leading-relaxed">
                    {__("Make it the selectable so users can change the theme")}. {__("(You must have 2+ selectable themes)")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="enabled" id="enabled" {if $sub_view == "edit" && $data['enabled']}checked{/if} aria-describedby="enabled-help">
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="theme-identity-title">
              <h2 id="theme-identity-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Theme Identity")}</h2>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="theme-title">{__("Title")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="title" id="theme-title" value="{if $sub_view == "edit"}{$data['title']}{/if}" aria-describedby="theme-title-help" autocomplete="off">
                  <div id="theme-title-help" class="admin-setting-help text-sm leading-relaxed">{__("The display name shown to users in the theme switcher")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="theme-name">{__("Path")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="flex min-w-0 flex-row items-stretch gap-2">
                    <div class="join min-w-0 flex-1" dir="ltr">
                      <span class="join-item flex max-w-64 min-w-10 shrink-0 items-center justify-center border border-e-0 border-base-300 bg-base-200 px-3 text-sm text-base-content/60 [[data-theme=admin-dark]_&]:border-base-content/30">
                        <span class="truncate whitespace-nowrap" title="content/themes/">content/themes/</span>
                      </span>
                      <input type="text" class="input join-item min-w-0 flex-1" name="name" id="theme-name" value="{if $sub_view == "edit"}{$data['name']}{/if}" aria-describedby="theme-name-help" autocomplete="off">
                    </div>
                    <button type="button" class="btn btn-outline shrink-0 js_check-theme-path">
                      <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
                      {__("Check")}
                    </button>
                  </div>
                  <div id="theme-name-help" class="admin-setting-help text-sm leading-relaxed">
                    {__("Theme path should not contain spaces or special characters")}. {__("(Valid name examples: mytheme, material, custom_theme)")}
                  </div>
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="theme-landing-active-title">
              <h2 id="theme-landing-active-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Active Landing")}</h2>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <div class="admin-setting-control flex min-w-0 flex-col gap-3">
                  <div class="js_theme-landing-options grid grid-cols-1 gap-6 sm:grid-cols-2 xl:grid-cols-3" role="radiogroup" aria-labelledby="theme-landing-active-title">
                    {foreach $data['landings'] as $landing_index => $theme_landing}
                      {include file='__admin_theme_landing_option.tpl' theme_landing=$theme_landing landing_index=$landing_index active_landing=$data['landing']}
                    {/foreach}
                  </div>
                  <div class="admin-setting-help text-sm leading-relaxed">{__("The landing page visitors see when they are signed out. Add, rename or remove landings from the Landing tab, then save to pick a new one here.")}</div>
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
        </div>
      </div>
    </div>

    <div id="theme-appearance" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="theme-tab-appearance" tabindex="0">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="theme-appearance-title">
              <h2 id="theme-appearance-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Appearance")}</h2>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="fluid" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="fluid_design">{__("Fluid Design")}</label>
                  <div id="fluid_design-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the full width containers On and Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="fluid_design" id="fluid_design" {if $sub_view == "edit" && $data['fluid_design']}checked{/if} aria-describedby="fluid_design-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="dark_light" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="system_theme_night_on">{__("Night Mode is Default")}</label>
                  <div id="system_theme_night_on-help" class="admin-setting-help text-sm leading-relaxed">{__("Make the night mode is the default mode of your website")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="system_theme_night_on" id="system_theme_night_on" {if $sub_view == "edit" && $data['system_theme_night_on']}checked{/if} aria-describedby="system_theme_night_on-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="settings" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="system_theme_mode_select">{__("Users Can Change Mode")}</label>
                  <div id="system_theme_mode_select-help" class="admin-setting-help text-sm leading-relaxed">{__("Allow users to select between day and night mode")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="system_theme_mode_select" id="system_theme_mode_select" {if $sub_view == "add" || ($sub_view == "edit" && $data['system_theme_mode_select'])}checked{/if} aria-describedby="system_theme_mode_select-help">
                </div>
              </div>
              <div class="divider"></div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="system_theme_icons-label">
                <div class="label-text" id="system_theme_icons-label">{__("Theme Icons")}</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="system_theme_icons" id="system_theme_icons_tabler" value="tabler" class="radio radio-primary" {if $sub_view == "add" || $data['system_theme_icons'] != "svg"}checked{/if} aria-describedby="system_theme_icons-help">
                    <label class="label-text" for="system_theme_icons_tabler">{__("Tabler Icons")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="system_theme_icons" id="system_theme_icons_svg" value="svg" class="radio radio-primary" {if $sub_view == "edit" && $data['system_theme_icons'] == "svg"}checked{/if} aria-describedby="system_theme_icons-help">
                    <label class="label-text" for="system_theme_icons_svg">{__("Custom SVG Icons")}</label>
                  </div>
                  <div id="system_theme_icons-help" class="admin-setting-help text-sm leading-relaxed">
                    {__("Custom icons are loaded from")} content/themes/{$theme_folder}/images/svg/ {__("as .svg")}. {__("Missing files fall back to Tabler icons")}
                  </div>
                </div>
              </div>
              <div class="divider"></div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="system_theme_fonts-label">
                <div class="label-text" id="system_theme_fonts-label">{__("Theme Fonts")}</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="system_theme_fonts" id="system_theme_fonts_local" value="local" class="radio radio-primary" {if $sub_view == "edit" && $data['system_theme_fonts'] == "local"}checked{/if} aria-describedby="system_theme_fonts-help">
                    <label class="label-text" for="system_theme_fonts_local">{__("Local Files")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="system_theme_fonts" id="system_theme_fonts_google" value="google" class="radio radio-primary" {if $sub_view == "add" || $data['system_theme_fonts'] != "local"}checked{/if} aria-describedby="system_theme_fonts-help">
                    <label class="label-text" for="system_theme_fonts_google">{__("Google Fonts CDN")}</label>
                  </div>
                  <div id="system_theme_fonts-help" class="admin-setting-help text-sm leading-relaxed">
                    {__("Local fonts are loaded from")} content/themes/{$theme_folder}/fonts/. {__("No requests are sent to Google")}
                  </div>
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="theme-wallpaper-title">
              <h2 id="theme-wallpaper-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Wallpaper")}</h2>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="home" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="system_wallpaper_default">{__("Default Wallpaper")}</label>
                  <div id="system_wallpaper_default-help" class="admin-setting-help text-sm leading-relaxed">
                    {__("Use the default")} (<a target="_blank" href="{$system['system_url']}/{$data['wallpaper_preview']}">{__("preview")}</a>) ({__("Disable it to use your custom uploaded image")})
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="system_wallpaper_default" id="system_wallpaper_default" {if $sub_view == "add" || ($sub_view == "edit" && $data['system_wallpaper_default'])}checked{/if} aria-describedby="system_wallpaper_default-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="system_wallpaper-label">
                <div class="label-text" id="system_wallpaper-label">{__("Custom Wallpaper")}</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if $sub_view == "add" || $data['system_wallpaper'] == ''}
                    {include file='__x_image.tpl' _x_name="system_wallpaper" _x_fit="contain"}
                  {else}
                    {include file='__x_image.tpl' _x_name="system_wallpaper" _x_value=$data['system_wallpaper'] _x_fit="contain"}
                  {/if}
                </div>
              </div>
            </div>

            {$_bottom_bar = $data['bottom_bar']|default:''|bottom_bar_items:true}
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="theme-bottom-bar-title">
              <h2 id="theme-bottom-bar-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Mobile Bottom Bar")}</h2>
              <div class="admin-setting-help text-sm leading-relaxed">
                {__("Drag items to choose what appears in the mobile bottom bar and in which order")} ({__("Up to 5 items, disabled features are skipped")})
              </div>
              <div class="grid gap-4 md:grid-cols-2">
                <div class="admin-setting-field flex min-w-0 flex-col gap-2">
                  <div class="label-text">{__("Shown")}</div>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <ul class="js_bottom-bar-list js_bottom-bar-shown flex min-h-14 flex-col gap-2 rounded-box border border-dashed border-base-300 p-2 [&>.sortable-ghost]:border-dashed [&>.sortable-ghost]:border-primary [&>.sortable-ghost]:bg-primary/10">
                      {foreach $_bottom_bar['shown'] as $_key => $_item}
                        <li class="flex cursor-grab items-center gap-3 rounded-field border border-base-300 bg-base-100 px-3 py-2 text-sm" data-key="{$_key}">
                          <span class="icon-[tabler--grip-vertical] size-4 shrink-0 text-base-content/40" aria-hidden="true"></span>
                          <span class="{$_item['icon']} size-5 shrink-0 text-base-content/70" aria-hidden="true"></span>
                          <span class="min-w-0 flex-1 truncate" title="{$_item['label']}">{$_item['label']}</span>
                          {if $_key == 'menu'}
                            <span class="badge badge-soft badge-primary badge-sm">{__("Required")}</span>
                          {elseif !$_item['enabled']}
                            <span class="badge badge-soft badge-sm">{__("Disabled")}</span>
                          {/if}
                          <input type="hidden" name="bottom_bar[]" value="{$_key}">
                        </li>
                      {/foreach}
                    </ul>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2">
                  <div class="label-text">{__("Hidden")}</div>
                  <fieldset class="admin-setting-control flex min-w-0 flex-col gap-2" disabled>
                    <ul class="js_bottom-bar-list max-h-80 overflow-y-auto flex min-h-14 flex-col gap-2 rounded-box border border-dashed border-base-300 p-2 [&>.sortable-ghost]:border-dashed [&>.sortable-ghost]:border-primary [&>.sortable-ghost]:bg-primary/10">
                      {foreach $_bottom_bar['hidden'] as $_key => $_item}
                        <li class="flex cursor-grab items-center gap-3 rounded-field border border-base-300 bg-base-100 px-3 py-2 text-sm" data-key="{$_key}">
                          <span class="icon-[tabler--grip-vertical] size-4 shrink-0 text-base-content/40" aria-hidden="true"></span>
                          <span class="{$_item['icon']} size-5 shrink-0 text-base-content/70" aria-hidden="true"></span>
                          <span class="min-w-0 flex-1 truncate" title="{$_item['label']}">{$_item['label']}</span>
                          {if $_key == 'menu'}
                            <span class="badge badge-soft badge-primary badge-sm">{__("Required")}</span>
                          {elseif !$_item['enabled']}
                            <span class="badge badge-soft badge-sm">{__("Disabled")}</span>
                          {/if}
                          <input type="hidden" name="bottom_bar[]" value="{$_key}">
                        </li>
                      {/foreach}
                    </ul>
                  </fieldset>
                </div>
              </div>
            </div>

            {$_sidebar = $data['sidebar']|default:''|sidebar_items:$data['sidebar_more']:true}
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="theme-sidebar-title">
              <h2 id="theme-sidebar-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Left Panel Menu")}</h2>
              <div class="admin-setting-help text-sm leading-relaxed">
                {__("Drag items to choose what appears in the left panel and in which order")} ({__("Disabled features are skipped")})
              </div>
              <div class="grid gap-4 md:grid-cols-3">
                <div class="admin-setting-field flex min-w-0 flex-col gap-2">
                  <div class="label-text">{__("Shown")}</div>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="flex items-center gap-3 rounded-field border border-base-300 bg-base-200 px-3 py-2 text-sm">
                      <span class="icon-[tabler--lock] size-4 shrink-0 text-base-content/40" aria-hidden="true"></span>
                      <span class="icon-[tabler--home] size-5 shrink-0 text-base-content/70" aria-hidden="true"></span>
                      <span class="min-w-0 flex-1 truncate" title="{__("News Feed")}">{__("News Feed")}</span>
                      <span class="badge badge-soft badge-primary badge-sm">{__("Required")}</span>
                    </div>
                    <ul class="js_sidebar-list flex min-h-14 flex-col gap-2 rounded-box border border-dashed border-base-300 p-2 [&>.sortable-ghost]:border-dashed [&>.sortable-ghost]:border-primary [&>.sortable-ghost]:bg-primary/10" data-name="sidebar[]">
                      {foreach $_sidebar['main'] as $_key => $_item}
                        <li class="flex cursor-grab items-center gap-3 rounded-field border border-base-300 bg-base-100 px-3 py-2 text-sm" data-key="{$_key}">
                          <span class="icon-[tabler--grip-vertical] size-4 shrink-0 text-base-content/40" aria-hidden="true"></span>
                          <span class="{$_item['icon']} size-5 shrink-0 text-base-content/70" aria-hidden="true"></span>
                          <span class="min-w-0 flex-1 truncate" title="{$_item['label']}">{$_item['label']}</span>
                          {if !$_item['enabled']}
                            <span class="badge badge-soft badge-sm">{__("Disabled")}</span>
                          {/if}
                          <input type="hidden" name="sidebar[]" value="{$_key}">
                        </li>
                      {/foreach}
                    </ul>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2">
                  <div class="label-text">{__("See More")}</div>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <ul class="js_sidebar-list flex min-h-14 flex-col gap-2 rounded-box border border-dashed border-base-300 p-2 [&>.sortable-ghost]:border-dashed [&>.sortable-ghost]:border-primary [&>.sortable-ghost]:bg-primary/10" data-name="sidebar_more[]">
                      {foreach $_sidebar['more'] as $_key => $_item}
                        <li class="flex cursor-grab items-center gap-3 rounded-field border border-base-300 bg-base-100 px-3 py-2 text-sm" data-key="{$_key}">
                          <span class="icon-[tabler--grip-vertical] size-4 shrink-0 text-base-content/40" aria-hidden="true"></span>
                          <span class="{$_item['icon']} size-5 shrink-0 text-base-content/70" aria-hidden="true"></span>
                          <span class="min-w-0 flex-1 truncate" title="{$_item['label']}">{$_item['label']}</span>
                          {if !$_item['enabled']}
                            <span class="badge badge-soft badge-sm">{__("Disabled")}</span>
                          {/if}
                          <input type="hidden" name="sidebar_more[]" value="{$_key}">
                        </li>
                      {/foreach}
                    </ul>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2">
                  <div class="label-text">{__("Hidden")}</div>
                  <fieldset class="admin-setting-control flex min-w-0 flex-col gap-2" disabled>
                    <ul class="js_sidebar-list max-h-80 overflow-y-auto flex min-h-14 flex-col gap-2 rounded-box border border-dashed border-base-300 p-2 [&>.sortable-ghost]:border-dashed [&>.sortable-ghost]:border-primary [&>.sortable-ghost]:bg-primary/10" data-name="sidebar[]">
                      {foreach $_sidebar['hidden'] as $_key => $_item}
                        <li class="flex cursor-grab items-center gap-3 rounded-field border border-base-300 bg-base-100 px-3 py-2 text-sm" data-key="{$_key}">
                          <span class="icon-[tabler--grip-vertical] size-4 shrink-0 text-base-content/40" aria-hidden="true"></span>
                          <span class="{$_item['icon']} size-5 shrink-0 text-base-content/70" aria-hidden="true"></span>
                          <span class="min-w-0 flex-1 truncate" title="{$_item['label']}">{$_item['label']}</span>
                          {if !$_item['enabled']}
                            <span class="badge badge-soft badge-sm">{__("Disabled")}</span>
                          {/if}
                          <input type="hidden" name="sidebar[]" value="{$_key}">
                        </li>
                      {/foreach}
                    </ul>
                  </fieldset>
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
        </div>
      </div>
    </div>

    <div id="theme-landing" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="theme-tab-landing" tabindex="0">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="theme-landing-title">
              <h2 id="theme-landing-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Landing")}</h2>
              <p class="admin-setting-help text-sm leading-relaxed">{__("Choose the active landing visitors see. Nova's landing designs are listed below. Extra slugs use index.landing.{ldelim}slug{rdelim}.tpl and fall back to Default if that file is missing.")}</p>
              <div class="js_theme-landings flex flex-col gap-3">
                {foreach $data['landings'] as $landing_index => $theme_landing}
                  {include file='__admin_theme_landing.tpl' theme_landing=$theme_landing landing_index=$landing_index active_landing=$data['landing']}
                {/foreach}
              </div>
              <div class="admin-setting-help text-sm leading-relaxed">
                {__("Landing slug should not contain spaces or special characters")}.
                {__("Thumbnails are loaded from")} <span class="font-medium [overflow-wrap:anywhere]">content/themes/{if $sub_view == "edit"}{$data['name']}{else}{__("theme")}{/if}/images/landing/{__("slug")}/</span>
                {__("as")} <span class="font-medium">thumbnail.webp</span> {__("and")} <span class="font-medium">thumbnail-dark.webp</span>.
              </div>
              <div>
                <button type="button" class="btn btn-outline js_add-theme-landing">
                  <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
                  {__("Add Landing")}
                </button>
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
        </div>
      </div>
      <script type="text/template" id="theme-landing-row-template">
        <article class="js_theme-landing-row flex flex-col gap-4 rounded-[14px] border border-base-300 p-3 lg:flex-row lg:items-center" data-landing-index="__INDEX__">
          <input type="hidden" name="landings[__INDEX__][id]" value="">
          <input type="hidden" name="landings[__INDEX__][is_default]" value="0">
          <div class="flex aspect-[16/10] w-full shrink-0 items-center justify-center overflow-hidden rounded-lg border border-base-300 bg-base-200 text-base-content/40 sm:w-40 lg:w-32">
            <span class="icon-[tabler--photo-off] size-6" aria-hidden="true"></span>
          </div>
          <div class="grid min-w-0 flex-1 grid-cols-1 items-start gap-4 sm:grid-cols-2">
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="theme-landing-title-__INDEX__">{__("Title")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="landings[__INDEX__][title]" id="theme-landing-title-__INDEX__" value="" autocomplete="off">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="theme-landing-slug-__INDEX__">{__("Slug")}</label>
              <div class="admin-setting-control join w-full min-w-0" dir="ltr">
                <span class="join-item hidden sm:flex min-w-10 shrink-0 items-center justify-center border border-e-0 border-base-300 bg-base-200 px-3 text-sm text-base-content/60 [[data-theme=admin-dark]_&]:border-base-content/30">index.landing.</span>
                <input type="text" class="input join-item min-w-0 flex-1 js_theme-landing-slug" name="landings[__INDEX__][slug]" id="theme-landing-slug-__INDEX__" value="" autocomplete="off">
              </div>
            </div>
          </div>
          <div class="flex shrink-0 items-center justify-end gap-2 lg:w-28">
            <span class="js_theme-landing-badge badge badge-soft badge-success hidden">
              <span class="icon-[tabler--circle-check-filled] size-4" aria-hidden="true"></span>
              {__("Active")}
            </span>
            <button type="button" class="btn btn-text btn-square btn-sm js_remove-theme-landing" aria-label="{__("Delete")}" title="{__("Delete")}">
              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
            </button>
          </div>
        </article>
      </script>
    </div>

    <div id="theme-customization" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="theme-tab-colors" tabindex="0">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="theme-colors-toggle">
              <h2 id="theme-colors-toggle" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Customization")}</h2>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="themes_switcher" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="css_customized">{__("Enable Customization")}</label>
                  <div id="css_customized-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the customization On and Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="css_customized" id="css_customized" {if $sub_view == "edit" && $data['css_customized']}checked{/if} aria-describedby="css_customized-help">
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="theme-colors-theme">
              <h2 id="theme-colors-theme" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Theme Colors")}</h2>
              <div class="admin-settings-fields-grid grid grid-cols-1 items-start gap-5 xl:grid-cols-2">
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="css_background">{__("Background Color")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-colorpicker js_colorpicker">
                      <input type="text" class="input w-full" name="css_background" id="css_background" value="{if $sub_view == "edit"}{$data['css_background']}{/if}">
                      <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['css_background']}{/if}" aria-label="{__("Background Color")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="css_link_color">{__("Link Color")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-colorpicker js_colorpicker">
                      <input type="text" class="input w-full" name="css_link_color" id="css_link_color" value="{if $sub_view == "edit"}{$data['css_link_color']}{/if}">
                      <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['css_link_color']}{/if}" aria-label="{__("Link Color")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="css_header">{__("Header Color")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-colorpicker js_colorpicker">
                      <input type="text" class="input w-full" name="css_header" id="css_header" value="{if $sub_view == "edit"}{$data['css_header']}{/if}">
                      <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['css_header']}{/if}" aria-label="{__("Header Color")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="css_header_search">{__("Header Search Background")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-colorpicker js_colorpicker">
                      <input type="text" class="input w-full" name="css_header_search" id="css_header_search" value="{if $sub_view == "edit"}{$data['css_header_search']}{/if}">
                      <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['css_header_search']}{/if}" aria-label="{__("Header Search Background")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="css_header_search_color">{__("Header Search Font")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-colorpicker js_colorpicker">
                      <input type="text" class="input w-full" name="css_header_search_color" id="css_header_search_color" value="{if $sub_view == "edit"}{$data['css_header_search_color']}{/if}">
                      <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['css_header_search_color']}{/if}" aria-label="{__("Header Search Font")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="css_btn_primary">{__("Button Primary")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-colorpicker js_colorpicker">
                      <input type="text" class="input w-full" name="css_btn_primary" id="css_btn_primary" value="{if $sub_view == "edit"}{$data['css_btn_primary']}{/if}">
                      <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['css_btn_primary']}{/if}" aria-label="{__("Button Primary")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="css_header_icons">{__("Header Icons")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-colorpicker js_colorpicker">
                      <input type="text" class="input w-full" name="css_header_icons" id="css_header_icons" value="{if $sub_view == "edit"}{$data['css_header_icons']}{/if}">
                      <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['css_header_icons']}{/if}" aria-label="{__("Header Icons")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="css_header_icons_night">{__("Header Icons (Night Mode)")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-colorpicker js_colorpicker">
                      <input type="text" class="input w-full" name="css_header_icons_night" id="css_header_icons_night" value="{if $sub_view == "edit"}{$data['css_header_icons_night']}{/if}">
                      <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['css_header_icons_night']}{/if}" aria-label="{__("Header Icons (Night Mode)")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="css_main_icons">{__("Main Icons")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-colorpicker js_colorpicker">
                      <input type="text" class="input w-full" name="css_main_icons" id="css_main_icons" value="{if $sub_view == "edit"}{$data['css_main_icons']}{/if}">
                      <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['css_main_icons']}{/if}" aria-label="{__("Main Icons")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="css_main_icons_night">{__("Main Icons (Night Mode)")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-colorpicker js_colorpicker">
                      <input type="text" class="input w-full" name="css_main_icons_night" id="css_main_icons_night" value="{if $sub_view == "edit"}{$data['css_main_icons_night']}{/if}">
                      <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['css_main_icons_night']}{/if}" aria-label="{__("Main Icons (Night Mode)")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="css_action_icons">{__("Action Icons")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-colorpicker js_colorpicker">
                      <input type="text" class="input w-full" name="css_action_icons" id="css_action_icons" value="{if $sub_view == "edit"}{$data['css_action_icons']}{/if}">
                      <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['css_action_icons']}{/if}" aria-label="{__("Action Icons")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="css_action_icons_night">{__("Action Icons (Night Mode)")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-colorpicker js_colorpicker">
                      <input type="text" class="input w-full" name="css_action_icons_night" id="css_action_icons_night" value="{if $sub_view == "edit"}{$data['css_action_icons_night']}{/if}">
                      <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit"}{$data['css_action_icons_night']}{/if}" aria-label="{__("Action Icons (Night Mode)")}">
                    </div>
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
        </div>
      </div>
    </div>

    <div id="theme-css" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="theme-tab-css" tabindex="0">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="theme-code-css">
              <h2 id="theme-code-css" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Custom CSS")}</h2>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="custom-css">{__("Custom CSS")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <textarea class="textarea w-full" rows="10" name="css_custome_css" id="custom-css" aria-describedby="custom-css-help">{if $sub_view == "edit"}{$data['css_custome_css']}{/if}</textarea>
                  <div class="admin-setting-help text-sm leading-relaxed" id="custom-css-help">{__("Header Custom CSS")}</div>
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
        </div>
      </div>
    </div>
  </form>
{/if}
