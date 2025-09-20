{if $_tpl == "box"}
	<li class="px-3 side_item_hover side_item_list d-flex align-items-start gap-3 x_group_list {if $_darker}darker{/if}">
		<a href="{$system['system_url']}/pages/{$_page['page_name']}{if $_search}?ref=qs{/if}" class="flex-0">
			<img alt="{$_page['page_title']}" src="{$_page['page_picture']}" class="rounded-circle" />
		</a>

		<div class="flex-1">
			<div class="">
				<span class="js_user-popover" data-uid="{$_page['page_id']}" data-type="page">
					<a class="text-md fw-semibold body-color" href="{$system['system_url']}/pages/{$_page['page_name']}{if $_search}?ref=qs{/if}">{$_page['page_title']}</a>
				</span>
				{if $_page['page_verified']}
					<span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified Page")}'>
						<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
					</span>
				{/if}
				<div class="text-muted small">{$_page['page_likes']} {__("Likes")}</div>
			</div>
			{if $_page['monetization_plan']}
				<div class="mt-1">
					{print_money($_page['monetization_plan']['price'])} / {if $_page['monetization_plan']['period_num'] != '1'}{$_page['monetization_plan']['period_num']}{/if} {__($_page['monetization_plan']['period']|ucfirst)}
				</div>
			{/if}
			<div class="mt-2 pt-1">
				{if $_connection == 'unsubscribe'}
					{if $user->_data['user_id'] == $_page['plan_user_id']}
						<button type="button" class="btn btn-danger js_unsubscribe-plan" data-id="{$_page['plan_id']}">
							<i class="fa fa-trash"></i> {__("Unsubscribe")}
						</button>
					{/if}
				{else}
					{if $_page['i_like']}
						<button type="button" class="btn btn-primary js_unlike-page" data-id="{$_page['page_id']}">
							<i class="fa fa-heart"></i>{__("Unlike")}
						</button>
					{else}
						<button type="button" class="btn btn-dark js_like-page" data-id="{$_page['page_id']}">
							<i class="fa fa-heart"></i>{__("Like")}
						</button>
					{/if}
				{/if}
			</div>
		</div>
    </li>
{elseif $_tpl == "list"}
	<li class="feeds-item px-3 side_item_hover side_item_list">
		<div class="d-flex align-items-center justify-content-between x_user_info {if $_small}small{/if}">
			<div class="d-flex align-items-center position-relative mw-0">
				<a class="position-relative flex-0" href="{$system['system_url']}/pages/{$_page['page_name']}{if $_search}?ref=qs{/if}">
					<img src="{$_page['page_picture']}" alt="{$_page['page_title']}" class="rounded-circle">
				</a>
				<div class="mw-0 text-truncate mx-2 px-1">
					<div class="fw-semibold text-truncate">
						<span class="name js_user-popover" data-uid="{$_page['page_id']}" data-type="page">
							<a href="{$system['system_url']}/pages/{$_page['page_name']}{if $_search}?ref=qs{/if}" class="body-color">
								{$_page['page_title']}
							</a>
						</span>
						{if $_page['page_verified']}
							<span class="verified-badge align-middle d-inline-flex" data-bs-toggle="tooltip" title='{__("Verified Page")}'><svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg></span>
						{/if}
					</div>
					<p class="m-0 text-muted text-truncate small">{$_page['page_likes']} {__("Likes")}</p>
				</div>
			</div>
			<div class="flex-0">
				<!-- buttons -->
				{if $_page['i_like']}
					<button type="button" class="btn btn-sm btn-light js_unlike-page" data-id="{$_page['page_id']}">
						{__("Unlike")}
					</button>
				{else}
					<button type="button" class="btn btn-sm btn-dark js_like-page" data-id="{$_page['page_id']}">
						{__("Like")}
					</button>
				{/if}
				<!-- buttons -->
			</div>
		</div>
	</li>
{/if}