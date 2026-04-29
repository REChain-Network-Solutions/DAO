<!-- card-header -->
<div class="card-header with-icon with-nav">
  <!-- panel title -->
  <div class="mb20">
    <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("Chat")}
  </div>
  <!-- panel title -->

  <!-- panel nav -->
  <ul class="nav nav-tabs">
    <li class="nav-item">
      <a class="nav-link active" href="#General" data-bs-toggle="tab">
        <i class="fa-solid fa-comments fa-fw mr5"></i><strong>{__("General")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#AudioVideoCalls" data-bs-toggle="tab">
        <i class="fa fa-phone fa-fw mr5"></i><strong>{__("Audio/Video Calls")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#ChatSocket" data-bs-toggle="tab">
        <i class="fa-solid fa-bolt fa-fw mr5"></i><strong>{__("Socket.io")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#Apps" data-bs-toggle="tab">
        <i class="fa-solid fa-mobile fa-fw mr5"></i><strong>{__("Apps")}</strong>
      </a>
    </li>
  </ul>
  <!-- panel nav -->
</div>
<!-- card-header -->

<!-- tab-content -->
<div class="tab-content">
  <!-- General -->
  <div class="tab-pane active" id="General">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=chat">
      <div class="card-body">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="chat" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Chat Enabled")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the chat system On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="chat_enabled">
              <input type="checkbox" name="chat_enabled" id="chat_enabled" {if $system['chat_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="voice_notes" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Voice Notes")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the voice notes in chat On and Off")}<br>
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="voice_notes_chat_enabled">
              <input type="checkbox" name="voice_notes_chat_enabled" id="voice_notes_chat_enabled" {if $system['voice_notes_chat_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="chat_status" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("User Status Enabled")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the Last Seen On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="chat_status_enabled">
              <input type="checkbox" name="chat_status_enabled" id="chat_status_enabled" {if $system['chat_status_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="chat_typing" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Typing Status Enabled")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the Typing Status On and Off")} ({__("Needs a good server to work fine")})</div>
          </div>
          <div class="text-end">
            <label class="switch" for="chat_typing_enabled">
              <input type="checkbox" name="chat_typing_enabled" id="chat_typing_enabled" {if $system['chat_typing_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="chat_seen" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Seen Status Enabled")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the Seen Status On and Off")} ({__("Needs a good server to work fine")})</div>
          </div>
          <div class="text-end">
            <label class="switch" for="chat_seen_enabled">
              <input type="checkbox" name="chat_seen_enabled" id="chat_seen_enabled" {if $system['chat_seen_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="delete" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Delete For Everyone")}</div>
            <div class="form-text d-none d-sm-block">{__("Permanently remove the conversation for all chat members when user delete it")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="chat_permanently_delete_enabled">
              <input type="checkbox" name="chat_permanently_delete_enabled" id="chat_permanently_delete_enabled" {if $system['chat_permanently_delete_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="language" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Chat Translation")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the chat messages translation On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="chat_translation_enabled">
              <input type="checkbox" name="chat_translation_enabled" id="chat_translation_enabled" {if $system['chat_translation_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
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
  <!-- General -->

  <!-- Audio/Video Calls -->
  <div class="tab-pane" id="AudioVideoCalls">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=audio_video_calls">
      <div class="card-body">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="call_audio" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Audio Call Enabled")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the audio call system On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="audio_call_enabled">
              <input type="checkbox" name="audio_call_enabled" id="audio_call_enabled" {if $system['audio_call_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="call_video" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Video Call Enabled")}</div>
            <div class="form-text d-none d-sm-block">{__("Turn the video call system On and Off")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="video_call_enabled">
              <input type="checkbox" name="video_call_enabled" id="video_call_enabled" {if $system['video_call_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider"></div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Calls Provider")}
          </label>
          <div class="col-md-9">
            <div>
              <!-- Twilio -->
              <input class="x-hidden input-label" type="radio" name="audio_video_provider" value="twilio" id="av_twilio" {if $system['audio_video_provider'] == "twilio"}checked{/if} />
              <label class="button-label" for="av_twilio">
                <div class="icon">
                  {include file='__svg_icons.tpl' icon="twilio" width="32px" height="32px"}
                </div>
                <div class="title">{__("Twilio")}</div>
              </label>
              <!-- Twilio -->
              <!-- LiveKit -->
              <input class="x-hidden input-label" type="radio" name="audio_video_provider" value="livekit" id="av_livekit" {if $system['audio_video_provider'] == "livekit"}checked{/if} />
              <label class="button-label" for="av_livekit">
                <div class="icon">
                  {include file='__svg_icons.tpl' icon="livekit" width="52px" height="32px"}
                </div>
                <div class="title">{__("LiveKit")}</div>
              </label>
              <!-- LiveKit -->
              <!-- Agora -->
              <input class="x-hidden input-label" type="radio" name="audio_video_provider" value="agora" id="av_agora" {if $system['audio_video_provider'] == "agora"}checked{/if} />
              <label class="button-label" for="av_agora">
                <div class="icon">
                  {include file='__svg_icons.tpl' icon="agora" width="32px" height="32px"}
                </div>
                <div class="title">{__("Agora")}</div>
              </label>
              <!-- Agora -->
            </div>
            <div class="form-text">
              {__("Select your default Audio/Video calls provider")}<br />
            </div>
          </div>
        </div>

        <div class="divider dashed"></div>

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
            {__("Twilio API SID")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="twilio_apisid" value="{$system['twilio_apisid']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Twilio API SECRET")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="twilio_apisecret" value="{$system['twilio_apisecret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="divider dashed"></div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("LiveKit API Key")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="livekit_api_key" value="{$system['livekit_api_key']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("LiveKit API Secret")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="livekit_api_secret" value="{$system['livekit_api_secret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("LiveKit WebSocket URL")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="livekit_ws_url" value="{$system['livekit_ws_url']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="divider dashed"></div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Agora App ID")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="agora_call_app_id" value="{$system['agora_call_app_id']}">
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
              <input type="text" class="form-control" name="agora_call_app_certificate" value="{$system['agora_call_app_certificate']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
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
  <!-- Audio/Video Calls -->

  <!-- Socket.io -->
  <div class="tab-pane" id="ChatSocket">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=chat_socket">
      <div class="card-body">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="socketio" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Chat Socket Enabled")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the chat socket system On and Off")}<br>
              {__("If disabled the default ajax system will be enabled")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="chat_socket_enabled">
              <input type="checkbox" name="chat_socket_enabled" id="chat_socket_enabled" {if $system['chat_socket_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider dashed"></div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Socket Server")}
          </label>
          <div class="col-md-9">
            <div>
              <!-- PHP -->
              <input class="x-hidden input-label" type="radio" name="chat_socket_server" value="php" id="socket_php" {if $system['chat_socket_server'] == "php"}checked{/if} />
              <label class="button-label" for="socket_php">
                <div class="icon">
                  {include file='__svg_icons.tpl' icon="php" width="32px" height="32px"}
                </div>
                <div class="title">{__("PHP")}</div>
              </label>
              <!-- PHP -->
              <!-- NodeJS -->
              <input class="x-hidden input-label" type="radio" name="chat_socket_server" value="nodejs" id="socket_nodejs" {if $system['chat_socket_server'] == "nodejs"}checked{/if} disabled />
              <label class="button-label" for="socket_nodejs">
                <div class="icon">
                  {include file='__svg_icons.tpl' icon="nodejs" width="52px" height="32px"}
                </div>
                <div class="title">{__("NodeJS")}</div>
              </label>
              <!-- NodeJS -->
            </div>
            <div class="form-text">
              {__("Select your default Socket.io server")}<br />
              <small>{__("Note: NodeJS support is currently unavailable and will be implemented in upcoming updates")}</small>
            </div>
          </div>
        </div>

        <!-- PHP bin path -->
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("PHP Path")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="php_bin_path" value="{$system['php_bin_path']}" placeholder="php">
            <div class="form-text">
              {__("The path to the PHP binary")}
            </div>
          </div>
        </div>
        <!-- PHP bin path -->

        <!-- NodeJS bin path -->
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("NodeJS Path")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="nodejs_bin_path" value="{$system['nodejs_bin_path']}" placeholder="node" disabled>
            <div class="form-text">
              {__("The path to the NodeJS binary")}
            </div>
          </div>
        </div>
        <!-- NodeJS bin path -->

        <div class="divider dashed"></div>

        <div class="form-table-row">
          <div>
            <div class="form-label h6">{__("Chat Socket Proxied")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the chat socket server proxied On and Off")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="chat_socket_proxied">
              <input type="checkbox" name="chat_socket_proxied" id="chat_socket_proxied" {if $system['chat_socket_proxied']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Socket Port")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="chat_socket_port" value="{$system['chat_socket_port']}" placeholder="3000">
            <div class="form-text">
              {__("The port number for the chat socket server (default: 3000)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("SSL Certificate Path")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="chat_socket_ssl_crt" value="{$system['chat_socket_ssl_crt']}">
            <div class="form-text">
              {__("The path to the SSL certificate (.crt)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("SSL Certificate Key Path")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="chat_socket_ssl_key" value="{$system['chat_socket_ssl_key']}">
            <div class="form-text">
              {__("The path to the SSL certificate key (.key)")}
            </div>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="verification" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("SSL Verify Peer")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable SSL certificate verification")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="chat_socket_ssl_verify_peer">
              <input type="checkbox" name="chat_socket_ssl_verify_peer" id="chat_socket_ssl_verify_peer" {if $system['chat_socket_ssl_verify_peer']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="ssl-sign" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("SSL Allow Self Signed")}</div>
            <div class="form-text d-none d-sm-block">{__("Allow self-signed SSL certificates")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="chat_socket_ssl_allow_self_signed">
              <input type="checkbox" name="chat_socket_ssl_allow_self_signed" id="chat_socket_ssl_allow_self_signed" {if $system['chat_socket_ssl_allow_self_signed']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden" style="font-size: 13px; background: #000; border-color: #000;"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </div>
      <div class="card-footer d-flex justify-content-between align-items-center">
        <div>
          <button type="button" class="btn btn-warning btn-sm rounded-pill js_admin-tester" style="padding: 8px 12px;" data-handle="chat_socket_status" title="{__("Check Status")}">
            <i class="fa fa-bolt fa-fw"></i> {__("Status")}
          </button>
          <button type="button" class="btn btn-success btn-sm rounded-pill js_admin-tester" style="padding: 8px 12px;" data-handle="chat_socket_start" title="{__("Start")}">
            <i class="fa fa-play fa-fw"></i> {__("Start")}
          </button>
          <button type="button" class="btn btn-danger btn-sm rounded-pill js_admin-tester" style="padding: 8px 12px;" data-handle="chat_socket_stop" title="{__("Stop")}">
            <i class="fa fa-stop fa-fw"></i> {__("Stop")}
          </button>
        </div>
        <div>
          <button type="button" class="btn btn-danger js_admin-tester" data-handle="socket_certificate">
            <i class="fa fa-bolt mr10"></i> {__("Check Certificate")}
          </button>
          <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
        </div>
      </div>
    </form>
  </div>
  <!-- Socket.io -->

  <!-- Apps -->
  <div class="tab-pane" id="Apps">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=chat_apps">
      <div class="card-body">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="mobile" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Redirect to Mobile Apps")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Turn the chat icon off on mobile devices if you have the mobile apps installed")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="redirect_to_mobile_apps">
              <input type="checkbox" name="redirect_to_mobile_apps" id="redirect_to_mobile_apps" {if $system['redirect_to_mobile_apps']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Google Play Store Link")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="messaging_app_android_link" value="{$system['messaging_app_android_link']}">
            <div class="form-text">
              {__("The messaging app link on Google Play Store")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Apple App Store Link")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="messaging_app_ios_link" value="{$system['messaging_app_ios_link']}">
            <div class="form-text">
              {__("The messaging app link on Apple App Store")}
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
  <!-- Socket.io -->
</div>