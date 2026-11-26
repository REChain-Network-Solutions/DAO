{include file='__modal_header.tpl' _icon="icon-[tabler--users]" _title=__("Group")}
<div class="modal__body">
  {include file='__chat_group.manage.tpl'}
</div>
<div class="modal__footer justify-end gap-2 border-t border-base-300 pt-4">
  <button type="button" class="button button--danger-soft js_chat-group-remove" data-cid="{$conversation['conversation_id']}" data-uid="{$user->_data['user_id']}">
    <span class="icon-[tabler--logout] size-4" aria-hidden="true"></span>{__("Leave")}
  </button>
</div>
