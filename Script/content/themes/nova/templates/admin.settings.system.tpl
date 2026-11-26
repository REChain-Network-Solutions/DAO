<section class="admin-settings-page" aria-labelledby="system-settings-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="system-settings-title" class="text-2xl font-semibold">{__("System Settings")}</h1>
    <p class="text-base-content/60 text-sm">{__("Manage your website configuration and features.")}</p>
  </div>
  <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("System Settings")}" aria-orientation="vertical">
    <button type="button" id="settings-tab-general" class="tab active-tab:tab-active active" data-tab="#General" aria-controls="General" role="tab" aria-selected="true"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("General")}</button>
    <button type="button" id="settings-tab-seo" class="tab active-tab:tab-active" data-tab="#SEO" aria-controls="SEO" role="tab" aria-selected="false"><span class="icon-[tabler--search] size-4" aria-hidden="true"></span>{__("SEO")}</button>
    <button type="button" id="settings-tab-modules" class="tab active-tab:tab-active" data-tab="#Modules" aria-controls="Modules" role="tab" aria-selected="false"><span class="icon-[tabler--cube] size-4" aria-hidden="true"></span>{__("Modules")}</button>
    <button type="button" id="settings-tab-features" class="tab active-tab:tab-active" data-tab="#Features" aria-controls="Features" role="tab" aria-selected="false"><span class="icon-[tabler--adjustments] size-4" aria-hidden="true"></span>{__("Features")}</button>
  </nav>
  <div id="General" class="admin-settings-panel js_admin-settings-panel" role="tabpanel" aria-labelledby="settings-tab-general" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=general">
            <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">

        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-general-0">
          <h3 id="settings-general-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Website availability")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="website_live" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="system_live">{__("Website Live")}</label>
                <div id="system_live-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the entire website On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="system_live-help" type="checkbox" class="switch switch-primary" name="system_live" id="system_live" {if $system['system_live']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_message">
                {__("Shutdown Message")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_message-help" id="system_message" class="textarea w-full" name="system_message" rows="3">{$system['system_message']}</textarea>
                <div id="system_message-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("The text that is presented when the site is closed")}
                </div>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-general-1">
          <h3 id="settings-general-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Contact")}
          </h3>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_email">
                {__("System Email")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                  <input aria-describedby="system_email-help" type="text" id="system_email" class="input w-full" name="system_email" value="{$system['system_email']}">
                {else}
                  <input aria-describedby="system_email-help" type="password" id="system_email" class="input w-full" value="*********">
                {/if}
                <div id="system_email-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("The contact email that all messages send to")}
                </div>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-general-2">
          <h3 id="settings-general-2" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Regional defaults")}
          </h3>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_datetime_format">
                {__("System Datetime Format")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select aria-describedby="system_datetime_format-help" id="system_datetime_format" class="select w-full" name="system_datetime_format">
                  <option {if $system['system_datetime_format'] == "d/m/Y H:i"}selected{/if} value="d/m/Y H:i">d/m/Y H:i ({__("Example")}: 30/05/2023 01:30 PM)</option>
                  <option {if $system['system_datetime_format'] == "m/d/Y H:i"}selected{/if} value="m/d/Y H:i">m/d/Y H:i ({__("Example")}: 05/30/2023 01:30 PM)</option>
                </select>
                <div id="system_datetime_format-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Select the datetime format of the datetime picker")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_distance">
                {__("System Distance Unit")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select aria-describedby="system_distance-help" id="system_distance" class="select w-full" name="system_distance">
                  <option {if $system['system_distance'] == "mile"}selected{/if} value="mile">{__("Mile")}</option>
                  <option {if $system['system_distance'] == "kilometer"}selected{/if} value="kilometer">{__("Kilometer")}</option>
                </select>
                <div id="system_distance-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Select the distance measure unit of your website")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_currency">
                {__("System Currency")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select aria-describedby="system_currency-help" id="system_currency" class="select w-full" name="system_currency">
                  {foreach $system_currencies as $currency}
                    <option {if $currency['default']}selected{/if} value="{$currency['currency_id']}">
                      {$currency['name']} ({$currency['code']})
                    </option>
                  {/foreach}
                </select>
                <div id="system_currency-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("This will be used to display prices on your website as default currency")}<br>
                  {__("You can add, edit or delete currencies from")} <a href="{$system['system_url']}/{$control_panel['url']}/currencies">{__("Currencies")}</a>
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_country">
                {__("System Country")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select aria-describedby="system_country-help" id="system_country" class="select w-full" name="system_country">
                  {foreach $countries as $country}
                    <option {if $country['default']}selected{/if} value="{$country['country_id']}">{$country['country_name_with_flag']}</option>
                  {/foreach}
                </select>
                <div id="system_country-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("This will be used as a default country for your website")}<br>
                  {__("You can add, edit or delete countries from")} <a href="{$system['system_url']}/{$control_panel['url']}/countries">{__("Countries")}</a>
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_language">
                {__("System Language")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select aria-describedby="system_language-help" id="system_language" class="select w-full" name="system_language">
                  {foreach $languages as $language}
                    <option {if $language['default']}selected{/if} value="{$language['language_id']}">{$language['title']}</option>
                  {/foreach}
                </select>
                <div id="system_language-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("This will be used as a default language for your website")}<br>
                  {__("You can add, edit or delete languages from")} <a href="{$system['system_url']}/{$control_panel['url']}/languages">{__("Languages")}</a>
                </div>
              </div>
            </div>
        </div>
            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
        <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
          <div class="alert alert-success" role="status" style="display: none"></div>
          <div class="alert alert-error alert-danger" role="alert" style="display: none"></div>
        </div>
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
          </section>
        </div>
      </div>
    </form>
  </div>
  <div id="SEO" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="settings-tab-seo" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=seo">
            <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <div class="alert alert-info items-center! [overflow-wrap:anywhere] max-sm:flex-wrap" role="status"><span class="min-w-0 flex-1">{__("You can also manage your XML sitemap, robots.txt and llms.txt from")}</span> <a class="btn btn-sm btn-info shrink-0 max-sm:w-full" href="{$system['system_url']}/{$control_panel['url']}/sitemap">{__("Sitemap")}</a></div>
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">

        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-seo-0">
          <h3 id="settings-seo-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Public visibility")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="website_public" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="system_public">{__("Website Public")}</label>
                <div id="system_public-help" class="admin-setting-help text-sm leading-relaxed">{__("Make the website public to allow non logged users to view website content")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="system_public-help" type="checkbox" class="switch switch-primary" name="system_public" id="system_public" {if $system['system_public']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="newsfeed" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="newsfeed_public">{__("Newsfeed Public")}</label>
                <div id="newsfeed_public-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Make the newsfeed available for visitors in landing page")}<br>
                  {__("Enable this will make your website public and list only public posts")}
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="newsfeed_public-help" type="checkbox" class="switch switch-primary" name="newsfeed_public" id="newsfeed_public" {if $system['newsfeed_public']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="directory" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="directory_enabled"> {__("Directory")}</label>
                <div id="directory_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Enable the directory for better SEO results")}<br>
                  {__("Make the website public to allow non logged users to view website content")}
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="directory_enabled-help" type="checkbox" class="switch switch-primary" name="directory_enabled" id="directory_enabled" {if $system['directory_enabled']}checked{/if}>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-seo-1">
          <h3 id="settings-seo-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Website metadata")}
          </h3>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_title">
                {__("Website Title")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input aria-describedby="system_title-help" type="text" id="system_title" class="input w-full" name="system_title" value="{__($system['system_title'])}">
                <div id="system_title-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Title of your website")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description">
                {__("Website Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description-help" id="system_description" class="textarea w-full" name="system_description" rows="3">{$system['system_description']}</textarea>
                <div id="system_description-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your website")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_keywords">
                {__("Website Keywords")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_keywords-help" id="system_keywords" class="textarea w-full" name="system_keywords" rows="3">{$system['system_keywords']}</textarea>
                <div id="system_keywords-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Example: social, social site")}
                </div>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-seo-2">
          <h3 id="settings-seo-2" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Module descriptions")}
          </h3>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_directory">
                {__("Directory Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_directory-help" id="system_description_directory" class="textarea w-full" name="system_description_directory" rows="3">{$system['system_description_directory']}</textarea>
                <div id="system_description_directory-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your Directory")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_pages">
                {__("Pages Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_pages-help" id="system_description_pages" class="textarea w-full" name="system_description_pages" rows="3">{$system['system_description_pages']}</textarea>
                <div id="system_description_pages-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your pages module")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_groups">
                {__("Groups Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_groups-help" id="system_description_groups" class="textarea w-full" name="system_description_groups" rows="3">{$system['system_description_groups']}</textarea>
                <div id="system_description_groups-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your groups module")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_events">
                {__("Events Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_events-help" id="system_description_events" class="textarea w-full" name="system_description_events" rows="3">{$system['system_description_events']}</textarea>
                <div id="system_description_events-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your events module")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_watch">
                {__("Watch Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_watch-help" id="system_description_watch" class="textarea w-full" name="system_description_watch" rows="3">{$system['system_description_watch']}</textarea>
                <div id="system_description_watch-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your watch module")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_live">
                {__("Live Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_live-help" id="system_description_live" class="textarea w-full" name="system_description_live" rows="3">{$system['system_description_live']}</textarea>
                <div id="system_description_live-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your live module")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_blogs">
                {__("Blogs Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_blogs-help" id="system_description_blogs" class="textarea w-full" name="system_description_blogs" rows="3">{$system['system_description_blogs']}</textarea>
                <div id="system_description_blogs-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your blogs module")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_marketplace">
                {__("Marketplace Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_marketplace-help" id="system_description_marketplace" class="textarea w-full" name="system_description_marketplace" rows="3">{$system['system_description_marketplace']}</textarea>
                <div id="system_description_marketplace-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your marketplace module")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_funding">
                {__("Funding Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_funding-help" id="system_description_funding" class="textarea w-full" name="system_description_funding" rows="3">{$system['system_description_funding']}</textarea>
                <div id="system_description_funding-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your funding module")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_offers">
                {__("Offers Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_offers-help" id="system_description_offers" class="textarea w-full" name="system_description_offers" rows="3">{$system['system_description_offers']}</textarea>
                <div id="system_description_offers-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your offer module")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_jobs">
                {__("Jobs Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_jobs-help" id="system_description_jobs" class="textarea w-full" name="system_description_jobs" rows="3">{$system['system_description_jobs']}</textarea>
                <div id="system_description_jobs-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your jobs module")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_courses">
                {__("Courses Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_courses-help" id="system_description_courses" class="textarea w-full" name="system_description_courses" rows="3">{$system['system_description_courses']}</textarea>
                <div id="system_description_courses-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your courses module")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_forums">
                {__("Forums Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_forums-help" id="system_description_forums" class="textarea w-full" name="system_description_forums" rows="3">{$system['system_description_forums']}</textarea>
                <div id="system_description_forums-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your forums module")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_movies">
                {__("Movies Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_movies-help" id="system_description_movies" class="textarea w-full" name="system_description_movies" rows="3">{$system['system_description_movies']}</textarea>
                <div id="system_description_movies-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your movies module")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_description_games">
                {__("Games Description")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea aria-describedby="system_description_games-help" id="system_description_games" class="textarea w-full" name="system_description_games" rows="3">{$system['system_description_games']}</textarea>
                <div id="system_description_games-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Description of your games module")}
                </div>
              </div>
            </div>
        </div>
            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
        <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
          <div class="alert alert-success" role="status" style="display: none"></div>
          <div class="alert alert-error alert-danger" role="alert" style="display: none"></div>
        </div>
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
          </section>
        </div>
      </div>
    </form>
  </div>
  <div id="Modules" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="settings-tab-modules" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=modules">
            <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">

        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-modules-0">
          <h3 id="settings-modules-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Pages")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="pages" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="pages_enabled">{__("Pages")}</label>
                <div id="pages_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the pages On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="pages_enabled-help" type="checkbox" class="switch switch-primary" name="pages_enabled" id="pages_enabled" {if $system['pages_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="star" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="pages_reviews_enabled">{__("Pages Reviews")}</label>
                <div id="pages_reviews_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the pages reviews On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="pages_reviews_enabled-help" type="checkbox" class="switch switch-primary" name="pages_reviews_enabled" id="pages_reviews_enabled" {if $system['pages_reviews_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="chat" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="pages_messages_enabled">{__("Pages Messages")}</label>
                <div id="pages_messages_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Allow pages admins to receive messages from users")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="pages_messages_enabled-help" type="checkbox" class="switch switch-primary" name="pages_messages_enabled" id="pages_messages_enabled" {if $system['pages_messages_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="star" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="pages_reviews_replacement_enabled">{__("Pages Review Replacement")}</label>
                <div id="pages_reviews_replacement_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Enbale this to allow user to change his review")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="pages_reviews_replacement_enabled-help" type="checkbox" class="switch switch-primary" name="pages_reviews_replacement_enabled" id="pages_reviews_replacement_enabled" {if $system['pages_reviews_replacement_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="user_information" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="pages_pbid_enabled">{__("Pages Business ID (PBID)")}</label>
                <div id="pages_pbid_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Turn the page business ID On and Off")}<br>
                  {__("PBID is a unique ID for each page consists of 16 digits from country code and category id and page id")}
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="pages_pbid_enabled-help" type="checkbox" class="switch switch-primary" name="pages_pbid_enabled" id="pages_pbid_enabled" {if $system['pages_pbid_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="map" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="pages_location_filter_enabled">{__("Pages Country Filter")}</label>
                <div id="pages_location_filter_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Turn the pages country filter On and Off")}
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="pages_location_filter_enabled-help" type="checkbox" class="switch switch-primary" name="pages_location_filter_enabled" id="pages_location_filter_enabled" {if $system['pages_location_filter_enabled']}checked{/if}>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-modules-1">
          <h3 id="settings-modules-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Groups")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="groups" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="groups_enabled">{__("Groups")}</label>
                <div id="groups_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the groups On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="groups_enabled-help" type="checkbox" class="switch switch-primary" name="groups_enabled" id="groups_enabled" {if $system['groups_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="star" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="groups_reviews_enabled">{__("Groups Reviews")}</label>
                <div id="groups_reviews_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the groups reviews On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="groups_reviews_enabled-help" type="checkbox" class="switch switch-primary" name="groups_reviews_enabled" id="groups_reviews_enabled" {if $system['groups_reviews_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="star" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="groups_reviews_replacement_enabled">{__("Groups Review Replacement")}</label>
                <div id="groups_reviews_replacement_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Enbale this to allow user to change his review")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="groups_reviews_replacement_enabled-help" type="checkbox" class="switch switch-primary" name="groups_reviews_replacement_enabled" id="groups_reviews_replacement_enabled" {if $system['groups_reviews_replacement_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="map" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="groups_location_filter_enabled">{__("Groups Country Filter")}</label>
                <div id="groups_location_filter_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Turn the groups country filter On and Off")}
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="groups_location_filter_enabled-help" type="checkbox" class="switch switch-primary" name="groups_location_filter_enabled" id="groups_location_filter_enabled" {if $system['groups_location_filter_enabled']}checked{/if}>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-modules-2">
          <h3 id="settings-modules-2" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Events")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="events" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="events_enabled">{__("Events")}</label>
                <div id="events_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the events On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="events_enabled-help" type="checkbox" class="switch switch-primary" name="events_enabled" id="events_enabled" {if $system['events_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="events" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="pages_events_enabled">{__("Pages Events")}</label>
                <div id="pages_events_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Allow pages to create events")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="pages_events_enabled-help" type="checkbox" class="switch switch-primary" name="pages_events_enabled" id="pages_events_enabled" {if $system['pages_events_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="star" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="events_reviews_enabled">{__("Events Reviews")}</label>
                <div id="events_reviews_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the events reviews On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="events_reviews_enabled-help" type="checkbox" class="switch switch-primary" name="events_reviews_enabled" id="events_reviews_enabled" {if $system['events_reviews_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="star" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="events_reviews_replacement_enabled">{__("Events Review Replacement")}</label>
                <div id="events_reviews_replacement_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Enbale this to allow user to change his review")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="events_reviews_replacement_enabled-help" type="checkbox" class="switch switch-primary" name="events_reviews_replacement_enabled" id="events_reviews_replacement_enabled" {if $system['events_reviews_replacement_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="map" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="events_location_filter_enabled">{__("Events Country Filter")}</label>
                <div id="events_location_filter_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Turn the events country filter On and Off")}
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="events_location_filter_enabled-help" type="checkbox" class="switch switch-primary" name="events_location_filter_enabled" id="events_location_filter_enabled" {if $system['events_location_filter_enabled']}checked{/if}>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-modules-4">
          <h3 id="settings-modules-4" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Reels")} & {__("Watch")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="reels" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="reels_enabled">{__("Reels")}</label>
                <div id="reels_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Turn the reels On and Off")}
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="reels_enabled-help" type="checkbox" class="switch switch-primary" name="reels_enabled" id="reels_enabled" {if $system['reels_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="watch" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="watch_enabled">{__("Watch")}</label>
                <div id="watch_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Turn the watch videos On and Off")}<br>
                  {__("Watch module will show all public videos at one place")}
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="watch_enabled-help" type="checkbox" class="switch switch-primary" name="watch_enabled" id="watch_enabled" {if $system['watch_enabled']}checked{/if}>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-modules-5">
          <h3 id="settings-modules-5" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Blogs")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="blogs" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="blogs_enabled">{__("Blogs")}</label>
                <div id="blogs_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the blogs On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="blogs_enabled-help" type="checkbox" class="switch switch-primary" name="blogs_enabled" id="blogs_enabled" {if $system['blogs_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="widget" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="blogs_widget_enabled">{__("Blogs Widget")}</label>
                <div id="blogs_widget_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Enbale latest blogs carousel widget to be displayed on the home page")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="blogs_widget_enabled-help" type="checkbox" class="switch switch-primary" name="blogs_widget_enabled" id="blogs_widget_enabled" {if $system['blogs_widget_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="newsfeed" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="blogs_rss_enabled">{__("RSS")}</label>
                <div id="blogs_rss_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the blogs RSS feed On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="blogs_rss_enabled-help" type="checkbox" class="switch switch-primary" name="blogs_rss_enabled" id="blogs_rss_enabled" {if $system['blogs_rss_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="posts_discover" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="blogs_search_content_enabled">{__("Search Content")}</label>
                <div id="blogs_search_content_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Search inside blog posts, not only the title and tags")}</div>
                {if !$system['posts_search_ready']}
                  <div class="admin-setting-help text-sm leading-relaxed">{__("The search index is still being built")} (<a class="link link-primary" href="{$system['system_url']}/{$control_panel['url']}/tools/search-index">{__("Search Index")}</a>)</div>
                {/if}
              </div>
              <div class="text-end">
                <input aria-describedby="blogs_search_content_enabled-help" type="checkbox" class="switch switch-primary" name="blogs_search_content_enabled" id="blogs_search_content_enabled" {if $system['blogs_search_content_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="photos" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="blogs_cover_required">{__("Cover Required")}</label>
                <div id="blogs_cover_required-help" class="admin-setting-help text-sm leading-relaxed">{__("Users must upload a cover image before publishing a blog")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="blogs_cover_required-help" type="checkbox" class="switch switch-primary" name="blogs_cover_required" id="blogs_cover_required" {if $system['blogs_cover_required']}checked{/if}>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-modules-6">
          <h3 id="settings-modules-6" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Listings")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="offers" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="offers_enabled">{__("Offers")}</label>
                <div id="offers_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Turn the offers On and Off")}<br>
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="offers_enabled-help" type="checkbox" class="switch switch-primary" name="offers_enabled" id="offers_enabled" {if $system['offers_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="jobs" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="jobs_enabled">{__("Jobs")}</label>
                <div id="jobs_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Turn the jobs On and Off")}<br>
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="jobs_enabled-help" type="checkbox" class="switch switch-primary" name="jobs_enabled" id="jobs_enabled" {if $system['jobs_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="courses" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="courses_enabled">{__("Courses")}</label>
                <div id="courses_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Turn the courses On and Off")}<br>
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="courses_enabled-help" type="checkbox" class="switch switch-primary" name="courses_enabled" id="courses_enabled" {if $system['courses_enabled']}checked{/if}>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-modules-7">
          <h3 id="settings-modules-7" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Forums")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="forums" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="forums_enabled">{__("Forums")}</label>
                <div id="forums_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the forums On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="forums_enabled-help" type="checkbox" class="switch switch-primary" name="forums_enabled" id="forums_enabled" {if $system['forums_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="user_online" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="forums_online_enabled">{__("Online Users")}</label>
                <div id="forums_online_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Show forums online users")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="forums_online_enabled-help" type="checkbox" class="switch switch-primary" name="forums_online_enabled" id="forums_online_enabled" {if $system['forums_online_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="stats" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="forums_statistics_enabled">{__("Statistics")}</label>
                <div id="forums_statistics_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Show forums statistics")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="forums_statistics_enabled-help" type="checkbox" class="switch switch-primary" name="forums_statistics_enabled" id="forums_statistics_enabled" {if $system['forums_statistics_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="newsfeed" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="forums_rss_enabled">{__("RSS")}</label>
                <div id="forums_rss_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the forums RSS feed On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="forums_rss_enabled-help" type="checkbox" class="switch switch-primary" name="forums_rss_enabled" id="forums_rss_enabled" {if $system['forums_rss_enabled']}checked{/if}>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-modules-8">
          <h3 id="settings-modules-8" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Entertainment")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="movies" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="movies_enabled">{__("Movies")}</label>
                <div id="movies_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the movies On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="movies_enabled-help" type="checkbox" class="switch switch-primary" name="movies_enabled" id="movies_enabled" {if $system['movies_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="games" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="games_enabled">{__("Games")}</label>
                <div id="games_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the games On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="games_enabled-help" type="checkbox" class="switch switch-primary" name="games_enabled" id="games_enabled" {if $system['games_enabled']}checked{/if}>
              </div>
            </div>
        </div>
            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
        <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
          <div class="alert alert-success" role="status" style="display: none"></div>
          <div class="alert alert-error alert-danger" role="alert" style="display: none"></div>
        </div>
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
          </section>
        </div>
      </div>
    </form>
  </div>
  <div id="Features" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="settings-tab-features" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=features">
            <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">

        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-features-0">
          <h3 id="settings-features-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Language and location")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="language" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="auto_language_detection">{__("Auto Language Detection")}</label>
                <div id="auto_language_detection-help" class="admin-setting-help text-sm leading-relaxed">{__("If enabled sytem will detect user language automatically")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="auto_language_detection-help" type="checkbox" class="switch switch-primary" name="auto_language_detection" id="auto_language_detection" {if $system['auto_language_detection']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="map" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="location_finder_enabled">{__("Fliter by Geolocation")}</label>
                <div id="location_finder_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("If enabled user will able to filter people, products ... etc by Geolocation")}<br>
                  {__("System will use your browser's geolocation feature to detect the user's current location (latitude and longitude)")}
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="location_finder_enabled-help" type="checkbox" class="switch switch-primary" name="location_finder_enabled" id="location_finder_enabled" {if $system['location_finder_enabled']}checked{/if}>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-features-1">
          <h3 id="settings-features-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Contact and support")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="contat_us" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="contact_enabled">{__("Contact Us")}</label>
                <div id="contact_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the contact us page On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="contact_enabled-help" type="checkbox" class="switch switch-primary" name="contact_enabled" id="contact_enabled" {if $system['contact_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="support" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="support_center_enabled">{__("Support Center")}</label>
                <div id="support_center_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the support tickets center On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="support_center_enabled-help" type="checkbox" class="switch switch-primary" name="support_center_enabled" id="support_center_enabled" {if $system['support_center_enabled']}checked{/if}>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-features-2">
          <h3 id="settings-features-2" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Daytime messages")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="dark_light" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="daytime_msg_enabled">{__("DayTime Messages")}</label>
                <div id="daytime_msg_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the DayTime Messages (Good Morning, Afternoon, Evening) On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="daytime_msg_enabled-help" type="checkbox" class="switch switch-primary" name="daytime_msg_enabled" id="daytime_msg_enabled" {if $system['daytime_msg_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_morning_message">
                {__("Morning Message")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea id="system_morning_message" class="textarea w-full" name="system_morning_message" rows="3">{$system['system_morning_message']}</textarea>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_afternoon_message">
                {__("Afternoon Message")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea id="system_afternoon_message" class="textarea w-full" name="system_afternoon_message" rows="3">{$system['system_afternoon_message']}</textarea>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="system_evening_message">
                {__("Evening Message")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea id="system_evening_message" class="textarea w-full" name="system_evening_message" rows="3">{$system['system_evening_message']}</textarea>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-features-3">
          <h3 id="settings-features-3" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Social interactions")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="poke" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="pokes_enabled">{__("Pokes")}</label>
                <div id="pokes_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Enable users to poke each others")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="pokes_enabled-help" type="checkbox" class="switch switch-primary" name="pokes_enabled" id="pokes_enabled" {if $system['pokes_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="gifts" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="gifts_enabled">{__("Gifts")}</label>
                <div id="gifts_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Enable users to send gifts to each others")}<br>
                  {__("Make sure you have configured")} <a href="{$system['system_url']}/{$control_panel['url']}/gifts">{__("Gifts")}</a>
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="gifts_enabled-help" type="checkbox" class="switch switch-primary" name="gifts_enabled" id="gifts_enabled" {if $system['gifts_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="points" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="gifts_points_enabled">{__("Gifts with Points")}</label>
                <div id="gifts_points_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Enable users to send gifts with points to each others")}<br>
                  {__("Make sure you have configured")} <a href="{$system['system_url']}/{$control_panel['url']}/points">{__("Points System")}</a>
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="gifts_points_enabled-help" type="checkbox" class="switch switch-primary" name="gifts_points_enabled" id="gifts_points_enabled" {if $system['gifts_points_enabled']}checked{/if}>
              </div>
            </div>
        </div>
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-features-4">
          <h3 id="settings-features-4" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Privacy and visitor controls")}
          </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="spy" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="incognito_mode_enabled">{__("Incognito Mode")}</label>
                <div id="incognito_mode_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Incognito mode will hide any user from the searh results")}<br>
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="incognito_mode_enabled-help" type="checkbox" class="switch switch-primary" name="incognito_mode_enabled" id="incognito_mode_enabled" {if $system['incognito_mode_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="panic" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="panic_mode_enabled">{__("Panic Mode")}</label>
                <div id="panic_mode_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Panic mode will hide all website content and show only the Google Search")}<br>
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="panic_mode_enabled-help" type="checkbox" class="switch switch-primary" name="panic_mode_enabled" id="panic_mode_enabled" {if $system['panic_mode_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="cookie" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="cookie_consent_enabled">{__("Cookie Consent")} ({__("GDPR")})</label>
                <div id="cookie_consent_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Turn the cookie consent notification On and Off")}</div>
              </div>
              <div class="text-end">
                <input aria-describedby="cookie_consent_enabled-help" type="checkbox" class="switch switch-primary" name="cookie_consent_enabled" id="cookie_consent_enabled" {if $system['cookie_consent_enabled']}checked{/if}>
              </div>
            </div>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="adblock" class="admin-setting-glyph" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="adblock_detector_enabled">{__("Adblock Detector")}</label>
                <div id="adblock_detector_enabled-help" class="admin-setting-help text-sm leading-relaxed">
                  {__("Turn the Adblock auto detector notification On and Off")}, {__("(Note: Admin is exception)")}<br>
                  {__("Red block message will appear to make user disable adblock from his browser")}<br>
                </div>
              </div>
              <div class="text-end">
                <input aria-describedby="adblock_detector_enabled-help" type="checkbox" class="switch switch-primary" name="adblock_detector_enabled" id="adblock_detector_enabled" {if $system['adblock_detector_enabled']}checked{/if}>
              </div>
            </div>
        </div>
            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
        <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
          <div class="alert alert-success" role="status" style="display: none"></div>
          <div class="alert alert-error alert-danger" role="alert" style="display: none"></div>
        </div>
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
          </section>
        </div>
      </div>
    </form>
  </div>
</section>
