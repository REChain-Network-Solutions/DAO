<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Connected Accounts")}
	</div>
	{if $user->_data['user_id'] == $user->_data['user_master_account']}
		<div class="mt-2">
			<button type="button" class="btn btn-sm btn-primary" data-toggle="modal" data-url="#account-connector">
				{__("Connect Account")}
			</button>
		</div>
	{/if}
</div>

<div class="p-3 pt-1">
	{if count($user->_data['connected_accounts']) > 1}
		{if $user->_data['user_id'] == $user->_data['user_master_account']}
			<ul>
				{foreach $user->_data['connected_accounts'] as $_user}
					{if $_user['user_id'] != $user->_data['user_id']}
						{include file='__feeds_user.tpl' _tpl="list" _connection="connected_account_remove"}
					{/if}
				{/foreach}
			</ul>
		{else}
			<div class="alert alert-info">
				{__("You are connected to this account")}
			</div>
			<ul>
				{foreach $user->_data['connected_accounts'] as $_user}
					{if $_user['user_id'] == $user->_data['user_master_account']}
						{include file='__feeds_user.tpl' _tpl="list" _connection="connected_account_revoke"}
					{/if}
				{/foreach}
			</ul>
		{/if}
	{else}
		{include file='_no_data.tpl'}
	{/if}
</div>