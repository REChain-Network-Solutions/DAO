{assign var="_field" value='input input-lg rounded-xl bg-base-content/5! [--input-color:transparent]! focus-within:[--input-color:var(--color-primary)]!'}
{assign var="_icon" value='my-auto me-3 size-5 shrink-0 text-base-content/50'}
{assign var="_tab" value='heroui button button--ghost rounded-full px-6 font-medium text-base-content/70 hover:bg-transparent hover:text-base-content active-tab:bg-primary active-tab:text-primary-content active-tab:hover:bg-primary active-tab:hover:text-primary-content'}
<div class="w-full">

  {if $system['registration_enabled']}
    <!-- tabs -->
    <div class="mb-10 flex justify-center">
      <nav class="tabs gap-1 rounded-full bg-base-content/5 p-1" aria-label="{__("Sign In")}" role="tablist" aria-orientation="horizontal">
        <button type="button" class="{$_tab}{if $do != 'up'} active{/if}" id="studio-tab-signin" data-tab="#studio-signin" aria-controls="studio-signin" role="tab" aria-selected="{if $do != 'up'}true{else}false{/if}">{__("Sign In")}</button>
        <button type="button" class="{$_tab}{if $do == 'up'} active{/if}" id="studio-tab-signup" data-tab="#studio-signup" aria-controls="studio-signup" role="tab" aria-selected="{if $do == 'up'}true{else}false{/if}">{__("Sign Up")}</button>
      </nav>
    </div>
    <!-- tabs -->
  {/if}

  <!-- signin -->
  <div id="studio-signin" class="js_panel{if $do == 'up'} hidden{/if}" role="tabpanel" aria-labelledby="studio-tab-signin">
    <div class="mb-8 text-center">
      <h2 class="text-3xl font-semibold tracking-tight">{__("Sign In to your Account")}</h2>
      <p class="mt-2 text-base-content/60">{__("Welcome back! Please enter your details")}</p>
    </div>
    {if isset($highlight)}
      <div class="alert alert-warning mb-5 rounded-xl" role="alert">{$highlight}</div>
    {/if}
    <form class="js_ajax-forms flex flex-col gap-4" data-url="core/signin.php" method="POST">
      <!-- username or email -->
      <div class="{$_field}">
        <span class="icon-[tabler--user] {$_icon}" aria-hidden="true"></span>
        <label class="sr-only" for="signin-username-email">{__("Email")} {__("or")} {__("Username")}</label>
        <input type="text" class="grow" id="signin-username-email" name="username_email" placeholder='{__("Email")} {__("or")} {__("Username")}' required>
      </div>
      <!-- username or email -->

      <!-- password -->
      <div class="{$_field}">
        <span class="icon-[tabler--lock] {$_icon}" aria-hidden="true"></span>
        <label class="sr-only" for="signin-password">{__("Password")}</label>
        <input type="password" class="grow" id="signin-password" name="password" placeholder='{__("Password")}' required>
        {include file='__password_toggle.tpl'}
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
      <button type="submit" class="heroui button button--primary button--lg button--full-width mt-2 rounded-[0.75rem] shadow-none">{__("Sign In")}</button>
      <!-- submit -->

      <!-- error -->
      <div class="alert alert-danger alert-error hidden rounded-xl"></div>
      <!-- error -->
    </form>
    {if $system['social_login_enabled']}
      {include file='__social_login.tpl' _style="studio"}
    {/if}
  </div>
  <!-- signin -->

  <!-- signup -->
  <div id="studio-signup" class="js_panel{if $do != 'up'} hidden{/if}" role="tabpanel" aria-labelledby="studio-tab-signup">
    <div class="mb-8 text-center">
      <h2 class="text-3xl font-semibold tracking-tight">{__("Create a new account")}</h2>
      <p class="mt-2 text-base-content/60">{__("Welcome to")} {__($system['system_title'])}</p>
    </div>
    <form class="js_ajax-forms flex flex-col gap-4" data-url="core/signup.php" method="POST">
      {if $system['invitation_enabled']}
        <!-- invitation code -->
        <div class="{$_field}">
          <span class="icon-[tabler--ticket] {$_icon}" aria-hidden="true"></span>
          <label class="sr-only" for="signup-invitation-code">{__("Invitation Code")}</label>
          <input name="invitation_code" type="text" class="grow" id="signup-invitation-code" placeholder='{__("Invitation Code")}' value="{$invitation_code}" required>
        </div>
        <!-- invitation code -->
      {/if}
      {if !$system['show_usernames_enabled']}
        <div class="grid gap-4 sm:grid-cols-2">
          <!-- first name -->
          <div class="{$_field}">
            <span class="icon-[tabler--id] {$_icon}" aria-hidden="true"></span>
            <label class="sr-only" for="signup-first-name">{__("First name")}</label>
            <input name="first_name" type="text" class="grow min-w-0" id="signup-first-name" placeholder='{__("First name")}' required>
          </div>
          <!-- first name -->
          <!-- last name -->
          <div class="{$_field}">
            <span class="icon-[tabler--id] {$_icon}" aria-hidden="true"></span>
            <label class="sr-only" for="signup-last-name">{__("Last name")}</label>
            <input name="last_name" type="text" class="grow min-w-0" id="signup-last-name" placeholder='{__("Last name")}' required>
          </div>
          <!-- last name -->
        </div>
      {/if}
      <!-- username -->
      <div class="{$_field}">
        <span class="icon-[tabler--at] {$_icon}" aria-hidden="true"></span>
        <label class="sr-only" for="signup-username">{__("Username")}</label>
        <input name="username" type="text" class="grow" id="signup-username" placeholder='{__("Username")}' required>
      </div>
      <!-- username -->
      <!-- email -->
      <div class="{$_field}">
        <span class="icon-[tabler--mail] {$_icon}" aria-hidden="true"></span>
        <label class="sr-only" for="signup-email">{__("Email")}</label>
        <input name="email" type="email" class="grow" id="signup-email" placeholder='{__("Email")}' required>
      </div>
      <!-- email -->
      {if $system['activation_enabled'] && $system['activation_type'] == "sms"}
        <!-- phone -->
        <div class="{$_field}">
          <span class="icon-[tabler--phone] {$_icon}" aria-hidden="true"></span>
          <label class="sr-only" for="signup-phone">{__("Phone number")}</label>
          <input name="phone" type="text" class="grow" id="signup-phone" placeholder='{__("Phone number (e.g: +1234567890)")}' required>
        </div>
        <!-- phone -->
      {/if}
      <!-- password -->
      <div class="{$_field}">
        <span class="icon-[tabler--lock] {$_icon}" aria-hidden="true"></span>
        <label class="sr-only" for="signup-password">{__("Password")}</label>
        <input name="password" type="password" class="grow" id="signup-password" placeholder='{__("Password")}' required>
        {include file='__password_toggle.tpl'}
      </div>
      <!-- password -->
      <!-- custom fields -->
      {if $custom_fields}
        {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true _input_class="input w-full rounded-xl" _select_class="select w-full rounded-xl" _textarea_class="textarea w-full rounded-xl"}
      {/if}
      <!-- custom fields -->
      <div class="js_hidden-section hidden space-y-4">
        {include file='__sign_form_extras.tpl' _floating=false _select_class="select select-lg rounded-xl" _checkbox_class="checkbox checkbox-primary"}
      </div>
      <!-- submit -->
      {if $oauth_app_id}
        <input type="hidden" name="oauth_app_id" value="{$oauth_app_id}">
      {/if}
      <button type="submit" class="heroui button button--primary button--lg button--full-width mt-2 rounded-[0.75rem] shadow-none">{__("Sign Up")}</button>
      <!-- submit -->
      <!-- error -->
      <div class="alert alert-danger alert-error hidden rounded-xl"></div>
      <!-- error -->
    </form>
    {if $system['social_login_enabled']}
      {include file='__social_login.tpl' _style="studio"}
    {/if}
  </div>
  <!-- signup -->
</div>
