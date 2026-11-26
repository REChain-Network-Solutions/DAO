{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {include file='__page_header.tpl' _title=__("Contact Us") _text=__("Contact us and we will contact you back") _image="contacts.svg"}
  <!-- page heading -->

  <div class="mt-6 grid gap-6 lg:grid-cols-[minmax(0,1fr)_20rem] lg:items-start">

    <!-- form -->
    <div class="rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-base-100">
      <form class="js_ajax-forms flex flex-col gap-6 p-5 sm:p-8" data-url="core/contact.php" method="POST">
        <div class="flex items-center gap-3">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-base-200 text-base-content" aria-hidden="true">
            <span class="icon-[tabler--mail] size-5"></span>
          </span>
          <h2 class="text-lg font-semibold">{__("Send us a message")}</h2>
        </div>
        <div class="flex flex-col gap-5">
          <div class="grid gap-5 sm:grid-cols-2">
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="contact-name">{__("Name")} <span class="text-error">*</span></label>
              <label class="input w-full">
                <span class="icon-[tabler--user] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
                <input type="text" class="grow" id="contact-name" name="name" required>
              </label>
            </div>
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="contact-email">{__("Email")} <span class="text-error">*</span></label>
              <label class="input w-full">
                <span class="icon-[tabler--at] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
                <input type="email" class="grow" id="contact-email" name="email" required>
              </label>
            </div>
          </div>
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="contact-subject">{__("Subject")} <span class="text-error">*</span></label>
            <label class="input w-full">
              <span class="icon-[tabler--tag] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
              <input type="text" class="grow" id="contact-subject" name="subject" required>
            </label>
          </div>
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="contact-message">{__("Message")} <span class="text-error">*</span></label>
            <textarea class="textarea w-full" id="contact-message" name="message" rows="6" required></textarea>
          </div>

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

          <!-- success -->
          <div class="alert alert-success hidden items-center" role="status"></div>
          <!-- success -->

          <!-- error -->
          <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
          <!-- error -->
        </div>
        <div class="flex justify-end">
          <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] px-6">
            <span class="icon-[tabler--send] size-4" aria-hidden="true"></span>
            {__("Send")}
          </button>
        </div>
      </form>
    </div>
    <!-- form -->

    <!-- aside -->
    <aside class="flex flex-col gap-6 lg:sticky lg:top-24">
      {if $system['support_center_enabled']}
        <!-- support -->
        <div class="rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[radial-gradient(circle_at_90%_0%,rgb(124_105_242/0.55),transparent_55%),radial-gradient(circle_at_60%_25%,rgb(56_189_248/0.35),transparent_50%),linear-gradient(165deg,#d8f1fb,#dde8fb_55%,#d3f2fd)] p-5 text-slate-900">
          {$_support_icon = ''}{if $system['system_theme_icons'] == 'svg'}{$_support_icon = 'support'|theme_module_icon:'size-12'}{/if}
          {if $_support_icon}
            {$_support_icon}
          {else}
            <span class="flex size-12 items-center justify-center rounded-full bg-info text-info-content">
              <span class="icon-[tabler--lifebuoy] size-6" aria-hidden="true"></span>
            </span>
          {/if}
          <h2 class="mt-4 text-base font-semibold text-slate-900">{__("Support Center")}</h2>
          <p class="mt-1 text-xs text-slate-600">{__("Already have an issue? Open a support ticket and follow its progress in one place")}</p>
          <a class="heroui button button--primary [--button-bg:var(--color-info)] [--button-bg-hover:color-mix(in_oklab,var(--color-info)_90%,black)] [--button-bg-pressed:color-mix(in_oklab,var(--color-info)_90%,black)] [--button-fg:var(--color-info-content)] mt-4 w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/support">{__("Open a support ticket")}</a>
        </div>
        <!-- support -->
      {/if}
    </aside>
    <!-- aside -->

  </div>

</div>
<!-- page content -->

{include file='_footer.tpl'}
