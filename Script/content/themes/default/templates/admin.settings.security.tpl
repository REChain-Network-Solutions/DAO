<!-- card-header -->
<div class="card-header with-icon">
  <!-- panel title -->
  <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("Security")}
  <!-- panel title -->
</div>
<!-- card-header -->

<!-- Security -->
<form class="js_ajax-forms" data-url="admin/settings.php?edit=security">
  <div class="card-body">
    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="spy" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Unusual Login Detection")}</div>
        <div class="form-text d-none d-sm-block">{__("Enable unusual login detection, System will not allow user to login with same session from different device or location")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="unusual_login_enabled">
          <input type="checkbox" name="unusual_login_enabled" id="unusual_login_enabled" {if $system['unusual_login_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="firewall" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Brute Force Detection")}</div>
        <div class="form-text d-none d-sm-block">{__("Enable brute force attack detection, System will block the user account if hacker try to login with invalid password too many times to guess the correct account password")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="brute_force_detection_enabled">
          <input type="checkbox" name="brute_force_detection_enabled" id="brute_force_detection_enabled" {if $system['brute_force_detection_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Bad Login Limit")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="brute_force_bad_login_limit" value="{$system['brute_force_bad_login_limit']}">
        <div class="form-text">
          {__("Number of bad login attempts till account get blocked")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Lockout Time")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="brute_force_lockout_time" value="{$system['brute_force_lockout_time']}">
        <div class="form-text">
          {__("Number of minutes the account will still locked out")}
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="fingerprint" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Two-Factor Authentication")}</div>
        <div class="form-text d-none d-sm-block">{__("Enable two-factor authentication to log in with a code from your email/phone as well as a password")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="two_factor_enabled">
          <input type="checkbox" name="two_factor_enabled" id="two_factor_enabled" {if $system['two_factor_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-sm-3 form-label">
        {__("Two-Factor Authentication Via")}
      </label>
      <div class="col-md-9">
        <div class="form-check form-check-inline">
          <input type="radio" name="two_factor_type" id="two_factor_email" value="email" class="form-check-input" {if $system['two_factor_type'] == "email"}checked{/if}>
          <label class="form-check-label" for="two_factor_email">{__("Email")}</label>
        </div>
        <div class="form-check form-check-inline">
          <input type="radio" name="two_factor_type" id="two_factor_sms" value="sms" class="form-check-input" {if $system['two_factor_type'] == "sms"}checked{/if}>
          <label class="form-check-label" for="two_factor_sms">{__("SMS")}</label>
        </div>
        <div class="form-check form-check-inline">
          <input type="radio" name="two_factor_type" id="two_factor_google" value="google" class="form-check-input" {if $system['two_factor_type'] == "google"}checked{/if}>
          <label class="form-check-label" for="two_factor_google">{__("Google Authenticator")}</label>
        </div>
        <div class="form-text">
          {__("Select Email, SMS or Google Authenticator to send log in code to user")}<br>
          {__("Make sure you have configured")} <a href="{$system['system_url']}/{$control_panel['url']}/settings/sms">{__("SMS Settings")}</a>
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="password" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Password Complexity System")}</div>
        <div class="form-text d-none d-sm-block">{__("This system will require a powerful password including letters, numbers and special characters")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="password_complexity_enabled">
          <input type="checkbox" name="password_complexity_enabled" id="password_complexity_enabled" {if $system['password_complexity_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="reserved" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Reserved Usernames Enabled")}</div>
        <div class="form-text d-none d-sm-block">{__("Enable/Disable Reserved Usernames")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="reserved_usernames_enabled">
          <input type="checkbox" name="reserved_usernames_enabled" id="reserved_usernames_enabled" {if $system['reserved_usernames_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Reserved Usernames")}
      </label>
      <div class="col-md-9">
        <textarea class="js_tagify x-hidden" name="reserved_usernames" rows="3">{$system['reserved_usernames']}</textarea>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="censored" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Censored Words Enabled")}</div>
        <div class="form-text d-none d-sm-block">{__("Enable/Disable Words to be censored")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="censored_words_enabled">
          <input type="checkbox" name="censored_words_enabled" id="censored_words_enabled" {if $system['censored_words_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Censored Words")}
      </label>
      <div class="col-md-9">
        <textarea class="js_tagify x-hidden" name="censored_words" rows="3">{$system['censored_words']}</textarea>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="block" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Censored Domains Enabled")}</div>
        <div class="form-text d-none d-sm-block">{__("Enable/Disable Domains to be censored (will not be fetched)")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="censored_domains_enabled">
          <input type="checkbox" name="censored_domains_enabled" id="censored_domains_enabled" {if $system['censored_domains_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Censored Domains")}
      </label>
      <div class="col-md-9">
        <textarea class="js_tagify x-hidden" name="censored_domains" rows="3">{$system['censored_domains']}</textarea>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="html" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("HTML Enabled")}</div>
        <div class="form-text d-none d-sm-block">{__("Enable/Disable HTML code in Rich Text Editor (blogs and forums)")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="html_richtext_enabled">
          <input type="checkbox" name="html_richtext_enabled" id="html_richtext_enabled" {if $system['html_richtext_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="google_recaptcha" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("reCAPTCHA Enabled")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn reCAPTCHA On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="reCAPTCHA_enabled">
          <input type="checkbox" name="reCAPTCHA_enabled" id="reCAPTCHA_enabled" {if $system['reCAPTCHA_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("reCAPTCHA Site Key")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="reCAPTCHA_site_key" value="{$system['reCAPTCHA_site_key']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("reCAPTCHA Secret Key")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="reCAPTCHA_secret_key" value="{$system['reCAPTCHA_secret_key']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
      </div>
    </div>

    <div class="divider dashed"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="cloudflare" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Turnstile Enabled")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn Cloudflare Turnstile On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="turnstile_enabled">
          <input type="checkbox" name="turnstile_enabled" id="turnstile_enabled" {if $system['turnstile_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Turnstile Site Key")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="turnstile_site_key" value="{$system['turnstile_site_key']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Turnstile Secret Key")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="turnstile_secret_key" value="{$system['turnstile_secret_key']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
      </div>
    </div>

    <!-- success -->
    <div class="alert alert-success mt15 mb0 x-hidden"></div>
    <!-- success -->

    <!-- error -->
    <div class="alert alert-danger mt15 mb0 x-hidden"></div>
    <!-- error -->
  </div>
  <div class="card-footer text-end">
    <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
  </div>
</form>
<!-- Security -->