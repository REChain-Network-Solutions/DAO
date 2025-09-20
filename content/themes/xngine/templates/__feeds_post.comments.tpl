<div class="post-comments">
	{if $user->_logged_in}
		{if $_is_photo}

			<!-- sort comments -->
			{if $photo['comments'] > 0}
				<div class="comments-filter mb-2 pb-1">
					<div class="btn-group btn-group-sm js_comments-filter" data-value="photo_comments">
						<button type="button" class="btn btn-sm btn-gray dropdown-toggle px-2" data-bs-toggle="dropdown" data-display="static">
							<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M3 6H21M6 12H18M10 18H14" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/></svg>
							<span class="btn-group-text">{__("Most Recent")}</span>
						</button>
						<div class="dropdown-menu dropdown-menu-left">
							<div class="dropdown-item pointer" data-value="photo_comments" data-id="{$photo['photo_id']}">{__("Most Recent")}</div>
							<div class="dropdown-item pointer" data-value="photo_comments_top" data-id="{$photo['photo_id']}">{__("Top Comments")}</div>
							<div class="dropdown-item pointer" data-value="photo_comments_all" data-id="{$photo['photo_id']}">{__("All Comments")}</div>
						</div>
					</div>
				</div>
			{/if}
			<!-- sort comments -->

			<!-- post comment -->
			{include file='__feeds_comment.form.tpl' _handle='photo' _id=$photo['photo_id']}
			<!-- post comment -->

			<!-- comments loader -->
			<div class="text-center py-5 x-hidden js_comments-filter-loader">
				<div class="loader loader_large"></div>
			</div>
			<!-- comments loader -->

			<!-- comments -->
			<ul class="js_comments x_comms_list">{if $photo['comments'] > 0}
					{foreach $photo['photo_comments'] as $comment}
						{include file='__feeds_comment.tpl' _comment=$comment}
					{/foreach}
				{/if}</ul>
			<!-- comments -->

			<!-- previous comments -->
			{if $photo['comments'] >= $system['min_results']}
				<div class="main pointer px-3 text-center rounded-3 d-block side_item_hover side_item_list small fw-semibold js_see-more" data-get="photo_comments" data-id="{$photo['photo_id']}" data-remove="true" data-target-stream=".js_comments">
					<span class="">
						{__("View previous comments")}
					</span>
					<div class="loader loader_small x-hidden"></div>
				</div>
			{/if}
			<!-- previous comments -->

		{else}

			<!-- sort comments -->
			{if $post['comments'] > 0}
				<div class="comments-filter mb-2 pb-1">
					<div class="btn-group btn-group-sm js_comments-filter" data-value="post_comments">
						<button type="button" class="btn btn-sm btn-gray dropdown-toggle px-2" data-bs-toggle="dropdown" data-display="static">
							<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M3 6H21M6 12H18M10 18H14" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/></svg>
							<span class="btn-group-text">{__("Most Recent")}</span>
						</button>
						<div class="dropdown-menu dropdown-menu-left">
							<div class="dropdown-item pointer" data-value="post_comments" data-id="{$post['post_id']}">{__("Most Recent")}</div>
							<div class="dropdown-item pointer" data-value="post_comments_top" data-id="{$post['post_id']}">{__("Top Comments")}</div>
							<div class="dropdown-item pointer" data-value="post_comments_all" data-id="{$post['post_id']}">{__("All Comments")}</div>
						</div>
					</div>
				</div>
			{/if}
			<!-- sort comments -->

			<!-- post comment -->
			{include file='__feeds_comment.form.tpl' _handle='post' _id=$post['post_id']}
			<!-- post comment -->

			<!-- comments loader -->
			<div class="text-center py-5 x-hidden js_comments-filter-loader">
				<div class="loader loader_large"></div>
			</div>
			<!-- comments loader -->

			<!-- comments -->
			<ul class="js_comments x_comms_list {if $_live_comments}js_live-comments{/if}">{if $post['comments'] > 0}
					{foreach $post['post_comments'] as $comment}
						{include file='__feeds_comment.tpl' _comment=$comment}
					{/foreach}
				{/if}</ul>
			<!-- comments -->

			<!-- previous comments -->
			{if $post['comments'] >= $system['min_results']}
				<div class="main pointer px-3 text-center rounded-3 d-block side_item_hover side_item_list small fw-semibold js_see-more" data-get="post_comments" data-id="{$post['post_id']}" data-remove="true" data-target-stream=".js_comments">
					<span class="">
						{__("View previous comments")}
					</span>
					<div class="loader loader_small x-hidden"></div>
				</div>
			{/if}
			<!-- previous comments -->

		{/if}
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