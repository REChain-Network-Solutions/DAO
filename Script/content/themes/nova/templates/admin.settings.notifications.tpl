<section class="admin-settings-page" aria-labelledby="settings-notifications-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-notifications-title" class="text-2xl font-semibold">{__("Notifications Settings")}</h1>
    <p class="text-base-content/60 text-sm">{__("Website, email, and push notifications.")}</p>
  </div>
  <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Notifications Settings")}" aria-orientation="vertical">
    <button type="button" id="settings-notifications-tab-0" class="tab active-tab:tab-active active" data-tab="#Website" aria-controls="Website" role="tab" aria-selected="true"><span class="icon-[tabler--bell] size-4" aria-hidden="true"></span>{__("Website Notifications")}</button>
    <button type="button" id="settings-notifications-tab-1" class="tab active-tab:tab-active" data-tab="#Email" aria-controls="Email" role="tab" aria-selected="false"><span class="icon-[tabler--mail] size-4" aria-hidden="true"></span>{__("Email Notifications")}</button>
    <button type="button" id="settings-notifications-tab-2" class="tab active-tab:tab-active" data-tab="#Push" aria-controls="Push" role="tab" aria-selected="false"><span class="icon-[tabler--broadcast] size-4" aria-hidden="true"></span>{__("Push Notifications")}</button>
  </nav>
  <div class="admin-settings-panel js_admin-settings-panel" id="Website" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=website_notifications">
      <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="profile_notifications" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="profile_notification_enabled">{__("Profile Visit Notification")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="profile_notification_enabled-help">{__("Turn the profile visit notification On and Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="profile_notification_enabled" id="profile_notification_enabled" {if $system['profile_notification_enabled']}checked{/if} aria-describedby="profile_notification_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="browser_notifications" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="browser_notifications_enabled">{__("Browser Notifications")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="browser_notifications_enabled-help">{__("Turn the browser notifications On and Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="browser_notifications_enabled" id="browser_notifications_enabled" {if $system['browser_notifications_enabled']}checked{/if} aria-describedby="browser_notifications_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="noty_notifications" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="noty_notifications_enabled">{__("Noty Notifications")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="noty_notifications_enabled-help">
                    {__("Turn the noty notifications On and Off")} (<a target="_blank" href="{$system['system_url']}/content/themes/{$system['theme']}/images/screenshots/noty_notification.png">{__("preview")}</a>)
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="noty_notifications_enabled" id="noty_notifications_enabled" {if $system['noty_notifications_enabled']}checked{/if} aria-describedby="noty_notifications_enabled-help">
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
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="Email" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=email_notifications">
      <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="newsletter" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="email_notifications">{__("Email Notifications")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="email_notifications-help">{__("Enable/Disable email notifications system")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="email_notifications" id="email_notifications" {if $system['email_notifications']}checked{/if} aria-describedby="email_notifications-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="email_user_when-label">
                <div class="label-text" id="email_user_when-label">{__("Email User When")}</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="email_post_likes" id="email_post_likes" {if $system['email_post_likes']}checked{/if}>
                    <label class="label-text" for="email_post_likes">{__("Someone reacted to his post")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="email_post_comments" id="email_post_comments" {if $system['email_post_comments']}checked{/if}>
                    <label class="label-text" for="email_post_comments">{__("Someone commented on his post")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="email_post_shares" id="email_post_shares" {if $system['email_post_shares']}checked{/if}>
                    <label class="label-text" for="email_post_shares">{__("Someone shared his post")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="email_wall_posts" id="email_wall_posts" {if $system['email_wall_posts']}checked{/if}>
                    <label class="label-text" for="email_wall_posts">{__("Someone posted on his timeline")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="email_mentions" id="email_mentions" {if $system['email_mentions']}checked{/if}>
                    <label class="label-text" for="email_mentions">{__("Someone mentioned him")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="email_profile_visits" id="email_profile_visits" {if $system['email_profile_visits']}checked{/if}>
                    <label class="label-text" for="email_profile_visits">{__("Someone visited his profile")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="email_friend_requests" id="email_friend_requests" {if $system['email_friend_requests']}checked{/if}>
                    <label class="label-text" for="email_friend_requests">{__("Someone sent him or accepted his friend requset")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="email_user_verification" id="email_user_verification" {if $system['email_user_verification']}checked{/if}>
                    <label class="label-text" for="email_user_verification">{__("Admin approved/declined my verification requests")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="email_user_post_approval" id="email_user_post_approval" {if $system['email_user_post_approval']}checked{/if}>
                    <label class="label-text" for="email_user_post_approval">{__("Admin approved my pending posts")}</label>
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="email_admin_when-label">
                <div class="label-text" id="email_admin_when-label">{__("Email Admin When")}</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="email_admin_verifications" id="email_admin_verifications" {if $system['email_admin_verifications']}checked{/if}>
                    <label class="label-text" for="email_admin_verifications">{__("Verification request sent by user/page")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="email_admin_post_approval" id="email_admin_post_approval" {if $system['email_admin_post_approval']}checked{/if}>
                    <label class="label-text" for="email_admin_post_approval">{__("Post published and needs approval")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="email_admin_user_approval" id="email_admin_user_approval" {if $system['email_admin_user_approval']}checked{/if}>
                    <label class="label-text" for="email_admin_user_approval">{__("New user needs approval")}</label>
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
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="Push" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=push_notifications">
      <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
              <h3 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Web Apps")}</h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="onesignal" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="onesignal_notification_enabled">{__("OneSignal Push Notifications")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="onesignal_notification_enabled-help">{__("Turn the OneSignal push notification for Web Apps and Web-View Apps")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="onesignal_notification_enabled" id="onesignal_notification_enabled" {if $system['onesignal_notification_enabled']}checked{/if} aria-describedby="onesignal_notification_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="onesignal_notify_button_enabled">{__("Subscription Bell")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="onesignal_notify_button_enabled-help">{__("Show the OneSignal subscription bell icon on the website")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="onesignal_notify_button_enabled" id="onesignal_notify_button_enabled" {if $system['onesignal_notify_button_enabled']}checked{/if} aria-describedby="onesignal_notify_button_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="onesignal_app_id">{__("OneSignal APP ID")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="onesignal_app_id" id="onesignal_app_id" value="{$system['onesignal_app_id']}">
                  {else}
                    <input type="password" class="input w-full" id="onesignal_app_id" value="*********">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="onesignal_api_key">{__("OneSignal REST API Key")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="onesignal_api_key" id="onesignal_api_key" value="{$system['onesignal_api_key']}">
                  {else}
                    <input type="password" class="input w-full" id="onesignal_api_key" value="*********">
                  {/if}
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <h3 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Messaging Apps")}</h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="onesignal" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="onesignal_messenger_notification_enabled">{__("OneSignal Push Notifications")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="onesignal_messenger_notification_enabled-help">{__("Turn the OneSignal push notification for Native Messenger Apps")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="onesignal_messenger_notification_enabled" id="onesignal_messenger_notification_enabled" {if $system['onesignal_messenger_notification_enabled']}checked{/if} aria-describedby="onesignal_messenger_notification_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="onesignal_messenger_app_id">{__("OneSignal APP ID")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="onesignal_messenger_app_id" id="onesignal_messenger_app_id" value="{$system['onesignal_messenger_app_id']}">
                  {else}
                    <input type="password" class="input w-full" id="onesignal_messenger_app_id" value="*********">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="onesignal_messenger_api_key">{__("OneSignal REST API Key")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="onesignal_messenger_api_key" id="onesignal_messenger_api_key" value="{$system['onesignal_messenger_api_key']}">
                  {else}
                    <input type="password" class="input w-full" id="onesignal_messenger_api_key" value="*********">
                  {/if}
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <h3 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Timeline Apps")}</h3>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="onesignal" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="onesignal_timeline_notification_enabled">{__("OneSignal Push Notifications")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="onesignal_timeline_notification_enabled-help">{__("Turn the OneSignal push notification for Native Timeline Apps")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="onesignal_timeline_notification_enabled" id="onesignal_timeline_notification_enabled" {if $system['onesignal_timeline_notification_enabled']}checked{/if} aria-describedby="onesignal_timeline_notification_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="onesignal_timeline_app_id">{__("OneSignal APP ID")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="onesignal_timeline_app_id" id="onesignal_timeline_app_id" value="{$system['onesignal_timeline_app_id']}">
                  {else}
                    <input type="password" class="input w-full" id="onesignal_timeline_app_id" value="*********">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="onesignal_timeline_api_key">{__("OneSignal REST API Key")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="onesignal_timeline_api_key" id="onesignal_timeline_api_key" value="{$system['onesignal_timeline_api_key']}">
                  {else}
                    <input type="password" class="input w-full" id="onesignal_timeline_api_key" value="*********">
                  {/if}
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
