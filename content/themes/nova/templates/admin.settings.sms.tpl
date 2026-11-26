<section class="admin-settings-page" aria-labelledby="settings-sms-title">
  <!-- card-header -->
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-sms-title" class="text-2xl font-semibold">
      {__("SMS Settings")}
    </h1>
    <p class="text-base-content/60 text-sm">{__("Providers, credentials, and SMS limits.")}</p>
  </div>
  <!-- card-header -->
  <!-- SMS -->
  <form class="js_ajax-forms" data-url="admin/settings.php?edit=sms">
        <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">

      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-sms-sms-card-0">
          <h3 id="settings-sms-sms-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Provider and limits")}
          </h3>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-sms-field-1-label">
            <div class="label-text" id="settings-sms-field-1-label">
              {__("SMS Provider")}
            </div>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <div class="admin-settings-provider-group flex flex-wrap items-stretch gap-3">
                <!-- Twilio -->
                    <label class="admin-settings-provider-card">
                      <span class="admin-settings-provider-logo">
                        {include file='__svg_icons.tpl' icon="twilio" width="32px" height="32px"}
                      </span>
                      <span class="label-text">{__("Twilio")}</span>
                      <input type="radio" name="sms_provider" value="twilio" id="sms_twilio" class="radio radio-primary" {if $system['sms_provider'] == "twilio"}checked{/if}  aria-describedby="settings-sms-field-1-help"/>
                    </label>
                <!-- Twilio -->
                <!-- BulkSMS -->
                    <label class="admin-settings-provider-card">
                      <span class="admin-settings-provider-logo">
                        {include file='__svg_icons.tpl' icon="bulksms" width="52px" height="32px"}
                      </span>
                      <span class="label-text">{__("BulkSMS")}</span>
                      <input type="radio" name="sms_provider" value="bulksms" id="sms_bulksms" class="radio radio-primary" {if $system['sms_provider'] == "bulksms"}checked{/if}  aria-describedby="settings-sms-field-1-help"/>
                    </label>
                <!-- BulkSMS -->
                <!-- Infobip -->
                    <label class="admin-settings-provider-card">
                      <span class="admin-settings-provider-logo">
                        {include file='__svg_icons.tpl' icon="infobip" width="52px" height="32px"}
                      </span>
                      <span class="label-text">{__("Infobip")}</span>
                      <input type="radio" name="sms_provider" value="infobip" id="sms_infobip" class="radio radio-primary" {if $system['sms_provider'] == "infobip"}checked{/if}  aria-describedby="settings-sms-field-1-help"/>
                    </label>
                <!-- Infobip -->
                <!-- Msg91 -->
                    <label class="admin-settings-provider-card">
                      <span class="admin-settings-provider-logo">
                        {include file='__svg_icons.tpl' icon="msg91" width="52px" height="32px"}
                      </span>
                      <span class="label-text">{__("Msg91")}</span>
                      <input type="radio" name="sms_provider" value="msg91" id="sms_msg91" class="radio radio-primary" {if $system['sms_provider'] == "msg91"}checked{/if}  aria-describedby="settings-sms-field-1-help"/>
                    </label>
                <!-- Msg91 -->
              </div>
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-sms-field-1-help">
                {__("Select your default SMS provider")}
                <br />
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-sms-field-2-label" for="settings-sms-field-2">
              {__("SMS Limit")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="sms_limit" value="{$system['sms_limit']}" id="settings-sms-field-2" aria-describedby="settings-sms-field-2-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-sms-field-2-help">
                {__("Set the maximum number of SMS messages that can be sent per hour")}
              </div>
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-sms-sms-card-1">
          <h3 id="settings-sms-sms-card-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Twilio")}
          </h3>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-sms-field-3-label" for="settings-sms-field-3">
              {__("Twilio Account SID")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="twilio_sid" value="{$system['twilio_sid']}" id="settings-sms-field-3">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-sms-field-3">
              {/if}
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-sms-field-4-label" for="settings-sms-field-4">
              {__("Twilio Auth Token")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="twilio_token" value="{$system['twilio_token']}" id="settings-sms-field-4">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-sms-field-4">
              {/if}
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-sms-field-5-label" for="settings-sms-field-5">
              {__("Twilio Phone Number")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="twilio_phone" value="{$system['twilio_phone']}" id="settings-sms-field-5">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-sms-field-5">
              {/if}
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-sms-sms-card-2">
          <h3 id="settings-sms-sms-card-2" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("BulkSMS")}
          </h3>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-sms-field-6-label" for="settings-sms-field-6">
              {__("BulkSMS Username")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="bulksms_username" value="{$system['bulksms_username']}" id="settings-sms-field-6">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-sms-field-6">
              {/if}
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-sms-field-7-label" for="settings-sms-field-7">
              {__("BulkSMS Password")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="bulksms_password" value="{$system['bulksms_password']}" id="settings-sms-field-7">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-sms-field-7">
              {/if}
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-sms-sms-card-3">
          <h3 id="settings-sms-sms-card-3" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Infobip")}
          </h3>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-sms-field-8-label" for="settings-sms-field-8">
              {__("Infobip Base URL")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="infobip_base_url" value="{$system['infobip_base_url']}" id="settings-sms-field-8" aria-describedby="settings-sms-field-8-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-sms-field-8-help">
                {__("Your personal base URL from the Infobip dashboard, e.g. xxxxx.api.infobip.com")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-sms-field-9-label" for="settings-sms-field-9">
              {__("Infobip API Key")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="infobip_api_key" value="{$system['infobip_api_key']}" id="settings-sms-field-9">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-sms-field-9">
              {/if}
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-sms-field-13-label" for="settings-sms-field-13">
              {__("Infobip Sender")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="infobip_sender" value="{$system['infobip_sender']}" id="settings-sms-field-13" aria-describedby="settings-sms-field-13-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-sms-field-13-help">
                {__("Registered sender name or number. Leave empty to use the site title")}
              </div>
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-sms-sms-card-4">
          <h3 id="settings-sms-sms-card-4" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Msg91")}
          </h3>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-sms-field-10-label" for="settings-sms-field-10">
              {__("Msg91 AuthKey")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="msg91_authkey" value="{$system['msg91_authkey']}" id="settings-sms-field-10">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-sms-field-10">
              {/if}
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-sms-field-11-label" for="settings-sms-field-11">
              {__("Msg91 Template ID")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="msg91_template_id" value="{$system['msg91_template_id']}" id="settings-sms-field-11">
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-sms-sms-card-5">
          <h3 id="settings-sms-sms-card-5" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Test recipient")}
          </h3>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-sms-field-12-label" for="settings-sms-field-12">
              {__("Test Phone Number")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="system_phone" value="{$system['system_phone']}" id="settings-sms-field-12" aria-describedby="settings-sms-field-12-help">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-sms-field-12" aria-describedby="settings-sms-field-12-help">
              {/if}
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-sms-field-12-help">
                {__("Your phone number to test the SMS service i.e +12344567890")}
                <br />
                {__("A test SMS will be sent to this phone number when you test the connection")}
              </div>
            </div>
          </div>
        </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
      <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
        <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
        </div>
        <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
        </div>
      </div>
      <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
        <button type="button" class="btn btn-outline js_admin-tester" data-handle="sms">
          <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span>{__("Test Connection")}
        </button>
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </div>
        </section>
      </div>
    </div>
  </form>
  <!-- SMS -->
</section>
