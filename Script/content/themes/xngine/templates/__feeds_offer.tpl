<div class="col-md-6 mb-4">
	<div class="x_address h-100 p-3">
		{if $post['needs_subscription']}
			<a href="{$system['system_url']}/posts/{$post['post_id']}">
				{include file='_need_subscription.tpl'}
			</a>
		{else}
			<div class="row">
				<div class="col-3">
					<a href="{$system['system_url']}/posts/{$post['post_id']}" class="d-block ratio ratio-1x1">
						<img src="{$system['system_uploads']}/{$post['offer']['thumbnail']}" class="w-100 h-100 object-cover rounded-2">
					</a>
				</div>
				<div class="col-9 align-self-center">
					{if $_boosted}
						<div class="d-inline-flex rounded-2 fw-medium small text-white boosted-icon mb-1">
							{__("Promoted")}
						</div>
					{/if}
                    <h6 class="text-truncate fw-semibold m-0">
						<a href="{$system['system_url']}/posts/{$post['post_id']}" class="body-color">{$post['offer']['meta_title']}</a>
                    </h6>
                    {if $post['offer']['price']}
						<div class="main mt-1">
							{__("From")} <strong>{print_money($post['offer']['price'])}</strong>
						</div>
                    {/if}
					{if $post['offer']['end_date']}
						<div class="text-muted small">
							{__("Expires")}: {$post['offer']['end_date']|date_format:$system['system_date_format']}
						</div>
                    {/if}
				</div>
			</div>
		{/if}
	</div>
</div>