<section class="admin-settings-page" aria-labelledby="admin-sitemap-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="admin-sitemap-title" class="text-2xl font-semibold">{__("Sitemap")}</h1>
    <p class="text-base-content/60 text-sm">{__("Help search engines find your public content with XML sitemaps, robots.txt and llms.txt")}</p>
  </div>
  <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Sitemap")}" aria-orientation="vertical">
    <button type="button" id="admin-sitemap-tab-0" class="tab active-tab:tab-active active" data-tab="#Overview" aria-controls="Overview" role="tab" aria-selected="true"><span class="icon-[tabler--chart-bar] size-4" aria-hidden="true"></span>{__("Overview")}</button>
    <button type="button" id="admin-sitemap-tab-1" class="tab active-tab:tab-active" data-tab="#Settings" aria-controls="Settings" role="tab" aria-selected="false"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("Settings")}</button>
    <button type="button" id="admin-sitemap-tab-2" class="tab active-tab:tab-active" data-tab="#Robots" aria-controls="Robots" role="tab" aria-selected="false"><span class="icon-[tabler--robot] size-4" aria-hidden="true"></span>robots.txt</button>
    <button type="button" id="admin-sitemap-tab-3" class="tab active-tab:tab-active" data-tab="#LLMs" aria-controls="LLMs" role="tab" aria-selected="false"><span class="icon-[tabler--file-text] size-4" aria-hidden="true"></span>llms.txt</button>
  </nav>

  <!-- overview -->
  <div class="admin-settings-panel js_admin-settings-panel" id="Overview" role="tabpanel" tabindex="0">
    <div class="flex min-w-0 flex-col gap-4">
      {if !$system['sitemap_enabled']}
        <div class="alert alert-warning [overflow-wrap:anywhere]" role="alert">{__("The sitemap is disabled, enable it from the Settings tab")}</div>
      {elseif !$system['system_public']}
        <div class="alert alert-warning [overflow-wrap:anywhere]" role="alert">{__("Your website is not public, so the sitemap is not available to search engines")}</div>
      {elseif !$system['cronjob_enabled']}
        <div class="alert alert-info items-center! [overflow-wrap:anywhere] max-sm:flex-wrap" role="status"><span class="min-w-0 flex-1">{__("The cronjob is disabled, sitemaps are only refreshed when search engines request them")}</span> <a class="btn btn-sm btn-info shrink-0 max-sm:w-full" href="{$system['system_url']}/{$control_panel['url']}/tools/cronjob">{__("Cronjob Settings")}</a></div>
      {/if}

      <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-info icon-[tabler--link] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("URLs")}">{__("URLs")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$sitemap_stats['urls']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-success icon-[tabler--files] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Sitemap Files")}">{__("Sitemap Files")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$sitemap_stats['files']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-warning icon-[tabler--database] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Cache Size")}">{__("Cache Size")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{if $sitemap_stats['size'] >= 1048576}{($sitemap_stats['size']/1048576)|number_format:1} {__("MB")}{else}{($sitemap_stats['size']/1024)|number_format:0} {__("KB")}{/if}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-neutral icon-[tabler--clock] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Last Generated")}">{__("Last Generated")}</span>
            <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{if $sitemap_stats['generated_at']}<span class="js_moment" data-time="{$sitemap_stats['generated_at']}">{$sitemap_stats['generated_at']}</span>{else}{__("N/A")}{/if}</p>
          </div>
        </article>
      </div>

      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/sitemap.php?do=rebuild">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="sitemap-url-title">
            <h2 id="sitemap-url-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              <span class="icon-[tabler--sitemap] size-5" aria-hidden="true"></span>
              {__("Sitemap URL")}
            </h2>
            <p class="text-base-content/60 text-sm">{__("Submit this URL once in Google Search Console and Bing Webmaster Tools, it is also listed in your robots.txt")}</p>
            <div class="admin-tools-code"><code>{$system['system_url']}/sitemap.xml</code></div>
            <p class="text-base-content/60 text-sm">{__("Sitemaps are refreshed by the cronjob and when search engines request them. Rebuilding reads all public content again and might take some time")}</p>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <a href="{$system['system_url']}/sitemap.xml" target="_blank" class="btn btn-outline"><span class="icon-[tabler--external-link] size-4" aria-hidden="true"></span>{__("Open Sitemap")}</a>
              <button type="button" class="btn btn-outline js_admin-tester" data-handle="sitemap_cache" title="{__("Delete the saved sitemap files, they are generated again on the next request")}"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Clear Cache")}</button>
              <button type="submit" class="btn btn-primary"><span class="icon-[tabler--refresh] size-4" aria-hidden="true"></span>{__("Rebuild")}</button>
            </div>
          </div>
        </section>
      </form>

      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Content Types")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("Content Type")}</th>
                <th>{__("Status")}</th>
                <th class="text-end">{__("Files")}</th>
                <th class="text-end">{__("URLs")}</th>
                <th>{__("Last Generated")}</th>
              </tr>
            </thead>
            <tbody>
              {foreach $sitemap_stats['types'] as $type => $row}
                <tr>
                  <td>
                    <span class="admin-list-identity-text grid min-w-32 gap-0.5">
                      <span class="admin-list-name text-sm font-semibold">{$row['title']}</span>
                      <span class="admin-list-id font-mono text-xs">sitemap-{$type}-1.xml</span>
                    </span>
                  </td>
                  <td>
                    {if !$row['available']}
                      <span class="badge badge-soft badge-sm rounded-full">{__("Module Disabled")}</span>
                    {elseif $row['enabled']}
                      <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Included")}</span>
                    {else}
                      <span class="badge badge-soft badge-warning badge-sm rounded-full">{__("Excluded")}</span>
                    {/if}
                  </td>
                  <td class="text-end tabular-nums">{$row['files']|number_format}</td>
                  <td class="text-end tabular-nums">{$row['urls']|number_format}</td>
                  <td>{if $row['generated_at']}<span class="js_moment" data-time="{$row['generated_at']}">{$row['generated_at']}</span>{else}&mdash;{/if}</td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  </div>
  <!-- overview -->

  <!-- settings -->
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="Settings" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/sitemap.php?do=settings">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="sitemap_enabled">{__("Sitemap Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="sitemap_enabled-help">{__("Publish sitemap.xml with your public content and list it in robots.txt")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="sitemap_enabled" id="sitemap_enabled" {if $system['sitemap_enabled']}checked{/if} aria-describedby="sitemap_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="sitemap_images_enabled">{__("Include Images")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="sitemap_images_enabled-help">{__("Add photos and covers so they can appear in image search")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="sitemap_images_enabled" id="sitemap_images_enabled" {if $system['sitemap_images_enabled']}checked{/if} aria-describedby="sitemap_images_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="sitemap_videos_enabled">{__("Include Videos")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="sitemap_videos_enabled-help">{__("Add videos and reels with their thumbnails so they can appear in video search")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="sitemap_videos_enabled" id="sitemap_videos_enabled" {if $system['sitemap_videos_enabled']}checked{/if} aria-describedby="sitemap_videos_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="indexnow_enabled">{__("IndexNow")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="indexnow_enabled-help">{__("Tell Bing, Yandex and other IndexNow search engines about new content right away")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="indexnow_enabled" id="indexnow_enabled" {if $system['indexnow_enabled']}checked{/if} aria-describedby="indexnow_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="sitemap_urls_per_file">{__("URLs Per File")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="number" min="1000" max="50000" step="1" class="input w-full" name="sitemap_urls_per_file" id="sitemap_urls_per_file" value="{$system['sitemap_urls_per_file']|default:10000}" aria-describedby="sitemap_urls_per_file-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="sitemap_urls_per_file-help">{__("Large content types are split into several files, from 1,000 to 50,000. Changing it rebuilds all sitemaps")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="sitemap_refresh">{__("Refresh Interval")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="number" min="1" step="1" class="input w-full" name="sitemap_refresh" id="sitemap_refresh" value="{$system['sitemap_refresh']|default:60}" aria-describedby="sitemap_refresh-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="sitemap_refresh-help">{__("How often new content is added to the sitemap, in minutes")}</div>
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
              <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Content Types")}</h2>
              {foreach $sitemap_stats['types'] as $type => $row}
                {if $row['available']}
                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div>
                      <label class="admin-setting-label block text-sm font-medium leading-normal" for="sitemap_type_{$type}">{$row['title']}</label>
                    </div>
                    <div class="text-end">
                      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="sitemap_types[]" value="{$type}" id="sitemap_type_{$type}" {if $row['enabled']}checked{/if}>
                    </div>
                  </div>
                {elseif $row['enabled']}
                  <input type="hidden" name="sitemap_types[]" value="{$type}">
                {/if}
              {/foreach}
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
  <!-- settings -->

  <!-- robots -->
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="Robots" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/sitemap.php?do=robots">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          {if $robots_file}
            <div class="alert alert-warning [overflow-wrap:anywhere]" role="alert">{__("A robots.txt file exists in your website folder and is served instead of these rules, delete that file to use them")}</div>
          {/if}
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="robots_txt">robots.txt</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <textarea class="textarea w-full font-mono" name="robots_txt" id="robots_txt" rows="12" aria-describedby="robots_txt-help">{$system['robots_txt']}</textarea>
                  <div class="admin-setting-help text-sm leading-relaxed" id="robots_txt-help">{__("The Sitemap line is added automatically while the sitemap is enabled")} &middot; <a class="link link-animated" href="{$system['system_url']}/robots.txt" target="_blank">{$system['system_url']}/robots.txt</a></div>
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
  <!-- robots -->

  <!-- llms -->
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="LLMs" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/sitemap.php?do=llms">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="llms_enabled">{__("llms.txt Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="llms_enabled-help">{__("Publish a short guide to your website for AI assistants")} &middot; <a class="link link-animated" href="{$system['system_url']}/llms.txt" target="_blank">{$system['system_url']}/llms.txt</a></div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="llms_enabled" id="llms_enabled" {if $system['llms_enabled']}checked{/if} aria-describedby="llms_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="llms_notes">{__("Notes")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <textarea class="textarea w-full font-mono" name="llms_notes" id="llms_notes" rows="6" aria-describedby="llms_notes-help">{$system['llms_notes']}</textarea>
                  <div class="admin-setting-help text-sm leading-relaxed" id="llms_notes-help">{__("Optional Markdown added at the end of the file")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2">
                <div class="label-text">{__("Preview")}</div>
                <div class="admin-tools-code"><code>{$llms_txt|escape}</code></div>
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
  <!-- llms -->
</section>