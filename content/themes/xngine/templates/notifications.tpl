{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="row x_content_row">
	<!-- center panel -->
	<div class="col-lg-8">
		<!-- notifications -->
		<div class="d-flex align-items-center p-3 position-sticky x_top_posts">
			<div class="d-flex align-items-center justify-content-between gap-10 position-relative">
				<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Your Notifications")}</span>
				<span class="flex-0 d-flex align-items-center gap-2 small fw-medium">
					{__("Sound")}
					<label class="switch sm" for="notifications_sound">
						<input type="checkbox" class="js_notifications-sound-toggle" name="notifications_sound" id="notifications_sound" {if $user->_data['notifications_sound']}checked{/if}>
						<span class="slider round"></span>
					</label>
				</span>
			</div>
		</div>
		
		<ul>
			{foreach $user->_data['notifications'] as $notification}
				{include file='__feeds_notification.tpl'}
			{/foreach}
		</ul>

		{if count($user->_data['notifications']) >= $system['max_results']}
			<!-- see-more -->
			<div class="alert alert-post see-more js_see-more" data-get="notifications">
				<span>{__("See More")}</span>
				<div class="loader loader_small x-hidden"></div>
			</div>
			<!-- see-more -->
		{/if}
		<!-- notifications -->
	</div>
	<!-- center panel -->

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