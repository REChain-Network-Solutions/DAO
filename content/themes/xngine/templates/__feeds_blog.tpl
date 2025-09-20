{if $_tpl == "featured"}
	{if $_iteration == 1}
		<div class="col-12 mb-4">
			<div class="x_feat_blog position-relative overflow-hidden p-3">
				{if $blog['needs_payment']}
					<div class="ptb20 plr20">
						{include file='_need_payment.tpl' post_id=$blog['post_id'] price=$blog['post_price']}
					</div>
				{elseif $blog['needs_subscription']}
					<div class="ptb20 plr20">
						{include file='_need_subscription.tpl'}
					</div>
				{elseif $blog['needs_pro_package']}
					<div class="ptb20 plr20">
						{include file='_need_pro_package.tpl'}
					</div>
				{elseif $blog['needs_age_verification']}
					<div class="ptb20 plr20">
						{include file='_need_age_verification.tpl'}
					</div>
				{else}
					<div class="position-absolute overflow-hidden w-100 h-100 top-0 end-0 bottom-0 start-0 x_feat_blog_bg">
						<div class="x_feat_blog_img_bg">
							<img src="{$blog['blog']['parsed_cover']}" alt="" class="w-100 h-100">
						</div>
						<div class="position-absolute w-100 h-100 top-0 end-0 bottom-0 start-0 x_feat_blog_grad_bg"></div>
					</div>
					<div class="row position-relative">
						<div class="col-md-6 order-2 order-md-1">
							<a href="{if $blog['needs_payment'] || $blog['needs_subscription'] || $blog['needs_pro_package'] || $blog['needs_age_verification']}{$system['system_url']}/posts/{$blog['post_id']}{else}{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}{/if}" class="blog-content text-white d-flex flex-column h-100">
								<h3 class="fw-semibold overflow-hidden">{$blog['blog']['title']}</h3>
								<div class="text small overflow-hidden mb-3">{$blog['blog']['text_snippet']|truncate:200}</div>
								<div class="mt-auto d-flex align-items-center mw-0 x_user_info">
									<img src="{$blog['post_author_picture']}" alt="{$blog['post_author_name']}" class="rounded-circle flex-0">
									<div class="mw-0 mx-2 px-1 text-truncate">
										<div class="fw-semibold text-truncate">{$blog['post_author_name']}</div>
										<p class="m-0 opacity-75 text-truncate small">
											<span class="js_moment" data-time="{$blog['time']}">{$blog['time']}</span>
										</p>
									</div>
								</div>
							</a>
						</div>
						<div class="col-md-6 align-self-center order-1 order-md-2 mb-3 mb-md-0">
							<a href="{if $blog['needs_payment'] || $blog['needs_subscription'] || $blog['needs_pro_package'] || $blog['needs_age_verification']}{$system['system_url']}/posts/{$blog['post_id']}{else}{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}{/if}" class="d-block w-100 blog-image ratio ratio-4x3">
								<img src="{$blog['blog']['parsed_cover']}" class="img-fluid rounded-3 h-100">
							</a>
						</div>
					</div>
				{/if}
			</div>
		</div>
	{else}
		<div class="col-sm-6 col-md-4 col-lg-4 mb-4">
			<a href="{if $blog['needs_payment'] || $blog['needs_subscription'] || $blog['needs_pro_package'] || $blog['needs_age_verification']}{$system['system_url']}/posts/{$blog['post_id']}{else}{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}{/if}" class="blog-container bg-white overflow-hidden d-flex flex-column position-relative body-color h-100">
				{if $blog['needs_payment']}
					<div class="ptb20 plr20">
						{include file='_need_payment.tpl' post_id=$blog['post_id'] price=$blog['post_price']}
					</div>
				{elseif $blog['needs_subscription']}
					<div class="ptb20 plr20">
						{include file='_need_subscription.tpl'}
					</div>
				{elseif $blog['needs_pro_package']}
					<div class="ptb20 plr20">
						{include file='_need_pro_package.tpl'}
					</div>
				{elseif $blog['needs_age_verification']}
					<div class="ptb20 plr20">
						{include file='_need_age_verification.tpl'}
					</div>
				{else}
					<div class="blog-image ratio ratio-4x3 flex-0">
						<img src="{$blog['blog']['parsed_cover']}">
					</div>
					<div class="blog-content p-3 d-flex flex-1 flex-column">
						<h6 class="fw-semibold overflow-hidden">{$blog['blog']['title']}</h6>
						<div class="text text-muted small mb-3 overflow-hidden">{$blog['blog']['text_snippet']|truncate:400}</div>
						<div class="mt-auto d-flex align-items-center mw-0 x_user_info small">
							<img src="{$blog['post_author_picture']}" alt="{$blog['post_author_name']}" class="rounded-circle flex-0">
							<div class="mw-0 mx-2 px-1 text-truncate">
								<div class="fw-medium text-truncate">{$blog['post_author_name']}</div>
								<p class="m-0 text-muted text-truncate small">
									<span class="js_moment" data-time="{$blog['time']}">{$blog['time']}</span>
								</p>
							</div>
						</div>
					</div>
				{/if}
			</a>
		</div>
	{/if}
{else}
	{if $_small}
		{if $blog['needs_payment'] || $blog['needs_subscription'] || $blog['needs_pro_package'] || $blog['needs_age_verification']}
		{else}
			<a href="{if $blog['needs_payment'] || $blog['needs_subscription'] || $blog['needs_pro_package'] || $blog['needs_age_verification']}{$system['system_url']}/posts/{$blog['post_id']}{else}{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}{/if}" class="d-block body-color feeds-item px-3 side_item_hover side_item_list" title="{$blog['blog']['title']}">
				<div class="d-flex align-items-center justify-content-between x_user_info gap-3">
					<div class="mw-0 text-truncate">
						<div class="fw-semibold text-truncate">
							{$blog['blog']['title']}
						</div>
						<p class="m-0 text-muted text-truncate small">
							{$blog['blog']['text_snippet']|truncate:400}
						</p>
					</div>
					<div class="flex-0">
						<img src="{$blog['blog']['parsed_cover']}" class="rounded-2">
					</div>
				</div>
			</a>
		{/if}
	{else}
		<div class="col-md-6 mb-4">
			<a href="{if $blog['needs_payment'] || $blog['needs_subscription'] || $blog['needs_pro_package'] || $blog['needs_age_verification']}{$system['system_url']}/posts/{$blog['post_id']}{else}{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}{/if}" class="blog-container bg-white overflow-hidden d-flex flex-column position-relative body-color h-100">
				{if $blog['needs_payment']}
					<div class="ptb20 plr20">
						{include file='_need_payment.tpl' post_id=$blog['post_id'] price=$blog['post_price']}
					</div>
				{elseif $blog['needs_subscription']}
					<div class="ptb20 plr20">
						{include file='_need_subscription.tpl'}
					</div>
				{elseif $blog['needs_pro_package']}
					<div class="ptb20 plr20">
						{include file='_need_pro_package.tpl'}
					</div>
				{elseif $blog['needs_age_verification']}
					<div class="ptb20 plr20">
						{include file='_need_age_verification.tpl'}
					</div>
				{else}
					<div class="blog-image ratio ratio-4x3 flex-0">
						<img src="{$blog['blog']['parsed_cover']}">
					</div>
					<div class="blog-content p-3 d-flex flex-1 flex-column">
						<h6 class="fw-semibold overflow-hidden">{$blog['blog']['title']}</h6>
						<div class="text text-muted small mb-3 overflow-hidden">{$blog['blog']['text_snippet']|truncate:400}</div>
						<div class="mt-auto d-flex align-items-center mw-0 x_user_info small">
							<img src="{$blog['post_author_picture']}" alt="{$blog['post_author_name']}" class="rounded-circle flex-0">
							<div class="mw-0 mx-2 px-1 text-truncate">
								<div class="fw-medium text-truncate">{$blog['post_author_name']}</div>
								<p class="m-0 text-muted text-truncate small">
									<span class="js_moment" data-time="{$blog['time']}">{$blog['time']}</span>
								</p>
							</div>
						</div>
					</div>
				{/if}
			</a>
		</div>
	{/if}
{/if}