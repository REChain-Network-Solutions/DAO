<div class="col-6 col-xl-3 pb-2 mb-4">
	<div class="position-relative product {if $_boosted}boosted{/if}">
		{if $_boosted}
			<div class="position-absolute m-2 rounded-2 fw-medium small text-white boosted-icon">
				{__("Promoted")}
			</div>
		{/if}
		{if $post['needs_subscription']}
			<a href="{$system['system_url']}/posts/{$post['post_id']}">
				{include file='_need_subscription.tpl'}
			</a>
		{else}
			<a href="{$system['system_url']}/posts/{$post['post_id']}" class="product-image d-block position-relative w-100 overflow-hidden">
				{if $post['photos_num'] > 0}
					<img src="{$system['system_uploads']}/{$post['photos'][0]['source']}" class="w-100 h-100">
				{else}
					<img src="{$system['system_url']}/content/themes/{$system['theme']}/images/blank_product.png" class="w-100 h-100">
				{/if}
				<div class="d-flex align-items-end gap-2 small text-white position-absolute p-2 stock_stat">
					<div class="d-flex align-items-center gap-2">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="15" height="15" color="currentColor" fill="none"><path d="M12 22C11.1818 22 10.4002 21.6698 8.83693 21.0095C4.94564 19.3657 3 18.5438 3 17.1613C3 16.7742 3 10.0645 3 7M12 22C12.8182 22 13.5998 21.6698 15.1631 21.0095C19.0544 19.3657 21 18.5438 21 17.1613V7M12 22L12 11.3548" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M8.32592 9.69138L5.40472 8.27785C3.80157 7.5021 3 7.11423 3 6.5C3 5.88577 3.80157 5.4979 5.40472 4.72215L8.32592 3.30862C10.1288 2.43621 11.0303 2 12 2C12.9697 2 13.8712 2.4362 15.6741 3.30862L18.5953 4.72215C20.1984 5.4979 21 5.88577 21 6.5C21 7.11423 20.1984 7.5021 18.5953 8.27785L15.6741 9.69138C13.8712 10.5638 12.9697 11 12 11C11.0303 11 10.1288 10.5638 8.32592 9.69138Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M6 12L8 13" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M17 4L7 9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
						<div class="d-flex">
							{if $post['product']['available']}
								{if $post['product']['quantity'] > 0}
									<span class="">{__("In stock")}</span>
								{else}
									<span class="text-danger">{__("Out of stock")}</span>
								{/if}
							{else}
								<span class="text-danger">{__("SOLD")}</span>
							{/if}
			  
							{if $post['product']['is_digital']}
								<span class="fw-bold mx-2">·</span><span>{__("Digital")}</span>
							{/if}
							
							{if $post['product']['status'] == "new"}
								<span class="fw-bold mx-2 d-none d-md-block">·</span><span class="d-none d-md-block">{__("New")}</span>
							{else}
								<span class="fw-bold mx-2 d-none d-md-block">·</span><span class="d-none d-md-block">{__("Used")}</span>
							{/if}
						</div>
					</div>
				</div>
			</a>
			<div class="mt-2">
				<h6 class="title text-truncate {if $system['posts_reviews_enabled']}mb-0{/if}"><a href="{$system['system_url']}/posts/{$post['post_id']}" class="body-color">{$post['product']['name']}</a></h6>
				
				{if $system['posts_reviews_enabled']}
					<div class="d-inline-flex align-items-center gap-2 small mb-2 pointer" data-toggle="modal" data-url="posts/who_reviews.php?post_id={$post['post_id']}">
						<span class="review-stars small">
							<i class="fa fa-star {if $post['post_rate'] >= 1}checked{/if}"></i>
							<i class="fa fa-star {if $post['post_rate'] >= 2}checked{/if}"></i>
							<i class="fa fa-star {if $post['post_rate'] >= 3}checked{/if}"></i>
							<i class="fa fa-star {if $post['post_rate'] >= 4}checked{/if}"></i>
							<i class="fa fa-star {if $post['post_rate'] >= 5}checked{/if}"></i>
						</span>
						<span class="">{$post['post_rate']|number_format:1}</span>
					</div>
				{/if}
				
				<h6 class="main text-truncate">
					{if $post['product']['price'] > 0}
						{print_money($post['product']['price'])}
					{else}
						{__("Free")}
					{/if}
				</h6>
		
				<div class="d-flex align-items-center gap-2 small">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="15" height="15" color="currentColor" fill="none" class="flex-0"><path d="M14.5 9C14.5 10.3807 13.3807 11.5 12 11.5C10.6193 11.5 9.5 10.3807 9.5 9C9.5 7.61929 10.6193 6.5 12 6.5C13.3807 6.5 14.5 7.61929 14.5 9Z" stroke="currentColor" stroke-width="1.75"></path><path d="M18.2222 17C19.6167 18.9885 20.2838 20.0475 19.8865 20.8999C19.8466 20.9854 19.7999 21.0679 19.7469 21.1467C19.1724 22 17.6875 22 14.7178 22H9.28223C6.31251 22 4.82765 22 4.25311 21.1467C4.20005 21.0679 4.15339 20.9854 4.11355 20.8999C3.71619 20.0475 4.38326 18.9885 5.77778 17" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M13.2574 17.4936C12.9201 17.8184 12.4693 18 12.0002 18C11.531 18 11.0802 17.8184 10.7429 17.4936C7.6543 14.5008 3.51519 11.1575 5.53371 6.30373C6.6251 3.67932 9.24494 2 12.0002 2C14.7554 2 17.3752 3.67933 18.4666 6.30373C20.4826 11.1514 16.3536 14.5111 13.2574 17.4936Z" stroke="currentColor" stroke-width="1.75"></path></svg>
					<span class="mw-0 text-truncate">{if $post['product']['location']}{$post['product']['location']}{else}{__("N/A")}{/if}</span>
				</div>
			</div>
		{/if}
	</div>
</div>