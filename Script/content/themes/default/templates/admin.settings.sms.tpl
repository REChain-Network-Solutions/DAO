<!-- card-header -->
<div class="card-header with-icon">
  <!-- panel title -->
  <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("SMS")}
  <!-- panel title -->
</div>
<!-- card-header -->

<!-- SMS -->
<form class="js_ajax-forms" data-url="admin/settings.php?edit=sms">
  <div class="card-body">

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("SMS Provider")}
      </label>
      <div class="col-md-9">
        <div>
          <!-- Twilio -->
          <input class="x-hidden input-label" type="radio" name="sms_provider" value="twilio" id="sms_twilio" {if $system['sms_provider'] == "twilio"}checked{/if} />
          <label class="button-label" for="sms_twilio">
            <div class="icon">
              {include file='__svg_icons.tpl' icon="twilio" width="32px" height="32px"}
            </div>
            <div class="title">{__("Twilio")}</div>
          </label>
          <!-- Twilio -->
          <!-- BulkSMS -->
          <input class="x-hidden input-label" type="radio" name="sms_provider" value="bulksms" id="sms_bulksms" {if $system['sms_provider'] == "bulksms"}checked{/if} />
          <label class="button-label" for="sms_bulksms">
            <div class="icon">
              {include file='__svg_icons.tpl' icon="bulksms" width="52px" height="32px"}
            </div>
            <div class="title">{__("BulkSMS")}</div>
          </label>
          <!-- BulkSMS -->
          <!-- Infobip -->
          <input class="x-hidden input-label" type="radio" name="sms_provider" value="infobip" id="sms_infobip" {if $system['sms_provider'] == "infobip"}checked{/if} />
          <label class="button-label" for="sms_infobip">
            <div class="icon">
              {include file='__svg_icons.tpl' icon="infobip" width="52px" height="32px"}
            </div>
            <div class="title">{__("Infobip")}</div>
          </label>
          <!-- Infobip -->
          <!-- Msg91 -->
          <input class="x-hidden input-label" type="radio" name="sms_provider" value="msg91" id="sms_msg91" {if $system['sms_provider'] == "msg91"}checked{/if} />
          <label class="button-label" for="sms_msg91">
            <div class="icon">
              {include file='__svg_icons.tpl' icon="msg91" width="52px" height="32px"}
            </div>
            <div class="title">{__("Msg91")}</div>
          </label>
          <!-- Msg91 -->
        </div>

        <div class="form-text">
          {__("Select your default SMS provider")}<br />
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("SMS Limit")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="sms_limit" value="{$system['sms_limit']}">
        <div class="form-text">
          {__("Set the maximum number of SMS messages that can be sent per hour")}
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <!-- Twilio -->
    <div class="heading-small mb20">
      {__("Twilio")}
    </div>
    <div class="pl-md-4">
      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("Twilio Account SID")}
        </label>
        <div class="col-md-9">
          {if !$user->_data['user_demo']}
            <input type="text" class="form-control" name="twilio_sid" value="{$system['twilio_sid']}">
          {else}
            <input type="password" class="form-control" value="*********">
          {/if}
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("Twilio Auth Token")}
        </label>
        <div class="col-md-9">
          {if !$user->_data['user_demo']}
            <input type="text" class="form-control" name="twilio_token" value="{$system['twilio_token']}">
          {else}
            <input type="password" class="form-control" value="*********">
          {/if}
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("Twilio Phone Number")}
        </label>
        <div class="col-md-9">
          {if !$user->_data['user_demo']}
            <input type="text" class="form-control" name="twilio_phone" value="{$system['twilio_phone']}">
          {else}
            <input type="password" class="form-control" value="*********">
          {/if}
        </div>
      </div>
    </div>
    <!-- Twilio -->

    <div class="divider"></div>

    <!-- BulkSMS -->
    <div class="heading-small mb20">
      {__("BulkSMS")}
    </div>
    <div class="pl-md-4">
      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("BulkSMS Username")}
        </label>
        <div class="col-md-9">
          {if !$user->_data['user_demo']}
            <input type="text" class="form-control" name="bulksms_username" value="{$system['bulksms_username']}">
          {else}
            <input type="password" class="form-control" value="*********">
          {/if}
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("BulkSMS Password")}
        </label>
        <div class="col-md-9">
          {if !$user->_data['user_demo']}
            <input type="text" class="form-control" name="bulksms_password" value="{$system['bulksms_password']}">
          {else}
            <input type="password" class="form-control" value="*********">
          {/if}
        </div>
      </div>
    </div>
    <!-- BulkSMS -->

    <div class="divider"></div>

    <!-- Infobip -->
    <div class="heading-small mb20">
      {__("Infobip")}
    </div>
    <div class="pl-md-4">
      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("Infobip Username")}
        </label>
        <div class="col-md-9">
          {if !$user->_data['user_demo']}
            <input type="text" class="form-control" name="infobip_username" value="{$system['infobip_username']}">
          {else}
            <input type="password" class="form-control" value="*********">
          {/if}
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("Infobip Password")}
        </label>
        <div class="col-md-9">
          {if !$user->_data['user_demo']}
            <input type="text" class="form-control" name="infobip_password" value="{$system['infobip_password']}">
          {else}
            <input type="password" class="form-control" value="*********">
          {/if}
        </div>
      </div>
    </div>
    <!-- Infobip -->

    <div class="divider"></div>

    <!-- Msg91 -->
    <div class="heading-small mb20">
      {__("Msg91")}
    </div>
    <div class="pl-md-4">
      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("Msg91 AuthKey")}
        </label>
        <div class="col-md-9">
          {if !$user->_data['user_demo']}
            <input type="text" class="form-control" name="msg91_authkey" value="{$system['msg91_authkey']}">
          {else}
            <input type="password" class="form-control" value="*********">
          {/if}
        </div>
      </div>
      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("Msg91 Template ID")}
        </label>
        <div class="col-md-9">
          <input type="text" class="form-control" name="msg91_template_id" value="{$system['msg91_template_id']}">
        </div>
      </div>
    </div>
    <!-- Msg91 -->

    <div class="divider"></div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Test Phone Number")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="system_phone" value="{$system['system_phone']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
        <div class="form-text">
          {__("Your phone number to test the SMS service i.e +12344567890")}<br />
          {__("A test SMS will be sent to this phone number when you test the connection")}
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
    <button type="button" class="btn btn-danger js_admin-tester" data-handle="sms">
      <i class="fa fa-bolt mr10"></i>{__("Test Connection")}
    </button>
    <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
  </div>
</form>
<!-- SMS -->