{assign var="_menu_class" value=$_select_class|default:"select w-full"}
{assign var="_text_class" value=$_label_class|default:"label-text"}
{assign var="_box_class" value=$_checkbox_class|default:"checkbox checkbox-primary"}
{if !$system['genders_disabled']}
  <!-- genders -->
  <div class="{if $_floating}select-floating{else}flex min-w-0 flex-col gap-2{/if}">
    {if !$_floating}<label class="{$_text_class}" for="gender">{__("Gender")}</label>{/if}
    <select class="{$_menu_class}" name="gender" id="gender" required>
      <option value="none">{__("Gender")}:</option>
      {foreach $genders as $gender}
        <option value="{$gender['gender_id']}">{$gender['gender_name']}</option>
      {/foreach}
    </select>
    {if $_floating}<label class="select-floating-label" for="gender">{__("Gender")}</label>{/if}
  </div>
  <!-- genders -->
{/if}
{if $system['age_restriction']}
  <!-- birthdate -->
  <div class="flex min-w-0 flex-col gap-2">
    <label class="{$_text_class}">{__("Birthdate")}</label>
    <div class="grid grid-cols-3 gap-2">
      <select class="{$_menu_class}" name="birth_month" aria-label="{__("Month")}">
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
      <select class="{$_menu_class}" name="birth_day" aria-label="{__("Day")}">
        <option value="none">{__("Day")}</option>
        {for $i=1 to 31}
          <option {if $user->_data['user_birthdate_parsed']['day'] == $i}selected{/if} value="{$i}">{$i}</option>
        {/for}
      </select>
      <select class="{$_menu_class}" name="birth_year" aria-label="{__("Year")}">
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
  <div class="{if $_floating}select-floating{else}flex min-w-0 flex-col gap-2{/if}">
    {if !$_floating}<label class="{$_text_class}" for="signup-user-group">{__("User Group")}</label>{/if}
    <select class="{$_menu_class}" name="custom_user_group" id="signup-user-group">
      <option value="none">{__("User Group")}:</option>
      <option value="0">{__("Users")}</option>
      {foreach $user_groups as $user_group}
        <option value="{$user_group['user_group_id']}">{__($user_group['user_group_title'])}</option>
      {/foreach}
    </select>
    {if $_floating}<label class="select-floating-label" for="signup-user-group">{__("User Group")}</label>{/if}
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
    <input type="checkbox" class="{$_box_class} mt-0.5" name="newsletter_agree" id="newsletter_agree">
    <label class="{$_text_class} text-base-content/80 p-0" for="newsletter_agree">
      {__("I expressly agree to receive the newsletter")}
    </label>
  </div>
  <!-- newsletter consent -->
{/if}
<!-- privacy & terms consent -->
<div class="flex items-start gap-2">
  <input type="checkbox" class="{$_box_class} mt-0.5" name="privacy_agree" id="privacy_agree">
  <label class="{$_text_class} text-base-content/80 p-0" for="privacy_agree">
    {__("By creating your account, you agree to our")} <a href="{$system['system_url']}/static/terms" class="link link-primary" target="_blank">{__("Terms")}</a> {__("and")} <a href="{$system['system_url']}/static/privacy" class="link link-primary" target="_blank">{__("Privacy Policy")}</a>
  </label>
</div>
<!-- privacy & terms consent -->
