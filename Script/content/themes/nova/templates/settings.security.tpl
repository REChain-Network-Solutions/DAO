{if $sub_view == "password"}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <form class="js_ajax-forms" data-url="users/settings.php?edit=password">
      {include file='__settings_card_header.tpl' _icon="icon-[tabler--key]" _title=__("Password") _text=__("Password, sessions, and two-factor")}
      <div class="card-body gap-6 pt-6">
        <div class="alert alert-warning flex items-start gap-3 leading-5" role="alert">
          <span class="icon-[tabler--alert-triangle] size-5 shrink-0" aria-hidden="true"></span>
          <p class="min-w-0 text-sm">{__("Changing password will log you out from all other sessions")}</p>
        </div>

        <!-- current password -->
        <div class="w-full sm:max-w-[calc(50%-0.75rem)]">
          <label class="label-text mb-1.5 block" for="current">{__("Confirm Current Password")}</label>
          <div class="input w-full items-center gap-2">
            <span class="icon-[tabler--lock] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <input type="password" class="grow" id="current" name="current" autocomplete="current-password" dir="ltr">
          </div>
        </div>
        <!-- current password -->

        <!-- new password -->
        <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
          <div class="grid gap-6 sm:grid-cols-2">
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="new">{__("Your New Password")}</label>
              <div class="input w-full items-center gap-2">
                <span class="icon-[tabler--key] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                <input type="password" class="grow" id="new" name="new" autocomplete="new-password" dir="ltr">
              </div>
            </div>
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="confirm">{__("Confirm New Password")}</label>
              <div class="input w-full items-center gap-2">
                <span class="icon-[tabler--shield-check] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                <input type="password" class="grow" id="confirm" name="confirm" autocomplete="new-password" dir="ltr">
              </div>
            </div>
          </div>
        </section>
        <!-- new password -->

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

{elseif $sub_view == "sessions"}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
      <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
        <span class="icon-[tabler--devices] size-5"></span>
      </span>
      <div class="min-w-0 grow">
        <h2 class="card-title text-lg">{__("Manage Sessions")}</h2>
        <p class="text-sm text-base-content/60">{__("Password, sessions, and two-factor")}</p>
      </div>
      <button type="button" class="heroui button button--danger button--sm w-full sm:ms-auto sm:w-auto shrink-0 js_session-delete-all rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
        <span class="icon-[tabler--logout] size-4" aria-hidden="true"></span>
        {__("Log Out Of All Sessions")}
      </button>
    </div>
    <div class="card-body gap-6 pt-6">
      {if $sessions}
        <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
          {foreach $sessions as $session}
            {if $session['user_browser'] == "Chrome"}
              {assign var="browser_icon" value="icon-[tabler--brand-chrome]"}
            {elseif $session['user_browser'] == "Firefox"}
              {assign var="browser_icon" value="icon-[tabler--brand-firefox]"}
            {elseif $session['user_browser'] == "Safari"}
              {assign var="browser_icon" value="icon-[tabler--brand-safari]"}
            {elseif $session['user_browser'] == "Edge"}
              {assign var="browser_icon" value="icon-[tabler--brand-edge]"}
            {elseif $session['user_browser'] == "Opera"}
              {assign var="browser_icon" value="icon-[tabler--brand-opera]"}
            {elseif $session['user_browser'] == "Handheld Browser"}
              {assign var="browser_icon" value="icon-[tabler--device-mobile]"}
            {else}
              {assign var="browser_icon" value="icon-[tabler--browser]"}
            {/if}
            {if $session['user_os']|truncate:7:"":true == "Windows"}
              {assign var="os_icon" value="icon-[tabler--brand-windows]"}
            {elseif in_array($session['user_os'], ["Mac OS X", "Mac OS 9", "iPhone", "iPod", "iPad"])}
              {assign var="os_icon" value="icon-[tabler--brand-apple]"}
            {elseif $session['user_os'] == "Android"}
              {assign var="os_icon" value="icon-[tabler--brand-android]"}
            {elseif $session['user_os'] == "Ubuntu"}
              {assign var="os_icon" value="icon-[tabler--brand-ubuntu]"}
            {elseif $session['user_os'] == "BlackBerry"}
              {assign var="os_icon" value="icon-[tabler--brand-blackberry]"}
            {elseif $session['user_os'] == "Mobile"}
              {assign var="os_icon" value="icon-[tabler--device-mobile]"}
            {else}
              {assign var="os_icon" value="icon-[tabler--device-desktop]"}
            {/if}
            <div class="grid grid-cols-[auto_minmax(0,1fr)] items-center gap-x-4 gap-y-3 p-4 sm:flex sm:gap-4">
              <span class="relative inline-flex size-11 shrink-0 items-center justify-center rounded-xl {if $session['session_id'] == $user->_data['active_session_id']}bg-success/10 text-success{else}bg-base-200 text-base-content{/if}" aria-hidden="true">
                <span class="{$browser_icon} size-6"></span>
                <span class="absolute -bottom-1 -end-1 inline-flex size-5 items-center justify-center rounded-full bg-base-100 text-base-content ring-1 ring-base-300">
                  <span class="{$os_icon} size-3.5"></span>
                </span>
              </span>
              <div class="min-w-0 grow">
                <div class="flex flex-wrap items-center gap-2">
                  <span class="text-sm font-medium">{$session['user_browser']}</span>
                  <span class="inline-flex items-center gap-1 text-sm text-base-content/60">
                    <span class="{$os_icon} size-4" aria-hidden="true"></span>
                    {$session['user_os']}
                  </span>
                </div>
                <div class="mt-0.5 flex flex-wrap items-center gap-x-3 gap-y-1 text-sm text-base-content/60">
                  {if $session['session_id'] == $user->_data['active_session_id']}
                    <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Active Session")}</span>
                  {/if}
                  <span class="inline-flex items-center gap-1">
                    <span class="icon-[tabler--clock] size-3.5" aria-hidden="true"></span>
                    <span class="js_moment" data-time="{$session['session_date']}">{$session['session_date']}</span>
                  </span>
                  <span class="inline-flex items-center gap-1" dir="ltr">
                    <span class="icon-[tabler--world] size-3.5" aria-hidden="true"></span>
                    {$session['user_ip']}
                  </span>
                  {if $session['user_location']}
                    <span class="inline-flex items-center gap-1">
                      <span class="icon-[tabler--map-pin] size-3.5" aria-hidden="true"></span>
                      {$session['user_location']}
                    </span>
                  {/if}
                </div>
              </div>
              <button type="button" class="heroui button button--danger-soft button--sm col-span-2 w-full shrink-0 sm:w-auto js_session-deleter rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-id="{$session['session_id']}" {if $session['session_id'] == $user->_data['active_session_id']} onclick="localStorage.clear();" {/if}>
                <span class="icon-[tabler--logout-2] size-4" aria-hidden="true"></span>
                {__("End Session")}
              </button>
            </div>
          {/foreach}
        </div>
      {else}
        {include file='_no_data.tpl' _empty_icon="icon-[tabler--devices]"}
      {/if}
    </div>
  </div>

{elseif $sub_view == "two-factor"}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <form class="js_ajax-forms" data-url="users/settings.php?edit=two-factor">
      <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
        <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
          <span class="icon-[tabler--shield-check] size-5"></span>
        </span>
        {capture assign="_two_factor_badge"}{if $user->_data['user_two_factor_enabled']}<span class="icon-[tabler--circle-check-filled] size-3.5" aria-hidden="true"></span>{__("Enabled")}{else}{__("Disabled")}{/if}{/capture}
        <div class="min-w-0 grow">
          <h2 class="card-title text-lg">{__("Two-Factor Authentication")}</h2>
          <p class="text-sm text-base-content/60 max-sm:hidden">{__("Password, sessions, and two-factor")}</p>
          <span class="badge badge-soft {if $user->_data['user_two_factor_enabled']}badge-success {/if}badge-sm mt-1 rounded-full sm:hidden">{$_two_factor_badge}</span>
        </div>
        <span class="badge badge-soft {if $user->_data['user_two_factor_enabled']}badge-success {/if}rounded-full ms-auto shrink-0 max-sm:hidden">{$_two_factor_badge}</span>
      </div>
      <div class="card-body gap-6 pt-6">
        {if !$user->_data['user_two_factor_enabled'] && $system['two_factor_type'] == "google"}
          <div class="alert alert-info flex items-start gap-3 leading-5" role="alert">
            <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
            <p class="min-w-0 text-sm">
              {__("Log in with a code from your")} {__("Google Authenticator App")} {__("as well as a password")}
            </p>
          </div>

          <!-- step 1 -->
          <section class="flex flex-col gap-5" aria-labelledby="authenticator-setup-title">
            <div class="flex items-start gap-3">
              <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-full bg-primary text-sm font-semibold text-primary-content" aria-hidden="true">1</span>
              <div class="min-w-0">
                <h3 id="authenticator-setup-title" class="text-sm font-semibold">{__("Configuring your authenticator")}</h3>
                <p class="mt-1 text-sm leading-relaxed text-base-content/60">{__("You need to download Google Authenticator app for")} {__("Android")} {__("or")} {__("IOS")}. {__("In your app, add a new account using the details below")}.</p>
                <div class="mt-3 flex gap-2 sm:flex-wrap">
                  <a class="heroui button button--outline button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" target="_blank" rel="noopener noreferrer" href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en">
                    <span class="icon-[tabler--brand-google-play] size-4" aria-hidden="true"></span>
                    {__("Android")}
                  </a>
                  <a class="heroui button button--outline button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" target="_blank" rel="noopener noreferrer" href="https://itunes.apple.com/eg/app/google-authenticator/id388497605?mt=8">
                    <span class="icon-[tabler--brand-apple] size-4" aria-hidden="true"></span>
                    {__("IOS")}
                  </a>
                </div>
              </div>
            </div>

            <div class="grid gap-4 sm:ms-11 sm:grid-cols-2">
              <div class="flex flex-col items-center rounded-xl border border-base-300 bg-base-200/40 p-5 text-center">
                <h4 class="flex items-center gap-2 text-sm font-semibold">
                  <span class="icon-[tabler--qrcode] size-5 text-base-content/60" aria-hidden="true"></span>
                  {__("Scanning the QR code")}
                </h4>
                <img class="mt-4 size-40 max-w-full rounded-lg bg-white p-2" src="{$two_factor_QR}" alt='{__("Scanning the QR code")}'>
              </div>
              <div class="flex flex-col items-center rounded-xl border border-base-300 bg-base-200/40 p-5 text-center">
                <h4 class="flex items-center gap-2 text-sm font-semibold">
                  <span class="icon-[tabler--key] size-5 text-base-content/60" aria-hidden="true"></span>
                  {__("Manually by entering this token")}
                </h4>
                <div class="my-auto flex w-full flex-col items-center gap-3 pt-4">
                  {include file='__copy_input.tpl' _id="two-factor-secret" _value=$two_factor_gsecret _icon="icon-[tabler--key]" _class="text-center font-mono font-semibold tracking-wider"}
                </div>
              </div>
            </div>
          </section>
          <!-- step 1 -->

          <!-- step 2 -->
          <section class="flex flex-col gap-4 border-t border-base-300 pt-6" aria-labelledby="authenticator-activate-title">
            <div class="flex items-start gap-3">
              <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-full bg-primary text-sm font-semibold text-primary-content" aria-hidden="true">2</span>
              <div class="min-w-0">
                <h3 id="authenticator-activate-title" class="text-sm font-semibold">{__("Activate your authenticator")}</h3>
                <p class="mt-1 text-sm text-base-content/60">{__("Enter the code shown on your app")}</p>
              </div>
            </div>
            <div class="w-full max-w-sm sm:ms-11">
              <label class="label-text mb-1.5 block" for="gcode">{__("Verification Code")}</label>
              <input name="gcode" id="gcode" type="text" class="input w-full text-center font-mono tracking-[0.3em]" inputmode="numeric" autocomplete="one-time-code" maxlength="6" placeholder="######" dir="ltr" required autofocus>
            </div>
          </section>
          <!-- step 2 -->
        {else}
          <div class="flex items-center gap-4 rounded-xl border p-4 sm:p-5 {if $user->_data['user_two_factor_enabled']}border-success/30 bg-success/5{else}border-base-300 bg-base-200/40{/if}">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl {if $user->_data['user_two_factor_enabled']}bg-success/10 text-success{else}bg-base-100 text-base-content{/if}" aria-hidden="true">
              {if $system['two_factor_type'] == "email"}
                <span class="icon-[tabler--mail] size-5"></span>
              {elseif $system['two_factor_type'] == "sms"}
                <span class="icon-[tabler--device-mobile-message] size-5"></span>
              {else}
                <span class="icon-[tabler--shield-lock] size-5"></span>
              {/if}
            </span>
            <div class="min-w-0 grow">
              <div class="text-sm font-medium" id="two_factor_enabled-label">{__("Two-Factor Authentication")}</div>
              <p class="mt-0.5 text-sm text-base-content/60">
                {__("Log in with a code from your")}
                {if $system['two_factor_type'] == "email"}{__("email")}{/if}
              {if $system['two_factor_type'] == "sms"}{__("phone")}{/if}
              {if $system['two_factor_type'] == "google"}{__("Google Authenticator App")}{/if}
                {__("as well as a password")}
              </p>
            </div>
            <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="two_factor_enabled-label" type="checkbox" name="two_factor_enabled" id="two_factor_enabled" {if $user->_data['user_two_factor_enabled']}checked{/if}>
          </div>
        {/if}

        <!-- success -->
        <div class="alert alert-success hidden items-center" role="status"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
        <!-- error -->
      </div>
      <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
        <input type="hidden" name="type" value="{$system['two_factor_type']}">
        <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
      </div>
    </form>
  </div>

{/if}
