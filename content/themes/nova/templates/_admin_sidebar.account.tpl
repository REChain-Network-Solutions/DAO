<div class="admin-sidebar-account dropdown relative [--flip:false] [--offset:8] [--placement:right-end] [--strategy:absolute]">
  <button type="button" class="dropdown-toggle admin-sidebar-account-trigger"
          aria-haspopup="menu" aria-expanded="false" aria-label="{__("Account")}">
    <img class="admin-sidebar-account-avatar" src="{$user->_data['user_picture']}" alt="">
    <span class="admin-sidebar-account-meta">
      <span class="admin-sidebar-account-name">{$user->_data['user_name']}</span>
      <span class="admin-sidebar-account-email">{$user->_data['user_email']}</span>
    </span>
    <span class="icon-[tabler--selector] admin-sidebar-account-selector" aria-hidden="true"></span>
  </button>
  <ul class="dropdown-menu dropdown-open:opacity-100 hidden admin-sidebar-account-menu" role="menu">
    <li>
      <a class="admin-sidebar-account-header" href="{$system['system_url']}/{$user->_data['user_name']}">
        <img class="admin-sidebar-account-avatar" src="{$user->_data['user_picture']}" alt="">
        <span class="admin-sidebar-account-meta">
          <span class="admin-sidebar-account-name">{$user->_data['user_name']}</span>
          <span class="admin-sidebar-account-email">{$user->_data['user_email']}</span>
        </span>
      </a>
    </li>
    <li class="dropdown-divider" role="separator"></li>
    {if $system['switch_accounts_enabled']}
      <li>
        <button type="button" class="js_modal dropdown-item" data-url="#account-switcher">
          <span class="icon-[tabler--switch-horizontal] size-4.5 me-2" aria-hidden="true"></span>{__("Switch Accounts")}
        </button>
      </li>
    {/if}

    {if ($system['packages_enabled'] && !$user->_data['user_subscribed']) || $system['points_enabled'] || $system['wallet_enabled']}
      <li class="dropdown-divider" role="separator"></li>
      {if $system['packages_enabled'] && !$user->_data['user_subscribed']}
        <li>
          <a class="dropdown-item" href="{$system['system_url']}/packages">
            <span class="icon-[tabler--crown] size-4.5 me-2 text-warning" aria-hidden="true"></span>{__("Upgrade to Pro")}
          </a>
        </li>
      {/if}
      {if $system['points_enabled']}
        <li>
          <a class="dropdown-item" href="{$system['system_url']}/settings/points">
            <span class="icon-[tabler--coin] size-4.5 me-2" aria-hidden="true"></span>
            {__("Points")}
            <span class="admin-sidebar-account-value">{$user->_data['user_points']}</span>
          </a>
        </li>
      {/if}
      {if $system['wallet_enabled']}
        <li>
          <a class="dropdown-item" href="{$system['system_url']}/wallet">
            <span class="icon-[tabler--wallet] size-4.5 me-2" aria-hidden="true"></span>
            {__("Wallet")}
            <span class="admin-sidebar-account-value">{print_money($user->_data['user_wallet_balance'])}</span>
          </a>
        </li>
      {/if}
    {/if}

    <li class="dropdown-divider"></li>
    {if $system['support_center_enabled']}
      <li>
        <a class="dropdown-item" href="{$system['system_url']}/support">
          <span class="icon-[tabler--headset] size-4.5 me-2" aria-hidden="true"></span>{__("Support Center")}
        </a>
      </li>
    {/if}
    <li>
      <a class="dropdown-item" href="{$system['system_url']}/settings">
        <span class="icon-[tabler--settings] size-4.5 me-2" aria-hidden="true"></span>{__("Settings")}
      </a>
    </li>
    <li class="hidden lg:block">
      <button type="button" class="js_modal dropdown-item" data-url="#keyboard-shortcuts">
        <span class="icon-[tabler--keyboard] size-4.5 me-2" aria-hidden="true"></span>{__("Keyboard Shortcuts")}
      </button>
    </li>
    {if $system['themes'] && count($system['themes']) > 1}
      <li>
        <button type="button" class="js_modal dropdown-item" data-url="#theme-switcher">
          <span class="icon-[tabler--palette] size-4.5 me-2" aria-hidden="true"></span>{__("Theme Switcher")}
        </button>
      </li>
    {/if}

    <li class="dropdown-divider"></li>
    <li>
      <a class="dropdown-item text-error" href="{$system['system_url']}/signout/?cache={$secret}" onclick="localStorage.clear();">
        <span class="icon-[tabler--logout] size-4.5 me-2" aria-hidden="true"></span>{__("Sign Out")}
      </a>
    </li>
  </ul>
</div>
