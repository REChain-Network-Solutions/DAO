<div class="modal-header">
  <h6 class="modal-title">
    {include file='__svg_icons.tpl' icon="courses" class="main-icon mr10" width="24px" height="24px"}
    {__("Edit Course")}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form class="js_ajax-forms" data-url="posts/edit.php">
  <div class="modal-body">
    <div class="row">
      <!-- title -->
      <div class="form-group col-md-6">
        <label class="form-label">{__("Title")}</label>
        <input name="title" type="text" class="form-control" value="{$post['course']['title']}">
      </div>
      <!-- title -->
      <!-- location -->
      <div class="form-group col-md-6">
        <label class="form-label">{__("Location")}</label>
        <input name="location" type="text" class="form-control" value="{$post['course']['location']}">
      </div>
      <!-- location -->
    </div>
    <!-- course fees -->
    <div class="form-group">
      <label class="form-label">{__("Course Fees")}</label>
      <div>
        <div class="input-group">
          <input name="fees" type="text" class="form-control" placeholder="{__("Course Fees")}" value="{$post['course']['fees']}">
          <select class="form-select" name="fees_currency">
            {foreach $currencies as $currency}
              <option value="{$currency['currency_id']}" {if $post['course']['fees_currency']['currency_id'] == $currency['currency_id']}selected{/if}>{$currency['symbol']} ({$currency['code']})</option>
            {/foreach}
          </select>
        </div>
      </div>
    </div>
    <!-- course fees -->
    <!-- start/end date -->
    <div class="row">
      <div class="form-group col-md-6">
        <label class="form-label">{__("Start Date")}</label>
        <input type="datetime-local" class="form-control" name="start_date" value="{$post['course']['start_date']}">
      </div>
      <div class="form-group col-md-6">
        <label class="form-label">{__("End Date")}</label>
        <input type="datetime-local" class="form-control" name="end_date" value="{$post['course']['end_date']}">
      </div>
    </div>
    <!-- start/end date -->
    <!-- category -->
    <div class="form-group">
      <label class="form-label">{__("Category")}</label>
      <select class="form-select" name="category">
        {foreach $courses_categories as $category}
          {include file='__categories.recursive_options.tpl' data_category=$post['course']['category_id']}
        {/foreach}
      </select>
    </div>
    <!-- category -->
    <!-- description -->
    <div class="form-group">
      <label class="form-label">{__("Description")}</label>
      <textarea name="description" rows="5" dir="auto" class="form-control">{$post['text_plain']}</textarea>
      <div class="form-text">
        {__("Describe the responsibilities and preferred skills for this course")}
      </div>
    </div>
    <!-- description -->
    <!-- custom fields -->
    {if $custom_fields['basic']}
      {include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
    {/if}
    <!-- custom fields -->
    <!-- cover image -->
    <div class="form-group">
      <label class="form-label">{__("Cover Image")}</label>
      <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$post['course']['cover_image']}')">
        <div class="x-image-loader">
          <div class="progress x-progress">
            <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
          </div>
        </div>
        <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
        <input type="hidden" class="js_x-image-input" name="cover_image" value="{$post['course']['cover_image']}">
      </div>
    </div>
    <!-- cover image -->
    <!-- error -->
    <div class="alert alert-danger mt15 mb0 x-hidden"></div>
    <!-- error -->
  </div>
  <div class="modal-footer">
    <input type="hidden" name="handle" value="course">
    <input type="hidden" name="id" value="{$post['post_id']}">
    <button type="submit" class="btn btn-primary">{__("Save")}</button>
  </div>
</form>