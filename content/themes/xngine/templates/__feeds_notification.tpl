<li class="feeds-item {if !$notification['seen']}unread{/if}" data-id="{$notification['notification_id']}">
	<a class="px-3 side_item_hover side_item_list d-flex align-items-center x_user_info body-color x_notification" href="{$notification['url']}" {if $notification['action'] == "mass_notification"}target="_blank" {/if}>
		<div class="position-relative flex-0">
			<img src="{$notification['user_picture']}" alt="{$notification['name']}" class="rounded-circle large">
			<div class="position-absolute bg-white rounded-circle text-center x_action_icon">
				{if $notification['reaction']}
					<div class="reaction-btn">
						<div class="reaction-btn-icon">
							<div class="inline-emoji no_animation">
								{include file='__reaction_emojis.tpl' _reaction=$notification['reaction']}
							</div>
						</div>
					</div>
				{else}
					<i class="{$notification['icon']} main"></i>
				{/if}
			</div>
		</div>

		<div class="flex-1 mx-2 px-1">
			<div>
				<span class="name fw-semibold">{$notification['name']}</span>
				{if !$notification['system_notification'] && $notification['user_verified']}
					<span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified User")}'>
						<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
					</span>
				{/if}
				{if !$notification['system_notification'] && $notification['user_subscribed']}
					<span class="pro-badge" data-bs-toggle="tooltip" title='{__("Pro User")}'>
						<svg xmlns="http://www.w3.org/2000/svg" height="17" viewBox="0 0 24 24" width="17"><path d="M0 0h24v24H0z" fill="none"></path><path fill="currentColor" d="M12 2.02c-5.51 0-9.98 4.47-9.98 9.98s4.47 9.98 9.98 9.98 9.98-4.47 9.98-9.98S17.51 2.02 12 2.02zm-.52 15.86v-4.14H8.82c-.37 0-.62-.4-.44-.73l3.68-7.17c.23-.47.94-.3.94.23v4.19h2.54c.37 0 .61.39.45.72l-3.56 7.12c-.24.48-.95.31-.95-.22z"></path></svg>
					</span>
				{/if}
				<span>{$notification['message']}</span>
			</div>
			<div class="time small opacity-50 js_moment" data-time="{$notification['time']}">{$notification['time']}</div>
		</div>
	</a>
</li>