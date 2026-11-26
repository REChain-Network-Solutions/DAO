<section class="admin-settings-page" aria-labelledby="admin-tools-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="admin-tools-title" class="text-2xl font-semibold">
      {if $sub_view == "faker"}
        {__("Fake Generator")}
      {elseif $sub_view == "auto-connect"}
        {__("Auto Connect")}
        {capture assign="_tip"}{__("Before add custom auto-connect make sure you enabled getting started and location data is required")}{/capture}
        {include file='__admin_tip.tpl' _tip_id="admin-auto-connect-tip" _tip_text=$_tip}
      {elseif $sub_view == "garbage-collector"}
        {__("Garbage Collector")}
      {elseif $sub_view == "search-index"}
        {__("Search Index")}
      {elseif $sub_view == "backups"}
        {__("Backup Database & Files")}
      {elseif $sub_view == "cronjob"}
        {__("Cronjob")}
      {elseif $sub_view == "reset"}
        {__("Factory Reset")}
      {/if}
    </h1>
    <p class="text-base-content/60 text-sm">
      {if $sub_view == "faker"}
        {__("Generate sample users, pages and groups to populate the website.")}
      {elseif $sub_view == "auto-connect"}
        {__("Choose who new accounts follow, friend, like and join on signup.")}
      {elseif $sub_view == "garbage-collector"}
        {__("Clean up stale accounts, posts and uploads in bulk.")}
      {elseif $sub_view == "search-index"}
        {__("Build the index that posts search uses.")}
      {elseif $sub_view == "backups"}
        {__("Generate a backup of the database, the uploaded files, or both.")}
      {elseif $sub_view == "cronjob"}
        {__("Pick the daily tasks and wire the command into your server.")}
      {elseif $sub_view == "reset"}
        {__("Wipe all content and start over from a fresh installation.")}
      {/if}
    </p>
  </div>

    {if $sub_view == "faker"}

      <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Fake Generator")}" aria-orientation="vertical">
        <button type="button" id="tools-faker-tab-users" class="tab active-tab:tab-active active" data-tab="#faker_users" aria-controls="faker_users" role="tab" aria-selected="true"><span class="icon-[tabler--user] size-4" aria-hidden="true"></span>{__("Users")}</button>
        <button type="button" id="tools-faker-tab-pages" class="tab active-tab:tab-active" data-tab="#faker_pages" aria-controls="faker_pages" role="tab" aria-selected="false"><span class="icon-[tabler--flag] size-4" aria-hidden="true"></span>{__("Pages")}</button>
        <button type="button" id="tools-faker-tab-groups" class="tab active-tab:tab-active" data-tab="#faker_groups" aria-controls="faker_groups" role="tab" aria-selected="false"><span class="icon-[tabler--users] size-4" aria-hidden="true"></span>{__("Groups")}</button>
      </nav>

      <div id="faker_users" class="admin-settings-panel js_admin-settings-panel" role="tabpanel" aria-labelledby="tools-faker-tab-users" tabindex="0">
        <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/tools.php?do=faker&handle=users">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="faker-users-title">
              <h2 id="faker-users-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--user] size-5" aria-hidden="true"></span>
                {__("Generate Users")}
              </h2>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="profile" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="users_random_avatar">{__("Random Pictures")}</label>
                  <div id="users_random_avatar-help" class="admin-setting-help text-sm leading-relaxed">{__("Profile pictures will be generated randomly and may be dublicated")}</div>
                </div>
                <div class="text-end">
                  <input aria-describedby="users_random_avatar-help" type="checkbox" class="switch switch-primary" name="random_avatar" id="users_random_avatar">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="faker-users-num">{__("Number of Users")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="number" class="input w-full" name="users_num" id="faker-users-num" value="10" aria-describedby="faker-users-num-help">
                  <div id="faker-users-num-help" class="admin-setting-help text-sm leading-relaxed">{__("How many users you want to generate (Maximum is 1000 per request)")}</div>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="faker-users-password">{__("Password")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="default_password" id="faker-users-password" autocomplete="off" aria-describedby="faker-users-password-help">
                  <div id="faker-users-password-help" class="admin-setting-help text-sm leading-relaxed">{__("This password will be used for all generated accounts (Default is 123456789)")}</div>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="faker-users-names-language">{__("Names Language")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="names_language" id="faker-users-names-language" aria-describedby="faker-users-names-language-help">
                    {foreach $system['languages'] as $language}
                      {$parts = explode('_', $language['code'])}
                      <option {if $system['default_language']['language_id'] == $language['language_id']}selected{/if} value="{$parts[0]}_{strtoupper($parts[1])}">{$language['title']}</option>
                    {/foreach}
                  </select>
                  <div id="faker-users-names-language-help" class="admin-setting-help text-sm leading-relaxed">{__("Select the language of generated names")}</div>
                </div>
              </div>
            </div>

            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
              <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
              </div>
              <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                <button type="submit" class="btn btn-primary">
                  <span class="icon-[tabler--bolt] size-4" aria-hidden="true"></span>
                  {__("Generate")}
                </button>
              </div>
            </div>
          </section>
        </form>
      </div>

      <div id="faker_pages" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="tools-faker-tab-pages" tabindex="0">
        <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/tools.php?do=faker&handle=pages">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="faker-pages-title">
              <h2 id="faker-pages-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--flag] size-5" aria-hidden="true"></span>
                {__("Generate Pages")}
              </h2>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="profile" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="pages_random_avatar">{__("Random Pictures")}</label>
                  <div id="pages_random_avatar-help" class="admin-setting-help text-sm leading-relaxed">{__("Profile pictures will be generated randomly and may be dublicated")}</div>
                </div>
                <div class="text-end">
                  <input aria-describedby="pages_random_avatar-help" type="checkbox" class="switch switch-primary" name="random_avatar" id="pages_random_avatar">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="faker-pages-num">{__("Number of Pages")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="number" class="input w-full" name="pages_num" id="faker-pages-num" value="10" aria-describedby="faker-pages-num-help">
                  <div id="faker-pages-num-help" class="admin-setting-help text-sm leading-relaxed">{__("How many pages you want to generate (Maximum is 1000 per request)")}</div>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="faker-pages-names-language">{__("Names Language")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="names_language" id="faker-pages-names-language" aria-describedby="faker-pages-names-language-help">
                    {foreach $system['languages'] as $language}
                      {$parts = explode('_', $language['code'])}
                      <option {if $system['default_language']['language_id'] == $language['language_id']}selected{/if} value="{$parts[0]}_{strtoupper($parts[1])}">{$language['title']}</option>
                    {/foreach}
                  </select>
                  <div id="faker-pages-names-language-help" class="admin-setting-help text-sm leading-relaxed">{__("Select the language of generated names")}</div>
                </div>
              </div>

              <div class="grid min-w-0 gap-5 md:grid-cols-2">
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="faker-pages-category">{__("Page Category")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <select class="select w-full" name="category" id="faker-pages-category">
                      <option>{__("Select Category")}</option>
                      {foreach $pages_categories as $category}
                        {include file='__categories.recursive_options.tpl'}
                      {/foreach}
                    </select>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="faker-pages-country">{__("Page Country")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <select class="select w-full" name="country" id="faker-pages-country">
                      <option>{__("Select Country")}</option>
                      {foreach $countries as $country}
                        <option value="{$country['country_id']}">{$country['country_name_with_flag']}</option>
                      {/foreach}
                    </select>
                  </div>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="faker-pages-language">{__("Page Language")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="language" id="faker-pages-language">
                    <option>{__("Select Language")}</option>
                    {foreach $languages as $language}
                      <option value="{$language['language_id']}">{$language['title']}</option>
                    {/foreach}
                  </select>
                </div>
              </div>
            </div>

            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
              <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
              </div>
              <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                <button type="submit" class="btn btn-primary">
                  <span class="icon-[tabler--bolt] size-4" aria-hidden="true"></span>
                  {__("Generate")}
                </button>
              </div>
            </div>
          </section>
        </form>
      </div>

      <div id="faker_groups" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="tools-faker-tab-groups" tabindex="0">
        <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/tools.php?do=faker&handle=groups">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="faker-groups-title">
              <h2 id="faker-groups-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--users] size-5" aria-hidden="true"></span>
                {__("Generate Groups")}
              </h2>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="profile" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="groups_random_avatar">{__("Random Pictures")}</label>
                  <div id="groups_random_avatar-help" class="admin-setting-help text-sm leading-relaxed">{__("Profile pictures will be generated randomly and may be dublicated")}</div>
                </div>
                <div class="text-end">
                  <input aria-describedby="groups_random_avatar-help" type="checkbox" class="switch switch-primary" name="random_avatar" id="groups_random_avatar">
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="faker-groups-num">{__("Number of Groups")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="number" class="input w-full" name="groups_num" id="faker-groups-num" value="10" aria-describedby="faker-groups-num-help">
                  <div id="faker-groups-num-help" class="admin-setting-help text-sm leading-relaxed">{__("How many groups you want to generate (Maximum is 1000 per request)")}</div>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="faker-groups-names-language">{__("Names Language")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="names_language" id="faker-groups-names-language" aria-describedby="faker-groups-names-language-help">
                    {foreach $system['languages'] as $language}
                      {$parts = explode('_', $language['code'])}
                      <option {if $system['default_language']['language_id'] == $language['language_id']}selected{/if} value="{$parts[0]}_{strtoupper($parts[1])}">{$language['title']}</option>
                    {/foreach}
                  </select>
                  <div id="faker-groups-names-language-help" class="admin-setting-help text-sm leading-relaxed">{__("Select the language of generated names")}</div>
                </div>
              </div>

              <div class="grid min-w-0 gap-5 md:grid-cols-2">
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="faker-groups-category">{__("Group Category")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <select class="select w-full" name="category" id="faker-groups-category">
                      <option>{__("Select Category")}</option>
                      {foreach $groups_categories as $category}
                        {include file='__categories.recursive_options.tpl'}
                      {/foreach}
                    </select>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="faker-groups-country">{__("Group Country")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <select class="select w-full" name="country" id="faker-groups-country">
                      <option>{__("Select Country")}</option>
                      {foreach $countries as $country}
                        <option value="{$country['country_id']}">{$country['country_name_with_flag']}</option>
                      {/foreach}
                    </select>
                  </div>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="faker-groups-language">{__("Group Language")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="language" id="faker-groups-language">
                    <option>{__("Select Language")}</option>
                    {foreach $languages as $language}
                      <option value="{$language['language_id']}">{$language['title']}</option>
                    {/foreach}
                  </select>
                </div>
              </div>
            </div>

            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
              <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
              </div>
              <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                <button type="submit" class="btn btn-primary">
                  <span class="icon-[tabler--bolt] size-4" aria-hidden="true"></span>
                  {__("Generate")}
                </button>
              </div>
            </div>
          </section>
        </form>
      </div>

    {elseif $sub_view == "auto-connect"}

      <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Auto Connect")}" aria-orientation="vertical">
        <button type="button" id="tools-auto-connect-tab-friend" class="tab active-tab:tab-active active" data-tab="#auto_connect_friend" aria-controls="auto_connect_friend" role="tab" aria-selected="true"><span class="icon-[tabler--users-plus] size-4" aria-hidden="true"></span>{__("Friend")}</button>
        <button type="button" id="tools-auto-connect-tab-follow" class="tab active-tab:tab-active" data-tab="#auto_connect_follow" aria-controls="auto_connect_follow" role="tab" aria-selected="false"><span class="icon-[tabler--user-plus] size-4" aria-hidden="true"></span>{__("Follow")}</button>
        {if $system['pages_enabled']}
        <button type="button" id="tools-auto-connect-tab-like" class="tab active-tab:tab-active" data-tab="#auto_connect_like" aria-controls="auto_connect_like" role="tab" aria-selected="false"><span class="icon-[tabler--thumb-up] size-4" aria-hidden="true"></span>{__("Like")}</button>
        {/if}
        {if $system['groups_enabled']}
        <button type="button" id="tools-auto-connect-tab-join" class="tab active-tab:tab-active" data-tab="#auto_connect_join" aria-controls="auto_connect_join" role="tab" aria-selected="false"><span class="icon-[tabler--users-group] size-4" aria-hidden="true"></span>{__("Join")}</button>
        {/if}
      </nav>

      <form class="js_ajax-forms admin-settings-form tab-content flex min-w-0 flex-col gap-4" data-url="admin/tools.php?do=auto-connect">

        <div id="auto_connect_friend" class="admin-settings-panel js_admin-settings-panel" role="tabpanel" aria-labelledby="tools-auto-connect-tab-friend" tabindex="0">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="auto-friend-title">
              <h2 id="auto-friend-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--users-plus] size-5" aria-hidden="true"></span>
                {__("Auto Friend")}
              </h2>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="friends" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="auto_friend">{__("Auto Friend")}</label>
                  <div id="auto_friend-help" class="admin-setting-help text-sm leading-relaxed">{__("When a user creates a new account, select which users you want to auto friend")}</div>
                </div>
                <div class="text-end">
                  <input aria-describedby="auto_friend-help" type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="auto_friend" id="auto_friend" {if $system['auto_friend']}checked{/if}>
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="auto-friend-nodes-title">
              <h2 id="auto-friend-nodes-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--world] size-5" aria-hidden="true"></span>
                {__("Select Users")}
              </h2>

              <div class="js_auto-friend-nodes-list flex min-w-0 flex-col gap-4">
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="auto_friend_users">{__("All Countries")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="js_tagify-ajax hidden" data-handle="users" name="auto_friend_users" id="auto_friend_users" value='{$system['auto_friend_users']}'>
                    <div class="admin-setting-help text-sm leading-relaxed">{__("Search for users you want new accounts to auto friend")} ({__("All Countries")})</div>
                  </div>
                </div>
                {if $rows['friend']}
                  {foreach $rows['friend'] as $node}
                    <div class="auto-connect-node admin-setting-field grid min-w-0 items-start gap-3 rounded-lg border border-base-300 p-4 md:grid-cols-[14rem_minmax(0,1fr)] js_admin-setting-field">
                      <select class="select w-full" name="auto_friend_country_{$node['country_id']}" aria-label="{__("Country")}">
                        {foreach $countries as $country}
                          <option {if $node['country_id'] == $country['country_id']}selected{/if} value="{$country['country_id']}">{$country['country_name_with_flag']}</option>
                        {/foreach}
                      </select>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <input type="text" class="js_tagify-ajax hidden" data-handle="users" name="auto_friend_nodes_ids_{$node['country_id']}" value='{$node['nodes_ids']}'>
                        <div class="admin-setting-help text-sm leading-relaxed">{__("Search for users you want new accounts to auto connect")} {__("to this country")}</div>
                      </div>
                    </div>
                  {/foreach}
                {/if}
              </div>

              <div>
                <button type="button" class="btn btn-outline btn-sm js_add-auto-connect-node max-sm:w-full" data-handle="friend">
                  <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
                  {__("Add Auto Friend Users For Specific Country")}
                </button>
              </div>
            </div>
          </section>
        </div>

        <div id="auto_connect_follow" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="tools-auto-connect-tab-follow" tabindex="0">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="auto-follow-title">
              <h2 id="auto-follow-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--user-plus] size-5" aria-hidden="true"></span>
                {__("Auto Follow")}
              </h2>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="followers" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="auto_follow">{__("Auto Follow")}</label>
                  <div id="auto_follow-help" class="admin-setting-help text-sm leading-relaxed">{__("When a user creates a new account, select which users you want to auto follow")}</div>
                </div>
                <div class="text-end">
                  <input aria-describedby="auto_follow-help" type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="auto_follow" id="auto_follow" {if $system['auto_follow']}checked{/if}>
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="auto-follow-nodes-title">
              <h2 id="auto-follow-nodes-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--world] size-5" aria-hidden="true"></span>
                {__("Select Users")}
              </h2>

              <div class="js_auto-follow-nodes-list flex min-w-0 flex-col gap-4">
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="auto_follow_users">{__("All Countries")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="js_tagify-ajax hidden" data-handle="users" name="auto_follow_users" id="auto_follow_users" value='{$system['auto_follow_users']}'>
                    <div class="admin-setting-help text-sm leading-relaxed">{__("Search for users you want new accounts to auto follow")} ({__("All Countries")})</div>
                  </div>
                </div>
                {if $rows['follow']}
                  {foreach $rows['follow'] as $node}
                    <div class="auto-connect-node admin-setting-field grid min-w-0 items-start gap-3 rounded-lg border border-base-300 p-4 md:grid-cols-[14rem_minmax(0,1fr)] js_admin-setting-field">
                      <select class="select w-full" name="auto_follow_country_{$node['country_id']}" aria-label="{__("Country")}">
                        {foreach $countries as $country}
                          <option {if $node['country_id'] == $country['country_id']}selected{/if} value="{$country['country_id']}">{$country['country_name_with_flag']}</option>
                        {/foreach}
                      </select>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <input type="text" class="js_tagify-ajax hidden" data-handle="users" name="auto_follow_nodes_ids_{$node['country_id']}" value='{$node['nodes_ids']}'>
                        <div class="admin-setting-help text-sm leading-relaxed">{__("Search for users you want new accounts to auto connect")} {__("to this country")}</div>
                      </div>
                    </div>
                  {/foreach}
                {/if}
              </div>

              <div>
                <button type="button" class="btn btn-outline btn-sm js_add-auto-connect-node max-sm:w-full" data-handle="follow">
                  <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
                  {__("Add Auto Follow Users For Specific Country")}
                </button>
              </div>
            </div>
          </section>
        </div>

        {if $system['pages_enabled']}
        <div id="auto_connect_like" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="tools-auto-connect-tab-like" tabindex="0">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="auto-like-title">
              <h2 id="auto-like-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--thumb-up] size-5" aria-hidden="true"></span>
                {__("Auto Like")}
              </h2>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="pages" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="auto_like">{__("Auto Like")}</label>
                  <div id="auto_like-help" class="admin-setting-help text-sm leading-relaxed">{__("When a user creates a new account, select which pages you want to auto like")}</div>
                </div>
                <div class="text-end">
                  <input aria-describedby="auto_like-help" type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="auto_like" id="auto_like" {if $system['auto_like']}checked{/if}>
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="auto-like-nodes-title">
              <h2 id="auto-like-nodes-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--world] size-5" aria-hidden="true"></span>
                {__("Select Pages")}
              </h2>

              <div class="js_auto-like-nodes-list flex min-w-0 flex-col gap-4">
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="auto_like_pages">{__("All Countries")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="js_tagify-ajax hidden" data-handle="pages" name="auto_like_pages" id="auto_like_pages" value='{$system['auto_like_pages']}'>
                    <div class="admin-setting-help text-sm leading-relaxed">{__("Search for pages you want new accounts to auto like")} ({__("All Countries")})</div>
                  </div>
                </div>
                {if $rows['like']}
                  {foreach $rows['like'] as $node}
                    <div class="auto-connect-node admin-setting-field grid min-w-0 items-start gap-3 rounded-lg border border-base-300 p-4 md:grid-cols-[14rem_minmax(0,1fr)] js_admin-setting-field">
                      <select class="select w-full" name="auto_like_country_{$node['country_id']}" aria-label="{__("Country")}">
                        {foreach $countries as $country}
                          <option {if $node['country_id'] == $country['country_id']}selected{/if} value="{$country['country_id']}">{$country['country_name_with_flag']}</option>
                        {/foreach}
                      </select>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <input type="text" class="js_tagify-ajax hidden" data-handle="pages" name="auto_like_nodes_ids_{$node['country_id']}" value='{$node['nodes_ids']}'>
                        <div class="admin-setting-help text-sm leading-relaxed">{__("Search for pages you want new accounts to auto connect")} {__("to this country")}</div>
                      </div>
                    </div>
                  {/foreach}
                {/if}
              </div>

              <div>
                <button type="button" class="btn btn-outline btn-sm js_add-auto-connect-node max-sm:w-full" data-handle="like">
                  <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
                  {__("Add Auto Like Pages For Specific Country")}
                </button>
              </div>
            </div>
          </section>
        </div>
        {/if}

        {if $system['groups_enabled']}
        <div id="auto_connect_join" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="tools-auto-connect-tab-join" tabindex="0">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="auto-join-title">
              <h2 id="auto-join-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--users-group] size-5" aria-hidden="true"></span>
                {__("Auto Join")}
              </h2>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="groups" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="auto_join">{__("Auto Join")}</label>
                  <div id="auto_join-help" class="admin-setting-help text-sm leading-relaxed">{__("When a user creates a new account, select which groups you want to auto join")}</div>
                </div>
                <div class="text-end">
                  <input aria-describedby="auto_join-help" type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="auto_join" id="auto_join" {if $system['auto_join']}checked{/if}>
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="auto-join-nodes-title">
              <h2 id="auto-join-nodes-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--world] size-5" aria-hidden="true"></span>
                {__("Select Groups")}
              </h2>

              <div class="js_auto-join-nodes-list flex min-w-0 flex-col gap-4">
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="auto_join_groups">{__("All Countries")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="js_tagify-ajax hidden" data-handle="groups" name="auto_join_groups" id="auto_join_groups" value='{$system['auto_join_groups']}'>
                    <div class="admin-setting-help text-sm leading-relaxed">{__("Search for groups you want new accounts to auto join")} ({__("All Countries")})</div>
                  </div>
                </div>
                {if $rows['join']}
                  {foreach $rows['join'] as $node}
                    <div class="auto-connect-node admin-setting-field grid min-w-0 items-start gap-3 rounded-lg border border-base-300 p-4 md:grid-cols-[14rem_minmax(0,1fr)] js_admin-setting-field">
                      <select class="select w-full" name="auto_join_country_{$node['country_id']}" aria-label="{__("Country")}">
                        {foreach $countries as $country}
                          <option {if $node['country_id'] == $country['country_id']}selected{/if} value="{$country['country_id']}">{$country['country_name_with_flag']}</option>
                        {/foreach}
                      </select>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <input type="text" class="js_tagify-ajax hidden" data-handle="groups" name="auto_join_nodes_ids_{$node['country_id']}" value='{$node['nodes_ids']}'>
                        <div class="admin-setting-help text-sm leading-relaxed">{__("Search for groups you want new accounts to auto connect")} {__("to this country")}</div>
                      </div>
                    </div>
                  {/foreach}
                {/if}
              </div>

              <div>
                <button type="button" class="btn btn-outline btn-sm js_add-auto-connect-node max-sm:w-full" data-handle="join">
                  <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
                  {__("Add Auto Join Groups For Specific Country")}
                </button>
              </div>
            </div>
          </section>
        </div>
        {/if}

        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 p-6">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
          </div>
        </section>

      </form>

    {elseif $sub_view == "garbage-collector"}

      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/tools.php?do=garbage-collector">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="garbage-collector-title">
            <h2 id="garbage-collector-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              <span class="icon-[tabler--trash] size-5" aria-hidden="true"></span>
              {__("Garbage Collector")}
              {capture assign="_tip"}{__("Garbage collector will perform the selected action and might take some time")}{/capture}
              {include file='__admin_tip.tpl' _tip_id="garbage-collector-tip" _tip_text=$_tip}
            </h2>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="garbage-collector-delete">{__("What you want to do")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="delete" id="garbage-collector-delete">
                  <optgroup label="{__("Users")}">
                    <option value="users_not_activated">{__("Delete all not activated accounts")} ({$insights['users_not_activated']} {__("user")})</option>
                    <option value="resend_activation_emails">{__("Resend Activation Emails")} ({$insights['users_not_activated']} {__("user")})</option>
                    <option value="users_not_logged_week">{__("Delete users who did not login from 1 week")} ({$insights['users_not_logged_week']} {__("user")})</option>
                    <option value="users_not_logged_month">{__("Delete users who did not login from 1 month")} ({$insights['users_not_logged_month']} {__("user")})</option>
                    <option value="users_not_logged_3_months">{__("Delete users who did not login from 3 months")} ({$insights['users_not_logged_3_months']} {__("user")})</option>
                    <option value="users_not_logged_6_months">{__("Delete users who did not login from 6 months")} ({$insights['users_not_logged_6_months']} {__("user")})</option>
                    <option value="users_not_logged_9_months">{__("Delete users who did not login from 9 months")} ({$insights['users_not_logged_9_months']} {__("user")})</option>
                    <option value="users_not_logged_year">{__("Delete users who did not login from 1 year")} ({$insights['users_not_logged_year']} {__("user")})</option>
                  </optgroup>
                  <optgroup label="{__("Posts")}">
                    <option value="posts_longer_week">{__("Delete posts that are longer than 1 week")} ({$insights['posts_longer_week']} {__("post")})</option>
                    <option value="posts_longer_month">{__("Delete posts that are longer than 1 month")} ({$insights['posts_longer_month']} {__("post")})</option>
                    <option value="posts_longer_year">{__("Delete posts that are longer than 1 year")} ({$insights['posts_longer_year']} {__("post")})</option>
                    <option value="expired_post_views">{__("Delete expired post-view history")}</option>
                    <option value="post_views_reset">{__("Reset all posts views and viewers history")}</option>
                  </optgroup>
                  <optgroup label="{__("Stories")}">
                    <option value="stories_expired">{__("Delete expired stories except highlights")} ({$insights['stories_expired']} {__("story")})</option>
                    <option value="stories_expired_all">{__("Delete all expired stories including highlights")} ({$insights['stories_expired_all']} {__("story")})</option>
                  </optgroup>
                  <optgroup label="{__("Fake Data")}">
                    <option value="fake_users">{__("Delete all fake users")} ({$insights['fake_users']} {__("user")})</option>
                    <option value="fake_pages">{__("Delete all fake pages")} ({$insights['fake_pages']} {__("page")})</option>
                    <option value="fake_groups">{__("Delete all fake groups")} ({$insights['fake_groups']} {__("group")})</option>
                  </optgroup>
                  <optgroup label="{__("Payments")}">
                    <option value="undelivered_orders">{__("Mark all shipped orders as delivered as passed the")} {$system['market_delivery_days']} {__("days")} ({$insights['undelivered_orders']} {__("order")})</option>
                    <option value="packages">{__("Reset all expired subscribers and their boosted posts and pages")}</option>
                    <option value="user_points">{__("Reset all users points")}</option>
                    <option value="user_wallets">{__("Reset all users wallet balance & transactions")}</option>
                  </optgroup>
                  <optgroup label="{__("System")}">
                    <option value="orphaned_data">{__("Delete orphaned data")}</option>
                    <option value="pending_uploads">{__("Clear pending uploads")} ({$insights['pending_uploads']} {__("files")}, {$insights['pending_uploads_size']} {__("MB")})</option>
                    <option value="clear_compiled_templates">{__("Delete compiled templates files")}</option>
                    <option value="clear_system_cache">{__("Clear system cache")}</option>
                  </optgroup>
                </select>
                <div class="admin-setting-help text-sm leading-relaxed">{__("Expired post-view history can be deleted when Unique Views uses a limited number of days. The displayed totals stay unchanged.")}</div>
                {if $system['posts_views_cleanup_time']}
                  <div class="admin-setting-help text-sm leading-relaxed">{__("Last post-view cleanup")}: {$system['posts_views_cleanup_time']|escape} — {$system['posts_views_cleanup_result']|escape}</div>
                {/if}
                {if $system['posts_views_cleanup_error']}
                  <div class="alert alert-error" role="alert">{$system['posts_views_cleanup_error']|escape}</div>
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
              <button type="submit" class="btn btn-primary">
                <span class="icon-[tabler--bolt] size-4" aria-hidden="true"></span>
                {__("Run")}
              </button>
            </div>
          </div>
        </section>
      </form>

    {elseif $sub_view == "search-index"}

      <div class="flex min-w-0 flex-col gap-6">

      <!-- stats -->
      <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon {if $system['posts_search_ready']}is-success icon-[tabler--circle-check]{else}is-warning icon-[tabler--loader-2]{/if} size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Status")}">{__("Status")}</span>
            <p class="admin-stat-value m-0 text-xl font-bold leading-tight tracking-tight sm:text-2xl">{if $system['posts_search_ready']}{__("Ready")}{else}{__("Building")}{/if}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-neutral icon-[tabler--article] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Total Posts")}">{__("Total Posts")}</span>
            <p class="admin-stat-value m-0 text-xl font-bold leading-tight tracking-tight tabular-nums sm:text-2xl">{$search_index['posts']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-info icon-[tabler--file-search] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Indexed Posts")}">{__("Indexed Posts")}</span>
            <p class="admin-stat-value m-0 text-xl font-bold leading-tight tracking-tight tabular-nums sm:text-2xl">{$search_index['indexed']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-neutral icon-[tabler--database] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Index Size")}">{__("Index Size")}</span>
            <p class="admin-stat-value m-0 text-xl font-bold leading-tight tracking-tight tabular-nums sm:text-2xl">{($search_index['size'] / 1048576)|number_format:2} {__("MB")}</p>
          </div>
        </article>
      </div>
      <!-- stats -->

      <div class="grid min-w-0 items-start gap-6 xl:grid-cols-5">

        <!-- index details -->
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none xl:col-span-3">
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="search-index-progress-title">
            <h2 id="search-index-progress-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              <span class="icon-[tabler--progress-check] size-5" aria-hidden="true"></span>
              {__("Index Progress")}
            </h2>
            <div class="grid min-w-0 gap-2">
              <div class="flex items-center justify-between gap-4 text-sm">
                <span class="text-base-content/60">{__("Indexed up to post")} <strong class="text-base-content tabular-nums">{if $system['posts_search_ready']}{$search_index['last_post_id']|number_format}{else}{$search_index['cursor']|number_format}{/if}</strong> {__("of")} <strong class="text-base-content tabular-nums">{$search_index['last_post_id']|number_format}</strong></span>
                <span class="font-semibold tabular-nums">{$search_index['progress']}%</span>
              </div>
              <div class="progress h-2" role="progressbar" aria-label="{__("Index Progress")}" aria-valuenow="{$search_index['progress']}" aria-valuemin="0" aria-valuemax="100">
                <div class="progress-bar {if $system['posts_search_ready']}progress-success{else}progress-warning{/if}" style="width: {$search_index['progress']}%"></div>
              </div>
            </div>
            {if !$system['posts_search_ready']}
              <p class="text-base-content/60 m-0 text-sm">{__("Search keeps working while the index is being built, the cronjob builds it in the background or you can build it now")}</p>
            {/if}
          </div>

          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="search-index-content-title">
            <h2 id="search-index-content-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              <span class="icon-[tabler--list-search] size-5" aria-hidden="true"></span>
              {__("What is indexed")}
            </h2>
            <ul class="m-0 grid list-none gap-3 p-0 text-sm">
                <li class="flex min-w-0 items-start gap-3">
                  <span class="icon-[tabler--check] text-success mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                  <span class="min-w-0">{__("Posts text and paid posts text")}</span>
                </li>
                <li class="flex min-w-0 items-start gap-3">
                  <span class="icon-[tabler--check] text-success mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                  <span class="min-w-0">{__("Titles of blogs, jobs, products, offers, courses, funding and live")}</span>
                </li>
                <li class="flex min-w-0 items-start gap-3">
                  <span class="icon-[tabler--check] text-success mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                  <span class="min-w-0">{__("Link and media titles and descriptions")}</span>
                </li>
                <li class="flex min-w-0 items-start gap-3">
                  <span class="icon-[tabler--check] text-success mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                  <span class="min-w-0">{__("Photo albums titles, poll options and merit messages")}</span>
                </li>
              <li class="flex min-w-0 items-start gap-3">
                <span class="{if $system['blogs_search_content_enabled']}icon-[tabler--check] text-success{else}icon-[tabler--x] text-base-content/40{/if} mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                <span class="min-w-0">
                  {__("Blog posts content")}
                  <span class="badge badge-soft {if $system['blogs_search_content_enabled']}badge-success{else}badge-neutral{/if} badge-sm ms-1 rounded-full">{if $system['blogs_search_content_enabled']}{__("Enabled")}{else}{__("Disabled")}{/if}</span>
                  <a class="link link-primary ms-1" href="{$system['system_url']}/{$control_panel['url']}/settings">{__("Settings")}</a>
                </span>
              </li>
            </ul>
          </div>
        </section>
        <!-- index details -->

        <!-- rebuild -->
        <form class="js_ajax-forms card flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6 shadow-none xl:col-span-2" data-url="admin/tools.php?do=search-index">
          <div class="flex min-w-0 items-start gap-4">
            <span class="flex size-12 shrink-0 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
              <span class="icon-[tabler--refresh] size-6" aria-hidden="true"></span>
            </span>
            <div class="grid min-w-0 gap-1">
              <h2 class="m-0 text-base font-semibold leading-snug">{__("Rebuild the posts search index")}</h2>
              <p class="text-base-content/60 m-0 text-sm leading-relaxed">{__("Rebuilding reads every post again and might take some time, search stays available while it runs")}</p>
            </div>
          </div>
          <div class="flex min-w-0 flex-col gap-3">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <button type="submit" class="btn btn-primary w-full">
              <span class="icon-[tabler--bolt] size-4" aria-hidden="true"></span>
              {__("Rebuild")}
            </button>
          </div>
        </form>
        <!-- rebuild -->

      </div>

      </div>

    {elseif $sub_view == "backups"}

      <div class="flex min-w-0 flex-col gap-6">

      <!-- stats -->
      <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-3 lg:gap-5">
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-info icon-[tabler--clock] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Last Backup")}">{__("Last Backup")}</span>
            <p class="admin-stat-value m-0 truncate text-xl font-bold leading-tight tracking-tight tabular-nums sm:text-2xl" title="{if $system['last_backup_time']}{$system['last_backup_time']|date_format:"%e %b %Y, %H:%M"}{else}{__("N/A")}{/if}">{if $system['last_backup_time']}{$system['last_backup_time']|date_format:"%e %b %Y, %H:%M"}{else}{__("N/A")}{/if}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-neutral icon-[tabler--database-export] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Total Backups")}">{__("Total Backups")}</span>
            <p class="admin-stat-value m-0 text-xl font-bold leading-tight tracking-tight tabular-nums sm:text-2xl">{$insights['total']|number_format}</p>
          </div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-warning icon-[tabler--server] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1">
            <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Storage Used")}">{__("Storage Used")}</span>
            <p class="admin-stat-value m-0 text-xl font-bold leading-tight tracking-tight tabular-nums sm:text-2xl">{($insights['size'] / 1048576)|number_format:2} {__("MB")}</p>
          </div>
        </article>
      </div>
      <!-- stats -->

      <!-- generate backup -->
      <div class="grid min-w-0 gap-4 md:grid-cols-3 lg:gap-5">
        <form class="js_ajax-forms card flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6 shadow-none" data-url="admin/tools.php?do=backups">
          <input type="hidden" name="backup_option" value="datebase_backup">
          <div class="flex min-w-0 items-start gap-4">
            <span class="flex size-12 shrink-0 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
              {include file='__svg_icons.tpl' icon="database" width="28px" height="28px"}
            </span>
            <div class="grid min-w-0 gap-1">
              <h2 class="m-0 text-base font-semibold leading-snug">{__("Database")}</h2>
              <p class="text-base-content/60 m-0 text-sm leading-relaxed">{__("SQL dump of all the database tables")}</p>
            </div>
          </div>
          <div class="mt-auto flex min-w-0 flex-col gap-3">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <button type="submit" class="btn btn-primary w-full">
              <span class="icon-[tabler--bolt] size-4" aria-hidden="true"></span>
              {__("Generate")}
            </button>
          </div>
        </form>
        <form class="js_ajax-forms card flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6 shadow-none" data-url="admin/tools.php?do=backups">
          <input type="hidden" name="backup_option" value="files_backup">
          <div class="flex min-w-0 items-start gap-4">
            <span class="flex size-12 shrink-0 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
              {include file='__svg_icons.tpl' icon="files" width="28px" height="28px"}
            </span>
            <div class="grid min-w-0 gap-1">
              <h2 class="m-0 text-base font-semibold leading-snug">{__("Files")}</h2>
              <p class="text-base-content/60 m-0 text-sm leading-relaxed">{__("Zip archive of all the website files and uploads")}</p>
            </div>
          </div>
          <div class="mt-auto flex min-w-0 flex-col gap-3">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <button type="submit" class="btn btn-primary w-full">
              <span class="icon-[tabler--bolt] size-4" aria-hidden="true"></span>
              {__("Generate")}
            </button>
          </div>
        </form>
        <form class="js_ajax-forms card flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6 shadow-none" data-url="admin/tools.php?do=backups">
          <input type="hidden" name="backup_option" value="full_backup">
          <div class="flex min-w-0 items-start gap-4">
            <span class="flex size-12 shrink-0 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
              {include file='__svg_icons.tpl' icon="server" width="28px" height="28px"}
            </span>
            <div class="grid min-w-0 gap-1">
              <h2 class="m-0 text-base font-semibold leading-snug">{__("Full Backup")}</h2>
              <p class="text-base-content/60 m-0 text-sm leading-relaxed">{__("Both the database dump and the files archive")}</p>
            </div>
          </div>
          <div class="mt-auto flex min-w-0 flex-col gap-3">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <button type="submit" class="btn btn-primary w-full">
              <span class="icon-[tabler--bolt] size-4" aria-hidden="true"></span>
              {__("Generate")}
            </button>
          </div>
        </form>
      </div>
      <p class="text-base-content/60 m-0 flex items-start gap-2 text-sm">
        <span class="icon-[tabler--info-circle] mt-0.5 size-4 shrink-0" aria-hidden="true"></span>
        <span>{__("Backups are generated in the background and might take some time, you will be notified once the backup is ready")}. {__("You can find backups in")} <strong>content/backups</strong></span>
      </p>
      <!-- generate backup -->

      <!-- backups -->
      {if $rows}
        <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Backups")}">
          <div class="admin-list-table-wrap w-full overflow-x-auto">
            <table class="table js_dataTable admin-list-table">
              <thead>
                <tr>
                  <th>{__("Backup")}</th>
                  <th>{__("Type")}</th>
                  <th>{__("Date")}</th>
                  <th>{__("Size")}</th>
                  <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
                </tr>
              </thead>
              <tbody>
                {foreach $rows as $row}
                  <tr>
                    <td data-order="{$row['time']}">
                      <div class="admin-list-identity flex min-w-0 items-center gap-3">
                        <span class="flex size-[38px] shrink-0 items-center justify-center rounded-md border border-base-300 bg-base-200">
                          {if $row['type'] == "database"}
                            <span class="icon-[tabler--database] size-5" aria-hidden="true"></span>
                          {elseif $row['type'] == "files"}
                            <span class="icon-[tabler--file-zip] size-5" aria-hidden="true"></span>
                          {elseif $row['type'] == "full"}
                            <span class="icon-[tabler--server] size-5" aria-hidden="true"></span>
                          {else}
                            <span class="icon-[tabler--loader-2] size-5" aria-hidden="true"></span>
                          {/if}
                        </span>
                        <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                          <span class="admin-list-name truncate text-sm font-semibold" title="#{$row['id']}">#{$row['id']}</span>
                          {foreach $row['files'] as $file}
                            <span class="admin-list-id truncate text-xs" title="{$file['name']|escape:'html'}">{$file['name']|escape:'html'}</span>
                          {/foreach}
                        </span>
                      </div>
                    </td>
                    <td>
                      {if $row['type'] == "database"}
                        <span class="badge badge-soft badge-info badge-sm rounded-full">{__("Database")}</span>
                      {elseif $row['type'] == "files"}
                        <span class="badge badge-soft badge-primary badge-sm rounded-full">{__("Files")}</span>
                      {elseif $row['type'] == "full"}
                        <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Full Backup")}</span>
                      {else}
                        <span class="badge badge-soft badge-warning badge-sm rounded-full">{__("Processing")}</span>
                      {/if}
                    </td>
                    <td data-order="{$row['time']}">
                      <span class="admin-list-inline flex items-center gap-1.5 whitespace-nowrap text-sm"><span class="icon-[tabler--calendar-event] text-base-content/50 size-4" aria-hidden="true"></span>{$row['time']|date_format:"%e %b %Y, %H:%M"}</span>
                    </td>
                    <td data-order="{$row['size']}">
                      <span class="whitespace-nowrap text-sm tabular-nums">{($row['size'] / 1048576)|number_format:2} {__("MB")}</span>
                    </td>
                    <td class="admin-list-actions-column w-14 text-end">
                      <div class="dropdown relative inline-flex [--placement:bottom-end]">
                        <button id="backup-actions-{$row['id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} #{$row['id']}">
                          <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                        </button>
                        <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="backup-actions-{$row['id']}">
                          {if isset($row['files']['database'])}
                            <li>
                              <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/downloads.php?type=backup&amp;id={$row['id']}&amp;file=database">
                                <span class="icon-[tabler--download] size-4" aria-hidden="true"></span>
                                {__("Download Database")}
                              </a>
                            </li>
                          {/if}
                          {if isset($row['files']['files'])}
                            <li>
                              <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/downloads.php?type=backup&amp;id={$row['id']}&amp;file=files">
                                <span class="icon-[tabler--download] size-4" aria-hidden="true"></span>
                                {__("Download Files")}
                              </a>
                            </li>
                          {/if}
                          <li>
                            <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="backup" data-id="{$row['id']}">
                              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                              {__("Delete")}
                            </button>
                          </li>
                        </ul>
                      </div>
                    </td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        </section>
      {else}
        <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-backups-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--database-export] size-6" aria-hidden="true"></span>
          </div>
          <h2 id="admin-backups-empty-title">{__("No backups yet")}</h2>
          <p>{__("Generate a backup and it will be listed here to download or delete.")}</p>
        </section>
      {/if}
      <!-- backups -->

      </div>

    {elseif $sub_view == "cronjob"}

      {capture assign="cronjob_file"}cronjob.php?hash={if $user->_data['user_demo']}DEMO RESTRICTED{else}{$system['cronjob_hash']}{/if}{/capture}
      {capture assign="cronjob_edit_command"}crontab -e{/capture}
      {capture assign="cronjob_command"}0 0 * * * curl -s "{$system['system_url']}/{$cronjob_file}" > /dev/null 2>&1{/capture}

      <div class="grid min-w-0 items-start gap-6 xl:grid-cols-5">

        <!-- cronjob settings -->
        <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4 xl:col-span-3" data-url="admin/settings.php?edit=cronjob">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="cronjob-title">
              <h2 id="cronjob-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--clock-play] size-5" aria-hidden="true"></span>
                {__("Cronjob")}
              </h2>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="cronjob" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="cronjob_enabled">{__("Cronjob")}</label>
                  <div id="cronjob_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Enable or disable the cronjob")}</div>
                </div>
                <div class="text-end">
                  <input aria-describedby="cronjob_enabled-help" type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="cronjob_enabled" id="cronjob_enabled" {if $system['cronjob_enabled']}checked{/if}>
                </div>
              </div>
            </div>

            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="cronjob-tasks-title">
              <div class="grid gap-1">
                <h2 id="cronjob-tasks-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                  <span class="icon-[tabler--list-check] size-5" aria-hidden="true"></span>
                  {__("Daily Tasks")}
                </h2>
                <p class="text-base-content/60 m-0 text-sm">{__("Select which tasks you want to run daily")}</p>
              </div>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="cronjob_undelivered_orders">{__("Deliver Shipped Orders")}</label>
                  <div id="cronjob_undelivered_orders-help" class="admin-setting-help text-sm leading-relaxed">{__("Mark all shipped orders as delivered as passed the")} {$system['market_delivery_days']} {__("days")}</div>
                </div>
                <div class="text-end">
                  <input aria-describedby="cronjob_undelivered_orders-help" type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="cronjob_undelivered_orders" id="cronjob_undelivered_orders" {if $system['cronjob_undelivered_orders']}checked{/if}>
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="cronjob_reset_pro_packages">{__("Expired Subscriptions")}</label>
                  <div id="cronjob_reset_pro_packages-help" class="admin-setting-help text-sm leading-relaxed">{__("Reset all expired subscribers and their boosted posts and pages")}</div>
                </div>
                <div class="text-end">
                  <input aria-describedby="cronjob_reset_pro_packages-help" type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="cronjob_reset_pro_packages" id="cronjob_reset_pro_packages" {if $system['cronjob_reset_pro_packages']}checked{/if}>
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="cronjob_clear_pending_uploads">{__("Pending Uploads")}</label>
                  <div id="cronjob_clear_pending_uploads-help" class="admin-setting-help text-sm leading-relaxed">{__("Clear pending uploads")}</div>
                </div>
                <div class="text-end">
                  <input aria-describedby="cronjob_clear_pending_uploads-help" type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="cronjob_clear_pending_uploads" id="cronjob_clear_pending_uploads" {if $system['cronjob_clear_pending_uploads']}checked{/if}>
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="cronjob_merits_reminder">{__("Merits Reminder")}</label>
                  <div id="cronjob_merits_reminder-help" class="admin-setting-help text-sm leading-relaxed">{__("Send merits reminder to users")}</div>
                </div>
                <div class="text-end">
                  <input aria-describedby="cronjob_merits_reminder-help" type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="cronjob_merits_reminder" id="cronjob_merits_reminder" {if $system['cronjob_merits_reminder']}checked{/if}>
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="cronjob_post_views_cleanup">{__("Post-View History")}</label>
                  <div id="cronjob_post_views_cleanup-help" class="admin-setting-help text-sm leading-relaxed">{__("Clean expired post-view history when Unique Views is set to Every X Days")}</div>
                </div>
                <div class="text-end">
                  <input aria-describedby="cronjob_post_views_cleanup-help" type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="cronjob_post_views_cleanup" id="cronjob_post_views_cleanup" {if $system['cronjob_post_views_cleanup']}checked{/if}>
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
        </form>
        <!-- cronjob settings -->

        <div class="flex min-w-0 flex-col gap-6 xl:col-span-2">

          <!-- cronjob status -->
          <section class="card min-w-0 border border-base-300 bg-base-100 p-6 shadow-none" aria-label="{__("Status")}">
            <div class="flex min-w-0 items-center justify-between gap-4">
              <div class="grid min-w-0 gap-1">
                <span class="text-base-content/60 text-sm">{__("Last Run")}</span>
                <span class="truncate text-lg font-semibold tabular-nums" title="{if $system['cronjob_last_run']}{$system['cronjob_last_run']|date_format:"%e %b %Y, %H:%M"}{else}{__("N/A")}{/if}">{if $system['cronjob_last_run']}{$system['cronjob_last_run']|date_format:"%e %b %Y, %H:%M"}{else}{__("N/A")}{/if}</span>
              </div>
              {if $cronjob_status == "running"}
                <span class="badge badge-soft badge-success shrink-0 gap-1 rounded-full"><span class="icon-[tabler--circle-check] size-3.5" aria-hidden="true"></span>{__("Running")}</span>
              {elseif $cronjob_status == "stopped"}
                <span class="badge badge-soft badge-error shrink-0 gap-1 rounded-full"><span class="icon-[tabler--alert-circle] size-3.5" aria-hidden="true"></span>{__("Not Running")}</span>
              {elseif $cronjob_status == "pending"}
                <span class="badge badge-soft badge-warning shrink-0 gap-1 rounded-full"><span class="icon-[tabler--clock] size-3.5" aria-hidden="true"></span>{__("Never Ran")}</span>
              {else}
                <span class="badge badge-soft badge-neutral shrink-0 gap-1 rounded-full"><span class="icon-[tabler--player-pause] size-3.5" aria-hidden="true"></span>{__("Disabled")}</span>
              {/if}
            </div>
            {if $cronjob_status == "stopped" || $cronjob_status == "pending"}
              <p class="text-base-content/60 m-0 mt-3 text-sm">{__("The cronjob is enabled but your server did not call it recently, make sure the command is added to your server's cronjob")}</p>
            {/if}
          </section>
          <!-- cronjob status -->

          <!-- server setup -->
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="cronjob-setup-title">
              <div class="grid gap-1">
                <h2 id="cronjob-setup-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                  <span class="icon-[tabler--terminal-2] size-5" aria-hidden="true"></span>
                  {__("Server Setup")}
                </h2>
                <p class="text-base-content/60 m-0 text-sm">{__("Important! After enable cronjob you need to use the command below and add it to your server's cronjob")}</p>
              </div>

              <ol class="admin-tools-steps grid min-w-0 gap-4 text-sm">
                <li>{__("Open your server terminal or login via SSH")}</li>
                <li class="min-w-0">
                  {__("Run the following command")}
                  <div class="mt-2 flex min-w-0 items-center gap-2">
                    <div class="admin-tools-code min-w-0 flex-1"><code>{$cronjob_edit_command|escape:'html'}</code></div>
                    <button type="button" class="btn btn-text btn-square btn-sm shrink-0 js_clipboard" data-clipboard-text="{$cronjob_edit_command|escape:'html'}" title="{__("Copy")}" aria-label="{__("Copy")}">
                      <span class="js-clipboard-default icon-[tabler--copy] size-4" aria-hidden="true"></span>
                      <span class="js-clipboard-success icon-[tabler--check] hidden size-4 text-success" aria-hidden="true"></span>
                    </button>
                  </div>
                </li>
                <li class="min-w-0">
                  {__("Add the following line then save")}
                  <div class="mt-2 flex min-w-0 items-center gap-2">
                    <div class="admin-tools-code min-w-0 flex-1"><code>{$cronjob_command|escape:'html'}</code></div>
                    <button type="button" class="btn btn-text btn-square btn-sm shrink-0 js_clipboard" data-clipboard-text="{$cronjob_command|escape:'html'}" title="{__("Copy")}" aria-label="{__("Copy")}">
                      <span class="js-clipboard-default icon-[tabler--copy] size-4" aria-hidden="true"></span>
                      <span class="js-clipboard-success icon-[tabler--check] hidden size-4 text-success" aria-hidden="true"></span>
                    </button>
                  </div>
                </li>
                <li class="[overflow-wrap:anywhere]">
                  {__("If you are using cPanel, please follow")} <a class="link link-primary" target="_blank" rel="noopener" href="https://cpanel.net/blog/tips-and-tricks/how-to-configure-a-cron-job/">{__("this tutorial")}</a> {__("and replace the file name with")} <strong>{$cronjob_file}</strong> {__("and make sure the cronjob run daily")}
                </li>
              </ol>
            </div>
          </section>
          <!-- server setup -->

        </div>

      </div>

    {elseif $sub_view == "reset"}

      <div class="flex min-w-0 flex-col gap-6">

        <div class="grid min-w-0 items-start gap-6 lg:grid-cols-2">

          <!-- deleted data -->
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="factory-reset-deleted-title">
              <h2 id="factory-reset-deleted-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--trash] size-5" aria-hidden="true"></span>
                {__("What will be deleted")}
              </h2>
              <ul class="m-0 grid list-none gap-3 p-0 text-sm">
              <li class="flex min-w-0 items-start gap-3">
                <span class="icon-[tabler--x] text-error mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                <span class="min-w-0">{__("All users except your account")}</span>
              </li>
              <li class="flex min-w-0 items-start gap-3">
                <span class="icon-[tabler--x] text-error mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                <span class="min-w-0">{__("All posts, comments, reactions and stories")}</span>
              </li>
              <li class="flex min-w-0 items-start gap-3">
                <span class="icon-[tabler--x] text-error mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                <span class="min-w-0">{__("All pages, groups, events, forums, games and movies")}</span>
              </li>
              <li class="flex min-w-0 items-start gap-3">
                <span class="icon-[tabler--x] text-error mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                <span class="min-w-0">{__("All conversations, notifications and reports")}</span>
              </li>
              <li class="flex min-w-0 items-start gap-3">
                <span class="icon-[tabler--x] text-error mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                <span class="min-w-0">{__("All payments, orders, wallets, points and subscriptions")}</span>
              </li>
              <li class="flex min-w-0 items-start gap-3">
                <span class="icon-[tabler--x] text-error mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                <span class="min-w-0">{__("All packages, custom fields, widgets, gifts, announcements and ads")}</span>
              </li>
              </ul>
            </div>
          </section>
          <!-- deleted data -->

          <!-- kept data -->
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="factory-reset-kept-title">
              <h2 id="factory-reset-kept-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                <span class="icon-[tabler--shield-check] size-5" aria-hidden="true"></span>
                {__("What will be kept")}
              </h2>
              <ul class="m-0 grid list-none gap-3 p-0 text-sm">
              <li class="flex min-w-0 items-start gap-3">
                <span class="icon-[tabler--check] text-success mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                <span class="min-w-0">{__("Your admin account, with its pictures, points and balances reset")}</span>
              </li>
              <li class="flex min-w-0 items-start gap-3">
                <span class="icon-[tabler--check] text-success mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                <span class="min-w-0">{__("System settings")}</span>
              </li>
              <li class="flex min-w-0 items-start gap-3">
                <span class="icon-[tabler--check] text-success mt-0.5 size-4.5 shrink-0" aria-hidden="true"></span>
                <span class="min-w-0">{__("Themes and languages")}</span>
              </li>
              </ul>
              <p class="text-base-content/60 m-0 text-sm">{__("(Note: All system settings will be saved)")}</p>
            </div>
          </section>
          <!-- kept data -->

        </div>

        <!-- factory reset -->
        <section class="card min-w-0 border border-error/40 bg-base-100 shadow-none" aria-labelledby="factory-reset-title">
          <div class="flex min-w-0 flex-col gap-5 p-6 md:flex-row md:items-center md:justify-between">
            <div class="flex min-w-0 items-start gap-4">
              <span class="flex size-12 shrink-0 items-center justify-center rounded-[14px] border border-error/30 bg-error/10 text-error">
                <span class="icon-[tabler--alert-triangle] size-6" aria-hidden="true"></span>
              </span>
              <div class="grid min-w-0 gap-1">
                <h2 id="factory-reset-title" class="m-0 text-base font-semibold leading-snug">{__("Factory Reset")}</h2>
                <p class="text-base-content/60 m-0 text-sm leading-relaxed">{__("Once you reset your website all data will be deleted and it will be like having a fresh installation")}</p>
                <p class="text-base-content/60 m-0 text-sm leading-relaxed">
                  {__("Last Backup")}: <strong class="text-base-content">{if $system['last_backup_time']}{$system['last_backup_time']|date_format:"%e %b %Y, %H:%M"}{else}{__("N/A")}{/if}</strong>
                  &middot; <a class="link link-primary" href="{$system['system_url']}/{$control_panel['url']}/tools/backups">{__("Backup Database & Files")}</a>
                </p>
              </div>
            </div>
            <button type="button" class="btn btn-error shrink-0 js_modal" data-url="#factory-reset">
              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
              {__("Reset Everything")}
            </button>
          </div>
        </section>
        <!-- factory reset -->

      </div>

    {/if}

</section>
