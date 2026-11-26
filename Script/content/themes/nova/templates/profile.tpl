{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="flex min-w-0 flex-col gap-6 pb-8 sm:pb-12">
  {include file='__profile_header.tpl'}
  {include file='__profile_nav.tpl'}

  <!-- profile-content -->
  <div class="grid min-w-0 items-start gap-6{if $view == "" || $view == "search"} lg:grid-cols-[23rem_minmax(0,1fr)]{/if}">

    <!-- left panel -->
    {if $view == "" || $view == "search"}
      <aside class="min-w-0">
        <!-- about -->
        <div class="accordion">
          <div class="accordion-item" id="profile-details">
            <button type="button" id="profile-details-toggle" class="accordion-toggle flex w-full items-center justify-between rounded-3xl bg-base-100 px-4 py-3 text-sm font-medium lg:hidden" aria-controls="profile-details-content" aria-expanded="false">
              <span class="flex items-center gap-2">
                <span class="icon-[tabler--info-circle] size-5 text-base-content/60" aria-hidden="true"></span>
                {__("About")}
              </span>
              <span class="icon-[tabler--chevron-down] size-4 accordion-item-active:rotate-180" aria-hidden="true"></span>
            </button>
            <div id="profile-details-content" class="accordion-content hidden overflow-hidden transition-[height] duration-300 motion-reduce:transition-none lg:block! lg:h-auto! lg:overflow-visible" role="region" aria-label='{__("About")}'>
              <div class="space-y-5 pt-5 lg:pt-0">
                {include file='__profile_completion.tpl'}
                {include file='__profile_details.tpl'}
                {include file='__profile_intro.tpl'}
              </div>
            </div>
          </div>
        </div>
        <!-- about -->
      </aside>
    {/if}
    <!-- left panel -->

    <!-- center panel -->
    <div class="min-w-0 space-y-5">
      <!-- view content -->
      {if $view == ""}

          <!-- publisher -->
          {if $user->_logged_in}
            {if $user->_data['user_id'] == $profile['user_id']}
              {include file='__publisher_trigger.tpl' _handle="me" _id="" _name=$user->_data['user_fullname'] _avatar=$user->_data['user_picture'] _target=""}
            {elseif $system['wall_posts_enabled'] && ( $profile['user_privacy_wall'] == 'friends' && $profile['we_friends'] || $profile['user_privacy_wall'] == 'public' )}
              {include file='__publisher_trigger.tpl' _handle="user" _id=$profile['user_id'] _name=$user->_data['user_fullname'] _avatar=$user->_data['user_picture'] _target=$profile['name']}
            {/if}
          {/if}
          <!-- publisher -->

          <!-- pinned post -->
          {if $pinned_post}
            {include file='_pinned_post.tpl' post=$pinned_post}
          {/if}
          <!-- pinned post -->

          <!-- posts -->
          {include file='_posts.tpl' _get="posts_profile" _id=$profile['user_id']}
          <!-- posts -->

      {elseif $view == "about"}
        {include file='__profile_details.tpl'}

      {elseif $view == "friends"}
        <!-- friends -->
        <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--users]" _title=__("Friends") _group="connections" _panel=true}
          <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
            {if $profile['friends']}
              <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {foreach $profile['friends'] as $_user}
                  {include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _top_friends=true _darker=true}
                {/foreach}
              </ul>
              {if $profile['friends_count'] >= $system['max_results_even']}
                <!-- see-more -->
                <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="friends" data-uid="{$profile['user_id']}">
                  <span>{__("See More")}</span>
                  <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                </button>
                <!-- see-more -->
              {/if}
            {else}
              {capture name=empty_text}{$profile['name']} {__("doesn't have friends")}{/capture}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--users]" _empty_title=$smarty.capture.empty_text}
            {/if}
          </div>
        </section>
        <!-- friends -->

      {elseif $view == "followers"}
        <!-- followers -->
        <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--users]" _title=__("Followers") _group="connections" _panel=true}
          <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
            {if $profile['followers']}
              <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {foreach $profile['followers'] as $_user}
                  {include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true}
                {/foreach}
              </ul>
              {if $profile['followers_count'] >= $system['max_results_even']}
                <!-- see-more -->
                <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="followers" data-uid="{$profile['user_id']}">
                  <span>{__("See More")}</span>
                  <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                </button>
                <!-- see-more -->
              {/if}
            {else}
              {capture name=empty_text}{$profile['name']} {__("doesn't have followers")}{/capture}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--users]" _empty_title=$smarty.capture.empty_text}
            {/if}
          </div>
        </section>
        <!-- followers -->

      {elseif $view == "followings"}
        <!-- followings -->
        <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--users]" _title=__("Followings") _group="connections" _panel=true}
          <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
            {if $profile['followings']}
              <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {foreach $profile['followings'] as $_user}
                  {include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true}
                {/foreach}
              </ul>
              {if $profile['followings_count'] >= $system['max_results_even']}
                <!-- see-more -->
                <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="followings" data-uid="{$profile['user_id']}">
                  <span>{__("See More")}</span>
                  <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                </button>
                <!-- see-more -->
              {/if}
            {else}
              {capture name=empty_text}{$profile['name']} {__("doesn't have followings")}{/capture}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--users]" _empty_title=$smarty.capture.empty_text}
            {/if}
          </div>
        </section>
        <!-- followings -->

      {elseif $view == "subscribers"}
        <!-- subscribers -->
        <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--user-star]" _title=__("Subscribers") _group="connections" _panel=true}
          <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
            {if $profile['subscribers']}
              <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {foreach $profile['subscribers'] as $_user}
                  {include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true}
                {/foreach}
              </ul>
              {if $profile['subscribers_count'] >= $system['max_results_even']}
                <!-- see-more -->
                <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="subscribers" data-uid="{$profile['user_id']}" data-type="user">
                  <span>{__("See More")}</span>
                  <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                </button>
                <!-- see-more -->
              {/if}
            {else}
              {capture name=empty_text}{$profile['name']} {__("doesn't have subscribers")}{/capture}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--user-star]" _empty_title=$smarty.capture.empty_text}
            {/if}
          </div>
        </section>
        <!-- subscribers -->

      {elseif $view == "subscriptions"}
        <!-- subscriptions -->
        <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--user-star]" _title=__("Subscriptions") _group="connections" _panel=true}
          <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
            {if $profile['subscriptions']}
              <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {foreach $profile['subscriptions'] as $_subscription}
                  {if $_subscription['node_type'] == "profile"}
                    {include file='__people_card.tpl' _user=$_subscription _connection='unsubscribe' _darker=true}
                  {elseif $_subscription['node_type'] == "page"}
                    {include file='__pages_card.tpl' _page=$_subscription _connection='unsubscribe' _darker=true}
                  {elseif $_subscription['node_type'] == "group"}
                    {include file='__groups_card.tpl' _group=$_subscription _connection='unsubscribe' _darker=true}
                  {/if}
                {/foreach}
              </ul>
              {if $profile['subscriptions_count'] >= $system['max_results_even']}
                <!-- see-more -->
                <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="subscriptions" data-uid="{$profile['user_id']}">
                  <span>{__("See More")}</span>
                  <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                </button>
                <!-- see-more -->
              {/if}
            {else}
              {capture name=empty_text}{$profile['name']} {__("doesn't have subscriptions")}{/capture}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--user-star]" _empty_title=$smarty.capture.empty_text}
            {/if}
          </div>
        </section>
        <!-- subscriptions -->

      {elseif $view == "photos"}
        <!-- photos -->
        {if $profile['needs_subscription']}
          <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
            {include file='_need_subscription.tpl' node_type='profile' node_id=$profile['user_id'] price=$profile['user_monetization_min_price'] discount_enabled=$profile['user_monetization_discount_enabled'] discount_percent=$profile['user_monetization_discount_percent']}
          </div>
        {else}
          <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
            {include file='__profile_section_head.tpl' _icon="icon-[tabler--photo]" _title=__("Photos") _group="photos" _panel=true}
            <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
              {if $profile['photos']}
                <ul class="grid grid-cols-2 gap-3 sm:grid-cols-3">
                  {foreach $profile['photos'] as $photo}
                    {include file='__profile_media.tpl' _kind='photo' _context="photos" _can_pin=true}
                  {/foreach}
                </ul>
                <!-- see-more -->
                <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="photos" data-tpl="list" data-id="{$profile['user_id']}" data-type='user'>
                  <span>{__("See More")}</span>
                  <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                </button>
                <!-- see-more -->
              {else}
                {capture name=empty_text}{$profile['name']} {__("doesn't have photos")}{/capture}
                {include file='_no_data.tpl' _empty_icon="icon-[tabler--photo]" _empty_title=$smarty.capture.empty_text}
              {/if}
            </div>
          </section>
        {/if}
        <!-- photos -->

      {elseif $view == "albums"}
        <!-- albums -->
        {if $profile['needs_subscription']}
          <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
            {include file='_need_subscription.tpl' node_type='profile' node_id=$profile['user_id'] price=$profile['user_monetization_min_price'] discount_enabled=$profile['user_monetization_discount_enabled'] discount_percent=$profile['user_monetization_discount_percent']}
          </div>
        {else}
          <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
            {include file='__profile_section_head.tpl' _icon="icon-[tabler--photo]" _title=__("Photos") _group="photos" _panel=true}
            <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
              {if $profile['albums']}
                <ul class="grid grid-cols-2 gap-3 sm:grid-cols-3 xl:grid-cols-4">
                  {foreach $profile['albums'] as $album}
                    {include file='__profile_media.tpl' _kind='album'}
                  {/foreach}
                </ul>
                {if count($profile['albums']) >= $system['max_results_even']}
                  <!-- see-more -->
                  <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="albums" data-tpl="list" data-id="{$profile['user_id']}" data-type='user'>
                    <span>{__("See More")}</span>
                    <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                  </button>
                  <!-- see-more -->
                {/if}
              {else}
                {capture name=empty_text}{$profile['name']} {__("doesn't have albums")}{/capture}
                {include file='_no_data.tpl' _empty_icon="icon-[tabler--library-photo]" _empty_title=$smarty.capture.empty_text}
              {/if}
            </div>
          </section>
        {/if}
        <!-- albums -->

      {elseif $view == "album"}
        <!-- album -->
        {if $profile['needs_subscription']}
          <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
            {include file='_need_subscription.tpl' node_type='profile' node_id=$profile['user_id'] price=$profile['user_monetization_min_price'] discount_enabled=$profile['user_monetization_discount_enabled'] discount_percent=$profile['user_monetization_discount_percent']}
          </div>
        {else}
          <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
            {include file='__profile_section_head.tpl' _icon="icon-[tabler--photo]" _title=__("Photos") _group="photos" _panel=true}
            <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
              {include file='__profile_album.tpl'}
            </div>
          </section>
        {/if}
        <!-- album -->

      {elseif $view == "videos"}
        <!-- videos -->
        {if $profile['needs_subscription']}
          <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
            {include file='_need_subscription.tpl' node_type='profile' node_id=$profile['user_id'] price=$profile['user_monetization_min_price'] discount_enabled=$profile['user_monetization_discount_enabled'] discount_percent=$profile['user_monetization_discount_percent']}
          </div>
        {else}
          <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
            {include file='__profile_section_head.tpl' _icon="icon-[tabler--movie]" _title=__("Videos") _group="videos" _panel=true}
            <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
              {if $profile['videos']}
                <ul class="grid grid-cols-1 gap-3 sm:grid-cols-3">
                  {foreach $profile['videos'] as $video}
                    {include file='__profile_media.tpl' _kind='video'}
                  {/foreach}
                </ul>
                <!-- see-more -->
                <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="videos" data-tpl="list" data-id="{$profile['user_id']}" data-type='user'>
                  <span>{__("See More")}</span>
                  <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                </button>
                <!-- see-more -->
              {else}
                {capture name=empty_text}{$profile['name']} {__("doesn't have videos")}{/capture}
                {include file='_no_data.tpl' _empty_icon="icon-[tabler--movie]" _empty_title=$smarty.capture.empty_text}
              {/if}
            </div>
          </section>
        {/if}
        <!-- videos -->

      {elseif $view == "reels"}
        <!-- reels -->
        {if $profile['needs_subscription']}
          <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
            {include file='_need_subscription.tpl' node_type='profile' node_id=$profile['user_id'] price=$profile['user_monetization_min_price'] discount_enabled=$profile['user_monetization_discount_enabled'] discount_percent=$profile['user_monetization_discount_percent']}
          </div>
        {else}
          <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
            {include file='__profile_section_head.tpl' _icon="icon-[tabler--brand-tiktok]" _title=__("Reels") _group="videos" _panel=true}
            <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
              {if $profile['reels']}
                <ul class="grid grid-cols-1 gap-3 sm:grid-cols-3">
                  {foreach $profile['reels'] as $video}
                    {include file='__profile_media.tpl' _kind='video' _is_reel=true}
                  {/foreach}
                </ul>
                <!-- see-more -->
                <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="videos_reels" data-tpl="list" data-id="{$profile['user_id']}" data-type='user'>
                  <span>{__("See More")}</span>
                  <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                </button>
                <!-- see-more -->
              {else}
                {capture name=empty_text}{$profile['name']} {__("doesn't have reels")}{/capture}
                {include file='_no_data.tpl' _empty_icon="icon-[tabler--brand-tiktok]" _empty_title=$smarty.capture.empty_text}
              {/if}
            </div>
          </section>
        {/if}
        <!-- reels -->

      {elseif $view == "blogs"}
        <!-- blogs -->
        <div class="min-w-0 space-y-5">
          {if $profile['needs_subscription']}
            <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
              {include file='_need_subscription.tpl' node_type='profile' node_id=$profile['user_id'] price=$profile['user_monetization_min_price'] discount_enabled=$profile['user_monetization_discount_enabled'] discount_percent=$profile['user_monetization_discount_percent']}
            </div>
          {else}
            <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
              <div class="flex flex-wrap items-center justify-between gap-3 px-5 py-3.5">
                <h2 class="text-sm font-semibold">{__("Blogs")}</h2>
                <!-- search -->
                <form class="relative w-full sm:w-72" action="{$system['system_url']}/{$profile['user_name']}/search" method="get">
                  <span class="icon-[tabler--search] pointer-events-none absolute start-3.5 top-1/2 size-4.5 -translate-y-1/2 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" name="query" class="h-10 w-full rounded-full bg-base-content/5 ps-10 pe-4 text-sm outline-none transition-shadow placeholder:text-base-content/50 focus:ring-2 focus:ring-primary/30 max-md:text-base" aria-label='{__("Search")}' placeholder="{__("Search")}">
                  <input type="hidden" name="filter" value="article">
                </form>
                <!-- search -->
              </div>
              <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
                {if $posts}
                  <ul class="blogs-grid grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                    {foreach $posts as $blog}
                      {include file='__feeds_blog.tpl'}
                    {/foreach}
                  </ul>

                  <!-- see-more -->
                  <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="blogs_profile" data-target-stream=".blogs-grid" data-id="{$profile['user_id']}">
                    <span>{__("See More")}</span>
                    <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                  </button>
                  <!-- see-more -->
                {else}
                  {include file='_no_data.tpl' _empty_icon="icon-[tabler--article]"}
                {/if}
              </div>
            </section>
          {/if}
        </div>
        <!-- blogs -->

      {elseif $view == "listings"}
        <!-- products -->
        <div class="min-w-0 space-y-5">
          {if $profile['needs_subscription']}
            <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
              {include file='_need_subscription.tpl' node_type='profile' node_id=$profile['user_id'] price=$profile['user_monetization_min_price'] discount_enabled=$profile['user_monetization_discount_enabled'] discount_percent=$profile['user_monetization_discount_percent']}
            </div>
          {else}
            <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
              <div class="flex flex-wrap items-center justify-between gap-3 px-5 py-3.5">
                <h2 class="text-sm font-semibold">{__("Listings")}</h2>
                <!-- search -->
                <form class="relative w-full sm:w-72" action="{$system['system_url']}/{$profile['user_name']}/search" method="get">
                  <span class="icon-[tabler--search] pointer-events-none absolute start-3.5 top-1/2 size-4.5 -translate-y-1/2 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" name="query" class="h-10 w-full rounded-full bg-base-content/5 ps-10 pe-4 text-sm outline-none transition-shadow placeholder:text-base-content/50 focus:ring-2 focus:ring-primary/30 max-md:text-base" aria-label='{__("Search")}' placeholder="{__("Search")}">
                  <input type="hidden" name="filter" value="product">
                </form>
                <!-- search -->
              </div>
              <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
                {if $posts}
                  <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                    {foreach $posts as $post}
                      {include file='__feeds_product.tpl'}
                    {/foreach}
                  </ul>

                  <!-- see-more -->
                  <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="products_profile" data-id="{$profile['user_id']}">
                    <span>{__("See More")}</span>
                    <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                  </button>
                  <!-- see-more -->
                {else}
                  {include file='_no_data.tpl' _empty_icon="icon-[tabler--building-store]"}
                {/if}
              </div>
            </section>
          {/if}
        </div>
        <!-- products -->

      {elseif $view == "pages"}
        <!-- pages -->
        <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--flag]" _title=__("Pages") _panel=true}
          <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
            {if ($profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_pages'] == "public" || ($profile['user_privacy_pages'] == "friends" && $profile['we_friends'])) && count($profile['pages']) > 0}
              <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {foreach $profile['pages'] as $_page}
                  {include file='__pages_card.tpl'}
                {/foreach}
              </ul>
              {if count($profile['pages']) >= $system['max_results_even']}
                <!-- see-more -->
                <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="profile_pages" data-uid="{$profile['user_id']}">
                  <span>{__("See More")}</span>
                  <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                </button>
                <!-- see-more -->
              {/if}
            {else}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--flag]"}
            {/if}
          </div>
        </section>
        <!-- pages -->

      {elseif $view == "groups"}
        <!-- groups -->
        <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--users-group]" _title=__("Groups") _panel=true}
          <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
            {if ($profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_groups'] == "public" || ($profile['user_privacy_groups'] == "friends" && $profile['we_friends'])) && count($profile['groups']) > 0}
              <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {foreach $profile['groups'] as $_group}
                  {include file='__groups_card.tpl'}
                {/foreach}
              </ul>
              {if count($profile['groups']) >= $system['max_results_even']}
                <!-- see-more -->
                <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="profile_groups" data-uid="{$profile['user_id']}">
                  <span>{__("See More")}</span>
                  <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                </button>
                <!-- see-more -->
              {/if}
            {else}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--users-group]"}
            {/if}
          </div>
        </section>
        <!-- groups -->

      {elseif $view == "events"}
        <!-- events -->
        <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--calendar-event]" _title=__("Events") _panel=true}
          <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
            {if ($profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_events'] == "public" || ($profile['user_privacy_events'] == "friends" && $profile['we_friends'])) && count($profile['events']) > 0}
              <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {foreach $profile['events'] as $_event}
                  {include file='__feeds_event.tpl' _tpl="box"}
                {/foreach}
              </ul>
              {if count($profile['events']) >= $system['max_results_even']}
                <!-- see-more -->
                <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="profile_events" data-uid="{$profile['user_id']}">
                  <span>{__("See More")}</span>
                  <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
                </button>
                <!-- see-more -->
              {/if}
            {else}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--calendar-event]"}
            {/if}
          </div>
        </section>
        <!-- events -->

      {elseif $view == "search"}
        {if $query}
          <!-- search bar -->
          <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="flex flex-wrap items-center justify-between gap-3 px-5 py-4">
              <h2 class="flex min-w-0 items-center gap-2 text-base font-semibold max-sm:w-full">
                <span class="flex size-9 shrink-0 items-center justify-center rounded-field bg-primary/10 text-primary">
                  <span class="icon-[tabler--search] size-5" aria-hidden="true"></span>
                </span>
                <span class="min-w-0 truncate" title="{$query}">{__("Results for")} "{$query}"</span>
                {include file='__search_filter.tpl' _base="`$system['system_url']`/`$profile['user_name']`/search"}
              </h2>
              <div class="flex w-full shrink-0 items-center gap-2 sm:w-auto">
                <button type="button" class="js_modal heroui button button--tertiary button--sm flex-1 sm:flex-none" data-url="users/search.php?id={$profile['user_id']}&query={$query|escape:'url'}">
                  <span class="icon-[tabler--search] size-4" aria-hidden="true"></span>{__("Search Again")}
                </button>
                <a class="heroui button button--tertiary button--sm button--icon-only" href="{$system['system_url']}/{$profile['user_name']}" aria-label='{__("Clear")}' title='{__("Clear")}'>
                  <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
                </a>
              </div>
            </div>
          </section>
          <!-- search bar -->

          <!-- posts -->
          {include file='_posts.tpl' _get="posts_profile" _id=$profile['user_id'] _title=__("Search Results") _query=$query _filter=$filter _no_filter=true}
          <!-- posts -->
        {else}
          <!-- search empty -->
          <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
            {include file='_no_data.tpl' _empty_icon="icon-[tabler--search]" _empty_title=__("Search this profile") _empty_text=__("Type a word or a phrase to find posts")}
            <div class="flex justify-center px-6 pb-10">
              <button type="button" class="js_modal heroui button button--primary" data-url="users/search.php?id={$profile['user_id']}">
                <span class="icon-[tabler--search] size-4.5" aria-hidden="true"></span>{__("Search")}
              </button>
            </div>
          </section>
          <!-- search empty -->
        {/if}

      {/if}
      <!-- view content -->

      <!-- footer links -->
      {if $view != ""}
        {include file='_footer.links.tpl'}
      {else}
        <div class="lg:hidden">
          {include file='_footer.links.tpl'}
        </div>
      {/if}
      <!-- footer links -->
    </div>
    <!-- center panel -->

  </div>
  <!-- profile-content -->
</div>
<!-- page content -->

{include file='_footer.tpl'}

{if $gift}
  <script>
    $(function() {
      modal('#gift');
    });
  </script>
{/if}
