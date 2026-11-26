<div class="w-full">

  <!-- signin -->
  <div class="js_panel {if $do == 'up'}hidden{/if}">
    <div class="mb-6">
      <h2 class="text-2xl font-semibold">{__("Sign In to your Account")}</h2>
      <p class="mt-1 text-base-content/70">{__("Welcome back! Please enter your details")}</p>
    </div>
    {if isset($highlight)}
      <div class="alert alert-warning mb-4" role="alert">{$highlight}</div>
    {/if}
    <form class="js_ajax-forms flex flex-col gap-4" data-url="core/signin.php" method="POST">
      <!-- username or email -->
      <div class="flex min-w-0 flex-col gap-2">
        <label class="label-text" for="signin-username-email">{__("Email")} {__("or")} {__("Username")}</label>
        <input type="text" class="input w-full" id="signin-username-email" name="username_email" placeholder='{__("Email")} {__("or")} {__("Username")}' required>
      </div>
      <!-- username or email -->

      <!-- password -->
      <div class="flex min-w-0 flex-col gap-2">
        <label class="label-text" for="signin-password">{__("Password")}</label>
        <div class="input w-full">
          <input type="password" class="grow" id="signin-password" name="password" placeholder='{__("Password")}' required>
          <button type="button" class="js_toggle-password cursor-pointer" aria-label="{__("Password")}">
            <svg class="eye-icon size-5" width="20" height="20" viewBox="0 0 56 56" xmlns="http://www.w3.org/2000/svg" fill="currentColor">
              <path d="M 28.0103 46.4025 C 44.5562 46.4025 56 33.0170 56 28.8443 C 56 24.6511 44.5354 11.2863 28.0103 11.2863 C 11.5883 11.2863 0 24.6511 0 28.8443 C 0 33.0170 11.6710 46.4025 28.0103 46.4025 Z M 28.0103 40.3501 C 21.5655 40.3501 16.4840 35.1240 16.4426 28.8443 C 16.4220 22.3995 21.5655 17.3387 28.0103 17.3387 C 34.4139 17.3387 39.5574 22.3995 39.5574 28.8443 C 39.5574 35.1240 34.4139 40.3501 28.0103 40.3501 Z M 28.0103 32.9963 C 30.3032 32.9963 32.2036 31.1166 32.2036 28.8443 C 32.2036 26.5515 30.3032 24.6717 28.0103 24.6717 C 25.6968 24.6717 23.7964 26.5515 23.7964 28.8443 C 23.7964 31.1166 25.6968 32.9963 28.0103 32.9963 Z" />
            </svg>
            <svg class="eye-icon-slash hidden size-5" width="20" height="20" viewBox="0 0 56 56" xmlns="http://www.w3.org/2000/svg" fill="currentColor">
              <path d="M 43.9492 47.3227 C 44.2544 47.6280 44.6821 47.7909 45.0686 47.7909 C 45.8832 47.7909 46.6361 47.0580 46.6361 46.2234 C 46.6361 45.8163 46.4735 45.4092 46.1679 45.1038 L 12.1120 11.0682 C 11.8066 10.7629 11.3995 10.6204 10.9924 10.6204 C 10.1781 10.6204 9.4250 11.3532 9.4250 12.1674 C 9.4250 12.5949 9.5675 13.0020 9.8728 13.2870 Z M 45.8628 41.5619 C 52.2546 37.4295 56.0000 32.0555 56.0000 29.6738 C 56.0000 25.5415 44.7025 12.3710 28.0102 12.3710 C 24.5497 12.3710 21.3130 12.9613 18.3410 13.9384 L 23.6540 19.2311 C 24.9771 18.6611 26.4428 18.3354 28.0102 18.3354 C 34.3207 18.3354 39.3892 23.3226 39.3892 29.6738 C 39.3892 31.2209 39.0636 32.7069 38.4324 34.0097 Z M 28.0102 46.9766 C 31.7761 46.9766 35.2774 46.3049 38.4124 45.2056 L 33.0179 39.8112 C 31.5318 40.5848 29.8219 41.0122 28.0102 41.0122 C 21.6591 41.0122 16.6310 35.8621 16.6107 29.6738 C 16.6107 27.8418 17.0382 26.1115 17.8117 24.5848 L 10.7278 17.4600 C 4.0102 21.5924 0 27.2310 0 29.6738 C 0 33.7858 11.5013 46.9766 28.0102 46.9766 Z M 34.4835 29.2463 C 34.4835 25.6840 31.6133 22.7934 28.0102 22.7934 C 27.7456 22.7934 27.4809 22.8137 27.2367 22.8341 L 34.4428 30.0402 C 34.4632 29.7960 34.4835 29.5110 34.4835 29.2463 Z M 21.5166 29.2056 C 21.5166 32.7883 24.4682 35.6789 28.0306 35.6789 C 28.3156 35.6789 28.5802 35.6586 28.8652 35.6382 L 21.5573 28.3303 C 21.5369 28.6153 21.5166 28.9206 21.5166 29.2056 Z" />
            </svg>
          </button>
        </div>
      </div>
      <!-- password -->

      <!-- remember me -->
      <div class="flex flex-wrap items-center justify-between gap-2">
        <div class="flex items-center gap-2">
          <input type="checkbox" class="checkbox checkbox-primary" name="remember" id="remember">
          <label class="label-text text-base-content/80 p-0" for="remember">{__("Remember me")}</label>
        </div>
        <a class="link link-primary" href="{$system['system_url']}/reset">{__("Forgotten password?")}</a>
      </div>
      <!-- remember me -->

      <!-- submit -->
      <button type="submit" class="heroui button button--primary button--lg button--full-width">{__("Sign In")}</button>
      <!-- submit -->

      <!-- error -->
      <div class="alert alert-danger alert-error hidden"></div>
      <!-- error -->
    </form>
    {if $system['social_login_enabled']}
      {include file='__social_login.tpl'}
    {/if}
    {if $system['registration_enabled']}
      <p class="mt-6 text-center text-base-content/80">
        {__("Do not have an account?")} <a href="{$system['system_url']}/signup{if $oauth_app_id}?oauth_app_id={$oauth_app_id}{/if}" class="js_toggle-panel link link-primary">{__("Sign Up")}</a>
      </p>
    {/if}
  </div>
  <!-- signin -->

  <!-- signup -->
  <div class="js_panel {if $do != 'up'}hidden{/if}">
    <div class="mb-6">
      <h2 class="text-2xl font-semibold">{__("Create a new account")}</h2>
    </div>
    <form class="js_ajax-forms flex flex-col gap-4" data-url="core/signup.php" method="POST">
      {if $system['invitation_enabled']}
        <!-- invitation code -->
        <div class="flex min-w-0 flex-col gap-2">
          <label class="label-text" for="signup-invitation-code">{__("Invitation Code")}</label>
          <input name="invitation_code" type="text" class="input w-full" id="signup-invitation-code" placeholder='{__("Invitation Code")}' value="{$invitation_code}" required>
        </div>
        <!-- invitation code -->
      {/if}
      {if !$system['show_usernames_enabled']}
        <div class="grid gap-4 sm:grid-cols-2">
          <!-- first name -->
          <div class="flex min-w-0 flex-col gap-2">
            <label class="label-text" for="signup-first-name">{__("First name")}</label>
            <input name="first_name" type="text" class="input w-full" id="signup-first-name" placeholder='{__("First name")}' required>
          </div>
          <!-- first name -->
          <!-- last name -->
          <div class="flex min-w-0 flex-col gap-2">
            <label class="label-text" for="signup-last-name">{__("Last name")}</label>
            <input name="last_name" type="text" class="input w-full" id="signup-last-name" placeholder='{__("Last name")}' required>
          </div>
          <!-- last name -->
        </div>
      {/if}
      <!-- username -->
      <div class="flex min-w-0 flex-col gap-2">
        <label class="label-text" for="signup-username">{__("Username")}</label>
        <input name="username" type="text" class="input w-full" id="signup-username" placeholder='{__("Username")}' required>
      </div>
      <!-- username -->
      <!-- email -->
      <div class="flex min-w-0 flex-col gap-2">
        <label class="label-text" for="signup-email">{__("Email")}</label>
        <input name="email" type="email" class="input w-full" id="signup-email" placeholder='{__("Email")}' required>
      </div>
      <!-- email -->
      {if $system['activation_enabled'] && $system['activation_type'] == "sms"}
        <!-- phone -->
        <div class="flex min-w-0 flex-col gap-2">
          <label class="label-text" for="signup-phone">{__("Phone number")}</label>
          <input name="phone" type="text" class="input w-full" id="signup-phone" placeholder='{__("Phone number (e.g: +1234567890)")}' required>
        </div>
        <!-- phone -->
      {/if}
      <!-- password -->
      <div class="flex min-w-0 flex-col gap-2">
        <label class="label-text" for="signup-password">{__("Password")}</label>
        <input name="password" type="password" class="input w-full" id="signup-password" placeholder='{__("Password")}' required>
      </div>
      <!-- password -->
      <!-- custom fields -->
      {if $custom_fields}
        {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true}
      {/if}
      <!-- custom fields -->
      <div class="js_hidden-section hidden space-y-4">
        {if !$system['genders_disabled']}
          <!-- genders -->
          <div class="flex min-w-0 flex-col gap-2">
            <label class="label-text" for="gender">{__("Gender")}</label>
            <select class="select w-full" name="gender" id="gender" required>
              <option value="none">{__("Gender")}:</option>
              {foreach $genders as $gender}
                <option value="{$gender['gender_id']}">{$gender['gender_name']}</option>
              {/foreach}
            </select>
          </div>
          <!-- genders -->
        {/if}
        {if $system['age_restriction']}
          <!-- birthdate -->
          <div class="flex min-w-0 flex-col gap-2">
            <label class="label-text">{__("Birthdate")}</label>
            <div class="grid grid-cols-3 gap-2">
              <select class="select w-full" name="birth_month" aria-label="{__("Month")}">
                <option value="none">{__("Month")}</option>
                <option {if $user->_data['user_birthdate_parsed']['month'] == '1'}selected{/if} value="1">{__("Jan")}</option>
                <option {if $user->_data['user_birthdate_parsed']['month'] == '2'}selected{/if} value="2">{__("Feb")}</option>
                <option {if $user->_data['user_birthdate_parsed']['month'] == '3'}selected{/if} value="3">{__("Mar")}</option>
                <option {if $user->_data['user_birthdate_parsed']['month'] == '4'}selected{/if} value="4">{__("Apr")}</option>
                <option {if $user->_data['user_birthdate_parsed']['month'] == '5'}selected{/if} value="5">{__("May")}</option>
                <option {if $user->_data['user_birthdate_parsed']['month'] == '6'}selected{/if} value="6">{__("Jun")}</option>
                <option {if $user->_data['user_birthdate_parsed']['month'] == '7'}selected{/if} value="7">{__("Jul")}</option>
                <option {if $user->_data['user_birthdate_parsed']['month'] == '8'}selected{/if} value="8">{__("Aug")}</option>
                <option {if $user->_data['user_birthdate_parsed']['month'] == '9'}selected{/if} value="9">{__("Sep")}</option>
                <option {if $user->_data['user_birthdate_parsed']['month'] == '10'}selected{/if} value="10">{__("Oct")}</option>
                <option {if $user->_data['user_birthdate_parsed']['month'] == '11'}selected{/if} value="11">{__("Nov")}</option>
                <option {if $user->_data['user_birthdate_parsed']['month'] == '12'}selected{/if} value="12">{__("Dec")}</option>
              </select>
              <select class="select w-full" name="birth_day" aria-label="{__("Day")}">
                <option value="none">{__("Day")}</option>
                {for $i=1 to 31}
                  <option {if $user->_data['user_birthdate_parsed']['day'] == $i}selected{/if} value="{$i}">{$i}</option>
                {/for}
              </select>
              <select class="select w-full" name="birth_year" aria-label="{__("Year")}">
                <option value="none">{__("Year")}</option>
                {for $i=1905 to 2023}
                  <option {if $user->_data['user_birthdate_parsed']['year'] == $i}selected{/if} value="{$i}">{$i}</option>
                {/for}
              </select>
            </div>
          </div>
          <!-- birthdate -->
        {/if}
        {if $system['select_user_group_enabled']}
          <!-- user group -->
          <div class="flex min-w-0 flex-col gap-2">
            <label class="label-text" for="signup-user-group">{__("User Group")}</label>
            <select class="select w-full" name="custom_user_group" id="signup-user-group">
              <option value="none">{__("User Group")}:</option>
              <option value="0">{__("Users")}</option>
              {foreach $user_groups as $user_group}
                <option value="{$user_group['user_group_id']}">{__($user_group['user_group_title'])}</option>
              {/foreach}
            </select>
          </div>
          <!-- user group -->
        {/if}
        {if $system['captcha_enabled'] && $system['captcha_provider'] == "recaptcha"}
          <div>
            <!-- reCAPTCHA -->
            <script src='https://www.google.com/recaptcha/api.js' async defer></script>
            <div class="g-recaptcha" data-sitekey="{$system['reCAPTCHA_site_key']}"></div>
            <!-- reCAPTCHA -->
          </div>
        {/if}
        {if $system['captcha_enabled'] && $system['captcha_provider'] == "turnstile"}
          <div>
            <!-- Turnstile -->
            <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
            <div class="cf-turnstile" data-sitekey="{$system['turnstile_site_key']}" data-callback="javascriptCallback"></div>
            <!-- Turnstile -->
          </div>
        {/if}
        {if $system['captcha_enabled'] && $system['captcha_provider'] == "hcaptcha"}
          <div>
            <!-- hCaptcha -->
            <script src="https://js.hcaptcha.com/1/api.js" async defer></script>
            <div class="h-captcha" data-sitekey="{$system['hcaptcha_site_key']}"></div>
            <!-- hCaptcha -->
          </div>
        {/if}
        {* Honeypot *}
        <input type="text" name="field1" style="display:none !important" tabindex="-1" autocomplete="off">
        {* Honeypot *}
        {if $system['newsletter_consent']}
          <!-- newsletter consent -->
          <div class="flex items-start gap-2">
            <input type="checkbox" class="checkbox checkbox-primary mt-0.5" name="newsletter_agree" id="newsletter_agree">
            <label class="label-text text-base-content/80 p-0" for="newsletter_agree">
              {__("I expressly agree to receive the newsletter")}
            </label>
          </div>
          <!-- newsletter consent -->
        {/if}
        <!-- privacy & terms consent -->
        <div class="flex items-start gap-2">
          <input type="checkbox" class="checkbox checkbox-primary mt-0.5" name="privacy_agree" id="privacy_agree">
          <label class="label-text text-base-content/80 p-0" for="privacy_agree">
            {__("By creating your account, you agree to our")} <a href="{$system['system_url']}/static/terms" class="link link-primary" target="_blank">{__("Terms")}</a> {__("and")} <a href="{$system['system_url']}/static/privacy" class="link link-primary" target="_blank">{__("Privacy Policy")}</a>
          </label>
        </div>
        <!-- privacy & terms consent -->
      </div>
      <!-- submit -->
      {if $oauth_app_id}
        <input type="hidden" name="oauth_app_id" value="{$oauth_app_id}">
      {/if}
      <button type="submit" class="heroui button button--primary button--lg button--full-width">{__("Sign Up")}</button>
      <!-- submit -->
      <!-- error -->
      <div class="alert alert-danger alert-error hidden"></div>
      <!-- error -->
    </form>
    {if $system['social_login_enabled']}
      {include file='__social_login.tpl'}
    {/if}
    <p class="mt-6 text-center text-base-content/80">
      {__("Already have an account?")} <a href="{$system['system_url']}/signin" class="js_toggle-panel link link-primary">{__("Sign In")}</a>
    </p>
  </div>
  <!-- signup -->
</div>
