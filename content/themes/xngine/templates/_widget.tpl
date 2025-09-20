{if $widgets}
	<!-- Widgets -->
	{foreach $widgets as $widget}
		{if $widget['target_audience'] == 'all' || ($widget['target_audience'] == 'visitors' && !$user->_logged_in) || ($widget['target_audience'] == 'members' && $user->_logged_in)}
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__({$widget['title']})}
				</h6>
				<div class="px-3 pt-1 side_item_list">
					{$widget['code']}
				</div>
			</div>
		{/if}
	{/foreach}
	<!-- Widgets -->
{/if}