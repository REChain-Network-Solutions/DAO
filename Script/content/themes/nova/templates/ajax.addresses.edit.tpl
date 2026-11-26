{include file='__modal_header.tpl' _icon="icon-[tabler--map-pin]" _title=__("Edit Address")}
<form class="js_ajax-forms" data-url="users/addresses.php?do=update">
  <div class="modal__body flex flex-col gap-4">
    <!-- title -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="address-edit-title">{__("Title")}</label>
      <label class="input w-full [--border:1px]">
        <span class="icon-[tabler--tag] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
        <input type="text" class="grow" id="address-edit-title" name="title" value="{$address['address_title']}">
      </label>
    </div>
    <!-- title -->
    <!-- address -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="address-edit-address">{__("Address")}</label>
      <textarea class="textarea w-full [--border:1px]" id="address-edit-address" name="address" rows="2" dir="auto">{$address['address_details']}</textarea>
    </div>
    <!-- address -->
    <div class="grid gap-4 sm:grid-cols-2">
      <!-- country -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="address-edit-country">{__("Country")}</label>
        <label class="input w-full [--border:1px]">
          <span class="icon-[tabler--world] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
          <input type="text" class="grow" id="address-edit-country" name="country" value="{$address['address_country']}">
        </label>
      </div>
      <!-- country -->
      <!-- city -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="address-edit-city">{__("City")}</label>
        <label class="input w-full [--border:1px]">
          <span class="icon-[tabler--building-community] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
          <input type="text" class="grow" id="address-edit-city" name="city" value="{$address['address_city']}">
        </label>
      </div>
      <!-- city -->
      <!-- zip code -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="address-edit-zip">{__("Zip Code")}</label>
        <label class="input w-full [--border:1px]">
          <span class="icon-[tabler--mailbox] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
          <input type="text" class="grow" id="address-edit-zip" name="zip_code" value="{$address['address_zip_code']}">
        </label>
      </div>
      <!-- zip code -->
      <!-- phone -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="address-edit-phone">{__("Phone")}</label>
        <label class="input w-full [--border:1px]">
          <span class="icon-[tabler--phone] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
          <input type="tel" class="grow" id="address-edit-phone" name="phone" value="{$address['address_phone']}" dir="ltr">
        </label>
      </div>
      <!-- phone -->
    </div>
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <input type="hidden" name="address_id" value="{$address['address_id']}">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Update")}</button>
  </div>
</form>
