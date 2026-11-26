{if !$user->_logged_in}

  <body {if $system['theme_mode_night']}data-bs-theme="dark" {/if} class="{if $system['theme_mode_night']}night-mode{/if} [--plyr-color-main:var(--color-primary)] visitor n_chat {if $page == 'reels'}overflow-hidden overscroll-none bg-black {/if}{if $page == 'index' && !$system['newsfeed_public']}index-body{/if} {if ($page == 'index' && !$system['newsfeed_public']) || in_array($page, ['sign','reset','activation','approval'])}auth-body{/if}" {if $page == 'profile' && $system['system_profile_background_enabled'] && $profile['user_profile_background']}style="background: url({$profile['user_profile_background']}) fixed !important; background-size: 100% auto;" {/if}>
  {else}

    <body data-chat-enabled="{$user->_data['user_chat_enabled']}" {if $system['theme_mode_night']}data-bs-theme="dark" {/if} class="{if $system['theme_mode_night']}night-mode{/if} [--plyr-color-main:var(--color-primary)] {if $page == 'reels'}overflow-hidden overscroll-none bg-black{else}pb-[calc(4.75rem+env(safe-area-inset-bottom))] pl-[env(safe-area-inset-left)] pr-[env(safe-area-inset-right)] md:pb-0{/if} {if !$system['chat_enabled'] || $user->_data['user_privacy_chat'] =="me"}n_chat{/if}{if $system['activation_enabled'] && !$system['activation_required'] && !$user->_data['user_activated']} n_activated{/if}{if !$system['system_live']} n_live{/if}" {if $page == 'profile' && $system['system_profile_background_enabled'] && $profile['user_profile_background']}style="background: url({$profile['user_profile_background']}) fixed !important; background-size: 100% auto;" {/if} {if $url}onload="initialize_scraper()" {/if}>
    {/if}
    <!-- main wrapper -->
    <div class="flex min-h-full min-w-[260px] w-full flex-col">
      {assign var="_site_header" value=($page != "reels" && ($page != "index" || $user->_logged_in || $system['newsfeed_public']) && !($page == "sign" && ($system['landing'] == "summit" || $system['landing'] == "studio"))) scope="global"}
      {assign var="_site_shell" value=($_site_header && !in_array($page, ['sign', 'reset', 'activation', 'approval'])) scope="global"}
      {assign var="_site_search" value=($user->_logged_in || $system['system_public'])}

      {if $user->_login_as}
        <!-- bottom-bar alert-->
        <div class="fixed inset-x-0 bottom-3 z-40 flex justify-center px-4">
          <div class="flex flex-wrap items-center justify-center gap-3 rounded-box bg-primary px-5 py-3.5 text-primary-content">
            <span class="icon-[tabler--alert-triangle] size-5" aria-hidden="true"></span>
            <span>{__("You are currently logged in as")} <a class="text-inherit! underline" href="{$system['system_url']}/{$user->_data['user_name']}">{$user->_data['user_fullname']}</a></span>
            <button class="heroui button button--primary [--button-bg:var(--warning)] [--button-bg-hover:var(--warning-hover)] [--button-bg-pressed:var(--warning-hover)] [--button-fg:var(--warning-foreground)] button--sm js_login-as" data-handle="revoke">
              <span class="icon-[tabler--arrow-back-up] size-4" aria-hidden="true"></span>{__("Switch Back")}
            </button>
          </div>
        </div>
        <!-- bottom-bar alert-->
      {/if}

      {if $_site_shell}
        <!-- site shell -->
        <div class="site-shell flex flex-col{if $page == 'messages'} h-[calc(100dvh-4.75rem-env(safe-area-inset-bottom))] overflow-hidden md:h-dvh{else} min-h-dvh{/if}">

            {if !$system['system_live']}
              <!-- shutdown -->
              <div class="bg-error text-error-content" role="alert">
                <div class="mx-auto flex min-h-10 w-full flex-wrap items-center justify-center gap-x-3 gap-y-1 px-4 py-2 text-center text-sm sm:px-6{if !$system['fluid_design']} max-w-7xl{/if}">
                  <span class="inline-flex items-center gap-2 font-medium">
                    <span class="icon-[tabler--power] size-4 shrink-0" aria-hidden="true"></span>
                    {__("The system has been shut down")}.
                  </span>
                  <a class="inline-flex items-center gap-1 font-semibold text-error-content! underline-offset-4 hover:underline" href="{$system['system_url']}/admincp/settings">
                    {__("Turn it on from")} {__("Admin Panel")}
                    <span class="icon-[tabler--arrow-right] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                  </a>
                </div>
              </div>
              <!-- shutdown -->
            {/if}

            {$_activation_alert = ($user->_logged_in && $system['activation_enabled'] && !$system['activation_required'] && !$user->_data['user_activated'])}
            {if $_activation_alert}
              <!-- alerts -->
              <div class="mx-auto flex w-full flex-col gap-3 px-4 pt-4 sm:px-6{if !$system['fluid_design']} max-w-7xl{/if}">
                <div class="alert alert-soft alert-warning flex flex-wrap items-center gap-x-4 gap-y-2 rounded-box text-sm" role="alert">
                  <span class="icon-[tabler--mail-exclamation] size-5 shrink-0" aria-hidden="true"></span>
                  <p class="min-w-0 grow">
                    {if $system['activation_type'] == "email"}
                      {__("Please go to")} <span class="font-semibold">{$user->_data['user_email']}</span> {__("to complete the activation process")}.
                    {else}
                      {__("Please check the SMS on your phone")} <strong>{$user->_data['user_phone']}</strong> {__("to complete the activation process")}.
                    {/if}
                  </p>
                  <div class="flex flex-wrap items-center gap-3 font-medium">
                    {if $system['activation_type'] == "email"}
                      <span class="js_modal cursor-pointer underline" data-url="core/activation_email_resend.php">{__("Resend Verification Email")}</span>
                      <span class="js_modal cursor-pointer underline" data-url="#activation-email-reset">{__("Change Email")}</span>
                    {else}
                      <span class="js_modal heroui button button--primary [--button-bg:var(--warning)] [--button-bg-hover:var(--warning-hover)] [--button-bg-pressed:var(--warning-hover)] [--button-fg:var(--warning-foreground)] button--sm rounded-field" data-url="#activation-phone">{__("Enter Code")}</span>
                      {if $user->_data['user_phone']}
                        <span class="js_modal cursor-pointer underline" data-url="core/activation_phone_resend.php">{__("Resend SMS")}</span>
                      {/if}
                      <span class="js_modal cursor-pointer underline" data-url="#activation-phone-reset">{__("Change Phone Number")}</span>
                    {/if}
                  </div>
                </div>
              </div>
              <!-- alerts -->
            {/if}

            {include file='_header.topbar.tpl'}

            {if $_site_search}
              {include file='_header.search.tpl'}
            {/if}

            <!-- page content -->
            <div class="flex min-h-0 min-w-0 flex-1">
            <main class="site-content mx-auto w-full min-w-0 flex-1 px-4 pt-4 sm:px-6 sm:pt-6{if $page == 'messages'} flex min-h-0 flex-col overflow-hidden pb-4 sm:pb-6{else} pb-4 sm:pb-6 md:pb-10{/if}{if !$system['fluid_design']} max-w-7xl{/if}{if in_array($page, ['404', 'banned', 'permission'])} flex flex-col{/if}">

              <!-- ads -->
              {include file='_ads.tpl' _ads=$ads_master['header'] _master=true}
              <!-- ads -->

      {elseif $_site_header}
        {include file='_header.topbar.tpl'}

        {if $_site_search}
          {include file='_header.search.tpl'}
        {/if}

        <!-- ads -->
        {include file='_ads.tpl' _ads=$ads_master['header'] _master=true}
        <!-- ads -->

      {elseif $page != "reels"}
        <!-- ads -->
        {include file='_ads.tpl' _ads=$ads_master['header'] _master=true}
        <!-- ads -->
      {/if}
