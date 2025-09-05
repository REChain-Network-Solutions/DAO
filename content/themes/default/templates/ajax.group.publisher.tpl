<div class="modal-header">
  <h6 class="modal-title">
    {include file='__svg_icons.tpl' icon="groups" class="main-icon mr10" width="24px" height="24px"}
    {__("Create New Group")}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form class="js_ajax-forms" data-url="modules/create.php?type=group&do=create">
  <div class="modal-body">
    <!-- name -->
    <div class="form-group">
      <label class="form-label" for="title">{__("Name Your Group")}</label>
      <input type="text" class="form-control" name="title" id="title">
    </div>
    <!-- name -->
    <!-- username -->
    <div class="form-group">
      <label class="form-label" for="username">{__("Group Username")}</label>
      <div class="input-group">
        <span class="input-group-text d-none d-sm-block">{$system['system_url']}/groups/</span>
        <input type="text" class="form-control" name="username" id="username">
      </div>
      <div class="form-text">
        {__("Can only contain alphanumeric characters (A–Z, 0–9) and periods ('.')")}
      </div>
    </div>
    <!-- username -->
    <!-- privacy -->
    <div class="form-group">
      <label class="form-label" for="privacy">{__("Select Privacy")}</label>
      <select class="form-select" name="privacy">
        <option value="public">{__("Public Group")}</option>
        <option value="closed">{__("Closed Group")}</option>
        <option value="secret">{__("Secret Group")}</option>
      </select>
    </div>
    <!-- privacy -->
    <!-- category -->
    <div class="form-group">
      <label class="form-label" for="category">{__("Category")}</label>
      <select class="form-select" name="category" id="category">
        <option>{__("Select Category")}</option>
        {foreach $categories as $category}
          {include file='__categories.recursive_options.tpl'}
        {/foreach}
      </select>
    </div>
    <!-- category -->
    <!-- country -->
    <div class="form-group">
      <label class="form-label" for="country">{__("Country")}</label>
      <select class="form-select" name="country">
        <option value="none">{__("Select Country")}</option>
        {foreach $countries as $country}
          <option value="{$country['country_id']}">{$country['country_name']}</option>
        {/foreach}
      </select>
    </div>
    <!-- country -->
    <!-- language -->
    <div class="form-group">
      <label class="form-label" for="language">{__("Language")}</label>
      <select class="form-select" name="language">
        <option value="none">{__("Select Language")}</option>
        {foreach $languages as $language}
          <option value="{$language['language_id']}">{$language['title']}</option>
        {/foreach}
      </select>
    </div>
    <!-- language -->
    <!-- description -->
    <div class="form-group">
      <label class="form-label" for="description">{__("About")}</label>
      <textarea class="form-control" name="description"></textarea>
    </div>
    <!-- custom fields -->
    {if $custom_fields}
      {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true}
    {/if}
    <!-- custom fields -->
    <!-- post -->
    <div class="form-table-row">
      <div>
        <div class="form-label h6 mb5">{__("Create Post")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Create a post after creating the group")}<br>
          <small class="text-muted">{__("Post will be public and only works with public/closed  ")}</small>
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="create_post">
          <input type="checkbox" name="create_post" id="create_post">
          <span class="slider round"></span>
        </label>
      </div>
    </div>
    <!-- post -->
    <!-- error -->
    <div class="alert alert-danger mb0 mt10 x-hidden"></div>
    <!-- error -->
  </div>
  <div class="modal-footer">
    <button type="submit" class="btn btn-primary">{__("Create")}</button>
  </div>
</form>