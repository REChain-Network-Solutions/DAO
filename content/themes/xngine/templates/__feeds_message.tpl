<li>
	<div class="conversation clearfix d-flex align-items-start py-1 gap-1 flex-wrap position-relative w-100 {if (isset($is_me) && $is_me) || $message['user_id'] == $user->_data['user_id']}right justify-content-end{/if}" id="{$message['message_id']}">
		{if (!isset($is_me) || !$is_me) && $message['user_id'] != $user->_data['user_id']}
			<a href="{$system['system_url']}/{$message['user_name']}" class="conversation-user overflow-hidden rounded-circle flex-0">
				<img src="{$message['user_picture']}" alt="" class="rounded-circle w-100 h-100">
			</a>
		{/if}
		<div class="conversation-body position-relative d-flex flex-column {if $system['chat_translation_enabled']}js_chat-translator{/if} {if (isset($is_me) && $is_me) || $message['user_id'] == $user->_data['user_id']}align-items-end{else}align-items-start{/if}">
			<!-- message text -->
			<div class="text {if (isset($is_me) && $is_me) || $message['user_id'] == $user->_data['user_id']}js_chat-color-me{/if}">{$message['message']}</div>
			{if $message['image']}
				<span class="main pointer js_lightbox-nodata {if $message['message'] != ''}mt5{/if}" data-image="{$system['system_uploads']}/{$message['image']}">
					<img alt="" class="img-fluid" src="{$system['system_uploads']}/{$message['image']}">
				</span>
			{/if}
			{if $message['voice_note']}
				<audio class="js_audio w-100" id="audio-{$message['message_id']}" controls preload="auto" style="min-width: 220px;">
					<source src="{$system['system_uploads']}/{$message['voice_note']}" type="audio/mpeg">
					<source src="{$system['system_uploads']}/{$message['voice_note']}" type="audio/mp3">
					{__("Your browser does not support HTML5 audio")}
				</audio>
			{/if}
			<!-- message text -->

			<!-- message time -->
			<div class="time js_moment" data-time="{$message['time']}">
				{$message['time']}
			</div>
			<!-- message time -->
			
			{if $system['chat_translation_enabled']}
				<!-- message translation -->
				<div class="translate">
				  {__("Tap to translate")}
				</div>
				<!-- message translation -->
			{/if}

			<!-- seen status -->
			{if $conversation['last_seen_message_id'] == $message['message_id']}
				<div class="seen">
					{__("Seen by")} <span class="js_seen-name-list">{$conversation['seen_name_list']}</span>
				</div>
			{/if}
			<!-- seen status -->
		</div>
	</div>
</li>