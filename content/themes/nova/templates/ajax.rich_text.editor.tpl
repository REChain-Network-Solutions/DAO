{include file='__modal_header.tpl' _icon="icon-[tabler--code]" _title=__("Edit Rich Text Post")}
<form class="js_ajax-forms" data-url="posts/rich_text.php?do=update&post_id={$post['post_id']}">
  <div class="modal__body flex flex-col gap-4">
    <!-- rich text editor -->
    <div class="w-full">
      <textarea name="text" class="textarea js_wysiwyg" id="rich-text-editor">{$post['rich_text']['text']}</textarea>
    </div>
    <!-- rich text editor -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Save")}</button>
  </div>
</form>

<style>
  .tox-tinymce-aux {
    z-index: 100001 !important;
  }
</style>

<script>
  $(document).ready(function() {
    init_tinymce_editor();
    /* let TinyMCE dialogs receive focus inside a Bootstrap modal */
    if (!window.tinymce_modal_focusfix) {
      window.tinymce_modal_focusfix = true;
      document.addEventListener('focusin', function(e) {
        if (e.target.closest('.tox-tinymce-aux, .tox-dialog, .moxman-window, .tam-assetmanager-root')) {
          e.stopImmediatePropagation();
        }
      }, true);
    }
  });
</script>
