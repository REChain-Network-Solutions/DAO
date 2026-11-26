<section class="admin-settings-page" aria-labelledby="settings-accounts-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-accounts-title" class="text-2xl font-semibold">{__("Accounts Settings")}</h1>
    <p class="text-base-content/60 text-sm">{__("Account defaults, profiles, and privacy.")}</p>
  </div>
  <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Accounts Settings")}" aria-orientation="vertical">
    <button type="button" id="settings-accounts-tab-0" class="tab active-tab:tab-active active" data-tab="#General" aria-controls="General" role="tab" aria-selected="true"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("General")}</button>
    <button type="button" id="settings-accounts-tab-1" class="tab active-tab:tab-active" data-tab="#Profile" aria-controls="Profile" role="tab" aria-selected="false"><span class="icon-[tabler--user] size-4" aria-hidden="true"></span>{__("Profile")}</button>
    <button type="button" id="settings-accounts-tab-2" class="tab active-tab:tab-active" data-tab="#Privacy" aria-controls="Privacy" role="tab" aria-selected="false"><span class="icon-[tabler--lock] size-4" aria-hidden="true"></span>{__("Privacy")}</button>
  </nav>
  <div class="admin-settings-panel js_admin-settings-panel" id="General" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=accounts">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-accounts-general-card-0">
              <h3 id="settings-accounts-general-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--users] size-5" aria-hidden="true"></span>
                {__("Connections")}
              </h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="registration" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="friends_enabled">{__("Friends System")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="friends_enabled-help">{__("if disabled only following system will be available")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="friends_enabled" id="friends_enabled" {if $system['friends_enabled']}checked{/if} aria-describedby="friends_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="followings" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="disable_declined_friendrequest">{__("Disable Friend Request After Decline")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="disable_declined_friendrequest-help">{__("If enabled, user A will not be able to send a friend request to user B again after it is declined")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="disable_declined_friendrequest" id="disable_declined_friendrequest" {if $system['disable_declined_friendrequest']}checked{/if} aria-describedby="disable_declined_friendrequest-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="max_friends">{__("Max Friends/User")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="max_friends" id="max_friends" value="{$system['max_friends']}" aria-describedby="max_friends-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="max_friends-help">{__("The Maximum number of friends allowed per User (0 for unlimited)")}</div>
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-accounts-general-card-1">
              <h3 id="settings-accounts-general-card-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--user-circle] size-5" aria-hidden="true"></span>
                {__("Accounts")}
              </h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="accounts_switcher" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="switch_accounts_enabled">{__("Switch Accounts")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="switch_accounts_enabled-help">{__("Allow users to switch between multiple accounts")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="switch_accounts_enabled" id="switch_accounts_enabled" {if $system['switch_accounts_enabled']}checked{/if} aria-describedby="switch_accounts_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="genders" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="genders_disabled">{__("Disable Genders")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="genders_disabled-help">{__("If disabled genders will be hidden for the users")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="genders_disabled" id="genders_disabled" {if $system['genders_disabled']}checked{/if} aria-describedby="genders_disabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="username" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="show_usernames_enabled">{__("Show Usernames Only")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="show_usernames_enabled-help">{__("If disabled full names will be displayed instead")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="show_usernames_enabled" id="show_usernames_enabled" {if $system['show_usernames_enabled']}checked{/if} aria-describedby="show_usernames_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="username" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="disable_username_changes">{__("Disable Username Changes")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="disable_username_changes-help">{__("If enabled users will not be able to change their usernames")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="disable_username_changes" id="disable_username_changes" {if $system['disable_username_changes']}checked{/if} aria-describedby="disable_username_changes-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="special_characters" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="special_characters_enabled">{__("Allow Special Characters")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="special_characters_enabled-help">{__("Allow special Characters in user's first & last name")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="special_characters_enabled" id="special_characters_enabled" {if $system['special_characters_enabled']}checked{/if} aria-describedby="special_characters_enabled-help">
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-accounts-general-card-2">
              <h3 id="settings-accounts-general-card-2" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--shield-lock] size-5" aria-hidden="true"></span>
                {__("GDPR")}
              </h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="delete_user" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="delete_accounts_enabled">{__("Delete Account")} ({__("GDPR")})</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="delete_accounts_enabled-help">{__("Allow users to delete their account")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="delete_accounts_enabled" id="delete_accounts_enabled" {if $system['delete_accounts_enabled']}checked{/if} aria-describedby="delete_accounts_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="user_information" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="download_info_enabled">{__("Download User Information")} ({__("GDPR")})</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="download_info_enabled-help">{__("Allow users to download their account information from settings page")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="download_info_enabled" id="download_info_enabled" {if $system['download_info_enabled']}checked{/if} aria-describedby="download_info_enabled-help">
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-accounts-general-card-3">
              <h3 id="settings-accounts-general-card-3" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--rosette-discount-check] size-5" aria-hidden="true"></span>
                {__("Verification")}
              </h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="verification" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="verification_requests">{__("Verification Requests")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="verification_requests-help">{__("Turn the verification requests from users & pages On and Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="verification_requests" id="verification_requests" {if $system['verification_requests']}checked{/if} aria-describedby="verification_requests-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="verification" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="verification_docs_required">{__("Verification Documents")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="verification_docs_required-help">{__("Enable it to make verification documents required")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="verification_docs_required" id="verification_docs_required" {if $system['verification_docs_required']}checked{/if} aria-describedby="verification_docs_required-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="verification" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="verification_for_posts">{__("Required for Posts")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="verification_for_posts-help">{__("If enabled then verification will be required to publish posts")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="verification_for_posts" id="verification_for_posts" {if $system['verification_for_posts']}checked{/if} aria-describedby="verification_for_posts-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="verification" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="verification_for_monetization">{__("Required for Monetization")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="verification_for_monetization-help">{__("If enabled then verification will be required to enable monetization")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="verification_for_monetization" id="verification_for_monetization" {if $system['verification_for_monetization']}checked{/if} aria-describedby="verification_for_monetization-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="verification" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="verification_for_adult_content">{__("Required for Adult Content")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="verification_for_adult_content-help">{__("If enabled then verification will be required to share or consume adult content")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="verification_for_adult_content" id="verification_for_adult_content" {if $system['verification_for_adult_content']}checked{/if} aria-describedby="verification_for_adult_content-help">
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-accounts-general-card-4">
              <h3 id="settings-accounts-general-card-4" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--id] size-5" aria-hidden="true"></span>
                {__("Verification Documents")}
              </h3>
              <div class="admin-setting-help text-sm leading-relaxed">{__("The documents requested when verification documents are required, switch off any document you do not need")}</div>
              <div class="admin-settings-fields-grid grid grid-cols-1 items-start gap-5 md:grid-cols-2">
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="verification_user_photo_title">{__("Users First Document")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="flex min-w-0 items-center gap-3">
                      <input type="text" class="input w-full" name="verification_user_photo_title" id="verification_user_photo_title" maxlength="64" value="{$system['verification_user_photo_title']}">
                      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="verification_user_photo_enabled" {if $system['verification_user_photo_enabled']}checked{/if} aria-label="{__("Enabled")}" title="{__("Enabled")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="verification_user_passport_title">{__("Users Second Document")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="flex min-w-0 items-center gap-3">
                      <input type="text" class="input w-full" name="verification_user_passport_title" id="verification_user_passport_title" maxlength="64" value="{$system['verification_user_passport_title']}">
                      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="verification_user_passport_enabled" {if $system['verification_user_passport_enabled']}checked{/if} aria-label="{__("Enabled")}" title="{__("Enabled")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="verification_page_photo_title">{__("Pages First Document")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="flex min-w-0 items-center gap-3">
                      <input type="text" class="input w-full" name="verification_page_photo_title" id="verification_page_photo_title" maxlength="64" value="{$system['verification_page_photo_title']}">
                      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="verification_page_photo_enabled" {if $system['verification_page_photo_enabled']}checked{/if} aria-label="{__("Enabled")}" title="{__("Enabled")}">
                    </div>
                  </div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="verification_page_passport_title">{__("Pages Second Document")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="flex min-w-0 items-center gap-3">
                      <input type="text" class="input w-full" name="verification_page_passport_title" id="verification_page_passport_title" maxlength="64" value="{$system['verification_page_passport_title']}">
                      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="verification_page_passport_enabled" {if $system['verification_page_passport_enabled']}checked{/if} aria-label="{__("Enabled")}" title="{__("Enabled")}">
                    </div>
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
  </div>
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="Profile" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=profile">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-accounts-profile-card-0">
              <h3 id="settings-accounts-profile-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--user-circle] size-5" aria-hidden="true"></span>
                {__("Profile Info")}
              </h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="relationship" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="relationship_info_enabled">{__("Relationship Status")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="relationship_info_enabled-help">{__("Turn the Relationship Status On/Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="relationship_info_enabled" id="relationship_info_enabled" {if $system['relationship_info_enabled']}checked{/if} aria-describedby="relationship_info_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="website" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="website_info_enabled">{__("Website")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="website_info_enabled-help">{__("Turn the Website On/Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="website_info_enabled" id="website_info_enabled" {if $system['website_info_enabled']}checked{/if} aria-describedby="website_info_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="biography" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="biography_info_enabled">{__("About Me")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="biography_info_enabled-help">{__("Turn the About Me On/Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="biography_info_enabled" id="biography_info_enabled" {if $system['biography_info_enabled']}checked{/if} aria-describedby="biography_info_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="jobs" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="work_info_enabled">{__("Work Info")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="work_info_enabled-help">{__("Turn the Work info On/Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="work_info_enabled" id="work_info_enabled" {if $system['work_info_enabled']}checked{/if} aria-describedby="work_info_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="map" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="location_info_enabled">{__("Location Info")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="location_info_enabled-help">{__("Turn the Location info On/Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="location_info_enabled" id="location_info_enabled" {if $system['location_info_enabled']}checked{/if} aria-describedby="location_info_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="education" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="education_info_enabled">{__("Education Info")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="education_info_enabled-help">{__("Turn the Education info On/Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="education_info_enabled" id="education_info_enabled" {if $system['education_info_enabled']}checked{/if} aria-describedby="education_info_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="social_share" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="social_info_enabled">{__("Social Links")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="social_info_enabled-help">{__("Turn the Social Links On/Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="social_info_enabled" id="social_info_enabled" {if $system['social_info_enabled']}checked{/if} aria-describedby="social_info_enabled-help">
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-accounts-profile-card-1">
              <h3 id="settings-accounts-profile-card-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--palette] size-5" aria-hidden="true"></span>
                {__("Design")}
              </h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="design" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="system_profile_background_enabled">{__("Profile Design")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="system_profile_background_enabled-help">{__("Allow users to upload background image to their profiles")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="system_profile_background_enabled" id="system_profile_background_enabled" {if $system['system_profile_background_enabled']}checked{/if} aria-describedby="system_profile_background_enabled-help">
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
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="Privacy" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=privacy">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-accounts-privacy-card-0">
              <h3 id="settings-accounts-privacy-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--adjustments-horizontal] size-5" aria-hidden="true"></span>
                {__("General")}
              </h3>
              <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--message-circle] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_chat">{__("Who can message you?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_chat" id="user_privacy_chat">
                    <option {if $system['user_privacy_chat'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_chat'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_chat'] == "me"}selected{/if} value="me">{__("No One")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--hand-finger] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_poke">{__("Who can poke you?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_poke" id="user_privacy_poke">
                    <option {if $system['user_privacy_poke'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_poke'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_poke'] == "me"}selected{/if} value="me">{__("No One")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--gift] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_gifts">{__("Who can send you gifts?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_gifts" id="user_privacy_gifts">
                    <option {if $system['user_privacy_gifts'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_gifts'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_gifts'] == "me"}selected{/if} value="me">{__("No One")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--layout-list] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_wall">{__("Who can post on your wall?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_wall" id="user_privacy_wall">
                    <option {if $system['user_privacy_wall'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_wall'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_wall'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--users-plus] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_collaborative">{__("Who can tag you in collaborative posts?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_collaborative" id="user_privacy_collaborative">
                    <option {if $system['user_privacy_collaborative'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_collaborative'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_collaborative'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-accounts-privacy-card-1">
              <h3 id="settings-accounts-privacy-card-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--user-circle] size-5" aria-hidden="true"></span>
                {__("Profile")}
              </h3>
              <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--gender-bigender] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_gender">{__("Who can see your gender?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_gender" id="user_privacy_gender">
                    <option {if $system['user_privacy_gender'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_gender'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_gender'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--heart] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_relationship">{__("Who can see your relationship?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_relationship" id="user_privacy_relationship">
                    <option {if $system['user_privacy_relationship'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_relationship'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_relationship'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--cake] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_birthdate">{__("Who can see your birthdate?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_birthdate" id="user_privacy_birthdate">
                    <option {if $system['user_privacy_birthdate'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_birthdate'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_birthdate'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--id-badge-2] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_basic">{__("Who can see your basic info?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_basic" id="user_privacy_basic">
                    <option {if $system['user_privacy_basic'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_basic'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_basic'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--briefcase] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_work">{__("Who can see your work info?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_work" id="user_privacy_work">
                    <option {if $system['user_privacy_work'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_work'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_work'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--map-pin] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_location">{__("Who can see your location info?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_location" id="user_privacy_location">
                    <option {if $system['user_privacy_location'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_location'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_location'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--school] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_education">{__("Who can see your education info?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_education" id="user_privacy_education">
                    <option {if $system['user_privacy_education'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_education'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_education'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--dots] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_other">{__("Who can see your other info?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_other" id="user_privacy_other">
                    <option {if $system['user_privacy_other'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_other'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_other'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--users] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_friends">{__("Who can see your friends?")}{if !$system['friends_enabled']} <span class="badge badge-soft badge-primary">{__("Disabled")}</span>{/if}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_friends" id="user_privacy_friends">
                    <option {if $system['user_privacy_friends'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_friends'] == "friends"}selected{/if} value="friends">{__("Friends")}</option>
                    <option {if $system['user_privacy_friends'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--user-heart] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_followers">{__("Who can see your followers/followings?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_followers" id="user_privacy_followers">
                    <option {if $system['user_privacy_followers'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_followers'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_followers'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--crown] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_subscriptions">{__("Who can see your subscriptions?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_subscriptions" id="user_privacy_subscriptions">
                    <option {if $system['user_privacy_subscriptions'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_subscriptions'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_subscriptions'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-accounts-privacy-card-2">
              <h3 id="settings-accounts-privacy-card-2" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--photo] size-5" aria-hidden="true"></span>
                {__("Content")}
              </h3>
              <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--photo] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_photos">{__("Who can see your photos?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_photos" id="user_privacy_photos">
                    <option {if $system['user_privacy_photos'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_photos'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_photos'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--flag] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_pages">{__("Who can see your liked pages?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_pages" id="user_privacy_pages">
                    <option {if $system['user_privacy_pages'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_pages'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_pages'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--users-group] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_groups">{__("Who can see your joined groups?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_groups" id="user_privacy_groups">
                    <option {if $system['user_privacy_groups'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_groups'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_groups'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
                </div>
                <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4 js_admin-setting-field">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--calendar-event] size-5"></span>
                  </span>
                  <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_events">{__("Who can see your joined events?")}</label>
                  <select class="select w-full shrink-0 sm:w-48" name="user_privacy_events" id="user_privacy_events">
                    <option {if $system['user_privacy_events'] == "public"}selected{/if} value="public">{__("Everyone")}</option>
                    <option {if $system['user_privacy_events'] == "friends"}selected{/if} value="friends">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    <option {if $system['user_privacy_events'] == "me"}selected{/if} value="me">{__("Just Me")}</option>
                  </select>
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
