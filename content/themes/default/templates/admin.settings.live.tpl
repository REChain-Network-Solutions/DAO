<!-- card-header -->
<div class="card-header with-icon">
  <!-- panel title -->
  <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("Live Stream")}
  <!-- panel title -->
</div>
<!-- card-header -->

<!-- Live -->
<form class="js_ajax-forms" data-url="admin/settings.php?edit=live">
  <div class="card-body">
    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="live" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Live Stream Enabled")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn the live stream system On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="live_enabled">
          <input type="checkbox" name="live_enabled" id="live_enabled" {if $system['live_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Agora App ID")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="agora_app_id" value="{$system['agora_app_id']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Agora App Certificate")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="agora_app_certificate" value="{$system['agora_app_certificate']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="cloud_save" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Save Live Videos")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the save live stream videos On and Off")}<br>
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="save_live_enabled">
          <input type="checkbox" name="save_live_enabled" id="save_live_enabled" {if $system['save_live_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Agora Customer ID")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="agora_customer_id" value="{$system['agora_customer_id']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Agora Customer Secret")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="agora_customer_certificate" value="{$system['agora_customer_certificate']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {"S3"} {__("Bucket Name")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="agora_s3_bucket" value="{$system['agora_s3_bucket']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
        <div class="form-text">
          {__("Your Amazon S3 bucket name")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {"S3"} {__("Bucket Region")}
      </label>
      <div class="col-md-9">
        <select class="form-select" name="agora_s3_region">
          <option value="us-east-1" {if $system['agora_s3_region'] == "us-east-1"}selected{/if}>US East (N. Virginia) us-east-1</option>
          <option value="us-east-2" {if $system['agora_s3_region'] == "us-east-2"}selected{/if}>US East (Ohio) us-east-2</option>
          <option value="us-west-1" {if $system['agora_s3_region'] == "us-west-1"}selected{/if}>US West (N. California) us-west-1</option>
          <option value="us-west-2" {if $system['agora_s3_region'] == "us-west-2"}selected{/if}>US West (Oregon) us-west-2</option>
          <option value="eu-west-1" {if $system['agora_s3_region'] == "eu-west-1"}selected{/if}>EU (Ireland) eu-west-1</option>
          <option value="eu-west-2" {if $system['agora_s3_region'] == "eu-west-2"}selected{/if}>EU (London) eu-west-2</option>
          <option value="eu-west-3" {if $system['agora_s3_region'] == "eu-west-3"}selected{/if}>EU (Paris) eu-west-3</option>
          <option value="eu-central-1" {if $system['agora_s3_region'] == "eu-central-1"}selected{/if}>EU (Frankfurt) eu-central-1</option>
          <option value="ap-southeast-1" {if $system['agora_s3_region'] == "ap-southeast-1"}selected{/if}>Asia Pacific (Singapore) ap-southeast-1</option>
          <option value="ap-southeast-2" {if $system['agora_s3_region'] == "ap-southeast-2"}selected{/if}>Asia Pacific (Sydney) ap-southeast-2</option>
          <option value="ap-northeast-1" {if $system['agora_s3_region'] == "ap-northeast-1"}selected{/if}>Asia Pacific (Tokyo) ap-northeast-1</option>
          <option value="ap-northeast-2" {if $system['agora_s3_region'] == "ap-northeast-2"}selected{/if}>Asia Pacific (Seoul) ap-northeast-2</option>
          <option value="sa-east-1" {if $system['agora_s3_region'] == "sa-east-1"}selected{/if}>South America (São Paulo) sa-east-1</option>
          <option value="ca-central-1" {if $system['agora_s3_region'] == "ca-central-1"}selected{/if}>Canada (Central) ca-central-1</option>
          <option value="ap-south-1" {if $system['agora_s3_region'] == "ap-south-1"}selected{/if}>Asia Pacific (Mumbai) ap-south-1</option>
        </select>
        <div class="form-text">
          {__("Your Amazon S3 bucket region")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {"S3"} {__("Access Key ID")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="agora_s3_key" value="{$system['agora_s3_key']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
        <div class="form-text">
          {__("Your Amazon S3 Access Key ID")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {"S3"} {__("Access Key Secret")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="agora_s3_secret" value="{$system['agora_s3_secret']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
        <div class="form-text">
          {__("Your Amazon S3 Access Key Secret")}
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
    <button type="button" class="btn btn-danger js_admin-tester" data-handle="s3-agora">
      <i class="fa fa-bolt mr10"></i> {__("Test Connection")} ({__("S3")})
    </button>
    <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
  </div>
</form>
<!-- Live -->