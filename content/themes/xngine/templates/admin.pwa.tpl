<div class="card">
  <div class="card-header with-icon">
    <i class="fa fa-window-restore mr10"></i>{__("Apps")} &rsaquo; {__("PWA (Progressive Web App)")}
  </div>

  <form class="js_ajax-forms" data-url="admin/settings.php?edit=pwa">
    <div class="card-body">
      <div class="form-table-row">
        <div class="avatar">
          {include file='__svg_icons.tpl' icon="pwa" class="main-icon" width="40px" height="40px"}
        </div>
        <div>
          <div class="form-label h6">{__("PWA Enabled")}</div>
          <div class="form-text d-none d-sm-block">{__("Enable or Disable the PWA - Progressive Web App")}</div>
        </div>
        <div class="text-end">
          <label class="switch" for="pwa_enabled">
            <input type="checkbox" name="pwa_enabled" id="pwa_enabled" {if $system['pwa_enabled']}checked{/if}>
            <span class="slider round"></span>
          </label>
        </div>
      </div>

      <div class="form-table-row">
        <div class="avatar">
          {include file='__svg_icons.tpl' icon="pwa-install" class="main-icon" width="40px" height="40px"}
        </div>
        <div>
          <div class="form-label h6">{__("PWA Install Banner")}</div>
          <div class="form-text d-none d-sm-block">{__("Show a banner to install the PWA")}</div>
        </div>
        <div class="text-end">
          <label class="switch" for="pwa_banner_enabled">
            <input type="checkbox" name="pwa_banner_enabled" id="pwa_banner_enabled" {if $system['pwa_banner_enabled']}checked{/if}>
            <span class="slider round"></span>
          </label>
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("PWA Icon 192x192")}
        </label>
        <div class="col-md-9">
          {if $system['pwa_192_icon'] == ''}
            <div class="x-image">
              <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
              <div class="x-image-loader">
                <div class="progress x-progress">
                  <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
              </div>
              <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
              <input type="hidden" class="js_x-image-input" name="pwa_192_icon" value="">
            </div>
          {else}
            <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$system['pwa_192_icon']}')">
              <button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'></button>
              <div class="x-image-loader">
                <div class="progress x-progress">
                  <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
              </div>
              <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
              <input type="hidden" class="js_x-image-input" name="pwa_192_icon" value="{$system['pwa_192_icon']}">
            </div>
          {/if}
          <div class="form-text">
            {__("The icon should be 192x192 pixels")}
          </div>
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("PWA Icon 512x512")}
        </label>
        <div class="col-md-9">
          {if $system['pwa_512_icon'] == ''}
            <div class="x-image">
              <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
              <div class="x-image-loader">
                <div class="progress x-progress">
                  <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
              </div>
              <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
              <input type="hidden" class="js_x-image-input" name="pwa_512_icon" value="">
            </div>
          {else}
            <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$system['pwa_512_icon']}')">
              <button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'></button>
              <div class="x-image-loader">
                <div class="progress x-progress">
                  <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
              </div>
              <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
              <input type="hidden" class="js_x-image-input" name="pwa_512_icon" value="{$system['pwa_512_icon']}">
            </div>
          {/if}
          <div class="form-text">
            {__("The icon should be 512x512 pixels")}
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
</div>