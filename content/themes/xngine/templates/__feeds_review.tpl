{if $_tpl == "box" || $_tpl == ""}
	<div class="col-12">
		<div class="">
			<div class="d-flex x_user_info post-header position-relative mt-3">
				<!-- picture -->
				<div class="post-avatar position-relative flex-0">
					<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$system['system_url']}/{$_review['user_name']}" style="background-image:url({$_review['user_picture']});"></a>
				</div>
				<!-- picture -->
				<div class="mw-0 mx-2">
					<div class="post-meta">
						<!-- author -->
						<span class="js_user-popover" data-uid="{$_review['user_id']}">
							<a class="post-author fw-semibold body-color" href="{$system['system_url']}/{$_review['user_name']}">{$_review['user_fullname']}</a>
						</span>
						{if $_review['user_verified']}
							<span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified User")}'>
								<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
							</span>
						{/if}
						{if $_review['user_subscribed']}
							<span class="pro-badge" data-bs-toggle="tooltip" title='{__("Pro User")}'>
								<svg xmlns='http://www.w3.org/2000/svg' height='17' viewBox='0 0 24 24' width='17'><path d='M0 0h24v24H0z' fill='none'></path><path fill='currentColor' d='M12 2.02c-5.51 0-9.98 4.47-9.98 9.98s4.47 9.98 9.98 9.98 9.98-4.47 9.98-9.98S17.51 2.02 12 2.02zm-.52 15.86v-4.14H8.82c-.37 0-.62-.4-.44-.73l3.68-7.17c.23-.47.94-.3.94.23v4.19h2.54c.37 0 .61.39.45.72l-3.56 7.12c-.24.48-.95.31-.95-.22z'></path></svg>
							</span>
						{/if}
						<span class="text-muted small">
							<small class="js_moment" data-time="{$_review['time']}">{$_review['time']}</small>
						</span>
						<!-- author -->

						<div class="post-time text-muted">
							<!-- rating -->
							<div class="review-stars small">
								<i class="fa fa-star {if $_review['rate'] >= 1}checked{/if}"></i>
								<i class="fa fa-star {if $_review['rate'] >= 2}checked{/if}"></i>
								<i class="fa fa-star {if $_review['rate'] >= 3}checked{/if}"></i>
								<i class="fa fa-star {if $_review['rate'] >= 4}checked{/if}"></i>
								<i class="fa fa-star {if $_review['rate'] >= 5}checked{/if}"></i>
							</div>
							<!-- rating -->
						</div>
					</div>
				</div>
			</div>

			<div class="d-flex mb-3">
				<div class="post_empty_space flex-0"></div>
				<div class="flex-1 mw-0">
					<!-- review -->
					{if $_review['review']}
						<div class="review-review">
							{$_review['review']}
						</div>
					{/if}
					<!-- review -->
					
					<!-- photos -->
					{if $_review['photos']}
						<div class="review-photos mt-2 gap-2 d-flex text-truncate overflow-x-auto">
							{foreach $_review['photos'] as $_photo}
								<span class="pointer flex-0 ratio ratio-1x1 js_lightbox-nodata" data-image="{$system['system_uploads']}/{$_photo['source']}">
									<img class="rounded-2 object-cover" src="{$system['system_uploads']}/{$_photo['source']}">
								</span>
							{/foreach}
						</div>
					{/if}
					<!-- photos -->

					<!-- reply -->
					{if $_review['reply']}
						<div class="review-reply x_address p-3 mt-3">
							<div class="d-flex x_user_info post-header position-relative">
								{if $_review['node_type'] == "page"}
									<!-- picture -->
									<div class="post-avatar position-relative flex-0">
										<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$system['system_url']}/pages/{$_review['page']['page_name']}" style="background-image:url({$_review['page']['page_picture']});"></a>
									</div>
									<!-- picture -->
									<div class="mw-0 mx-2">
										<div class="post-meta">
											<!-- author -->
											<span class="">
												<a class="post-author fw-semibold body-color" href="{$system['system_url']}/pages/{$_review['page']['page_name']}">{$_review['page']['page_title']}</a>
											</span>
											<!-- author -->
											{if $_review['page']['page_verified']}
												<span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified Page")}'>
													<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
												</span>
											{/if}

											<div class="mt-1 review-review">
												{$_review['reply']}
											</div>
										</div>
									</div>
								{elseif $_review['node_type'] == "group"}
									<!-- picture -->
									<div class="post-avatar position-relative flex-0">
										<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$system['system_url']}/groups/{$_review['group']['group_name']}" style="background-image:url({$_review['group']['group_picture']});"></a>
									</div>
									<!-- picture -->
									<div class="mw-0 mx-2">
										<div class="post-meta">
											<!-- author -->
											<span class="">
												<a class="post-author fw-semibold body-color" href="{$system['system_url']}/groups/{$_review['group']['group_name']}">{$_review['group']['group_title']}</a>
											</span>
											<!-- author -->

											<div class="mt-1 review-review">
												{$_review['reply']}
											</div>
										</div>
									</div>
								{elseif $_review['node_type'] == "event"}
									<!-- picture -->
									<div class="post-avatar position-relative flex-0">
										<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$system['system_url']}/events/{$_review['event']['event_id']}" style="background-image:url({$_review['event']['event_picture']});"></a>
									</div>
									<!-- picture -->
									<div class="mw-0 mx-2">
										<div class="post-meta">
											<!-- author -->
											<span class="">
												<a class="post-author fw-semibold body-color" href="{$system['system_url']}/events/{$_review['event']['event_id']}">{$_review['event']['event_title']}</a>
											</span>
											<!-- author -->

											<div class="mt-1 review-review">
												{$_review['reply']}
											</div>
										</div>
									</div>
								{elseif $_review['node_type'] == "post"}
									<!-- picture -->
									<div class="post-avatar position-relative flex-0">
										<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$_review['post']['post_author_url']}" style="background-image:url({$_review['post']['post_author_picture']});"></a>
									</div>
									<!-- picture -->
									<div class="mw-0 mx-2">
										<div class="post-meta">
											<!-- author -->
											<span class="">
												<a class="post-author fw-semibold body-color" href="{$_review['post']['post_author_url']}">{$_review['event']['event_title']}</a>
											</span>
											<!-- author -->

											<div class="mt-1 review-review">
												{$_review['reply']}
											</div>
										</div>
									</div>
								{/if}
							</div>
						</div>
					{/if}
					<!-- reply -->
					<!-- actions -->
					{if $_review['manage_review'] && !$_review['reply']}
						<button type="button" class="btn btn-sm btn-primary" data-toggle="modal" data-url="modules/review.php?do=reply&id={$_review['review_id']}">
							{__("Reply")}
						</button>
					{/if}
					<!-- actions -->
				</div>
			</div>
		</div>
		<hr class="mb-0">
	</div>
{elseif $_tpl == "list"}
	<div class="col-12">
		<div class="">
			<div class="d-flex x_user_info post-header position-relative mt-3">
				<!-- picture -->
				<div class="post-avatar position-relative flex-0">
					<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$system['system_url']}/{$_review['user_name']}" style="background-image:url({$_review['user_picture']});"></a>
				</div>
				<!-- picture -->
				<div class="mw-0 mx-2">
					<div class="post-meta">
						<!-- author -->
						<span class="js_user-popover" data-uid="{$_review['user_id']}">
							<a class="post-author fw-semibold body-color" href="{$system['system_url']}/{$_review['user_name']}">{$_review['user_fullname']}</a>
						</span>
						{if $_review['user_verified']}
							<span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified User")}'>
								<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
							</span>
						{/if}
						{if $_review['user_subscribed']}
							<span class="pro-badge" data-bs-toggle="tooltip" title='{__("Pro User")}'>
								<svg xmlns='http://www.w3.org/2000/svg' height='17' viewBox='0 0 24 24' width='17'><path d='M0 0h24v24H0z' fill='none'></path><path fill='currentColor' d='M12 2.02c-5.51 0-9.98 4.47-9.98 9.98s4.47 9.98 9.98 9.98 9.98-4.47 9.98-9.98S17.51 2.02 12 2.02zm-.52 15.86v-4.14H8.82c-.37 0-.62-.4-.44-.73l3.68-7.17c.23-.47.94-.3.94.23v4.19h2.54c.37 0 .61.39.45.72l-3.56 7.12c-.24.48-.95.31-.95-.22z'></path></svg>
							</span>
						{/if}
						<span class="text-muted small">
							<small class="js_moment" data-time="{$_review['time']}">{$_review['time']}</small>
						</span>
						<!-- author -->

						<div class="post-time text-muted">
							<!-- rating -->
							<div class="review-stars small">
								<i class="fa fa-star {if $_review['rate'] >= 1}checked{/if}"></i>
								<i class="fa fa-star {if $_review['rate'] >= 2}checked{/if}"></i>
								<i class="fa fa-star {if $_review['rate'] >= 3}checked{/if}"></i>
								<i class="fa fa-star {if $_review['rate'] >= 4}checked{/if}"></i>
								<i class="fa fa-star {if $_review['rate'] >= 5}checked{/if}"></i>
							</div>
							<!-- rating -->
						</div>
					</div>
				</div>
			</div>

			<div class="d-flex mb-3">
				<div class="post_empty_space flex-0"></div>
				<div class="flex-1 mw-0">
					<!-- review -->
					{if $_review['review']}
						<div class="review-review">
							{$_review['review']}
						</div>
					{/if}
					<!-- review -->
					
					<!-- photos -->
					{if $_review['photos']}
						<div class="review-photos mt-2 gap-2 d-flex text-truncate overflow-x-auto">
							{foreach $_review['photos'] as $_photo}
								<span class="pointer flex-0 ratio ratio-1x1 js_lightbox-nodata" data-image="{$system['system_uploads']}/{$_photo['source']}">
									<img class="rounded-2 object-cover" src="{$system['system_uploads']}/{$_photo['source']}">
								</span>
							{/foreach}
						</div>
					{/if}
					<!-- photos -->

					<!-- reply -->
					{if $_review['reply']}
						<div class="review-reply x_address p-3 mt-3">
							<div class="d-flex x_user_info post-header position-relative">
								{if $_review['node_type'] == "page"}
									<!-- picture -->
									<div class="post-avatar position-relative flex-0">
										<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$system['system_url']}/pages/{$_review['page']['page_name']}" style="background-image:url({$_review['page']['page_picture']});"></a>
									</div>
									<!-- picture -->
									<div class="mw-0 mx-2">
										<div class="post-meta">
											<!-- author -->
											<span class="">
												<a class="post-author fw-semibold body-color" href="{$system['system_url']}/pages/{$_review['page']['page_name']}">{$_review['page']['page_title']}</a>
											</span>
											<!-- author -->
											{if $_review['page']['page_verified']}
												<span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified Page")}'>
													<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
												</span>
											{/if}

											<div class="mt-1 review-review">
												{$_review['reply']}
											</div>
										</div>
									</div>
								{elseif $_review['node_type'] == "group"}
									<!-- picture -->
									<div class="post-avatar position-relative flex-0">
										<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$system['system_url']}/groups/{$_review['group']['group_name']}" style="background-image:url({$_review['group']['group_picture']});"></a>
									</div>
									<!-- picture -->
									<div class="mw-0 mx-2">
										<div class="post-meta">
											<!-- author -->
											<span class="">
												<a class="post-author fw-semibold body-color" href="{$system['system_url']}/groups/{$_review['group']['group_name']}">{$_review['group']['group_title']}</a>
											</span>
											<!-- author -->

											<div class="mt-1 review-review">
												{$_review['reply']}
											</div>
										</div>
									</div>
								{elseif $_review['node_type'] == "event"}
									<!-- picture -->
									<div class="post-avatar position-relative flex-0">
										<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$system['system_url']}/events/{$_review['event']['event_id']}" style="background-image:url({$_review['event']['event_picture']});"></a>
									</div>
									<!-- picture -->
									<div class="mw-0 mx-2">
										<div class="post-meta">
											<!-- author -->
											<span class="">
												<a class="post-author fw-semibold body-color" href="{$system['system_url']}/events/{$_review['event']['event_id']}">{$_review['event']['event_title']}</a>
											</span>
											<!-- author -->

											<div class="mt-1 review-review">
												{$_review['reply']}
											</div>
										</div>
									</div>
								{elseif $_review['node_type'] == "post"}
									<!-- picture -->
									<div class="post-avatar position-relative flex-0">
										<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$_review['post']['post_author_url']}" style="background-image:url({$_review['post']['post_author_picture']});"></a>
									</div>
									<!-- picture -->
									<div class="mw-0 mx-2">
										<div class="post-meta">
											<!-- author -->
											<span class="">
												<a class="post-author fw-semibold body-color" href="{$_review['post']['post_author_url']}">{$_review['event']['event_title']}</a>
											</span>
											<!-- author -->

											<div class="mt-1 review-review">
												{$_review['reply']}
											</div>
										</div>
									</div>
								{/if}
							</div>
						</div>
					{/if}
					<!-- reply -->
					<!-- actions -->
					{if $_review['manage_review'] && !$_review['reply']}
						<button type="button" class="btn btn-sm btn-primary" data-toggle="modal" data-url="modules/review.php?do=reply&id={$_review['review_id']}">
							{__("Reply")}
						</button>
					{/if}
					<!-- actions -->
				</div>
			</div>
		</div>
		<hr class="mb-0">
	</div>
{/if}