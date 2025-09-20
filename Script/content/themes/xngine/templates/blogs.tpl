{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="row x_content_row">
	{if $view == ""}
		<style>
		.search-wrapper-prnt {
		display: none !important
		}
		</style>

		<div class="col-lg-12 w-100">
			<div class="d-flex align-items-center p-3 position-sticky x_top_posts">
				<div class="d-flex align-items-center justify-content-between gap-10 position-relative">
					<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Blogs")}</span>
					<span class="flex-0 d-flex align-items-center gap-2">
						{if $system['newsfeed_location_filter_enabled']}
							<button type="button" class="btn btn-gray border-0 p-2 rounded-circle lh-1 flex-0" data-bs-toggle="modal" data-bs-target="#filter_modal">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" color="currentColor" fill="none"><path d="M22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12Z" stroke="currentColor" stroke-width="1.75" /><path d="M20 5.69899C19.0653 5.76636 17.8681 6.12824 17.0379 7.20277C15.5385 9.14361 14.039 9.30556 13.0394 8.65861C11.5399 7.6882 12.8 6.11636 11.0401 5.26215C9.89313 4.70542 9.73321 3.19045 10.3716 2" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M2 11C2.7625 11.6621 3.83046 12.2682 5.08874 12.2682C7.68843 12.2682 8.20837 12.7649 8.20837 14.7518C8.20837 16.7387 8.20837 16.7387 8.72831 18.2288C9.06651 19.1981 9.18472 20.1674 8.5106 21" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M22 13.4523C21.1129 12.9411 20 12.7308 18.8734 13.5405C16.7177 15.0898 15.2314 13.806 14.5619 15.0889C13.5765 16.9775 17.0957 17.5711 14 22" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /></svg>
							</button>
						{/if}
						{if $user->_data['can_write_blogs']}
							<a href="{$system['system_url']}/blogs/new" class="btn btn-sm btn-primary flex-0 d-none d-md-flex">
								<span class="my2">{__("Create Blog")}</span>
							</a>
							<a href="{$system['system_url']}/blogs/new" class="btn btn-primary flex-0 p-2 rounded-circle lh-1 d-md-none">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 3C12.5523 3 13 3.44772 13 4V11H20C20.5523 11 21 11.4477 21 12C21 12.5523 20.5523 13 20 13H13V20C13 20.5523 12.5523 21 12 21C11.4477 21 11 20.5523 11 20V13H4C3.44772 13 3 12.5523 3 12C3 11.4477 3.44772 11 4 11H11V4C11 3.44772 11.4477 3 12 3Z" fill="currentColor"/></svg>
							</a>
						{/if}
					</span>
				</div>
			</div>
			
			<div class="pt-3 pb-2 px-2 mx-1">
				<form class="js_search-form" data-filter="blogs">
					<div class="position-relative">
						<input type="search" class="form-control shadow-none rounded-pill x_search_filter" name="query" placeholder='{__("Search for blogs")}'>
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"></path></svg>
					</div>
				</form>
			</div>

			<!-- content panel -->
			<div class="p-3 pt-2">
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
		</div>
		
		<!-- Schema.org structured data for blogs listing page -->
		<script type="application/ld+json">
		{
		  "@context": "https://schema.org",
		  "@type": "CollectionPage",
		  "name": "{__("Blogs")|escape:'html'}",
		  "description": "{__($system['system_description_blogs'])|escape:'html'}",
		  "url": "{$system['system_url']}/blogs",
		  "publisher": {
			"@type": "Organization",
			"name": "{$system['system_title']|escape:'html'}",
			"url": "{$system['system_url']}"
		  },
		  "mainEntity": {
			"@type": "ItemList",
			"numberOfItems": "{if $blogs}{$blogs|count}{else}0{/if}",
			"itemListElement": [
			  {if $blogs}
				{foreach $blogs as $blog name=blogList}
				  {
					"@type": "ListItem",
					"position": {$smarty.foreach.blogList.iteration},
					"item": {
					  "@type": "BlogPosting",
					  "headline": "{$blog['blog']['title']|escape:'html'}",
					  "description": "{$blog['blog']['text']|strip_tags|truncate:150|escape:'html'}",
					  "image": "{if $blog['blog']['cover']}{$blog['blog']['parsed_cover']}{/if}",
					  "author": {
						"@type": "Person",
						"name": "{$blog['post_author_name']|escape:'html'}",
						"url": "{$blog['post_author_url']}"
					  },
					  "datePublished": "{$blog['time']}",
					  "url": "{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}",
					  "articleSection": "{__($blog['blog']['category_name'])|escape:'html'}"
					}
					}{if !$smarty.foreach.blogList.last},{/if}
				  {/foreach}
				{/if}
			  ]
			}
		  }
		</script>
		<!-- Schema.org structured data for blogs listing page -->

    {elseif $view == "category"}

		<!-- left panel -->
		<div class="col-lg-8">
			<div class="d-flex align-items-center p-3 position-sticky x_top_posts">
				<div class="d-flex align-items-center justify-content-between gap-10 position-relative">
					<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{$category['category_name']} {__("Blogs")}</span>
					<span class="flex-0 d-flex align-items-center gap-2">
						{if $user->_data['can_write_blogs']}
							<a href="{$system['system_url']}/blogs/new" class="btn btn-sm btn-primary flex-0 d-none d-md-flex">
								<span class="my2">{__("Create Blog")}</span>
							</a>
							<a href="{$system['system_url']}/blogs/new" class="btn btn-primary flex-0 p-2 rounded-circle lh-1 d-md-none">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 3C12.5523 3 13 3.44772 13 4V11H20C20.5523 11 21 11.4477 21 12C21 12.5523 20.5523 13 20 13H13V20C13 20.5523 12.5523 21 12 21C11.4477 21 11 20.5523 11 20V13H4C3.44772 13 3 12.5523 3 12C3 11.4477 3.44772 11 4 11H11V4C11 3.44772 11.4477 3 12 3Z" fill="currentColor"/></svg>
							</a>
						{/if}
					</span>
				</div>
			</div>
				
			{if $category['category_description']}
				<!-- category description -->
				<div class="posts-filter p-3">
					{__($category['category_description'])}
				</div>
				<!-- category description -->
			{/if}
			
			{if $blogs_categories}
				<!-- categories -->
				<div class="pt-3">
					<div class="overflow-hidden x_page_cats x_page_scroll d-flex align-items-start position-relative">
						<ul class="px-3 d-flex gap-2 align-items-center overflow-x-auto pb-3 scrolll">
							{foreach $blogs_categories as $category}
								<li>
									<a class="btn btn-sm" href="{$system['system_url']}/blogs/category/{$category['category_id']}/{$category['category_url']}">
										{__($category['category_name'])}
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

			<div class="p-3">
				{if $blogs}
					<ul class="row">
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
		
            {include file='_ads.tpl'}
            {include file='_widget.tpl'}

            <!-- read more -->
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Read More")}
				</h6>
				<div>
					{foreach $latest_blogs as $blog}
						{include file='__feeds_blog.tpl' _small=true}
					{/foreach}
				</div>
			</div>
            <!-- read more -->
			
			<!-- mini footer -->
			{include file='_footer_mini.tpl'}
			<!-- mini footer -->
		</div>
		<!-- right panel -->
		
		<!-- Schema.org structured data for blog category page -->
		<script type="application/ld+json">
		  {
			"@context": "https://schema.org",
			"@type": "CollectionPage",
			"name": "{__($category['category_name'])|escape:'html'}",
			"description": "{if $category['category_description']}{__($category['category_description'])|escape:'html'}{else}{__($category['category_name'])|escape:'html'} {__("blogs")|escape:'html'}{/if}",
			"url": "{$system['system_url']}/blogs/category/{$category['category_id']}/{$category['category_url']}",
			"publisher": {
			  "@type": "Organization",
			  "name": "{$system['system_title']|escape:'html'}",
			  "url": "{$system['system_url']}"
			},
			"mainEntity": {
			  "@type": "ItemList",
			  "numberOfItems": "{if $blogs}{$blogs|count}{else}0{/if}",
			  "itemListElement": [
				{if $blogs}
				  {foreach $blogs as $blog name=categoryBlogList}
					{
					  "@type": "ListItem",
					  "position": {$smarty.foreach.categoryBlogList.iteration},
					  "item": {
						"@type": "BlogPosting",
						"headline": "{$blog['blog']['title']|escape:'html'}",
						"description": "{$blog['blog']['text']|strip_tags|truncate:150|escape:'html'}",
						"image": "{if $blog['blog']['cover']}{$blog['blog']['parsed_cover']}{/if}",
						"author": {
						  "@type": "Person",
						  "name": "{$blog['post_author_name']|escape:'html'}",
						  "url": "{$blog['post_author_url']}"
						},
						"datePublished": "{$blog['time']}",
						"url": "{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}",
						"articleSection": "{__($blog['blog']['category_name'])|escape:'html'}"
					  }
					  }{if !$smarty.foreach.categoryBlogList.last},{/if}
					{/foreach}
				  {/if}
				]
			  }
			}
		</script>
		<!-- Schema.org structured data for blog category page -->

    {elseif $view == "blog"}

		<!-- left panel -->
		<div class="col-lg-8">
            {if $blog['needs_payment']}
                <div class="ptb20 plr20">
					{include file='_need_payment.tpl' post_id=$blog['post_id'] price=$blog['post_price'] paid_text=$blog['paid_text']}
                </div>
            {elseif $blog['needs_subscription']}
                <div class="ptb20 plr20">
					{include file='_need_subscription.tpl' node_type=$blog['needs_subscription_type'] node_id=$blog['needs_subscription_id'] price=$blog['needs_subscription_price']}
                </div>
            {elseif $blog['needs_pro_package']}
                <div class="ptb20 plr20">
					{include file='_need_pro_package.tpl' _manage = true}
                </div>
            {elseif $blog['needs_age_verification']}
                <div class="ptb20 plr20">
					{include file='_need_age_verification.tpl'}
                </div>
            {else}
				<div class="position-relative bg-white p-3 blog {if ($blog['is_pending']) OR ($blog['in_group'] && !$blog['group_approved']) OR ($blog['in_event'] && !$blog['event_approved'])}pending{/if}" data-id="{$blog['post_id']}">
					{if ($blog['is_pending']) OR ($blog['in_group'] && !$blog['group_approved']) OR ($blog['in_event'] && !$blog['event_approved'])}
						<div class="text-secondary fw-bold small mb-2 d-flex align-items-center gap-1">
							<svg xmlns="http://www.w3.org/2000/svg" height="15" viewBox="0 -960 960 960" width="15" fill="currentColor"><path d="M520-496v-144q0-17-11.5-28.5T480-680q-17 0-28.5 11.5T440-640v159q0 8 3 15.5t9 13.5l132 132q11 11 28 11t28-11q11-11 11-28t-11-28L520-496ZM480-80q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Z"></path></svg>
							{__("Pending Post")}
						</div>
					{/if}
					{if $blog['for_subscriptions']}
						<div class="main fw-bold small mb-2 d-flex align-items-center gap-1">
							<svg width="14" height="14" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M17.9982 13.25C18.67 13.25 19.12 13.7533 19.3627 14.245L19.3632 14.2459L20.0587 15.6484L20.0645 15.654C20.0693 15.6583 20.0749 15.663 20.0811 15.6676C20.0874 15.6722 20.0935 15.6763 20.0992 15.6798L20.1075 15.6844L21.3626 15.8947C21.9028 15.9855 22.4905 16.275 22.6893 16.8985C22.8877 17.521 22.5775 18.0974 22.1899 18.486L22.1889 18.487L21.2132 19.4708C21.2098 19.4778 21.2053 19.4888 21.2014 19.5027C21.197 19.5181 21.1949 19.5314 21.1942 19.5401L21.4735 20.7579C21.5995 21.3093 21.6116 22.0753 21.0171 22.5123C20.4194 22.9516 19.6913 22.7048 19.2061 22.4159L18.0294 21.7135C18.0283 21.702 18.0142 21.6859 17.9668 21.7142L16.7916 22.4156C16.3047 22.7069 15.5783 22.9496 14.9815 22.5106C14.3883 22.0742 14.397 21.3106 14.524 20.7572L14.8031 19.5401C14.8024 19.5314 14.8003 19.5181 14.7959 19.5027C14.792 19.4888 14.7875 19.4778 14.7841 19.4708L13.8065 18.4851C13.4213 18.0967 13.1123 17.5211 13.3091 16.8998C13.5068 16.2757 14.0941 15.9855 14.6351 15.8946L15.8859 15.6851L15.893 15.681C15.8987 15.6775 15.9049 15.6734 15.9113 15.6687C15.9176 15.6639 15.9233 15.6592 15.9282 15.6547L15.9345 15.6487L16.6315 14.2431C16.8762 13.7522 17.3273 13.25 17.9982 13.25Z" fill="currentColor"/><path d="M5.74919 6.5C5.74919 3.6005 8.0997 1.25 10.9992 1.25C13.8987 1.25 16.2492 3.6005 16.2492 6.5C16.2492 9.39949 13.8987 11.75 10.9992 11.75C8.0997 11.75 5.74919 9.39949 5.74919 6.5Z" fill="currentColor"/><path d="M14.439 14.3825C14.489 14.3525 14.514 14.3375 14.5301 14.3244C14.702 14.1856 14.6657 13.9073 14.4639 13.8172C14.4449 13.8087 14.4182 13.801 14.3648 13.7855C13.8202 13.628 13.0833 13.4302 12.6038 13.3625C11.5399 13.2125 10.4581 13.2125 9.39427 13.3625C7.9298 13.5691 6.49773 14.0602 5.19288 14.8372C5.07659 14.9064 4.93296 14.9874 4.77034 15.0792C4.05753 15.4813 2.9799 16.0893 2.24174 16.8118C1.78007 17.2637 1.34141 17.8592 1.26167 18.5888C1.17686 19.3646 1.51533 20.0927 2.19434 20.7396C3.36579 21.8556 4.77158 22.75 6.58989 22.75H12.2935C12.7003 22.75 12.9037 22.75 12.9933 22.6475C13.083 22.545 13.0507 22.3047 12.9861 21.8241C12.9094 21.2541 12.9885 20.7329 13.0599 20.4219L13.0898 20.2912C13.126 20.1337 13.144 20.055 13.1229 19.9808C13.1017 19.9066 13.0448 19.8493 12.931 19.7346L12.7395 19.5414C12.1778 18.9751 11.4358 17.84 11.8771 16.4469C12.3097 15.081 13.5273 14.5747 14.322 14.4264C14.3312 14.4247 14.3358 14.4238 14.339 14.4232C14.3713 14.4164 14.398 14.4063 14.4267 14.3899C14.4295 14.3883 14.4327 14.3864 14.439 14.3825Z" fill="currentColor"/></svg>
							{__("Subscriptions")}
						</div>
					{/if}
					{if $blog['is_paid']}
						<div class="text-success text-opacity-75 fw-bold small mb-2 d-flex align-items-center gap-1">
							<svg width="14" height="14" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M7.78894 3.38546C7.87779 3.52092 7.77748 3.75186 7.57686 4.21374C7.49965 4.39151 7.42959 4.57312 7.36705 4.75819C7.29287 4.9777 7.25578 5.08746 7.17738 5.14373C7.09897 5.19999 6.99012 5.19999 6.77242 5.19999H4.18138C3.64164 5.19999 3.2041 5.63651 3.2041 6.17499C3.2041 6.71346 3.64164 7.14998 4.18138 7.14998L15.9776 7.14998C16.8093 7.13732 18.6295 7.14275 19.2563 7.26578C20.1631 7.3874 20.9639 7.65257 21.6051 8.29227C22.2463 8.93197 22.512 9.73091 22.6339 10.6355C22.7501 11.4972 22.75 12.5859 22.75 13.9062V15.9937C22.75 17.314 22.7501 18.4027 22.6339 19.2644C22.512 20.169 22.2463 20.9679 21.6051 21.6076C20.9639 22.2473 20.1631 22.5125 19.2563 22.6341C18.3927 22.75 17.3014 22.75 15.978 22.7499H9.97398C8.19196 22.7499 6.75559 22.75 5.6259 22.5984C4.45303 22.4411 3.4655 22.1046 2.68119 21.3221C1.89687 20.5396 1.55952 19.5543 1.40184 18.3842C1.24996 17.2572 1.24998 15.8241 1.25 14.0463V6.175C1.25 4.55957 2.56262 3.25001 4.18182 3.25001L6.99624 3.25C7.46547 3.25 7.70009 3.25 7.78894 3.38546ZM17.5 12.9998C18.6046 12.9998 19.5 13.8952 19.5 14.9998C19.5 16.1043 18.6046 16.9998 17.5 16.9998C16.3954 16.9998 15.5 16.1043 15.5 14.9998C15.5 13.8952 16.3954 12.9998 17.5 12.9998Z" fill="currentColor"/><path d="M19.4557 6.03151C19.563 6.0463 19.6555 5.95355 19.6339 5.84742C19.1001 3.22413 16.7803 1.25 13.9994 1.25C11.3264 1.25 9.07932 3.07399 8.43503 5.54525C8.38746 5.72772 8.52962 5.90006 8.7182 5.90006L15.9679 5.90006C16.3968 5.89365 17.0712 5.89192 17.7232 5.90742C18.3197 5.92161 19.0159 5.95164 19.4557 6.03151Z" fill="currentColor"/></svg>
							{__("Paid")}
						</div>
					{/if}
					
					<div class="blog-wrapper">
						<div class="d-flex align-items-center justify-content-between gap-2">
							<a class="fw-semibold main" href="{$system['system_url']}/blogs/category/{$blog['blog']['category_id']}/{$blog['blog']['category_url']}">
								{__($blog['blog']['category_name'])}
							</a>
							{if $blog['manage_post']}
								<a type="button" class="btn btn-sm btn-light" href="{$system['system_url']}/blogs/edit/{$blog['post_id']}">
									{__("Edit")}
								</a>
							{/if}
						</div>

						<!-- blog title -->
						<h1 class="fw-bold">{$blog['blog']['title']}</h1>
						<!-- blog title -->

						<!-- blog meta -->
						<div class="d-flex justify-content-between x_user_info post-header mt-3">
							<div class="d-flex position-relative mw-0">
								<!-- post picture -->
								<div class="post-avatar position-relative flex-0">
									<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$blog['post_author_url']}" style="background-image:url({$blog['post_author_picture']});"></a>
								</div>
								<!-- post picture -->
								<div class="mw-0 mx-2">
									<!-- post meta -->
									<div class="post-meta">
										<!-- post author -->
										<span class="js_user-popover" data-type="{$blog['user_type']}" data-uid="{$blog['user_id']}">
											<a class="post-author fw-semibold body-color" href="{$blog['post_author_url']}">{$blog['post_author_name']}</a>
										</span>
										{if $blog['post_author_verified']}
											<span class="verified-badge" data-bs-toggle="tooltip" title='{if $blog['user_type'] == "user"}{__("Verified User")}{else}{__("Verified Page")}{/if}'>
												<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
											</span>
										{/if}
										{if $blog['user_subscribed']}
										<span class="pro-badge" data-bs-toggle="tooltip" title='{__("Pro User")}'>
											<svg xmlns="http://www.w3.org/2000/svg" height="17" viewBox="0 0 24 24" width="17"><path d="M0 0h24v24H0z" fill="none"></path><path fill="currentColor" d="M12 2.02c-5.51 0-9.98 4.47-9.98 9.98s4.47 9.98 9.98 9.98 9.98-4.47 9.98-9.98S17.51 2.02 12 2.02zm-.52 15.86v-4.14H8.82c-.37 0-.62-.4-.44-.73l3.68-7.17c.23-.47.94-.3.94.23v4.19h2.54c.37 0 .61.39.45.72l-3.56 7.12c-.24.48-.95.31-.95-.22z"></path></svg>
										</span>
										{/if}

										<!-- post time & location & privacy -->
										<div class="post-time text-muted">
											{__("Posted")} <span class="js_moment" data-time="{$blog['time']}">{$blog['time']}</span>
											<span class="fw-bold mx-1">·</span>
											<span class="">{$blog['views_formatted']} {__("Views")}</span>
										</div>
										<!-- post time & location & privacy -->
									</div>
									<!-- post meta -->
								</div>
							</div>
							
							<div class="flex-0">
								<a class="btn p-0 btn-sm unselectable" href="#blog-comments">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" color="currentColor" fill="none" class="position-relative"><path d="M14.1706 20.8905C18.3536 20.6125 21.6856 17.2332 21.9598 12.9909C22.0134 12.1607 22.0134 11.3009 21.9598 10.4707C21.6856 6.22838 18.3536 2.84913 14.1706 2.57107C12.7435 2.47621 11.2536 2.47641 9.8294 2.57107C5.64639 2.84913 2.31441 6.22838 2.04024 10.4707C1.98659 11.3009 1.98659 12.1607 2.04024 12.9909C2.1401 14.536 2.82343 15.9666 3.62791 17.1746C4.09501 18.0203 3.78674 19.0758 3.30021 19.9978C2.94941 20.6626 2.77401 20.995 2.91484 21.2351C3.05568 21.4752 3.37026 21.4829 3.99943 21.4982C5.24367 21.5285 6.08268 21.1757 6.74868 20.6846C7.1264 20.4061 7.31527 20.2668 7.44544 20.2508C7.5756 20.2348 7.83177 20.3403 8.34401 20.5513C8.8044 20.7409 9.33896 20.8579 9.8294 20.8905C11.2536 20.9852 12.7435 20.9854 14.1706 20.8905Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M11.9953 12H12.0043M15.9908 12H15.9998M7.99982 12H8.00879" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg> {$blog['comments_formatted']}
								</a>
							</div>
						</div>
						<!-- blog meta -->

						<!-- blog cover -->
						{if $blog['blog']['cover']}
							<div class="mt-3">
								<img class="img-fluid rounded-4" src="{$blog['blog']['parsed_cover']}">
							</div>
						{/if}
						<!-- blog cover -->

						<!-- blog text -->
						<div class="blog-text text-with-list mt-2" dir="auto">
							{$blog['blog']['parsed_text']}
						</div>
						<!-- blog text -->

						<!-- blog tags -->
						{if $blog['blog']['parsed_tags']}
							<div class="blog-tags d-flex align-items-center flex-wrap gap-2">
								{foreach $blog['blog']['parsed_tags'] as $tag}
									<a href="{$system['system_url']}/search/hashtag/{$tag}" class="main">#{__($tag)}</a>
								{/foreach}
							</div>
						{/if}
						<!-- blog tags -->

						<!-- post stats -->
						<div class="post-stats d-flex align-items-center">
							<!-- reactions stats -->
							{if $blog['reactions_total_count'] > 0}
								<div class="pointer" data-toggle="modal" data-url="posts/who_reacts.php?post_id={$blog['post_id']}">
									<div class="reactions-stats d-flex align-items-center">
										{foreach $blog['reactions'] as $reaction_type => $reaction_count}
											{if $reaction_count > 0}
												<div class="reactions-stats-item bg-white rounded-circle position-relative d-inline-flex align-middle align-items-center justify-content-center">
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
							<div class="post-actions d-flex align-items-center justify-content-between">
								<!-- reactions -->
								<div class="action-btn position-relative rounded-circle main_bg_half p-2 lh-1 pointer unselectable reactions-wrapper {if $blog['i_react']}js_unreact-post{/if}" data-reaction="{$blog['i_reaction']}">
									<!-- reaction-btn -->
									<div class="reaction-btn position-relative">
										{if !$blog['i_react']}
											<div class="reaction-btn-icon">
												<i class="far fa-smile fa-fw action-icon"></i>
											</div>
											<span class="reaction-btn-name d-none">{__("React")}</span>
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
								<div class="action-btn position-relative rounded-circle main_bg_half p-2 lh-1 pointer js_comment {if $blog['comments_disabled']}x-hidden{/if}">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="position-relative"><path d="M14.1706 20.8905C18.3536 20.6125 21.6856 17.2332 21.9598 12.9909C22.0134 12.1607 22.0134 11.3009 21.9598 10.4707C21.6856 6.22838 18.3536 2.84913 14.1706 2.57107C12.7435 2.47621 11.2536 2.47641 9.8294 2.57107C5.64639 2.84913 2.31441 6.22838 2.04024 10.4707C1.98659 11.3009 1.98659 12.1607 2.04024 12.9909C2.1401 14.536 2.82343 15.9666 3.62791 17.1746C4.09501 18.0203 3.78674 19.0758 3.30021 19.9978C2.94941 20.6626 2.77401 20.995 2.91484 21.2351C3.05568 21.4752 3.37026 21.4829 3.99943 21.4982C5.24367 21.5285 6.08268 21.1757 6.74868 20.6846C7.1264 20.4061 7.31527 20.2668 7.44544 20.2508C7.5756 20.2348 7.83177 20.3403 8.34401 20.5513C8.8044 20.7409 9.33896 20.8579 9.8294 20.8905C11.2536 20.9852 12.7435 20.9854 14.1706 20.8905Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M11.9953 12H12.0043M15.9908 12H15.9998M7.99982 12H8.00879" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
									<span class="d-none">{__("Comment")}</span>
								</div>
								<!-- comment -->

								<!-- share -->
								{if $blog['privacy'] == "public"}
									<div class="action-btn position-relative rounded-circle main_bg_half p-2 lh-1 pointer" data-toggle="modal" data-url="posts/share.php?do=create&post_id={$blog['post_id']}">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="position-relative"><path d="M18 7C18.7745 7.16058 19.3588 7.42859 19.8284 7.87589C21 8.99181 21 10.7879 21 14.38C21 17.9721 21 19.7681 19.8284 20.8841C18.6569 22 16.7712 22 13 22H11C7.22876 22 5.34315 22 4.17157 20.8841C3 19.7681 3 17.9721 3 14.38C3 10.7879 3 8.99181 4.17157 7.87589C4.64118 7.42859 5.2255 7.16058 6 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M12.0253 2.00052L12 14M12.0253 2.00052C11.8627 1.99379 11.6991 2.05191 11.5533 2.17492C10.6469 2.94006 9 4.92886 9 4.92886M12.0253 2.00052C12.1711 2.00657 12.3162 2.06476 12.4468 2.17508C13.3531 2.94037 15 4.92886 15 4.92886" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										<span class="d-none">{__("Share")}</span>
									</div>
								{/if}
								<!-- share -->

								<!-- tips -->
								{if $user->_logged_in && $blog['author_id'] != $user->_data['user_id'] && $blog['tips_enabled']}
									<div class="action-btn position-relative rounded-circle main_bg_half p-2 lh-1 pointer" data-toggle="modal" data-url="#send-tip" data-options='{ "id": "{$blog['author_id']}"}'>
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="position-relative"><path d="M19.7453 13C20.5362 11.8662 21 10.4872 21 9C21 5.13401 17.866 2 14 2C10.134 2 7 5.134 7 9C7 10.0736 7.24169 11.0907 7.67363 12" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M14 6C12.8954 6 12 6.67157 12 7.5C12 8.32843 12.8954 9 14 9C15.1046 9 16 9.67157 16 10.5C16 11.3284 15.1046 12 14 12M14 6C14.8708 6 15.6116 6.4174 15.8862 7M14 6V5M14 12C13.1292 12 12.3884 11.5826 12.1138 11M14 12V13" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M3 14H5.39482C5.68897 14 5.97908 14.0663 6.24217 14.1936L8.28415 15.1816C8.54724 15.3089 8.83735 15.3751 9.1315 15.3751H10.1741C11.1825 15.3751 12 16.1662 12 17.142C12 17.1814 11.973 17.2161 11.9338 17.2269L9.39287 17.9295C8.93707 18.0555 8.449 18.0116 8.025 17.8064L5.84211 16.7503M12 16.5L16.5928 15.0889C17.407 14.8352 18.2871 15.136 18.7971 15.8423C19.1659 16.3529 19.0157 17.0842 18.4785 17.3942L10.9629 21.7305C10.4849 22.0063 9.92094 22.0736 9.39516 21.9176L3 20.0199" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										<span class="ml5 d-none">{__("Tip")}</span>
									</div>
								{/if}
								<!-- tips -->
							</div>
						{/if}
						<!-- post actions -->
					</div>

					<!-- post footer -->
					<div class="post-footer pt-3 mt-3" id="blog-comments">
						{if $user->_logged_in}
							<!-- comments -->
							{include file='__feeds_post.comments.tpl' post=$blog}
							<!-- comments -->
						{else}
							<div class="d-flex">
								<div class="post_empty_space flex-0"></div>
								<div class="flex-1">
									<div class="small">
										<a href="{$system['system_url']}/signin" class="d-inline-flex align-items-center gap-2">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M11.5 2C6.21 2.24942 2 6.43482 2 11.5606C2 14.1004 3.03333 16.4082 4.71889 18.1208C5.09 18.4979 5.33778 19.0131 5.23778 19.5433C5.07275 20.4103 4.69874 21.2189 4.15111 21.8929C5.59195 22.1611 7.09014 21.9196 8.37499 21.2359C8.82918 20.9943 9.05627 20.8734 9.21653 20.8489C9.37678 20.8244 9.60633 20.8676 10.0654 20.9538C10.7032 21.0737 11.3507 21.1337 12 21.1329C17.5222 21.1329 22 16.8468 22 11.5606C22 11.3702 21.9942 11.1812 21.9827 10.9935" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M15.015 2.38661C16.0876 1.74692 17.0238 2.00471 17.5863 2.41534C17.8169 2.58371 17.9322 2.66789 18 2.66789C18.0678 2.66789 18.1831 2.58371 18.4137 2.41534C18.9762 2.00471 19.9124 1.74692 20.985 2.38661C22.3928 3.22614 22.7113 5.99577 19.4642 8.33241C18.8457 8.77747 18.5365 9 18 9C17.4635 9 17.1543 8.77747 16.5358 8.33241C13.2887 5.99577 13.6072 3.22614 15.015 2.38661Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M11.9955 12H12.0045M15.991 12H16M8 12H8.00897" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>{__("Please log in to like, share and comment!")}
										</a>
									</div>
								</div>
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

            {include file='_ads.tpl'}
            {include file='_widget.tpl'}

            <!-- blogs categories -->
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Categories")}
				</h6>
				<div class="px-3 pb-3 x_page_cats h-100">
					<ul class="d-flex align-items-center flex-wrap gap-2">
						{foreach $blogs_categories as $category}
							<li>
								<a class="btn btn-sm" href="{$system['system_url']}/blogs/category/{$category['category_id']}/{$category['category_url']}">{__($category['category_name'])}</a>
							</li>
						{/foreach}
					</ul>
				</div>
			</div>
            <!-- blogs categories -->
			
			<!-- read more -->
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Read More")}
				</h6>
				<div>
					{foreach $latest_blogs as $blog}
						{include file='__feeds_blog.tpl' _small=true}
					{/foreach}
				</div>
			</div>
            <!-- read more -->
			
			<!-- mini footer -->
			{include file='_footer_mini.tpl'}
			<!-- mini footer -->
		</div>
		<!-- right panel -->
		
		<!-- Schema.org structured data for blog post -->
		<script type="application/ld+json">
		{
		  "@context": "https://schema.org",
		  "@type": "BlogPosting",
		  "headline": "{$blog['blog']['title']|escape:'html'}",
		  "description": "{$blog['blog']['text']|strip_tags|truncate:200|escape:'html'}",
		  "image": "{if $blog['blog']['cover']}{$blog['blog']['parsed_cover']}{/if}",
		  "author": {
			"@type": "Person",
			"name": "{$blog['post_author_name']|escape:'html'}",
			"url": "{$blog['post_author_url']}"
		  },
		  "publisher": {
			"@type": "Organization",
			"name": "{$system['system_title']|escape:'html'}",
			"url": "{$system['system_url']}"
		  },
		  "datePublished": "{$blog['time']}",
		  "dateModified": "{$blog['time']}",
		  "mainEntityOfPage": {
			"@type": "WebPage",
			"@id": "{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}"
		  },
		  "url": "{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}",
		  "articleSection": "{__($blog['blog']['category_name'])|escape:'html'}",
		  "keywords": "{if $blog['blog']['parsed_tags']}{foreach $blog['blog']['parsed_tags'] as $tag}{$tag|escape:'html'}{if !$tag@last}, {/if}{/foreach}{/if}",
		  "wordCount": "{$blog['blog']['text']|strip_tags|strlen}",
		  "commentCount": "{$blog['comments_count']}",
		  "interactionStatistic": [{
			  "@type": "InteractionCounter",
			  "interactionType": "https://schema.org/CommentAction",
			  "userInteractionCount": "{$blog['comments_count']}"
			},
			{
			  "@type": "InteractionCounter",
			  "interactionType": "https://schema.org/ViewAction",
			  "userInteractionCount": "{$blog['views_count']}"
			}
		  ]
		}
		</script>
		<!-- Schema.org structured data for blog post -->

    {elseif $view == "edit"}

		<!-- content panel -->
		<div class="col-lg-8">
			<div class="d-flex align-items-center p-3 position-sticky x_top_posts">
				<div class="d-flex align-items-center justify-content-between gap-10 position-relative">
					<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Edit Blog")}</span>
					<span class="flex-0">
						<a href="{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}" class="btn btn-sm flex-0">
							<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg> <span class="my2">{__("Go Back")}</span>
						</a>
					</span>
				</div>
			</div>
		
			<div class="js_ajax-forms-html p-3" data-url="posts/blog.php?do=edit&id={$blog['post_id']}">
				<div class="form-floating">
					<select class="form-select" name="category">
						<option>{__("Select Category")}</option>
						{foreach $blogs_categories as $category}
							{include file='__categories.recursive_options.tpl' data_category=$blog['blog']['category_id']}
						{/foreach}
					</select>
					<label class="form-label">{__("Category")}</label>
				</div>
				
				<div class="form-floating">
					<input class="form-control" name="title" value="{$blog['blog']['title']}" placeholder=" ">
					<label class="form-label">{__("Title")}</label>
				</div>
				
				<div class="form-floating">
					{if $blog['blog']['cover'] == ''}
						<div class="x-image w-100">
							<button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
							<div class="x-image-loader">
								<div class="progress x-progress">
									<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
								</div>
							</div>
							<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
							<input type="hidden" class="js_x-image-input" name="cover" value="">
						</div>
					{else}
						<div class="x-image w-100" style="background-image: url('{$system['system_uploads']}/{$blog['blog']['cover']}')">
							<button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'></button>
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
				
				<div class="form-floating">
					<textarea name="text" class="form-control js_wysiwyg" placeholder=" ">{$blog['blog']['text']}</textarea>
				</div>
				
				<div class="form-floating">
					<input class="form-control js_tagify" name="tags" value="{$blog['blog']['tags']}" placeholder=" ">
					<label class="form-label">{__("Tags")}</label>
					<div class="form-text">{__("Type a tag name and press Enter or Comma to add it")}</div>
				</div>
				
				{if ($user->_data['can_receive_tip'] && $blog['user_type'] != "page") || $user->_data['can_monetize_content']}
					<hr class="hr-2">
				{/if}
				
				<!-- enable tips -->
				{if $user->_data['can_receive_tip'] && $blog['user_type'] != "page"}
					<div class="form-table-row mb-2 pb-1">
						<div>
							<div class="form-label mb0">{__("Enable Tips")}</div>
							<div class="form-text d-none d-sm-block mt0">{__("Allow people to send you tips")}</div>
						</div>
						<div class="text-end align-self-center flex-0">
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
					<div class="form-table-row mb-2 pb-1 {if $blog['is_paid']}disabled{/if}" id="subscribers-toggle-wrapper">
						<div>
							<div class="form-label mb0">{__("Subscribers Only")}</div>
							<div class="form-text d-none d-sm-block mt0">{__("Share this post to")} {__("subscribers only")}</div>
						</div>
						<div class="text-end align-self-center flex-0">
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
					<div class="form-table-row mb-2 pb-1 {if $blog['for_subscriptions']}disabled{/if}" id="paid-toggle-wrapper">
						<div>
							<div class="form-label mb0">{__("Paid Post")}</div>
							<div class="form-text d-none d-sm-block mt0">{__("Set a price to your post")}</div>
						</div>
						<div class="text-end align-self-center flex-0">
							<label class="switch" for="paid_post">
								<input type="checkbox" name="paid_post" id="paid_post" class="js_publisher-paid-toggle" {if $blog['is_paid']} checked{/if} {if $blog['for_subscriptions']}disabled{/if}>
								<span class="slider round"></span>
							</label>
						</div>
					</div>
					<div class="x-hidden" id="paid-price-wrapper">
						<div class="d-flex mb-2 gap-3 x_pub_paid_post">
							<div class="set_desc flex-1 x-hidden" id="paid-text-wrapper">
								<label class="d-block fw-medium mb-2">{__("Description")}</label>
								<textarea class="form-control bg-transparent border-0 p-0" name="paid_post_text" rows="2" placeholder='{__("Paid Post Description")}'>{$blog['paid_text']}</textarea>
							</div>
							<div class="set_price flex-0">
								<label class="d-block fw-medium mb-2">{__('Price')} ({$system['system_currency']})</label>
								<input class="bg-transparent border-0 p-0" type="text" name="paid_post_price" placeholder="0.00" value="{$blog['post_price']}">
							</div>
						</div>
					</div>
				{/if}
				<!-- paid post -->
				
				<!-- error -->
				<div class="alert alert-danger mt15 mb0 x-hidden"></div>
				<!-- error -->
				
				<hr class="hr-2">
				
				<div class="text-end">
					<button type="button" class="btn text-danger js_delete-blog" data-id="{$blog['post_id']}">
						{__("Delete Blog")}
					</button>
					<button type="submit" class="btn btn-primary">{__("Publish")}</button>
				</div>
			</div>
		</div>
		<!-- content panel -->
		
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
		
		<!-- Schema.org structured data for blog edit page -->
		<script type="application/ld+json">
            {
              "@context": "https://schema.org",
              "@type": "WebPage",
              "name": "{__("Edit Blog")|escape:'html'}: {$blog['blog']['title']|escape:'html'}",
              "description": "{__("Edit blog post")|escape:'html'}: {$blog['blog']['title']|escape:'html'}",
              "url": "{$system['system_url']}/blogs/edit/{$blog['post_id']}",
              "publisher": {
                "@type": "Organization",
                "name": "{$system['system_title']|escape:'html'}",
                "url": "{$system['system_url']}"
              },
              "breadcrumb": {
                "@type": "BreadcrumbList",
                "itemListElement": [{
                    "@type": "ListItem",
                    "position": 1,
                    "name": "{$system['system_title']|escape:'html'}",
                    "item": "{$system['system_url']}"
                  },
                  {
                    "@type": "ListItem",
                    "position": 2,
                    "name": "{__("Blogs")|escape:'html'}",
                    "item": "{$system['system_url']}/blogs"
                  },
                  {
                    "@type": "ListItem",
                    "position": 3,
                    "name": "{$blog['blog']['title']|escape:'html'}",
                    "item": "{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}"
                  },
                  {
                    "@type": "ListItem",
                    "position": 4,
                    "name": "{__("Edit")|escape:'html'}",
                    "item": "{$system['system_url']}/blogs/edit/{$blog['post_id']}"
                  }
                ]
              },
              "mainEntity": {
                "@type": "BlogPosting",
                "headline": "{$blog['blog']['title']|escape:'html'}",
                "description": "{$blog['blog']['text']|strip_tags|truncate:200|escape:'html'}",
                "image": "{if $blog['blog']['cover']}{$blog['blog']['parsed_cover']}{/if}",
                "author": {
                  "@type": "Person",
                  "name": "{$blog['post_author_name']|escape:'html'}",
                  "url": "{$blog['post_author_url']}"
                },
                "datePublished": "{$blog['time']}",
                "dateModified": "{$blog['time']}",
                "url": "{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}"
              }
            }
		</script>
		<!-- Schema.org structured data for blog edit page -->

    {elseif $view == "new"}

		<!-- content panel -->
		<div class="col-lg-8">
			<div class="d-flex align-items-center p-3 position-sticky x_top_posts">
				<div class="d-flex align-items-center justify-content-between gap-10 position-relative">
					<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Create New Blog")}</span>
					<span class="flex-0">
						<a href="{$system['system_url']}/my/blogs" class="btn btn-sm flex-0">
							<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg> <span class="my2">{__("My Blogs")}</span>
						</a>
					</span>
				</div>
			</div>
			
			<div class="js_ajax-forms-html p-3" data-url="posts/blog.php?do=create">
				<div class="form-label fw-medium">
					{__("Publish To")}
                </div>
				<!-- publish to options -->
				<div class="d-flex align-items-center flex-wrap gap-3 mb-3 pb-1">
                    <!-- Timeline -->
                    <input class="x-hidden input-label" type="radio" name="publish_to" id="publish_to_timeline" value="timeline" {if $share_to == "timeline"}checked="checked" {/if} />
                    <label class="button-label m-0 px-3 py-2" for="publish_to_timeline">
						<div class="title m-0">{__("Timeline")}</div>
                    </label>
                    <!-- Timeline -->
                    <!-- Page -->
                    {if $system['pages_enabled'] && $pages}
						<input class="x-hidden input-label" type="radio" name="publish_to" id="publish_to_page" value="page" {if $share_to == "page"}checked="checked" {/if} />
						<label class="button-label m-0 px-3 py-2" for="publish_to_page">
							<div class="title m-0">{__("Page")}</div>
						</label>
                    {/if}
                    <!-- Page -->
                    <!-- Group -->
                    {if $system['groups_enabled'] && $groups}
						<input class="x-hidden input-label" type="radio" name="publish_to" id="publish_to_group" value="group" {if $share_to == "group"}checked="checked" {/if} />
						<label class="button-label m-0 px-3 py-2" for="publish_to_group">
							<div class="title m-0">{__("Group")}</div>
						</label>
                    {/if}
                    <!-- Group -->
                    <!-- Event -->
                    {if $system['events_enabled'] && $events}
						<input class="x-hidden input-label" type="radio" name="publish_to" id="publish_to_event" value="event" {if $share_to == "event"}checked="checked" {/if} />
						<label class="button-label m-0 px-3 py-2" for="publish_to_event">
							<div class="title m-0">{__("Event")}</div>
						</label>
                    {/if}
                    <!-- Event -->
				</div>
				<!-- publish to options -->
				
				<div id="js_publish-to-page" {if $share_to != "page"}class="x-hidden" {/if}>
					<div class="form-floating">
						<select class="form-select" name="page_id">
							{foreach $pages as $page}
								<option value="{$page['page_id']}" {if $share_to_page_id == $page['page_id']}selected{/if}>{$page['page_title']}</option>
							{/foreach}
						</select>
						<label class="form-label">{__("Select Page")}</label>
					</div>
				</div>

				<div id="js_publish-to-group" {if $share_to != "group"}class="x-hidden" {/if}>
					<div class="form-floating">
						<select class="form-select" name="group_id">
							{foreach $groups as $group}
								<option value="{$group['group_id']}" {if $share_to_group_id == $group['group_id']}selected{/if}>{$group['group_title']}</option>
							{/foreach}
						</select>
						<label class="form-label">{__("Select Group")}</label>
					</div>
				</div>

				<div id="js_publish-to-event" {if $share_to != "event"}class="x-hidden" {/if}>
					<div class="form-floating">
						<select class="form-select" name="event_id">
							{foreach $events as $event}
								<option value="{$event['event_id']}" {if $share_to_event_id == $event['event_id']}selected{/if}>{$event['event_title']}</option>
							{/foreach}
						</select>
						<label class="form-label">{__("Select Event")}</label>
					</div>
				</div>
				
				<hr class="hr-2">
				
				<div class="form-floating">
					<select class="form-select" name="category">
						<option>{__("Select Category")}</option>
						{foreach $blogs_categories as $category}
							{include file='__categories.recursive_options.tpl'}
						{/foreach}
					</select>
					<label class="form-label">{__("Category")}</label>
				</div>
				
				<div class="form-floating">
					<input class="form-control" name="title" placeholder=" ">
					<label class="form-label">{__("Title")}</label>
				</div>
				
				<div class="form-floating">
					<div class="x-image w-100">
						<button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
						<div class="x-image-loader">
							<div class="progress x-progress">
								<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
							</div>
						</div>
						<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
						<input type="hidden" class="js_x-image-input" name="cover">
					</div>
				</div>
				
				<div class="form-floating">
					<textarea name="text" class="form-control js_wysiwyg" placeholder=" "></textarea>
				</div>
				
				<div class="form-floating">
					<input class="form-control js_tagify" name="tags" placeholder=" ">
					<label class="form-label">{__("Tags")}</label>
					<div class="form-text">
						{__("Type a tag name and press Enter or Comma to add it")}
					</div>
				</div>
				
				{if $user->_data['can_receive_tip'] || $user->_data['can_monetize_content']}
					<hr class="hr-2">
				{/if}
				
				<!-- enable tips -->
				{if $user->_data['can_receive_tip']}
					<div class="form-table-row mb-2 pb-1">
						<div>
							<div class="form-label mb0">{__("Enable Tips")}</div>
							<div class="form-text d-none d-sm-block mt0">{__("Allow people to send you tips")}</div>
						</div>
						<div class="text-end align-self-center flex-0">
							<label class="switch" for="tips_enabled">
								<input type="checkbox" name="tips_enabled" id="tips_enabled">
								<span class="slider round"></span>
							</label>
						</div>
					</div>
				{/if}
				<!-- enable tips -->
				
				<!-- only for subscribers -->
				{if $user->_data['can_monetize_content']}
					<div class="form-table-row mb-2 pb-1" id="subscribers-toggle-wrapper">
						<div>
							<div class="form-label mb0">{__("Subscribers Only")}</div>
							<div class="form-text d-none d-sm-block mt0">{__("Share this post to")} {__("subscribers only")}</div>
						</div>
						<div class="text-end align-self-center flex-0">
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
					<div class="form-table-row mb-2 pb-1" id="paid-toggle-wrapper">
						<div>
							<div class="form-label mb0">{__("Paid Post")}</div>
							<div class="form-text d-none d-sm-block mt0">{__("Set a price to your post")}</div>
						</div>
						<div class="text-end align-self-center flex-0">
							<label class="switch" for="paid_post">
								<input type="checkbox" name="paid_post" id="paid_post" class="js_publisher-paid-toggle">
								<span class="slider round"></span>
							</label>
						</div>
					</div>
					<div class="x-hidden" id="paid-price-wrapper">
						<div class="d-flex mb-2 gap-3 x_pub_paid_post">
							<div class="set_desc flex-1 x-hidden" id="paid-text-wrapper">
								<label class="d-block fw-medium mb-2">{__("Description")}</label>
								<textarea class="form-control bg-transparent border-0 p-0" name="paid_post_text" rows="2" placeholder='{__("Paid Post Description")}'></textarea>
							</div>
							<div class="set_price flex-0">
								<label class="d-block fw-medium mb-2">{__('Price')} ({$system['system_currency']})</label>
								<input class="bg-transparent border-0 p-0" type="text" name="paid_post_price" placeholder="0.00">
							</div>
						</div>
					</div>
				{/if}
				<!-- paid post -->

				<!-- error -->
				<div class="alert alert-danger mt15 mb0 x-hidden"></div>
				<!-- error -->
		
				<hr class="hr-2">
				
				<div class="text-end">
					<button type="submit" class="btn btn-primary">{__("Publish")}</button>
				</div>
			</div>
		</div>
		<!-- content panel -->
		
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
		
		<!-- Schema.org structured data for blog creation page -->
		<script type="application/ld+json">
            {
              "@context": "https://schema.org",
              "@type": "WebPage",
              "name": "{__("Create New Blog")|escape:'html'}",
              "description": "{__("Create and publish a new blog post")|escape:'html'}",
              "url": "{$system['system_url']}/blogs/new",
              "publisher": {
                "@type": "Organization",
                "name": "{$system['system_title']|escape:'html'}",
                "url": "{$system['system_url']}"
              },
              "breadcrumb": {
                "@type": "BreadcrumbList",
                "itemListElement": [{
                    "@type": "ListItem",
                    "position": 1,
                    "name": "{$system['system_title']|escape:'html'}",
                    "item": "{$system['system_url']}"
                  },
                  {
                    "@type": "ListItem",
                    "position": 2,
                    "name": "{__("Blogs")|escape:'html'}",
                    "item": "{$system['system_url']}/blogs"
                  },
                  {
                    "@type": "ListItem",
                    "position": 3,
                    "name": "{__("Create New Blog")|escape:'html'}",
                    "item": "{$system['system_url']}/blogs/new"
                  }
                ]
              }
            }
		</script>
		<!-- Schema.org structured data for blog creation page -->
    {/if}

</div>
<!-- page content -->

<!-- location filter -->
{if $view == "" || $view == "category"}
	{if $system['newsfeed_location_filter_enabled']}
		<div class="modal fade" id="filter_modal" tabindex="-1">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">{__("Filter")}</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
			  
					<div class="modal-body">
						<label class="form-label fw-medium d-flex align-items-center gap-1 small">
							<svg width="14" height="14" class="flex-0" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M9.67752 20.4855C10.4174 20.6875 11.1961 20.7953 12 20.7953C12.6913 20.7953 13.3639 20.7156 14.0093 20.5648C14.3307 19.9605 14.4776 19.4829 14.5303 19.102C14.6018 18.5855 14.5081 18.1915 14.3586 17.8254C14.2834 17.6415 14.1803 17.4375 14.082 17.2433C13.9831 17.0477 13.8667 16.8162 13.7803 16.5734C13.5893 16.0372 13.5394 15.4284 13.8976 14.7419C14.1585 14.2419 14.5367 13.9512 14.9899 13.8083C15.3375 13.6987 15.8203 13.6782 16.1267 13.6653C16.8013 13.6345 17.5354 13.5789 18.4363 12.9314C19.2407 12.3532 20.0495 12.1908 20.7915 12.2677C20.7941 12.1788 20.7955 12.0895 20.7955 11.9999C20.7955 9.99664 20.1258 8.14982 18.998 6.67109C18.4992 6.85577 18.0138 7.16643 17.6315 7.66136C16.8187 8.71334 15.9471 9.36049 15.063 9.62066C14.1618 9.88583 13.3114 9.72806 12.6319 9.28831C11.6258 8.63716 11.4958 7.7271 11.4107 7.13117C11.3644 6.81979 11.3081 6.5283 11.2244 6.37345C11.1546 6.24443 11.0279 6.08994 10.7127 5.93693C9.92015 5.55225 9.471 4.84875 9.31521 4.09083C9.28482 3.94302 9.26529 3.7926 9.25612 3.64087C6.05016 4.6926 3.65688 7.5373 3.26198 10.9893C3.80225 11.3049 4.42081 11.518 5.08874 11.518C5.75485 11.518 6.32888 11.5491 6.81102 11.6394C7.29426 11.73 7.73816 11.8892 8.09861 12.1844C8.84883 12.7987 8.95837 13.7612 8.95837 14.7516C8.95837 15.7705 8.9604 16.1995 9.01512 16.5654C9.06753 16.916 9.16946 17.2163 9.43644 17.9815C9.59057 18.4233 9.80455 19.0503 9.79233 19.7264C9.78777 19.9791 9.75206 20.2335 9.67752 20.4855ZM1.25115 11.8409C1.25038 11.8938 1.25 11.9468 1.25 11.9999C1.25 17.9369 6.06294 22.7499 12 22.7499C12.7905 22.7499 13.561 22.6646 14.3029 22.5026L14.3214 22.4988C18.665 21.5427 22.0226 17.962 22.6466 13.5021C22.6481 13.491 22.6494 13.4799 22.6505 13.4688C22.7161 12.9886 22.75 12.4982 22.75 11.9999C22.75 6.06282 17.9371 1.24988 12 1.24988H11.9999C11.9548 1.24988 11.9099 1.25016 11.8649 1.25071C6.04305 1.3224 1.33552 6.02206 1.25115 11.8409Z" fill="currentColor"/></svg>
							{if $selected_country}{$selected_country['country_name']}{else}{__("All Countries")}{/if}
						</label>
						<div class="dropdown-menu position-relative w-100 d-block shadow-none countries-dropdown">
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
			</div>
		</div>
	{/if}
{/if}
<!-- location filter -->

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