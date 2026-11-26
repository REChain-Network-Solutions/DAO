<section class="admin-settings-page" aria-labelledby="admin-apis-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="admin-apis-title" class="text-2xl font-semibold">{__("APIs Settings")}</h1>
    <p class="text-base-content/60 text-sm">{__("Native app keys and JWT sessions.")}</p>
  </div>

  <div class="admin-settings-panel js_admin-settings-panel" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=apis">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="apis-native-title">
              <h2 id="apis-native-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--shape] size-5" aria-hidden="true"></span>
                {__("API Key and Secret")}
              </h2>

              <div class="alert alert-warning" role="status">
                <div class="min-w-0 flex-1">
                  <strong class="block">{__("API Key and Secret")}</strong>
                  <span class="mt-0.5 block font-normal">{__("Reset the API Key will affect the APIs that are used in the your native apps")}</span>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="system_api_key">{__("API Key")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="system_api_key" id="system_api_key" value="{$system['system_api_key']}" aria-describedby="system_api_key-help" autocomplete="off">
                  {else}
                    <input type="password" class="input w-full" id="system_api_key" value="*********" aria-describedby="system_api_key-help">
                  {/if}
                  <div id="system_api_key-help" class="admin-setting-help text-sm leading-relaxed">{__("The API Key that is used in the your native apps")}</div>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="system_api_secret">{__("API Secret")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="system_api_secret" id="system_api_secret" value="{$system['system_api_secret']}" aria-describedby="system_api_secret-help" autocomplete="off">
                  {else}
                    <input type="password" class="input w-full" id="system_api_secret" value="*********" aria-describedby="system_api_secret-help">
                  {/if}
                  <div id="system_api_secret-help" class="admin-setting-help text-sm leading-relaxed">{__("The API Secret that is used in the your native apps")}</div>
                </div>
              </div>

              <div class="flex justify-end">
                <button type="button" class="btn btn-error max-sm:w-full js_admin-api-reset">
                  <span class="icon-[tabler--refresh] size-4" aria-hidden="true"></span>
                  {__("Reset API Key")}
                </button>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="apis-jwt-title">
              <h2 id="apis-jwt-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--key] size-5" aria-hidden="true"></span>
                {__("JWT Key")}
              </h2>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="system_jwt_key">{__("JWT Key")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="system_jwt_key" id="system_jwt_key" value="{$system['system_jwt_key']}" aria-describedby="system_jwt_key-help" autocomplete="off">
                  {else}
                    <input type="password" class="input w-full" id="system_jwt_key" value="*********" aria-describedby="system_jwt_key-help">
                  {/if}
                  <div id="system_jwt_key-help" class="admin-setting-help text-sm leading-relaxed">
                    {__("The JSON Web Token Key that is used to generate the token for users sessions")}<br>
                    {__("Note: Resetting the JWT Key will log the users out from all sessions")}
                  </div>
                </div>
              </div>

              <div class="flex justify-end">
                <button type="button" class="btn btn-error max-sm:w-full js_admin-jwt-reset">
                  <span class="icon-[tabler--refresh] size-4" aria-hidden="true"></span>
                  {__("Reset JWT Key")}
                </button>
              </div>
            </div>

            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
              <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
              </div>
              <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                <button type="button" class="btn btn-outline js_admin-tester" data-handle="api">
                  <span class="icon-[tabler--bolt] size-4" aria-hidden="true"></span>
                  {__("Ping API")}
                </button>
                <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
              </div>
            </div>
          </section>
        </div>
      </div>
    </form>
  </div>
</section>
