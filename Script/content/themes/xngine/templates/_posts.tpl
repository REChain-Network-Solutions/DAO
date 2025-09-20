<!-- posts-filter -->
{if $_filter == "article"}
	{if $user->_data['can_write_blogs']}
		<div class="d-flex align-items-center p-3 position-sticky x_top_posts">
			<div class="d-flex align-items-center justify-content-between gap-10 position-relative flex-wrap">
				<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{if $_title}{$_title}{else}{__("Recent Updates")}{/if}</span>
				<span class="flex-0">
					<a href="{$system['system_url']}/blogs/new" class="btn btn-sm btn-primary flex-0 d-none d-md-flex">
						<span class="my2">{__("Create Blog")}</span>
					</a>
					<a href="{$system['system_url']}/blogs/new" class="btn btn-primary flex-0 p-2 rounded-circle lh-1 d-md-none">
						<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 3C12.5523 3 13 3.44772 13 4V11H20C20.5523 11 21 11.4477 21 12C21 12.5523 20.5523 13 20 13H13V20C13 20.5523 12.5523 21 12 21C11.4477 21 11 20.5523 11 20V13H4C3.44772 13 3 12.5523 3 12C3 11.4477 3.44772 11 4 11H11V4C11 3.44772 11.4477 3 12 3Z" fill="currentColor"/></svg>
					</a>
				</span>
			</div>
		</div>
	{/if}
{elseif $_filter == "product" && !$_query}
	{if $system['market_enabled'] && !in_array($_get, ['posts_page', 'posts_group', 'posts_event'])}
		<div class="d-flex align-items-center p-3 position-sticky x_top_posts">
			<div class="d-flex align-items-center justify-content-between gap-10 position-relative flex-wrap">
				<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{if $_title}{$_title}{else}{__("Recent Updates")}{/if}</span>
				<span class="flex-0">
					<a href="javascript:void(0);" class="btn btn-sm btn-primary flex-0 d-none d-md-flex" data-toggle="modal" data-url="posts/product.php?do=create">
						<span class="my2">{__("Create Product")}</span>
					</a>
					<a href="javascript:void(0);" class="btn btn-primary flex-0 p-2 rounded-circle lh-1 d-md-none" data-toggle="modal" data-url="posts/product.php?do=create">
						<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 3C12.5523 3 13 3.44772 13 4V11H20C20.5523 11 21 11.4477 21 12C21 12.5523 20.5523 13 20 13H13V20C13 20.5523 12.5523 21 12 21C11.4477 21 11 20.5523 11 20V13H4C3.44772 13 3 12.5523 3 12C3 11.4477 3.44772 11 4 11H11V4C11 3.44772 11.4477 3 12 3Z" fill="currentColor"/></svg>
					</a>
				</span>
			</div>
		</div>
	{/if}
{elseif $_filter == "funding"}
	{if $user->_data['can_raise_funding'] && !in_array($_get, ['posts_page', 'posts_group', 'posts_event'])}
		<div class="d-flex align-items-center p-3 position-sticky x_top_posts">
			<div class="d-flex align-items-center justify-content-between gap-10 position-relative flex-wrap">
				<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{if $_title}{$_title}{else}{__("Recent Updates")}{/if}</span>
				<span class="flex-0">
					<a href="javascript:void(0);" class="btn btn-sm btn-primary flex-0 d-none d-md-flex" data-toggle="modal" data-url="posts/funding.php?do=create">
						<span class="my2">{__("Create Funding")}</span>
					</a>
					<a href="javascript:void(0);" class="btn btn-primary flex-0 p-2 rounded-circle lh-1 d-md-none" data-toggle="modal" data-url="posts/funding.php?do=create">
						<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 3C12.5523 3 13 3.44772 13 4V11H20C20.5523 11 21 11.4477 21 12C21 12.5523 20.5523 13 20 13H13V20C13 20.5523 12.5523 21 12 21C11.4477 21 11 20.5523 11 20V13H4C3.44772 13 3 12.5523 3 12C3 11.4477 3.44772 11 4 11H11V4C11 3.44772 11.4477 3 12 3Z" fill="currentColor"/></svg>
					</a>
				</span>
			</div>
		</div>
	{/if}
{else}
	<div class="posts-filter d-flex align-items-center justify-content-between p-3 gap-10 flex-wrap">
		<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{if $_title}{$_title}{else}{__("Recent Updates")}{/if}</span>
		<div class="d-flex align-items-center flex-0 gap-10">
			<!-- newsfeed location filter -->
			{if $system['newsfeed_location_filter_enabled'] && in_array($page, ['index', 'group', 'event']) && $view != "scheduled" && $view != "boosted_posts" && (!$_filter || $view == "watch")}
				<div class="dropdown">
					<a href="#" data-bs-toggle="dropdown" class="btn btn-sm btn-gray px-2 countries-filter">
						<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M10.3188 3.18507C10.8477 3.0777 11.1895 2.56186 11.0821 2.03292C10.9747 1.50398 10.4589 1.16223 9.92995 1.2696C4.9777 2.27486 1.25 6.65163 1.25 11.9012C1.25 17.8928 6.1071 22.7499 12.0986 22.7499C17.3482 22.7499 21.725 19.0222 22.7303 14.0699C22.8376 13.541 22.4959 13.0252 21.967 12.9178C21.438 12.8104 20.9222 13.1522 20.8148 13.6811C20.5655 14.9091 20.0631 16.0451 19.3644 17.0325C19.332 17.0784 19.2871 17.114 19.2345 17.1337C19.0927 17.187 18.9431 17.2311 18.7858 17.2656C17.8771 17.4417 16.9299 17.289 16.6055 17.1992C16.1083 17.0838 15.5109 16.8837 14.9525 16.6391C14.194 16.3528 13.0623 15.6217 12.575 15.2753L12.5698 15.2716C12.3666 15.1298 11.9201 14.7976 11.9155 14.7942C11.7113 14.642 11.499 14.4839 11.2921 14.3384C10.3543 13.6518 9.1392 13.0492 8.6485 12.832C7.88909 12.5125 7.19972 12.3322 6.56673 12.2584C6.02094 12.1536 5.44083 12.2082 4.97194 12.296C4.48664 12.3869 4.0525 12.5266 3.78339 12.6361C3.7375 12.6543 3.68926 12.6742 3.63946 12.6953C3.45004 12.7759 3.23361 12.6545 3.22112 12.4491C3.21011 12.2679 3.20453 12.0852 3.20453 11.9012C3.20453 7.59948 6.25948 4.00906 10.3188 3.18507Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M17 1.24988C13.8964 1.24988 11.25 3.78754 11.25 6.90905C11.25 8.51167 11.9368 9.83941 12.8702 10.9141C13.7966 11.9808 14.9932 12.8315 16.0931 13.5055L16.106 13.5134L16.1191 13.5208C16.3884 13.6712 16.6919 13.7499 17 13.7499C17.3081 13.7499 17.6116 13.6712 17.8809 13.5208L17.8924 13.5143L17.9036 13.5075C19.009 12.8379 20.206 11.9844 21.1322 10.9144C22.0645 9.83715 22.75 8.50653 22.75 6.90905C22.75 3.78754 20.1036 1.24988 17 1.24988ZM17 4.99988C18.1046 4.99988 19 5.89531 19 6.99988C19 8.10445 18.1046 8.99988 17 8.99988C15.8954 8.99988 15 8.10445 15 6.99988C15 5.89531 15.8954 4.99988 17 4.99988Z" fill="currentColor"/></svg>
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
			{/if}
			<!-- newsfeed location filter -->
			
			{if $user->_logged_in && !$_filter && !$_query}
				<div class="btn-group dropdown js_posts-filter" data-value="all">
					<button type="button" class="btn btn-sm btn-gray px-2 dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
						<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M15 1.25C15.3507 1.25 15.6546 1.49305 15.7317 1.83518L16.2704 4.22676C16.6637 5.97278 18.0272 7.33629 19.7732 7.7296L22.1648 8.26833C22.507 8.3454 22.75 8.64929 22.75 9C22.75 9.35071 22.507 9.6546 22.1648 9.73167L19.7732 10.2704C18.0272 10.6637 16.6637 12.0272 16.2704 13.7732L15.7317 16.1648C15.6546 16.507 15.3507 16.75 15 16.75C14.6493 16.75 14.3454 16.507 14.2683 16.1648L13.7296 13.7732C13.3363 12.0272 11.9728 10.6637 10.2268 10.2704L7.83518 9.73167C7.49305 9.6546 7.25 9.35071 7.25 9C7.25 8.64929 7.49305 8.3454 7.83518 8.26833L10.2268 7.7296C11.9728 7.33629 13.3363 5.97278 13.7296 4.22676L14.2683 1.83518C14.3454 1.49305 14.6493 1.25 15 1.25Z" fill="currentColor"/><path d="M7 11.25C7.35071 11.25 7.6546 11.493 7.73167 11.8352L8.11647 13.5435C8.37923 14.7099 9.29012 15.6208 10.4565 15.8835L12.1648 16.2683C12.507 16.3454 12.75 16.6493 12.75 17C12.75 17.3507 12.507 17.6546 12.1648 17.7317L10.4565 18.1165C9.29012 18.3792 8.37923 19.2901 8.11647 20.4565L7.73167 22.1648C7.6546 22.507 7.35071 22.75 7 22.75C6.64929 22.75 6.3454 22.507 6.26833 22.1648L5.88353 20.4565C5.62077 19.2901 4.70988 18.3792 3.54345 18.1165L1.83518 17.7317C1.49305 17.6546 1.25 17.3507 1.25 17C1.25 16.6493 1.49305 16.3454 1.83518 16.2683L3.54345 15.8835C4.70988 15.6208 5.62077 14.7099 5.88353 13.5435L6.26833 11.8352C6.3454 11.493 6.64929 11.25 7 11.25Z" fill="currentColor"/></svg> <span class="btn-group-text">{__("All")}</span>
					</button>
					<div class="dropdown-menu dropdown-menu-end">
						<div class="js_scroller">
							<div class="dropdown-item pointer" data-title='{__("All")}' data-value="all">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M20.4999 14V10C20.4999 6.22876 20.4999 4.34315 19.3284 3.17157C18.1568 2 16.2712 2 12.4999 2H11.5C7.72883 2 5.84323 2 4.67166 3.17156C3.50008 4.34312 3.50007 6.22872 3.50004 9.99993L3.5 13.9999C3.49997 17.7712 3.49995 19.6568 4.67153 20.8284C5.8431 22 7.72873 22 11.5 22H12.4999C16.2712 22 18.1568 22 19.3284 20.8284C20.4999 19.6569 20.4999 17.7712 20.4999 14Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M8 7H16M8 12H16M8 17L12 17" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
								{__("All")}
							</div>
							<div class="dropdown-item pointer" data-title='{__("Text")}' data-value="">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M14 19L11.1069 10.7479C9.76348 6.91597 9.09177 5 8 5C6.90823 5 6.23652 6.91597 4.89309 10.7479L2 19M4.5 12H11.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M21.9692 13.9392V18.4392M21.9692 13.9392C22.0164 13.1161 22.0182 12.4891 21.9194 11.9773C21.6864 10.7709 20.4258 10.0439 19.206 9.89599C18.0385 9.75447 17.1015 10.055 16.1535 11.4363M21.9692 13.9392L19.1256 13.9392C18.6887 13.9392 18.2481 13.9603 17.8272 14.0773C15.2545 14.7925 15.4431 18.4003 18.0233 18.845C18.3099 18.8944 18.6025 18.9156 18.8927 18.9026C19.5703 18.8724 20.1955 18.545 20.7321 18.1301C21.3605 17.644 21.9692 16.9655 21.9692 15.9392V13.9392Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
								{__("Text")}
							</div>
							<div class="dropdown-item pointer" data-title='{__("Links")}' data-value="link">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M9.14339 10.691L9.35031 10.4841C11.329 8.50532 14.5372 8.50532 16.5159 10.4841C18.4947 12.4628 18.4947 15.671 16.5159 17.6497L13.6497 20.5159C11.671 22.4947 8.46279 22.4947 6.48405 20.5159C4.50532 18.5372 4.50532 15.329 6.48405 13.3503L6.9484 12.886" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M17.0516 11.114L17.5159 10.6497C19.4947 8.67095 19.4947 5.46279 17.5159 3.48405C15.5372 1.50532 12.329 1.50532 10.3503 3.48405L7.48405 6.35031C5.50532 8.32904 5.50532 11.5372 7.48405 13.5159C9.46279 15.4947 12.671 15.4947 14.6497 13.5159L14.8566 13.309" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
								{__("Links")}
							</div>
							<div class="dropdown-item pointer" data-title='{__("Media")}' data-value="media">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M14.9531 12.3948C14.8016 13.0215 14.0857 13.4644 12.6539 14.3502C11.2697 15.2064 10.5777 15.6346 10.0199 15.4625C9.78934 15.3913 9.57925 15.2562 9.40982 15.07C9 14.6198 9 13.7465 9 12C9 10.2535 9 9.38018 9.40982 8.92995C9.57925 8.74381 9.78934 8.60868 10.0199 8.53753C10.5777 8.36544 11.2697 8.79357 12.6539 9.64983C14.0857 10.5356 14.8016 10.9785 14.9531 11.6052C15.0156 11.8639 15.0156 12.1361 14.9531 12.3948Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75" /></svg>
								{__("Media")}
							</div>
							{if $system['live_enabled'] && $_get != "posts_page" && $_get != "posts_group" && $_get != "posts_event"}
								<div class="dropdown-item pointer" data-title='{__("Live")}' data-value="live">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><circle cx="12" cy="12" r="2" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M7.5 8C6.5 9 6 10.5 6 12C6 13.5 6.5 15 7.5 16" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M4.5 6C3 7.5 2 9.5 2 12C2 14.5 3 16.5 4.5 18" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M16.5 16C17.5 15 18 13.5 18 12C18 10.5 17.5 9 16.5 8" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M19.5 18C21 16.5 22 14.5 22 12C22 9.5 21 7.5 19.5 6" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
									{__("Live")}
								</div>
							{/if}
							<div class="dropdown-item pointer" data-title='{__("Photos")}' data-value="photos">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75" /><circle cx="16.5" cy="7.5" r="1.5" stroke="currentColor" stroke-width="1.75" /><path d="M16 22C15.3805 19.7749 13.9345 17.7821 11.8765 16.3342C9.65761 14.7729 6.87163 13.9466 4.01569 14.0027C3.67658 14.0019 3.33776 14.0127 3 14.0351" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M13 18C14.7015 16.6733 16.5345 15.9928 18.3862 16.0001C19.4362 15.999 20.4812 16.2216 21.5 16.6617" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /></svg>
								{__("Photos")}
							</div>
							{if $system['geolocation_enabled']}
								<div class="dropdown-item pointer" data-title='{__("Maps")}' data-value="map">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M14.5 9C14.5 10.3807 13.3807 11.5 12 11.5C10.6193 11.5 9.5 10.3807 9.5 9C9.5 7.61929 10.6193 6.5 12 6.5C13.3807 6.5 14.5 7.61929 14.5 9Z" stroke="currentColor" stroke-width="1.75" /><path d="M18.2222 17C19.6167 18.9885 20.2838 20.0475 19.8865 20.8999C19.8466 20.9854 19.7999 21.0679 19.7469 21.1467C19.1724 22 17.6875 22 14.7178 22H9.28223C6.31251 22 4.82765 22 4.25311 21.1467C4.20005 21.0679 4.15339 20.9854 4.11355 20.8999C3.71619 20.0475 4.38326 18.9885 5.77778 17" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M13.2574 17.4936C12.9201 17.8184 12.4693 18 12.0002 18C11.531 18 11.0802 17.8184 10.7429 17.4936C7.6543 14.5008 3.51519 11.1575 5.53371 6.30373C6.6251 3.67932 9.24494 2 12.0002 2C14.7554 2 17.3752 3.67933 18.4666 6.30373C20.4826 11.1514 16.3536 14.5111 13.2574 17.4936Z" stroke="currentColor" stroke-width="1.75" /></svg>
									{__("Maps")}
								</div>
							{/if}
							{if $system['blogs_enabled']}
								<div class="dropdown-item pointer" data-title='{__("Blogs")}' data-value="article">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M10.5 8H18.5M10.5 12H13M18.5 12H16M10.5 16H13M18.5 16H16" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M7 7.5H6C4.11438 7.5 3.17157 7.5 2.58579 8.08579C2 8.67157 2 9.61438 2 11.5V18C2 19.3807 3.11929 20.5 4.5 20.5C5.88071 20.5 7 19.3807 7 18V7.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M16 3.5H11C10.07 3.5 9.60504 3.5 9.22354 3.60222C8.18827 3.87962 7.37962 4.68827 7.10222 5.72354C7 6.10504 7 6.57003 7 7.5V18C7 19.3807 5.88071 20.5 4.5 20.5H16C18.8284 20.5 20.2426 20.5 21.1213 19.6213C22 18.7426 22 17.3284 22 14.5V9.5C22 6.67157 22 5.25736 21.1213 4.37868C20.2426 3.5 18.8284 3.5 16 3.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
									{__("Blogs")}
								</div>
							{/if}
							{if $system['market_enabled'] && $_get != "posts_page" && $_get != "posts_group" && $_get != "posts_event"}
								<div class="dropdown-item pointer" data-title='{__("Products")}' data-value="product">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3.00003 10.9866V15.4932C3.00003 18.3257 3.00003 19.742 3.87871 20.622C4.75739 21.502 6.1716 21.502 9.00003 21.502H15C17.8284 21.502 19.2426 21.502 20.1213 20.622C21 19.742 21 18.3257 21 15.4932V10.9866" stroke="currentColor" stroke-width="1.75" /><path d="M7.00003 17.9741H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M17.7957 2.50049L6.14986 2.52954C4.41169 2.44011 3.96603 3.77859 3.96603 4.4329C3.96603 5.01809 3.89058 5.8712 2.82527 7.47462C1.75996 9.07804 1.84001 9.55437 2.44074 10.6644C2.93931 11.5857 4.20744 11.9455 4.86865 12.0061C6.96886 12.0538 7.99068 10.2398 7.99068 8.96495C9.03254 12.1683 11.9956 12.1683 13.3158 11.802C14.6386 11.435 15.7717 10.1214 16.0391 8.96495C16.195 10.4021 16.6682 11.2408 18.0663 11.817C19.5145 12.4139 20.7599 11.5016 21.3848 10.9168C22.0097 10.332 22.4107 9.03364 21.2968 7.60666C20.5286 6.62257 20.2084 5.69548 20.1033 4.73462C20.0423 4.17787 19.9888 3.57961 19.5972 3.1989C19.0248 2.64253 18.2036 2.47372 17.7957 2.50049Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
									{__("Products")}
								</div>
							{/if}
							{if $system['funding_enabled'] && $_get != "posts_page" && $_get != "posts_group" && $_get != "posts_event"}
								<div class="dropdown-item pointer" data-title='{__("Funding")}' data-value="funding">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M8.39559 2.55196C9.8705 1.63811 11.1578 2.00638 11.9311 2.59299C12.2482 2.83351 12.4067 2.95378 12.5 2.95378C12.5933 2.95378 12.7518 2.83351 13.0689 2.59299C13.8422 2.00638 15.1295 1.63811 16.6044 2.55196C18.5401 3.75128 18.9781 7.7079 14.5133 11.046C13.6629 11.6818 13.2377 11.9996 12.5 11.9996C11.7623 11.9996 11.3371 11.6818 10.4867 11.046C6.02195 7.7079 6.45994 3.75128 8.39559 2.55196Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M4 14H6.39482C6.68897 14 6.97908 14.0663 7.24217 14.1936L9.28415 15.1816C9.54724 15.3089 9.83735 15.3751 10.1315 15.3751H11.1741C12.1825 15.3751 13 16.1662 13 17.142C13 17.1814 12.973 17.2161 12.9338 17.2269L10.3929 17.9295C9.93707 18.0555 9.449 18.0116 9.025 17.8064L6.84211 16.7503" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M13 16.5L17.5928 15.0889C18.407 14.8352 19.2871 15.136 19.7971 15.8423C20.1659 16.3529 20.0157 17.0842 19.4785 17.3942L11.9629 21.7305C11.4849 22.0063 10.9209 22.0736 10.3952 21.9176L4 20.0199" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
									{__("Funding")}
								</div>
							{/if}
							{if $system['offers_enabled']}
								<div class="dropdown-item pointer" data-title='{__("Offers")}' data-value="offer">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7.83152 21.3478L7.31312 20.6576C6.85764 20.0511 5.89044 20.1 5.50569 20.7488C4.96572 21.6595 3.5 21.2966 3.5 20.2523V3.74775C3.5 2.7034 4.96572 2.3405 5.50569 3.25115C5.89044 3.90003 6.85764 3.94888 7.31312 3.34244L7.83152 2.65222C8.48467 1.78259 9.84866 1.78259 10.5018 2.65222L10.5833 2.76076C11.2764 3.68348 12.7236 3.68348 13.4167 2.76076L13.4982 2.65222C14.1513 1.78259 15.5153 1.78259 16.1685 2.65222L16.6869 3.34244C17.1424 3.94888 18.1096 3.90003 18.4943 3.25115C19.0343 2.3405 20.5 2.7034 20.5 3.74774V20.2523C20.5 21.2966 19.0343 21.6595 18.4943 20.7488C18.1096 20.1 17.1424 20.0511 16.6869 20.6576L16.1685 21.3478C15.5153 22.2174 14.1513 22.2174 13.4982 21.3478L13.4167 21.2392C12.7236 20.3165 11.2764 20.3165 10.5833 21.2392L10.5018 21.3478C9.84866 22.2174 8.48467 22.2174 7.83152 21.3478Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M15 9L9 15" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M15 15H14.991M9.00897 9H9" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
									{__("Offers")}
								</div>
							{/if}
							{if $system['jobs_enabled']}
								<div class="dropdown-item pointer" data-title='{__("Jobs")}' data-value="job">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3 11L3.15288 14.2269C3.31714 17.6686 3.39927 19.3894 4.55885 20.4447C5.71843 21.5 7.52716 21.5 11.1446 21.5H12.8554C16.4728 21.5 18.2816 21.5 19.4412 20.4447C20.6007 19.3894 20.6829 17.6686 20.8471 14.2269L21 11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M2.84718 10.4431C4.54648 13.6744 8.3792 15 12 15C15.6208 15 19.4535 13.6744 21.1528 10.4431C21.964 8.90056 21.3498 6 19.352 6H4.648C2.65023 6 2.03603 8.90056 2.84718 10.4431Z" stroke="currentColor" stroke-width="1.75" /><path d="M11.9999 11H12.0089" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M15.9999 6L15.9116 5.69094C15.4716 4.15089 15.2516 3.38087 14.7278 2.94043C14.204 2.5 13.5083 2.5 12.1168 2.5H11.8829C10.4915 2.5 9.79575 2.5 9.27198 2.94043C8.7482 3.38087 8.52819 4.15089 8.08818 5.69094L7.99988 6" stroke="currentColor" stroke-width="1.75" /></svg>
									{__("Jobs")}
								</div>
							{/if}
							{if $system['courses_enabled']}
								<div class="dropdown-item pointer" data-title='{__("Courses")}' data-value="course">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7.50586 4.94531H16.0059C16.8343 4.94531 17.5059 5.61688 17.5059 6.44531V7.94531" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M15.0059 17.9453L14.1488 15.9453M14.1488 15.9453L12.5983 12.3277C12.4992 12.0962 12.2653 11.9453 12.0059 11.9453C11.7465 11.9453 11.5126 12.0962 11.4135 12.3277L9.863 15.9453M14.1488 15.9453H9.863M9.00586 17.9453L9.863 15.9453" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M18.497 2L6.30767 2.00002C5.81071 2.00002 5.30241 2.07294 4.9007 2.36782C3.62698 3.30279 2.64539 5.38801 4.62764 7.2706C5.18421 7.7992 5.96217 7.99082 6.72692 7.99082H18.2835C19.077 7.99082 20.5 8.10439 20.5 10.5273V17.9812C20.5 20.2007 18.7103 22 16.5026 22H7.47246C5.26886 22 3.66619 20.4426 3.53959 18.0713L3.5061 5.16638" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
									{__("Courses")}
								</div>
							{/if}
							{if $system['polls_enabled']}
								<div class="dropdown-item pointer" data-title='{__("Polls")}' data-value="poll">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3.5 9.5V18.5C3.5 18.9659 3.5 19.1989 3.57612 19.3827C3.67761 19.6277 3.87229 19.8224 4.11732 19.9239C4.30109 20 4.53406 20 5 20C5.46594 20 5.69891 20 5.88268 19.9239C6.12771 19.8224 6.32239 19.6277 6.42388 19.3827C6.5 19.1989 6.5 18.9659 6.5 18.5V9.5C6.5 9.03406 6.5 8.80109 6.42388 8.61732C6.32239 8.37229 6.12771 8.17761 5.88268 8.07612C5.69891 8 5.46594 8 5 8C4.53406 8 4.30109 8 4.11732 8.07612C3.87229 8.17761 3.67761 8.37229 3.57612 8.61732C3.5 8.80109 3.5 9.03406 3.5 9.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="square" stroke-linejoin="round" /><path d="M10.5 5.5V18.4995C10.5 18.9654 10.5 19.1984 10.5761 19.3822C10.6776 19.6272 10.8723 19.8219 11.1173 19.9234C11.3011 19.9995 11.5341 19.9995 12 19.9995C12.4659 19.9995 12.6989 19.9995 12.8827 19.9234C13.1277 19.8219 13.3224 19.6272 13.4239 19.3822C13.5 19.1984 13.5 18.9654 13.5 18.4995V5.5C13.5 5.03406 13.5 4.80109 13.4239 4.61732C13.3224 4.37229 13.1277 4.17761 12.8827 4.07612C12.6989 4 12.4659 4 12 4C11.5341 4 11.3011 4 11.1173 4.07612C10.8723 4.17761 10.6776 4.37229 10.5761 4.61732C10.5 4.80109 10.5 5.03406 10.5 5.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="square" stroke-linejoin="round" /><path d="M17.5 12.5V18.5C17.5 18.9659 17.5 19.1989 17.5761 19.3827C17.6776 19.6277 17.8723 19.8224 18.1173 19.9239C18.3011 20 18.5341 20 19 20C19.4659 20 19.6989 20 19.8827 19.9239C20.1277 19.8224 20.3224 19.6277 20.4239 19.3827C20.5 19.1989 20.5 18.9659 20.5 18.5V12.5C20.5 12.0341 20.5 11.8011 20.4239 11.6173C20.3224 11.3723 20.1277 11.1776 19.8827 11.0761C19.6989 11 19.4659 11 19 11C18.5341 11 18.3011 11 18.1173 11.0761C17.8723 11.1776 17.6776 11.3723 17.5761 11.6173C17.5 11.8011 17.5 12.0341 17.5 12.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="square" stroke-linejoin="round" /></svg>
									{__("Polls")}
								</div>
							{/if}
							{if $system['reels_enabled']}
								<div class="dropdown-item pointer" data-title='{__("Reels")}' data-value="reel">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M2.50012 7.5H21.5001" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M17.0001 2.5L14.0001 7.5" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M10.0001 2.5L7.00012 7.5" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75" /><path d="M14.9531 14.8948C14.8016 15.5215 14.0857 15.9644 12.6539 16.8502C11.2697 17.7064 10.5777 18.1346 10.0199 17.9625C9.78934 17.8913 9.57925 17.7562 9.40982 17.57C9 17.1198 9 16.2465 9 14.5C9 12.7535 9 11.8802 9.40982 11.4299C9.57925 11.2438 9.78934 11.1087 10.0199 11.0375C10.5777 10.8654 11.2697 11.2936 12.6539 12.1498C14.0857 13.0356 14.8016 13.4785 14.9531 14.1052C15.0156 14.3639 15.0156 14.6361 14.9531 14.8948Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /></svg>
									{__("Reels")}
								</div>
							{/if}
							{if $system['videos_enabled']}
								<div class="dropdown-item pointer" data-title='{__("Videos")}' data-value="video">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M11 8L13 8" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M2 11C2 7.70017 2 6.05025 3.02513 5.02513C4.05025 4 5.70017 4 9 4H10C13.2998 4 14.9497 4 15.9749 5.02513C17 6.05025 17 7.70017 17 11V13C17 16.2998 17 17.9497 15.9749 18.9749C14.9497 20 13.2998 20 10 20H9C5.70017 20 4.05025 20 3.02513 18.9749C2 17.9497 2 16.2998 2 13V11Z" stroke="currentColor" stroke-width="1.75" /><path d="M17 8.90585L17.1259 8.80196C19.2417 7.05623 20.2996 6.18336 21.1498 6.60482C22 7.02628 22 8.42355 22 11.2181V12.7819C22 15.5765 22 16.9737 21.1498 17.3952C20.2996 17.8166 19.2417 16.9438 17.1259 15.198L17 15.0941" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
									{__("Videos")}
								</div>
							{/if}
							{if $system['audio_enabled']}
								<div class="dropdown-item pointer" data-title='{__("Audios")}' data-value="audio">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><circle cx="6.5" cy="18.5" r="3.5" stroke="currentColor" stroke-width="1.75" /><circle cx="18" cy="16" r="3" stroke="currentColor" stroke-width="1.75" /><path d="M10 18.5L10 7C10 6.07655 10 5.61483 10.2635 5.32794C10.5269 5.04106 11.0175 4.9992 11.9986 4.91549C16.022 4.57222 18.909 3.26005 20.3553 2.40978C20.6508 2.236 20.7986 2.14912 20.8993 2.20672C21 2.26432 21 2.4315 21 2.76587V16" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M10 10C15.8667 10 19.7778 7.66667 21 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
									{__("Audios")}
								</div>
							{/if}
							{if $system['file_enabled']}
								<div class="dropdown-item pointer" data-title='{__("Files")}' data-value="file">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M4 12.0004L4 14.5446C4 17.7896 4 19.4121 4.88607 20.5111C5.06508 20.7331 5.26731 20.9354 5.48933 21.1144C6.58831 22.0004 8.21082 22.0004 11.4558 22.0004C12.1614 22.0004 12.5141 22.0004 12.8372 21.8864C12.9044 21.8627 12.9702 21.8354 13.0345 21.8047C13.3436 21.6569 13.593 21.4074 14.0919 20.9085L18.8284 16.172C19.4065 15.5939 19.6955 15.3049 19.8478 14.9374C20 14.5698 20 14.1611 20 13.3436V10.0004C20 6.22919 20 4.34358 18.8284 3.172C17.7693 2.11284 16.1265 2.01122 13.0345 2.00146M13 21.5004V21.0004C13 18.172 13 16.7578 13.8787 15.8791C14.7574 15.0004 16.1716 15.0004 19 15.0004H19.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M4 8.23028V5.46105C4 3.54929 5.567 1.99951 7.5 1.99951C9.433 1.99951 11 3.54929 11 5.46105V9.26874C11 10.2246 10.2165 10.9995 9.25 10.9995C8.2835 10.9995 7.5 10.2246 7.5 9.26874V5.46105" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
									{__("Files")}
								</div>
							{/if}
							{if $system['merits_enabled']}
								<div class="dropdown-item pointer" data-title='{__("Merits")}' data-value="merit">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12Z" stroke="currentColor" stroke-width="1.75" /><path d="M12.8638 7.72209L13.7437 9.49644C13.8637 9.74344 14.1837 9.98035 14.4536 10.0257L16.0485 10.2929C17.0684 10.4643 17.3083 11.2103 16.5734 11.9462L15.3335 13.1964C15.1236 13.4081 15.0086 13.8164 15.0736 14.1087L15.4285 15.6562C15.7085 16.8812 15.0636 17.355 13.9887 16.7148L12.4939 15.8226C12.2239 15.6613 11.7789 15.6613 11.504 15.8226L10.0091 16.7148C8.93925 17.355 8.28932 16.8761 8.56929 15.6562L8.92425 14.1087C8.98925 13.8164 8.87426 13.4081 8.66428 13.1964L7.42442 11.9462C6.6945 11.2103 6.92947 10.4643 7.94936 10.2929L9.54419 10.0257C9.80916 9.98035 10.1291 9.74344 10.2491 9.49644L11.129 7.72209C11.609 6.7593 12.3889 6.7593 12.8638 7.72209Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
									{__("Merits")}
								</div>
							{/if}
						</div>
					</div>
				</div>
			{/if}
		</div>
	</div>
{/if}
<!-- posts-filter -->

<!-- posts-loader -->
<div class="post x-hidden js_posts_loader">
  <div class="post-body with-loader">
    <div class="panel-effect">
      <div class="fake-effect fe-0"></div>
      <div class="fake-effect fe-1"></div>
      <div class="fake-effect fe-2"></div>
      <div class="fake-effect fe-3"></div>
      <div class="fake-effect fe-4"></div>
      <div class="fake-effect fe-5"></div>
      <div class="fake-effect fe-6"></div>
      <div class="fake-effect fe-7"></div>
      <div class="fake-effect fe-8"></div>
      <div class="fake-effect fe-9"></div>
      <div class="fake-effect fe-10"></div>
      <div class="fake-effect fe-11"></div>
    </div>
  </div>
</div>
<!-- posts-loader -->

<!-- posts staging -->
<button class="btn btn-primary rounded-pill posts-staging-btn js_view-staging-posts">
  {__("View")} <span>0</span> {__("New Posts")}
</button>

<div class="js_posts_stream_staging" style="display: none;"></div>
<!-- posts staging -->

<!-- posts stream -->
<div class="js_posts_stream" data-get="{$_get}" data-filter="{if $_filter}{$_filter}{else}all{/if}" data-country="{if $selected_country}{$selected_country['country_id']}{else}all{/if}" {if $_id}data-id="{$_id}" {/if} {if $_query}data-query="{$_query}" {/if}>
	{if $posts}
		<ul>
			<!-- posts -->
			{foreach $posts as $post}
				{include file='__feeds_post.tpl' _get=$_get}
			{/foreach}
			<!-- posts -->
		</ul>

		<!-- see-more -->
		<div class="alert alert-post see-more mb20 js_see-more js_see-more-infinite" data-get="{if $_load_more}{$_load_more}{else}{$_get}{/if}" data-filter="{if $_filter}{$_filter}{else}all{/if}" data-country="{if $selected_country}{$selected_country['country_id']}{else}all{/if}" {if $_id}data-id="{$_id}" {/if} {if $_query}data-query="{$_query}" {/if}>
			<span>{__("More Stories")}</span>
			<div class="loader loader_small x-hidden"></div>
		</div>
		<!-- see-more -->
	{else}
		<div class="js_posts_stream" data-get="{$_get}" data-filter="{if $_filter}{$_filter}{else}all{/if}" data-country="{if $selected_country}{$selected_country['country_id']}{else}all{/if}" {if $_id}data-id="{$_id}" {/if}>
			<ul>
				{include file='_no_data.tpl'}
			</ul>
		</div>
	{/if}
</div>
<!-- posts stream -->