<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Apps")}
	</div>
</div>

<div class="p-3 pt-1">
	<div class="alert alert-secondary">
		<div class="text">
			{__("These are apps you've used to log into. They can receive information you chose to share with them.")}
		</div>
	</div>

	{if $apps}
		{foreach $apps as $app}
			<div class="form-table-row mb-2 pb-1">
				<div class="avatar align-self-center">
					<img src="{$system['system_uploads']}/{$app['app_icon']}" width="30" height="30" alt="{$app['app_name']}">
				</div>
				<div>
					<div class="form-label mb0">{$app['app_name']}</div>
					<div class="form-text d-none d-sm-block mt0">{$app['app_description']}</div>
				</div>
				<div class="text-end">
					<button class="btn btn-sm btn-danger js_delete-user-app" data-id="{$app['app_auth_id']}">
						{__("Remove")}
					</button>
				</div>
			</div>
		{/foreach}
	{else}
		{include file='_no_data.tpl'}
	{/if}
</div>