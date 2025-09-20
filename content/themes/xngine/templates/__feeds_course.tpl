<div class="col-md-6 col-lg-4 mb-4">
	<div class="x_adslist p-3 h-100">
		{if $post['needs_subscription']}
			<a href="{$system['system_url']}/posts/{$post['post_id']}">
				{include file='_need_subscription.tpl'}
			</a>
		{else}
			<a href="{$system['system_url']}/posts/{$post['post_id']}" class="d-block ratio ratio-4x3">
				<img src="{$system['system_uploads']}/{$post['course']['cover_image']}" class="w-100 h-100 object-cover rounded-3">
				{if $_boosted}
					<div>
					<div class="position-absolute m-2 d-inline-flex rounded-2 fw-medium small text-white boosted-icon mb-1">
						{__("Promoted")}
					</div>
					</div>
				{/if}
			</a>
			
			<div class="h5 m-0 text-truncate mt-2">
				<a href="{$system['system_url']}/posts/{$post['post_id']}" class="body-color">{$post['course']['title']}</a>
			</div>
			
			<div class="">
				{print_money($post['course']['fees'], $post['course']['fees_currency']['symbol'], $post['course']['fees_currency']['dir'])}
			</div>
			
			<div class="d-flex align-items-center gap-2 mt-2 text-muted">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M14.5 9C14.5 10.3807 13.3807 11.5 12 11.5C10.6193 11.5 9.5 10.3807 9.5 9C9.5 7.61929 10.6193 6.5 12 6.5C13.3807 6.5 14.5 7.61929 14.5 9Z" stroke="currentColor" stroke-width="1.75"></path><path d="M18.2222 17C19.6167 18.9885 20.2838 20.0475 19.8865 20.8999C19.8466 20.9854 19.7999 21.0679 19.7469 21.1467C19.1724 22 17.6875 22 14.7178 22H9.28223C6.31251 22 4.82765 22 4.25311 21.1467C4.20005 21.0679 4.15339 20.9854 4.11355 20.8999C3.71619 20.0475 4.38326 18.9885 5.77778 17" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M13.2574 17.4936C12.9201 17.8184 12.4693 18 12.0002 18C11.531 18 11.0802 17.8184 10.7429 17.4936C7.6543 14.5008 3.51519 11.1575 5.53371 6.30373C6.6251 3.67932 9.24494 2 12.0002 2C14.7554 2 17.3752 3.67933 18.4666 6.30373C20.4826 11.1514 16.3536 14.5111 13.2574 17.4936Z" stroke="currentColor" stroke-width="1.75"></path></svg>
				<span class="mw-0">{if $post['course']['location']}{$post['course']['location']}{else}{__("N/A")}{/if}</span>
			</div>
			{if $system['posts_reviews_enabled']}
				<div class="d-flex align-items-center gap-2 mt-1 text-muted">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M13.7276 3.44418L15.4874 6.99288C15.7274 7.48687 16.3673 7.9607 16.9073 8.05143L20.0969 8.58575C22.1367 8.92853 22.6167 10.4206 21.1468 11.8925L18.6671 14.3927C18.2471 14.8161 18.0172 15.6327 18.1471 16.2175L18.8571 19.3125C19.417 21.7623 18.1271 22.71 15.9774 21.4296L12.9877 19.6452C12.4478 19.3226 11.5579 19.3226 11.0079 19.6452L8.01827 21.4296C5.8785 22.71 4.57865 21.7522 5.13859 19.3125L5.84851 16.2175C5.97849 15.6327 5.74852 14.8161 5.32856 14.3927L2.84884 11.8925C1.389 10.4206 1.85895 8.92853 3.89872 8.58575L7.08837 8.05143C7.61831 7.9607 8.25824 7.48687 8.49821 6.99288L10.258 3.44418C11.2179 1.51861 12.7777 1.51861 13.7276 3.44418Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
					<span class="mw-0">
						{$post['reviews_count']} {__("Reviews")}
						{if $post['post_rate']}
							({$post['post_rate']|number_format:1})
						{/if}
					</span>
				</div>
			{/if}
			
			{if $post['author_id'] != $user->_data['user_id'] }
				<button type="button" class="btn btn-dark w-100 js_course-enroll" data-toggle="modal" data-size="large" data-url="posts/course.php?do=application&post_id={$post['post_id']}">
					{__("Enroll Now")}
				</button>
			{/if}
		{/if}
	</div>
</div>