{strip}
  {include file='_js_templates.core.tpl'}

  <!-- Two-Factor Authentication -->
  <script id="two-factor-authentication" type="text/template">
    {include file='__modal_header.tpl' _icon="icon-[tabler--shield-lock]" _title=__("2FA Authentication")}
    <form class="js_ajax-forms" data-url="core/two_factor_authentication.php">
      <div class="modal__body flex flex-col gap-4">
        <p class="text-sm text-base-content/70">{__("You've asked us to require a 6-digit login code when anyone tries to access your account from a new device or browser")}.</p>
        <p class="text-sm text-base-content/70">{__("Enter the 6-digit code that you received on your")} <strong>{literal}{{method}}{/literal}</strong></p>
        <input class="input w-full font-mono tracking-widest [--border:1px]" name="two_factor_key" type="text" placeholder="######" required autofocus aria-label='{__("Verification Code")}'>
        <!-- error -->
        <div class="alert alert-soft alert-error alert-danger hidden"></div>
        <!-- error -->
      </div>
      <div class="modal__footer justify-end gap-2">
        <input name="user_id" type="hidden" value="{literal}{{user_id}}{/literal}">
        {literal}{{#remember}}{/literal}<input name="remember" type="hidden" value="true">{literal}{{/remember}}{/literal}
        {literal}{{#connecting_account}}{/literal}<input name="connecting_account" type="hidden" value="true">{literal}{{/connecting_account}}{/literal}
        <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
        <button type="submit" class="button button--primary">{__("Continue")}</button>
      </div>
    </form>
  </script>
  <!-- Two-Factor Authentication -->

  {if !$user->_logged_in}

    <!-- Forget Password -->
    <script id="forget-password-confirm" type="text/template">
      {include file='__modal_header.tpl' _icon="icon-[tabler--key]" _title=__("Verification Code")}
      <form class="js_ajax-forms" data-url="core/forget_password_confirm.php">
        <div class="modal__body flex flex-col gap-4">
          <p class="text-sm text-base-content/70">{__("We sent you an email with a six-digit verification code. Enter it below to continue to reset your password")}.</p>
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="reset-key">{__("Verification Code")}</label>
            <input class="input w-full font-mono tracking-widest [--border:1px]" name="reset_key" id="reset-key" type="text" placeholder="######" required autofocus>
            <p class="mt-1.5 text-sm text-base-content/60">{__("We sent your code to")} <span class="font-medium text-base-content">{literal}{{email}}{/literal}</span></p>
          </div>
          <!-- error -->
          <div class="alert alert-soft alert-error alert-danger hidden"></div>
          <!-- error -->
        </div>
        <div class="modal__footer justify-end gap-2">
          <input name="email" type="hidden" value="{literal}{{email}}{/literal}">
          <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
          <button type="submit" class="button button--primary">{__("Continue")}</button>
        </div>
      </form>
    </script>

    <script id="forget-password-reset" type="text/template">
      {include file='__modal_header.tpl' _icon="icon-[tabler--key]" _title=__("Change Your Password")}
      <form class="js_ajax-forms" data-url="core/forget_password_reset.php">
        <div class="modal__body flex flex-col gap-4">
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="password">{__("New Password")}</label>
            <input class="input w-full [--border:1px]" name="password" id="password" type="password" required autofocus>
          </div>
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="confirm">{__("Confirm Password")}</label>
            <input class="input w-full [--border:1px]" name="confirm" id="confirm" type="password" required>
          </div>
          <!-- error -->
          <div class="alert alert-soft alert-error alert-danger hidden"></div>
          <!-- error -->
        </div>
        <div class="modal__footer justify-end gap-2">
          <input name="email" type="hidden" value="{literal}{{email}}{/literal}">
          <input name="reset_key" type="hidden" value="{literal}{{reset_key}}{/literal}">
          <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
          <button type="submit" class="button button--primary">{__("Continue")}</button>
        </div>
      </form>
    </script>
    <!-- Forget Password -->

  {else}

    <!-- Account Switcher -->
    <script id="account-switcher" type="text/template">
      {include file='__modal_header.tpl' _icon="icon-[tabler--switch-horizontal]" _title=__("Switch Accounts")}
      <div class="modal__body flex flex-col gap-4">
        {include file='__connected_accounts.tpl' _add_account=true}
        <a class="link link-hover inline-flex items-center gap-1.5 self-center text-sm text-base-content/60" href="{$system['system_url']}/settings/accounts">
          <span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>
          {__("Manage")} {__("Connected Accounts")}
        </a>
      </div>
    </script>

    <script id="account-connector" type="text/template">
      {include file='__modal_header.tpl' _icon="icon-[tabler--user-plus]" _title=__("Connect Accounts")}
      <form class="js_ajax-forms" data-url="users/switch.php" method="POST">
        <div class="modal__body flex flex-col gap-4">
          <!-- accounts -->
          <div class="flex items-center justify-center gap-4 rounded-[1rem] bg-base-200/60 py-6" aria-hidden="true">
            <img class="size-14 rounded-full object-cover ring-4 ring-base-100" src="{$user->_data['user_picture']}" alt="">
            <span class="flex size-9 items-center justify-center rounded-full bg-base-100 text-base-content/60 shadow-sm">
              <span class="icon-[tabler--arrows-exchange] size-5"></span>
            </span>
            <span class="flex size-14 items-center justify-center rounded-full border-2 border-dashed border-base-content/25 bg-base-100 text-base-content/40">
              <span class="icon-[tabler--user-plus] size-6"></span>
            </span>
          </div>
          <!-- accounts -->
          <!-- username or email -->
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="account-connector-username">{__("Email")} {__("or")} {__("Username")}</label>
            <div class="input w-full [--border:1px]">
              <span class="icon-[tabler--user] my-auto me-2 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
              <input class="grow" type="text" id="account-connector-username" name="username_email" autocomplete="username" required>
            </div>
          </div>
          <!-- username or email -->
          <!-- password -->
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="account-connector-password">{__("Password")}</label>
            <div class="input w-full [--border:1px]">
              <span class="icon-[tabler--lock] my-auto me-2 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
              <input class="grow" type="password" id="account-connector-password" name="password" autocomplete="current-password" required>
              <button type="button" class="js_toggle-password my-auto cursor-pointer text-base-content/50 hover:text-base-content" aria-label="{__("Password")}">
                <svg class="eye-icon size-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 12a2 2 0 1 0 4 0a2 2 0 0 0 -4 0" /><path d="M21 12c-2.4 4 -5.4 6 -9 6c-3.6 0 -6.6 -2 -9 -6c2.4 -4 5.4 -6 9 -6c3.6 0 6.6 2 9 6" /></svg>
                <svg class="eye-icon-slash hidden size-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.585 10.587a2 2 0 0 0 2.829 2.828" /><path d="M16.681 16.673a8.717 8.717 0 0 1 -4.681 1.327c-3.6 0 -6.6 -2 -9 -6c1.272 -2.12 2.712 -3.678 4.32 -4.674m2.86 -1.146a9.055 9.055 0 0 1 1.82 -.18c3.6 0 6.6 2 9 6c-.666 1.11 -1.379 2.067 -2.138 2.87" /><path d="M3 3l18 18" /></svg>
              </button>
            </div>
          </div>
          <!-- password -->
          <!-- error -->
          <div class="alert alert-soft alert-error alert-danger hidden"></div>
          <!-- error -->
        </div>
        <div class="modal__footer justify-end gap-2">
          <input type="hidden" name="do" value="signin">
          <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
          <button type="submit" class="button button--primary">{__("Login")}</button>
        </div>
      </form>
    </script>
    <!-- Account Switcher -->

    <!-- Email Activation -->
    <script id="activation-email" type="text/template">
      {include file='__modal_header.tpl' _icon="icon-[tabler--mail]" _title=__("Enter the code from the email")}
      <form class="js_ajax-forms" data-url="core/activation_email.php">
        <div class="modal__body flex flex-col gap-4">
          <p class="text-sm text-base-content/70">{__("Let us know if this email belongs to you. Enter the code in the email")}</p>
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="activation-email-code">{__("Verification Code")}</label>
            <input class="input w-full font-mono tracking-widest [--border:1px]" name="code" id="activation-email-code" type="text" placeholder="######" required autofocus>
            {if $user->_data['user_email']}
              <p class="mt-1.5 text-sm text-base-content/60">
                {__("We sent your code to")} <span class="font-medium text-base-content">{$user->_data['user_email']}</span> ·
                <button type="button" class="js_modal link link-primary" data-url="core/activation_email_resend.php">{__("Resend Email")}</button>
              </p>
            {/if}
          </div>
          <!-- error -->
          <div class="alert alert-soft alert-error alert-danger hidden"></div>
          <!-- error -->
        </div>
        <div class="modal__footer justify-end gap-2">
          <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
          <button type="submit" class="button button--primary">{__("Continue")}</button>
        </div>
      </form>
    </script>

    <script id="activation-email-reset" type="text/template">
      {include file='__modal_header.tpl' _icon="icon-[tabler--mail]" _title=__("Change Email Address")}
      <form class="js_ajax-forms" data-url="core/activation_email_reset.php">
        <div class="modal__body flex flex-col gap-4">
          <div class="w-full">
            <span class="label-text mb-1.5 block">{__("Current Email")}</span>
            <p class="text-sm font-medium text-base-content">{$user->_data['user_email']}</p>
          </div>
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="email">{__("New Email")}</label>
            <input class="input w-full [--border:1px]" name="email" id="email" type="email" required autofocus>
          </div>
          <!-- error -->
          <div class="alert alert-soft alert-error alert-danger hidden"></div>
          <!-- error -->
        </div>
        <div class="modal__footer justify-end gap-2">
          <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
          <button type="submit" class="button button--primary">{__("Continue")}</button>
        </div>
      </form>
    </script>
    <!-- Email Activation -->

    <!-- Phone Activation -->
    <script id="activation-phone" type="text/template">
      {include file='__modal_header.tpl' _icon="icon-[tabler--device-mobile]" _title=__("Enter the code from the SMS message")}
      <form class="js_ajax-forms" data-url="core/activation_phone.php">
        <div class="modal__body flex flex-col gap-4">
          <p class="text-sm text-base-content/70">{__("Let us know if this mobile number belongs to you. Enter the code in the SMS")}</p>
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="activation-phone-code">{__("Verification Code")}</label>
            <input class="input w-full font-mono tracking-widest [--border:1px]" name="code" id="activation-phone-code" type="text" placeholder="######" required autofocus>
            {if $user->_data['user_phone']}
              <p class="mt-1.5 text-sm text-base-content/60">
                {__("We sent your code to")} <span class="font-medium text-base-content" dir="ltr">{$user->_data['user_phone']}</span> ·
                <button type="button" class="js_modal link link-primary" data-url="core/activation_phone_resend.php">{__("Resend SMS")}</button>
              </p>
            {/if}
          </div>
          <!-- error -->
          <div class="alert alert-soft alert-error alert-danger hidden"></div>
          <!-- error -->
        </div>
        <div class="modal__footer justify-end gap-2">
          <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
          <button type="submit" class="button button--primary">{__("Continue")}</button>
        </div>
      </form>
    </script>

    <script id="activation-phone-reset" type="text/template">
      {include file='__modal_header.tpl' _icon="icon-[tabler--device-mobile]" _title=__("Change Phone Number")}
      <form class="js_ajax-forms" data-url="core/activation_phone_reset.php">
        <div class="modal__body flex flex-col gap-4">
          {if $user->_data['user_phone']}
            <div class="w-full">
              <span class="label-text mb-1.5 block">{__("Current Phone")}</span>
              <p class="text-sm font-medium text-base-content" dir="ltr">{$user->_data['user_phone']}</p>
            </div>
          {/if}
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="activation-phone-reset-phone">{__("New Phone")}</label>
            <input class="input w-full [--border:1px]" name="phone" type="text" required autofocus id="activation-phone-reset-phone">
            <p class="mt-1.5 text-sm text-base-content/60">{__("For example")}: +12344567890</p>
          </div>
          <!-- error -->
          <div class="alert alert-soft alert-error alert-danger hidden"></div>
          <!-- error -->
        </div>
        <div class="modal__footer justify-end gap-2">
          <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
          <button type="submit" class="button button--primary">{__("Continue")}</button>
        </div>
      </form>
    </script>
    <!-- Phone Activation -->

    <!-- x-uploader -->
    {/strip}
    {include file='_js_templates.uploader.tpl'}
    {strip}
    <!-- x-uploader -->

    {include file='_js_templates.chat.tpl'}

    {if $system['stories_enabled']}
      {/strip}
      {include file='_js_templates.stories.tpl'}
      {strip}
    {/if}

    <!-- Adblock Detector -->
    {if $system['adblock_detector_enabled']}
      <script id="adblock-detector" type="text/template">
        <div class="adblock-detector fixed inset-0 z-[100050] flex items-center justify-center overflow-y-auto overscroll-contain bg-base-content/40 p-4 backdrop-blur-md" role="alertdialog" aria-modal="true" aria-labelledby="adblock-detector-title" aria-describedby="adblock-detector-text">
          <div class="w-full max-w-md rounded-3xl border border-base-300 bg-base-100 p-6 text-center shadow-2xl sm:p-8">
            <span class="mx-auto flex size-16 items-center justify-center rounded-full bg-error/10 text-error ring-8 ring-error/5">
              <span class="icon-[tabler--shield-exclamation] size-8" aria-hidden="true"></span>
            </span>
            <h2 class="mt-5 text-lg font-semibold text-base-content" id="adblock-detector-title">{__("Please consider supporting us by disabling your ad blocker")}</h2>
            <p class="mt-2 text-sm leading-relaxed text-base-content/70" id="adblock-detector-text">{__("Our website is made possible by displaying online advertisements to our visitors")}. {__("After you turn off the ad blocker, you'll need to refresh your screen")}.</p>
            <a class="heroui button button--primary mt-6 w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="">
              <span class="icon-[tabler--refresh] size-4" aria-hidden="true"></span>
              {__("Refresh")}
            </a>
          </div>
        </div>
      </script>
    {/if}
    <!-- Adblock Detector -->

    <!-- Keyboard Shortcuts -->
    <script id="keyboard-shortcuts" type="text/template">
      {include file='__modal_header.tpl' _icon="icon-[tabler--keyboard]" _title=__("Keyboard Shortcuts")}
      <div class="modal__body flex flex-col gap-3">
        <div class="flex items-center gap-3 text-sm">
          <kbd class="kbd size-8 justify-center border border-base-300 bg-base-200 font-semibold text-base-content">J</kbd>
          <span>{__("Scroll to the next post")}</span>
        </div>
        <div class="flex items-center gap-3 text-sm">
          <kbd class="kbd size-8 justify-center border border-base-300 bg-base-200 font-semibold text-base-content">K</kbd>
          <span>{__("Scroll to the previous post")}</span>
        </div>
      </div>
    </script>
    <!-- Keyboard Shortcuts -->


    <!-- Emoji Menu -->
    <script id="emoji-menu" type="text/template">
      {$_stickers = $user->get_stickers()}
      <div class="group/emoji">
        {if $_stickers || !empty($user->_data['can_send_gifs'])}
          <div class="{if $_stickers}flex{else}hidden has-[[value=gifs]]:flex{/if} gap-1 border-b border-base-300 p-2">
            <label class="flex flex-1 cursor-pointer items-center justify-center rounded-field px-3 py-2 text-sm font-medium hover:bg-base-200 has-checked:bg-primary/10 has-checked:text-primary">
              <input class="sr-only" type="radio" name="emoji-tab-{literal}{{id}}{/literal}" value="emojis" checked>{__("Emojis")}
            </label>
            {if $_stickers}
              <label class="flex flex-1 cursor-pointer items-center justify-center rounded-field px-3 py-2 text-sm font-medium hover:bg-base-200 has-checked:bg-primary/10 has-checked:text-primary">
                <input class="sr-only" type="radio" name="emoji-tab-{literal}{{id}}{/literal}" value="stickers">{__("Stickers")}
              </label>
            {/if}
            {if !empty($user->_data['can_send_gifs'])}
              {literal}{{#gifs}}{/literal}
              <label class="flex flex-1 cursor-pointer items-center justify-center rounded-field px-3 py-2 text-sm font-medium hover:bg-base-200 has-checked:bg-primary/10 has-checked:text-primary">
                <input class="sr-only" type="radio" name="emoji-tab-{literal}{{id}}{/literal}" value="gifs" data-gif-tab>{__("GIFs")}
              </label>
              {literal}{{/gifs}}{/literal}
            {/if}
          </div>
        {/if}
        <div class="group-has-[[value=stickers]:checked]/emoji:hidden group-has-[[value=gifs]:checked]/emoji:hidden">
          <div class="grid gap-2 border-b border-base-300 p-3">
            <input type="search" class="input input-sm w-full [--border:1px]" data-emoji-search placeholder='{__("Search emojis")}' aria-label='{__("Search emojis")}' autocomplete="off">
            <div class="flex gap-2">
              <select class="select select-sm min-w-0 flex-1 [--border:1px]" data-emoji-category aria-label='{__("Emoji category")}'><option value="all">{__("All emojis")}</option><option value="recent">{__("Recently used")}</option></select>
              <select class="select select-sm w-28 [--border:1px]" data-emoji-tone aria-label='{__("Skin tone")}'>
                <option value="0">{__("Default")}</option>
                <option value="1">{__("Light")}</option>
                <option value="2">{__("Medium-light")}</option>
                <option value="3">{__("Medium")}</option>
                <option value="4">{__("Medium-dark")}</option>
                <option value="5">{__("Dark")}</option>
              </select>
            </div>
          </div>
          <div class="max-h-64 min-h-40 overflow-y-auto overscroll-contain p-2" data-emoji-scroll>
            <div class="grid grid-cols-8 gap-0.5" data-emoji-grid role="group" aria-label='{__("Emojis")}'></div>
            <div class="p-3 text-center text-sm text-base-content/65" data-emoji-status role="status">{__("Loading emojis")}</div>
            <button type="button" class="heroui button button--ghost button--sm mt-2 w-full hidden" data-emoji-more>{__("Load more")}</button>
            <button type="button" class="heroui button button--tertiary button--sm mx-auto hidden" data-emoji-retry>{__("Try again")}</button>
          </div>
        </div>
        {if $_stickers}
          <div class="hidden max-h-72 overflow-y-auto overscroll-contain group-has-[[value=stickers]:checked]/emoji:block">
            <div class="grid grid-cols-4 gap-1 p-2">
              {foreach $_stickers as $sticker}
                <button type="button" class="heroui button button--ghost aspect-square h-auto p-1" data-sticker=":STK-{$sticker['sticker_id']}:" aria-label='{__("Sticker")} {$sticker['sticker_id']}'><img class="size-full object-contain" src="{$system['system_uploads']}/{$sticker['image']}" alt="" loading="lazy"></button>
              {/foreach}
            </div>
          </div>
        {/if}
        {if !empty($user->_data['can_send_gifs'])}
          {literal}{{#gifs}}{/literal}
          <div class="hidden group-has-[[value=gifs]:checked]/emoji:block">
            <div class="border-b border-base-300 p-3">
              <input type="search" class="input input-sm w-full [--border:1px]" data-gif-search placeholder='{__("Search GIFs")}' aria-label='{__("Search GIFs")}' autocomplete="off">
            </div>
            <div class="max-h-72 min-h-40 overflow-y-auto overscroll-contain p-2" data-gif-scroll>
              <div class="columns-2 gap-1" data-gif-grid role="group" aria-label='{__("GIFs")}'></div>
              <div class="p-3 text-center text-sm text-base-content/65" data-gif-status role="status">{__("Loading")}</div>
              <button type="button" class="heroui button button--tertiary button--sm mx-auto hidden" data-gif-retry>{__("Try again")}</button>
            </div>
            <div class="border-t border-base-300 px-3 py-1.5 text-end text-[11px] font-medium text-base-content/50">{__("Powered by GIPHY")}</div>
          </div>
          {literal}{{/gifs}}{/literal}
        {/if}
      </div>
    </script>
    <!-- Emoji Menu -->


    <!-- DayTime Messages -->
    {if $system['daytime_msg_enabled'] && $page == "index"}
      <script id="message-morning" type="text/template">
        <div class="daytime_message flex items-start gap-3 rounded-box bg-base-100 p-3 shadow-surface sm:gap-3 sm:p-4 dark:shadow-none">
          <span class="icon-[tabler--sun] mt-0.5 size-10 shrink-0 text-warning" aria-hidden="true"></span>
          <div class="min-w-0 grow">
            <strong class="block font-semibold">{__("Good Morning, %s")|replace:'%s':$user->_data['user_fullname']}</strong>
            <span class="text-sm text-base-content/70">{__($system['system_morning_message'])}</span>
          </div>
          <button type="button" class="js_daytime-remover heroui button button--ghost button--sm button--icon-only size-6 rounded-full shrink-0" aria-label='{__("Close")}'>
            <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
          </button>
        </div>
      </script>

      <script id="message-afternoon" type="text/template">
        <div class="daytime_message flex items-start gap-3 rounded-box bg-base-100 p-3 shadow-surface sm:gap-3 sm:p-4 dark:shadow-none">
          <span class="icon-[tabler--sunset] mt-0.5 size-10 shrink-0 text-warning" aria-hidden="true"></span>
          <div class="min-w-0 grow">
            <strong class="block font-semibold">{__("Good Afternoon, %s")|replace:'%s':$user->_data['user_fullname']}</strong>
            <span class="text-sm text-base-content/70">{__($system['system_afternoon_message'])}</span>
          </div>
          <button type="button" class="js_daytime-remover heroui button button--ghost button--sm button--icon-only size-6 rounded-full shrink-0" aria-label='{__("Close")}'>
            <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
          </button>
        </div>
      </script>

      <script id="message-evening" type="text/template">
        <div class="daytime_message flex items-start gap-3 rounded-box bg-base-100 p-3 shadow-surface sm:gap-3 sm:p-4 dark:shadow-none">
          <span class="icon-[tabler--moon] mt-0.5 size-10 shrink-0 text-info" aria-hidden="true"></span>
          <div class="min-w-0 grow">
            <strong class="block font-semibold">{__("Good Evening, %s")|replace:'%s':$user->_data['user_fullname']}</strong>
            <span class="text-sm text-base-content/70">{__($system['system_evening_message'])}</span>
          </div>
          <button type="button" class="js_daytime-remover heroui button button--ghost button--sm button--icon-only size-6 rounded-full shrink-0" aria-label='{__("Close")}'>
            <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
          </button>
        </div>
      </script>
    {/if}
    <!-- DayTime Messages -->

    <!-- Gifts -->
    {if $system['gifts_enabled'] && $page == "profile"}
      <script id="gifts" type="text/template">
        {include file='__modal_header.tpl' _icon="icon-[tabler--gift]" _title=__("Gifts")}
        <form class="js_ajax-forms" data-url="users/gifts.php?do=send&uid={literal}{{uid}}{/literal}">
          <div class="modal__body flex flex-col gap-4">
            <div class="js_scroller" data-slimScroll-height="440">
              <div class="grid grid-cols-3 gap-2">
                {foreach from=$gifts item=gift}
                  <label class="flex cursor-pointer flex-col items-center gap-2 rounded-box border border-base-300 p-2 text-center transition-colors hover:bg-base-200 has-[:checked]:border-primary has-[:checked]:bg-primary/5" for="gift_{$gift['gift_id']}">
                    <input class="sr-only" type="radio" name="gift" value="{$gift['gift_id']}" id="gift_{$gift['gift_id']}" />
                    <img class="size-20 object-contain" src="{$system['system_uploads']}/{$gift['image']}" alt="">
                    {if $system['gifts_points_enabled']}
                      <span class="badge badge-soft badge-primary badge-sm">{$gift['points']} {__("Points")}</span>
                    {/if}
                  </label>
                {/foreach}
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-soft alert-error alert-danger hidden"></div>
            <!-- error -->
          </div>
          <div class="modal__footer justify-end gap-2">
            <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
            <button type="submit" class="button button--primary">{__("Send")}</button>
          </div>
        </form>
      </script>

      <script id="gift" type="text/template">
        <div class="modal__header mb-4 flex-row items-center gap-3 [&+.modal\_\_body]:mt-0">
          <span class="modal__icon size-9 rounded-lg bg-base-200 text-base-content" aria-hidden="true"><span class="icon-[tabler--gift] size-5"></span></span>
          <div class="min-w-0 flex-1">
            <h6 class="modal__heading">{if $system['show_usernames_enabled']}{$gift['user_name']}{else}{$gift['user_firstname']} {$gift['user_lastname']}{/if} {__("sent you a gift")}</h6>
          </div>
          {include file='__close_button.tpl' extra_class="static"}
        </div>
        <div class="modal__body flex flex-col items-center gap-4 text-center">
          <img class="max-h-64 max-w-full object-contain" src="{$system['system_uploads']}/{$gift['image']}" alt="">
          {if $system['gifts_points_enabled']}
            <span class="badge badge-soft badge-primary">{$gift['points']} {__("Points")}</span>
          {/if}
        </div>
      </script>
    {/if}
    <!-- Gifts -->

    <!-- Uploader -->
    {include file='_js_templates.uploads.tpl'}
    <script id="uploader-attachments-image-item" type="text/template">
      <li class="item deletable group relative aspect-square overflow-hidden rounded-box bg-base-200" data-src="{literal}{{src}}{/literal}">
        <img class="size-full object-cover" alt="" src="{literal}{{image_path}}{/literal}">
        <button class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full absolute end-1.5 top-1.5 border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100 {literal}{{#mini}}{/literal}js_publisher-mini-attachment-image-remover{literal}{{/mini}}{/literal}{literal}{{^mini}}{/literal}js_publisher-attachment-image-remover{literal}{{/mini}}{/literal}" type="button" title='{__("Remove")}' aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
      </li>
    </script>

    <script id="publisher-photo-item" type="text/template">
      <li class="item relative overflow-hidden rounded-box border border-base-300 bg-base-200" data-src="{literal}{{src}}{/literal}">
        <div class="relative aspect-square overflow-hidden">
          <img class="size-full object-cover" alt="" src="{literal}{{image_path}}{/literal}" draggable="false">
          <span class="js_photo-drag absolute start-1.5 top-1.5 flex size-8 touch-none cursor-grab items-center justify-center rounded-full bg-base-100/90 text-base-content shadow-sm active:cursor-grabbing" aria-hidden="true"><span class="icon-[tabler--grip-vertical] size-4"></span></span>
          <button class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full js_publisher-attachment-image-remover absolute end-1.5 top-1.5 border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100" type="button" title='{__("Remove")}' aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
          <span class="js_photo-position absolute bottom-1.5 start-1.5 rounded-full bg-black/60 px-2 py-0.5 text-xs font-medium text-white"></span>
          <span class="js_photo-featured absolute bottom-1.5 end-1.5 rounded-full bg-primary px-2 py-0.5 text-xs font-medium text-primary-content">{__("Featured")}</span>
        </div>
        <div class="flex items-center justify-center gap-1 p-1">
          <button type="button" class="js_photo-move heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full static!" data-direction="earlier" title='{__("Move earlier")}' aria-label='{__("Move earlier")}'><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span></button>
          <button type="button" class="js_photo-move heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full static!" data-direction="first" title='{__("Make first")}' aria-label='{__("Make first")}'><span class="icon-[tabler--star] size-4" aria-hidden="true"></span></button>
          <button type="button" class="js_photo-move heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full static!" data-direction="later" title='{__("Move later")}' aria-label='{__("Move later")}'><span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span></button>
        </div>
      </li>
    </script>

    <script id="uploader-attachments-video-item" type="text/template">
      <li class="item deletable relative flex min-h-20 items-center gap-3 rounded-box border border-base-300 bg-base-100 p-3 pe-12" data-src="{literal}{{src}}{/literal}">
        <span class="flex size-10 shrink-0 items-center justify-center rounded-lg bg-error/10 text-error"><span class="icon-[tabler--video] size-5" aria-hidden="true"></span></span>
        <div class="name min-w-0 flex-1 truncate text-sm font-medium" title="{literal}{{name}}{/literal}">{literal}{{name}}{/literal}</div>
        <button class="heroui button button--tertiary button--sm button--icon-only size-6 rounded-full js_publisher-mini-attachment-video-remover absolute end-2 top-2" type="button" title='{__("Remove")}' aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
      </li>
    </script>
    <!-- Uploader -->

    <!-- Publisher -->
    <script id="scraper-photo" type="text/template">
      <div class="publisher-scraper-remover js_publisher-scraper-remover absolute end-2 top-2 z-10">
        <button class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100" type="button" title='{__("Remove")}' aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
      </div>
      <div class="post-media overflow-hidden">
        <div class="post-media-image bg-base-200">
          <img class="max-h-80 w-full object-cover" src="{literal}{{url}}{/literal}" alt="">
        </div>
        <div class="post-media-meta border-t border-base-300 px-4 py-3">
          <div class="source text-xs font-medium uppercase tracking-wide text-base-content/50">{literal}{{provider}}{/literal}</div>
        </div>
      </div>
    </script>

    <script id="scraper-link" type="text/template">
      <div class="publisher-scraper-remover js_publisher-scraper-remover absolute end-2 top-2 z-10">
        <button class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100" type="button" title='{__("Remove")}' aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
      </div>
      <div class="post-media overflow-hidden">
        {literal}{{#thumbnail}}{/literal}
        <a class="post-media-image block bg-base-200" href="{literal}{{url}}{/literal}" target="_blank" rel="noopener">
          <img class="max-h-72 w-full object-cover" src="{literal}{{thumbnail}}{/literal}" alt="">
          <div class="source px-4 py-2 text-xs font-medium uppercase tracking-wide text-base-content/50">{literal}{{host}}{/literal}</div>
        </a>
        {literal}{{/thumbnail}}{/literal}
        <div class="post-media-meta border-t border-base-300 px-4 py-3">
          <a class="title block font-semibold text-base-content!" href="{literal}{{url}}{/literal}" target="_blank" rel="noopener">{literal}{{title}}{/literal}</a>
          <div class="text mt-1 line-clamp-2 text-sm text-base-content/60" title="{literal}{{text}}{/literal}">{literal}{{text}}{/literal}</div>
        </div>
      </div>
    </script>

    <script id="scraper-media" type="text/template">
      <div class="publisher-scraper-remover js_publisher-scraper-remover absolute end-2 top-2 z-10">
        <button class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100" type="button" title='{__("Remove")}' aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
      </div>
      <div class="overflow-hidden [&_iframe]:block [&_iframe]:w-full [&_iframe]:max-w-full">
        {literal}{{{html}}}{/literal}
      </div>
    </script>

    <script id="scraper-player" type="text/template">
      <div class="publisher-scraper-remover js_publisher-scraper-remover absolute end-2 top-2 z-10">
        <button class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100" type="button" title='{__("Remove")}' aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
      </div>
      <div>
        <div class="aspect-video w-full overflow-hidden bg-base-200 [&>*]:block [&>*]:size-full [&_iframe]:block [&_iframe]:size-full">
          {literal}{{{html}}}{/literal}
        </div>
      </div>
    </script>

    <script id="scraper-facebook" type="text/template">
      <div class="publisher-scraper-remover js_publisher-scraper-remover absolute end-2 top-2 z-10">
        <button class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100" type="button" title='{__("Remove")}' aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
      </div>
      <div>
        <div class="overflow-hidden [&>iframe]:w-full">
          {literal}{{{html}}}{/literal}
        </div>
      </div>
    </script>

    <script id="poll-option" type="text/template">
      <div class="publisher-meta" data-meta="poll">
        <div class="flex w-full items-center gap-2.5">
          <span class="flex size-10 shrink-0 items-center justify-center rounded-field bg-warning/10 text-warning"><span class="icon-[tabler--plus] size-5" aria-hidden="true"></span></span>
          <input class="input w-full [--border:1px]" type="text" placeholder='{__("Add an option")}...'>
        </div>
      </div>
    </script>

    <script id="pubisher-gif" type="text/template">
      <div class="publisher-scraper-remover js_publisher-gif-remover absolute end-2 top-2 z-10">
        <button class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100" type="button" title='{__("Remove")}' aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
      </div>
      <div class="post-media overflow-hidden bg-base-200">
        <div class="post-media-image">
          <div class="image aspect-video w-full bg-contain bg-center bg-no-repeat" style="background-image:url('{literal}{{src}}{/literal}');"></div>
        </div>
      </div>
    </script>

    <script id="publisher-mention-item" type="text/template">
      <div class="publisher-mention-item flex items-center gap-3 rounded-lg px-3 py-2 hover:bg-base-200">
        <div class="publisher-mention-item__avatar shrink-0">
          <img class="publisher-mention-item__img size-9 rounded-full object-cover" src="{literal}{{avatar}}{/literal}" alt="" loading="lazy" draggable="false">
        </div>
        <div class="publisher-mention-item__body min-w-0 flex-1">
          <div class="publisher-mention-item__name mention-item-label truncate text-sm font-medium" title="{literal}{{value}}{/literal}">{literal}{{value}}{/literal}</div>
        </div>
      </div>
    </script>

    <script id="publisher-hashtag-item" type="text/template">
      <div class="publisher-hashtag-item rounded-lg px-3 py-2 hover:bg-base-200">
        <div class="publisher-hashtag-item__body">
          <div class="publisher-hashtag-item__name mention-item-label text-sm font-medium text-primary">#{literal}{{value}}{/literal}</div>
        </div>
      </div>
    </script>
    <!-- Publisher -->

    <!-- Posts & Comments -->
    {if in_array($page, ["index", "profile", "page", "group", "event", "post", "photo", "market", "blogs", "directory", "search", "share", "reels"])}
      <!-- Comments -->
      <script id="comment-attachments-item" type="text/template">
        <li class="item deletable relative size-20 overflow-hidden rounded-field bg-base-200" data-src="{literal}{{src}}{/literal}">
          <img class="size-full object-cover" alt="" src="{literal}{{image_path}}{/literal}">
          <button class="heroui button button--tertiary button--sm button--icon-only size-6 rounded-full js_comment-attachment-remover absolute end-1 top-1 shadow-sm" type="button" title='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
        </li>
      </script>
      <!-- Comments -->

      <!-- Edit (Posts|Comments) -->
      <script id="edit-post" type="text/template">
        <div class="post-edit px-4 pb-3">
          <div class="x-form post-form relative">
            <textarea rows="2" class="js_autosize js_mentions js_update-post-textarea textarea min-h-24 w-full resize-none rounded-box border-base-300 bg-base-200 pe-12 text-sm leading-6">{literal}{{text}}{/literal}</textarea>
            <ul class="x-form-tools absolute end-2 top-2">
              <li class="x-form-tools-emoji inline-flex">{include file='__emoji_trigger.tpl'}</li>
            </ul>
          </div>
          <div class="mt-2 flex justify-end gap-2">
            <button class="heroui button button--tertiary button--sm rounded-full px-4 js_unedit-post">{__("Cancel")}</button>
            <button class="heroui button button--primary button--sm rounded-full px-4 js_update-post">{__("Save")}</button>
          </div>
        </div>
      </script>

      <script id="edit-comment" type="text/template">
        <div class="comment-edit min-w-0 flex-1 pb-2">
          <div class="x-form comment-form relative [&_.x-uploader]:relative [&_.x-uploader]:grid [&_.x-uploader]:size-full [&_.x-uploader]:cursor-pointer [&_.x-uploader]:place-items-center [&_.x-uploader]:overflow-hidden [&_.x-uploader>input[type=file]]:absolute [&_.x-uploader>input[type=file]]:inset-0 [&_.x-uploader>input[type=file]]:z-10 [&_.x-uploader>input[type=file]]:size-full [&_.x-uploader>input[type=file]]:cursor-pointer [&_.x-uploader>input[type=file]]:opacity-0">
            <textarea rows="1" class="js_autosize js_mentions js_update-comment-textarea textarea block min-h-11 w-full resize-none rounded-box border-transparent bg-base-200/70 transition-colors focus:border-primary focus:bg-base-100 py-3 pe-20 text-sm leading-5">{literal}{{text}}{/literal}</textarea>
            <ul class="x-form-tools absolute end-2 bottom-2 flex items-center gap-1">
              <li class="x-form-tools-attach inline-flex size-7 cursor-pointer items-center justify-center overflow-hidden rounded-full hover:bg-base-200">
                <span class="icon-[tabler--photo] js_x-uploader size-4" data-handle="comment" aria-hidden="true"></span>
              </li>
              <li class="x-form-tools-emoji inline-flex">{include file='__emoji_trigger.tpl'}</li>
            </ul>
          </div>
          <div class="comment-attachments attachments mt-2 hidden rounded-box border border-base-300 bg-base-100 p-2">
            <ul class="flex flex-wrap gap-2">
              <li class="js_loading">
                <div class="progress x-progress">
                  <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
              </li>
            </ul>
          </div>
          <div class="mt-2 flex justify-end gap-2">
            <button class="heroui button button--tertiary button--sm rounded-full px-4 js_unedit-comment">{__("Cancel")}</button>
            <button class="heroui button button--primary button--sm rounded-full px-4 js_update-comment">{__("Save")}</button>
          </div>
        </div>
      </script>
      <!-- Edit (Posts|Comments) -->

      <!-- Hidden (Posts|Authors) -->
      <script id="hidden-post" type="text/template">
        <div class="post flagged rounded-box border border-base-300 bg-base-100 p-4 text-sm" data-id="{literal}{{id}}{/literal}">
          <div class="mb-1 font-semibold">{__("Post Hidden")}</div>
          {__("This post will no longer appear to you")} <span class="text-primary cursor-pointer js_unhide-post">{__("Undo")}</span>
        </div>
      </script>

      <script id="hidden-author" type="text/template">
        <div class="post flagged rounded-box border border-base-300 bg-base-100 p-4 text-sm" data-id="{literal}{{id}}{/literal}">
          {__("You won't see posts from")} {literal}{{name}}{/literal} {__("in News Feed anymore")}. <span class="text-primary cursor-pointer js_unhide-author" data-author-id="{literal}{{uid}}{/literal}" data-author-name="{literal}{{name}}{/literal}">{__("Undo")}</span>
        </div>
      </script>
      <!-- Hidden (Posts|Authors) -->
    {/if}
    <!-- Posts & Comments -->

    <!-- Wallet -->
    {if $page == "wallet"}
      <script id="wallet-withdraw-affiliates" type="text/template">
        <div>
          <div class="modal__header mb-4 flex-row items-center gap-3 [&+.modal\_\_body]:mt-0">
            <span class="modal__icon size-9 rounded-lg bg-base-200 text-base-content" aria-hidden="true"><span class="icon-[tabler--users] size-5"></span></span>
            <div class="min-w-0 flex-1">
              <h6 class="modal__heading">{__("Withdraw Affiliates Credit")}</h6>
            </div>
            {include file='__close_button.tpl' extra_class="static"}
          </div>
          <form class="js_ajax-forms" data-url="payments/wallet.php?do=wallet_withdraw_affiliates">
            <div class="modal__body flex flex-col gap-4">
              <div class="flex items-center justify-between gap-3 rounded-box bg-base-200 px-4 py-3">
                <span class="text-sm text-base-content/70">{__("Your Affiliates Balance")}</span>
                <strong class="text-base font-semibold text-base-content">{print_money($user->_data['user_affiliate_balance'])}</strong>
              </div>
              {include file='__wallet_money_field.tpl'}
              <!-- error -->
              <div class="alert alert-soft alert-error alert-danger hidden"></div>
              <!-- error -->
            </div>
            <div class="modal__footer justify-end gap-2">
              <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
              <button type="submit" class="button button--primary">{__("Continue")}</button>
            </div>
          </form>
        </div>
      </script>

      <script id="wallet-withdraw-points" type="text/template">
        <div>
          <div class="modal__header mb-4 flex-row items-center gap-3 [&+.modal\_\_body]:mt-0">
            <span class="modal__icon size-9 rounded-lg bg-base-200 text-base-content" aria-hidden="true"><span class="icon-[tabler--coin] size-5"></span></span>
            <div class="min-w-0 flex-1">
              <h6 class="modal__heading">{__("Withdraw Points Credit")}</h6>
            </div>
            {include file='__close_button.tpl' extra_class="static"}
          </div>
          <form class="js_ajax-forms" data-url="payments/wallet.php?do=wallet_withdraw_points">
            <div class="modal__body flex flex-col gap-4">
              <div class="flex items-center justify-between gap-3 rounded-box bg-base-200 px-4 py-3">
                <span class="text-sm text-base-content/70">{__("Your Points Balance")}</span>
                <strong class="text-base font-semibold text-base-content">{if $system['points_per_currency'] == 0}0{else}{print_money((((1/$system['points_per_currency'])*$user->_data['user_points'])))}{/if}</strong>
              </div>
              {include file='__wallet_money_field.tpl'}
              <!-- error -->
              <div class="alert alert-soft alert-error alert-danger hidden"></div>
              <!-- error -->
            </div>
            <div class="modal__footer justify-end gap-2">
              <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
              <button type="submit" class="button button--primary">{__("Continue")}</button>
            </div>
          </form>
        </div>
      </script>

      <script id="wallet-withdraw-market" type="text/template">
        <div>
          <div class="modal__header mb-4 flex-row items-center gap-3 [&+.modal\_\_body]:mt-0">
            <span class="modal__icon size-9 rounded-lg bg-base-200 text-base-content" aria-hidden="true"><span class="icon-[tabler--shopping-bag] size-5"></span></span>
            <div class="min-w-0 flex-1">
              <h6 class="modal__heading">{__("Withdraw Market Credit")}</h6>
            </div>
            {include file='__close_button.tpl' extra_class="static"}
          </div>
          <form class="js_ajax-forms" data-url="payments/wallet.php?do=wallet_withdraw_market">
            <div class="modal__body flex flex-col gap-4">
              <div class="flex items-center justify-between gap-3 rounded-box bg-base-200 px-4 py-3">
                <span class="text-sm text-base-content/70">{__("Your Marketplace Balance")}</span>
                <strong class="text-base font-semibold text-base-content">{print_money($user->_data['user_market_balance'])}</strong>
              </div>
              {include file='__wallet_money_field.tpl'}
              <!-- error -->
              <div class="alert alert-soft alert-error alert-danger hidden"></div>
              <!-- error -->
            </div>
            <div class="modal__footer justify-end gap-2">
              <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
              <button type="submit" class="button button--primary">{__("Continue")}</button>
            </div>
          </form>
        </div>
      </script>
    {/if}
    <!-- Wallet -->

    <!-- Crop Profile (Picture|Cover) -->
    {if in_array($page, ["started", "profile", "page", "group", "event"])}
      <script id="crop-profile-picture" type="text/template">
        {include file='__modal_header.tpl' _icon="icon-[tabler--crop]" _title=__("Crop Picture")}
        <div class="modal__body flex flex-col gap-4 text-center">
          <div class="alert alert-soft alert-primary flex items-start gap-3 text-start" role="alert">
            <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
            <p class="min-w-0">{__("Crop animated images will make them static, You can skip the cropping process by clicking on the cancel button")}</p>
          </div>
          <img id="cropped-profile-picture" class="max-w-full" src="{literal}{{image}}{/literal}" alt="">
        </div>
        <div class="modal__footer justify-end gap-2">
          <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
          <button type="button" class="button button--primary js_crop-picture" data-handle="{literal}{{handle}}{/literal}" data-id="{literal}{{id}}{/literal}">{__("Save")}</button>
        </div>
      </script>

      <script id="crop-profile-cover" type="text/template">
        {include file='__modal_header.tpl' _icon="icon-[tabler--crop]" _title=__("Crop Cover")}
        <div class="modal__body flex flex-col gap-4 text-center">
          <div class="alert alert-soft alert-primary flex items-start gap-3 text-start" role="alert">
            <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
            <p class="min-w-0">{__("Crop animated images will make them static, You can skip the cropping process by clicking on the cancel button")}</p>
          </div>
          <img id="cropped-profile-cover" class="max-w-full" src="{literal}{{image}}{/literal}" alt="">
        </div>
        <div class="modal__footer justify-end gap-2">
          <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
          <button type="button" class="button button--primary js_crop-cover" data-handle="{literal}{{handle}}{/literal}" data-id="{literal}{{id}}{/literal}">{__("Save")}</button>
        </div>
      </script>
    {/if}
    <!-- Crop Profile (Picture|Cover) -->

    <!-- Download Information -->
    {if $page == "settings"}
      <script id="download-information" type="text/template">
        {include file='__modal_header.tpl' _icon="icon-[tabler--file-download]" _title=__("Download Your Information")}
        <div class="modal__body flex flex-col items-center py-2 text-center">
          <div class="relative flex size-24 items-center justify-center" aria-hidden="true">
            <span class="absolute inset-0 rounded-full bg-success/5"></span>
            <span class="absolute inset-3 rounded-full bg-success/10"></span>
            <span class="relative flex size-12 items-center justify-center rounded-[0.875rem] bg-base-100 text-success shadow-sm ring-1 ring-success/20">
              <span class="icon-[tabler--file-check] size-6"></span>
            </span>
          </div>
          <h3 class="mt-4 text-base font-semibold text-base-content">{__("Your file is ready to download")}</h3>
          <p class="mt-2 inline-flex max-w-sm items-start gap-2 rounded-[0.75rem] bg-base-200 px-3 py-2 text-start text-xs leading-relaxed text-base-content/70">
            <span class="icon-[tabler--lock] mt-0.5 size-4 shrink-0" aria-hidden="true"></span>
            <span>{__("This file contains your personal information, keep it in a safe place")}</span>
          </p>
        </div>
        <div class="modal__footer justify-end gap-2 max-sm:flex-col-reverse max-sm:[&>*]:w-full">
          <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Close")}</button>
          <a href="{$system['system_url']}/settings/download?hash={$user->_data['user_name']}-{$secret}" class="button button--primary">
            <span class="icon-[tabler--download] size-4" aria-hidden="true"></span>
            {__("Download")}
          </a>
        </div>
      </script>
    {/if}
    <!-- Download Information -->




    <!-- Blog reference -->
    {if $page == "blogs" && in_array($view, ['edit', 'new'])}
      <script id="blog-reference" type="text/template">
        <div class="auto-connect-node">
          <div class="flex flex-col gap-3 rounded-field border border-base-300 p-4">
            <input type="text" class="input w-full" name="references[{literal}{{index}}{/literal}][title]" placeholder="{__('Title')}">
            <input type="text" class="input w-full" name="references[{literal}{{index}}{/literal}][link]" placeholder="{__('Link')}">
            <span class="text-sm text-base-content/60">{__("Add a reference title and link to cite your source")}</span>
          </div>
        </div>
      </script>
    {/if}
    <!-- Blog reference -->

    {if $licence_monetization && is_file("content/themes/`$system.theme`/templates/_js_templates.payments.tpl")}
      {include file='_js_templates.payments.tpl'}
    {/if}

  {/if}

{/strip}
