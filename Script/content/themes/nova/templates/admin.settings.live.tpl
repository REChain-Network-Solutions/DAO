<section class="admin-settings-page" aria-labelledby="settings-live-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-live-title" class="text-2xl font-semibold">{__("Live Stream Settings")}</h1>
    <p class="text-base-content/60 text-sm">{__("Live streaming providers, cloud recording, and moderation.")}</p>
  </div>
  <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Live Stream Settings")}" aria-orientation="vertical">
    <button type="button" id="settings-live-tab-0" class="tab active-tab:tab-active active" data-tab="#General" aria-controls="General" role="tab" aria-selected="true"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("General")}</button>
    <button type="button" id="settings-live-tab-1" class="tab active-tab:tab-active" data-tab="#CloudRecording" aria-controls="CloudRecording" role="tab" aria-selected="false"><span class="icon-[tabler--cloud-upload] size-4" aria-hidden="true"></span>{__("Cloud Recording")}</button>
    <button type="button" id="settings-live-tab-2" class="tab active-tab:tab-active" data-tab="#Moderation" aria-controls="Moderation" role="tab" aria-selected="false"><span class="icon-[tabler--shield] size-4" aria-hidden="true"></span>{__("Moderation")}</button>
  </nav>
  <div class="admin-settings-panel js_admin-settings-panel" id="General" role="tabpanel" tabindex="0">
  <form class="js_ajax-forms" data-url="admin/settings.php?edit=live">
    <div class="admin-settings-layout block">
      <div class="admin-settings-form flex min-w-0 flex-col gap-4">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="live" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <div class="flex items-center gap-1">
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="live_enabled">{__("Live Stream Enabled")}</label>
                  {capture assign="_tip"}{__("You can manage live stream categories from")} <a class="link link-primary" href="{$system['system_url']}/{$control_panel['url']}/posts/live_categories">{__("Live Categories")}</a>{/capture}
                  {include file='__admin_tip.tpl' _tip_id="live-categories-tip" _tip_text=$_tip}
                </div>
                <div class="admin-setting-help text-sm leading-relaxed" id="live_enabled-help">{__("Turn the live stream system On and Off")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="live_enabled" id="live_enabled" {if $system['live_enabled']}checked{/if} aria-describedby="live_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="live_provider-label">
              <div class="label-text" id="live_provider-label">{__("Live Stream Provider")}</div>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <div class="admin-settings-provider-group flex flex-wrap items-stretch gap-3">
                  <label class="admin-settings-provider-card">
                    <span class="admin-settings-provider-logo">
                      {include file='__svg_icons.tpl' icon="agora" width="32px" height="32px"}
                    </span>
                    <span class="label-text">{__("Agora")}</span>
                    <input type="radio" name="live_provider" value="agora" id="live_agora" class="radio radio-primary" {if $system['live_provider'] != "livekit"}checked{/if} aria-describedby="live_provider-help">
                  </label>
                  <label class="admin-settings-provider-card">
                    <span class="admin-settings-provider-logo">
                      {include file='__svg_icons.tpl' icon="livekit" width="52px" height="32px"}
                    </span>
                    <span class="label-text">{__("LiveKit")}</span>
                    <input type="radio" name="live_provider" value="livekit" id="live_livekit" class="radio radio-primary" {if $system['live_provider'] == "livekit"}checked{/if} aria-describedby="live_provider-help">
                  </label>
                </div>
                <div class="admin-setting-help text-sm leading-relaxed" id="live_provider-help">{__("Select your default live stream provider")}</div>
              </div>
            </div>
          </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Agora")}</h3>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="agora_app_id">{__("Agora App ID")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="agora_app_id" id="agora_app_id" value="{$system['agora_app_id']}">
                {else}
                  <input type="password" class="input w-full" id="agora_app_id" value="*********">
                {/if}
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="agora_app_certificate">{__("Agora App Certificate")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="agora_app_certificate" id="agora_app_certificate" value="{$system['agora_app_certificate']}">
                {else}
                  <input type="password" class="input w-full" id="agora_app_certificate" value="*********">
                {/if}
              </div>
            </div>
            <div class="divider divider-dashed"></div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <div class="flex items-center gap-1">
                <label class="label-text" for="agora_customer_id">{__("Agora Customer ID")}</label>
                {capture assign="_tip"}{__("Agora Customer ID & Secret are only required to save live videos with Agora Cloud Recording, you can get them from Agora Console > RESTful API")}.{/capture}
                {include file='__admin_tip.tpl' _tip_id="agora-customer-tip" _tip_text=$_tip}
              </div>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="agora_customer_id" id="agora_customer_id" value="{$system['agora_customer_id']}">
                {else}
                  <input type="password" class="input w-full" id="agora_customer_id" value="*********">
                {/if}
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="agora_customer_certificate">{__("Agora Customer Secret")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="agora_customer_certificate" id="agora_customer_certificate" value="{$system['agora_customer_certificate']}">
                {else}
                  <input type="password" class="input w-full" id="agora_customer_certificate" value="*********">
                {/if}
              </div>
            </div>
          </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("LiveKit")}</h3>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="livekit_live_api_key">{__("LiveKit API Key")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="livekit_live_api_key" id="livekit_live_api_key" value="{$system['livekit_live_api_key']}">
                {else}
                  <input type="password" class="input w-full" id="livekit_live_api_key" value="*********">
                {/if}
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="livekit_live_api_secret">{__("LiveKit API Secret")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="livekit_live_api_secret" id="livekit_live_api_secret" value="{$system['livekit_live_api_secret']}">
                {else}
                  <input type="password" class="input w-full" id="livekit_live_api_secret" value="*********">
                {/if}
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="livekit_live_ws_url">{__("LiveKit WebSocket URL")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="livekit_live_ws_url" id="livekit_live_ws_url" value="{$system['livekit_live_ws_url']}" placeholder="wss://your-project.livekit.cloud" aria-describedby="livekit_live_ws_url-help">
                {else}
                  <input type="password" class="input w-full" id="livekit_live_ws_url" value="*********">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="livekit_live_ws_url-help">{__("Saving live videos requires LiveKit Cloud or a self-hosted LiveKit Egress service")}</div>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                <span class="icon-[tabler--device-desktop-up] size-6" aria-hidden="true"></span>
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="live_rtmp_enabled">{__("OBS / RTMP Streaming")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="live_rtmp_enabled-help">{__("Allow users to go live from OBS or any streaming software, requires LiveKit Cloud or a self-hosted LiveKit Ingress service")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="live_rtmp_enabled" id="live_rtmp_enabled" {if $system['live_rtmp_enabled']}checked{/if} aria-describedby="live_rtmp_enabled-help">
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </section>
      </div>
    </div>
  </form>
  </div>
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="CloudRecording" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=live_recording">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="cloud_save" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="save_live_enabled">{__("Save Live Videos")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="save_live_enabled-help">{__("Turn the save live stream videos On and Off")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="save_live_enabled" id="save_live_enabled" {if $system['save_live_enabled']}checked{/if} aria-describedby="save_live_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="agora_s3_bucket">{"S3"} {__("Bucket Name")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="agora_s3_bucket" id="agora_s3_bucket" value="{$system['agora_s3_bucket']}" aria-describedby="agora_s3_bucket-help">
                {else}
                  <input type="password" class="input w-full" id="agora_s3_bucket" value="*********">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="agora_s3_bucket-help">{__("Your S3 bucket name")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="agora_s3_region">{"S3"} {__("Bucket Region")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="agora_s3_region" id="agora_s3_region" aria-describedby="agora_s3_region-help">
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
                <div class="admin-setting-help text-sm leading-relaxed" id="agora_s3_region-help">{__("Your S3 bucket region")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="agora_s3_key">{"S3"} {__("Access Key ID")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="agora_s3_key" id="agora_s3_key" value="{$system['agora_s3_key']}" aria-describedby="agora_s3_key-help">
                {else}
                  <input type="password" class="input w-full" id="agora_s3_key" value="*********">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="agora_s3_key-help">{__("Your S3 Access Key ID")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="agora_s3_secret">{"S3"} {__("Access Key Secret")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="agora_s3_secret" id="agora_s3_secret" value="{$system['agora_s3_secret']}" aria-describedby="agora_s3_secret-help">
                {else}
                  <input type="password" class="input w-full" id="agora_s3_secret" value="*********">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="agora_s3_secret-help">{__("Your S3 Access Key Secret")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="agora_s3_endpoint">{"S3"} {__("Endpoint")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="agora_s3_endpoint" id="agora_s3_endpoint" value="{$system['agora_s3_endpoint']}" placeholder="https://" aria-describedby="agora_s3_endpoint-help">
                {else}
                  <input type="password" class="input w-full" id="agora_s3_endpoint" value="*********">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="agora_s3_endpoint-help">{__("For S3-compatible storage like Cloudflare R2, Wasabi, DigitalOcean Spaces or Backblaze B2. Leave it empty for Amazon S3")}</div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="agora_s3_public_url">{__("Public URL")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="agora_s3_public_url" id="agora_s3_public_url" value="{$system['agora_s3_public_url']}" placeholder="https://" aria-describedby="agora_s3_public_url-help">
                {else}
                  <input type="password" class="input w-full" id="agora_s3_public_url" value="*********">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="agora_s3_public_url-help">{__("Public URL used to play the saved live videos. Leave it empty to use the bucket URL")}</div>
              </div>
            </div>
          </div>
            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
              <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
              </div>
              <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                <button type="button" class="btn btn-outline js_admin-tester" data-handle="s3-agora">
                  <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span>{__("Test Connection")} ({__("S3")})
                  </button>
                <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
              </div>
            </div>
          </section>
        </div>
      </div>
    </form>
  </div>
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="Moderation" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=live_moderation">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                <span class="icon-[tabler--shield] size-6" aria-hidden="true"></span>
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="live_moderation_enabled">{__("Live Moderation")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="live_moderation_enabled-help">{__("Allow hosts to appoint moderators, timeout, mute, kick and ban viewers, and set slow mode, blocked words and chat rules")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="live_moderation_enabled" id="live_moderation_enabled" {if $system['live_moderation_enabled']}checked{/if} aria-describedby="live_moderation_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="live_chat_rules">{__("Default Chat Rules")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea class="textarea w-full" name="live_chat_rules" id="live_chat_rules" rows="3" maxlength="1000" aria-describedby="live_chat_rules-help">{$system['live_chat_rules']}</textarea>
                <div class="admin-setting-help text-sm leading-relaxed" id="live_chat_rules-help">{__("Shown to viewers in the live chat when the host has not written their own rules, leave it empty to show nothing")}</div>
              </div>
            </div>
          </div>
            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
              <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
              </div>
              <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
              </div>
            </div>
          </section>
        </div>
      </div>
    </form>
  </div>
</section>