{foreach $sidebar_friends as $_user}
	<div class="chat-avatar-wrapper clickable js_chat-start" data-uid="{$_user['user_id']}" data-name="{if $system['show_usernames_enabled']}{$_user['user_name']}{else}{$_user['user_firstname']} {$_user['user_lastname']}{/if}" data-link="{$_user['user_name']}" data-picture="{$_user['user_picture']}" data-bs-toggle="tooltip" data-bs-placement="left" title="{if $system['show_usernames_enabled']} {$_user['user_name']} {else} {$_user['user_firstname']} {$_user['user_lastname']} {/if}">
		<div class="chat-avatar position-relative mx-auto">
			<img class="rounded-circle" src="{$_user['user_picture']}" alt="" />
			{if $_user['user_is_online'] }
				<span class="online-dot position-absolute rounded-circle"></span>
			{/if}
		</div>
		{if $system['chat_status_enabled'] && !$_user['user_is_online']}
			<div class="last-seen rounded-2 text-center position-absolute text-white pe-none">
				<span class='js_moment' data-time='{$_user['user_last_seen']}'>{$_user['user_last_seen']}</span>
			</div>
		{/if}
	</div>
{/foreach}