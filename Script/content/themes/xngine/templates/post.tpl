{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="row x_content_row">
	<!-- left panel -->
	<div class="col-lg-8">
		{include file='__feeds_post.tpl' standalone=true}
		{include file='_ads.tpl' ads=$ads_footer}
	</div>
	<!-- left panel -->

	<!-- right panel -->
	<div class="col-lg-4">
		<!-- upgrade to pro -->	
		{if $system['packages_enabled'] && !$user->_data['user_subscribed']}
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Upgrade to Pro")}
				</h6>
				<div class="px-3 py-0 side_item_list">
					{__("Choose the Plan That's Right for You")}
				</div>
				<div class="px-3 side_item_list">
					<a class="btn btn-main" href="{$system['system_url']}/packages">
						{__("Upgrade")}
					</a>
				</div>
			</div>
		{/if}
		<!-- upgrade to pro -->
		
		{include file='_ads_campaigns.tpl'}
		{include file='_ads.tpl'}
		{include file='_widget.tpl'}
		
		<!-- mini footer -->
		{include file='_footer_mini.tpl'}
		<!-- mini footer -->
	</div>
	<!-- right panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}