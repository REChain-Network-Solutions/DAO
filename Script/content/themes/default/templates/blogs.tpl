{include file='_head.tpl'}
{include file='_header.tpl'}

{if $view == ""}
  <!-- page header -->
  <div class="page-header">
    <img class="floating-img d-none d-md-block" src="{$system['system_url']}/content/themes/{$system['theme']}/images/headers/undraw_content_creator_xeju.svg">
    <div class="circle-2"></div>
    <div class="circle-3"></div>
    <div class="{if $system['fluid_design']}container-fluid{else}container{/if}">
      <h2>{__("Blogs")}</h2>
      <p class="text-xlg">{__($system['system_description_blogs'])}</p>
      <div class="row mt20">
        <div class="col-sm-9 col-lg-6 mx-sm-auto">
          <form class="js_search-form" data-filter="blogs">
            <div class="input-group">
              <input type="text" class="form-control" name="query" placeholder='{__("Search for blogs")}'>
              <button type="submit" class="btn btn-light">{__("Search")}</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
  <!-- page header -->
{/if}


<!-- page content -->
<div class="{if $system['fluid_design']}container-fluid{else}container{/if} mt20 sg-offcanvas">
  <div class="row">

    {if $view == ""}

      <!-- side panel -->
      <div class="col-12 d-block d-md-none sg-offcanvas-sidebar">
        {include file='_sidebar.tpl'}
      </div>
      <!-- side panel -->

      <!-- content panel -->
      <div class="col-12 sg-offcanvas-mainbar">
        <!-- location filter -->
        {if $system['newsfeed_location_filter_enabled']}
          <div class="posts-filter">
            <span>{__("Blogs")}</span>
            <div class="float-end">
              <a href="#" data-bs-toggle="dropdown" class="countries-filter">
                <i class="fa fa-globe fa-fw"></i>
                {if $selected_country}
                  <span>{$selected_country['country_name']}</span>
                {else}
                  <span>{__("All Countries")}</span>
                {/if}
              </a>
              <div class="dropdown-menu dropdown-menu-end countries-dropdown">
                <div class="js_scroller">
                  <a class="dropdown-item" href="?country=all">
                    {__("All Countries")}
                  </a>
                  {foreach $countries as $country}
                    <a class="dropdown-item" href="?country={$country['country_name_native']}">
                      {$country['country_name']}
                    </a>
                  {/foreach}
                </div>
              </div>
            </div>
          </div>
        {/if}
        <!-- location filter -->

        <div class="blogs-wrapper">
          {if $blogs}
            <ul class="row">
              {foreach $blogs as $blog}
                {include file='__feeds_blog.tpl' _tpl="featured" _iteration=$blog@iteration}
              {/foreach}
            </ul>

            <!-- see-more -->
            <div class="alert alert-post see-more js_see-more" data-get="blogs" data-country="{if $selected_country}{$selected_country['country_id']}{else}all{/if}">
              <span>{__("More Blogs")}</span>
              <div class="loader loader_small x-hidden"></div>
            </div>
            <!-- see-more -->
          {else}
            {include file='_no_data.tpl'}
          {/if}
        </div>
      </div>
      <!-- content panel -->

    {elseif $view == "category"}

      <!-- side panel -->
      <div class="col-12 d-block d-md-none sg-offcanvas-sidebar">
        {include file='_sidebar.tpl'}
      </div>
      <!-- side panel -->

      <!-- content panel -->
      <div class="col-12 sg-offcanvas-mainbar">
        <div class="row">
          <!-- left panel -->
          <div class="col-md-8 mb20">
            <!-- location filter -->
            {if $system['newsfeed_location_filter_enabled']}
              <div class="posts-filter">
                <span>{__($category['category_name'])}</span>
                <div class="float-end">
                  <a href="#" data-bs-toggle="dropdown" class="countries-filter">
                    <i class="fa fa-globe fa-fw"></i>
                    {if $selected_country}
                      <span>{$selected_country['country_name']}</span>
                    {else}
                      <span>{__("All Countries")}</span>
                    {/if}
                  </a>
                  <div class="dropdown-menu dropdown-menu-end countries-dropdown">
                    <div class="js_scroller">
                      <a class="dropdown-item" href="?country=all">
                        {__("All Countries")}
                      </a>
                      {foreach $countries as $country}
                        <a class="dropdown-item" href="?country={$country['country_name_native']}">
                          {$country['country_name']}
                        </a>
                      {/foreach}
                    </div>
                  </div>
                </div>
              </div>
            {/if}
            <!-- location filter -->

            {if $blogs}
              <ul>
                {foreach $blogs as $blog}
                  {include file='__feeds_blog.tpl'}
                {/foreach}
              </ul>

              <!-- see-more -->
              <div class="alert alert-post see-more js_see-more" data-get="category_blogs" data-id="{$category['category_id']}" data-country="{if $selected_country}{$selected_country['country_id']}{else}all{/if}">
                <span>{__("More Blogs")}</span>
                <div class="loader loader_small x-hidden"></div>
              </div>
              <!-- see-more -->
            {else}
              {include file='_no_data.tpl'}
            {/if}
          </div>
          <!-- left panel -->

          <!-- right panel -->
          <div class="col-md-4">
            <!-- create new blog -->
            {if $user->_logged_in && $user->_data['can_write_blogs']}
              <div class="mb10 d-none d-sm-block">
                <div class="d-grid">
                  <a href="{$system['system_url']}/blogs/new" class="btn btn-success">
                    <i class="fa fa-edit mr5"></i>{__("Create New Blog")}
                  </a>
                </div>
              </div>
            {/if}
            <!-- create new blog -->

            {include file='_ads.tpl'}
            {include file='_widget.tpl'}

            {if $category['category_description']}
              <!-- category description -->
              <div class="blogs-widget-header">
                <div class="blogs-widget-title">{__("Description")}</div>
              </div>
              <div class="mb15">
                {__($category['category_description'])}
              </div>
              <!-- category description -->
            {/if}

            {if $blogs_categories}
              <!-- blogs categories -->
              <div class="blogs-widget-header">
                <div class="blogs-widget-title">{__("Sub-Categories")}</div>
              </div>
              <ul class="blog-categories clearfix">
                {foreach $blogs_categories as $category}
                  <li>
                    <a class="blog-category" href="{$system['system_url']}/blogs/category/{$category['category_id']}/{$category['category_url']}">
                      {__($category['category_name'])}
                    </a>
                  </li>
                {/foreach}
              </ul>
              <!-- blogs categories -->
            {/if}

            <!-- read more -->
            <div class="blogs-widget-header">
              <div class="blogs-widget-title">{__("Read More")}</div>
            </div>

            {foreach $latest_blogs as $blog}
              {include file='__feeds_blog.tpl' _small=true}
            {/foreach}
            <!-- read more -->
          </div>
          <!-- right panel -->
        </div>
      </div>
      <!-- content panel -->

    {elseif $view == "blog"}

      <!-- side panel -->
      <div class="col-12 d-block d-md-none sg-offcanvas-sidebar">
        {include file='_sidebar.tpl'}
      </div>
      <!-- side panel -->

      <!-- content panel -->
      <div class="col-12 sg-offcanvas-mainbar">
        <div class="row">
          <!-- left panel -->
          <div class="col-md-8 mb20">
            {if $blog['needs_payment']}
              <div class="blog-wrapper no-footer">
                <div class="ptb20 plr20">
                  {include file='_need_payment.tpl' post_id=$blog['post_id'] price=$blog['post_price'] paid_text=$blog['paid_text']}
                </div>
              </div>
            {elseif $blog['needs_subscription']}
              <div class="blog-wrapper no-footer">
                <div class="ptb20 plr20">
                  {include file='_need_subscription.tpl' node_type=$blog['needs_subscription_type'] node_id=$blog['needs_subscription_id'] price=$blog['needs_subscription_price']}
                </div>
              </div>
            {elseif $blog['needs_pro_package']}
              <div class="blog-wrapper no-footer">
                <div class="ptb20 plr20">
                  {include file='_need_pro_package.tpl' _manage = true}
                </div>
              </div>
            {elseif $blog['needs_age_verification']}
              <div class="blog-wrapper no-footer">
                <div class="ptb20 plr20">
                  {include file='_need_age_verification.tpl'}
                </div>
              </div>
            {else}
              <div class="blog mb20 {if ($blog['is_pending']) OR ($blog['in_group'] && !$blog['group_approved']) OR ($blog['in_event'] && !$blog['event_approved'])}pending{/if}" data-id="{$blog['post_id']}">
                {if ($blog['is_pending']) OR ($blog['in_group'] && !$blog['group_approved']) OR ($blog['in_event'] && !$blog['event_approved'])}
                  <div class="pending-icon" data-bs-toggle="tooltip" title="{__("Pending Post")}">
                    <i class="fa fa-clock"></i>
                  </div>
                {/if}
                <div class="blog-wrapper {if $user->_logged_in}pb10{/if}">
                  {if $blog['manage_post']}
                    <div class="text-end mb10">
                      <a type="button" class="btn btn-sm btn-light" href="{$system['system_url']}/blogs/edit/{$blog['post_id']}">
                        {__("Edit")}
                      </a>
                    </div>
                  {/if}

                  <!-- blog title -->
                  <h3 class="mb10">{$blog['blog']['title']}</h3>
                  <!-- blog title -->

                  <!-- blog category -->
                  <div class="mb20">
                    <a class="badge bg-light text-primary" href="{$system['system_url']}/blogs">
                      {__("Blogs")}
                    </a>
                    <i class="fa fa-chevron-right ml5 mr5"></i>
                    <a class="badge bg-light text-primary" href="{$system['system_url']}/blogs/category/{$blog['blog']['category_id']}/{$blog['blog']['category_url']}">
                      {__($blog['blog']['category_name'])}
                    </a>
                  </div>
                  <!-- blog category -->

                  <!-- blog meta -->
                  <div class="row">
                    <div class="col-lg-6 mb20">
                      <div class="post-avatar">
                        <a class="post-avatar-picture" href="{$blog['post_author_url']}" style="background-image:url({$blog['post_author_picture']});">
                        </a>
                      </div>
                      <div class="post-meta">
                        <div>
                          <!-- post author name -->
                          <span class="js_user-popover" data-type="{$blog['user_type']}" data-uid="{$blog['user_id']}">
                            <a href="{$blog['post_author_url']}">{$blog['post_author_name']}</a>
                          </span>
                          {if $blog['post_author_verified']}
                            <span class="verified-badge" data-bs-toggle="tooltip" title='{if $blog['user_type'] == "user"}{__("Verified User")}{else}{__("Verified Page")}{/if}'>
                              {include file='__svg_icons.tpl' icon="verified_badge" width="20px" height="20px"}
                            </span>
                          {/if}
                          {if $blog['user_subscribed']}
                            <span class="pro-badge" data-bs-toggle="tooltip" title='{__("Pro User")}'>
                              {include file='__svg_icons.tpl' icon="pro_badge" width="20px" height="20px"}
                            </span>
                          {/if}
                          <!-- post author name -->
                        </div>
                        <div class="post-time">
                          {__("Posted")} <span class="js_moment" data-time="{$blog['time']}">{$blog['time']}</span>
                          {if $blog['for_subscriptions']}
                            <span class="badge bg-light text-primary ml5"><i class="fa fa-star mr5"></i>{__("Subscriptions")|upper}</span>
                          {/if}
                          {if $blog['is_paid']}
                            <span class="badge bg-light text-primary ml5"><i class="fa-solid fa-sack-dollar mr5"></i>{__("Paid")|upper}</span>
                          {/if}
                        </div>
                      </div>
                    </div>
                    <div class="col-lg-6 text-start text-lg-end mb20">
                      <a class="blog-meta-counter unselectable" href="#blog-comments">
                        <i class="fa fa-comments fa-fw"></i> {$blog['comments_formatted']}
                      </a>
                      <div class="blog-meta-counter unselectable">
                        <i class="fa fa-eye fa-fw"></i> {$blog['views_formatted']}
                      </div>
                    </div>
                  </div>
                  <!-- blog meta -->

                  <!-- blog cover -->
                  {if $blog['blog']['cover']}
                    <div class="mb20">
                      <img class="img-fluid" src="{$blog['blog']['parsed_cover']}">
                    </div>
                  {/if}
                  <!-- blog cover -->

                  <!-- blog text -->
                  <div class="blog-text text-with-list" dir="auto">
                    {$blog['blog']['parsed_text']}
                  </div>
                  <!-- blog text -->

                  <!-- blog tags -->
                  {if $blog['blog']['parsed_tags']}
                    <div class="blog-tags">
                      <ul>
                        {foreach $blog['blog']['parsed_tags'] as $tag}
                          <li>
                            <a href="{$system['system_url']}/search/hashtag/{$tag}">{__($tag)}</a>
                          </li>
                        {/foreach}
                      </ul>
                    </div>
                  {/if}
                  <!-- blog tags -->

                  <!-- post stats -->
                  <div class="post-stats clearfix">
                    <!-- reactions stats -->
                    {if $blog['reactions_total_count'] > 0}
                      <div class="float-start mr10" data-toggle="modal" data-url="posts/who_reacts.php?post_id={$blog['post_id']}">
                        <div class="reactions-stats">
                          {foreach $blog['reactions'] as $reaction_type => $reaction_count}
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
                            {$blog['reactions_total_count_formatted']}
                          </span>
                          <!-- reactions count -->
                        </div>
                      </div>
                    {/if}
                    <!-- reactions stats -->
                  </div>
                  <!-- post stats -->

                  <!-- post actions -->
                  {if $user->_logged_in}
                    <div class="post-actions">
                      <!-- reactions -->
                      <div class="action-btn unselectable reactions-wrapper {if $blog['i_react']}js_unreact-post{/if}" data-reaction="{$blog['i_reaction']}">
                        <!-- reaction-btn -->
                        <div class="reaction-btn">
                          {if !$blog['i_react']}
                            <div class="reaction-btn-icon">
                              <i class="far fa-smile fa-fw action-icon"></i>
                            </div>
                            <span class="reaction-btn-name d-none d-xl-inline-block">{__("React")}</span>
                          {else}
                            <div class="reaction-btn-icon">
                              <div class="inline-emoji no_animation">
                                {include file='__reaction_emojis.tpl' _reaction=$blog['i_reaction']}
                              </div>
                            </div>
                            <span class="reaction-btn-name" style="{$reactions[$blog['i_reaction']]['color']}">{__($reactions[$blog['i_reaction']]['title'])}</span>
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
                      <!-- reactions -->

                      <!-- comment -->
                      <div class="action-btn js_comment {if $blog['comments_disabled']}x-hidden{/if}">
                        {include file='__svg_icons.tpl' icon="comment" class="action-icon mr5" width="24px" height="24px"}
                        <span class="d-none d-xl-inline-block">{__("Comment")}</span>
                      </div>
                      <!-- comment -->

                      <!-- share -->
                      {if $blog['privacy'] == "public"}
                        <div class="action-btn" data-toggle="modal" data-url="posts/share.php?do=create&post_id={$blog['post_id']}">
                          {include file='__svg_icons.tpl' icon="share" class="action-icon mr5" width="24px" height="24px"}
                          <span class="d-none d-xl-inline-block">{__("Share")}</span>
                        </div>
                      {/if}
                      <!-- share -->

                      <!-- tips -->
                      {if $user->_logged_in && $blog['author_id'] != $user->_data['user_id'] && $blog['tips_enabled']}
                        <div class="action-btn" data-toggle="modal" data-url="#send-tip" data-options='{ "id": "{$blog['author_id']}"}'>
                          {include file='__svg_icons.tpl' icon="tip" class="action-icon mr5" width="24px" height="24px"}
                          <span class="ml5 d-none d-xl-inline-block">{__("Tip")}</span>
                        </div>
                      {/if}
                      <!-- tips -->
                    </div>
                  {/if}
                  <!-- post actions -->
                </div>

                <!-- post footer -->
                <div class="post-footer" id="blog-comments">
                  {if $user->_logged_in}
                    <!-- comments -->
                    {include file='__feeds_post.comments.tpl' post=$blog}
                    <!-- comments -->
                  {else}
                    <div class="ptb10">
                      <a href="{$system['system_url']}/signin">{__("Please log in to like, share and comment!")}</a>
                    </div>
                  {/if}
                </div>
                <!-- post footer -->
              </div>
            {/if}
            {include file='_ads.tpl' ads=$ads_footer}
          </div>
          <!-- left panel -->

          <!-- right panel -->
          <div class="col-md-4">
            <!-- create new blog -->
            {if $user->_logged_in && $user->_data['can_write_blogs']}
              <div class="mb10 d-none d-sm-block">
                <div class="d-grid">
                  <a href="{$system['system_url']}/blogs/new" class="btn btn-success">
                    <i class="fa fa-edit mr5"></i>{__("Create New Blog")}
                  </a>
                </div>
              </div>
            {/if}
            <!-- create new blog -->

            <!-- search -->
            <div class="blogs-widget-header">
              <div class="blogs-widget-title">{__("Search")}</div>
            </div>
            <div class="mb10">
              <form class="js_search-form" data-filter="blogs">
                <div class="input-group">
                  <input type="text" class="form-control" name="query" placeholder='{__("Search for blogs")}'>
                  <button type="submit" class="btn btn-secondary">{__("Search")}</button>
                </div>
              </form>
            </div>
            <!-- search -->

            {include file='_ads.tpl'}
            {include file='_widget.tpl'}

            <!-- blogs categories -->
            <div class="blogs-widget-header">
              <div class="blogs-widget-title">{__("Categories")}</div>
            </div>
            <ul class="blog-categories clearfix">
              {foreach $blogs_categories as $category}
                <li>
                  <a class="blog-category" href="{$system['system_url']}/blogs/category/{$category['category_id']}/{$category['category_url']}">
                    {__($category['category_name'])}
                  </a>
                </li>
              {/foreach}
            </ul>
            <!-- blogs categories -->

            <!-- read more -->
            <div class="blogs-widget-header">
              <div class="blogs-widget-title">{__("Read More")}</div>
            </div>

            {foreach $latest_blogs as $blog}
              {include file='__feeds_blog.tpl' _small=true}
            {/foreach}
            <!-- read more -->
          </div>
          <!-- right panel -->
        </div>
      </div>
      <!-- content panel -->

    {elseif $view == "edit"}

      <!-- side panel -->
      <div class="col-md-4 col-lg-3 sg-offcanvas-sidebar js_sticky-sidebar">
        {include file='_sidebar.tpl'}
      </div>
      <!-- side panel -->

      <!-- content panel -->
      <div class="col-md-8 col-lg-9 sg-offcanvas-mainbar">
        <!-- content -->
        <div class="card">
          <div class="card-header with-icon">
            {include file='__svg_icons.tpl' icon="blogs" class="main-icon mr5" width="24px" height="24px"}
            {__("Edit Blog")}
            <div class="float-end">
              <a href="{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}" class="btn btn-md btn-light">
                <i class="fa fa-arrow-circle-left mr5"></i>{__("Go Back")}
              </a>
            </div>
          </div>
          <div class="js_ajax-forms-html " data-url="posts/blog.php?do=edit&id={$blog['post_id']}">
            <div class="card-body">
              <div class="row form-group">
                <label class="col-md-2 form-label">
                  {__("Title")}
                </label>
                <div class="col-md-10">
                  <input class="form-control" name="title" value="{$blog['blog']['title']}">
                </div>
              </div>

              <div class="row form-group">
                <label class="col-md-2 form-label">
                  {__("Content")}
                </label>
                <div class="col-md-10">
                  <textarea name="text" class="form-control js_wysiwyg">{$blog['blog']['text']}</textarea>
                </div>
              </div>

              <div class="row form-group">
                <label class="col-md-2 form-label">
                  {__("Cover")}
                </label>
                <div class="col-md-10">
                  {if $blog['blog']['cover'] == ''}
                    <div class="x-image">
                      <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'>

                      </button>
                      <div class="x-image-loader">
                        <div class="progress x-progress">
                          <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                      </div>
                      <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                      <input type="hidden" class="js_x-image-input" name="cover" value="">
                    </div>
                  {else}
                    <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$blog['blog']['cover']}')">
                      <button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'>

                      </button>
                      <div class="x-image-loader">
                        <div class="progress x-progress">
                          <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                      </div>
                      <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                      <input type="hidden" class="js_x-image-input" name="cover" value="{$blog['blog']['cover']}">
                    </div>
                  {/if}
                </div>
              </div>

              <div class="row form-group">
                <label class="col-md-2 form-label">
                  {__("Category")}
                </label>
                <div class="col-md-10">
                  <select class="form-select" name="category">
                    <option>{__("Select Category")}</option>
                    {foreach $blogs_categories as $category}
                      {include file='__categories.recursive_options.tpl' data_category=$blog['blog']['category_id']}
                    {/foreach}
                  </select>
                </div>
              </div>

              <div class="row form-group">
                <label class="col-md-2 form-label">
                  {__("Tags")}
                </label>
                <div class="col-md-10">
                  <input class="form-control js_tagify" name="tags" value="{$blog['blog']['tags']}">
                  <div class="form-text">
                    {__("Type a tag name and press Enter or Comma to add it")}
                  </div>
                </div>
              </div>

              {if ($user->_data['can_receive_tip'] && $blog['user_type'] != "page") || $user->_data['can_monetize_content']}
                <div class="divider"></div>
              {/if}

              <!-- enable tips -->
              {if $user->_data['can_receive_tip'] && $blog['user_type'] != "page"}
                <div class="form-table-row mb10">
                  <div>
                    <div class="form-label mb0">{__("Enable Tips")}</div>
                    <div class="form-text d-none d-sm-block mt0">{__("Allow people to send you tips")}</div>
                  </div>
                  <div class="text-end">
                    <label class="switch" for="tips_enabled">
                      <input type="checkbox" name="tips_enabled" id="tips_enabled" {if $blog['tips_enabled']} checked{/if}>
                      <span class="slider round"></span>
                    </label>
                  </div>
                </div>
              {/if}
              <!-- enable tips -->

              <!-- only for subscribers -->
              {if $user->_data['can_monetize_content']}
                <div class="form-table-row mb10 {if $blog['is_paid']}disabled{/if}" id="subscribers-toggle-wrapper">
                  <div>
                    <div class="form-label mb0">{__("Subscribers Only")}</div>
                    <div class="form-text d-none d-sm-block mt0">{__("Share this post to")} {__("subscribers only")}</div>
                  </div>
                  <div class="text-end">
                    <label class="switch" for="subscribers_only">
                      <input type="checkbox" name="subscribers_only" id="subscribers_only" class="js_publisher-subscribers-toggle" {if $blog['for_subscriptions']} checked{/if} {if $blog['is_paid']}disabled{/if}>
                      <span class="slider round"></span>
                    </label>
                  </div>
                </div>
              {/if}
              <!-- only for subscribers -->

              <!-- paid post -->
              {if $user->_data['can_monetize_content'] && $user->_data['user_monetization_enabled']}
                <div class="form-table-row mb10 {if $blog['for_subscriptions']}disabled{/if}" id="paid-toggle-wrapper">
                  <div>
                    <div class="form-label mb0">{__("Paid Post")}</div>
                    <div class="form-text d-none d-sm-block mt0">{__("Set a price to your post")}</div>
                  </div>
                  <div class="text-end">
                    <label class="switch" for="paid_post">
                      <input type="checkbox" name="paid_post" id="paid_post" class="js_publisher-paid-toggle" {if $blog['is_paid']} checked{/if} {if $blog['for_subscriptions']}disabled{/if}>
                      <span class="slider round"></span>
                    </label>
                  </div>
                </div>
                <div class="form-group {if !$blog['post_price']}x-hidden{/if}" id="paid-price-wrapper">
                  <input type="text" class="form-control" name="paid_post_price" placeholder="{__("Price")} ({$system['system_currency']})" value="{$blog['post_price']}">
                </div>
                <div class="form-group {if !$blog['paid_text']}x-hidden{/if}" id="paid-text-wrapper">
                  <textarea class="form-control" name="paid_post_text" rows="3">{$blog['paid_text']}</textarea>
                </div>
              {/if}
              <!-- paid post -->

              <!-- error -->
              <div class="alert alert-danger mt15 mb0 x-hidden"></div>
              <!-- error -->
            </div>
            <div class="card-footer text-end">
              <button type="button" class="btn btn-danger js_delete-blog" data-id="{$blog['post_id']}">
                <i class="fa fa-trash mr5"></i>{__("Delete Blog")}
              </button>
              <button type="submit" class="btn btn-primary">{__("Publish")}</button>
            </div>
          </div>
        </div>
        <!-- content -->
      </div>
      <!-- content panel -->

    {elseif $view == "new"}

      <!-- side panel -->
      <div class="col-md-4 col-lg-3 sg-offcanvas-sidebar js_sticky-sidebar">
        {include file='_sidebar.tpl'}
      </div>
      <!-- side panel -->

      <!-- content panel -->
      <div class="col-md-8 col-lg-9 sg-offcanvas-mainbar">
        <!-- content -->
        <div class="card">
          <div class="card-header with-icon">
            {include file='__svg_icons.tpl' icon="blogs" class="main-icon mr5" width="24px" height="24px"}
            {__("Create New Blog")}
          </div>
          <div class="js_ajax-forms-html" data-url="posts/blog.php?do=create">
            <div class="card-body">
              <div class="row form-group">
                <label class="col-md-2 form-label">
                  {__("Publish To")}
                </label>
                <div class="col-md-10">
                  <!-- publish to options -->
                  <div>
                    <!-- Timeline -->
                    <input class="x-hidden input-label" type="radio" name="publish_to" id="publish_to_timeline" value="timeline" {if $share_to == "timeline"}checked="checked" {/if} />
                    <label class="button-label" for="publish_to_timeline">
                      <div class="icon">
                        {include file='__svg_icons.tpl' icon="newsfeed" class="main-icon" width="20px" height="20px"}
                      </div>
                      <div class="title">{__("Timeline")}</div>
                    </label>
                    <!-- Timeline -->
                    <!-- Page -->
                    {if $system['pages_enabled'] && $pages}
                      <input class="x-hidden input-label" type="radio" name="publish_to" id="publish_to_page" value="page" {if $share_to == "page"}checked="checked" {/if} />
                      <label class="button-label" for="publish_to_page">
                        <div class="icon">
                          {include file='__svg_icons.tpl' icon="pages" class="main-icon" width="20px" height="20px"}
                        </div>
                        <div class="title">{__("Page")}</div>
                      </label>
                    {/if}
                    <!-- Page -->
                    <!-- Group -->
                    {if $system['groups_enabled'] && $groups}
                      <input class="x-hidden input-label" type="radio" name="publish_to" id="publish_to_group" value="group" {if $share_to == "group"}checked="checked" {/if} />
                      <label class="button-label" for="publish_to_group">
                        <div class="icon">
                          {include file='__svg_icons.tpl' icon="groups" class="main-icon" width="20px" height="20px"}
                        </div>
                        <div class="title">{__("Group")}</div>
                      </label>
                    {/if}
                    <!-- Group -->
                    <!-- Event -->
                    {if $system['events_enabled'] && $events}
                      <input class="x-hidden input-label" type="radio" name="publish_to" id="publish_to_event" value="event" {if $share_to == "event"}checked="checked" {/if} />
                      <label class="button-label" for="publish_to_event">
                        <div class="icon">
                          {include file='__svg_icons.tpl' icon="events" class="main-icon" width="20px" height="20px"}
                        </div>
                        <div class="title">{__("Event")}</div>
                      </label>
                    {/if}
                    <!-- Event -->
                  </div>
                  <!-- publish to options -->
                </div>
              </div>

              <div id="js_publish-to-page" {if $share_to != "page"}class="x-hidden" {/if}>
                <div class="row form-group">
                  <label class="col-md-2 form-label">
                    {__("Select Page")}
                  </label>
                  <div class="col-md-10">
                    <select class="form-select" name="page_id">
                      {foreach $pages as $page}
                        <option value="{$page['page_id']}" {if $share_to_page_id == $page['page_id']}selected{/if}>{$page['page_title']}</option>
                      {/foreach}
                    </select>
                  </div>
                </div>
              </div>

              <div id="js_publish-to-group" {if $share_to != "group"}class="x-hidden" {/if}>
                <div class="row form-group">
                  <label class="col-md-2 form-label">
                    {__("Select Group")}
                  </label>
                  <div class="col-md-10">
                    <select class="form-select" name="group_id">
                      {foreach $groups as $group}
                        <option value="{$group['group_id']}" {if $share_to_group_id == $group['group_id']}selected{/if}>{$group['group_title']}</option>
                      {/foreach}
                    </select>
                  </div>
                </div>
              </div>

              <div id="js_publish-to-event" {if $share_to != "event"}class="x-hidden" {/if}>
                <div class="row form-group">
                  <label class="col-md-2 form-label">
                    {__("Select Event")}
                  </label>
                  <div class="col-md-10">
                    <select class="form-select" name="event_id">
                      {foreach $events as $event}
                        <option value="{$event['event_id']}" {if $share_to_event_id == $event['event_id']}selected{/if}>{$event['event_title']}</option>
                      {/foreach}
                    </select>
                  </div>
                </div>
              </div>

              <div class="row form-group">
                <label class="col-md-2 form-label">
                  {__("Title")}
                </label>
                <div class="col-md-10">
                  <input class="form-control" name="title">
                </div>
              </div>

              <div class="row form-group">
                <label class="col-md-2 form-label">
                  {__("Content")}
                </label>
                <div class="col-md-10">
                  <textarea name="text" class="form-control js_wysiwyg"></textarea>
                </div>
              </div>

              <div class="row form-group">
                <label class="col-md-2 form-label">
                  {__("Cover")}
                </label>
                <div class="col-md-10">
                  <div class="x-image">
                    <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'>

                    </button>
                    <div class="x-image-loader">
                      <div class="progress x-progress">
                        <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                      </div>
                    </div>
                    <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                    <input type="hidden" class="js_x-image-input" name="cover">
                  </div>
                </div>
              </div>

              <div class="row form-group">
                <label class="col-md-2 form-label">
                  {__("Category")}
                </label>
                <div class="col-md-10">
                  <select class="form-select" name="category">
                    <option>{__("Select Category")}</option>
                    {foreach $blogs_categories as $category}
                      {include file='__categories.recursive_options.tpl'}
                    {/foreach}
                  </select>
                </div>
              </div>

              <div class="row form-group">
                <label class="col-md-2 form-label">
                  {__("Tags")}
                </label>
                <div class="col-md-10">
                  <input class="form-control js_tagify" name="tags">
                  <div class="form-text">
                    {__("Type a tag name and press Enter or Comma to add it")}
                  </div>
                </div>
              </div>

              {if $user->_data['can_receive_tip'] || $user->_data['can_monetize_content']}
                <div class="divider"></div>
              {/if}

              <!-- enable tips -->
              {if $user->_data['can_receive_tip']}
                <div id="js_tips-enabled">
                  <div {if $share_to == "page"}class="x-hidden" {/if}>
                    <div class="form-table-row mb10">
                      <div>
                        <div class="form-label mb0">{__("Enable Tips")}</div>
                        <div class="form-text d-none d-sm-block mt0">{__("Allow people to send you tips")}</div>
                      </div>
                      <div class="text-end">
                        <label class="switch" for="tips_enabled">
                          <input type="checkbox" name="tips_enabled" id="tips_enabled">
                          <span class="slider round"></span>
                        </label>
                      </div>
                    </div>
                  </div>
                </div>
              {/if}
              <!-- enable tips -->

              <!-- only for subscribers -->
              {if $user->_data['can_monetize_content']}
                <div class="form-table-row mb10" id="subscribers-toggle-wrapper">
                  <div>
                    <div class="form-label mb0">{__("Subscribers Only")}</div>
                    <div class="form-text d-none d-sm-block mt0">{__("Share this post to")} {__("subscribers only")}</div>
                  </div>
                  <div class="text-end">
                    <label class="switch" for="subscribers_only">
                      <input type="checkbox" name="subscribers_only" id="subscribers_only" class="js_publisher-subscribers-toggle">
                      <span class="slider round"></span>
                    </label>
                  </div>
                </div>
              {/if}
              <!-- only for subscribers -->

              <!-- paid post -->
              {if $user->_data['can_monetize_content'] && $user->_data['user_monetization_enabled']}
                <div class="form-table-row mb10" id="paid-toggle-wrapper">
                  <div>
                    <div class="form-label mb0">{__("Paid Post")}</div>
                    <div class="form-text d-none d-sm-block mt0">{__("Set a price to your post")}</div>
                  </div>
                  <div class="text-end">
                    <label class="switch" for="paid_post">
                      <input type="checkbox" name="paid_post" id="paid_post" class="js_publisher-paid-toggle">
                      <span class="slider round"></span>
                    </label>
                  </div>
                </div>
                <div class="form-group x-hidden" id="paid-price-wrapper">
                  <input type="text" class="form-control" name="paid_post_price" placeholder="{__("Price")} ({$system['system_currency']})">
                </div>
                <div class="form-group x-hidden" id="paid-text-wrapper">
                  <textarea class="form-control" name="paid_post_text" rows="3" placeholder="{__("Paid Post Description")}"></textarea>
                </div>
              {/if}
              <!-- paid post -->

              <!-- error -->
              <div class="alert alert-danger mt15 mb0 x-hidden"></div>
              <!-- error -->
            </div>
            <div class="card-footer text-end">
              <button type="submit" class="btn btn-primary">{__("Publish")}</button>
            </div>
          </div>
        </div>
        <!-- content -->
      </div>
      <!-- content panel -->

    {/if}
  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}

<script>
  /* share post */
  $('input[type=radio][name=publish_to]').on('change', function() {
    switch ($(this).val()) {
      case 'timeline':
        $('#js_publish-to-page').hide();
        $('#js_publish-to-group').hide();
        $('#js_publish-to-event').hide();
        $('#js_tips-enabled').fadeIn();
        $('#subscribers-toggle-wrapper').show();
        break;
      case 'page':
        $('#js_publish-to-page').fadeIn();
        $('#js_publish-to-group').hide();
        $('#js_publish-to-event').hide();
        $('#js_tips-enabled').hide();
        $('#subscribers-toggle-wrapper').show();
        break;
      case 'group':
        $('#js_publish-to-page').hide();
        $('#js_publish-to-group').fadeIn();
        $('#js_publish-to-event').hide();
        $('#js_tips-enabled').fadeIn();
        $('#subscribers-toggle-wrapper').show();
        break;
      case 'event':
        $('#js_publish-to-page').hide();
        $('#js_publish-to-group').hide();
        $('#js_publish-to-event').fadeIn();
        $('#js_tips-enabled').fadeIn();
        $('#subscribers-toggle-wrapper').hide();
        break;
    }
  });
</script>