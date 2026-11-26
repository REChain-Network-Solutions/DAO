{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="flex min-w-0 flex-col gap-6 pb-8 sm:pb-12">
  {include file='__page_profile_header.tpl'}
  {include file='__page_nav.tpl'}
  {if $view == ''}
    <div class="grid min-w-0 items-start gap-6 lg:grid-cols-[23rem_minmax(0,1fr)]">
      <aside class="min-w-0"><div class="accordion"><div class="accordion-item" id="page-details"><button type="button" id="page-details-toggle" class="accordion-toggle flex w-full items-center justify-between rounded-3xl bg-base-100 px-4 py-3 text-sm font-medium lg:hidden" aria-controls="page-details-content" aria-expanded="false"><span class="flex items-center gap-2"><span class="icon-[tabler--info-circle] size-5 text-base-content/60" aria-hidden="true"></span>{__("About")}</span><span class="icon-[tabler--chevron-down] size-4 accordion-item-active:rotate-180" aria-hidden="true"></span></button><div id="page-details-content" class="accordion-content hidden overflow-hidden transition-[height] duration-300 motion-reduce:transition-none lg:block! lg:h-auto! lg:overflow-visible" role="region" aria-label='{__("About")}'><div class="pt-5 lg:pt-0">{include file='__page_details.tpl'}</div></div></div></div></aside>
      <div class="min-w-0 space-y-5">{if $spage['i_admin']}{include file='__publisher_trigger.tpl' _handle="page" _id=$spage['page_id'] _name=$spage['page_title'] _avatar=$spage['page_picture'] _target=""}{/if}{if $pinned_post}{include file='_pinned_post.tpl' post=$pinned_post}{/if}{include file='_posts.tpl' _get="posts_page" _id=$spage['page_id']}</div>
    </div>
  {elseif in_array($view, ['photos','albums','album','videos','reels'])}
    {if $spage['needs_subscription']}
      <div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">{include file='_need_subscription.tpl' node_type='page' node_id=$spage['page_id'] price=$spage['page_monetization_min_price'] discount_enabled=$spage['page_monetization_discount_enabled'] discount_percent=$spage['page_monetization_discount_percent']}</div>
    {else}
      <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
        {if $view == 'videos'}
          {include file='__section_head.tpl' _title=__("Videos") _group="videos" _base="`$system['system_url']`/pages/`$spage['page_name']`"}
        {elseif $view == 'reels'}
          {include file='__section_head.tpl' _title=__("Reels") _group="videos" _base="`$system['system_url']`/pages/`$spage['page_name']`"}
        {else}
          {include file='__section_head.tpl' _title=__("Photos") _group="photos" _base="`$system['system_url']`/pages/`$spage['page_name']`"}
        {/if}
        <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
          {if $view == 'album'}
            {include file='__profile_album.tpl'}
          {elseif $view == 'photos'}
            {if $spage['photos']}<div><ul class="grid grid-cols-2 gap-3 sm:grid-cols-3 xl:grid-cols-4">{foreach $spage['photos'] as $photo}{include file='__profile_media.tpl' _kind='photo' _context='photos'}{/foreach}</ul><button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-tpl="list" data-get="photos" data-id="{$spage['page_id']}" data-type="page"><span>{__("See More")}</span><i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i></button></div>{else}{capture name=page_empty}{$spage['page_title']} {__("doesn't have photos")}{/capture}{include file='_no_data.tpl' _empty_icon='icon-[tabler--photo]' _empty_title=$smarty.capture.page_empty}{/if}
          {elseif $view == 'albums'}
            {if $spage['albums']}<div><ul class="grid grid-cols-2 gap-3 sm:grid-cols-3 xl:grid-cols-4">{foreach $spage['albums'] as $album}{include file='__profile_media.tpl' _kind='album'}{/foreach}</ul>{if count($spage['albums']) >= $system['max_results_even']}<button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-tpl="list" data-get="albums" data-id="{$spage['page_id']}" data-type="page"><span>{__("See More")}</span><i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i></button>{/if}</div>{else}{capture name=page_empty}{$spage['page_title']} {__("doesn't have albums")}{/capture}{include file='_no_data.tpl' _empty_icon='icon-[tabler--album]' _empty_title=$smarty.capture.page_empty}{/if}
          {elseif $view == 'videos'}
            {if $spage['videos']}<div><ul class="grid grid-cols-1 gap-3 sm:grid-cols-3 xl:grid-cols-4">{foreach $spage['videos'] as $video}{include file='__profile_media.tpl' _kind='video'}{/foreach}</ul><button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-tpl="list" data-get="videos" data-id="{$spage['page_id']}" data-type="page"><span>{__("See More")}</span><i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i></button></div>{else}{capture name=page_empty}{$spage['page_title']} {__("doesn't have videos")}{/capture}{include file='_no_data.tpl' _empty_icon='icon-[tabler--video]' _empty_title=$smarty.capture.page_empty}{/if}
          {elseif $view == 'reels'}
            {if $spage['reels']}<div><ul class="grid grid-cols-1 gap-3 sm:grid-cols-3 xl:grid-cols-4">{foreach $spage['reels'] as $video}{include file='__profile_media.tpl' _kind='video' _is_reel=true}{/foreach}</ul><button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-tpl="list" data-get="videos_reels" data-id="{$spage['page_id']}" data-type="page"><span>{__("See More")}</span><i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i></button></div>{else}{capture name=page_empty}{$spage['page_title']} {__("doesn't have reels")}{/capture}{include file='_no_data.tpl' _empty_icon='icon-[tabler--movie]' _empty_title=$smarty.capture.page_empty}{/if}
          {/if}
        </div>
      </section>
    {/if}
  {elseif $view == 'blogs' || $view == 'listings'}
    {if $spage['needs_subscription']}<div class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">{include file='_need_subscription.tpl' node_type='page' node_id=$spage['page_id'] price=$spage['page_monetization_min_price'] discount_enabled=$spage['page_monetization_discount_enabled'] discount_percent=$spage['page_monetization_discount_percent']}</div>{else}<section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">{capture assign="_section_title"}{if $view == 'blogs'}{__("Blogs")}{else}{__("Listings")}{/if}{/capture}{capture assign="_section_actions"}<form class="relative w-full sm:w-72" action="{$system['system_url']}/pages/{$spage['page_name']}/search" method="get"><span class="icon-[tabler--search] pointer-events-none absolute start-3.5 top-1/2 size-4.5 -translate-y-1/2 text-base-content/50" aria-hidden="true"></span><input type="text" name="query" class="h-10 w-full rounded-full bg-base-content/5 ps-10 pe-4 text-sm outline-none transition-shadow placeholder:text-base-content/50 focus:ring-2 focus:ring-primary/30 max-md:text-base" aria-label='{__("Search")}' placeholder="{__("Search")}"><input type="hidden" name="filter" value="{if $view == 'blogs'}article{else}product{/if}"></form>{/capture}{include file='__section_head.tpl' _title=$_section_title _actions=$_section_actions}<div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">{if $posts}<div><ul class="{if $view == 'blogs'}blogs-grid{/if} grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">{if $view == 'blogs'}{foreach $posts as $blog}{include file='__feeds_blog.tpl'}{/foreach}{else}{foreach $posts as $post}{include file='__feeds_product.tpl'}{/foreach}{/if}</ul><button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="{if $view == 'blogs'}blogs_page{else}products_page{/if}" {if $view == 'blogs'}data-target-stream=".blogs-grid"{/if} data-id="{$spage['page_id']}"><span>{__("See More")}</span><i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i></button></div>{else}{include file='_no_data.tpl' _empty_icon='icon-[tabler--inbox]'}{/if}</div></section>{/if}
  {elseif $view == 'reviews'}
    <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">{capture assign="_section_title"}{__("Reviews")}{/capture}{include file='__section_head.tpl' _title=$_section_title}<div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">{if $spage['reviews_count'] > 0}<div>{if $spage['reviews_details']}{$_reviews_details = $spage['reviews_details']}<div class="mb-5 grid gap-5 rounded-box bg-[#F9F9F9] p-5 sm:grid-cols-[auto_minmax(0,1fr)] sm:items-center sm:gap-8 sm:p-6 dark:bg-base-200"><div class="flex flex-col items-center text-center sm:px-6"><span class="text-5xl leading-none font-bold tabular-nums">{$_reviews_details['average']|number_format:1}</span><span class="mt-3 inline-flex items-center gap-0.5">{include file='__stars_rate.tpl' rate=$_reviews_details['average'] _size="size-5"}</span><span class="mt-2 text-sm text-base-content/60">{$_reviews_details['total']} {__("Reviews")}</span></div><ul class="m-0 list-none space-y-2 p-0">{for $_stars=5 to 1 step -1}{$_stars_row = $_reviews_details["`$_stars`_stars"]}<li class="flex items-center gap-3 text-xs"><span class="inline-flex w-7 shrink-0 items-center gap-1 font-semibold tabular-nums">{$_stars}<span class="icon-[tabler--star-filled] size-3.5 text-warning" aria-hidden="true"></span></span><span class="h-2 flex-1 overflow-hidden rounded-full bg-base-content/10"><span class="block h-full rounded-full bg-warning" style="width: {$_stars_row['percentage']}%"></span></span><span class="w-8 shrink-0 text-end tabular-nums text-base-content/60">{$_stars_row['count']}</span></li>{/for}</ul></div>{/if}<ul class="grid grid-cols-1 gap-4 lg:grid-cols-2">{foreach $spage['reviews'] as $_review}{include file='__page_review.tpl'}{/foreach}</ul>{if $spage['reviews_count'] >= $system['max_results_even']}<button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="reviews" data-tpl="list" data-id="{$spage['page_id']}" data-type="page"><span>{__("See More")}</span><i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i></button>{/if}</div>{else}{capture name=page_empty}{$spage['page_title']} {__("doesn't have reviews")}{/capture}{include file='_no_data.tpl' _empty_icon='icon-[tabler--star]' _empty_title=$smarty.capture.page_empty}{/if}</div></section>
  {elseif $view == 'events'}
    <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">{capture assign="_section_title"}{__("Events")}{/capture}{capture assign="_section_actions"}{if $spage['i_admin'] && $system['events_enabled'] && $system['pages_events_enabled']}<button type="button" class="js_modal heroui button button--primary button--sm rounded-[1rem]" data-url="modules/add.php?type=event&page_id={$spage['page_id']}"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Create Event")}</button>{/if}{/capture}{include file='__section_head.tpl' _title=$_section_title _actions=$_section_actions}<div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">{if $spage['events']}<div><ul class="grid grid-cols-2 gap-4 sm:grid-cols-3 xl:grid-cols-4">{foreach $spage['events'] as $_event}{include file='__feeds_event.tpl' _tpl='box'}{/foreach}</ul>{if count($spage['events']) >= $system['max_results_even']}<button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="page_events" data-tpl="box" data-id="{$spage['page_id']}"><span>{__("See More")}</span><i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i></button>{/if}</div>{else}{include file='_no_data.tpl' _empty_icon='icon-[tabler--calendar-event]'}{/if}</div></section>
  {elseif $view == 'subscribers'}
    <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">{include file='__section_head.tpl' _title=__("Subscribers")}<div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">{if $spage['subscribers_count'] > 0}<div><ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">{foreach $spage['subscribers'] as $_user}{include file='__feeds_user.tpl' _tpl='box' _connection=$_user['connection'] _darker=true}{/foreach}</ul>{if count($spage['subscribers']) >= $system['max_results_even']}<button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="subscribers" data-tpl="box" data-uid="{$spage['page_id']}" data-type="page"><span>{__("See More")}</span><i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i></button>{/if}</div>{else}{include file='_no_data.tpl' _empty_icon='icon-[tabler--users]'}{/if}</div></section>
  {elseif $view == 'search'}
    {if $query}
      <!-- search bar -->
      <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="flex flex-wrap items-center justify-between gap-3 px-5 py-4">
          <h2 class="flex min-w-0 items-center gap-2 text-base font-semibold max-sm:w-full">
            <span class="flex size-9 shrink-0 items-center justify-center rounded-field bg-primary/10 text-primary">
              <span class="icon-[tabler--search] size-5" aria-hidden="true"></span>
            </span>
            <span class="min-w-0 truncate" title="{$query}">{__("Results for")} "{$query}"</span>
            {include file='__search_filter.tpl' _base="`$system['system_url']`/pages/`$spage['page_name']`/search"}
          </h2>
          <div class="flex w-full shrink-0 items-center gap-2 sm:w-auto">
            <button type="button" class="js_modal heroui button button--tertiary button--sm flex-1 sm:flex-none" data-url="users/search.php?type=page&id={$spage['page_id']}&query={$query|escape:'url'}">
              <span class="icon-[tabler--search] size-4" aria-hidden="true"></span>{__("Search Again")}
            </button>
            <a class="heroui button button--tertiary button--sm button--icon-only" href="{$system['system_url']}/pages/{$spage['page_name']}" aria-label='{__("Clear")}' title='{__("Clear")}'>
              <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
            </a>
          </div>
        </div>
      </section>
      <!-- search bar -->

      <!-- posts -->
      {include file='_posts.tpl' _get="posts_page" _id=$spage['page_id'] _title=__("Search Results") _query=$query _filter=$filter _no_filter=true}
      <!-- posts -->
    {else}
      <!-- search empty -->
      <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
        {include file='_no_data.tpl' _empty_icon="icon-[tabler--search]" _empty_title=__("Looking for something?") _empty_text=__("Type a word or a phrase to find posts")}
        <div class="flex justify-center px-6 pb-10">
          <button type="button" class="js_modal heroui button button--primary" data-url="users/search.php?type=page&id={$spage['page_id']}">
            <span class="icon-[tabler--search] size-4.5" aria-hidden="true"></span>{__("Search")}
          </button>
        </div>
      </section>
      <!-- search empty -->
    {/if}
  {elseif $view == 'settings'}
    {include file='__page_settings.tpl'}
  {/if}
  {if $view != ''}
    {include file='_footer.links.tpl'}
  {else}
    <div class="lg:hidden">
      {include file='_footer.links.tpl'}
    </div>
  {/if}
</div>
<!-- page content -->

{include file='_footer.tpl'}
