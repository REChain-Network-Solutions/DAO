{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
.search-wrapper-prnt {
display: none !important
}
</style>

<!-- page content -->
<div class="row x_content_row">
    <!-- content panel -->
    <div class="col-lg-12 w-100">
		<div class="position-sticky x_top_posts">
			<div class="headline-font fw-semibold side_widget_title p-3 d-flex align-items-center justify-content-between">
				{__("Forums")}
			</div>
			
			<div class="d-flex align-items-center justify-content-center">
				<div {if $view == ""}class="active fw-semibold" {/if}>
					<a href="{$system['system_url']}/forums" class="body-color side_item_hover w-100 text-center d-block">
						<span class="position-relative d-inline-block py-3">{__("Home")}</span>
					</a>
				</div>
				{if $user->_logged_in}
					<div {if $view == "my-threads"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/forums/my-threads" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("My Threads")}</span>
						</a>
					</div>
					<div {if $view == "my-replies"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/forums/my-replies" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("My Replies")}</span>
						</a>
					</div>
				{/if}
				<div {if $view == "search" || $view == "search-results"}class="active fw-semibold" {/if}>
					<a href="{$system['system_url']}/forums/search" class="body-color side_item_hover w-100 text-center d-block">
						<span class="position-relative d-inline-block py-3">{__("Search")}</span>
					</a>
				</div>
			</div>
		</div>

		<div class="p-3">
			{if $view == ""}
				<!-- forums -->
				{foreach $forums as $forum}
					<div class="overflow-hidden mb-4 x_address">
						<div class="forum-category main main_bg_half position-relative d-flex align-items-center justify-content-between gap-3 p-3">
							<a href="{$system['system_url']}/forums/{$forum['forum_id']}/{$forum['title_url']}" class="main d-flex align-items-center gap-2 fw-semibold">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="flex-0"><path d="M7.79098 19C7.46464 18.8681 7.28441 18.8042 7.18359 18.8166C7.05968 18.8317 6.8799 18.9637 6.52034 19.2275C5.88637 19.6928 5.0877 20.027 3.90328 19.9983C3.30437 19.9838 3.00491 19.9765 2.87085 19.749C2.73679 19.5216 2.90376 19.2067 3.23769 18.5769C3.70083 17.7034 3.99427 16.7035 3.54963 15.9023C2.78384 14.7578 2.13336 13.4025 2.0383 11.9387C1.98723 11.1522 1.98723 10.3377 2.0383 9.55121C2.29929 5.53215 5.47105 2.33076 9.45292 2.06733C10.8086 1.97765 12.2269 1.97746 13.5854 2.06733C17.5503 2.32964 20.712 5.50498 20.9965 9.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M14.6976 21.6471C12.1878 21.4862 10.1886 19.5298 10.0241 17.0737C9.99195 16.593 9.99195 16.0953 10.0241 15.6146C10.1886 13.1585 12.1878 11.2021 14.6976 11.0411C15.5539 10.9862 16.4479 10.9863 17.3024 11.0411C19.8122 11.2021 21.8114 13.1585 21.9759 15.6146C22.008 16.0953 22.008 16.593 21.9759 17.0737C21.9159 17.9682 21.5059 18.7965 21.0233 19.4958C20.743 19.9854 20.928 20.5965 21.2199 21.1303C21.4304 21.5152 21.5356 21.7076 21.4511 21.8466C21.3666 21.9857 21.1778 21.9901 20.8003 21.999C20.0538 22.0165 19.5504 21.8123 19.1508 21.5279C18.9242 21.3667 18.8108 21.2861 18.7327 21.2768C18.6546 21.2675 18.5009 21.3286 18.1936 21.4507C17.9174 21.5605 17.5966 21.6283 17.3024 21.6471C16.4479 21.702 15.5539 21.7021 14.6976 21.6471Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path></svg>
								{__($forum['forum_name'])}
							</a>
							<svg xmlns="http://www.w3.org/2000/svg" class="pointer js_forum-toggle flex-0" viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M0 0h24v24H0V0z" fill="none"></path><path d="M12 5.83l2.46 2.46c.39.39 1.02.39 1.41 0 .39-.39.39-1.02 0-1.41L12.7 3.7c-.39-.39-1.02-.39-1.41 0L8.12 6.88c-.39.39-.39 1.02 0 1.41.39.39 1.02.39 1.41 0L12 5.83zm0 12.34l-2.46-2.46c-.39-.39-1.02-.39-1.41 0-.39.39-.39 1.02 0 1.41l3.17 3.18c.39.39 1.02.39 1.41 0l3.17-3.17c.39-.39.39-1.02 0-1.41-.39-.39-1.02-.39-1.41 0L12 18.17z"></path></svg>
						</div>
						{if $forum['childs']}
							<div class="js_forum-toggle-wrapper">
								{foreach $forum['childs'] as $_forum}
									<div class="p-3 x_forum_section">
										<h5 class="m-0"><a href="{$system['system_url']}/forums/{$_forum['forum_id']}/{$_forum['title_url']}" class="body-color">{__($_forum['forum_name'])}</a></h5>
										<p class="m-0 text-muted">{__($_forum['forum_description'])}</p>
										<div class="d-flex align-items-center gap-1 flex-wrap mt-1 small opacity-50">
											<small class="">
												{$_forum['total_threads']} {__("Threads")}
											</small>
											<small class="fw-bold mx-1">·</small>
											<small class="">
												{$_forum['total_replies']} {__("Replies")}
											</small>
										</div>
										{if $_forum['childs']}
											<div class="p-2 mt-2 d-inline-block x_adslist small">
												<div class="fw-semibold">{__("Sub-Forums")}:</div>
												<div>
													{foreach $_forum['childs'] as $__forum}
														<a href="{$system['system_url']}/forums/{$__forum['forum_id']}/{$_forum['title_url']}">{__($__forum['forum_name'])}</a>{if !$__forum@last}, {/if}
													{/foreach}
												</div>
											</div>
										{/if}
									</div>
								{/foreach}
							</div>
						{/if}
					</div>
				{/foreach}
				<!-- forums -->

				<!-- forums meta -->
				{if $system['forums_online_enabled'] || $system['forums_statistics_enabled']}
					<!-- online users -->
					{if $system['forums_online_enabled']}
						<div class="mb-3 overflow-hidden content">
							<h6 class="headline-font fw-semibold m-0 side_widget_title">
								{__("Who's online")} ({count($online_users)|number_format:0})
							</h6>
							<div class="px-3 pb-3 x_page_cats h-100">
								<ul class="d-flex align-items-center flex-wrap gap-2">
									{foreach $online_users as $_user}
										<li>
											<a class="btn btn-sm" href="{$system['system_url']}/{$_user['user_name']}">
												{if $system['show_usernames_enabled']}
													{$_user['user_name']}
												{else}
													{$_user['user_firstname']} {$_user['user_lastname']}
												{/if}
											</a>
										</li>
									{/foreach}
								</ul>
							</div>
						</div>
					{/if}
					<!-- online users -->
					<!-- statistics -->
					{if $system['forums_statistics_enabled']}
						<div class="mb-3 overflow-hidden content">
							<h6 class="headline-font fw-semibold m-0 side_widget_title">
								{__("Forum Statistics")}
							</h6>
							<div class="px-3 pt-0 pb-3 side_item_list d-flex align-items-center gap-3 flex-wrap">
								<span class=""><strong class="fw-semibold">{__("Threads")}</strong>: {$insights['threads']|number_format:0}</span>
								<span class=""><strong class="fw-semibold">{__("Replies")}</strong>: {$insights['replies']|number_format:0}</span>
								<span class=""><strong class="fw-semibold">{__("Members")}</strong>: {$insights['users']|number_format:0}</span>
							</div>
						</div>
					{/if}
					<!-- statistics -->
				{/if}
				<!-- forums meta -->

			{elseif $view == "forum"}

				<!-- breadcrumb -->
				<ol class="breadcrumb mb-2">
					<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/">{__("Home")}</a></li>
					{if $forum['parents']}
						{foreach array_reverse($forum['parents']) as $parent}
							<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/{$parent['forum_id']}/{$parent['title_url']}">{__($parent['forum_name'])}</a></li>
						{/foreach}
					{/if}
					<li class="breadcrumb-item small active">{__($forum['forum_name'])}</li>
				</ol>
				<!-- breadcrumb -->

				<!-- forum title & description -->
				<div class="d-flex gap-2 align-items-start justify-content-between flex-wrap">
					<div>
						<h3 class="m-0 fw-semibold headline-font">{__($forum['forum_name'])}</h3>
						<p class="m-0 text-muted">{__($forum['forum_description'])}</p>
					</div>
					{if $forum['forum_section'] != '0'}
						<a href="{$system['system_url']}/forums/new-thread/{$forum['forum_id']}" class="btn flex-0 btn-success">
							{__("Write New Thread")}
						</a>
					{/if}
				</div>
				<!-- forum title & description -->

				<!-- childs (forums|sub-forums) -->
				{if $forum['childs']}
					<div class="overflow-hidden mb-4 x_address mt-3">
						<div class="forum-category main main_bg_half position-relative d-flex align-items-center justify-content-between gap-3 p-3">
							<a class="main d-flex align-items-center gap-2 fw-semibold">
								{if $forum['forum_section'] == '0'}{__("Forums")}{else}{__("Sub-Forums")}{/if}
							</a>
						</div>
						{foreach $forum['childs'] as $_forum}
							<div class="p-3 x_forum_section">
								<h5 class="m-0"><a href="{$system['system_url']}/forums/{$_forum['forum_id']}/{$_forum['title_url']}" class="body-color">{__($_forum['forum_name'])}</a></h5>
								<p class="m-0 text-muted">{__($_forum['forum_description'])}</p>
								<div class="d-flex align-items-center gap-1 flex-wrap mt-1 small opacity-50">
									<small class="">
										{$_forum['total_threads']} {__("Threads")}
									</small>
									<small class="fw-bold mx-1">·</small>
									<small class="">
										{$_forum['total_replies']} {__("Replies")}
									</small>
								</div>
								{if $_forum['childs']}
									<div class="p-2 mt-2 d-inline-block x_adslist small">
										<div class="fw-semibold">{__("Sub-Forums")}:</div>
										<div>
											{foreach $_forum['childs'] as $__forum}
												<a href="{$system['system_url']}/forums/{$__forum['forum_id']}/{$_forum['title_url']}">{__($__forum['forum_name'])}</a>{if !$__forum@last}, {/if}
											{/foreach}
										</div>
									</div>
								{/if}
							</div>
						{/foreach}
					</div>
				{/if}
				<!-- childs (forums|sub-forums) -->

				<!-- threads -->
				{if $forum['forum_section'] != '0'}
					{if $forum['threads']}
						<div class="overflow-hidden mb-4 x_address mt-3">
							<div class="forum-category rounded-0 x_adslist position-relative p-3">
								<div class="row">
									<div class="col-12 col-md-9 fw-semibold">{__("Thread")}</div>
									<div class="col-md-1 text-end fw-semibold d-none d-md-block">{__("Replies")}</div>
									<div class="col-md-2 text-end fw-semibold d-none d-md-block">{__("Last Post")}</div> 
								</div>
							</div>
							{foreach $forum['threads'] as $thread}
								<div class="p-3 x_forum_section">
									<div class="row">
										<div class="col-12 col-md-9">
											<div class="fw-semibold">
												<a href="{$system['system_url']}/forums/thread/{$thread['thread_id']}/{$thread['title_url']}">{$thread['title']}</a>
											</div>
											<div class="mb-2 mb-md-0">
												<small>
													<a href="{$system['system_url']}/{$thread['user_name']}" class="body-color">{$thread['user_fullname']}</a>
													<span class="fw-bold mx-1">·</span>
													<span class="js_moment" data-time="{$thread['time']}">{$thread['time']}</span>
													<span class="fw-bold mx-1">·</span>
													<span>{$thread['views']} {__("Views")}</span>
												</small>
											</div>
										</div>
										<div class="col-md-1 text-md-end small">
											<span class="d-md-none">{__("Replies")}:</span> {$thread['replies']}
										</div>
										<div class="col-md-2 text-md-end small">
											<span class="d-md-none">{__("Last Post")}:</span> <span class="js_moment" data-time="{$thread['last_reply']}">{$thread['last_reply']}</span>
										</div>
									</div>
								</div>
							{/foreach}
						</div>
						{$pager}
					{else}
						<div class="p-3">
							<div class="text-center text-muted py-5">
								<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M2.53168 9.32334C2.79738 9.26497 3.0942 9.25 3.4 9.25H20.6C20.9058 9.25 21.2026 9.26497 21.4683 9.32334C21.7425 9.38357 22.0291 9.49978 22.2647 9.73532C22.5002 9.97086 22.6164 10.2575 22.6767 10.5317C22.735 10.7974 22.75 11.0942 22.75 11.4V12.6C22.75 12.9058 22.735 13.2026 22.6767 13.4683C22.6164 13.7425 22.5002 14.0291 22.2647 14.2647C22.0291 14.5002 21.7425 14.6164 21.4683 14.6767C21.2026 14.735 20.9058 14.75 20.6 14.75H3.4C3.0942 14.75 2.79738 14.735 2.53168 14.6767C2.25749 14.6164 1.97086 14.5002 1.73532 14.2647C1.49978 14.0291 1.38357 13.7425 1.32334 13.4683C1.26497 13.2026 1.25 12.9058 1.25 12.6V11.4C1.25 11.0942 1.26497 10.7974 1.32334 10.5317C1.38357 10.2575 1.49978 9.97086 1.73532 9.73532C1.97086 9.49978 2.25749 9.38357 2.53168 9.32334Z" fill="currentColor"/><path opacity="0.4" d="M2.53168 1.32334C2.79738 1.26497 3.0942 1.25 3.4 1.25H20.6C20.9058 1.25 21.2026 1.26497 21.4683 1.32334C21.7425 1.38357 22.0291 1.49978 22.2647 1.73532C22.5002 1.97086 22.6164 2.25749 22.6767 2.53168C22.735 2.79738 22.75 3.0942 22.75 3.4V4.6C22.75 4.9058 22.735 5.20262 22.6767 5.46832C22.6164 5.74251 22.5002 6.02914 22.2647 6.26468C22.0291 6.50022 21.7425 6.61643 21.4683 6.67666C21.2026 6.73503 20.9058 6.75 20.6 6.75H3.4C3.0942 6.75 2.79738 6.73503 2.53168 6.67666C2.25749 6.61643 1.97086 6.50022 1.73532 6.26468C1.49978 6.02914 1.38357 5.74251 1.32334 5.46832C1.26497 5.20262 1.25 4.9058 1.25 4.6V3.4C1.25 3.0942 1.26497 2.79738 1.32334 2.53168C1.38357 2.25749 1.49978 1.97086 1.73532 1.73532C1.97086 1.49978 2.25749 1.38357 2.53168 1.32334Z" fill="currentColor"/><path opacity="0.4" d="M2.53168 17.3233C2.79738 17.265 3.0942 17.25 3.4 17.25H20.6C20.9058 17.25 21.2026 17.265 21.4683 17.3233C21.7425 17.3836 22.0291 17.4998 22.2647 17.7353C22.5002 17.9709 22.6164 18.2575 22.6767 18.5317C22.735 18.7974 22.75 19.0942 22.75 19.4V20.6C22.75 20.9058 22.735 21.2026 22.6767 21.4683C22.6164 21.7425 22.5002 22.0291 22.2647 22.2647C22.0291 22.5002 21.7425 22.6164 21.4683 22.6767C21.2026 22.735 20.9058 22.75 20.6 22.75H3.4C3.0942 22.75 2.79738 22.735 2.53168 22.6767C2.25749 22.6164 1.97086 22.5002 1.73532 22.2647C1.49978 22.0291 1.38357 21.7425 1.32334 21.4683C1.26497 21.2026 1.25 20.9058 1.25 20.6V19.4C1.25 19.0942 1.26497 18.7974 1.32334 18.5317C1.38357 18.2575 1.49978 17.9709 1.73532 17.7353C1.97086 17.4998 2.25749 17.3836 2.53168 17.3233Z" fill="currentColor"/></svg>
								<div class="text-md mt-4">
									<h5 class="headline-font m-0">
										{__("No Threads")}
									</h5>
								</div>
							</div>
						</div>
					{/if}
				{/if}
				<!-- threads -->

			{elseif $view == "thread"}

				<!-- breadcrumb -->
				<ol class="breadcrumb mb-2">
					<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/">{__("Home")}</a></li>
					{if $thread['forum']['parents']}
						{foreach array_reverse($thread['forum']['parents']) as $parent}
							<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/{$parent['forum_id']}/{$parent['title_url']}">{__($parent['forum_name'])}</a></li>
						{/foreach}
					{/if}
					<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/{$thread['forum']['forum_id']}/{$thread['forum']['title_url']}">{__($thread['forum']['forum_name'])}</a></li>
				</ol>
				<!-- breadcrumb -->

				<!-- thread title -->
				<div class="">
					<h3 class="m-0 fw-semibold headline-font">{$thread['title']}</h3>
				</div>
				<!-- thread title -->

				<!-- thread -->
				<div class="{if $thread['replies'] > 0 && $selected_page != 1}x-hidden{/if}">
					<div class="d-flex justify-content-between x_user_info post-header mt-3">
						<div class="d-flex position-relative mw-0">
							<!-- picture -->
							<div class="post-avatar position-relative flex-0">
								<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$system['system_url']}/{$thread['user_name']}" style="background-image:url({$thread['user_picture']});"></a>
							</div>
							<!-- picture -->
							<div class="mw-0 mx-2">
								<div class="post-meta">
									<!-- author -->
									<span class="js_user-popover" data-type="user" data-uid="{$thread['user_id']}">
										<a class="post-author fw-semibold body-color" href="{$system['system_url']}/{$thread['user_name']}">{$thread['user_fullname']}</a>
									</span>
									<span class="text-muted small">
										{if $thread['user_group'] == 1}
											<i class="fa fa-shield-alt"></i> {__("Admin")}
										{elseif $thread['user_group'] == 2}
											<i class="fab fa-black-tie"></i> {__("Moderator")}
										{else}
											<i class="fa fa-user"></i> {__("Member")}
										{/if}
									</span>
									<!-- author -->

									<div class="post-time text-muted">
										<span class="js_moment" data-time="{$thread['time']}">{$thread['time']}</span>
									</div>
								</div>
							</div>
						</div>
	
						<div class="flex-0 dropdown">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none" data-bs-toggle="dropdown" data-display="static" class="pointer position-relative"><path d="M11.9959 12H12.0049" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M17.9998 12H18.0088" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.99981 12H6.00879" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path></svg>
							<div class="dropdown-menu dropdown-menu-end">
								{if $thread['manage_thread']}
									<a href="{$system['system_url']}/forums/edit-thread/{$thread['thread_id']}" class="dropdown-item pointer">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
										{__("Edit")}
									</a>
									<div class="dropdown-item pointer js_delete-forum" data-handle="thread" data-id="{$thread['thread_id']}">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.5 5.5L18.8803 15.5251C18.7219 18.0864 18.6428 19.3671 18.0008 20.2879C17.6833 20.7431 17.2747 21.1273 16.8007 21.416C15.8421 22 14.559 22 11.9927 22C9.42312 22 8.1383 22 7.17905 21.4149C6.7048 21.1257 6.296 20.7408 5.97868 20.2848C5.33688 19.3626 5.25945 18.0801 5.10461 15.5152L4.5 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M3 5.5H21M16.0557 5.5L15.3731 4.09173C14.9196 3.15626 14.6928 2.68852 14.3017 2.39681C14.215 2.3321 14.1231 2.27454 14.027 2.2247C13.5939 2 13.0741 2 12.0345 2C10.9688 2 10.436 2 9.99568 2.23412C9.8981 2.28601 9.80498 2.3459 9.71729 2.41317C9.32164 2.7167 9.10063 3.20155 8.65861 4.17126L8.05292 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M9.5 16.5L9.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M14.5 16.5L14.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
										{__("Delete")}
									</div>
								{else}
									<div class="dropdown-item pointer" data-toggle="modal" data-url="data/report.php?do=create&handle=forum_thread&id={$thread['thread_id']}">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M5.32171 9.6829C7.73539 5.41196 8.94222 3.27648 10.5983 2.72678C11.5093 2.42437 12.4907 2.42437 13.4017 2.72678C15.0578 3.27648 16.2646 5.41196 18.6783 9.6829C21.092 13.9538 22.2988 16.0893 21.9368 17.8293C21.7376 18.7866 21.2469 19.6548 20.535 20.3097C19.241 21.5 16.8274 21.5 12 21.5C7.17265 21.5 4.75897 21.5 3.46496 20.3097C2.75308 19.6548 2.26239 18.7866 2.06322 17.8293C1.70119 16.0893 2.90803 13.9538 5.32171 9.6829Z" stroke="currentColor" stroke-width="1.75" /><path d="M11.992 16H12.001" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M12 13L12 8.99997" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										{__("Report")}
									</div>
								{/if}
							</div>
						</div>
					</div>

					<div class="d-flex mb-3">
						<div class="post_empty_space flex-0"></div>
						<div class="flex-1">
							<div class="text">
								{$thread['parsed_text']}
							</div>
							<a href="{$system['system_url']}/forums/new-reply/{$thread['thread_id']}" class="btn btn-primary">
								{__("Post Reply")}
							</a>
						</div>
					</div>
				</div>
				<!-- thread -->

				<!-- replies -->
				{if $thread['replies'] > 0}
					{foreach $thread['thread_replies'] as $reply}
						<div class="forum-thread pt-3" id="reply-{$reply['reply_id']}">
							<div class="d-flex justify-content-between x_user_info post-header">
								<div class="d-flex position-relative mw-0">
									<!-- picture -->
									<div class="post-avatar position-relative flex-0">
										<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$system['system_url']}/{$reply['user_name']}" style="background-image:url({$reply['user_picture']});"></a>
									</div>
									<!-- picture -->
									<div class="mw-0 mx-2">
										<div class="post-meta">
											<!-- author -->
											<span class="js_user-popover" data-type="user" data-uid="{$reply['user_id']}">
												<a class="post-author fw-semibold body-color" href="{$system['system_url']}/{$reply['user_name']}">{$reply['user_fullname']}</a>
											</span>
											<span class="text-muted small">
												{if $reply['user_group'] == 1}
													<i class="fa fa-shield-alt"></i> {__("Admin")}
												{elseif $reply['user_group'] == 2}
													<i class="fab fa-black-tie"></i> {__("Moderator")}
												{else}
													<i class="fa fa-user"></i> {__("Member")}
												{/if}
											</span>
											<!-- author -->

											<div class="post-time text-muted">
												<span class="js_moment" data-time="{$reply['time']}">{$reply['time']}</span>
											</div>
										</div>
									</div>
								</div>
			
								<div class="flex-0 dropdown">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none" data-bs-toggle="dropdown" data-display="static" class="pointer position-relative"><path d="M11.9959 12H12.0049" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M17.9998 12H18.0088" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.99981 12H6.00879" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path></svg>
									<div class="dropdown-menu dropdown-menu-end">
										<a href="{$system['system_url']}/forums/thread/{$thread['thread_id']}/{$thread['title_url']}#reply-{$reply['reply_id']}" class="dropdown-item pointer">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M9.14339 10.691L9.35031 10.4841C11.329 8.50532 14.5372 8.50532 16.5159 10.4841C18.4947 12.4628 18.4947 15.671 16.5159 17.6497L13.6497 20.5159C11.671 22.4947 8.46279 22.4947 6.48405 20.5159C4.50532 18.5372 4.50532 15.329 6.48405 13.3503L6.9484 12.886" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M17.0516 11.114L17.5159 10.6497C19.4947 8.67095 19.4947 5.46279 17.5159 3.48405C15.5372 1.50532 12.329 1.50532 10.3503 3.48405L7.48405 6.35031C5.50532 8.32904 5.50532 11.5372 7.48405 13.5159C9.46279 15.4947 12.671 15.4947 14.6497 13.5159L14.8566 13.309" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
											{__("Link")}
										</a>
										{if $reply['manage_reply']}
											<a href="{$system['system_url']}/forums/edit-reply/{$reply['reply_id']}" class="dropdown-item pointer">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
												{__("Edit")}
											</a>
											<div class="dropdown-item pointer js_delete-forum" data-handle="reply" data-id="{$reply['reply_id']}">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.5 5.5L18.8803 15.5251C18.7219 18.0864 18.6428 19.3671 18.0008 20.2879C17.6833 20.7431 17.2747 21.1273 16.8007 21.416C15.8421 22 14.559 22 11.9927 22C9.42312 22 8.1383 22 7.17905 21.4149C6.7048 21.1257 6.296 20.7408 5.97868 20.2848C5.33688 19.3626 5.25945 18.0801 5.10461 15.5152L4.5 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M3 5.5H21M16.0557 5.5L15.3731 4.09173C14.9196 3.15626 14.6928 2.68852 14.3017 2.39681C14.215 2.3321 14.1231 2.27454 14.027 2.2247C13.5939 2 13.0741 2 12.0345 2C10.9688 2 10.436 2 9.99568 2.23412C9.8981 2.28601 9.80498 2.3459 9.71729 2.41317C9.32164 2.7167 9.10063 3.20155 8.65861 4.17126L8.05292 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M9.5 16.5L9.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M14.5 16.5L14.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
												{__("Delete")}
											</div>
										{else}
											<div class="dropdown-item pointer" data-toggle="modal" data-url="data/report.php?do=create&handle=forum_reply&id={$reply['reply_id']}">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M5.32171 9.6829C7.73539 5.41196 8.94222 3.27648 10.5983 2.72678C11.5093 2.42437 12.4907 2.42437 13.4017 2.72678C15.0578 3.27648 16.2646 5.41196 18.6783 9.6829C21.092 13.9538 22.2988 16.0893 21.9368 17.8293C21.7376 18.7866 21.2469 19.6548 20.535 20.3097C19.241 21.5 16.8274 21.5 12 21.5C7.17265 21.5 4.75897 21.5 3.46496 20.3097C2.75308 19.6548 2.26239 18.7866 2.06322 17.8293C1.70119 16.0893 2.90803 13.9538 5.32171 9.6829Z" stroke="currentColor" stroke-width="1.75" /><path d="M11.992 16H12.001" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M12 13L12 8.99997" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												{__("Report")}
											</div>
										{/if}
									</div>
								</div>
							</div>

							<div class="d-flex">
								<div class="post_empty_space flex-0"></div>
								<div class="flex-1">
									<div class="text">
										{$reply['parsed_text']}
									</div>
								</div>
							</div>
						</div>
					{/foreach}
					<div class="mt-3">
						{$pager}
					</div>
				{/if}
				<!-- replies -->

			{elseif $view == "new-thread"}

				<!-- breadcrumb -->
				<ol class="breadcrumb mb-2">
					<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/">{__("Home")}</a></li>
					{if $forum['parents']}
						{foreach array_reverse($forum['parents']) as $parent}
							<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/{$parent['forum_id']}/{$parent['title_url']}">{__($parent['forum_name'])}</a></li>
						{/foreach}
					{/if}
					<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/{$forum['forum_id']}/{$forum['title_url']}">{__($forum['forum_name'])}</a></li>
					<li class="breadcrumb-item small active">{__("Write New Thread")}</li>
				</ol>
				<!-- breadcrumb -->

				<!-- new thread -->
				<div class="pb-3 headline-font fw-semibold h4 m-0">
					{__("Write New Thread")}
				</div>
				<form class="js_ajax-forms" data-url="forums/thread.php?do=create&id={$forum['forum_id']}">
					<div class="form-floating">
						<input class="form-control" name="title" placeholder=" ">
						<label class="form-label">{__("Title")}</label>
					</div>

					<div class="form-floating">
						<textarea name="text" class="form-control js_wysiwyg" placeholder=" "></textarea>
					</div>

					<!-- error -->
					<div class="alert alert-danger mt15 mb0 x-hidden"></div>
					<!-- error -->
					
					<hr class="hr-2">

					<div class="text-end">
						<button type="submit" class="btn btn-primary">{__("Publish")}</button>
					</div>
				</form>
				<!-- new thread -->

			{elseif $view == "edit-thread"}

				<!-- breadcrumb -->
				<ol class="breadcrumb mb-2">
					<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/">{__("Home")}</a></li>
					{if $thread['forum']['parents']}
						{foreach array_reverse($thread['forum']['parents']) as $parent}
							<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/{$parent['forum_id']}/{$parent['title_url']}">{__($parent['forum_name'])}</a></li>
						{/foreach}
					{/if}
					<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/{$thread['forum']['forum_id']}/{$thread['forum']['title_url']}">{__($thread['forum']['forum_name'])}</a></li>
					<li class="breadcrumb-item small active">{__("Edit Thread")}</li>
				</ol>
				<!-- breadcrumb -->

				<!-- edit thread -->
				<div class="pb-3 headline-font fw-semibold h4 m-0">
					{__("Edit Thread")}
				</div>
				<form class="js_ajax-forms" data-url="forums/thread.php?do=edit&id={$thread['thread_id']}">
					<div class="form-floating">
						<input class="form-control" name="title" value="{$thread['title']}" placeholder=" ">
						<label class="form-label">{__("Title")}</label>
					</div>

					<div class="form-floating">
						<textarea name="text" class="form-control js_wysiwyg" placeholder=" ">{$thread['text']}</textarea>
					</div>

					<!-- error -->
					<div class="alert alert-danger mt15 mb0 x-hidden"></div>
					<!-- error -->
					
					<hr class="hr-2">

					<div class="text-end">
						<button type="submit" class="btn btn-primary">{__("Update")}</button>
					</div>
				</form>
				<!-- edit thread -->

			{elseif $view == "new-reply"}
		
				<!-- breadcrumb -->
				<ol class="breadcrumb mb-2">
					<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/">{__("Home")}</a></li>
					{if $thread['forum']['parents']}
						{foreach array_reverse($thread['forum']['parents']) as $parent}
							<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/{$parent['forum_id']}/{$parent['title_url']}">{__($parent['forum_name'])}</a></li>
						{/foreach}
					{/if}
					<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/{$thread['forum']['forum_id']}/{$thread['forum']['title_url']}">{__($thread['forum']['forum_name'])}</a></li>
					<li class="breadcrumb-item small active">{__("Post Reply")}</li>
				</ol>
				<!-- breadcrumb -->

				<!-- new reply -->
				<div class="pb-3 headline-font fw-semibold h4 m-0">
					{__("Post Reply")}
				</div>
				
				<form class="js_ajax-forms" data-url="forums/reply.php?do=create&id={$thread['thread_id']}">
					<div class="form-floating">
						<textarea name="text" class="form-control js_wysiwyg" placeholder=" "></textarea>
					</div>

					<!-- error -->
					<div class="alert alert-danger mt15 mb0 x-hidden"></div>
					<!-- error -->
					
					<hr class="hr-2">
					
					<div class="text-end">
						<button type="submit" class="btn btn-primary">{__("Reply")}</button>
					</div>
				</form>
				<!-- new reply -->

			{elseif $view == "edit-reply"}

				<!-- breadcrumb -->
				<ol class="breadcrumb mb-2">
					<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/">{__("Home")}</a></li>
					{if $reply['thread']['forum']['parents']}
						{foreach array_reverse($reply['thread']['forum']['parents']) as $parent}
							<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/{$parent['forum_id']}/{$parent['title_url']}">{__($parent['forum_name'])}</a></li>
						{/foreach}
					{/if}
					<li class="breadcrumb-item small"><a href="{$system['system_url']}/forums/{$reply['thread']['forum']['forum_id']}/{$reply['thread']['forum']['title_url']}">{__($reply['thread']['forum']['forum_name'])}</a></li>
					<li class="breadcrumb-item small active">{__("Edit Reply")}</li>
				</ol>
				<!-- breadcrumb -->

				<!-- edit reply -->
				<div class="pb-3 headline-font fw-semibold h4 m-0">
					{__("Edit Reply")}
				</div>

				<form class="js_ajax-forms" data-url="forums/reply.php?do=edit&id={$reply['reply_id']}">
					<div class="form-floating">
						<textarea name="text" class="form-control js_wysiwyg" placeholder=" ">{$reply['text']}</textarea>
					</div>

					<!-- error -->
					<div class="alert alert-danger mt15 mb0 x-hidden"></div>
					<!-- error -->
					
					<hr class="hr-2">
					
					<div class="text-end">
						<button type="submit" class="btn btn-primary">{__("Update")}</button>
					</div>
				</form>
				<!-- edit reply -->

			{elseif $view == "my-threads"}

				<!-- threads -->
				{if $threads}
					{foreach $threads as $thread}
						<div class="overflow-hidden mb-4 x_address">
							<div class="forum-category main_bg_half position-relative p-3">
								{__("Forum")}: <a href="{$system['system_url']}/forums/{$thread['forum']['forum_id']}/{$thread['forum']['title_url']}" class="main fw-semibold">{__($thread['forum']['forum_name'])}</a>
							</div>
							<div class="p-3 x_forum_section">
								<h5 class="m-0"><a href="{$system['system_url']}/forums/thread/{$thread['thread_id']}/{$thread['title_url']}" class="">{$thread['title']}</a></h5>
								<div class="d-flex align-items-center gap-1 flex-wrap mt-1 opacity-75">
									<small class="">
										{$thread['replies']} {__("Replies")}
									</small>
									<small class="fw-bold mx-1">·</small>
									<small class="">
										{$thread['views']} {__("Views")}
									</small>
									<small class="fw-bold mx-1">·</small>
									<small class="js_moment" data-time="{$thread['time']}">{$thread['time']}</small>
								</div>
								<p class="m-0 x_adslist px-3 py-2 mt-3 small d-inline-block">{$thread['text_snippet']|truncate:300}</p>
							</div>
						</div>
					{/foreach}
					<div class="mt-3">
						{$pager}
					</div>
				{else}
					{include file='_no_data.tpl'}
				{/if}
				<!-- threads -->

			{elseif $view == "my-replies"}

				<!-- replies -->
				{if $replies}
					{foreach $replies as $reply}
						<div class="overflow-hidden mb-4 x_address">
							<div class="forum-category main_bg_half position-relative p-3">
								{__("Forum")}: <a href="{$system['system_url']}/forums/{$reply['thread']['forum']['forum_id']}/{$reply['thread']['forum']['title_url']}" class="main fw-semibold">{__($reply['thread']['forum']['forum_name'])}</a>
							</div>
							<div class="p-3 x_forum_section">
								<h5 class="m-0"><a href="{$system['system_url']}/forums/thread/{$reply['thread']['thread_id']}/{$reply['thread']['title_url']}" class="">{$reply['thread']['title']}</a></h5>
								<div class="d-flex align-items-center gap-1 flex-wrap mt-1 opacity-75">
									<small class="">
										{$reply['thread']['replies']} {__("Replies")}
									</small>
									<small class="fw-bold mx-1">·</small>
									<small class="">
										{$reply['thread']['views']} {__("Views")}
									</small>
									<small class="fw-bold mx-1">·</small>
									<small class="js_moment" data-time="{$reply['time']}">{$reply['time']}</small>
								</div>
								<p class="m-0 x_adslist px-3 py-2 mt-3 small d-inline-block">{$reply['text_snippet']|truncate:300}</p>
							</div>
						</div>
					{/foreach}
					<div class="mt-3">
						{$pager}
					</div>
				{else}
					{include file='_no_data.tpl'}
				{/if}
				<!-- replies -->

			{elseif $view == "search"}

				<!-- search -->
				<div class="pb-3 headline-font fw-semibold h4 m-0">
					{__("Search")}
				</div>
				
				<form action="{$system['system_url']}/forums/search-results" method="get">
					<div class="form-floating">
						<input class="form-control" name="query" required autofocus placeholder=" ">
						<label class="form-label">{__("Keyword(s)")}</label>
					</div>
					
					<div class="form-floating">
						<select class="form-select" name="type">
							<option value="threads">{__("Threads")}</option>
							<option value="replies">{__("Replies")}</option>
						</select>
						<label class="form-label">{__("Search For")}</label>
					</div>
					
					<div class="form-floating mb-2">
						<select class="form-select" name="forum">
							<option value="all">{__("Search All Forums")}</option>
							{foreach $forums as $forum}
								{include file='admin.forums.recursive_options.tpl'}
							{/foreach}
						</select>
						<label class="form-label">{__("Search in Forum(s)")}</label>
					</div>
					
					<div class="form-check">
						<input class="form-check-input" type="checkbox" name="recursive" id="recursive">
						<label class="form-check-label" for="recursive">
							{__("Also search in child forums")}
						</label>
					</div>

					<!-- error -->
					<div class="alert alert-danger mt15 mb0 x-hidden"></div>
					<!-- error -->
				
					<hr class="hr-2">
					
					<div class="text-end">
						<button type="submit" class="btn btn-primary">{__("Search")}</button>
					</div>
				</form>
				<!-- search -->

			{elseif $view == "search-results"}

				<div class="pb-2 headline-font fw-semibold h4 m-0">
					{__("Search")}
				</div>

				<!-- search title -->
				<div class="text-muted pb-3">
					<span class="fw-medium">{if $total}{$total}{else}0{/if}</span> {__("results were found for the search for")} "<strong class="main fw-medium">{htmlentities($query, ENT_QUOTES, 'utf-8')}</strong>"
				</div>
				<!-- search title -->

				<!-- search results -->
				{if $type == "threads"}
					<!-- threads -->
					{if $results}
						{foreach $results as $thread}
							<div class="overflow-hidden mb-4 x_address">
								<div class="forum-category main_bg_half position-relative p-3">
									{__("Forum")}: <a href="{$system['system_url']}/forums/{$thread['forum']['forum_id']}/{$thread['forum']['title_url']}" class="main fw-semibold">{__($thread['forum']['forum_name'])}</a>
								</div>
								<div class="p-3 x_forum_section">
									<h5 class="m-0"><a href="{$system['system_url']}/forums/thread/{$thread['thread_id']}/{$thread['title_url']}" class="">{$thread['title']}</a></h5>
									<div class="mt-2">
										{__("By")}: <a href="{$system['system_url']}/{$thread['user_name']}">{$thread['user_fullname']}</a>
									</div>
									<div class="d-flex align-items-center gap-1 flex-wrap mt-1 opacity-75">
										<small class="">
											{$thread['replies']} {__("Replies")}
										</small>
										<small class="fw-bold mx-1">·</small>
										<small class="">
											{$thread['views']} {__("Views")}
										</small>
										<small class="fw-bold mx-1">·</small>
										<small class="js_moment" data-time="{$thread['time']}">{$thread['time']}</small>
									</div>
									<p class="m-0 x_adslist px-3 py-2 mt-3 small d-inline-block">{$thread['text_snippet']|truncate:300}</p>
								</div>
							</div>
						{/foreach}
						<div class="mt-3">
							{$pager}
						</div>
					{else}
						{include file='_no_data.tpl'}
					{/if}
					<!-- threads -->
				{elseif $type == "replies"}
					<!-- replies -->
					{if $results}
						{foreach $results as $reply}
							<div class="overflow-hidden mb-4 x_address">
								<div class="forum-category main_bg_half position-relative p-3">
									{__("Forum")}: <a href="{$system['system_url']}/forums/{$reply['thread']['forum']['forum_id']}/{$reply['thread']['forum']['title_url']}" class="main fw-semibold">{__($reply['thread']['forum']['forum_name'])}</a>
								</div>
								<div class="p-3 x_forum_section">
									<h5 class="m-0"><a href="{$system['system_url']}/forums/thread/{$reply['thread']['thread_id']}/{$reply['thread']['title_url']}" class="">{$reply['thread']['title']}</a></h5>
									<div class="mt-2">
										{__("By")}: <a href="{$system['system_url']}/{$reply['thread']['user_name']}">{$reply['thread']['user_fullname']}</a>
									</div>
									<div class="d-flex align-items-center gap-1 flex-wrap mt-1 opacity-75">
										<small class="">
											{$reply['thread']['replies']} {__("Replies")}
										</small>
										<small class="fw-bold mx-1">·</small>
										<small class="">
											{$reply['thread']['views']} {__("Views")}
										</small>
										<small class="fw-bold mx-1">·</small>
										<small class="js_moment" data-time="{$reply['time']}">{$reply['time']}</small>
									</div>
									<p class="m-0 x_adslist px-3 py-2 mt-3 small d-inline-block">{$reply['text_snippet']|truncate:300}</p>
								</div>
							</div>
						{/foreach}
						<div class="mt-3">
							{$pager}
						</div>
					{else}
						{include file='_no_data.tpl'}
					{/if}
					<!-- replies -->
				{/if}
				<!-- search results -->

			{/if}
		</div>
    </div>
    <!-- content panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}