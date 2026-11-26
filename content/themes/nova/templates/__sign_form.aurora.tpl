<div class="w-full">

  <!-- signin -->
  <div class="js_panel {if $do == 'up'}hidden{/if}">
    <div>
      <h2 class="mb-1.5 text-2xl font-semibold">{__("Sign In to your Account")}</h2>
      <p class="text-base-content/80">{__("Welcome back! Please enter your details")}</p>
    </div>
    {if isset($highlight)}
      <div class="alert alert-warning mt-6" role="alert">{$highlight}</div>
    {/if}
    {if $system['social_login_enabled']}
      {include file='__social_login.tpl' _style="plain" _or_pos="bottom"}
    {/if}
    <form class="js_ajax-forms mt-6 flex flex-col gap-5" data-url="core/signin.php" method="POST">
      <!-- username or email -->
      <div class="input-floating">
        <input type="text" class="input input-lg" id="signin-username-email" name="username_email" placeholder='{__("Email")} {__("or")} {__("Username")}' required>
        <label class="input-floating-label" for="signin-username-email">{__("Email")} {__("or")} {__("Username")}</label>
      </div>
      <!-- username or email -->

      <!-- password -->
      <div class="input-floating">
        <div class="input input-lg">
          <input type="password" class="grow" id="signin-password" name="password" placeholder="············" required>
          {include file='__password_toggle.tpl'}
        </div>
        <label class="input-floating-label" for="signin-password">{__("Password")}</label>
      </div>
      <!-- password -->

      <!-- remember me -->
      <div class="flex flex-wrap items-center justify-between gap-2">
        <div class="flex items-center gap-2">
          <input type="checkbox" class="checkbox checkbox-primary" name="remember" id="remember">
          <label class="label-text text-base-content/80 p-0" for="remember">{__("Remember me")}</label>
        </div>
        <a class="link link-animated link-primary" href="{$system['system_url']}/reset">{__("Forgotten password?")}</a>
      </div>
      <!-- remember me -->

      <!-- submit -->
      <button type="submit" class="heroui button button--primary button--lg button--full-width">{__("Sign In")}</button>
      <!-- submit -->

      <!-- error -->
      <div class="alert alert-danger alert-error hidden"></div>
      <!-- error -->
    </form>
    {if $system['registration_enabled']}
      <p class="mt-6 text-center text-base-content/80">
        {__("Do not have an account?")} <a href="{$system['system_url']}/signup{if $oauth_app_id}?oauth_app_id={$oauth_app_id}{/if}" class="js_toggle-panel link link-animated link-primary font-medium">{__("Sign Up")}</a>
      </p>
    {/if}
  </div>
  <!-- signin -->

  <!-- signup -->
  <div class="js_panel {if $do != 'up'}hidden{/if}">
    <div>
      <h2 class="mb-1.5 text-2xl font-semibold">{__("Create a new account")}</h2>
      <p class="text-base-content/80">{__("Welcome to")} {__($system['system_title'])}</p>
    </div>
    {if $system['social_login_enabled']}
      {include file='__social_login.tpl' _style="plain" _or_pos="bottom"}
    {/if}
    <form class="js_ajax-forms mt-6 flex flex-col gap-5" data-url="core/signup.php" method="POST">
      {if $system['invitation_enabled']}
        <!-- invitation code -->
        <div class="input-floating">
          <input name="invitation_code" type="text" class="input input-lg" id="signup-invitation-code" placeholder='{__("Invitation Code")}' value="{$invitation_code}" required>
          <label class="input-floating-label" for="signup-invitation-code">{__("Invitation Code")}</label>
        </div>
        <!-- invitation code -->
      {/if}
      {if !$system['show_usernames_enabled']}
        <div class="grid gap-5 sm:grid-cols-2">
          <!-- first name -->
          <div class="input-floating">
            <input name="first_name" type="text" class="input input-lg" id="signup-first-name" placeholder='{__("First name")}' required>
            <label class="input-floating-label" for="signup-first-name">{__("First name")}</label>
          </div>
          <!-- first name -->
          <!-- last name -->
          <div class="input-floating">
            <input name="last_name" type="text" class="input input-lg" id="signup-last-name" placeholder='{__("Last name")}' required>
            <label class="input-floating-label" for="signup-last-name">{__("Last name")}</label>
          </div>
          <!-- last name -->
        </div>
      {/if}
      <!-- username -->
      <div class="input-floating">
        <input name="username" type="text" class="input input-lg" id="signup-username" placeholder='{__("Username")}' required>
        <label class="input-floating-label" for="signup-username">{__("Username")}</label>
      </div>
      <!-- username -->
      <!-- email -->
      <div class="input-floating">
        <input name="email" type="email" class="input input-lg" id="signup-email" placeholder='{__("Email")}' required>
        <label class="input-floating-label" for="signup-email">{__("Email")}</label>
      </div>
      <!-- email -->
      {if $system['activation_enabled'] && $system['activation_type'] == "sms"}
        <!-- phone -->
        <div class="input-floating">
          <input name="phone" type="text" class="input input-lg" id="signup-phone" placeholder='{__("Phone number (e.g: +1234567890)")}' required>
          <label class="input-floating-label" for="signup-phone">{__("Phone number")}</label>
        </div>
        <!-- phone -->
      {/if}
      <!-- password -->
      <div class="input-floating">
        <div class="input input-lg">
          <input name="password" type="password" class="grow" id="signup-password" placeholder="············" required>
          {include file='__password_toggle.tpl'}
        </div>
        <label class="input-floating-label" for="signup-password">{__("Password")}</label>
      </div>
      <!-- password -->
      <!-- custom fields -->
      {if $custom_fields}
        {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true}
      {/if}
      <!-- custom fields -->
      <div class="js_hidden-section hidden space-y-5">
        {include file='__sign_form_extras.tpl' _floating=true _select_class="select select-lg" _checkbox_class="checkbox checkbox-primary"}
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
    <p class="mt-6 text-center text-base-content/80">
      {__("Already have an account?")} <a href="{$system['system_url']}/signin" class="js_toggle-panel link link-animated link-primary font-medium">{__("Sign In")}</a>
    </p>
  </div>
  <!-- signup -->
</div>