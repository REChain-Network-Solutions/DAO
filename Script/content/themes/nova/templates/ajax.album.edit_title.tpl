{include file='__modal_header.tpl' _icon="icon-[tabler--album]" _title=__("Edit Album")}
<form class="js_ajax-forms" data-url="albums/action.php">
  <div class="modal__body flex flex-col gap-4">
    <!-- title -->
    <div class="w-full">
      <label class="label-text mb-1.5 block">{__("Title")}</label>
      <input type="hidden" name="do" value="edit_album">
      <input type="hidden" name="id" value="{$album['album_id']}">
      <input name="title" type="text" value="{$album['title']}" class="input w-full [--border:1px]" required autofocus>
    </div>
    <!-- title -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Save")}</button>
  </div>
</form>
