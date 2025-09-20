{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
.search-wrapper-prnt {
display: none !important
}
</style>

<!-- page content -->
<div class="row x_content_row">
	<!-- center panel -->
	<div class="col-lg-12 w-100">
		<div class="position-sticky x_top_posts">
			<div class="headline-font fw-semibold side_widget_title px-3 py-2 d-flex align-items-center justify-content-between">
				{__("Marketplace")}
				<span class="flex-0 d-flex align-items-center gap-2">
					{if in_array($view, ['', 'search', 'category'])}
						{if $rows}
							{if $user->_logged_in && $system['location_finder_enabled']}
								<!-- location filter -->
								<button type="button" class="btn btn-gray border-0 p-2 rounded-circle lh-1 flex-0" data-bs-toggle="dropdown">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7 18C5.17107 18.4117 4 19.0443 4 19.7537C4 20.9943 7.58172 22 12 22C16.4183 22 20 20.9943 20 19.7537C20 19.0443 18.8289 18.4117 17 18" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M14.5 9C14.5 10.3807 13.3807 11.5 12 11.5C10.6193 11.5 9.5 10.3807 9.5 9C9.5 7.61929 10.6193 6.5 12 6.5C13.3807 6.5 14.5 7.61929 14.5 9Z" stroke="currentColor" stroke-width="1.75" /><path d="M13.2574 17.4936C12.9201 17.8184 12.4693 18 12.0002 18C11.531 18 11.0802 17.8184 10.7429 17.4936C7.6543 14.5008 3.51519 11.1575 5.53371 6.30373C6.6251 3.67932 9.24494 2 12.0002 2C14.7554 2 17.3752 3.67933 18.4666 6.30373C20.4826 11.1514 16.3536 14.5111 13.2574 17.4936Z" stroke="currentColor" stroke-width="1.75" /></svg>
								</button>
								<div class="dropdown-menu p-0 dropdown-menu-end">
									<form class="p-3" method="get" action="?">
										<div class="form-group">
											<label class="form-label fw-medium">{__("Distance")}</label>
											<div class="d-flex align-items-center gap-2">
												{if $location}
													<input type="hidden" name="location" value="{$location}">
												{/if}
												{if $sort}
													<input type="hidden" name="sort" value="{$sort}">
												{/if}
												<input type="range" class="custom-range" min="1" max="5000" name="distance" value="{if $distance}{$distance}{else}5000{/if}" oninput="this.form.distance_value.value=this.value">

												<div class="flex-0 d-flex align-items-center small">
													<input disabled type="text" class="p-0 border-0 bg-transparent x_distance" min="1" max="5000" name="distance_value" value="{if $distance}{$distance}{else}5000{/if}" oninput="this.form.distance.value=this.value">
													<span class="flex-0">{if $system['system_distance'] == "mile"}{__("ML")}{else}{__("KM")}{/if}</span>
												</div>
											</div>
										</div>
										<div class="mt-3">
											<button type="submit" class="btn w-100 btn-primary">{__("Filter")}</button>
										</div>
									</form>
								</div>
								<!-- location filter -->
							{/if}
							
							<!-- sort -->
							<button type="button" class="btn btn-gray border-0 p-2 rounded-circle lh-1 flex-0" data-bs-toggle="dropdown">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M11 10L18 10" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M11 14H16" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M11 18H14" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M11 6H21" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M7 18.8125C6.60678 19.255 5.56018 21 5 21M3 18.8125C3.39322 19.255 4.43982 21 5 21M5 21L5 15" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M3 5.1875C3.39322 4.74501 4.43982 3 5 3M7 5.1875C6.60678 4.74501 5.56018 3 5 3M5 3L5 9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
							</button>
							<div class="dropdown-menu dropdown-menu-end">
								<a href="?{if $location}location={$location}&{/if}{if $distance}distance={$distance}{if $location}&{else}?{/if}{/if}sort=latest" class='dropdown-item {if !$sort || $sort == "latest"}active{/if}'>
									{__("Latest")}
								</a>
								<a href="?{if $location}location={$location}&{/if}{if $distance}distance={$distance}{if $location}&{else}?{/if}{/if}sort=price-high" class='dropdown-item {if $sort == "price-high"}active{/if}'>
									{__("Price High")}
								</a>
								<a href="?{if $location}location={$location}&{/if}{if $distance}distance={$distance}{if $location}&{else}?{/if}{/if}sort=price-low" class='dropdown-item {if $sort == "price-low"}active{/if}'>
									{__("Price Low")}
								</a>
							</div>
							<!-- sort -->
						{/if}
					{/if}
					{if $system['market_enabled']}
						<button class="btn btn-sm btn-primary flex-0 d-none d-md-flex" data-toggle="modal" data-url="posts/product.php?do=create">
							<span class="my2">{__("Create Product")}</span>
						</button>
						<button class="btn btn-primary flex-0 p-2 rounded-circle lh-1 d-md-none" data-toggle="modal" data-url="posts/product.php?do=create">
							<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 3C12.5523 3 13 3.44772 13 4V11H20C20.5523 11 21 11.4477 21 12C21 12.5523 20.5523 13 20 13H13V20C13 20.5523 12.5523 21 12 21C11.4477 21 11 20.5523 11 20V13H4C3.44772 13 3 12.5523 3 12C3 11.4477 3.44772 11 4 11H11V4C11 3.44772 11.4477 3 12 3Z" fill="currentColor"/></svg>
						</button>
					{/if}
				</span>
			</div>
			
			<div class="d-flex align-items-center justify-content-center">
				<div {if $view == "" || $view == "search" || $view == "category"}class="active fw-semibold" {/if}>
					<a href="{$system['system_url']}/market" class="body-color side_item_hover w-100 text-center d-block">
						<span class="position-relative d-inline-block py-3">{__("Discover")}</span>
					</a>
				</div>
				{if $system['market_shopping_cart_enabled'] && $user->_logged_in}
					<div {if $view == "cart"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/market/cart" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Shopping Cart")}</span>
						</a>
					</div>
					<div {if $view == "orders"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/market/orders" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Orders")}</span>
						</a>
					</div>
					{if $user->_data['can_sell_products']}
						<div {if $view == "sales"}class="active fw-semibold" {/if}>
							<a href="{$system['system_url']}/market/sales" class="body-color side_item_hover w-100 text-center d-block">
								<span class="position-relative d-inline-block py-3">{__("Sales")}</span>
							</a>
						</div>
					{/if}
				{/if}
			</div>
		</div>
		
		<div class="pt-3 pb-2 px-2 mx-1">
			{if $view == "orders"}
				<form action="{$system['system_url']}/market/orders" method="get">
					<div class="position-relative">
						<input type="search" class="form-control shadow-none rounded-pill x_search_filter" name="query" placeholder='{__("Search")} {__("Orders")}'>
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"></path></svg>
					</div>
				</form>
			{elseif $view == "sales"}
				<form action="{$system['system_url']}/market/sales" method="get">
					<div class="position-relative">
						<input type="search" class="form-control shadow-none rounded-pill x_search_filter" name="query" placeholder='{__("Search")} {__("Sales")}'>
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"></path></svg>
					</div>
				</form>
			{else}
				<form class="js_search-form" data-handle="market">
					<div class="row g-3">
						<div class="col-12 col-lg-5 position-relative">
							<input type="search" class="form-control shadow-none rounded-pill x_search_filter" name="query" placeholder='{__("Search for products")}'>
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"></path></svg>
						</div>
						<div class="col-12 col-lg-5 position-relative">
							<input type="text" class="form-control shadow-none rounded-pill x_search_filter" name="location" placeholder='{__("at location")}'>
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M13.6177 21.367C13.1841 21.773 12.6044 22 12.0011 22C11.3978 22 10.8182 21.773 10.3845 21.367C6.41302 17.626 1.09076 13.4469 3.68627 7.37966C5.08963 4.09916 8.45834 2 12.0011 2C15.5439 2 18.9126 4.09916 20.316 7.37966C22.9082 13.4393 17.599 17.6389 13.6177 21.367Z" stroke="currentColor" stroke-width="2" /><path d="M15.5 11C15.5 12.933 13.933 14.5 12 14.5C10.067 14.5 8.5 12.933 8.5 11C8.5 9.067 10.067 7.5 12 7.5C13.933 7.5 15.5 9.067 15.5 11Z" stroke="currentColor" stroke-width="2" /></svg>
						</div>
						<div class="col">
							<button type="submit" class="btn btn-secondary w-100">{__("Search")}</button>
						</div>
					</div>
				</form>
			{/if}
		</div>
		
		{if in_array($view, ['', 'search', 'category'])}
			<!-- categories -->
			<div class="pb-2 pt-2">
				<div class="overflow-hidden x_page_cats x_page_scroll d-flex align-items-start position-relative">
					<ul class="px-3 d-flex gap-2 align-items-center overflow-x-auto pb-3 scrolll">
						{if $view != "category"}
						{else}
							{if $current_category['parent']}
								<li>
									<a class="btn btn-sm border-0 ps-0 pe-1" href="{$system['system_url']}/market/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
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
									<a class="btn btn-sm border-0 ps-0 pe-1" href="{$system['system_url']}/market">
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
								<a class="btn btn-sm" href="{$system['system_url']}/market/category/{$category['category_id']}/{$category['category_url']}">
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

			<div class="">
				{include file='_ads.tpl'}
				<div class="px-3 pt-2">
					{if $view == "search"}
						<div class="text-muted pb-3">
							<!-- results counter -->
								<span class="fw-medium">{$total}</span> {__("results were found for the search for")} "<strong class="main fw-medium">{htmlentities($query, ENT_QUOTES, 'utf-8')}</strong>" {if $location} {__("at")} "<strong class="main fw-medium">{htmlentities($location, ENT_QUOTES, 'utf-8')}</strong>" {/if}
							<!-- results counter -->
						</div>
					{/if}
					
					<div class="row">
						{if $view == "" && $promoted_products}
							{foreach $promoted_products as $post}
								{include file='__feeds_product.tpl' _boosted=true}
							{/foreach}
						{/if}

						{if $rows}
							{foreach $rows as $post}
								{include file='__feeds_product.tpl'}
							{/foreach}

							<div class="col-12">{$pager}</div>
						{else}
							<div class="col-12">
								{include file='_no_data.tpl'}
							</div>
						{/if}
					</div>
				</div>
			</div>

		{elseif $view == "cart"}
			<div class="px-3 pt-2 page-content">
				<div class="row">
					<!-- Addresses -->
					<div class="col-md-5 col-lg-4 mb-4 mb-md-0">
						<div class="pb-2 mb-1 headline-font fw-semibold h6 m-0">{__("Your Addresses")}</div>
						{include file='_addresses.tpl' _small=true}
					</div>
					<!-- Addresses -->

					<!-- Shopping Cart -->
					<div class="col-md-7 col-lg-8">
						<div class="headline-font fw-semibold h6 m-0">{__("Items")}</div>
						
						{if $cart['items']}
							<div>
								{foreach $cart['items'] as $cart_item}
									<div class="side_item_list d-flex align-items-start gap-3 x_group_list x_cart_list">
										<a href="{$system['system_url']}/posts/{$cart_item['post']['post_id']}" class="flex-0">
											{if $cart_item['post']['photos_num'] > 0}
												<img src="{$system['system_uploads']}/{$cart_item['post']['photos'][0]['source']}" class="rounded-3">
											{else}
												<img src="{$system['system_url']}/content/themes/{$system['theme']}/images/blank_product.png" class="rounded-3">
											{/if}
										</a>

										<div class="flex-1">
											<div class="">
												<a class="text-md fw-semibold body-color" href="{$system['system_url']}/posts/{$cart_item['post']['post_id']}">{$cart_item['post']['product']['name']}</a>
												<div class="">
													{if $cart_item['post']['product']['price'] > 0}
														{print_money($cart_item['post']['product']['price'])}
													{else}
														{__("Free")}
													{/if}
												</div>
											</div>
											<div class="mt-2 pt-1 d-flex align-items-center justify-content-between">
												<div class="form-group">
													<div class="input-group input-group-sm">
														<select class="form-select js_shopping-update-cart" name="quantity" data-id="{$cart_item['product_post_id']}">
															{for $i=1; $i <= $cart_item['post']['product']['quantity']; $i++}
																<option value="{$i}" {if $i == $cart_item['quantity']}selected{/if}>{$i}</option>
															{/for}
														</select>
													</div>
												</div>
										
												<button type="button" class="btn btn-danger rounded-circle p-2 js_shopping-remove-from-cart flex-0" data-id="{$cart_item['product_post_id']}">
													<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M19.5825 15.6564C19.5058 16.9096 19.4449 17.9041 19.3202 18.6984C19.1922 19.5131 18.9874 20.1915 18.5777 20.7849C18.2029 21.3278 17.7204 21.786 17.1608 22.1303C16.5491 22.5067 15.8661 22.6713 15.0531 22.75L8.92739 22.7499C8.1135 22.671 7.42972 22.5061 6.8176 22.129C6.25763 21.7841 5.77494 21.3251 5.40028 20.7813C4.99073 20.1869 4.78656 19.5075 4.65957 18.6917C4.53574 17.8962 4.47623 16.9003 4.40122 15.6453L3.75 4.75H20.25L19.5825 15.6564ZM9.5 17.9609C9.08579 17.9609 8.75 17.6252 8.75 17.2109L8.75 11.2109C8.75 10.7967 9.08579 10.4609 9.5 10.4609C9.91421 10.4609 10.25 10.7967 10.25 11.2109L10.25 17.2109C10.25 17.6252 9.91421 17.9609 9.5 17.9609ZM15.25 11.2109C15.25 10.7967 14.9142 10.4609 14.5 10.4609C14.0858 10.4609 13.75 10.7967 13.75 11.2109V17.2109C13.75 17.6252 14.0858 17.9609 14.5 17.9609C14.9142 17.9609 15.25 17.6252 15.25 17.2109V11.2109Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13.3473 1.28277C13.9124 1.33331 14.4435 1.50576 14.8996 1.84591C15.2369 2.09748 15.4712 2.40542 15.6714 2.73893C15.8569 3.04798 16.0437 3.4333 16.2555 3.8704L16.6823 4.7507H21C21.5523 4.7507 22 5.19842 22 5.7507C22 6.30299 21.5523 6.7507 21 6.7507C14.9998 6.7507 9.00019 6.7507 3 6.7507C2.44772 6.7507 2 6.30299 2 5.7507C2 5.19842 2.44772 4.7507 3 4.7507H7.40976L7.76556 3.97016C7.97212 3.51696 8.15403 3.11782 8.33676 2.79754C8.53387 2.45207 8.76721 2.13237 9.10861 1.87046C9.57032 1.51626 10.1121 1.33669 10.6899 1.28409C11.1249 1.24449 11.5634 1.24994 12 1.25064C12.5108 1.25146 12.97 1.24902 13.3473 1.28277ZM9.60776 4.7507H14.4597C14.233 4.28331 14.088 3.98707 13.9566 3.7682C13.7643 3.44787 13.5339 3.30745 13.1691 3.27482C12.9098 3.25163 12.5719 3.2507 12.0345 3.2507C11.4837 3.2507 11.137 3.25166 10.8712 3.27585C10.4971 3.30991 10.2639 3.45568 10.0739 3.78866C9.94941 4.00687 9.81387 4.29897 9.60776 4.7507Z" fill="currentColor"/></svg>
												</button>
											</div>
										</div>
									</div>
								{/foreach}
							</div>
						{else}
							<div class="p-3">
								<div class="text-muted text-center py-5">
									<svg width="56" height="56" class="text-danger opacity-50" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M14.5528 2.23067C15.0468 1.98368 15.6474 2.1839 15.8944 2.67788L18.2429 7.37488H20.2198H20.2199H20.2199C20.5119 7.37487 20.768 7.37486 20.9785 7.38922C21.1985 7.40423 21.434 7.43785 21.6644 7.53946C22.0522 7.71041 22.3488 7.97226 22.5339 8.31652C22.7121 8.64768 22.7549 8.99516 22.7496 9.29243C22.7442 9.58775 22.6901 9.87651 22.6362 10.1175C22.6033 10.2645 22.4849 10.7579 22.4849 10.7579C22.4038 11.1429 22.144 11.4539 21.8031 11.6157C21.4336 11.791 21.1928 12.1137 21.1306 12.468L20.431 16.5305C20.3464 17.1057 20.2472 17.7798 20.0904 18.39C19.858 19.2949 19.4564 20.2759 18.6183 20.9496L18.6154 20.9519C17.9859 21.453 17.2478 21.6714 16.3692 21.7748C15.5183 21.8749 14.4502 21.8749 13.1152 21.8749H10.8848C9.54983 21.8749 8.48171 21.8749 7.63078 21.7748C6.75215 21.6714 6.01409 21.453 5.38455 20.9519L5.38167 20.9496C4.54362 20.2759 4.14201 19.2949 3.90958 18.39C3.75283 17.7798 3.65361 17.1057 3.56896 16.5306L2.86937 12.468C2.80715 12.1137 2.56639 11.791 2.19688 11.6157C1.85601 11.4539 1.59618 11.1429 1.51506 10.7579C1.51506 10.7579 1.39665 10.2645 1.36376 10.1175C1.30986 9.87651 1.25576 9.58775 1.25043 9.29243C1.24507 8.99516 1.28792 8.64768 1.46605 8.31652C1.65124 7.97226 1.94781 7.71041 2.33555 7.53946C2.56603 7.43785 2.80147 7.40423 3.02149 7.38922C3.23204 7.37486 3.48812 7.37487 3.7801 7.37488H3.78013H3.78016L7.04925 7.37488L9.08387 2.72431C9.30524 2.21833 9.89487 1.98761 10.4009 2.20897C10.9068 2.43034 11.1376 3.01997 10.9162 3.52595L9.23228 7.37488L16.0069 7.37488L14.1056 3.57231C13.8586 3.07833 14.0588 2.47766 14.5528 2.23067ZM9.25 12.1249C9.25 11.7107 9.58579 11.3749 10 11.3749L14 11.3749C14.4142 11.3749 14.75 11.7107 14.75 12.1249C14.75 12.5391 14.4142 12.8749 14 12.8749L10 12.8749C9.58579 12.8749 9.25 12.5391 9.25 12.1249Z" fill="currentColor"/></svg>
									<div class="text-md mt-4">
										<h5 class="headline-font m-0">
											{__("Your cart is empty")}
										</h5>
									</div>
								</div>
							</div>
						{/if}
						
						{if $addresses}
							<div class="pb-1 mt-3 headline-font fw-semibold h6 m-0">{__("Shipping Address")}</div>
							{foreach $addresses as $address}
								<div class="x_address p-2 mt-2">
									<div class="form-check m-0">
										<input class="form-check-input js_shipping-address" type="radio" name="shipping_address" id="shipping_address-{$address['address_id']}" value="{$address['address_id']}">
										<label class="form-check-label p-0" for="shipping_address-{$address['address_id']}">
											<strong class="fw-medium">{$address['address_title']}</strong> <span class="text-muted">({$address['address_details']}, {$address['address_city']} - {$address['address_country']})</span>
										</label>
									</div>
								</div>
							{/foreach}
							<!-- error -->
							<div class="alert alert-danger mt-2 mb-0 x-hidden" id="addresses-error">
								{__("Select a shipping address")}
							</div>
							<!-- error -->
						{/if}

						<hr class="hr-2">
						<div class="text-end">
							{__("Total Price")}
							<p>
								<span class="text-xxlg">
									{print_money(number_format($cart['total'], 2))}
								</span>
							</p>
						</div>
						<div class="text-end">
							<button type="button" class="btn btn-main btn-lg js_shopping-checkout" {if !$cart['items'] || !$addresses}disabled{/if}>
								{__("Checkout")}
							</button>
						</div>
					</div>
					<!-- Shopping Cart -->
				</div>
			</div>

		{elseif $view == "orders"}
			
			<div class="">
				<div class="px-3 pt-2 headline-font fw-semibold h4 m-0">
					{__("Orders")} {if !$query}({$orders_count}){/if}
					{if $query}
						<span class="text-muted small fw-normal"><small>{__("for")} "{$query}"</small></span>
					{/if}
				</div>

				{if $orders}
					<ul class="js_orders-stream">
						{foreach $orders as $order}
							{include file='_order.tpl'}
						{/foreach}
					</ul>
					
					<!-- see-more -->
					{if count($orders) >= $system['max_results']}
						<div class="alert alert-post see-more js_see-more" data-get="orders" data-target-stream=".js_orders-stream" {if $query}data-filter="{$query}" {/if}>
							<span>{__("See More")}</span>
							<div class="loader loader_small x-hidden"></div>
						</div>
					{/if}
					<!-- see-more -->
				{else}
					{include file='_no_data.tpl'}
				{/if}
			</div>

		{elseif $view == "sales"}

			<div class="px-3 pt-2">
				<div class="row">
					<div class="col-lg-4">
						<div class="stat-panel bg-info bg-opacity-10">
							<div class="stat-cell narrow">
								<div class="">{__("Total Orders")}</div>
								<div class="h3 m-0 mt-2">{$orders_count}</div>
							</div>
						</div>
					</div>
					<div class="col-lg-4">
						<div class="stat-panel bg-success bg-opacity-10">
							<div class="stat-cell narrow">
								<div class="">{__("This Month Earnings")}</div>
								<div class="h3 m-0 mt-2">{print_money($monthly_sales|number_format:2)}</div>
							</div>
						</div>
					</div>
					<div class="col-lg-4">
						<div class="stat-panel bg-success bg-opacity-10">
							<div class="stat-cell narrow">
								<div class="">{__("Total Earnings")}</div>
								<div class="h3 m-0 mt-2">{print_money($user->_data['user_market_balance']|number_format:2)}</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="px-3  headline-font fw-semibold h4 m-0">
				{__("Sales Orders")}
				{if $query}
					<span class="text-muted small fw-normal"><small>{__("for")} "{$query}"</small></span>
				{/if}
			</div>

			{if $orders}
				<ul class="js_orders-stream">
					{foreach $orders as $order}
						{include file='_order.tpl' sales = true}
					{/foreach}
				</ul>

				<!-- see-more -->
				{if count($orders) >= $system['max_results']}
					<div class="alert alert-post see-more js_see-more" data-get="sales_orders" data-target-stream=".js_orders-stream" {if $query}data-filter="{$query}" {/if}>
						<span>{__("See More")}</span>
						<div class="loader loader_small x-hidden"></div>
					</div>
				{/if}
				<!-- see-more -->
			{else}
				{include file='_no_data.tpl'}
			{/if}

		{/if}
	</div>
	<!-- center panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}