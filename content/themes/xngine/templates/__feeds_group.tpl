{if $_tpl == "box"}
    <li class="px-3 side_item_hover side_item_list d-flex align-items-start gap-3 x_group_list {if $_darker}darker{/if}">
		<a href="{$system['system_url']}/groups/{$_group['group_name']}{if $_search}?ref=qs{/if}" class="flex-0">
			<img alt="{$_group['group_title']}" src="{$_group['group_picture']}" class="rounded-3" />
		</a>

		<div class="flex-1">
			<div class="">
				<a class="text-md fw-semibold body-color" href="{$system['system_url']}/groups/{$_group['group_name']}{if $_search}?ref=qs{/if}">{$_group['group_title']}</a>
				<div class="text-muted small">{$_group['group_members']} {__("Members")}</div>
			</div>
			{if $_group['monetization_plan']}
				<div class="mt-1">
					{print_money($_group['monetization_plan']['price'])} / {if $_group['monetization_plan']['period_num'] != '1'}{$_group['monetization_plan']['period_num']}{/if} {__($_group['monetization_plan']['period']|ucfirst)}
				</div>
			{/if}
			<div class="mt-2 pt-1">
				{if $_connection == 'unsubscribe'}
					{if $user->_data['user_id'] == $_group['plan_user_id']}
						<button type="button" class="btn btn-danger js_unsubscribe-plan" data-id="{$_group['plan_id']}">
							<i class="fa fa-trash"></i> {__("Unsubscribe")}
						</button>
					{/if}
				{else}
					{if $_group['i_joined'] == "approved"}
						<button type="button" class="btn btn-success {if !$_no_action}btn-delete{/if} js_leave-group" data-id="{$_group['group_id']}" data-privacy="{$_group['group_privacy']}">
							<i class="fa fa-check"></i>{__("Joined")}
						</button>
					{elseif $_group['i_joined'] == "pending"}
						<button type="button" class="btn btn-warning js_leave-group" data-id="{$_group['group_id']}" data-privacy="{$_group['group_privacy']}">
							<i class="fa fa-clock"></i>{__("Pending")}
						</button>
					{else}
						<button type="button" class="btn btn-dark js_join-group" data-id="{$_group['group_id']}" data-privacy="{if $user->_data['user_id'] == $_group['group_admin']}public{else}{$_group['group_privacy']}{/if}">
							<i class="fa fa-user-plus"></i>{__("Join")}
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
				<a class="position-relative flex-0" href="{$system['system_url']}/groups/{$_group['group_name']}{if $_search}?ref=qs{/if}">
					<img src="{$_group['group_picture']}" alt="{$_group['group_title']}" class="rounded-circle">
				</a>
				<div class="mw-0 text-truncate mx-2 px-1">
					<div class="fw-semibold text-truncate">
						<a href="{$system['system_url']}/groups/{$_group['group_name']}{if $_search}?ref=qs{/if}" class="body-color">
							{$_group['group_title']}
						</a>
					</div>
					<p class="m-0 text-muted text-truncate small">{$_group['group_members']} {__("Members")}</p>
				</div>
			</div>
			<div class="flex-0">
				<!-- buttons -->
				{if $_group['i_joined'] == "approved"}
					<button type="button" class="btn btn-sm btn-success {if !$_no_action}btn-delete{/if} js_leave-group" data-id="{$_group['group_id']}" data-privacy="{$_group['group_privacy']}">
						{__("Joined")}
					</button>
				{elseif $_group['i_joined'] == "pending"}
					<button type="button" class="btn btn-sm btn-warning js_leave-group" data-id="{$_group['group_id']}" data-privacy="{$_group['group_privacy']}">
						{__("Pending")}
					</button>
				{else}
					<button type="button" class="btn btn-sm btn-dark js_join-group" data-id="{$_group['group_id']}" data-privacy="{if $user->_data['user_id'] == $_group['group_admin']}public{else}{$_group['group_privacy']}{/if}">
						{__("Join")}
					</button>
				{/if}
				<!-- buttons -->
			</div>
		</div>
	</li>
{/if}