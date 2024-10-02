<!-- post body -->
<div class="post-body {if $_lightbox}pt0{/if}">

  <!-- post header -->
  <div class="post-header">
    <!-- post picture -->
    <div class="post-avatar">
      {if $post['is_anonymous']}
        {include file='__svg_icons.tpl' icon="spy" class="main-icon" width="40px" height="40px"}
      {else}
        <a class="post-avatar-picture" href="{$post['post_author_url']}" style="background-image:url({$post['post_author_picture']});">
        </a>
        {if $post['post_author_online']}<i class="fa fa-circle online-dot"></i>{/if}
      {/if}
    </div>
    <!-- post picture -->

    <!-- post meta -->
    <div class="post-meta">
      <!-- post author -->
      {if $post['is_anonymous']}
        <span class="post-author">{__("Anonymous")}</span>
      {else}
        <span class="js_user-popover" data-type="{$post['user_type']}" data-uid="{$post['user_id']}">
          <a class="post-author" href="{$post['post_author_url']}">{$post['post_author_name']}</a>
        </span>
        {if $post['post_author_verified']}
          <span class="verified-badge" data-bs-toggle="tooltip" title='{if $post['user_type'] == "user"}{__("Verified User")}{else}{__("Verified Page")}{/if}'>
            {include file='__svg_icons.tpl' icon="verified_badge" width="20px" height="20px"}
          </span>
        {/if}
        {if $post['user_subscribed']}
          <span class="pro-badge" data-bs-toggle="tooltip" title='{__("Pro User")}'>
            {include file='__svg_icons.tpl' icon="pro_badge" width="20px" height="20px"}
          </span>
        {/if}
      {/if}
      <!-- post author -->

      <!-- post time & location & privacy -->
      <div class="post-time">
        <a href="{$system['system_url']}/posts/{$post['post_id']}" class="js_moment" data-time="{$post['time']}">{$post['time']}</a>

        {if $post['location']}
          ·
          <i class="fa fa-map-marker"></i> <span>{$post['location']}</span>
        {/if}

        -
        {if $post['privacy'] == "me"}
          <i class="fa fa-lock" data-bs-toggle="tooltip" title='{__("Shared with")} {__("Only Me")}'></i>
        {elseif $post['privacy'] == "friends"}
          <i class="fa fa-users" data-bs-toggle="tooltip" title='{__("Shared with")} {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}'></i>
        {elseif $post['privacy'] == "public"}
          <i class="fa fa-globe" data-bs-toggle="tooltip" title='{__("Shared with")} {__("Public")}'></i>
        {elseif $post['privacy'] == "custom"}
          <i class="fa fa-cog" data-bs-toggle="tooltip" title='{__("Shared with")} {__("Custom People")}'></i>
        {/if}
      </div>
      <!-- post time & location & privacy -->
    </div>
    <!-- post meta -->
  </div>
  <!-- post header -->

  <!-- photo -->
  {if !$_lightbox}
    <div class="mt10 clearfix">
      <div class="pg_wrapper">
        <div class="pg_1x {if $photo['blur']}x-blured{/if}">
          <a href="{$system['system_url']}/photos/{$photo['photo_id']}" class="js_lightbox" data-id="{$photo['photo_id']}" data-image="{$system['system_uploads']}/{$photo['source']}" data-context="{if $photo['is_single']}album{else}post{/if}">
            <img src="{$system['system_uploads']}/{$photo['source']}">
          </a>
        </div>
      </div>
    </div>
  {/if}
  <!-- photo -->

  <!-- post stats -->
  <div class="post-stats clearfix">
    <!-- reactions stats -->
    {if $photo['reactions_total_count'] > 0}
      <div class="float-start" data-toggle="modal" data-url="posts/who_reacts.php?{if $photo['is_single']}post_id={$post['post_id']}{else}photo_id={$photo['photo_id']}{/if}">
        <div class="reactions-stats">
          {foreach $photo['reactions'] as $reaction_type => $reaction_count}
            {if $reaction_count > 0}
              <div class="reactions-stats-item">
                <div class="inline-emoji no_animation">
                  {include file='__reaction_emojis.tpl' _reaction=$reaction_type}
                </div>
              </div>
            {/if}
          {/foreach}
          <!-- reactions count -->
          <span>
            {$photo['reactions_total_count_formatted']}
          </span>
          <!-- reactions count -->
        </div>
      </div>
    {/if}
    <!-- reactions stats -->

    <!-- comments & shares -->
    <span class="float-end">
      <!-- comments -->
      <span class="pointer js_comments-toggle">
        <i class="fa fa-comments"></i> {$photo['comments_formatted']} {__("Comments")}
      </span>
      <!-- comments -->

      <!-- shares -->
      <span class="pointer ml10 {if $post['shares'] == 0}x-hidden{/if}" data-toggle="modal" data-url="posts/who_shares.php?post_id={$post['post_id']}">
        <i class="fa fa-share"></i> {$post['shares_formatted']} {__("Shares")}
      </span>
      <!-- shares -->
    </span>
    <!-- comments & shares -->
  </div>
  <!-- post stats -->

  <!-- post actions -->
  {if $user->_logged_in}
    <div class="post-actions clearfix">
      <!-- reactions -->
      <div class="action-btn unselectable reactions-wrapper {if $photo['i_react']}js_unreact-{if $photo['is_single']}post{else}photo{/if}{/if}" data-reaction="{$photo['i_reaction']}">
        <!-- reaction-btn -->
        <div class="reaction-btn">
          {if !$photo['i_react']}
            <div class="reaction-btn-icon">
              <i class="far fa-smile fa-fw action-icon"></i>
            </div>
            <span class="reaction-btn-name d-none d-xl-inline-block">{__("React")}</span>
          {else}
            <div class="reaction-btn-icon">
              <div class="inline-emoji no_animation">
                {include file='__reaction_emojis.tpl' _reaction=$photo['i_reaction']}
              </div>
            </div>
            <span class="reaction-btn-name" style="color: {$reactions[$photo['i_reaction']]['color']};">{__($reactions[$photo['i_reaction']]['title'])}</span>
          {/if}
        </div>
        <!-- reaction-btn -->

        <!-- reactions-container -->
        <div class="reactions-container">
          {foreach $reactions_enabled as $reaction}
            <div class="reactions_item reaction reaction-{$reaction@iteration} js_react-{if $photo['is_single']}post{else}photo{/if}" data-reaction="{$reaction['reaction']}" data-reaction-color="{$reaction['color']}" data-title="{__($reaction['title'])}">
              {include file='__reaction_emojis.tpl' _reaction=$reaction['reaction']}
            </div>
          {/foreach}
        </div>
        <!-- reactions-container -->
      </div>
      <!-- reactions -->

      <!-- comment -->
      <span class="action-btn js_comment {if $post['comments_disabled']}x-hidden{/if}">
        {include file='__svg_icons.tpl' icon="comment" class="action-icon mr5" width="20px" height="20px"}
        <span class="d-none d-xl-inline-block">{__("Comment")}</span>
      </span>
      <!-- comment -->

      <!-- share -->
      {if $post['privacy'] == "public"}
        <div class="action-btn" data-toggle="modal" data-url="posts/share.php?do=create&post_id={$post['post_id']}&photo_id={$photo['photo_id']}">
          {include file='__svg_icons.tpl' icon="share" class="action-icon mr5" width="20px" height="20px"}
          <span class="d-none d-xl-inline-block">{__("Share")}</span>
        </div>
      {/if}
      <!-- share -->
    </div>
  {/if}
  <!-- post actions -->
</div>

<!-- post footer -->
{if $user->_logged_in}
  <div class="post-footer">
    <!-- comments -->
    {include file='__feeds_post.comments.tpl' _is_photo=(!$photo['is_single'])?true:false}
    <!-- comments -->
  </div>
{else}
  <div class="post-footer">
    <div class="post-comments">
      <div class="pb10">
        <a href="{$system['system_url']}/signin">{__("Please log in to like, share and comment!")}</a>
      </div>
    </div>
  </div>
{/if}
<!-- post footer -->