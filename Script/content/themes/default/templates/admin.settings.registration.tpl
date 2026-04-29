<!-- card-header -->
<div class="card-header with-icon with-nav">
  <!-- panel title -->
  <div class="mb20">
    <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("Registration")}
  </div>
  <!-- panel title -->

  <!-- panel nav -->
  <ul class="nav nav-tabs">
    <li class="nav-item">
      <a class="nav-link active" href="#General" data-bs-toggle="tab">
        <i class="fa fa-sign-in-alt fa-fw mr5"></i><strong>{__("General")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#Social" data-bs-toggle="tab">
        <i class="fab fa-facebook fa-fw mr5"></i><strong>{__("Social Login")}</strong>
      </a>
    </li>
  </ul>
  <!-- panel nav -->
</div>
<!-- card-header -->

<!-- tabs content -->
<div class="tab-content">
  <!-- General -->
  <div class="tab-pane active" id="General">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=registration">
      <div class="card-body">
        <div class="alert alert-info">
          <div class="icon">
            <i class="fa fa-info-circle fa-2x"></i>
          </div>
          <div class="text pt5">
            {__("If Registration is Free and Pro Packages enabled they will be used as optional upgrading plans")}.
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="registration" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Registration")}</div>
            <div class="form-text d-none d-sm-block">{__("Allow users to create accounts")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="registration_enabled">
              <input type="checkbox" name="registration_enabled" id="registration_enabled" {if $system['registration_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Registration Type")}
          </label>
          <div class="col-md-9">
            <div class="form-check form-check-inline">
              <input type="radio" name="registration_type" id="registration_free" value="free" class="form-check-input" {if $system['registration_type'] == "free"}checked{/if}>
              <label class="form-check-label" for="registration_free">{__("Free")}</label>
            </div>
            <div class="form-check form-check-inline">
              <input type="radio" name="registration_type" id="registration_paid" value="paid" class="form-check-input" {if $system['registration_type'] == "paid"}checked{/if}>
              <label class="form-check-label" for="registration_paid">{__("Subscriptions Only")}</label>
            </div>
            <div class="form-text">
              {__("Allow users to create accounts Free or via Subscriptions only")}<br>
              {__("Make sure you have configured")} <a href="{$system['system_url']}/{$control_panel['url']}/pro">{__("Pro System")}</a>
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="groups" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("User Can Select Custom User Group")}</div>
            <div class="form-text d-none d-sm-block">{__("Allow users to select custom user group during registration")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="select_user_group_enabled">
              <input type="checkbox" name="select_user_group_enabled" id="select_user_group_enabled" {if $system['select_user_group_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <div style="width: 40px; height: 40px;"></div>
          </div>
          <div>
            <div class="form-label h6">{__("Show Custom User Group Badge")}</div>
            <div class="form-text d-none d-sm-block">{__("Show user group badge on profile page")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="show_user_group_enabled">
              <input type="checkbox" name="show_user_group_enabled" id="show_user_group_enabled" {if $system['show_user_group_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Default User Group")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="default_custom_user_group">
              <option value="0" {if $system['default_custom_user_group'] == '0'}selected{/if}>
                {__("Users")}
              </option>
              {foreach $user_groups as $user_group}
                <option value="{$user_group['user_group_id']}" {if $system['default_custom_user_group'] == $user_group['user_group_id']}selected{/if}>
                  {$user_group['user_group_title']}
                </option>
              {/foreach}
            </select>
            <div class="form-text">
              {__("Select the default user group for new accounts")}<br>
              {__("You can manage users groups from")} <a href="{$system['system_url']}/{$control_panel['url']}/users_groups">{__("User Groups")}</a>
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="invitation" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Invitation System")}</div>
            <div class="form-text d-none d-sm-block">
              {__("This option is used to register the users by invitation codes only")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="invitation_enabled">
              <input type="checkbox" name="invitation_enabled" id="invitation_enabled" {if $system['invitation_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Invitations/User")}
          </label>
          <div class="col-md-9">
            <div class="row">
              <div class="col-sm-8">
                <input class="form-control" name="invitation_user_limit" value="{$system['invitation_user_limit']}">
              </div>
              <div class="col-sm-4">
                <select class="form-select" name="invitation_expire_period">
                  <option {if $system['invitation_expire_period'] == "hour"}selected{/if} value="hour">{__("Hour")}</option>
                  <option {if $system['invitation_expire_period'] == "day"}selected{/if} value="day">{__("Day")}</option>
                  <option {if $system['invitation_expire_period'] == "week"}selected{/if} value="week">{__("Week")}</option>
                  <option {if $system['invitation_expire_period'] == "month"}selected{/if} value="month">{__("Month")}</option>
                  <option {if $system['invitation_expire_period'] == "year"}selected{/if} value="year">{__("Year")}</option>
                </select>
              </div>
            </div>
            <div class="form-text">
              {__("Number of invitation codes allowed to each user (0 for unlimited) ")}<br>
              {__("For example 1 code per day, 5 codes per month")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Send Method")}
          </label>
          <div class="col-md-9">
            <div class="form-check form-check-inline">
              <input type="radio" name="invitation_send_method" id="invitation_email" value="email" class="form-check-input" {if $system['invitation_send_method'] == "email"}checked{/if}>
              <label class="form-check-label" for="invitation_email">{__("Email")}</label>
            </div>
            <div class="form-check form-check-inline">
              <input type="radio" name="invitation_send_method" id="invitation_sms" value="sms" class="form-check-input" {if $system['invitation_send_method'] == "sms"}checked{/if}>
              <label class="form-check-label" for="invitation_sms">{__("SMS")}</label>
            </div>
            <div class="form-check form-check-inline">
              <input type="radio" name="invitation_send_method" id="invitation_both" value="both" class="form-check-input" {if $system['invitation_send_method'] == "both"}checked{/if}>
              <label class="form-check-label" for="invitation_both">{__("Both")}</label>
            </div>
            <div class="form-text">
              {__("Select Email or SMS to send invitation link to new user's email/phone")}<br>
              {__("Make sure you have configured")} <a href="{$system['system_url']}/{$control_panel['url']}/settings/sms">{__("SMS Settings")}</a>
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="account_activation" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Activation Enabled")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable account activation to send activation code to user's email/phone")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="activation_enabled">
              <input type="checkbox" name="activation_enabled" id="activation_enabled" {if $system['activation_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="adblock" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Activation Required")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable this and user will not be able to access without activation")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="activation_required">
              <input type="checkbox" name="activation_required" id="activation_required" {if $system['activation_required']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Activation Type")}
          </label>
          <div class="col-md-9">
            <div class="form-check form-check-inline">
              <input type="radio" name="activation_type" id="activation_email" value="email" class="form-check-input" {if $system['activation_type'] == "email"}checked{/if}>
              <label class="form-check-label" for="activation_email">{__("Email")}</label>
            </div>
            <div class="form-check form-check-inline">
              <input type="radio" name="activation_type" id="activation_sms" value="sms" class="form-check-input" {if $system['activation_type'] == "sms"}checked{/if}>
              <label class="form-check-label" for="activation_sms">{__("SMS")}</label>
            </div>
            <div class="form-text">
              {__("Select Email or SMS activation to send activation code to user's email/phone")}<br>
              {__("Make sure you have configured")} <a href="{$system['system_url']}/{$control_panel['url']}/settings/sms">{__("SMS Settings")}</a>
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="verification" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Users Approval System")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the approval system On and Off (If disabled all users will be approved by default)")}<br>
              {__("If enabled, users will be pending for approval by the admin or moderators")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="users_approval_enabled">
              <input type="checkbox" name="users_approval_enabled" id="users_approval_enabled" {if $system['users_approval_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="locked" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Whitelist Enabled")}</div>
            <div class="form-text d-none d-sm-block">
              {__("If enabled, only users with whitelisted email providers will be able to register")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="whitelist_enabled">
              <input type="checkbox" name="whitelist_enabled" id="whitelist_enabled" {if $system['whitelist_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Whitelisted Providers")}
          </label>
          <div class="col-md-9">
            <textarea class="js_tagify x-hidden" name="whitelist_providers" rows="3">{$system['whitelist_providers']}</textarea>
            <div class="form-text">
              {__("Enter the email providers that you want to whitelist")} ({__("Example: gmail.com")})
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="age_limit" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Age Restriction")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable/Disable age restriction")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="age_restriction">
              <input type="checkbox" name="age_restriction" id="age_restriction" {if $system['age_restriction']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Minimum Age")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="minimum_age" value="{$system['minimum_age']}">
            <div class="form-text">
              {__("The minimum age required to register (in years)")}
            </div>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <img height="40px" src="{$system['system_url']}/content/themes/{$system['theme']}/images/icons/ageverif.png">
          </div>
          <div>
            <div class="form-label h6">{__("AgeVerif Enbaled")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable/Disable age verification using AgeVerify.com")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="ageverif_enabled">
              <input type="checkbox" name="ageverif_enabled" id="ageverif_enabled" {if $system['ageverif_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("AgeVerif API Key")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="ageverif_api_key" value="{$system['ageverif_api_key']}">
            <div class="form-text">
              {__("The AgeVerif API Key")} ({__("Check the docs to learn how to get this key")})
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="getting_started" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Getting Started")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable/Disable getting started page after registration")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="getting_started">
              <input type="checkbox" name="getting_started" id="getting_started" {if $system['getting_started']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Required Data")}
          </label>
          <div class="col-md-9">
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="getting_started_profile_image_required" id="getting_started_profile_image_required" {if $system['getting_started_profile_image_required']}checked{/if}>
              <label class="form-check-label" for="getting_started_profile_image_required">{__("Profile Image Required")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="getting_started_location_required" id="getting_started_location_required" {if $system['getting_started_location_required']}checked{/if}>
              <label class="form-check-label" for="getting_started_location_required">{__("Location Data Required")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="getting_started_work_required" id="getting_started_work_required" {if $system['getting_started_work_required']}checked{/if}>
              <label class="form-check-label" for="getting_started_work_required">{__("Work Data Required")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="getting_started_education_required" id="getting_started_education_required" {if $system['getting_started_education_required']}checked{/if}>
              <label class="form-check-label" for="getting_started_education_required">{__("Education Data Required")}</label>
            </div>
            <span class="form-text mt10">
              {__("Such data will be mandatory when user getting started")}
            </span>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="newsletter" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Newsletter Consent")} ({__("GDPR")})</div>
            <div class="form-text d-none d-sm-block">{__("Enable/Disable newsletter consent during the registration")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="newsletter_consent">
              <input type="checkbox" name="newsletter_consent" id="newsletter_consent" {if $system['newsletter_consent']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Max Accounts/IP")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="max_accounts" value="{$system['max_accounts']}">
            <div class="form-text">
              {__("The Maximum number of accounts allowed to register per IP (0 for unlimited)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Name Minimum Length")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="name_min_length" value="{$system['name_min_length']}">
            <div class="form-text">
              {__("The First and Last name minimum length")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Name Maximum Length")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="name_max_length" value="{$system['name_max_length']}">
            <div class="form-text">
              {__("The First and Last name maximum length")}
            </div>
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
  </div>
  <!-- General -->

  <!-- Social -->
  <div class="tab-pane" id="Social">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=social_login">
      <div class="card-body">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="social_share" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Social Logins")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn registration/login via social media (Facebook, Twitter and etc) On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="social_login_enabled">
              <input type="checkbox" name="social_login_enabled" id="social_login_enabled" {if $system['social_login_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <!-- facebook -->
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="facebook" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Facebook")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn registration/login via Facebook On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="facebook_login_enabled">
              <input type="checkbox" name="facebook_login_enabled" id="facebook_login_enabled" {if $system['facebook_login_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Facebook App ID")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="facebook_appid" value="{$system['facebook_appid']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Facebook App Secret")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="facebook_secret" value="{$system['facebook_secret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>
        <!-- facebook -->

        <div class="divider"></div>

        <!-- google -->
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="google" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Google")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn registration/login via Google On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="google_login_enabled">
              <input type="checkbox" name="google_login_enabled" id="google_login_enabled" {if $system['google_login_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Google App ID")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="google_appid" value="{$system['google_appid']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Google App Secret")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="google_secret" value="{$system['google_secret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>
        <!-- google -->

        <div class="divider"></div>

        <!-- X -->
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="x" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("X")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn registration/login via X On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="twitter_login_enabled">
              <input type="checkbox" name="twitter_login_enabled" id="twitter_login_enabled" {if $system['twitter_login_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("X API Key")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="twitter_appid" value="{$system['twitter_appid']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("X API Secret")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="twitter_secret" value="{$system['twitter_secret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>
        <!-- X -->

        <div class="divider"></div>

        <!-- linkedin -->
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="linkedin" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Linkedin")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn registration/login via Linkedin On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="linkedin_login_enabled">
              <input type="checkbox" name="linkedin_login_enabled" id="linkedin_login_enabled" {if $system['linkedin_login_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Linkedin App ID")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="linkedin_appid" value="{$system['linkedin_appid']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Linkedin App Secret")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="linkedin_secret" value="{$system['linkedin_secret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>
        <!-- linkedin -->

        <div class="divider"></div>

        <!-- vk -->
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="vk" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Vkontakte")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn registration/login via Vkontakte On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="vkontakte_login_enabled">
              <input type="checkbox" name="vkontakte_login_enabled" id="vkontakte_login_enabled" {if $system['vkontakte_login_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Vkontakte App ID")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="vkontakte_appid" value="{$system['vkontakte_appid']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Vkontakte Secure Key")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="vkontakte_secret" value="{$system['vkontakte_secret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>
        <!-- vk -->

        <div class="divider"></div>

        <!-- wordpress -->
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="wordpress" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("WordPress")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn registration/login via WordPress On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="wordpress_login_enabled">
              <input type="checkbox" name="wordpress_login_enabled" id="wordpress_login_enabled" {if $system['wordpress_login_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("WordPress Client ID")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="wordpress_appid" value="{$system['wordpress_appid']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("WordPress Client Secret")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="wordpress_secret" value="{$system['wordpress_secret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>
        <!-- wordpress -->

        <div class="divider"></div>

        <!-- Sngine -->
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="developers" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Sngine")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn registration/login via other Sngine website On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="sngine_login_enabled">
              <input type="checkbox" name="sngine_login_enabled" id="sngine_login_enabled" {if $system['sngine_login_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Sngine App ID")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="sngine_appid" value="{$system['sngine_appid']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Sngine App Secret")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="sngine_secret" value="{$system['sngine_secret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Sngine App Domain")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="sngine_app_domain" value="{$system['sngine_app_domain']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("Please enter your Sngine App Domain without http:// or https://")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Sngine App Name")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="sngine_app_name" value="{$system['sngine_app_name']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Sngine App Icon")}
          </label>
          <div class="col-md-9">
            {if $system['sngine_app_icon'] == ''}
              <div class="x-image">
                <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-uploader-input" name="sngine_app_icon" value="">
              </div>
            {else}
              <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$system['sngine_app_icon']}')">
                <button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'></button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-uploader-input" name="sngine_app_icon" value="{$system['sngine_app_icon']}">
              </div>
            {/if}
          </div>
        </div>
        <!-- Sngine -->

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
  </div>
  <!-- Social -->
</div>
<!-- tabs content -->