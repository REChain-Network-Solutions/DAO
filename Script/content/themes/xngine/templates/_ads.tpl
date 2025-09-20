{if $_master}

	{if $_ads && !in_array($page, ["static", "settings", "admin"])}
		<!-- ads -->
		{foreach $_ads as $ads_unit}
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Sponsored")}
				</h6>
				<div class="px-3 pt-1 side_item_list">
					{$ads_unit['code']}
				</div>
			</div>
		{/foreach}
		<!-- ads -->
	{/if}

{else}

	{if $ads}
		<!-- ads -->
		{foreach $ads as $ads_unit}
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Sponsored")}
				</h6>
				<div class="px-3 pt-1 side_item_list">
					{$ads_unit['code']}
				</div>
			</div>
		{/foreach}
		<!-- ads -->
	{/if}

{/if}