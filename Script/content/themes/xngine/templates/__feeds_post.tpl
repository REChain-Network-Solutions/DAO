{if !$standalone}<li>{/if}
	<!-- post -->
	{if $post['source'] == "popular"}
		<div class="fw-medium small p-3 pb-0 d-flex align-items-center gap-1 text-muted">
			<svg xmlns="http://www.w3.org/2000/svg" height="14" viewBox="0 -960 960 960" width="14" class="text-danger text-opacity-75" fill="currentColor"><path d="M160-400q0-113 67-217t184-182q22-15 45.5-1.5T480-760v52q0 34 23.5 57t57.5 23q17 0 32.5-7.5T621-657q8-10 20.5-12.5T665-664q63 45 99 115t36 149q0 88-43 160.5T644-125q17-24 26.5-52.5T680-238q0-40-15-75.5T622-377L480-516 339-377q-29 29-44 64t-15 75q0 32 9.5 60.5T316-125q-70-42-113-114.5T160-400Zm320-4 85 83q17 17 26 38t9 45q0 49-35 83.5T480-120q-50 0-85-34.5T360-238q0-23 9-44.5t26-38.5l85-83Z"/></svg>
			{__("Popular")}
		</div>
	{else if $post['source'] == "discover"}
		<div class="fw-medium small p-3 pb-0 d-flex align-items-center gap-1 text-muted">
			<svg xmlns="http://www.w3.org/2000/svg" height="14" viewBox="0 -960 960 960" width="14" fill="currentColor"><path d="m600-275 71 43q6 4 11.5 0t3.5-11l-19-81 62-53q5-5 3-11t-9-7l-81-7-33-77q-2-6-9-6t-9 6l-33 77-81 7q-7 1-9 7t3 11l62 53-19 81q-2 7 3.5 11t11.5 0l71-43Zm-440-45q-33 0-56.5-23.5T80-400v-400q0-33 23.5-56.5T160-880h400q33 0 56.5 23.5T640-800v40q0 17-11.5 28.5T600-720q-17 0-28.5-11.5T560-760v-40H160v400h40q17 0 28.5 11.5T240-360q0 17-11.5 28.5T200-320h-40ZM400-80q-33 0-56.5-23.5T320-160v-400q0-33 23.5-56.5T400-640h400q33 0 56.5 23.5T880-560v400q0 33-23.5 56.5T800-80H400Z"/></svg>
			{__("Suggested for you")}
		</div>
	{/if}
  
	<div class="bg-white position-relative p-3 post 
                {if $_get == "posts_profile" && $user->_data['user_id'] == $post['author_id'] && ($post['is_hidden'] || $post['is_anonymous'])}is_hidden{/if} 
                {if $boosted}boosted{/if} 
				{if ($post['still_scheduled']) OR ($post['is_pending']) OR ($post['in_group'] && !$post['group_approved']) OR ($post['in_event'] && !$post['event_approved'])}pending{/if}
            " data-id="{$post['post_id']}">

		{if ($post['is_pending']) OR ($post['in_group'] && !$post['group_approved']) OR ($post['in_event'] && !$post['event_approved'])}
			<div class="text-secondary fw-bold small mb-2 d-flex align-items-center gap-1">
				<svg xmlns="http://www.w3.org/2000/svg" height="15" viewBox="0 -960 960 960" width="15" fill="currentColor"><path d="M320-160h320v-120q0-66-47-113t-113-47q-66 0-113 47t-47 113v120ZM200-80q-17 0-28.5-11.5T160-120q0-17 11.5-28.5T200-160h40v-120q0-61 28.5-114.5T348-480q-51-32-79.5-85.5T240-680v-120h-40q-17 0-28.5-11.5T160-840q0-17 11.5-28.5T200-880h560q17 0 28.5 11.5T800-840q0 17-11.5 28.5T760-800h-40v120q0 61-28.5 114.5T612-480q51 32 79.5 85.5T720-280v120h40q17 0 28.5 11.5T800-120q0 17-11.5 28.5T760-80H200Z"/></svg>
				{__("Pending Post")}
			</div>
		{/if}
		
		{if $post['still_scheduled']}
			<div class="text-secondary fw-bold small mb-2 d-flex align-items-center gap-1">
				<svg xmlns="http://www.w3.org/2000/svg" height="15" viewBox="0 -960 960 960" width="15" fill="currentColor"><path d="M520-496v-144q0-17-11.5-28.5T480-680q-17 0-28.5 11.5T440-640v159q0 8 3 15.5t9 13.5l132 132q11 11 28 11t28-11q11-11 11-28t-11-28L520-496ZM480-80q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Z"></path></svg>
				{__("Scheduled Post")}
			</div>
		{/if}

		{if $standalone && $pinned}
			<div class="text-warning fw-bold small mb-2 d-flex align-items-center gap-1">
				<svg width="15" height="15" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 14.75C12.5523 14.75 13 15.1977 13 15.75V20.75C13 21.3023 12.5523 21.75 12 21.75C11.4477 21.75 11 21.3023 11 20.75V15.75C11 15.1977 11.4477 14.75 12 14.75Z" fill="currentColor"/><path d="M10.2491 2.25001H13.751C13.9801 2.24994 14.1567 2.24989 14.3145 2.26805C15.5842 2.41419 16.5859 3.41586 16.732 4.68559C16.7502 4.84338 16.7501 5.01993 16.7501 5.24906C16.7501 5.31819 16.7501 5.45153 16.7443 5.52317C16.699 6.08346 16.3873 6.58786 15.9064 6.87899C15.8449 6.91621 15.7795 6.94887 15.7176 6.97975L15.7176 6.97976C15.5062 7.08549 15.1071 7.28554 15.0189 7.33808C14.9649 7.3702 14.9374 7.39363 14.9374 7.39363C14.9112 7.42485 14.8946 7.46052 14.886 7.50037C14.8854 7.50758 14.8846 7.53437 14.8924 7.59668C14.9051 7.69858 14.9315 7.83308 14.9779 8.0649L15.6149 11.25C16.0514 11.2509 16.402 11.2607 16.7118 11.3437C17.6608 11.598 18.4021 12.3393 18.6563 13.2883C18.7507 13.6404 18.7504 14.0451 18.7501 14.5689V14.569C18.7506 14.8115 18.7511 15.2264 18.6904 15.4529C18.5286 16.0569 18.0569 16.5286 17.453 16.6904C17.2264 16.7511 16.9734 16.7506 16.7308 16.7501H7.26927C7.0267 16.7506 6.77366 16.7511 6.54712 16.6904C5.9432 16.5286 5.4715 16.0569 5.30968 15.4529C5.24898 15.2264 5.24952 14.8115 5.25001 14.569C5.24966 14.0452 5.24939 13.6404 5.34375 13.2883C5.59804 12.3393 6.33929 11.598 7.2883 11.3437C7.59813 11.2607 7.94867 11.2509 8.3852 11.25L9.02222 8.0649C9.06858 7.83308 9.09501 7.69857 9.1077 7.59668C9.11547 7.53436 9.11467 7.50757 9.1141 7.50037C9.10555 7.46052 9.08887 7.42485 9.06267 7.39363C9.06267 7.39363 9.03518 7.37021 8.98123 7.33808C8.893 7.28554 8.49392 7.08549 8.28247 6.97976C8.22062 6.94888 8.15518 6.91621 8.0937 6.87899C7.61284 6.58786 7.3011 6.08346 7.25575 5.52317C7.24996 5.45153 7.25 5.31819 7.25004 5.24906C7.24997 5.01993 7.24992 4.84338 7.26808 4.68559C7.41422 3.41586 8.41589 2.41419 9.68562 2.26805C9.84341 2.24989 10.02 2.24994 10.2491 2.25001Z" fill="currentColor"/></svg>
				{__("Pinned Post")}
			</div>
		{/if}

		{if $standalone && $boosted}
			<div class="text-orange fw-bold small mb-2 d-flex align-items-center gap-1">
				<svg width="14" height="14" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M13.6076 1.14723C14.3143 1.44842 14.7969 2.16259 14.7969 3.01681L14.7976 9.78474C14.7976 9.89519 14.8871 9.98472 14.9976 9.98472H18.0993C18.9851 9.98472 19.5954 10.5826 19.8466 11.2101C20.0974 11.8369 20.0636 12.642 19.5628 13.2849L12.5645 22.2678C12.0032 22.9883 11.1205 23.1629 10.3917 22.8523C9.68508 22.5511 9.20248 21.8369 9.20248 20.9827L9.20181 14.2148C9.2018 14.1043 9.11226 14.0148 9.00181 14.0148H5.90003C5.01422 14.0148 4.40394 13.4169 4.1528 12.7894C3.90193 12.1626 3.93574 11.3575 4.43658 10.7146L11.4348 1.73169C11.9962 1.01115 12.8788 0.83658 13.6076 1.14723Z" fill="currentColor"/></svg>
				{__("Promoted Posts")}
			</div>
		{/if}
	
		<!-- post top alert -->
		{if $_get == "posts_profile" && $user->_data['user_id'] == $post['author_id'] && ($post['is_hidden'] || $post['is_anonymous'])}
			<div class="post-top-alert small text-white text-center fw-semibold p-2">{__("Only you can see this post")}</div>
		{/if}
		<!-- post top alert -->

		<!-- memory post -->
		{if $_get == "memories"}
			<div class="post-memory-header main fw-semibold mb-3">
				<span class="js_moment" data-time="{$post['time']}">{$post['time']}</span>
			</div>
		{/if}
		<!-- memory post -->

		<!-- post body -->
		<div class="post-body">
			{include file='__feeds_post.body.tpl' _post=$post _shared=false}

			{if $post['can_get_details'] && !$post['needs_pro_package'] && !$post['needs_permission'] }
				<div class="d-flex mt-2 pt-1">
					<div class="post_empty_space flex-0"></div>
					<div class="flex-1">
						<!-- post stats -->
						<div class="post-stats d-flex align-items-center">
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

							<!-- comments & shares & views & plays & donations -->
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

							<!-- views -->
							{if $system['posts_views_enabled']}
								<span class="fw-bold mx-1">·</span>{$post['views_formatted']} {__("Views")}
							{/if}
							<!-- views -->

							<!-- video views -->
							{if $post['post_type'] == "video"}
								<span class="fw-bold mx-1">·</span>{$post['video']['views']} {__("Plays")}
							{/if}
							{if $post['post_type'] == "shared" && $post['origin']['post_type'] == "video"}
								<span class="fw-bold mx-1">·</span>{$post['origin']['video']['views']} {__("Plays")}
							{/if}
							<!-- video views -->

							<!-- audio views -->
							{if $post['post_type'] == "audio"}
								<span class="fw-bold mx-1">·</span>{$post['audio']['views']} {__("Plays")}
							{/if}
							{if $post['post_type'] == "shared" && $post['origin']['post_type'] == "audio"}
								<span class="fw-bold mx-1">·</span>{$post['origin']['audio']['views']} {__("Plays")}
							{/if}
							<!-- audio views -->

							<!-- donations -->
							{if $post['post_type'] == "funding"}
								<span class="pointer" data-toggle="modal" data-url="posts/who_donates.php?post_id={$post['post_id']}">
									<span class="fw-bold mx-1">·</span>{$post['funding']['total_donations']} {__("Donations")}
								</span>
							{/if}
							<!-- donations -->

							{if $system['posts_reviews_enabled']}
								<!-- reviews -->
								<span class="pointer" data-toggle="modal" data-url="posts/who_reviews.php?post_id={$post['post_id']}">
									<span class="fw-bold mx-1">·</span>{$post['reviews_count_formatted']} {__("Reviews")}
								</span>
								<!-- reviews -->
							{/if}
							<!-- comments & shares & views & plays & donations -->
						</div>
						<!-- post stats -->

						<!-- post actions -->
						{if $user->_logged_in && $_get != "posts_information"}
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
								{if !$post['still_scheduled'] && ($post['privacy'] == "public" || ($post['in_group'] && $post['group_privacy'] == "public") || ($post['in_event'] && $post['event_privacy'] == "public")) }
									<div class="action-btn position-relative rounded-circle main_bg_half p-2 lh-1 pointer" data-toggle="modal" data-url="posts/share.php?do=create&post_id={$post['post_id']}">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="position-relative"><path d="M18 7C18.7745 7.16058 19.3588 7.42859 19.8284 7.87589C21 8.99181 21 10.7879 21 14.38C21 17.9721 21 19.7681 19.8284 20.8841C18.6569 22 16.7712 22 13 22H11C7.22876 22 5.34315 22 4.17157 20.8841C3 19.7681 3 17.9721 3 14.38C3 10.7879 3 8.99181 4.17157 7.87589C4.64118 7.42859 5.2255 7.16058 6 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M12.0253 2.00052L12 14M12.0253 2.00052C11.8627 1.99379 11.6991 2.05191 11.5533 2.17492C10.6469 2.94006 9 4.92886 9 4.92886M12.0253 2.00052C12.1711 2.00657 12.3162 2.06476 12.4468 2.17508C13.3531 2.94037 15 4.92886 15 4.92886" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										<span class="d-none">{__("Share")}</span>
									</div>
								{/if}
								<!-- share -->

								<!-- review -->
								{if $post['author_id'] != $user->_data['user_id'] && $system['posts_reviews_enabled']}
									<div class="action-btn position-relative rounded-circle main_bg_half p-2 lh-1 pointer" data-toggle="modal" data-url="modules/review.php?do=review&id={$post['post_id']}&type=post">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="position-relative"><path d="M13.7276 3.44418L15.4874 6.99288C15.7274 7.48687 16.3673 7.9607 16.9073 8.05143L20.0969 8.58575C22.1367 8.92853 22.6167 10.4206 21.1468 11.8925L18.6671 14.3927C18.2471 14.8161 18.0172 15.6327 18.1471 16.2175L18.8571 19.3125C19.417 21.7623 18.1271 22.71 15.9774 21.4296L12.9877 19.6452C12.4478 19.3226 11.5579 19.3226 11.0079 19.6452L8.01827 21.4296C5.8785 22.71 4.57865 21.7522 5.13859 19.3125L5.84851 16.2175C5.97849 15.6327 5.74852 14.8161 5.32856 14.3927L2.84884 11.8925C1.389 10.4206 1.85895 8.92853 3.89872 8.58575L7.08837 8.05143C7.61831 7.9607 8.25824 7.48687 8.49821 6.99288L10.258 3.44418C11.2179 1.51861 12.7777 1.51861 13.7276 3.44418Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										<span class="d-none">{__("Review")}</span>
									</div>
								{/if}
								<!-- review -->

								<!-- tips -->
								{if $post['author_id'] != $user->_data['user_id'] && $post['tips_enabled']}
									<div class="action-btn position-relative rounded-circle main_bg_half p-2 lh-1 pointer" data-toggle="modal" data-url="#send-tip" data-options='{ "id": "{$post['author_id']}"}'>
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="position-relative"><path d="M19.7453 13C20.5362 11.8662 21 10.4872 21 9C21 5.13401 17.866 2 14 2C10.134 2 7 5.134 7 9C7 10.0736 7.24169 11.0907 7.67363 12" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M14 6C12.8954 6 12 6.67157 12 7.5C12 8.32843 12.8954 9 14 9C15.1046 9 16 9.67157 16 10.5C16 11.3284 15.1046 12 14 12M14 6C14.8708 6 15.6116 6.4174 15.8862 7M14 6V5M14 12C13.1292 12 12.3884 11.5826 12.1138 11M14 12V13" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M3 14H5.39482C5.68897 14 5.97908 14.0663 6.24217 14.1936L8.28415 15.1816C8.54724 15.3089 8.83735 15.3751 9.1315 15.3751H10.1741C11.1825 15.3751 12 16.1662 12 17.142C12 17.1814 11.973 17.2161 11.9338 17.2269L9.39287 17.9295C8.93707 18.0555 8.449 18.0116 8.025 17.8064L5.84211 16.7503M12 16.5L16.5928 15.0889C17.407 14.8352 18.2871 15.136 18.7971 15.8423C19.1659 16.3529 19.0157 17.0842 18.4785 17.3942L10.9629 21.7305C10.4849 22.0063 9.92094 22.0736 9.39516 21.9176L3 20.0199" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										<span class="ml5 d-none">{__("Tip")}</span>
									</div>
								{/if}
								<!-- tips -->
							</div>
						{/if}
						<!-- post actions -->
					</div>
				</div>
			{/if}
		</div>
		<!-- post body -->

		<!-- post footer -->
		{if $post['can_get_details'] && !$post['needs_pro_package'] && !$post['needs_permission']}
			<div class="post-footer pt-3 mt-3 {if !$standalone}border-0 x_inside_comms{/if} {if !$standalone || ($page != "post" && $post['boosted'])}x-hidden{/if}">
				<!-- comments -->
				{include file='__feeds_post.comments.tpl'}
				<!-- comments -->
			</div>
		{/if}
		<!-- post footer -->

		<!-- post approval -->
		{if ($post['in_group'] && $post['is_group_admin'] &&!$post['group_approved']) OR ($post['in_event'] && $post['is_event_admin'] &&!$post['event_approved']) }
			<div class="post-approval mt-3 pt-3 d-flex align-items-center justify-content-end gap-2">
				<button class="btn text-danger btn-sm js_delete-post">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M19.0005 4.99988L5.00049 18.9999M5.00049 4.99988L19.0005 18.9999" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>{__("Decline")}
				</button>
				<button class="btn btn-main btn-sm js_approve-post">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M5 14L8.5 17.5L19 6.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>{__("Approve")}
				</button>
			</div>
		{/if}
		<!-- post approval -->
	</div>
	<!-- post -->
  {if !$standalone}
</li>{/if}