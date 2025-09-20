{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="row x_content_row">
	{if $view == "game"}
		<style>
		.search-wrapper-prnt {
		display: none !important
		}
		
		@media (max-width: 520px) {
			.main-wrapper {
				padding: 50px 0;
			}
			.x_side_create {
				display: none;
			}
		}
		</style>

		<!-- center panel -->
		<div class="col-lg-12 w-100">
			<div class="d-flex flex-column h-100">
				<div class="d-flex align-items-center px-3 py-2 position-sticky flex-0 x_top_posts">
					<div class="d-flex align-items-center gap-3 position-relative mw-0">
						<a href="{$system['system_url']}/games" class="btn border-0 p-0 rounded-circle lh-1 flex-0">
							<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8.99996 16.9998L4 11.9997L9 6.99976" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/><path d="M4 12H20" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/></svg>
						</a>
						<span class="headline-font fw-semibold side_widget_title p-0 flex-1 text-truncate mw-0 d-flex align-items-center gap-2">
							<img src="{$game['thumbnail']}" height="36" width="36" class="rounded-2 object-cover">
							<span class="mw-0 text-truncate">{$game['title']}</span>
						</span>
					</div>
				</div>
			
				<div class="flex-1 mh-0 bg-black d-flex align-items-center justify-content-center">
					<div class="ratio ratio-16x9">
						<iframe frameborder="0" src="{$game['source']}"></iframe>
					</div>
				</div>
			</div>
		</div>
		<!-- content panel -->

	{else}
		<!-- center panel -->
		<div class="col-lg-8">
			<div class="position-sticky x_top_posts">
				<div class="headline-font fw-semibold side_widget_title p-3">
					{__("Games")}
				</div>
				
				<div class="d-flex align-items-center justify-content-center">
					<div {if $view == "" || $view == "genre"}class="active fw-semibold"{/if}>
						<a href="{$system['system_url']}/games" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Discover")}</span>
						</a>
					</div>
					{if $user->_logged_in}
						<div {if $view != "" && $view != "genre"}class="active fw-semibold" {/if}>
							<a href="{$system['system_url']}/games/played" class="body-color side_item_hover w-100 text-center d-block">
								<span class="position-relative d-inline-block py-3">{__("Your Games")}</span>
							</a>
						</div>
					{/if}
				</div>
			</div>

			{if $view == "" || $view == "genre"}
				<!-- genres -->
				<div class="pt-3">
					<div class="overflow-hidden x_page_cats x_page_scroll d-flex align-items-start position-relative">
						<ul class="px-3 d-flex gap-2 align-items-center overflow-x-auto pb-3 scrolll">
							{if $view == "genre"}
								<li>
									<a class="btn btn-sm border-0 ps-0 pe-1" href="{$system['system_url']}/games">
										<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8.99996 16.9998L4 11.9997L9 6.99976" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/><path d="M4 12H20" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/></svg>
										{__("All")}
									</a>
								</li>
							{/if}
							{foreach $genres as $_genre}
								<li {if $view == "genre" && $genre['genre_id'] == $_genre['genre_id']}class="position-relative main main_bg_half" {/if}>
									<a class="btn btn-sm" href="{$system['system_url']}/games/genre/{$_genre['genre_id']}/{$_genre['genre_url']}">
										{__($_genre['genre_name'])}
									</a>
								</li>
							{/foreach}
						</ul>
						<div class="d-flex align-items-center justify-content-between position-absolute w-100 h-100 pe-none scroll-btns">
							<div class="pe-auto">
								<button class="btn rounded-circle p-1 bg-black text-white mx-2 scroll-left-btn">
									<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M15 6L9 12.0001L15 18" stroke="currentColor" stroke-width="2" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
								</button>
							</div>
							<div class="pe-auto">
								<button class="btn rounded-circle p-1 bg-black text-white mx-2 scroll-right-btn">
									<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M9.00005 6L15 12L9 18" stroke="currentColor" stroke-width="2" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
								</button>
							</div>
						</div>
					</div>
				</div>
				<!-- genres -->
			{/if}

			<!-- content -->
			<div class="p-3">
				{if $games}
					<ul class="row">
						{foreach $games as $_game}
							{include file='__feeds_game.tpl' _tpl='box'}
						{/foreach}
					</ul>

					<!-- see-more -->
					{if count($games) >= $system['games_results']}
						<div class="alert alert-post see-more js_see-more" data-get="{$get}" {if $view == "genre"}data-id="{$genre['genre_id']}" {/if} {if $view == "played"}data-uid="{$user->_data['user_id']}" {/if}>
							<span>{__("See More")}</span>
							<div class="loader loader_small x-hidden"></div>
						</div>
					{/if}
					<!-- see-more -->
				{else}
					{include file='_no_data.tpl'}
				{/if}
			</div>
			<!-- content -->
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
	{/if}
</div>
<!-- page content -->

{include file='_footer.tpl'}