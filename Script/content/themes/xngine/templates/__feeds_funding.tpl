<div class="col-sm-12 mb-4 pb-1">
	{if $funding['needs_subscription']}
		<div class="ptb20 plr20">
			{include file='_need_subscription.tpl'}
		</div>
	{else}
		<div class="row">
			<div class="col-md-5 mb-3 mb-md-0">
				<a href="{$system['system_url']}/posts/{$funding['post_id']}" class="d-block ratio ratio-4x3">
					<img src="{$system['system_uploads']}/{$funding['funding']['cover_image']}" class="img-fluid rounded-4 object-cover">
				</a>
			</div>
			<div class="col-md-7 align-self-center x_funding_list">
				<div class="main fw-semibold text-uppercase small mb-1">
					<small class="js_moment" data-time="{$funding['time']}">{$funding['time']}</small>
				</div>

				<h4 class="fw-semibold overflow-hidden"><a href="{$system['system_url']}/posts/{$funding['post_id']}" class="body-color">{$funding['funding']['title']}</a></h4>
				<div class="text overflow-hidden">{$funding['text']|truncate:100}</div>
				
				<div class="progress mt-4">
					<div class="progress-bar bg-success bg-opacity-75" role="progressbar" aria-valuenow="{$funding['funding']['funding_completion']}" aria-valuemin="0" aria-valuemax="100" style="width: {$funding['funding']['funding_completion']}%"></div>
				</div>
				
				<div class="d-flex align-items-center justify-content-between mt-3">
					<div class="flex-0">
						<h5 class="m-0">{print_money($funding['funding']['raised_amount'])}</h5>
						<p class="m-0 text-muted">{__("Raised of")} {print_money($funding['funding']['amount'])}</p>
					</div>
					<a href="{$system['system_url']}/posts/{$funding['post_id']}" class="btn btn-main flex-0" target="_blank">
						{__("Donate")}
						<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M17.5 6.5L6 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M8 6H18V16" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
					</a>
				</div>
			</div>
		</div>
	{/if}
</div>