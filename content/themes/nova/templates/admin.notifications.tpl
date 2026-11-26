<section class="admin-settings-page" aria-labelledby="notifications-settings-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="notifications-settings-title" class="text-2xl font-semibold">{__("Mass Notifications")}</h1>
    <p class="text-base-content/60 text-sm">{__("Send a notification to all site users")}</p>
  </div>

  <form class="js_ajax-forms" data-url="admin/notifications.php">
    <div class="admin-settings-layout block">
      <div class="admin-settings-form flex min-w-0 flex-col gap-4">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="notifications-settings-message">
            <h3 id="notifications-settings-message" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Notification")}</h3>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="notification_url">{__("URL")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="url" id="notification_url" aria-describedby="notification_url-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="notification_url-help">{__("Notification link used when user clicks on the notification")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="notification_message">{__("Message")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea class="textarea w-full" rows="3" name="message" id="notification_message"></textarea>
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="submit" class="btn btn-primary">
                <span class="icon-[tabler--send] size-4" aria-hidden="true"></span>{__("Send")}
              </button>
            </div>
          </div>
        </section>
      </div>
    </div>
  </form>
</section>
