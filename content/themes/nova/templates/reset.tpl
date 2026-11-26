{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
{capture name="auth_content"}
  <div class="text-center">
    <h2 class="mb-1.5 text-2xl font-semibold">{__("Forgot your password?")}</h2>
    <p class="text-base-content/80">{__("Enter the email address associated with your account and we will send you a link to reset your password.")}</p>
  </div>
  <form class="js_ajax-forms mt-6 flex flex-col gap-5" data-url="core/forget_password.php">
    <!-- email -->
    <div class="input-floating">
      <input name="email" type="email" class="input input-lg" id="reset-email" placeholder='{__("Email")}' required>
      <label class="input-floating-label" for="reset-email">{__("Email")}</label>
    </div>
    <!-- email -->

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

    <!-- submit -->
    <input type="hidden" name="secret" value="{$secret}">
    <button type="submit" class="heroui button button--primary button--lg button--full-width">{__("Continue")}</button>
    <!-- submit -->

    <!-- error -->
    <div class="alert alert-danger alert-error hidden"></div>
    <!-- error -->
  </form>
  <p class="mt-6 text-center text-base-content/80">
    <a href="{$system['system_url']}/signin" class="link link-animated link-primary font-medium">{__("Back to Signin")}</a>
  </p>
  {if $system['registration_enabled']}
    <p class="mt-2 text-center text-base-content/80">
      {__("Do not have an account?")} <a href="{$system['system_url']}/signup" class="link link-animated link-primary font-medium">{__("Sign Up")}</a>
    </p>
  {/if}
{/capture}
{include file='__auth_card.tpl'}
<!-- page content -->

{include file='_footer.tpl'}