<div class="card border border-base-300 bg-base-100 shadow-none">
  <form class="js_ajax-forms" data-url="users/settings.php?edit=account">
    {include file='__settings_card_header.tpl' _icon="icon-[tabler--settings]" _title=__("Account Settings") _text=__("Update your email, phone number, and username")}
    <div class="card-body gap-6 pt-6">
      <!-- email -->
      <section class="flex flex-col gap-4" aria-labelledby="settings-email-heading">
        <div class="flex flex-wrap items-center gap-2">
          <h3 id="settings-email-heading" class="flex items-center gap-2 text-sm font-semibold">
            <span class="icon-[tabler--mail] size-5 text-base-content/60" aria-hidden="true"></span>
            {__("Email Address")}
          </h3>
          {if $user->_data['user_email_verified']}
            <span class="badge badge-soft badge-success badge-sm rounded-full">
              <span class="icon-[tabler--circle-check-filled] size-3.5" aria-hidden="true"></span>{__("Verified")}
            </span>
          {else}
            <span class="badge badge-soft badge-error badge-sm rounded-full">{__("Not Verified")}</span>
          {/if}
        </div>

        {if !$user->_data['user_email_verified']}
          <div class="alert alert-error flex flex-wrap items-center gap-3 leading-5" role="alert">
            <span class="icon-[tabler--mail-exclamation] size-5 shrink-0" aria-hidden="true"></span>
            <div class="min-w-0 grow">
              <div class="font-medium">{__("Email Verification Required")}</div>
              <p class="mt-0.5 text-sm">{__("Check your email inbox")} {__("to complete the verification process")}</p>
            </div>
            <button type="button" class="js_modal heroui button button--danger button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="core/activation_email_resend.php">
              <span class="icon-[tabler--send] size-4" aria-hidden="true"></span>
              {__("Resend Verification Email")}
            </button>
          </div>
        {/if}

        <div class="w-full">
          <label class="sr-only" for="settings-email">{__("Email Address")}</label>
          <div class="input w-full items-center gap-2">
            <span class="icon-[tabler--at] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <input type="email" class="grow" id="settings-email" name="email" value="{$user->_data['user_email']}" autocomplete="email" dir="ltr">
          </div>
        </div>
      </section>
      <!-- email -->

      <!-- phone -->
      {if ($system['activation_enabled'] && $system['activation_type'] == "sms") || ($system['two_factor_enabled'] && $system['two_factor_type'] == "sms")}
        <section class="flex flex-col gap-4 border-t border-base-300 pt-6" aria-labelledby="settings-phone-heading">
          <div class="flex flex-wrap items-center gap-2">
            <h3 id="settings-phone-heading" class="flex items-center gap-2 text-sm font-semibold">
              <span class="icon-[tabler--device-mobile] size-5 text-base-content/60" aria-hidden="true"></span>
              {__("Phone Number")}
            </h3>
            {if $user->_data['user_phone']}
              {if $user->_data['user_phone_verified']}
                <span class="badge badge-soft badge-success badge-sm rounded-full">
                  <span class="icon-[tabler--circle-check-filled] size-3.5" aria-hidden="true"></span>{__("Verified")}
                </span>
              {else}
                <span class="badge badge-soft badge-error badge-sm rounded-full">{__("Not Verified")}</span>
              {/if}
            {/if}
          </div>

          {if $user->_data['user_phone'] && !$user->_data['user_phone_verified']}
            <div class="alert alert-error flex flex-wrap items-center gap-3 leading-5" role="alert">
              <span class="icon-[tabler--device-mobile-exclamation] size-5 shrink-0" aria-hidden="true"></span>
              <div class="min-w-0 grow">
                <div class="font-medium">{__("Phone Verification Required")}</div>
                <p class="mt-0.5 text-sm">{__("Check your phone SMS")} {__("to complete phone verification process")}</p>
              </div>
              <button type="button" class="js_modal heroui button button--danger button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="#activation-phone">
                <span class="icon-[tabler--password] size-4" aria-hidden="true"></span>
                {__("Enter Code")}
              </button>
            </div>
          {/if}

          <div class="w-full">
            <label class="sr-only" for="settings-phone">{__("Phone Number")}</label>
            <div class="input w-full items-center gap-2">
              <span class="icon-[tabler--phone] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
              <input type="tel" class="grow" id="settings-phone" name="phone" value="{$user->_data['user_phone']}" autocomplete="tel" dir="ltr" aria-describedby="settings-phone-help">
            </div>
            <p id="settings-phone-help" class="helper-text">{__("Phone number (e.g: +1234567890)")}</p>
          </div>
        </section>
      {/if}
      <!-- phone -->

      <!-- username -->
      {if !$system['disable_username_changes']}
        <section class="flex flex-col gap-4 border-t border-base-300 pt-6" aria-labelledby="settings-username-heading">
          <h3 id="settings-username-heading" class="flex items-center gap-2 text-sm font-semibold">
            <span class="icon-[tabler--user-circle] size-5 text-base-content/60" aria-hidden="true"></span>
            {__("Username")}
          </h3>

          {if $user->_data['user_verified']}
            <div class="alert alert-warning flex items-start gap-3 leading-5" role="alert">
              <span class="icon-[tabler--alert-triangle] size-5 shrink-0" aria-hidden="true"></span>
              <div class="min-w-0">
                <div class="font-medium">{__("Attention")}</div>
                <p class="mt-0.5 text-sm">{__("Your account is already verified if you changed your username you will lose the verification badge")}</p>
              </div>
            </div>
          {/if}

          <div class="w-full">
            <label class="sr-only" for="settings-username">{__("Username")}</label>
            <div class="join w-full" dir="ltr">
              <span class="join-item flex min-w-10 max-w-64 shrink-0 items-center border border-e-0 border-base-300 bg-base-200 px-3 text-sm text-base-content/60">
                <span class="truncate whitespace-nowrap" title="{$system['system_url']}/">{$system['system_url']}/</span>
              </span>
              <input type="text" class="input join-item min-w-0 flex-1" id="settings-username" name="username" value="{$user->_data['user_name']}" autocomplete="username" aria-describedby="settings-username-help">
            </div>
            <p id="settings-username-help" class="helper-text">{__("Can only contain alphanumeric characters (A–Z, 0–9) and periods ('.')")}</p>
          </div>
        </section>
      {/if}
      <!-- username -->

      <!-- security check -->
      <div class="js_hidden-section hidden">
        <section class="flex flex-col gap-4 rounded-xl border border-warning/40 bg-warning/5 p-4 sm:p-5" aria-labelledby="settings-password-heading">
          <h3 id="settings-password-heading" class="flex items-center gap-2 text-sm font-semibold">
            <span class="icon-[tabler--shield-lock] size-5 text-warning" aria-hidden="true"></span>
            {__("Secuirty Check")}
          </h3>
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="settings-password">{__("Current Password")}</label>
            <div class="input w-full items-center gap-2">
              <span class="icon-[tabler--lock] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
              <input type="password" class="grow" id="settings-password" name="password" autocomplete="current-password" dir="ltr" aria-describedby="settings-password-help">
              {include file='__password_toggle.tpl'}
            </div>
            <p id="settings-password-help" class="helper-text">{__("You need to enter your current password for security check")}</p>
          </div>
        </section>
      </div>
      <!-- security check -->

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
