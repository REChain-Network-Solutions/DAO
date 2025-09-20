{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- content panel -->
<div class="row x_content_row">
	<!-- center panel -->
	<div class="col-lg-8">
		{if $system['discover_posts_enabled'] || $system['popular_posts_enabled']}
			{if $page == "index" && ($view == "" || $view == "discover" || $view == "popular")}
			<div class="d-flex align-items-center justify-content-start position-sticky x_top_posts home">
				{if $system['discover_posts_enabled']}
					<div {if $page == "index" && $view == "discover"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/discover" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Discover Posts")}</span>
						</a>
					</div>
				{/if}
				{if $system['popular_posts_enabled']}
					<div {if $page == "index" && $view == "popular"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/popular" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Popular Posts")}</span>
						</a>
					</div>
				{/if}
				<div {if $page == "index" && $view == ""}class="active fw-semibold" {/if}>
					<a href="{$system['system_url']}" class="body-color side_item_hover w-100 text-center d-block">
						<span class="position-relative d-inline-block py-3">{__("Recent Updates")}</span>
					</a>
				</div>
            </div>
			{/if}
		{/if}
		
		<!-- announcments -->
			{include file='_announcements.tpl'}
		<!-- announcments -->
		
		{if $view == ""}

            {if $user->_logged_in}
				<!-- stories -->
				{if $user->_data['can_add_stories'] || ($system['stories_enabled'] && !empty($stories['array']))}
					<div class="bg-white x_announcement">
						<div class="stories-wrapper">
							<div id="stories" data-json='{htmlspecialchars($stories["json"], ENT_QUOTES, 'UTF-8')}'>
								{if $user->_data['can_add_stories']}
									<div class="add-story pointer" data-toggle="modal" data-url="posts/story.php?do=create" title='{__("Create Story")}'>
										<a class="position-relative">
											<img src="{$user->_data['user_picture']}">
											<span class="position-absolute rounded-circle d-flex"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="14" height="14" color="currentColor" fill="none"><path d="M12 4V20M20 12H4" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg></span>
										</a>
										<p class="text-truncate mb-0 text-center">{__("Create")}</p>
									</div>
								{/if}
								{if $has_story}
									<div class="add-story pointer js_story-deleter" title='{__("Delete Your Story")}'>
										<a class="position-relative">
											<img src="{$user->_data['user_picture']}">
											<span class="position-absolute rounded-circle d-flex bg-danger"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="14" height="14" color="currentColor" fill="none"><path d="M19.5 5.5L18.8803 15.5251C18.7219 18.0864 18.6428 19.3671 18.0008 20.2879C17.6833 20.7431 17.2747 21.1273 16.8007 21.416C15.8421 22 14.559 22 11.9927 22C9.42312 22 8.1383 22 7.17905 21.4149C6.7048 21.1257 6.296 20.7408 5.97868 20.2848C5.33688 19.3626 5.25945 18.0801 5.10461 15.5152L4.5 5.5" stroke="currentColor" stroke-width="3" stroke-linecap="round" /><path d="M3 5.5H21M16.0557 5.5L15.3731 4.09173C14.9196 3.15626 14.6928 2.68852 14.3017 2.39681C14.215 2.3321 14.1231 2.27454 14.027 2.2247C13.5939 2 13.0741 2 12.0345 2C10.9688 2 10.436 2 9.99568 2.23412C9.8981 2.28601 9.80498 2.3459 9.71729 2.41317C9.32164 2.7167 9.10063 3.20155 8.65861 4.17126L8.05292 5.5" stroke="currentColor" stroke-width="3" stroke-linecap="round" /><path d="M9.5 16.5L9.5 10.5" stroke="currentColor" stroke-width="3" stroke-linecap="round" /><path d="M14.5 16.5L14.5 10.5" stroke="currentColor" stroke-width="3" stroke-linecap="round" /></svg></span>
										</a>
										<p class="text-truncate mb-0 text-center">{__("Delete")}</p>
									</div>
								{/if}
							</div>
						</div>
					</div>
				{/if}
				<!-- stories -->
				
				{if $system['merits_enabled'] && $system['merits_widgets_newsfeed']}
					<!-- merits -->
					<div class="bg-white x_announcement">
						<h6 class="headline-font fw-semibold m-0 side_widget_title">{__("Merits")}</h6>
						<div class="overflow-hidden px-3 px-md-0">
							{if $merits_categories}
								<div class="row merits-box-wrapper">
									{foreach $merits_categories as $_category}
										<div class="col-6 col-md-3 text-center mb-3">
											<div class="merit-box mx-auto" data-toggle="modal" data-size="large" data-url="users/merits.php?do=publish&category_id={$_category['category_id']}">
												<img src="{$system['system_uploads']}/{$_category['category_image']}" width="64px" height="64px">
												<div class="name">{$_category['category_name']}</div>
											</div>
										</div>
									{/foreach}
								</div>
							{/if}
						</div>
					</div>
					<!-- merits -->
				{/if}
			  
				<!-- publisher -->
				{include file='_publisher.tpl' _handle="me" _node_can_monetize_content=$user->_data['can_monetize_content'] _node_monetization_enabled=$user->_data['user_monetization_enabled'] _node_monetization_plans=$user->_data['user_monetization_plans'] _privacy=true}
				<!-- publisher -->
			  
				<!-- pro users -->
				{if $pro_members}
					<div class="d-block d-lg-none">
						<div class="overflow-hidden content rounded-0 border-top-0 border-start-0 border-end-0">
							<h6 class="headline-font fw-semibold m-0 side_widget_title">
								{__("Pro Users")}
							</h6>
							<ul>
								{foreach $pro_members as $_user name=pro_loop}
									{if $smarty.foreach.pro_loop.iteration <= 3}
										{include file='__feeds_user.tpl' _tpl="list" _connection="add" _prusrs="pro"}
									{/if}
								{/foreach}
							</ul>
							{if $system['packages_enabled'] && !$user->_data['user_subscribed']}
								<a class="main px-3 d-block side_item_hover side_item_list" href="{$system['system_url']}/packages">
									{__("Upgrade")}
								</a>
							{/if}
						</div>
					</div>
				{/if}
				<!-- pro users -->

				<!-- pro pages -->
				{if $promoted_pages}
					<div class="d-block d-lg-none">
						<div class="overflow-hidden content rounded-0 border-top-0 border-start-0 border-end-0">
							<h6 class="headline-font fw-semibold m-0 side_widget_title">
								{__("Pro Pages")}
							</h6>
							<ul>
								{foreach $promoted_pages as $_page}
									{include file='__feeds_page.tpl' _tpl="list"}
								{/foreach}
							</ul>
							{if $system['packages_enabled'] && !$user->_data['user_subscribed']}
								<a class="main px-3 d-block side_item_hover side_item_list" href="{$system['system_url']}/packages">
									{__("Upgrade")}
								</a>
							{/if}
						</div>
					</div>
				{/if}
				<!-- pro pages -->
            {/if}
			
			{include file='_widget.tpl' widgets=$newsfeed_widgets}

            <!-- boosted post -->
            {if $boosted_post}
				{include file='_boosted_post.tpl' post=$boosted_post}
            {/if}
            <!-- boosted post -->

            <!-- posts -->
            {include file='_posts.tpl' _get="newsfeed"}
            <!-- posts -->

		{elseif $view == "popular"}
            <!-- popular posts -->
            {include file='_posts.tpl' _get="popular" _title=__("Popular Posts")}
            <!-- popular posts -->

		{elseif $view == "discover"}
            <!-- discover posts -->
            {include file='_posts.tpl' _get="discover" _title=__("Discover Posts")}
            <!-- discover posts -->

		{elseif $view == "saved"}
            <!-- saved posts -->
            {include file='_posts.tpl' _get="saved" _title=__("Saved Posts")}
            <!-- saved posts -->
			
		{elseif $view == "scheduled"}
			<!-- scheduled posts -->
            {include file='_posts.tpl' _get="scheduled" _title=__("Scheduled Posts")}
            <!-- scheduled posts -->

		{elseif $view == "memories"}
            <!-- memories posts -->
            {include file='_posts.tpl' _get="memories" _title=__("Memories") _filter="all"}
            <!-- memories posts -->

		{elseif $view == "blogs"}
            <!-- blogs posts -->
            {include file='_posts.tpl' _get="posts_profile" _id=$user->_data['user_id'] _filter="article" _title=__("My Blogs")}
            <!-- blogs posts -->

		{elseif $view == "products"}
            <!-- products posts -->
            {include file='_posts.tpl' _get="posts_profile" _id=$user->_data['user_id'] _filter="product" _title=__("My Products")}
            <!-- products posts -->

		{elseif $view == "funding"}
            <!-- funding posts -->
            {include file='_posts.tpl' _get="posts_profile" _id=$user->_data['user_id'] _filter="funding" _title=__("My Funding")}
            <!-- funding posts -->
		
		{elseif $view == "offers"}
            <!-- funding posts -->
            {include file='_posts.tpl' _get="posts_profile" _id=$user->_data['user_id'] _filter="offer" _title=__("My Offers")}
            <!-- funding posts -->

		{elseif $view == "jobs"}
            <!-- jobs posts -->
            {include file='_posts.tpl' _get="posts_profile" _id=$user->_data['user_id'] _filter="job" _title=__("My Jobs")}
            <!-- jobs posts -->

		{elseif $view == "courses"}
            <!-- courses posts -->
            {include file='_posts.tpl' _get="posts_profile" _id=$user->_data['user_id'] _filter="course" _title=__("My Courses")}
            <!-- courses posts -->

		{elseif $view == "boosted_posts"}
			<div class="position-sticky x_top_posts">
				<div class="headline-font fw-semibold side_widget_title p-3">
					{__("Boosted")}
				</div>
			
				<div class="d-flex align-items-center justify-content-center">
					<div class="active fw-semibold">
						<a href="{$system['system_url']}/boosted/posts" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Boosted Posts")}</span>
						</a>
					</div>
					{if $system['pages_enabled']}
						<div>
							<a href="{$system['system_url']}/boosted/pages" class="body-color side_item_hover w-100 text-center d-block">
								<span class="position-relative d-inline-block py-3">{__("Boosted Pages")}</span>
							</a>
						</div>
					{/if}
				</div>
            </div>
            {if $user->_is_admin || $user->_data['user_subscribed']}
				<!-- boosted posts -->
				{include file='_posts.tpl' _get="boosted" _title=__("My Boosted Posts")}
				<!-- boosted posts -->
            {else}
				<!-- upgrade -->
				<div class="p-3">
					<div class="text-muted text-center py-5">
						<svg width="56" height="56" class="text-warning" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M13.6076 1.14723C14.3143 1.44842 14.7969 2.16259 14.7969 3.01681L14.7976 9.78474C14.7976 9.89519 14.8871 9.98472 14.9976 9.98472H18.0993C18.9851 9.98472 19.5954 10.5826 19.8466 11.2101C20.0974 11.8369 20.0636 12.642 19.5628 13.2849L12.5645 22.2678C12.0032 22.9883 11.1205 23.1629 10.3917 22.8523C9.68508 22.5511 9.20248 21.8369 9.20248 20.9827L9.20181 14.2148C9.2018 14.1043 9.11226 14.0148 9.00181 14.0148H5.90003C5.01422 14.0148 4.40394 13.4169 4.1528 12.7894C3.90193 12.1626 3.93574 11.3575 4.43658 10.7146L11.4348 1.73169C11.9962 1.01115 12.8788 0.83658 13.6076 1.14723Z" fill="currentColor"/></svg>
						<div class="text-md mt-4">
							<h5 class="headline-font m-0">
								{__("Membership")}
							</h5>
						</div>
						<div class="post-paid-description mt-2">
							{__("Choose the Plan That's Right for You")}, {__("Check the package from")} <a href="{$system['system_url']}/packages">{__("Here")}</a>
						</div>
						
						<div class="mt-3">
							<a class="btn btn-main text-no-underline" href="{$system['system_url']}/packages">
								{__("Upgrade to Pro")}
							</a>
						</div>
					</div>
				</div>
				<!-- upgrade -->
            {/if}

		{elseif $view == "boosted_pages"}
			<div class="position-sticky x_top_posts">
				<div class="headline-font fw-semibold side_widget_title p-3">
					{__("Boosted")}
				</div>
				<div class="d-flex align-items-center justify-content-center">
					<div>
						<a href="{$system['system_url']}/boosted/posts" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Boosted Posts")}</span>
						</a>
					</div>
					<div class="active fw-semibold">
						<a href="{$system['system_url']}/boosted/pages" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Boosted Pages")}</span>
						</a>
					</div>
				</div>
            </div>
            {if $user->_is_admin || $user->_data['user_subscribed']}
				{if $boosted_pages}
                    <ul>
						{foreach $boosted_pages as $_page}
							{include file='__feeds_page.tpl' _tpl="list"}
						{/foreach}
                    </ul>

                    {if count($boosted_pages) >= $system['max_results_even']}
						<!-- see-more -->
						<div class="alert alert-info see-more js_see-more" data-get="boosted_pages">
							<span>{__("See More")}</span>
							<div class="loader loader_small x-hidden"></div>
						</div>
						<!-- see-more -->
                    {/if}
				{else}
					{include file='_no_data.tpl'}
				{/if}
            {else}
				<!-- upgrade -->
				<div class="p-3">
					<div class="text-muted text-center py-5">
						<svg width="56" height="56" class="text-warning" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M13.6076 1.14723C14.3143 1.44842 14.7969 2.16259 14.7969 3.01681L14.7976 9.78474C14.7976 9.89519 14.8871 9.98472 14.9976 9.98472H18.0993C18.9851 9.98472 19.5954 10.5826 19.8466 11.2101C20.0974 11.8369 20.0636 12.642 19.5628 13.2849L12.5645 22.2678C12.0032 22.9883 11.1205 23.1629 10.3917 22.8523C9.68508 22.5511 9.20248 21.8369 9.20248 20.9827L9.20181 14.2148C9.2018 14.1043 9.11226 14.0148 9.00181 14.0148H5.90003C5.01422 14.0148 4.40394 13.4169 4.1528 12.7894C3.90193 12.1626 3.93574 11.3575 4.43658 10.7146L11.4348 1.73169C11.9962 1.01115 12.8788 0.83658 13.6076 1.14723Z" fill="currentColor"/></svg>
						<div class="text-md mt-4">
							<h5 class="headline-font m-0">
								{__("Membership")}
							</h5>
						</div>
						<div class="post-paid-description mt-2">
							{__("Choose the Plan That's Right for You")}, {__("Check the package from")} <a href="{$system['system_url']}/packages">{__("Here")}</a>
						</div>
						
						<div class="mt-3">
							<a class="btn btn-main text-no-underline" href="{$system['system_url']}/packages">
								{__("Upgrade to Pro")}
							</a>
						</div>
					</div>
				</div>
				<!-- upgrade -->
            {/if}

		{elseif $view == "watch"}
            <!-- videos posts -->
				{include file='_posts.tpl' _get="discover" _filter="video" _load_more="watch" _title=__("Watch")}
            <!-- videos posts -->
		{/if}
	</div>
	<!-- center panel -->
	
	<!-- right panel -->
	<div class="col-lg-4 js_sticky-sidebar">
		<!-- upgrade to pro -->	
		{if $system['packages_enabled'] && !$user->_data['user_subscribed']}
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Upgrade to Pro")}
				</h6>
				<div class="px-3 py-0 side_item_list">
					{__("Choose the Plan That's Right for You")}
				</div>
				<div class="px-3 side_item_list">
					<a class="btn btn-main" href="{$system['system_url']}/packages">
						{__("Upgrade")}
					</a>
				</div>
			</div>
		{/if}
		<!-- upgrade to pro -->
		
		{if $system['merits_enabled'] && $system['merits_widgets_balance']}
            <!-- merits -->
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Merits")}
				</h6>
				<div class="px-3 py-0 side_item_list">
					{__("You have")} <span class="main fw-semibold">{$user->_data['merits_balance']['remining']}</span> {__("merits left")}
				</div>
				<div class="px-3 side_item_list">
					<button class="btn btn-main" data-toggle="modal" data-size="large" data-url="users/merits.php?do=publish">
						{__("Send Merit")}
					</button>
				</div>
			</div>
            <!-- merits -->
		{/if}

		<!-- pro users -->
		{if $pro_members}
			<div class="d-none d-lg-block">
				<div class="mb-3 overflow-hidden content">
					<h6 class="headline-font fw-semibold m-0 side_widget_title">
						{__("Pro Users")}
					</h6>
					<ul>
						{foreach $pro_members as $_user name=pro_loop}
							{if $smarty.foreach.pro_loop.iteration <= 5}
								{include file='__feeds_user.tpl' _tpl="list" _connection="add" _prusrs="pro"}
							{/if}
						{/foreach}
					</ul>
					{if $system['packages_enabled'] && !$user->_data['user_subscribed']}
						<a class="main px-3 d-block side_item_hover side_item_list" href="{$system['system_url']}/packages">
							{__("Upgrade")}
						</a>
					{/if}
				</div>
            </div>
		{/if}
		<!-- pro users -->

		<!-- pro pages -->
		{if $promoted_pages}
            <div class="d-none d-lg-block">
				<div class="mb-3 overflow-hidden content">
					<h6 class="headline-font fw-semibold m-0 side_widget_title">
						{__("Pro Pages")}
					</h6>
					<ul>
						{foreach $promoted_pages as $_page}
							{include file='__feeds_page.tpl' _tpl="list"}
						{/foreach}
					</ul>
					{if $system['packages_enabled'] && !$user->_data['user_subscribed']}
						<a class="main px-3 d-block side_item_hover side_item_list" href="{$system['system_url']}/packages">
							{__("Upgrade")}
						</a>
					{/if}
				</div>
            </div>
		{/if}
		<!-- pro pages -->

		<!-- trending -->
		{if $trending_hashtags}
            {include file='_trending_widget.tpl'}
		{/if}
		<!-- trending -->

		{include file='_ads.tpl'}
		{include file='_ads_campaigns.tpl'}
		{include file='_widget.tpl'}
		
		{if $top_merits_users}
            <!-- merits top users -->
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Merits Top Users")}
				</h6>
				<ul>
					{foreach $top_merits_users as $top_user}
						{include file='__feeds_user.tpl' _tpl="list" _user=$top_user['top_user'] _merit_category=$top_user['category'] _merits_count= $top_user['top_user']['count']}
					{/foreach}
				</ul>
				<a class="main px-3 d-block side_item_hover side_item_list" href="{$system['system_url']}/merits">
					{__("See All")}
				</a>
			</div>
            <!-- merits top users -->
		{/if}
		
		<!-- friends suggestions -->
		{if $new_people}
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{if $system['friends_enabled']}
						{__("Suggested Friends")}
					{else}
						{__("Suggested People")}
					{/if}
				</h6>
				<ul>
					{foreach $new_people as $_user}
						{include file='__feeds_user.tpl' _tpl="list" _connection="add"}
					{/foreach}
				</ul>
				<a class="main px-3 d-block side_item_hover side_item_list" href="{$system['system_url']}/people">
					{__("See All")}
				</a>
			</div>
		{/if}
		<!-- friends suggestions -->

		<!-- suggested pages -->
		{if $new_pages}
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Suggested Pages")}
				</h6>
				<ul>
					{foreach $new_pages as $_page}
						{include file='__feeds_page.tpl' _tpl="list"}
					{/foreach}
				</ul>
				<a class="main px-3 d-block side_item_hover side_item_list" href="{$system['system_url']}/pages">
					{__("See All")}
				</a>
			</div>
		{/if}
		<!-- suggested pages -->

		<!-- suggested groups -->
		{if $new_groups}
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Suggested Groups")}
				</h6>
				<ul>
					{foreach $new_groups as $_group}
						{include file='__feeds_group.tpl' _tpl="list"}
					{/foreach}
				</ul>
				<a class="main px-3 d-block side_item_hover side_item_list" href="{$system['system_url']}/groups">
					{__("See All")}
				</a>
			</div>
		{/if}
		<!-- suggested groups -->

		<!-- suggested events -->
		{if $new_events}
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Suggested Events")}
				</h6>
				<ul>
					{foreach $new_events as $_event}
						{include file='__feeds_event.tpl' _tpl="list" _small=true}
					{/foreach}
				</ul>
				<a class="main px-3 d-block side_item_hover side_item_list" href="{$system['system_url']}/events">
					{__("See All")}
				</a>
			</div>
		{/if}
		<!-- suggested events -->

		<!-- mini footer -->
		{include file='_footer_mini.tpl'}
		<!-- mini footer -->
	</div>
	<!-- right panel -->
</div>
<!-- content panel -->

{include file='_footer.tpl'}