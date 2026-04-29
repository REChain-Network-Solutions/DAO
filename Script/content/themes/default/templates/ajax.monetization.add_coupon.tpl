<div class="modal-header">
  <h6 class="modal-title">
    {include file='__svg_icons.tpl' icon="offers" class="main-icon mr10" width="24px" height="24px"}
    {__("New Coupon")}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form class="js_ajax-forms" data-url="monetization/controller.php?do=insert_coupon">
  <div class="modal-body">
    <!-- is onetime -->
    <div class="form-table-row">
      <div>
        <div class="form-label h6">{__("Is one time coupon")}</div>
        <div class="form-text d-none d-sm-block">{__("If enabled, the coupon will be used only once")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="is_onetime">
          <input type="checkbox" name="is_onetime" id="is_onetime">
          <span class="slider round"></span>
        </label>
      </div>
    </div>
    <!-- is onetime -->
    <!-- discount percent -->
    <div class="form-group">
      <label class="form-label">{__("Discount Percent")}</label>
      <input name="discount_percent" type="number" min="1" max="99" class="form-control">
      <div class="form-text">
        {__("How much discount you want to apply for this coupon (min 1, max 99)")}
      </div>
    </div>
    <!-- discount percent -->
    <!-- error -->
    <div class="alert alert-danger mt15 mb0 x-hidden"></div>
    <!-- error -->
  </div>
  <div class="modal-footer">
    <input type="hidden" name="node_id" value="{$node_id}">
    <input type="hidden" name="node_type" value="{$node_type}">
    <button type="submit" class="btn btn-primary">{__("Generate")}</button>
  </div>
</form>