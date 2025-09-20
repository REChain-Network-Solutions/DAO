{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="row x_content_row">
	<div class="col-lg-8">
		<div class="position-sticky x_top_posts">
			<div class="headline-font fw-semibold side_widget_title px-3 py-2 d-flex align-items-center justify-content-between">
				{__("Events")}
				<span class="flex-0 d-flex align-items-center gap-2">
					<button type="button" class="btn btn-gray border-0 p-2 rounded-circle lh-1 flex-0" data-bs-toggle="modal" data-bs-target="#filter_modal">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3 7H6" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M3 17H9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M18 17L21 17" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M15 7L21 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M6 7C6 6.06812 6 5.60218 6.15224 5.23463C6.35523 4.74458 6.74458 4.35523 7.23463 4.15224C7.60218 4 8.06812 4 9 4C9.93188 4 10.3978 4 10.7654 4.15224C11.2554 4.35523 11.6448 4.74458 11.8478 5.23463C12 5.60218 12 6.06812 12 7C12 7.93188 12 8.39782 11.8478 8.76537C11.6448 9.25542 11.2554 9.64477 10.7654 9.84776C10.3978 10 9.93188 10 9 10C8.06812 10 7.60218 10 7.23463 9.84776C6.74458 9.64477 6.35523 9.25542 6.15224 8.76537C6 8.39782 6 7.93188 6 7Z" stroke="currentColor" stroke-width="1.75"></path><path d="M12 17C12 16.0681 12 15.6022 12.1522 15.2346C12.3552 14.7446 12.7446 14.3552 13.2346 14.1522C13.6022 14 14.0681 14 15 14C15.9319 14 16.3978 14 16.7654 14.1522C17.2554 14.3552 17.6448 14.7446 17.8478 15.2346C18 15.6022 18 16.0681 18 17C18 17.9319 18 18.3978 17.8478 18.7654C17.6448 19.2554 17.2554 19.6448 16.7654 19.8478C16.3978 20 15.9319 20 15 20C14.0681 20 13.6022 20 13.2346 19.8478C12.7446 19.6448 12.3552 19.2554 12.1522 18.7654C12 18.3978 12 17.9319 12 17Z" stroke="currentColor" stroke-width="1.75"></path></svg>
					</button>
					{if $system['events_enabled']}
						<button class="btn btn-sm btn-primary flex-0 d-none d-md-flex" data-toggle="modal" data-url="modules/add.php?type=event">
							<span class="my2">{__("Create Event")}</span>
						</button>
						<button class="btn btn-primary flex-0 p-2 rounded-circle lh-1 d-md-none" data-toggle="modal" data-url="modules/add.php?type=event">
							<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 3C12.5523 3 13 3.44772 13 4V11H20C20.5523 11 21 11.4477 21 12C21 12.5523 20.5523 13 20 13H13V20C13 20.5523 12.5523 21 12 21C11.4477 21 11 20.5523 11 20V13H4C3.44772 13 3 12.5523 3 12C3 11.4477 3.44772 11 4 11H11V4C11 3.44772 11.4477 3 12 3Z" fill="currentColor"/></svg>
						</button>
					{/if}
				</span>
			</div>
			
			<div class="d-flex align-items-center justify-content-center">
				<div {if $view == "" || $view == "category"}class="active fw-semibold" {/if}>
					<a href="{$system['system_url']}/events" class="body-color side_item_hover w-100 text-center d-block">
						<span class="position-relative d-inline-block py-3">{__("Discover")}</span>
					</a>
				</div>
				{if $user->_logged_in}
					<div {if $view == "going"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/events/going" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Going")}</span>
						</a>
					</div>
					<div {if $view == "interested"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/events/interested" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Interested")}</span>
						</a>
					</div>
					<div {if $view == "invited"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/events/invited" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Invited")}</span>
						</a>
					</div>
					<div {if $view == "manage"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/events/manage" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("My Events")}</span>
						</a>
					</div>
				{/if}
			</div>
		</div>
		
		<div class="pt-3 pb-2 px-2 mx-1">
			<form class="js_search-form" data-filter="events">
				<div class="position-relative">
					<input type="search" class="form-control shadow-none rounded-pill x_search_filter" name="query" placeholder='{__("Search for events")}'>
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"></path></svg>
				</div>
			</form>
		</div>
		
		{if $view == "" || $view == "category"}
			<!-- categories -->
			<div class="pb-2 pt-2">
				<div class="overflow-hidden x_page_cats x_page_scroll d-flex align-items-start position-relative">
					<ul class="px-3 d-flex gap-2 align-items-center overflow-x-auto pb-3 scrolll">
						{if $view != "category"}
						{else}
							{if $current_category['parent']}
								<li>
									<a class="btn btn-sm border-0 ps-0 pe-1" href="{$system['system_url']}/events/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
										<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8.99996 16.9998L4 11.9997L9 6.99976" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/><path d="M4 12H20" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/></svg> {__($current_category['parent']['category_name'])}
									</a>
								</li>
								<li>
									<a class="btn btn-sm main position-relative main_bg_half">
										{__($current_category['category_name'])}
									</a>
								</li>
							{else}
								<li>
									<a class="btn btn-sm border-0 ps-0 pe-1" href="{$system['system_url']}/events">
										<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8.99996 16.9998L4 11.9997L9 6.99976" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/><path d="M4 12H20" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/></svg>
										{__("All")}
									</a>
								</li>
								{if $current_category['sub_categories']}
									<li>
										<a class="btn btn-sm position-relative main main_bg_half">
											{__($current_category['category_name'])}
										</a>
									</li>
								{/if}
							{/if}
						{/if}
						{foreach $categories as $category}
							<li {if $view == "category" && $current_category['category_id'] == $category['category_id']}class="position-relative main main_bg_half" {/if}>
								<a class="btn btn-sm" href="{$system['system_url']}/events/category/{$category['category_id']}/{$category['category_url']}">
									{__($category['category_name'])}
									{if $category['sub_categories']}
										<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="d-none"><path d="M12 4V20M20 12H4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/></svg>
									{/if}
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
			<!-- categories -->
		{/if}
		
		<!-- content -->
		<div class="p-3 pt-2">
			{if $events}
				<ul class="row">
					{foreach $events as $_event}
						{include file='__feeds_event.tpl' _tpl='box'}
					{/foreach}
				</ul>

				<!-- see-more -->
				{if count($events) >= $system['events_results']}
					<div class="alert alert-post see-more js_see-more" data-get="{$get}" {if $view == "category"}data-id="{$current_category['category_id']}" {/if} {if $view == "going" || $view == "interested" || $view == "invited" || $view == "manage"}data-uid="{$user->_data['user_id']}" {/if} data-country="{if $selected_country}{$selected_country['country_id']}{else}all{/if}">
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

<!-- location filter -->
<div class="modal fade" id="filter_modal" tabindex="-1">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">{__("Filter")}</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
	  
			<div class="modal-body">
				{if $system['newsfeed_location_filter_enabled']}
					<div class="dropdown mb-3">
						<div class="form-label fw-medium d-flex align-items-center gap-1 small p-3 border rounded-4 bg-white m-0" type="button" data-bs-toggle="dropdown">
							<svg width="14" height="14" class="flex-0" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M9.67752 20.4855C10.4174 20.6875 11.1961 20.7953 12 20.7953C12.6913 20.7953 13.3639 20.7156 14.0093 20.5648C14.3307 19.9605 14.4776 19.4829 14.5303 19.102C14.6018 18.5855 14.5081 18.1915 14.3586 17.8254C14.2834 17.6415 14.1803 17.4375 14.082 17.2433C13.9831 17.0477 13.8667 16.8162 13.7803 16.5734C13.5893 16.0372 13.5394 15.4284 13.8976 14.7419C14.1585 14.2419 14.5367 13.9512 14.9899 13.8083C15.3375 13.6987 15.8203 13.6782 16.1267 13.6653C16.8013 13.6345 17.5354 13.5789 18.4363 12.9314C19.2407 12.3532 20.0495 12.1908 20.7915 12.2677C20.7941 12.1788 20.7955 12.0895 20.7955 11.9999C20.7955 9.99664 20.1258 8.14982 18.998 6.67109C18.4992 6.85577 18.0138 7.16643 17.6315 7.66136C16.8187 8.71334 15.9471 9.36049 15.063 9.62066C14.1618 9.88583 13.3114 9.72806 12.6319 9.28831C11.6258 8.63716 11.4958 7.7271 11.4107 7.13117C11.3644 6.81979 11.3081 6.5283 11.2244 6.37345C11.1546 6.24443 11.0279 6.08994 10.7127 5.93693C9.92015 5.55225 9.471 4.84875 9.31521 4.09083C9.28482 3.94302 9.26529 3.7926 9.25612 3.64087C6.05016 4.6926 3.65688 7.5373 3.26198 10.9893C3.80225 11.3049 4.42081 11.518 5.08874 11.518C5.75485 11.518 6.32888 11.5491 6.81102 11.6394C7.29426 11.73 7.73816 11.8892 8.09861 12.1844C8.84883 12.7987 8.95837 13.7612 8.95837 14.7516C8.95837 15.7705 8.9604 16.1995 9.01512 16.5654C9.06753 16.916 9.16946 17.2163 9.43644 17.9815C9.59057 18.4233 9.80455 19.0503 9.79233 19.7264C9.78777 19.9791 9.75206 20.2335 9.67752 20.4855ZM1.25115 11.8409C1.25038 11.8938 1.25 11.9468 1.25 11.9999C1.25 17.9369 6.06294 22.7499 12 22.7499C12.7905 22.7499 13.561 22.6646 14.3029 22.5026L14.3214 22.4988C18.665 21.5427 22.0226 17.962 22.6466 13.5021C22.6481 13.491 22.6494 13.4799 22.6505 13.4688C22.7161 12.9886 22.75 12.4982 22.75 11.9999C22.75 6.06282 17.9371 1.24988 12 1.24988H11.9999C11.9548 1.24988 11.9099 1.25016 11.8649 1.25071C6.04305 1.3224 1.33552 6.02206 1.25115 11.8409Z" fill="currentColor"/></svg>
							{if $selected_country}{$selected_country['country_name']}{else}{__("All Countries")}{/if}
						</div>
						<div class="dropdown-menu w-100 countries-dropdown">
							<div class="js_scroller">
								<a class="dropdown-item" href="?country=all{if $selected_type}&type={$selected_type}{/if}{if $selected_language}&language={$selected_language['code']}{/if}">
									{__("All Countries")}
								</a>
								{foreach $countries as $country}
									<a class="dropdown-item" href="?country={$country['country_name_native']}{if $selected_type}&type={$selected_type}{/if}{if $selected_language}&language={$selected_language['code']}{/if}">
										{$country['country_name']}
									</a>
								{/foreach}
							</div>
						</div>
					</div>
				{/if}
				
				<!-- language filter -->
				<div class="dropdown mb-3">
					<div class="form-label fw-medium d-flex align-items-center gap-1 small p-3 border rounded-4 bg-white m-0" type="button" data-bs-toggle="dropdown">
						<svg xmlns="http://www.w3.org/2000/svg" height="14" viewBox="0 -960 960 960" width="14" class="flex-0" fill="currentColor"><path d="m603-202-34 97q-4 11-14 18t-22 7q-20 0-32.5-16.5T496-133l152-402q5-11 15-18t22-7h30q12 0 22 7t15 18l152 403q8 19-4 35.5T868-80q-13 0-22.5-7T831-106l-34-96H603ZM362-401 188-228q-11 11-27.5 11.5T132-228q-11-11-11-28t11-28l174-174q-35-35-63.5-80T190-640h84q20 39 40 68t48 58q33-33 68.5-92.5T484-720H80q-17 0-28.5-11.5T40-760q0-17 11.5-28.5T80-800h240v-40q0-17 11.5-28.5T360-880q17 0 28.5 11.5T400-840v40h240q17 0 28.5 11.5T680-760q0 17-11.5 28.5T640-720h-76q-21 72-63 148t-83 116l96 98-30 82-122-125Zm266 129h144l-72-204-72 204Z"/></svg>
						{if $selected_language}{$selected_language['title']}{else}{__("All Languages")}{/if}
					</div>
					<div class="dropdown-menu w-100 countries-dropdown">
						<div class="js_scroller">
							<a class="dropdown-item" href="?language=all{if $selected_type}&type={$selected_type}{/if}{if $selected_country}&country={$selected_country['country_name']}{/if}">
								{__("All Languages")}
							</a>
							{foreach $languages as $language}
								<a class="dropdown-item" href="?language={$language['code']}{if $selected_type}&type={$selected_type}{/if}{if $selected_country}&country={$selected_country['country_name']}{/if}">
									{$language['title']}
								</a>
							{/foreach}
						</div>
					</div>
				</div>
				<!-- language filter -->
				
				<!-- type filter (in person or online) -->
				<div class="dropdown">
					<div class="form-label fw-medium d-flex align-items-center gap-1 small p-3 border rounded-4 bg-white m-0" type="button" data-bs-toggle="dropdown">
						<svg xmlns="http://www.w3.org/2000/svg" height="14" viewBox="0 -960 960 960" width="14" class="flex-0" fill="currentColor"><path d="M480-219q-12 0-24-4t-22-12q-118-94-176-183.5T200-594q0-125 78-205.5T480-880q124 0 202 80.5T760-594q0 86-58 175.5T526-235q-10 8-22 12t-24 4Zm0-301q33 0 56.5-23.5T560-600q0-33-23.5-56.5T480-680q-33 0-56.5 23.5T400-600q0 33 23.5 56.5T480-520ZM240-80q-17 0-28.5-11.5T200-120q0-17 11.5-28.5T240-160h480q17 0 28.5 11.5T760-120q0 17-11.5 28.5T720-80H240Z"/></svg>
						{if $selected_type}{if $selected_type == "all"}{__("All Types")}{/if}{if $selected_type == "in_person"}{__("In Person")}{/if}{if $selected_type == "online"}{__("Online")}{/if}{else}{__("All Types")}{/if}
					</div>
					<div class="dropdown-menu w-100 countries-dropdown">
						<a class="dropdown-item" href="?type=all{if $selected_country}&country={$selected_country['country_name']}{/if}{if $selected_language}&language={$selected_language['code']}{/if}">
							{__("All")}
						</a>
						<a class="dropdown-item" href="?type=in_person{if $selected_country}&country={$selected_country['country_name']}{/if}{if $selected_language}&language={$selected_language['code']}{/if}">
							{__("In Person")}
						</a>
						<a class="dropdown-item" href="?type=online{if $selected_country}&country={$selected_country['country_name']}{/if}{if $selected_language}&language={$selected_language['code']}{/if}">
							{__("Online")}
						</a>
					</div>
				</div>
				<!-- type filter (in person or online) -->
			</div>
		</div>
	</div>
</div>

<!-- location filter -->

{include file='_footer.tpl'}