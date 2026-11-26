{assign var="term_line" value='mb-1.5 text-[.82rem] text-[#3f7a4f] dark:text-[#3f9b57]'}
{assign var="term_em" value='font-normal text-green-800 dark:text-green-300'}
{assign var="term_heading" value='mt-3.5 mb-[22px] text-base font-bold text-green-900 dark:text-green-200'}
{assign var="term_label" value='mb-1.5 block text-[.78rem] text-[#3f7a4f] dark:text-[#3f9b57]'}
{assign var="term_label_extras" value='text-[.78rem] text-[#3f7a4f]! dark:text-[#3f9b57]!'}
{assign var="term_prompt" value='me-1 text-green-800 dark:text-green-300'}
{assign var="term_input" value='w-full rounded-lg border border-[#cdd6c0] bg-white px-[13px] py-[11px] font-mono text-[.9rem] text-green-900 caret-green-700 transition-[border-color,box-shadow] placeholder:text-[#9aab8f] focus:border-green-700 focus:shadow-[0_0_0_3px_rgba(21,128,61,.15)] focus:outline-none dark:border-[#1f3320] dark:bg-[#0a0f0a] dark:text-green-200 dark:caret-green-400 dark:placeholder:text-[#2d4a2f] dark:focus:border-green-400 dark:focus:shadow-[0_0_0_3px_rgba(74,222,128,.12)]'}
{assign var="term_wrap" value='flex w-full items-center gap-2 rounded-lg border border-[#cdd6c0] bg-white pe-[13px] text-green-900 transition-[border-color,box-shadow] focus-within:border-green-700 focus-within:shadow-[0_0_0_3px_rgba(21,128,61,.15)] dark:border-[#1f3320] dark:bg-[#0a0f0a] dark:text-green-200 dark:focus-within:border-green-400 dark:focus-within:shadow-[0_0_0_3px_rgba(74,222,128,.12)]'}
{assign var="term_inner" value='min-w-0 grow bg-transparent py-[11px] ps-[13px] font-mono text-[.9rem] caret-green-700 outline-none placeholder:text-[#9aab8f] dark:caret-green-400 dark:placeholder:text-[#2d4a2f]'}
{assign var="term_select" value='select w-full rounded-lg border-[#cdd6c0] bg-white font-mono text-[.9rem] text-green-900 dark:border-[#1f3320] dark:bg-[#0a0f0a] dark:text-green-200'}
{assign var="term_check" value='checkbox [--input-color:#15803d] dark:[--input-color:#4ade80]'}
{assign var="term_button" value='w-full cursor-pointer rounded-lg border border-green-700 bg-transparent p-3 font-mono text-[.9rem] font-bold tracking-[.05em] text-green-700 transition-colors hover:bg-green-700 hover:text-white dark:border-green-400 dark:text-green-400 dark:hover:bg-green-400 dark:hover:text-[#0a0e0a]'}
{assign var="term_alert" value='alert alert-danger alert-error hidden rounded-lg border border-red-300 bg-transparent font-mono text-[.8rem] text-red-700 dark:border-red-900 dark:text-red-400'}
{assign var="term_hint" value='mt-[18px] text-[.75rem] text-[#7d8b6f] dark:text-[#3f513f]'}
{assign var="term_link" value='border-b border-dashed border-[#3f7a4f] text-green-700! dark:border-[#3f9b57] dark:text-green-300!'}
<div class="w-full font-mono">

  <!-- signin -->
  <div class="js_panel {if $do == 'up'}hidden{/if}">
    {if $visitor_ip}
      <p class="{$term_line}">{__("Connection from")} <b class="{$term_em}">{$visitor_ip}</b></p>
    {/if}
    <p class="{$term_line}">{__("Session requires authentication.")}</p>
    <h2 class="{$term_heading}"><span aria-hidden="true">&gt; </span>{__("identify yourself")}<span class="animate-blink ms-0.5" aria-hidden="true">▌</span></h2>
    {if isset($highlight)}
      <div class="alert alert-warning mb-5 font-mono text-[.8rem]" role="alert">{$highlight}</div>
    {/if}
    {if $system['social_login_enabled']}
      {include file='__social_login.tpl' _style="terminal" _or_pos="bottom" _margin="mt-0"}
    {/if}
    <form class="js_ajax-forms flex flex-col gap-[18px]" data-url="core/signin.php" method="POST">
      <!-- username or email -->
      <div>
        <label class="{$term_label}" for="signin-username-email"><span class="{$term_prompt}" aria-hidden="true">$</span>{__("Email")} {__("or")} {__("Username")}</label>
        <input type="text" class="{$term_input}" id="signin-username-email" name="username_email" placeholder="ada" autocomplete="username" spellcheck="false" required>
      </div>
      <!-- username or email -->

      <!-- password -->
      <div>
        <label class="{$term_label}" for="signin-password"><span class="{$term_prompt}" aria-hidden="true">$</span>{__("Password")}</label>
        <div class="{$term_wrap}">
          <input type="password" class="{$term_inner}" id="signin-password" name="password" placeholder="************" autocomplete="current-password" required>
          {include file='__password_toggle.tpl'}
        </div>
      </div>
      <!-- password -->

      <!-- remember me -->
      <div class="flex items-center gap-2">
        <input type="checkbox" class="{$term_check}" name="remember" id="remember">
        <label class="text-[.78rem] text-[#3f7a4f] dark:text-[#3f9b57]" for="remember">{__("Remember me")}</label>
      </div>
      <!-- remember me -->

      <!-- submit -->
      <button type="submit" class="{$term_button}">[ {__("authenticate")} ]</button>
      <!-- submit -->

      <!-- error -->
      <div class="{$term_alert}"></div>
      <!-- error -->
    </form>
    <p class="{$term_hint}">
      <span aria-hidden="true">// </span>{__("lost credentials?")} <a class="{$term_link}" href="{$system['system_url']}/reset">{__("run recovery")}</a>
    </p>
    {if $system['registration_enabled']}
      <p class="mt-1.5 text-[.75rem] text-[#7d8b6f] dark:text-[#3f513f]">
        <span aria-hidden="true">// </span>{__("no account?")} <a class="js_toggle-panel {$term_link}" href="{$system['system_url']}/signup{if $oauth_app_id}?oauth_app_id={$oauth_app_id}{/if}">{__("register")}</a>
      </p>
    {/if}
  </div>
  <!-- signin -->

  <!-- signup -->
  <div class="js_panel {if $do != 'up'}hidden{/if}">
    <p class="{$term_line}">{__("Welcome to")} <b class="{$term_em}">{__($system['system_title'])}</b></p>
    <h2 class="{$term_heading}"><span aria-hidden="true">&gt; </span>{__("create account")}<span class="animate-blink ms-0.5" aria-hidden="true">▌</span></h2>
    {if $system['social_login_enabled']}
      {include file='__social_login.tpl' _style="terminal" _or_pos="bottom" _margin="mt-0"}
    {/if}
    <form class="js_ajax-forms flex flex-col gap-[18px]" data-url="core/signup.php" method="POST">
      {if $system['invitation_enabled']}
        <!-- invitation code -->
        <div>
          <label class="{$term_label}" for="signup-invitation-code"><span class="{$term_prompt}" aria-hidden="true">$</span>{__("Invitation Code")}</label>
          <input name="invitation_code" type="text" class="{$term_input}" id="signup-invitation-code" value="{$invitation_code}" spellcheck="false" required>
        </div>
        <!-- invitation code -->
      {/if}
      {if !$system['show_usernames_enabled']}
        <div class="grid gap-[18px] sm:grid-cols-2">
          <!-- first name -->
          <div>
            <label class="{$term_label}" for="signup-first-name"><span class="{$term_prompt}" aria-hidden="true">$</span>{__("First name")}</label>
            <input name="first_name" type="text" class="{$term_input}" id="signup-first-name" required>
          </div>
          <!-- first name -->
          <!-- last name -->
          <div>
            <label class="{$term_label}" for="signup-last-name"><span class="{$term_prompt}" aria-hidden="true">$</span>{__("Last name")}</label>
            <input name="last_name" type="text" class="{$term_input}" id="signup-last-name" required>
          </div>
          <!-- last name -->
        </div>
      {/if}
      <!-- username -->
      <div>
        <label class="{$term_label}" for="signup-username"><span class="{$term_prompt}" aria-hidden="true">$</span>{__("Username")}</label>
        <input name="username" type="text" class="{$term_input}" id="signup-username" autocomplete="username" spellcheck="false" required>
      </div>
      <!-- username -->
      <!-- email -->
      <div>
        <label class="{$term_label}" for="signup-email"><span class="{$term_prompt}" aria-hidden="true">$</span>{__("Email")}</label>
        <input name="email" type="email" class="{$term_input}" id="signup-email" autocomplete="email" spellcheck="false" required>
      </div>
      <!-- email -->
      {if $system['activation_enabled'] && $system['activation_type'] == "sms"}
        <!-- phone -->
        <div>
          <label class="{$term_label}" for="signup-phone"><span class="{$term_prompt}" aria-hidden="true">$</span>{__("Phone number")}</label>
          <input name="phone" type="text" class="{$term_input}" id="signup-phone" placeholder='{__("Phone number (e.g: +1234567890)")}' required>
        </div>
        <!-- phone -->
      {/if}
      <!-- password -->
      <div>
        <label class="{$term_label}" for="signup-password"><span class="{$term_prompt}" aria-hidden="true">$</span>{__("Password")}</label>
        <div class="{$term_wrap}">
          <input name="password" type="password" class="{$term_inner}" id="signup-password" placeholder="************" autocomplete="new-password" required>
          {include file='__password_toggle.tpl'}
        </div>
      </div>
      <!-- password -->
      <!-- custom fields -->
      {if $custom_fields}
        {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true _input_class=$term_input _select_class=$term_select _textarea_class=$term_input _label_class=$term_label_extras}
      {/if}
      <!-- custom fields -->
      <div class="js_hidden-section hidden space-y-[18px]">
        {include file='__sign_form_extras.tpl' _floating=false _select_class=$term_select _label_class=$term_label_extras _checkbox_class=$term_check}
      </div>
      <!-- submit -->
      {if $oauth_app_id}
        <input type="hidden" name="oauth_app_id" value="{$oauth_app_id}">
      {/if}
      <button type="submit" class="{$term_button}">[ {__("register")} ]</button>
      <!-- submit -->
      <!-- error -->
      <div class="{$term_alert}"></div>
      <!-- error -->
    </form>
    <p class="{$term_hint}">
      <span aria-hidden="true">// </span>{__("already registered?")} <a class="js_toggle-panel {$term_link}" href="{$system['system_url']}/signin">{__("login")}</a>
    </p>
  </div>
  <!-- signup -->
</div>
