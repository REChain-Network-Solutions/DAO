<section class="admin-settings-page" aria-labelledby="design-settings-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="design-settings-title" class="text-2xl font-semibold">{__("Design")}</h1>
    <p class="text-base-content/60 text-sm">{__("Customize your website branding and custom code.")}</p>
  </div>
  <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Design")}" aria-orientation="vertical">
    <button type="button" id="design-tab-general" class="tab active-tab:tab-active active" data-tab="#General" aria-controls="General" role="tab" aria-selected="true"><span class="icon-[tabler--layout] size-4" aria-hidden="true"></span>{__("General")}</button>
    <button type="button" id="design-tab-landing" class="tab active-tab:tab-active" data-tab="#Landing" aria-controls="Landing" role="tab" aria-selected="false"><span class="icon-[tabler--home] size-4" aria-hidden="true"></span>{__("Landing")}</button>
    <button type="button" id="design-tab-code" class="tab active-tab:tab-active" data-tab="#CustomCode" aria-controls="CustomCode" role="tab" aria-selected="false"><span class="icon-[tabler--code] size-4" aria-hidden="true"></span>{__("Custom Code")}</button>
    <button type="button" id="design-tab-modules" class="tab active-tab:tab-active" data-tab="#ModuleNames" aria-controls="ModuleNames" role="tab" aria-selected="false"><span class="icon-[tabler--tag] size-4" aria-hidden="true"></span>{__("Module Names")}</button>
  </nav>

  <div id="General" class="admin-settings-panel js_admin-settings-panel" role="tabpanel" aria-labelledby="design-tab-general" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/design.php?edit=general">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="design-general-logos">
              <h3 id="design-general-logos" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Logos")}</h3>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="system_logo-label">
                <div class="label-text" id="system_logo-label">{__("Logo")} ({__("Light Mode")})</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if $system['system_logo'] == ''}
                    {include file='__x_image.tpl' _x_name="system_logo" _x_fit="contain"}
                  {else}
                    {include file='__x_image.tpl' _x_name="system_logo" _x_value=$system['system_logo'] _x_fit="contain"}
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="system_logo_dark-label">
                <div class="label-text" id="system_logo_dark-label">{__("Logo")} ({__("Dark Mode")})</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if $system['system_logo_dark'] == ''}
                    {include file='__x_image.tpl' _x_name="system_logo_dark" _x_fit="contain"}
                  {else}
                    {include file='__x_image.tpl' _x_name="system_logo_dark" _x_value=$system['system_logo_dark'] _x_fit="contain"}
                  {/if}
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="design-general-favicon">
              <h3 id="design-general-favicon" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Favicon")}</h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="star" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="system_favicon_default">{__("Default Favicon")}</label>
                  <div id="system_favicon_default-help" class="admin-setting-help text-sm leading-relaxed">
                    {__("Use the default")} (<a target="_blank" href="{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png">{__("preview")}</a>) ({__("Disable it to use your custom uploaded image")})
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="system_favicon_default" id="system_favicon_default" {if $system['system_favicon_default']}checked{/if} aria-describedby="system_favicon_default-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="system_favicon-label">
                <div class="label-text" id="system_favicon-label">{__("Custom Favicon")}</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if $system['system_favicon'] == ''}
                    {include file='__x_image.tpl' _x_name="system_favicon" _x_fit="contain"}
                  {else}
                    {include file='__x_image.tpl' _x_name="system_favicon" _x_value=$system['system_favicon'] _x_fit="contain"}
                  {/if}
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="design-general-og">
              <h3 id="design-general-og" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Open Graph Image")}</h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="social_share" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="system_ogimage_default">{__("Default OG-Image")}</label>
                  <div id="system_ogimage_default-help" class="admin-setting-help text-sm leading-relaxed">
                    {__("Use the default")} (<a target="_blank" href="{$system['system_url']}/content/themes/{$system['theme']}/images/og-image.jpg">{__("preview")}</a>) ({__("Disable it to use your custom uploaded image")})
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="system_ogimage_default" id="system_ogimage_default" {if $system['system_ogimage_default']}checked{/if} aria-describedby="system_ogimage_default-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="system_ogimage-label">
                <div class="label-text" id="system_ogimage-label">{__("Custom OG-Image")}</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if $system['system_ogimage'] == ''}
                    {include file='__x_image.tpl' _x_name="system_ogimage" _x_fit="contain"}
                  {else}
                    {include file='__x_image.tpl' _x_name="system_ogimage" _x_value=$system['system_ogimage'] _x_fit="contain"}
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="system_ogimage-help">{__("The perfect size for your og-image should be (wdith: 590px & height: 300px)")}</div>
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="design-general-themes-demo">
              <h3 id="design-general-themes-demo" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Themes Demo")}</h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="themes_switcher" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="themes_demo_enabled">{__("Themes Demo")}</label>
                  <div id="themes_demo_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                    {__("Show a floating button that lets everyone preview the enabled themes and their landing pages")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="themes_demo_enabled" id="themes_demo_enabled" {if $system['themes_demo_enabled']}checked{/if} aria-describedby="themes_demo_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="profile" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="themes_demo_hide_loggedin">{__("Hide After Login")}</label>
                  <div id="themes_demo_hide_loggedin-help" class="admin-setting-help text-sm leading-relaxed">
                    {__("Hide the themes button after the user signs in")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="themes_demo_hide_loggedin" id="themes_demo_hide_loggedin" {if $system['themes_demo_hide_loggedin']}checked{/if} aria-describedby="themes_demo_hide_loggedin-help">
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
    </form>
  </div>

  <div id="Landing" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="design-tab-landing" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/design.php?edit=landing">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="design-landing-badges">
              <h3 id="design-landing-badges" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("App Store Badges")}</h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="playstore" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="play_store_badge_enabled">{__("Google Play Store Badge")}</label>
                  <div id="play_store_badge_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Show Google Play Store badge on the landing page")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="play_store_badge_enabled" id="play_store_badge_enabled" {if $system['play_store_badge_enabled']}checked{/if} aria-describedby="play_store_badge_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="play_store_link">{__("Google Play Store Link")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="play_store_link" id="play_store_link" value="{$system['play_store_link']}" aria-describedby="play_store_link-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="play_store_link-help">{__("The app link on Google Play Store")}</div>
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="appgallery" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="appgallery_badge_enabled">{__("Huawei AppGallery Badge")}</label>
                  <div id="appgallery_badge_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Show Huawei AppGallery badge on the landing page")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="appgallery_badge_enabled" id="appgallery_badge_enabled" {if $system['appgallery_badge_enabled']}checked{/if} aria-describedby="appgallery_badge_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="appgallery_store_link">{__("Huawei AppGallery Link")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="appgallery_store_link" id="appgallery_store_link" value="{$system['appgallery_store_link']}" aria-describedby="appgallery_store_link-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="appgallery_store_link-help">{__("The app link on Huawei AppGallery")}</div>
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="appstore" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="app_store_badge_enabled">{__("Apple App Store Badge")}</label>
                  <div id="app_store_badge_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Show Apple App Store badge on the landing page")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="app_store_badge_enabled" id="app_store_badge_enabled" {if $system['app_store_badge_enabled']}checked{/if} aria-describedby="app_store_badge_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="app_store_link">{__("Apple App Store Link")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="app_store_link" id="app_store_link" value="{$system['app_store_link']}" aria-describedby="app_store_link-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="app_store_link-help">{__("The app link on Apple App Store")}</div>
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
    </form>
  </div>

  <div id="CustomCode" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="design-tab-code" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/design.php?edit=code">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="design-code-js">
              <h3 id="design-code-js" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Custom JavaScript")}</h3>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="custome_js_header">{__("Header Custom JavaScript")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <textarea class="textarea w-full" name="custome_js_header" id="custome_js_header" aria-describedby="custome_js_header-help">{$system['custome_js_header']}</textarea>
                  <div class="admin-setting-help text-sm leading-relaxed" id="custome_js_header-help">{__("The code will be added in head tag")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="custome_js_footer">{__("Footer Custom JavaScript")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <textarea class="textarea w-full" name="custome_js_footer" id="custome_js_footer" aria-describedby="custome_js_footer-help">{$system['custome_js_footer']}</textarea>
                  <div class="admin-setting-help text-sm leading-relaxed" id="custome_js_footer-help">{__("The code will be added at the end of body tag")}</div>
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
    </form>
  </div>

  <div id="ModuleNames" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="design-tab-modules" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/design.php?edit=module_names">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="design-modules-names">
              <h3 id="design-modules-names" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Module Names")}</h3>
              <div class="admin-setting-help text-sm leading-relaxed">{__("Rename the modules across your website, the new names apply to the English language only and the admin panel keeps the original names")} ({__("Leave a field empty to use the default name")})</div>
              <!-- modules names -->
              {foreach $module_names as $_key => $_module}
                <div class="flex flex-col gap-4 rounded-[14px] border border-base-300 p-3 lg:flex-row lg:items-center" role="group" aria-labelledby="module-name-{$_key}-label">
                  <div class="flex min-w-0 items-center gap-3 lg:w-48 lg:shrink-0">
                    <span class="{$_module['icon']} size-5 shrink-0 text-base-content/70" aria-hidden="true"></span>
                    <span class="min-w-0 flex-1 truncate text-sm font-medium" id="module-name-{$_key}-label" title="{$_module['label']}">{$_module['label']}</span>
                  </div>
                  <div class="grid min-w-0 flex-1 grid-cols-1 items-start gap-4 sm:grid-cols-2">
                    {foreach $_module['terms'] as $_term => $_name}
                      <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                        <label class="label-text" for="module-name-{$_key}-{$_term}">{if $_term == "singular"}{__("Singular")}{elseif $_term == "plural"}{__("Plural")}{else}{__("Name")}{/if}</label>
                        <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                          <input type="text" class="input w-full" name="module_names[{$_key}][{$_term}]" id="module-name-{$_key}-{$_term}" value="{$_name['value']}" placeholder="{$_name['default']}" maxlength="32" autocomplete="off">
                        </div>
                      </div>
                    {/foreach}
                  </div>
                </div>
              {/foreach}
              <!-- modules names -->
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
    </form>
  </div>
</section>
