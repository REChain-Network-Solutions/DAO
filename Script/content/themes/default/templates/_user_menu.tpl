<a href="#" class="dropdown dropdown-toggle user-menu" data-bs-toggle="dropdown" data-display="static">
  <img src="{$user->_data['user_picture']}">
  <div class="title">{__("Menu")}</div>
</a>
<div class="dropdown-menu {if $_as_widget}dropdown-widget{/if} dropdown-menu-end">
  <a class="dropdown-item" href="{$system['system_url']}/{$user->_data['user_name']}">
    <img class="rounded-circle mr10" src="{$user->_data.user_picture}" width="20px" height="20px">
    <span>{$user->_data['user_fullname']}</span>
  </a>
  {if $system['switch_accounts_enabled']}
    <div class="dropdown-item pointer" data-toggle="modal" data-url="#account-switcher">
      {include file='__svg_icons.tpl' icon="accounts_switcher" class="main-icon mr10" width="20px" height="20px"}
      {__("Switch Accounts")}
    </div>
  {/if}
  <div class="dropdown-divider"></div>
  {if $system['packages_enabled'] && !$user->_data['user_subscribed']}
    <a class="dropdown-item" href="{$system['system_url']}/packages">
      {include file='__svg_icons.tpl' icon="membership" class="main-icon mr10" width="20px" height="20px"}
      {__("Upgrade to Pro")}
    </a>
  {/if}
  {if $system['points_enabled'] || $system['wallet_enabled']}
    {if $system['points_enabled']}
      <a class="dropdown-item" href="{$system['system_url']}/settings/points">
        {include file='__svg_icons.tpl' icon="points" class="main-icon mr10" width="20px" height="20px"}
        {__("Points")}: <span class="badge bg-light text-primary">{$user->_data['user_points']}</span>
      </a>
    {/if}
    {if $system['wallet_enabled']}
      <a class="dropdown-item" href="{$system['system_url']}/wallet">
        {include file='__svg_icons.tpl' icon="wallet" class="main-icon mr10" width="20px" height="20px"}
        {__("Wallet")}: <span class="badge bg-light text-primary">{print_money($user->_data['user_wallet_balance']|number_format:2)}</span>
      </a>
    {/if}
    <div class="dropdown-divider"></div>
  {/if}

  <a class="dropdown-item" href="{$system['system_url']}/settings{if $detect->isMobile()}?show_categories{/if}">
    {include file='__svg_icons.tpl' icon="settings" class="main-icon mr10" width="20px" height="20px"}
    {__("Settings")}
  </a>
  {if $user->_is_admin}
    <div class="dropdown-divider"></div>
    <a class="dropdown-item" href="{$system['system_url']}/admincp">
      {include file='__svg_icons.tpl' icon="admin_panel" class="main-icon mr10" width="20px" height="20px"}
      {__("Admin Panel")}
    </a>
  {elseif $user->_is_moderator}
    <div class="dropdown-divider"></div>
    <a class="dropdown-item" href="{$system['system_url']}/modcp">
      {include file='__svg_icons.tpl' icon="admin_panel" class="main-icon mr10" width="20px" height="20px"}{__("Moderator Panel")}
    </a>
  {/if}
  <div class="dropdown-divider"></div>
  <a class="dropdown-item" href="{$system['system_url']}/signout/?cache={$secret}">
    {include file='__svg_icons.tpl' icon="logout" class="main-icon mr10" width="20px" height="20px"}
    {__("Sign Out")}
  </a>
  <div class="dropdown-divider"></div>
  <div class="dropdown-item pointer d-none d-lg-block" data-toggle="modal" data-url="#keyboard-shortcuts">
    {include file='__svg_icons.tpl' icon="keyboard" class="main-icon mr10" width="20px" height="20px"}
    {__("Keyboard Shortcuts")}
  </div>
  {if $system['themes'] && count($system['themes']) > 1}
    <div class="dropdown-item pointer" data-toggle="modal" data-url="#theme-switcher">
      {include file='__svg_icons.tpl' icon="themes_switcher" class="main-icon mr10" width="20px" height="20px"}
      {__("Theme Switcher")}
    </div>
  {/if}
  {if $system['system_theme_mode_select']}
    {if $system['theme_mode_night']}
      <div class="dropdown-item pointer js_theme-mode" data-mode="day">
        {include file='__svg_icons.tpl' icon="dark_light" class="main-icon mr10" width="20px" height="20px"}
        <span class="js_theme-mode-text">{__("Day Mode")}</span>
      </div>
    {else}
      <div class="dropdown-item pointer js_theme-mode" data-mode="night">
        {include file='__svg_icons.tpl' icon="dark_light" class="main-icon mr10" width="20px" height="20px"}
        <span class="js_theme-mode-text">{__("Night Mode")}</span>
      </div>
    {/if}
  {/if}
</div>