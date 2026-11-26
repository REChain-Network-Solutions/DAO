<!-- post header -->
<div class="post-header flex items-start gap-3 {if $_shared}px-4 pt-3.5 pb-2{else}px-4 pt-4 pb-2.5{/if}">

  <!-- post picture -->
  <div class="post-avatar relative shrink-0">
    {if $_post['is_anonymous']}
      <div class="post-avatar-anonymous flex {if $_shared}size-9{else}size-11{/if} items-center justify-center overflow-hidden rounded-full bg-base-200 text-base-content/60">
        {include file='__svg_icons.tpl' icon="spy" class="main-icon" width="22px" height="22px"}
      </div>
    {else}
      {if !$_shared && $_post['author_story']}
        <a class="post-avatar-picture js_story-open js_story-ring block size-11 rounded-full bg-base-200 bg-cover bg-center ring-2 ring-fuchsia-500 ring-offset-2 ring-offset-base-100 focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-primary data-[seen=true]:ring-base-content/25" href="{$_post['post_author_url']}" data-user-id="{$_post['user_id']}" data-seen="{if $_post['author_story'] == "seen"}true{else}false{/if}" style="background-image:url({$_post['post_author_picture']});" title='{__("View story")}' aria-label="{$_post['post_author_name']}"></a>
      {else}
        <a class="post-avatar-picture block {if $_shared}size-9{else}size-11{/if} rounded-full bg-base-200 bg-cover bg-center ring-1 ring-base-content/5 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" href="{$_post['post_author_url']}" style="background-image:url({$_post['post_author_picture']});" aria-label="{$_post['post_author_name']}"></a>
      {/if}
      {if $_post['post_author_online']}<span class="online-dot absolute end-0 bottom-0 size-3 rounded-full bg-success ring-2 ring-base-100" title="{__("Online")}"></span>{/if}
    {/if}
  </div>
  <!-- post picture -->

  <!-- post meta -->
  <div class="post-meta min-w-0 flex-1 {if !$_shared}pt-0.5{/if} text-sm leading-5 wrap-break-word">
    <div class="text-base-content/60 [&_a]:font-semibold [&_a]:text-base-content! [&_a:hover]:text-primary!">
      <!-- post author -->
      {if $_post['is_anonymous']}
        <span class="post-author font-semibold text-base-content">{__("Anonymous")}</span>
      {else}
        <span class="js_user-popover" data-type="{$_post['user_type']}" data-uid="{$_post['user_id']}">
          <a class="post-author text-[0.9375rem]" href="{$_post['post_author_url']}">{$_post['post_author_name']}</a>
        </span>
        {if $_post['post_author_verified']}
          {include file='__badge.tpl' _badge="verified" _badge_type=$_post['user_type'] _badge_size=20 _badge_class="align-[-5px]"}
        {/if}
        {if $_post['user_subscribed']}
          {include file='__badge.tpl' _badge="pro" _badge_package=$_post['package_name'] _badge_size=20 _badge_class="align-[-5px]"}
        {/if}
      {/if}
      <!-- post author -->

      <!-- post-title -->
      <span class="post-title">
        {if !$_shared && $_post['post_type'] == "shared"}
          {__("shared")}
          {if $_post['origin']['is_anonymous']}
            {__("Anonymous post")}
          {else}
            <span class="js_user-popover" data-type="{$_post['origin']['user_type']}" data-uid="{$_post['origin']['user_id']}">
              <a href="{$_post['origin']['post_author_url']}">
                {$_post['origin']['post_author_name']}
              </a>{__("'s")}
            </span>
            <a href="{$system['system_url']}/posts/{$_post['origin']['post_id']}">
              {if $_post['origin']['post_type'] == 'link'}
                {__("link")}

              {elseif $_post['origin']['post_type'] == 'media'}
                {if $_post['origin']['media']['media_type'] != "soundcloud"}
                  {__("video")}
                {else}
                  {__("song")}
                {/if}

              {elseif $_post['origin']['post_type'] == 'photos'}
                {if $_post['origin']['photos_num'] > 1}{__("photos")}{else}{__("photo")}{/if}

              {elseif $_post['origin']['post_type'] == 'album'}
                {__("album")}

              {elseif $_post['origin']['post_type'] == 'poll'}
                {__("poll")}

              {elseif $_post['origin']['post_type'] == 'reel'}
                {__("reel")}

              {elseif $_post['origin']['post_type'] == 'video'}
                {__("video")}

              {elseif $_post['origin']['post_type'] == 'audio'}
                {__("audio")}

              {elseif $_post['origin']['post_type'] == 'file'}
                {__("file")}

              {else}
                {__("post")}
              {/if}
            </a>
          {/if}

        {elseif $_post['post_type'] == "link"}
          {__("shared a link")}

        {elseif $_post['post_type'] == "live"}
          {if $_post['live']['live_ended']}
            {__("was live")}
          {else}
            {__("is live now")}
          {/if}
          {if $_post['live']['category_name']}<a href="{$system['system_url']}/live/category/{$_post['live']['category_id']}/{$_post['live']['category_url']}" class="blog-category">{__($_post['live']['category_name'])}</a>{/if}

        {elseif $_post['post_type'] == "photos"}
          {if $_post['photos_num'] == 1}
            {__("added a photo")}
          {else}
            {__("added")} {$_post['photos_num']} {__("photos")}
          {/if}

        {elseif $_post['post_type'] == "album"}
          {__("added")} {$_post['photos_num']} {__("photos to the album")}: <a href="{$system['system_url']}/{$_post['album']['path']}/album/{$_post['album']['album_id']}">{$_post['album']['title']}</a>

        {elseif $_post['post_type'] == "profile_picture"}
          {__("updated the profile picture")}

        {elseif $_post['post_type'] == "profile_cover"}
          {__("updated the cover photo")}

        {elseif $_post['post_type'] == "page_picture"}
          {__("updated page picture")}

        {elseif $_post['post_type'] == "page_cover"}
          {__("updated cover photo")}

        {elseif $_post['post_type'] == "group_picture"}
          {__("updated group picture")}

        {elseif $_post['post_type'] == "group_cover"}
          {__("updated group cover")}

        {elseif $_post['post_type'] == "event_cover"}
          {__("updated event cover")}

        {elseif $_post['post_type'] == "rich_text"}
          {__("added write-up")}

        {elseif $_post['post_type'] == "article"}
          {__("added blog")} {if $_post['blog']['category_name']}<a href="{$system['system_url']}/blogs/category/{$_post['blog']['category_id']}/{$_post['blog']['category_url']}" class="blog-category">{__($_post['blog']['category_name'])}</a>{/if}

        {elseif $_post['post_type'] == "product"}
          {__("added product for sale")}

        {elseif $_post['post_type'] == "funding"}
          {__("raised funding request")}

        {elseif $_post['post_type'] == "offer"}
          {__("added offer")}

        {elseif $_post['post_type'] == "job"}
          {__("added job")}

        {elseif $_post['post_type'] == "course"}
          {__("added course")}

        {elseif $_post['post_type'] == "poll"}
          {__("added poll")}

        {elseif $_post['post_type'] == "reel"}
          {__("added reel")}

        {elseif $_post['post_type'] == "video"}
          {__("added video")} {if $_post['video']['category_name']}<a href="{$system['system_url']}/watch/category/{$_post['video']['category_id']}/{$_post['video']['category_url']}" class="blog-category">{__($_post['video']['category_name'])}</a>{/if}

        {elseif $_post['post_type'] == "audio"}
          {__("added audio")}

        {elseif $_post['post_type'] == "file"}
          {__("added file")}

        {elseif $_post['post_type'] == "merit"}
          {__("sent merit")} {if $_post['merit']['category_name']}<span class="badge badge-sm badge-soft badge-info rounded-full align-middle">{__($_post['merit']['category_name'])}</span>{/if}

        {elseif $_post['post_type'] == "group"}
          {__("created group")}

        {elseif $_post['post_type'] == "event"}
          {__("created event")}

        {/if}

        {if $_get != 'posts_group' && $_post['in_group']}
          <span class="icon-[tabler--caret-right-filled] mx-0.5 size-3.5 align-[-2px] text-base-content/40 rtl:rotate-180" aria-hidden="true"></span>
          <span class="icon-[tabler--users-group] me-0.5 size-4 align-[-3px]" aria-hidden="true"></span>
          <a href="{$system['system_url']}/groups/{$_post['group_name']}">{$_post['group_title']}</a>
        {elseif $_get != 'posts_event' && $_post['in_event']}
          <span class="icon-[tabler--caret-right-filled] mx-0.5 size-3.5 align-[-2px] text-base-content/40 rtl:rotate-180" aria-hidden="true"></span>
          <span class="icon-[tabler--calendar-event] me-0.5 size-4 align-[-3px]" aria-hidden="true"></span>
          <a href="{$system['system_url']}/events/{$_post['event_id']}">{$_post['event_title']}</a>
        {elseif $_post['in_wall']}
          <span class="icon-[tabler--caret-right-filled] mx-0.5 size-3.5 align-[-2px] text-base-content/40 rtl:rotate-180" aria-hidden="true"></span>
          <span class="js_user-popover" data-type="user" data-uid="{$_post['wall_id']}">
            <a href="{$system['system_url']}/{$_post['wall_username']}">{$_post['wall_fullname']}</a>
          </span>
        {elseif $_post['is_collaborative']}
          <span class="icon-[tabler--users] mx-0.5 size-4 align-[-3px]" aria-hidden="true"></span>
          {__("collaborated with")}
          {foreach $_post['collaborative_users'] as $_user}
            <span class="js_user-popover" data-type="user" data-uid="{$_user['user_id']}">
              <a href="{$system['system_url']}/{$_user['user_name']}">{$_user['user_fullname']}</a>
            </span>
            {if !$_user@last}
              <span class="text-base-content/60">,</span>
            {/if}
          {/foreach}
        {/if}
      </span>
      <!-- post-title -->

      <!-- post feeling -->
      {if $_post['feeling_action']}
        <span class="post-title text-base-content/60">
          {if $_post['post_type'] != "" && $_post['post_type'] != "map"  && $_post['post_type'] != "media"} & {/if}{__("is")} {__($_post["feeling_action"])} {__($_post["feeling_value"])} <span class="inline-block text-lg">{get_feeling_emoji($_post['feeling_icon'])}</span>
        </span>
      {/if}
      <!-- post feeling -->

    </div>

    <!-- post time & location & privacy -->
    <div class="post-time mt-0.5 flex flex-wrap items-center gap-x-1.5 gap-y-1 text-xs leading-5 text-base-content/55">
      <a href="{$system['system_url']}/posts/{$_post['post_id']}" class="js_moment rounded-field text-base-content/55! hover:text-base-content! hover:underline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" data-time="{$_post['time']}">{$_post['time']}</a>
      {if $system['newsfeed_source'] == "default"}
        <span aria-hidden="true">·</span>
        {if !$_post['is_anonymous'] && !$_shared && $_post['manage_post'] && $_post['user_type'] == 'user' && !$_post['in_group'] && !$_post['in_event'] && !in_array($_post['post_type'], ['rich_text', 'article', 'product', 'funding'])}
          <!-- privacy -->
          <div class="dropdown group/privacy relative inline-flex [--offset:6] {if $system['language']['dir'] == 'RTL'}[--placement:bottom-end]{else}[--placement:bottom-start]{/if}">
            <button type="button" class="dropdown-toggle -mx-1 inline-flex h-6 cursor-pointer items-center gap-1 rounded-field px-1 text-base-content/55 hover:bg-base-200 hover:text-base-content focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Privacy")}">
              <span class="icon-[tabler--world] hidden size-3.5 group-has-[[value=public]:checked]/privacy:inline-block" aria-hidden="true"></span>
              <span class="icon-[tabler--users] hidden size-3.5 group-has-[[value=friends]:checked]/privacy:inline-block" aria-hidden="true"></span>
              <span class="icon-[tabler--lock] hidden size-3.5 group-has-[[value=me]:checked]/privacy:inline-block" aria-hidden="true"></span>
              <span class="icon-[tabler--settings] hidden size-3.5 group-has-[[value=custom]:checked]/privacy:inline-block" aria-hidden="true"></span>
              <span class="hidden group-has-[[value=public]:checked]/privacy:inline">{__("Public")}</span>
              <span class="hidden group-has-[[value=friends]:checked]/privacy:inline">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</span>
              <span class="hidden group-has-[[value=me]:checked]/privacy:inline">{__("Only Me")}</span>
              <span class="hidden group-has-[[value=custom]:checked]/privacy:inline">{__("Custom People")}</span>
              <span class="icon-[tabler--chevron-down] size-3 transition-transform dropdown-open:rotate-180" aria-hidden="true"></span>
            </button>
            <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-60 max-w-[calc(100vw-2rem)] rounded-2xl border border-base-300 bg-base-100 p-2 shadow-lg" role="menu" aria-label="{__("Privacy")}">
              <label class="dropdown-close dropdown-item flex min-h-11 w-full cursor-pointer items-center gap-3 rounded-xl px-3 py-2 text-sm font-medium text-base-content! has-checked:bg-base-200" role="menuitemradio">
                <input type="radio" class="js_edit-privacy peer sr-only" name="privacy_{$_post['post_id']}" value="public" {if $_post['privacy'] == "public"}checked{/if}>
                <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-base-200 peer-checked:bg-primary/10 peer-checked:text-primary"><span class="icon-[tabler--world] size-4.5" aria-hidden="true"></span></span>
                <span class="min-w-0 flex-1">{__("Public")}</span>
                <span class="icon-[tabler--check] hidden size-4 text-primary peer-checked:inline-block" aria-hidden="true"></span>
              </label>
              <label class="dropdown-close dropdown-item flex min-h-11 w-full cursor-pointer items-center gap-3 rounded-xl px-3 py-2 text-sm font-medium text-base-content! has-checked:bg-base-200" role="menuitemradio">
                <input type="radio" class="js_edit-privacy peer sr-only" name="privacy_{$_post['post_id']}" value="friends" {if $_post['privacy'] == "friends"}checked{/if}>
                <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-base-200 peer-checked:bg-primary/10 peer-checked:text-primary"><span class="icon-[tabler--users] size-4.5" aria-hidden="true"></span></span>
                <span class="min-w-0 flex-1">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</span>
                <span class="icon-[tabler--check] hidden size-4 text-primary peer-checked:inline-block" aria-hidden="true"></span>
              </label>
              <label class="dropdown-close dropdown-item flex min-h-11 w-full cursor-pointer items-center gap-3 rounded-xl px-3 py-2 text-sm font-medium text-base-content! has-checked:bg-base-200" role="menuitemradio">
                <input type="radio" class="js_edit-privacy peer sr-only" name="privacy_{$_post['post_id']}" value="me" {if $_post['privacy'] == "me"}checked{/if}>
                <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-base-200 peer-checked:bg-primary/10 peer-checked:text-primary"><span class="icon-[tabler--lock] size-4.5" aria-hidden="true"></span></span>
                <span class="min-w-0 flex-1">{__("Only Me")}</span>
                <span class="icon-[tabler--check] hidden size-4 text-primary peer-checked:inline-block" aria-hidden="true"></span>
              </label>
              {if $_post['privacy'] == "custom"}
                <input type="radio" class="hidden" name="privacy_{$_post['post_id']}" value="custom" checked disabled>
              {/if}
            </div>
          </div>
          <!-- privacy -->
        {else}
          {if $_post['privacy'] == "me"}
            <span class="inline-flex items-center" title='{__("Shared with")} {__("Only Me")}'><i class="icon-[tabler--lock] size-3.5" aria-hidden="true"></i><span class="sr-only">{__("Only Me")}</span></span>
          {elseif $_post['privacy'] == "friends"}
            <span class="inline-flex items-center" title='{__("Shared with")} {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}'><i class="icon-[tabler--users] size-3.5" aria-hidden="true"></i><span class="sr-only">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</span></span>
          {elseif $_post['privacy'] == "public"}
            <span class="inline-flex items-center" title='{__("Shared with")} {__("Public")}'><i class="icon-[tabler--world] size-3.5" aria-hidden="true"></i><span class="sr-only">{__("Public")}</span></span>
          {elseif $_post['privacy'] == "custom"}
            <span class="inline-flex items-center" title='{__("Shared with")} {__("Custom People")}'><i class="icon-[tabler--settings] size-3.5" aria-hidden="true"></i><span class="sr-only">{__("Custom People")}</span></span>
          {/if}
        {/if}
      {/if}
      {if $_post['location']}
        <span aria-hidden="true">·</span>
        <span class="inline-flex min-w-0 items-center gap-1">
          <i class="icon-[tabler--map-pin] size-3.5 shrink-0" aria-hidden="true"></i><span class="wrap-break-word">{$_post['location']}</span>
        </span>
      {/if}
      {if $system['post_translation_enabled'] && $_post['can_get_details'] && !$_post['needs_pro_package'] && !$_post['needs_permission'] && (!is_empty($_post['text_plain']) || in_array($_post['post_type'], ['funding', 'offer', 'job', 'course']))}
        <span aria-hidden="true">·</span>
        <button type="button" class="js_translator js_translator-icon -mx-0.5 inline-flex size-6 cursor-pointer items-center justify-center rounded-full text-base-content/55 transition-colors hover:bg-base-200 hover:text-primary focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary disabled:pointer-events-none disabled:opacity-40" data-node-type="post" data-node-id="{$_post['post_id']}" title="{__("Translate")}" aria-label="{__("Translate")}"><span class="icon-[tabler--language] size-4" aria-hidden="true"></span></button>
      {/if}
      {if $_post['boosted'] && !$boosted && !$_shared}
        <span aria-hidden="true">·</span>
        <span class="inline-flex items-center" title="{__("Boosted")}"><span class="icon-[tabler--rocket] size-4" aria-hidden="true"></span><span class="sr-only">{__("Boosted")}</span></span>
      {/if}
      {if $_post['for_subscriptions']}
        <span class="badge badge-sm badge-soft badge-primary"><span class="icon-[tabler--star] size-3" aria-hidden="true"></span>{__("Subscriptions")}</span>
      {/if}
      {if $_post['is_paid']}
        <span class="badge badge-sm badge-soft badge-primary"><span class="icon-[tabler--coin] size-3" aria-hidden="true"></span>{__("Paid")}</span>
      {/if}
      {if $_post['for_adult']}
        <span class="badge badge-sm badge-soft badge-error"><span class="icon-[tabler--eye-off] size-3" aria-hidden="true"></span>{__("Adult")}</span>
      {/if}

      {if $system['posts_reviews_enabled'] && $_post['post_type'] != "product"}
        {if $_post['post_rate']}
          <span class="review-stars inline-flex items-center gap-0.5">{include file='__stars_rate.tpl' rate=$_post['post_rate'] _size='size-3.5'}</span>
          <span class="badge badge-sm badge-soft badge-primary">{$_post['post_rate']|number_format:1}</span>
        {/if}
      {/if}
    </div>
    <!-- post time & location & privacy -->
  </div>
  <!-- post meta -->

  {include file='__feeds_post.menu.tpl'}
</div>
<!-- post header -->

{if $_post['can_get_details'] }

  {if $_post['needs_pro_package']}
    {include file='_need_pro_package.tpl' _manage=true _framed=true}
  {elseif $_post['needs_permission']}
    {include file='_need_permission.tpl' _framed=true}
  {else}

    {if $_post['preview_lock'] && !$_shared}
      <!-- locked preview -->
      <div class="group/preview">
        <div class="mx-4 mb-3 flex flex-wrap items-center justify-between gap-2 rounded-field bg-base-200/60 py-1.5 ps-3 pe-1.5">
          <span class="inline-flex min-w-0 items-center gap-1.5 text-xs font-medium text-base-content/60"><span class="icon-[tabler--eye] size-4 shrink-0" aria-hidden="true"></span>{__("How others see this post")}</span>
          <div class="inline-flex rounded-full bg-base-100 p-0.5 text-xs font-semibold shadow-xs" role="radiogroup" aria-label="{__("How others see this post")}">
            <label class="cursor-pointer rounded-full px-3 py-1 text-base-content/60 transition-colors hover:text-base-content has-checked:bg-primary has-checked:text-primary-content">
              <input type="radio" class="sr-only" name="lock_preview_{$_post['post_id']}{if $pinned}_pinned{/if}{if $boosted}_boosted{/if}" value="original">{__("Original")}
            </label>
            <label class="cursor-pointer rounded-full px-3 py-1 text-base-content/60 transition-colors hover:text-base-content has-checked:bg-primary has-checked:text-primary-content">
              <input type="radio" class="lock-preview-input sr-only" name="lock_preview_{$_post['post_id']}{if $pinned}_pinned{/if}{if $boosted}_boosted{/if}" value="locked" checked>{__("Locked")}
            </label>
          </div>
        </div>
        <div class="group-has-[.lock-preview-input:checked]/preview:hidden">
          <!-- locked preview -->
        {/if}

        <!-- post text -->
        {if !in_array($_post['post_type'], ['product', 'funding', 'offer', 'job', 'course', 'poll'])}
          {if !$_shared}
            {include file='__feeds_post.text.tpl'}
          {else}
            {if $_post['colored_pattern']}
              <div class="post-colored mx-4 flex min-h-72 items-center justify-center overflow-hidden rounded-box bg-cover bg-center p-7 text-center" {if $_post['colored_pattern']['type'] == "color"} style="background-image: linear-gradient(45deg, {$_post['colored_pattern']['background_color_1']}, {$_post['colored_pattern']['background_color_2']});" {else} style="background-image: url({$system['system_uploads']}/{$_post['colored_pattern']['background_image']})" {/if}>
                <div class="post-colored-text-wrapper js_scroller flex max-h-60 w-full items-center justify-center overflow-y-auto" data-slimScroll-height="240">
                  <div class="post-text text-xl font-semibold leading-8" dir="auto" style="color: {$_post['colored_pattern']['text_color']};">
                    {$_post['text']}
                  </div>
                </div>
              </div>
            {else}
              <div class="post-text js_readmore px-4 pb-2 text-start text-[0.9375rem] leading-6 wrap-break-word" dir="auto">{$_post['text']}</div>
            {/if}
            <div class="post-text-translation mt-2 hidden border-s-2 border-base-300 ps-3 text-start" dir="auto"></div>
          {/if}
        {/if}
        <!-- post text -->

        {if !$_shared && $_post['post_type'] == "shared" && $_post['origin']}
          <div class="post-snippet mx-4 mt-3 overflow-hidden rounded-box border border-base-300 {if in_array($_post['origin']['post_type'], ['product', 'funding', 'job', 'course', 'poll'])}pb-4{/if}">
            {if $_snippet}
              <div class="post-snippet-toggle js_show-attachments cursor-pointer bg-base-200 px-4 py-3 text-center text-sm font-semibold text-primary">{__("Show Attachments")}</div>
            {/if}
            <div {if $_snippet}class="hidden" {/if}>
              {include file='__feeds_post.body.tpl' _post=$_post['origin'] _shared=true}
            </div>
          </div>
        {/if}

        {if $_post['post_type'] == "link" && $_post['link']}
          <div class="mx-4 mt-3">
            <div class="post-media overflow-hidden rounded-box border border-base-300 bg-base-100">
              {if $_post['link']['source_thumbnail']}
                <a class="post-media-image relative block overflow-hidden" href="{$_post['link']['source_url']}" target="_blank" rel="nofollow">
                  <img class="max-h-96 w-full object-cover" src="{$_post['link']['source_thumbnail']}" alt="">
                  <div class="source absolute bottom-3 start-3 max-w-[calc(100%-1.5rem)] truncate rounded-field bg-black/70 px-3 py-2 text-xs text-white" title="{$_post['link']['source_host']|upper}">{$_post['link']['source_host']|upper}</div>
                </a>
              {/if}
              <div class="post-media-meta p-4">
                <a class="title mb-1 block text-base font-semibold text-base-content!" href="{$_post['link']['source_url']}" target="_blank" rel="nofollow">{$_post['link']['source_title']}</a>
                <div class="text text-sm text-base-content/65">{$_post['link']['source_text']}</div>
              </div>
            </div>
          </div>
        {/if}

        {if $_post['post_type'] == "media" && $_post['media']}
          <div class="mx-4 mt-3">
            {if $_post['media']['source_type'] == "photo"}
              <div class="post-media overflow-hidden rounded-box border border-base-300 bg-base-100">
                <div class="post-media-image relative block overflow-hidden">
                  <img class="max-h-[32rem] w-full object-contain" src="{$_post['media']['source_url']}" alt="">
                </div>
                <div class="post-media-meta p-4">
                  <div class="source text-xs text-base-content/55"><a target="_blank" href="{$_post['media']['source_url']}">{$_post['media']['source_provider']}</a></div>
                </div>
              </div>
            {else}
              {if $_post['media']['source_provider'] == "YouTube"}
                {$_post['media']['vidoe_id'] = get_youtube_id($_post['media']['source_html'])}
                {if $system['smart_yt_player']}
                  <div class="youtube-player js_youtube-player relative aspect-video cursor-pointer overflow-hidden bg-black" data-id="{$_post['media']['vidoe_id']}">
                    <img class="size-full object-cover" src="https://i.ytimg.com/vi/{$_post['media']['vidoe_id']}/hqdefault.jpg" alt="">
                    <div class="play absolute inset-0 flex items-center justify-center"><span class="icon-[tabler--player-play-filled] size-16 text-white drop-shadow-lg" aria-hidden="true"></span></div>
                  </div>
                {else}
                  <div class="post-media overflow-hidden rounded-box border border-base-300 bg-base-100">
                    {if $system['disable_yt_player']}
                      <div class="plyr__video-embed js_video-plyr-youtube" data-plyr-provider="youtube" data-plyr-embed-id="{$_post['media']['vidoe_id']}"></div>
                    {else}
                      <div class="ratio ratio-16x9 aspect-video overflow-hidden [&>iframe]:size-full">
                        {html_entity_decode($_post['media']['source_html'], ENT_QUOTES)}
                      </div>
                    {/if}
                  </div>
                {/if}
              {elseif in_array($_post['media']['source_provider'], ["Vimeo", "Twitch", "Rumble.com", "Banned.Video", "Brighteon", "Odysee", "Gab TV"])}
                <div class="post-media overflow-hidden rounded-box border border-base-300 bg-base-100">
                  <div class="ratio ratio-16x9 aspect-video overflow-hidden [&>iframe]:size-full">
                    {html_entity_decode($_post['media']['source_html'], ENT_QUOTES)}
                  </div>
                </div>
              {elseif $_post['media']['source_provider'] == "Facebook"}
                <div class="overflow-hidden rounded-box [&>iframe]:w-full">
                  {html_entity_decode($_post['media']['source_html'], ENT_QUOTES)}
                </div>
              {else}
                <div class="embed-iframe-wrapper mx-4 overflow-hidden rounded-box [&>iframe]:min-h-80 [&>iframe]:w-full">
                  {html_entity_decode($_post['media']['source_html'], ENT_QUOTES)}
                </div>
              {/if}
            {/if}
          </div>
        {/if}

        {if $_post['post_type'] == "live" && $_post['live']}
          {$_live_now = !$_post['live']['live_ended']}
          {$_live_title = $_post['live']['live_title']|default:''}
          <div class="mx-4 mt-1">
            <div class="post-media overflow-hidden rounded-box border border-base-300 bg-base-100">
              {if $system['save_live_enabled'] && !$_live_now && $_post['live']['live_recorded']}
                <!-- live recording -->
                <div class="bg-black">
                  <video class="js_video-plyr max-h-[65dvh] w-full bg-black object-contain" id="video-{$_post['live']['live_id']}{if $pinned || $boosted}-{$_post['post_id']}{/if}" {if $_post['live']['video_thumbnail']}poster="{$system['system_uploads']}/{$_post['live']['video_thumbnail']}" {/if} playsinline controls preload="auto">
                    {if $_post['live']['live_provider'] == "livekit"}
                      <source src="{$system['system_agora_uploads']}/{$_post['live']['livekit_file']}" type="video/mp4">
                    {else}
                      <source src="{$system['system_agora_uploads']}/{$_post['live']['agora_file']}" type="application/x-mpegURL">
                    {/if}
                  </video>
                </div>
                <div class="post-media-meta flex min-w-0 items-center justify-between gap-3 p-4">
                  <h3 class="min-w-0 truncate text-base font-semibold" title="{if $_live_title}{$_live_title}{else}{__("Live")}{/if}">{if $_live_title}{$_live_title}{else}{__("Live")}{/if}</h3>
                </div>
                <!-- live recording -->
              {else}
                <!-- live stage -->
                <div class="group relative isolate aspect-video overflow-hidden bg-neutral-950 text-white{if $_live_now} js_lightbox-live cursor-pointer{/if}" {if $_live_now}role="button" tabindex="0" aria-label='{__("Join Live")}'{/if}>
                  {if $_post['live']['video_thumbnail']}
                    <img class="size-full object-cover{if $_live_now} transition-transform duration-500 group-hover:scale-105{else} grayscale-[40%]{/if}" src="{$system['system_uploads']}/{$_post['live']['video_thumbnail']}" alt="" loading="lazy">
                  {else}
                    <img class="size-full scale-125 object-cover opacity-50 blur-3xl" src="{$_post['post_author_picture']}" alt="" loading="lazy" aria-hidden="true">
                  {/if}
                  <span class="pointer-events-none absolute inset-0 bg-linear-to-b from-black/70 via-transparent to-black/50" aria-hidden="true"></span>
                  <!-- live title -->
                  <div class="pointer-events-none absolute inset-x-0 top-0 flex items-center gap-3 p-4">
                    <img class="size-10 shrink-0 rounded-full object-cover ring-2 ring-white/20" src="{$_post['post_author_picture']}" alt="" loading="lazy">
                    <div class="min-w-0 flex-1">
                      <h3 class="truncate text-base font-semibold leading-snug drop-shadow-sm" title="{if $_live_title}{$_live_title}{else}{__("Live")}{/if}">{if $_live_title}{$_live_title}{else}{__("Live")}{/if}</h3>
                      <div class="truncate text-sm text-white/75" title="{$_post['post_author_name']}">{$_post['post_author_name']}</div>
                    </div>
                  </div>
                  <!-- live title -->
                  {if $_live_now}
                    <span class="pointer-events-none absolute start-1/2 top-1/2 grid -translate-x-1/2 -translate-y-1/2 place-items-center transition duration-300 group-hover:scale-105 rtl:translate-x-1/2">
                      <span class="absolute inset-0 animate-ping rounded-full bg-white/30 [animation-duration:2s]" aria-hidden="true"></span>
                      <span class="relative inline-flex items-center gap-2 rounded-full bg-white px-5 py-2.5 text-sm font-semibold text-neutral-900 shadow-lg">
                        <span class="icon-[tabler--broadcast] size-5 text-error" aria-hidden="true"></span>
                        {__("Join Live")}
                      </span>
                    </span>
                  {else}
                    <span class="pointer-events-none absolute start-1/2 top-1/2 inline-flex -translate-x-1/2 -translate-y-1/2 items-center gap-2 rounded-full bg-black/60 px-5 py-2.5 text-sm font-semibold text-white/80 ring-1 ring-white/15 backdrop-blur-sm rtl:translate-x-1/2">
                      <span class="icon-[tabler--broadcast-off] size-5" aria-hidden="true"></span>
                      {__("Live Ended")}
                    </span>
                  {/if}
                  <!-- live info -->
                  <div class="pointer-events-none absolute inset-x-0 bottom-0 flex items-center justify-end gap-3 p-4">
                    {if $_live_now}
                      <span class="inline-flex shrink-0 items-center gap-1.5 rounded-full bg-black/50 px-3 py-1 text-xs font-medium backdrop-blur-sm">
                        <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
                        {$_post['live']['live_viewers']} {__("Watching")}
                      </span>
                    {/if}
                  </div>
                  <!-- live info -->
                </div>
                <!-- live stage -->
              {/if}
            </div>
          </div>
        {/if}

        {if ($_post['post_type'] == "photos" || $_post['post_type'] == "album" || $_post['post_type'] == "profile_picture" || $_post['post_type'] == "profile_cover" || $_post['post_type'] == "page_picture" || $_post['post_type'] == "page_cover" || $_post['post_type'] == "group_picture" || $_post['post_type'] == "group_cover" || $_post['post_type'] == "event_cover" || $_post['post_type'] == "combo") && $_post['photos_num'] > 0}
          <div class="mt-3">
            {include file='__feeds_post.body.photos.tpl'}
          </div>
        {/if}

        {if $_post['post_type'] == "map"}
          {include file='__map.tpl' location=$_post['location'] latitude=$_post['location_latitude'] longitude=$_post['location_longitude'] _title=__("Location") _class="post-map mt-3 overflow-hidden bg-base-200" _frame_class="block h-75 w-full border-0" _link_class="px-4 pt-1"}
        {/if}

        {if $_post['post_type'] == "article" && $_post['blog']}
          <div class="mx-4 mt-3">
            <div class="post-media overflow-hidden rounded-box border border-base-300 bg-base-100">
              {if $_post['blog']['cover']}
                <a class="post-media-image relative block overflow-hidden" href="{$system['system_url']}/blogs/{$_post['post_id']}/{$_post['blog']['title_url']}">
                  <div style="padding-top: 50%; background-size: cover; background-image:url('{$system['system_uploads']}/{$_post['blog']['cover']}');"></div>
                </a>
              {/if}
              <div class="post-media-meta p-4">
                <a class="title mb-1 block text-base font-semibold text-base-content!" href="{$system['system_url']}/blogs/{$_post['post_id']}/{$_post['blog']['title_url']}">{$_post['blog']['title']}</a>
                <div class="text text-sm text-base-content/65">{$_post['blog']['text_snippet']|truncate:400}</div>
              </div>
            </div>
          </div>
        {/if}

        {if $_post['post_type'] == "rich_text" && $_post['rich_text']}
          <div class="mx-4 mt-3">
            <div class="post-media overflow-hidden rounded-box border border-base-300 bg-base-100">
              <div class="post-media-meta p-4">
                <div class="rich-text-container max-w-none text-sm leading-7 wrap-break-word">{$_post['rich_text']['parsed_text']}</div>
              </div>
            </div>
          </div>
        {/if}

        {if $_post['post_type'] == "product" && $_post['product']}
          {capture name='product_stock'}{if !$_post['product']['available']}<span class="size-2 rounded-full bg-error" aria-hidden="true"></span>{__("SOLD")}{elseif $_post['product']['quantity'] > 0}<span class="size-2 rounded-full bg-success" aria-hidden="true"></span>{__("In stock")}{else}<span class="size-2 rounded-full bg-error" aria-hidden="true"></span>{__("Out of stock")}{/if}{/capture}
          {capture name='product_price'}{if $_post['product']['price'] > 0}{$_post['product']['price_formatted']}{else}{__("Free")}{/if}{/capture}

          <div class="mx-4 mt-3">
            <div class="post-media overflow-hidden rounded-box border border-base-300 bg-base-100">
              <!-- product photo -->
              {if $_post['photos_num'] > 0}
                <div class="post-product-photo relative isolate aspect-[4/3] overflow-hidden bg-base-200 {if $_post['photos'][0]['blur']}x-blured{/if}">
                  <a href="{$system['system_url']}/photos/{$_post['photos'][0]['photo_id']}" class="js_lightbox block size-full {if $_post['photos'][0]['blur']}blur-md{/if}" data-id="{$_post['photos'][0]['photo_id']}" data-image="{$system['system_uploads']}/{$_post['photos'][0]['source']}" data-context="post" aria-label="{$_post['product']['name']}">
                    <img class="size-full object-cover transition-transform duration-500 ease-out hover:scale-[1.03] motion-reduce:transition-none" src="{$system['system_uploads']}/{$_post['photos'][0]['source']}" alt="{$_post['product']['name']}" loading="lazy">
                  </a>
                  {if $_post['photos_num'] > 1}
                    <span class="pointer-events-none absolute end-3 top-3 inline-flex items-center gap-1 px-2.5 py-1 text-xs font-semibold rounded-field bg-black/70 text-white"><span class="icon-[tabler--photo] size-3.5" aria-hidden="true"></span>{$_post['photos_num']}</span>
                  {/if}
                  <div class="pointer-events-none absolute inset-x-3 bottom-3 flex items-end justify-between gap-2">
                    <span class="inline-flex items-center gap-1.5 px-3.5 py-1.5 text-lg leading-6 font-bold rounded-field bg-black/70 text-white"><span class="icon-[tabler--tag] size-4.5" aria-hidden="true"></span>{$smarty.capture.product_price}</span>
                    <span class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-field bg-black/70 text-white">{$smarty.capture.product_stock}</span>
                  </div>
                </div>
              {/if}
              <!-- product photo -->

              <div class="post-product-container p-4">
                {if $_post['photos_num'] == 0}
                  <div class="mb-2 flex flex-wrap items-center gap-2">
                    <span class="text-xl font-bold text-base-content">{$smarty.capture.product_price}</span>
                    <span class="inline-flex items-center gap-1.5 rounded-full bg-base-200 px-2.5 py-1 text-xs font-semibold">{$smarty.capture.product_stock}</span>
                  </div>
                {/if}

                <!-- name -->
                <h3 class="text-base leading-snug font-semibold wrap-break-word text-base-content">{$_post['product']['name']}</h3>
                <!-- name -->

                <!-- meta -->
                <div class="mt-1.5 flex flex-wrap items-center gap-x-3.5 gap-y-1.5 text-sm text-base-content/60">
                  <a href="{$system['system_url']}/market/category/{$_post['product']['category_id']}/{$_post['product']['category_url']}" class="inline-flex min-w-0 items-center gap-1 font-medium text-base-content/70! hover:text-primary!">
                    <span class="icon-[tabler--category] size-4 shrink-0" aria-hidden="true"></span>{__($_post['product']['category_name'])}
                  </a>
                  {if $_post['product']['location']}
                    <span class="inline-flex min-w-0 items-center gap-1"><span class="icon-[tabler--map-pin] size-4 shrink-0" aria-hidden="true"></span><span class="wrap-break-word">{$_post['product']['location']}</span></span>
                  {/if}
                  {if $_post['product']['status'] == "new"}
                    <span class="inline-flex min-w-0 items-center gap-1"><span class="icon-[tabler--sparkles] size-4 shrink-0" aria-hidden="true"></span>{__("New")}</span>
                  {else}
                    <span class="inline-flex min-w-0 items-center gap-1"><span class="icon-[tabler--recycle] size-4 shrink-0" aria-hidden="true"></span>{__("Used")}</span>
                  {/if}
                  {if $_post['product']['is_digital']}
                    <span class="inline-flex min-w-0 items-center gap-1"><span class="icon-[tabler--cloud-download] size-4 shrink-0" aria-hidden="true"></span>{__("Digital")}</span>
                  {/if}
                  {if $system['posts_reviews_enabled'] && $_post['reviews_count'] > 0}
                    <button type="button" class="js_modal inline-flex min-w-0 items-center gap-1 cursor-pointer transition-colors hover:text-base-content" data-url="posts/who_reviews.php?post_id={$_post['post_id']}" title="{__("Reviews")}">
                      <span class="icon-[tabler--star] size-4 shrink-0" aria-hidden="true"></span>{if $_post['post_rate']}<span class="font-medium">{$_post['post_rate']|number_format:1}</span>{/if}<span>({$_post['reviews_count']})</span>
                    </button>
                  {/if}
                </div>
                <!-- meta -->

                <!-- post text -->
                <div class="mt-2.5 [&_.post-text]:px-0 [&_.post-text]:text-base-content/75 [&_.post-text-translation]:mx-0">
                  {if !$_shared}
                    {include file='__feeds_post.text.tpl'}
                  {else}
                    <div class="post-text js_readmore pb-2 text-start text-[0.9375rem] leading-6 wrap-break-word" dir="auto">{$_post['text']}</div>
                    <div class="post-text-translation mt-2 hidden border-s-2 border-base-300 ps-3 text-start" dir="auto"></div>
                  {/if}
                </div>
                <!-- post text -->

                <!-- custom fileds -->
                {if $_post['custom_fields']['basic']}
                  <dl class="post-custom-fileds-wrapper mt-1 grid grid-cols-1 gap-x-6 gap-y-3 rounded-box bg-base-200/60 p-4 text-sm sm:grid-cols-2">
                    {foreach $_post['custom_fields']['basic'] as $custom_field}
                      {if $custom_field['value']}
                        <div class="min-w-0">
                          <dt class="text-xs text-base-content/60">{__($custom_field['label'])}</dt>
                          <dd class="mt-0.5 font-medium wrap-break-word">
                            {if $custom_field['type'] == "textbox" && $custom_field['is_link']}
                              <a href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
                            {elseif $custom_field['type'] == "multipleselectbox"}
                              {__($custom_field['value_string']|trim)}
                            {else}
                              {__($custom_field['value']|trim)}
                            {/if}
                          </dd>
                        </div>
                      {/if}
                    {/foreach}
                  </dl>
                {/if}
                <!-- custom fileds -->

                <!-- actions -->
                {if $_post['author_id'] != $user->_data['user_id'] }
                  <div class="mt-3 flex items-center gap-2">
                    {if $system['market_shopping_cart_enabled']}
                      {if $_post['product']['available'] && $_post['product']['quantity'] > 0}
                        <button type="button" class="heroui button button--primary min-w-0 flex-1 js_shopping-add-to-cart" data-id="{$_post['post_id']}">
                          <span class="icon-[tabler--shopping-cart-plus] size-4.5 shrink-0" aria-hidden="true"></span>
                          {if $_post['product']['is_digital']}{__("Buy & Download")}{else}{__("Buy")}{/if}
                        </button>
                      {else}
                        <button type="button" class="heroui button button--tertiary min-w-0 flex-1" disabled>
                          {__("Currently unavailable")}
                        </button>
                      {/if}
                    {/if}
                    {if $system['chat_enabled'] && $_post['user_type'] == 'user'}
                      {if $system['market_shopping_cart_enabled']}
                        <button type="button" class="heroui button button--tertiary button--icon-only size-10 shrink-0 js_chat-start" data-uid="{$_post['author_id']}" data-name="{$_post['post_author_name']}" data-link="{$_post['user_name']}" data-picture="{$_post['post_author_picture']}" data-product-post-id="{$_post['post_id']}" data-product-name="{$_post['product']['name']}" data-product-price="{$smarty.capture.product_price}" data-product-image="{if $_post['photos_num'] > 0}{$system['system_uploads']}/{$_post['photos'][0]['source']}{/if}" title="{__("Contact Seller")}" aria-label="{__("Contact Seller")}">
                          <span class="icon-[tabler--message-circle] size-5" aria-hidden="true"></span>
                        </button>
                      {else}
                        <button type="button" class="heroui button button--primary min-w-0 flex-1 js_chat-start" data-uid="{$_post['author_id']}" data-name="{$_post['post_author_name']}" data-link="{$_post['user_name']}" data-picture="{$_post['post_author_picture']}" data-product-post-id="{$_post['post_id']}" data-product-name="{$_post['product']['name']}" data-product-price="{$smarty.capture.product_price}" data-product-image="{if $_post['photos_num'] > 0}{$system['system_uploads']}/{$_post['photos'][0]['source']}{/if}">
                          <span class="icon-[tabler--message-circle] size-4.5 shrink-0" aria-hidden="true"></span>
                          {__("Contact Seller")}
                        </button>
                      {/if}
                    {/if}
                  </div>
                {/if}
                <!-- actions -->
              </div>
            </div>
          </div>
        {/if}

        {if $_post['post_type'] == "funding" && $_post['funding']}
          <div class="mx-4 mt-3">
            <div class="post-media overflow-hidden rounded-box border border-base-300 bg-base-100">
              <!-- funding cover -->
              {if $_post['funding']['cover_image']}
                <div class="post-funding-cover relative isolate aspect-[2/1] overflow-hidden bg-base-200">
                  <img class="size-full object-cover" src="{$system['system_uploads']}/{$_post['funding']['cover_image']}" alt="{$_post['funding']['title']}" loading="lazy">
                  <div class="pointer-events-none absolute inset-x-3 bottom-3 flex items-end justify-between gap-2">
                    <span class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-field bg-black/70 text-white"><span class="icon-[tabler--heart-handshake] size-4" aria-hidden="true"></span>{__("Funding")}</span>
                    <span class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-field bg-black/70 text-white"><span class="icon-[tabler--chart-pie] size-4" aria-hidden="true"></span>{$_post['funding']['funding_completion']}%</span>
                  </div>
                </div>
              {/if}
              <!-- funding cover -->

              <div class="post-funding-meta p-4">
                <!-- title -->
                <h3 class="funding-title text-base leading-snug font-semibold wrap-break-word text-base-content">
                  <span class="js_post_title">{$_post['funding']['title']}</span>
                </h3>
                <!-- title -->

                <!-- progress -->
                <div class="funding-completion mt-3 rounded-box bg-base-200/60 p-4">
                  <div class="flex flex-wrap items-baseline justify-between gap-x-3 gap-y-1">
                    <span class="flex min-w-0 flex-wrap items-baseline gap-x-1.5">
                      <strong class="text-2xl leading-8 font-bold text-base-content">{print_money($_post['funding']['raised_amount'])}</strong>
                      <span class="text-sm text-base-content/60">{__("Raised of")} <span class="font-medium text-base-content/80">{print_money($_post['funding']['amount'])}</span></span>
                    </span>
                    <span class="shrink-0 text-sm font-semibold text-primary tabular-nums">{$_post['funding']['funding_completion']}%</span>
                  </div>
                  <div class="mt-3 h-2 overflow-hidden rounded-full bg-base-content/10">
                    <div class="h-full rounded-full bg-primary" role="progressbar" aria-valuenow="{$_post['funding']['funding_completion']}" aria-valuemin="0" aria-valuemax="100" style="width: {if $_post['funding']['funding_completion'] > 100}100{else}{$_post['funding']['funding_completion']}{/if}%"></div>
                  </div>
                  <div class="mt-3 flex flex-wrap items-center gap-x-3.5 gap-y-1.5 text-sm text-base-content/60">
                    <span class="inline-flex items-center gap-1"><span class="icon-[tabler--target-arrow] size-4 shrink-0" aria-hidden="true"></span>{print_money($_post['funding']['amount'])}</span>
                    <button type="button" class="js_modal inline-flex cursor-pointer items-center gap-1 transition-colors hover:text-base-content" data-url="posts/who_donates.php?post_id={$_post['post_id']}">
                      <span class="icon-[tabler--users] size-4 shrink-0" aria-hidden="true"></span>{$_post['funding']['total_donations']} {__("Donations")}
                    </button>
                  </div>
                </div>
                <!-- progress -->

                <!-- post text -->
                <div class="funding-description mt-3 [&_.post-text]:px-0 [&_.post-text]:text-base-content/75 [&_.post-text-translation]:mx-0">
                  {if !$_shared}
                    {include file='__feeds_post.text.tpl'}
                  {else}
                    <div class="post-text js_readmore pb-2 text-start text-[0.9375rem] leading-6 wrap-break-word" dir="auto">{$_post['text']}</div>
                    <div class="post-text-translation mt-2 hidden border-s-2 border-base-300 ps-3 text-start" dir="auto"></div>
                  {/if}
                </div>
                <!-- post text -->

                <!-- actions -->
                {if $user->_logged_in && $_post['author_id'] != $user->_data['user_id'] }
                  <div class="mt-2 flex">
                    <button type="button" class="js_modal heroui button button--primary min-w-0 flex-1" data-url="#funding-donate" data-options='{ "post_id": {$_post["post_id"]} }'>
                      <span class="icon-[tabler--heart-handshake] size-4.5 shrink-0" aria-hidden="true"></span>
                      {__("Donate")}
                    </button>
                  </div>
                {/if}
                <!-- actions -->
              </div>
            </div>
          </div>
        {/if}

        {if $_post['post_type'] == "offer" && $_post['offer']}
          <div class="mx-4 mt-3">
            <div class="post-media overflow-hidden rounded-box border border-base-300 bg-base-100">
              <!-- offer cover -->
              {if $_post['photos_num'] > 0}
                <div class="post-offer-cover relative isolate overflow-hidden bg-base-200">
                  {if $_post['photos_num'] == 1}
                    <img class="aspect-[2/1] w-full object-cover" src="{$system['system_uploads']}/{$_post['offer']['thumbnail']}" alt="{$_post['offer']['meta_title']}" loading="lazy">
                  {else}
                    <div class="-mt-2">
                      {include file='__feeds_post.body.photos.tpl'}
                    </div>
                  {/if}
                  <div class="pointer-events-none absolute inset-x-3 bottom-3 flex items-end justify-between gap-2">
                    <span class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-field bg-black/70 text-white"><span class="icon-[tabler--discount-2] size-4" aria-hidden="true"></span>{__("Offer")}</span>
                    {if $_post['offer']['end_date']}
                      <span class="inline-flex min-w-0 items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-field bg-black/70 text-white" title="{__("Expires")}: {$_post['offer']['end_date']|date_format:$system['system_date_format']}"><span class="icon-[tabler--calendar-due] size-4 shrink-0" aria-hidden="true"></span><span class="truncate">{__("Expires")}: {$_post['offer']['end_date']|date_format:$system['system_date_format']}</span></span>
                    {/if}
                  </div>
                </div>
              {/if}
              <!-- offer cover -->

              <div class="post-offer-meta p-4">
                <!-- title -->
                <h3 class="text-base leading-snug font-semibold wrap-break-word text-base-content">
                  <span class="js_post_title">{$_post['offer']['meta_title']}</span>
                </h3>
                <!-- title -->

                <!-- meta -->
                {if $_post['offer']['price'] || ($_post['offer']['end_date'] && $_post['photos_num'] == 0)}
                  <div class="mt-1.5 flex flex-wrap items-center gap-x-3.5 gap-y-1.5 text-sm text-base-content/60">
                    {if $_post['offer']['price']}
                      <span class="inline-flex items-center gap-1"><span class="icon-[tabler--tag] size-4 shrink-0" aria-hidden="true"></span>{__("From")} <strong class="text-base font-bold text-base-content">{print_money($_post['offer']['price'])}</strong></span>
                    {/if}
                    {if $_post['offer']['end_date'] && $_post['photos_num'] == 0}
                      <span class="inline-flex items-center gap-1"><span class="icon-[tabler--calendar-due] size-4 shrink-0" aria-hidden="true"></span>{__("Expires")}: {$_post['offer']['end_date']|date_format:$system['system_date_format']}</span>
                    {/if}
                  </div>
                {/if}
                <!-- meta -->

                <!-- post text -->
                <div class="mt-2.5 [&_.post-text]:px-0 [&_.post-text]:text-base-content/75 [&_.post-text-translation]:mx-0">
                  {if !$_shared}
                    {include file='__feeds_post.text.tpl'}
                  {else}
                    <div class="post-text js_readmore pb-2 text-start text-[0.9375rem] leading-6 wrap-break-word" dir="auto">{$_post['text']}</div>
                    <div class="post-text-translation mt-2 hidden border-s-2 border-base-300 ps-3 text-start" dir="auto"></div>
                  {/if}
                </div>
                <!-- post text -->

                <!-- custom fileds -->
                {if $_post['custom_fields']['basic']}
                  <dl class="post-custom-fileds-wrapper mt-1 grid grid-cols-1 gap-x-6 gap-y-3 rounded-box bg-base-200/60 p-4 text-sm sm:grid-cols-2">
                    {foreach $_post['custom_fields']['basic'] as $custom_field}
                      {if $custom_field['value']}
                        <div class="min-w-0">
                          <dt class="text-xs text-base-content/60">{__($custom_field['label'])}</dt>
                          <dd class="mt-0.5 font-medium wrap-break-word">
                            {if $custom_field['type'] == "textbox" && $custom_field['is_link']}
                              <a href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
                            {elseif $custom_field['type'] == "multipleselectbox"}
                              {__($custom_field['value_string']|trim)}
                            {else}
                              {__($custom_field['value']|trim)}
                            {/if}
                          </dd>
                        </div>
                      {/if}
                    {/foreach}
                  </dl>
                {/if}
                <!-- custom fileds -->
              </div>
            </div>
          </div>
        {/if}

        {if $_post['post_type'] == "job" && $_post['job']}
          {capture name='job_salary'}{print_money($_post['job']['salary_minimum'], $_post['job']['salary_minimum_currency']['symbol'], $_post['job']['salary_minimum_currency']['dir'])} - {print_money($_post['job']['salary_maximum'], $_post['job']['salary_maximum_currency']['symbol'], $_post['job']['salary_maximum_currency']['dir'])} / {$_post['job']['pay_salary_per_meta']}{/capture}
          {capture name='job_status'}{if $_post['job']['available']}<span class="size-2 rounded-full bg-success" aria-hidden="true"></span>{__("Open")}{else}<span class="size-2 rounded-full bg-error" aria-hidden="true"></span>{__("Closed")}{/if}{/capture}

          <div class="mx-4 mt-3">
            <div class="post-media overflow-hidden rounded-box border border-base-300 bg-base-100">
              <!-- job cover -->
              {if $_post['job']['cover_image']}
                <div class="post-job-cover relative isolate aspect-[2/1] overflow-hidden bg-base-200">
                  <img class="size-full object-cover" src="{$system['system_uploads']}/{$_post['job']['cover_image']}" alt="{$_post['job']['title']}" loading="lazy">
                  <div class="pointer-events-none absolute inset-x-3 bottom-3 flex items-end justify-between gap-2">
                    <span class="inline-flex min-w-0 items-center gap-1.5 px-3 py-1.5 text-sm font-bold rounded-field bg-black/70 text-white" title="{$smarty.capture.job_salary}"><span class="icon-[tabler--cash] size-4.5 shrink-0" aria-hidden="true"></span><span class="truncate">{$smarty.capture.job_salary}</span></span>
                    <span class="inline-flex shrink-0 items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-field bg-black/70 text-white">{$smarty.capture.job_status}</span>
                  </div>
                </div>
              {/if}
              <!-- job cover -->

              <div class="post-job-meta p-4">
                <!-- title -->
                <h3 class="job-title text-base leading-snug font-semibold wrap-break-word">
                  <span class="js_post_title">{$_post['job']['title']}</span>
                </h3>
                <!-- title -->

                <!-- meta -->
                <div class="mt-1.5 flex flex-wrap items-center gap-x-3.5 gap-y-1.5 text-sm text-base-content/60">
                  {if $_post['job']['location']}
                    <span class="inline-flex min-w-0 items-center gap-1"><span class="icon-[tabler--map-pin] size-4 shrink-0" aria-hidden="true"></span><span class="wrap-break-word">{$_post['job']['location']}</span></span>
                  {/if}
                  {if $_post['job']['type_meta']}
                    <span class="inline-flex items-center gap-1"><span class="icon-[tabler--briefcase] size-4 shrink-0" aria-hidden="true"></span>{$_post['job']['type_meta']}</span>
                  {/if}
                  {if !$_post['job']['cover_image']}
                    <span class="inline-flex items-center gap-1"><span class="icon-[tabler--cash] size-4 shrink-0" aria-hidden="true"></span><span class="font-medium text-base-content">{$smarty.capture.job_salary}</span></span>
                    <span class="inline-flex items-center gap-1.5">{$smarty.capture.job_status}</span>
                  {/if}
                </div>
                <!-- meta -->

                <!-- post text -->
                <div class="job-description mt-2.5 [&_.post-text]:px-0 [&_.post-text]:text-base-content/75 [&_.post-text-translation]:mx-0">
                  {if !$_shared}
                    {include file='__feeds_post.text.tpl'}
                  {else}
                    <div class="post-text js_readmore pb-2 text-start text-[0.9375rem] leading-6 wrap-break-word" dir="auto">{$_post['text']}</div>
                    <div class="post-text-translation mt-2 hidden border-s-2 border-base-300 ps-3 text-start" dir="auto"></div>
                  {/if}
                </div>
                <!-- post text -->

                <!-- custom fileds -->
                {if $_post['custom_fields']['basic']}
                  <dl class="post-custom-fileds-wrapper mt-1 grid grid-cols-1 gap-x-6 gap-y-3 rounded-box bg-base-200/60 p-4 text-sm sm:grid-cols-2">
                    {foreach $_post['custom_fields']['basic'] as $custom_field}
                      {if $custom_field['value']}
                        <div class="min-w-0">
                          <dt class="text-xs text-base-content/60">{__($custom_field['label'])}</dt>
                          <dd class="mt-0.5 font-medium wrap-break-word">
                            {if $custom_field['type'] == "textbox" && $custom_field['is_link']}
                              <a href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
                            {elseif $custom_field['type'] == "multipleselectbox"}
                              {__($custom_field['value_string']|trim)}
                            {else}
                              {__($custom_field['value']|trim)}
                            {/if}
                          </dd>
                        </div>
                      {/if}
                    {/foreach}
                  </dl>
                {/if}
                <!-- custom fileds -->

                <!-- actions -->
                {if $_post['author_id'] == $user->_data['user_id']}
                  <div class="mt-3 flex">
                    <button type="button" class="js_modal heroui button button--tertiary min-w-0 flex-1 justify-between gap-3 js_job-apply" data-size="large" data-url="posts/job.php?do=candidates&post_id={$_post['post_id']}" title="{__("View Candidates")}" {if $_post['job']['candidates_count'] == 0}disabled{/if}>
                                        <span class="inline-flex min-w-0 items-center gap-2"><span class="icon-[tabler--users] size-4.5 shrink-0" aria-hidden="true"></span><span class="truncate">{__("View Candidates")}</span></span>
                                        <span class="inline-flex shrink-0 items-center gap-1.5"><span class="rounded-full bg-primary px-2 py-0.5 text-xs leading-4 font-semibold text-primary-content tabular-nums">{$_post['job']['candidates_count']}</span><span class="icon-[tabler--chevron-right] size-4 text-base-content/50 rtl:rotate-180" aria-hidden="true"></span></span>
                                      </button>
                  </div>
                {/if}
                {if $user->_logged_in && $_post['job']['available'] &&  $_post['author_id'] != $user->_data['user_id'] }
                  <div class="mt-3 flex">
                    <button type="button" class="js_modal heroui button button--primary min-w-0 flex-1 js_job-apply" data-size="large" data-url="posts/job.php?do=application&post_id={$_post['post_id']}">
                      <span class="icon-[tabler--send] size-4.5 shrink-0" aria-hidden="true"></span>{__("Apply Now")}
                    </button>
                  </div>
                {/if}
                <!-- actions -->
              </div>
            </div>
          </div>
        {/if}

        {if $_post['post_type'] == "course" && $_post['course']}
          {capture name='course_fees'}{print_money($_post['course']['fees'], $_post['course']['fees_currency']['symbol'], $_post['course']['fees_currency']['dir'])}{/capture}
          {capture name='course_status'}{if $_post['course']['available']}<span class="size-2 rounded-full bg-success" aria-hidden="true"></span>{__("Open")}{else}<span class="size-2 rounded-full bg-error" aria-hidden="true"></span>{__("Closed")}{/if}{/capture}
          {capture name='course_date'}{if ($_post['course']['start_date']|date_format:"%Y") != ($_post['course']['end_date']|date_format:"%Y")}{$_post['course']['start_date']|date_format:"%e %b %Y"}{else}{$_post['course']['start_date']|date_format:"%e %b"}{/if} &ndash; {$_post['course']['end_date']|date_format:"%e %b %Y"}{/capture}

          <div class="mx-4 mt-3">
            <div class="post-media overflow-hidden rounded-box border border-base-300 bg-base-100">
              <!-- course cover -->
              {if $_post['course']['cover_image']}
                <div class="post-course-cover relative isolate aspect-[2/1] overflow-hidden bg-base-200">
                  <img class="size-full object-cover" src="{$system['system_uploads']}/{$_post['course']['cover_image']}" alt="{$_post['course']['title']}" loading="lazy">
                  <div class="pointer-events-none absolute inset-x-3 bottom-3 flex items-end justify-between gap-2">
                    <span class="inline-flex min-w-0 items-center gap-1.5 px-3 py-1.5 text-sm font-bold rounded-field bg-black/70 text-white" title="{__("Course Fees")}: {$smarty.capture.course_fees}"><span class="icon-[tabler--school] size-4.5 shrink-0" aria-hidden="true"></span><span class="truncate">{$smarty.capture.course_fees}</span></span>
                    <span class="inline-flex shrink-0 items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-field bg-black/70 text-white">{$smarty.capture.course_status}</span>
                  </div>
                </div>
              {/if}
              <!-- course cover -->

              <div class="post-course-meta p-4">
                <!-- title -->
                <h3 class="text-base leading-snug font-semibold wrap-break-word">
                  <span class="js_post_title">{$_post['course']['title']}</span>
                </h3>
                <!-- title -->

                <!-- meta -->
                <div class="mt-1.5 flex flex-wrap items-center gap-x-3.5 gap-y-1.5 text-sm text-base-content/60">
                  {if $_post['course']['location']}
                    <span class="inline-flex min-w-0 items-center gap-1"><span class="icon-[tabler--map-pin] size-4 shrink-0" aria-hidden="true"></span><span class="wrap-break-word">{$_post['course']['location']}</span></span>
                  {/if}
                  <span class="inline-flex items-center gap-1"><span class="icon-[tabler--calendar] size-4 shrink-0" aria-hidden="true"></span>{$smarty.capture.course_date}</span>
                  {if !$_post['course']['cover_image']}
                    <span class="inline-flex items-center gap-1"><span class="icon-[tabler--school] size-4 shrink-0" aria-hidden="true"></span><span class="font-medium text-base-content">{$smarty.capture.course_fees}</span></span>
                    <span class="inline-flex items-center gap-1.5">{$smarty.capture.course_status}</span>
                  {/if}
                </div>
                <!-- meta -->

                <!-- post text -->
                <div class="mt-2.5 [&_.post-text]:px-0 [&_.post-text]:text-base-content/75 [&_.post-text-translation]:mx-0">
                  {if !$_shared}
                    {include file='__feeds_post.text.tpl'}
                  {else}
                    <div class="post-text js_readmore pb-2 text-start text-[0.9375rem] leading-6 wrap-break-word" dir="auto">{$_post['text']}</div>
                    <div class="post-text-translation mt-2 hidden border-s-2 border-base-300 ps-3 text-start" dir="auto"></div>
                  {/if}
                </div>
                <!-- post text -->

                <!-- custom fileds -->
                {if $_post['custom_fields']['basic']}
                  <dl class="post-custom-fileds-wrapper mt-1 grid grid-cols-1 gap-x-6 gap-y-3 rounded-box bg-base-200/60 p-4 text-sm sm:grid-cols-2">
                    {foreach $_post['custom_fields']['basic'] as $custom_field}
                      {if $custom_field['value']}
                        <div class="min-w-0">
                          <dt class="text-xs text-base-content/60">{__($custom_field['label'])}</dt>
                          <dd class="mt-0.5 font-medium wrap-break-word">
                            {if $custom_field['type'] == "textbox" && $custom_field['is_link']}
                              <a href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
                            {elseif $custom_field['type'] == "multipleselectbox"}
                              {__($custom_field['value_string']|trim)}
                            {else}
                              {__($custom_field['value']|trim)}
                            {/if}
                          </dd>
                        </div>
                      {/if}
                    {/foreach}
                  </dl>
                {/if}
                <!-- custom fileds -->

                <!-- actions -->
                <div class="mt-3 grid">
                  {include file='__course_actions.tpl' _course_post=$_post _small=false}
                </div>
                <!-- actions -->
              </div>
            </div>
          </div>
        {/if}

        {if $_post['post_type'] == "poll" && $_post['poll']}
          <div class="mx-4 mt-2 mb-1 rounded-3xl border border-base-300 bg-base-100 p-4 sm:p-5">
            <div class="[&_.post-text]:px-0 [&_.post-text]:pb-0 [&_.post-text]:text-lg [&_.post-text]:font-semibold [&_.post-text]:leading-snug [&_.post-text-translation]:mx-0">
              {if !$_shared}
                {include file='__feeds_post.text.tpl'}
              {else}
                <div class="post-text js_readmore text-start wrap-break-word" dir="auto">{$_post['text']}</div>
                <div class="post-text-translation mt-2 hidden border-s-2 border-base-300 ps-3 text-start" dir="auto"></div>
              {/if}
            </div>
            <div class="poll-options mt-2" data-poll-id="{$_post['poll']['poll_id']}" data-poll-votes="{$_post['poll']['votes']}">
              {include file='__feeds_post.poll.tpl' poll=$_post['poll']}
            </div>
          </div>
        {/if}

        {if $_post['post_type'] == "reel" && $_post['reel']}
          <div class="px-4">
            <a class="relative mx-auto block aspect-[9/16] w-full max-w-xs overflow-hidden rounded-box bg-linear-to-br from-neutral-700 to-neutral-900" href="{$system['system_url']}/reels/{$_post['post_id']}" aria-label='{__("Reels")}'>
              {if $_post['reel']['thumbnail']}
                <img class="size-full object-cover" src="{$system['system_uploads']}/{$_post['reel']['thumbnail']}" alt="" loading="lazy">
              {/if}
              <span class="absolute inset-0 m-auto flex size-14 items-center justify-center rounded-full bg-black/45 text-white"><i class="icon-[tabler--player-play-filled] size-7" aria-hidden="true"></i></span>
            </a>
          </div>
        {/if}

        {if ($_post['post_type'] == "video" || $_post['post_type'] == "combo") && $_post['video']}
          <div class="{if $_post['post_type'] == "combo"}mt-3{/if}">
            {if $system['auto_play_videos']}
            <video class="js_video-plyr max-h-[65dvh] w-full bg-black object-contain [.plyr--fullscreen-active_&]:h-full [.plyr--fullscreen-active_&]:max-h-none [.plyr:fullscreen_&]:h-full [.plyr:fullscreen_&]:max-h-none [.plyr--fullscreen-fallback_&]:h-full [.plyr--fullscreen-fallback_&]:max-h-none" id="video-{$_post['video']['video_id']}{if $pinned || $boosted}-{$_post['post_id']}{/if}" {if $user->_logged_in}onplay="update_media_views('video', {$_post['video']['video_id']})" {/if} {if $_post['video']['thumbnail']}data-poster="{$system['system_uploads']}/{$_post['video']['thumbnail']}" {/if} playsinline controls preload="auto">
              {if empty($_post['video']['source_240p']) && empty($_post['video']['source_360p']) && empty($_post['video']['source_480p']) && empty($_post['video']['source_720p']) && empty($_post['video']['source_1080p']) && empty($_post['video']['source_1440p']) && empty($_post['video']['source_2160p'])}
                <source src="{$system['system_uploads']}/{$_post['video']['source']}" type="video/mp4">
              {/if}
              {if $_post['video']['source_240p']}
                <source src="{$system['system_uploads']}/{$_post['video']['source_240p']}" type="video/mp4" size="240">
              {/if}
              {if $_post['video']['source_360p']}
                <source src="{$system['system_uploads']}/{$_post['video']['source_360p']}" type="video/mp4" size="360">
              {/if}
              {if $_post['video']['source_480p']}
                <source src="{$system['system_uploads']}/{$_post['video']['source_480p']}" type="video/mp4" size="480">
              {/if}
              {if $_post['video']['source_720p']}
                <source src="{$system['system_uploads']}/{$_post['video']['source_720p']}" type="video/mp4" size="720">
              {/if}
              {if $_post['video']['source_1080p']}
                <source src="{$system['system_uploads']}/{$_post['video']['source_1080p']}" type="video/mp4" size="1080">
              {/if}
              {if $_post['video']['source_1440p']}
                <source src="{$system['system_uploads']}/{$_post['video']['source_1440p']}" type="video/mp4" size="1440">
              {/if}
              {if $_post['video']['source_2160p']}
                <source src="{$system['system_uploads']}/{$_post['video']['source_2160p']}" type="video/mp4" size="2160">
              {/if}
            </video>
            {else}
              <div class="js_lightbox-video group relative block cursor-pointer{if $system['fluid_videos_enabled']} flex items-center justify-center{else} aspect-video{/if} overflow-hidden bg-black" data-id="{$_post['post_id']}" role="button" tabindex="0" aria-label='{__("Play")}'>
                {$_video_portrait = ($_post['video']['width'] && $_post['video']['height'] && $_post['video']['height'] > $_post['video']['width'])}
                {if $_post['video']['thumbnail']}
                  {if $_video_portrait}
                    <img class="pointer-events-none absolute inset-0 size-full scale-110 object-cover opacity-60 blur-2xl" src="{$system['system_uploads']}/{$_post['video']['thumbnail']}" alt="" loading="lazy" aria-hidden="true">
                  {/if}
                  <img class="relative {if $system['fluid_videos_enabled']}max-h-[65dvh] w-full object-contain{elseif $_video_portrait}size-full object-contain{else}size-full object-cover{/if}" src="{$system['system_uploads']}/{$_post['video']['thumbnail']}" alt="" loading="lazy">
                {else}
                  {if $_video_portrait}
                    <video class="pointer-events-none absolute inset-0 size-full scale-110 object-cover opacity-60 blur-2xl" src="{$system['system_uploads']}/{$_post['video']['source']}#t=0.1" preload="metadata" muted playsinline aria-hidden="true"></video>
                  {/if}
                  <video class="pointer-events-none relative {if $system['fluid_videos_enabled']}max-h-[65dvh] w-full object-contain{elseif $_video_portrait}size-full object-contain{else}size-full object-cover{/if}" src="{$system['system_uploads']}/{$_post['video']['source']}#t=0.1" preload="metadata" muted playsinline aria-hidden="true"></video>
                {/if}
                <span class="pointer-events-none absolute inset-0 bg-linear-to-t from-black/40 via-transparent to-transparent" aria-hidden="true"></span>
                <span class="pointer-events-none absolute start-1/2 top-1/2 flex size-14 -translate-x-1/2 -translate-y-1/2 items-center justify-center rounded-full bg-primary text-primary-content shadow-lg transition duration-300 group-hover:scale-110 rtl:translate-x-1/2" aria-hidden="true">
                  <span class="icon-[tabler--player-play-filled] size-6"></span>
                </span>
              </div>
            {/if}
          </div>
        {/if}

        {if ($_post['post_type'] == "audio" || $_post['post_type'] == "combo") && $_post['audio']}
          <div class="mx-4 {if $_post['post_type'] == "combo"}mt-3{/if}">
            <audio class="js_audio" id="audio-{$_post['audio']['audio_id']}" {if $user->_logged_in}onplay="update_media_views('audio', {$_post['audio']['audio_id']})" {/if} controls preload="auto" style="width: 100%;">
              <source src="{$system['system_uploads']}/{$_post['audio']['source']}" type="audio/mpeg">
              <source src="{$system['system_uploads']}/{$_post['audio']['source']}" type="audio/mp3">
              {__("Your browser does not support HTML5 audio")}
            </audio>
          </div>
        {/if}

        {if ($_post['post_type'] == "file" || $_post['post_type'] == "combo") && $_post['file']}
          {capture name="file_action"}
            {if $_post['needs_payment']}
              <button type="button" class="js_modal heroui button button--primary button--sm shrink-0 {if !$user->_logged_in}js_login{/if}" {if $user->_logged_in} data-url="#payment" data-options='{ "handle": "paid_post", "paid_post": "true", "id": {$_post['post_id']}, "price": {$_post['post_price']}, "vat": "{get_payment_vat_value($_post['post_price'])}", "fees": "{get_payment_fees_value($_post['post_price'])}", "total": "{get_payment_total_value($_post['post_price'])}", "total_printed": "{get_payment_total_value($_post['post_price'], true)}" }' {/if}>
                <span class="icon-[tabler--lock] size-4" aria-hidden="true"></span>{__("PAY TO DOWNLOAD")} ({print_money($_post['post_price'])})
              </button>
            {else}
              <a class="heroui button button--primary button--sm shrink-0" href="{if $system['mask_file_path_enabled']}{$system['system_url']}/downloads.php?id={$_post['post_id']}{else}{$system['system_uploads']}/{$_post['file']['source']}{/if}" {if !$system['mask_file_path_enabled'] && $_post['file']['name']} download="{$_post['file']['name']}" {/if}>{__("Download")}</a>
            {/if}
          {/capture}
          {include file='__file_card.tpl' _file=$_post['file'] _mode="post" _combo=($_post['post_type'] == "combo") _action=$smarty.capture.file_action}
        {/if}

        {if $_post['post_type'] == "merit" && ($_post['merit']['image'] || $_post['merit']['message'])}
          <div class="mx-4 mt-3">
            <div class="post-media overflow-hidden rounded-box border border-base-300 bg-base-100">
              <!-- merit cover -->
              {if $_post['merit']['image']}
                <div class="post-merit-cover relative isolate aspect-[2/1] overflow-hidden bg-base-200">
                  <img class="size-full object-cover" src="{$system['system_uploads']}/{$_post['merit']['image']}" alt="{__($_post['merit']['category_name'])}" loading="lazy">
                  <div class="pointer-events-none absolute inset-x-3 bottom-3 flex items-end justify-between gap-2">
                    <span class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-field bg-black/70 text-white"><span class="icon-[tabler--award] size-4" aria-hidden="true"></span>{__("Merit")}</span>
                  </div>
                </div>
              {/if}
              <!-- merit cover -->

              <div class="post-merit-meta p-4">
                <!-- category -->
                <div class="flex min-w-0 items-center gap-3">
                  {if $_post['merit']['category_image']}
                    <img class="size-11 shrink-0 rounded-field bg-base-200 object-cover" src="{$system['system_uploads']}/{$_post['merit']['category_image']}" alt="" loading="lazy">
                  {else}
                    <span class="flex size-11 shrink-0 items-center justify-center rounded-field bg-primary/10 text-primary" aria-hidden="true"><span class="icon-[tabler--award] size-6"></span></span>
                  {/if}
                  <div class="min-w-0">
                    {if $_post['merit']['category_name']}
                      <h3 class="truncate text-base leading-snug font-semibold text-base-content" title="{__($_post['merit']['category_name'])}">{__($_post['merit']['category_name'])}</h3>
                    {/if}
                    {if $_post['in_wall']}
                      <p class="mt-0.5 flex min-w-0 items-center gap-1 text-sm text-base-content/60">
                        <span class="icon-[tabler--arrow-right] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                        <span class="js_user-popover min-w-0 truncate" data-type="user" data-uid="{$_post['wall_id']}">
                          <a class="font-medium text-base-content/80! hover:text-primary!" href="{$system['system_url']}/{$_post['wall_username']}" title="{$_post['wall_fullname']}">{$_post['wall_fullname']}</a>
                        </span>
                      </p>
                    {/if}
                  </div>
                </div>
                <!-- category -->

                <!-- message -->
                {if $_post['merit']['message']}
                  <div class="merit-description mt-3 flex gap-2.5 rounded-box bg-base-200/60 p-3.5">
                    <span class="icon-[tabler--quote] mt-0.5 size-4.5 shrink-0 text-primary/60" aria-hidden="true"></span>
                    <div class="post-text js_readmore min-w-0 text-start text-[0.9375rem] leading-6 text-base-content/80 wrap-break-word" dir="auto">{$_post['merit']['message']}</div>
                  </div>
                {/if}
                <!-- message -->
              </div>
            </div>
          </div>
        {/if}

        {if $_post['post_type'] == "group" && $_post['group']}
          <div class="mx-4 mt-3">
            <div class="post-media module overflow-hidden rounded-box border border-base-300 bg-base-100">
              <!-- group cover -->
              <a class="post-group-cover relative isolate block aspect-[2/1] overflow-hidden bg-base-200" href="{$system['system_url']}/groups/{$_post['group']['group_name']}" aria-label="{$_post['group']['group_title']}">
                {if $_post['group']['group_cover']}
                  <img class="size-full object-cover transition-transform duration-500 ease-out hover:scale-[1.03] motion-reduce:transition-none" src="{$system['system_uploads']}/{$_post['group']['group_cover']}" alt="{$_post['group']['group_title']}" loading="lazy">
                {else}
                  <span class="flex size-full items-center justify-center text-base-content/25" aria-hidden="true"><span class="icon-[tabler--users-group] size-14"></span></span>
                {/if}
                <span class="pointer-events-none absolute inset-x-3 bottom-3 flex items-end justify-between gap-2">
                  <span class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-field bg-black/70 text-white"><span class="icon-[tabler--users-group] size-4" aria-hidden="true"></span>{__("Group")}</span>
                  <span class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-field bg-black/70 text-white">
                    {if $_post['group']['group_privacy'] == "public"}
                      <span class="icon-[tabler--world] size-4" aria-hidden="true"></span>{__("Public Group")}
                    {elseif $_post['group']['group_privacy'] == "closed"}
                      <span class="icon-[tabler--lock] size-4" aria-hidden="true"></span>{__("Closed Group")}
                    {else}
                      <span class="icon-[tabler--eye-off] size-4" aria-hidden="true"></span>{__("Secret Group")}
                    {/if}
                  </span>
                </span>
              </a>
              <!-- group cover -->

              <div class="post-media-meta p-4">
                <div class="flex items-start justify-between gap-3">
                  <div class="min-w-0">
                    <!-- title -->
                    <h3 class="text-base leading-snug font-semibold wrap-break-word">
                      <a class="text-base-content! hover:text-primary!" href="{$system['system_url']}/groups/{$_post['group']['group_name']}">{$_post['group']['group_title']}</a>
                    </h3>
                    <!-- title -->

                    <!-- meta -->
                    <button type="button" class="js_modal mt-1 inline-flex cursor-pointer items-center gap-1 text-sm text-base-content/60 transition-colors hover:text-base-content" data-url="modules/who_members.php?group_id={$_post['group']['group_id']}">
                      <span class="icon-[tabler--users] size-4 shrink-0" aria-hidden="true"></span>{$_post['group']['group_members_formatted']} {__("members")}
                    </button>
                    <!-- meta -->
                  </div>
                  <div class="shrink-0">
                    {if $_post['group']['i_joined'] == "approved"}
                      {include file='__connection_button.tpl' _state="group_joined" _id=$_post['group']['group_id'] _privacy=$_post['group']['group_privacy']}
                    {elseif $_post['group']['i_joined'] == "pending"}
                      {include file='__connection_button.tpl' _state="group_pending" _id=$_post['group']['group_id'] _privacy=$_post['group']['group_privacy']}
                    {elseif $_post['group']['i_admin']}
                      {include file='__connection_button.tpl' _state="group_join" _id=$_post['group']['group_id'] _privacy="public"}
                    {else}
                      {include file='__connection_button.tpl' _state="group_join" _id=$_post['group']['group_id'] _privacy=$_post['group']['group_privacy']}
                    {/if}
                  </div>
                </div>

                <!-- description -->
                {if $_post['group']['group_description']}
                  <div class="js_readmore mt-2.5 text-sm leading-relaxed text-base-content/75 wrap-break-word" data-lines="3" dir="auto">{$_post['group']['group_description']}</div>
                {/if}
                <!-- description -->
              </div>
            </div>
          </div>
        {/if}

        {if $_post['post_type'] == "event" && $_post['event']}
          <div class="mx-4 mt-3">
            <div class="post-media module overflow-hidden rounded-box border border-base-300 bg-base-100">
              <!-- event cover -->
              <a class="post-event-cover relative isolate block aspect-[2/1] overflow-hidden bg-base-200" href="{$system['system_url']}/events/{$_post['event']['event_id']}" aria-label="{$_post['event']['event_title']}">
                {if $_post['event']['event_cover']}
                  <img class="size-full object-cover transition-transform duration-500 ease-out hover:scale-[1.03] motion-reduce:transition-none" src="{$system['system_uploads']}/{$_post['event']['event_cover']}" alt="{$_post['event']['event_title']}" loading="lazy">
                {else}
                  <span class="flex size-full items-center justify-center text-base-content/25" aria-hidden="true"><span class="icon-[tabler--calendar-event] size-14"></span></span>
                {/if}
                <span class="date pointer-events-none absolute start-3 top-3 flex w-12 flex-col overflow-hidden rounded-field bg-base-100 text-center shadow-md">
                  <span class="month bg-primary py-0.5 text-[0.6875rem] leading-4 font-semibold tracking-wide text-primary-content uppercase">{$_post['event']['event_start_date']|date_format:"%b"}</span>
                  <span class="day py-1 text-lg leading-6 font-bold text-base-content">{$_post['event']['event_start_date']|date_format:"%e"}</span>
                </span>
                <span class="pointer-events-none absolute inset-x-3 bottom-3 flex items-end justify-between gap-2">
                  <span class="inline-flex shrink-0 items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-field bg-black/70 text-white"><span class="icon-[tabler--calendar-event] size-4" aria-hidden="true"></span>{__("Event")}</span>
                  {if $_post['event']['event_is_online']}
                    <span class="inline-flex min-w-0 items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-field bg-black/70 text-white"><span class="icon-[tabler--world] size-4 shrink-0" aria-hidden="true"></span><span class="truncate">{__("Online Event")}</span></span>
                  {elseif $_post['event']['event_location']}
                    <span class="inline-flex min-w-0 items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded-field bg-black/70 text-white" title="{$_post['event']['event_location']}"><span class="icon-[tabler--map-pin] size-4 shrink-0" aria-hidden="true"></span><span class="truncate">{$_post['event']['event_location']}</span></span>
                  {/if}
                </span>
              </a>
              <!-- event cover -->

              <div class="post-media-meta p-4">
                <div class="flex items-start justify-between gap-3">
                  <div class="min-w-0">
                    <!-- title -->
                    <h3 class="text-base leading-snug font-semibold wrap-break-word">
                      <a class="text-base-content! hover:text-primary!" href="{$system['system_url']}/events/{$_post['event']['event_id']}">{$_post['event']['event_title']}</a>
                    </h3>
                    <!-- title -->

                    <!-- meta -->
                    <div class="mt-1 flex flex-wrap items-center gap-x-3.5 gap-y-1.5 text-sm text-base-content/60">
                      <span class="inline-flex items-center gap-1"><span class="icon-[tabler--clock] size-4 shrink-0" aria-hidden="true"></span>{$_post['event']['event_start_date']|date_format:"%e %b %Y, %I:%M %p"}</span>
                      <button type="button" class="js_modal inline-flex cursor-pointer items-center gap-1 transition-colors hover:text-base-content" data-url="modules/who_interested.php?event_id={$_post['event']['event_id']}">
                        <span class="icon-[tabler--star] size-4 shrink-0" aria-hidden="true"></span>{$_post['event']['event_interested_formatted']} {__("interested")}
                      </button>
                    </div>
                    <!-- meta -->
                  </div>
                  <div class="shrink-0">
                    {if $_post['event']['i_joined']['is_interested']}
                      {include file='__connection_button.tpl' _state="event_interested" _id=$_post['event']['event_id']}
                    {else}
                      {include file='__connection_button.tpl' _state="event_interest" _id=$_post['event']['event_id']}
                    {/if}
                  </div>
                </div>

                <!-- description -->
                {if $_post['event']['event_description']}
                  <div class="js_readmore mt-2.5 text-sm leading-relaxed text-base-content/75 wrap-break-word" data-lines="3" dir="auto">{$_post['event']['event_description']}</div>
                {/if}
                <!-- description -->
              </div>
            </div>
          </div>
        {/if}

        {if $_post['preview_lock'] && !$_shared}
          <!-- locked preview -->
        </div>
        <div class="hidden group-has-[.lock-preview-input:checked]/preview:block">
          {if $_post['preview_lock'] == 'payment'}
            {include file='_need_payment.tpl' post_id=$_post['post_id'] post_type=$_post['post_type'] price=$_post['post_price'] discounted_price=$_post['post_price_discounted'] paid_text=$_post['paid_text'] paid_image=$_post['paid_image'] _framed=true _preview=true}
          {else}
            {include file='_need_subscription.tpl' node_type=$_post['preview_subscription_type'] node_id=$_post['preview_subscription_id'] price=$_post['preview_subscription_price'] discount_enabled=$_post['preview_subscription_discount_enabled'] discount_percent=$_post['preview_subscription_discount_percent'] subscriptions_image=$_post['subscriptions_image'] _framed=true _preview=true}
          {/if}
        </div>
      </div>
      <!-- locked preview -->
    {/if}

  {/if}

{else}

  {if $_post['needs_age_verification']}
    {include file='_need_age_verification.tpl' _framed=true}
  {elseif $_post['needs_payment']}
    {include file='_need_payment.tpl' post_id=$_post['post_id'] post_type=$_post['post_type'] price=$_post['post_price'] discounted_price=$_post['post_price_discounted'] paid_text=$_post['paid_text'] paid_image=$_post['paid_image'] _framed=true}
  {elseif $_post['needs_subscription']}
    {include file='_need_subscription.tpl' node_type=$_post['needs_subscription_type'] node_id=$_post['needs_subscription_id'] price=$_post['needs_subscription_price'] discount_enabled=$_post['needs_subscription_discount_enabled'] discount_percent=$_post['needs_subscription_discount_percent'] subscriptions_image=$_post['subscriptions_image'] _framed=true}
  {/if}

{/if}