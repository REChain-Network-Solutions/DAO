{if $user->_logged_in}
	<a href="javascript:void(0);" class="body-color dropdownMenuButton dropdownUserMenuButton" data-bs-toggle="dropdown" data-display="static">
		<div class="d-flex align-items-center justify-content-between rounded-pill bg-white main_bg_half x_user_info">
			<div class="d-flex align-items-center position-relative mw-0">
				<img src="{$user->_data['user_picture']}" alt="{$user->_data['user_fullname']}" class="rounded-circle flex-0">
				<div class="mw-0 mx-2 px-1 text-truncate">
					<div class="fw-semibold text-truncate">{$user->_data['user_fullname']}</div>
					<p class="m-0 text-muted text-truncate small">@{$user->_data['user_name']}</p>
				</div>
			</div>
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none" class="flex-0 position-relative"><path d="M11.9959 12H12.0049" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /><path d="M17.9998 12H18.0088" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /><path d="M5.99981 12H6.00879" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg>
		</div>
	</a>
	<div class="dropdown-menu x_mobi_user_menu {if $_as_widget}dropdown-widget{/if}">
		<a class="dropdown-item" href="{$system['system_url']}/{$user->_data['user_name']}">
			<div class="d-flex align-items-center justify-content-between flex-1 x_user_info">
				<div class="d-flex align-items-center position-relative">
					<img src="{$user->_data['user_picture']}" alt="{$user->_data['user_fullname']}" class="rounded-circle flex-0">
					<div class="mw-0 mx-2 px-1">
						<div class="fw-semibold">{$user->_data['user_fullname']}</div>
						<p class="m-0 opacity-50 small">@{$user->_data['user_name']}</p>
					</div>
				</div>
				<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="flex-0 position-relative"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.25 12C1.25 17.9371 6.06294 22.75 12 22.75C17.9371 22.75 22.75 17.9371 22.75 12C22.75 6.06294 17.9371 1.25 12 1.25C6.06294 1.25 1.25 6.06294 1.25 12ZM16.6757 8.26285C17.0828 8.63604 17.1103 9.26861 16.7372 9.67573L11.2372 15.6757C11.0528 15.8768 10.7944 15.9938 10.5217 15.9998C10.249 16.0057 9.98576 15.9 9.79289 15.7071L7.29289 13.2071C6.90237 12.8166 6.90237 12.1834 7.29289 11.7929C7.68342 11.4024 8.31658 11.4024 8.70711 11.7929L10.4686 13.5544L15.2628 8.32428C15.636 7.91716 16.2686 7.88966 16.6757 8.26285Z" fill="#1bc3bb"/></svg>
			</div>
		</a>
		{if $system['switch_accounts_enabled']}
			<div class="dropdown-item pointer" data-toggle="modal" data-url="#account-switcher">
				{__("Switch Accounts")}
			</div>
		{/if}
		<div class="dropdown-divider"></div>
		
		{if $system['points_enabled'] || $system['wallet_enabled']}
			{if $system['wallet_enabled']}
				<a class="dropdown-item" href="{$system['system_url']}/wallet">
					{print_money($user->_data['user_wallet_balance']|number_format:2)} {__("Wallet")}
				</a>
			{/if}
			{if $system['points_enabled']}
				<a class="dropdown-item" href="{$system['system_url']}/settings/points">
					{$user->_data['user_points']} {__("Points")}
				</a>
			{/if}
			<div class="dropdown-divider"></div>
		{/if}

		<a class="dropdown-item" href="{$system['system_url']}/settings{if $detect->isMobile()}?show_categories{/if}">
			{__("Settings")} & {__("Privacy")}
		</a>
		{if $user->_is_admin}
			<div class="dropdown-divider"></div>
			<a class="dropdown-item" href="{$system['system_url']}/admincp">
				{__("Admin Panel")}
			</a>
		{elseif $user->_is_moderator}
			<div class="dropdown-divider"></div>
			<a class="dropdown-item" href="{$system['system_url']}/modcp">
				{__("Moderator Panel")}
			</a>
		{/if}
	  
		{if $system['themes'] && count($system['themes']) > 1}
			<div class="dropdown-item pointer" data-toggle="modal" data-url="#theme-switcher">
				{__("Theme Switcher")}
			</div>
		{/if}
		{if $system['system_theme_mode_select']}
			<div class="dropdown-divider"></div>
			{if $system['theme_mode_night']}
				<div class="dropdown-item pointer js_theme-mode" data-mode="day">
					<span class="js_theme-mode-text">{__("Day Mode")}</span>
				</div>
			{else}
				<div class="dropdown-item pointer js_theme-mode" data-mode="night">
					<span class="js_theme-mode-text">{__("Night Mode")}</span>
				</div>
			{/if}
		{/if}
		<div class="dropdown-divider"></div>
		<a class="dropdown-item" href="{$system['system_url']}/signout/?cache={$secret}" onclick="localStorage.clear();">
			{__("Sign Out")}
		</a>
	</div>
{else}
	<a href="javascript:void(0);" class="body-color dropdownMenuButton dropdownUserMenuButton" data-bs-toggle="dropdown" data-display="static">
		<div class="d-flex align-items-center justify-content-between rounded-pill bg-white main_bg_half x_user_info">
			<div class="d-flex align-items-center position-relative mw-0">
				<div class="rounded-circle flex-0 x_adslist p-2">
					<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 3.20455C7.1424 3.20455 3.20455 7.1424 3.20455 12C3.20455 16.8576 7.1424 20.7955 12 20.7955C16.8576 20.7955 20.7955 16.8576 20.7955 12C20.7955 7.1424 16.8576 3.20455 12 3.20455ZM1.25 12C1.25 6.06294 6.06294 1.25 12 1.25C17.9371 1.25 22.75 6.06294 22.75 12C22.75 17.9371 17.9371 22.75 12 22.75C6.06294 22.75 1.25 17.9371 1.25 12Z" fill="currentColor"/><path d="M8.5 9.5C8.5 7.567 10.067 6 12 6C13.933 6 15.5 7.567 15.5 9.5C15.5 11.433 13.933 13 12 13C10.067 13 8.5 11.433 8.5 9.5Z" fill="currentColor"/><path d="M5.40873 17.6472C6.43247 15.8556 8.3377 14.75 10.4011 14.75H13.5979C15.6613 14.75 17.5666 15.8556 18.5903 17.6472L19.6094 19.5928C17.6634 21.5432 14.9724 22.7499 11.9996 22.7499C9.0267 22.7499 6.33569 21.5431 4.38965 19.5928L5.40873 17.6472Z" fill="currentColor"/></svg>
				</div>
				<div class="mw-0 mx-2 px-1 text-truncate">
					<div class="fw-semibold text-truncate">{__("Join")}</div>
				</div>
			</div>
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none" class="flex-0 position-relative"><path d="M11.9959 12H12.0049" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /><path d="M17.9998 12H18.0088" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /><path d="M5.99981 12H6.00879" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg>
		</div>
	</a>
	<div class="dropdown-menu x_mobi_user_menu {if $_as_widget}dropdown-widget{/if}">
		<a class="dropdown-item" href="{$system['system_url']}/signin">
			{__("Sign In")}
		</a>
		{if $system['registration_enabled']}
			<a class="dropdown-item" href="{$system['system_url']}/signup">
				{__("Sign Up")}
			</a>
		{/if}
		{if ($system['themes'] && count($system['themes']) > 1) || $system['system_theme_mode_select']}
			<div class="dropdown-divider"></div>
		{/if}
		{if $system['themes'] && count($system['themes']) > 1}
			<div class="dropdown-item pointer" data-toggle="modal" data-url="#theme-switcher">
				{__("Theme Switcher")}
			</div>
		{/if}
		{if $system['system_theme_mode_select']}
			{if $system['theme_mode_night']}
				<div class="dropdown-item pointer js_theme-mode" data-mode="day">
					<span class="js_theme-mode-text">{__("Day Mode")}</span>
				</div>
			{else}
				<div class="dropdown-item pointer js_theme-mode" data-mode="night">
					<span class="js_theme-mode-text">{__("Night Mode")}</span>
				</div>
			{/if}
		{/if}
	</div>
{/if}