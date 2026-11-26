{include file='__modal_header.tpl' _icon="icon-[tabler--message-heart]" _title=__("Send a Message")}
<form class="js_dating-message-form" data-id="{$id}">
  <div class="modal__body flex flex-col gap-4">
    <p class="text-sm text-base-content/60">{__("Your message goes with your like and shows at the top of their likes")}</p>
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="dating-message">{__("Message")}</label>
      <textarea name="message" id="dating-message" rows="3" maxlength="200" dir="auto" class="textarea w-full [--border:1px]" required></textarea>
    </div>
    <div class="flex items-center justify-between rounded-xl bg-base-200/60 px-4 py-3 text-sm">
      <span class="text-base-content/60">{__("Price")}</span>
      <strong>{print_money($system['dating_priority_message_price'])}</strong>
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
