<div class="modal__header mb-4 flex-row items-center gap-3 [&+.modal\_\_body]:mt-0">
  <span class="modal__icon size-9 rounded-lg bg-base-200 text-base-content" aria-hidden="true"><span class="icon-[tabler--receipt] size-5"></span></span>
  <div class="min-w-0 flex-1">
    <h6 class="modal__heading">{__("View Order")} #{$order['order_hash']}</h6>
  </div>
  {include file='__close_button.tpl' extra_class="static"}
</div>
<div class="modal__body flex flex-col gap-4">
  <ul class="m-0 list-none p-0">
    {include file='_order.tpl' for_admin=true sales=true}
  </ul>
</div>
