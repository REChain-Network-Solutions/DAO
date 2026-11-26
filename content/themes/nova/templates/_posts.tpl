<!-- posts-filter -->
{if !$_no_filter}
  <div class="posts-filter mb-4 flex flex-wrap items-center gap-3 border-b border-base-300 pb-3 text-sm font-semibold">
    {if in_array($_get, ['newsfeed', 'popular', 'discover'])}
      {if !$system['popular_posts_enabled'] && !$system['discover_posts_enabled']}
        <span>{if $_title}{$_title}{else}{__("Recent Updates")}{/if}</span>
      {else}
        <select class="select select-sm js_newsfeed-nav h-9 min-h-9 w-auto py-0" aria-label="{if $_title}{$_title}{else}{__("Recent Updates")}{/if}">
          <option value="{$system['system_url']}"{if $_get == "newsfeed"} selected{/if}>{__("Recent Updates")}</option>
          {if $system['popular_posts_enabled']}
            <option value="{$system['system_url']}/popular"{if $_get == "popular"} selected{/if}>{__("Popular Posts")}</option>
          {/if}
          {if $system['discover_posts_enabled']}
            <option value="{$system['system_url']}/discover"{if $_get == "discover"} selected{/if}>{__("Discover Posts")}</option>
          {/if}
        </select>
      {/if}
    {else}
      <span>{if $_title}{$_title}{else}{__("Recent Updates")}{/if}</span>
    {/if}

    <div class="ms-auto flex flex-wrap items-center gap-2">

      <!-- newsfeed location filter -->
      {if $system['newsfeed_location_filter_enabled'] && in_array($page, ['index', 'group', 'event']) && !in_array($view, ['scheduled', 'boosted_posts']) && !$_filter}
        {include file='__countries_filter.tpl'}
      {/if}
      <!-- newsfeed location filter -->

      {if $user->_logged_in && !$_filter && !$_query}
        {include file='__posts_filter.tpl'}
      {elseif $_filter == "article"}
        {if $system['blogs_enabled']}
          <a href="{$system['system_url']}/blogs/new" class="heroui button button--primary button--sm">
            {__("Create Blog")}
          </a>
        {/if}
      {elseif $_filter == "product" && !$_query}
        {if $system['market_enabled'] && !in_array($_get, ['posts_page', 'posts_group', 'posts_event'])}
          <button type="button" class="js_modal heroui button button--primary button--sm" data-url="posts/product.php?do=create">
            {__("Create Product")}
          </button>
        {/if}
      {elseif $_filter == "funding"}
        {if $system['funding_enabled'] && !in_array($_get, ['posts_page', 'posts_group', 'posts_event'])}
          <button type="button" class="js_modal heroui button button--primary button--sm" data-url="posts/funding.php?do=create">
            {__("Create Funding")}
          </button>
        {/if}

      {elseif $_filter == "offer"}
        {if $system['offers_enabled'] && !in_array($_get, ['posts_page', 'posts_group', 'posts_event'])}
          <button type="button" class="js_modal heroui button button--primary button--sm" data-url="posts/offer.php?do=create">
            {__("Create Offer")}
          </button>
        {/if}

      {elseif $_filter == "job"}
        {if $system['jobs_enabled'] && !in_array($_get, ['posts_page', 'posts_group', 'posts_event'])}
          <button type="button" class="js_modal heroui button button--primary button--sm" data-url="posts/job.php?do=create">
            {__("Create Job")}
          </button>
        {/if}

      {elseif $_filter == "course"}
        {if $system['courses_enabled'] && !in_array($_get, ['posts_page', 'posts_group', 'posts_event'])}
          <button type="button" class="js_modal heroui button button--primary button--sm" data-url="posts/course.php?do=create">
            {__("Create Course")}
          </button>
        {/if}
      {/if}

    </div>
  </div>
{/if}
<!-- posts-filter -->

<!-- posts-loader -->
<div class="post hidden js_posts_loader overflow-hidden rounded-box bg-base-100 p-4" aria-hidden="true">
  <div class="post-body with-loader animate-pulse">
    <div class="flex items-center gap-3">
      <div class="size-14 shrink-0 rounded-box bg-base-200"></div>
      <div class="min-w-0 grow space-y-2">
        <div class="h-3 w-2/5 rounded-full bg-base-200"></div>
        <div class="h-2.5 w-1/4 rounded-full bg-base-200"></div>
      </div>
    </div>
    <div class="mt-4 space-y-2">
      <div class="h-3 w-full rounded-full bg-base-200"></div>
      <div class="h-3 w-4/5 rounded-full bg-base-200"></div>
    </div>
    <div class="mt-5 flex gap-2 border-t border-base-300 pt-3">
      <div class="h-10 flex-1 rounded-field bg-base-200"></div>
      <div class="h-10 flex-1 rounded-field bg-base-200"></div>
      <div class="h-10 flex-1 rounded-field bg-base-200"></div>
    </div>
  </div>
</div>
<!-- posts-loader -->

<!-- posts staging -->
<button class="posts-staging-btn js_view-staging-posts heroui button button--primary fixed bottom-24 start-1/2 z-30 hidden -translate-x-1/2 rounded-full shadow-lg md:bottom-6">
  {__("View")} <span>0</span> {__("New Posts")}
</button>

<div class="js_posts_stream_staging" style="display: none;"></div>
<!-- posts staging -->

<!-- posts stream -->
<div class="js_posts_stream" data-get="{$_get}" data-filter="{if $_filter}{$_filter}{else}all{/if}" {if $_category}data-category="{$_category}" {/if} data-country="{if $selected_country}{$selected_country['country_id']}{else}all{/if}" {if $_id}data-id="{$_id}" {/if} {if $_query}data-query="{$_query}" {/if}>
  {if $posts}
    <ul class="flex flex-col gap-5">
      <!-- posts -->
      {foreach $posts as $post}
        {include file='__feeds_post.tpl' _get=$_get}
      {/foreach}
      <!-- posts -->
    </ul>

    <!-- see-more -->
    <div class="see-more js_see-more js_see-more-infinite mt-5 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="{if $_load_more}{$_load_more}{else}{$_get}{/if}" data-filter="{if $_filter}{$_filter}{else}all{/if}" {if $_category}data-category="{$_category}" {/if} data-country="{if $selected_country}{$selected_country['country_id']}{else}all{/if}" {if $_id}data-id="{$_id}" {/if} {if $_query}data-query="{$_query}" {/if}>
      <span>{__("More Stories")}</span>
      <div class="loading loading-spinner loading-sm hidden"></div>
    </div>
    <!-- see-more -->
  {else}
    <ul>
      <li class="rounded-box bg-base-100 p-4">
        {if $_get == "memories"}
          {include file='_no_data.tpl' _empty_icon="icon-[tabler--history]" _empty_title=__("No memories today") _empty_text=__("Posts you shared on this day in previous years will show up here")}
        {elseif $_query}
          {include file='_no_data.tpl' _empty_icon="icon-[tabler--search-off]" _empty_title=__("No result found")}
        {else}
          {include file='_no_data.tpl' _empty_icon="icon-[tabler--news]" _empty_title=__("No posts yet") _empty_text=__("Follow people and pages to see their posts here")}
        {/if}
      </li>
    </ul>
  {/if}
</div>
<!-- posts stream -->
