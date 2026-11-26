{assign var="arc_tag" value='inline-block rounded-lg border-[3px] border-[#111] bg-[#5157e7] px-2.5 py-[5px] text-[.75rem] font-extrabold uppercase tracking-[.05em] text-white shadow-[3px_3px_0_#111] dark:border-[#22d3ee] dark:shadow-[3px_3px_0_#ff2e97] dark:bg-[#facc15] dark:text-[#0b0724]'}
{assign var="arc_heading" value='mt-[18px] mb-1.5 text-[1.8rem] leading-tight font-black tracking-[-.03em]'}
{assign var="arc_sub" value='mb-[26px] text-[.92rem] font-semibold text-[#444] dark:text-[#a5f3fc]'}
{assign var="arc_label" value='mb-1.5 block text-[.85rem] font-extrabold uppercase tracking-[.03em] dark:text-[#22d3ee]'}
{assign var="arc_label_extras" value='text-[.85rem] font-extrabold uppercase tracking-[.03em] text-[#111]! dark:text-[#22d3ee]!'}
{assign var="arc_input" value='w-full rounded-[10px] border-[3px] border-[#111] bg-white px-3.5 py-3 text-[.95rem] font-semibold text-[#111] transition-[box-shadow,translate] duration-[120ms] placeholder:text-[#11111166] focus:-translate-x-0.5 focus:-translate-y-0.5 focus:shadow-[4px_4px_0_#111] focus:outline-none dark:border-[#22d3ee] dark:bg-[#0b0724] dark:text-[#f8f5ff] dark:placeholder:text-[#a5f3fc66] dark:focus:shadow-[4px_4px_0_#ff2e97]'}
{assign var="arc_wrap" value='flex w-full items-center gap-2 rounded-[10px] border-[3px] border-[#111] bg-white pe-3.5 text-[#111] transition-[box-shadow,translate] duration-[120ms] focus-within:-translate-x-0.5 focus-within:-translate-y-0.5 focus-within:shadow-[4px_4px_0_#111] dark:border-[#22d3ee] dark:bg-[#0b0724] dark:text-[#f8f5ff] dark:focus-within:shadow-[4px_4px_0_#ff2e97]'}
{assign var="arc_inner" value='min-w-0 grow bg-transparent py-3 ps-3.5 text-[.95rem] font-semibold outline-none placeholder:text-[#11111166] dark:placeholder:text-[#a5f3fc66]'}
{assign var="arc_select" value='select w-full rounded-[10px] border-[3px] border-[#111] bg-white font-semibold text-[#111] dark:border-[#22d3ee] dark:bg-[#0b0724] dark:text-[#f8f5ff]'}
{assign var="arc_check" value='checkbox [--input-color:#5157e7] dark:[--input-color:#ff2e97]'}
{assign var="arc_button" value='w-full cursor-pointer rounded-[10px] border-[3px] border-[#111] bg-[#fb923c] p-3.5 text-base font-black uppercase tracking-[.04em] text-[#111] shadow-[5px_5px_0_#111] transition-[box-shadow,translate] duration-[120ms] hover:translate-x-0.5 hover:translate-y-0.5 hover:shadow-[2px_2px_0_#111] active:translate-x-[5px] active:translate-y-[5px] active:shadow-none dark:border-[#22d3ee] dark:shadow-[5px_5px_0_#ff2e97] dark:hover:shadow-[2px_2px_0_#ff2e97] dark:bg-[#facc15] dark:text-[#0b0724]'}
{assign var="arc_alert" value='alert alert-danger alert-error hidden rounded-[10px] border-[3px] border-[#111] bg-[#fecaca] font-semibold text-[#111] dark:border-[#ff2e97] dark:bg-[#3b0a2a] dark:text-[#f8f5ff]'}
{assign var="arc_links" value='mt-[22px] flex flex-wrap justify-between gap-3 text-[.85rem] font-extrabold'}
{assign var="arc_link" value='text-[#111]! underline decoration-[#5157e7] decoration-[3px] underline-offset-[3px] hover:decoration-[#fb923c] dark:text-[#f8f5ff]! dark:decoration-[#22d3ee] dark:hover:decoration-[#ff2e97]'}
<div class="w-full">

  <!-- signin -->
  <div class="js_panel {if $do == 'up'}hidden{/if}">
    <span class="{$arc_tag}">{__("Members only")}</span>
    <h2 class="{$arc_heading}">{__("Log in.")}</h2>
    <p class="{$arc_sub}">{__("No fluff. Just your friends and your feed.")}</p>
    {if isset($highlight)}
      <div class="alert alert-warning mb-5 rounded-[10px] border-[3px] border-[#111] font-semibold" role="alert">{$highlight}</div>
    {/if}
    {if $system['social_login_enabled']}
      {include file='__social_login.tpl' _style="retro" _or_pos="bottom" _margin="mt-0"}
    {/if}
    <form class="js_ajax-forms flex flex-col gap-[18px]" data-url="core/signin.php" method="POST">
      <!-- username or email -->
      <div>
        <label class="{$arc_label}" for="signin-username-email">{__("Email")} {__("or")} {__("Username")}</label>
        <input type="text" class="{$arc_input}" id="signin-username-email" name="username_email" placeholder="you@example.com" autocomplete="username" spellcheck="false" required>
      </div>
      <!-- username or email -->

      <!-- password -->
      <div>
        <label class="{$arc_label}" for="signin-password">{__("Password")}</label>
        <div class="{$arc_wrap}">
          <input type="password" class="{$arc_inner}" id="signin-password" name="password" placeholder="••••••••" autocomplete="current-password" required>
          {include file='__password_toggle.tpl'}
        </div>
      </div>
      <!-- password -->

      <!-- remember me -->
      <div class="flex items-center gap-2">
        <input type="checkbox" class="{$arc_check}" name="remember" id="remember">
        <label class="text-[.85rem] font-bold" for="remember">{__("Remember me")}</label>
      </div>
      <!-- remember me -->

      <!-- submit -->
      <button type="submit" class="{$arc_button}">{__("Let me in")} <span class="inline-block rtl:rotate-180" aria-hidden="true">→</span></button>
      <!-- submit -->

      <!-- error -->
      <div class="{$arc_alert}"></div>
      <!-- error -->
    </form>
    <div class="{$arc_links}">
      <a class="{$arc_link}" href="{$system['system_url']}/reset">{__("Lost password")}</a>
      {if $system['registration_enabled']}
        <a class="js_toggle-panel {$arc_link}" href="{$system['system_url']}/signup{if $oauth_app_id}?oauth_app_id={$oauth_app_id}{/if}">{__("Join instead")}</a>
      {/if}
    </div>
  </div>
  <!-- signin -->

  <!-- signup -->
  <div class="js_panel {if $do != 'up'}hidden{/if}">
    <span class="{$arc_tag}">{__("New player")}</span>
    <h2 class="{$arc_heading}">{__("Join in.")}</h2>
    <p class="{$arc_sub}">{__("Pick a username and you're in.")}</p>
    {if $system['social_login_enabled']}
      {include file='__social_login.tpl' _style="retro" _or_pos="bottom" _margin="mt-0"}
    {/if}
    <form class="js_ajax-forms flex flex-col gap-[18px]" data-url="core/signup.php" method="POST">
      {if $system['invitation_enabled']}
        <!-- invitation code -->
        <div>
          <label class="{$arc_label}" for="signup-invitation-code">{__("Invitation Code")}</label>
          <input name="invitation_code" type="text" class="{$arc_input}" id="signup-invitation-code" value="{$invitation_code}" spellcheck="false" required>
        </div>
        <!-- invitation code -->
      {/if}
      {if !$system['show_usernames_enabled']}
        <div class="grid gap-[18px] sm:grid-cols-2">
          <!-- first name -->
          <div>
            <label class="{$arc_label}" for="signup-first-name">{__("First name")}</label>
            <input name="first_name" type="text" class="{$arc_input}" id="signup-first-name" required>
          </div>
          <!-- first name -->
          <!-- last name -->
          <div>
            <label class="{$arc_label}" for="signup-last-name">{__("Last name")}</label>
            <input name="last_name" type="text" class="{$arc_input}" id="signup-last-name" required>
          </div>
          <!-- last name -->
        </div>
      {/if}
      <!-- username -->
      <div>
        <label class="{$arc_label}" for="signup-username">{__("Username")}</label>
        <input name="username" type="text" class="{$arc_input}" id="signup-username" autocomplete="username" spellcheck="false" required>
      </div>
      <!-- username -->
      <!-- email -->
      <div>
        <label class="{$arc_label}" for="signup-email">{__("Email")}</label>
        <input name="email" type="email" class="{$arc_input}" id="signup-email" placeholder="you@example.com" autocomplete="email" spellcheck="false" required>
      </div>
      <!-- email -->
      {if $system['activation_enabled'] && $system['activation_type'] == "sms"}
        <!-- phone -->
        <div>
          <label class="{$arc_label}" for="signup-phone">{__("Phone number")}</label>
          <input name="phone" type="text" class="{$arc_input}" id="signup-phone" placeholder='{__("Phone number (e.g: +1234567890)")}' required>
        </div>
        <!-- phone -->
      {/if}
      <!-- password -->
      <div>
        <label class="{$arc_label}" for="signup-password">{__("Password")}</label>
        <div class="{$arc_wrap}">
          <input name="password" type="password" class="{$arc_inner}" id="signup-password" placeholder="••••••••" autocomplete="new-password" required>
          {include file='__password_toggle.tpl'}
        </div>
      </div>
      <!-- password -->
      <!-- custom fields -->
      {if $custom_fields}
        {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true _input_class=$arc_input _select_class=$arc_select _textarea_class=$arc_input _label_class=$arc_label_extras}
      {/if}
      <!-- custom fields -->
      <div class="js_hidden-section hidden space-y-[18px]">
        {include file='__sign_form_extras.tpl' _floating=false _select_class=$arc_select _label_class=$arc_label_extras _checkbox_class=$arc_check}
      </div>
      <!-- submit -->
      {if $oauth_app_id}
        <input type="hidden" name="oauth_app_id" value="{$oauth_app_id}">
      {/if}
      <button type="submit" class="{$arc_button}">{__("Create account")} <span class="inline-block rtl:rotate-180" aria-hidden="true">→</span></button>
      <!-- submit -->
      <!-- error -->
      <div class="{$arc_alert}"></div>
      <!-- error -->
    </form>
    <div class="{$arc_links}">
      <a class="js_toggle-panel {$arc_link}" href="{$system['system_url']}/signin">{__("Already a member")}</a>
    </div>
  </div>
  <!-- signup -->
</div>
