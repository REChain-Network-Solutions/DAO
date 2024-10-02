{if $_tpl == "featured"}
  <div class="{if $_iteration == 1}col-sm-12 col-md-8 col-lg-6{else}col-sm-6 col-md-4 col-lg-3{/if}">
    <a href="{if $blog['needs_payment'] || $blog['needs_subscription'] || $blog['needs_pro_package'] || $blog['needs_age_verification']}{$system['system_url']}/posts/{$blog['post_id']}{else}{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}{/if}" class="blog-container {if $_iteration == 1}primary{/if}">
      {if $blog['needs_payment']}
        <div class="ptb20 plr20">
          {include file='_need_payment.tpl' post_id=$blog['post_id'] price=$blog['post_price']}
        </div>
      {elseif $blog['needs_subscription']}
        <div class="ptb20 plr20">
          {include file='_need_subscription.tpl'}
        </div>
      {elseif $blog['needs_pro_package']}
        <div class="ptb20 plr20">
          {include file='_need_pro_package.tpl'}
        </div>
      {elseif $blog['needs_age_verification']}
        <div class="ptb20 plr20">
          {include file='_need_age_verification.tpl'}
        </div>
      {else}
        <div class="blog-image">
          <img src="{$blog['blog']['parsed_cover']}">
        </div>
        <div class="blog-content">
          <h3>{$blog['blog']['title']}</h3>
          <div class="text">{$blog['blog']['text_snippet']|truncate:400}</div>
          <div>
            <div class="post-avatar">
              <div class="post-avatar-picture small" style="background-image:url('{$blog['post_author_picture']}');">
              </div>
            </div>
            <div class="post-meta">
              <span class="text-link">
                {$blog['post_author_name']}
              </span>
              <div class="post-time">
                <span class="js_moment" data-time="{$blog['time']}">{$blog['time']}</span>
              </div>
            </div>
          </div>
        </div>
      {/if}
      <div class="blog-more">
        <span>{__("More")}</span>
      </div>
    </a>
  </div>
{else}
  <div class="post-media list">
    {if $blog['needs_payment']}
      <a href="{$system['system_url']}/posts/{$blog['post_id']}">
        <div class="ptb20 plr20">
          {include file='_need_payment.tpl' post_id=$blog['post_id'] price=$blog['post_price'] paid_text=$blog['paid_text']}
        </div>
      </a>
    {elseif $blog['needs_subscription']}
      <a href="{$system['system_url']}/posts/{$blog['post_id']}">
        <div class="ptb20 plr20">
          {include file='_need_subscription.tpl'}
        </div>
      </a>
    {elseif $blog['needs_pro_package']}
      <a href="{$system['system_url']}/posts/{$blog['post_id']}">
        <div class="ptb20 plr20">
          {include file='_need_pro_package.tpl'}
        </div>
      </a>
    {elseif $blog['needs_age_verification']}
      <a href="{$system['system_url']}/posts/{$blog['post_id']}">
        <div class="ptb20 plr20">
          {include file='_need_age_verification.tpl'}
        </div>
      </a>
    {else}
      <div class="post-media-image-wrapper">
        <a class="post-media-image" href="{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}">
          <div style="padding-top: 50%; background-position: center center; background-size: cover; background-image:url('{$blog['blog']['parsed_cover']}');"></div>
        </a>
        <div class="post-media-image-meta">
          <a class="blog-category {if $_small}small{/if}" href="{$system['system_url']}/blogs/category/{$blog['blog']['category_id']}/{$blog['blog']['category_url']}">
            {__($blog['blog']['category_name'])}
          </a>
        </div>
      </div>
      <div class="post-media-meta">
        <a class="title mb5" href="{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}">{$blog['blog']['title']}</a>
        <div class="text mb5">
          {if $_small}
            {$blog['blog']['text_snippet']|truncate:100}
          {else}
            {$blog['blog']['text_snippet']|truncate:500}
          {/if}
        </div>
        <div class="info">
          {__("By")}
          <span class="js_user-popover pr10" data-type="{$blog['user_type']}" data-uid="{$blog['user_id']}">
            <a href="{$blog['post_author_url']}">{$blog['post_author_name']}</a>
          </span>
          <i class="fa fa-clock pr5"></i><span class="js_moment pr10" data-time="{$blog['time']}">{$blog['time']}</span>
          <i class="fa fa-comments pr5"></i><span class="pr10">{$blog['comments_formatted']}</span>
          <i class="fa fa-eye pr5"></i><span class="pr10">{$blog['views_formatted']}</span>
        </div>
      </div>
    {/if}
  </div>
{/if}