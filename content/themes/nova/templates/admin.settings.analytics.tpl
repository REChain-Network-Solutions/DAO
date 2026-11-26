<section class="admin-settings-page" aria-labelledby="settings-analytics-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-analytics-title" class="text-2xl font-semibold">{__("Analytics Settings")}</h1>
    <p class="text-base-content/60 text-sm">{__("Tracking code for your website.")}</p>
  </div>
  <form class="js_ajax-forms" data-url="admin/settings.php?edit=analytics">
    <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="analytics_code">{__("Tracking Code")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea class="textarea w-full" name="message" id="analytics_code" rows="3" aria-describedby="analytics_code-help">{$system['analytics_code']}</textarea>
                <div class="admin-setting-help text-sm leading-relaxed" id="analytics_code-help">
                  {__("The analytics tracking code (Ex: Google Analytics)")}
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
  </form>
</section>
