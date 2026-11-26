<div class="modal__header shrink-0 flex-row items-center gap-2.5 border-b border-base-300 px-4 py-3 sm:px-5">
  <h6 class="modal__heading min-w-0 flex-1 text-base font-semibold text-base-content">{__("Send a Paid Message")}</h6>
  {include file='__close_button.tpl' extra_class='static js_close-publisher-modal' no_overlay=true}
</div>
<div class="modal__body flex min-h-0 flex-col overflow-hidden p-0">
  {include file='_publisher.chat.tpl'}
</div>
