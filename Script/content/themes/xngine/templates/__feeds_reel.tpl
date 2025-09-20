<div class="reel-container position-absolute{if $_hidden || $_iteration > 1} hidden{/if}" data-id="{$post['post_id']}">
	<div class="position-relative w-100 h-100">
		<div class="reel-video-wrapper position-relative w-100 h-100">
			<div class="btn btn-gray reel-prev-btn d-none d-lg-flex rounded-circle p-2 position-absolute pointer js_reel-prev-btn">
				<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="m-1"><path d="M11.6341 3.06904C11.5098 3.11782 11.3933 3.19243 11.2929 3.2929L6.29289 8.2929C5.90237 8.68342 5.90237 9.31659 6.2929 9.70711C6.68342 10.0976 7.31659 10.0976 7.70711 9.7071L11 6.41419L11 20C11 20.5523 11.4477 21 12 21C12.5523 21 13 20.5523 13 20L13 6.41423L16.2929 9.70707C16.6834 10.0976 17.3166 10.0976 17.7071 9.70706C18.0976 9.31653 18.0976 8.68337 17.7071 8.29285L12.7124 3.29818C12.6943 3.27989 12.6756 3.26229 12.6562 3.24542C12.5785 3.17767 12.4928 3.12395 12.4024 3.08425C12.2793 3.03007 12.1431 3 12 3C11.8709 3 11.7475 3.02448 11.6341 3.06904Z" fill="currentColor"/></svg>
			</div>
			<div class="btn btn-gray reel-next-btn d-none d-lg-flex rounded-circle p-2 position-absolute pointer js_reel-next-btn">
				<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="m-1"><path d="M12.003 21C12.145 20.9996 12.2801 20.9695 12.4024 20.9157L12.003 21Z" fill="currentColor"/><path d="M12.4024 20.9157C12.4932 20.8759 12.5793 20.8218 12.6574 20.7536C12.6764 20.737 12.6947 20.7197 12.7124 20.7018L17.7071 15.7072C18.0976 15.3166 18.0976 14.6835 17.7071 14.2929C17.3166 13.9024 16.6834 13.9024 16.2929 14.2929L13 17.5858L13 4C13 3.44772 12.5523 3 12 3C11.4477 3 11 3.44772 11 4L11 17.5858L7.70711 14.2929C7.31659 13.9024 6.68342 13.9024 6.2929 14.2929C5.90237 14.6834 5.90237 15.3166 6.29289 15.7071L11.2929 20.7071C11.3933 20.8076 11.5098 20.8822 11.6341 20.931C11.7316 20.9693 11.8365 20.9927 11.946 20.9986C11.9639 20.9995 11.9819 21 12 21" fill="currentColor"/></svg>
			</div>
			<div class="reel-video-container position-relative w-100 h-100">
				<video class="w-100 h-100 js_video-plyr" data-reel="true" id="reel-{$post['reel']['reel_id']}" {if $user->_logged_in}onplay="update_media_views('reel', {$post['reel']['reel_id']})" {/if} {if $post['reel']['thumbnail']}data-poster="{$system['system_uploads']}/{$post['reel']['thumbnail']}" {/if} preload="auto" {if $_iteration == 1}autoplay{/if} playsinline preload="auto">
					{if empty($post['reel']['source_240p']) && empty($post['reel']['source_360p']) && empty($post['reel']['source_480p']) && empty($post['reel']['source_720p']) && empty($post['reel']['source_1080p']) && empty($post['reel']['source_1440p']) && empty($post['reel']['source_2160p'])}
						<source src="{$system['system_uploads']}/{$post['reel']['source']}" type="video/mp4">
					{/if}
					{if $post['reel']['source_240p']}
						<source src="{$system['system_uploads']}/{$post['reel']['source_240p']}" type="video/mp4" size="240">
					{/if}
					{if $post['reel']['source_360p']}
						<source src="{$system['system_uploads']}/{$post['reel']['source_360p']}" type="video/mp4" size="360">
					{/if}
					{if $post['reel']['source_480p']}
						<source src="{$system['system_uploads']}/{$post['reel']['source_480p']}" type="video/mp4" size="480">
					{/if}
					{if $post['reel']['source_720p']}
						<source src="{$system['system_uploads']}/{$post['reel']['source_720p']}" type="video/mp4" size="720">
					{/if}
					{if $post['reel']['source_1080p']}
						<source src="{$system['system_uploads']}/{$post['reel']['source_1080p']}" type="video/mp4" size="1080">
					{/if}
					{if $post['reel']['source_1440p']}
						<source src="{$system['system_uploads']}/{$post['reel']['source_1440p']}" type="video/mp4" size="1440">
					{/if}
					{if $post['reel']['source_2160p']}
						<source src="{$system['system_uploads']}/{$post['reel']['source_2160p']}" type="video/mp4" size="2160">
					{/if}
				</video>
				
				<div class="position-absolute d-flex align-items-end py-3 video-caption-overlay">
					<div class="video-caption px-3 text-white flex-1">
						{if $post['text']}
							{include file='__feeds_post.text.tpl'}
						{/if}
					</div>
					<div class="video-controlls flex-0">
						<div class="reel-actions d-flex flex-column text-center gap-2 gap-md-3">
							<!-- reactions -->
							<div class="reel-action-btn">
								<div class="btn btn-gray rounded-circle p-2 lh-1 action-btn position-relative pointer unselectable reactions-wrapper {if $post['i_react']}js_unreact-post{/if}" data-reaction="{$post['i_reaction']}">
									<!-- reaction-btn -->
									<div class="reaction-btn position-relative m-1">
										{if !$post['i_react']}
											<div class="reaction-btn-icon">
												<i class="far fa-smile fa-fw white-icon"></i>
											</div>
										{else}
											<div class="reaction-btn-icon">
												<div class="inline-emoji no_animation">
													{include file='__reaction_emojis.tpl' _reaction=$post['i_reaction']}
												</div>
											</div>
										{/if}
									</div>
									<!-- reaction-btn -->

									<!-- reactions-container -->
									<div class="reactions-container position-absolute">
										{foreach $reactions_enabled as $reaction}
											<div class="reactions_item reaction reaction-{$reaction@iteration} js_react-post" data-reaction="{$reaction['reaction']}" data-reaction-color="{$reaction['color']}" data-title="{__($reaction['title'])}">
												{include file='__reaction_emojis.tpl' _reaction=$reaction['reaction']}
											</div>
										{/foreach}
									</div>
									<!-- reactions-container -->
								</div>
								<!-- reactions stats -->
								<span class="pointer d-block mt-1 small fw-medium" data-toggle="modal" data-url="posts/who_reacts.php?post_id={$post['post_id']}">
									{$post['reactions_total_count_formatted']}
								</span>
								<!-- reactions stats -->
							</div>
							<!-- reactions -->

							<!-- comment -->
							<div class="reel-action-btn">
								<div class="btn btn-gray rounded-circle p-2 lh-1 action-btn position-relative pointer js_reel-comments-toggle">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none" class="m-1"><path d="M14.1706 20.8905C18.3536 20.6125 21.6856 17.2332 21.9598 12.9909C22.0134 12.1607 22.0134 11.3009 21.9598 10.4707C21.6856 6.22838 18.3536 2.84913 14.1706 2.57107C12.7435 2.47621 11.2536 2.47641 9.8294 2.57107C5.64639 2.84913 2.31441 6.22838 2.04024 10.4707C1.98659 11.3009 1.98659 12.1607 2.04024 12.9909C2.1401 14.536 2.82343 15.9666 3.62791 17.1746C4.09501 18.0203 3.78674 19.0758 3.30021 19.9978C2.94941 20.6626 2.77401 20.995 2.91484 21.2351C3.05568 21.4752 3.37026 21.4829 3.99943 21.4982C5.24367 21.5285 6.08268 21.1757 6.74868 20.6846C7.1264 20.4061 7.31527 20.2668 7.44544 20.2508C7.5756 20.2348 7.83177 20.3403 8.34401 20.5513C8.8044 20.7409 9.33896 20.8579 9.8294 20.8905C11.2536 20.9852 12.7435 20.9854 14.1706 20.8905Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M11.9953 12H12.0043M15.9908 12H15.9998M7.99982 12H8.00879" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg>
								</div>
								<span class="pointer d-block mt-1 small fw-medium js_reel-comments-toggle">{$post['comments_formatted']}</span>
							</div>
							<!-- comment -->

							<!-- share -->
							{if $post['privacy'] == "public" || ($post['in_group'] && $post['group_privacy'] == "public") || ($post['in_event'] && $post['event_privacy'] == "public") }
								<div class="reel-action-btn">
									<div class="btn btn-gray rounded-circle p-2 lh-1 action-btn position-relative pointer" data-toggle="modal" data-url="posts/share.php?do=create&post_id={$post['post_id']}">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none" class="m-1"><path d="M18 7C18.7745 7.16058 19.3588 7.42859 19.8284 7.87589C21 8.99181 21 10.7879 21 14.38C21 17.9721 21 19.7681 19.8284 20.8841C18.6569 22 16.7712 22 13 22H11C7.22876 22 5.34315 22 4.17157 20.8841C3 19.7681 3 17.9721 3 14.38C3 10.7879 3 8.99181 4.17157 7.87589C4.64118 7.42859 5.2255 7.16058 6 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M12.0253 2.00052L12 14M12.0253 2.00052C11.8627 1.99379 11.6991 2.05191 11.5533 2.17492C10.6469 2.94006 9 4.92886 9 4.92886M12.0253 2.00052C12.1711 2.00657 12.3162 2.06476 12.4468 2.17508C13.3531 2.94037 15 4.92886 15 4.92886" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
									</div>
									<!-- shares -->
									<span class="pointer d-block mt-1 small fw-medium" data-toggle="modal" data-url="posts/who_shares.php?post_id={$post['post_id']}">
										{$post['shares_formatted']}
									</span>
									<!-- shares -->
								</div>
							{/if}
							<!-- share -->
							
							<!-- post picture -->
							<div class="post-avatar position-relative">
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
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="reel-comments-wrapper position-absolute content w-100">
			<div class="d-flex justify-content-end px-2 pt-2">
				<button type="button" class="btn btn-gray rounded-circle p-1 js_reel-comments-toggle">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.0005 4.99988L5.00049 18.9999M5.00049 4.99988L19.0005 18.9999" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
				</button>
			</div>
			<div class="lightbox-post p-0" data-id="{$post['post_id']}">
				<div class="js_scroller" data-slimScroll-height="100%">
					{include file='__feeds_post_reel.tpl'}
				</div>
			</div>
		</div>
	</div>
</div>