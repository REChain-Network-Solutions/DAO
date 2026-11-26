{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {if $view == "category"}
    {include file='__page_header.tpl' _title=__($current_category['category_name']) _text=__($current_category['category_description']) _image="pages.svg"}
  {elseif $view == "liked"}
    {include file='__page_header.tpl' _title=__("Pages") _text=__("Pages you have liked") _image="pages.svg"}
  {elseif $view == "manage"}
    {include file='__page_header.tpl' _title=__("Pages") _text=__("Pages you manage") _image="pages.svg"}
  {else}
    {include file='__page_header.tpl' _title=__("Pages") _text=__($system['system_description_pages']) _image="pages.svg"}
  {/if}
  <!-- page heading -->

  <!-- tabs -->
  <div class="mt-6 flex flex-col gap-4 sm:flex-row sm:flex-wrap sm:items-end sm:justify-between sm:gap-3 sm:border-b sm:border-base-300">
    <nav class="tabs tabs-bordered gap-1 border-b border-base-300 sm:gap-6 sm:border-b-0" aria-label='{__("Pages")}'>
      <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "" || $view == "category"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/pages" {if $view == "" || $view == "category"}aria-current="page"{/if}>
        <span class="icon-[tabler--compass] size-4 shrink-0" aria-hidden="true"></span>
        <span class="max-w-full truncate" title="{__("Discover")}">{__("Discover")}</span>
      </a>
      {if $user->_logged_in}
        <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "liked"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/pages/liked" {if $view == "liked"}aria-current="page"{/if}>
          <span class="icon-[tabler--heart] size-4 shrink-0" aria-hidden="true"></span>
          <span class="max-w-full truncate" title="{__("Liked Pages")}">{__("Liked Pages")}</span>
        </a>
        <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "manage"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/pages/manage" {if $view == "manage"}aria-current="page"{/if}>
          <span class="icon-[tabler--briefcase] size-4 shrink-0" aria-hidden="true"></span>
          <span class="max-w-full truncate" title="{__("My Pages")}">{__("My Pages")}</span>
        </a>
      {/if}
    </nav>
    {if $system['pages_enabled']}
      <button type="button" class="heroui button button--primary button--sm w-full sm:mb-2 sm:w-auto js_modal rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="modules/add.php?type=page">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Create Page")}
      </button>
    {/if}
  </div>
  <!-- tabs -->

  <!-- toolbar -->
  <div class="mt-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <form class="js_search-form w-full sm:max-w-sm" data-filter="pages" role="search">
      <label class="input w-full">
        <span class="icon-[tabler--search] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
        <input type="search" class="grow" name="query" placeholder='{__("Search for pages")}' aria-label='{__("Search for pages")}'>
      </label>
    </form>
    <div class="flex flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-center sm:gap-2">
      {if $system['pages_location_filter_enabled']}
        <!-- country filter -->
        <div class="dropdown relative z-30 inline-flex [&.open]:z-[34] w-full sm:w-auto [--placement:bottom-start] [--strategy:absolute] sm:[--placement:bottom-end] sm:[--strategy:fixed]">
          <button id="pages-country-filter" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 sm:w-auto hover:bg-primary/5 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false">
            {if !$selected_country}<span class="icon-[tabler--world] size-4 shrink-0" aria-hidden="true"></span>{/if}
            <span class="min-w-0 grow truncate text-start sm:max-w-32 sm:grow-0" title="{if $selected_country}{$selected_country['country_name_with_flag']}{else}{__("All Countries")}{/if}">{if $selected_country}{$selected_country['country_name_with_flag']}{else}{__("All Countries")}{/if}</span>
            <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
          </button>
          <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 w-full min-w-56 overflow-y-auto p-1 sm:w-auto" role="menu" aria-labelledby="pages-country-filter">
            <a class="dropdown-item{if !$selected_country} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?country=all{if $selected_language}&language={$selected_language['code']}{/if}">{__("All Countries")}</a>
            {foreach $countries as $country}
              <a class="dropdown-item{if $selected_country && $selected_country['country_id'] == $country['country_id']} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?country={$country['country_name_native']}{if $selected_language}&language={$selected_language['code']}{/if}">{$country['country_name_with_flag']}</a>
            {/foreach}
          </div>
        </div>
        <!-- country filter -->
      {/if}

      <!-- language filter -->
      <div class="dropdown relative z-30 inline-flex [&.open]:z-[34] w-full sm:w-auto [--placement:bottom-start] [--strategy:absolute] sm:[--placement:bottom-end] sm:[--strategy:fixed]">
        <button id="pages-language-filter" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 sm:w-auto hover:bg-primary/5 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false">
          <span class="icon-[tabler--language] size-4 shrink-0" aria-hidden="true"></span>
          <span class="min-w-0 grow truncate text-start sm:max-w-32 sm:grow-0" title="{if $selected_language}{$selected_language['title']}{else}{__("All Languages")}{/if}">{if $selected_language}{$selected_language['title']}{else}{__("All Languages")}{/if}</span>
          <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
        </button>
        <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 w-full min-w-56 overflow-y-auto p-1 sm:w-auto" role="menu" aria-labelledby="pages-language-filter">
          <a class="dropdown-item{if !$selected_language} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?language=all{if $selected_country}&country={$selected_country['country_name']}{/if}">{__("All Languages")}</a>
          {foreach $languages as $language}
            <a class="dropdown-item{if $selected_language && $selected_language['code'] == $language['code']} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?language={$language['code']}{if $selected_country}&country={$selected_country['country_name']}{/if}">{$language['title']}</a>
          {/foreach}
        </div>
      </div>
      <!-- language filter -->
    </div>
  </div>
  <!-- toolbar -->

  {assign var="_pages_discovery" value=($view == "" || $view == "category")}

  <div class="grid gap-6{if $_pages_discovery} mt-3 lg:mt-6 lg:grid-cols-[15rem_minmax(0,1fr)]{else} mt-6{/if} lg:items-start">

    {if $_pages_discovery}
      <!-- categories -->
      <aside class="lg:sticky lg:top-24">
        <!-- categories dropdown -->
        <div class="dropdown relative z-20 flex w-full lg:hidden [--placement:bottom-start] [--strategy:absolute]">
          <button id="pages-categories-dropdown" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 hover:bg-primary/5 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false">
            <span class="icon-[tabler--category-2] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
            <span class="min-w-0 grow truncate text-start" title="{if $view == "category"}{__($current_category['category_name'])}{else}{__("Categories")}{/if}">{if $view == "category"}{__($current_category['category_name'])}{else}{__("Categories")}{/if}</span>
            <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
          </button>
          <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 w-full overflow-y-auto p-1" role="menu" aria-labelledby="pages-categories-dropdown">
            {if $view != "category"}
              <a class="dropdown-item dropdown-active" role="menuitem" href="{$system['system_url']}/pages" aria-current="page">{__("All")}</a>
            {elseif $current_category['parent']}
              <a class="dropdown-item text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5" role="menuitem" href="{$system['system_url']}/pages/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
                <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                <span class="truncate" title="{__($current_category['parent']['category_name'])}">{__($current_category['parent']['category_name'])}</span>
              </a>
            {else}
              <a class="dropdown-item text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5" role="menuitem" href="{$system['system_url']}/pages">
                {if $current_category['sub_categories']}
                  <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                {/if}
                {__("All")}
              </a>
            {/if}
            {foreach $categories as $category}
              <a class="dropdown-item{if $view == "category" && $current_category['category_id'] == $category['category_id']} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$system['system_url']}/pages/category/{$category['category_id']}/{$category['category_url']}" {if $view == "category" && $current_category['category_id'] == $category['category_id']}aria-current="page"{/if}>
                <span class="grow truncate" title="{__($category['category_name'])}">{__($category['category_name'])}</span>
                {if $category['sub_categories']}
                  <span class="icon-[tabler--chevron-right] size-4 shrink-0 opacity-50 rtl:rotate-180" aria-hidden="true"></span>
                {/if}
              </a>
            {/foreach}
          </div>
        </div>
        <!-- categories dropdown -->

        <nav class="card hidden border border-base-300 bg-base-100 shadow-none lg:flex" aria-labelledby="pages-categories-title">
          <div class="flex items-center gap-2 border-b border-base-300 px-4 py-3">
            <span class="icon-[tabler--category-2] size-4.5 text-base-content/60" aria-hidden="true"></span>
            <h2 class="text-sm font-semibold" id="pages-categories-title">{__("Categories")}</h2>
          </div>
          <ul class="menu menu-sm gap-0.5 p-2">
            {if $view != "category"}
              <li><a class="menu-active" href="{$system['system_url']}/pages" aria-current="page">{__("All")}</a></li>
            {else}
              <li>
                {if $current_category['parent']}
                  <a class="text-base-content!" href="{$system['system_url']}/pages/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
                    <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                    <span class="truncate" title="{__($current_category['parent']['category_name'])}">{__($current_category['parent']['category_name'])}</span>
                  </a>
                {else}
                  <a class="text-base-content!" href="{$system['system_url']}/pages">
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
                <a class="{if $view == "category" && $current_category['category_id'] == $category['category_id']}menu-active{else}text-base-content!{/if}" href="{$system['system_url']}/pages/category/{$category['category_id']}/{$category['category_url']}" {if $view == "category" && $current_category['category_id'] == $category['category_id']}aria-current="page"{/if}>
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

    <!-- pages -->
    <div class="flex min-w-0 flex-col gap-6">
      {if $view == "" && $promoted_pages}
        <!-- promoted -->
        <section class="flex flex-col gap-4" aria-labelledby="pages-promoted-title">
          <h2 id="pages-promoted-title" class="flex items-center gap-2 text-lg font-semibold">
            <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-warning/15 text-base-content" aria-hidden="true">
              <span class="icon-[tabler--speakerphone] size-4.5"></span>
            </span>
            {__("Promoted Pages")}
          </h2>
          <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
            {foreach $promoted_pages as $_page}
              {include file='__pages_card.tpl' _promoted=true}
            {/foreach}
          </ul>
        </section>
        <!-- promoted -->
      {/if}

      <section class="flex flex-col gap-4" aria-labelledby="pages-results-title">
        <h2 id="pages-results-title" class="flex items-center gap-2 text-lg font-semibold">
          {$view_title}
          {if $total}<span class="badge badge-soft rounded-full">{$total}</span>{/if}
        </h2>

        {if $pages}
          <div>
            <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 {if $_pages_discovery}xl:grid-cols-3{else}lg:grid-cols-3 xl:grid-cols-4{/if}">
              {foreach $pages as $_page}
                {include file='__pages_card.tpl'}
              {/foreach}
            </ul>

            {if count($pages) >= $system['pages_results']}
              <!-- see-more -->
              <div class="see-more js_see-more mt-6 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="{$get}" {if $view == "category"}data-id="{$current_category['category_id']}" {/if} {if $view == "liked" || $view == "manage"}data-uid="{$user->_data['user_id']}" {/if} data-country="{if $selected_country}{$selected_country['country_id']}{else}all{/if}">
                <span>{__("See More")}</span>
                <div class="loading loading-spinner loading-sm hidden"></div>
              </div>
              <!-- see-more -->
            {/if}
          </div>
        {else}
          <div class="card border border-base-300 bg-base-100 shadow-none">
            {if $view == "liked"}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--heart]" _empty_title=__("No liked pages yet") _empty_text=__("Pages you like will appear here")}
            {elseif $view == "manage"}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--briefcase]" _empty_title=__("You don't manage any pages") _empty_text=__("Create a page to start building your audience")}
              {if $system['pages_enabled']}
                <div class="-mt-8 flex justify-center pb-10">
                  <button type="button" class="js_modal heroui button button--primary button--sm rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="modules/add.php?type=page">
                    <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
                    {__("Create Page")}
                  </button>
                </div>
              {/if}
            {else}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--flag]" _empty_title=__("No pages found") _empty_text=__("Try a different category or search")}
            {/if}
          </div>
        {/if}
      </section>
    </div>
    <!-- pages -->

  </div>

</div>
<!-- page content -->

{include file='_footer.tpl'}
