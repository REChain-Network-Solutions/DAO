{include file='__modal_header.tpl' _icon="icon-[tabler--map-pin]" _title=__("Add New Address")}
<form class="js_ajax-forms" data-url="users/addresses.php?do=insert">
  <div class="modal__body flex flex-col gap-4">
    <!-- title -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="address-add-title">{__("Title")}</label>
      <label class="input w-full [--border:1px]">
        <span class="icon-[tabler--tag] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
        <input type="text" class="grow" id="address-add-title" name="title">
      </label>
    </div>
    <!-- title -->
    <!-- address -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="address-add-address">{__("Address")}</label>
      <textarea class="textarea w-full [--border:1px]" id="address-add-address" name="address" rows="2" dir="auto"></textarea>
    </div>
    <!-- address -->
    <div class="grid gap-4 sm:grid-cols-2">
      <!-- country -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="address-add-country">{__("Country")}</label>
        <label class="input w-full [--border:1px]">
          <span class="icon-[tabler--world] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
          <input type="text" class="grow" id="address-add-country" name="country">
        </label>
      </div>
      <!-- country -->
      <!-- city -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="address-add-city">{__("City")}</label>
        <label class="input w-full [--border:1px]">
          <span class="icon-[tabler--building-community] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
          <input type="text" class="grow" id="address-add-city" name="city">
        </label>
      </div>
      <!-- city -->
      <!-- zip code -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="address-add-zip">{__("Zip Code")}</label>
        <label class="input w-full [--border:1px]">
          <span class="icon-[tabler--mailbox] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
          <input type="text" class="grow" id="address-add-zip" name="zip_code">
        </label>
      </div>
      <!-- zip code -->
      <!-- phone -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="address-add-phone">{__("Phone")}</label>
        <label class="input w-full [--border:1px]">
          <span class="icon-[tabler--phone] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
          <input type="tel" class="grow" id="address-add-phone" name="phone" dir="ltr">
        </label>
      </div>
      <!-- phone -->
    </div>
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Add")}</button>
  </div>
</form>
