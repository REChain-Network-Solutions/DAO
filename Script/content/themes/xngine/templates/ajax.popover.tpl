{if $type == "user"}
	<!-- user popover -->
	<div class="user-popover-content bg-white rounded-4 p-3">
		<div class="user-card position-relative">
			<div class="user-card-avatar">
				<img src="{$profile['user_picture']}" alt="" class="rounded-circle">
			</div>
			<div class="user-card-info mt-2">
				<a class="name h5 body-color fw-semibold" href="{$system['system_url']}/{$profile['user_name']}">
					{if $system['show_usernames_enabled']}
						{$profile['user_name']}
					{else}
						{$profile['user_firstname']} {$profile['user_lastname']}
					{/if}
				</a>
				{if $profile['user_verified']}
					<span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified User")}'>
						<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
					</span>
				{/if}
				{if !$system['show_usernames_enabled']}
					<p class="mb-0 text-muted">@{$profile['user_name']}</p>
				{/if}
			</div>
		</div>
		
		<div class="d-flex flex-column mt-2 text-muted w-100">
			<!-- work -->
			{if $system['work_info_enabled']}
				{if !is_empty($profile['user_work_title'])}
					{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_work'] == "public" || $profile['we_friends']}
						<div class="d-flex align-items-center gap-1 flex-0">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M3 11L3.15288 14.2269C3.31714 17.6686 3.39927 19.3894 4.55885 20.4447C5.71843 21.5 7.52716 21.5 11.1446 21.5H12.8554C16.4728 21.5 18.2816 21.5 19.4412 20.4447C20.6007 19.3894 20.6829 17.6686 20.8471 14.2269L21 11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M2.84718 10.4431C4.54648 13.6744 8.3792 15 12 15C15.6208 15 19.4535 13.6744 21.1528 10.4431C21.964 8.90056 21.3498 6 19.352 6H4.648C2.65023 6 2.03603 8.90056 2.84718 10.4431Z" stroke="currentColor" stroke-width="1.75"></path><path d="M11.9999 11H12.0089" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M15.9999 6L15.9116 5.69094C15.4716 4.15089 15.2516 3.38087 14.7278 2.94043C14.204 2.5 13.5083 2.5 12.1168 2.5H11.8829C10.4915 2.5 9.79575 2.5 9.27198 2.94043C8.7482 3.38087 8.52819 4.15089 8.08818 5.69094L7.99988 6" stroke="currentColor" stroke-width="1.75"></path></svg>
							{$profile['user_work_title']} {__("at")} {$profile['user_work_place']}
						</div>
					{/if}
				{/if}
			{/if}
			<!-- work -->
			
			<!-- hometown -->
			{if $system['location_info_enabled']}
				{if !is_empty($profile['user_hometown'])}
					{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_location'] == "public" || $profile['we_friends']}
						<div class="d-flex align-items-center gap-1 flex-0">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M13.6177 21.367C13.1841 21.773 12.6044 22 12.0011 22C11.3978 22 10.8182 21.773 10.3845 21.367C6.41302 17.626 1.09076 13.4469 3.68627 7.37966C5.08963 4.09916 8.45834 2 12.0011 2C15.5439 2 18.9126 4.09916 20.316 7.37966C22.9082 13.4393 17.599 17.6389 13.6177 21.367Z" stroke="currentColor" stroke-width="1.75"></path><path d="M15.5 11C15.5 12.933 13.933 14.5 12 14.5C10.067 14.5 8.5 12.933 8.5 11C8.5 9.067 10.067 7.5 12 7.5C13.933 7.5 15.5 9.067 15.5 11Z" stroke="currentColor" stroke-width="1.75"></path></svg>
							{__("From")} {$profile['user_hometown']}
						</div>
					{/if}
				{/if}
			{/if}
			<!-- hometown -->
		</div>
		
		<div class="mt-2 d-flex align-items-center gap-3 flex-wrap">
			<a href="{$system['system_url']}/{$profile['user_name']}/followers" class="body-color small">
				<span class="fw-semibold">{$profile['followers_count']}</span>
				<span class="text-muted">{__("followers")}</span>
			</a>
			<!-- mutual friends -->
			{if $profile['mutual_friends_count'] && $profile['mutual_friends_count'] > 0}
				<a href="javascript:void(0);" class="body-color small" data-toggle="modal" data-url="users/mutual_friends.php?uid={$profile['user_id']}">
					<span class="fw-semibold">{$profile['mutual_friends_count']}</span>
					<span class="text-muted">{__("mutual friends")}</span>
				</a>
			{/if}
			<!-- mutual friends -->
		</div>

		<div class="mt-3 d-flex align-items-center gap-2 flex-wrap">
			{if $user->_data['user_id'] != $profile['user_id']}
				<!-- add friend -->
				{if $system['friends_enabled']}
					{if $profile['we_friends']}
						<button type="button" class="btn btn-sm btn-success btn-delete js_friend-remove" data-uid="{$profile['user_id']}">
							{__("Friends")}
						</button>
					{elseif $profile['he_request']}
						<button type="button" class="btn btn-sm btn-primary js_friend-accept" data-uid="{$profile['user_id']}">{__("Confirm")}</button>
						<button type="button" class="btn btn-sm btn-danger js_friend-decline" data-uid="{$profile['user_id']}">{__("Decline")}</button>
					{elseif $profile['i_request']}
						<button type="button" class="btn btn-sm btn-warning js_friend-cancel" data-uid="{$profile['user_id']}">
							{__("Sent")}
						</button>
					{else}
						<button type="button" class="btn btn-sm btn-success js_friend-add" data-uid="{$profile['user_id']}">
							{__("Add Friend")}
						</button>
					{/if}
				{/if}
				<!-- add friend -->

				<!-- follow -->
				{if $profile['i_follow']}
					<button type="button" class="btn btn-sm btn-gray js_unfollow" data-uid="{$profile['user_id']}">
						{__("Following")}
					</button>
				{else}
					<button type="button" class="btn btn-sm btn-gray js_follow" data-uid="{$profile['user_id']}">
						{__("Follow")}
					</button>
				{/if}
				<!-- follow -->

				<!-- message -->
				{if $user->_logged_in}
					{if $system['chat_enabled'] && $profile['user_privacy_chat'] == "public" || ($profile['user_privacy_chat'] == "friends" && $profile['we_friends'])}
						<button type="button" class="btn btn-gray rounded-circle p-2 js_chat-start" data-uid="{$profile['user_id']}" data-name="{if $system['show_usernames_enabled']}{$profile['user_name']}{else}{$profile['user_firstname']} {$profile['user_lastname']}{/if}" data-link="{$profile['user_name']}" data-picture="{$profile['user_picture']}">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" color="currentColor" fill="none"><path d="M8 13.5H16M8 8.5H12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M6.09881 19C4.7987 18.8721 3.82475 18.4816 3.17157 17.8284C2 16.6569 2 14.7712 2 11V10.5C2 6.72876 2 4.84315 3.17157 3.67157C4.34315 2.5 6.22876 2.5 10 2.5H14C17.7712 2.5 19.6569 2.5 20.8284 3.67157C22 4.84315 22 6.72876 22 10.5V11C22 14.7712 22 16.6569 20.8284 17.8284C19.6569 19 17.7712 19 14 19C13.4395 19.0125 12.9931 19.0551 12.5546 19.155C11.3562 19.4309 10.2465 20.0441 9.14987 20.5789C7.58729 21.3408 6.806 21.7218 6.31569 21.3651C5.37769 20.6665 6.29454 18.5019 6.5 17.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"></path></svg>
						</button>
					{/if}
				{/if}
				<!-- message -->
			{else}
				<!-- edit -->
				<a href="{$system['system_url']}/settings/profile" class="btn btn-sm btn-gray">
					{__("Update")}
				</a>
				<!-- edit -->
			{/if}
		</div>
	</div>
	<!-- user popover -->
{else}
	<!-- page popover -->
	<div class="user-popover-content bg-white rounded-4 p-3">
		<div class="user-card position-relative">
			<div class="user-card-avatar">
				<img class="rounded-circle" src="{$profile['page_picture']}" alt="{$profile['page_title']}">
			</div>
			<div class="user-card-info mt-2">
				<a class="name h5 body-color fw-semibold" href="{$system['system_url']}/pages/{$profile['page_name']}">{$profile['page_title']}</a>
				{if $profile['page_verified']}
					<span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified Page")}'>
						<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
					</span>
				{/if}
			</div>
		</div>
		
		<div class="d-flex align-items-center gap-1 mt-2 text-muted">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M19.4626 3.99415C16.7809 2.34923 14.4404 3.01211 13.0344 4.06801C12.4578 4.50096 12.1696 4.71743 12 4.71743C11.8304 4.71743 11.5422 4.50096 10.9656 4.06801C9.55962 3.01211 7.21909 2.34923 4.53744 3.99415C1.01807 6.15294 0.221721 13.2749 8.33953 19.2834C9.88572 20.4278 10.6588 21 12 21C13.3412 21 14.1143 20.4278 15.6605 19.2834C23.7783 13.2749 22.9819 6.15294 19.4626 3.99415Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
			{$profile['page_likes']} {__("people like this")}
		</div>

		<div class="mt-3 d-flex align-items-center gap-2 flex-wrap">
			<!-- like -->
			{if $profile['i_like']}
				<button type="button" class="btn btn-sm btn-primary js_unlike-page" data-id="{$profile['page_id']}">
					{__("Unlike")}
				</button>
			{else}
				<button type="button" class="btn btn-sm btn-primary js_like-page" data-id="{$profile['page_id']}">
					{__("Like")}
				</button>
			{/if}
			<!-- like -->
		</div>
	</div>
	<!-- page popover -->
{/if}