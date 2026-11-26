<section class="admin-settings-page" aria-labelledby="settings-chat-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-chat-title" class="text-2xl font-semibold">{__("Chat Settings")}</h1>
    <p class="text-base-content/60 text-sm">{__("Messaging, calls, sockets, and chat apps.")}</p>
  </div>
  <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Chat Settings")}" aria-orientation="vertical">
    <button type="button" id="settings-chat-tab-0" class="tab active-tab:tab-active active" data-tab="#General" aria-controls="General" role="tab" aria-selected="true"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("General")}</button>
    <button type="button" id="settings-chat-tab-1" class="tab active-tab:tab-active" data-tab="#AudioVideoCalls" aria-controls="AudioVideoCalls" role="tab" aria-selected="false"><span class="icon-[tabler--phone] size-4" aria-hidden="true"></span>{__("Audio/Video Calls")}</button>
    <button type="button" id="settings-chat-tab-2" class="tab active-tab:tab-active" data-tab="#ChatSocket" aria-controls="ChatSocket" role="tab" aria-selected="false"><span class="icon-[tabler--plug] size-4" aria-hidden="true"></span>{__("Socket.io")}</button>
    <button type="button" id="settings-chat-tab-3" class="tab active-tab:tab-active" data-tab="#Apps" aria-controls="Apps" role="tab" aria-selected="false"><span class="icon-[tabler--apps] size-4" aria-hidden="true"></span>{__("Apps")}</button>
  </nav>
  <div class="admin-settings-panel js_admin-settings-panel" id="General" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=chat">
      <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="chat" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chat_enabled">{__("Chat Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_enabled-help">{__("Turn the chat system On and Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="chat_enabled" id="chat_enabled" {if $system['chat_enabled']}checked{/if} aria-describedby="chat_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="voice_notes" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="voice_notes_chat_enabled">{__("Voice Notes")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="voice_notes_chat_enabled-help">{__("Turn the voice notes in chat On and Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="voice_notes_chat_enabled" id="voice_notes_chat_enabled" {if $system['voice_notes_chat_enabled']}checked{/if} aria-describedby="voice_notes_chat_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="chat_status" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chat_status_enabled">{__("User Status Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_status_enabled-help">{__("Turn the Last Seen On and Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="chat_status_enabled" id="chat_status_enabled" {if $system['chat_status_enabled']}checked{/if} aria-describedby="chat_status_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="chat_typing" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chat_typing_enabled">{__("Typing Status Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_typing_enabled-help">{__("Turn the Typing Status On and Off")} ({__("Needs a good server to work fine")})</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="chat_typing_enabled" id="chat_typing_enabled" {if $system['chat_typing_enabled']}checked{/if} aria-describedby="chat_typing_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="chat_seen" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chat_seen_enabled">{__("Seen Status Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_seen_enabled-help">{__("Turn the Seen Status On and Off")} ({__("Needs a good server to work fine")})</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="chat_seen_enabled" id="chat_seen_enabled" {if $system['chat_seen_enabled']}checked{/if} aria-describedby="chat_seen_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="delete" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chat_permanently_delete_enabled">{__("Delete For Everyone")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_permanently_delete_enabled-help">{__("Permanently remove the conversation for all chat members when user delete it")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="chat_permanently_delete_enabled" id="chat_permanently_delete_enabled" {if $system['chat_permanently_delete_enabled']}checked{/if} aria-describedby="chat_permanently_delete_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="language" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chat_translation_enabled">{__("Chat Translation")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_translation_enabled-help">{__("Turn the chat messages translation On and Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="chat_translation_enabled" id="chat_translation_enabled" {if $system['chat_translation_enabled']}checked{/if} aria-describedby="chat_translation_enabled-help">
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
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="AudioVideoCalls" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=audio_video_calls">
      <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="audio_call" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="audio_call_enabled">{__("Audio Call Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="audio_call_enabled-help">{__("Turn the audio call system On and Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="audio_call_enabled" id="audio_call_enabled" {if $system['audio_call_enabled']}checked{/if} aria-describedby="audio_call_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="video_call" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="video_call_enabled">{__("Video Call Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="video_call_enabled-help">{__("Turn the video call system On and Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="video_call_enabled" id="video_call_enabled" {if $system['video_call_enabled']}checked{/if} aria-describedby="video_call_enabled-help">
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="audio_video_provider-label">
                <div class="label-text" id="audio_video_provider-label">{__("Calls Provider")}</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-provider-group flex flex-wrap items-stretch gap-3">
                    <label class="admin-settings-provider-card">
                      <span class="admin-settings-provider-logo">
                        {include file='__svg_icons.tpl' icon="twilio" width="32px" height="32px"}
                      </span>
                      <span class="label-text">{__("Twilio")}</span>
                      <input type="radio" name="audio_video_provider" value="twilio" id="av_twilio" class="radio radio-primary" {if $system['audio_video_provider'] == "twilio"}checked{/if} aria-describedby="audio_video_provider-help">
                    </label>
                    <label class="admin-settings-provider-card">
                      <span class="admin-settings-provider-logo">
                        {include file='__svg_icons.tpl' icon="livekit" width="52px" height="32px"}
                      </span>
                      <span class="label-text">{__("LiveKit")}</span>
                      <input type="radio" name="audio_video_provider" value="livekit" id="av_livekit" class="radio radio-primary" {if $system['audio_video_provider'] == "livekit"}checked{/if} aria-describedby="audio_video_provider-help">
                    </label>
                    <label class="admin-settings-provider-card">
                      <span class="admin-settings-provider-logo">
                        {include file='__svg_icons.tpl' icon="agora" width="32px" height="32px"}
                      </span>
                      <span class="label-text">{__("Agora")}</span>
                      <input type="radio" name="audio_video_provider" value="agora" id="av_agora" class="radio radio-primary" {if $system['audio_video_provider'] == "agora"}checked{/if} aria-describedby="audio_video_provider-help">
                    </label>
                  </div>
                  <div class="admin-setting-help text-sm leading-relaxed" id="audio_video_provider-help">{__("Select your default Audio/Video calls provider")}</div>
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <h3 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Twilio")}</h3>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="twilio_sid">{__("Twilio Account SID")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="twilio_sid" id="twilio_sid" value="{$system['twilio_sid']}">
                  {else}
                    <input type="password" class="input w-full" id="twilio_sid" value="*********">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="twilio_apisid">{__("Twilio API SID")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="twilio_apisid" id="twilio_apisid" value="{$system['twilio_apisid']}">
                  {else}
                    <input type="password" class="input w-full" id="twilio_apisid" value="*********">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="twilio_apisecret">{__("Twilio API SECRET")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="twilio_apisecret" id="twilio_apisecret" value="{$system['twilio_apisecret']}">
                  {else}
                    <input type="password" class="input w-full" id="twilio_apisecret" value="*********">
                  {/if}
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <h3 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("LiveKit")}</h3>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="livekit_api_key">{__("LiveKit API Key")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="livekit_api_key" id="livekit_api_key" value="{$system['livekit_api_key']}">
                  {else}
                    <input type="password" class="input w-full" id="livekit_api_key" value="*********">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="livekit_api_secret">{__("LiveKit API Secret")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="livekit_api_secret" id="livekit_api_secret" value="{$system['livekit_api_secret']}">
                  {else}
                    <input type="password" class="input w-full" id="livekit_api_secret" value="*********">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="livekit_ws_url">{__("LiveKit WebSocket URL")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="livekit_ws_url" id="livekit_ws_url" value="{$system['livekit_ws_url']}">
                  {else}
                    <input type="password" class="input w-full" id="livekit_ws_url" value="*********">
                  {/if}
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <h3 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Agora")}</h3>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="agora_call_app_id">{__("Agora App ID")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="agora_call_app_id" id="agora_call_app_id" value="{$system['agora_call_app_id']}">
                  {else}
                    <input type="password" class="input w-full" id="agora_call_app_id" value="*********">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="agora_call_app_certificate">{__("Agora App Certificate")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="agora_call_app_certificate" id="agora_call_app_certificate" value="{$system['agora_call_app_certificate']}">
                  {else}
                    <input type="password" class="input w-full" id="agora_call_app_certificate" value="*********">
                  {/if}
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
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="ChatSocket" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=chat_socket">
      <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="socketio" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chat_socket_enabled">{__("Chat Socket Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_socket_enabled-help">
                    {__("Turn the chat socket system On and Off")}<br>
                    {__("If disabled the default ajax system will be enabled")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="chat_socket_enabled" id="chat_socket_enabled" {if $system['chat_socket_enabled']}checked{/if} aria-describedby="chat_socket_enabled-help">
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="chat_socket_server-label">
                <div class="label-text" id="chat_socket_server-label">{__("Socket Server")}</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-provider-group flex flex-wrap items-stretch gap-3">
                    <label class="admin-settings-provider-card">
                      <span class="admin-settings-provider-logo">
                        {include file='__svg_icons.tpl' icon="php" width="32px" height="32px"}
                      </span>
                      <span class="label-text">{__("PHP")}</span>
                      <input type="radio" name="chat_socket_server" value="php" id="socket_php" class="radio radio-primary" {if $system['chat_socket_server'] == "php"}checked{/if} aria-describedby="chat_socket_server-help">
                    </label>
                    <label class="admin-settings-provider-card">
                      <span class="admin-settings-provider-logo">
                        {include file='__svg_icons.tpl' icon="nodejs" width="52px" height="32px"}
                      </span>
                      <span class="label-text">{__("NodeJS")}</span>
                      <input type="radio" name="chat_socket_server" value="nodejs" id="socket_nodejs" class="radio radio-primary" {if $system['chat_socket_server'] == "nodejs"}checked{/if} aria-describedby="chat_socket_server-help">
                    </label>
                  </div>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_socket_server-help">{__("Select your default Socket.io server")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="php_bin_path">{__("PHP Path")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="php_bin_path" id="php_bin_path" value="{$system['php_bin_path']}" placeholder="php" aria-describedby="php_bin_path-help">
                  {else}
                    <input type="password" class="input w-full" id="php_bin_path" value="*********">
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="php_bin_path-help">{__("The path to the PHP binary")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="nodejs_bin_path">{__("NodeJS Path")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="nodejs_bin_path" id="nodejs_bin_path" value="{$system['nodejs_bin_path']}" placeholder="node" aria-describedby="nodejs_bin_path-help">
                  {else}
                    <input type="password" class="input w-full" id="nodejs_bin_path" value="*********">
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="nodejs_bin_path-help">{__("The path to the NodeJS binary")}</div>
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chat_socket_proxied">{__("Chat Socket Proxied")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_socket_proxied-help">{__("Turn the chat socket server proxied On and Off")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="chat_socket_proxied" id="chat_socket_proxied" {if $system['chat_socket_proxied']}checked{/if} aria-describedby="chat_socket_proxied-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="chat_socket_port">{__("Socket Port")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="chat_socket_port" id="chat_socket_port" value="{$system['chat_socket_port']}" placeholder="3000" aria-describedby="chat_socket_port-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_socket_port-help">{__("The port number for the chat socket server (default: 3000)")}</div>
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="verification" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chat_socket_ssl_verify_peer">{__("SSL Verify Peer")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_socket_ssl_verify_peer-help">{__("Enable SSL certificate verification")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="chat_socket_ssl_verify_peer" id="chat_socket_ssl_verify_peer" {if $system['chat_socket_ssl_verify_peer']}checked{/if} aria-describedby="chat_socket_ssl_verify_peer-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="ssl-sign" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chat_socket_ssl_allow_self_signed">{__("SSL Allow Self Signed")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_socket_ssl_allow_self_signed-help">{__("Allow self-signed SSL certificates")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="chat_socket_ssl_allow_self_signed" id="chat_socket_ssl_allow_self_signed" {if $system['chat_socket_ssl_allow_self_signed']}checked{/if} aria-describedby="chat_socket_ssl_allow_self_signed-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="chat_socket_ssl_crt">{__("SSL Certificate Path")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="chat_socket_ssl_crt" id="chat_socket_ssl_crt" value="{$system['chat_socket_ssl_crt']}" aria-describedby="chat_socket_ssl_crt-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_socket_ssl_crt-help">{__("The path to the SSL certificate (.crt)")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="chat_socket_ssl_key">{__("SSL Certificate Key Path")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="chat_socket_ssl_key" id="chat_socket_ssl_key" value="{$system['chat_socket_ssl_key']}" aria-describedby="chat_socket_ssl_key-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_socket_ssl_key-help">{__("The path to the SSL certificate key (.key)")}</div>
                </div>
              </div>
            </div>
            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
              <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
              </div>
              <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                <button type="button" class="btn btn-outline js_admin-tester" data-handle="chat_socket_status" title="{__("Check Status")}">
                  <span class="icon-[tabler--activity] size-4" aria-hidden="true"></span>{__("Status")}
                </button>
                <button type="button" class="btn btn-outline js_admin-tester" data-handle="chat_socket_start" title="{__("Start")}">
                  <span class="icon-[tabler--player-play] size-4" aria-hidden="true"></span>{__("Start")}
                </button>
                <button type="button" class="btn btn-outline js_admin-tester" data-handle="chat_socket_stop" title="{__("Stop")}">
                  <span class="icon-[tabler--player-stop] size-4" aria-hidden="true"></span>{__("Stop")}
                </button>
                <button type="button" class="btn btn-outline js_admin-tester" data-handle="socket_certificate">
                  <span class="icon-[tabler--certificate] size-4" aria-hidden="true"></span>{__("Check Certificate")}
                </button>
                <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
              </div>
            </div>
          </section>
        </div>
      </div>
    </form>
  </div>
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="Apps" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=chat_apps">
      <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="mobile" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="redirect_to_mobile_apps">{__("Redirect to Mobile Apps")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="redirect_to_mobile_apps-help">{__("Turn the chat icon off on mobile devices if you have the mobile apps installed")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="redirect_to_mobile_apps" id="redirect_to_mobile_apps" {if $system['redirect_to_mobile_apps']}checked{/if} aria-describedby="redirect_to_mobile_apps-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="messaging_app_android_link">{__("Google Play Store Link")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="messaging_app_android_link" id="messaging_app_android_link" value="{$system['messaging_app_android_link']}" aria-describedby="messaging_app_android_link-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="messaging_app_android_link-help">{__("The messaging app link on Google Play Store")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="messaging_app_ios_link">{__("Apple App Store Link")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="messaging_app_ios_link" id="messaging_app_ios_link" value="{$system['messaging_app_ios_link']}" aria-describedby="messaging_app_ios_link-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="messaging_app_ios_link-help">{__("The messaging app link on Apple App Store")}</div>
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
