<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Membership")}
	</div>
</div>

<div class="p-3 pt-1">
	{if $user->_data['user_subscribed']}
		<div class="heading-small mb-1">
			{__("Package Details")}
		</div>
		<div class="row form-group">
			<label class="col-md-3 form-label fw-medium">
				{__("Package")}
			</label>
			<div class="col-md-9">
				<p class="">
					{__($user->_data['package_name'])} ({print_money($user->_data['price'])}
					{if $user->_data['period'] == "life"}{__("Life Time")}{else}{__("per")} {if $user->_data['period_num'] != '1'}{$user->_data['period_num']}{/if} {__($user->_data['period']|ucfirst)}{/if})
				</p>
			</div>
		</div>
		
		<div class="row form-group">
			<label class="col-md-3 form-label fw-medium">
				{__("Subscription Date")}
			</label>
			<div class="col-md-9">
				<p class="">
					{$user->_data['user_subscription_date']|date_format:"%e/%m/%Y"}
				</p>
			</div>
		</div>
		
		<div class="row form-group">
			<label class="col-md-3 form-label fw-medium">
				{__("Expiration Date")}
			</label>
			<div class="col-md-9">
				<p class="">
					{if $user->_data['period'] == "life"}
						{__("Life Time")}
					{else}
						{$user->_data['subscription_end']|date_format:"%e/%m/%Y"} ({if $user->_data['subscription_timeleft'] > 0}{__("Remaining")} {$user->_data['subscription_timeleft']} {__("Days")}{else}{__("Expired")}{/if})
					{/if}
				</p>
			</div>
		</div>
		
		<div class="row form-group">
			<label class="col-md-3 form-label fw-medium">
				{__("Boosted Posts")}
			</label>
			<div class="col-md-9">
				<p class="mb-1">
					{$user->_data['user_boosted_posts']}/{$user->_data['boost_posts']} (<a href="{$system['system_url']}/boosted/posts">{__("Manage")}</a>)
				</p>

				<div class="progress mb-2">
					<div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="{if $user->_data['boost_posts'] == 0}0{else}{($user->_data['user_boosted_posts']/$user->_data['boost_posts'])*100}{/if}" aria-valuemin="0" aria-valuemax="100" style="width: {if $user->_data['boost_posts'] == 0}0{else}{($user->_data['user_boosted_posts']/$user->_data['boost_posts'])*100}{/if}%"></div>
				</div>
			</div>
		</div>
		
		<div class="row form-group">
			<label class="col-md-3 form-label fw-medium">
				{__("Boosted Pages")}
			</label>
			<div class="col-md-9">
				<p class="mb-1">
					{$user->_data['user_boosted_pages']}/{$user->_data['boost_pages']} (<a href="{$system['system_url']}/boosted/pages">{__("Manage")}</a>)
				</p>

				<div class="progress mb-2">
					<div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="{if $user->_data['boost_pages'] == 0}0{else}{($user->_data['user_boosted_pages']/$user->_data['boost_pages'])*100}{/if}" aria-valuemin="0" aria-valuemax="100" style="width: {if $user->_data['boost_pages'] == 0}0{else}{($user->_data['user_boosted_pages']/$user->_data['boost_pages'])*100}{/if}%"></div>
				</div>
			</div>
		</div>

		{if !$user->_data['can_pick_categories']}
			<div class="row form-group">
				<div class="col-md-9 offset-md-3 mt-2">
					<button type="button" class="btn btn-sm btn-danger js_unsubscribe-package">
						{__("Unsubscribe")}
					</button>
				</div>
			</div>
		{/if}

		{if $user->_data['can_pick_categories']}
			<form class="js_ajax-forms pt-2" data-url="users/settings.php?edit=membership">
				{if $user->_data['allowed_videos_categories'] > 0}
					<div class="form-floating">
						<input type="text" class="js_tagify-ajax" data-handle="video_categories" name="package_videos_categories" value="{$user->_data['user_package_videos_categories']}" placeholder=" ">
						<label class="form-label">{__("Videos Categories")}</label>
						<div class="form-text">
							{__("You can select")} {$user->_data['allowed_videos_categories']} {__("categories")}
						</div>
					</div>
				{/if}

				{if $user->_data['allowed_blogs_categories'] > 0}
					<div class="form-floating">
						<input type="text" class="js_tagify-ajax" data-handle="blogs_categories" name="package_blogs_categories" value="{$user->_data['user_package_blogs_categories']}" placeholder=" ">
						<label class="form-label">{__("Blogs Categories")}</label>
						<div class="form-text">
							{__("You can select")} {$user->_data['allowed_blogs_categories']} {__("categories")}
						</div>
					</div>
				{/if}

				<div class="text-center">
					<button type="button" class="btn btn-danger js_unsubscribe-package">
						{__("Unsubscribe")}
					</button>
					<button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
				</div>

				<!-- success -->
				<div class="alert alert-success mt15 mb0 x-hidden"></div>
				<!-- success -->

				<!-- error -->
				<div class="alert alert-danger mt15 mb0 x-hidden"></div>
				<!-- error -->
			</form>
		{/if}

		<hr>
		
		<div class="heading-small mb-1">
			{__("Upgrade Package")}
		</div>
		<div class="">
			<a href="{$system['system_url']}/packages" class="btn btn-success">{__("Upgrade Package")}</a>
		</div>
	{else}
		<div class="">
			<a href="{$system['system_url']}/packages" class="btn btn-success">{__("Upgrade to Pro")}</a>
		</div>
	{/if}
</div>