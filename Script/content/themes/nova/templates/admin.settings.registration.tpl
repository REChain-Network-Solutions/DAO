<section class="admin-settings-page" aria-labelledby="settings-registration-title">
  <!-- card-header -->
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-registration-title" class="text-2xl font-semibold">
      {__("Registration Settings")}
      {capture assign="_tip"}{__("If Registration is Free and Pro Packages enabled they will be used as optional upgrading plans")}.{/capture}
      {include file='__admin_tip.tpl' _tip_id="settings-registration-tip" _tip_text=$_tip}
    </h1>
    <p class="text-base-content/60 text-sm">{__("Sign-up rules and social login providers.")}</p>
  </div>
  <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Registration Settings")}" aria-orientation="vertical">
    <button type="button" id="settings-registration-tab-0" class="tab active-tab:tab-active active" data-tab="#General" aria-controls="General" role="tab" aria-selected="true"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("General")}</button>
    <button type="button" id="settings-registration-tab-1" class="tab active-tab:tab-active" data-tab="#Social" aria-controls="Social" role="tab" aria-selected="false"><span class="icon-[tabler--share] size-4" aria-hidden="true"></span>{__("Social Login")}</button>
  </nav>
  <!-- card-header -->
  <!-- tabs content -->
  <div class="tab-content">
    <!-- General -->
    <div class="admin-settings-panel js_admin-settings-panel" id="General" role="tabpanel" aria-labelledby="settings-registration-tab-0" tabindex="0">
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=registration">
                <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">

          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-registration-card-0">
          <h3 id="settings-registration-registration-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Registration and user groups")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="registration" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="registration_enabled">{__("Registration")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="registration_enabled-help">
                    {__("Allow users to create accounts")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="registration_enabled" id="registration_enabled" {if $system['registration_enabled']}checked{/if} class="switch switch-primary" aria-describedby="registration_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-registration-field-1-label">
                <div class="label-text" id="settings-registration-field-1-label">
                  {__("Registration Type")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="registration_type" id="registration_free" value="free" class="radio radio-primary" {if $system['registration_type'] == "free"}checked{/if} aria-describedby="settings-registration-field-1-help">
                    <label class="label-text" for="registration_free">{__("Free")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="registration_type" id="registration_paid" value="paid" class="radio radio-primary" {if $system['registration_type'] == "paid"}checked{/if} aria-describedby="settings-registration-field-1-help">
                    <label class="label-text" for="registration_paid">{__("Subscriptions Only")}</label>
                  </div>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-1-help">
                    {__("Allow users to create accounts Free or via Subscriptions only")}
                    <br>
                    {__("Make sure you have configured")}
                    <a href="{$system['system_url']}/{$control_panel['url']}/pro">{__("Pro System")}</a>
                  </div>
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="groups" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="select_user_group_enabled">{__("User Can Select Custom User Group")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="select_user_group_enabled-help">
                    {__("Allow users to select custom user group during registration")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="select_user_group_enabled" id="select_user_group_enabled" {if $system['select_user_group_enabled']}checked{/if} class="switch switch-primary" aria-describedby="select_user_group_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="groups" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="show_user_group_enabled">{__("Show Custom User Group Badge")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="show_user_group_enabled-help">
                    {__("Show user group badge on profile page")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="show_user_group_enabled" id="show_user_group_enabled" {if $system['show_user_group_enabled']}checked{/if} class="switch switch-primary" aria-describedby="show_user_group_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-2-label" for="settings-registration-field-2">
                  {__("Default User Group")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="default_custom_user_group" id="settings-registration-field-2" aria-describedby="settings-registration-field-2-help">
                    <option value="0" {if $system['default_custom_user_group'] == '0'}selected{/if}>
                    {__("Users")}
                    </option>
                    {foreach $user_groups as $user_group}
                    <option value="{$user_group['user_group_id']}" {if $system['default_custom_user_group'] == $user_group['user_group_id']}selected{/if}>
                    {$user_group['user_group_title']}
                    </option>
                    {/foreach}
                  </select>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-2-help">
                    {__("Select the default user group for new accounts")}
                    <br>
                    {__("You can manage users groups from")}
                    <a href="{$system['system_url']}/{$control_panel['url']}/users_groups">{__("User Groups")}</a>
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-registration-card-1">
          <h3 id="settings-registration-registration-card-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Invitations")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="invitation" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="invitation_enabled">{__("Invitation System")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="invitation_enabled-help">
                    {__("This option is used to register the users by invitation codes only")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="invitation_enabled" id="invitation_enabled" {if $system['invitation_enabled']}checked{/if} class="switch switch-primary" aria-describedby="invitation_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-registration-field-3-label">
                <div class="label-text" id="settings-registration-field-3-label">
                  {__("Invitations/User")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-split-control flex min-w-0 items-stretch gap-2">
                    <input class="input w-full" name="invitation_user_limit" value="{$system['invitation_user_limit']}" aria-describedby="settings-registration-field-3-help" aria-labelledby="settings-registration-field-3-label">
                    <select class="select" name="invitation_expire_period" aria-describedby="settings-registration-field-3-help" aria-labelledby="settings-registration-field-3-label">
                      <option {if $system['invitation_expire_period'] == "hour"}selected{/if} value="hour">{__("Hour")}</option>
                      <option {if $system['invitation_expire_period'] == "day"}selected{/if} value="day">{__("Day")}</option>
                      <option {if $system['invitation_expire_period'] == "week"}selected{/if} value="week">{__("Week")}</option>
                      <option {if $system['invitation_expire_period'] == "month"}selected{/if} value="month">{__("Month")}</option>
                      <option {if $system['invitation_expire_period'] == "year"}selected{/if} value="year">{__("Year")}</option>
                    </select>
                  </div>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-3-help">
                    {__("Number of invitation codes allowed to each user (0 for unlimited) ")}
                    <br>
                    {__("For example 1 code per day, 5 codes per month")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-registration-field-4-label">
                <div class="label-text" id="settings-registration-field-4-label">
                  {__("Send Method")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="invitation_send_method" id="invitation_email" value="email" class="radio radio-primary" {if $system['invitation_send_method'] == "email"}checked{/if} aria-describedby="settings-registration-field-4-help">
                    <label class="label-text" for="invitation_email">{__("Email")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="invitation_send_method" id="invitation_sms" value="sms" class="radio radio-primary" {if $system['invitation_send_method'] == "sms"}checked{/if} aria-describedby="settings-registration-field-4-help">
                    <label class="label-text" for="invitation_sms">{__("SMS")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="invitation_send_method" id="invitation_both" value="both" class="radio radio-primary" {if $system['invitation_send_method'] == "both"}checked{/if} aria-describedby="settings-registration-field-4-help">
                    <label class="label-text" for="invitation_both">{__("Both")}</label>
                  </div>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-4-help">
                    {__("Select Email or SMS to send invitation link to new user's email/phone")}
                    <br>
                    {__("Make sure you have configured")}
                    <a href="{$system['system_url']}/{$control_panel['url']}/settings/sms">{__("SMS Settings")}</a>
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-registration-card-2">
          <h3 id="settings-registration-registration-card-2" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Activation and approval")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="account_activation" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="activation_enabled">{__("Activation Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="activation_enabled-help">
                    {__("Enable account activation to send activation code to user's email/phone")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="activation_enabled" id="activation_enabled" {if $system['activation_enabled']}checked{/if} class="switch switch-primary" aria-describedby="activation_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="adblock" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="activation_required">{__("Activation Required")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="activation_required-help">
                    {__("Enable this and user will not be able to access without activation")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="activation_required" id="activation_required" {if $system['activation_required']}checked{/if} class="switch switch-primary" aria-describedby="activation_required-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-registration-field-5-label">
                <div class="label-text" id="settings-registration-field-5-label">
                  {__("Activation Type")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="activation_type" id="activation_email" value="email" class="radio radio-primary" {if $system['activation_type'] == "email"}checked{/if} aria-describedby="settings-registration-field-5-help">
                    <label class="label-text" for="activation_email">{__("Email")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="activation_type" id="activation_sms" value="sms" class="radio radio-primary" {if $system['activation_type'] == "sms"}checked{/if} aria-describedby="settings-registration-field-5-help">
                    <label class="label-text" for="activation_sms">{__("SMS")}</label>
                  </div>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-5-help">
                    {__("Select Email or SMS activation to send activation code to user's email/phone")}
                    <br>
                    {__("Make sure you have configured")}
                    <a href="{$system['system_url']}/{$control_panel['url']}/settings/sms">{__("SMS Settings")}</a>
                  </div>
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="verification" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="users_approval_enabled">{__("Users Approval System")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="users_approval_enabled-help">
                    {__("Turn the approval system On and Off (If disabled all users will be approved by default)")}
                    <br>
                    {__("If enabled, users will be pending for approval by the admin or moderators")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="users_approval_enabled" id="users_approval_enabled" {if $system['users_approval_enabled']}checked{/if} class="switch switch-primary" aria-describedby="users_approval_enabled-help">
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-registration-card-3">
          <h3 id="settings-registration-registration-card-3" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Email providers")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="locked" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="whitelist_enabled">{__("Whitelist Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="whitelist_enabled-help">
                    {__("If enabled, only users with whitelisted email providers will be able to register")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="whitelist_enabled" id="whitelist_enabled" {if $system['whitelist_enabled']}checked{/if} class="switch switch-primary" aria-describedby="whitelist_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-6-label" for="settings-registration-field-6">
                  {__("Whitelisted Providers")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <textarea class="js_tagify textarea w-full" name="whitelist_providers" rows="3" id="settings-registration-field-6" aria-describedby="settings-registration-field-6-help">{$system['whitelist_providers']}</textarea>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-6-help">
                    {__("Enter the email providers that you want to whitelist")} ({__("Example: gmail.com")})
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-registration-card-4">
          <h3 id="settings-registration-registration-card-4" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Age verification")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="age_limit" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="age_restriction">{__("Age Restriction")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="age_restriction-help">
                    {__("Enable/Disable age restriction")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="age_restriction" id="age_restriction" {if $system['age_restriction']}checked{/if} class="switch switch-primary" aria-describedby="age_restriction-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-7-label" for="settings-registration-field-7">
                  {__("Minimum Age")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="minimum_age" value="{$system['minimum_age']}" id="settings-registration-field-7" aria-describedby="settings-registration-field-7-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-7-help">
                    {__("The minimum age required to register (in years)")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  <img height="40px" src="{$system['system_url']}/content/themes/{$system['theme']}/images/svg/services/ageverif.png">
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="ageverif_enabled">{__("AgeVerif Enbaled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="ageverif_enabled-help">
                    {__("Enable/Disable age verification using AgeVerify.com")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="ageverif_enabled" id="ageverif_enabled" {if $system['ageverif_enabled']}checked{/if} class="switch switch-primary" aria-describedby="ageverif_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-8-label" for="settings-registration-field-8">
                  {__("AgeVerif API Key")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="ageverif_api_key" value="{$system['ageverif_api_key']}" id="settings-registration-field-8" aria-describedby="settings-registration-field-8-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-8-help">
                    {__("The AgeVerif API Key")} ({__("Check the docs to learn how to get this key")})
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-registration-card-5">
          <h3 id="settings-registration-registration-card-5" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Onboarding and consent")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="getting_started" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="getting_started">{__("Getting Started")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="getting_started-help">
                    {__("Enable/Disable getting started page after registration")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="getting_started" id="getting_started" {if $system['getting_started']}checked{/if} class="switch switch-primary" aria-describedby="getting_started-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-registration-field-9-label">
                <div class="label-text" id="settings-registration-field-9-label">
                  {__("Required Data")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="getting_started_profile_image_required" id="getting_started_profile_image_required" {if $system['getting_started_profile_image_required']}checked{/if} aria-describedby="settings-registration-field-9-help">
                    <label class="label-text" for="getting_started_profile_image_required">{__("Profile Image Required")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="getting_started_location_required" id="getting_started_location_required" {if $system['getting_started_location_required']}checked{/if} aria-describedby="settings-registration-field-9-help">
                    <label class="label-text" for="getting_started_location_required">{__("Location Data Required")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="getting_started_work_required" id="getting_started_work_required" {if $system['getting_started_work_required']}checked{/if} aria-describedby="settings-registration-field-9-help">
                    <label class="label-text" for="getting_started_work_required">{__("Work Data Required")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="getting_started_education_required" id="getting_started_education_required" {if $system['getting_started_education_required']}checked{/if} aria-describedby="settings-registration-field-9-help">
                    <label class="label-text" for="getting_started_education_required">{__("Education Data Required")}</label>
                  </div>
                  <span class="admin-setting-help text-sm leading-relaxed mt-2.5" id="settings-registration-field-9-help">
                    {__("Such data will be mandatory when user getting started")}
                  </span>
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="newsletter" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="newsletter_consent">{__("Newsletter Consent")} ({__("GDPR")})</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="newsletter_consent-help">
                    {__("Enable/Disable newsletter consent during the registration")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="newsletter_consent" id="newsletter_consent" {if $system['newsletter_consent']}checked{/if} class="switch switch-primary" aria-describedby="newsletter_consent-help">
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-registration-card-6">
          <h3 id="settings-registration-registration-card-6" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Account limits")}
          </h3>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-10-label" for="settings-registration-field-10">
                  {__("Max Accounts/IP")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="max_accounts" value="{$system['max_accounts']}" id="settings-registration-field-10" aria-describedby="settings-registration-field-10-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-10-help">
                    {__("The Maximum number of accounts allowed to register per IP (0 for unlimited)")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-11-label" for="settings-registration-field-11">
                  {__("Name Minimum Length")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="name_min_length" value="{$system['name_min_length']}" id="settings-registration-field-11" aria-describedby="settings-registration-field-11-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-11-help">
                    {__("The First and Last name minimum length")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-12-label" for="settings-registration-field-12">
                  {__("Name Maximum Length")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="name_max_length" value="{$system['name_max_length']}" id="settings-registration-field-12" aria-describedby="settings-registration-field-12-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-12-help">
                    {__("The First and Last name maximum length")}
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
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
          </div>
        </div>
            </section>
          </div>
        </div>
      </form>
    </div>
    <!-- General -->
    <!-- Social -->
    <div class="admin-settings-panel js_admin-settings-panel hidden" id="Social" role="tabpanel" aria-labelledby="settings-registration-tab-1" tabindex="0">
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=social_login">
                <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">

          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-social_login-card-0">
          <h3 id="settings-registration-social_login-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Social login")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="social_share" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="social_login_enabled">{__("Social Logins")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="social_login_enabled-help">
                    {__("Turn registration/login via social media (Facebook, Twitter and etc) On and Off")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="social_login_enabled" id="social_login_enabled" {if $system['social_login_enabled']}checked{/if} class="switch switch-primary" aria-describedby="social_login_enabled-help">
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-social_login-card-1">
          <h3 id="settings-registration-social_login-card-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Apple")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="apple" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="apple_login_enabled">{__("Apple")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="apple_login_enabled-help">
                    {__("Turn registration/login via Sign in with Apple On and Off")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="apple_login_enabled" id="apple_login_enabled" {if $system['apple_login_enabled']}checked{/if} class="switch switch-primary" aria-describedby="apple_login_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-13-label" for="settings-registration-field-13">
                  {__("Apple Services ID")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="apple_appid" value="{$system['apple_appid']}" placeholder="com.example.web" id="settings-registration-field-13" aria-describedby="settings-registration-field-13-help">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-13" aria-describedby="settings-registration-field-13-help">
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-13-help">
                    {__("The Services ID (client identifier) from your Apple Developer account")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-14-label" for="settings-registration-field-14">
                  {__("Apple Team ID")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="apple_team_id" value="{$system['apple_team_id']}" id="settings-registration-field-14">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-14">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-15-label" for="settings-registration-field-15">
                  {__("Apple Key ID")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="apple_key_id" value="{$system['apple_key_id']}" id="settings-registration-field-15">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-15">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-16-label" for="settings-registration-field-16">
                  {__("Apple Private Key")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <textarea class="textarea w-full" name="apple_key_content" rows="6" placeholder="-----BEGIN PRIVATE KEY-----" id="settings-registration-field-16" aria-describedby="settings-registration-field-16-help">{$system['apple_key_content']}</textarea>
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-16" aria-describedby="settings-registration-field-16-help">
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-16-help">
                    {__("Paste the contents of the .p8 key file created for Sign in with Apple")}
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-social_login-card-2">
          <h3 id="settings-registration-social_login-card-2" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Google")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="google" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="google_login_enabled">{__("Google")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="google_login_enabled-help">
                    {__("Turn registration/login via Google On and Off")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="google_login_enabled" id="google_login_enabled" {if $system['google_login_enabled']}checked{/if} class="switch switch-primary" aria-describedby="google_login_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-17-label" for="settings-registration-field-17">
                  {__("Google App ID")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="google_appid" value="{$system['google_appid']}" id="settings-registration-field-17">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-17">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-18-label" for="settings-registration-field-18">
                  {__("Google App Secret")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="google_secret" value="{$system['google_secret']}" id="settings-registration-field-18">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-18">
                  {/if}
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-social_login-card-3">
          <h3 id="settings-registration-social_login-card-3" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Facebook")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="facebook" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="facebook_login_enabled">{__("Facebook")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="facebook_login_enabled-help">
                    {__("Turn registration/login via Facebook On and Off")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="facebook_login_enabled" id="facebook_login_enabled" {if $system['facebook_login_enabled']}checked{/if} class="switch switch-primary" aria-describedby="facebook_login_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-19-label" for="settings-registration-field-19">
                  {__("Facebook App ID")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="facebook_appid" value="{$system['facebook_appid']}" id="settings-registration-field-19">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-19">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-20-label" for="settings-registration-field-20">
                  {__("Facebook App Secret")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="facebook_secret" value="{$system['facebook_secret']}" id="settings-registration-field-20">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-20">
                  {/if}
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-social_login-card-4">
          <h3 id="settings-registration-social_login-card-4" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("X")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="x" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="twitter_login_enabled">{__("X")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="twitter_login_enabled-help">
                    {__("Turn registration/login via X On and Off")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="twitter_login_enabled" id="twitter_login_enabled" {if $system['twitter_login_enabled']}checked{/if} class="switch switch-primary" aria-describedby="twitter_login_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-21-label" for="settings-registration-field-21">
                  {__("X API Key")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="twitter_appid" value="{$system['twitter_appid']}" id="settings-registration-field-21">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-21">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-22-label" for="settings-registration-field-22">
                  {__("X API Secret")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="twitter_secret" value="{$system['twitter_secret']}" id="settings-registration-field-22">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-22">
                  {/if}
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-social_login-card-5">
          <h3 id="settings-registration-social_login-card-5" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Discord")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="discord" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="discord_login_enabled">{__("Discord")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="discord_login_enabled-help">
                    {__("Turn registration/login via Discord On and Off")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="discord_login_enabled" id="discord_login_enabled" {if $system['discord_login_enabled']}checked{/if} class="switch switch-primary" aria-describedby="discord_login_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-23-label" for="settings-registration-field-23">
                  {__("Discord Application ID")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="discord_appid" value="{$system['discord_appid']}" id="settings-registration-field-23">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-23">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-24-label" for="settings-registration-field-24">
                  {__("Discord Application Secret")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="discord_secret" value="{$system['discord_secret']}" id="settings-registration-field-24">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-24">
                  {/if}
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-social_login-card-6">
          <h3 id="settings-registration-social_login-card-6" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("LinkedIn")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="linkedin" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="linkedin_login_enabled">{__("Linkedin")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="linkedin_login_enabled-help">
                    {__("Turn registration/login via Linkedin On and Off")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="linkedin_login_enabled" id="linkedin_login_enabled" {if $system['linkedin_login_enabled']}checked{/if} class="switch switch-primary" aria-describedby="linkedin_login_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-25-label" for="settings-registration-field-25">
                  {__("Linkedin App ID")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="linkedin_appid" value="{$system['linkedin_appid']}" id="settings-registration-field-25">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-25">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-26-label" for="settings-registration-field-26">
                  {__("Linkedin App Secret")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="linkedin_secret" value="{$system['linkedin_secret']}" id="settings-registration-field-26">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-26">
                  {/if}
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-social_login-card-7">
          <h3 id="settings-registration-social_login-card-7" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Vkontakte")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="vk" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="vkontakte_login_enabled">{__("Vkontakte")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="vkontakte_login_enabled-help">
                    {__("Turn registration/login via Vkontakte On and Off")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="vkontakte_login_enabled" id="vkontakte_login_enabled" {if $system['vkontakte_login_enabled']}checked{/if} class="switch switch-primary" aria-describedby="vkontakte_login_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-27-label" for="settings-registration-field-27">
                  {__("Vkontakte App ID")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="vkontakte_appid" value="{$system['vkontakte_appid']}" id="settings-registration-field-27">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-27">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-28-label" for="settings-registration-field-28">
                  {__("Vkontakte Secure Key")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="vkontakte_secret" value="{$system['vkontakte_secret']}" id="settings-registration-field-28">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-28">
                  {/if}
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-social_login-card-8">
          <h3 id="settings-registration-social_login-card-8" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("WordPress")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="wordpress" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="wordpress_login_enabled">{__("WordPress")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="wordpress_login_enabled-help">
                    {__("Turn registration/login via WordPress On and Off")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="wordpress_login_enabled" id="wordpress_login_enabled" {if $system['wordpress_login_enabled']}checked{/if} class="switch switch-primary" aria-describedby="wordpress_login_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-29-label" for="settings-registration-field-29">
                  {__("WordPress Client ID")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="wordpress_appid" value="{$system['wordpress_appid']}" id="settings-registration-field-29">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-29">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-30-label" for="settings-registration-field-30">
                  {__("WordPress Client Secret")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="wordpress_secret" value="{$system['wordpress_secret']}" id="settings-registration-field-30">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-30">
                  {/if}
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-registration-social_login-card-9">
          <h3 id="settings-registration-social_login-card-9" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Sngine")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="developers" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="sngine_login_enabled">{__("Sngine")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="sngine_login_enabled-help">
                    {__("Turn registration/login via other Sngine website On and Off")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="sngine_login_enabled" id="sngine_login_enabled" {if $system['sngine_login_enabled']}checked{/if} class="switch switch-primary" aria-describedby="sngine_login_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-31-label" for="settings-registration-field-31">
                  {__("Sngine App ID")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="sngine_appid" value="{$system['sngine_appid']}" id="settings-registration-field-31">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-31">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-32-label" for="settings-registration-field-32">
                  {__("Sngine App Secret")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="sngine_secret" value="{$system['sngine_secret']}" id="settings-registration-field-32">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-32">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-33-label" for="settings-registration-field-33">
                  {__("Sngine App Domain")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="sngine_app_domain" value="{$system['sngine_app_domain']}" id="settings-registration-field-33" aria-describedby="settings-registration-field-33-help">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-33" aria-describedby="settings-registration-field-33-help">
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-registration-field-33-help">
                    {__("Please enter your Sngine App Domain without http:// or https://")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-registration-field-34-label" for="settings-registration-field-34">
                  {__("Sngine App Name")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="sngine_app_name" value="{$system['sngine_app_name']}" id="settings-registration-field-34">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-registration-field-34">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-registration-field-35-label">
                <div class="label-text" id="settings-registration-field-35-label">
                  {__("Sngine App Icon")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if $system['sngine_app_icon'] == ''}
                  {include file='__x_image.tpl' _x_name="sngine_app_icon" _x_fit="contain"}
                  {else}
                  {include file='__x_image.tpl' _x_name="sngine_app_icon" _x_value=$system['sngine_app_icon'] _x_fit="contain"}
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
    <!-- Social -->
  </div>
  <!-- tabs content -->
</section>
