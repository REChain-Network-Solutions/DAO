<li>
	<div class="comment {if $_is_reply}reply{/if}" data-id="{$_comment['comment_id']}" id="comment_{$_comment['comment_id']}">
		<div class="d-flex x_user_info gap-2">
			<!-- comment avatar -->
			<div class="comment-avatar flex-0">
				<a class="comment-avatar-picture rounded-circle overflow-hidden d-block" href="{$_comment['author_url']}" style="background-image:url({$_comment['author_picture']});"></a>
			</div>
			<!-- comment avatar -->

			<!-- comment body -->
			<div class="comment-data flex-1">
				<div class="d-flex align-items-start justify-content-between gap-2">
					<!-- comment author & text  -->
					<div class="comment-inner-wrapper flex-1">
						<div class="comment-inner js_notifier-flasher">
							<!-- author -->
							<div class="comment-author">
								<span class="js_user-popover" data-type="{$_comment['user_type']}" data-uid="{$_comment['user_id']}">
									<a class="fw-semibold body-color" href="{$_comment['author_url']}">{$_comment['author_name']}</a>
								</span>
								{if $_comment['author_verified']}
									<span class="verified-badge" data-bs-toggle="tooltip" {if $_post['user_type'] == "user"}title='{__("Verified User")}'{else}title='{__("Verified Page")}'{/if}>
										<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
									</span>
								{/if}
								{if $_comment['user_subscribed']}
									<span class="pro-badge" data-bs-toggle="tooltip" title='{__($_comment['package_name'])} {__("Member")}'>
										<svg xmlns='http://www.w3.org/2000/svg' height='17' viewBox='0 0 24 24' width='17'><path d='M0 0h24v24H0z' fill='none'></path><path fill='currentColor' d='M12 2.02c-5.51 0-9.98 4.47-9.98 9.98s4.47 9.98 9.98 9.98 9.98-4.47 9.98-9.98S17.51 2.02 12 2.02zm-.52 15.86v-4.14H8.82c-.37 0-.62-.4-.44-.73l3.68-7.17c.23-.47.94-.3.94.23v4.19h2.54c.37 0 .61.39.45.72l-3.56 7.12c-.24.48-.95.31-.95-.22z'></path></svg>
									</span>
								{/if}
							</div>
							<!-- author -->

							<!-- text -->
							{include file='__feeds_comment.text.tpl'}
							<!-- text -->
						</div>
					</div>
					<!-- comment author & text  -->
					
					<!-- comment menu -->
					{if $user->_logged_in}
						<div class="comment-btn flex-0 dropdown">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none" data-bs-toggle="dropdown" data-display="static" class="pointer position-relative"><path d="M11.9959 12H12.0049" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M17.9998 12H18.0088" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.99981 12H6.00879" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path></svg>
							<div class="dropdown-menu dropdown-menu-end">
								{if !$_comment['edit_comment'] && !$_comment['delete_comment'] }
									<div class="dropdown-item pointer" data-toggle="modal" data-url="data/report.php?do=create&handle=comment&id={$_comment['comment_id']}">{__("Report")}</div>
								{elseif !$_comment['edit_comment'] && $_comment['delete_comment']}
									<div class="dropdown-item pointer js_delete-comment">{__("Delete Comment")}</div>
								{else}
									<div class="dropdown-item pointer js_edit-comment">{__("Edit Comment")}</div>
									<div class="dropdown-item pointer js_delete-comment">{__("Delete Comment")}</div>
								{/if}
							</div>
						</div>
					{/if}
					<!-- comment menu -->
				</div>

				<!-- comment actions & time  -->
				<div class="comment-actions d-flex align-items-start text-muted fw-medium">
					<!-- reactions stats -->
					{if $_comment['reactions_total_count'] > 0}
						<div class="pointer" data-toggle="modal" data-url="posts/who_reacts.php?comment_id={$_comment['comment_id']}">
							<div class="reactions-stats d-flex align-items-center">
								{foreach $_comment['reactions'] as $reaction_type => $reaction_count}
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
									{$_comment['reactions_total_count_formatted']}
								</span>
								<!-- reactions count -->
							</div>
						</div>
						<span class="fw-bold mx-1">·</span>
					{/if}
					<!-- reactions stats -->
		
					<!-- reactions -->
					<div class="pointer unselectable reactions-wrapper {if $_comment['i_react']}js_unreact-comment{/if}" data-reaction="{$_comment['i_reaction']}">
						<!-- reaction-btn -->
						<div class="reaction-btn">
							{if !$_comment['i_react']}
								<div class="reaction-btn-icon d-none">
									<i class="fa fa-smile fa-fw"></i>
								</div>
								<span class="reaction-btn-name text-link">{__("React")}</span>
							{else}
								<div class="reaction-btn-icon d-none">
									<div class="inline-emoji no_animation">
										{include file='__reaction_emojis.tpl' _reaction=$_comment['i_reaction']}
									</div>
								</div>
								<span class="reaction-btn-name text-link" style="color: {$reactions[$_comment['i_reaction']]['color']};">{__($reactions[$_comment['i_reaction']]['title'])}</span>
							{/if}
						</div>
						<!-- reaction-btn -->

						<!-- reactions-container -->
						<div class="reactions-container">
							{foreach $reactions_enabled as $reaction}
								<div class="reactions_item reaction reaction-{$reaction@iteration} js_react-comment" data-reaction="{$reaction['reaction']}" data-reaction-color="{$reaction['color']}" data-title="{__($reaction['title'])}">
									{include file='__reaction_emojis.tpl' _reaction=$reaction['reaction']}
								</div>
							{/foreach}
						</div>
						<!-- reactions-container -->
					</div>
					<!-- reactions -->

					<!-- comment -->
					<span class="fw-bold mx-1">·</span>
					<span class="text-link js_reply {if $_comment['comments_disabled']}x-hidden{/if}" data-username="{if $user->_data['user_name'] != $_comment['author_user_name']}{$_comment['author_user_name']}{/if}">
						{__("Reply")}
					</span>
					<!-- comment -->

					<!-- time  -->
					<span class="fw-bold mx-1">·</span>
					<small class="js_moment fw-normal" data-time="{$_comment['time']}">{$_comment['time']}</small>
					<!-- time  -->
				</div>
				<!-- comment actions & time  -->

				<!-- comment replies  -->
				{if !$_is_reply}
					{if !$standalone && $_comment['replies'] > 0}
						<div class="pt-2 fw-semibold small text-muted js_replies-toggle">
							<span class="text-link d-flex align-items-center gap-2">
								<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.25 11.5667C1.25 5.83838 6.09523 1.25 12 1.25C17.9048 1.25 22.75 5.83838 22.75 11.5667C22.75 17.295 17.9048 21.8834 12 21.8834C11.3041 21.8843 10.6103 21.8199 9.92698 21.6916C9.68979 21.647 9.53909 21.6189 9.42696 21.6036C9.34334 21.5907 9.25931 21.6219 9.22775 21.6391C9.11322 21.6935 8.96068 21.7744 8.72714 21.8986C7.29542 22.66 5.62504 22.93 4.01396 22.6303C3.75381 22.5819 3.5384 22.4 3.44713 22.1517C3.35586 21.9033 3.40224 21.6252 3.56917 21.4199C4.03697 20.8445 4.35863 20.1513 4.50088 19.4052C4.53937 19.2 4.45227 18.9213 4.18451 18.6494C2.36972 16.8065 1.25 14.3144 1.25 11.5667ZM8 11C7.44772 11 7 11.4477 7 12C7 12.5523 7.44772 13 8 13H8.00897C8.56126 13 9.00897 12.5523 9.00897 12C9.00897 11.4477 8.56126 11 8.00897 11H8ZM11.9955 11C11.4432 11 10.9955 11.4477 10.9955 12C10.9955 12.5523 11.4432 13 11.9955 13H12.0045C12.5568 13 13.0045 12.5523 13.0045 12C13.0045 11.4477 12.5568 11 12.0045 11H11.9955ZM14.991 12C14.991 11.4477 15.4387 11 15.991 11H16C16.5523 11 17 11.4477 17 12C17 12.5523 16.5523 13 16 13H15.991C15.4387 13 14.991 12.5523 14.991 12Z" fill="currentColor"/></svg>
								{$_comment['replies']} {__("Replies")}
							</span>
						</div>
					{/if}
					
					<div class="comment-replies {if !$standalone}x-hidden{/if}">
						<!-- previous replies -->
						{if $_comment['replies'] >= $system['min_results']}
							<div class="main pointer px-3 text-center rounded-3 d-block side_item_hover side_item_list small fw-semibold js_see-more" data-get="comment_replies" data-id="{$_comment['comment_id']}" data-remove="true">
								<span class="">
									{__("View previous replies")}
								</span>
								<div class="loader loader_small x-hidden"></div>
							</div>
						{/if}
						<!-- previous replies -->

						<!-- replies -->
						<ul class="js_replies w-100 x_comms_list">{if $_comment['replies'] > 0}
								{foreach $_comment['comment_replies'] as $reply}
									{include file='__feeds_comment.tpl' _comment=$reply _is_reply=true}
								{/foreach}
							{/if}</ul>
						<!-- replies -->

						<!-- post a reply -->
						{if $user->_logged_in}
							<div class="x-hidden mt-2 pt-1 js_reply-form">
								<div class="x-form comment-form d-flex align-items-end gap-2">
									<textarea dir="auto" class="js_autosize js_mention js_post-reply bg-transparent px-0 w-100 m-0 py-2 border-0" rows="1" placeholder='{__("Write a Reply")}'></textarea>
									<ul class="x-form-tools position-relative d-flex align-items-center flex-0 mb-2 gap-1">
										{if $system['comments_photos_enabled']}
											<li class="x-form-tools-attach lh-1">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="js_x-uploader" data-handle="comment"><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75"></path><circle cx="16.5" cy="7.5" r="1.5" stroke="currentColor" stroke-width="1.75"></circle><path d="M16 22C15.3805 19.7749 13.9345 17.7821 11.8765 16.3342C9.65761 14.7729 6.87163 13.9466 4.01569 14.0027C3.67658 14.0019 3.33776 14.0127 3 14.0351" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M13 18C14.7015 16.6733 16.5345 15.9928 18.3862 16.0001C19.4362 15.999 20.4812 16.2216 21.5 16.6617" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path></svg>
											</li>
										{/if}
										{if $system['voice_notes_comments_enabled']}
											<li class="x-form-tools-voice js_comment-voice-notes-toggle lh-1">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M17 7V11C17 13.7614 14.7614 16 12 16C9.23858 16 7 13.7614 7 11V7C7 4.23858 9.23858 2 12 2C14.7614 2 17 4.23858 17 7Z" stroke="currentColor" stroke-width="1.75"></path><path d="M17 7H14M17 11H14" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M20 11C20 15.4183 16.4183 19 12 19M12 19C7.58172 19 4 15.4183 4 11M12 19V22M12 22H15M12 22H9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
											</li>
										{/if}
										<li class="x-form-tools-emoji js_emoji-menu-toggle lh-1">
											<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.75" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"> <path stroke="none" d="M0 0h24v24H0z" fill="none"></path> <circle cx="12" cy="12" r="9"></circle> <line x1="9" y1="10" x2="9.01" y2="10"></line> <line x1="15" y1="10" x2="15.01" y2="10"></line> <path d="M9.5 15a3.5 3.5 0 0 0 5 0"></path></svg>
										</li>
										<li class="x-form-tools-post js_post-reply">
											<button type="button" class="btn btn-sm btn-main">{__("Post")}</button>
										</li>
									</ul>
								</div>
								<div class="comment-voice-notes mt-2">
									<div class="voice-recording-wrapper" data-handle="comment">
										<!-- processing message -->
										<div class="x-hidden small fw-medium js_voice-processing-message">
											<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20"><path d="M0 0h24v24H0V0z" fill="none"></path><path fill="#ef4c5d" d="M8 18c.55 0 1-.45 1-1V7c0-.55-.45-1-1-1s-1 .45-1 1v10c0 .55.45 1 1 1zm4 4c.55 0 1-.45 1-1V3c0-.55-.45-1-1-1s-1 .45-1 1v18c0 .55.45 1 1 1zm-8-8c.55 0 1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1v2c0 .55.45 1 1 1zm12 4c.55 0 1-.45 1-1V7c0-.55-.45-1-1-1s-1 .45-1 1v10c0 .55.45 1 1 1zm3-7v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1z"></path></svg> {__("Processing")}<span class="loading-dots"></span>
										</div>
										<!-- processing message -->

										<!-- success message -->
										<div class="x-hidden js_voice-success-message">
											<div class="d-flex align-items-center justify-content-between gap-3">
												<div class="d-flex align-items-center small fw-medium gap-1">
													<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20" class="flex-0"><path d="M0 0h24v24H0V0z" fill="none"/><path fill="#1bc3bb" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM9.29 16.29L5.7 12.7c-.39-.39-.39-1.02 0-1.41.39-.39 1.02-.39 1.41 0L10 14.17l6.88-6.88c.39-.39 1.02-.39 1.41 0 .39.39.39 1.02 0 1.41l-7.59 7.59c-.38.39-1.02.39-1.41 0z"/></svg> {__("Voice note recorded successfully")}
												</div>
												<button type="button" class="btn btn-voice-clear js_voice-remove p-0 text-danger text-opacity-75 flex-0">
													<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M19.5825 15.6564C19.5058 16.9096 19.4449 17.9041 19.3202 18.6984C19.1922 19.5131 18.9874 20.1915 18.5777 20.7849C18.2029 21.3278 17.7204 21.786 17.1608 22.1303C16.5491 22.5067 15.8661 22.6713 15.0531 22.75L8.92739 22.7499C8.1135 22.671 7.42972 22.5061 6.8176 22.129C6.25763 21.7841 5.77494 21.3251 5.40028 20.7813C4.99073 20.1869 4.78656 19.5075 4.65957 18.6917C4.53574 17.8962 4.47623 16.9003 4.40122 15.6453L3.75 4.75H20.25L19.5825 15.6564ZM9.5 17.9609C9.08579 17.9609 8.75 17.6252 8.75 17.2109L8.75 11.2109C8.75 10.7967 9.08579 10.4609 9.5 10.4609C9.91421 10.4609 10.25 10.7967 10.25 11.2109L10.25 17.2109C10.25 17.6252 9.91421 17.9609 9.5 17.9609ZM15.25 11.2109C15.25 10.7967 14.9142 10.4609 14.5 10.4609C14.0858 10.4609 13.75 10.7967 13.75 11.2109V17.2109C13.75 17.6252 14.0858 17.9609 14.5 17.9609C14.9142 17.9609 15.25 17.6252 15.25 17.2109V11.2109Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13.3473 1.28277C13.9124 1.33331 14.4435 1.50576 14.8996 1.84591C15.2369 2.09748 15.4712 2.40542 15.6714 2.73893C15.8569 3.04798 16.0437 3.4333 16.2555 3.8704L16.6823 4.7507H21C21.5523 4.7507 22 5.19842 22 5.7507C22 6.30299 21.5523 6.7507 21 6.7507C14.9998 6.7507 9.00019 6.7507 3 6.7507C2.44772 6.7507 2 6.30299 2 5.7507C2 5.19842 2.44772 4.7507 3 4.7507H7.40976L7.76556 3.97016C7.97212 3.51696 8.15403 3.11782 8.33676 2.79754C8.53387 2.45207 8.76721 2.13237 9.10861 1.87046C9.57032 1.51626 10.1121 1.33669 10.6899 1.28409C11.1249 1.24449 11.5634 1.24994 12 1.25064C12.5108 1.25146 12.97 1.24902 13.3473 1.28277ZM9.60776 4.7507H14.4597C14.233 4.28331 14.088 3.98707 13.9566 3.7682C13.7643 3.44787 13.5339 3.30745 13.1691 3.27482C12.9098 3.25163 12.5719 3.2507 12.0345 3.2507C11.4837 3.2507 11.137 3.25166 10.8712 3.27585C10.4971 3.30991 10.2639 3.45568 10.0739 3.78866C9.94941 4.00687 9.81387 4.29897 9.60776 4.7507Z" fill="currentColor"/></svg>
												</button>
											</div>
										</div>
										<!-- success message -->

										<!-- start recording -->
										<div class="btn btn-voice-start btn-main btn-sm js_voice-start">
											<svg xmlns="http://www.w3.org/2000/svg" height="16" viewBox="0 0 24 24" width="16"><path fill="currentColor" d="M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3zm5.91-3c-.49 0-.9.36-.98.85C16.52 14.2 14.47 16 12 16s-4.52-1.8-4.93-4.15c-.08-.49-.49-.85-.98-.85-.61 0-1.09.54-1 1.14.49 3 2.89 5.35 5.91 5.78V20c0 .55.45 1 1 1s1-.45 1-1v-2.08c3.02-.43 5.42-2.78 5.91-5.78.1-.6-.39-1.14-1-1.14z"></path></svg> {__("Record")}
										</div>
										<!-- start recording -->

										<!-- stop recording -->
										<div class="btn btn-voice-stop btn-danger btn-sm js_voice-stop" style="display: none">
											<svg xmlns="http://www.w3.org/2000/svg" height="18" viewBox="0 0 24 24" width="18"><path fill="currentColor" d="M8 6h8c1.1 0 2 .9 2 2v8c0 1.1-.9 2-2 2H8c-1.1 0-2-.9-2-2V8c0-1.1.9-2 2-2z"></path></svg> {__("Recording")} <span class="js_voice-timer">00:00</span>
										</div>
										<!-- stop recording -->
									</div>
								</div>
								<div class="comment-attachments attachments mt-2 clearfix x-hidden">
									<ul>
										<li class="loading">
											<div class="progress x-progress">
												<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
											</div>
										</li>
									</ul>
								</div>
							</div>
						{/if}
						<!-- post a reply -->
					</div>
				{/if}
				<!-- comment replies  -->
			</div>
			<!-- comment body -->
		</div>
	</div>
</li>