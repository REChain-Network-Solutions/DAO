<!-- card-header -->
<div class="card-header with-icon">
  <!-- panel title -->
  <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("Analytics")}
  <!-- panel title -->
</div>
<!-- card-header -->

<!-- Analytics -->
<form class="js_ajax-forms" data-url="admin/settings.php?edit=analytics">
  <div class="card-body">
    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Tracking Code")}
      </label>
      <div class="col-md-9">
        <textarea class="form-control" name="message" rows="3">{$system['analytics_code']}</textarea>
        <div class="form-text">
          {__("The analytics tracking code (Ex: Google Analytics)")}
        </div>
      </div>
    </div>

    <!-- success -->
    <div class="alert alert-success mt15 mb0 x-hidden"></div>
    <!-- success -->

    <!-- error -->
    <div class="alert alert-danger mt15 mb0 x-hidden"></div>
    <!-- error -->
  </div>
  <div class="card-footer text-end">
    <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
  </div>
</form>
<!-- Analytics -->