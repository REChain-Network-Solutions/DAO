<!-- card-header -->
<div class="card-header with-icon">
  <!-- panel title -->
  <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("Posts")}
  <!-- panel title -->
</div>
<!-- card-header -->

<!-- Posts -->
<form class="js_ajax-forms" data-url="admin/settings.php?edit=posts">
  <div class="card-body">
    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="24_hours" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Stories")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the stories On and Off")}<br>
          {__("Stories are photos and videos that only last 24 hours")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="stories_enabled">
          <input type="checkbox" name="stories_enabled" id="stories_enabled" {if $system['stories_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Story Duration")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="stories_duration" value="{$system['stories_duration']}">
        <div class="form-text">
          {__("The story duration in seconds")}
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Newsfeed Posts Source")}
      </label>
      <div class="col-md-9">
        <select class="form-select" name="newsfeed_source">
          <option value="default" {if $system['newsfeed_source'] == "default"}selected{/if}>{__("Default")} [{__("Show what user is followings (Friends, Followings, Pages... etc)")}]</option>
          <option value="all_posts" {if $system['newsfeed_source'] == "all_posts"}selected{/if}>{__("All Posts")} [{__("All posts will be shown")}]</option>
        </select>
        <div class="form-text">
          {__("Algorithm will exclude any post from closed/secret groups and events that users not member of incase of all posts also will disable all posts privacy")}
        </div>
      </div>
    </div>

    <div class="divider dashed"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="merge" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Newsfeed Merge")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the newsfeed merge On and Off")}<br>
          {__("Will enable the newsfeed algorithm to merge posts from recent, popular & discover sources")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="newsfeed_merge_enabled">
          <input type="checkbox" name="newsfeed_merge_enabled" id="newsfeed_merge_enabled" {if $system['newsfeed_merge_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Recent Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="merge_recent_results" value="{$system['merge_recent_results']}">
        <div class="form-text">
          {__("How many posts to show from recent source")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Popular Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="merge_popular_results" value="{$system['merge_popular_results']}">
        <div class="form-text">
          {__("How many posts to show from popular source")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Discover Results")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="merge_discover_results" value="{$system['merge_discover_results']}">
        <div class="form-text">
          {__("How many posts to show from discover source")}
        </div>
      </div>
    </div>

    <div class="divider dashed"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="database" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Newsfeed Caching")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the newsfeed caching On and Off")}<br>
          {__("Delivers fresh, unique content on every refresh with a smart caching algorithm")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="newsfeed_caching_enabled">
          <input type="checkbox" name="newsfeed_caching_enabled" id="newsfeed_caching_enabled" {if $system['newsfeed_caching_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider dashed"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="cache-cleaner" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Enhance Newsfeed Infinite Scroll")}</div>
        <div class="form-text d-none d-sm-block">{__("Ensures smooth newsfeed browsing experience by seamlessly replacing older results at the top with new ones")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="smooth_infinite_scroll">
          <input type="checkbox" name="smooth_infinite_scroll" id="smooth_infinite_scroll" {if $system['smooth_infinite_scroll']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider dashed"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="map" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Newsfeed Country Filter")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the newsfeed country filter On and Off")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="newsfeed_location_filter_enabled">
          <input type="checkbox" name="newsfeed_location_filter_enabled" id="newsfeed_location_filter_enabled" {if $system['newsfeed_location_filter_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="verification" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Posts Approval System")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the approval system On and Off (If disabled all posts will be approved by default)")}<br>
          {__("If enabled, posts will be pending for approval by the admin or moderators")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="posts_approval_enabled">
          <input type="checkbox" name="posts_approval_enabled" id="posts_approval_enabled" {if $system['posts_approval_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Appoval Limit")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="posts_approval_limit" value="{$system['posts_approval_limit']}">
        <div class="form-text">
          {__("After how many posts needs to be approved so the user can post without approval")}
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="popularity" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Popular Posts")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the popular posts On and Off")}<br>
          {__("Popular posts are public posts ordered by most reactions, comments & shares")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="popular_posts_enabled">
          <input type="checkbox" name="popular_posts_enabled" id="popular_posts_enabled" {if $system['popular_posts_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Popular Interval")}
      </label>
      <div class="col-md-9">
        <select class="form-select" name="popular_posts_interval">
          <option {if $system['popular_posts_interval'] == "day"}selected{/if} value="day">{__("Last 24 Hours")}</option>
          <option {if $system['popular_posts_interval'] == "week"}selected{/if} value="week">{__("Last 7 Days")}</option>
          <option {if $system['popular_posts_interval'] == "month"}selected{/if} value="month">{__("Last 30 Days")}</option>
          <option {if $system['popular_posts_interval'] == "year"}selected{/if} value="year">{__("Last 12 Months")}</option>
        </select>
        <div class="form-text">
          {__("Select the interval of popular posts")}
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="posts_discover" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Discover Posts")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the discover posts On and Off")}<br>
          {__("Discover posts are public posts ordered from most recent to old")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="discover_posts_enabled">
          <input type="checkbox" name="discover_posts_enabled" id="discover_posts_enabled" {if $system['discover_posts_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="memories" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Memories")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the memories On and Off")}<br>
          {__("Memories are posts from the same day on last year")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="memories_enabled">
          <input type="checkbox" name="memories_enabled" id="memories_enabled" {if $system['memories_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="wall_posts" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Wall Posts")}</div>
        <div class="form-text d-none d-sm-block">{__("Users can publish posts on their friends walls")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="wall_posts_enabled">
          <input type="checkbox" name="wall_posts_enabled" id="wall_posts_enabled" {if $system['wall_posts_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="schedule" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Schedule Posts")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the schedule posts On and Off")}<br>
          {__("If enabled, users will be able to schedule posts to be published in the future")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="posts_schedule_enabled">
          <input type="checkbox" name="posts_schedule_enabled" id="posts_schedule_enabled" {if $system['posts_schedule_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="spy" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Post As Anonymous")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn Anonymous mode On and Off")}<br>
          {__("Note: Admins and Moderators will able to see the real post author")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="anonymous_mode">
          <input type="checkbox" name="anonymous_mode" id="anonymous_mode" {if $system['anonymous_mode']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="adult" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Adult Mode")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Adult mode will hide content that marked for adult from users under 18 years old")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="adult_mode">
          <input type="checkbox" name="adult_mode" id="adult_mode" {if $system['adult_mode']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="collaborative" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Collaborative Posts")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the collaborative posts On and Off")}<br>
          {__("If enabled, users will be able to collaborate on posts and share revenues in paid posts")}
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="collaborative_posts_enabled">
          <input type="checkbox" name="collaborative_posts_enabled" id="collaborative_posts_enabled" {if $system['collaborative_posts_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="posts_colored" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Colored Posts")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the colored posts On and Off")}<br>
          {__("Make sure you have configured")} <a href="{$system['system_url']}/{$control_panel['url']}/colored_posts">{__("Colored Posts")}</a>
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="colored_posts_enabled">
          <input type="checkbox" name="colored_posts_enabled" id="colored_posts_enabled" {if $system['colored_posts_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="smile" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Feelings/Activity Posts")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the feelings and activity posts On and Off")}<br>
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="activity_posts_enabled">
          <input type="checkbox" name="activity_posts_enabled" id="activity_posts_enabled" {if $system['activity_posts_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="voice_notes" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Voice Notes in Posts")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the voice notes in posts On and Off")}<br>
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="voice_notes_posts_enabled">
          <input type="checkbox" name="voice_notes_posts_enabled" id="voice_notes_posts_enabled" {if $system['voice_notes_posts_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="form-table-row">
      <div class="avatar">
        <div style="width: 40px; height: 40px;"></div>
      </div>
      <div>
        <div class="form-label h6">{__("Voice Notes in Comments")}</div>
        <div class="form-text d-none d-sm-block">
          {__("Turn the voice notes in comments On and Off")}<br>
        </div>
      </div>
      <div class="text-end">
        <label class="switch" for="voice_notes_comments_enabled">
          <input type="checkbox" name="voice_notes_comments_enabled" id="voice_notes_comments_enabled" {if $system['voice_notes_comments_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Voice Notes Max Duration")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="voice_notes_durtaion" value="{$system['voice_notes_durtaion']}">
        <div class="form-text">
          {__("The maximum length for voice note in seconds")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Voice Notes Encoding")}
      </label>
      <div class="col-md-9">
        <select class="form-select" name="voice_notes_encoding">
          <option value="mp3" {if $system['voice_notes_encoding'] == "mp3"}selected{/if}>mp3</option>
          <option value="ogg" {if $system['voice_notes_encoding'] == "ogg"}selected{/if}>ogg</option>
          <option value="wav" {if $system['voice_notes_encoding'] == "wav"}selected{/if}>wav</option>
        </select>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="polls" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Polls")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn the poll posts On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="polls_enabled">
          <input type="checkbox" name="polls_enabled" id="polls_enabled" {if $system['polls_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="map" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Geolocation")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn the post Geolocation On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="geolocation_enabled">
          <input type="checkbox" name="geolocation_enabled" id="geolocation_enabled" {if $system['geolocation_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Geolocation Google Key")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="geolocation_key" value="{$system['geolocation_key']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
        <div class="form-text">
          {__("Check the documentation to learn how to get this key")}
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="gif" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("GIF")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn the gif posts On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="gif_enabled">
          <input type="checkbox" name="gif_enabled" id="gif_enabled" {if $system['gif_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Giphy API Key")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="giphy_key" value="{$system['giphy_key']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
        <div class="form-text">
          {__("Check the documentation to learn how to get this key")}
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="user_information" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Disable Profile Posts Updates")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn it on to disable changing profile picture and cover posts")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="profile_posts_updates_disabled">
          <input type="checkbox" name="profile_posts_updates_disabled" id="profile_posts_updates_disabled" {if $system['profile_posts_updates_disabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="language" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Post Translation")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn the post translation On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="post_translation_enabled">
          <input type="checkbox" name="post_translation_enabled" id="post_translation_enabled" {if $system['post_translation_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Google Translation Key")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="google_translation_key" value="{$system['google_translation_key']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
        <div class="form-text">
          {__("Check the documentation to learn how to get this key")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Yandex Translation Key")}
      </label>
      <div class="col-md-9">
        {if !$user->_data['user_demo']}
          <input type="text" class="form-control" name="yandex_key" value="{$system['yandex_key']}">
        {else}
          <input type="password" class="form-control" value="*********">
        {/if}
        <div class="form-text">
          {__("Check the documentation to learn how to get this key")}
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="youtube_player" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Smart YouTube Player")}</div>
        <div class="form-text d-none d-sm-block">{__("Smart YouTube player will save a lot of bandwidth")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="smart_yt_player">
          <input type="checkbox" name="smart_yt_player" id="smart_yt_player" {if $system['smart_yt_player']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="media-player" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Disable YouTube Player")}</div>
        <div class="form-text d-none d-sm-block">{__("If you disable YouTube player the default system media player will be used instead")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="disable_yt_player">
          <input type="checkbox" name="disable_yt_player" id="disable_yt_player" {if $system['disable_yt_player']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="social_share" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Social Media Share")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn the social media share for posts On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="social_share_enabled">
          <input type="checkbox" name="social_share_enabled" id="social_share_enabled" {if $system['social_share_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Max Post Characters")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="max_post_length" value="{$system['max_post_length']}">
        <div class="form-text">
          {__("The Maximum allowed post characters length (0 for unlimited)")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Max Comment Characters")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="max_comment_length" value="{$system['max_comment_length']}">
        <div class="form-text">
          {__("The Maximum allowed comment characters length (0 for unlimited)")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Max Posts/Hour")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="max_posts_hour" value="{$system['max_posts_hour']}">
        <div class="form-text">
          {__("The Maximum number of posts that user can publish per hour (0 for unlimited)")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Max Comments/Hour")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="max_comments_hour" value="{$system['max_comments_hour']}">
        <div class="form-text">
          {__("The Maximum number of comments that user can publish per hour (0 for unlimited)")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Default Posts Privacy")}
      </label>
      <div class="col-md-9">
        <select class="form-select" name="default_privacy">
          <option value="public" {if $system['default_privacy'] == "public"}selected{/if}>{__("Public")}</option>
          <option value="friends" {if $system['default_privacy'] == "friends"}selected{/if}>{__("Friends")}</option>
          <option value="me" {if $system['default_privacy'] == "me"}selected{/if}>{__("Only Me")}</option>
        </select>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="user_online" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Online Status on Posts")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn online indicator on Posts On and Off (User must be online and enabled the chat)")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="posts_online_status">
          <input type="checkbox" name="posts_online_status" id="posts_online_status" {if $system['posts_online_status']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="scroll_desktop" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Desktop Infinite Scroll")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn infinite scroll on desktop screens On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="desktop_infinite_scroll">
          <input type="checkbox" name="desktop_infinite_scroll" id="desktop_infinite_scroll" {if $system['desktop_infinite_scroll']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="scroll_mobile" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Mobile Infinite Scroll")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn infinite scroll on mobile screens On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="mobile_infinite_scroll">
          <input type="checkbox" name="mobile_infinite_scroll" id="mobile_infinite_scroll" {if $system['mobile_infinite_scroll']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="videos" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Auto Play Videos")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn auto play videos On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="auto_play_videos">
          <input type="checkbox" name="auto_play_videos" id="auto_play_videos" {if $system['auto_play_videos']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="fluid_vertical" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Videos Fluid Mode")}</div>
        <div class="form-text d-none d-sm-block">{__("Enable video player fluid mode")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="fluid_videos_enabled">
          <input type="checkbox" name="fluid_videos_enabled" id="fluid_videos_enabled" {if $system['fluid_videos_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="views" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Posts Views")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn posts views system On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="posts_views_enabled">
          <input type="checkbox" name="posts_views_enabled" id="posts_views_enabled" {if $system['posts_views_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Views Type")}
      </label>
      <div class="col-md-9">
        <div class="form-check form-check-inline">
          <input type="radio" name="posts_views_type" id="all_views" value="all" class="form-check-input" {if $system['posts_views_type'] == "all"}checked{/if}>
          <label class="form-check-label" for="all_views">{__("All Views")}</label>
        </div>
        <div class="form-check form-check-inline">
          <input type="radio" name="posts_views_type" id="unique_views" value="unique" class="form-check-input" {if $system['posts_views_type'] == "unique"}checked{/if}>
          <label class="form-check-label" for="unique_views">{__("Unique Views Only")}</label>
        </div>
        <div class="form-text">
          {__("Note: All views will count all views including the same user multiple views")}
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="star" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6">{__("Posts Reviews")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn the posts reviews On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="posts_reviews_enabled">
          <input type="checkbox" name="posts_reviews_enabled" id="posts_reviews_enabled" {if $system['posts_reviews_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="form-table-row">
      <div class="avatar">
        <div style="width: 40px; height: 40px;"></div>
      </div>
      <div>
        <div class="form-label h6">{__("Posts Review Replacement")}</div>
        <div class="form-text d-none d-sm-block">{__("Enbale this to allow user to change his review")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="posts_reviews_replacement_enabled">
          <input type="checkbox" name="posts_reviews_replacement_enabled" id="posts_reviews_replacement_enabled" {if $system['posts_reviews_replacement_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="trending" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Trending Hashtags")}</div>
        <div class="form-text d-none d-sm-block">{__("Turn the trending hashtags feature On and Off")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="trending_hashtags_enabled">
          <input type="checkbox" name="trending_hashtags_enabled" id="trending_hashtags_enabled" {if $system['trending_hashtags_enabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Trending Interval")}
      </label>
      <div class="col-md-9">
        <select class="form-select" name="trending_hashtags_interval">
          <option {if $system['trending_hashtags_interval'] == "day"}selected{/if} value="day">{__("Last 24 Hours")}</option>
          <option {if $system['trending_hashtags_interval'] == "week"}selected{/if} value="week">{__("Last 7 Days")}</option>
          <option {if $system['trending_hashtags_interval'] == "month"}selected{/if} value="month">{__("Last 30 Days")}</option>
        </select>
        <div class="form-text">
          {__("Select the interval of trending hashtags")}
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Hashtags Limit")}
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="trending_hashtags_limit" value="{$system['trending_hashtags_limit']}">
        <div class="form-text">
          {__("How many hashtags you want to display")}
        </div>
      </div>
    </div>

    <div class="divider"></div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="download" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Disable Download Images")}</div>
        <div class="form-text d-none d-sm-block">{__("Enable this to disable download images in lightbox modal")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="download_images_disabled">
          <input type="checkbox" name="download_images_disabled" id="download_images_disabled" {if $system['download_images_disabled']}checked{/if}>
          <span class="slider round"></span>
        </label>
      </div>
    </div>

    <div class="form-table-row">
      <div class="avatar">
        {include file='__svg_icons.tpl' icon="right_click" class="main-icon" width="40px" height="40px"}
      </div>
      <div>
        <div class="form-label h6 mb5">{__("Disable Mouse Right Click")}</div>
        <div class="form-text d-none d-sm-block">{__("Enable this to disable mouse right click on images")}</div>
      </div>
      <div class="text-end">
        <label class="switch" for="right_click_disabled">
          <input type="checkbox" name="right_click_disabled" id="right_click_disabled" {if $system['right_click_disabled']}checked{/if}>
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
<!-- Posts -->



</div>