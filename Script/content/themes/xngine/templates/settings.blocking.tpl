<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Manage Blocking")}
	</div>
</div>


<div class="p-3 pt-1">
	<div class="alert alert-warning">
		<div class="text">
			{__("Once you block someone, that person can no longer see things you post on your timeline")}
		</div>
	</div>
	{if $blocks}
		<ul>
			{foreach $blocks as $_user}
				{include file='__feeds_user.tpl' _tpl="list" _connection="blocked"}
			{/foreach}
		</ul>

		{if count($blocks) >= $system['max_results']}
			<!-- see-more -->
			<div class="alert alert-info see-more js_see-more" data-get="blocks">
				<span>{__("See More")}</span>
				<div class="loader loader_small x-hidden"></div>
			</div>
			<!-- see-more -->
		{/if}
	{else}
		{include file='_no_data.tpl'}
	{/if}
</div>