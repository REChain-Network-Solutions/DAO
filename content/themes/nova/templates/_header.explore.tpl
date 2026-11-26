{$_explore_ads = ($user->_logged_in && ($system['ads_enabled'] || $system['wallet_enabled'] || $user->_data['can_boost_posts'] || $user->_data['can_boost_pages'] || $user->_data['can_boost_groups'] || $user->_data['can_boost_events']))}
<!-- explore -->
<div class="dropdown inline-flex max-lg:[--strategy:static] lg:relative [--offset:10] [--placement:bottom-end]">
  <span class="heroui inline-flex">
    <button type="button" class="dropdown-toggle site-topbar-icon button button--tertiary button--icon-only rounded-2xl! corner-squircle supports-[corner-shape:squircle]:rounded-[2rem]!" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Explore")}">
      <span class="icon-[tabler--layout-grid] size-5" aria-hidden="true"></span>
    </button>
  </span>
  <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-[calc(100dvh-5rem)] w-[min(46rem,calc(100vw-2rem))] overflow-y-auto p-4 max-lg:absolute max-lg:inset-x-0 max-lg:top-full max-lg:mt-0 max-lg:w-auto max-lg:rounded-t-none max-lg:border-x-0 max-lg:border-t-0 border border-base-content/15 shadow-lg shadow-black/10 dark:shadow-black/25" role="menu">
    <h2 class="px-3 pb-3 text-xl font-bold">{__("Explore")}</h2>
    <div class="grid gap-4 {if $_explore_ads}md:grid-cols-[minmax(0,1fr)_15rem]{/if}">

      <!-- explore links -->
      <ul class="flex flex-col gap-0.5">
        {if $user->_logged_in}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/saved" _module="bookmark" _icon="icon-[tabler--bookmark]" _color="bg-warning/15 text-warning" _label=__("Saved") _desc=__("Revisit posts you saved for later") _active=($page == "index" && $view == "saved")}
          {if $user->_data['can_schedule_posts']}
            {include file='__explore_link.tpl' _url="`$system['system_url']`/scheduled" _module="schedule" _icon="icon-[tabler--calendar-time]" _color="bg-warning/15 text-warning" _label=__("Scheduled") _desc=__("Manage posts scheduled for later") _active=($page == "index" && $view == "scheduled")}
          {/if}
          {if $system['memories_enabled']}
            {include file='__explore_link.tpl' _url="`$system['system_url']`/memories" _module="memories" _icon="icon-[tabler--history]" _color="bg-info/10 text-info" _label=__("Memories") _desc=__("Look back at posts from this day") _active=($page == "index" && $view == "memories")}
          {/if}
          {if $system['stories_enabled'] && $system['stories_archive_enabled']}
            {include file='__explore_link.tpl' _url="`$system['system_url']`/stories/archive" _module="stories" _icon="icon-[tabler--history-toggle]" _color="bg-primary/10 text-primary" _label=__("Stories Archive") _desc=__("Your past stories, only you can see them") _active=($page == "index" && $view == "stories_archive")}
          {/if}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/people" _module="people" _icon="icon-[tabler--users]" _color="bg-primary/10 text-primary" _label=__("People") _desc=__("Discover members and make new connections") _active=($page == "people")}
        {/if}
        {if $user->_data['can_use_dating']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/dating" _module="dating" _icon="icon-[tabler--heart]" _color="bg-error/10 text-error" _label=__("Dating") _desc=__("Meet new people and find your match") _active=($page == "dating")}
        {/if}
        {if $system['pages_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/pages" _module="pages" _icon="icon-[tabler--flag]" _color="bg-info/10 text-info" _label=__("Pages") _desc=__("Follow brands, creators and communities") _active=($page == "pages")}
        {/if}
        {if $system['groups_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/groups" _module="groups" _icon="icon-[tabler--users-group]" _color="bg-success/10 text-success" _label=__("Groups") _desc=__("Join groups that share your interests") _active=($page == "groups")}
        {/if}
        {if $system['events_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/events" _module="events" _icon="icon-[tabler--calendar-event]" _color="bg-accent/10 text-accent" _label=__("Events") _desc=__("Find events and see who is going") _active=($page == "events")}
        {/if}
        {if $system['reels_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/reels" _module="reels" _icon="icon-[tabler--movie]" _color="bg-error/10 text-error" _label=__("Reels") _desc=__("Watch short videos from the community") _active=($page == "reels")}
        {/if}
        {if $user->_logged_in && $system['watch_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/watch" _module="watch" _icon="icon-[tabler--player-play]" _color="bg-error/10 text-error" _label=__("Watch") _desc=__("Watch videos from people and pages") _active=($page == "watch")}
        {/if}
        {if $system['live_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/live" _module="live" _icon="icon-[tabler--broadcast]" _color="bg-error/10 text-error" _label=__("Live") _desc=__("Watch live streams from creators") _active=($page == "live")}
        {/if}
        {if $system['blogs_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/blogs" _module="blogs" _icon="icon-[tabler--article]" _color="bg-info/10 text-info" _label=__("Blogs") _desc=__("Read and share articles and insights") _active=($page == "blogs")}
        {/if}
        {if $system['market_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/market" _module="marketplace" _icon="icon-[tabler--building-store]" _color="bg-success/10 text-success" _label=__("Marketplace") _desc=__("Buy and sell products in the marketplace") _active=($page == "market")}
        {/if}
        {if $system['funding_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/funding" _module="funding" _icon="icon-[tabler--coin]" _color="bg-warning/15 text-warning" _label=__("Funding") _desc=__("Support campaigns and raise funds") _active=($page == "funding")}
        {/if}
        {if $system['offers_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/offers" _module="offers" _icon="icon-[tabler--discount]" _color="bg-accent/10 text-accent" _label=__("Offers") _desc=__("Browse the latest deals and offers") _active=($page == "offers")}
        {/if}
        {if $system['jobs_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/jobs" _module="jobs" _icon="icon-[tabler--briefcase]" _color="bg-primary/10 text-primary" _label=__("Jobs") _desc=__("Find jobs and hire talent") _active=($page == "jobs")}
        {/if}
        {if $system['courses_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/courses" _module="courses" _icon="icon-[tabler--school]" _color="bg-info/10 text-info" _label=__("Courses") _desc=__("Learn new skills from courses") _active=($page == "courses")}
        {/if}
        {if $system['forums_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/forums" _module="forums" _icon="icon-[tabler--messages]" _color="bg-success/10 text-success" _label=__("Forums") _desc=__("Join discussions and ask questions") _active=($page == "forums")}
        {/if}
        {if $system['movies_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/movies" _module="movies" _icon="icon-[tabler--device-tv]" _color="bg-error/10 text-error" _label=__("Movies") _desc=__("Watch movies and series") _active=($page == "movies")}
        {/if}
        {if $system['games_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/games" _module="games" _icon="icon-[tabler--device-gamepad-2]" _color="bg-accent/10 text-accent" _label=__("Games") _desc=__("Play games with friends") _active=($page == "games")}
        {/if}
        {if $system['merits_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/merits" _module="merits" _icon="icon-[tabler--award]" _color="bg-warning/15 text-warning" _label=__("Merits") _desc=__("Recognize members who make a difference") _active=($page == "merits")}
        {/if}
        {if $system['developers_apps_enabled'] || $system['developers_share_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/developers{if !$system['developers_apps_enabled']}/share{/if}" _module="developers" _icon="icon-[tabler--code]" _color="bg-primary/10 text-primary" _label=__("Developers") _desc=__("Build apps with our developer tools") _active=($page == "developers")}
        {/if}
        {if $system['directory_enabled']}
          {include file='__explore_link.tpl' _url="`$system['system_url']`/directory" _module="directory" _icon="icon-[tabler--list-details]" _color="bg-primary/10 text-primary" _label=__("Directory") _desc=__("Browse users, posts, pages and groups") _active=($page == "directory")}
        {/if}
        {if $static_pages}
          {foreach $static_pages as $static_page}
            {if $static_page['page_in_sidebar']}
              {include file='__explore_link.tpl' _url=$static_page['url'] _image=$static_page['page_icon'] _icon="icon-[tabler--file-text]" _color="bg-base-200 text-base-content/70" _label=__($static_page['page_title']) _active=($page == "static_page" && $static_page['page_id'] == $static_page_id)}
            {/if}
          {/foreach}
        {/if}
      </ul>
      <!-- explore links -->

      {if $_explore_ads}
        <div class="flex flex-col gap-4 md:border-s md:border-base-300 md:ps-4">
          <!-- advertising -->
          <ul class="flex flex-col gap-0.5">
            <li class="px-3 pb-1 text-[11px] font-medium uppercase tracking-wider text-base-content/40">{__("Advertising")}</li>
            {if $system['wallet_enabled']}
              {include file='__explore_side_link.tpl' _url="`$system['system_url']`/wallet" _module="wallet" _icon="icon-[tabler--wallet]" _label=__("Wallet") _active=($page == "wallet")}
            {/if}
            {if $system['ads_enabled']}
              {include file='__explore_side_link.tpl' _url="`$system['system_url']`/ads" _module="ads" _icon="icon-[tabler--speakerphone]" _label=__("Ads Manager") _active=($page == "ads")}
            {/if}
            {if $user->_data['can_boost_posts'] || $user->_data['can_boost_pages'] || $user->_data['can_boost_groups'] || $user->_data['can_boost_events']}
              {include file='__explore_side_link.tpl' _url="`$system['system_url']`/boosted/posts" _module="boosted" _icon="icon-[tabler--rocket]" _label=__("Boosted") _active=($page == "index" && ($view == "boosted_posts" || $view == "boosted_pages" || $view == "boosted_groups" || $view == "boosted_events"))}
            {/if}
          </ul>
          <!-- advertising -->
        </div>
      {/if}

    </div>
  </div>
</div>
<!-- explore -->
