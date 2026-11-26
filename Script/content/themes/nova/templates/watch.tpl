{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {if $view == "category"}
    {include file='__page_header.tpl' _title=__($current_category['category_name']) _text=__($system['system_description_watch']) _image="watch.svg"}
  {elseif $view == "following"}
    {include file='__page_header.tpl' _title=__("Watch") _text=__("Videos from people you follow") _image="watch.svg"}
  {else}
    {include file='__page_header.tpl' _title=__("Watch") _text=__($system['system_description_watch']) _image="watch.svg"}
  {/if}
  <!-- page heading -->

  <!-- tabs -->
  <div class="mt-6 border-b border-base-300">
    <nav class="tabs tabs-bordered gap-2 sm:flex-wrap sm:gap-x-6" aria-label="{__("Watch")}">
      <a class="tab -mb-px h-11 min-w-0 flex-1 justify-center gap-1.5 px-0 text-sm font-medium sm:flex-none sm:shrink-0 sm:justify-start{if $view != "following" && $view != "manage"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/watch" {if $view != "following" && $view != "manage"}aria-current="page"{/if}>
        <span class="icon-[tabler--compass] size-4 shrink-0" aria-hidden="true"></span>
        <span class="truncate" title="{__("Discover")}">{__("Discover")}</span>
      </a>
      {if $user->_logged_in}
        <a class="tab -mb-px h-11 min-w-0 flex-1 justify-center gap-1.5 px-0 text-sm font-medium sm:flex-none sm:shrink-0 sm:justify-start{if $view == "following"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/watch/following" {if $view == "following"}aria-current="page"{/if}>
          <span class="icon-[tabler--user-check] size-4 shrink-0" aria-hidden="true"></span>
          {if $system['friends_enabled']}
            <span class="truncate sm:hidden" title="{__("Following")}">{__("Following")}</span>
            <span class="hidden truncate sm:inline" title="{__("Friends & Following")}">{__("Friends & Following")}</span>
          {else}
            <span class="truncate" title="{__("Following")}">{__("Following")}</span>
          {/if}
        </a>
        <a class="tab -mb-px h-11 min-w-0 flex-1 justify-center gap-1.5 px-0 text-sm font-medium sm:flex-none sm:shrink-0 sm:justify-start{if $view == "manage"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/watch/manage" {if $view == "manage"}aria-current="page"{/if}>
          <span class="icon-[tabler--video] size-4 shrink-0" aria-hidden="true"></span>
          <span class="truncate" title="{__("My Videos")}">{__("My Videos")}</span>
        </a>
      {/if}
    </nav>
  </div>
  <!-- tabs -->

  <!-- toolbar -->
  <div class="mt-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <form class="js_search-form w-full sm:max-w-sm" data-filter="posts" data-type="video" role="search">
      <label class="input w-full">
        <span class="icon-[tabler--search] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
        <input type="search" class="grow" name="query" placeholder='{__("Search for videos")}' aria-label='{__("Search for videos")}'>
      </label>
    </form>
    {if $system['newsfeed_location_filter_enabled'] && $view != "manage"}
      <div class="dropdown relative z-30 inline-flex [&.open]:z-[34] w-full sm:w-auto [--placement:bottom-start] [--strategy:absolute] sm:[--placement:bottom-end] sm:[--strategy:fixed]">
        <button id="watch-country-filter" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:bg-base-200 sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false">
          {if !$selected_country}<span class="icon-[tabler--world] size-4 shrink-0" aria-hidden="true"></span>{/if}
          <span class="min-w-0 grow truncate text-start sm:max-w-32 sm:grow-0" title="{if $selected_country}{$selected_country['country_name_with_flag']}{else}{__("All Countries")}{/if}">{if $selected_country}{$selected_country['country_name_with_flag']}{else}{__("All Countries")}{/if}</span>
          <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
        </button>
        <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 w-full min-w-56 overflow-y-auto p-1 sm:w-auto" role="menu" aria-labelledby="watch-country-filter">
          <a class="dropdown-item{if !$selected_country} dropdown-active{else} text-inherit!{/if}" role="menuitem" href="?country=all">{__("All Countries")}</a>
          {foreach $countries as $country}
            <a class="dropdown-item{if $selected_country && $selected_country['country_id'] == $country['country_id']} dropdown-active{else} text-inherit!{/if}" role="menuitem" href="?country={$country['country_name_native']}">{$country['country_name_with_flag']}</a>
          {/foreach}
        </div>
      </div>
    {/if}
  </div>
  <!-- toolbar -->

  <div class="grid gap-6{if $view != "following" && $view != "manage"} mt-3 lg:mt-6 lg:grid-cols-[15rem_minmax(0,1fr)] lg:items-start{else} mt-6{/if}">

    {if $view != "following" && $view != "manage"}
    <!-- categories -->
    <aside class="lg:sticky lg:top-24">
      <!-- categories dropdown -->
      <div class="dropdown relative z-20 flex w-full lg:hidden [--placement:bottom-start] [--strategy:absolute]">
        <button id="watch-categories-dropdown" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 hover:bg-primary/5 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false">
          <span class="icon-[tabler--category-2] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
          <span class="min-w-0 grow truncate text-start" title="{if $view == "category"}{__($current_category['category_name'])}{else}{__("Categories")}{/if}">{if $view == "category"}{__($current_category['category_name'])}{else}{__("Categories")}{/if}</span>
          <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
        </button>
        <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 w-full overflow-y-auto p-1" role="menu" aria-labelledby="watch-categories-dropdown">
          {if $view != "category"}
            <a class="dropdown-item dropdown-active" role="menuitem" href="{$system['system_url']}/watch" aria-current="page">{__("All")}</a>
          {elseif $current_category['parent']}
            <a class="dropdown-item text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5" role="menuitem" href="{$system['system_url']}/watch/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
              <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
              <span class="truncate" title="{__($current_category['parent']['category_name'])}">{__($current_category['parent']['category_name'])}</span>
            </a>
          {else}
            <a class="dropdown-item text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5" role="menuitem" href="{$system['system_url']}/watch">
              {if $current_category['sub_categories']}
                <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
              {/if}
              {__("All")}
            </a>
          {/if}
          {foreach $categories as $category}
            <a class="dropdown-item{if $view == "category" && $current_category['category_id'] == $category['category_id']} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$system['system_url']}/watch/category/{$category['category_id']}/{$category['category_url']}" {if $view == "category" && $current_category['category_id'] == $category['category_id']}aria-current="page"{/if}>
              <span class="grow truncate" title="{__($category['category_name'])}">{__($category['category_name'])}</span>
              {if $category['sub_categories']}
                <span class="icon-[tabler--chevron-right] size-4 shrink-0 opacity-50 rtl:rotate-180" aria-hidden="true"></span>
              {/if}
            </a>
          {/foreach}
        </div>
      </div>
      <!-- categories dropdown -->

      <nav class="card hidden border border-base-300 bg-base-100 shadow-none lg:flex" aria-labelledby="watch-categories-title">
        <div class="flex items-center gap-2 border-b border-base-300 px-4 py-3">
          <span class="icon-[tabler--category-2] size-4.5 text-base-content/60" aria-hidden="true"></span>
          <h2 class="text-sm font-semibold" id="watch-categories-title">{__("Categories")}</h2>
        </div>
        <ul class="menu menu-sm gap-0.5 p-2">
          {if $view != "category"}
            <li><a class="menu-active" href="{$system['system_url']}/watch" aria-current="page">{__("All")}</a></li>
          {else}
            <li>
              {if $current_category['parent']}
                <a class="text-base-content!" href="{$system['system_url']}/watch/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
                  <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                  <span class="truncate" title="{__($current_category['parent']['category_name'])}">{__($current_category['parent']['category_name'])}</span>
                </a>
              {else}
                <a class="text-base-content!" href="{$system['system_url']}/watch">
                  {if $current_category['sub_categories']}
                    <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                  {/if}
                  {__("All")}
                </a>
              {/if}
            </li>
          {/if}
          {foreach $categories as $category}
            <li>
              <a class="{if $view == "category" && $current_category['category_id'] == $category['category_id']}menu-active{else}text-base-content!{/if}" href="{$system['system_url']}/watch/category/{$category['category_id']}/{$category['category_url']}" {if $view == "category" && $current_category['category_id'] == $category['category_id']}aria-current="page"{/if}>
                <span class="grow truncate" title="{__($category['category_name'])}">{__($category['category_name'])}</span>
                {if $category['sub_categories']}
                  <span class="icon-[tabler--chevron-right] size-4 shrink-0 opacity-50 rtl:rotate-180" aria-hidden="true"></span>
                {/if}
              </a>
            </li>
          {/foreach}
        </ul>
      </nav>
    </aside>
    <!-- categories -->
    {/if}

    <!-- videos -->
    <div class="flex min-w-0 flex-col gap-4">
      {if $posts}
        <div>
          <ul class="grid grid-cols-1 gap-x-5 gap-y-7 sm:grid-cols-2 xl:grid-cols-3">
            {foreach $posts as $post}
              {include file='__feeds_video.tpl'}
            {/foreach}
          </ul>
          <div class="see-more js_see-more mt-8 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="{if $view == "following"}watch_following{elseif $view == "manage"}watch_manage{else}watch{/if}" data-filter="video" {if $current_category}data-category="{$current_category['category_id']}" {/if} data-country="{if $selected_country}{$selected_country['country_id']}{else}all{/if}">
            <span>{__("See More")}</span>
            <div class="loading loading-spinner loading-sm hidden"></div>
          </div>
        </div>
      {else}
        <div class="card border border-base-300 bg-base-100 shadow-none">
          {include file='_no_data.tpl' _empty_icon="icon-[tabler--video]"}
        </div>
      {/if}
    </div>
    <!-- videos -->

  </div>

</div>
<!-- page content -->

{include file='_footer.tpl'}
