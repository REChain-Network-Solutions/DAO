{if !$user->_logged_in}

  <body data-hash-tok="{$session_hash['token']}" data-hash-pos="{$session_hash['position']}" {if $system['theme_mode_night']}data-bs-theme="dark" {/if} class="{if $system['theme_mode_night']}night-mode{/if} visitor n_chat {if $page == 'index' && !$system['newsfeed_public']}index-body{/if}" {if $page == 'profile' && $system['system_profile_background_enabled'] && $profile['user_profile_background']}style="background: url({$profile['user_profile_background']}) fixed !important; background-size: 100% auto;" {/if}>
  {else}

    <body data-hash-tok="{$session_hash['token']}" data-hash-pos="{$session_hash['position']}" data-chat-enabled="{$user->_data['user_chat_enabled']}" {if $system['theme_mode_night']}data-bs-theme="dark" {/if} class="{if $system['theme_mode_night']}night-mode{/if} {if !$system['chat_enabled'] || $user->_data['user_privacy_chat'] == "me"}n_chat{/if}{if $system['activation_enabled'] && !$system['activation_required'] && !$user->_data['user_activated']} n_activated{/if}{if !$system['system_live']} n_live{/if}" {if $page == 'profile' && $system['system_profile_background_enabled'] && $profile['user_profile_background']}style="background: url({$profile['user_profile_background']}) fixed !important; background-size: 100% auto;" {/if} {if $url}onload="initialize_scraper()" {/if}>
    {/if}
    <!-- main wrapper -->
    <div class="main-wrapper">
      {if $user->_logged_in && $system['activation_enabled'] && !$system['activation_required'] && !$user->_data['user_activated']}
        <!-- top-bar -->
        <div class="top-bar">
          <div class="{if $system['fluid_design']}container-fluid{else}container{/if}">
            <div class="row">
              <div class="col-sm-7 d-none d-sm-block">
                {if $system['activation_type'] == "email"}
                  {__("Please go to")} <span class="text-primary">{$user->_data['user_email']}</span> {__("to complete the activation process")}.
                {else}
                  {__("Please check the SMS on your phone")} <strong>{$user->_data['user_phone']}</strong> {__("to complete the activation process")}.
                {/if}
              </div>
              <div class="col-sm-5">
                {if $system['activation_type'] == "email"}
                  <span class="text-link" data-toggle="modal" data-url="core/activation_email_resend.php">
                    {__("Resend Verification Email")}
                  </span>
                  -
                  <span class="text-link" data-toggle="modal" data-url="#activation-email-reset">
                    {__("Change Email")}
                  </span>
                {else}
                  <span class="btn btn-info btn-sm mr10" data-toggle="modal" data-url="#activation-phone">{__("Enter Code")}</span>
                  {if $user->_data['user_phone']}
                    <span class="text-link" data-toggle="modal" data-url="core/activation_phone_resend.php">
                      {__("Resend SMS")}
                    </span>
                    -
                  {/if}
                  <span class="text-link" data-toggle="modal" data-url="#activation-phone-reset">
                    {__("Change Phone Number")}
                  </span>
                {/if}
              </div>
            </div>
          </div>
        </div>
        <!-- top-bar -->
      {/if}

      {if !$system['system_live']}
        <!-- top-bar alert-->
        <div class="top-bar danger">
          <div class="{if $system['fluid_design']}container-fluid{else}container{/if}">
            <i class="fa fa-exclamation-triangle fa-lg pr5"></i>
            <span class="d-none d-sm-inline">{__("The system has been shut down")}.</span>
            <span>{__("Turn it on from")}</span> <a href="{$system['system_url']}/admincp/settings">{__("Admin Panel")}</a>
          </div>
        </div>
        <!-- top-bar alert-->
      {/if}

      {if $user->_login_as}
        <!-- bottom-bar alert-->
        <div class="bottom-bar">
          <div class="container logged-as-container">
            <i class="fa fa-exclamation-triangle fa-lg pr5"></i>
            <span>{__("You are currently logged in as")} <a href="{$system['system_url']}/{$user->_data['user_name']}">{$user->_data['user_fullname']}</a></span>
            <button class="btn btn-sm btn-warning ml20 js_login-as" data-handle="revoke">
              <i class="fa-solid fa-arrow-rotate-left mr5"></i>{__("Switch Back")}
            </button>
          </div>
        </div>
        <!-- bottom-bar alert-->
      {/if}

      <!-- main-header -->
      {if $page != "index" || ($user->_logged_in || $system['newsfeed_public'])}
        <div class="main-header" {if $system['fluid_design']}style="padding-right: 0;" {/if}>
          <div class="{if $system['fluid_design']}container-fluid{else}container{/if}">
            <div class="row">

              <div class="col-7 col-md-4 col-lg-3">
                <!-- logo-wrapper -->
                <div class="logo-wrapper" {if !($user->_logged_in || (!$user->_logged_in && $system['newsfeed_public']))}style="padding-left: 0;" {/if}>

                  {if $user->_logged_in || (!$user->_logged_in && $system['newsfeed_public'])}
                    <!-- menu-icon -->
                    <a href="#" data-bs-toggle="sg-offcanvas" class="menu-icon d-block d-md-none">
                      {include file='__svg_icons.tpl' icon="header-menu" class="header-icon" width="20px" height="20px"}
                    </a>
                    <!-- menu-icon -->
                  {/if}

                  <!-- logo -->
                  <a href="{$system['system_url']}" class="logo">
                    {if $system['system_logo']}
                      <img class="logo-light img-fluid" src="{$system['system_uploads']}/{$system['system_logo']}" alt="{__($system['system_title'])}" title="{__($system['system_title'])}">
                      {if !$system['system_logo_dark']}
                        <img class="logo-dark img-fluid" src="{$system['system_uploads']}/{$system['system_logo']}" alt="{__($system['system_title'])}" title="{__($system['system_title'])}">
                      {else}
                        <img class="logo-dark img-fluid" src="{$system['system_uploads']}/{$system['system_logo_dark']}" alt="{$system['system_title']}" title="{__($system['system_title'])}">
                      {/if}
                    {else}
                      {__($system['system_title'])}
                    {/if}
                  </a>
                  <!-- logo -->
                </div>
                <!-- logo-wrapper -->
              </div>

              <div class="col-5 col-md-8 col-lg-9">
                <div class="row">
                  <div class="col-md-7 col-lg-8">
                    <!-- search-wrapper -->
                    {if $user->_logged_in || (!$user->_logged_in && $system['system_public']) }
                      {include file='_header.search.tpl'}
                    {/if}
                    <!-- search-wrapper -->
                  </div>
                  <div class="col-md-5 col-lg-4">
                    <!-- navbar-wrapper -->
                    <div class="navbar-wrapper">
                      <ul>
                        {if $user->_logged_in}
                          {if $user->_data['can_publish_posts'] || $user->_data['can_go_live'] || $user->_data['can_add_stories'] || $user->_data['can_write_blogs'] || $user->_data['can_sell_products'] || $user->_data['can_raise_funding'] || $user->_data['can_create_ads'] || $user->_data['can_create_pages'] || $user->_data['can_create_groups'] || $user->_data['can_create_events']}
                            <!-- add -->
                            <li class="d-none d-xxl-block dropdown">
                              <a href="#" data-bs-toggle="dropdown" data-display="static">
                                {include file='__svg_icons.tpl' icon="header-plus" class="header-icon" width="24px" height="24px"}
                              </a>
                              <div class="dropdown-menu dropdown-menu-end">
                                {if $user->_data['can_publish_posts']}
                                  <div class="dropdown-item pointer" data-toggle="modal" data-url="posts/publisher.php">
                                    {include file='__svg_icons.tpl' icon="newsfeed" class="main-icon mr10" width="24px" height="24px"}
                                    {__("Create Post")}
                                  </div>
                                {/if}
                                {if $user->_data['can_go_live']}
                                  <a class="dropdown-item" href="{$system['system_url']}/live">
                                    {include file='__svg_icons.tpl' icon="live" class="main-icon mr10" width="24px" height="24px"}
                                    {__("Create Live")}
                                  </a>
                                {/if}
                                {if $user->_data['can_add_stories']}
                                  <div class="dropdown-item pointer" data-toggle="modal" data-url="posts/story.php?do=create">
                                    {include file='__svg_icons.tpl' icon="24_hours" class="main-icon mr10" width="24px" height="24px"}
                                    {__("Create Story")}
                                  </div>
                                {/if}
                                {if $user->_data['can_write_blogs']}
                                  <a class="dropdown-item" href="{$system['system_url']}/blogs/new">
                                    {include file='__svg_icons.tpl' icon="blogs" class="main-icon mr10" width="24px" height="24px"}
                                    {__("Create Blog")}
                                  </a>
                                {/if}
                                {if $user->_data['can_sell_products']}
                                  <div class="dropdown-item pointer" data-toggle="modal" data-url="posts/product.php?do=create">
                                    {include file='__svg_icons.tpl' icon="products" class="main-icon mr10" width="24px" height="24px"}
                                    {__("Create Product")}
                                  </div>
                                {/if}
                                {if $user->_data['can_raise_funding']}
                                  <div class="dropdown-item pointer" data-toggle="modal" data-url="posts/funding.php?do=create">
                                    {include file='__svg_icons.tpl' icon="funding" class="main-icon mr10" width="24px" height="24px"}
                                    {__("Create Funding")}
                                  </div>
                                {/if}
                                {if $user->_data['can_create_ads']}
                                  <a class="dropdown-item" href="{$system['system_url']}/ads/new">
                                    {include file='__svg_icons.tpl' icon="ads" class="main-icon mr10" width="24px" height="24px"}
                                    {__("Create Ads")}
                                  </a>
                                {/if}
                                {if $user->_data['can_create_pages']}
                                  <div class="dropdown-item pointer" data-toggle="modal" data-url="modules/add.php?type=page">
                                    {include file='__svg_icons.tpl' icon="pages" class="main-icon mr10" width="24px" height="24px"}
                                    {__("Create Page")}
                                  </div>
                                {/if}
                                {if $user->_data['can_create_groups']}
                                  <div class="dropdown-item pointer" data-toggle="modal" data-url="modules/add.php?type=group">
                                    {include file='__svg_icons.tpl' icon="groups" class="main-icon mr10" width="24px" height="24px"}
                                    {__("Create Group")}
                                  </div>
                                {/if}
                                {if $user->_data['can_create_events']}
                                  <div class="dropdown-item pointer" data-toggle="modal" data-url="modules/add.php?type=event">
                                    {include file='__svg_icons.tpl' icon="events" class="main-icon mr10" width="24px" height="24px"}
                                    {__("Create Event")}
                                  </div>
                                {/if}
                              </div>
                            </li>
                            <!-- add -->
                          {/if}

                          <!-- friend requests -->
                          {if $system['friends_enabled']}
                            {include file='_header.friend_requests.tpl'}
                          {/if}
                          <!-- friend requests -->

                          <!-- messages -->
                          {if $system['chat_enabled'] && $user->_data['user_privacy_chat'] != "me"}
                            {include file='_header.messages.tpl'}
                          {/if}
                          <!-- messages -->

                          <!-- notifications -->
                          {include file='_header.notifications.tpl'}
                          <!-- notifications -->

                          <!-- user-menu -->
                          <li class="d-none d-md-block dropdown">
                            {include file='_user_menu.tpl'}
                          </li>
                          <!-- user-menu -->

                        {else}

                          <li class="dropdown">
                            <a href="#" class="dropdown-toggle user-menu float-end" data-bs-toggle="dropdown" data-display="static">
                              <img src="{$system['system_url']}/content/themes/{$system['theme']}/images/blank_profile_male.png">
                              <span>{__("Join")}</span>
                            </a>
                            <div class="dropdown-menu dropdown-menu-end">
                              <a class="dropdown-item" href="{$system['system_url']}/signin">
                                {include file='__svg_icons.tpl' icon="login" class="main-icon mr10" width="20px" height="20px"}
                                {__("Sign In")}
                              </a>
                              {if $system['registration_enabled']}
                                <a class="dropdown-item" href="{$system['system_url']}/signup">
                                  {include file='__svg_icons.tpl' icon="user_add" class="main-icon mr10" width="20px" height="20px"}
                                  {__("Sign Up")}
                                </a>
                              {/if}
                              {if $user->_logged_in || (!$user->_logged_in && $system['system_public']) }
                                <div class="d-block d-md-none">
                                  <div class="dropdown-divider"></div>
                                  <a class="dropdown-item" href="{$system['system_url']}/search">
                                    {include file='__svg_icons.tpl' icon="search" class="main-icon mr10" width="20px" height="20px"}
                                    {__("Search")}
                                  </a>
                                </div>
                              {/if}
                              {if ($system['themes'] && count($system['themes']) > 1) || $system['system_theme_mode_select']}
                                <div class="dropdown-divider"></div>
                              {/if}
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
                          </li>

                        {/if}
                      </ul>
                    </div>
                    <!-- navbar-wrapper -->
                  </div>
                </div>

              </div>
            </div>

          </div>
        </div>
      {/if}
      <!-- main-header -->

      <!-- ads -->
      {include file='_ads.tpl' _ads=$ads_master['header'] _master=true}
<!-- ads -->