<!-- page heading -->
{if $view == "category"}
  {include file='__page_header.tpl' _title=__($current_category['category_name']) _text=$_text _image=$_image}
{else}
  {include file='__page_header.tpl' _title=$_title _text=$_text _image=$_image}
{/if}
<!-- page heading -->

<!-- tabs -->
<div class="mt-6 flex flex-col gap-4 sm:flex-row sm:flex-wrap sm:items-end sm:justify-between sm:gap-3 sm:border-b sm:border-base-300">
  <nav class="tabs tabs-bordered gap-2 border-b border-base-300 sm:flex-wrap sm:gap-x-6 sm:border-b-0" aria-label="{$_title}">
    <a class="tab -mb-px h-11 min-w-0 flex-1 justify-center gap-1.5 px-0 text-sm font-medium sm:flex-none sm:shrink-0 sm:justify-start{if $view == "" || $view == "category" || $view == "search"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/{$_module}" {if $view == "" || $view == "category" || $view == "search"}aria-current="page"{/if}>
      <span class="icon-[tabler--compass] size-4 shrink-0" aria-hidden="true"></span>
      <span class="truncate" title="{__("Discover")}">{__("Discover")}</span>
    </a>
    {if $user->_logged_in}
      <a class="tab -mb-px h-11 min-w-0 flex-1 justify-center gap-1.5 px-0 text-sm font-medium sm:flex-none sm:shrink-0 sm:justify-start{if $view == "manage"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/{$_module}/manage" {if $view == "manage"}aria-current="page"{/if}>
        <span class="{$_my_icon} size-4 shrink-0" aria-hidden="true"></span>
        <span class="truncate" title="{$_my_label}">{$_my_label}</span>
      </a>
    {/if}
  </nav>
  {if ($_rss_href && $view != "search" && $view != "manage") || $_create_enabled}
    <div class="flex items-center gap-2 sm:mb-2">
      {if $_rss_href && $view != "search" && $view != "manage"}
        <a class="heroui button button--tertiary button--sm flex-1 bg-orange-500/10 sm:flex-none text-orange-600 hover:bg-orange-500/15 dark:text-orange-400 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$_rss_href}">
          <span class="icon-[tabler--rss] size-4" aria-hidden="true"></span>
          {__("RSS")}
        </a>
      {/if}
      {if $_create_enabled}
        {if $_create_href}
          <a class="heroui button button--primary button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$_create_href}">
            <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
            {$_create_label}
          </a>
        {else}
          <button type="button" class="heroui button button--primary button--sm flex-1 sm:flex-none js_modal rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="{$_create_url}">
            <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
            {$_create_label}
          </button>
        {/if}
      {/if}
    </div>
  {/if}
</div>
<!-- tabs -->

<!-- toolbar -->
<div class="mt-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
  <form class="js_search-form w-full sm:max-w-sm" data-handle="{$_module}" role="search">
    <label class="input w-full">
      <span class="icon-[tabler--search] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
      <input type="search" class="grow" name="query" placeholder="{$_search_placeholder}" aria-label="{$_search_placeholder}" {if $view == "search"}value="{$query}"{/if}>
    </label>
  </form>
  <div class="flex flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-center sm:gap-2">
    {if $_sort2_key}
    <!-- sort -->
    <div class="dropdown relative z-30 inline-flex w-full sm:w-auto [&.open]:z-[34] [--placement:bottom-start] [--strategy:absolute] sm:[--placement:bottom-end] sm:[--strategy:fixed]">
      <button id="{$_module}-sort-filter" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 hover:bg-primary/5 sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false">
        <span class="icon-[tabler--arrows-sort] size-4 shrink-0" aria-hidden="true"></span>
        <span class="min-w-0 grow truncate text-start sm:grow-0">{if $sort == $_sort2_key}{$_sort2_label}{elseif $sort == $_sort3_key}{$_sort3_label}{else}{__("Latest")}{/if}</span>
        <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
      </button>
      <ul class="dropdown-menu dropdown-open:opacity-100 hidden w-full min-w-48 p-1 sm:w-auto" role="menu" aria-orientation="vertical" aria-labelledby="{$_module}-sort-filter">
        <li>
          <a class="dropdown-item{if !$sort || $sort == "latest"} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?{if $selected_country}country={$selected_country['country_name']}&{/if}{if $distance}distance={$distance}&{/if}sort=latest">
            <span class="icon-[tabler--clock] size-4" aria-hidden="true"></span>
            {__("Latest")}
          </a>
        </li>
        <li>
          <a class="dropdown-item{if $sort == $_sort2_key} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?{if $selected_country}country={$selected_country['country_name']}&{/if}{if $distance}distance={$distance}&{/if}sort={$_sort2_key}">
            <span class="icon-[tabler--sort-descending] size-4" aria-hidden="true"></span>
            {$_sort2_label}
          </a>
        </li>
        <li>
          <a class="dropdown-item{if $sort == $_sort3_key} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?{if $selected_country}country={$selected_country['country_name']}&{/if}{if $distance}distance={$distance}&{/if}sort={$_sort3_key}">
            <span class="icon-[tabler--sort-ascending] size-4" aria-hidden="true"></span>
            {$_sort3_label}
          </a>
        </li>
      </ul>
    </div>
    <!-- sort -->
    {/if}

    <!-- location filter -->
    {if $user->_logged_in && $system['location_finder_enabled']}
      <div class="dropdown relative z-30 inline-flex w-full sm:w-auto [&.open]:z-[34] [--placement:bottom-start] [--strategy:absolute] sm:[--placement:bottom-end] sm:[--strategy:fixed] [--auto-close:inside]">
        <button id="{$_module}-distance-filter" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 hover:bg-primary/5 sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="dialog" aria-expanded="false">
          <span class="icon-[tabler--map-pin] size-4 shrink-0" aria-hidden="true"></span>
          <span class="min-w-0 grow truncate text-start sm:grow-0">{if $distance}{$distance} {if $system['system_distance'] == "mile"}{__("ML")}{else}{__("KM")}{/if}{else}{__("Distance")}{/if}</span>
          <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
        </button>
        <div class="dropdown-menu dropdown-open:opacity-100 hidden w-full p-4 sm:w-72" role="dialog" aria-labelledby="{$_module}-distance-filter">
          <form class="flex flex-col gap-3" method="get" action="?">
            <label class="label-text font-medium" for="{$_module}-distance-range">{__("Distance")}</label>
            {if $selected_country}
              <input type="hidden" name="country" value="{$selected_country['country_name']}">
            {/if}
            {if $sort}
              <input type="hidden" name="sort" value="{$sort}">
            {/if}
            <input type="range" class="range range-primary range-sm [--color-neutral:var(--color-base-content)]" id="{$_module}-distance-range" min="1" max="5000" name="distance" value="{if $distance}{$distance}{else}5000{/if}" oninput="this.form.distance_value.value=this.value">
            <div class="input">
              <input disabled type="number" class="grow" min="1" max="5000" name="distance_value" value="{if $distance}{$distance}{else}5000{/if}" oninput="this.form.distance.value=this.value" aria-label='{__("Distance")}'>
              <span class="my-auto ms-2 shrink-0 text-sm text-base-content/60">{if $system['system_distance'] == "mile"}{__("ML")}{else}{__("KM")}{/if}</span>
            </div>
            <button type="submit" class="heroui button button--primary button--sm w-full sm:w-auto sm:self-start rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Filter")}</button>
          </form>
        </div>
      </div>
    {/if}
    <!-- location filter -->

    <!-- country filter -->
    {if $system['newsfeed_location_filter_enabled']}
      <div class="dropdown relative z-30 inline-flex w-full sm:w-auto [&.open]:z-[34] [--placement:bottom-start] [--strategy:absolute] sm:[--placement:bottom-end] sm:[--strategy:fixed]">
        <button id="{$_module}-country-filter" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 hover:bg-primary/5 sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false">
          {if !$selected_country}<span class="icon-[tabler--world] size-4 shrink-0" aria-hidden="true"></span>{/if}
          <span class="min-w-0 grow truncate text-start sm:max-w-32 sm:grow-0" title="{if $selected_country}{$selected_country['country_name_with_flag']}{else}{__("All Countries")}{/if}">{if $selected_country}{$selected_country['country_name_with_flag']}{else}{__("All Countries")}{/if}</span>
          <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
        </button>
        <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 w-full min-w-56 overflow-y-auto p-1 sm:w-auto" role="menu" aria-labelledby="{$_module}-country-filter">
          <a class="dropdown-item{if !$selected_country} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?{if $distance}distance={$distance}{if $sort}&{/if}{/if}{if $sort}sort={$sort}{/if}">{__("All Countries")}</a>
          {foreach $countries as $country}
            <a class="dropdown-item{if $selected_country && $selected_country['country_id'] == $country['country_id']} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?country={$country['country_name_native']}{if $distance}&distance={$distance}{/if}{if $sort}&sort={$sort}{/if}">{$country['country_name_with_flag']}</a>
          {/foreach}
        </div>
      </div>
    {/if}
    <!-- country filter -->
  </div>
</div>
<!-- toolbar -->

{assign var="_discovery" value=($view == "" || $view == "category" || $view == "search")}

<div class="grid gap-6{if $_discovery} mt-3 lg:mt-6 lg:grid-cols-[15rem_minmax(0,1fr)]{else} mt-6{/if} lg:items-start">

  {if $_discovery}
  <!-- categories -->
  <aside class="lg:sticky lg:top-24">
  <!-- categories dropdown -->
  <div class="dropdown relative z-20 flex w-full lg:hidden [--placement:bottom-start] [--strategy:absolute]">
    <button id="{$_module}-categories-dropdown" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 hover:bg-primary/5 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false">
      <span class="icon-[tabler--category-2] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
      <span class="min-w-0 grow truncate text-start" title="{if $view == "category"}{__($current_category['category_name'])}{else}{__("Categories")}{/if}">{if $view == "category"}{__($current_category['category_name'])}{else}{__("Categories")}{/if}</span>
      <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
    </button>
    <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 w-full overflow-y-auto p-1" role="menu" aria-labelledby="{$_module}-categories-dropdown">
      {if $view != "category"}
        <a class="dropdown-item dropdown-active" role="menuitem" href="{$system['system_url']}/{$_module}" aria-current="page">{__("All")}</a>
      {elseif $current_category['parent']}
        <a class="dropdown-item text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5" role="menuitem" href="{$system['system_url']}/{$_module}/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
          <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
          <span class="truncate" title="{__($current_category['parent']['category_name'])}">{__($current_category['parent']['category_name'])}</span>
        </a>
      {else}
        <a class="dropdown-item text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5" role="menuitem" href="{$system['system_url']}/{$_module}">
          {if $current_category['sub_categories']}
            <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
          {/if}
          {__("All")}
        </a>
      {/if}
      {foreach $categories as $category}
        <a class="dropdown-item{if $view == "category" && $current_category['category_id'] == $category['category_id']} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$system['system_url']}/{$_module}/category/{$category['category_id']}/{$category['category_url']}" {if $view == "category" && $current_category['category_id'] == $category['category_id']}aria-current="page"{/if}>
          <span class="grow truncate" title="{__($category['category_name'])}">{__($category['category_name'])}</span>
          {if $category['sub_categories']}
            <span class="icon-[tabler--chevron-right] size-4 shrink-0 opacity-50 rtl:rotate-180" aria-hidden="true"></span>
          {/if}
        </a>
      {/foreach}
    </div>
  </div>
  <!-- categories dropdown -->

    <nav class="card hidden border border-base-300 bg-base-100 shadow-none lg:flex" aria-labelledby="{$_module}-categories-title">
      <div class="flex items-center gap-2 border-b border-base-300 px-4 py-3">
        <span class="icon-[tabler--category-2] size-4.5 text-base-content/60" aria-hidden="true"></span>
        <h2 class="text-sm font-semibold" id="{$_module}-categories-title">{__("Categories")}</h2>
      </div>
      <ul class="menu menu-sm gap-0.5 p-2">
        {if $view != "category"}
          <li><a class="menu-active" href="{$system['system_url']}/{$_module}" aria-current="page">{__("All")}</a></li>
        {else}
          <li>
            {if $current_category['parent']}
              <a class="text-base-content!" href="{$system['system_url']}/{$_module}/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
                <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                <span class="truncate" title="{__($current_category['parent']['category_name'])}">{__($current_category['parent']['category_name'])}</span>
              </a>
            {else}
              <a class="text-base-content!" href="{$system['system_url']}/{$_module}">
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
            <a class="{if $view == "category" && $current_category['category_id'] == $category['category_id']}menu-active{else}text-base-content!{/if}" href="{$system['system_url']}/{$_module}/category/{$category['category_id']}/{$category['category_url']}" {if $view == "category" && $current_category['category_id'] == $category['category_id']}aria-current="page"{/if}>
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

  <!-- results -->
  <div class="flex min-w-0 flex-col gap-6">

    {if $ads}
      <div class="flex flex-col gap-4">
        {include file='_ads.tpl'}
      </div>
    {/if}

    {if $view == "search"}
      <section class="flex min-w-0 flex-col gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-100 p-4 sm:flex-row sm:items-center sm:justify-between sm:px-5" aria-labelledby="{$_module}-search-title">
        <div class="flex min-w-0 items-center gap-3.5">
          <span class="flex size-11 shrink-0 items-center justify-center rounded-2xl bg-primary/10 text-primary" aria-hidden="true">
            <span class="icon-[tabler--search] size-5"></span>
          </span>
          <div class="min-w-0">
            <h2 class="text-base font-semibold" id="{$_module}-search-title">{__("Search Results")}</h2>
            <p class="mt-1 text-sm leading-relaxed break-words text-base-content/60">
              {__("Search for")} <span class="font-medium text-base-content">&ldquo;{$query}&rdquo;</span>
            </p>
          </div>
        </div>
        <div class="flex shrink-0 items-center gap-2.5 self-start rounded-xl bg-primary/10 px-3.5 py-2 text-primary sm:self-center">
          <span class="{$_my_icon} size-4" aria-hidden="true"></span>
          <span class="text-lg leading-none font-bold tabular-nums">{$total}</span>
          <span class="text-xs font-medium">{$_title}</span>
        </div>
      </section>
    {/if}

    {if $view == "" && $_promoted}
      <!-- promoted -->
      <section class="flex flex-col gap-4" aria-labelledby="{$_module}-promoted-title">
        <h2 id="{$_module}-promoted-title" class="flex items-center gap-2 text-lg font-semibold">
          <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-warning/15 text-base-content" aria-hidden="true">
            <span class="icon-[tabler--speakerphone] size-4.5"></span>
          </span>
          {$_promoted_title}
        </h2>
        <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {foreach $_promoted as $post}
            {include file=$_card _boosted=true blog=$post funding=$post}
          {/foreach}
        </ul>
      </section>
      <!-- promoted -->
    {/if}

    <section class="flex flex-col gap-4" aria-labelledby="{$_module}-{if $view == "search"}search{else}results{/if}-title">
      {if $view != "search"}
        <h2 id="{$_module}-results-title" class="flex items-center gap-2 text-lg font-semibold">
          {if $view == "category"}{__($current_category['category_name'])}{elseif $view == "manage"}{$_my_label}{else}{__("Discover")}{/if}
          {if $total}<span class="badge badge-soft rounded-full">{$total}</span>{/if}
        </h2>
      {/if}

      {if $rows}
        <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {foreach $rows as $post}
            {include file=$_card blog=$post funding=$post}
          {/foreach}
        </ul>
        {if $pager}{$pager}{/if}
      {else}
        <div class="card border border-base-300 bg-base-100 shadow-none">
          {include file='_no_data.tpl' _empty_icon=$_empty_icon}
        </div>
      {/if}
    </section>
  </div>
  <!-- results -->

</div>
