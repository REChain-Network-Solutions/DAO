<div class="card border border-base-300 bg-base-100 shadow-none">
  <form class="js_ajax-forms" data-url="users/settings.php?edit=privacy">
    {include file='__settings_card_header.tpl' _icon="icon-[tabler--lock]" _title=__("Privacy Settings") _text=__("Who can see you and what you share")}
    <div class="card-body gap-6 pt-6">
      <!-- general -->
      <section class="flex flex-col gap-4">
        <h3 class="flex items-center gap-2 text-sm font-semibold">
          <span class="icon-[tabler--adjustments-horizontal] size-5 text-base-content/60" aria-hidden="true"></span>
          {__("General")}
        </h3>
        <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
          {if $system['chat_enabled']}
            <div class="flex items-center gap-4 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                {include file='__svg_icons.tpl' icon="chat" class="main-icon" width="24px" height="24px"}
              </span>
              <div class="min-w-0 grow">
                <div class="text-sm font-medium" id="user_chat_enabled-label">{__("Chat Active Status")}</div>
                <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("If chat active status is disabled you will appear offline and will not see who is online")}</p>
              </div>
              <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="user_chat_enabled-label" type="checkbox" name="user_chat_enabled" id="user_chat_enabled" {if $user->_data['user_chat_enabled']}checked{/if}>
            </div>
          {/if}

          <div class="flex items-center gap-4 p-4">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
              {include file='__svg_icons.tpl' icon="invitation" class="main-icon" width="24px" height="24px"}
            </span>
            <div class="min-w-0 grow">
              <div class="text-sm font-medium" id="user_newsletter_enabled-label">{__("Email you with our newsletter")}</div>
              <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("From time to time we send newsletter email to all of our members")}</p>
            </div>
            <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="user_newsletter_enabled-label" type="checkbox" name="user_newsletter_enabled" id="user_newsletter_enabled" {if $user->_data['user_newsletter_enabled']}checked{/if}>
          </div>

          {if $user->_data['can_receive_tip']}
            <div class="flex items-center gap-4 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                {include file='__svg_icons.tpl' icon="tip" class="main-icon" width="24px" height="24px"}
              </span>
              <div class="min-w-0 grow">
                <div class="text-sm font-medium" id="user_tips_enabled-label">{__("Tips Enabled")}</div>
                <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Allow the send tips button on your profile")}</p>
              </div>
              <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="user_tips_enabled-label" type="checkbox" name="user_tips_enabled" id="user_tips_enabled" {if $user->_data['user_tips_enabled']}checked{/if}>
            </div>
          {/if}

          <div class="flex items-center gap-4 p-4">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
              {include file='__svg_icons.tpl' icon="unlist" class="main-icon" width="24px" height="24px"}
            </span>
            <div class="min-w-0 grow">
              <div class="text-sm font-medium" id="user_suggestions_hidden-label">
                {if $system['friends_enabled']}{__("Hide from friends suggestions list")}{else}{__("Hide from followings suggestions list")}{/if}
              </div>
              <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Enable this option to hide your profile from the suggestions list")}</p>
            </div>
            <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="user_suggestions_hidden-label" type="checkbox" name="user_suggestions_hidden" id="user_suggestions_hidden" {if $user->_data['user_suggestions_hidden']}checked{/if}>
          </div>

          {if $system['incognito_mode_enabled']}
            <div class="flex items-center gap-4 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                {include file='__svg_icons.tpl' icon="spy" class="main-icon" width="24px" height="24px"}
              </span>
              <div class="min-w-0 grow">
                <div class="text-sm font-medium" id="user_incognito_enabled-label">{__("Incognito Mode")}</div>
                <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("When enabled, your profile will not appear in search results and you will be invisible to other users")}</p>
              </div>
              <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="user_incognito_enabled-label" type="checkbox" name="user_incognito_enabled" id="user_incognito_enabled" {if $user->_data['user_incognito_enabled']}checked{/if}>
            </div>
          {/if}
        </div>
        <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
          {if $system['chat_enabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--message-circle] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_chat">{__("Who can message you?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_chat" name="user_privacy_chat">
                <option {if $user->_data['user_privacy_chat'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_chat'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_chat'] == "me"}selected{/if} value="me">
                  {__("No One")}
                </option>
              </select>
            </div>
          {/if}

          {if $system['pokes_enabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--hand-finger] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_poke">{__("Who can poke you?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_poke" name="user_privacy_poke">
                <option {if $user->_data['user_privacy_poke'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_poke'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_poke'] == "me"}selected{/if} value="me">
                  {__("No One")}
                </option>
              </select>
            </div>
          {/if}

          {if $system['gifts_enabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--gift] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_gifts">{__("Who can send you gifts?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_gifts" name="user_privacy_gifts">
                <option {if $user->_data['user_privacy_gifts'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_gifts'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_gifts'] == "me"}selected{/if} value="me">
                  {__("No One")}
                </option>
              </select>
            </div>
          {/if}

          {if $system['wall_posts_enabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--layout-list] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_wall">{__("Who can post on your wall?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_wall" name="user_privacy_wall">
                <option {if $user->_data['user_privacy_wall'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_wall'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_wall'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          {/if}

          {if $user->_data['can_add_collaborative_posts']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--users-plus] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_collaborative">{__("Who can tag you in collaborative posts?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_collaborative" name="user_privacy_collaborative">
                <option {if $user->_data['user_privacy_collaborative'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_collaborative'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_collaborative'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          {/if}
        </div>
      </section>
      <!-- general -->

      <!-- profile -->
      <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
        <h3 class="flex items-center gap-2 text-sm font-semibold">
          <span class="icon-[tabler--user-circle] size-5 text-base-content/60" aria-hidden="true"></span>
          {__("Profile")}
        </h3>
        <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
          {if !$system['genders_disabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--gender-bigender] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_gender">{__("Who can see your gender?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_gender" name="user_privacy_gender">
                <option {if $user->_data['user_privacy_gender'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_gender'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_gender'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          {/if}

          {if $system['relationship_info_enabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--heart] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_relationship">{__("Who can see your relationship?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_relationship" name="user_privacy_relationship">
                <option {if $user->_data['user_privacy_relationship'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_relationship'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_relationship'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          {/if}

          <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
              <span class="icon-[tabler--cake] size-5"></span>
            </span>
            <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_birthdate">{__("Who can see your birthdate?")}</label>
            <select class="select w-full shrink-0 sm:w-48" id="user_privacy_birthdate" name="user_privacy_birthdate">
              <option {if $user->_data['user_privacy_birthdate'] == "public"}selected{/if} value="public">
                {__("Everyone")}
              </option>
              <option {if $user->_data['user_privacy_birthdate'] == "friends"}selected{/if} value="friends">
                {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
              </option>
              <option {if $user->_data['user_privacy_birthdate'] == "me"}selected{/if} value="me">
                {__("Just Me")}
              </option>
            </select>
          </div>

          <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
              <span class="icon-[tabler--id-badge-2] size-5"></span>
            </span>
            <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_basic">{__("Who can see your basic info?")}</label>
            <select class="select w-full shrink-0 sm:w-48" id="user_privacy_basic" name="user_privacy_basic">
              <option {if $user->_data['user_privacy_basic'] == "public"}selected{/if} value="public">
                {__("Everyone")}
              </option>
              <option {if $user->_data['user_privacy_basic'] == "friends"}selected{/if} value="friends">
                {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
              </option>
              <option {if $user->_data['user_privacy_basic'] == "me"}selected{/if} value="me">
                {__("Just Me")}
              </option>
            </select>
          </div>

          {if $system['work_info_enabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--briefcase] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_work">{__("Who can see your work info?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_work" name="user_privacy_work">
                <option {if $user->_data['user_privacy_work'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_work'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_work'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          {/if}

          {if $system['location_info_enabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--map-pin] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_location">{__("Who can see your location info?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_location" name="user_privacy_location">
                <option {if $user->_data['user_privacy_location'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_location'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_location'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          {/if}

          {if $system['education_info_enabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--school] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_education">{__("Who can see your education info?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_education" name="user_privacy_education">
                <option {if $user->_data['user_privacy_education'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_education'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_education'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          {/if}

          <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
              <span class="icon-[tabler--dots] size-5"></span>
            </span>
            <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_other">{__("Who can see your other info?")}</label>
            <select class="select w-full shrink-0 sm:w-48" id="user_privacy_other" name="user_privacy_other">
              <option {if $user->_data['user_privacy_other'] == "public"}selected{/if} value="public">
                {__("Everyone")}
              </option>
              <option {if $user->_data['user_privacy_other'] == "friends"}selected{/if} value="friends">
                {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
              </option>
              <option {if $user->_data['user_privacy_other'] == "me"}selected{/if} value="me">
                {__("Just Me")}
              </option>
            </select>
          </div>

          {if $system['friends_enabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--users] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_friends">{__("Who can see your friends?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_friends" name="user_privacy_friends">
                <option {if $user->_data['user_privacy_friends'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_friends'] == "friends"}selected{/if} value="friends">
                  {__("Friends")}
                </option>
                <option {if $user->_data['user_privacy_friends'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          {/if}

          <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
              <span class="icon-[tabler--user-heart] size-5"></span>
            </span>
            <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_followers">{__("Who can see your followers/followings?")}</label>
            <select class="select w-full shrink-0 sm:w-48" id="user_privacy_followers" name="user_privacy_followers">
              <option {if $user->_data['user_privacy_followers'] == "public"}selected{/if} value="public">
                {__("Everyone")}
              </option>
              <option {if $user->_data['user_privacy_followers'] == "friends"}selected{/if} value="friends">
                {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
              </option>
              <option {if $user->_data['user_privacy_followers'] == "me"}selected{/if} value="me">
                {__("Just Me")}
              </option>
            </select>
          </div>

          {if $system['monetization_enabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--crown] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_subscriptions">{__("Who can see your subscriptions?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_subscriptions" name="user_privacy_subscriptions">
                <option {if $user->_data['user_privacy_subscriptions'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_subscriptions'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_subscriptions'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          {/if}
        </div>
      </section>
      <!-- profile -->

      <!-- content -->
      <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
        <h3 class="flex items-center gap-2 text-sm font-semibold">
          <span class="icon-[tabler--photo] size-5 text-base-content/60" aria-hidden="true"></span>
          {__("Content")}
        </h3>
        <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
          <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
              <span class="icon-[tabler--photo] size-5"></span>
            </span>
            <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_photos">{__("Who can see your photos?")}</label>
            <select class="select w-full shrink-0 sm:w-48" id="user_privacy_photos" name="user_privacy_photos">
              <option {if $user->_data['user_privacy_photos'] == "public"}selected{/if} value="public">
                {__("Everyone")}
              </option>
              <option {if $user->_data['user_privacy_photos'] == "friends"}selected{/if} value="friends">
                {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
              </option>
              <option {if $user->_data['user_privacy_photos'] == "me"}selected{/if} value="me">
                {__("Just Me")}
              </option>
            </select>
          </div>

          {if $system['pages_enabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--flag] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_pages">{__("Who can see your liked pages?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_pages" name="user_privacy_pages">
                <option {if $user->_data['user_privacy_pages'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_pages'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_pages'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          {/if}

          {if $system['groups_enabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--users-group] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_groups">{__("Who can see your joined groups?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_groups" name="user_privacy_groups">
                <option {if $user->_data['user_privacy_groups'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_groups'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_groups'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          {/if}

          {if $system['events_enabled']}
            <div class="flex flex-wrap items-center gap-x-4 gap-y-3 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--calendar-event] size-5"></span>
              </span>
              <label class="min-w-0 grow basis-40 text-sm font-medium" for="user_privacy_events">{__("Who can see your joined events?")}</label>
              <select class="select w-full shrink-0 sm:w-48" id="user_privacy_events" name="user_privacy_events">
                <option {if $user->_data['user_privacy_events'] == "public"}selected{/if} value="public">
                  {__("Everyone")}
                </option>
                <option {if $user->_data['user_privacy_events'] == "friends"}selected{/if} value="friends">
                  {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                </option>
                <option {if $user->_data['user_privacy_events'] == "me"}selected{/if} value="me">
                  {__("Just Me")}
                </option>
              </select>
            </div>
          {/if}
        </div>
      </section>
      <!-- content -->

      {if $system['stories_enabled']}
        <!-- stories -->
        <section class="flex flex-col gap-4">
          <h3 class="flex items-center gap-2 text-sm font-semibold">
            <span class="icon-[tabler--history-toggle] size-5 text-base-content/60" aria-hidden="true"></span>
            {__("Stories")}
          </h3>
          <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
            <div class="flex items-center gap-4 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--star] size-5"></span>
              </span>
              <div class="min-w-0 grow">
                <div class="text-sm font-medium">{__("Close Friends")}</div>
                <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Only these people see the stories you share with close friends")}</p>
              </div>
              <button type="button" class="heroui button button--tertiary text-base-content button--sm shrink-0 js_modal rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="stories/audience.php?do=manage&type=close">{__("Manage")}</button>
            </div>
            <div class="flex items-center gap-4 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-primary" aria-hidden="true">
                <span class="icon-[tabler--eye-off] size-5"></span>
              </span>
              <div class="min-w-0 grow">
                <div class="text-sm font-medium">{__("Hide Story From")}</div>
                <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("These people will not see any of your stories")}</p>
              </div>
              <button type="button" class="heroui button button--tertiary text-base-content button--sm shrink-0 js_modal rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="stories/audience.php?do=manage&type=hidden">{__("Manage")}</button>
            </div>
          </div>
        </section>
        <!-- stories -->
      {/if}

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
