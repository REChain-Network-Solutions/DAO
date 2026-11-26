{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
{capture name="auth_content"}
  <div class="text-center">
    <h2 class="mb-1.5 text-2xl font-semibold">{__("Hey")} 👋 {__("Let's verify your")} {if $system['activation_type'] == "email"}{__("email")}{else}{__("phone")}{/if}</h2>
    <p class="text-base-content/80">
      {if $system['activation_type'] == "email"}
        {__("Please go to")} <span class="font-medium text-primary">{$user->_data['user_email']}</span> {__("to complete the activation process")}
      {else}
        {__("Please check the SMS on your phone")} <strong>{$user->_data['user_phone']}</strong> {__("to complete the activation process")}
      {/if}
    </p>
    {if $system['activation_type'] == "email"}
      <p class="mt-3 text-sm text-base-content/60">{__("If you didn't receive the email, please check your spam/junk folder")}</p>
    {/if}
  </div>
  <div class="mt-6 flex flex-col gap-3">
    {if $system['activation_type'] == "email"}
      <button type="button" class="js_modal heroui button button--primary button--lg button--full-width" data-url="#activation-email">{__("Enter Code")}</button>
      <button type="button" class="js_modal heroui button button--outline button--lg button--full-width" data-url="core/activation_email_resend.php">{__("Resend Email")}</button>
      <button type="button" class="js_modal heroui button button--ghost button--lg button--full-width" data-url="#activation-email-reset">{__("Change Email")}</button>
    {else}
      <button type="button" class="js_modal heroui button button--primary button--lg button--full-width" data-url="#activation-phone">{__("Enter Code")}</button>
      {if $user->_data['user_phone']}
        <button type="button" class="js_modal heroui button button--outline button--lg button--full-width" data-url="core/activation_phone_resend.php">{__("Resend SMS")}</button>
      {/if}
      <button type="button" class="js_modal heroui button button--ghost button--lg button--full-width" data-url="#activation-phone-reset">{__("Change Phone Number")}</button>
    {/if}
  </div>
{/capture}
{include file='__auth_card.tpl'}
<!-- page content -->

{include file='_footer.tpl'}
