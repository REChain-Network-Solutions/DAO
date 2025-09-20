<div class="modal-header">
  <h6 class="modal-title">
    {include file='__svg_icons.tpl' icon="courses" class="main-icon mr10" width="24px" height="24px"}
    {__("Course Enrollment")}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form class="js_ajax-forms" data-url="posts/course.php?do=apply&post_id={$post['post_id']}">
  <div class="modal-body">
    <div class="text-xlg mb10">{__("Your Information")}</div>
    <div class="row">
      <!-- name -->
      <div class="form-group col-md-6">
        <label class="form-label">{__("Name")}</label>
        <input name="name" type="text" class="form-control" value="{$user->_data['user_fullname']}">
      </div>
      <!-- name -->
      <!-- location -->
      <div class="form-group col-md-6">
        <label class="form-label">{__("Location")}</label>
        <input name="location" type="text" class="form-control">
      </div>
      <!-- location -->
    </div>
    <div class="row">
      <!-- phone -->
      <div class="form-group col-md-6">
        <label class="form-label">{__("Phone")}</label>
        <input name="phone" type="text" class="form-control" value="{$user->_data['user_phone']}">
      </div>
      <!-- phone -->
      <!-- email -->
      <div class="form-group col-md-6">
        <label class="form-label">{__("Email")}</label>
        <input name="email" type="text" class="form-control" value="{$user->_data['user_email']}">
      </div>
      <!-- email -->
    </div>
    <!-- error -->
    <div class="alert alert-danger mt15 mb0 x-hidden"></div>
    <!-- error -->
  </div>
  <div class="modal-footer">
    <button type="submit" class="btn btn-primary">{__("Apply")}</button>
  </div>
</form>