<!-- section head -->
<div class="flex flex-wrap items-center justify-between gap-3 px-5 {if $_panel}min-h-18 py-3.5{else}border-b border-base-300 py-4{/if}">
  <!-- section title -->
  <h2 class="flex items-center gap-2 {if $_panel}text-sm{else}text-base{/if} font-semibold{if $_group == "connections"} max-sm:sr-only{/if}">
    {if !$_panel}
      <span class="flex size-9 shrink-0 items-center justify-center rounded-field bg-primary/10 text-primary">
        <span class="{$_icon} size-5" aria-hidden="true"></span>
      </span>
    {/if}
    {$_title}
  </h2>
  <!-- section title -->

  {if $_group == "connections"}
    <!-- section tabs dropdown -->
    <div class="dropdown relative z-20 flex w-full sm:hidden [--placement:bottom-start] [--strategy:absolute]">
      <button id="profile-connections-dropdown" type="button" class="dropdown-toggle flex h-11 w-full items-center gap-2 rounded-full {if $_panel}bg-base-content/5{else}bg-base-200{/if} px-4 text-sm font-medium text-base-content transition hover:bg-base-content/10" aria-haspopup="menu" aria-expanded="false">
        <span class="min-w-0 truncate text-start" title="{if $view == "friends"}{__("Friends")}{elseif $view == "followers"}{__("Followers")}{elseif $view == "followings"}{__("Followings")}{elseif $view == "subscribers"}{__("Subscribers")}{else}{__("Subscriptions")}{/if}">{if $view == "friends"}{__("Friends")}{elseif $view == "followers"}{__("Followers")}{elseif $view == "followings"}{__("Followings")}{elseif $view == "subscribers"}{__("Subscribers")}{else}{__("Subscriptions")}{/if}</span>
        <span class="badge badge-soft badge-primary badge-sm rounded-full">{if $view == "friends"}{$profile['friends_count']|default:0}{elseif $view == "followers"}{$profile['followers_count']|default:0}{elseif $view == "followings"}{$profile['followings_count']|default:0}{elseif $view == "subscribers"}{$profile['subscribers_count']|default:0}{else}{$profile['subscriptions_count']|default:0}{/if}</span>
        <span class="icon-[tabler--chevron-down] ms-auto size-4 shrink-0 opacity-60" aria-hidden="true"></span>
      </button>
      <div class="dropdown-menu dropdown-open:opacity-100 hidden w-full p-1" role="menu" aria-labelledby="profile-connections-dropdown">
        {if $system['friends_enabled']}
          <a class="dropdown-item{if $view == "friends"} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$system['system_url']}/{$profile['user_name']}/friends" {if $view == "friends"}aria-current="page"{/if}>{__("Friends")}</a>
        {/if}
        <a class="dropdown-item{if $view == "followers"} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$system['system_url']}/{$profile['user_name']}/followers" {if $view == "followers"}aria-current="page"{/if}>{__("Followers")}</a>
        <a class="dropdown-item{if $view == "followings"} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$system['system_url']}/{$profile['user_name']}/followings" {if $view == "followings"}aria-current="page"{/if}>{__("Followings")}</a>
        {if $profile['has_subscriptions_plans']}
          <a class="dropdown-item{if $view == "subscribers"} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$system['system_url']}/{$profile['user_name']}/subscribers" {if $view == "subscribers"}aria-current="page"{/if}>{__("Subscribers")}</a>
        {/if}
        {if $system['monetization_enabled']}
          <a class="dropdown-item{if $view == "subscriptions"} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$system['system_url']}/{$profile['user_name']}/subscriptions" {if $view == "subscriptions"}aria-current="page"{/if}>{__("Subscriptions")}</a>
        {/if}
      </div>
    </div>
    <!-- section tabs dropdown -->
  {/if}

  {if $_group && !($_group == "videos" && (!$system['videos_enabled'] || !$system['reels_enabled']))}
    <!-- section tabs -->
    <ul class="m-0 {if $_group == "connections"}max-sm:hidden {/if}flex max-w-full list-none items-center gap-1 overflow-x-auto rounded-full {if $_panel}bg-base-content/5{else}bg-base-200{/if} p-1 [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
      {if $_group == "connections"}
        {if $system['friends_enabled']}
          <li class="shrink-0">
            <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "friends"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/{$profile['user_name']}/friends" {if $view == "friends"}aria-current="page"{/if}>
              {__("Friends")}
              {if $view == "friends"}<span class="badge badge-soft badge-primary badge-sm rounded-full">{$profile['friends_count']|default:0}</span>{/if}
            </a>
          </li>
        {/if}
        <li class="shrink-0">
          <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "followers"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/{$profile['user_name']}/followers" {if $view == "followers"}aria-current="page"{/if}>
            {__("Followers")}
            {if $view == "followers"}<span class="badge badge-soft badge-primary badge-sm rounded-full">{$profile['followers_count']|default:0}</span>{/if}
          </a>
        </li>
        <li class="shrink-0">
          <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "followings"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/{$profile['user_name']}/followings" {if $view == "followings"}aria-current="page"{/if}>
            {__("Followings")}
            {if $view == "followings"}<span class="badge badge-soft badge-primary badge-sm rounded-full">{$profile['followings_count']|default:0}</span>{/if}
          </a>
        </li>
        {if $profile['has_subscriptions_plans']}
          <li class="shrink-0">
            <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "subscribers"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/{$profile['user_name']}/subscribers" {if $view == "subscribers"}aria-current="page"{/if}>
              {__("Subscribers")}
              {if $view == "subscribers"}<span class="badge badge-soft badge-primary badge-sm rounded-full">{$profile['subscribers_count']|default:0}</span>{/if}
            </a>
          </li>
        {/if}
        {if $system['monetization_enabled']}
          <li class="shrink-0">
            <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "subscriptions"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/{$profile['user_name']}/subscriptions" {if $view == "subscriptions"}aria-current="page"{/if}>
              {__("Subscriptions")}
              {if $view == "subscriptions"}<span class="badge badge-soft badge-primary badge-sm rounded-full">{$profile['subscriptions_count']|default:0}</span>{/if}
            </a>
          </li>
        {/if}
      {elseif $_group == "photos"}
        <li class="shrink-0">
          <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "photos"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/{$profile['user_name']}/photos" {if $view == "photos"}aria-current="page"{/if}>{__("Photos")}</a>
        </li>
        <li class="shrink-0">
          <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "albums" || $view == "album"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/{$profile['user_name']}/albums" {if $view == "albums" || $view == "album"}aria-current="page"{/if}>{__("Albums")}</a>
        </li>
      {elseif $_group == "videos"}
        {if $system['videos_enabled']}
          <li class="shrink-0">
            <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "videos"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/{$profile['user_name']}/videos" {if $view == "videos"}aria-current="page"{/if}>{__("Videos")}</a>
          </li>
        {/if}
        {if $system['reels_enabled']}
          <li class="shrink-0">
            <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "reels"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/{$profile['user_name']}/reels" {if $view == "reels"}aria-current="page"{/if}>{__("Reels")}</a>
          </li>
        {/if}
      {/if}
    </ul>
    <!-- section tabs -->
  {/if}
</div>
<!-- section head -->
