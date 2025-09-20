<div class="dropend js_live-messages">
	<a href="{$system['system_url']}/messages" class="d-block py-1 body-color x_side_links {if $page == "messages"}fw-semibold main{/if}">
		<div class="d-inline-flex align-items-center position-relative main_bg_half">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="27" height="27" color="currentColor" fill="none">
				{if $page == "messages"}
					<path fill-rule="evenodd" clip-rule="evenodd" d="M14.15 1.75H9.85C5.79592 1.75 3.76888 1.75 2.50944 3.01407C1.25 4.27813 1.25 6.31261 1.25 10.3816V10.9211C1.25 14.99 1.25 17.0245 2.50944 18.2886C3.09038 18.8716 3.90736 19.2607 4.96365 19.4558C5.28808 19.5158 5.45029 19.5457 5.52074 19.6474C5.5912 19.7492 5.56226 19.9112 5.5044 20.2351C5.36431 21.0194 5.38644 21.7285 5.88937 22.1045C6.41645 22.4893 7.25633 22.0782 8.93611 21.2562C9.12216 21.1651 9.30888 21.0718 9.49596 20.9783L9.49881 20.9768C10.4961 20.4783 11.5124 19.9703 12.5962 19.7199C13.0676 19.6121 13.5475 19.5661 14.15 19.5526C18.2041 19.5526 20.2311 19.5526 21.4906 18.2886C22.75 17.0245 22.75 14.99 22.75 10.9211V10.3816C22.75 6.31261 22.75 4.27813 21.4906 3.01407C20.2311 1.75 18.2041 1.75 14.15 1.75ZM16.75 13.5C16.75 13.9142 16.4142 14.25 16 14.25H8C7.58579 14.25 7.25 13.9142 7.25 13.5C7.25 13.0858 7.58579 12.75 8 12.75H16C16.4142 12.75 16.75 13.0858 16.75 13.5ZM12.75 8.5C12.75 8.91421 12.4142 9.25 12 9.25H8C7.58579 9.25 7.25 8.91421 7.25 8.5C7.25 8.08579 7.58579 7.75 8 7.75H12C12.4142 7.75 12.75 8.08579 12.75 8.5Z" fill="currentColor"/>
				{else}
					<path d="M8 13.5H16M8 8.5H12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M6.09881 19C4.7987 18.8721 3.82475 18.4816 3.17157 17.8284C2 16.6569 2 14.7712 2 11V10.5C2 6.72876 2 4.84315 3.17157 3.67157C4.34315 2.5 6.22876 2.5 10 2.5H14C17.7712 2.5 19.6569 2.5 20.8284 3.67157C22 4.84315 22 6.72876 22 10.5V11C22 14.7712 22 16.6569 20.8284 17.8284C19.6569 19 17.7712 19 14 19C13.4395 19.0125 12.9931 19.0551 12.5546 19.155C11.3562 19.4309 10.2465 20.0441 9.14987 20.5789C7.58729 21.3408 6.806 21.7218 6.31569 21.3651C5.37769 20.6665 6.29454 18.5019 6.5 17.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
				{/if}
			</svg>
			<span class="counter rounded-pill position-absolute text-center pe-none {if $user->_data['user_live_messages_counter'] == 0}x-hidden{/if}">
				{$user->_data['user_live_messages_counter']}
			</span>
			<span class="text">{__("Messages")}</span>
		</div>
	</a>
	<div class="dropdown-menu position-fixed dropdown-widget">
		<div class="dropdown-widget-header">
			<span class="title">{__("Messages")}</span>
			<a class="float-end text-link js_chat-new" href="{$system['system_url']}/messages/new">{__("Send a New Message")}</a>
		</div>
		<div class="dropdown-widget-body">
			<div class="js_scroller">
				{if $user->_data['conversations']}
				<ul>
					{foreach $user->_data['conversations'] as $conversation}
						{include file='__feeds_conversation.tpl'}
					{/foreach}
				</ul>
				{else}
				<p class="text-center text-muted mt10">
					{__("No messages")}
				</p>
				{/if}
			</div>
		</div>
		<a class="dropdown-widget-footer" href="{$system['system_url']}/messages">{__("See All")}</a>
	</div>
</div>