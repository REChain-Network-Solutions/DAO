<li class="feeds-item px-3 side_item_hover side_item_list x_menu_content_back {if !$conversation['seen']}unread{/if}" data-last-message="{$conversation['last_message_id']}">
	{if $conversation['multiple_recipients']}
		<a class="d-flex align-items-center x_user_info js_chat-start body-color" data-cid="{$conversation['conversation_id']}" data-name="{$conversation['name']}" data-name-list="{$conversation['name_list']}" data-link="{$conversation['link']}" data-multiple="true" href="{$system['system_url']}/messages/{$conversation['conversation_id']}" {if $conversation['node_id']}data-chat-box="true" {/if}>
			<div class="position-relative flex-0">
				{if $conversation['node_id']}
					<img src="{$conversation['picture']}" alt="{$conversation['name']}" class="rounded-circle">
				{else}
					<div class="d-flex align-items-center rounded-circle overflow-hidden x_user_multi_avatar">
						<div class="avatar" style="background-image: url('{$conversation['picture_left']}')"></div>
						<div class="avatar" style="background-image: url('{$conversation['picture_right']}')"></div>
					</div>
				{/if}
			</div>
			<div class="mw-0 flex-1 text-truncate mx-2 px-1 d-flex align-items-center justify-content-between gap-2">
				<div class="mw-0 text-truncate">
					<div class="name fw-semibold">{$conversation['name']}</div>
					<div class="text text-muted text-truncate small">
						{if $conversation['message'] != ''}
							{$conversation['message_orginal']}
						{elseif $conversation['image'] != ''}
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" color="currentColor" fill="none"><path d="M8 8.00049V6.00049C8 3.79135 9.79086 2.00049 12 2.00049C14.2091 2.00049 16 3.79135 16 6.00049V18.0005C16 20.2096 14.2091 22.0005 12 22.0005C9.79086 22.0005 8 20.2096 8 18.0005V13.5005C8 12.1198 9.11929 11.0005 10.5 11.0005C11.8807 11.0005 13 12.1198 13 13.5005V16.0005" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg> {__("Photo")}
						{elseif $conversation['image'] != ''}
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" color="currentColor" fill="none"><path d="M8 8.00049V6.00049C8 3.79135 9.79086 2.00049 12 2.00049C14.2091 2.00049 16 3.79135 16 6.00049V18.0005C16 20.2096 14.2091 22.0005 12 22.0005C9.79086 22.0005 8 20.2096 8 18.0005V13.5005C8 12.1198 9.11929 11.0005 10.5 11.0005C11.8807 11.0005 13 12.1198 13 13.5005V16.0005" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg> {__("Photo")}
						{elseif $conversation['voice_note'] != ''}
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" color="currentColor" fill="none"><path d="M8 8.00049V6.00049C8 3.79135 9.79086 2.00049 12 2.00049C14.2091 2.00049 16 3.79135 16 6.00049V18.0005C16 20.2096 14.2091 22.0005 12 22.0005C9.79086 22.0005 8 20.2096 8 18.0005V13.5005C8 12.1198 9.11929 11.0005 10.5 11.0005C11.8807 11.0005 13 12.1198 13 13.5005V16.0005" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg> {__("Voice Message")}
						{/if}
					</div>
					<small class="d-block"><div class="time opacity-50 small js_moment" data-time="{$conversation['time']}">{$conversation['time']}</div></small>
				</div>
				{if $conversation['image'] != ''}
					<img class="img-fluid rounded-1 attch_img" width="25" height="25" src="{$system['system_uploads']}/{$conversation['image']}" alt="">
				{/if}
			</div>
		</a>
	{else}
		<a class="d-flex align-items-center x_user_info js_chat-start body-color" data-cid="{$conversation['conversation_id']}" data-uid="{$conversation['user_id']}" data-name="{$conversation['name']}" data-name-list="{$conversation['name_list']}" data-link="{$conversation['link']}" data-picture="{$conversation['picture']}" href="{$system['system_url']}/messages/{$conversation['conversation_id']}" {if $conversation['node_id']}data-chat-box="true" {/if}>
			<div class="position-relative flex-0">
				<img src="{$conversation['picture']}" alt="{$conversation['name']}" class="rounded-circle">
			</div>
			<div class="mw-0 flex-1 text-truncate mx-2 px-1 d-flex align-items-center justify-content-between gap-2">
				<div class="mw-0 text-truncate">
					<div class="name fw-semibold">{$conversation['name']}</div>
					<div class="text text-muted text-truncate small">
						{if $conversation['message'] != ''}
							{$conversation['message_orginal']}
						{elseif $conversation['image'] != ''}
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" color="currentColor" fill="none"><path d="M8 8.00049V6.00049C8 3.79135 9.79086 2.00049 12 2.00049C14.2091 2.00049 16 3.79135 16 6.00049V18.0005C16 20.2096 14.2091 22.0005 12 22.0005C9.79086 22.0005 8 20.2096 8 18.0005V13.5005C8 12.1198 9.11929 11.0005 10.5 11.0005C11.8807 11.0005 13 12.1198 13 13.5005V16.0005" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg> {__("Photo")}
						{elseif $conversation['image'] != ''}
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" color="currentColor" fill="none"><path d="M8 8.00049V6.00049C8 3.79135 9.79086 2.00049 12 2.00049C14.2091 2.00049 16 3.79135 16 6.00049V18.0005C16 20.2096 14.2091 22.0005 12 22.0005C9.79086 22.0005 8 20.2096 8 18.0005V13.5005C8 12.1198 9.11929 11.0005 10.5 11.0005C11.8807 11.0005 13 12.1198 13 13.5005V16.0005" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg> {__("Photo")}
						{elseif $conversation['voice_note'] != ''}
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" color="currentColor" fill="none"><path d="M8 8.00049V6.00049C8 3.79135 9.79086 2.00049 12 2.00049C14.2091 2.00049 16 3.79135 16 6.00049V18.0005C16 20.2096 14.2091 22.0005 12 22.0005C9.79086 22.0005 8 20.2096 8 18.0005V13.5005C8 12.1198 9.11929 11.0005 10.5 11.0005C11.8807 11.0005 13 12.1198 13 13.5005V16.0005" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg> {__("Voice Message")}
						{/if}
					</div>
					<small class="d-block"><div class="time opacity-50 small js_moment" data-time="{$conversation['time']}">{$conversation['time']}</div></small>
				</div>
				{if $conversation['image'] != ''}
					<img class="img-fluid rounded-1 attch_img" width="25" height="25" src="{$system['system_uploads']}/{$conversation['image']}" alt="">
				{/if}
			</div>
		</a>
	{/if}
</li>