<div class="modal__header mb-4 flex-row items-center gap-3 [&+.modal\_\_body]:mt-0">
  <span class="modal__icon size-9 rounded-lg bg-base-200 text-base-content" aria-hidden="true"><span class="icon-[tabler--truck] size-5"></span></span>
  <div class="min-w-0 flex-1">
    <h6 class="modal__heading">{__("Update Order")} #{$order['order_hash']}</h6>
  </div>
  {include file='__close_button.tpl' extra_class="static"}
</div>
<form class="js_ajax-forms" data-url="users/orders.php?do=update">
  <div class="modal__body flex flex-col gap-4">
    <!-- status -->
    <div class="w-full">
      <label class="label-text mb-1.5 block">{__("Status")}</label>
      <select class="select w-full [--border:1px]" name="status">
        {if $order['seller_id'] == $user->_data['user_id']}
          <option value="placed" {if $order['status'] == "placed"}selected{/if}>{__("placed")|ucfirst}</option>
          <option value="canceled" {if $order['status'] == "canceled"}selected{/if}>{__("canceled")|ucfirst}</option>
          <option value="accepted" {if $order['status'] == "accepted"}selected{/if}>{__("accepted")|ucfirst}</option>
          <option value="packed" {if $order['status'] == "packed"}selected{/if}>{__("packed")|ucfirst}</option>
          <option value="shipped" {if $order['status'] == "shipped"}selected{/if}>{__("shipped")|ucfirst}</option>
        {else}
          <option value="delivered" {if $order['status'] == "delivered"}selected{/if}>{__("delivered")|ucfirst}</option>
        {/if}
      </select>
    </div>
    <!-- status -->
    {if $order['seller_id'] == $user->_data['user_id']}
      <!-- tracking link -->
      <div class="w-full">
        <label class="label-text mb-1.5 block">{__("Tracking Link")}</label>
        <input name="tracking_link" type="text" class="input w-full [--border:1px]" value="{$order['tracking_link']}">
      </div>
      <!-- tracking link -->
      <!-- tracking number -->
      <div class="w-full">
        <label class="label-text mb-1.5 block">{__("Tracking Number")}</label>
        <input name="tracking_number" type="text" class="input w-full [--border:1px]" value="{$order['tracking_number']}">
      </div>
      <!-- tracking number -->
    {/if}
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <input type="hidden" name="order_id" value="{$order['order_id']}">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Update")}</button>
  </div>
</form>
