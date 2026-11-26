<section class="admin-settings-page" aria-labelledby="settings-security-title">
  <!-- card-header -->
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-security-title" class="text-2xl font-semibold">
      {__("Security Settings")}
    </h1>
    <p class="text-base-content/60 text-sm">{__("Security protections and captcha providers.")}</p>
  </div>
  <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Security Settings")}" aria-orientation="vertical">
    <button type="button" id="settings-security-tab-0" class="tab active-tab:tab-active active" data-tab="#Security" aria-controls="Security" role="tab" aria-selected="true"><span class="icon-[tabler--shield] size-4" aria-hidden="true"></span>{__("Security")}</button>
    <button type="button" id="settings-security-tab-1" class="tab active-tab:tab-active" data-tab="#Captcha" aria-controls="Captcha" role="tab" aria-selected="false"><span class="icon-[tabler--robot] size-4" aria-hidden="true"></span>{__("Captcha")}</button>
  </nav>
  <!-- card-header -->
  <!-- tabs content -->
  <div class="tab-content">
    <!-- Security -->
    <div class="admin-settings-panel js_admin-settings-panel" id="Security" role="tabpanel" aria-labelledby="settings-security-tab-0" tabindex="0">
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=security">
                <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">

          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-security-security-card-0">
          <h3 id="settings-security-security-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Login protection")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="spy" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="unusual_login_enabled">{__("Unusual Login Detection")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="unusual_login_enabled-help">
                    {__("Enable unusual login detection, System will not allow user to login with same session from different device or location")}
                    <br>
                    {__("With IPinfo enabled the session ends only when it moves to another country, otherwise any IP address change logs the user out")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="unusual_login_enabled" id="unusual_login_enabled" {if $system['unusual_login_enabled']}checked{/if} class="switch switch-primary" aria-describedby="unusual_login_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="firewall" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="brute_force_detection_enabled">{__("Brute Force Detection")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="brute_force_detection_enabled-help">
                    {__("Enable brute force attack detection, System will block the user account if hacker try to login with invalid password too many times to guess the correct account password")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="brute_force_detection_enabled" id="brute_force_detection_enabled" {if $system['brute_force_detection_enabled']}checked{/if} class="switch switch-primary" aria-describedby="brute_force_detection_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-security-field-1-label" for="settings-security-field-1">
                  {__("Bad Login Limit")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="brute_force_bad_login_limit" value="{$system['brute_force_bad_login_limit']}" id="settings-security-field-1" aria-describedby="settings-security-field-1-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-security-field-1-help">
                    {__("Number of bad login attempts till account get blocked")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-security-field-2-label" for="settings-security-field-2">
                  {__("Lockout Time")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="brute_force_lockout_time" value="{$system['brute_force_lockout_time']}" id="settings-security-field-2" aria-describedby="settings-security-field-2-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-security-field-2-help">
                    {__("Number of minutes the account will still locked out")}
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-security-security-card-ipinfo">
          <h3 id="settings-security-security-card-ipinfo" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("IP intelligence")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="map" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="ipinfo_enabled">{__("IPinfo Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="ipinfo_enabled-help">
                    {__("Detect the country and network of each login to show session locations, set the country of new users and improve unusual login detection")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="ipinfo_enabled" id="ipinfo_enabled" {if $system['ipinfo_enabled']}checked{/if} class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-describedby="ipinfo_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-security-field-ipinfo-label" for="settings-security-field-ipinfo">
                  {__("IPinfo Access Token")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="ipinfo_token" value="{$system['ipinfo_token']}" id="settings-security-field-ipinfo" aria-describedby="settings-security-field-ipinfo-help">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-security-field-ipinfo" aria-describedby="settings-security-field-ipinfo-help">
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-security-field-ipinfo-help">
                    {__("Your free IPinfo Lite access token from")} <a href="https://ipinfo.io/dashboard/token" target="_blank" rel="noopener">ipinfo.io</a>
                  </div>
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="notification_bell" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="login_alerts_enabled">{__("New Location Login Alerts")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="login_alerts_enabled-help">
                    {__("Send the user an email and a notification when their account is logged in from a new country (requires IPinfo)")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="login_alerts_enabled" id="login_alerts_enabled" {if $system['login_alerts_enabled']}checked{/if} class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-describedby="login_alerts_enabled-help">
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-security-security-card-1">
          <h3 id="settings-security-security-card-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Two-factor authentication")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="fingerprint" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="two_factor_enabled">{__("Two-Factor Authentication")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="two_factor_enabled-help">
                    {__("Enable two-factor authentication to log in with a code from your email/phone as well as a password")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="two_factor_enabled" id="two_factor_enabled" {if $system['two_factor_enabled']}checked{/if} class="switch switch-primary" aria-describedby="two_factor_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-security-field-3-label">
                <div class="label-text" id="settings-security-field-3-label">
                  {__("Two-Factor Authentication Via")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="two_factor_type" id="two_factor_email" value="email" class="radio radio-primary" {if $system['two_factor_type'] == "email"}checked{/if} aria-describedby="settings-security-field-3-help">
                    <label class="label-text" for="two_factor_email">{__("Email")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="two_factor_type" id="two_factor_sms" value="sms" class="radio radio-primary" {if $system['two_factor_type'] == "sms"}checked{/if} aria-describedby="settings-security-field-3-help">
                    <label class="label-text" for="two_factor_sms">{__("SMS")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="two_factor_type" id="two_factor_google" value="google" class="radio radio-primary" {if $system['two_factor_type'] == "google"}checked{/if} aria-describedby="settings-security-field-3-help">
                    <label class="label-text" for="two_factor_google">{__("Google Authenticator")}</label>
                  </div>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-security-field-3-help">
                    {__("Select Email, SMS or Google Authenticator to send log in code to user")}
                    <br>
                    {__("Make sure you have configured")}
                    <a href="{$system['system_url']}/{$control_panel['url']}/settings/sms">{__("SMS Settings")}</a>
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-security-security-card-2">
          <h3 id="settings-security-security-card-2" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Passwords")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="password" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="password_complexity_enabled">{__("Password Complexity System")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="password_complexity_enabled-help">
                    {__("This system will require a powerful password including letters, numbers and special characters")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="password_complexity_enabled" id="password_complexity_enabled" {if $system['password_complexity_enabled']}checked{/if} class="switch switch-primary" aria-describedby="password_complexity_enabled-help">
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-security-security-card-3">
          <h3 id="settings-security-security-card-3" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Reserved usernames")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="reserved" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="reserved_usernames_enabled">{__("Reserved Usernames Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="reserved_usernames_enabled-help">
                    {__("Enable/Disable Reserved Usernames")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="reserved_usernames_enabled" id="reserved_usernames_enabled" {if $system['reserved_usernames_enabled']}checked{/if} class="switch switch-primary" aria-describedby="reserved_usernames_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-security-field-4-label" for="settings-security-field-4">
                  {__("Reserved Usernames")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <textarea class="js_tagify textarea w-full" name="reserved_usernames" rows="3" id="settings-security-field-4">{$system['reserved_usernames']}</textarea>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-security-security-card-4">
          <h3 id="settings-security-security-card-4" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Content filters")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="censored" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="censored_words_enabled">{__("Censored Words Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="censored_words_enabled-help">
                    {__("Enable/Disable Words to be censored")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="censored_words_enabled" id="censored_words_enabled" {if $system['censored_words_enabled']}checked{/if} class="switch switch-primary" aria-describedby="censored_words_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-security-field-5-label" for="settings-security-field-5">
                  {__("Censored Words")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <textarea class="js_tagify textarea w-full" name="censored_words" rows="3" id="settings-security-field-5">{$system['censored_words']}</textarea>
                </div>
              </div>
              <div class="divider"></div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="block" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="censored_domains_enabled">{__("Censored Domains Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="censored_domains_enabled-help">
                    {__("Enable/Disable Domains to be censored (will not be fetched)")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="censored_domains_enabled" id="censored_domains_enabled" {if $system['censored_domains_enabled']}checked{/if} class="switch switch-primary" aria-describedby="censored_domains_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-security-field-6-label" for="settings-security-field-6">
                  {__("Censored Domains")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <textarea class="js_tagify textarea w-full" name="censored_domains" rows="3" id="settings-security-field-6">{$system['censored_domains']}</textarea>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-security-security-card-5">
          <h3 id="settings-security-security-card-5" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("HTML content")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="html" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="html_richtext_enabled">{__("HTML Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="html_richtext_enabled-help">
                    {__("Enable/Disable HTML code in Rich Text Editor")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="html_richtext_enabled" id="html_richtext_enabled" {if $system['html_richtext_enabled']}checked{/if} class="switch switch-primary" aria-describedby="html_richtext_enabled-help">
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
            <button type="button" class="btn btn-outline js_admin-tester" data-handle="ipinfo">
              <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection (IPinfo)")}
            </button>
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
          </div>
        </div>
            </section>
          </div>
        </div>
      </form>
    </div>
    <!-- Security -->
    <!-- Captcha -->
    <div class="admin-settings-panel js_admin-settings-panel hidden" id="Captcha" role="tabpanel" aria-labelledby="settings-security-tab-1" tabindex="0">
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=captcha">
                <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">

          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-security-captcha-card-0">
          <h3 id="settings-security-captcha-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("CAPTCHA provider")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="google_recaptcha" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="captcha_enabled">{__("Captcha Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="captcha_enabled-help">
                    {__("Enable/Disable Captcha protection on registration and login forms")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="captcha_enabled" id="captcha_enabled" {if $system['captcha_enabled']}checked{/if} class="switch switch-primary" aria-describedby="captcha_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-security-field-7-label">
                <div class="label-text" id="settings-security-field-7-label">
                  {__("Captcha Provider")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-provider-group flex flex-wrap items-stretch gap-3">
                    <!-- reCAPTCHA -->
                    <label class="admin-settings-provider-card">
                      <span class="admin-settings-provider-logo">
                        {include file='__svg_icons.tpl' icon="google_recaptcha" width="32px" height="32px"}
                      </span>
                      <span class="label-text">{__("reCAPTCHA")}</span>
                      <input type="radio" name="captcha_provider" value="recaptcha" id="captcha_recaptcha" class="radio radio-primary" {if $system['captcha_provider'] == "recaptcha"}checked{/if}  aria-describedby="settings-security-field-7-help"/>
                    </label>
                    <!-- reCAPTCHA -->
                    <!-- Turnstile -->
                    <label class="admin-settings-provider-card">
                      <span class="admin-settings-provider-logo">
                        {include file='__svg_icons.tpl' icon="cloudflare" width="32px" height="32px"}
                      </span>
                      <span class="label-text">{__("Turnstile")}</span>
                      <input type="radio" name="captcha_provider" value="turnstile" id="captcha_turnstile" class="radio radio-primary" {if $system['captcha_provider'] == "turnstile"}checked{/if}  aria-describedby="settings-security-field-7-help"/>
                    </label>
                    <!-- Turnstile -->
                    <!-- hCaptcha -->
                    <label class="admin-settings-provider-card">
                      <span class="admin-settings-provider-logo">
                        {include file='__svg_icons.tpl' icon="hcaptcha" width="32px" height="32px"}
                      </span>
                      <span class="label-text">{__("hCaptcha")}</span>
                      <input type="radio" name="captcha_provider" value="hcaptcha" id="captcha_hcaptcha" class="radio radio-primary" {if $system['captcha_provider'] == "hcaptcha"}checked{/if}  aria-describedby="settings-security-field-7-help"/>
                    </label>
                    <!-- hCaptcha -->
                  </div>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-security-field-7-help">
                    {__("Select your captcha provider")}
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-security-captcha-card-1">
          <h3 id="settings-security-captcha-card-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("reCAPTCHA")}
          </h3>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-security-field-8-label" for="settings-security-field-8">
                  {__("reCAPTCHA Site Key")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="reCAPTCHA_site_key" value="{$system['reCAPTCHA_site_key']}" id="settings-security-field-8">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-security-field-8">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-security-field-9-label" for="settings-security-field-9">
                  {__("reCAPTCHA Secret Key")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="reCAPTCHA_secret_key" value="{$system['reCAPTCHA_secret_key']}" id="settings-security-field-9">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-security-field-9">
                  {/if}
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-security-captcha-card-2">
          <h3 id="settings-security-captcha-card-2" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Turnstile")}
          </h3>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-security-field-10-label" for="settings-security-field-10">
                  {__("Turnstile Site Key")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="turnstile_site_key" value="{$system['turnstile_site_key']}" id="settings-security-field-10">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-security-field-10">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-security-field-11-label" for="settings-security-field-11">
                  {__("Turnstile Secret Key")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="turnstile_secret_key" value="{$system['turnstile_secret_key']}" id="settings-security-field-11">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-security-field-11">
                  {/if}
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-security-captcha-card-3">
          <h3 id="settings-security-captcha-card-3" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("hCaptcha")}
          </h3>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-security-field-12-label" for="settings-security-field-12">
                  {__("hCaptcha Site Key")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="hcaptcha_site_key" value="{$system['hcaptcha_site_key']}" id="settings-security-field-12">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-security-field-12">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-security-field-13-label" for="settings-security-field-13">
                  {__("hCaptcha Secret Key")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="hcaptcha_secret_key" value="{$system['hcaptcha_secret_key']}" id="settings-security-field-13">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-security-field-13">
                  {/if}
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
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
          </div>
        </div>
            </section>
          </div>
        </div>
      </form>
    </div>
    <!-- Captcha -->
  </div>
  <!-- tabs content -->
</section>
