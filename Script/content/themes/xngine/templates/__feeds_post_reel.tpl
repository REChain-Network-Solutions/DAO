<!-- post body -->
<div class="post-body px-3 pb-3 pt-2">
	<!-- post header -->
	<div class="d-flex x_user_info post-header">
		<!-- post picture -->
		<div class="post-avatar position-relative flex-0">
			{if $post['is_anonymous']}
				<div class="post-avatar-anonymous text-white rounded-circle overflow-hidden d-flex align-items-center justify-content-center">
					<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M7.13889 16.124C6.065 16.124 5.19444 16.9635 5.19444 17.999C5.19444 19.0346 6.065 19.874 7.13889 19.874C8.21278 19.874 9.08333 19.0346 9.08333 17.999C9.08333 16.9635 8.21278 16.124 7.13889 16.124ZM3.25 17.999C3.25 15.928 4.99112 14.249 7.13889 14.249C8.57833 14.249 9.83511 15.0031 10.5075 16.124H13.4925C14.1649 15.0031 15.4217 14.249 16.8611 14.249C19.0089 14.249 20.75 15.928 20.75 17.999C20.75 20.0701 19.0089 21.749 16.8611 21.749C14.7133 21.749 12.9722 20.0701 12.9722 17.999L11.0278 17.999C11.0278 20.0701 9.28666 21.749 7.13889 21.749C4.99112 21.749 3.25 20.0701 3.25 17.999ZM16.8611 16.124C15.7872 16.124 14.9167 16.9635 14.9167 17.999C14.9167 19.0346 15.7872 19.874 16.8611 19.874C17.935 19.874 18.8056 19.0346 18.8056 17.999C18.8056 16.9635 17.935 16.124 16.8611 16.124Z" fill="currentColor"/><path d="M5.31634 4.59645C5.6103 2.70968 7.67269 1.66315 9.35347 2.59225L9.96847 2.93221C11.2351 3.63236 12.7647 3.63236 14.0313 2.93221L14.6463 2.59225C16.3271 1.66315 18.3895 2.70968 18.6834 4.59644L19.7409 11.384C19.7788 11.6271 19.695 11.8734 19.5167 12.043C19.3383 12.2125 19.0882 12.2838 18.8472 12.2337C16.7318 11.7939 10.9673 11.1659 5.13538 12.2371C4.89638 12.281 4.65092 12.2064 4.47679 12.0369C4.30265 11.8674 4.22142 11.6241 4.25883 11.384L5.31634 4.59645Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M12.0005 11.9989C8.22613 11.9989 4.89604 12.6584 2.66477 13.6566C2.18196 13.8726 1.59501 13.6972 1.35376 13.265C1.11251 12.8327 1.30834 12.3072 1.79114 12.0912C4.3613 10.9414 8.00877 10.249 12.0005 10.249C15.9922 10.249 19.6397 10.9414 22.2098 12.0912C22.6926 12.3072 22.8885 12.8327 22.6472 13.265C22.406 13.6972 21.819 13.8726 21.3362 13.6566C19.1049 12.6584 15.7748 11.9989 12.0005 11.9989Z" fill="currentColor"/></svg>
				</div>
			{else}
				<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$post['post_author_url']}" style="background-image:url({$post['post_author_picture']});"></a>
				{if $post['post_author_online']}<span class="online-dot position-absolute rounded-circle"></span>{/if}
			{/if}
		</div>
		<!-- post picture -->
		<div class="mw-0 mx-2">
			<!-- post meta -->
			<div class="post-meta">
				<!-- post author -->
				{if $post['is_anonymous']}
					<span class="post-author fw-semibold">{__("Anonymous")}</span>
				{else}
					<span class="js_user-popover" data-type="{$post['user_type']}" data-uid="{$post['user_id']}">
						<a class="post-author fw-semibold body-color" href="{$post['post_author_url']}">{$post['post_author_name']}</a>
					</span>
					{if $post['post_author_verified']}
						<span class="verified-badge" data-bs-toggle="tooltip" {if $post['user_type'] == "user"}title='{__("Verified User")}'{else}title='{__("Verified Page")}'{/if}>
							<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
						</span>
					{/if}
					{if $post['user_subscribed']}
						<span class="pro-badge" data-bs-toggle="tooltip" title='{__($post['package_name'])} {__("Member")}'>
							<svg xmlns='http://www.w3.org/2000/svg' height='17' viewBox='0 0 24 24' width='17'><path d='M0 0h24v24H0z' fill='none'></path><path fill='currentColor' d='M12 2.02c-5.51 0-9.98 4.47-9.98 9.98s4.47 9.98 9.98 9.98 9.98-4.47 9.98-9.98S17.51 2.02 12 2.02zm-.52 15.86v-4.14H8.82c-.37 0-.62-.4-.44-.73l3.68-7.17c.23-.47.94-.3.94.23v4.19h2.54c.37 0 .61.39.45.72l-3.56 7.12c-.24.48-.95.31-.95-.22z'></path></svg>
						</span>
					{/if}
					{if $post['user_type'] == "user"}
						<span class="text-muted small">@{$post['user_name']}</span>
					{/if}
					{if $post['user_type'] == "page"}
						<span class="text-muted small">@{$post['page_name']}</span>
					{/if}
				{/if}
				<!-- post author -->

				<!-- post time & location & privacy -->
				<div class="post-time text-muted">
					<a href="{$system['system_url']}/posts/{$post['post_id']}" class="js_moment text-muted" data-time="{$post['time']}">{$post['time']}</a>
					<span class="fw-bold mx-1">·</span>
					{if $post['privacy'] == "me"}
						<i class="fa fa-user-lock flex-0 privacy-icon" data-bs-toggle="tooltip" title='{__("Shared with")} {__("Only Me")}'></i>
					{elseif $post['privacy'] == "friends"}
						<i class="fa fa-user-friends flex-0 privacy-icon" data-bs-toggle="tooltip" title='{__("Shared with")} {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}'></i>
					{elseif $post['privacy'] == "public"}
						<i class="fa fa-globe-americas flex-0 privacy-icon" data-bs-toggle="tooltip" title='{__("Shared with")} {__("Public")}'></i>
					{elseif $post['privacy'] == "custom"}
						<i class="fa fa-cog privacy-icon" data-bs-toggle="tooltip" title='{__("Shared with")} {__("Custom People")}'></i>
					{/if}
				</div>
				<!-- post time & location & privacy -->
			</div>
			<!-- post meta -->
		</div>
	</div>
	<!-- post header -->

	<!-- post stats -->
	<div class="post-stats d-flex align-items-center mt-2 pt-1">
		<!-- reactions stats -->
		{if $post['reactions_total_count'] > 0}
			<div class="pointer" data-toggle="modal" data-url="posts/who_reacts.php?post_id={$post['post_id']}">
				<div class="reactions-stats d-flex align-items-center">
					{foreach $post['reactions'] as $reaction_type => $reaction_count}
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
						{$post['reactions_total_count_formatted']}
					</span>
					<!-- reactions count -->
				</div>
			</div>
			<span class="fw-bold mx-1">·</span>
		{/if}
		<!-- reactions stats -->
		
		<!-- comments -->
		<span class="pointer js_comments-toggle">
			{$post['comments_formatted']} {__("Comments")}
		</span>
		<!-- comments -->
		
		<!-- shares -->
		<span class="pointer {if $post['shares'] == 0}x-hidden{/if}" data-toggle="modal" data-url="posts/who_shares.php?post_id={$post['post_id']}">
			<span class="fw-bold mx-1">·</span>{$post['shares_formatted']} {__("Shares")}
		</span>
		<!-- shares -->
	</div>
	<!-- post stats -->

	<!-- post actions -->
	{if $user->_logged_in}
		<div class="post-actions d-flex align-items-center justify-content-between">
			<!-- reactions -->
			<div class="action-btn position-relative rounded-circle main_bg_half p-2 lh-1 pointer unselectable reactions-wrapper {if $post['i_react']}js_unreact-post{/if}" data-reaction="{$post['i_reaction']}">
				<!-- reaction-btn -->
				<div class="reaction-btn position-relative">
					{if !$post['i_react']}
						<div class="reaction-btn-icon">
							<i class="far fa-smile fa-fw action-icon"></i>
						</div>
						<span class="reaction-btn-name d-none">{__("React")}</span>
					{else}
						<div class="reaction-btn-icon">
							<div class="inline-emoji no_animation">
								{include file='__reaction_emojis.tpl' _reaction=$post['i_reaction']}
							</div>
						</div>
						<span class="reaction-btn-name" style="color: {$reactions[$post['i_reaction']]['color']};">{__($reactions[$post['i_reaction']]['title'])}</span>
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
			<div class="action-btn position-relative rounded-circle main_bg_half p-2 lh-1 pointer js_comment {if $post['comments_disabled']}x-hidden{/if}">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="position-relative"><path d="M14.1706 20.8905C18.3536 20.6125 21.6856 17.2332 21.9598 12.9909C22.0134 12.1607 22.0134 11.3009 21.9598 10.4707C21.6856 6.22838 18.3536 2.84913 14.1706 2.57107C12.7435 2.47621 11.2536 2.47641 9.8294 2.57107C5.64639 2.84913 2.31441 6.22838 2.04024 10.4707C1.98659 11.3009 1.98659 12.1607 2.04024 12.9909C2.1401 14.536 2.82343 15.9666 3.62791 17.1746C4.09501 18.0203 3.78674 19.0758 3.30021 19.9978C2.94941 20.6626 2.77401 20.995 2.91484 21.2351C3.05568 21.4752 3.37026 21.4829 3.99943 21.4982C5.24367 21.5285 6.08268 21.1757 6.74868 20.6846C7.1264 20.4061 7.31527 20.2668 7.44544 20.2508C7.5756 20.2348 7.83177 20.3403 8.34401 20.5513C8.8044 20.7409 9.33896 20.8579 9.8294 20.8905C11.2536 20.9852 12.7435 20.9854 14.1706 20.8905Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M11.9953 12H12.0043M15.9908 12H15.9998M7.99982 12H8.00879" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
				<span class="d-none">{__("Comment")}</span>
			</div>
			<!-- comment -->
			
			<!-- share -->
			{if $post['privacy'] == "public"}
				<div class="action-btn position-relative rounded-circle main_bg_half p-2 lh-1 pointer" data-toggle="modal" data-url="posts/share.php?do=create&post_id={$post['post_id']}">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="position-relative"><path d="M18 7C18.7745 7.16058 19.3588 7.42859 19.8284 7.87589C21 8.99181 21 10.7879 21 14.38C21 17.9721 21 19.7681 19.8284 20.8841C18.6569 22 16.7712 22 13 22H11C7.22876 22 5.34315 22 4.17157 20.8841C3 19.7681 3 17.9721 3 14.38C3 10.7879 3 8.99181 4.17157 7.87589C4.64118 7.42859 5.2255 7.16058 6 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M12.0253 2.00052L12 14M12.0253 2.00052C11.8627 1.99379 11.6991 2.05191 11.5533 2.17492C10.6469 2.94006 9 4.92886 9 4.92886M12.0253 2.00052C12.1711 2.00657 12.3162 2.06476 12.4468 2.17508C13.3531 2.94037 15 4.92886 15 4.92886" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
					<span class="d-none">{__("Share")}</span>
				</div>
			{/if}
			<!-- share -->
		</div>

		{if $post['author_id'] != $user->_data['user_id'] && $post['tips_enabled']}
			<!-- tips -->
			<div class="post-tips">
				<button class="btn btn-sm btn-primary" data-toggle="modal" data-url="#send-tip" data-options='{ "id": "{$post['author_id']}", "value": "1"}'>
				  {print_money(1)}
				</button>
				<button class="btn btn-sm btn-primary" data-toggle="modal" data-url="#send-tip" data-options='{ "id": "{$post['author_id']}", "value": "5"}'>
				  {print_money(5)}
				</button>
				<button class="btn btn-sm btn-primary" data-toggle="modal" data-url="#send-tip" data-options='{ "id": "{$post['author_id']}", "value": "10"}'>
				  {print_money(10)}
				</button>
				<button class="btn btn-sm btn-primary" data-toggle="modal" data-url="#send-tip" data-options='{ "id": "{$post['author_id']}", "value": "20"}'>
				  {print_money(20)}
				</button>
				<button class="btn btn-sm btn-primary" data-toggle="modal" data-url="#send-tip" data-options='{ "id": "{$post['author_id']}", "value": "50"}'>
				  {print_money(50)}
				</button>
				<button class="btn btn-sm btn-primary" data-toggle="modal" data-url="#send-tip" data-options='{ "id": "{$post['author_id']}", "value": "100"}'>
				  {print_money(100)}
				</button>
				<button class="btn btn-sm btn-primary" data-toggle="modal" data-url="#send-tip" data-options='{ "id": "{$post['author_id']}"}'>
				  $$$
				</button>
			</div>
			<!-- tips -->
		{/if}
	{/if}
	<!-- post actions -->
</div>

<!-- post footer -->
<div class="post-footer px-3 pt-3">
	<!-- comments -->
	{include file='__feeds_post.comments.tpl'}
	<!-- comments -->
</div>
<!-- post footer -->