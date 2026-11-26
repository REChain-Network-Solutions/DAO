<section class="admin-settings-page" aria-labelledby="admin-newsletter-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="admin-newsletter-title" class="text-2xl font-semibold">{__("Newsletter")}</h1>
    <p class="text-base-content/60 text-sm">{__("Send email to opted-in members.")}</p>
  </div>

  <div class="admin-settings-panel js_admin-settings-panel" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/newsletter.php">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="newsletter-test-title">
              <h2 id="newsletter-test-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Test Message")}</h2>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="account_activation" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="is_test">{__("Test Message")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="is_test-help">{__("The message will sent to Website Email only")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="is_test" id="is_test" aria-describedby="is_test-help">
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="newsletter-compose-title">
              <h2 id="newsletter-compose-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Compose")}</h2>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="newsletter-to">{__("Send to")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="to" id="newsletter-to">
                    <option value="all_users">{__("All Users")} ({$insights['users_all']} {__("user")})</option>
                    <option value="users_activated">{__("Users who activated their account")} ({$insights['users_activated']} {__("user")})</option>
                    <option value="users_not_activated">{__("Users who did not activated their account")} ({$insights['users_not_activated']} {__("user")})</option>
                    <option value="users_not_logged_week">{__("Users who did not login from 1 week")} ({$insights['users_not_logged_week']} {__("user")})</option>
                    <option value="users_not_logged_month">{__("Users who did not login from 1 month")} ({$insights['users_not_logged_month']} {__("user")})</option>
                    <option value="users_not_logged_3_months">{__("Users who did not login from 3 months")} ({$insights['users_not_logged_3_months']} {__("user")})</option>
                    <option value="users_not_logged_6_months">{__("Users who did not login from 6 months")} ({$insights['users_not_logged_6_months']} {__("user")})</option>
                    <option value="users_not_logged_9_months">{__("Users who did not login from 9 months")} ({$insights['users_not_logged_9_months']} {__("user")})</option>
                    <option value="users_not_logged_year">{__("Users who did not login from 1 year")} ({$insights['users_not_logged_year']} {__("user")})</option>
                  </select>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="newsletter-subject">{__("Subject")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="subject" id="newsletter-subject" autocomplete="off">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="newsletter-message">{__("Message")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <textarea class="textarea w-full js_wysiwyg-advanced" id="newsletter-message" rows="10" name="message"></textarea>
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
                  <span class="icon-[tabler--send] size-4" aria-hidden="true"></span>
                  {__("Send")}
                </button>
              </div>
            </div>
          </section>
        </div>
      </div>
    </form>
  </div>
</section>
