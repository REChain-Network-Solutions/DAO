<body data-chat-enabled="{$user->_data['user_chat_enabled']}" class="admin-shell font-sans antialiased [--plyr-color-main:var(--color-primary)]">

  <div class="admin-frame flex min-h-dvh flex-col bg-base-200">

    <!-- header -->
    <div class="admin-topbar bg-base-100 border-base-300 sticky top-0 z-50 flex border-b">
      <div class="w-full min-w-0">
        <nav class="navbar h-full min-h-0 gap-2 px-4 py-0">

          <!-- desktop sidebar toggle -->
          <button type="button" id="admin-sidebar-toggle" class="btn btn-text btn-square btn-sm me-2 hidden lg:inline-flex"
                  aria-expanded="true" aria-controls="layout-toggle" aria-label="{__("Collapse sidebar")}"
                  data-label-collapse="{__("Collapse sidebar")}" data-label-expand="{__("Expand sidebar")}">
            <span class="icon-[tabler--layout-sidebar] size-5" aria-hidden="true"></span>
          </button>
          <!-- sidebar toggle (mobile) -->
          <button type="button" class="btn btn-square btn-sm admin-topbar-icon me-2 lg:hidden"
                  aria-haspopup="dialog" aria-expanded="false" aria-controls="layout-toggle"
                  data-overlay="#layout-toggle" aria-label="{__("Menu")}">
            <span class="icon-[tabler--menu-2] size-4.5"></span>
          </button>
          <!-- sidebar toggle (mobile) -->

          <span class="admin-topbar-title" title="{$page_title|replace:'&rsaquo;':'›'}">{$page_title|replace:'&rsaquo;':'›'}</span>

          <div class="grow"></div>

          <!-- command palette trigger -->
          <button type="button" id="admin-palette-trigger" class="admin-topbar-search"
                  aria-haspopup="dialog" aria-expanded="false" aria-controls="admin-palette"
                  data-overlay="#admin-palette" aria-label="{__("Search")}">
            <span class="icon-[tabler--search] size-4.5 shrink-0" aria-hidden="true"></span>
            <span class="admin-topbar-search-label">{__("Search…")}</span>
            <kbd class="kbd kbd-xs admin-topbar-search-kbd" aria-hidden="true"><span class="js_palette-mod">Ctrl</span> K</kbd>
          </button>
          <!-- command palette trigger -->

          <div class="admin-topbar-chrome js_admin-topbar-chrome">
            <a class="btn btn-square btn-sm admin-topbar-icon" href="{$system['system_url']}" target="_blank" title="{__("Visit Website")}" aria-label="{__("Visit Website")}">
              <span class="icon-[tabler--world] size-4.5" aria-hidden="true"></span>
            </a>
            {include file='_admin_header.friend_requests.tpl'}
            {include file='_admin_header.messages.tpl'}
            {include file='_admin_header.notifications.tpl'}
          </div>

        </nav>
      </div>
    </div>
    <!-- header -->

    <!-- sidebar -->
    <aside id="layout-toggle"
           class="admin-sidebar overlay overlay-open:translate-x-0 drawer drawer-start inset-y-0 start-0 hidden h-full [--auto-close:lg] sm:w-64 lg:block lg:translate-x-0 lg:shadow-none"
           aria-label="{__("Sidebar")}" tabindex="-1">
      <div class="drawer-body border-base-content/20 h-full border-e p-0">
        <div class="flex h-full max-h-full flex-col">

          <button type="button" class="btn btn-text btn-circle btn-sm absolute end-3 top-3 lg:hidden"
                  aria-label="{__("Close")}" data-overlay="#layout-toggle">
            <span class="icon-[tabler--x] size-5"></span>
          </button>

          <!-- brand -->
          <a class="admin-sidebar-brand" href="{$system['system_url']}/{$control_panel['url']}" aria-label="{__($system['system_title'])} — {__("Admin Panel")}">
            {if $system['system_logo']}
              <img class="admin-sidebar-logo{if $system['system_logo_dark']} admin-sidebar-logo-light{/if}" src="{$system['system_uploads']}/{$system['system_logo']}" alt="">
              {if $system['system_logo_dark']}
                <img class="admin-sidebar-logo admin-sidebar-logo-dark" src="{$system['system_uploads']}/{$system['system_logo_dark']}" alt="">
              {/if}
            {else}
              <img class="admin-sidebar-logo" src="{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png" alt="">
            {/if}
            <span class="admin-sidebar-brand-text">
              <span class="admin-sidebar-brand-name">{__($system['system_title'])}</span>
              <span class="admin-sidebar-brand-sub">{__("Admin Panel")}</span>
            </span>
          </a>
          <!-- brand -->

          <div class="js_admin-sidebar-scroll min-h-0 flex-1 overflow-y-auto pt-2">
            <ul class="accordion menu menu-sm gap-0.5 px-4" id="admin-nav">
              <!-- System -->
              <li class="admin-nav-heading js_admin-nav-heading">{__("System")}</li>
              <!-- Dashboard -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}" class="px-2{if $view == "dashboard"} menu-active{/if}"><span class="icon-[tabler--gauge] size-4.5 shrink-0"></span><span class="grow">{__("Dashboard")}</span></a>
              </li>
              <!-- Dashboard -->
              {if $user->_is_admin}
              <!-- Settings -->
              <li class="accordion-item{if $view == "settings"} active{/if}" id="nav-settings">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-settings-collapse" aria-expanded="{if $view == "settings"}true{else}false{/if}">
                  <span class="icon-[tabler--settings] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Settings")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-settings-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "settings"}{else} hidden{/if}" aria-labelledby="nav-settings" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings" class="px-2{if $view == "settings" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("System Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/posts" class="px-2{if $view == "settings" && $sub_view == "posts"} menu-active{/if}"><span class="grow">{__("Posts Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/ai" class="px-2{if $view == "settings" && $sub_view == "ai"} menu-active{/if}"><span class="grow">{__("AI Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/registration" class="px-2{if $view == "settings" && $sub_view == "registration"} menu-active{/if}"><span class="grow">{__("Registration Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/accounts" class="px-2{if $view == "settings" && $sub_view == "accounts"} menu-active{/if}"><span class="grow">{__("Accounts Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/email" class="px-2{if $view == "settings" && $sub_view == "email"} menu-active{/if}"><span class="grow">{__("Email Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/sms" class="px-2{if $view == "settings" && $sub_view == "sms"} menu-active{/if}"><span class="grow">{__("SMS Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/notifications" class="px-2{if $view == "settings" && $sub_view == "notifications"} menu-active{/if}"><span class="grow">{__("Notifications Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/chat" class="px-2{if $view == "settings" && $sub_view == "chat"} menu-active{/if}"><span class="grow">{__("Chat Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/live" class="px-2{if $view == "settings" && $sub_view == "live"} menu-active{/if}"><span class="grow">{__("Live Stream Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/uploads" class="px-2{if $view == "settings" && $sub_view == "uploads"} menu-active{/if}"><span class="grow">{__("Uploads Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/payments" class="px-2{if $view == "settings" && $sub_view == "payments"} menu-active{/if}"><span class="grow">{__("Payments Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/security" class="px-2{if $view == "settings" && $sub_view == "security"} menu-active{/if}"><span class="grow">{__("Security Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/limits" class="px-2{if $view == "settings" && $sub_view == "limits"} menu-active{/if}"><span class="grow">{__("Limits Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/redis" class="px-2{if $view == "settings" && $sub_view == "redis"} menu-active{/if}"><span class="grow">{__("Redis Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/settings/analytics" class="px-2{if $view == "settings" && $sub_view == "analytics"} menu-active{/if}"><span class="grow">{__("Analytics Settings")}</span></a></li>
                  </ul>
                </div>
              </li>
              <!-- Settings -->
              <!-- Design -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/design" class="px-2{if $view == "design"} menu-active{/if}"><span class="icon-[tabler--brush] size-4.5 shrink-0"></span><span class="grow">{__("Design")}</span></a>
              </li>
              <!-- Design -->
              <!-- Themes -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/themes" class="px-2{if $view == "themes"} menu-active{/if}"><span class="icon-[tabler--device-desktop] size-4.5 shrink-0"></span><span class="grow">{__("Themes")}</span></a>
              </li>
              <!-- Themes -->
              <!-- Languages -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/languages" class="px-2{if $view == "languages"} menu-active{/if}"><span class="icon-[tabler--language] size-4.5 shrink-0"></span><span class="grow">{__("Languages")}</span></a>
              </li>
              <!-- Languages -->
              <!-- Countries -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/countries" class="px-2{if $view == "countries"} menu-active{/if}"><span class="icon-[tabler--world] size-4.5 shrink-0"></span><span class="grow">{__("Countries")}</span></a>
              </li>
              <!-- Countries -->
              <!-- Currencies -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/currencies" class="px-2{if $view == "currencies"} menu-active{/if}"><span class="icon-[tabler--cash] size-4.5 shrink-0"></span><span class="grow">{__("Currencies")}</span></a>
              </li>
              <!-- Currencies -->
              <!-- Genders -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/genders" class="px-2{if $view == "genders"} menu-active{/if}"><span class="icon-[tabler--gender-bigender] size-4.5 shrink-0"></span><span class="grow">{__("Genders")}</span></a>
              </li>
              <!-- Genders -->
              {/if}
              <!-- System -->
              <!-- Users -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_users_permission'])}
              <li class="admin-nav-heading js_admin-nav-heading">{__("Users")}</li>
              <!-- Users -->
              <li class="accordion-item{if $view == "users"} active{/if}" id="nav-users">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-users-collapse" aria-expanded="{if $view == "users"}true{else}false{/if}">
                  <span class="icon-[tabler--user] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Users")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-users-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "users"}{else} hidden{/if}" aria-labelledby="nav-users" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/users" class="px-2{if $view == "users" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List Users")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/users/moderators" class="px-2{if $view == "users" && $sub_view == "moderators"} menu-active{/if}"><span class="grow">{__("List Moderators")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/users/admins" class="px-2{if $view == "users" && $sub_view == "admins"} menu-active{/if}"><span class="grow">{__("List Admins")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/users/online" class="px-2{if $view == "users" && $sub_view == "online"} menu-active{/if}"><span class="grow">{__("List Online")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/users/banned" class="px-2{if $view == "users" && $sub_view == "banned"} menu-active{/if}"><span class="grow">{__("List Banned")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/users/not_activated" class="px-2{if $view == "users" && $sub_view == "not_activated"} menu-active{/if}"><span class="grow">{__("List Not Activated")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/users/pending" class="px-2{if $view == "users" && $sub_view == "pending"} menu-active{/if}"><span class="grow">{__("List Pending")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/users/stats" class="px-2{if $view == "users" && $sub_view == "stats"} menu-active{/if}"><span class="grow">{__("List Users Stats")}</span></a></li>
                  </ul>
                </div>
              </li>
              <!-- Users -->
              {if $user->_is_admin}
              <!-- Users Groups -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/users_groups" class="px-2{if $view == "users_groups"} menu-active{/if}"><span class="icon-[tabler--users] size-4.5 shrink-0"></span><span class="grow">{__("Users Groups")}</span></a>
              </li>
              <!-- Users Groups -->
              {/if}
              {if $user->_is_admin}
              <!-- Permissions Groups -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/permissions_groups" class="px-2{if $view == "permissions_groups"} menu-active{/if}"><span class="icon-[tabler--key] size-4.5 shrink-0"></span><span class="grow">{__("Permissions Groups")}</span></a>
              </li>
              <!-- Permissions Groups -->
              {/if}
              <!-- Users -->
              {/if}
              <!-- Modules -->
              <li class="admin-nav-heading js_admin-nav-heading">{__("Modules")}</li>
              <!-- Stories -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_stories_permission'])}
              <li class="accordion-item{if $view == "stories"} active{/if}" id="nav-stories">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-stories-collapse" aria-expanded="{if $view == "stories"}true{else}false{/if}">
                  <span class="icon-[tabler--history-toggle] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Stories")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-stories-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "stories"}{else} hidden{/if}" aria-labelledby="nav-stories" role="region">
                  <ul class="space-y-1 ps-4">
                    {if $user->_is_admin}
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/stories" class="px-2{if $view == "stories" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("Settings")}</span></a></li>
                    {/if}
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/stories/music" class="px-2{if $view == "stories" && ($sub_view == "music" || $sub_view == "add_music" || $sub_view == "edit_music")} menu-active{/if}"><span class="grow">{__("Music Library")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/stories/list" class="px-2{if $view == "stories" && $sub_view == "list"} menu-active{/if}"><span class="grow">{__("List Stories")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Stories -->
              <!-- Posts -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_posts_permission'])}
              <li class="accordion-item{if $view == "posts"} active{/if}" id="nav-posts">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-posts-collapse" aria-expanded="{if $view == "posts"}true{else}false{/if}">
                  <span class="icon-[tabler--news] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Posts")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-posts-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "posts"}{else} hidden{/if}" aria-labelledby="nav-posts" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/posts" class="px-2{if $view == "posts" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List Posts")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/posts/pending" class="px-2{if $view == "posts" && $sub_view == "pending"} menu-active{/if}"><span class="grow">{__("List Pending Posts")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/posts/videos_categories" class="px-2{if $view == "posts" && $sub_view == "videos_categories"} menu-active{/if}"><span class="grow">{__("List Videos Categories")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/posts/live_categories" class="px-2{if $view == "posts" && $sub_view == "live_categories"} menu-active{/if}"><span class="grow">{__("List Live Categories")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Posts -->
              <!-- Pages -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_pages_permission'])}
              <li class="accordion-item{if $view == "pages"} active{/if}" id="nav-pages">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-pages-collapse" aria-expanded="{if $view == "pages"}true{else}false{/if}">
                  <span class="icon-[tabler--flag] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Pages")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-pages-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "pages"}{else} hidden{/if}" aria-labelledby="nav-pages" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/pages" class="px-2{if $view == "pages" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List Pages")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/pages/categories" class="px-2{if $view == "pages" && $sub_view == "categories"} menu-active{/if}"><span class="grow">{__("List Categories")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Pages -->
              <!-- Groups -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_groups_permission'])}
              <li class="accordion-item{if $view == "groups"} active{/if}" id="nav-groups">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-groups-collapse" aria-expanded="{if $view == "groups"}true{else}false{/if}">
                  <span class="icon-[tabler--users] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Groups")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-groups-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "groups"}{else} hidden{/if}" aria-labelledby="nav-groups" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/groups" class="px-2{if $view == "groups" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List Groups")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/groups/categories" class="px-2{if $view == "groups" && $sub_view == "categories"} menu-active{/if}"><span class="grow">{__("List Categories")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Groups -->
              <!-- Events -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_events_permission'])}
              <li class="accordion-item{if $view == "events"} active{/if}" id="nav-events">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-events-collapse" aria-expanded="{if $view == "events"}true{else}false{/if}">
                  <span class="icon-[tabler--calendar] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Events")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-events-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "events"}{else} hidden{/if}" aria-labelledby="nav-events" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/events" class="px-2{if $view == "events" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List Events")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/events/categories" class="px-2{if $view == "events" && $sub_view == "categories"} menu-active{/if}"><span class="grow">{__("List Categories")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Events -->
              <!-- Blogs -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_blogs_permission'])}
              <li class="accordion-item{if $view == "blogs"} active{/if}" id="nav-blogs">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-blogs-collapse" aria-expanded="{if $view == "blogs"}true{else}false{/if}">
                  <span class="icon-[tabler--brand-blogger] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Blogs")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-blogs-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "blogs"}{else} hidden{/if}" aria-labelledby="nav-blogs" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/blogs" class="px-2{if $view == "blogs" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List Blogs")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/blogs/categories" class="px-2{if $view == "blogs" && $sub_view == "categories"} menu-active{/if}"><span class="grow">{__("List Categories")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Blogs -->
              <!-- Offers -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_offers_permission'])}
              <li class="accordion-item{if $view == "offers"} active{/if}" id="nav-offers">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-offers-collapse" aria-expanded="{if $view == "offers"}true{else}false{/if}">
                  <span class="icon-[tabler--tag] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Offers")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-offers-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "offers"}{else} hidden{/if}" aria-labelledby="nav-offers" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/offers" class="px-2{if $view == "offers" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List Offers")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/offers/categories" class="px-2{if $view == "offers" && $sub_view == "categories"} menu-active{/if}"><span class="grow">{__("List Categories")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Offers -->
              <!-- Jobs -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_jobs_permission'])}
              <li class="accordion-item{if $view == "jobs"} active{/if}" id="nav-jobs">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-jobs-collapse" aria-expanded="{if $view == "jobs"}true{else}false{/if}">
                  <span class="icon-[tabler--briefcase] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Jobs")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-jobs-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "jobs"}{else} hidden{/if}" aria-labelledby="nav-jobs" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/jobs" class="px-2{if $view == "jobs" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List Jobs")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/jobs/categories" class="px-2{if $view == "jobs" && $sub_view == "categories"} menu-active{/if}"><span class="grow">{__("List Categories")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Jobs -->
              <!-- Courses -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_courses_permission'])}
              <li class="accordion-item{if $view == "courses"} active{/if}" id="nav-courses">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-courses-collapse" aria-expanded="{if $view == "courses"}true{else}false{/if}">
                  <span class="icon-[tabler--book] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Courses")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-courses-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "courses"}{else} hidden{/if}" aria-labelledby="nav-courses" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/courses" class="px-2{if $view == "courses" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List Courses")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/courses/categories" class="px-2{if $view == "courses" && $sub_view == "categories"} menu-active{/if}"><span class="grow">{__("List Categories")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Courses -->
              <!-- Forums -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_forums_permission'])}
              <li class="accordion-item{if $view == "forums"} active{/if}" id="nav-forums">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-forums-collapse" aria-expanded="{if $view == "forums"}true{else}false{/if}">
                  <span class="icon-[tabler--messages] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Forums")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-forums-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "forums"}{else} hidden{/if}" aria-labelledby="nav-forums" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/forums" class="px-2{if $view == "forums" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List Forums")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/forums/threads" class="px-2{if $view == "forums" && $sub_view == "threads"} menu-active{/if}"><span class="grow">{__("List Threads")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/forums/replies" class="px-2{if $view == "forums" && $sub_view == "replies"} menu-active{/if}"><span class="grow">{__("List Replies")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Forums -->
              <!-- Movies -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_movies_permission'])}
              <li class="accordion-item{if $view == "movies"} active{/if}" id="nav-movies">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-movies-collapse" aria-expanded="{if $view == "movies"}true{else}false{/if}">
                  <span class="icon-[tabler--movie] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Movies")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-movies-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "movies"}{else} hidden{/if}" aria-labelledby="nav-movies" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/movies" class="px-2{if $view == "movies" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List Movies")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/movies/genres" class="px-2{if $view == "movies" && $sub_view == "genres"} menu-active{/if}"><span class="grow">{__("List Genres")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Movies -->
              <!-- Games -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_games_permission'])}
              <li class="accordion-item{if $view == "games"} active{/if}" id="nav-games">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-games-collapse" aria-expanded="{if $view == "games"}true{else}false{/if}">
                  <span class="icon-[tabler--device-gamepad-2] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Games")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-games-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "games"}{else} hidden{/if}" aria-labelledby="nav-games" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/games" class="px-2{if $view == "games" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List Games")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/games/genres" class="px-2{if $view == "games" && $sub_view == "genres"} menu-active{/if}"><span class="grow">{__("List Genres")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Games -->
              <!-- Modules -->
              <!-- Money -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_ads_permission']) || ($user->_is_moderator && $system['mods_wallet_permission']) || ($user->_is_moderator && $system['mods_pro_permission']) || ($user->_is_moderator && $system['mods_affiliates_permission']) || ($user->_is_moderator && $system['mods_points_permission']) || ($user->_is_moderator && $system['mods_marketplace_permission']) || ($user->_is_moderator && $system['mods_funding_permission']) || ($user->_is_moderator && $system['mods_monetization_permission']) || ($user->_is_moderator && $system['mods_dating_permission']) || ($user->_is_moderator && $system['mods_tips_permission'])}
              <li class="admin-nav-heading js_admin-nav-heading">{__("Money")}</li>
              <!-- Earnings -->
              {if $user->_is_admin}
              <li class="accordion-item{if $view == "earnings"} active{/if}" id="nav-earnings">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-earnings-collapse" aria-expanded="{if $view == "earnings"}true{else}false{/if}">
                  <span class="icon-[tabler--chart-line] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Earnings")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-earnings-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "earnings"}{else} hidden{/if}" aria-labelledby="nav-earnings" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/earnings" class="px-2{if $view == "earnings" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("Payments")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/earnings/commissions" class="px-2{if $view == "earnings" && $sub_view == "commissions"} menu-active{/if}"><span class="grow">{__("Commissions")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/earnings/packages" class="px-2{if $view == "earnings" && $sub_view == "packages"} menu-active{/if}"><span class="grow">{__("Pro Packages")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/earnings/movies" class="px-2{if $view == "earnings" && $sub_view == "movies"} menu-active{/if}"><span class="grow">{__("Movies")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/earnings/paid_modules" class="px-2{if $view == "earnings" && $sub_view == "paid_modules"} menu-active{/if}"><span class="grow">{__("Paid Modules")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Earnings -->
              <!-- Ads -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_ads_permission'])}
              <li class="accordion-item{if $view == "ads"} active{/if}" id="nav-ads">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-ads-collapse" aria-expanded="{if $view == "ads"}true{else}false{/if}">
                  <span class="icon-[tabler--target] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Ads")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-ads-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "ads"}{else} hidden{/if}" aria-labelledby="nav-ads" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/ads" class="px-2{if $view == "ads" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("Ads Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/ads/users_ads" class="px-2{if $view == "ads" && $sub_view == "users_ads"} menu-active{/if}"><span class="grow">{__("List Users Ads")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/ads/system_ads" class="px-2{if $view == "ads" && $sub_view == "system_ads"} menu-active{/if}"><span class="grow">{__("List System Ads")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Ads -->
              <!-- Wallet -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_wallet_permission'])}
              <li class="accordion-item{if $view == "wallet"} active{/if}" id="nav-wallet">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-wallet-collapse" aria-expanded="{if $view == "wallet"}true{else}false{/if}">
                  <span class="icon-[tabler--wallet] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Wallet")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-wallet-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "wallet"}{else} hidden{/if}" aria-labelledby="nav-wallet" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/wallet" class="px-2{if $view == "wallet" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("Wallet Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/wallet/payments" class="px-2{if $view == "wallet" && $sub_view == "payments"} menu-active{/if}"><span class="grow">{__("Payment Requests")}</span>{if $wallet_payments_insights}<span class="badge badge-sm badge-error rounded-full">{$wallet_payments_insights}</span>{/if}</a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Wallet -->
              <!-- Pro System -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_pro_permission'])}
              <li class="accordion-item{if $view == "pro"} active{/if}" id="nav-pro">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-pro-collapse" aria-expanded="{if $view == "pro"}true{else}false{/if}">
                  <span class="icon-[tabler--stack-2] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Pro System")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-pro-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "pro"}{else} hidden{/if}" aria-labelledby="nav-pro" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/pro" class="px-2{if $view == "pro" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("Pro Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/pro/packages" class="px-2{if $view == "pro" && $sub_view == "packages"} menu-active{/if}"><span class="grow">{__("List Packages")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/pro/subscribers" class="px-2{if $view == "pro" && $sub_view == "subscribers"} menu-active{/if}"><span class="grow">{__("List Subscribers")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Pro System -->
              <!-- Affiliates -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_affiliates_permission'])}
              <li class="accordion-item{if $view == "affiliates"} active{/if}" id="nav-affiliates">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-affiliates-collapse" aria-expanded="{if $view == "affiliates"}true{else}false{/if}">
                  <span class="icon-[tabler--arrows-exchange] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Affiliates")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-affiliates-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "affiliates"}{else} hidden{/if}" aria-labelledby="nav-affiliates" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/affiliates" class="px-2{if $view == "affiliates" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("Affiliates Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/affiliates/payments" class="px-2{if $view == "affiliates" && $sub_view == "payments"} menu-active{/if}"><span class="grow">{__("Payment Requests")}</span>{if $affiliates_payments_insights}<span class="badge badge-sm badge-error rounded-full">{$affiliates_payments_insights}</span>{/if}</a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Affiliates -->
              <!-- Points -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_points_permission'])}
              <li class="accordion-item{if $view == "points"} active{/if}" id="nav-points">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-points-collapse" aria-expanded="{if $view == "points"}true{else}false{/if}">
                  <span class="icon-[tabler--pig-money] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Points System")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-points-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "points"}{else} hidden{/if}" aria-labelledby="nav-points" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/points" class="px-2{if $view == "points" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("Points Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/points/payments" class="px-2{if $view == "points" && $sub_view == "payments"} menu-active{/if}"><span class="grow">{__("Payment Requests")}</span>{if $points_payments_insights}<span class="badge badge-sm badge-error rounded-full">{$points_payments_insights}</span>{/if}</a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Points -->
              <!-- Paid Modules -->
              {if $user->_is_admin}
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/paid_modules" class="px-2{if $view == "paid_modules"} menu-active{/if}"><span class="icon-[tabler--report-money] size-4.5 shrink-0"></span><span class="grow">{__("Paid Modules")}</span></a>
              </li>
              {/if}
              <!-- Paid Modules -->
              <!-- Market -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_marketplace_permission'])}
              <li class="accordion-item{if $view == "market"} active{/if}" id="nav-market">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-market-collapse" aria-expanded="{if $view == "market"}true{else}false{/if}">
                  <span class="icon-[tabler--shopping-bag] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Marketplace")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-market-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "market"}{else} hidden{/if}" aria-labelledby="nav-market" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/market" class="px-2{if $view == "market" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("Market Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/market/products" class="px-2{if $view == "market" && $sub_view == "products"} menu-active{/if}"><span class="grow">{__("List Products")}</span></a></li>
                    {if $licence_monetization}
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/market/orders" class="px-2{if $view == "market" && $sub_view == "orders"} menu-active{/if}"><span class="grow">{__("List Orders")}</span></a></li>
                    {/if}
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/market/categories" class="px-2{if $view == "market" && $sub_view == "categories"} menu-active{/if}"><span class="grow">{__("List Categories")}</span></a></li>
                    {if $licence_monetization}
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/market/payments" class="px-2{if $view == "market" && $sub_view == "payments"} menu-active{/if}"><span class="grow">{__("Payment Requests")}</span>{if $marketplace_payments_insights}<span class="badge badge-sm badge-error rounded-full">{$marketplace_payments_insights}</span>{/if}</a></li>
                    {/if}
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Market -->
              <!-- Funding -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_funding_permission'])}
              <li class="accordion-item{if $view == "funding"} active{/if}" id="nav-funding">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-funding-collapse" aria-expanded="{if $view == "funding"}true{else}false{/if}">
                  <span class="icon-[tabler--coin] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Funding")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-funding-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "funding"}{else} hidden{/if}" aria-labelledby="nav-funding" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/funding" class="px-2{if $view == "funding" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("Funding Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/funding/payments" class="px-2{if $view == "funding" && $sub_view == "payments"} menu-active{/if}"><span class="grow">{__("Payment Requests")}</span>{if $funding_payments_insights}<span class="badge badge-sm badge-error rounded-full">{$funding_payments_insights}</span>{/if}</a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/funding/requests" class="px-2{if $view == "funding" && $sub_view == "requests"} menu-active{/if}"><span class="grow">{__("Funding Requests")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/funding/categories" class="px-2{if $view == "funding" && ($sub_view == "categories" || $sub_view == "add_category" || $sub_view == "edit_category")} menu-active{/if}"><span class="grow">{__("Categories")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Funding -->
              <!-- Monetization -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_monetization_permission'])}
              <li class="accordion-item{if $view == "monetization"} active{/if}" id="nav-monetization">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-monetization-collapse" aria-expanded="{if $view == "monetization"}true{else}false{/if}">
                  <span class="icon-[tabler--coins] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Monetization")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-monetization-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "monetization"}{else} hidden{/if}" aria-labelledby="nav-monetization" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/monetization" class="px-2{if $view == "monetization" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("Monetization Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/monetization/payments" class="px-2{if $view == "monetization" && $sub_view == "payments"} menu-active{/if}"><span class="grow">{__("Payment Requests")}</span>{if $monetization_payments_insights}<span class="badge badge-sm badge-error rounded-full">{$monetization_payments_insights}</span>{/if}</a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Monetization -->
              <!-- Dating -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_dating_permission'])}
              <li class="accordion-item{if $view == "dating"} active{/if}" id="nav-dating">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-dating-collapse" aria-expanded="{if $view == "dating"}true{else}false{/if}">
                  <span class="icon-[tabler--heart] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Dating")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-dating-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "dating"}{else} hidden{/if}" aria-labelledby="nav-dating" role="region">
                  <ul class="space-y-1 ps-4">
                    {if $user->_is_admin}
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/dating" class="px-2{if $view == "dating" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("Dashboard")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/dating/settings" class="px-2{if $view == "dating" && $sub_view == "settings"} menu-active{/if}"><span class="grow">{__("Dating Settings")}</span></a></li>
                    {/if}
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/dating/photos" class="px-2{if $view == "dating" && $sub_view == "photos"} menu-active{/if}"><span class="grow">{__("Photos In Review")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/dating/members" class="px-2{if $view == "dating" && ($sub_view == "members" || $sub_view == "edit_member")} menu-active{/if}"><span class="grow">{__("List Members")}</span></a></li>
                    {if $user->_is_admin}
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/dating/interests" class="px-2{if $view == "dating" && ($sub_view == "interests" || $sub_view == "add_interest" || $sub_view == "edit_interest")} menu-active{/if}"><span class="grow">{__("List Interests")}</span></a></li>
                    {/if}
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Dating -->
              <!-- Tips -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_tips_permission'])}
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/tips" class="px-2{if $view == "tips"} menu-active{/if}"><span class="icon-[tabler--currency-dollar] size-4.5 shrink-0"></span><span class="grow">{__("Tips")}</span></a>
              </li>
              {/if}
              <!-- Tips -->
              {/if}
              <!-- Money -->
              <!-- Payments -->
              {if $user->_is_admin || $user->_is_moderator && $system['mods_payments_permission']}
              <li class="admin-nav-heading js_admin-nav-heading">{__("Payments")}</li>
              <!-- CoinPayments -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/coinpayments" class="px-2{if $view == "coinpayments"} menu-active{/if}"><span class="icon-[tabler--currency-bitcoin] size-4.5 shrink-0"></span><span class="grow">{__("CoinPayments")}</span></a>
              </li>
              <!-- CoinPayments -->
              <!-- Bank Receipts -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/bank" class="px-2{if $view == "bank"} menu-active{/if}"><span class="icon-[tabler--building-bank] size-4.5 shrink-0"></span><span class="grow">{__("Bank Receipts")}</span>{if $bank_transfers_insights}<span class="badge badge-sm badge-error rounded-full">{$bank_transfers_insights}</span>{/if}</a>
              </li>
              <!-- Bank Receipts -->
              {/if}
              <!-- Payments -->
              <!-- Developers -->
              {if $user->_is_admin || $user->_is_moderator && $system['mods_developers_permission']}
              <li class="admin-nav-heading js_admin-nav-heading">{__("Developers")}</li>
              <!-- Developers -->
              <li class="accordion-item{if $view == "developers"} active{/if}" id="nav-developers">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-developers-collapse" aria-expanded="{if $view == "developers"}true{else}false{/if}">
                  <span class="icon-[tabler--stack-2] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Developers")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-developers-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "developers"}{else} hidden{/if}" aria-labelledby="nav-developers" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/developers" class="px-2{if $view == "developers" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("Developers Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/developers/apps" class="px-2{if $view == "developers" && $sub_view == "apps"} menu-active{/if}"><span class="grow">{__("List Apps")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/developers/categories" class="px-2{if $view == "developers" && $sub_view == "categories"} menu-active{/if}"><span class="grow">{__("List Categories")}</span></a></li>
                  </ul>
                </div>
              </li>
              <!-- Developers -->
              {/if}
              <!-- Developers -->
              <!-- Support -->
              {if $system['support_center_enabled']}
              <li class="admin-nav-heading js_admin-nav-heading">{__("Support Center")}</li>
              <li>
                <a href="{$system['system_url']}/support" class="px-2{if $view == "support"} menu-active{/if}"><span class="icon-[tabler--headset] size-4.5 shrink-0"></span><span class="grow">{__("Support Center")}</span></a>
              </li>
              {/if}
              <!-- Support -->
              <!-- Moderation -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_reports_permission']) || ($user->_is_moderator && $system['mods_blacklist_permission']) || ($user->_is_moderator && $system['mods_verifications_permission'])}
              <li class="admin-nav-heading js_admin-nav-heading">{__("Moderation")}</li>
              <!-- Reports -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_reports_permission'])}
              <li class="accordion-item{if $view == "reports"} active{/if}" id="nav-reports">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-reports-collapse" aria-expanded="{if $view == "reports"}true{else}false{/if}">
                  <span class="icon-[tabler--alert-triangle] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Reports")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-reports-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "reports"}{else} hidden{/if}" aria-labelledby="nav-reports" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/reports" class="px-2{if $view == "reports" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List reports")}</span>{if $reports_insights}<span class="badge badge-sm badge-error rounded-full">{$reports_insights}</span>{/if}</a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/reports/categories" class="px-2{if $view == "reports" && $sub_view == "categories"} menu-active{/if}"><span class="grow">{__("List Categories")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Reports -->
              <!-- Blacklist -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_blacklist_permission'])}
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/blacklist" class="px-2{if $view == "blacklist"} menu-active{/if}"><span class="icon-[tabler--circle-minus] size-4.5 shrink-0"></span><span class="grow">{__("Blacklist")}</span></a>
              </li>
              {/if}
              <!-- Blacklist -->
              <!-- Verification -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_verifications_permission'])}
              <li class="accordion-item{if $view == "verification"} active{/if}" id="nav-verification">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-verification-collapse" aria-expanded="{if $view == "verification"}true{else}false{/if}">
                  <span class="icon-[tabler--circle-check] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Verification")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-verification-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "verification"}{else} hidden{/if}" aria-labelledby="nav-verification" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/verification" class="px-2{if $view == "verification" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("List Requests")}</span>{if $verification_requests_insights}<span class="badge badge-sm badge-error rounded-full">{$verification_requests_insights}</span>{/if}</a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/verification/users" class="px-2{if $view == "verification" && $sub_view == "users"} menu-active{/if}"><span class="grow">{__("List Verified Users")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/verification/pages" class="px-2{if $view == "verification" && $sub_view == "pages"} menu-active{/if}"><span class="grow">{__("List Verified Pages")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Verification -->
              {/if}
              <!-- Moderation -->
              <!-- Tools -->
              {if $user->_is_admin}
              <li class="admin-nav-heading js_admin-nav-heading">{__("Tools")}</li>
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/tools/faker" class="px-2{if $view == "tools" && $sub_view == "faker"} menu-active{/if}"><span class="icon-[tabler--users-plus] size-4.5 shrink-0"></span><span class="grow">{__("Fake Generator")}</span></a>
              </li>
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/tools/auto-connect" class="px-2{if $view == "tools" && $sub_view == "auto-connect"} menu-active{/if}"><span class="icon-[tabler--plug-connected] size-4.5 shrink-0"></span><span class="grow">{__("Auto Connect")}</span></a>
              </li>
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/tools/garbage-collector" class="px-2{if $view == "tools" && $sub_view == "garbage-collector"} menu-active{/if}"><span class="icon-[tabler--trash] size-4.5 shrink-0"></span><span class="grow">{__("Garbage Collector")}</span></a>
              </li>
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/tools/search-index" class="px-2{if $view == "tools" && $sub_view == "search-index"} menu-active{/if}"><span class="icon-[tabler--search] size-4.5 shrink-0"></span><span class="grow">{__("Search Index")}</span></a>
              </li>
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/sitemap" class="px-2{if $view == "sitemap"} menu-active{/if}"><span class="icon-[tabler--sitemap] size-4.5 shrink-0"></span><span class="grow">{__("Sitemap")}</span></a>
              </li>
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/tools/backups" class="px-2{if $view == "tools" && $sub_view == "backups"} menu-active{/if}"><span class="icon-[tabler--database-export] size-4.5 shrink-0"></span><span class="grow">{__("Backup Database & Files")}</span></a>
              </li>
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/tools/cronjob" class="px-2{if $view == "tools" && $sub_view == "cronjob"} menu-active{/if}"><span class="icon-[tabler--clock] size-4.5 shrink-0"></span><span class="grow">{__("Cronjob")}</span></a>
              </li>
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/tools/reset" class="px-2{if $view == "tools" && $sub_view == "reset"} menu-active{/if}"><span class="icon-[tabler--refresh] size-4.5 shrink-0"></span><span class="grow">{__("Factory Reset")}</span></a>
              </li>
              {/if}
              <!-- Tools -->
              <!-- Customization -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_customization_permission'])}
              <li class="admin-nav-heading js_admin-nav-heading">{__("Customization")}</li>
              <!-- Custom Fields -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/custom_fields" class="px-2{if $view == "custom_fields"} menu-active{/if}"><span class="icon-[tabler--menu-2] size-4.5 shrink-0"></span><span class="grow">{__("Custom Fields")}</span></a>
              </li>
              <!-- Custom Fields -->
              <!-- Static Pages -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/static" class="px-2{if $view == "static"} menu-active{/if}"><span class="icon-[tabler--file] size-4.5 shrink-0"></span><span class="grow">{__("Static Pages")}</span></a>
              </li>
              <!-- Static Pages -->
              <!-- Colored Posts -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/colored_posts" class="px-2{if $view == "colored_posts"} menu-active{/if}"><span class="icon-[tabler--palette] size-4.5 shrink-0"></span><span class="grow">{__("Colored Posts")}</span></a>
              </li>
              <!-- Colored Posts -->
              <!-- Widgets -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/widgets" class="px-2{if $view == "widgets"} menu-active{/if}"><span class="icon-[tabler--puzzle] size-4.5 shrink-0"></span><span class="grow">{__("Widgets")}</span></a>
              </li>
              <!-- Widgets -->
              <!-- Reactions -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/reactions" class="px-2{if $view == "reactions"} menu-active{/if}"><span class="icon-[tabler--mood-smile] size-4.5 shrink-0"></span><span class="grow">{__("Reactions")}</span></a>
              </li>
              <!-- Reactions -->
              <!-- Stickers -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/stickers" class="px-2{if $view == "stickers"} menu-active{/if}"><span class="icon-[tabler--hand-love-you] size-4.5 shrink-0"></span><span class="grow">{__("Stickers")}</span></a>
              </li>
              <!-- Stickers -->
              <!-- Gifts -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/gifts" class="px-2{if $view == "gifts"} menu-active{/if}"><span class="icon-[tabler--gift] size-4.5 shrink-0"></span><span class="grow">{__("Gifts")}</span></a>
              </li>
              <!-- Gifts -->
              {/if}
              <!-- Customization -->
              <!-- Reach -->
              {if $user->_is_admin || ($user->_is_moderator && $system['mods_reach_permission'])}
              <li class="admin-nav-heading js_admin-nav-heading">{__("Reach")}</li>
              <!-- Announcements -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/announcements" class="px-2{if $view == "announcements"} menu-active{/if}"><span class="icon-[tabler--speakerphone] size-4.5 shrink-0"></span><span class="grow">{__("Announcements")}</span></a>
              </li>
              <!-- Announcements -->
              <!-- Notifications -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/notifications" class="px-2{if $view == "notifications"} menu-active{/if}"><span class="icon-[tabler--bell] size-4.5 shrink-0"></span><span class="grow">{__("Mass Notifications")}</span></a>
              </li>
              <!-- Notifications -->
              <!-- Newsletter -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/newsletter" class="px-2{if $view == "newsletter"} menu-active{/if}"><span class="icon-[tabler--send] size-4.5 shrink-0"></span><span class="grow">{__("Newsletter")}</span></a>
              </li>
              <!-- Newsletter -->
              {/if}
              <!-- Reach -->
              <!-- Plugins -->
              {if $user->_is_admin}
              <li class="admin-nav-heading js_admin-nav-heading">{__("Plugins")}</li>
              <!-- Merits -->
              {if $user->_is_admin}
              <li class="accordion-item{if $view == "merits"} active{/if}" id="nav-merits">
                <button type="button" class="accordion-toggle accordion-item-active:bg-neutral/10 inline-flex w-full items-center gap-2 p-2 text-start text-sm font-normal" aria-controls="nav-merits-collapse" aria-expanded="{if $view == "merits"}true{else}false{/if}">
                  <span class="icon-[tabler--star] size-4.5 shrink-0"></span>
                  <span class="grow">{__("Merits")}</span>
                  <span class="icon-[tabler--chevron-right] accordion-item-active:rotate-90 size-4.5 shrink-0 transition-transform duration-300 rtl:rotate-180"></span>
                </button>
                <div id="nav-merits-collapse" class="accordion-content mt-1 w-full overflow-hidden transition-[height] duration-300{if $view == "merits"}{else} hidden{/if}" aria-labelledby="nav-merits" role="region">
                  <ul class="space-y-1 ps-4">
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/merits" class="px-2{if $view == "merits" && $sub_view == ""} menu-active{/if}"><span class="grow">{__("Merits Settings")}</span></a></li>
                    <li><a href="{$system['system_url']}/{$control_panel['url']}/merits/categories" class="px-2{if $view == "merits" && $sub_view == "categories"} menu-active{/if}"><span class="grow">{__("List Categories")}</span></a></li>
                  </ul>
                </div>
              </li>
              {/if}
              <!-- Merits -->
              {/if}
              <!-- Plugins -->
              <!-- Apps -->
              {if $user->_is_admin}
              <li class="admin-nav-heading js_admin-nav-heading">{__("Apps")}</li>
              <!-- PWA -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/pwa" class="px-2{if $view == "pwa"} menu-active{/if}"><span class="icon-[tabler--app-window] size-4.5 shrink-0"></span><span class="grow">{__("PWA")}</span></a>
              </li>
              <!-- PWA -->
              <!-- APIs Settings -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/apis" class="px-2{if $view == "apis"} menu-active{/if}"><span class="icon-[tabler--shape] size-4.5 shrink-0"></span><span class="grow">{__("APIs Settings")}</span></a>
              </li>
              <!-- APIs Settings -->
              <!-- Native Apps -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/apps" class="px-2{if $view == "apps"} menu-active{/if}"><span class="icon-[tabler--device-mobile] size-4.5 shrink-0"></span><span class="grow">{__("Native Apps")}</span></a>
              </li>
              <!-- Native Apps -->
              {/if}
              <!-- Apps -->
              <!-- System -->
              {if $user->_is_admin}
              <li class="admin-nav-heading js_admin-nav-heading">{__("Info")}</li>
              <!-- License -->
              <li>
                <a href="{$system['system_url']}/{$control_panel['url']}/license" class="px-2{if $view == "license"} menu-active{/if}"><span class="icon-[tabler--key] size-4.5 shrink-0"></span><span class="grow">{__("License")}</span></a>
              </li>
              <!-- License -->
              <!-- Changelog -->
              <li>
                <a href="https://zamblek.com/products/sngine/changelog" class="px-2" target="_blank" rel="noopener"><span class="icon-[tabler--stopwatch] size-4.5 shrink-0"></span><span class="grow">{__("Changelog")}</span><span class="icon-[tabler--arrow-up-right] size-4 shrink-0" aria-hidden="true"></span></a>
              </li>
              <!-- Changelog -->
              <!-- Build -->
              <!-- Build -->
              {/if}
              <!-- System -->            </ul>
          </div>

          {include file='_admin_sidebar.account.tpl'}

        </div>
      </div>
    </aside>
    <!-- sidebar -->

    <div class="admin-workspace flex min-w-0 grow flex-col">

      <!-- page content -->
      <main class="admin-main w-full min-w-0 flex-1 p-4 sm:p-6">
