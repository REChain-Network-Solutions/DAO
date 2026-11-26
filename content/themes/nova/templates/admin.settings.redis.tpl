<section class="admin-settings-page" aria-labelledby="settings-redis-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-redis-title" class="text-2xl font-semibold">{__("Redis Settings")}</h1>
    <p class="text-base-content/60 text-sm">{__("Optional Redis cache that makes the site faster. The site works normally without it.")}</p>
  </div>
  <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Redis Settings")}" aria-orientation="vertical">
    <button type="button" id="settings-redis-tab-0" class="tab active-tab:tab-active active" data-tab="#Connection" aria-controls="Connection" role="tab" aria-selected="true"><span class="icon-[tabler--plug] size-4" aria-hidden="true"></span>{__("Connection")}</button>
    <button type="button" id="settings-redis-tab-1" class="tab active-tab:tab-active" data-tab="#Features" aria-controls="Features" role="tab" aria-selected="false"><span class="icon-[tabler--bolt] size-4" aria-hidden="true"></span>{__("Features")}</button>
    <button type="button" id="settings-redis-tab-2" class="tab active-tab:tab-active" data-tab="#Monitor" aria-controls="Monitor" role="tab" aria-selected="false"><span class="icon-[tabler--activity] size-4" aria-hidden="true"></span>{__("Monitor")}</button>
  </nav>

  <div class="admin-settings-panel js_admin-settings-panel" id="Connection" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=redis">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            {if !$redis_status['installed']}
              <div class="px-6 pt-6">
                <div class="alert alert-warning [overflow-wrap:anywhere]" role="alert">{__("The Predis library is missing from the vendor folder. Redis can't be enabled until it is installed.")}</div>
              </div>
            {/if}
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="database" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="redis_enabled">{__("Redis Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="redis_enabled-help">
                    {__("Turn the Redis cache On and Off")}<br>
                    {__("If Redis stops responding, the site keeps working from the database and retries Redis every 15 seconds")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="redis_enabled" id="redis_enabled" {if $system['redis_enabled']}checked{/if} aria-describedby="redis_enabled-help">
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="redis_host">{__("Host")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="redis_host" id="redis_host" value="{$system['redis_host']|default:'127.0.0.1'}" placeholder="127.0.0.1" aria-describedby="redis_host-help">
                  {else}
                    <input type="password" class="input w-full" id="redis_host" value="*********">
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="redis_host-help">{__("The Redis server hostname or IP address")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="redis_port">{__("Port")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="redis_port" id="redis_port" value="{$system['redis_port']|default:'6379'}" placeholder="6379" aria-describedby="redis_port-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="redis_port-help">{__("The Redis server port (default: 6379)")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="redis_password">{__("Password")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="password" class="input w-full" name="redis_password" id="redis_password" value="{$system['redis_password']}" autocomplete="new-password" aria-describedby="redis_password-help">
                  {else}
                    <input type="password" class="input w-full" id="redis_password" value="*********">
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="redis_password-help">{__("Leave empty if your Redis server has no password")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="redis_database">{__("Database")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="redis_database" id="redis_database" value="{$system['redis_database']|default:'0'}" placeholder="0" aria-describedby="redis_database-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="redis_database-help">{__("The Redis database number (default: 0)")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="redis_prefix">{__("Key Prefix")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="redis_prefix" id="redis_prefix" value="{$system['redis_prefix']}" placeholder="{$redis_default_prefix}" aria-describedby="redis_prefix-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="redis_prefix-help">{__("Keeps this site's keys apart when several sites share one Redis server. Leave empty to use the default")}</div>
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="ssl-sign" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="redis_tls_enabled">{__("TLS Connection")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="redis_tls_enabled-help">{__("Encrypt the connection (required by most managed Redis services)")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="redis_tls_enabled" id="redis_tls_enabled" {if $system['redis_tls_enabled']}checked{/if} aria-describedby="redis_tls_enabled-help">
                </div>
              </div>
            </div>
            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
              <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
              </div>
              <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                <button type="button" class="btn btn-outline js_admin-tester" data-handle="redis" title="{__("Test the saved connection")}">
                  <span class="icon-[tabler--activity] size-4" aria-hidden="true"></span>{__("Test Connection")}
                </button>
                <button type="button" class="btn btn-outline js_admin-tester" data-handle="redis_flush" title="{__("Delete this site's cached keys")}">
                  <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Flush Cache")}
                </button>
                <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
              </div>
            </div>
          </section>
        </div>
      </div>
    </form>
  </div>

  <div class="admin-settings-panel js_admin-settings-panel hidden" id="Features" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=redis_features">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="cache-cleaner" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="redis_widgets_enabled">{__("Widgets Cache")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="redis_widgets_enabled-help">{__("Cache shared widgets for a few minutes: trending hashtags, Pro members, promoted items, top merits users and announcements")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="redis_widgets_enabled" id="redis_widgets_enabled" {if $system['redis_widgets_enabled']}checked{/if} aria-describedby="redis_widgets_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="friends" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="redis_relations_enabled">{__("Relationships Cache")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="redis_relations_enabled-help">{__("Keep each user's friends, followings, friend requests and blocks in Redis instead of loading them from the database on every request. Cleared the moment any of them changes")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="redis_relations_enabled" id="redis_relations_enabled" {if $system['redis_relations_enabled']}checked{/if} aria-describedby="redis_relations_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="server" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="redis_sessions_enabled">{__("Sessions in Redis")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="redis_sessions_enabled-help">
                    {__("Store PHP sessions in Redis instead of files. Useful when the site runs on more than one web server")}<br>
                    {__("Nobody is logged out when you switch, but open forms may need a page refresh. If Redis is unavailable, sessions fall back to files")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="redis_sessions_enabled" id="redis_sessions_enabled" {if $system['redis_sessions_enabled']}checked{/if} aria-describedby="redis_sessions_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="views" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="redis_post_views_enabled">{__("Post Views Buffering")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="redis_post_views_enabled-help">
                    {__("Unique views: repeat views by the same viewer are skipped in Redis instead of checked in the database")}<br>
                    {__("All views: views are counted in Redis and written to the database about once a minute (and by the cron job)")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="redis_post_views_enabled" id="redis_post_views_enabled" {if $system['redis_post_views_enabled']}checked{/if} aria-describedby="redis_post_views_enabled-help">
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

  <div class="admin-settings-panel js_admin-settings-panel hidden" id="Monitor" role="tabpanel" tabindex="0">
    <div class="admin-settings-layout block">
      <div class="admin-settings-form flex min-w-0 flex-col gap-4">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Redis")}</h3>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div>
                <div class="admin-setting-label block text-sm font-medium leading-normal">{__("Status")}</div>
                <div class="admin-setting-help text-sm leading-relaxed [overflow-wrap:anywhere]">
                  {if !$redis_status['installed']}
                    {__("The Predis library is not installed")}
                  {elseif !$redis_status['enabled']}
                    {__("Redis is disabled, the site runs from the database")}
                  {elseif $redis_status['connected']}
                    {__("Connected")} &middot; {__("Redis")} {$redis_status['version']} &middot; {$redis_status['latency']} {__("ms")}
                  {else}
                    {__("Can't connect, the site is running from the database")}{if $redis_status['error']}: {$redis_status['error']}{/if}
                  {/if}
                </div>
              </div>
              <div class="text-end">
                {if $redis_status['connected']}
                  <span class="badge badge-soft badge-success badge-sm rounded-full shrink-0">{__("Connected")}</span>
                {elseif $redis_status['enabled']}
                  <span class="badge badge-soft badge-error badge-sm rounded-full shrink-0">{__("Unavailable")}</span>
                {else}
                  <span class="badge badge-soft badge-sm rounded-full shrink-0">{__("Disabled")}</span>
                {/if}
              </div>
            </div>
            {if $redis_status['connected']}
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <div class="admin-setting-label block text-sm font-medium leading-normal">{__("Cache Hit Rate")}</div>
                  <div class="admin-setting-help text-sm leading-relaxed">{$redis_status['hits']|number_format} {__("hits")} &middot; {$redis_status['misses']|number_format} {__("misses")}</div>
                </div>
                <div class="text-end text-sm font-semibold">{if $redis_status['hit_rate'] !== null}{$redis_status['hit_rate']}%{else}&mdash;{/if}</div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <div class="admin-setting-label block text-sm font-medium leading-normal">{__("Memory Used")}</div>
                  <div class="admin-setting-help text-sm leading-relaxed">{if $redis_status['memory_max']}{__("Limit")}: {$redis_status['memory_max']}{else}{__("No memory limit set on the Redis server")}{/if}</div>
                </div>
                <div class="text-end text-sm font-semibold">{$redis_status['memory']}</div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <div class="admin-setting-label block text-sm font-medium leading-normal">{__("Keys")}</div>
                  <div class="admin-setting-help text-sm leading-relaxed [overflow-wrap:anywhere]">{__("All keys in this Redis database")} &middot; {__("This site's prefix")}: <span class="font-mono">{$redis_status['prefix']}</span></div>
                </div>
                <div class="text-end text-sm font-semibold">{$redis_status['keys']|number_format}</div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <div class="admin-setting-label block text-sm font-medium leading-normal">{__("Server")}</div>
                  <div class="admin-setting-help text-sm leading-relaxed">{$redis_status['clients']} {__("connected clients")}</div>
                </div>
                <div class="text-end text-sm font-semibold">{$redis_status['uptime_days']} {__("days uptime")}</div>
              </div>
            {/if}
          </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
            <h3 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("System Cache")}</h3>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div>
                <div class="admin-setting-label block text-sm font-medium leading-normal">{__("Cache Folder")}</div>
                <div class="admin-setting-help text-sm leading-relaxed [overflow-wrap:anywhere]">
                  {if $system_cache_status['writable']}
                    {$system_cache_status['files']} {__("files")} &middot; {($system_cache_status['size']/1024)|number_format:0} {__("KB")}
                  {else}
                    {__("content/cache is not writable, settings and translations are loaded from the database on every request")}
                  {/if}
                </div>
              </div>
              <div class="text-end">
                {if $system_cache_status['writable']}
                  <span class="badge badge-soft badge-success badge-sm rounded-full shrink-0">{__("Writable")}</span>
                {else}
                  <span class="badge badge-soft badge-error badge-sm rounded-full shrink-0">{__("Not Writable")}</span>
                {/if}
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div>
                <div class="admin-setting-label block text-sm font-medium leading-normal">{__("OPcache")}</div>
                <div class="admin-setting-help text-sm leading-relaxed">{__("Keeps compiled PHP, settings and translations in memory")}</div>
              </div>
              <div class="text-end">
                {if $system_cache_status['opcache']}
                  <span class="badge badge-soft badge-success badge-sm rounded-full shrink-0">{__("Enabled")}</span>
                {else}
                  <span class="badge badge-soft badge-warning badge-sm rounded-full shrink-0">{__("Disabled")}</span>
                {/if}
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
  </div>
</section>
