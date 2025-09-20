<div class="modal-header">
  <h6 class="modal-title">
    {include file='__svg_icons.tpl' icon="activities" class="main-icon mr10" width="24px" height="24px"}
    {__("Edit Activity")}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form class="js_ajax-forms" data-url="modules/activities.php?do=update">
  <div class="modal-body">
    <div class="form-table-row">
      <div>
        <div class="form-label h6 mb5">{__("Mark As Completed")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Enable this option to mark this activity as completed")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="is_completed">
          <input type="checkbox" name="is_completed" id="is_completed">
          <span class="slider round"></span>
        </label>
      </div>
    </div>
    <div class="divider"></div>
    <div class="form-group">
      <label class="form-label" for="title">{__("Activity")}</label>
      <input type="text" class="form-control" name="title" id="title" value="{$activity['title']}">
    </div>
    <div class="form-group">
      <label class="form-label" for="description">{__("About")}</label>
      <textarea class="form-control" name="description">{$activity['description']}</textarea>
    </div>
    <div class="form-group">
      <label class="form-label" for="category">{__("Category")}</label>
      <select class="form-select" name="category" id="category">
        <option>{__("Select Category")}</option>
        {foreach $categories as $category}
          {include file='__categories.recursive_options.tpl' data_category=$activity['category_id']}
        {/foreach}
      </select>
    </div>
    <div class="divider"></div>
    <div class="form-group">
      <label class="form-label" for="follow_date">{__("Follow Alert")}</label>
      <input type="datetime-local" class="form-control" name="follow_date" id="follow_date" value="{$activity['follow_date']}">
    </div>
    <div class="form-group">
      <label class="form-label" for="follow_date">{__("Follow Message")}</label>
      <textarea class="form-control" name="follow_message">{$activity['follow_message']}</textarea>
    </div>
    <!-- error -->
    <div class="alert alert-danger mb0 mt10 x-hidden"></div>
    <!-- error -->
  </div>
  <div class="modal-footer">
    <input type="hidden" name="activity_id" value="{$activity['activity_id']}">
    <button type="submit" class="btn btn-primary">{__("Edit")}</button>
  </div>
</form>