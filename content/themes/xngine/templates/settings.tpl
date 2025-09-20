{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
.search-wrapper-prnt {
display: none !important
}
</style>

<!-- page content -->
<div class="w-100 d-flex bg-white">
    <!-- left panel -->
    <div class="x_menu_sidebar flex-0 x_side_msg_bar {if $view == "" && $show_categories}no_hide{/if}">
		<div class="p-3 w-100">
            <div class="headline-font fw-semibold side_widget_title p-0">
				{__("Settings")}
            </div>
		</div>
		<ul class="side-nav x_settings position-sticky top-0 pb-3">
            <li {if $view == "" && !$show_categories}class="active" {/if}>
				<a href="{$system['system_url']}/settings" class="main_bg_half position-relative">
					{__("Account Settings")}
				</a>
            </li>

            <li {if $view == "profile"}class="active" {/if}>
				<a href="#info-settings" class="main_bg_half position-relative" data-bs-toggle="collapse" {if $view == "profile"}aria-expanded="true" {/if}>
					{__("Edit Profile")}
				</a>
				<div class='collapse {if $view == "profile"}show{/if}' id="info-settings">
					<ul>
						<li {if $view == "profile" && $sub_view == ""}class="active" {/if}>
							<a href="{$system['system_url']}/settings/profile">
								{__("Basic")}
							</a>
						</li>
						{if $system['work_info_enabled']}
							<li {if $view == "profile" && $sub_view == "work"}class="active" {/if}>
								<a href="{$system['system_url']}/settings/profile/work">
									{__("Work")}
								</a>
							</li>
						{/if}
						{if $system['location_info_enabled']}
							<li {if $view == "profile" && $sub_view == "location"}class="active" {/if}>
								<a href="{$system['system_url']}/settings/profile/location">
									{__("Location")}
								</a>
							</li>
						{/if}
						{if $system['education_info_enabled']}
							<li {if $view == "profile" && $sub_view == "education"}class="active" {/if}>
								<a href="{$system['system_url']}/settings/profile/education">
									{__("Education")}
								</a>
							</li>
						{/if}
						{if $custom_fields['other']}
							<li {if $view == "profile" && $sub_view == "other"}class="active" {/if}>
								<a href="{$system['system_url']}/settings/profile/other">
									{__("Other")}
								</a>
							</li>
						{/if}
						{if $system['social_info_enabled']}
							<li {if $view == "profile" && $sub_view == "social"}class="active" {/if}>
								<a href="{$system['system_url']}/settings/profile/social">
									{__("Social Links")}
								</a>
							</li>
						{/if}
						{if $system['system_profile_background_enabled']}
							<li {if $view == "profile" && $sub_view == "design"}class="active" {/if}>
								<a href="{$system['system_url']}/settings/profile/design">
									{__("Design")}
								</a>
							</li>
						{/if}
					</ul>
				</div>
            </li>

            <li {if $view == "security"}class="active" {/if}>
				<a href="#security-settings" class="main_bg_half position-relative" data-bs-toggle="collapse" {if $view == "security"}aria-expanded="true" {/if}>
					{__("Security Settings")}
				</a>
				<div class='collapse {if $view == "security"}show{/if}' id="security-settings">
					<ul>
						<li {if $view == "security" && $sub_view == "password"}class="active" {/if}>
							<a href="{$system['system_url']}/settings/security/password">
								{__("Password")}
							</a>
						</li>
						<li {if $view == "security" && $sub_view == "sessions"}class="active" {/if}>
							<a href="{$system['system_url']}/settings/security/sessions">
								{__("Manage Sessions")}
							</a>
						</li>
						{if $system['two_factor_enabled']}
							<li {if $view == "security" && $sub_view == "two-factor"}class="active" {/if}>
								<a href="{$system['system_url']}/settings/security/two-factor">
									{__("Two-Factor Authentication")}
								</a>
							</li>
						{/if}
					</ul>
				</div>
            </li>

            <hr class="my-2">

            <li {if $view == "notifications"}class="active" {/if}>
				<a href="{$system['system_url']}/settings/notifications" class="main_bg_half position-relative">
					{__("Notifications")}
				</a>
            </li>

            {if $system['verification_requests']}
				<li {if $view == "verification"}class="active" {/if}>
					<a href="{$system['system_url']}/settings/verification" class="main_bg_half position-relative">
						{__("Verification")}
					</a>
				</li>
            {/if}

            <hr class="my-2">

            <li {if $view == "privacy"}class="active" {/if}>
				<a href="{$system['system_url']}/settings/privacy" class="main_bg_half position-relative">
					{__("Privacy")}
				</a>
            </li>

            <li {if $view == "blocking"}class="active" {/if}>
				<a href="{$system['system_url']}/settings/blocking" class="main_bg_half position-relative">
					{__("Blocking")}
				</a>
            </li>

            {if $system['switch_accounts_enabled'] || $system['social_login_enabled']}
				<hr class="my-2">
            {/if}

            {if $system['switch_accounts_enabled']}
				<li {if $view == "accounts"}class="active" {/if}>
					<a href="{$system['system_url']}/settings/accounts" class="main_bg_half position-relative">
						{__("Connected Accounts")}
					</a>
				</li>
            {/if}

            {if $system['social_login_enabled']}
				{if $system['facebook_login_enabled'] || $system['google_login_enabled'] || $system['twitter_login_enabled'] || $system['linkedin_login_enabled'] || $system['vkontakte_login_enabled'] || $system['wordpress_login_enabled'] || $system['Delus_login_enabled']}
					<li {if $view == "linked"}class="active" {/if}>
						<a href="{$system['system_url']}/settings/linked" class="main_bg_half position-relative">
							{__("Linked Accounts")}
						</a>
					</li>
				{/if}
            {/if}

            {if $system['packages_enabled'] || $user->_data['can_monetize_content'] || $user->_data['can_invite_users'] || $system['affiliates_enabled'] || $system['points_enabled'] || $user->_data['can_sell_products'] || $user->_data['can_raise_funding'] || $system['coinpayments_enabled'] || $system['bank_transfers_enabled']}
				<hr class="my-2">
            {/if}

            {if $system['packages_enabled']}
				<li {if $view == "membership"}class="active" {/if}>
					<a href="{$system['system_url']}/settings/membership" class="main_bg_half position-relative">
						{__("Membership")}
					</a>
				</li>
            {/if}

            {if $user->_data['can_monetize_content']}
				<li {if $view == "monetization"}class="active" {/if}>
					<a href="#monetization-settings" class="main_bg_half position-relative" data-bs-toggle="collapse" {if $view == "monetization"}aria-expanded="true" {/if}>
						{__("Monetization")}
					</a>
					<div class='collapse {if $view == "monetization"}show{/if}' id="monetization-settings">
						<ul>
							<li {if $view == "monetization" && $sub_view == ""}class="active" {/if}>
								<a href="{$system['system_url']}/settings/monetization">
									{__("Settings")}
								</a>
							</li>
							{if $system['monetization_money_withdraw_enabled']}
								<li {if $view == "monetization" && $sub_view == "payments"}class="active" {/if}>
									<a href="{$system['system_url']}/settings/monetization/payments">
										{__("Payments")}
									</a>
								</li>
							{/if}
							<li {if $view == "monetization" && $sub_view == "earnings"}class="active" {/if}>
								<a href="{$system['system_url']}/settings/monetization/earnings">
									{__("Earnings")}
								</a>
							</li>
						</ul>
					</div>
				</li>
            {/if}

            {if $user->_data['can_invite_users']}
				<li {if $view == "invitations"}class="active" {/if}>
					<a href="{$system['system_url']}/settings/invitations" class="main_bg_half position-relative">
						{__("Invitations")}
					</a>
				</li>
            {/if}

            {if $system['affiliates_enabled']}
				<li {if $view == "affiliates"}class="active" {/if}>
					<a href="#affiliates-settings" class="main_bg_half position-relative" data-bs-toggle="collapse" {if $view == "affiliates"}aria-expanded="true" {/if}>
						{__("Affiliates")}
					</a>
					<div class='collapse {if $view == "affiliates"}show{/if}' id="affiliates-settings">
						<ul>
							<li {if $view == "affiliates" && $sub_view == ""}class="active" {/if}>
								<a href="{$system['system_url']}/settings/affiliates">
									{__("My Affiliates")}
								</a>
							</li>
							{if $system['affiliates_money_withdraw_enabled']}
								<li {if $view == "affiliates" && $sub_view == "payments"}class="active" {/if}>
									<a href="{$system['system_url']}/settings/affiliates/payments">
										{__("Payments")}
									</a>
								</li>
							{/if}
						</ul>
					</div>
				</li>
            {/if}

            {if $system['points_enabled']}
				<li {if $view == "points"}class="active" {/if}>
					<a href="#points-settings" class="main_bg_half position-relative" data-bs-toggle="collapse" {if $view == "points"}aria-expanded="true" {/if}>
						{__("Points")}
					</a>
					<div class='collapse {if $view == "points"}show{/if}' id="points-settings">
						<ul>
							<li {if $view == "points" && $sub_view == ""}class="active" {/if}>
								<a href="{$system['system_url']}/settings/points">
									{__("My Points")}
								</a>
							</li>
							{if $system['points_per_currency'] > 0 && $system['points_money_withdraw_enabled']}
								<li {if $view == "points" && $sub_view == "payments"}class="active" {/if}>
									<a href="{$system['system_url']}/settings/points/payments">
										{__("Payments")}
									</a>
								</li>
							{/if}
						</ul>
					</div>
				</li>
            {/if}

            {if $user->_data['can_sell_products'] && $system['market_shopping_cart_enabled']}
				<li {if $view == "market"}class="active" {/if}>
					<a href="{$system['system_url']}/settings/market" class="main_bg_half position-relative">
						{__("Marketplace")}
					</a>
				</li>
            {/if}

            {if $user->_data['can_raise_funding']}
				<li {if $view == "funding"}class="active" {/if}>
					<a href="{$system['system_url']}/settings/funding" class="main_bg_half position-relative">
						{__("Funding")}
					</a>
				</li>
            {/if}

            {if $system['coinpayments_enabled']}
				<li {if $view == "coinpayments"}class="active" {/if}>
					<a href="{$system['system_url']}/settings/coinpayments" class="main_bg_half position-relative">
						{__("CoinPayments")}
					</a>
				</li>
            {/if}

            {if $system['bank_transfers_enabled']}
				<li {if $view == "bank"}class="active" {/if}>
					<a href="{$system['system_url']}/settings/bank" class="main_bg_half position-relative">
						{__("Bank Transfers")}
					</a>
				</li>
            {/if}

            {if $system['developers_apps_enabled']}
				<hr class="my-2">

				<li {if $view == "apps"}class="active" {/if}>
					<a href="{$system['system_url']}/settings/apps" class="main_bg_half position-relative">
						{__("Apps")}
					</a>
				</li>
            {/if}

            {if $system['download_info_enabled'] || $system['delete_accounts_enabled']}
				<hr class="my-2">
            {/if}

            <li {if $view == "addresses"}class="active" {/if}>
				<a href="{$system['system_url']}/settings/addresses" class="main_bg_half position-relative">
					{__("Your Addresses")}
				</a>
            </li>

            {if $system['download_info_enabled']}
				<li {if $view == "information"}class="active" {/if}>
					<a href="{$system['system_url']}/settings/information" class="main_bg_half position-relative">
						{__("Your Information")}
					</a>
				</li>
            {/if}

            {if $system['delete_accounts_enabled']}
				<li {if $view == "delete"}class="active" {/if}>
					<a href="{$system['system_url']}/settings/delete" class="main_bg_half position-relative">
						{__("Delete Account")}
					</a>
				</li>
            {/if}
		</ul>
    </div>
    <!-- left panel -->

    <!-- right panel -->
    <div class="x_menu_sidebar_content flex-1">
		<div class=" position-sticky top-0">
			{if $view == ""}
				{include file='settings.account.tpl'}
			{elseif $view == "profile"}
				{include file='settings.profile.tpl'}
			{elseif $view == "security"}
				{include file='settings.security.tpl'}
			{elseif $view == "privacy"}
				{include file='settings.privacy.tpl'}
			{elseif $view == "notifications"}
				{include file='settings.notifications.tpl'}
			{elseif $view == "accounts"}
				{include file='settings.accounts.tpl'}
			{elseif $view == "linked"}
				{include file='settings.linked.tpl'}
			{elseif $view == "membership"}
				{include file='settings.membership.tpl'}
			{elseif $view == "invitations"}
				{include file='settings.invitations.tpl'}
			{elseif $view == "affiliates"}
				{include file='settings.affiliates.tpl'}
			{elseif $view == "points"}
				{include file='settings.points.tpl'}
			{elseif $view == "market"}
				{include file='settings.market.tpl'}
			{elseif $view == "funding"}
				{include file='settings.funding.tpl'}
			{elseif $view == "monetization"}
				{include file='settings.monetization.tpl'}
			{elseif $view == "coinpayments"}
				{include file='settings.coinpayments.tpl'}
			{elseif $view == "bank"}
				{include file='settings.bank.tpl'}
			{elseif $view == "verification"}
				{include file='settings.verification.tpl'}
			{elseif $view == "apps"}
				{include file='settings.apps.tpl'}
			{elseif $view == "blocking"}
				{include file='settings.blocking.tpl'}
			{elseif $view == "addresses"}
				{include file='settings.addresses.tpl'}
			{elseif $view == "information"}
				{include file='settings.information.tpl'}
			{elseif $view == "delete"}
				{include file='settings.delete.tpl'}
			{/if}
		</div>
    </div>
    <!-- right panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}