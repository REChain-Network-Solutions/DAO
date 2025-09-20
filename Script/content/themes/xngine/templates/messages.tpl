{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
.search-wrapper-prnt {
display: none !important
}

@media (max-width: 520px) {
	body:not(.show_menu_sidebar) .main-wrapper {
        padding: 0;
    }
    body:not(.show_menu_sidebar) .search-wrapper-prnt, body:not(.show_menu_sidebar) .x-sidebar-fixed {
        display: none !important;
    }
	body:not(.show_menu_sidebar) .x_menu_sidebar_content {
        min-height: 100dvh;
    }
}
</style>

<!-- page content -->
<div class="w-100 overflow-hidden d-flex bg-white">
	<!-- threads -->
	<div class="x_menu_sidebar d-flex flex-column flex-0 msg x_side_msg_bar {if $view == "message" && $sub_view == "all"}no_hide{/if}">
		<div class="d-flex align-items-center justify-content-between gap-2 p-2 flex-0 w-100">
            <div class="headline-font fw-semibold side_widget_title p-0 m-1">
				{__("Messenger")}
            </div>
            <div class="flex-0 m-1">
				<a class="btn btn-gray border-0 p-2 rounded-circle lh-1 js_chat-new" href="{$system['system_url']}/messages/new">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M14 6H22M18 2L18 10" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M6.09881 19.5C4.7987 19.3721 3.82475 18.9816 3.17157 18.3284C2 17.1569 2 15.2712 2 11.5V11C2 7.22876 2 5.34315 3.17157 4.17157C4.34315 3 6.22876 3 10 3H11.5M6.5 18C6.29454 19.0019 5.37769 21.1665 6.31569 21.8651C6.806 22.2218 7.58729 21.8408 9.14987 21.0789C10.2465 20.5441 11.3562 19.9309 12.5546 19.655C12.9931 19.5551 13.4395 19.5125 14 19.5C17.7712 19.5 19.6569 19.5 20.8284 18.3284C21.947 17.2098 21.9976 15.4403 21.9999 12" stroke="currentColor" stroke-width="2" stroke-linecap="round"></path></svg>
				</a>
            </div>
		</div>
		
		<div class="flex-1 mh-0 js_live-messages-alt">
			<div class="js_scroller h-100" data-slimScroll-height="490px">
				{if $user->_data['conversations']}
					<ul>
						{foreach $user->_data['conversations'] as $_conversation}
							{include file='__feeds_conversation.tpl' conversation=$_conversation}
						{/foreach}
					</ul>
					{if count($user->_data['conversations']) >= $system['max_results']}
						<!-- see-more -->
						<div class="alert alert-post see-more small mlr5 js_see-more" data-get="conversations">
							<span>{__("Load Older Threads")}</span>
							<div class="loader loader_small x-hidden"></div>
						</div>
						<!-- see-more -->
					{/if}
				{/if}
			</div>
        </div>
	</div>
	<!-- threads -->
	
	<!-- conversation -->
	<div class="x_menu_sidebar_content flex-1 js_conversation-container msg">
		{if $view == "new"}
			<div class="panel-messages d-flex flex-column h-100 fresh">
				<div class="d-flex align-items-center justify-content-between gap-2 p-2 flex-0 w-100">
					<div class="headline-font fw-semibold side_widget_title p-0 m-1 d-flex align-items-center gap-3">
						<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" class="flex-0 pointer p-1 x-hidden x_menu_sidebar_back"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
						{__("New Message")}
					</div>
				</div>

				<div class="card-body flex-1 mh-0 d-flex flex-column position-relative">
					<div class="chat-conversations px-2 flex-1 mh-0 js_scroller" data-slimScroll-height="420px"></div>
					<div class="chat-to px-2 gap-2 position-absolute bg-white d-flex align-items-start js_autocomplete-tags">
						<div class="to flex-0 py-1 small">{__("To")}:</div>
						<div class="flex-1 d-flex align-items-center flex-wrap">
							<ul class="tags">
								{if $recipient}
									<li data-uid="{$recipient['user_id']}">{$recipient['user_fullname']}<button type="button" class="btn-close js_tag-remove" title='{__("Remove")}'></button></li>
								{/if}
							</ul>
							<div class="typeahead">
								<input type="text" size="1" autofocus>
							</div>
						</div>
					</div>
					<div class="chat-voice-notes flex-0">
						<div class="voice-recording-wrapper" data-handle="chat">
							<!-- processing message -->
							<div class="x-hidden small fw-medium js_voice-processing-message">
								<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20"><path d="M0 0h24v24H0V0z" fill="none"></path><path fill="#ef4c5d" d="M8 18c.55 0 1-.45 1-1V7c0-.55-.45-1-1-1s-1 .45-1 1v10c0 .55.45 1 1 1zm4 4c.55 0 1-.45 1-1V3c0-.55-.45-1-1-1s-1 .45-1 1v18c0 .55.45 1 1 1zm-8-8c.55 0 1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1v2c0 .55.45 1 1 1zm12 4c.55 0 1-.45 1-1V7c0-.55-.45-1-1-1s-1 .45-1 1v10c0 .55.45 1 1 1zm3-7v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1z"></path></svg> {__("Processing")} <span class="loading-dots"></span>
							</div>
							<!-- processing message -->

							<!-- success message -->
							<div class="x-hidden js_voice-success-message">
								<div class="d-flex align-items-center justify-content-between gap-3">
									<div class="d-flex align-items-center small fw-medium gap-1">
										<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20" class="flex-0"><path d="M0 0h24v24H0V0z" fill="none"/><path fill="#1bc3bb" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM9.29 16.29L5.7 12.7c-.39-.39-.39-1.02 0-1.41.39-.39 1.02-.39 1.41 0L10 14.17l6.88-6.88c.39-.39 1.02-.39 1.41 0 .39.39.39 1.02 0 1.41l-7.59 7.59c-.38.39-1.02.39-1.41 0z"/></svg> {__("Voice note recorded successfully")}
									</div>
									<button type="button" class="btn btn-voice-clear js_voice-remove p-0 text-danger text-opacity-75 flex-0">
										<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M19.5825 15.6564C19.5058 16.9096 19.4449 17.9041 19.3202 18.6984C19.1922 19.5131 18.9874 20.1915 18.5777 20.7849C18.2029 21.3278 17.7204 21.786 17.1608 22.1303C16.5491 22.5067 15.8661 22.6713 15.0531 22.75L8.92739 22.7499C8.1135 22.671 7.42972 22.5061 6.8176 22.129C6.25763 21.7841 5.77494 21.3251 5.40028 20.7813C4.99073 20.1869 4.78656 19.5075 4.65957 18.6917C4.53574 17.8962 4.47623 16.9003 4.40122 15.6453L3.75 4.75H20.25L19.5825 15.6564ZM9.5 17.9609C9.08579 17.9609 8.75 17.6252 8.75 17.2109L8.75 11.2109C8.75 10.7967 9.08579 10.4609 9.5 10.4609C9.91421 10.4609 10.25 10.7967 10.25 11.2109L10.25 17.2109C10.25 17.6252 9.91421 17.9609 9.5 17.9609ZM15.25 11.2109C15.25 10.7967 14.9142 10.4609 14.5 10.4609C14.0858 10.4609 13.75 10.7967 13.75 11.2109V17.2109C13.75 17.6252 14.0858 17.9609 14.5 17.9609C14.9142 17.9609 15.25 17.6252 15.25 17.2109V11.2109Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13.3473 1.28277C13.9124 1.33331 14.4435 1.50576 14.8996 1.84591C15.2369 2.09748 15.4712 2.40542 15.6714 2.73893C15.8569 3.04798 16.0437 3.4333 16.2555 3.8704L16.6823 4.7507H21C21.5523 4.7507 22 5.19842 22 5.7507C22 6.30299 21.5523 6.7507 21 6.7507C14.9998 6.7507 9.00019 6.7507 3 6.7507C2.44772 6.7507 2 6.30299 2 5.7507C2 5.19842 2.44772 4.7507 3 4.7507H7.40976L7.76556 3.97016C7.97212 3.51696 8.15403 3.11782 8.33676 2.79754C8.53387 2.45207 8.76721 2.13237 9.10861 1.87046C9.57032 1.51626 10.1121 1.33669 10.6899 1.28409C11.1249 1.24449 11.5634 1.24994 12 1.25064C12.5108 1.25146 12.97 1.24902 13.3473 1.28277ZM9.60776 4.7507H14.4597C14.233 4.28331 14.088 3.98707 13.9566 3.7682C13.7643 3.44787 13.5339 3.30745 13.1691 3.27482C12.9098 3.25163 12.5719 3.2507 12.0345 3.2507C11.4837 3.2507 11.137 3.25166 10.8712 3.27585C10.4971 3.30991 10.2639 3.45568 10.0739 3.78866C9.94941 4.00687 9.81387 4.29897 9.60776 4.7507Z" fill="currentColor"/></svg>
									</button>
								</div>
							</div>
							<!-- success message -->

							<!-- start recording -->
							<div class="btn btn-voice-start btn-main btn-sm js_voice-start">
								<svg xmlns="http://www.w3.org/2000/svg" height="16" viewBox="0 0 24 24" width="16"><path fill="currentColor" d="M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3zm5.91-3c-.49 0-.9.36-.98.85C16.52 14.2 14.47 16 12 16s-4.52-1.8-4.93-4.15c-.08-.49-.49-.85-.98-.85-.61 0-1.09.54-1 1.14.49 3 2.89 5.35 5.91 5.78V20c0 .55.45 1 1 1s1-.45 1-1v-2.08c3.02-.43 5.42-2.78 5.91-5.78.1-.6-.39-1.14-1-1.14z"></path></svg> {__("Record")}
							</div>
							<!-- start recording -->

							<!-- stop recording -->
							<div class="btn btn-voice-stop btn-danger btn-sm js_voice-stop" style="display: none">
								<svg xmlns="http://www.w3.org/2000/svg" height="18" viewBox="0 0 24 24" width="18"><path fill="currentColor" d="M8 6h8c1.1 0 2 .9 2 2v8c0 1.1-.9 2-2 2H8c-1.1 0-2-.9-2-2V8c0-1.1.9-2 2-2z"></path></svg> {__("Recording")} <span class="js_voice-timer">00:00</span>
							</div>
							<!-- stop recording -->
						</div>
					</div>
					<div class="chat-attachments flex-0 p-2 attachments clearfix x-hidden">
						<ul>
							<li class="loading">
								<div class="progress x-progress">
									<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
								</div>
							</li>
						</ul>
					</div>
					<div class="x-form flex-0 chat-form p-2 bg-white">
						<div class="chat-form-message">
							<textarea class="pt-2 px-3 w-100 m-0 shadow-none border-0 d-block js_autosize js_post-message" dir="auto" rows="1" placeholder='{__("Write a message")}'></textarea>
						</div>
						<ul class="x-form-tools d-flex align-items-center gap-2 pt-2">
							{if $system['chat_photos_enabled']}
								<li class="x-form-tools-attach lh-1">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="js_x-uploader" data-handle="chat"><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75"></path><circle cx="16.5" cy="7.5" r="1.5" stroke="currentColor" stroke-width="1.75"></circle><path d="M16 22C15.3805 19.7749 13.9345 17.7821 11.8765 16.3342C9.65761 14.7729 6.87163 13.9466 4.01569 14.0027C3.67658 14.0019 3.33776 14.0127 3 14.0351" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M13 18C14.7015 16.6733 16.5345 15.9928 18.3862 16.0001C19.4362 15.999 20.4812 16.2216 21.5 16.6617" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path></svg>
								</li>
							{/if}
							{if $system['voice_notes_chat_enabled']}
								<li class="x-form-tools-voice lh-1 js_chat-voice-notes-toggle">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M17 7V11C17 13.7614 14.7614 16 12 16C9.23858 16 7 13.7614 7 11V7C7 4.23858 9.23858 2 12 2C14.7614 2 17 4.23858 17 7Z" stroke="currentColor" stroke-width="1.75"></path><path d="M17 7H14M17 11H14" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M20 11C20 15.4183 16.4183 19 12 19M12 19C7.58172 19 4 15.4183 4 11M12 19V22M12 22H15M12 22H9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
								</li>
							{/if}
							<li class="x-form-tools-emoji lh-1 js_emoji-menu-toggle">
								<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.75" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"> <path stroke="none" d="M0 0h24v24H0z" fill="none"></path> <circle cx="12" cy="12" r="9"></circle> <line x1="9" y1="10" x2="9.01" y2="10"></line> <line x1="15" y1="10" x2="15.01" y2="10"></line> <path d="M9.5 15a3.5 3.5 0 0 0 5 0"></path></svg>
							</li>
							<li type="button" class="x-form-tools-post js_post-message ms-auto btn btn-sm btn-main">
								{__("Send")}
							</li>
						</ul>
					</div>
				</div>
			</div>
		{else}
			{if $conversation}
				{include file='ajax.chat.conversation.tpl'}
			{else}
				<div class="d-flex align-items-center justify-content-between gap-2 p-2 flex-0 w-100">
					<div class="headline-font fw-semibold side_widget_title p-0 m-1 d-flex align-items-center gap-3">
						<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" class="flex-0 pointer p-1 x-hidden x_menu_sidebar_back"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
					</div>
				</div>
				<div class="d-flex align-items-center justify-content-center h-100 x_message_empty_height">
					<div class="text-muted text-center p-3">
						<svg width="56" height="56" class="text-info opacity-75" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M14.15 1.75H9.85C5.79592 1.75 3.76888 1.75 2.50944 3.01407C1.25 4.27813 1.25 6.31261 1.25 10.3816V10.9211C1.25 14.99 1.25 17.0245 2.50944 18.2886C3.09038 18.8716 3.90736 19.2607 4.96365 19.4558C5.28808 19.5158 5.45029 19.5457 5.52074 19.6474C5.5912 19.7492 5.56226 19.9112 5.5044 20.2351C5.36431 21.0194 5.38644 21.7285 5.88937 22.1045C6.41645 22.4893 7.25633 22.0782 8.93611 21.2562C9.12216 21.1651 9.30888 21.0718 9.49596 20.9783L9.49881 20.9768C10.4961 20.4783 11.5124 19.9703 12.5962 19.7199C13.0676 19.6121 13.5475 19.5661 14.15 19.5526C18.2041 19.5526 20.2311 19.5526 21.4906 18.2886C22.75 17.0245 22.75 14.99 22.75 10.9211V10.3816C22.75 6.31261 22.75 4.27813 21.4906 3.01407C20.2311 1.75 18.2041 1.75 14.15 1.75ZM16.75 13.5C16.75 13.9142 16.4142 14.25 16 14.25H8C7.58579 14.25 7.25 13.9142 7.25 13.5C7.25 13.0858 7.58579 12.75 8 12.75H16C16.4142 12.75 16.75 13.0858 16.75 13.5ZM12.75 8.5C12.75 8.91421 12.4142 9.25 12 9.25H8C7.58579 9.25 7.25 8.91421 7.25 8.5C7.25 8.08579 7.58579 7.75 8 7.75H12C12.4142 7.75 12.75 8.08579 12.75 8.5Z" fill="currentColor"/></svg>
						<div class="text-md mt-4">
							<h5 class="headline-font m-0">
								{__("No Conversation Selected")}
							</h5>
						</div>
						<a class="mt-3 btn btn-main js_chat-new" href="{$system['system_url']}/messages/new">
							{__("New Message")}
						</a>
					</div>
				</div>
			{/if}
		{/if}
	</div>
	<!-- conversation -->
</div>
<!-- page content -->

{include file='_footer.tpl'}