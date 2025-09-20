<div class="modal-header">
  <h6 class="modal-title">
    {include file='__svg_icons.tpl' icon="merits" class="main-icon mr10" width="24px" height="24px"}
    {__("Send Merit")}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form class="js_ajax-forms" data-url="users/merits.php?do=send">
  <div class="modal-body">
    <div class="form-group">
      <label class="form-label" for="title">{__("Merits Balance")}</label>
      <div class="form-text">
        {__("You have")} <span class="badge text-primary bg-light">{$user->_data['merits_balance']['remining']}</span> {__("merits left")}
      </div>
    </div>
    <div class="form-group">
      <label class="form-label" for="title">{__("Recepients")}</label>
      <input type="text" class="js_tagify-ajax x-hidden" data-handle="users" name="recepients" />
      <div class="form-text">
        {__("Select the users to whom you want to send the merit")}
      </div>
    </div>
    <div class="form-group">
      <label class="form-label" for="category">{__("Category")}</label>
      <select class="form-select" name="category" id="category">
        <option>{__("Select Category")}</option>
        {foreach $merits_categories as $category}
          {include file='__categories.recursive_options.tpl' data_category=$category_id}
        {/foreach}
      </select>
      <div class="form-text text-muted">
        {__("Select the category in which they will be recognized")}
      </div>
    </div>
    <div class="form-group">
      <label class="form-label" for="message">{__("Message")}</label>
      <textarea class="form-control" name="message"></textarea>
    </div>
    <div class="form-group">
      <label class="form-label">{__("Image")}</label>
      <div class="x-image">
        <div class="x-image-loader">
          <div class="progress x-progress">
            <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
          </div>
        </div>
        <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
        <input type="hidden" class="js_x-image-input" name="image" value="">
      </div>
    </div>
    <!-- error -->
    <div class="alert alert-danger mb0 mt10 x-hidden"></div>
    <!-- error -->
  </div>
  <div class="modal-footer">
    <button type="submit" class="btn btn-primary">{__("Send Merit")}</button>
  </div>
</form>