{include file='__modal_header.tpl' _icon="icon-[tabler--star]" _title=__("Reply To Review")}
<form class="js_ajax-forms" data-url="modules/review.php?do=publish-reply&id={$review['review_id']}" method="POST">
  <div class="modal__body flex flex-col gap-4">
    <!-- reply -->
    <div class="w-full">
      <label class="label-text mb-1.5 block">{__("Write Your Reply")}</label>
      <textarea name="reply" rows="5" dir="auto" class="textarea w-full [--border:1px]"></textarea>
    </div>
    <!-- reply -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Submit")}</button>
  </div>
</form>
