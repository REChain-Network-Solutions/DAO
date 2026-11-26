{include file='__modal_header.tpl' _icon="icon-[tabler--user-plus]" _title=__("Share Invitation Code")}
<form class="js_ajax-forms" data-url="users/invitations.php?do=send">
  <div class="modal__body flex flex-col gap-4">
    <!-- invitation code -->
    <div class="flex flex-col items-center gap-2 rounded-box bg-base-200 p-4 text-center">
      <span class="text-sm text-base-content/60">{__("Your invitation code is")}</span>
      <span class="badge badge-warning badge-lg font-mono font-semibold tracking-wider">{$code}</span>
    </div>
    <!-- invitation code -->

    <!-- invitation link -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="invitation-link">{__("Link")}</label>
      {include file='__copy_input.tpl' _id="invitation-link" _value="{$system['system_url']}/signup?invitation_code={$code}{if $system['affiliates_enabled']}&ref={$user->_data['user_name']}{/if}"}
    </div>
    <div class="flex items-center justify-between gap-2">
      {include file='__social_share.tpl' _link="{$system['system_url']}/signup?invitation_code={$code}{if $system['affiliates_enabled']}&ref={$user->_data['user_name']}{/if}"}
    </div>
    <!-- invitation link -->

    <hr class="separator">

    <!-- send method -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Share the code to")}</span>
      <div class="grid gap-3 sm:grid-cols-2">
        {if $system['invitation_send_method'] == "email" || $system['invitation_send_method'] == "both"}
          <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="send_method_email">
            <input type="radio" name="send_method" id="send_method_email" value="email" class="radio radio-primary [--border:1px]" checked="checked">
            <span class="icon-[tabler--mail] size-5 shrink-0" aria-hidden="true"></span>
            <span class="text-sm font-medium">{__("Email")}</span>
          </label>
        {/if}
        {if $system['invitation_send_method'] == "sms" || $system['invitation_send_method'] == "both"}
          <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="send_method_sms">
            <input type="radio" name="send_method" id="send_method_sms" value="sms" class="radio radio-primary [--border:1px]"{if $system['invitation_send_method'] == "sms"} checked="checked"{/if}>
            <span class="icon-[tabler--message] size-5 shrink-0" aria-hidden="true"></span>
            <span class="text-sm font-medium">{__("SMS")}</span>
          </label>
        {/if}
      </div>
    </div>
    <!-- send method -->

    <div id="js_method-email" {if $system['invitation_send_method'] == "sms"}class="hidden" {/if}>
      <label class="label-text mb-1.5 block" for="invitation-email">{__("Email")}</label>
      <div class="input w-full [--border:1px]">
        <span class="icon-[tabler--mail] my-auto me-2 size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
        <input type="email" class="grow" id="invitation-email" name="email">
      </div>
    </div>

    <div id="js_method-sms" {if $system['invitation_send_method'] != "sms"}class="hidden" {/if}>
      <label class="label-text mb-1.5 block" for="invitation-phone">{__("Phone")}</label>
      <div class="input w-full [--border:1px]">
        <span class="icon-[tabler--phone] my-auto me-2 size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
        <input type="text" class="grow" id="invitation-phone" name="phone" dir="ltr">
      </div>
      <p class="mt-1.5 text-sm text-base-content/60">{__("Phone number i.e +1234567890")}</p>
    </div>

    <!-- success -->
    <div class="alert alert-soft alert-success hidden"></div>
    <!-- success -->

    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <input type="hidden" name="code" value="{$code}">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Send")}</button>
  </div>
</form>

<script>
  /* share post */
  $('input[type=radio][name=send_method]').on('change', function() {
    switch ($(this).val()) {
      case 'email':
        $('#js_method-sms').hide();
        $('#js_method-email').fadeIn();
        break;
      case 'sms':
        $('#js_method-email').hide();
        $('#js_method-sms').fadeIn();
        break;
    }
  });
</script>