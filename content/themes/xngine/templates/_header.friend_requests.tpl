<div class="dropend js_live-requests">
	<a href="{$system['system_url']}/people/friend_requests" class="d-block py-1 body-color x_side_links {if $view == "friend_requests"}fw-semibold main{/if}">
		<div class="d-inline-flex align-items-center position-relative main_bg_half">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="27" height="27" color="currentColor" fill="none">
				{if $view == "friend_requests"}
					<path d="M13.5647 15.2197C14.1348 15.528 15.0292 16.0116 15.6409 16.5861C16.0219 16.9439 16.4159 17.4432 16.4883 18.0782C16.5665 18.7653 16.2485 19.3856 15.6772 19.9078C14.7182 20.7844 13.5522 21.5 12.0399 21.5H4.96015C3.44779 21.5 2.28177 20.7844 1.3228 19.9078C0.751481 19.3856 0.433458 18.7653 0.511739 18.0782C0.584083 17.4432 0.978131 16.9439 1.35906 16.5861C1.97085 16.0116 2.86511 15.528 3.43523 15.2197C3.56216 15.1511 3.67304 15.0911 3.76114 15.0408C6.66339 13.3828 10.3366 13.3828 13.2389 15.0408C13.3269 15.0911 13.4378 15.1511 13.5647 15.2197Z" fill="currentColor"/><path d="M3.59668 7.37838C3.59668 4.68412 5.79187 2.5 8.49977 2.5C11.2077 2.5 13.4029 4.68412 13.4029 7.37838C13.4029 10.0726 11.2077 12.2568 8.49977 12.2568C5.79187 12.2568 3.59668 10.0726 3.59668 7.37838Z" fill="currentColor"/><path d="M13.7776 10.9656C13.572 11.2407 13.4692 11.3783 13.5081 11.5144C13.5471 11.6506 13.6841 11.7128 13.9581 11.8373C14.5282 12.0963 15.1712 12.2419 15.8515 12.2419C18.1982 12.2419 20.1005 10.5088 20.1005 8.37097C20.1005 6.23309 18.1982 4.5 15.8515 4.5C15.5956 4.5 15.345 4.52061 15.1016 4.56011C14.8001 4.60902 14.6494 4.63347 14.5698 4.75422C14.4902 4.87497 14.5465 5.03357 14.6592 5.35075C14.8816 5.97695 15.0017 6.64504 15.0017 7.33871C15.0017 8.68342 14.5502 9.93204 13.7776 10.9656Z" fill="currentColor"/><path d="M18.893 20.5C20.4249 20.5 21.6164 19.9038 22.6072 19.1596C23.1944 18.7186 23.5791 18.1506 23.4862 17.4806C23.4027 16.8788 22.9563 16.4309 22.5711 16.1336C21.94 15.6466 21.0193 15.2377 20.4392 14.98C20.3111 14.9231 20.1996 14.8735 20.1114 14.8322C18.981 14.3015 17.7373 13.9735 16.4669 13.8483C15.6476 13.7676 15.238 13.7272 15.1443 13.9501C15.0507 14.173 15.4155 14.4118 16.1451 14.8893C16.4221 15.0707 16.6902 15.265 16.9254 15.4673C17.4549 15.9226 18.2313 16.7422 18.3777 17.9186C18.4456 18.4638 18.367 18.9661 18.1903 19.4199C17.9799 19.9603 17.8747 20.2305 17.9657 20.3586C17.9715 20.3668 17.9751 20.3713 17.9816 20.3791C18.0837 20.5 18.3534 20.5 18.893 20.5Z" fill="currentColor"/>
				{else}
					<path d="M18.6161 20H19.1063C20.2561 20 21.1707 19.4761 21.9919 18.7436C24.078 16.8826 19.1741 15 17.5 15M15.5 5.06877C15.7271 5.02373 15.9629 5 16.2048 5C18.0247 5 19.5 6.34315 19.5 8C19.5 9.65685 18.0247 11 16.2048 11C15.9629 11 15.7271 10.9763 15.5 10.9312" stroke="currentColor" stroke-width="2" stroke-linecap="round" /><path d="M4.48131 16.1112C3.30234 16.743 0.211137 18.0331 2.09388 19.6474C3.01359 20.436 4.03791 21 5.32572 21H12.6743C13.9621 21 14.9864 20.436 15.9061 19.6474C17.7889 18.0331 14.6977 16.743 13.5187 16.1112C10.754 14.6296 7.24599 14.6296 4.48131 16.1112Z" stroke="currentColor" stroke-width="2" /><path d="M13 7.5C13 9.70914 11.2091 11.5 9 11.5C6.79086 11.5 5 9.70914 5 7.5C5 5.29086 6.79086 3.5 9 3.5C11.2091 3.5 13 5.29086 13 7.5Z" stroke="currentColor" stroke-width="2" />
				{/if}
			</svg>
			<span class="counter rounded-pill position-absolute text-center pe-none {if $user->_data['user_live_requests_counter'] == 0}x-hidden{/if}">
				{$user->_data['user_live_requests_counter']}
			</span>
			<span class="text">{__("Friend Requests")}</span>
		</div>
	</a>
	
  <div class="dropdown-menu position-fixed dropdown-widget js_dropdown-keepopen">
    <div class="dropdown-widget-header">
      <span class="title">{__("Friend Requests")}</span>
    </div>
    <div class="dropdown-widget-body">
      <div class="js_scroller">
        <!-- Friend Requests -->
        {if $user->_data['friend_requests']}
          <ul>
            {foreach $user->_data['friend_requests'] as $_user}
              {include file='__feeds_user.tpl' _tpl="list" _connection="request"}
            {/foreach}
          </ul>
        {else}
          <p class="text-center text-muted mt10">
            {__("No new requests")}
          </p>
        {/if}
        <!-- Friend Requests -->
      </div>
    </div>
    <a class="dropdown-widget-footer" href="{$system['system_url']}/people/friend_requests">{__("See All")}</a>
  </div>
</div>