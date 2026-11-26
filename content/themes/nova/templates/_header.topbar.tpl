<!-- header -->
<header class="site-topbar sticky top-0 z-40 flex border-b border-base-300 bg-base-100">
  <div class="mx-auto flex h-16 w-full min-w-0 flex-1 items-center gap-3 px-4 sm:px-6 lg:gap-6{if !$system['fluid_design']} max-w-7xl{/if}">

    <!-- logo -->
    <a href="{$system['system_url']}" class="flex min-w-0 shrink-0 items-center gap-3 text-base-content! lg:w-64" aria-label="{__($system['system_title'])}">
      {if $system['system_logo']}
        <img class="max-h-9 max-w-36 object-contain {if $system['system_logo_dark']}dark:hidden{/if}" src="{$system['system_uploads']}/{$system['system_logo']}" alt="{__($system['system_title'])}">
        {if $system['system_logo_dark']}
          <img class="hidden max-h-9 max-w-36 object-contain dark:block" src="{$system['system_uploads']}/{$system['system_logo_dark']}" alt="{__($system['system_title'])}">
        {/if}
      {else}
        <img class="size-9 shrink-0 rounded-field object-contain" src="{if $system['system_favicon_default'] || !$system['system_favicon']}{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png{else}{$system['system_uploads']}/{$system['system_favicon']}{/if}" alt="">
        <span class="hidden truncate text-xl font-bold tracking-tight sm:block" title="{__($system['system_title'])}">{__($system['system_title'])}</span>
      {/if}
    </a>
    <!-- logo -->

    <div class="flex min-w-0 grow justify-center lg:justify-start">
      {if $_site_search}
        <!-- search -->
        <button type="button" id="site-palette-trigger" class="site-topbar-search hidden h-11 w-full max-w-xl cursor-pointer lg:max-w-none items-center gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] border border-transparent bg-base-200 ps-4 pe-2 text-start text-base-content/60 transition-colors hover:border-base-300 md:flex" aria-haspopup="dialog" aria-expanded="false" aria-controls="site-palette" data-overlay="#site-palette">
          <span class="icon-[tabler--search] size-5 shrink-0" aria-hidden="true"></span>
          <span class="grow truncate text-sm" title="{__("Search everything...")}">{__("Search everything...")}</span>
          <kbd class="kbd kbd-sm hidden shrink-0 border-base-300 bg-base-100 font-sans text-base-content/60 lg:inline-flex">⌘K</kbd>
        </button>
        <!-- search -->
      {/if}
    </div>

    <div class="site-topbar-chrome js_site-topbar-chrome flex shrink-0 items-center gap-1 sm:gap-2 xl:w-80 xl:justify-end">
      {if $_site_search}
        <!-- search -->
        <span class="heroui inline-flex md:hidden">
          <button type="button" class="site-topbar-icon button button--tertiary button--icon-only rounded-2xl! corner-squircle supports-[corner-shape:squircle]:rounded-[2rem]!" aria-haspopup="dialog" aria-expanded="false" aria-controls="site-palette" data-overlay="#site-palette" aria-label="{__("Search")}">
            <span class="icon-[tabler--search] size-5" aria-hidden="true"></span>
          </button>
        </span>
        <!-- search -->
      {/if}
      {if $user->_logged_in}
        {include file='_header.explore.tpl'}
        <!-- create -->
        <div class="dropdown relative hidden md:inline-flex [--offset:10] [--placement:bottom-end]">
          <span class="heroui inline-flex">
            <button type="button" class="dropdown-toggle site-topbar-icon button button--tertiary button--icon-only relative rounded-2xl! corner-squircle supports-[corner-shape:squircle]:rounded-[2rem]!" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Create")}">
              <span class="icon-[tabler--plus] size-5" aria-hidden="true"></span>
            </button>
          </span>
          <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-[calc(100dvh-5rem)] w-[min(22rem,calc(100vw-1.5rem))] overflow-y-auto p-3 border border-base-content/15 shadow-lg shadow-black/10 dark:shadow-black/25" role="menu">
            <h2 class="px-3 pt-1 pb-3 text-xl font-bold">{__("Create")}</h2>
            <ul class="flex flex-col gap-0.5">
              {include file='__create_link.tpl' _modal="posts/publisher.php" _size="publisher" _static=true _module="posts" _icon="icon-[tabler--pencil]" _color="bg-primary/10 text-primary" _label=__("Post") _desc=__("Share what's on your mind")}
              {if $system['stories_enabled']}
                {include file='__create_link.tpl' _class="js_story-create" _module="stories" _icon="icon-[tabler--clock]" _color="bg-accent/10 text-accent" _label=__("Story") _desc=__("Share a moment for 24 hours")}
              {/if}
              {if $system['live_enabled']}
                {include file='__create_link.tpl' _url="`$system['system_url']`/live/create" _module="live" _icon="icon-[tabler--broadcast]" _color="bg-error/10 text-error" _label=__("Live") _desc=__("Go live with your followers")}
              {/if}
              {if $system['blogs_enabled']}
                {include file='__create_link.tpl' _url="`$system['system_url']`/blogs/new" _module="blogs" _icon="icon-[tabler--article]" _color="bg-info/10 text-info" _label=__("Blog") _desc=__("Write and publish an article") _paid=$system['paid_blogs_enabled']}
              {/if}
              {if $system['market_enabled']}
                {include file='__create_link.tpl' _modal="posts/product.php?do=create" _module="marketplace" _icon="icon-[tabler--building-store]" _color="bg-success/10 text-success" _label=__("Product") _desc=__("Sell something in the marketplace") _paid=$system['paid_products_enabled']}
              {/if}
              {if $system['funding_enabled']}
                {include file='__create_link.tpl' _modal="posts/funding.php?do=create" _module="funding" _icon="icon-[tabler--coin]" _color="bg-warning/15 text-warning" _label=__("Funding") _desc=__("Raise money for a cause") _paid=$system['paid_funding_enabled']}
              {/if}
            </ul>
            {if $system['pages_enabled'] || $system['groups_enabled'] || $system['events_enabled']}
              <ul class="mt-2 flex flex-col gap-0.5 border-t border-base-300 pt-2">
                <li class="px-3 pt-1 pb-1 text-[11px] font-medium uppercase tracking-wider text-base-content/40">{__("Community")}</li>
                {if $system['pages_enabled']}
                  {include file='__create_link.tpl' _modal="modules/add.php?type=page" _module="pages" _icon="icon-[tabler--flag]" _color="bg-info/10 text-info" _label=__("Page") _desc=__("Build a home for your brand or cause")}
                {/if}
                {if $system['groups_enabled']}
                  {include file='__create_link.tpl' _modal="modules/add.php?type=group" _module="groups" _icon="icon-[tabler--users-group]" _color="bg-success/10 text-success" _label=__("Group") _desc=__("Bring people together around a topic")}
                {/if}
                {if $system['events_enabled']}
                  {include file='__create_link.tpl' _modal="modules/add.php?type=event" _module="events" _icon="icon-[tabler--calendar-event]" _color="bg-accent/10 text-accent" _label=__("Event") _desc=__("Plan a gathering and invite people")}
                {/if}
              </ul>
            {/if}
            {if $system['ads_enabled']}
              <ul class="mt-2 flex flex-col gap-0.5 border-t border-base-300 pt-2">
                <li class="px-3 pt-1 pb-1 text-[11px] font-medium uppercase tracking-wider text-base-content/40">{__("Advertising")}</li>
                {include file='__create_link.tpl' _url="`$system['system_url']`/ads/new" _module="ads" _icon="icon-[tabler--speakerphone]" _color="bg-error/10 text-error" _label=__("Ad") _desc=__("Promote your content to more people")}
              </ul>
            {/if}
          </div>
        </div>
        <!-- create -->

        {if $system['friends_enabled']}
          {include file='_header.friend_requests.tpl'}
        {/if}

        {if $system['chat_enabled'] && $user->_data['user_privacy_chat'] != "me"}
          {include file='_header.messages.tpl'}
        {/if}

        {include file='_header.notifications.tpl'}

        <!-- user menu -->
        <div class="dropdown relative hidden md:inline-flex [--offset:10] [--placement:bottom-end]">
          {include file='_user_menu.tpl' _topbar=true}
        </div>
        <!-- user menu -->
      {else}
        <!-- join -->
        <span class="heroui inline-flex items-center gap-2">
          <a class="button button--tertiary text-base-content! rounded-2xl! corner-squircle supports-[corner-shape:squircle]:rounded-[2rem]! {if $system['registration_enabled']}hidden! sm:inline-flex!{/if}" href="{$system['system_url']}/signin">{__("Sign In")}</a>
          {if $system['registration_enabled']}
            <a class="button button--primary text-(--button-fg)! rounded-2xl! corner-squircle supports-[corner-shape:squircle]:rounded-[2rem]!" href="{$system['system_url']}/signup">{__("Sign Up")}</a>
          {/if}
        </span>
        <!-- join -->
      {/if}
    </div>

  </div>
  {if $user->_logged_in && $system['chat_enabled'] && $user->_data['user_privacy_chat'] != "me"}
    <div class="hidden w-[4.7rem] shrink-0 min-[1200px]:block" aria-hidden="true"></div>
  {/if}
</header>
<!-- header -->
