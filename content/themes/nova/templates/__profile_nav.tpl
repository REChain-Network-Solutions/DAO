<!-- profile-menu -->
{capture name="profile_navigation"}
    {include file='__profile_tab.tpl' _url="`$system['system_url']`/`$profile['user_name']`" _icon="icon-[tabler--home]" _label=__("All") _active=($view == "")}
    {include file='__profile_tab.tpl' _url="`$system['system_url']`/`$profile['user_name']`/about" _icon="icon-[tabler--user-circle]" _label=__("About") _active=($view == "about")}
    {if $system['friends_enabled']}
      {include file='__profile_tab.tpl' _url="`$system['system_url']`/`$profile['user_name']`/friends" _icon="icon-[tabler--users]" _label=__("Friends") _active=(in_array($view, ["friends", "followers", "followings", "subscribers", "subscriptions"]))}
    {else}
      {include file='__profile_tab.tpl' _url="`$system['system_url']`/`$profile['user_name']`/followers" _icon="icon-[tabler--users]" _label=__("Followers") _active=(in_array($view, ["friends", "followers", "followings", "subscribers", "subscriptions"]))}
    {/if}
    {include file='__profile_tab.tpl' _url="`$system['system_url']`/`$profile['user_name']`/photos" _icon="icon-[tabler--photo]" _label=__("Photos") _active=in_array($view, ["photos", "albums", "album"])}
    {if $system['videos_enabled']}
      {include file='__profile_tab.tpl' _url="`$system['system_url']`/`$profile['user_name']`/videos" _icon="icon-[tabler--player-play]" _label=__("Videos") _active=($view == "videos")}
    {/if}
    {if $system['reels_enabled']}
      {include file='__profile_tab.tpl' _url="`$system['system_url']`/`$profile['user_name']`/reels" _icon="icon-[tabler--movie]" _label=__("Reels") _active=($view == "reels")}
    {/if}
    {include file='__profile_tab.tpl' _modal_url="users/search.php?id=`$profile['user_id']`" _icon="icon-[tabler--search]" _label=__("Search") _active=($view == "search")}
{/capture}
{capture name="profile_more_navigation"}
    {if $profile['can_write_blogs']}
      {include file='__profile_tab.tpl' _url="`$system['system_url']`/`$profile['user_name']`/blogs" _icon="icon-[tabler--article]" _label=__("Blogs") _active=($view == "blogs")}
    {/if}
    {if $profile['can_sell_products']}
      {include file='__profile_tab.tpl' _url="`$system['system_url']`/`$profile['user_name']`/listings" _icon="icon-[tabler--building-store]" _label=__("Listings") _active=($view == "listings")}
    {/if}
    {if $system['pages_enabled']}
      {include file='__profile_tab.tpl' _url="`$system['system_url']`/`$profile['user_name']`/pages" _icon="icon-[tabler--flag]" _label=__("Pages") _active=($view == "pages")}
    {/if}
    {if $system['groups_enabled']}
      {include file='__profile_tab.tpl' _url="`$system['system_url']`/`$profile['user_name']`/groups" _icon="icon-[tabler--users-group]" _label=__("Groups") _active=($view == "groups")}
    {/if}
    {if $system['events_enabled']}
      {include file='__profile_tab.tpl' _url="`$system['system_url']`/`$profile['user_name']`/events" _icon="icon-[tabler--calendar-event]" _label=__("Events") _active=($view == "events")}
    {/if}
{/capture}
{$_profile_more_active = in_array($view, ["blogs", "listings", "pages", "groups", "events"])}
<nav class="flex min-w-0 items-center gap-2 rounded-3xl bg-base-100 p-2 sm:gap-3 sm:p-3" aria-label='{__("Profile")}'>
  <div class="relative min-w-0 flex-1">
    <div class="overflow-x-auto overscroll-x-contain scroll-smooth snap-x snap-proximity scroll-px-1 motion-reduce:scroll-auto [scrollbar-width:none]! [&::-webkit-scrollbar]:hidden!">
      <ul class="m-0 flex w-max min-w-full list-none items-center gap-1.5 py-1 ps-1 pe-6">
        {$smarty.capture.profile_navigation nofilter}
      </ul>
    </div>
    <div class="pointer-events-none absolute inset-y-0 end-0 w-6 bg-linear-to-l from-base-100 to-transparent rtl:bg-linear-to-r" aria-hidden="true"></div>
  </div>
  {if $smarty.capture.profile_more_navigation|trim}
    <div class="shrink-0 border-s border-base-300 ps-2 sm:ps-3">
      <div class="dropdown relative inline-flex {if $system['language']['dir'] == 'RTL'}[--placement:bottom-start]{else}[--placement:bottom-end]{/if}">
        <button id="profile-navigation-menu" type="button" class="dropdown-toggle heroui button button--tertiary h-12 gap-2 rounded-[1rem] border-0 px-3 shadow-none sm:px-4{if $_profile_more_active} bg-primary/10 text-primary hover:bg-primary/15{/if}" aria-haspopup="true" aria-expanded="false" aria-controls="profile-navigation-sections" aria-label='{__("More")}'>
          <span class="icon-[tabler--layout-grid] size-5 shrink-0" aria-hidden="true"></span>
          <span class="hidden sm:inline">{__("More")}</span>
          <span class="icon-[tabler--chevron-down] size-4 shrink-0 transition-transform dropdown-open:rotate-180" aria-hidden="true"></span>
        </button>
        <div id="profile-navigation-sections" class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-72 max-w-[calc(100vw-2rem)] rounded-3xl border border-base-300 p-2 shadow-lg" aria-labelledby="profile-navigation-menu">
          <ul class="m-0 grid max-h-80 list-none gap-1 overflow-y-auto p-1 [&>li>a]:flex [&>li>a]:w-full [&>li>a]:justify-start [&>li>a]:whitespace-normal [&>li>a]:text-start">
            {$smarty.capture.profile_more_navigation nofilter}
          </ul>
        </div>
      </div>
    </div>
  {/if}
</nav>
<!-- profile-menu -->
