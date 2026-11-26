{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- newsfeed -->
<div class="flex flex-col gap-6 lg:flex-row lg:items-start">

  <!-- left panel -->
  <aside id="site-sidebar" class="overlay hidden w-64 shrink-0 transition-[width] duration-300 lg:sticky lg:top-22 lg:block lg:h-[calc(100dvh-6.5rem)] lg:overflow-y-auto lg:[scrollbar-gutter:stable] overlay-minified:w-15 [scrollbar-color:transparent_transparent]! hover:[scrollbar-color:var(--scrollbar-thumb)_transparent]! [&::-webkit-scrollbar-thumb]:bg-transparent! hover:[&::-webkit-scrollbar-thumb]:bg-(--scrollbar-thumb)!">
    {include file='_sidebar.tpl'}
  </aside>
  <!-- left panel -->

  <!-- content panel -->
  <div class="flex min-w-0 flex-1 flex-col gap-5">

    {$_story_backgrounds = ['aurora' => 'bg-linear-to-br from-indigo-500 via-purple-500 to-pink-500', 'sunset' => 'bg-linear-to-br from-orange-400 via-rose-500 to-fuchsia-600', 'ocean' => 'bg-linear-to-br from-cyan-400 via-sky-500 to-indigo-600', 'forest' => 'bg-linear-to-br from-emerald-400 via-teal-500 to-cyan-700', 'candy' => 'bg-linear-to-br from-pink-400 via-rose-400 to-amber-300', 'grape' => 'bg-linear-to-br from-fuchsia-600 via-purple-700 to-indigo-900', 'peach' => 'bg-linear-to-br from-amber-300 via-orange-400 to-rose-500', 'midnight' => 'bg-linear-to-br from-slate-700 via-slate-900 to-black']}

    {if $view == "memories"}
      <!-- page header -->
      {include file='__page_header.tpl' _title=__("Memories") _text=__("Enjoy looking back on your memories") _image="memories.svg"}
      <!-- page header -->
    {elseif $view == "stories_archive"}
      <!-- page header -->
      {include file='__page_header.tpl' _title=__("Stories Archive") _text=__("Your past stories, only you can see them") _image="stories.svg"}
      <!-- page header -->

      <!-- stories archive -->
      {if $archive['stories']}
        <div class="grid grid-cols-3 gap-2 sm:gap-4">
          {foreach $archive['stories'] as $_story}
            <button type="button" class="js_story-open group/card relative block aspect-[9/14] w-full overflow-hidden rounded-2xl text-start transition active:scale-[0.98] {if $_story['preview']}bg-base-300{elseif $_story_backgrounds[$_story['background']]}{$_story_backgrounds[$_story['background']]}{else}bg-linear-to-br from-primary to-accent{/if}" data-archive-id="{$_story['story_id']}" aria-label='{__("View story")}'>
              {if $_story['preview']}
                <img class="absolute inset-0 size-full object-cover transition duration-300 group-hover/card:scale-105" src="{$_story['preview']}" alt="" loading="lazy">
              {elseif $_story['type'] == "video"}
                <span class="absolute inset-0 flex items-center justify-center text-white"><span class="icon-[tabler--video] size-7" aria-hidden="true"></span></span>
              {elseif $_story['thumb_layers']}
                <span class="js_story-thumb pointer-events-none absolute inset-x-0 top-1/2 block aspect-[9/16] -translate-y-1/2 @container [&_*]:pointer-events-none!" data-layers="{$_story['thumb_layers']|escape:'html'}" data-fonts="{$system['system_theme_fonts']}" aria-hidden="true">
                  {if $_story['thumb_drawing']}<img class="absolute inset-0 size-full" src="{$_story['thumb_drawing']}" alt="" loading="lazy">{/if}
                </span>
              {else}
                <span class="absolute inset-0 flex items-center justify-center text-white"><span class="icon-[tabler--typography] size-7" aria-hidden="true"></span></span>
              {/if}
              <span class="absolute inset-0 bg-linear-to-b from-black/30 via-transparent to-black/65" aria-hidden="true"></span>
              {if $_story['highlighted']}
                <span class="absolute end-2 top-2 flex size-7 items-center justify-center rounded-full bg-black/50 text-white backdrop-blur-md" title='{__("Highlight")}'>
                  <span class="icon-[tabler--star-filled] size-4" aria-hidden="true"></span>
                </span>
              {/if}
              <span class="absolute inset-x-2 bottom-2 flex flex-col gap-0.5 text-white">
                <span class="js_moment truncate text-xs font-semibold" data-time="{$_story['time']}">{$_story['time']}</span>
                <span class="flex items-center gap-1 text-[11px] text-white/80"><span class="icon-[tabler--eye] size-3.5 shrink-0" aria-hidden="true"></span>{$_story['views_count']}</span>
              </span>
            </button>
          {/foreach}
        </div>
        {if $archive['more']}
          <div class="flex justify-center">
            <a class="heroui button button--tertiary text-base-content rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/stories/archive?before={$archive['before']}">{__("See More")}</a>
          </div>
        {/if}
      {else}
        <div class="rounded-box bg-base-100 p-4">
          {include file='_no_data.tpl' _empty_icon="icon-[tabler--history-toggle]" _empty_title=__("No archived stories yet") _empty_text=__("Your stories will show up here after they disappear from your profile")}
        </div>
      {/if}
      <!-- stories archive -->
    {elseif in_array($view, ['boosted_posts', 'boosted_pages', 'boosted_groups', 'boosted_events'])}
      <!-- page header -->
      {include file='__page_header.tpl' _title=__("Boosted") _text=__("All the content you boosted in one place") _image="boosted.svg"}
      <!-- page header -->

      <!-- boosted filter -->
      <div class="flex items-center gap-3">
        <div class="dropdown relative inline-flex min-w-0 [--offset:8] [--placement:bottom-start]">
          <button type="button" class="dropdown-toggle inline-flex h-9 min-w-0 items-center gap-2 rounded-field bg-base-100 px-3 text-sm font-semibold transition-colors hover:bg-base-300" aria-haspopup="menu" aria-expanded="false">
            <span class="truncate" title="{if $view == "boosted_pages"}{__("Boosted Pages")}{elseif $view == "boosted_groups"}{__("Boosted Groups")}{elseif $view == "boosted_events"}{__("Boosted Events")}{else}{__("Boosted Posts")}{/if}">{if $view == "boosted_pages"}{__("Boosted Pages")}{elseif $view == "boosted_groups"}{__("Boosted Groups")}{elseif $view == "boosted_events"}{__("Boosted Events")}{else}{__("Boosted Posts")}{/if}</span>
            <span class="icon-[tabler--chevron-down] size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
          </button>
          <div class="dropdown-menu dropdown-open:opacity-100 hidden min-w-60" role="menu">
            {include file='__nav_filter_item.tpl' _view="boosted_posts" _url="`$system['system_url']`/boosted/posts" _module="boosted" _icon="icon-[tabler--rocket]" _label=__("Boosted Posts")}
            {if $system['pages_enabled']}
              {include file='__nav_filter_item.tpl' _view="boosted_pages" _url="`$system['system_url']`/boosted/pages" _module="pages" _icon="icon-[tabler--flag]" _label=__("Boosted Pages")}
            {/if}
            {if $system['groups_enabled']}
              {include file='__nav_filter_item.tpl' _view="boosted_groups" _url="`$system['system_url']`/boosted/groups" _module="groups" _icon="icon-[tabler--users-group]" _label=__("Boosted Groups")}
            {/if}
            {if $system['events_enabled']}
              {include file='__nav_filter_item.tpl' _view="boosted_events" _url="`$system['system_url']`/boosted/events" _module="events" _icon="icon-[tabler--calendar-event]" _label=__("Boosted Events")}
            {/if}
          </div>
        </div>
      </div>
      <!-- boosted filter -->
    {elseif $view == "scheduled"}
      <!-- page header -->
      {include file='__page_header.tpl' _title=__("Scheduled Posts") _text=__("Posts waiting to be published") _image="scheduled.svg"}
      <!-- page header -->
    {elseif $view == "saved"}
      <!-- page header -->
      {include file='__page_header.tpl' _title=__("Saved Posts") _text=__("All the posts you saved in one place") _image="saved.svg"}
      <!-- page header -->
    {elseif !in_array($view, ['', 'popular', 'discover'])}
      <!-- page header -->
      <div class="min-w-0">
        <h1 class="text-3xl font-bold tracking-tight sm:text-4xl">
          {if $view == "saved"}{__("Saved Posts")}{elseif $view == "scheduled"}{__("Scheduled Posts")}{elseif $view == "memories"}{__("Memories")}{elseif $view == "boosted_posts"}{__("Boosted Posts")}{elseif $view == "boosted_pages"}{__("Boosted Pages")}{elseif $view == "boosted_groups"}{__("Boosted Groups")}{elseif $view == "boosted_events"}{__("Boosted Events")}{/if}
        </h1>
      </div>
      <!-- page header -->
    {/if}

    {capture assign="_feed_filters"}
      <div class="flex items-center gap-3">
        <!-- feed filter -->
        <div class="dropdown relative inline-flex min-w-0 [--offset:8] [--placement:bottom-start]">
          <button type="button" class="dropdown-toggle inline-flex h-8 min-w-0 items-center gap-1.5 rounded-field bg-base-100 px-2.5 text-xs font-semibold transition-colors hover:bg-base-300" aria-haspopup="menu" aria-expanded="false">
            <span class="truncate" title="{if $view == "popular"}{__("Popular")}{elseif $view == "discover"}{__("Discover")}{else}{__("Recent")}{/if}">{if $view == "popular"}{__("Popular")}{elseif $view == "discover"}{__("Discover")}{else}{__("Recent")}{/if}</span>
            <span class="icon-[tabler--chevron-down] size-3.5 shrink-0 text-base-content/50" aria-hidden="true"></span>
          </button>
          <div class="dropdown-menu dropdown-open:opacity-100 hidden min-w-44" role="menu">
            <a class="dropdown-item{if $view == ""} dropdown-active{else} text-inherit!{/if}" href="{$system['system_url']}">
              <span class="icon-[tabler--clock] size-5 shrink-0" aria-hidden="true"></span>
              {__("Recent")}
            </a>
            {if $system['popular_posts_enabled']}
              <a class="dropdown-item{if $view == "popular"} dropdown-active{else} text-inherit!{/if}" href="{$system['system_url']}/popular">
                <span class="icon-[tabler--flame] size-5 shrink-0" aria-hidden="true"></span>
                {__("Popular")}
              </a>
            {/if}
            {if $system['discover_posts_enabled']}
              <a class="dropdown-item{if $view == "discover"} dropdown-active{else} text-inherit!{/if}" href="{$system['system_url']}/discover">
                <span class="icon-[tabler--sparkles] size-5 shrink-0" aria-hidden="true"></span>
                {__("Discover")}
              </a>
            {/if}
          </div>
        </div>
        <!-- feed filter -->

        <div class="grow"></div>

        {if $system['newsfeed_location_filter_enabled'] && $view != "saved"}
          {include file='__countries_filter.tpl'}
        {/if}

        {if $user->_logged_in}
          {include file='__posts_filter.tpl' _get="newsfeed"}
        {/if}
      </div>
    {/capture}

    <!-- announcments -->
    {include file='_announcements.tpl'}
    <!-- announcments -->

    {$_boosted_view = in_array($view, ['boosted_posts', 'boosted_pages', 'boosted_groups', 'boosted_events'])}

    {if $_boosted_view && !$user->_is_admin && !$user->_data['user_subscribed']}
      <!-- upgrade -->
      <div class="card border border-base-300 bg-base-100 p-8 text-center shadow-none">
        <span class="mx-auto flex size-16 items-center justify-center rounded-box bg-warning/15 text-warning">
          <span class="icon-[tabler--crown] size-8" aria-hidden="true"></span>
        </span>
        <h2 class="mt-4 text-xl font-semibold">{__("Membership")}</h2>
        <p class="mt-1 text-sm text-base-content/60">{__("Choose the Plan That's Right for You")}</p>
        <a href="{$system['system_url']}/packages" class="heroui button button--primary mt-5 h-12 rounded-box px-6">
          <span class="icon-[tabler--rocket] size-5" aria-hidden="true"></span>{__("Upgrade to Pro")}
        </a>
      </div>
      <!-- upgrade -->

    {elseif $view == "boosted_pages" || $view == "boosted_groups" || $view == "boosted_events"}
      <!-- boosted -->
      <div class="card border border-base-300 bg-base-100 p-3 shadow-none">
        {if ($view == "boosted_pages" && $boosted_pages) || ($view == "boosted_groups" && $boosted_groups) || ($view == "boosted_events" && $boosted_events)}
          <ul class="flex flex-col gap-1">
            {if $view == "boosted_pages"}
              {foreach $boosted_pages as $_page}
                {include file='__feeds_page.tpl' _tpl="list"}
              {/foreach}
            {elseif $view == "boosted_groups"}
              {foreach $boosted_groups as $_group}
                {include file='__feeds_group.tpl' _tpl="list"}
              {/foreach}
            {else}
              {foreach $boosted_events as $_event}
                {include file='__feeds_event.tpl' _tpl="list" _small=true}
              {/foreach}
            {/if}
          </ul>
          {if ($view == "boosted_pages" && count($boosted_pages) >= $system['pages_results']) || ($view == "boosted_groups" && count($boosted_groups) >= $system['groups_results']) || ($view == "boosted_events" && count($boosted_events) >= $system['events_results'])}
            <!-- see-more -->
            <div class="see-more js_see-more mt-2 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="{$view}">
              <span>{__("See More")}</span>
              <div class="loading loading-spinner loading-sm hidden"></div>
            </div>
            <!-- see-more -->
          {/if}
        {else}
          <div class="p-4">
            {include file='_no_data.tpl'}
          </div>
        {/if}
      </div>
      <!-- boosted -->

    {else}

      {if $view == "" && $user->_logged_in}

        {if $system['stories_enabled'] && ($stories['mine'] || $stories['users'] || $user->_data['can_add_stories'])}
          <!-- stories -->
          <div class="js_stories relative">
            <div class="js_stories-strip -my-1 flex touch-pan-x {if $system['stories_design'] == "cards"}gap-2{else}gap-1{/if} overflow-x-auto py-1 overscroll-x-contain scroll-smooth [scrollbar-width:none]! [&::-webkit-scrollbar]:hidden!">

              {if $system['stories_design'] == "cards"}

                {if $user->_data['can_add_stories']}
                  <div class="w-28 shrink-0 sm:w-32">
                    <button type="button" class="js_story-create group/add relative flex aspect-[9/14] w-full flex-col overflow-hidden rounded-2xl border border-base-content/10 bg-base-100 text-center transition active:scale-[0.98]" aria-label='{__("Create story")}'>
                      <img class="min-h-0 w-full flex-1 object-cover" src="{$user->_data['user_picture']}" alt="">
                      <span class="relative flex h-14 shrink-0 items-end justify-center pb-2 text-xs font-semibold text-base-content">
                        <span class="absolute -top-4 left-1/2 flex size-8 -translate-x-1/2 items-center justify-center rounded-full border-4 border-base-100 bg-primary text-primary-content transition group-hover/add:scale-110" aria-hidden="true">
                          <span class="icon-[tabler--plus] size-4"></span>
                        </span>
                        <span class="w-full truncate px-2" title='{__("Create story")}'>{__("Create story")}</span>
                      </span>
                    </button>
                  </div>
                {/if}
                {if $stories['mine']}
                  <div class="js_story-slide relative w-28 shrink-0 sm:w-32">
                    <button type="button" class="js_story-open relative block aspect-[9/14] w-full overflow-hidden rounded-2xl text-start transition active:scale-[0.98] {if $stories['mine']['preview']}bg-base-300{elseif $_story_backgrounds[$stories['mine']['background']]}{$_story_backgrounds[$stories['mine']['background']]}{else}bg-linear-to-br from-primary to-accent{/if}" data-user-id="{$user->_data['user_id']}" aria-label='{__("Your story")}'>
                      {if $stories['mine']['preview']}
                        <img class="absolute inset-0 size-full object-cover" src="{$stories['mine']['preview']}" alt="" loading="lazy">
                      {/if}
                      {if $stories['mine']['thumb_layers']}
                        <span class="js_story-thumb pointer-events-none absolute inset-x-0 top-1/2 block aspect-[9/16] -translate-y-1/2 @container [&_*]:pointer-events-none!" data-layers="{$stories['mine']['thumb_layers']|escape:'html'}" data-fonts="{$system['system_theme_fonts']}" aria-hidden="true">
                          {if $stories['mine']['thumb_drawing']}<img class="absolute inset-0 size-full" src="{$stories['mine']['thumb_drawing']}" alt="" loading="lazy">{/if}
                        </span>
                      {/if}
                      <span class="absolute inset-0 bg-linear-to-b from-black/35 via-transparent to-black/65" aria-hidden="true"></span>
                      <span class="absolute start-2 top-2 rounded-full bg-linear-to-tr from-amber-400 via-rose-500 to-fuchsia-600 p-0.5">
                        <img class="size-9 rounded-full border-2 border-base-100 object-cover" src="{$stories['mine']['user_picture']}" alt="">
                      </span>
                      <span class="absolute inset-x-2 bottom-2 truncate text-xs font-semibold text-white" title='{__("Your story")}'>{__("Your story")}</span>
                    </button>
                  </div>
                {/if}

                {foreach $stories['users'] as $_story}
                  <div class="js_story-slide w-28 shrink-0 sm:w-32">
                    <button type="button" class="js_story-open group/card relative block aspect-[9/14] w-full overflow-hidden rounded-2xl text-start transition active:scale-[0.98] {if $_story['preview']}bg-base-300{elseif $_story_backgrounds[$_story['background']]}{$_story_backgrounds[$_story['background']]}{else}bg-linear-to-br from-primary to-accent{/if}" data-user-id="{$_story['user_id']}" data-seen="{if $_story['seen']}true{else}false{/if}" aria-label="{$_story['user_fullname']}">
                      {if $_story['preview']}
                        <img class="absolute inset-0 size-full object-cover transition duration-300 group-hover/card:scale-105 group-data-[seen=true]/card:opacity-75" src="{$_story['preview']}" alt="" loading="lazy">
                      {/if}
                      {if $_story['thumb_layers']}
                        <span class="js_story-thumb pointer-events-none absolute inset-x-0 top-1/2 block aspect-[9/16] -translate-y-1/2 @container [&_*]:pointer-events-none!" data-layers="{$_story['thumb_layers']|escape:'html'}" data-fonts="{$system['system_theme_fonts']}" aria-hidden="true">
                          {if $_story['thumb_drawing']}<img class="absolute inset-0 size-full" src="{$_story['thumb_drawing']}" alt="" loading="lazy">{/if}
                        </span>
                      {/if}
                      <span class="absolute inset-0 bg-linear-to-b from-black/35 via-transparent to-black/65" aria-hidden="true"></span>
                      <span class="absolute start-2 top-2 rounded-full bg-linear-to-tr from-amber-400 via-rose-500 to-fuchsia-600 p-0.5 group-data-[seen=true]/card:from-white/50 group-data-[seen=true]/card:via-white/50 group-data-[seen=true]/card:to-white/50">
                        <img class="size-9 rounded-full border-2 border-base-100 object-cover" src="{$_story['user_picture']}" alt="">
                      </span>
                      <span class="absolute inset-x-2 bottom-2 flex min-w-0 items-center gap-1 text-xs font-semibold text-white">
                        {if $_story['is_ads']}<span class="icon-[tabler--speakerphone] size-3.5 shrink-0" aria-hidden="true"></span>{/if}
                        <span class="truncate" title="{$_story['user_fullname']}">{$_story['user_fullname']}</span>
                      </span>
                    </button>
                  </div>
                {/foreach}

              {else}
                {if $user->_data['can_add_stories']}
                  <div class="w-19 shrink-0 sm:w-22">
                    <div class="flex flex-col items-center gap-2">
                      <button type="button" class="js_story-create flex size-17 items-center justify-center rounded-full border-2 border-dashed border-base-content/25 text-base-content/50 transition-colors hover:border-primary hover:text-primary sm:size-19" aria-label='{__("Create story")}'>
                        <span class="icon-[tabler--plus] size-6" aria-hidden="true"></span>
                      </button>
                      <span class="w-full truncate text-center text-xs" title='{__("Create story")}'>{__("Create story")}</span>
                    </div>
                  </div>
                {/if}
                {if $stories['mine']}
                  <div class="js_story-slide w-19 shrink-0 sm:w-22">
                    <div class="flex flex-col items-center gap-2">
                      <div class="relative">
                        <button type="button" class="js_story-open block rounded-full bg-linear-to-tr from-amber-400 via-rose-500 to-fuchsia-600 p-0.5 transition active:scale-95" data-user-id="{$user->_data['user_id']}" aria-label='{__("Your story")}'>
                          <img class="size-16 rounded-full border-2 border-base-100 object-cover sm:size-18" src="{$stories['mine']['user_picture']}" alt="">
                        </button>
                      </div>
                      <span class="w-full truncate text-center text-xs font-medium" title='{__("Your story")}'>{__("Your story")}</span>
                    </div>
                  </div>
                {/if}

                {foreach $stories['users'] as $_story}
                  <div class="js_story-slide w-19 shrink-0 sm:w-22">
                    <div class="flex flex-col items-center gap-2">
                      <button type="button" class="js_story-open block rounded-full bg-linear-to-tr from-amber-400 via-rose-500 to-fuchsia-600 p-0.5 transition active:scale-95 data-[seen=true]:from-base-content/20 data-[seen=true]:via-base-content/20 data-[seen=true]:to-base-content/20" data-user-id="{$_story['user_id']}" data-seen="{if $_story['seen']}true{else}false{/if}" aria-label="{$_story['user_fullname']}">
                        <img class="size-16 rounded-full border-2 border-base-100 object-cover sm:size-18" src="{$_story['user_picture']}" alt="">
                      </button>
                      <span class="flex w-full min-w-0 items-center justify-center gap-1 text-xs font-medium">
                        {if $_story['is_ads']}<span class="icon-[tabler--speakerphone] size-3.5 shrink-0 text-base-content/60" aria-hidden="true"></span>{/if}
                        <span class="truncate" title="{$_story['user_fullname']}">{$_story['user_fullname']}</span>
                      </span>
                    </div>
                  </div>
                {/foreach}

              {/if}

            </div>

            <!-- arrows -->
            <button type="button" disabled class="js_stories-prev absolute start-0 {if $system['stories_design'] == "cards"}top-1/2{else}top-8.5 sm:top-9.5{/if} z-10 inline-flex size-9 -translate-y-1/2 items-center justify-center rounded-full border border-base-300 bg-base-100 text-base-content shadow-sm transition hover:bg-base-200 pointer-coarse:hidden disabled:pointer-events-none disabled:opacity-0" aria-label='{__("Previous")}'>
              <span class="icon-[tabler--chevron-left] size-5 rtl:rotate-180" aria-hidden="true"></span>
            </button>
            <button type="button" class="js_stories-next absolute end-0 {if $system['stories_design'] == "cards"}top-1/2{else}top-8.5 sm:top-9.5{/if} z-10 inline-flex size-9 -translate-y-1/2 items-center justify-center rounded-full border border-base-300 bg-base-100 text-base-content shadow-sm transition hover:bg-base-200 pointer-coarse:hidden disabled:pointer-events-none disabled:opacity-0" aria-label='{__("Next")}'>
              <span class="icon-[tabler--chevron-right] size-5 rtl:rotate-180" aria-hidden="true"></span>
            </button>
            <!-- arrows -->
          </div>
          <!-- stories -->
        {/if}

        <!-- publisher -->
        {include file='__publisher_trigger.tpl' _handle="me" _id="" _name=$user->_data['user_fullname'] _avatar=$user->_data['user_picture'] _target=""}
        <!-- publisher -->

        {if $pro_members || $promoted_pages || $promoted_groups || $promoted_events}
          <!-- promoted -->
          <div class="flex flex-col gap-5 xl:hidden">
            {if $pro_members}
              {include file='__promoted_strip.tpl' _items=$pro_members _type="users" _title=__("Promoted Users")}
            {/if}
            {if $promoted_pages}
              {include file='__promoted_strip.tpl' _items=$promoted_pages _type="pages" _title=__("Promoted Pages")}
            {/if}
            {if $promoted_groups}
              {include file='__promoted_strip.tpl' _items=$promoted_groups _type="groups" _title=__("Promoted Groups")}
            {/if}
            {if $promoted_events}
              {include file='__promoted_strip.tpl' _items=$promoted_events _type="events" _title=__("Promoted Events")}
            {/if}
          </div>
          <!-- promoted -->
        {/if}

      {/if}

      {if $view == ""}
        {include file='_widget.tpl' widgets=$newsfeed_widgets}
      {/if}

      {if $view == "" && $boosted_posts}
        <!-- boosted posts -->
        <div class="mt-3 mb-1">
          {include file='_boosted_posts.tpl'}
        </div>
        <!-- boosted posts -->
      {/if}

      {if in_array($view, ['', 'popular', 'discover'])}
        <!-- filters -->
        {$_feed_filters nofilter}
        <!-- filters -->
      {/if}

      <!-- posts -->
      {if $view == ""}
        {include file='_posts.tpl' _get="newsfeed" _no_filter=true}
      {elseif $view == "popular"}
        {include file='_posts.tpl' _get="popular" _title=__("Popular Posts") _no_filter=true}
      {elseif $view == "discover"}
        {include file='_posts.tpl' _get="discover" _title=__("Discover Posts") _no_filter=true}
      {elseif $view == "saved"}
        {include file='_posts.tpl' _get="saved" _title=__("Saved Posts") _no_filter=true}
      {elseif $view == "scheduled"}
        {include file='_posts.tpl' _get="scheduled" _title=__("Scheduled Posts") _no_filter=true}
      {elseif $view == "memories"}
        {include file='_posts.tpl' _get="memories" _title=__("On This Day") _filter="all" _no_filter=true}
      {elseif $view == "boosted_posts" && ($user->_is_admin || $user->_data['user_subscribed'])}
        {include file='_posts.tpl' _get="boosted" _title=__("Boosted Posts") _no_filter=true}
      {/if}
      <!-- posts -->

    {/if}
  </div>
  <!-- content panel -->

  <!-- right panel -->
  <aside class="hidden w-80 shrink-0 xl:sticky xl:bottom-4 xl:block xl:min-h-[calc(100dvh-6.5rem)] xl:self-end">
    <div class="flex flex-col gap-5">

      <!-- promoted -->
      {if $pro_members}
        {include file='__promoted_strip.tpl' _items=$pro_members _type="users" _title=__("Promoted Users")}
      {/if}
      {if $promoted_pages}
        {include file='__promoted_strip.tpl' _items=$promoted_pages _type="pages" _title=__("Promoted Pages")}
      {/if}
      {if $promoted_groups}
        {include file='__promoted_strip.tpl' _items=$promoted_groups _type="groups" _title=__("Promoted Groups")}
      {/if}
      {if $promoted_events}
        {include file='__promoted_strip.tpl' _items=$promoted_events _type="events" _title=__("Promoted Events")}
      {/if}
      <!-- promoted -->

      {if $user->_logged_in && $system['merits_enabled'] && $system['merits_widgets_balance']}
        {include file='__merits_balance.tpl'}
      {/if}

      {if $top_merits_users}
        <!-- merits top users -->
        {$_leaderboard_icon = ''}{if $system['system_theme_icons'] == 'svg'}{$_leaderboard_icon = 'merits_trophy'|theme_module_icon:'size-14 shrink-0'}{/if}
        <div class="rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-linear-to-br from-primary/25 via-accent/15 to-info/5 p-5 text-sm">
          <div class="flex items-start gap-3">
            {if $_leaderboard_icon}
              {$_leaderboard_icon}
            {else}
              <span class="icon-[tabler--trophy] size-12 shrink-0 text-primary" aria-hidden="true"></span>
            {/if}
            <div class="min-w-0 grow">
              <h2 class="text-base font-semibold">{__("Merits Top Users")}</h2>
              <p class="mt-1 text-xs text-base-content/60">{__("People who earned the most merits")}</p>
            </div>
            <a class="heroui button button--tertiary button--sm button--icon-only size-6 shrink-0 rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-[0.75rem] border-white/60 dark:border-white/10 dark:bg-black/25 dark:hover:border-white/20 dark:hover:bg-black/40 bg-base-100/50 text-base-content shadow-sm backdrop-blur-md hover:bg-base-100" href="{$system['system_url']}/merits" aria-label='{__("See All")}' title='{__("See All")}'>
              <span class="icon-[tabler--arrow-up-right] size-4 rtl:-scale-x-100" aria-hidden="true"></span>
            </a>
          </div>
          <ol class="mt-4 flex flex-col gap-1.5">
            {foreach $top_merits_users as $top_user}
              {$_merit_user = $top_user['top_user']}
              {$_merit_category = $top_user['category']}
              <li>
                <a class="group flex items-center gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-base-100/70 px-2 py-2 text-base-content! shadow-sm backdrop-blur-sm transition-colors hover:bg-base-100" href="{$system['system_url']}/{$_merit_user['user_name']}">
                  <span class="relative shrink-0">
                    <img class="size-10 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl object-cover" src="{$_merit_user['user_picture']}" alt="" loading="lazy">
                    <span class="absolute -top-1.5 -start-1.5 flex size-5 items-center justify-center rounded-full text-[0.625rem] font-bold tabular-nums ring-2 ring-base-100 {if $top_user@iteration == 1}bg-linear-to-br from-amber-300 to-amber-500 text-amber-950{elseif $top_user@iteration == 2}bg-linear-to-br from-slate-200 to-slate-400 text-slate-800{elseif $top_user@iteration == 3}bg-linear-to-br from-orange-300 to-orange-600 text-white{else}bg-base-200 text-base-content/70{/if}">{$top_user@iteration}</span>
                  </span>
                  <span class="min-w-0 grow">
                    <span class="block truncate text-sm font-semibold" title="{if $system['show_usernames_enabled']}{$_merit_user['user_name']}{else}{$_merit_user['user_firstname']} {$_merit_user['user_lastname']}{/if}">{if $system['show_usernames_enabled']}{$_merit_user['user_name']}{else}{$_merit_user['user_firstname']} {$_merit_user['user_lastname']}{/if}</span>
                    <span class="flex min-w-0 items-center gap-1 text-xs text-base-content/60">
                      <img class="size-3.5 shrink-0 rounded-full object-cover" src="{$system['system_uploads']}/{$_merit_category['category_image']}" alt="" loading="lazy">
                      <span class="truncate" title="{__($_merit_category['category_name'])}">{__($_merit_category['category_name'])}</span>
                    </span>
                  </span>
                  <span class="flex shrink-0 items-center gap-1 rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-xl bg-primary/10 px-2 py-1 text-xs font-semibold text-primary tabular-nums" title='{__("Merits")}'>
                    <span class="icon-[tabler--award] size-3.5" aria-hidden="true"></span>
                    {$_merit_user['count']}
                  </span>
                </a>
              </li>
            {/foreach}
          </ol>
        </div>
        <!-- merits top users -->
      {/if}

      {include file='_ads.tpl'}
      {include file='_ads_campaigns.tpl'}

      {if $user->_data['can_create_ads'] && !$ads_campaigns}
        {$_ads_icon = ''}
        {if $system['system_theme_icons'] == 'svg'}
          {$_ads_icon = 'ads'|theme_module_icon:'size-14 shrink-0'}
        {/if}
        <!-- advertise -->
        <div class="rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-primary/10 p-5">
          <div class="flex items-start gap-3">
            <div class="min-w-0 grow">
              <h2 class="text-base font-semibold">{__("Put your ads here")}</h2>
              <p class="mt-1 text-xs text-base-content/60">{__("Reach more people with your campaigns")}</p>
            </div>
            {if $_ads_icon}
              {$_ads_icon}
            {else}
              <span class="icon-[tabler--speakerphone] size-12 shrink-0 text-primary" aria-hidden="true"></span>
            {/if}
          </div>
          <a class="heroui button button--primary mt-4 w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/ads/new">{__("Create Ads")}</a>
        </div>
        <!-- advertise -->
      {/if}

      <!-- trending -->
      {if $trending_hashtags}
        {include file='_trending_widget.tpl'}
      {/if}
      <!-- trending -->

      {include file='_widget.tpl'}

      <!-- latest blogs -->
      {if $latest_blogs}
        {include file='_blogs_carousel.tpl'}
      {/if}
      <!-- latest blogs -->

      <!-- friends suggestions -->
      {if $new_people}
        {capture assign="_people_title"}{if $system['friends_enabled']}{__("Suggested Friends")}{else}{__("Suggested People")}{/if}{/capture}
        <div class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none text-sm" data-carousel='{ "loadingClasses": "opacity-0", "isAutoPlay": true, "speed": 9000, "isInfiniteLoop": true, "isRTL": {if $system['language']['dir'] == "RTL"}true{else}false{/if} }'>
          {include file='__card_header.tpl' _card_title=$_people_title _card_url="`$system['system_url']`/people" _card_arrows=true _card_arrow_class="border-transparent bg-black/5 text-base-content shadow-none hover:bg-black/10 dark:bg-white/10 dark:hover:bg-white/15"}
          <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-3">
            <div class="carousel rounded-none bg-transparent">
              <div class="carousel-body peer opacity-0 [&.opacity-0]:absolute [&.opacity-0]:inset-x-0 [&.opacity-0]:top-0">
                {foreach $new_people as $_user}
                  {capture assign="_people_name"}{if $system['show_usernames_enabled']}{$_user['user_name']}{else}{$_user['user_firstname']} {$_user['user_lastname']}{/if}{/capture}
                  <div class="carousel-slide">
                    <div class="flex h-full flex-col rounded-[1.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[2.25rem] bg-[#F9F9F9] dark:bg-base-200 p-2">
                      <a class="block overflow-hidden rounded-[1.375rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.875rem]" href="{$system['system_url']}/{$_user['user_name']}">
                        <img class="aspect-square w-full object-cover" src="{$_user['user_picture']}" alt="{$_people_name}" loading="lazy">
                      </a>
                      <div class="flex flex-col gap-1 px-3 pt-4">
                        <div class="flex min-w-0 items-center gap-1.5">
                          <a class="truncate text-base font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/{$_user['user_name']}" title="{$_people_name}">{$_people_name}</a>
                          {if $_user['user_verified']}
                            {include file='__badge.tpl' _badge="verified" _badge_type="user"}
                          {/if}
                          {if $_user['user_subscribed']}
                            {include file='__badge.tpl' _badge="pro" _badge_package=$_user['package_name']}
                          {/if}
                        </div>
                        {$_card = $_user|user_card_details}
                        {if $_card['work'] || $_card['location'] || $_card['education']}
                          <ul class="mt-1 flex min-w-0 flex-col gap-1 text-xs text-base-content/70">
                            {if $_card['work']}
                              <li class="flex min-w-0 items-center gap-1.5">
                                <span class="icon-[tabler--briefcase] size-3.5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                                <span class="truncate" title="{$_card['work']['title']}{if $_card['work']['place']} {__("at")} {$_card['work']['place']}{/if}">{$_card['work']['title']}{if $_card['work']['place']} {__("at")} <span class="font-medium text-base-content">{$_card['work']['place']}</span>{/if}</span>
                              </li>
                            {/if}
                            {if $_card['location']}
                              <li class="flex min-w-0 items-center gap-1.5">
                                <span class="icon-[tabler--map-pin] size-3.5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                                <span class="truncate" title="{$_card['location']}">{$_card['location']}</span>
                              </li>
                            {/if}
                            {if $_card['education']}
                              <li class="flex min-w-0 items-center gap-1.5">
                                <span class="icon-[tabler--school] size-3.5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                                <span class="truncate" title="{if $_card['education']['major']}{__("Studied")} {$_card['education']['major']} {__("at")} {/if}{$_card['education']['school']}">{if $_card['education']['major']}{__("Studied")} {$_card['education']['major']} {__("at")} {/if}<span class="font-medium text-base-content">{$_card['education']['school']}</span></span>
                              </li>
                            {/if}
                          </ul>
                        {/if}
                        {if $_user['mutual_friends_count']}
                          <button type="button" class="js_modal mt-2 flex min-w-0 items-center gap-2 text-start text-xs text-base-content/60 hover:text-primary" data-url="users/mutual_friends.php?uid={$_user['user_id']}">
                            {if $_user['mutual_friends']}
                              <span class="avatar-group shrink-0 -space-x-2">
                                {foreach $_user['mutual_friends'] as $_mutual_friend}
                                  <span class="avatar">
                                    <span class="size-6 rounded-full ring-2 ring-base-100">
                                      <img src="{$_mutual_friend['user_picture']}" alt="" loading="lazy">
                                    </span>
                                  </span>
                                {/foreach}
                              </span>
                            {/if}
                            <span class="truncate" title="{$_user['mutual_friends_count']} {__("mutual friends")}"><span class="font-semibold text-base-content">{$_user['mutual_friends_count']}</span> {__("mutual friends")}</span>
                          </button>
                        {/if}
                      </div>
                      <div class="mt-auto px-1 pb-1 pt-4 [&>.button]:w-full">
                        {if $system['friends_enabled']}
                          {include file='__connection_button.tpl' _state="friend_add" _uid=$_user['user_id']}
                        {else}
                          {include file='__connection_button.tpl' _state="follow" _uid=$_user['user_id']}
                        {/if}
                      </div>
                    </div>
                  </div>
                {/foreach}
              </div>
              {include file='__carousel_skeleton.tpl' _type="card" _media="aspect-square" _footer="button"}
            </div>
          </div>
        </div>
      {/if}
      <!-- friends suggestions -->

      <!-- suggested pages -->
      {if $new_pages}
        <div class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none text-sm" data-carousel='{ "loadingClasses": "opacity-0", "isAutoPlay": true, "speed": 11000, "isInfiniteLoop": true, "isRTL": {if $system['language']['dir'] == "RTL"}true{else}false{/if} }'>
          {include file='__card_header.tpl' _card_title=__("Suggested Pages") _card_url="`$system['system_url']`/pages" _card_arrows=true _card_arrow_class="border-transparent bg-black/5 text-base-content shadow-none hover:bg-black/10 dark:bg-white/10 dark:hover:bg-white/15"}
          <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-3">
            <div class="carousel rounded-none bg-transparent">
              <div class="carousel-body peer opacity-0 [&.opacity-0]:absolute [&.opacity-0]:inset-x-0 [&.opacity-0]:top-0">
                {foreach $new_pages as $_page}
                  <div class="carousel-slide">
                    <div class="flex h-full flex-col rounded-[1.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[2.25rem] bg-[#F9F9F9] dark:bg-base-200 p-2">
                      <a class="block aspect-[5/2] overflow-hidden rounded-[1.375rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.875rem] bg-linear-to-br from-primary/25 via-primary/10 to-secondary/20 bg-cover bg-center" href="{$system['system_url']}/pages/{$_page['page_name']}" tabindex="-1" aria-hidden="true" {if $_page['page_cover']}style="background-image: url('{$system['system_uploads']}/{$_page['page_cover']}')"{/if}></a>
                      <div class="flex flex-col gap-1 px-3">
                        <a class="relative z-1 -mt-8 mb-2 w-fit shrink-0 rounded-2xl ring-4 ring-[#F9F9F9] dark:ring-base-200" href="{$system['system_url']}/pages/{$_page['page_name']}" tabindex="-1" aria-hidden="true">
                          <img class="size-16 rounded-2xl bg-base-100 object-cover" src="{$_page['page_picture']}" alt="" loading="lazy">
                        </a>
                        <div class="flex min-w-0 items-center gap-1.5">
                          <span class="js_user-popover inline-flex min-w-0" data-uid="{$_page['page_id']}" data-type="page">
                            <a class="truncate text-base font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/pages/{$_page['page_name']}" title="{$_page['page_title']}">{$_page['page_title']}</a>
                          </span>
                          {if $_page['page_verified']}
                            {include file='__badge.tpl' _badge="verified" _badge_type="page"}
                          {/if}
                        </div>
                        <span class="flex min-w-0 items-center gap-1.5 text-xs text-base-content/60">
                          <span class="icon-[tabler--heart] size-3.5 shrink-0" aria-hidden="true"></span>
                          <span class="truncate" title="{$_page['page_likes']} {__("Likes")}"><span class="font-semibold text-base-content">{$_page['page_likes']}</span> {__("Likes")}</span>
                        </span>
                        {if $_page['page_description']}
                          <p class="mt-1.5 line-clamp-2 text-sm text-base-content/65" title="{$_page['page_description']|strip_tags}">{$_page['page_description']|strip_tags|truncate:140}</p>
                        {/if}
                      </div>
                      <div class="mt-auto px-1 pb-1 pt-4 [&>.button]:w-full">
                        {if $_page['i_like']}
                          {include file='__connection_button.tpl' _state="page_liked" _id=$_page['page_id']}
                        {else}
                          {include file='__connection_button.tpl' _state="page_like" _id=$_page['page_id']}
                        {/if}
                      </div>
                    </div>
                  </div>
                {/foreach}
              </div>
              {include file='__carousel_skeleton.tpl' _type="card" _media="aspect-[5/2]" _footer="button" _avatar=true}
            </div>
          </div>
        </div>
      {/if}
      <!-- suggested pages -->

      <!-- suggested groups -->
      {if $new_groups}
        <div class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none text-sm" data-carousel='{ "loadingClasses": "opacity-0", "isAutoPlay": true, "speed": 10000, "isInfiniteLoop": true, "isRTL": {if $system['language']['dir'] == "RTL"}true{else}false{/if} }'>
          {include file='__card_header.tpl' _card_title=__("Suggested Groups") _card_url="`$system['system_url']`/groups" _card_arrows=true _card_arrow_class="border-transparent bg-black/5 text-base-content shadow-none hover:bg-black/10 dark:bg-white/10 dark:hover:bg-white/15"}
          <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-3">
            <div class="carousel rounded-none bg-transparent">
              <div class="carousel-body peer opacity-0 [&.opacity-0]:absolute [&.opacity-0]:inset-x-0 [&.opacity-0]:top-0">
                {foreach $new_groups as $_group}
                  <div class="carousel-slide">
                    <div class="flex h-full flex-col rounded-[1.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[2.25rem] bg-[#F9F9F9] dark:bg-base-200 p-2">
                      <a class="block aspect-[5/2] overflow-hidden rounded-[1.375rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.875rem] bg-linear-to-br from-primary/25 via-primary/10 to-secondary/20 bg-cover bg-center" href="{$system['system_url']}/groups/{$_group['group_name']}" tabindex="-1" aria-hidden="true" {if $_group['group_cover']}style="background-image: url('{$system['system_uploads']}/{$_group['group_cover']}')"{/if}></a>
                      <div class="flex flex-col gap-1 px-3">
                        <a class="relative z-1 -mt-8 mb-2 w-fit shrink-0 rounded-2xl ring-4 ring-[#F9F9F9] dark:ring-base-200" href="{$system['system_url']}/groups/{$_group['group_name']}" tabindex="-1" aria-hidden="true">
                          <img class="size-16 rounded-2xl bg-base-100 object-cover" src="{$_group['group_picture']}" alt="" loading="lazy">
                        </a>
                        <a class="truncate text-base font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/groups/{$_group['group_name']}" title="{$_group['group_title']}">{$_group['group_title']}</a>
                        <span class="flex min-w-0 items-center gap-1.5 text-xs text-base-content/60">
                          <span class="icon-[tabler--users] size-3.5 shrink-0" aria-hidden="true"></span>
                          <span class="truncate" title="{$_group['group_members']} {__("Members")}"><span class="font-semibold text-base-content">{$_group['group_members']}</span> {__("Members")}</span>
                          <span aria-hidden="true">·</span>
                          {if $_group['group_privacy'] == "secret"}
                            <span class="flex shrink-0 items-center gap-1"><span class="icon-[tabler--eye-off] size-3.5" aria-hidden="true"></span>{__("Secret")}</span>
                          {elseif $_group['group_privacy'] == "closed"}
                            <span class="flex shrink-0 items-center gap-1"><span class="icon-[tabler--lock] size-3.5" aria-hidden="true"></span>{__("Closed")}</span>
                          {else}
                            <span class="flex shrink-0 items-center gap-1"><span class="icon-[tabler--world] size-3.5" aria-hidden="true"></span>{__("Public")}</span>
                          {/if}
                        </span>
                        {if $_group['group_description']}
                          <p class="mt-1.5 line-clamp-2 text-sm text-base-content/65" title="{$_group['group_description']|strip_tags}">{$_group['group_description']|strip_tags|truncate:140}</p>
                        {/if}
                      </div>
                      <div class="mt-auto px-1 pb-1 pt-4 [&>.button]:w-full">
                        {if $_group['i_joined'] == "approved"}
                          {include file='__connection_button.tpl' _state="group_joined" _id=$_group['group_id'] _privacy=$_group['group_privacy']}
                        {elseif $_group['i_joined'] == "pending"}
                          {include file='__connection_button.tpl' _state="group_pending" _id=$_group['group_id'] _privacy=$_group['group_privacy']}
                        {elseif $user->_data['user_id'] == $_group['group_admin']}
                          {include file='__connection_button.tpl' _state="group_join" _id=$_group['group_id'] _privacy="public"}
                        {else}
                          {include file='__connection_button.tpl' _state="group_join" _id=$_group['group_id'] _privacy=$_group['group_privacy']}
                        {/if}
                      </div>
                    </div>
                  </div>
                {/foreach}
              </div>
              {include file='__carousel_skeleton.tpl' _type="card" _media="aspect-[5/2]" _footer="button" _avatar=true}
            </div>
          </div>
        </div>
      {/if}
      <!-- suggested groups -->

      <!-- suggested events -->
      {if $new_events}
        <div class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none text-sm" data-carousel='{ "loadingClasses": "opacity-0", "isAutoPlay": true, "speed": 12000, "isInfiniteLoop": true, "isRTL": {if $system['language']['dir'] == "RTL"}true{else}false{/if} }'>
          {include file='__card_header.tpl' _card_title=__("Suggested Events") _card_url="`$system['system_url']`/events" _card_arrows=true _card_arrow_class="border-transparent bg-black/5 text-base-content shadow-none hover:bg-black/10 dark:bg-white/10 dark:hover:bg-white/15"}
          <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-3">
            <div class="carousel rounded-none bg-transparent">
              <div class="carousel-body peer opacity-0 [&.opacity-0]:absolute [&.opacity-0]:inset-x-0 [&.opacity-0]:top-0">
                {foreach $new_events as $_event}
                  <div class="carousel-slide">
                    <div class="flex h-full flex-col rounded-[1.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[2.25rem] bg-[#F9F9F9] dark:bg-base-200 p-2">
                      <a class="relative block aspect-[4/3] overflow-hidden rounded-[1.375rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.875rem] bg-linear-to-br from-primary/20 via-primary/5 to-secondary/15" href="{$system['system_url']}/events/{$_event['event_id']}">
                        {if $_event['event_picture']}
                          <img class="size-full object-cover" src="{$_event['event_picture']}" alt="{$_event['event_title']}" loading="lazy">
                        {else}
                          <span class="absolute inset-0 flex items-center justify-center text-primary/40" aria-hidden="true"><span class="icon-[tabler--calendar-event] size-12"></span></span>
                        {/if}
                        <time class="absolute start-3 top-3 flex min-w-12 flex-col items-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-base-100/95 px-2 py-1 leading-tight text-base-content shadow-sm backdrop-blur-sm" datetime="{$_event['event_start_date']|date_format:"%Y-%m-%dT%H:%M"}">
                          <strong class="text-lg font-bold">{$_event['event_start_date']|date_format:"%e"}</strong>
                          <span class="text-[11px] font-semibold uppercase text-primary">{__($_event['event_start_date']|date_format:"%b")}</span>
                        </time>
                        <span class="absolute end-3 top-3 flex items-center gap-1 rounded-full bg-black/50 px-2 py-0.5 text-[11px] font-medium text-white backdrop-blur-sm">
                          {if $_event['event_is_online']}<span class="icon-[tabler--broadcast] size-3.5" aria-hidden="true"></span>{__("Online Event")}{else}<span class="icon-[tabler--map-pin] size-3.5" aria-hidden="true"></span>{__("In Person")}{/if}
                        </span>
                      </a>
                      <div class="flex flex-col gap-1 px-3 pt-4">
                        <a class="line-clamp-2 text-base font-semibold leading-snug text-base-content! hover:text-primary!" href="{$system['system_url']}/events/{$_event['event_id']}" title="{$_event['event_title']}">{$_event['event_title']}</a>
                        <span class="mt-1 flex items-center gap-1.5 text-xs text-base-content/60">
                          <span class="icon-[tabler--clock] size-4 shrink-0" aria-hidden="true"></span>
                          <time datetime="{$_event['event_start_date']|date_format:"%Y-%m-%dT%H:%M"}">{__($_event['event_start_date']|date_format:"%a")}, {$_event['event_start_date']|date_format:"%I:%M %p"}</time>
                        </span>
                        {if !$_event['event_is_online'] && $_event['event_location']}
                          <span class="flex min-w-0 items-center gap-1.5 text-xs text-base-content/60">
                            <span class="icon-[tabler--map-pin] size-4 shrink-0" aria-hidden="true"></span>
                            <span class="truncate" title="{$_event['event_location']}">{$_event['event_location']}</span>
                          </span>
                        {/if}
                        <span class="flex min-w-0 items-center gap-1.5 text-xs text-base-content/60">
                          <span class="icon-[tabler--users] size-4 shrink-0" aria-hidden="true"></span>
                          <span class="truncate" title="{$_event['event_going']} {__("Going")} · {$_event['event_interested']} {__("Interested")}"><span class="font-semibold text-base-content">{$_event['event_going']}</span> {__("Going")} · <span class="font-semibold text-base-content">{$_event['event_interested']}</span> {__("Interested")}</span>
                        </span>
                        {if $_event['event_description']}
                          <p class="mt-1.5 line-clamp-2 text-sm text-base-content/65" title="{$_event['event_description']|strip_tags}">{$_event['event_description']|strip_tags|truncate:140}</p>
                        {/if}
                      </div>
                      <div class="mt-auto px-1 pb-1 pt-4 [&>.button]:w-full">
                        {if $_event['i_joined']['is_interested']}
                          {include file='__connection_button.tpl' _state="event_interested" _id=$_event['event_id']}
                        {else}
                          {include file='__connection_button.tpl' _state="event_interest" _id=$_event['event_id']}
                        {/if}
                      </div>
                    </div>
                  </div>
                {/foreach}
              </div>
              {include file='__carousel_skeleton.tpl' _type="card" _media="aspect-[4/3]" _footer="button"}
            </div>
          </div>
        </div>
      {/if}
      <!-- suggested events -->

      <!-- invitation widget -->
      {if $user->_data['can_invite_users']}
        <div class="relative overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300/70 bg-linear-to-br from-info/15 via-base-100 to-primary/20 p-5">
          <span class="pointer-events-none absolute -end-12 -top-12 size-40 rounded-full bg-primary/25 blur-3xl" aria-hidden="true"></span>
          <span class="pointer-events-none absolute -bottom-14 -start-10 size-36 rounded-full bg-info/25 blur-3xl" aria-hidden="true"></span>
          <div class="relative flex items-center gap-4">
            {$_invite_icon = ''}{if $system['system_theme_icons'] == 'svg'}{$_invite_icon = 'invitation'|theme_module_icon:'size-14 shrink-0'}{/if}
            {if $_invite_icon}
              {$_invite_icon}
            {else}
              <span class="flex size-14 shrink-0 items-center justify-center rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-info/15 text-info">
                <span class="icon-[tabler--mail-heart] size-7" aria-hidden="true"></span>
              </span>
            {/if}
            <div class="min-w-0">
              <h2 class="text-base font-semibold">{__("Invite Your Friends")}</h2>
              <p class="mt-1 text-xs text-base-content/60">{__("Bring your friends to join you here")}</p>
            </div>
          </div>
          <a class="heroui button button--primary relative mt-5 w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/settings/invitations">
            <span class="icon-[tabler--send] size-4.5 rtl:-scale-x-100" aria-hidden="true"></span>{__("Invite Friends")}
          </a>
        </div>
      {/if}
      <!-- invitation widget -->

      <!-- mini footer -->
      {include file='_footer_mini.tpl'}
      <!-- mini footer -->

    </div>
  </aside>
  <!-- right panel -->

</div>
<!-- newsfeed -->

{include file='_footer.tpl'}
