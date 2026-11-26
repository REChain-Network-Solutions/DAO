{include file='__modal_header.tpl' _icon="icon-[tabler--tag]" _title=__("New Coupon")}
<form class="js_ajax-forms" data-url="monetization/controller.php?do=insert_coupon">
  <div class="modal__body flex flex-col gap-4">
    <!-- is onetime -->
    <div class="flex items-center gap-4">
      <div class="min-w-0 grow">
        <div class="text-sm font-medium text-base-content" id="is_onetime-label">{__("Is one time coupon")}</div>
        <p class="mt-0.5 text-xs text-base-content/60">{__("If enabled, the coupon will be used only once")}</p>
      </div>
      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px] [--border:1px]" aria-labelledby="is_onetime-label" name="is_onetime" id="is_onetime">
    </div>
    <!-- is onetime -->
    <!-- discount percent -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="monetization-add-coupon-discount-percent">{__("Discount Percent")}</label>
      <input name="discount_percent" type="number" min="1" max="99" class="input w-full [--border:1px]" id="monetization-add-coupon-discount-percent">
      <p class="mt-1.5 text-sm text-base-content/60">{__("How much discount you want to apply for this coupon (min 1, max 99)")}</p>
    </div>
    <!-- discount percent -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <input type="hidden" name="node_id" value="{$node_id}">
    <input type="hidden" name="node_type" value="{$node_type}">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Generate")}</button>
  </div>
</form>
