<section class="admin-settings-page" aria-labelledby="pwa-settings-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="pwa-settings-title" class="text-2xl font-semibold">{__("PWA (Progressive Web App)")}</h1>
    <p class="text-base-content/60 text-sm">{__("Installable web app, manifest icons, and the install banner.")}</p>
  </div>

  <div class="admin-settings-panel js_admin-settings-panel" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=pwa">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="pwa-settings-general">
              <h3 id="pwa-settings-general" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("General")}</h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="pwa" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="pwa_enabled">{__("PWA Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="pwa_enabled-help">{__("Enable or Disable the PWA - Progressive Web App")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="pwa_enabled" id="pwa_enabled" {if $system['pwa_enabled']}checked{/if} aria-describedby="pwa_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="pwa-install" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="pwa_banner_enabled">{__("PWA Install Banner")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="pwa_banner_enabled-help">{__("Show a banner to install the PWA")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="pwa_banner_enabled" id="pwa_banner_enabled" {if $system['pwa_banner_enabled']}checked{/if} aria-describedby="pwa_banner_enabled-help">
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="pwa-settings-icons">
              <h3 id="pwa-settings-icons" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Icons")}</h3>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="pwa_192_icon-label">
                <div class="label-text" id="pwa_192_icon-label">{__("PWA Icon 192x192")}</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if $system['pwa_192_icon'] == ''}
                    {include file='__x_image.tpl' _x_name="pwa_192_icon" _x_fit="contain"}
                  {else}
                    {include file='__x_image.tpl' _x_name="pwa_192_icon" _x_value=$system['pwa_192_icon'] _x_fit="contain"}
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed">{__("The icon should be 192x192 pixels")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="pwa_512_icon-label">
                <div class="label-text" id="pwa_512_icon-label">{__("PWA Icon 512x512")}</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if $system['pwa_512_icon'] == ''}
                    {include file='__x_image.tpl' _x_name="pwa_512_icon" _x_fit="contain"}
                  {else}
                    {include file='__x_image.tpl' _x_name="pwa_512_icon" _x_value=$system['pwa_512_icon'] _x_fit="contain"}
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed">{__("The icon should be 512x512 pixels")}</div>
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
</section>
