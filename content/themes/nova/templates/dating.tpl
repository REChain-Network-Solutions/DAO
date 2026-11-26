{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {if $view == "browse"}
    {include file='__page_header.tpl' _title=__("Dating") _text=__("Browse members matching your filters") _image="dating.svg"}
  {elseif $view == "likes"}
    {include file='__page_header.tpl' _title=__("Dating") _text=__("See the members who liked you") _image="dating.svg"}
  {elseif $view == "matches"}
    {include file='__page_header.tpl' _title=__("Dating") _text=__("Start a conversation with your matches") _image="dating.svg"}
  {elseif $view == "profile"}
    {include file='__page_header.tpl' _title=__("Dating") _text=__("Manage your dating profile and preferences") _image="dating.svg"}
  {else}
    {include file='__page_header.tpl' _title=__("Dating") _text=__("Meet new people and find your match") _image="dating.svg"}
  {/if}
  <!-- page heading -->

  {if $dating_ready}
    <!-- tabs -->
    <div class="mt-6 border-b border-base-300">
      <nav class="tabs tabs-bordered gap-1 sm:flex-wrap sm:gap-x-6" aria-label='{__("Dating")}'>
        <a class="tab relative -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == ""} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/dating" {if $view == ""}aria-current="page" {/if}>
          <span class="icon-[tabler--cards] size-4" aria-hidden="true"></span>
          <span class="max-w-full truncate" title="{__("Discover")}">{__("Discover")}</span>
        </a>
        <a class="tab relative -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "browse"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/dating/browse" {if $view == "browse"}aria-current="page" {/if}>
          <span class="icon-[tabler--layout-grid] size-4" aria-hidden="true"></span>
          <span class="max-w-full truncate" title="{__("Browse")}">{__("Browse")}</span>
        </a>
        <a class="tab relative -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "likes"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/dating/likes" {if $view == "likes"}aria-current="page" {/if}>
          <span class="icon-[tabler--heart] size-4" aria-hidden="true"></span>
          <span class="max-w-full truncate" title="{__("Likes")}">{__("Likes")}</span>
          {if $dating_likes_count}
            <span class="badge badge-primary badge-sm absolute top-1 start-1/2 ms-1.5 rounded-full sm:static sm:ms-0">{if $dating_likes_count >= 100}99+{else}{$dating_likes_count}{/if}</span>
          {/if}
        </a>
        <a class="tab relative -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "matches"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/dating/matches" {if $view == "matches"}aria-current="page" {/if}>
          <span class="icon-[tabler--heart-handshake] size-4" aria-hidden="true"></span>
          <span class="max-w-full truncate" title="{__("Matches")}">{__("Matches")}</span>
        </a>
        <a class="tab relative -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "profile"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/dating/profile" {if $view == "profile"}aria-current="page" {/if}>
          <span class="icon-[tabler--user-heart] size-4" aria-hidden="true"></span>
          <span class="max-w-full truncate" title="{__("My Profile")}">{__("My Profile")}</span>
        </a>
      </nav>
    </div>
    <!-- tabs -->
  {/if}

  {if $view == ""}

    <!-- discover -->
    <div class="mt-6 grid gap-6 lg:grid-cols-[minmax(0,26rem)_minmax(0,1fr)] lg:items-start">
      <div class="mx-auto flex w-full max-w-md flex-col gap-4">
        <!-- deck -->
        <div class="js_dating-deck relative isolate mb-10 mt-6 aspect-[3/4] w-full [&>article]:z-0 [&>article:first-of-type]:z-10 [&>article:nth-of-type(n+2)]:pointer-events-none [&>article:nth-of-type(n+2)]:origin-top [&>article:nth-of-type(2)]:-translate-y-3 [&>article:nth-of-type(2)]:scale-[0.94] [&>article:nth-of-type(2)]:brightness-75 [&>article:nth-of-type(3)]:-z-10 [&>article:nth-of-type(3)]:-translate-y-6 [&>article:nth-of-type(3)]:scale-[0.88] [&>article:nth-of-type(3)]:brightness-50 [&>article:nth-of-type(n+4)]:hidden [&:not(:has(article))>.js\_dating-actions]:hidden">
          {include file='ajax.dating.cards.tpl'}
          <div class="js_dating-empty absolute inset-0 hidden flex-col items-center justify-center rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-dashed border-base-300 bg-base-100 [&:not(.hidden)]:flex">
            {include file='_no_data.tpl' _empty_icon="icon-[tabler--cards]" _empty_title=__("You have seen everyone for now") _empty_text=__("Widen your preferences or check back later") _empty_compact=true}
            <a class="heroui button button--tertiary text-base-content button--sm rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/dating/profile">{__("Edit Preferences")}</a>
          </div>
          <div class="js_dating-limit absolute inset-0 z-40 hidden flex-col items-center justify-center rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-base-100 [&:not(.hidden)]:flex">
            {include file='_no_data.tpl' _empty_icon="icon-[tabler--hourglass]" _empty_title=__("You are out of swipes for today") _empty_text=__("Come back tomorrow for more") _empty_compact=true}
            {if $dating_upgrade}
              <a class="heroui button button--primary button--sm rounded-full" href="{$system['system_url']}/packages">{__("Get Unlimited Swipes")}</a>
            {/if}
          </div>

          <!-- actions -->
          <div class="js_dating-actions absolute inset-x-0 -bottom-8 z-30 flex items-center justify-center gap-3">
            {if $user->dating_feature_available('rewind')}
              <button type="button" class="heroui button button--tertiary button--icon-only rounded-full size-12 border-0 bg-linear-to-b from-slate-500 to-slate-700 shadow-slate-700/40 text-white shadow-lg transition-transform hover:scale-110 active:scale-95 js_dating-rewind" title='{__("Undo")}' aria-label='{__("Undo")}'>
                <span class="icon-[tabler--arrow-back-up] size-5" aria-hidden="true"></span>
              </button>
            {/if}
            <button type="button" class="heroui button button--tertiary button--icon-only rounded-full size-16 border-0 bg-linear-to-b from-sky-400 to-blue-500 shadow-blue-500/40 text-white shadow-lg transition-transform hover:scale-110 active:scale-95 js_dating-swipe" data-action="pass" title='{__("Pass")}' aria-label='{__("Pass")}'>
              <span class="icon-[tabler--x] size-8" aria-hidden="true"></span>
            </button>
            <button type="button" class="heroui button button--tertiary button--icon-only rounded-full size-16 border-0 bg-linear-to-b from-rose-400 to-red-500 shadow-red-500/40 text-white shadow-lg transition-transform hover:scale-110 active:scale-95 js_dating-swipe" data-action="like" title='{__("Like")}' aria-label='{__("Like")}'>
              <span class="icon-[tabler--heart-filled] size-8" aria-hidden="true"></span>
            </button>
            {if $user->dating_feature_available('super_likes')}
              <button type="button" class="heroui button button--tertiary button--icon-only rounded-full size-12 border-0 bg-linear-to-b from-amber-300 to-orange-400 shadow-orange-400/40 text-white shadow-lg transition-transform hover:scale-110 active:scale-95 js_dating-swipe" data-action="super" title='{__("Super Like")}' aria-label='{__("Super Like")}'>
                <span class="icon-[tabler--star-filled] size-5" aria-hidden="true"></span>
              </button>
            {/if}
            {if $dating_paid && $system['dating_priority_message_price'] > 0}
              <button type="button" class="heroui button button--tertiary button--icon-only rounded-full size-12 border-0 bg-linear-to-b from-fuchsia-400 to-violet-600 shadow-violet-600/40 text-white shadow-lg transition-transform hover:scale-110 active:scale-95 js_dating-message" title='{__("Send a Message")}' aria-label='{__("Send a Message")}'>
                <span class="icon-[tabler--message-heart] size-5" aria-hidden="true"></span>
                </button>
            {/if}
          </div>
          <!-- actions -->
        </div>
        <!-- deck -->

        <div class="hidden items-center justify-center gap-4 text-xs text-base-content/50 lg:flex" aria-hidden="true">
          <span class="flex items-center gap-1.5"><kbd class="kbd kbd-sm">←</kbd>{__("Pass")}</span>
          {if $user->dating_feature_available('super_likes')}
            <span class="flex items-center gap-1.5"><kbd class="kbd kbd-sm">↑</kbd>{__("Super Like")}</span>
          {/if}
          <span class="flex items-center gap-1.5"><kbd class="kbd kbd-sm">→</kbd>{__("Like")}</span>
        </div>

        <div class="mt-2 lg:hidden">
          {include file='__dating_plan.tpl'}
        </div>
      </div>

      <!-- details -->
      <div class="hidden min-w-0 flex-col gap-6 lg:flex">
        <aside class="relative isolate flex min-w-0 flex-col gap-7 rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[3rem] bg-base-100 p-6 xl:p-8">
          <section class="js_dating-detail flex flex-col gap-7"></section>
          {include file='__dating_plan.tpl'}
        </aside>
        {include file='_ads.tpl'}
      </div>
      <!-- details -->
    </div>
    <!-- discover -->

  {elseif $view == "browse"}

    <!-- browse -->
    <div class="mt-6 grid gap-6 lg:grid-cols-[18rem_minmax(0,1fr)] lg:items-start">
      <!-- filters -->
      <aside class="flex flex-col gap-6 lg:sticky lg:top-24" aria-label='{__("Find Your Match")}'>
        <section class="card border border-base-300 bg-base-100 shadow-none">
          <form action="{$system['system_url']}/dating/browse" method="get">
            {include file='__settings_card_header.tpl' _icon="icon-[tabler--heart-search]" _title=__("Find Your Match") _text=__("Search by what matters to you") _text_class="text-xs"}
            <div class="card-body gap-4 pt-5">
              <div class="w-full {if $system['genders_disabled']}hidden{/if}">
                <label class="label-text mb-1.5 block" for="dating-gender">{__("Looking For")}</label>
                <select id="dating-gender" class="select w-full" name="gender">
                  <option value="">{__("My Preference")}</option>
                  {foreach $genders as $_gender}
                    <option {if $filters['gender'] == $_gender['gender_id']}selected{/if} value="{$_gender['gender_id']}">{$_gender['gender_name']}</option>
                  {/foreach}
                </select>
              </div>
              <div class="grid grid-cols-2 gap-3">
                <div class="min-w-0">
                  <label class="label-text mb-1.5 block" for="dating-min-age">{__("Min Age")}</label>
                  <input id="dating-min-age" type="number" class="input w-full" name="min_age" min="{$system['dating_min_age']}" max="99" value="{if $filters['min_age']}{$filters['min_age']}{else}{$dating_profile['min_age']}{/if}">
                </div>
                <div class="min-w-0">
                  <label class="label-text mb-1.5 block" for="dating-max-age">{__("Max Age")}</label>
                  <input id="dating-max-age" type="number" class="input w-full" name="max_age" min="{$system['dating_min_age']}" max="99" value="{if $filters['max_age']}{$filters['max_age']}{else}{$dating_profile['max_age']}{/if}">
                </div>
              </div>
              {if $dating_profile['latitude'] !== null && !$system['dating_worldwide']}
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="dating-distance">{__("Distance")}</label>
                  <input type="range" class="range range-primary range-sm [--color-neutral:var(--color-base-content)]" min="1" max="{$system['dating_max_distance']}" name="distance_slider" value="{if $filters['distance']}{$filters['distance']}{else}{$dating_profile['max_distance']}{/if}" oninput="this.form.distance.value=this.value" aria-label='{__("Distance")}'>
                  <label class="input mt-2 w-full">
                    <input id="dating-distance" type="number" class="grow" min="1" max="{$system['dating_max_distance']}" name="distance" value="{if $filters['distance']}{$filters['distance']}{else}{$dating_profile['max_distance']}{/if}" oninput="this.form.distance_slider.value=this.value">
                    <span class="my-auto ms-2 shrink-0 text-sm text-base-content/60">{if $system['system_distance'] == "mile"}{__("ML")}{else}{__("KM")}{/if}</span>
                  </label>
                </div>
              {/if}
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="dating-city">{__("City")}</label>
                <input id="dating-city" type="text" class="input w-full" name="city" value="{$filters['city']}">
              </div>
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="dating-interest">{__("Interest")}</label>
                <select id="dating-interest" class="select w-full" name="interest">
                  <option value="">{__("Any")}</option>
                  {foreach $dating_interests as $_interest}
                    <option {if $filters['interest'] == $_interest['interest_id']}selected{/if} value="{$_interest['interest_id']}">{$_interest['icon']} {__($_interest['title'])}</option>
                  {/foreach}
                </select>
              </div>
            </div>
            <div class="card-footer border-t border-base-300 pt-5">
              <button type="submit" class="heroui button button--primary button--full-width">
                <span class="icon-[tabler--search] size-4" aria-hidden="true"></span>
                {__("Search")}
              </button>
            </div>
          </form>
        </section>
        {include file='_ads.tpl'}
      </aside>
      <!-- filters -->

      <!-- members -->
      <div class="min-w-0">
        {if $members}
          <ul class="grid grid-cols-1 gap-4 sm:grid-cols-3">
            {foreach $members as $card}
              {include file='__dating_grid_card.tpl'}
            {/foreach}
          </ul>
          {if $cursor}
            <div class="see-more js_see-more mt-6 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="dating_browse" data-cursor="{$cursor}" data-filter="{$filters_query|escape:'html'}">
              <span>{__("See More")}</span>
              <div class="loading loading-spinner loading-sm hidden"></div>
            </div>
          {/if}
        {else}
          <div class="card border border-base-300 bg-base-100 shadow-none">
            {include file='_no_data.tpl' _empty_icon="icon-[tabler--user-search]" _empty_title=__("No members match your search") _empty_text=__("Try changing your filters")}
          </div>
        {/if}
      </div>
      <!-- members -->
    </div>
    <!-- browse -->

  {elseif $view == "likes"}

    <!-- likes -->
    <div class="mt-6 flex flex-col gap-6">
      {if !$can_see_likes && $dating_likes_count}
        <!-- likes locked -->
        <section class="relative overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-primary/20 bg-base-100">
          <span class="pointer-events-none absolute inset-0 bg-linear-to-br from-primary/15 via-primary/5 to-transparent" aria-hidden="true"></span>
          <span class="pointer-events-none absolute -end-16 -top-24 size-72 rounded-full bg-primary/15 blur-3xl" aria-hidden="true"></span>
          <div class="relative grid items-center gap-8 p-6 sm:p-10 md:grid-cols-[minmax(0,1fr)_18rem]">
            <div class="min-w-0">
              <span class="badge badge-soft badge-primary rounded-full">
                <span class="icon-[tabler--heart-filled] size-3.5" aria-hidden="true"></span>
                {__("Likes")}
              </span>
              <h2 class="mt-4 text-2xl font-bold tracking-tight sm:text-3xl">
                <span class="text-primary">{if $dating_likes_count >= 100}99+{else}{$dating_likes_count}{/if}</span> {if $dating_likes_count == 1}{__("member liked you")}{else}{__("members liked you")}{/if}
              </h2>
              {if $system['packages_enabled']}
                <p class="mt-2 max-w-md text-base-content/70">{__("Upgrade your plan to see who they are and match right away")}</p>
                <ul class="mt-5 flex flex-col gap-2.5 text-sm">
                  <li class="flex items-center gap-2.5">
                    <span class="icon-[tabler--circle-check-filled] size-5 shrink-0 text-primary" aria-hidden="true"></span>
                    {__("See everyone who liked you")}
                  </li>
                  <li class="flex items-center gap-2.5">
                    <span class="icon-[tabler--circle-check-filled] size-5 shrink-0 text-primary" aria-hidden="true"></span>
                    {__("Like back and match instantly")}
                  </li>
                  <li class="flex items-center gap-2.5">
                    <span class="icon-[tabler--circle-check-filled] size-5 shrink-0 text-primary" aria-hidden="true"></span>
                    {__("Never miss someone who is into you")}
                  </li>
                </ul>
                <a class="heroui button button--primary mt-6 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/packages">
                  <span class="icon-[tabler--crown] size-4" aria-hidden="true"></span>
                  {__("Upgrade to See Them")}
                </a>
              {else}
                <p class="mt-2 max-w-md text-base-content/70">{__("Keep swiping, when you like them back it is a match")}</p>
                <a class="heroui button button--primary mt-6 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/dating">
                  <span class="icon-[tabler--cards] size-4" aria-hidden="true"></span>
                  {__("Go to Discover")}
                </a>
              {/if}
            </div>
            <div class="relative mx-auto hidden h-48 w-64 md:block" aria-hidden="true">
              <span class="absolute flex h-40 w-28 items-center justify-center rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] border-4 border-base-100 bg-linear-to-br shadow-lg start-2 top-6 -rotate-12 from-rose-400 to-orange-300">
                <span class="icon-[tabler--lock] size-8 text-white/90"></span>
              </span>
              <span class="absolute flex h-40 w-28 items-center justify-center rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] border-4 border-base-100 bg-linear-to-br shadow-lg end-2 top-6 rotate-12 from-sky-400 to-indigo-400">
                <span class="icon-[tabler--lock] size-8 text-white/90"></span>
              </span>
              <span class="absolute flex h-40 w-28 items-center justify-center rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] border-4 border-base-100 bg-linear-to-br shadow-lg inset-x-0 top-1 z-10 mx-auto from-primary to-fuchsia-500">
                <span class="icon-[tabler--heart-filled] size-8 text-white/90"></span>
              </span>
            </div>
          </div>
        </section>
        <!-- likes locked -->
      {/if}
      {if $members}
        <div>
          <ul class="grid grid-cols-1 gap-4 sm:grid-cols-3 lg:grid-cols-4">
            {foreach $members as $card}
              {include file='__dating_grid_card.tpl'}
            {/foreach}
          </ul>
          {if $cursor}
            <div class="see-more js_see-more mt-6 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="dating_likes" data-cursor="{$cursor}">
              <span>{__("See More")}</span>
              <div class="loading loading-spinner loading-sm hidden"></div>
            </div>
          {/if}
        </div>
      {elseif $can_see_likes || !$dating_likes_count}
        <div class="card border border-base-300 bg-base-100 shadow-none">
          {include file='_no_data.tpl' _empty_icon="icon-[tabler--heart]" _empty_title=__("No likes yet") _empty_text=__("When someone likes your profile, they will show up here")}
        </div>
      {/if}
    </div>
    <!-- likes -->

  {elseif $view == "matches"}

    <!-- matches -->
    <div class="mt-6">
      {if $matches}
        <ul class="grid grid-cols-1 gap-4 sm:grid-cols-3 lg:grid-cols-4">
          {foreach $matches as $match}
            {include file='__dating_grid_card.tpl' card=$match _matched=true}
          {/foreach}
        </ul>
        {if $cursor}
          <div class="see-more js_see-more mt-6 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="dating_matches" data-cursor="{$cursor}">
            <span>{__("See More")}</span>
            <div class="loading loading-spinner loading-sm hidden"></div>
          </div>
        {/if}
      {else}
        <div class="card border border-base-300 bg-base-100 shadow-none">
          {include file='_no_data.tpl' _empty_icon="icon-[tabler--heart-handshake]" _empty_title=__("No matches yet") _empty_text=__("Keep swiping, your matches will show up here")}
        </div>
      {/if}
    </div>
    <!-- matches -->

  {elseif $view == "profile"}

    {include file='__dating_profile.tpl'}

  {/if}

</div>
<!-- page content -->

{include file='_footer.tpl'}
