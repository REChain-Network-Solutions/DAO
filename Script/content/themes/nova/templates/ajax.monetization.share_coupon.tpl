{include file='__modal_header.tpl' _icon="icon-[tabler--discount]" _title=__("Share Coupon Code")}
<div class="modal__body flex flex-col gap-4">
  <!-- coupon code -->
  <div class="w-full">
    <label class="label-text mb-1.5 block" for="coupon-code">{__("Your coupon code is")}</label>
    {include file='__copy_input.tpl' _id="coupon-code" _value=$coupon['coupon_code'] _icon="icon-[tabler--discount]" _class="font-mono font-semibold tracking-wider"}
  </div>
  <!-- coupon code -->

  <!-- social share -->
  <div class="flex items-center justify-between gap-2">
    {include file='__social_share.tpl' _link=$coupon['sharing_text']}
  </div>
  <!-- social share -->
</div>
