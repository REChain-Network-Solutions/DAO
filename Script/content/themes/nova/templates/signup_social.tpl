{assign var="page" value="sign"}
{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
{capture name="auth_content"}
  <div class="text-center">
    {if $user_profile->photoURL}
      <img class="mx-auto mb-4 size-20 rounded-full object-cover" src="{$user_profile->photoURL}" width="80" height="80" alt="{$user_profile->displayName}">
    {/if}
    <h2 class="mb-1.5 text-2xl font-semibold">{__("Welcome")} <span class="text-primary">{$user_profile->displayName}</span></h2>
    <p class="text-base-content/80">{__("This information will let us know more about you")}</p>
  </div>
  <form class="js_ajax-forms mt-6 flex flex-col gap-5" data-url="core/signup_social.php">
    {if $system['invitation_enabled']}
      <!-- invitation code -->
      <div class="input-floating">
        <input name="invitation_code" type="text" class="input input-lg" id="social-invitation-code" placeholder='{__("Invitation Code")}' value="{$invitation_code}" required>
        <label class="input-floating-label" for="social-invitation-code">{__("Invitation Code")}</label>
      </div>
      <!-- invitation code -->
    {/if}
    {if !$system['show_usernames_enabled']}
      <div class="grid gap-5 sm:grid-cols-2">
        <!-- first name -->
        <div class="input-floating">
          <input name="first_name" type="text" class="input input-lg" id="social-first-name" placeholder='{__("First name")}' value="{$user_profile->firstName}" required>
          <label class="input-floating-label" for="social-first-name">{__("First name")}</label>
        </div>
        <!-- first name -->
        <!-- last name -->
        <div class="input-floating">
          <input name="last_name" type="text" class="input input-lg" id="social-last-name" placeholder='{__("Last name")}' value="{$user_profile->lastName}" required>
          <label class="input-floating-label" for="social-last-name">{__("Last name")}</label>
        </div>
        <!-- last name -->
      </div>
    {/if}
    <!-- username -->
    <div class="input-floating">
      <input name="username" type="text" class="input input-lg" id="social-username" placeholder='{__("Username")}' required>
      <label class="input-floating-label" for="social-username">{__("Username")}</label>
    </div>
    <!-- username -->
    <!-- email -->
    <div class="input-floating">
      <input name="email" type="email" class="input input-lg" id="social-email" placeholder='{__("Email")}' value="{$user_profile->email}" required>
      <label class="input-floating-label" for="social-email">{__("Email")}</label>
    </div>
    <!-- email -->
    {if $system['activation_enabled'] && $system['activation_type'] == "sms"}
      <!-- phone -->
      <div class="input-floating">
        <input name="phone" type="text" class="input input-lg" id="social-phone" placeholder='{__("Phone number (e.g: +1234567890)")}' required>
        <label class="input-floating-label" for="social-phone">{__("Phone number")}</label>
      </div>
      <!-- phone -->
    {/if}
    <!-- password -->
    <div class="input-floating">
      <div class="input input-lg">
        <input name="password" type="password" class="grow" id="social-password" placeholder='{__("Password")}' required>
        {include file='__password_toggle.tpl'}
      </div>
      <label class="input-floating-label" for="social-password">{__("Password")}</label>
    </div>
    <!-- password -->
    <!-- custom fields -->
    {if $custom_fields}
      {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true}
    {/if}
    <!-- custom fields -->
    {if !$system['genders_disabled']}
      <!-- genders -->
      <div class="select-floating">
        <select class="select select-lg" name="gender" id="gender" required>
          <option value="none">{__("Gender")}:</option>
          {foreach $genders as $gender}
            <option value="{$gender['gender_id']}">{$gender['gender_name']}</option>
          {/foreach}
        </select>
        <label class="select-floating-label" for="gender">{__("Gender")}</label>
      </div>
      <!-- genders -->
    {/if}
    {if $system['age_restriction']}
      <!-- birthdate -->
      <div class="flex min-w-0 flex-col gap-2">
        <label class="label-text">{__("Birthdate")}</label>
        <div class="grid grid-cols-3 gap-2">
          <select class="select select-lg" name="birth_month" aria-label="{__("Month")}">
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
          <select class="select select-lg" name="birth_day" aria-label="{__("Day")}">
            <option value="none">{__("Day")}</option>
            {for $i=1 to 31}
              <option {if $user->_data['user_birthdate_parsed']['day'] == $i}selected{/if} value="{$i}">{$i}</option>
            {/for}
          </select>
          <select class="select select-lg" name="birth_year" aria-label="{__("Year")}">
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
      <div class="select-floating">
        <select class="select select-lg" name="custom_user_group" id="social-user-group">
          <option value="none">{__("User Group")}:</option>
          <option value="0">{__("Users")}</option>
          {foreach $user_groups as $user_group}
            <option value="{$user_group['user_group_id']}">{__($user_group['user_group_title'])}</option>
          {/foreach}
        </select>
        <label class="select-floating-label" for="social-user-group">{__("User Group")}</label>
      </div>
      <!-- user group -->
    {/if}
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
    <!-- submit -->
    <input value="{$user_profile->photoURL}" name="avatar" type="hidden">
    <input value="{$provider}" name="provider" type="hidden">
    <button type="submit" class="heroui button button--primary button--lg button--full-width">{__("Sign Up")}</button>
    <!-- submit -->
    <!-- error -->
    <div class="alert alert-danger alert-error hidden"></div>
    <!-- error -->
  </form>
{/capture}
{include file='__auth_card.tpl' _width="max-w-lg"}
<!-- page content -->

{include file='_footer.tpl'}