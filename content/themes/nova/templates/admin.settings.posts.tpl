<section class="admin-settings-page" aria-labelledby="settings-posts-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-posts-title" class="text-2xl font-semibold">{__("Posts Settings")}</h1>
    <p class="text-base-content/60 text-sm">{__("Configure newsfeed, post types, and sharing.")}</p>
  </div>
  <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Posts Settings")}" aria-orientation="vertical">
    <button type="button" id="settings-posts-tab-newsfeed" class="tab active-tab:tab-active active" data-tab="#Newsfeed" aria-controls="Newsfeed" role="tab" aria-selected="true"><span class="icon-[tabler--layout-list] size-4" aria-hidden="true"></span>{__("Newsfeed")}</button>
    <button type="button" id="settings-posts-tab-types" class="tab active-tab:tab-active" data-tab="#Types" aria-controls="Types" role="tab" aria-selected="false"><span class="icon-[tabler--article] size-4" aria-hidden="true"></span>{__("Types")}</button>
    <button type="button" id="settings-posts-tab-media" class="tab active-tab:tab-active" data-tab="#Media" aria-controls="Media" role="tab" aria-selected="false"><span class="icon-[tabler--player-play] size-4" aria-hidden="true"></span>{__("Display")}</button>
    <button type="button" id="settings-posts-tab-privacy" class="tab active-tab:tab-active" data-tab="#Privacy" aria-controls="Privacy" role="tab" aria-selected="false"><span class="icon-[tabler--adjustments] size-4" aria-hidden="true"></span>{__("Tweaks")}</button>
  </nav>
  <div id="Newsfeed" class="admin-settings-panel js_admin-settings-panel" role="tabpanel" aria-labelledby="settings-posts-tab-newsfeed" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=posts_newsfeed">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-1">
          <h3 id="settings-posts-posts-card-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Newsfeed")}
          </h3>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-2-label" for="settings-posts-field-2">
              {__("Newsfeed Posts Source")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full" name="newsfeed_source" id="settings-posts-field-2" aria-describedby="settings-posts-field-2-help">
                <option value="default" {if $system['newsfeed_source'] == "default"}selected{/if}>{__("Default")} [{__("Show what user is followings (Friends, Followings, Pages... etc)")}]</option>
                <option value="all_posts" {if $system['newsfeed_source'] == "all_posts"}selected{/if}>{__("All Posts")} [{__("All posts will be shown")}]</option>
              </select>
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-2-help">
                {__("Algorithm will exclude any post from closed/secret groups and events that users not member of incase of all posts also will disable all posts privacy")}
              </div>
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="merge" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="newsfeed_merge_enabled">{__("Newsfeed Merge")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="newsfeed_merge_enabled-help">
                {__("Turn the newsfeed merge On and Off")}
                <br>
                {__("Will enable the newsfeed algorithm to merge posts from recent, popular & discover sources")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="newsfeed_merge_enabled" id="newsfeed_merge_enabled" {if $system['newsfeed_merge_enabled']}checked{/if} class="switch switch-primary" aria-describedby="newsfeed_merge_enabled-help">
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-3-label" for="settings-posts-field-3">
              {__("Recent Results")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="merge_recent_results" value="{$system['merge_recent_results']}" id="settings-posts-field-3" aria-describedby="settings-posts-field-3-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-3-help">
                {__("How many posts to show from recent source")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-4-label" for="settings-posts-field-4">
              {__("Popular Results")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="merge_popular_results" value="{$system['merge_popular_results']}" id="settings-posts-field-4" aria-describedby="settings-posts-field-4-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-4-help">
                {__("How many posts to show from popular source")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-5-label" for="settings-posts-field-5">
              {__("Discover Results")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="merge_discover_results" value="{$system['merge_discover_results']}" id="settings-posts-field-5" aria-describedby="settings-posts-field-5-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-5-help">
                {__("How many posts to show from discover source")}
              </div>
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="database" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="newsfeed_caching_enabled">{__("Newsfeed Caching")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="newsfeed_caching_enabled-help">
                {__("Turn the newsfeed caching On and Off")}
                <br>
                {__("Delivers fresh, unique content on every refresh with a smart caching algorithm")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="newsfeed_caching_enabled" id="newsfeed_caching_enabled" {if $system['newsfeed_caching_enabled']}checked{/if} class="switch switch-primary" aria-describedby="newsfeed_caching_enabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="cache-cleaner" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="smooth_infinite_scroll">{__("Enhance Newsfeed Infinite Scroll")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="smooth_infinite_scroll-help">
                {__("Ensures smooth newsfeed browsing experience by seamlessly replacing older results at the top with new ones")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="smooth_infinite_scroll" id="smooth_infinite_scroll" {if $system['smooth_infinite_scroll']}checked{/if} class="switch switch-primary" aria-describedby="smooth_infinite_scroll-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="map" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="newsfeed_location_filter_enabled">{__("Newsfeed Country Filter")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="newsfeed_location_filter_enabled-help">
                {__("Turn the newsfeed country filter On and Off")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="newsfeed_location_filter_enabled" id="newsfeed_location_filter_enabled" {if $system['newsfeed_location_filter_enabled']}checked{/if} class="switch switch-primary" aria-describedby="newsfeed_location_filter_enabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="popularity" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="popular_posts_enabled">{__("Popular Posts")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="popular_posts_enabled-help">
                {__("Turn the popular posts On and Off")}
                <br>
                {__("Popular posts are public posts ordered by most reactions, comments & shares")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="popular_posts_enabled" id="popular_posts_enabled" {if $system['popular_posts_enabled']}checked{/if} class="switch switch-primary" aria-describedby="popular_posts_enabled-help">
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-6-label" for="settings-posts-field-6">
              {__("Popular Interval")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full" name="popular_posts_interval" id="settings-posts-field-6" aria-describedby="settings-posts-field-6-help">
                <option {if $system['popular_posts_interval'] == "day"}selected{/if} value="day">{__("Last 24 Hours")}</option>
                <option {if $system['popular_posts_interval'] == "week"}selected{/if} value="week">{__("Last 7 Days")}</option>
                <option {if $system['popular_posts_interval'] == "month"}selected{/if} value="month">{__("Last 30 Days")}</option>
                <option {if $system['popular_posts_interval'] == "year"}selected{/if} value="year">{__("Last 12 Months")}</option>
              </select>
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-6-help">
                {__("Select the interval of popular posts")}
              </div>
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="posts_discover" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="discover_posts_enabled">{__("Discover Posts")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="discover_posts_enabled-help">
                {__("Turn the discover posts On and Off")}
                <br>
                {__("Discover posts are public posts ordered from most recent to old")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="discover_posts_enabled" id="discover_posts_enabled" {if $system['discover_posts_enabled']}checked{/if} class="switch switch-primary" aria-describedby="discover_posts_enabled-help">
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-2">
          <h3 id="settings-posts-posts-card-2" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Post approval")}
          </h3>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="verification" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="posts_approval_enabled">{__("Posts Approval System")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="posts_approval_enabled-help">
                {__("Turn the approval system On and Off (If disabled all posts will be approved by default)")}
                <br>
                {__("If enabled, posts will be pending for approval by the admin or moderators")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="posts_approval_enabled" id="posts_approval_enabled" {if $system['posts_approval_enabled']}checked{/if} class="switch switch-primary" aria-describedby="posts_approval_enabled-help">
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-7-label" for="settings-posts-field-7">
              {__("Appoval Limit")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="posts_approval_limit" value="{$system['posts_approval_limit']}" id="settings-posts-field-7" aria-describedby="settings-posts-field-7-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-7-help">
                {__("After how many posts needs to be approved so the user can post without approval")}
              </div>
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              <span class="icon-[tabler--clock] size-6" aria-hidden="true"></span>
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="posts_edit_limit_enabled">{__("Post Edit Time Limit")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="posts_edit_limit_enabled-help">
                {__("Turn the post edit time limit On and Off")}
                <br>
                {__("If enabled, members can edit a published post only within the set hours")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="posts_edit_limit_enabled" id="posts_edit_limit_enabled" {if $system['posts_edit_limit_enabled']}checked{/if} class="switch switch-primary" aria-describedby="posts_edit_limit_enabled-help">
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-edit-limit-label" for="settings-posts-field-edit-limit">
              {__("Edit Limit")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="posts_edit_limit" value="{$system['posts_edit_limit']}" id="settings-posts-field-edit-limit" aria-describedby="settings-posts-field-edit-limit-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-edit-limit-help">
                {__("After how many hours a published post can no longer be edited")}
              </div>
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-10">
          <h3 id="settings-posts-posts-card-10" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Infinite scroll")}
          </h3>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="scroll_desktop" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="desktop_infinite_scroll">{__("Desktop Infinite Scroll")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="desktop_infinite_scroll-help">
                {__("Turn infinite scroll on desktop screens On and Off")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="desktop_infinite_scroll" id="desktop_infinite_scroll" {if $system['desktop_infinite_scroll']}checked{/if} class="switch switch-primary" aria-describedby="desktop_infinite_scroll-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="scroll_mobile" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="mobile_infinite_scroll">{__("Mobile Infinite Scroll")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="mobile_infinite_scroll-help">
                {__("Turn infinite scroll on mobile screens On and Off")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="mobile_infinite_scroll" id="mobile_infinite_scroll" {if $system['mobile_infinite_scroll']}checked{/if} class="switch switch-primary" aria-describedby="mobile_infinite_scroll-help">
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
  <div id="Types" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="settings-posts-tab-types" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=posts_types">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-3">
          <h3 id="settings-posts-posts-card-3" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Post types")}
          </h3>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="memories" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="memories_enabled">{__("Memories")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="memories_enabled-help">
                {__("Turn the memories On and Off")}
                <br>
                {__("Memories are posts from the same day on last year")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="memories_enabled" id="memories_enabled" {if $system['memories_enabled']}checked{/if} class="switch switch-primary" aria-describedby="memories_enabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="wall_posts" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="wall_posts_enabled">{__("Wall Posts")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="wall_posts_enabled-help">
                {__("Users can publish posts on their friends walls")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="wall_posts_enabled" id="wall_posts_enabled" {if $system['wall_posts_enabled']}checked{/if} class="switch switch-primary" aria-describedby="wall_posts_enabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="schedule" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="posts_schedule_enabled">{__("Schedule Posts")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="posts_schedule_enabled-help">
                {__("Turn the schedule posts On and Off")}
                <br>
                {__("If enabled, users will be able to schedule posts to be published in the future")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="posts_schedule_enabled" id="posts_schedule_enabled" {if $system['posts_schedule_enabled']}checked{/if} class="switch switch-primary" aria-describedby="posts_schedule_enabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="spy" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="anonymous_mode">{__("Post As Anonymous")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="anonymous_mode-help">
                {__("Turn Anonymous mode On and Off")}
                <br>
                {__("Note: Admins and Moderators will able to see the real post author")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="anonymous_mode" id="anonymous_mode" {if $system['anonymous_mode']}checked{/if} class="switch switch-primary" aria-describedby="anonymous_mode-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="adult" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="adult_mode">{__("Adult Mode")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="adult_mode-help">
                {__("Adult mode will hide content that marked for adult from users under 18 years old")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="adult_mode" id="adult_mode" {if $system['adult_mode']}checked{/if} class="switch switch-primary" aria-describedby="adult_mode-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="collaborative" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="collaborative_posts_enabled">{__("Collaborative Posts")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="collaborative_posts_enabled-help">
                {__("Turn the collaborative posts On and Off")}
                <br>
                {__("If enabled, users will be able to collaborate on posts and share revenues in paid posts")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="collaborative_posts_enabled" id="collaborative_posts_enabled" {if $system['collaborative_posts_enabled']}checked{/if} class="switch switch-primary" aria-describedby="collaborative_posts_enabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="html" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="rich_text_posts_enabled">{__("Rich Text Posts")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="rich_text_posts_enabled-help">
                {__("Turn the rich text posts On and Off")}
                <br>
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="rich_text_posts_enabled" id="rich_text_posts_enabled" {if $system['rich_text_posts_enabled']}checked{/if} class="switch switch-primary" aria-describedby="rich_text_posts_enabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="posts_colored" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="colored_posts_enabled">{__("Colored Posts")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="colored_posts_enabled-help">
                {__("Turn the colored posts On and Off")}
                <br>
                {__("Make sure you have configured")}
                <a href="{$system['system_url']}/{$control_panel['url']}/colored_posts">{__("Colored Posts")}</a>
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="colored_posts_enabled" id="colored_posts_enabled" {if $system['colored_posts_enabled']}checked{/if} class="switch switch-primary" aria-describedby="colored_posts_enabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="smile" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="activity_posts_enabled">{__("Feelings/Activity Posts")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="activity_posts_enabled-help">
                {__("Turn the feelings and activity posts On and Off")}
                <br>
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="activity_posts_enabled" id="activity_posts_enabled" {if $system['activity_posts_enabled']}checked{/if} class="switch switch-primary" aria-describedby="activity_posts_enabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="polls" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="polls_enabled">{__("Polls")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="polls_enabled-help">
                {__("Turn the poll posts On and Off")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="polls_enabled" id="polls_enabled" {if $system['polls_enabled']}checked{/if} class="switch switch-primary" aria-describedby="polls_enabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="user_information" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="profile_posts_updates_disabled">{__("Disable Profile Posts Updates")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="profile_posts_updates_disabled-help">
                {__("Turn it on to disable changing profile picture and cover posts")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="profile_posts_updates_disabled" id="profile_posts_updates_disabled" {if $system['profile_posts_updates_disabled']}checked{/if} class="switch switch-primary" aria-describedby="profile_posts_updates_disabled-help">
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-4">
          <h3 id="settings-posts-posts-card-4" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Voice notes")}
          </h3>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="voice_notes" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="voice_notes_posts_enabled">{__("Voice Notes in Posts")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="voice_notes_posts_enabled-help">
                {__("Turn the voice notes in posts On and Off")}
                <br>
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="voice_notes_posts_enabled" id="voice_notes_posts_enabled" {if $system['voice_notes_posts_enabled']}checked{/if} class="switch switch-primary" aria-describedby="voice_notes_posts_enabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="voice_notes" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="voice_notes_comments_enabled">{__("Voice Notes in Comments")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="voice_notes_comments_enabled-help">
                {__("Turn the voice notes in comments On and Off")}
                <br>
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="voice_notes_comments_enabled" id="voice_notes_comments_enabled" {if $system['voice_notes_comments_enabled']}checked{/if} class="switch switch-primary" aria-describedby="voice_notes_comments_enabled-help">
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-8-label" for="settings-posts-field-8">
              {__("Voice Notes Max Duration")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="voice_notes_durtaion" value="{$system['voice_notes_durtaion']}" id="settings-posts-field-8" aria-describedby="settings-posts-field-8-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-8-help">
                {__("The maximum length for voice note in seconds")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-9-label" for="settings-posts-field-9">
              {__("Voice Notes Encoding")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full" name="voice_notes_encoding" id="settings-posts-field-9">
                <option value="mp3" {if $system['voice_notes_encoding'] == "mp3"}selected{/if}>mp3</option>
                <option value="ogg" {if $system['voice_notes_encoding'] == "ogg"}selected{/if}>ogg</option>
                <option value="wav" {if $system['voice_notes_encoding'] == "wav"}selected{/if}>wav</option>
              </select>
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-5">
          <h3 id="settings-posts-posts-card-5" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Location")}
          </h3>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="map" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="geolocation_enabled">{__("Geolocation")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="geolocation_enabled-help">
                {__("Turn the post Geolocation On and Off")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="geolocation_enabled" id="geolocation_enabled" {if $system['geolocation_enabled']}checked{/if} class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-describedby="geolocation_enabled-help">
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="geolocation_provider-label">
            <div class="label-text" id="geolocation_provider-label">
              {__("Geolocation Provider")}
            </div>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <div class="admin-settings-provider-group flex flex-wrap items-stretch gap-3">
                <!-- Google Maps -->
                <label class="admin-settings-provider-card">
                  <span class="admin-settings-provider-logo">
                    {include file='__svg_icons.tpl' icon="google" width="32px" height="32px"}
                  </span>
                  <span class="label-text">{__("Google Maps")}</span>
                  <input type="radio" name="geolocation_provider" value="google" id="geolocation_google" class="radio radio-primary" {if $system['geolocation_provider'] != "openstreetmap"}checked{/if} aria-describedby="geolocation_provider-help"/>
                </label>
                <!-- Google Maps -->
                <!-- OpenStreetMap -->
                <label class="admin-settings-provider-card">
                  <span class="admin-settings-provider-logo">
                    {include file='__svg_icons.tpl' icon="openstreetmap" width="32px" height="32px"}
                  </span>
                  <span class="label-text">{__("OpenStreetMap")}</span>
                  <input type="radio" name="geolocation_provider" value="openstreetmap" id="geolocation_openstreetmap" class="radio radio-primary" {if $system['geolocation_provider'] == "openstreetmap"}checked{/if} aria-describedby="geolocation_provider-help"/>
                </label>
                <!-- OpenStreetMap -->
              </div>
              <div class="admin-setting-help text-sm leading-relaxed" id="geolocation_provider-help">
                {__("Select the provider of the location search and maps")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-10-label" for="settings-posts-field-10">
              {__("Geolocation Google Key")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="geolocation_key" value="{$system['geolocation_key']}" id="settings-posts-field-10" aria-describedby="settings-posts-field-10-help">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-posts-field-10" aria-describedby="settings-posts-field-10-help">
              {/if}
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-10-help">
                {__("Check the documentation to learn how to get this key")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="geolocation_osm_url">
              {__("OpenStreetMap Search URL")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="geolocation_osm_url" value="{$system['geolocation_osm_url']|default:'https://photon.komoot.io'}" id="geolocation_osm_url" aria-describedby="geolocation_osm_url-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="geolocation_osm_url-help">
                {__("Your Photon server URL, no key is needed")} ({__("Default")}: https://photon.komoot.io)
              </div>
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-15">
          <h3 id="settings-posts-posts-card-15" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("GIFs")}
          </h3>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="gif" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="gif_enabled">{__("GIF")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="gif_enabled-help">
                {__("Turn the gif posts On and Off")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="gif_enabled" id="gif_enabled" {if $system['gif_enabled']}checked{/if} class="switch switch-primary" aria-describedby="gif_enabled-help">
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-11-label" for="settings-posts-field-11">
              {__("Giphy API Key")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="giphy_key" value="{$system['giphy_key']}" id="settings-posts-field-11" aria-describedby="settings-posts-field-11-help">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-posts-field-11" aria-describedby="settings-posts-field-11-help">
              {/if}
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-11-help">
                {__("Check the documentation to learn how to get this key")}
              </div>
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
  <div id="Media" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="settings-posts-tab-media" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=posts_media">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-6">
          <h3 id="settings-posts-posts-card-6" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Translation")}
          </h3>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="language" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="post_translation_enabled">{__("Post Translation")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="post_translation_enabled-help">
                {__("Turn the post translation On and Off")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="post_translation_enabled" id="post_translation_enabled" {if $system['post_translation_enabled']}checked{/if} class="switch switch-primary" aria-describedby="post_translation_enabled-help">
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="translation_provider-label">
            <div class="label-text" id="translation_provider-label">{__("Translation Provider")}</div>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <div class="admin-settings-provider-group flex flex-wrap items-stretch gap-3">
                <label class="admin-settings-provider-card sm:w-36!">
                  <span class="admin-settings-provider-logo">
                    {include file='__svg_icons.tpl' icon="google" width="32px" height="32px"}
                  </span>
                  <span class="label-text">{__("Google")}</span>
                  <input type="radio" name="translation_provider" value="google" id="translation_provider_google" class="radio radio-primary" {if $system['translation_provider'] == "google"}checked{/if} aria-describedby="translation_provider-help">
                </label>
                <label class="admin-settings-provider-card sm:w-36!">
                  <span class="admin-settings-provider-logo">
                    {include file='__svg_icons.tpl' icon="yandex" width="32px" height="32px"}
                  </span>
                  <span class="label-text">{__("Yandex")}</span>
                  <input type="radio" name="translation_provider" value="yandex" id="translation_provider_yandex" class="radio radio-primary" {if $system['translation_provider'] == "yandex"}checked{/if} aria-describedby="translation_provider-help">
                </label>
                <label class="admin-settings-provider-card sm:w-36!">
                  <span class="admin-settings-provider-logo">
                    {include file='__svg_icons.tpl' icon="deepl" width="32px" height="32px"}
                  </span>
                  <span class="label-text">{__("DeepL")}</span>
                  <input type="radio" name="translation_provider" value="deepl" id="translation_provider_deepl" class="radio radio-primary" {if $system['translation_provider'] == "deepl"}checked{/if} aria-describedby="translation_provider-help">
                </label>
                <label class="admin-settings-provider-card sm:w-36!">
                  <span class="admin-settings-provider-logo">
                    {include file='__svg_icons.tpl' icon="libretranslate" width="32px" height="32px"}
                  </span>
                  <span class="label-text">{__("LibreTranslate")}</span>
                  <input type="radio" name="translation_provider" value="libretranslate" id="translation_provider_libretranslate" class="radio radio-primary" {if $system['translation_provider'] == "libretranslate"}checked{/if} aria-describedby="translation_provider-help">
                </label>
              </div>
              <div class="admin-setting-help text-sm leading-relaxed" id="translation_provider-help">
                {__("Select the service used to translate posts and messages")}
              </div>
            </div>
          </div>
          <div class="divider my-0"></div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-12-label" for="settings-posts-field-12">
              {__("Google Translation Key")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="google_translation_key" value="{$system['google_translation_key']}" id="settings-posts-field-12" aria-describedby="settings-posts-field-12-help">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-posts-field-12" aria-describedby="settings-posts-field-12-help">
              {/if}
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-12-help">
                {__("Check the documentation to learn how to get this key")}
              </div>
            </div>
          </div>
          <div class="divider my-0"></div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-13-label" for="settings-posts-field-13">
              {__("Yandex Translation Key")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="yandex_key" value="{$system['yandex_key']}" id="settings-posts-field-13" aria-describedby="settings-posts-field-13-help">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-posts-field-13" aria-describedby="settings-posts-field-13-help">
              {/if}
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-13-help">
                {__("Yandex Cloud service account API key")}
              </div>
            </div>
          </div>
          <div class="divider my-0"></div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-deepl-key-label" for="settings-posts-field-deepl-key">
              {__("DeepL API Key")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="deepl_key" value="{$system['deepl_key']}" id="settings-posts-field-deepl-key" aria-describedby="settings-posts-field-deepl-key-help">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-posts-field-deepl-key" aria-describedby="settings-posts-field-deepl-key-help">
              {/if}
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-deepl-key-help">
                {__("Free and Pro keys are both supported")}
              </div>
            </div>
          </div>
          <div class="divider my-0"></div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-libretranslate-url-label" for="settings-posts-field-libretranslate-url">
              {__("LibreTranslate URL")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="libretranslate_url" value="{$system['libretranslate_url']}" id="settings-posts-field-libretranslate-url" placeholder="https://translate.example.com">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-posts-field-libretranslate-url">
              {/if}
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-libretranslate-key-label" for="settings-posts-field-libretranslate-key">
              {__("LibreTranslate API Key")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              {if !$user->_data['user_demo']}
              <input type="text" class="input w-full" name="libretranslate_key" value="{$system['libretranslate_key']}" id="settings-posts-field-libretranslate-key" aria-describedby="settings-posts-field-libretranslate-key-help">
              {else}
              <input type="password" class="input w-full" value="*********" id="settings-posts-field-libretranslate-key" aria-describedby="settings-posts-field-libretranslate-key-help">
              {/if}
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-libretranslate-key-help">
                {__("Leave empty if your server does not require a key")}
              </div>
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-7">
          <h3 id="settings-posts-posts-card-7" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Video playback")}
          </h3>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="youtube_player" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="smart_yt_player">{__("Smart YouTube Player")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="smart_yt_player-help">
                {__("Smart YouTube player will save a lot of bandwidth")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="smart_yt_player" id="smart_yt_player" {if $system['smart_yt_player']}checked{/if} class="switch switch-primary" aria-describedby="smart_yt_player-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="media-player" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="disable_yt_player">{__("Disable YouTube Player")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="disable_yt_player-help">
                {__("If you disable YouTube player the default system media player will be used instead")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="disable_yt_player" id="disable_yt_player" {if $system['disable_yt_player']}checked{/if} class="switch switch-primary" aria-describedby="disable_yt_player-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="developers" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="video_embed_code_enabled">{__("Video Embed Code Enabled")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="video_embed_code_enabled-help">
                {__("Turn the video embed code enabled On and Off")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="video_embed_code_enabled" id="video_embed_code_enabled" {if $system['video_embed_code_enabled']}checked{/if} class="switch switch-primary" aria-describedby="video_embed_code_enabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="videos" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="auto_play_videos">{__("Auto Play Videos")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="auto_play_videos-help">
                {__("Turn auto play videos On and Off")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="auto_play_videos" id="auto_play_videos" {if $system['auto_play_videos']}checked{/if} class="switch switch-primary" aria-describedby="auto_play_videos-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="fluid_vertical" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="fluid_videos_enabled">{__("Videos Fluid Mode")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="fluid_videos_enabled-help">
                {__("Enable video player fluid mode")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="fluid_videos_enabled" id="fluid_videos_enabled" {if $system['fluid_videos_enabled']}checked{/if} class="switch switch-primary" aria-describedby="fluid_videos_enabled-help">
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-11">
          <h3 id="settings-posts-posts-card-11" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Views")}
          </h3>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="views" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="posts_views_enabled">{__("Posts Views")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="posts_views_enabled-help">
                {__("Turn posts views system On and Off")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="posts_views_enabled" id="posts_views_enabled" {if $system['posts_views_enabled']}checked{/if} class="switch switch-primary" aria-describedby="posts_views_enabled-help">
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-posts-field-19-label">
            <div class="label-text" id="settings-posts-field-19-label">
              {__("Views Type")}
            </div>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                <input type="radio" name="posts_views_type" id="all_views" value="all" class="radio radio-primary" {if $system['posts_views_type'] == "all"}checked{/if} aria-describedby="settings-posts-field-19-help">
                <label class="label-text" for="all_views">{__("All Views")}</label>
              </div>
              <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                <input type="radio" name="posts_views_type" id="unique_views" value="unique" class="radio radio-primary" {if $system['posts_views_type'] == "unique"}checked{/if} aria-describedby="settings-posts-field-19-help">
                <label class="label-text" for="unique_views">{__("Unique Views Only")}</label>
              </div>
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-19-help">
                {__("Note: All views will count all views including the same user multiple views")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="posts_views_period">{__("Unique View Period")}</label>
            <select class="select w-full" name="posts_views_period" id="posts_views_period">
              <option value="lifetime" {if $system['posts_views_period'] == 'lifetime'}selected{/if}>{__("Lifetime")}</option>
              <option value="days" {if $system['posts_views_period'] == 'days'}selected{/if}>{__("Every X Days")}</option>
            </select>
            <div class="admin-setting-help text-sm leading-relaxed">{__("Lifetime keeps viewer history indefinitely. With a limited period, the same viewer can count again when that period has passed.")}</div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="posts_views_days">{__("Unique View Days")}</label>
            <input type="number" min="1" max="36500" step="1" class="input w-full" name="posts_views_days" id="posts_views_days" value="{$system['posts_views_days']|default:1}">
            <div class="admin-setting-help text-sm leading-relaxed">{__("Used only with Every X Days. Cleanup removes expired history; changing to Lifetime cannot restore records already removed.")}</div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-14">
          <h3 id="settings-posts-posts-card-14" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Reviews")}
          </h3>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="star" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="posts_reviews_enabled">{__("Posts Reviews")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="posts_reviews_enabled-help">
                {__("Turn the posts reviews On and Off")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="posts_reviews_enabled" id="posts_reviews_enabled" {if $system['posts_reviews_enabled']}checked{/if} class="switch switch-primary" aria-describedby="posts_reviews_enabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="star" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="posts_reviews_replacement_enabled">{__("Posts Review Replacement")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="posts_reviews_replacement_enabled-help">
                {__("Enbale this to allow user to change his review")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="posts_reviews_replacement_enabled" id="posts_reviews_replacement_enabled" {if $system['posts_reviews_replacement_enabled']}checked{/if} class="switch switch-primary" aria-describedby="posts_reviews_replacement_enabled-help">
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
    {if $system['posts_views_maintenance'] == 'clear' || $system['posts_views_maintenance'] == 'reset'}
      <form class="js_ajax-forms admin-settings-form mt-4 flex min-w-0 flex-col gap-4" data-url="admin/reset.php">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 class="admin-settings-section-title m-0 text-sm font-semibold">{__("Finish Post Views Maintenance")}</h3>
            <p class="admin-setting-help text-sm leading-relaxed">{__("A post views operation stopped before it finished. Re-enter your password to retry it.")}</p>
            <input type="hidden" name="do" value="post_views_recover">
            <label class="label-text" for="post-views-recover-password">{__("Your Password")}</label>
            <input type="password" class="input w-full" name="password_check" id="post-views-recover-password" required autocomplete="current-password">
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice" role="alert" style="display: none"></div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2"><button type="submit" class="btn btn-primary">{__("Retry Maintenance")}</button></div>
          </div>
        </section>
      </form>
    {/if}
  </div>
  <div id="Privacy" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="settings-posts-tab-privacy" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=posts_privacy">
      <div class="admin-settings-layout block">
        <div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-8">
          <h3 id="settings-posts-posts-card-8" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Sharing and privacy")}
          </h3>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="social_share" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="social_share_enabled">{__("Social Media Share")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="social_share_enabled-help">
                {__("Turn the social media share for posts On and Off")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="social_share_enabled" id="social_share_enabled" {if $system['social_share_enabled']}checked{/if} class="switch switch-primary" aria-describedby="social_share_enabled-help">
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-9">
          <h3 id="settings-posts-posts-card-9" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Limits and privacy")}
          </h3>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-14-label" for="settings-posts-field-14">
              {__("Max Post Characters")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="max_post_length" value="{$system['max_post_length']}" id="settings-posts-field-14" aria-describedby="settings-posts-field-14-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-14-help">
                {__("The Maximum allowed post characters length (0 for unlimited)")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-15-label" for="settings-posts-field-15">
              {__("Max Comment Characters")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="max_comment_length" value="{$system['max_comment_length']}" id="settings-posts-field-15" aria-describedby="settings-posts-field-15-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-15-help">
                {__("The Maximum allowed comment characters length (0 for unlimited)")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-22-label" for="settings-posts-field-22">
              {__("Post Read More Lines")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="number" min="1" max="50" class="input w-full" name="posts_read_more_lines" value="{$system['posts_read_more_lines']|default:5}" id="settings-posts-field-22" aria-describedby="settings-posts-field-22-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-22-help">
                {__("Number of text lines shown in a post before Read more")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-23-label" for="settings-posts-field-23">
              {__("Comment Read More Lines")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="number" min="1" max="50" class="input w-full" name="comments_read_more_lines" value="{$system['comments_read_more_lines']|default:3}" id="settings-posts-field-23" aria-describedby="settings-posts-field-23-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-23-help">
                {__("Number of text lines shown in a comment before Read more")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-16-label" for="settings-posts-field-16">
              {__("Max Posts/Hour")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="max_posts_hour" value="{$system['max_posts_hour']}" id="settings-posts-field-16" aria-describedby="settings-posts-field-16-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-16-help">
                {__("The Maximum number of posts that user can publish per hour (0 for unlimited)")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-17-label" for="settings-posts-field-17">
              {__("Max Comments/Hour")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="max_comments_hour" value="{$system['max_comments_hour']}" id="settings-posts-field-17" aria-describedby="settings-posts-field-17-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-17-help">
                {__("The Maximum number of comments that user can publish per hour (0 for unlimited)")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-18-label" for="settings-posts-field-18">
              {__("Default Posts Privacy")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full" name="default_privacy" id="settings-posts-field-18">
                <option value="public" {if $system['default_privacy'] == "public"}selected{/if}>{__("Public")}</option>
                <option value="friends" {if $system['default_privacy'] == "friends"}selected{/if}>{__("Friends")}</option>
                <option value="me" {if $system['default_privacy'] == "me"}selected{/if}>{__("Only Me")}</option>
              </select>
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="user_online" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="posts_online_status">{__("Online Status on Posts")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="posts_online_status-help">
                {__("Turn online indicator on Posts On and Off (User must be online and enabled the chat)")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="posts_online_status" id="posts_online_status" {if $system['posts_online_status']}checked{/if} class="switch switch-primary" aria-describedby="posts_online_status-help">
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-12">
          <h3 id="settings-posts-posts-card-12" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Trending hashtags")}
          </h3>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="trending" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="trending_hashtags_enabled">{__("Trending Hashtags")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="trending_hashtags_enabled-help">
                {__("Turn the trending hashtags feature On and Off")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="trending_hashtags_enabled" id="trending_hashtags_enabled" {if $system['trending_hashtags_enabled']}checked{/if} class="switch switch-primary" aria-describedby="trending_hashtags_enabled-help">
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-20-label" for="settings-posts-field-20">
              {__("Trending Interval")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full" name="trending_hashtags_interval" id="settings-posts-field-20" aria-describedby="settings-posts-field-20-help">
                <option {if $system['trending_hashtags_interval'] == "day"}selected{/if} value="day">{__("Last 24 Hours")}</option>
                <option {if $system['trending_hashtags_interval'] == "week"}selected{/if} value="week">{__("Last 7 Days")}</option>
                <option {if $system['trending_hashtags_interval'] == "month"}selected{/if} value="month">{__("Last 30 Days")}</option>
              </select>
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-20-help">
                {__("Select the interval of trending hashtags")}
              </div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" id="settings-posts-field-21-label" for="settings-posts-field-21">
              {__("Hashtags Limit")}
            </label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="trending_hashtags_limit" value="{$system['trending_hashtags_limit']}" id="settings-posts-field-21" aria-describedby="settings-posts-field-21-help">
              <div class="admin-setting-help text-sm leading-relaxed" id="settings-posts-field-21-help">
                {__("How many hashtags you want to display")}
              </div>
            </div>
          </div>
        </div>
      <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-posts-posts-card-13">
          <h3 id="settings-posts-posts-card-13" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Media protection")}
          </h3>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="download" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="download_images_disabled">{__("Disable Download Images")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="download_images_disabled-help">
                {__("Enable this to disable download images in lightbox modal")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="download_images_disabled" id="download_images_disabled" {if $system['download_images_disabled']}checked{/if} class="switch switch-primary" aria-describedby="download_images_disabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="download" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="download_videos_disabled">{__("Disable Download Videos")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="download_videos_disabled-help">
                {__("Enable this to disable download videos in lightbox modal")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="download_videos_disabled" id="download_videos_disabled" {if $system['download_videos_disabled']}checked{/if} class="switch switch-primary" aria-describedby="download_videos_disabled-help">
            </div>
          </div>
          <div class="admin-setting-switch js_admin-setting-switch">
            <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="right_click" class="admin-setting-glyph" width="32px" height="32px"}
            </div>
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="right_click_disabled">{__("Disable Mouse Right Click")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="right_click_disabled-help">
                {__("Enable this to disable mouse right click on images")}
              </div>
            </div>
            <div class="text-end">
              <input type="checkbox" name="right_click_disabled" id="right_click_disabled" {if $system['right_click_disabled']}checked{/if} class="switch switch-primary" aria-describedby="right_click_disabled-help">
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
