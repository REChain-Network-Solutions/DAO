{include file='_head.tpl'}
{include file='_header.tpl'}

{if $view == "packages"}

  <!-- page content -->
  <div class="pb-8 sm:pb-12">

    <!-- page heading -->
    <div class="mb-8">
      {include file='__page_header.tpl' _title=__("Pro Packages") _text=__("Choose the Plan That's Right for You") _image="packages.svg"}
    </div>
    <!-- page heading -->

    {if $highlight}
      <div class="alert alert-warning mb-6 flex items-start gap-3" role="alert">
        <span class="icon-[tabler--lock] size-5 shrink-0" aria-hidden="true"></span>
        <span>{__("To unlock this feature, you need to upgrade to a Pro package")}</span>
      </div>
    {/if}

    <!-- packages -->
    <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
      <div class="grid gap-px bg-base-300 {if $packages_count >= 4}sm:grid-cols-2 xl:grid-cols-4{elseif $packages_count == 3}md:grid-cols-3{elseif $packages_count == 2}md:grid-cols-2{/if}">
        {foreach $packages as $package}
          <div class="flex flex-col gap-6 p-6 {if $package['package_popular']}bg-base-100 bg-linear-to-br from-primary/20 via-primary/5 to-secondary/10 shadow-[inset_0_3px_0_0_var(--color-primary)]{else}bg-base-100{/if}">
            <div class="flex items-start justify-between gap-3">
              <img class="size-10 shrink-0 object-contain" src="{$package['icon']}" alt="">
              {if $package['package_popular']}
                <span class="badge badge-primary badge-sm rounded-full">
                  <span class="icon-[tabler--flame] size-3.5" aria-hidden="true"></span>{__("Popular")}
                </span>
              {/if}
            </div>
            <div class="space-y-2">
              <h2 class="text-base font-semibold{if $package['package_popular']} text-primary{/if}">{__($package['name'])}</h2>
              {include file='__package_price.tpl'}
              {if $package['custom_description']}
                <p class="text-sm text-base-content/60">{__($package['custom_description'])|nl2br}</p>
              {/if}
            </div>
            <ul class="flex flex-col gap-2.5 text-sm text-base-content *:flex *:items-start *:gap-2">
              {include file='__package_highlights.tpl'}
            </ul>
            <div class="mt-auto">
              {if $package['package_popular']}
                {include file='__package_cta.tpl' _class="heroui button button--primary w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]"}
              {else}
                {include file='__package_cta.tpl' _class="heroui button button--tertiary text-base-content w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]"}
              {/if}
            </div>
          </div>
        {/foreach}
      </div>
    </div>
    <!-- packages -->

    <!-- compare -->
    <section class="mt-8" id="compare">
      <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--list-check]" _title=__("Compare Packages") _text=""}
        <div class="overflow-x-auto">
          <table class="table w-full text-sm">
            <thead class="normal-case tracking-normal">
              <tr>
                <th class="min-w-48"></th>
                {foreach $packages as $package}
                  <th class="min-w-36 text-center{if $package['package_popular']} bg-linear-to-b from-primary/20 to-primary/5 shadow-[inset_0_3px_0_0_var(--color-primary)]{/if}">
                    <div class="font-semibold{if $package['package_popular']} text-primary{/if}">{__($package['name'])}</div>
                    <div class="mt-1 text-xl font-semibold text-base-content">{if $package['price'] == 0}{__("Free")}{else}{print_money($package['price'])}{/if}</div>
                    <div class="text-xs font-normal text-base-content/60">{if $package['period'] == "life"}{__("Life Time")}{else}{__("for")} {if $package['period_num'] != '1'}{$package['period_num']} {/if}{__($package['period']|ucfirst)}{/if}</div>
                  </th>
                {/foreach}
              </tr>
            </thead>
            <tbody class="text-base-content">
              <tr>
                <td class="font-medium">{__("Featured member")}</td>
                {foreach $packages as $package}
                  {include file='__package_cell.tpl' _enabled=true _value="" _popular=$package['package_popular']}
                {/foreach}
              </tr>
              {if $system['packages_ads_free_enabled']}
                <tr>
                  <td class="font-medium">{__("No Ads")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=true _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              <tr>
                <td class="font-medium">{__("Verified Badge")}</td>
                {foreach $packages as $package}
                  {include file='__package_cell.tpl' _enabled=$package['verification_badge_enabled'] _value="" _popular=$package['package_popular']}
                {/foreach}
              </tr>
              <tr>
                <td class="font-medium">{__("Free Points")}</td>
                {foreach $packages as $package}
                  {capture assign="_value"}{if $package['free_points'] > 0}{$package['free_points']}{/if}{/capture}
                  {include file='__package_cell.tpl' _enabled=($package['free_points'] > 0) _value=$_value _popular=$package['package_popular']}
                {/foreach}
              </tr>
              <tr>
                <td class="font-medium">{__("Posts Promotion")}</td>
                {foreach $packages as $package}
                  {capture assign="_value"}{if $package['boost_posts_enabled']}{$package['boost_posts']} {__("Posts")}{/if}{/capture}
                  {include file='__package_cell.tpl' _enabled=$package['boost_posts_enabled'] _value=$_value _popular=$package['package_popular']}
                {/foreach}
              </tr>
              <tr>
                <td class="font-medium">{__("Pages Promotion")}</td>
                {foreach $packages as $package}
                  {capture assign="_value"}{if $package['boost_pages_enabled']}{$package['boost_pages']} {__("Pages")}{/if}{/capture}
                  {include file='__package_cell.tpl' _enabled=$package['boost_pages_enabled'] _value=$_value _popular=$package['package_popular']}
                {/foreach}
              </tr>
              <tr>
                <td class="font-medium">{__("Groups Promotion")}</td>
                {foreach $packages as $package}
                  {capture assign="_value"}{if $package['boost_groups_enabled']}{$package['boost_groups']} {__("Groups")}{/if}{/capture}
                  {include file='__package_cell.tpl' _enabled=$package['boost_groups_enabled'] _value=$_value _popular=$package['package_popular']}
                {/foreach}
              </tr>
              <tr>
                <td class="font-medium">{__("Events Promotion")}</td>
                {foreach $packages as $package}
                  {capture assign="_value"}{if $package['boost_events_enabled']}{$package['boost_events']} {__("Events")}{/if}{/capture}
                  {include file='__package_cell.tpl' _enabled=$package['boost_events_enabled'] _value=$_value _popular=$package['package_popular']}
                {/foreach}
              </tr>
              {if $system['pages_enabled']}
                <tr>
                  <td class="font-medium">{__("Create Pages")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['pages_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['groups_enabled']}
                <tr>
                  <td class="font-medium">{__("Create Groups")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['groups_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['events_enabled']}
                <tr>
                  <td class="font-medium">{__("Create Events")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['events_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['reels_enabled']}
                <tr>
                  <td class="font-medium">{__("Can Add Reels")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['reels_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              <tr>
                <td class="font-medium">{__("Watch Videos")}</td>
                {foreach $packages as $package}
                  {capture assign="_value"}{if $package['watch_permission']}{if $package['allowed_videos_categories'] == '0'}{__("All")}{else}{$package['allowed_videos_categories']}{/if} {__("Categories")}{/if}{/capture}
                  {include file='__package_cell.tpl' _enabled=$package['watch_permission'] _value=$_value _popular=$package['package_popular']}
                {/foreach}
              </tr>
              {if $system['blogs_enabled']}
                <tr>
                  <td class="font-medium">{__("Create Blogs")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['blogs_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['blogs_enabled']}
                <tr>
                  <td class="font-medium">{__("Read Blogs")}</td>
                  {foreach $packages as $package}
                    {capture assign="_value"}{if $package['blogs_permission_read']}{if $package['allowed_blogs_categories'] == '0'}{__("All")}{else}{$package['allowed_blogs_categories']}{/if} {__("Categories")}{/if}{/capture}
                    {include file='__package_cell.tpl' _enabled=$package['blogs_permission_read'] _value=$_value _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['market_enabled']}
                <tr>
                  <td class="font-medium">{__("Sell Products")}</td>
                  {foreach $packages as $package}
                    {capture assign="_value"}{if $package['market_permission']}{if $package['allowed_products'] == '0'}{__("Unlimited")}{else}{$package['allowed_products']} {__("Products")}{/if}{/if}{/capture}
                    {include file='__package_cell.tpl' _enabled=$package['market_permission'] _value=$_value _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['offers_enabled']}
                <tr>
                  <td class="font-medium">{__("Create Offers")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['offers_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['offers_enabled']}
                <tr>
                  <td class="font-medium">{__("Read Offers")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['offers_permission_read'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['jobs_enabled']}
                <tr>
                  <td class="font-medium">{__("Create Jobs")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['jobs_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['dating_enabled']}
                <tr>
                  <td class="font-medium">{__("Dating: Unlimited Swipes")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['dating_unlimited_swipes_enabled'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
                <tr>
                  <td class="font-medium">{__("Dating: See Who Liked You")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['dating_likes_list_enabled'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
                <tr>
                  <td class="font-medium">{__("Dating: Rewind")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['dating_rewind_enabled'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
                <tr>
                  <td class="font-medium">{__("Dating: Incognito Mode")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['dating_incognito_enabled'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
                <tr>
                  <td class="font-medium">{__("Dating: Monthly Super Likes")}</td>
                  {foreach $packages as $package}
                    {capture assign="_value"}{if $package['dating_super_likes']}{$package['dating_super_likes']}{/if}{/capture}
                    {include file='__package_cell.tpl' _enabled=$package['dating_super_likes'] _value=$_value _popular=$package['package_popular']}
                  {/foreach}
                </tr>
                <tr>
                  <td class="font-medium">{__("Dating: Monthly Boosts")}</td>
                  {foreach $packages as $package}
                    {capture assign="_value"}{if $package['dating_boosts']}{$package['dating_boosts']}{/if}{/capture}
                    {include file='__package_cell.tpl' _enabled=$package['dating_boosts'] _value=$_value _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['courses_enabled']}
                <tr>
                  <td class="font-medium">{__("Create Courses")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['courses_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['forums_enabled']}
                <tr>
                  <td class="font-medium">{__("Add Forums Threads/Replies")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['forums_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['movies_enabled']}
                <tr>
                  <td class="font-medium">{__("Watch Movies")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['movies_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['games_enabled']}
                <tr>
                  <td class="font-medium">{__("Play Games")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['games_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['gifts_enabled']}
                <tr>
                  <td class="font-medium">{__("Send Gifts")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['gifts_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['stories_enabled']}
                <tr>
                  <td class="font-medium">{__("Add Stories")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['stories_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              <tr>
                <td class="font-medium">{__("Add Posts")}</td>
                {foreach $packages as $package}
                  {include file='__package_cell.tpl' _enabled=$package['posts_permission'] _value="" _popular=$package['package_popular']}
                {/foreach}
              </tr>
              <tr>
                <td class="font-medium">{__("Add Comments")}</td>
                {foreach $packages as $package}
                  {include file='__package_cell.tpl' _enabled=$package['comments_permission'] _value="" _popular=$package['package_popular']}
                {/foreach}
              </tr>
              {if $system['posts_schedule_enabled']}
                <tr>
                  <td class="font-medium">{__("Schedule Posts")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['schedule_posts_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['anonymous_mode']}
                <tr>
                  <td class="font-medium">{__("Add Anonymous Posts")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['anonymous_posts_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['collaborative_posts_enabled']}
                <tr>
                  <td class="font-medium">{__("Add Collaborative Posts")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['collaborative_posts_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['rich_text_posts_enabled']}
                <tr>
                  <td class="font-medium">{__("Add Rich Text Posts")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['rich_text_posts_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['colored_posts_enabled']}
                <tr>
                  <td class="font-medium">{__("Add Colored Posts")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['colored_posts_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['activity_posts_enabled']}
                <tr>
                  <td class="font-medium">{__("Add Feelings/Activity Posts")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['activity_posts_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['polls_enabled']}
                <tr>
                  <td class="font-medium">{__("Add Polls Posts")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['polls_posts_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['geolocation_enabled']}
                <tr>
                  <td class="font-medium">{__("Add Geolocation Posts")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['geolocation_posts_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['gif_enabled']}
                <tr>
                  <td class="font-medium">{__("Add GIF Posts")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['gif_posts_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['ai_posts_enabled']}
                <tr>
                  <td class="font-medium">{__("Generate AI Posts")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['ai_posts_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['ai_blogs_enabled']}
                <tr>
                  <td class="font-medium">{__("Generate AI Blogs")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['ai_blogs_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['ai_images_enabled']}
                <tr>
                  <td class="font-medium">{__("Generate AI Images")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['ai_images_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['audio_call_enabled']}
                <tr>
                  <td class="font-medium">{__("Make Audio Calls")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['audio_call_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['video_call_enabled']}
                <tr>
                  <td class="font-medium">{__("Make Video Calls")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['video_call_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['live_enabled']}
                <tr>
                  <td class="font-medium">{__("Go Live")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['live_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['videos_enabled']}
                <tr>
                  <td class="font-medium">{__("Upload Videos")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['videos_upload_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['audio_enabled']}
                <tr>
                  <td class="font-medium">{__("Upload Audios")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['audios_upload_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['file_enabled']}
                <tr>
                  <td class="font-medium">{__("Upload Files")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['files_upload_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['ads_enabled']}
                <tr>
                  <td class="font-medium">{__("Create Ads")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['ads_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['funding_enabled']}
                <tr>
                  <td class="font-medium">{__("Raise Funding")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['funding_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['monetization_enabled']}
                <tr>
                  <td class="font-medium">{__("Monetize Content")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['monetization_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              {if $system['tips_enabled']}
                <tr>
                  <td class="font-medium">{__("Receive Tips")}</td>
                  {foreach $packages as $package}
                    {include file='__package_cell.tpl' _enabled=$package['tips_permission'] _value="" _popular=$package['package_popular']}
                  {/foreach}
                </tr>
              {/if}
              <tr>
                <td></td>
                {foreach $packages as $package}
                  <td class="text-center{if $package['package_popular']} bg-primary/5{/if}">
                    {if $package['package_popular']}
                      {include file='__package_cta.tpl' _class="heroui button button--primary button--sm w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]"}
                    {else}
                      {include file='__package_cta.tpl' _class="heroui button button--tertiary text-base-content button--sm w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]"}
                    {/if}
                  </td>
                {/foreach}
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </section>
    <!-- compare -->

  </div>
  <!-- page content -->

{elseif $view == "upgraded"}

  <!-- page content -->
  <div class="pb-8 sm:pb-12">
    <div class="card mx-auto max-w-xl border border-base-300 bg-base-100 shadow-none">
      <div class="card-body items-center gap-4 py-10 text-center">
        <span class="inline-flex size-16 items-center justify-center rounded-full bg-success/10 text-success" aria-hidden="true">
          <span class="icon-[tabler--rosette-discount-check] size-9"></span>
        </span>
        <h1 class="text-2xl font-semibold">{__("Congratulations")}!</h1>
        <p class="text-base-content/70">
          {__("You are now")} <span class="badge badge-soft badge-primary rounded-full">{__($user->_data['package_name'])}</span> {__("member")}
        </p>
        {if $user->_data['can_pick_categories']}
          <p class="text-sm text-base-content/70">{__("Your package allows you to pick categories that you are interested in")}</p>
          <div class="flex flex-wrap justify-center gap-2">
            {if $user->_data['allowed_videos_categories'] > 0}
              <span class="badge badge-soft badge-secondary rounded-full">{$user->_data['allowed_videos_categories']} {__("Videos Categories")}</span>
            {/if}
            {if $user->_data['allowed_blogs_categories'] > 0}
              <span class="badge badge-soft badge-secondary rounded-full">{$user->_data['allowed_blogs_categories']} {__("Blogs Categories")}</span>
            {/if}
          </div>
          <a class="heroui button button--primary mt-2 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/settings/membership">{__("Pick Categories")}</a>
        {else}
          <a class="heroui button button--primary mt-2 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}">{__("Start Now")}</a>
        {/if}
      </div>
    </div>
  </div>
  <!-- page content -->

{/if}

{include file='_footer.tpl'}