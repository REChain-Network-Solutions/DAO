<div class="modal-header">
  <h6 class="modal-title">
    {include file='__svg_icons.tpl' icon="activities" class="main-icon mr10" width="24px" height="24px"}
    {__("Create New Activity")}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form class="js_ajax-forms" data-url="modules/activities.php?do=publish">
  <div class="modal-body">
    <div class="form-group">
      <label class="form-label" for="title">{__("Activity")}</label>
      <input type="text" class="form-control" name="title" id="title">
    </div>
    <div class="form-group">
      <label class="form-label" for="description">{__("About")}</label>
      <textarea class="form-control" name="description"></textarea>
    </div>
    <div class="form-group">
      <label class="form-label" for="category">{__("Category")}</label>
      <select class="form-select" name="category" id="category">
        <option>{__("Select Category")}</option>
        {foreach $categories as $category}
          {include file='__categories.recursive_options.tpl'}
        {/foreach}
      </select>
    </div>
    <div class="divider"></div>
    <div class="form-group">
      <label class="form-label" for="follow_date">{__("Follow Alert")}</label>
      <input type="datetime-local" class="form-control" name="follow_date" id="follow_date">
    </div>
    <div class="form-group">
      <label class="form-label" for="follow_date">{__("Follow Message")}</label>
      <textarea class="form-control" name="follow_message"></textarea>
    </div>
    <!-- error -->
    <div class="alert alert-danger mb0 mt10 x-hidden"></div>
    <!-- error -->
  </div>
  <div class="modal-footer">
    <input type="hidden" name="page_id" value="{$spage['page_id']}">
    <button type="submit" class="btn btn-primary">{__("Create")}</button>
  </div>
</form>