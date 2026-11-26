<div class="card border border-base-300 bg-base-100 shadow-none">
  <form class="js_ajax-forms" data-url="users/settings.php?edit=notifications">
    {include file='__settings_card_header.tpl' _icon="icon-[tabler--bell]" _title=__("Notifications") _text=__("Email and site alerts")}
    <div class="card-body gap-6 pt-6">
      <!-- system notifications -->
      <section class="flex flex-col gap-4">
        <h3 class="flex items-center gap-2 text-sm font-semibold">
          <span class="icon-[tabler--volume] size-5 text-base-content/60" aria-hidden="true"></span>
          {__("System Notifications")}
        </h3>
        <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
          <div class="flex items-center gap-4 p-4">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
              {include file='__svg_icons.tpl' icon="chat_bell" class="main-icon" width="24px" height="24px"}
            </span>
            <div class="min-w-0 grow">
              <div class="text-sm font-medium" id="chat_sound_settings-label">{__("Chat Message Sound")}</div>
              <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("A sound will be played each time you receive a new message on an inactive chat window")}</p>
            </div>
            <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="chat_sound_settings-label" type="checkbox" name="chat_sound" id="chat_sound_settings" {if $user->_data['chat_sound']}checked{/if}>
          </div>
          <div class="flex items-center gap-4 p-4">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
              {include file='__svg_icons.tpl' icon="notification_bell" class="main-icon" width="24px" height="24px"}
            </span>
            <div class="min-w-0 grow">
              <div class="text-sm font-medium" id="notifications_sound_settings-label">{__("Notifications Sound")}</div>
              <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("A sound will be played each time you receive a new activity notification")}</p>
            </div>
            <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="notifications_sound_settings-label" type="checkbox" name="notifications_sound" id="notifications_sound_settings" {if $user->_data['notifications_sound']}checked{/if}>
          </div>
        </div>
      </section>
      <!-- system notifications -->

      <!-- email notifications -->
      {if $email_user_notifications_enabled || $email_admin_notifications_enabled}
        <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
          <div>
            <h3 class="flex items-center gap-2 text-sm font-semibold">
              <span class="icon-[tabler--mail] size-5 text-base-content/60" aria-hidden="true"></span>
              {__("Email Notifications")}
            </h3>
            <p class="mt-0.5 text-sm text-base-content/60">{__("Email Me When")}</p>
          </div>
          {if $email_user_notifications_enabled}
            <div class="grid gap-3 sm:grid-cols-2">
              {if $system['email_post_likes']}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="email_post_likes">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--heart] size-5"></span>
                  </span>
                  <span class="min-w-0 grow text-sm">{__("Someone reacted to my post")}</span>
                  <input type="checkbox" class="checkbox checkbox-primary shrink-0" name="email_post_likes" id="email_post_likes" {if $user->_data['email_post_likes']}checked{/if}>
                </label>
              {/if}
              {if $system['email_post_comments']}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="email_post_comments">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--message-circle] size-5"></span>
                  </span>
                  <span class="min-w-0 grow text-sm">{__("Someone commented on my post")}</span>
                  <input type="checkbox" class="checkbox checkbox-primary shrink-0" name="email_post_comments" id="email_post_comments" {if $user->_data['email_post_comments']}checked{/if}>
                </label>
              {/if}
              {if $system['email_post_shares']}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="email_post_shares">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--share-3] size-5"></span>
                  </span>
                  <span class="min-w-0 grow text-sm">{__("Someone shared my post")}</span>
                  <input type="checkbox" class="checkbox checkbox-primary shrink-0" name="email_post_shares" id="email_post_shares" {if $user->_data['email_post_shares']}checked{/if}>
                </label>
              {/if}
              {if $system['email_wall_posts']}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="email_wall_posts">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--layout-list] size-5"></span>
                  </span>
                  <span class="min-w-0 grow text-sm">{__("Someone posted on my timeline")}</span>
                  <input type="checkbox" class="checkbox checkbox-primary shrink-0" name="email_wall_posts" id="email_wall_posts" {if $user->_data['email_wall_posts']}checked{/if}>
                </label>
              {/if}
              {if $system['email_mentions']}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="email_mentions">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--at] size-5"></span>
                  </span>
                  <span class="min-w-0 grow text-sm">{__("Someone mentioned me")}</span>
                  <input type="checkbox" class="checkbox checkbox-primary shrink-0" name="email_mentions" id="email_mentions" {if $user->_data['email_mentions']}checked{/if}>
                </label>
              {/if}
              {if $system['email_profile_visits']}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="email_profile_visits">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--eye] size-5"></span>
                  </span>
                  <span class="min-w-0 grow text-sm">{__("Someone visited my profile")}</span>
                  <input type="checkbox" class="checkbox checkbox-primary shrink-0" name="email_profile_visits" id="email_profile_visits" {if $user->_data['email_profile_visits']}checked{/if}>
                </label>
              {/if}
              {if $system['email_friend_requests']}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="email_friend_requests">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--user-plus] size-5"></span>
                  </span>
                  <span class="min-w-0 grow text-sm">{__("Someone sent me/accepted my friend requset")}</span>
                  <input type="checkbox" class="checkbox checkbox-primary shrink-0" name="email_friend_requests" id="email_friend_requests" {if $user->_data['email_friend_requests']}checked{/if}>
                </label>
              {/if}
              {if $system['verification_requests'] && $system['email_user_verification']}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="email_user_verification">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--rosette-discount-check] size-5"></span>
                  </span>
                  <span class="min-w-0 grow text-sm">{__("Admin approved/declined my verification requests")}</span>
                  <input type="checkbox" class="checkbox checkbox-primary shrink-0" name="email_user_verification" id="email_user_verification" {if $user->_data['email_user_verification']}checked{/if}>
                </label>
              {/if}
              {if $system['posts_approval_enabled'] && $system['email_user_post_approval']}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="email_user_post_approval">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--circle-check] size-5"></span>
                  </span>
                  <span class="min-w-0 grow text-sm">{__("Admin approved my pending posts")}</span>
                  <input type="checkbox" class="checkbox checkbox-primary shrink-0" name="email_user_post_approval" id="email_user_post_approval" {if $user->_data['email_user_post_approval']}checked{/if}>
                </label>
              {/if}
            </div>
          {/if}
          {if $email_admin_notifications_enabled && ($user->_is_admin || $user->_is_moderator)}
            <div class="grid gap-3 sm:grid-cols-2{if $email_user_notifications_enabled} border-t border-dashed border-base-300 pt-4{/if}">
              {if $system['email_admin_verifications']}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="email_admin_verifications">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--rosette-discount-check] size-5"></span>
                  </span>
                  <span class="min-w-0 grow text-sm">{__("Verification request sent by user/page")}</span>
                  <input type="checkbox" class="checkbox checkbox-primary shrink-0" name="email_admin_verifications" id="email_admin_verifications" {if $user->_data['email_admin_verifications']}checked{/if}>
                </label>
              {/if}
              {if $system['email_admin_post_approval']}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="email_admin_post_approval">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--file-check] size-5"></span>
                  </span>
                  <span class="min-w-0 grow text-sm">{__("Post published and needs approval")}</span>
                  <input type="checkbox" class="checkbox checkbox-primary shrink-0" name="email_admin_post_approval" id="email_admin_post_approval" {if $user->_data['email_admin_post_approval']}checked{/if}>
                </label>
              {/if}
              {if $system['email_admin_user_approval']}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="email_admin_user_approval">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-primary" aria-hidden="true">
                    <span class="icon-[tabler--user-check] size-5"></span>
                  </span>
                  <span class="min-w-0 grow text-sm">{__("New user needs approval")}</span>
                  <input type="checkbox" class="checkbox checkbox-primary shrink-0" name="email_admin_user_approval" id="email_admin_user_approval" {if $user->_data['email_admin_user_approval']}checked{/if}>
                </label>
              {/if}
            </div>
          {/if}
        </section>
      {/if}
      <!-- email notifications -->

      <!-- success -->
      <div class="alert alert-success hidden items-center" role="status"></div>
      <!-- success -->

      <!-- error -->
      <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
      <!-- error -->
    </div>
    <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
      <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
    </div>
  </form>
</div>
