<div class="dropend js_live-notifications">
	<a href="{$system['system_url']}/notifications" class="d-block py-1 body-color x_side_links {if $page == "notifications"}fw-semibold main{/if}">
		<div class="d-inline-flex align-items-center position-relative main_bg_half">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="27" height="27" color="currentColor" fill="none">
				{if $page == "notifications"}
					<path d="M3.92786 9.27697C3.92789 4.84151 7.54419 1.25 12 1.25C16.4558 1.25 20.0721 4.84155 20.0721 9.27703C20.0722 10.3088 20.1416 11.0874 20.6173 11.7873C20.6835 11.8832 20.7712 12.0033 20.8671 12.1345L20.8671 12.1345C21.0337 12.3625 21.2247 12.624 21.3697 12.8505C21.6255 13.2503 21.8754 13.7324 21.9613 14.2942C22.2416 16.127 20.9494 17.3136 19.6625 17.8454C15.1298 19.7182 8.87016 19.7182 4.33746 17.8454C3.05056 17.3136 1.75836 16.127 2.03868 14.2942C2.12459 13.7324 2.37452 13.2503 2.63033 12.8505C2.77528 12.624 2.96636 12.3624 3.13291 12.1345L3.13294 12.1344C3.22882 12.0032 3.31657 11.8831 3.38271 11.7872C3.85838 11.0873 3.92776 10.3087 3.92786 9.27697Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M7.74341 17.7838C8.27717 17.6419 8.82485 17.9596 8.9667 18.4934C9.30659 19.7724 10.5207 20.7502 12.0002 20.7502C13.4798 20.7502 14.6939 19.7724 15.0338 18.4934C15.1756 17.9596 15.7233 17.6419 16.2571 17.7838C16.7908 17.9256 17.1086 18.4733 16.9667 19.0071C16.3896 21.1786 14.3697 22.7502 12.0002 22.7502C9.63084 22.7502 7.61087 21.1786 7.03379 19.0071C6.89194 18.4733 7.20965 17.9256 7.74341 17.7838Z" fill="currentColor"/>
				{else}
					<path d="M2.52992 14.7696C2.31727 16.1636 3.268 17.1312 4.43205 17.6134C8.89481 19.4622 15.1052 19.4622 19.5679 17.6134C20.732 17.1312 21.6827 16.1636 21.4701 14.7696C21.3394 13.9129 20.6932 13.1995 20.2144 12.5029C19.5873 11.5793 19.525 10.5718 19.5249 9.5C19.5249 5.35786 16.1559 2 12 2C7.84413 2 4.47513 5.35786 4.47513 9.5C4.47503 10.5718 4.41272 11.5793 3.78561 12.5029C3.30684 13.1995 2.66061 13.9129 2.52992 14.7696Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M8 19C8.45849 20.7252 10.0755 22 12 22C13.9245 22 15.5415 20.7252 16 19" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
				{/if}
			</svg>
			<span class="counter rounded-pill position-absolute text-center pe-none {if $user->_data['user_live_notifications_counter'] == 0}x-hidden{/if}">
				{$user->_data['user_live_notifications_counter']}
			</span>
			<span class="text">{__("Notifications")}</span>
		</div>
	</a>
	
  <div class="dropdown-menu position-fixed dropdown-widget js_dropdown-keepopen">
    <div class="dropdown-widget-header">
      <span class="title">{__("Notifications")}</span>

    
    </div>
    <div class="dropdown-widget-body">
      <div class="js_scroller">
        {if $user->_data['notifications']}
          <ul>
            {foreach $user->_data['notifications'] as $notification}
              {include file='__feeds_notification.tpl'}
            {/foreach}
          </ul>
        {else}
          <p class="text-center text-muted mt10">
            {__("No notifications")}
          </p>
        {/if}
      </div>
    </div>
    <a class="dropdown-widget-footer" href="{$system['system_url']}/notifications">{__("See All")}</a>
  </div>
</div>