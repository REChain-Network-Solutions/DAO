<div class="w-full">

  <!-- signin -->
  <div class="js_panel {if $do == 'up'}hidden{/if}">
    <div class="mb-8">
      <h2 class="text-3xl font-semibold tracking-tight">{if $_liquid_form|default:false}{__("Welcome back")}{else}{__("Sign In to your Account")}{/if}</h2>
      <p class="mt-2 text-base-content/70">{if $_liquid_form|default:false}{__("Sign in to pick up where you left off.")}{else}{__("Welcome back! Please enter your details")}{/if}</p>
    </div>
    {if isset($highlight)}
      <div class="alert alert-warning mt-6" role="alert">{$highlight}</div>
    {/if}
    {if $system['social_login_enabled'] && !($_liquid_form|default:false)}
      {include file='__social_login.tpl' _style="plain" _or_pos="bottom" _margin="mt-0"}
    {/if}
    <form class="js_ajax-forms flex flex-col gap-5" data-url="core/signin.php" method="POST">
      <!-- username or email -->
      <div class="{if $_liquid_form|default:false}flex min-w-0 flex-col{elseif $_plain_signin|default:false}w-full{else}input-floating{/if}">
        <input type="text" class="input input-lg" id="signin-username-email" name="username_email" placeholder='{__("Email")} {__("or")} {__("Username")}' required>
        <label class="{if $_liquid_form|default:false}order-first mb-1.5 text-sm font-semibold{elseif $_plain_signin|default:false}sr-only{else}input-floating-label{/if}" for="signin-username-email">{__("Email")} {__("or")} {__("Username")}</label>
      </div>
      <!-- username or email -->

      <!-- password -->
      <div class="{if $_liquid_form|default:false}flex min-w-0 flex-col{elseif $_plain_signin|default:false}w-full{else}input-floating{/if}">
        <div class="input input-lg">
          <input type="password" class="grow" id="signin-password" name="password" placeholder="{if $_liquid_form|default:false}············{else}{__("Password")}{/if}" required>
          {include file='__password_toggle.tpl'}
        </div>
        <label class="{if $_liquid_form|default:false}order-first mb-1.5 text-sm font-semibold{elseif $_plain_signin|default:false}sr-only{else}input-floating-label{/if}" for="signin-password">{__("Password")}</label>
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
      <button type="submit" class="heroui button button--primary button--lg button--full-width{if $_submit_arrow|default:false} group relative{/if}">{__("Sign In")}{if $_submit_arrow|default:false}<span class="absolute end-4 inline-block transition-transform group-hover:translate-x-0.5 group-hover:-translate-y-0.5 motion-reduce:transition-none icon-[tabler--arrow-up-right] size-5" aria-hidden="true"></span>{/if}</button>
      <!-- submit -->

      <!-- error -->
      <div class="alert alert-danger alert-error hidden"></div>
      <!-- error -->
    </form>
    {if $system['social_login_enabled'] && ($_liquid_form|default:false)}
      {include file='__social_login.tpl' _style="liquid" _or_pos="top" _margin="mt-5"}
    {/if}
    {if $system['registration_enabled']}
      <p class="mt-8 text-center text-base-content/80">
        {__("Do not have an account?")} <a href="{$system['system_url']}/signup{if $oauth_app_id}?oauth_app_id={$oauth_app_id}{/if}" class="js_toggle-panel link link-primary font-medium">{__("Sign Up")}</a>
      </p>
    {/if}
  </div>
  <!-- signin -->

  <!-- signup -->
  <div class="js_panel {if $do != 'up'}hidden{/if}">
    <div class="mb-8">
      <h2 class="text-3xl font-semibold tracking-tight">{if $_liquid_form|default:false}{__("Create an account")}{else}{__("Create a new account")}{/if}</h2>
      <p class="mt-2 text-base-content/70">{__("Welcome to")} {__($system['system_title'])}</p>
    </div>
    {if $system['social_login_enabled'] && !($_liquid_form|default:false)}
      {include file='__social_login.tpl' _style="plain" _or_pos="bottom" _margin="mt-0"}
    {/if}
    <form class="js_ajax-forms flex flex-col gap-5" data-url="core/signup.php" method="POST">
      {if $system['invitation_enabled']}
        <!-- invitation code -->
        <div class="{if $_liquid_form|default:false}flex min-w-0 flex-col{elseif $_plain_signup|default:false}w-full{else}input-floating{/if}">
          <input name="invitation_code" type="text" class="input input-lg" id="signup-invitation-code" placeholder='{__("Invitation Code")}' value="{$invitation_code}" required>
          <label class="{if $_liquid_form|default:false}order-first mb-1.5 text-sm font-semibold{elseif $_plain_signup|default:false}sr-only{else}input-floating-label{/if}" for="signup-invitation-code">{__("Invitation Code")}</label>
        </div>
        <!-- invitation code -->
      {/if}
      {if !$system['show_usernames_enabled']}
        <div class="grid gap-5 sm:grid-cols-2">
          <!-- first name -->
          <div class="{if $_liquid_form|default:false}flex min-w-0 flex-col{elseif $_plain_signup|default:false}w-full{else}input-floating{/if}">
            <input name="first_name" type="text" class="input input-lg" id="signup-first-name" placeholder='{__("First name")}' required>
            <label class="{if $_liquid_form|default:false}order-first mb-1.5 text-sm font-semibold{elseif $_plain_signup|default:false}sr-only{else}input-floating-label{/if}" for="signup-first-name">{__("First name")}</label>
          </div>
          <!-- first name -->
          <!-- last name -->
          <div class="{if $_liquid_form|default:false}flex min-w-0 flex-col{elseif $_plain_signup|default:false}w-full{else}input-floating{/if}">
            <input name="last_name" type="text" class="input input-lg" id="signup-last-name" placeholder='{__("Last name")}' required>
            <label class="{if $_liquid_form|default:false}order-first mb-1.5 text-sm font-semibold{elseif $_plain_signup|default:false}sr-only{else}input-floating-label{/if}" for="signup-last-name">{__("Last name")}</label>
          </div>
          <!-- last name -->
        </div>
      {/if}
      <!-- username -->
      <div class="{if $_liquid_form|default:false}flex min-w-0 flex-col{elseif $_plain_signup|default:false}w-full{else}input-floating{/if}">
        <input name="username" type="text" class="input input-lg" id="signup-username" placeholder='{__("Username")}' required>
        <label class="{if $_liquid_form|default:false}order-first mb-1.5 text-sm font-semibold{elseif $_plain_signup|default:false}sr-only{else}input-floating-label{/if}" for="signup-username">{__("Username")}</label>
      </div>
      <!-- username -->
      <!-- email -->
      <div class="{if $_liquid_form|default:false}flex min-w-0 flex-col{elseif $_plain_signup|default:false}w-full{else}input-floating{/if}">
        <input name="email" type="email" class="input input-lg" id="signup-email" placeholder='{__("Email")}' required>
        <label class="{if $_liquid_form|default:false}order-first mb-1.5 text-sm font-semibold{elseif $_plain_signup|default:false}sr-only{else}input-floating-label{/if}" for="signup-email">{__("Email")}</label>
      </div>
      <!-- email -->
      {if $system['activation_enabled'] && $system['activation_type'] == "sms"}
        <!-- phone -->
        <div class="{if $_liquid_form|default:false}flex min-w-0 flex-col{elseif $_plain_signup|default:false}w-full{else}input-floating{/if}">
          <input name="phone" type="text" class="input input-lg" id="signup-phone" placeholder='{__("Phone number (e.g: +1234567890)")}' required>
          <label class="{if $_liquid_form|default:false}order-first mb-1.5 text-sm font-semibold{elseif $_plain_signup|default:false}sr-only{else}input-floating-label{/if}" for="signup-phone">{__("Phone number")}</label>
        </div>
        <!-- phone -->
      {/if}
      <!-- password -->
      <div class="{if $_liquid_form|default:false}flex min-w-0 flex-col{elseif $_plain_signup|default:false}w-full{else}input-floating{/if}">
        <div class="input input-lg">
          <input name="password" type="password" class="grow" id="signup-password" placeholder="{if $_liquid_form|default:false}············{else}{__("Password")}{/if}" required>
          {include file='__password_toggle.tpl'}
        </div>
        <label class="{if $_liquid_form|default:false}order-first mb-1.5 text-sm font-semibold{elseif $_plain_signup|default:false}sr-only{else}input-floating-label{/if}" for="signup-password">{__("Password")}</label>
      </div>
      <!-- password -->
      <!-- custom fields -->
      {if $custom_fields}
        {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true}
      {/if}
      <!-- custom fields -->
      <div class="js_hidden-section hidden space-y-5">
        {if ($_plain_signup|default:false) || ($_liquid_form|default:false)}
          {include file='__sign_form_extras.tpl' _floating=false _select_class="select select-lg" _checkbox_class="checkbox checkbox-primary"}
        {else}
          {include file='__sign_form_extras.tpl' _floating=true _select_class="select select-lg" _checkbox_class="checkbox checkbox-primary"}
        {/if}
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
    {if $system['social_login_enabled'] && ($_liquid_form|default:false)}
      {include file='__social_login.tpl' _style="liquid" _or_pos="top" _margin="mt-5"}
    {/if}
    <p class="mt-8 text-center text-base-content/80">
      {__("Already have an account?")} <a href="{$system['system_url']}/signin" class="js_toggle-panel link link-primary font-medium">{__("Sign In")}</a>
    </p>
  </div>
  <!-- signup -->
</div>
