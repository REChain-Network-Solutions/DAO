<section class="admin-settings-page" aria-labelledby="settings-email-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-email-title" class="text-2xl font-semibold">{__("Email Settings")}</h1>
    <p class="text-base-content/60 text-sm">{__("SMTP delivery and email connection options.")}</p>
  </div>
  <form class="js_ajax-forms" data-url="admin/settings.php?edit=email">
    <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="email" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="email_smtp_enabled">{__("SMTP")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="email_smtp_enabled-help">
                  {__("Enable/Disable SMTP email system")}<br>
                  {__("PHP mail() function will be used in case of disabled")}
                </div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary" name="email_smtp_enabled" id="email_smtp_enabled" {if $system['email_smtp_enabled']}checked{/if} aria-describedby="email_smtp_enabled-help">
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="authentication" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="email_smtp_authentication">{__("SMTP Require Authentication")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="email_smtp_authentication-help">{__("Enable/Disable SMTP authentication")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary" name="email_smtp_authentication" id="email_smtp_authentication" {if $system['email_smtp_authentication']}checked{/if} aria-describedby="email_smtp_authentication-help">
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="ssl" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="email_smtp_ssl">{__("SMTP SSL Encryption")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="email_smtp_ssl-help">
                  {__("Enable/Disable SMTP SSL encryption")}<br>
                  {__("TLS encryption will be used in case of disabled")}
                </div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary" name="email_smtp_ssl" id="email_smtp_ssl" {if $system['email_smtp_ssl']}checked{/if} aria-describedby="email_smtp_ssl-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="email_smtp_server">{__("SMTP Server")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="email_smtp_server" id="email_smtp_server" value="{$system['email_smtp_server']}">
                {else}
                  <input type="password" class="input w-full" id="email_smtp_server" value="*********">
                {/if}
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="email_smtp_port">{__("SMTP Port")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="email_smtp_port" id="email_smtp_port" value="{$system['email_smtp_port']}">
                {else}
                  <input type="password" class="input w-full" id="email_smtp_port" value="*********">
                {/if}
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="email_smtp_username">{__("SMTP Username")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="email_smtp_username" id="email_smtp_username" value="{$system['email_smtp_username']}">
                {else}
                  <input type="password" class="input w-full" id="email_smtp_username" value="*********">
                {/if}
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="email_smtp_password">{__("SMTP Password")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="email_smtp_password" id="email_smtp_password" value="{$system['email_smtp_password']}">
                {else}
                  <input type="password" class="input w-full" id="email_smtp_password" value="*********">
                {/if}
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="email_smtp_setfrom">{__("Set From")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="email_smtp_setfrom" id="email_smtp_setfrom" value="{$system['email_smtp_setfrom']}" aria-describedby="email_smtp_setfrom-help">
                {else}
                  <input type="password" class="input w-full" id="email_smtp_setfrom" value="*********">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="email_smtp_setfrom-help">
                  {__("Set the From email address")}, {__("For example: email@domain.com")}
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
              <button type="button" class="btn btn-outline js_admin-tester" data-handle="smtp">
                <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span>{__("Test Connection")}
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </section>
      </div>
    </div>
  </form>
</section>
