{if $_topbar}
  <span class="heroui inline-flex">
    <button type="button" class="dropdown-toggle site-topbar-avatar button button--ghost button--icon-only relative overflow-hidden rounded-2xl! corner-squircle supports-[corner-shape:squircle]:rounded-[2rem]! p-0" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Menu")}">
      <img class="size-full rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] object-cover" src="{$user->_data['user_picture']}" alt="">
    </button>
  </span>
{else}
  <div class="dropdown relative flex h-full [--offset:8] [--placement:top-end]">
    <button type="button" class="dropdown-toggle flex h-full w-full min-w-0 items-center justify-center text-base-content!" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Menu")}">
      <img class="size-8 rounded-full object-cover" src="{$user->_data['user_picture']}" alt="">
    </button>
{/if}
  <ul class="dropdown-menu dropdown-open:opacity-100 hidden w-72 border border-base-content/15 shadow-lg shadow-black/10 dark:shadow-black/25" role="menu">
    <!-- profile -->
    <li>
      <a class="dropdown-item text-inherit!" href="{$system['system_url']}/{$user->_data['user_name']}">
        <img class="size-9 shrink-0 rounded-full object-cover" src="{$user->_data['user_picture']}" alt="">
        <span class="flex min-w-0 flex-1 flex-col">
          <span class="truncate text-sm font-semibold" title="{$user->_data['user_fullname']}">{$user->_data['user_fullname']}</span>
          <span class="truncate text-xs font-normal text-base-content/50" title="@{$user->_data['user_name']}">@{$user->_data['user_name']}</span>
        </span>
      </a>
    </li>
    <!-- profile -->
    {if $system['switch_accounts_enabled']}
      <li>
        <button type="button" class="js_modal dropdown-item" data-url="#account-switcher">
          <span class="icon-[tabler--arrows-exchange] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
          {__("Switch Accounts")}
        </button>
      </li>
    {/if}

    {if ($system['packages_enabled'] && !$user->_data['user_subscribed']) || $system['points_enabled'] || $system['wallet_enabled']}
      {if $system['switch_accounts_enabled']}
        <li class="px-3 py-1.5" role="separator"><div class="border-t border-base-300"></div></li>
      {/if}
      {if $system['packages_enabled'] && !$user->_data['user_subscribed']}
        <li>
          <a class="dropdown-item text-inherit!" href="{$system['system_url']}/packages">
            <span class="icon-[tabler--crown] size-4 shrink-0 text-accent" aria-hidden="true"></span>
            {__("Upgrade to Pro")}
          </a>
        </li>
      {/if}
      {if $system['points_enabled']}
        <li>
          <a class="dropdown-item text-inherit!" href="{$system['system_url']}/settings/points">
            <span class="icon-[tabler--coins] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
            {__("Points")}
            <span class="ms-auto text-sm font-semibold tabular-nums">{$user->_data['user_points']|number_format:2}</span>
          </a>
        </li>
      {/if}
      {if $system['wallet_enabled']}
        <li>
          <a class="dropdown-item text-inherit!" href="{$system['system_url']}/wallet">
            <span class="icon-[tabler--wallet] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
            {__("Wallet")}
            <span class="ms-auto text-sm font-semibold tabular-nums">{print_money($user->_data['user_wallet_balance'])}</span>
          </a>
        </li>
      {/if}
    {/if}

    {if $system['switch_accounts_enabled'] || ($system['packages_enabled'] && !$user->_data['user_subscribed']) || $system['points_enabled'] || $system['wallet_enabled']}
      <li class="px-3 py-1.5" role="separator"><div class="border-t border-base-300"></div></li>
    {/if}
    {if $system['support_center_enabled']}
      <li>
        <a class="dropdown-item text-inherit!" href="{$system['system_url']}/support">
          <span class="icon-[tabler--lifebuoy] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
          {__("Support Center")}
        </a>
      </li>
    {/if}
    <li>
      <a class="dropdown-item text-inherit!" href="{$system['system_url']}/settings">
        <span class="icon-[tabler--settings] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
        {__("Settings")}
      </a>
    </li>
    {if $user->_is_admin}
      <li>
        <a class="dropdown-item text-inherit!" href="{$system['system_url']}/admincp">
          <span class="icon-[tabler--shield-lock] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
          {__("Admin Panel")}
        </a>
      </li>
    {elseif $user->_is_moderator}
      <li>
        <a class="dropdown-item text-inherit!" href="{$system['system_url']}/modcp">
          <span class="icon-[tabler--shield-check] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
          {__("Moderator Panel")}
        </a>
      </li>
    {/if}

    {if ($system['themes'] && count($system['themes']) > 1) || $system['system_theme_mode_select']}
      <li class="px-3 py-1.5" role="separator"><div class="border-t border-base-300"></div></li>
    {else}
      <li class="hidden px-3 py-1.5 lg:block" role="separator"><div class="border-t border-base-300"></div></li>
    {/if}
    <li class="hidden lg:block">
      <button type="button" class="js_modal dropdown-item" data-url="#keyboard-shortcuts">
        <span class="icon-[tabler--keyboard] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
        {__("Keyboard Shortcuts")}
      </button>
    </li>
    {if $system['themes'] && count($system['themes']) > 1}
      <li>
        <button type="button" class="js_modal dropdown-item" data-url="#theme-switcher">
          <span class="icon-[tabler--palette] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
          {__("Theme Switcher")}
        </button>
      </li>
    {/if}
    {if $system['system_theme_mode_select']}
      <li>
        {if $system['theme_mode_night']}
          <button type="button" class="dropdown-item js_theme-mode" data-mode="day">
            <span class="icon-[tabler--sun] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
            <span class="js_theme-mode-text">{__("Day Mode")}</span>
          </button>
        {else}
          <button type="button" class="dropdown-item js_theme-mode" data-mode="night">
            <span class="icon-[tabler--moon] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
            <span class="js_theme-mode-text">{__("Night Mode")}</span>
          </button>
        {/if}
      </li>
    {/if}

    <li class="px-3 py-1.5" role="separator"><div class="border-t border-base-300"></div></li>
    <li>
      <a class="dropdown-item text-error!" href="{$system['system_url']}/signout/?cache={$secret}" onclick="localStorage.clear();">
        <span class="icon-[tabler--logout] size-4 shrink-0" aria-hidden="true"></span>
        {__("Sign Out")}
      </a>
    </li>
  </ul>
{if !$_topbar}
  </div>
{/if}
