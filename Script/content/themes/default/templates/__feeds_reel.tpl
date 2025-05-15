<div class="reel-container{if $_hidden || $_iteration > 1} hidden{/if}" data-id="{$post['post_id']}">
  <div class="position-relative">
    <div class="reel-video-wrapper">
      <div class="reel-prev-btn js_reel-prev-btn"><i class="fa fa-chevron-circle-up fa-3x"></i></div>
      <div class="reel-next-btn js_reel-next-btn"><i class="fa fa-chevron-circle-down fa-3x"></i></div>
      <div class="reel-video-container">
        <video class="js_video-plyr" data-reel="true" id="reel-{$post['reel']['reel_id']}" {if $user->_logged_in}onplay="update_media_views('reel', {$post['reel']['reel_id']})" {/if} {if $post['reel']['thumbnail']}data-poster="{$system['system_uploads']}/{$post['reel']['thumbnail']}" {/if} preload="auto" {if $_iteration == 1}autoplay{/if} playsinline preload="auto">
          {if empty($post['reel']['source_240p']) && empty($post['reel']['source_360p']) && empty($post['reel']['source_480p']) && empty($post['reel']['source_720p']) && empty($post['reel']['source_1080p']) && empty($post['reel']['source_1440p']) && empty($post['reel']['source_2160p'])}
            <source src="{$system['system_uploads']}/{$post['reel']['source']}" type="video/mp4">
          {/if}
          {if $post['reel']['source_240p']}
            <source src="{$system['system_uploads']}/{$post['reel']['source_240p']}" type="video/mp4" size="240">
          {/if}
          {if $post['reel']['source_360p']}
            <source src="{$system['system_uploads']}/{$post['reel']['source_360p']}" type="video/mp4" size="360">
          {/if}
          {if $post['reel']['source_480p']}
            <source src="{$system['system_uploads']}/{$post['reel']['source_480p']}" type="video/mp4" size="480">
          {/if}
          {if $post['reel']['source_720p']}
            <source src="{$system['system_uploads']}/{$post['reel']['source_720p']}" type="video/mp4" size="720">
          {/if}
          {if $post['reel']['source_1080p']}
            <source src="{$system['system_uploads']}/{$post['reel']['source_1080p']}" type="video/mp4" size="1080">
          {/if}
          {if $post['reel']['source_1440p']}
            <source src="{$system['system_uploads']}/{$post['reel']['source_1440p']}" type="video/mp4" size="1440">
          {/if}
          {if $post['reel']['source_2160p']}
            <source src="{$system['system_uploads']}/{$post['reel']['source_2160p']}" type="video/mp4" size="2160">
          {/if}
        </video>

        {if $post['text']}
          <div class="video-caption-overlay"></div>
          <div class="video-caption">
            {include file='__feeds_post.text.tpl'}
          </div>
        {/if}
        <div class="video-controlls">
          <div class="reel-actions">
            <!-- post picture -->
            <div class="post-avatar">
              {if $post['is_anonymous']}
                <div class="post-avatar-anonymous">
                  {include file='__svg_icons.tpl' icon="spy" class="main-icon" width="40px" height="40px"}
                </div>
              {else}
                <a class="post-avatar-picture" href="{$post['post_author_url']}" style="background-image:url({$post['post_author_picture']});">
                </a>
                {if $post['post_author_online']}<i class="fa fa-circle online-dot"></i>{/if}
              {/if}
            </div>
            <!-- post picture -->

            <!-- reactions -->
            <div class="reel-action-btn">
              <div class="action-btn unselectable reactions-wrapper {if $post['i_react']}js_unreact-post{/if}" data-reaction="{$post['i_reaction']}">
                <!-- reaction-btn -->
                <div class="reaction-btn">
                  {if !$post['i_react']}
                    <div class="reaction-btn-icon">
                      <i class="far fa-smile fa-fw white-icon"></i>
                    </div>
                  {else}
                    <div class="reaction-btn-icon">
                      <div class="inline-emoji no_animation">
                        {include file='__reaction_emojis.tpl' _reaction=$post['i_reaction']}
                      </div>
                    </div>
                  {/if}
                </div>
                <!-- reaction-btn -->

                <!-- reactions-container -->
                <div class="reactions-container">
                  {foreach $reactions_enabled as $reaction}
                    <div class="reactions_item reaction reaction-{$reaction@iteration} js_react-post" data-reaction="{$reaction['reaction']}" data-reaction-color="{$reaction['color']}" data-title="{__($reaction['title'])}">
                      {include file='__reaction_emojis.tpl' _reaction=$reaction['reaction']}
                    </div>
                  {/foreach}
                </div>
                <!-- reactions-container -->
              </div>
              <!-- reactions stats -->
              <span class="pointer" data-toggle="modal" data-url="posts/who_reacts.php?post_id={$post['post_id']}">
                {$post['reactions_total_count_formatted']}
              </span>
              <!-- reactions stats -->
            </div>
            <!-- reactions -->

            <!-- comment -->
            <div class="reel-action-btn">
              <div class="action-btn js_reel-comments-toggle">
                {include file='__svg_icons.tpl' icon="comment" class="white-icon" width="30px" height="30px"}
              </div>
              <span class="pointer  js_reel-comments-toggle">{$post['comments_formatted']}</span>
            </div>
            <!-- comment -->

            <!-- share -->
            {if $post['privacy'] == "public" || ($post['in_group'] && $post['group_privacy'] == "public") || ($post['in_event'] && $post['event_privacy'] == "public") }
              <div class="reel-action-btn">
                <div class="action-btn" data-toggle="modal" data-url="posts/share.php?do=create&post_id={$post['post_id']}">
                  {include file='__svg_icons.tpl' icon="share" class="white-icon" width="30px" height="30px"}
                </div>
                <!-- shares -->
                <span class="pointer" data-toggle="modal" data-url="posts/who_shares.php?post_id={$post['post_id']}">
                  {$post['shares_formatted']}
                </span>
                <!-- shares -->
              </div>
            {/if}
            <!-- share -->
          </div>
        </div>
      </div>
    </div>
    <div class="reel-comments-wrapper">
      <div class="clearfix">
        <div class="pt5 pr5 float-end">
          <button type="button" class="btn-close js_reel-comments-toggle"></button>
        </div>
      </div>
      <div class="lightbox-post" data-id="{$post['post_id']}">
        <div class="js_scroller" data-slimScroll-height="100%">
          {include file='__feeds_post_reel.tpl'}
        </div>
      </div>
    </div>
  </div>
</div>