<nav aria-label="{__("Settings")}">
  <ul class="menu menu-sm w-full gap-0.5 p-0">
    <li class="menu-title px-3 pt-3 pb-1 text-[11px]! font-medium! uppercase tracking-wider text-base-content/40!"><span>{__("Account")}</span></li>
    {include file='__settings_nav_item.tpl' _icon="icon-[tabler--settings]" _active=($view == "") _url="{$system['system_url']}/settings" _title=__("Account Settings")}

    <li class="space-y-0.5">
      <button type="button" id="settings-profile-toggle" class="collapse-toggle collapse-open:bg-base-content/10 {if $view == "profile"}collapse-open{/if}" data-collapse="#settings-profile-menu" aria-expanded="{if $view == "profile"}true{else}false{/if}" aria-controls="settings-profile-menu">
        <span class="icon-[tabler--user-edit] size-5 shrink-0" aria-hidden="true"></span>
        <span class="grow">{__("Edit Profile")}</span>
        <span class="icon-[tabler--chevron-down] collapse-open:rotate-180 size-4 shrink-0" aria-hidden="true"></span>
      </button>
      <ul id="settings-profile-menu" class="collapse {if $view != "profile"}hidden{/if} w-auto space-y-0.5 overflow-hidden transition-[height] duration-300" aria-labelledby="settings-profile-toggle">
        <li>
          <a href="{$system['system_url']}/settings/profile" class="{if $view == "profile" && $sub_view == ""}menu-active{else}text-base-content!{/if}" {if $view == "profile" && $sub_view == ""}aria-current="page" {/if}>{__("Basic")}</a>
        </li>
        {if $system['work_info_enabled']}
          <li>
            <a href="{$system['system_url']}/settings/profile/work" class="{if $view == "profile" && $sub_view == "work"}menu-active{else}text-base-content!{/if}" {if $view == "profile" && $sub_view == "work"}aria-current="page" {/if}>{__("Work")}</a>
          </li>
        {/if}
        {if $system['location_info_enabled']}
          <li>
            <a href="{$system['system_url']}/settings/profile/location" class="{if $view == "profile" && $sub_view == "location"}menu-active{else}text-base-content!{/if}" {if $view == "profile" && $sub_view == "location"}aria-current="page" {/if}>{__("Location")}</a>
          </li>
        {/if}
        {if $system['education_info_enabled']}
          <li>
            <a href="{$system['system_url']}/settings/profile/education" class="{if $view == "profile" && $sub_view == "education"}menu-active{else}text-base-content!{/if}" {if $view == "profile" && $sub_view == "education"}aria-current="page" {/if}>{__("Education")}</a>
          </li>
        {/if}
        {if $custom_fields['other']}
          <li>
            <a href="{$system['system_url']}/settings/profile/other" class="{if $view == "profile" && $sub_view == "other"}menu-active{else}text-base-content!{/if}" {if $view == "profile" && $sub_view == "other"}aria-current="page" {/if}>{__("Other")}</a>
          </li>
        {/if}
        {if $system['social_info_enabled']}
          <li>
            <a href="{$system['system_url']}/settings/profile/social" class="{if $view == "profile" && $sub_view == "social"}menu-active{else}text-base-content!{/if}" {if $view == "profile" && $sub_view == "social"}aria-current="page" {/if}>{__("Social Links")}</a>
          </li>
        {/if}
        {if $system['system_profile_background_enabled']}
          <li>
            <a href="{$system['system_url']}/settings/profile/design" class="{if $view == "profile" && $sub_view == "design"}menu-active{else}text-base-content!{/if}" {if $view == "profile" && $sub_view == "design"}aria-current="page" {/if}>{__("Design")}</a>
          </li>
        {/if}
      </ul>
    </li>

    {if $system['verification_requests']}
      {include file='__settings_nav_item.tpl' _icon="icon-[tabler--rosette-discount-check]" _active=($view == "verification") _url="{$system['system_url']}/settings/verification" _title=__("Verification")}
    {/if}
    {if $system['switch_accounts_enabled']}
      {include file='__settings_nav_item.tpl' _icon="icon-[tabler--users]" _active=($view == "accounts") _url="{$system['system_url']}/settings/accounts" _title=__("Connected Accounts")}
    {/if}
    {if $system['social_login_enabled'] && ($system['apple_login_enabled'] || $system['facebook_login_enabled'] || $system['google_login_enabled'] || $system['discord_login_enabled'] || $system['twitter_login_enabled'] || $system['linkedin_login_enabled'] || $system['vkontakte_login_enabled'] || $system['wordpress_login_enabled'] || $system['sngine_login_enabled'])}
      {include file='__settings_nav_item.tpl' _icon="icon-[tabler--link]" _active=($view == "linked") _url="{$system['system_url']}/settings/linked" _title=__("Linked Accounts")}
    {/if}
    {if $user->_data['can_invite_users']}
      {include file='__settings_nav_item.tpl' _icon="icon-[tabler--mail-forward]" _active=($view == "invitations") _url="{$system['system_url']}/settings/invitations" _title=__("Invitations")}
    {/if}

    <li class="menu-title px-3 pt-3 pb-1 text-[11px]! font-medium! uppercase tracking-wider text-base-content/40!"><span>{__("Privacy & Security")}</span></li>
    <li class="space-y-0.5">
      <button type="button" id="settings-security-toggle" class="collapse-toggle collapse-open:bg-base-content/10 {if $view == "security"}collapse-open{/if}" data-collapse="#settings-security-menu" aria-expanded="{if $view == "security"}true{else}false{/if}" aria-controls="settings-security-menu">
        <span class="icon-[tabler--shield-lock] size-5 shrink-0" aria-hidden="true"></span>
        <span class="grow">{__("Security Settings")}</span>
        <span class="icon-[tabler--chevron-down] collapse-open:rotate-180 size-4 shrink-0" aria-hidden="true"></span>
      </button>
      <ul id="settings-security-menu" class="collapse {if $view != "security"}hidden{/if} w-auto space-y-0.5 overflow-hidden transition-[height] duration-300" aria-labelledby="settings-security-toggle">
        <li>
          <a href="{$system['system_url']}/settings/security/password" class="{if $view == "security" && $sub_view == "password"}menu-active{else}text-base-content!{/if}" {if $view == "security" && $sub_view == "password"}aria-current="page" {/if}>{__("Password")}</a>
        </li>
        <li>
          <a href="{$system['system_url']}/settings/security/sessions" class="{if $view == "security" && $sub_view == "sessions"}menu-active{else}text-base-content!{/if}" {if $view == "security" && $sub_view == "sessions"}aria-current="page" {/if}>{__("Manage Sessions")}</a>
        </li>
        {if $system['two_factor_enabled']}
          <li>
            <a href="{$system['system_url']}/settings/security/two-factor" class="{if $view == "security" && $sub_view == "two-factor"}menu-active{else}text-base-content!{/if}" {if $view == "security" && $sub_view == "two-factor"}aria-current="page" {/if}>{__("Two-Factor Authentication")}</a>
          </li>
        {/if}
      </ul>
    </li>
    {include file='__settings_nav_item.tpl' _icon="icon-[tabler--bell]" _active=($view == "notifications") _url="{$system['system_url']}/settings/notifications" _title=__("Notifications")}
    {include file='__settings_nav_item.tpl' _icon="icon-[tabler--lock]" _active=($view == "privacy") _url="{$system['system_url']}/settings/privacy" _title=__("Privacy")}
    {include file='__settings_nav_item.tpl' _icon="icon-[tabler--ban]" _active=($view == "blocking") _url="{$system['system_url']}/settings/blocking" _title=__("Blocking")}

    {if $system['packages_enabled'] || $user->_data['can_monetize_content'] || $system['affiliates_enabled'] || $system['points_enabled'] || $user->_data['can_sell_products'] || $user->_data['can_raise_funding'] || $system['coinpayments_enabled'] || $system['bank_transfers_enabled']}
      <li class="menu-title px-3 pt-3 pb-1 text-[11px]! font-medium! uppercase tracking-wider text-base-content/40!"><span>{__("Membership & Earnings")}</span></li>
    {/if}
    {if $system['packages_enabled']}
      {include file='__settings_nav_item.tpl' _icon="icon-[tabler--crown]" _active=($view == "membership") _url="{$system['system_url']}/settings/membership" _title=__("Membership")}
    {/if}

    {if $user->_data['can_monetize_content']}
      <li class="space-y-0.5">
        <button type="button" id="settings-monetization-toggle" class="collapse-toggle collapse-open:bg-base-content/10 {if $view == "monetization"}collapse-open{/if}" data-collapse="#settings-monetization-menu" aria-expanded="{if $view == "monetization"}true{else}false{/if}" aria-controls="settings-monetization-menu">
          <span class="icon-[tabler--coin] size-5 shrink-0" aria-hidden="true"></span>
          <span class="grow">{__("Monetization")}</span>
          <span class="icon-[tabler--chevron-down] collapse-open:rotate-180 size-4 shrink-0" aria-hidden="true"></span>
        </button>
        <ul id="settings-monetization-menu" class="collapse {if $view != "monetization"}hidden{/if} w-auto space-y-0.5 overflow-hidden transition-[height] duration-300" aria-labelledby="settings-monetization-toggle">
          <li>
            <a href="{$system['system_url']}/settings/monetization" class="{if $view == "monetization" && $sub_view == ""}menu-active{else}text-base-content!{/if}" {if $view == "monetization" && $sub_view == ""}aria-current="page" {/if}>{__("Settings")}</a>
          </li>
          <li>
            <a href="{$system['system_url']}/settings/monetization/coupons" class="{if $view == "monetization" && $sub_view == "coupons"}menu-active{else}text-base-content!{/if}" {if $view == "monetization" && $sub_view == "coupons"}aria-current="page" {/if}>{__("Coupons")}</a>
          </li>
          {if $system['monetization_money_withdraw_enabled']}
            <li>
              <a href="{$system['system_url']}/settings/monetization/payments" class="{if $view == "monetization" && $sub_view == "payments"}menu-active{else}text-base-content!{/if}" {if $view == "monetization" && $sub_view == "payments"}aria-current="page" {/if}>{__("Payments")}</a>
            </li>
          {/if}
          <li>
            <a href="{$system['system_url']}/settings/monetization/earnings" class="{if $view == "monetization" && $sub_view == "earnings"}menu-active{else}text-base-content!{/if}" {if $view == "monetization" && $sub_view == "earnings"}aria-current="page" {/if}>{__("Earnings")}</a>
          </li>
        </ul>
      </li>
    {/if}

    {if $system['affiliates_enabled']}
      <li class="space-y-0.5">
        <button type="button" id="settings-affiliates-toggle" class="collapse-toggle collapse-open:bg-base-content/10 {if $view == "affiliates"}collapse-open{/if}" data-collapse="#settings-affiliates-menu" aria-expanded="{if $view == "affiliates"}true{else}false{/if}" aria-controls="settings-affiliates-menu">
          <span class="icon-[tabler--affiliate] size-5 shrink-0" aria-hidden="true"></span>
          <span class="grow">{__("Affiliates")}</span>
          <span class="icon-[tabler--chevron-down] collapse-open:rotate-180 size-4 shrink-0" aria-hidden="true"></span>
        </button>
        <ul id="settings-affiliates-menu" class="collapse {if $view != "affiliates"}hidden{/if} w-auto space-y-0.5 overflow-hidden transition-[height] duration-300" aria-labelledby="settings-affiliates-toggle">
          <li>
            <a href="{$system['system_url']}/settings/affiliates" class="{if $view == "affiliates" && $sub_view == ""}menu-active{else}text-base-content!{/if}" {if $view == "affiliates" && $sub_view == ""}aria-current="page" {/if}>{__("My Affiliates")}</a>
          </li>
          {if $system['affiliates_money_withdraw_enabled']}
            <li>
              <a href="{$system['system_url']}/settings/affiliates/payments" class="{if $view == "affiliates" && $sub_view == "payments"}menu-active{else}text-base-content!{/if}" {if $view == "affiliates" && $sub_view == "payments"}aria-current="page" {/if}>{__("Payments")}</a>
            </li>
          {/if}
        </ul>
      </li>
    {/if}

    {if $system['points_enabled']}
      <li class="space-y-0.5">
        <button type="button" id="settings-points-toggle" class="collapse-toggle collapse-open:bg-base-content/10 {if $view == "points"}collapse-open{/if}" data-collapse="#settings-points-menu" aria-expanded="{if $view == "points"}true{else}false{/if}" aria-controls="settings-points-menu">
          <span class="icon-[tabler--star] size-5 shrink-0" aria-hidden="true"></span>
          <span class="grow">{__("Points")}</span>
          <span class="icon-[tabler--chevron-down] collapse-open:rotate-180 size-4 shrink-0" aria-hidden="true"></span>
        </button>
        <ul id="settings-points-menu" class="collapse {if $view != "points"}hidden{/if} w-auto space-y-0.5 overflow-hidden transition-[height] duration-300" aria-labelledby="settings-points-toggle">
          <li>
            <a href="{$system['system_url']}/settings/points" class="{if $view == "points" && $sub_view == ""}menu-active{else}text-base-content!{/if}" {if $view == "points" && $sub_view == ""}aria-current="page" {/if}>{__("My Points")}</a>
          </li>
          {if $system['points_per_currency'] > 0 && $system['points_money_withdraw_enabled']}
            <li>
              <a href="{$system['system_url']}/settings/points/payments" class="{if $view == "points" && $sub_view == "payments"}menu-active{else}text-base-content!{/if}" {if $view == "points" && $sub_view == "payments"}aria-current="page" {/if}>{__("Payments")}</a>
            </li>
          {/if}
        </ul>
      </li>
    {/if}

    {if $user->_data['can_sell_products'] && $system['market_shopping_cart_enabled']}
      {include file='__settings_nav_item.tpl' _icon="icon-[tabler--building-store]" _active=($view == "market") _url="{$system['system_url']}/settings/market" _title=__("Marketplace")}
    {/if}
    {if $user->_data['can_raise_funding']}
      {include file='__settings_nav_item.tpl' _icon="icon-[tabler--heart-handshake]" _active=($view == "funding") _url="{$system['system_url']}/settings/funding" _title=__("Funding")}
    {/if}
    {if $system['coinpayments_enabled']}
      {include file='__settings_nav_item.tpl' _icon="icon-[tabler--currency-bitcoin]" _active=($view == "coinpayments") _url="{$system['system_url']}/settings/coinpayments" _title=__("CoinPayments")}
    {/if}
    {if $system['bank_transfers_enabled']}
      {include file='__settings_nav_item.tpl' _icon="icon-[tabler--building-bank]" _active=($view == "bank") _url="{$system['system_url']}/settings/bank" _title=__("Bank Transfers")}
    {/if}

    <li class="menu-title px-3 pt-3 pb-1 text-[11px]! font-medium! uppercase tracking-wider text-base-content/40!"><span>{__("Tools & Data")}</span></li>
    {if $system['developers_apps_enabled']}
      {include file='__settings_nav_item.tpl' _icon="icon-[tabler--apps]" _active=($view == "apps") _url="{$system['system_url']}/settings/apps" _title=__("Apps")}
    {/if}
    {include file='__settings_nav_item.tpl' _icon="icon-[tabler--map-pin]" _active=($view == "addresses") _url="{$system['system_url']}/settings/addresses" _title=__("Your Addresses")}
    {if $system['download_info_enabled']}
      {include file='__settings_nav_item.tpl' _icon="icon-[tabler--file-download]" _active=($view == "information") _url="{$system['system_url']}/settings/information" _title=__("Your Information")}
    {/if}
    {if $system['delete_accounts_enabled']}
      {include file='__settings_nav_item.tpl' _danger=true _icon="icon-[tabler--user-off]" _active=($view == "delete") _url="{$system['system_url']}/settings/delete" _title=__("Delete Account")}
    {/if}
  </ul>
</nav>
