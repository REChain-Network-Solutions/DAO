<div class="card border border-base-300 bg-base-100 shadow-none">
  {include file='__settings_card_header.tpl' _icon="icon-[tabler--link]" _title=__("Linked Accounts") _text=__("Facebook, Google, and other logins")}
  <div class="card-body gap-6 pt-6">
    <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
      {if $system['apple_login_enabled']}
        <!-- apple -->
        <div class="flex items-center gap-4 p-4">
          <span class="inline-flex size-10 shrink-0 items-center justify-center overflow-hidden rounded-xl bg-base-200" aria-hidden="true">
            <span class="icon-[tabler--brand-apple] size-5"></span>
          </span>
          <div class="min-w-0 grow">
            <div class="flex flex-wrap items-center gap-2">
              <span class="text-sm font-medium">{__("Apple")}</span>
              {if $user->_data['apple_connected']}
                <span class="icon-[tabler--circle-check-filled] size-4 text-success" aria-hidden="true"></span>
              {/if}
            </div>
            <p class="mt-0.5 hidden truncate text-sm text-base-content/60 sm:block" title="{if $user->_data['apple_connected']} {__("Your account is connected to")} {__("Apple")} {else} {__("Connect your account to")} {__("Apple")} {/if}">
              {if $user->_data['apple_connected']}
                {__("Your account is connected to")} {__("Apple")}
              {else}
                {__("Connect your account to")} {__("Apple")}
              {/if}
            </p>
          </div>
          {if $user->_data['apple_connected']}
            <a class="heroui button button--danger-soft button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/revoke/apple">
              <span class="icon-[tabler--plug-connected-x] size-4" aria-hidden="true"></span>
              {__("Disconnect")}
            </a>
          {else}
            <a class="heroui button button--primary button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/connect/apple">
              <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span>
              {__("Connect")}
            </a>
          {/if}
        </div>
        <!-- apple -->
      {/if}
      {if $system['google_login_enabled']}
        <!-- google -->
        <div class="flex items-center gap-4 p-4">
          <span class="inline-flex size-10 shrink-0 items-center justify-center overflow-hidden rounded-xl bg-base-200" aria-hidden="true">
            {include file='__svg_icons.tpl' icon="google" width="24px" height="24px"}
          </span>
          <div class="min-w-0 grow">
            <div class="flex flex-wrap items-center gap-2">
              <span class="text-sm font-medium">{__("Google")}</span>
              {if $user->_data['google_connected']}
                <span class="icon-[tabler--circle-check-filled] size-4 text-success" aria-hidden="true"></span>
              {/if}
            </div>
            <p class="mt-0.5 hidden truncate text-sm text-base-content/60 sm:block" title="{if $user->_data['google_connected']} {__("Your account is connected to")} {__("Google")} {else} {__("Connect your account to")} {__("Google")} {/if}">
              {if $user->_data['google_connected']}
                {__("Your account is connected to")} {__("Google")}
              {else}
                {__("Connect your account to")} {__("Google")}
              {/if}
            </p>
          </div>
          {if $user->_data['google_connected']}
            <a class="heroui button button--danger-soft button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/revoke/google">
              <span class="icon-[tabler--plug-connected-x] size-4" aria-hidden="true"></span>
              {__("Disconnect")}
            </a>
          {else}
            <a class="heroui button button--primary button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/connect/google">
              <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span>
              {__("Connect")}
            </a>
          {/if}
        </div>
        <!-- google -->
      {/if}
      {if $system['facebook_login_enabled']}
        <!-- facebook -->
        <div class="flex items-center gap-4 p-4">
          <span class="inline-flex size-10 shrink-0 items-center justify-center overflow-hidden rounded-xl bg-base-200" aria-hidden="true">
            {include file='__svg_icons.tpl' icon="facebook" width="24px" height="24px"}
          </span>
          <div class="min-w-0 grow">
            <div class="flex flex-wrap items-center gap-2">
              <span class="text-sm font-medium">{__("Facebook")}</span>
              {if $user->_data['facebook_connected']}
                <span class="icon-[tabler--circle-check-filled] size-4 text-success" aria-hidden="true"></span>
              {/if}
            </div>
            <p class="mt-0.5 hidden truncate text-sm text-base-content/60 sm:block" title="{if $user->_data['facebook_connected']} {__("Your account is connected to")} {__("Facebook")} {else} {__("Connect your account to")} {__("Facebook")} {/if}">
              {if $user->_data['facebook_connected']}
                {__("Your account is connected to")} {__("Facebook")}
              {else}
                {__("Connect your account to")} {__("Facebook")}
              {/if}
            </p>
          </div>
          {if $user->_data['facebook_connected']}
            <a class="heroui button button--danger-soft button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/revoke/facebook">
              <span class="icon-[tabler--plug-connected-x] size-4" aria-hidden="true"></span>
              {__("Disconnect")}
            </a>
          {else}
            <a class="heroui button button--primary button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/connect/facebook">
              <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span>
              {__("Connect")}
            </a>
          {/if}
        </div>
        <!-- facebook -->
      {/if}
      {if $system['twitter_login_enabled']}
        <!-- twitter -->
        <div class="flex items-center gap-4 p-4">
          <span class="inline-flex size-10 shrink-0 items-center justify-center overflow-hidden rounded-xl bg-base-200" aria-hidden="true">
            {include file='__svg_icons.tpl' icon="x" width="24px" height="24px"}
          </span>
          <div class="min-w-0 grow">
            <div class="flex flex-wrap items-center gap-2">
              <span class="text-sm font-medium">{__("Twitter")}</span>
              {if $user->_data['twitter_connected']}
                <span class="icon-[tabler--circle-check-filled] size-4 text-success" aria-hidden="true"></span>
              {/if}
            </div>
            <p class="mt-0.5 hidden truncate text-sm text-base-content/60 sm:block" title="{if $user->_data['twitter_connected']} {__("Your account is connected to")} {__("Twitter")} {else} {__("Connect your account to")} {__("Twitter")} {/if}">
              {if $user->_data['twitter_connected']}
                {__("Your account is connected to")} {__("Twitter")}
              {else}
                {__("Connect your account to")} {__("Twitter")}
              {/if}
            </p>
          </div>
          {if $user->_data['twitter_connected']}
            <a class="heroui button button--danger-soft button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/revoke/twitter">
              <span class="icon-[tabler--plug-connected-x] size-4" aria-hidden="true"></span>
              {__("Disconnect")}
            </a>
          {else}
            <a class="heroui button button--primary button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/connect/twitter">
              <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span>
              {__("Connect")}
            </a>
          {/if}
        </div>
        <!-- twitter -->
      {/if}
      {if $system['discord_login_enabled']}
        <!-- discord -->
        <div class="flex items-center gap-4 p-4">
          <span class="inline-flex size-10 shrink-0 items-center justify-center overflow-hidden rounded-xl bg-base-200" aria-hidden="true">
            {include file='__svg_icons.tpl' icon="discord" width="24px" height="24px"}
          </span>
          <div class="min-w-0 grow">
            <div class="flex flex-wrap items-center gap-2">
              <span class="text-sm font-medium">{__("Discord")}</span>
              {if $user->_data['discord_connected']}
                <span class="icon-[tabler--circle-check-filled] size-4 text-success" aria-hidden="true"></span>
              {/if}
            </div>
            <p class="mt-0.5 hidden truncate text-sm text-base-content/60 sm:block" title="{if $user->_data['discord_connected']} {__("Your account is connected to")} {__("Discord")} {else} {__("Connect your account to")} {__("Discord")} {/if}">
              {if $user->_data['discord_connected']}
                {__("Your account is connected to")} {__("Discord")}
              {else}
                {__("Connect your account to")} {__("Discord")}
              {/if}
            </p>
          </div>
          {if $user->_data['discord_connected']}
            <a class="heroui button button--danger-soft button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/revoke/discord">
              <span class="icon-[tabler--plug-connected-x] size-4" aria-hidden="true"></span>
              {__("Disconnect")}
            </a>
          {else}
            <a class="heroui button button--primary button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/connect/discord">
              <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span>
              {__("Connect")}
            </a>
          {/if}
        </div>
        <!-- discord -->
      {/if}
      {if $system['linkedin_login_enabled']}
        <!-- linkedin -->
        <div class="flex items-center gap-4 p-4">
          <span class="inline-flex size-10 shrink-0 items-center justify-center overflow-hidden rounded-xl bg-base-200" aria-hidden="true">
            {include file='__svg_icons.tpl' icon="linkedin" width="24px" height="24px"}
          </span>
          <div class="min-w-0 grow">
            <div class="flex flex-wrap items-center gap-2">
              <span class="text-sm font-medium">{__("Linkedin")}</span>
              {if $user->_data['linkedin_connected']}
                <span class="icon-[tabler--circle-check-filled] size-4 text-success" aria-hidden="true"></span>
              {/if}
            </div>
            <p class="mt-0.5 hidden truncate text-sm text-base-content/60 sm:block" title="{if $user->_data['linkedin_connected']} {__("Your account is connected to")} {__("Linkedin")} {else} {__("Connect your account to")} {__("Linkedin")} {/if}">
              {if $user->_data['linkedin_connected']}
                {__("Your account is connected to")} {__("Linkedin")}
              {else}
                {__("Connect your account to")} {__("Linkedin")}
              {/if}
            </p>
          </div>
          {if $user->_data['linkedin_connected']}
            <a class="heroui button button--danger-soft button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/revoke/linkedin">
              <span class="icon-[tabler--plug-connected-x] size-4" aria-hidden="true"></span>
              {__("Disconnect")}
            </a>
          {else}
            <a class="heroui button button--primary button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/connect/linkedin">
              <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span>
              {__("Connect")}
            </a>
          {/if}
        </div>
        <!-- linkedin -->
      {/if}
      {if $system['vkontakte_login_enabled']}
        <!-- vkontakte -->
        <div class="flex items-center gap-4 p-4">
          <span class="inline-flex size-10 shrink-0 items-center justify-center overflow-hidden rounded-xl bg-base-200" aria-hidden="true">
            {include file='__svg_icons.tpl' icon="vk" width="24px" height="24px"}
          </span>
          <div class="min-w-0 grow">
            <div class="flex flex-wrap items-center gap-2">
              <span class="text-sm font-medium">{__("Vkontakte")}</span>
              {if $user->_data['vkontakte_connected']}
                <span class="icon-[tabler--circle-check-filled] size-4 text-success" aria-hidden="true"></span>
              {/if}
            </div>
            <p class="mt-0.5 hidden truncate text-sm text-base-content/60 sm:block" title="{if $user->_data['vkontakte_connected']} {__("Your account is connected to")} {__("Vkontakte")} {else} {__("Connect your account to")} {__("Vkontakte")} {/if}">
              {if $user->_data['vkontakte_connected']}
                {__("Your account is connected to")} {__("Vkontakte")}
              {else}
                {__("Connect your account to")} {__("Vkontakte")}
              {/if}
            </p>
          </div>
          {if $user->_data['vkontakte_connected']}
            <a class="heroui button button--danger-soft button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/revoke/vkontakte">
              <span class="icon-[tabler--plug-connected-x] size-4" aria-hidden="true"></span>
              {__("Disconnect")}
            </a>
          {else}
            <a class="heroui button button--primary button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/connect/vkontakte">
              <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span>
              {__("Connect")}
            </a>
          {/if}
        </div>
        <!-- vkontakte -->
      {/if}
      {if $system['wordpress_login_enabled']}
        <!-- wordpress -->
        <div class="flex items-center gap-4 p-4">
          <span class="inline-flex size-10 shrink-0 items-center justify-center overflow-hidden rounded-xl bg-base-200" aria-hidden="true">
            {include file='__svg_icons.tpl' icon="wordpress" width="24px" height="24px"}
          </span>
          <div class="min-w-0 grow">
            <div class="flex flex-wrap items-center gap-2">
              <span class="text-sm font-medium">{__("Wordpress")}</span>
              {if $user->_data['wordpress_connected']}
                <span class="icon-[tabler--circle-check-filled] size-4 text-success" aria-hidden="true"></span>
              {/if}
            </div>
            <p class="mt-0.5 hidden truncate text-sm text-base-content/60 sm:block" title="{if $user->_data['wordpress_connected']} {__("Your account is connected to")} {__("Wordpress")} {else} {__("Connect your account to")} {__("Wordpress")} {/if}">
              {if $user->_data['wordpress_connected']}
                {__("Your account is connected to")} {__("Wordpress")}
              {else}
                {__("Connect your account to")} {__("Wordpress")}
              {/if}
            </p>
          </div>
          {if $user->_data['wordpress_connected']}
            <a class="heroui button button--danger-soft button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/revoke/wordpress">
              <span class="icon-[tabler--plug-connected-x] size-4" aria-hidden="true"></span>
              {__("Disconnect")}
            </a>
          {else}
            <a class="heroui button button--primary button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/connect/wordpress">
              <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span>
              {__("Connect")}
            </a>
          {/if}
        </div>
        <!-- wordpress -->
      {/if}
      {if $system['sngine_login_enabled']}
        <!-- sngine -->
        <div class="flex items-center gap-4 p-4">
          <span class="inline-flex size-10 shrink-0 items-center justify-center overflow-hidden rounded-xl bg-base-200">
            <img class="size-full object-cover" src="{$system['system_uploads']}/{$system['sngine_app_icon']}" alt="{__({$system['sngine_app_name']})}">
          </span>
          <div class="min-w-0 grow">
            <div class="flex flex-wrap items-center gap-2">
              <span class="text-sm font-medium">{__({$system['sngine_app_name']})}</span>
              {if $user->_data['sngine_connected']}
                <span class="icon-[tabler--circle-check-filled] size-4 text-success" aria-hidden="true"></span>
              {/if}
            </div>
            <p class="mt-0.5 hidden truncate text-sm text-base-content/60 sm:block" title="{if $user->_data['sngine_connected']} {__("Your account is connected to")} {__({$system['sngine_app_name']})} {else} {__("Connect your account to")} {__({$system['sngine_app_name']})} {/if}">
              {if $user->_data['sngine_connected']}
                {__("Your account is connected to")} {__({$system['sngine_app_name']})}
              {else}
                {__("Connect your account to")} {__({$system['sngine_app_name']})}
              {/if}
            </p>
          </div>
          {if $user->_data['sngine_connected']}
            <a class="heroui button button--danger-soft button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/revoke/sngine">
              <span class="icon-[tabler--plug-connected-x] size-4" aria-hidden="true"></span>
              {__("Disconnect")}
            </a>
          {else}
            <a class="heroui button button--primary button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="https://{$system['sngine_app_domain']}/api/oauth?app_id={$system['sngine_appid']}">
              <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span>
              {__("Connect")}
            </a>
          {/if}
        </div>
        <!-- sngine -->
      {/if}
    </div>
  </div>
</div>
