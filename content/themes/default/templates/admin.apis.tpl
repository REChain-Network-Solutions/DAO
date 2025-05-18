<div class="card">
  <div class="card-header with-icon">
    <i class="fa-solid fa-shapes mr10"></i>{__("Apps")} &rsaquo; {__("APIs Settings")}
  </div>

  <form class="js_ajax-forms" data-url="admin/settings.php?edit=apis">
    <div class="card-body">

      <div class="alert alert-warning">
        <div class="icon">
          <i class="fa fa-exclamation-circle fa-2x"></i>
        </div>
        <div class="text">
          <strong>{__("API Key and Secret")}</strong><br>
          {__("Reset the API Key will affect the APIs that are used in the your native apps")}
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("API Key")}
        </label>
        <div class="col-md-9">
          {if !$user->_data['user_demo']}
            <input type="text" class="form-control" name="system_api_key" value="{$system['system_api_key']}">
          {else}
            <input type="password" class="form-control" value="*********">
          {/if}
          <div class="form-text">
            {__("The API Key that is used in the your native apps")}
          </div>
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("API Secret")}
        </label>
        <div class="col-md-9">
          {if !$user->_data['user_demo']}
            <input type="text" class="form-control" name="system_api_secret" value="{$system['system_api_secret']}">
          {else}
            <input type="password" class="form-control" value="*********">
          {/if}
          <div class="form-text">
            {__("The API Secret that is used in the your native apps")}
          </div>
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
        </label>
        <div class="col-md-9">
          <button type="button" class="btn btn-danger js_admin-api-reset">{__("Reset API Key")}</button>
        </div>
      </div>

      <div class="divider"></div>

      <!-- JWT KEY -->
      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("JWT Key")}
        </label>
        <div class="col-md-9">
          {if !$user->_data['user_demo']}
            <input type="text" class="form-control" name="system_jwt_key" value="{$system['system_jwt_key']}">
          {else}
            <input type="password" class="form-control" value="*********">
          {/if}
          <div class="form-text">
            {__("The JSON Web Token Key that is used to generate the token for users sessions")}<br>
            {__("Note: Resetting the JWT Key will log the users out from all sessions")}
          </div>
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
        </label>
        <div class="col-md-9">
          <button type="button" class="btn btn-danger js_admin-jwt-reset">{__("Reset JWT Key")}</button>
        </div>
      </div>
      <!-- JWT KEY -->

      <!-- success -->
      <div class="alert alert-success mt15 mb0 x-hidden"></div>
      <!-- success -->

      <!-- error -->
      <div class="alert alert-danger mt15 mb0 x-hidden"></div>
      <!-- error -->
    </div>
    <div class="card-footer text-end">
      <button type="button" class="btn btn-success js_admin-tester" data-handle="api">
        <i class="fa fa-bolt mr10"></i> {__("Ping API")}
      </button>
      <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
    </div>
  </form>
</div>