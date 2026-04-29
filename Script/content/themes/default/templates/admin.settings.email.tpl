<!-- card-header -->
<div class="card-header with-icon">
  <!-- panel title -->
  <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("Email")}
  <!-- panel title -->
</div>
<!-- card-header -->

<form class="js_ajax-forms" data-url="admin/settings.php?edit=email">
  <div class="card-body">
    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="email" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("SMTP")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Enable/Disable SMTP email system")}<br />
          {__("PHP mail() function will be used in case of disabled")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="email_smtp_enabled">
          <input type="checkbox" name="email_smtp_enabled" id="email_smtp_enabled" {if $system['email_smtp_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="authentication" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("SMTP Require Authentication")}</div>
        <div class="form-text d-none d-sm-block">{__("Enable/Disable SMTP authentication")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="email_smtp_authentication">
          <input type="checkbox" name="email_smtp_authentication" id="email_smtp_authentication" {if $system['email_smtp_authentication']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="ssl" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("SMTP SSL Encryption")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Enable/Disable SMTP SSL encryption")}<br />
          {__("TLS encryption will be used in case of disabled")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="email_smtp_ssl">
          <input type="checkbox" name="email_smtp_ssl" id="email_smtp_ssl" {if $system['email_smtp_ssl']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("SMTP Server")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="email_smtp_server" value="{$system['email_smtp_server']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("SMTP Port")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="email_smtp_port" value="{$system['email_smtp_port']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("SMTP Username")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="email_smtp_username" value="{$system['email_smtp_username']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("SMTP Password")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="email_smtp_password" value="{$system['email_smtp_password']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Set From")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="email_smtp_setfrom" value="{$system['email_smtp_setfrom']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
        <div class="form-text">
          {__("Set the From email address")}, {__("For example: email@domain.com")}
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
    <button type="button" class="btn btn-danger js_admin-tester" data-handle="smtp">
      <i class="fa fa-bolt mr10"></i>{__("Test Connection")}
    </button>
    <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
  </div>
</form>