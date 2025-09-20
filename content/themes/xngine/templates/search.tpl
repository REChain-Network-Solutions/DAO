{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="row x_content_row">
	<!-- left panel -->
	<div class="col-lg-8">
		<div class="position-sticky x_top_posts">
			<div class="headline-font fw-semibold side_widget_title p-3">
				{__("Search")}
			</div>
			
			{if $query}
				<div class="d-flex align-items-center justify-content-center">
					<div {if $tab == "" || $tab == "posts"}class="active fw-semibold"{/if}>
						<a href="{$system['system_url']}/search/{if $hashtag}hashtag/{/if}{if $query}{$query}/posts{/if}" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Posts")}</span>
						</a>
					</div>
					{if $system['blogs_enabled']}
						<div {if $tab == "blogs"}class="active fw-semibold" {/if}>
							<a href="{$system['system_url']}/search/{if $hashtag}hashtag/{/if}{if $query}{$query}/blogs{/if}" class="body-color side_item_hover w-100 text-center d-block">
								<span class="position-relative d-inline-block py-3">{__("Blogs")}</span>
							</a>
						</div>
					{/if}
					<div {if $tab == "users"}class="active fw-semibold"{/if}>
						<a href="{$system['system_url']}/search/{if $query}{$query}/users{/if}" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Users")}</span>
						</a>
					</div>
					{if $system['pages_enabled']}
						<div {if $tab == "pages"}class="active fw-semibold" {/if}>
							<a href="{$system['system_url']}/search/{if $query}{$query}/pages{/if}" class="body-color side_item_hover w-100 text-center d-block">
								<span class="position-relative d-inline-block py-3">{__("Pages")}</span>
							</a>
						</div>
					{/if}
					{if $system['groups_enabled']}
						<div {if $tab == "groups"}class="active fw-semibold" {/if}>
							<a href="{$system['system_url']}/search/{if $query}{$query}/groups{/if}" class="body-color side_item_hover w-100 text-center d-block">
								<span class="position-relative d-inline-block py-3">{__("Groups")}</span>
							</a>
						</div>
					{/if}
					{if $system['events_enabled']}
						<div {if $tab == "events"}class="active fw-semibold" {/if}>
							<a href="{$system['system_url']}/search/{if $query}{$query}/events{/if}" class="body-color side_item_hover w-100 text-center d-block">
								<span class="position-relative d-inline-block py-3">{__("Events")}</span>
							</a>
						</div>
					{/if}
				</div>
			{/if}
		</div>
		
		<div class="pt-3 pb-2 px-2 mx-1">
			<form class="js_search-form" {if $tab} data-filter="{$tab}" {/if}>
				<div class="position-relative">
					<input type="search" class="form-control shadow-none rounded-pill x_search_filter" name="query" placeholder='{__("Search")}' {if $query} value="{$query}" {/if}>
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"></path></svg>
				</div>
			</form>
		</div>

		{if $results}
			<ul>
				{if $tab == "" || $tab == "posts"}
					<!-- posts -->
					{foreach $results as $post}
						{include file='__feeds_post.tpl'}
					{/foreach}
					<!-- posts -->
				{elseif $tab == "blogs"}
					<!-- blogs -->
					{foreach $results as $post}
						{include file='__feeds_post.tpl'}
					{/foreach}
					<!-- blogs -->
				{elseif $tab == "users"}
					<!-- users -->
					{foreach $results as $_user}
						{include file='__feeds_user.tpl' _tpl="list" _connection=$_user['connection']}
					{/foreach}
					<!-- users -->
				{elseif $tab == "pages"}
					<!-- pages -->
					{foreach $results as $_page}
						{include file='__feeds_page.tpl' _tpl="list"}
					{/foreach}
					<!-- pages -->
				{elseif $tab == "groups"}
					<!-- groups -->
					{foreach $results as $_group}
						{include file='__feeds_group.tpl' _tpl="list"}
					{/foreach}
					<!-- groups -->
				{elseif $tab == "events"}
					<!-- events -->
					{foreach $results as $_event}
						{include file='__feeds_event.tpl' _tpl="list"}
					{/foreach}
					<!-- events -->
				{/if}
			</ul>

			{if count($results) >= $system['search_results']}
				<!-- see-more -->
				<div class="alert alert-post see-more mb20 js_see-more js_see-more-infinite" data-get="search_{$tab}" data-filter="{$query}">
					<span>{__("More Results")}</span>
					<div class="loader loader_small x-hidden"></div>
				</div>
				<!-- see-more -->
			{/if}
		{else}
			{include file='_no_data.tpl'}
		{/if}
	</div>
	<!-- left panel -->

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
		
		<!-- trending -->
		{if $trending_hashtags}
            {include file='_trending_widget.tpl'}
		{/if}
		<!-- trending -->

		{include file='_ads.tpl'}
		{include file='_ads_campaigns.tpl'}
		{include file='_widget.tpl'}
		
		<!-- mini footer -->
		{include file='_footer_mini.tpl'}
		<!-- mini footer -->
	</div>
	<!-- right panel -->

</div>
<!-- page content -->

{include file='_footer.tpl'}