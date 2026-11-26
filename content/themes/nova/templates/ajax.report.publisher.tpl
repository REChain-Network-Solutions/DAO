{include file='__modal_header.tpl' _icon="icon-[tabler--flag]" _title=__("Report")}
<form class="js_ajax-forms" data-url="data/report.php?do=submit&id={$id}&handle={$handle}">
  <div class="modal__body flex flex-col gap-4">
    <!-- category -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="category">{__("Why you want to report this?")}</label>
      <select class="select w-full [--border:1px]" name="category" id="category">
        {foreach $categories as $category}
          {include file='__categories.recursive_options.tpl'}
        {/foreach}
      </select>
    </div>
    <!-- category -->
    <!-- reason -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="report-reason">{__("Reason")}</label>
      <textarea name="reason" id="report-reason" rows="3" dir="auto" class="textarea w-full [--border:1px]"></textarea>
    </div>
    <!-- reason -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Report")}</button>
  </div>
</form>
