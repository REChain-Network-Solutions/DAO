{if $_tpl == "box"}
    <div class="{if $_vsmall}col-md-6 col-lg-4{else}col-md-6 col-lg-3{/if}">
        <div class="ui-box">
            <div class="img">
                <a href="{$system['system_url']}/{$_user['user_name']}">
                    <img alt="" src="{$_user['user_picture']}" />
                </a>
            </div>
            <div class="mt10 truncate">
                <span class="js_user-popover" data-uid="{$_user['user_id']}">
                    <a class="h6" href="{$system['system_url']}/{$_user['user_name']}">
                        {if $system['show_usernames_enabled']}
                            {$_user['user_name']}
                        {else}
                            {$_user['user_firstname']} {$_user['user_lastname']}
                        {/if}
                    </a>
                </span>
                {if $_user['user_verified']}
					<span class="verified-color" data-toggle="tooltip" data-placement="top" title='{__("Verified User")}'><svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg></span>
                {/if}
            </div>
			{if $_user['monetization_plan']}
				<div class="mt10">
					<span class="badge badge-info">{print_money($_user['monetization_plan']['price'])} / {if $_user['monetization_plan']['period_num'] != '1'}{$_user['monetization_plan']['period_num']}{/if} {__($_user['monetization_plan']['period']|ucfirst)}</span>
				</div>
			{/if}
            <div class="mt10">
                <!-- buttons -->
                {if $_connection == "request"}
                    <button type="button" class="btn btn-sm btn-primary js_friend-accept" data-uid="{$_user['user_id']}">{__("Confirm")}</button>
                    <button type="button" class="btn btn-sm btn-danger js_friend-decline" data-uid="{$_user['user_id']}">{__("Decline")}</button>

                {elseif $_connection == "add"}
					{if $system['friends_enabled']}
						<button type="button" class="btn btn-sm btn-success js_friend-add" data-uid="{$_user['user_id']}">
							<i class="fa fa-user-plus mr5"></i>{if $_small}{__("Add")}{else}{__("Add Friend")}{/if}
						</button>
					{else}
						<button type="button" class="btn btn-sm btn-success js_follow" data-uid="{$_user['user_id']}">
							<i class="fa fa-user-plus mr5"></i>{__("Follow")}
						</button>
					{/if}

                {elseif $_connection == "cancel"}
                    <button type="button" class="btn btn-sm btn-warning js_friend-cancel" data-uid="{$_user['user_id']}">
                        <i class="fa fa-clock mr5"></i>{__("Sent")}
                    </button>
					
                {elseif $_connection == "remove"}
					{if $system['friends_enabled']}
						<button type="button" class="btn btn-sm btn-success {if !$_no_action}btn-delete{/if} js_friend-remove" data-uid="{$_user['user_id']}">
							<i class="fa fa-check mr5"></i>{__("Friends")}
						</button>
					{else}
						<button type="button" class="btn btn-sm btn-info js_unfollow" data-uid="{$_user['user_id']}">
							<i class="fa fa-check mr5"></i>{__("Following")}
						</button>
					{/if}
		  
					{if $_top_friends}
						<button type="button" class="btn btn-sm btn-warning p-2 {if $_user['top_friend']}js_friend-unfavorite{else}js_friend-favorite{/if}" data-uid="{$_user['user_id']}">
							{if $_user['top_friend']}
								<i class="fa-solid fa-star"></i>
							{else}
								<i class="fa-regular fa-star"></i>
							{/if}
						</button>
					{/if}

                {elseif $_connection == "follow"}
                    <button type="button" class="btn btn-sm btn-info js_follow" data-uid="{$_user['user_id']}">
                        <i class="fa fa-rss mr5"></i>{__("Follow")}
                    </button>

                {elseif $_connection == "unfollow"}
                    <button type="button" class="btn btn-sm btn-info js_unfollow" data-uid="{$_user['user_id']}">
                        <i class="fa fa-check mr5"></i>{__("Following")}
                    </button>

                {elseif $_connection == "blocked"}
                    <button type="button" class="btn btn-sm btn-danger js_unblock-user" data-uid="{$_user['user_id']}">
                        <i class="fa fa-trash mr5"></i>{__("Unblock")}
                    </button>

                {elseif $_connection == "page_invite"}
                    <button type="button" class="btn btn-info btn-sm js_page-invite" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
                        <i class="fa fa-user-plus mr5"></i>{__("Invite")}
                    </button>

                {elseif $_connection == "page_manage"}
                    <button type="button" class="btn btn-danger js_page-member-remove" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
                        <i class="fa fa-trash mr5"></i>{__("Remove")}
                    </button>
                    {if $_user['i_admin']}
                        <button type="button" class="btn btn-danger js_page-admin-remove" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
                            <i class="fa fa-trash mr5"></i>{__("Remove Admin")}
                        </button>
                    {else}
                        <button type="button" class="btn btn-primary js_page-admin-addation" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
                            <i class="fa fa-check mr5"></i>{__("Make Admin")}
                        </button>
                    {/if}

                {elseif $_connection == "group_invite"}
                    <button type="button" class="btn btn-sm btn-info js_group-invite" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
                        <i class="fa fa-user-plus mr5"></i>{__("Invite")}
                    </button>

                {elseif $_connection == "group_request"}
                    <button type="button" class="btn btn-sm btn-primary js_group-request-accept" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">{__("Approve")}</button>
                    <button type="button" class="btn btn-sm btn-danger js_group-request-decline" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">{__("Decline")}</button>

                {elseif $_connection == "group_manage"}
                    <button type="button" class="btn btn-sm btn-danger js_group-member-remove" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
                        <i class="fa fa-trash mr5"></i>{__("Remove")}
                    </button>
                    {if $_user['i_admin']}
                        <button type="button" class="btn btn-sm btn-danger js_group-admin-remove" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
                            <i class="fa fa-trash mr5"></i>{__("Remove Admin")}
                        </button>
                    {else}
                        <button type="button" class="btn btn-sm btn-primary js_group-admin-addation" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
                            <i class="fa fa-check mr5"></i>{__("Make Admin")}
                        </button>
                    {/if}

                {elseif $_connection == "event_invite"}
                    <button type="button" class="btn btn-sm btn-info js_event-invite" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
                        <i class="fa fa-user-plus mr5"></i> {__("Invite")}
                    </button>

                {elseif $_connection == "unsubscribe"}
					{if $user->_data['user_id'] == $_user['plan_user_id']}
						<button type="button" class="btn btn-sm btn-danger js_unsubscribe-plan" data-id="{$_user['plan_id']}">
							<i class="fa fa-trash mr5"></i> {__("Unsubscribe")}
						</button>
					{/if}

				{/if}
                <!-- buttons -->
            </div>
        </div>
    </div>
{elseif $_tpl == "list"}
    <li class="feeds-item px-3 side_item_hover side_item_list" {if $_user['id']}data-id="{$_user['id']}" {/if}>
		<div class="d-flex align-items-center justify-content-between x_user_info {if $_small}small{/if}">
			<div class="d-flex align-items-center position-relative mw-0">
				<a class="position-relative flex-0" href="{$system['system_url']}/{$_user['user_name']}{if $_search}?ref=qs{/if}">
					<img src="{$_user['user_picture']}" alt="{$_user['user_name']}" class="rounded-circle">
					{if $_reaction}
						<div class="data-reaction">
							<div class="inline-emoji no_animation">
								{include file='__reaction_emojis.tpl' _reaction=$_reaction}
							</div>
						</div>
					{/if}
				</a>
				<div class="mw-0 text-truncate mx-2 px-1">
					<div class="fw-semibold text-truncate">
						<span class="name js_user-popover" data-uid="{$_user['user_id']}">
							<a href="{$system['system_url']}/{$_user['user_name']}{if $_search}?ref=qs{/if}" class="body-color">
								{if $system['show_usernames_enabled']}
									{$_user['user_name']}
								{else}
									{$_user['user_firstname']} {$_user['user_lastname']}
								{/if}
							</a>
						</span>
						{if $_user['user_verified']}
							<span class="verified-badge align-middle d-inline-flex" data-bs-toggle="tooltip" title='{__("Verified User")}'><svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg></span>
						{/if}
						{if $_user['user_subscribed']}
							<span class="pro-badge align-middle d-inline-flex align-items-center small" data-bs-toggle="tooltip" title='{__("Pro User")}'>
								<svg xmlns="http://www.w3.org/2000/svg" height="18" viewBox="0 0 24 24" width="18"><path d="M0 0h24v24H0z" fill="none"></path><path fill="currentColor" d="M12 2.02c-5.51 0-9.98 4.47-9.98 9.98s4.47 9.98 9.98 9.98 9.98-4.47 9.98-9.98S17.51 2.02 12 2.02zm-.52 15.86v-4.14H8.82c-.37 0-.62-.4-.44-.73l3.68-7.17c.23-.47.94-.3.94.23v4.19h2.54c.37 0 .61.39.45.72l-3.56 7.12c-.24.48-.95.31-.95-.22z"></path></svg> <small>PRO</small>
							</span>
						{/if}
						{if $_user['permission']}<span class="badge bg-warning">{__($_user['permission'])|ucfirst}</span>{/if}
					</div>
					{if $system['show_usernames_enabled']}
					{else}
						<p class="m-0 text-muted text-truncate small">@{$_user['user_name']}</p>
					{/if}
					{if $_connection != "me" && $_user['mutual_friends_count'] > 0}
						<p class="m-0 text-muted text-truncate small">
							<span class="" data-toggle="modal" data-url="users/mutual_friends.php?uid={$_user['user_id']}">{$_user['mutual_friends_count']} {__("mutual friends")}</span>
						</p>
					{/if}
					{if $_donation}
						<p class="m-0 text-muted text-truncate small">
							<span class="badge badge-success">{print_money($_donation|number_format:2)}</span>
							<span class="js_moment" data-time="{$_donation_time}">{$_donation_time}</span>
						</p>
					{/if}
					{if $_merits_count}
						<p class="m-0 text-muted text-truncate small">
							{$_merits_count} {__("Merits")}
						</p>
					{/if}
				</div>
			</div>
			{if !$_prusrs == "pro"}
				<div class="flex-0">
					<!-- buttons -->
					{if $_connection == "request"}
						<button type="button" class="btn btn-main btn-sm js_friend-accept" data-uid="{$_user['user_id']}">{__("Confirm")}</button>
						<button type="button" class="btn btn-secondary btn-sm js_friend-decline" data-uid="{$_user['user_id']}">{__("Decline")}</button>

					{elseif $_connection == "add"}
						{if $system['friends_enabled']}
							<button type="button" class="btn btn-success btn-sm js_friend-add" data-uid="{$_user['user_id']}">
								{if $_small}{__("Add")}{else}{__("Add")}{/if}
							</button>
						{else}
							<button type="button" class="btn btn-success btn-sm js_follow" data-uid="{$_user['user_id']}">
								{__("Follow")}
							</button>
						{/if}

					{elseif $_connection == "cancel"}
						<button type="button" class="btn btn-sm btn-default js_friend-cancel" data-uid="{$_user['user_id']}">{__("Sent")}</button>
					
					{elseif $_connection == "remove"}
						{if $system['friends_enabled']}
							<button type="button" class="btn btn-sm btn-success {if !$_no_action}btn-delete{/if} js_friend-remove" data-uid="{$_user['user_id']}">
								{__("Friends")}
							</button>
						{else}
							<button type="button" class="btn btn-sm btn-info js_unfollow" data-uid="{$_user['user_id']}">
								{__("Following")}
							</button>
						{/if}

					{elseif $_connection == "follow"}
						<button type="button" class="btn btn-sm btn-info js_follow" data-uid="{$_user['user_id']}">
							{__("Follow")}
						</button>

					{elseif $_connection == "unfollow"}
						<button type="button" class="btn btn-sm btn-info js_unfollow" data-uid="{$_user['user_id']}">
							{__("Following")}
						</button>

					{elseif $_connection == "blocked"}
						<button type="button" class="btn btn-sm btn-danger js_unblock-user" data-uid="{$_user['user_id']}">
							{__("Unblock")}
						</button>

					{elseif $_connection == "page_invite"}
						<button type="button" class="btn btn-info btn-sm js_page-invite" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
							{__("Invite")}
						</button>

					{elseif $_connection == "page_manage"}
						<button type="button" class="btn btn-danger btn-sm js_page-member-remove" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
							{__("Remove")}
						</button>
						{if $_user['i_admin']}
							<button type="button" class="btn btn-danger btn-sm js_page-admin-remove" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
								{__("Remove Admin")}
							</button>
						{else}
							<button type="button" class="btn btn-main btn-sm js_page-admin-addation" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
								{__("Make Admin")}
							</button>
						{/if}

					{elseif $_connection == "group_invite"}
						<button type="button" class="btn btn-sm btn-info js_group-invite" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
							{__("Invite")}
						</button>

					{elseif $_connection == "group_request"}
						<button type="button" class="btn btn-sm btn-main js_group-request-accept" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">{__("Approve")}</button>
						<button type="button" class="btn btn-sm btn-danger js_group-request-decline" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">{__("Decline")}</button>

					{elseif $_connection == "group_manage"}
						<button type="button" class="btn btn-sm btn-danger js_group-member-remove" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
							{__("Remove")}
						</button>
						{if $_user['i_admin']}
							<button type="button" class="btn btn-sm btn-danger js_group-admin-remove" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
								{__("Remove Admin")}
							</button>
						{else}
							<button type="button" class="btn btn-sm btn-main js_group-admin-addation" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
								{__("Make Admin")}
							</button>
						{/if}

					{elseif $_connection == "event_invite"}
						<button type="button" class="btn btn-sm btn-info js_event-invite" data-id="{$_user['node_id']}" data-uid="{$_user['user_id']}">
							{__("Invite")}
						</button>

					{elseif $_connection == "connected_account_remove"}
						<button type="button" class="btn btn-sm btn-danger js_connected-account-remove" data-uid="{$_user['user_id']}">
							{__("Remove")}
						</button>

					{elseif $_connection == "connected_account_revoke"}
						<button type="button" class="btn btn-sm btn-danger js_connected-account-revoke">
							{__("Revoke")}
						</button>
						
					{/if}
					{if $_merit_category}
						<img src="{$system['system_uploads']}/{$_merit_category['category_image']}" width="32px" height="32px" class="attch_img" title="{$_merit_category['category_name']}" />
					{/if}
					<!-- buttons -->
				</div>
			{/if}
		</div>
    </li>
{/if}
