<!-- card-header -->
<div class="card-header with-icon with-nav">
  <!-- panel title -->
  <div class="mb20">
    <i class="fa fa-bell mr10"></i>{__("Settings")} &rsaquo; {__("Notifications")}
  </div>
  <!-- panel title -->

  <!-- panel nav -->
  <ul class="nav nav-tabs">
    <li class="nav-item">
      <a class="nav-link active" href="#Website" data-bs-toggle="tab">
        <i class="fa fa-bell fa-fw mr5"></i><strong>{__("Website Notifications")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#Email" data-bs-toggle="tab">
        <i class="fa fa-envelope fa-fw mr5"></i><strong>{__("Email Notifications")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#Push" data-bs-toggle="tab">
        <i class="fas fa-broadcast-tower fa-fw mr5"></i><strong>{__("Push Notifications")}</strong>
      </a>
    </li>
  </ul>
  <!-- panel nav -->
</div>
<!-- card-header -->

<!-- tabs content -->
<div class="tab-content">
  <!-- Website Notifications -->
  <div class="tab-pane active" id="Website">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=website_notifications">
      <div class="card-body">

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="profile_notifications" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Profile Visit Notification")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the profile visit notification On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="profile_notification_enabled">
              <input type="checkbox" name="profile_notification_enabled" id="profile_notification_enabled" {if $system['profile_notification_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="browser_notifications" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Browser Notifications")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the browser notifications On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="browser_notifications_enabled">
              <input type="checkbox" name="browser_notifications_enabled" id="browser_notifications_enabled" {if $system['browser_notifications_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="noty_notifications" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Noty Notifications")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the noty notifications On and Off")} (<a target="_blank" href="{$system['system_url']}/content/themes/{$system['theme']}/images/screenshots/noty_notification.png">{__("preview")}</a>)
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="noty_notifications_enabled">
              <input type="checkbox" name="noty_notifications_enabled" id="noty_notifications_enabled" {if $system['noty_notifications_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
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
  <!-- Website Notifications -->

  <!-- Email Notifications -->
  <div class="tab-pane" id="Email">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=email_notifications">
      <div class="card-body">

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="newsletter" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Email Notifications")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable/Disable email notifications system")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="email_notifications">
              <input type="checkbox" name="email_notifications" id="email_notifications" {if $system['email_notifications']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Email User When")}
          </label>
          <div class="col-md-9">
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="email_post_likes" id="email_post_likes" {if $system['email_post_likes']}checked{/if}>
              <label class="form-check-label" for="email_post_likes">{__("Someone reacted to his post")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="email_post_comments" id="email_post_comments" {if $system['email_post_comments']}checked{/if}>
              <label class="form-check-label" for="email_post_comments">{__("Someone commented on his post")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="email_post_shares" id="email_post_shares" {if $system['email_post_shares']}checked{/if}>
              <label class="form-check-label" for="email_post_shares">{__("Someone shared his post")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="email_wall_posts" id="email_wall_posts" {if $system['email_wall_posts']}checked{/if}>
              <label class="form-check-label" for="email_wall_posts">{__("Someone posted on his timeline")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="email_mentions" id="email_mentions" {if $system['email_mentions']}checked{/if}>
              <label class="form-check-label" for="email_mentions">{__("Someone mentioned him")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="email_profile_visits" id="email_profile_visits" {if $system['email_profile_visits']}checked{/if}>
              <label class="form-check-label" for="email_profile_visits">{__("Someone visited his profile")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="email_friend_requests" id="email_friend_requests" {if $system['email_friend_requests']}checked{/if}>
              <label class="form-check-label" for="email_friend_requests">{__("Someone sent him or accepted his friend requset")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="email_user_verification" id="email_user_verification" {if $system['email_user_verification']}checked{/if}>
              <label class="form-check-label" for="email_user_verification">{__("Admin approved/declined my verification requests")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="email_user_post_approval" id="email_user_post_approval" {if $system['email_user_post_approval']}checked{/if}>
              <label class="form-check-label" for="email_user_post_approval">{__("Admin approved my pending posts")}</label>
            </div>
          </div>
        </div>

        <div class="divider dashed"></div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Email Admin When")}
          </label>
          <div class="col-md-9">
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="email_admin_verifications" id="email_admin_verifications" {if $system['email_admin_verifications']}checked{/if}>
              <label class="form-check-label" for="email_admin_verifications">{__("Verification request sent by user/page")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="email_admin_post_approval" id="email_admin_post_approval" {if $system['email_admin_post_approval']}checked{/if}>
              <label class="form-check-label" for="email_admin_post_approval">{__("Post published and needs approval")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="email_admin_user_approval" id="email_admin_user_approval" {if $system['email_admin_user_approval']}checked{/if}>
              <label class="form-check-label" for="email_admin_user_approval">{__("New user needs approval")}</label>
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
  <!-- Email Notifications -->

  <!-- Push Notifications -->
  <div class="tab-pane" id="Push">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=push_notifications">
      <div class="card-body">
        <div class="heading-small mb20">
          <i class="fa-solid fa-desktop mr5"></i>{__("Web Apps")}
        </div>
        <div class="pl-md-4">
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="onesignal" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("OneSignal Push Notifications")} </div>
              <div class="form-text d-none d-sm-block">
                {__("Turn the OneSignal push notification for Web Apps and Web-View Apps")}
              </div>
            </div>
            <div class="text-end">
              <label class="switch" for="onesignal_notification_enabled">
                <input type="checkbox" name="onesignal_notification_enabled" id="onesignal_notification_enabled" {if $system['onesignal_notification_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("OneSignal APP ID")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="onesignal_app_id" value="{$system['onesignal_app_id']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("OneSignal REST API Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="onesignal_api_key" value="{$system['onesignal_api_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>

        <div class="divider dashed"></div>

        <div class="heading-small mb20">
          <i class="fa-solid fa-comments mr5"></i>{__("Messaging Apps")}
        </div>
        <div class="pl-md-4">
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="onesignal" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("OneSignal Push Notifications")} </div>
              <div class="form-text d-none d-sm-block">
                {__("Turn the OneSignal push notification for Native Messenger Apps")}
              </div>
            </div>
            <div class="text-end">
              <label class="switch" for="onesignal_messenger_notification_enabled">
                <input type="checkbox" name="onesignal_messenger_notification_enabled" id="onesignal_messenger_notification_enabled" {if $system['onesignal_messenger_notification_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("OneSignal APP ID")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="onesignal_messenger_app_id" value="{$system['onesignal_messenger_app_id']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("OneSignal REST API Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="onesignal_messenger_api_key" value="{$system['onesignal_messenger_api_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>

        <div class="divider dashed"></div>

        <div class="heading-small mb20">
          <i class="fa-solid fa-mobile mr5"></i>{__("Timeline Apps")}
        </div>
        <div class="pl-md-4">
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="onesignal" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("OneSignal Push Notifications")} </div>
              <div class="form-text d-none d-sm-block">
                {__("Turn the OneSignal push notification for Native Timeline Apps")}
              </div>
            </div>
            <div class="text-end">
              <label class="switch" for="onesignal_timeline_notification_enabled">
                <input type="checkbox" name="onesignal_timeline_notification_enabled" id="onesignal_timeline_notification_enabled" {if $system['onesignal_timeline_notification_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("OneSignal APP ID")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="onesignal_timeline_app_id" value="{$system['onesignal_timeline_app_id']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("OneSignal REST API Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="onesignal_timeline_api_key" value="{$system['onesignal_timeline_api_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
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
  <!-- Push Notifications -->
</div>