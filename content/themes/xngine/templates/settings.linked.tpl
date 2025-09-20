<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Linked Accounts")}
	</div>
</div>


<div class="p-3 pt-1">
	{if $system['facebook_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				{include file='__svg_icons.tpl' icon="facebook" width="30px" height="30px"}
			</div>
			<div>
				<div class="form-label mb0">{__("Facebook")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['facebook_connected']}
						{__("Your account is connected to")} {__("Facebook")}
					{else}
						{__("Connect your account to")} {__("Facebook")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['facebook_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/facebook">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/facebook">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}

	{if $system['google_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				{include file='__svg_icons.tpl' icon="google" width="30px" height="30px"}
			</div>
			<div>
				<div class="form-label mb0">{__("Google")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['google_connected']}
						{__("Your account is connected to")} {__("Google")}
					{else}
						{__("Connect your account to")} {__("Google")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['google_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/google">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/google">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}

	{if $system['twitter_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				{include file='__svg_icons.tpl' icon="x" width="30px" height="30px"}
			</div>
			<div>
				<div class="form-label mb0">{__("Twitter")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['twitter_connected']}
						{__("Your account is connected to")} {__("Twitter")}
					{else}
						{__("Connect your account to")} {__("Twitter")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['twitter_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/twitter">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/twitter">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}

	{if $system['linkedin_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				{include file='__svg_icons.tpl' icon="linkedin" width="30px" height="30px"}
			</div>
			<div>
				<div class="form-label mb0">{__("Linkedin")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['linkedin_connected']}
						{__("Your account is connected to")} {__("Linkedin")}
					{else}
						{__("Connect your account to")} {__("Linkedin")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['linkedin_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/linkedin">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/linkedin">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}

	{if $system['vkontakte_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				{include file='__svg_icons.tpl' icon="vk" width="30px" height="30px"}
			</div>
			<div>
				<div class="form-label mb0">{__("Vkontakte")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['vkontakte_connected']}
						{__("Your account is connected to")} {__("Vkontakte")}
					{else}
						{__("Connect your account to")} {__("Vkontakte")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['vkontakte_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/vkontakte">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/vkontakte">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}

	{if $system['wordpress_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				{include file='__svg_icons.tpl' icon="wordpress" width="30px" height="30px"}
			</div>
			<div>
				<div class="form-label mb0">{__("Wordpress")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['wordpress_connected']}
						{__("Your account is connected to")} {__("wordpress")}
					{else}
						{__("Connect your account to")} {__("wordpress")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['wordpress_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/wordpress">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/wordpress">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}

	{if $system['Delus_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				<img src="{$system['system_uploads']}/{$system['Delus_app_icon']}" width="30" height="30" alt="{__({$system['Delus_app_name']})}">
			</div>
			<div>
				<div class="form-label mb0">{__({$system['Delus_app_name']})}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['Delus_connected']}
						{__("Your account is connected to")} {__({$system['Delus_app_name']})}
					{else}
						{__("Connect your account to")} {__({$system['Delus_app_name']})}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['Delus_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/Delus">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="https://{$system['Delus_app_domain']}/api/oauth?app_id={$system['Delus_appid']}">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}
</div>