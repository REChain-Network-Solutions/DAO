<div class="modal-header">
  <h6 class="modal-title">
    {include file='__svg_icons.tpl' icon="products" class="main-icon mr10" width="24px" height="24px"}
    {__("Create New Product")}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form class="publisher-mini">
  <div class="modal-body">
    <div class="form-table-row">
      <div>
        <div class="form-label h6 mb5">{__("Digital Product")}</div>
        <div class="form-text d-none d-sm-block">{__("Enable this option if you are selling a digital product")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="is_digital">
          <input type="checkbox" name="is_digital" id="is_digital" class="js_publisher-digital">
          <span class="slider round"></span>
        </label>
      </div>
    </div>
    <div id="digital_product" class="x-hidden">
      <div class="form-group">
        <label class="form-label">{__("Download URL")}</label>
        <input name="product_url" type="text" class="form-control">
      </div>
      <div class="form-group">
        <label class="form-label">{__("OR Upload your File")}</label>
        <div class="x-image">
          <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
          <div class="x-image-loader">
            <div class="progress x-progress">
              <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
            </div>
          </div>
          <i class="fa fa-paperclip fa-lg js_x-uploader" data-handle="x-file" data-type="file"></i>
          <input type="hidden" class="js_x-image-input" name="product_file" value="">
        </div>
        <div class="form-text">
          {__("Allowed file types")}: {$system['file_extensions']}
        </div>
      </div>
    </div>
    <div class="divider dashed"></div>
    <div class="form-group">
      <label class="form-label">{__("Product Name")}</label>
      <input name="name" type="text" class="form-control">
    </div>
    <div class="row">
      <div class="form-group col-md-8">
        <label class="form-label">{__("Total Item Units")}</label>
        <input name="quantity" type="number" min="1" max="500" class="form-control">
      </div>
      <div class="form-group col-md-4">
        <label class="form-label">{__("Price")} ({$system['system_currency']})</label>
        <input name="price" type="text" class="form-control">
      </div>
    </div>
    <div class="row">
      <div class="form-group col-md-8">
        <label class="form-label">{__("Category")}</label>
        <select class="form-select" name="category">
          {foreach $market_categories as $category}
            {include file='__categories.recursive_options.tpl'}
          {/foreach}
        </select>
      </div>
      <div class="form-group col-md-4">
        <label class="form-label">{__("Status")}</label>
        <select class="form-select" name="status">
          <option value="new">{__("New")}</option>
          <option value="old">{__("Used")}</option>
        </select>
      </div>
    </div>
    <div class="form-group">
      <label class="form-label">{__("Location")}</label>
      <input name="location" type="text" class="form-control js_geocomplete">
    </div>
    <div class="form-group">
      <label class="form-label">{__("Description")}</label>
      <textarea name="message" rows="5" dir="auto" class="form-control"></textarea>
    </div>
    <!-- custom fields -->
    {if $custom_fields}
      {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true}
    {/if}
    <!-- custom fields -->
    <div class="form-group">
      <label class="form-label">{__("Photos")}</label>
      <div class="attachments clearfix" data-type="photos">
        <ul>
          <li class="add">
            <i class="fa fa-camera js_x-uploader" data-handle="publisher-mini" data-multiple="true"></i>
          </li>
        </ul>
      </div>
    </div>
    <!-- error -->
    <div class="alert alert-danger mt15 mb0 x-hidden"></div>
    <!-- error -->
  </div>
  <div class="modal-footer">
    {if $share_to == "page"}
      <input type="hidden" name="handle" value="page">
      <input type="hidden" name="id" value="{$share_to_id}">
    {elseif $share_to == "group"}
      <input type="hidden" name="handle" value="group">
      <input type="hidden" name="id" value="{$share_to_id}">
    {elseif $share_to == "event"}
      <input type="hidden" name="handle" value="event">
      <input type="hidden" name="id" value="{$share_to_id}">
    {/if}
    <button type="button" class="btn btn-primary js_publisher-btn js_publisher-product">{__("Publish")}</button>
  </div>
</form>

<script>
  /* digital product */
  $('#is_digital').on('change', function() {
    if ($(this).prop('checked')) {
      $('#digital_product').fadeIn();
    } else {
      $('#digital_product').hide();
    }
  });
</script>