{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {if $view == "category"}
    {include file='__page_header.tpl' _title=__($current_category['category_name']) _text=__($system['system_description_marketplace']) _image="market.svg"}
  {elseif $view == "cart"}
    {include file='__page_header.tpl' _title=__("Shopping Cart") _text=__($system['system_description_marketplace']) _image="market.svg"}
  {elseif $view == "orders"}
    {include file='__page_header.tpl' _title=__("Orders") _text=__($system['system_description_marketplace']) _image="market.svg"}
  {elseif $view == "sales"}
    {include file='__page_header.tpl' _title=__("Sales") _text=__($system['system_description_marketplace']) _image="market.svg"}
  {else}
    {include file='__page_header.tpl' _title=__("Marketplace") _text=__($system['system_description_marketplace']) _image="market.svg"}
  {/if}
  <!-- page heading -->

  <!-- tabs -->
  <div class="mt-6 flex flex-col gap-4 sm:flex-row sm:flex-wrap sm:items-end sm:justify-between sm:gap-3 sm:border-b sm:border-base-300">
    <nav class="tabs tabs-bordered gap-1 border-b border-base-300 sm:flex-wrap sm:gap-x-6 sm:border-b-0" aria-label='{__("Marketplace")}'>
      <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "" || $view == "search" || $view == "category"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/market" {if $view == "" || $view == "search" || $view == "category"}aria-current="page"{/if}>
        <span class="icon-[tabler--building-store] size-4 shrink-0" aria-hidden="true"></span>
        <span class="max-w-full truncate" title="{__("Market")}">{__("Market")}</span>
      </a>
      {if $user->_logged_in}
        <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "manage"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/market/manage" {if $view == "manage"}aria-current="page"{/if}>
          <span class="icon-[tabler--package] size-4 shrink-0" aria-hidden="true"></span>
          <span class="max-w-full truncate" title="{__("My Products")}">{__("My Products")}</span>
        </a>
      {/if}
      {if $system['market_shopping_cart_enabled'] && $user->_logged_in}
        <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "cart"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/market/cart" {if $view == "cart"}aria-current="page"{/if}>
          <span class="icon-[tabler--shopping-cart] size-4 shrink-0" aria-hidden="true"></span>
          <span class="max-w-full truncate sm:hidden" title="{__("Cart")}">{__("Cart")}</span>
          <span class="hidden truncate sm:inline" title="{__("Shopping Cart")}">{__("Shopping Cart")}</span>
        </a>
        <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "orders"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/market/orders" {if $view == "orders"}aria-current="page"{/if}>
          <span class="icon-[tabler--receipt] size-4 shrink-0" aria-hidden="true"></span>
          <span class="max-w-full truncate" title="{__("Orders")}">{__("Orders")}</span>
        </a>
        {if $user->_data['can_sell_products']}
          <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "sales"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/market/sales" {if $view == "sales"}aria-current="page"{/if}>
            <span class="icon-[tabler--chart-line] size-4 shrink-0" aria-hidden="true"></span>
            <span class="max-w-full truncate" title="{__("Sales")}">{__("Sales")}</span>
          </a>
        {/if}
      {/if}
    </nav>
    {if $system['market_enabled']}
      <button type="button" class="heroui button button--primary button--sm w-full sm:mb-2 sm:w-auto js_modal rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="posts/product.php?do=create">
        <span class="icon-[tabler--plus] size-4 shrink-0" aria-hidden="true"></span>
        {__("Create Product")}
      </button>
    {/if}
  </div>
  <!-- tabs -->

  {if in_array($view, ['', 'search', 'category', 'manage'])}

    {assign var="_discovery" value=($view == "" || $view == "search" || $view == "category")}

    <!-- toolbar -->
    <div class="mt-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
      <form class="js_search-form w-full sm:max-w-sm" data-handle="market" role="search">
        <label class="input w-full">
          <span class="icon-[tabler--search] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
          <input type="search" class="grow" name="query" placeholder='{__("Search for products")}' aria-label='{__("Search for products")}' {if $view == "search"}value="{$query}"{/if}>
        </label>
      </form>
      <div class="flex flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-center sm:gap-2">
        <!-- sort -->
        <div class="dropdown relative z-30 inline-flex w-full sm:w-auto [&.open]:z-[34] [--placement:bottom-start] [--strategy:absolute] sm:[--placement:bottom-end] sm:[--strategy:fixed]">
          <button id="market-sort-filter" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 hover:bg-primary/5 sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false">
            <span class="icon-[tabler--arrows-sort] size-4 shrink-0" aria-hidden="true"></span>
            <span class="min-w-0 grow truncate text-start sm:grow-0">{if $sort == "price-high"}{__("Price High")}{elseif $sort == "price-low"}{__("Price Low")}{else}{__("Latest")}{/if}</span>
            <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
          </button>
          <ul class="dropdown-menu dropdown-open:opacity-100 hidden w-full min-w-48 p-1 sm:w-auto" role="menu" aria-orientation="vertical" aria-labelledby="market-sort-filter">
            <li>
              <a class="dropdown-item{if !$sort || $sort == "latest"} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?{if $selected_country}country={$selected_country['country_name']}&{/if}{if $distance}distance={$distance}&{/if}sort=latest">
                <span class="icon-[tabler--clock] size-4" aria-hidden="true"></span>
                {__("Latest")}
              </a>
            </li>
            <li>
              <a class="dropdown-item{if $sort == "price-high"} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?{if $selected_country}country={$selected_country['country_name']}&{/if}{if $distance}distance={$distance}&{/if}sort=price-high">
                <span class="icon-[tabler--sort-descending-numbers] size-4" aria-hidden="true"></span>
                {__("Price High")}
              </a>
            </li>
            <li>
              <a class="dropdown-item{if $sort == "price-low"} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?{if $selected_country}country={$selected_country['country_name']}&{/if}{if $distance}distance={$distance}&{/if}sort=price-low">
                <span class="icon-[tabler--sort-ascending-numbers] size-4" aria-hidden="true"></span>
                {__("Price Low")}
              </a>
            </li>
          </ul>
        </div>
        <!-- sort -->

        <!-- location filter -->
        {if $user->_logged_in && $system['location_finder_enabled']}
          <div class="dropdown relative z-30 inline-flex w-full sm:w-auto [&.open]:z-[34] [--placement:bottom-start] [--strategy:absolute] sm:[--placement:bottom-end] sm:[--strategy:fixed] [--auto-close:inside]">
            <button id="market-distance-filter" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 hover:bg-primary/5 sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="dialog" aria-expanded="false">
              <span class="icon-[tabler--map-pin] size-4 shrink-0" aria-hidden="true"></span>
              <span class="min-w-0 grow truncate text-start sm:grow-0">{if $distance}{$distance} {if $system['system_distance'] == "mile"}{__("ML")}{else}{__("KM")}{/if}{else}{__("Distance")}{/if}</span>
              <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
            </button>
            <div class="dropdown-menu dropdown-open:opacity-100 hidden w-full p-4 sm:w-72" role="dialog" aria-labelledby="market-distance-filter">
              <form class="flex flex-col gap-3" method="get" action="?">
                <label class="label-text font-medium" for="market-distance-range">{__("Distance")}</label>
                {if $selected_country}
                  <input type="hidden" name="country" value="{$selected_country['country_name']}">
                {/if}
                {if $sort}
                  <input type="hidden" name="sort" value="{$sort}">
                {/if}
                <input type="range" class="range range-primary range-sm [--color-neutral:var(--color-base-content)]" id="market-distance-range" min="1" max="5000" name="distance" value="{if $distance}{$distance}{else}5000{/if}" oninput="this.form.distance_value.value=this.value">
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
            <button id="market-country-filter" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 hover:bg-primary/5 sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false">
              {if !$selected_country}<span class="icon-[tabler--world] size-4 shrink-0" aria-hidden="true"></span>{/if}
              <span class="min-w-0 grow truncate text-start sm:max-w-32 sm:grow-0" title="{if $selected_country}{$selected_country['country_name_with_flag']}{else}{__("All Countries")}{/if}">{if $selected_country}{$selected_country['country_name_with_flag']}{else}{__("All Countries")}{/if}</span>
              <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
            </button>
            <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 w-full min-w-56 overflow-y-auto p-1 sm:w-auto" role="menu" aria-labelledby="market-country-filter">
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

    <div class="grid gap-6{if $_discovery} mt-3 lg:mt-6 lg:grid-cols-[15rem_minmax(0,1fr)]{else} mt-6{/if} lg:items-start">

      {if $_discovery}
      <!-- categories -->
      <aside class="lg:sticky lg:top-24">
        <!-- categories dropdown -->
        <div class="dropdown relative z-20 flex w-full lg:hidden [--placement:bottom-start] [--strategy:absolute]">
          <button id="market-categories-dropdown" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 hover:bg-primary/5 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false">
            <span class="icon-[tabler--category-2] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
            <span class="min-w-0 grow truncate text-start" title="{if $view == "category"}{__($current_category['category_name'])}{else}{__("Categories")}{/if}">{if $view == "category"}{__($current_category['category_name'])}{else}{__("Categories")}{/if}</span>
            <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
          </button>
          <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 w-full overflow-y-auto p-1" role="menu" aria-labelledby="market-categories-dropdown">
            {if $view != "category"}
              <a class="dropdown-item dropdown-active" role="menuitem" href="{$system['system_url']}/market" aria-current="page">{__("All")}</a>
            {elseif $current_category['parent']}
              <a class="dropdown-item text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5" role="menuitem" href="{$system['system_url']}/market/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
                <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                <span class="truncate" title="{__($current_category['parent']['category_name'])}">{__($current_category['parent']['category_name'])}</span>
              </a>
            {else}
              <a class="dropdown-item text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5" role="menuitem" href="{$system['system_url']}/market">
                {if $current_category['sub_categories']}
                  <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                {/if}
                {__("All")}
              </a>
            {/if}
            {foreach $categories as $category}
              <a class="dropdown-item{if $view == "category" && $current_category['category_id'] == $category['category_id']} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$system['system_url']}/market/category/{$category['category_id']}/{$category['category_url']}" {if $view == "category" && $current_category['category_id'] == $category['category_id']}aria-current="page"{/if}>
                <span class="grow truncate" title="{__($category['category_name'])}">{__($category['category_name'])}</span>
                {if $category['sub_categories']}
                  <span class="icon-[tabler--chevron-right] size-4 shrink-0 opacity-50 rtl:rotate-180" aria-hidden="true"></span>
                {/if}
              </a>
            {/foreach}
          </div>
        </div>
        <!-- categories dropdown -->

        <nav class="card hidden border border-base-300 bg-base-100 shadow-none lg:flex" aria-labelledby="market-categories-title">
          <div class="flex items-center gap-2 border-b border-base-300 px-4 py-3">
            <span class="icon-[tabler--category-2] size-4.5 text-base-content/60" aria-hidden="true"></span>
            <h2 class="text-sm font-semibold" id="market-categories-title">{__("Categories")}</h2>
          </div>
          <ul class="menu menu-sm gap-0.5 p-2">
            {if $view != "category"}
              <li><a class="menu-active" href="{$system['system_url']}/market" aria-current="page">{__("All")}</a></li>
            {else}
              <li>
                {if $current_category['parent']}
                  <a class="text-base-content!" href="{$system['system_url']}/market/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
                    <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                    <span class="truncate" title="{__($current_category['parent']['category_name'])}">{__($current_category['parent']['category_name'])}</span>
                  </a>
                {else}
                  <a class="text-base-content!" href="{$system['system_url']}/market">
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
                <a class="{if $view == "category" && $current_category['category_id'] == $category['category_id']}menu-active{else}text-base-content!{/if}" href="{$system['system_url']}/market/category/{$category['category_id']}/{$category['category_url']}" {if $view == "category" && $current_category['category_id'] == $category['category_id']}aria-current="page"{/if}>
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

      <!-- products -->
      <div class="flex min-w-0 flex-col gap-6">

        {if $ads}
          <div class="flex flex-col gap-4">
            {include file='_ads.tpl'}
          </div>
        {/if}

        {if $view == "search"}
          <section class="flex min-w-0 flex-col gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-100 p-4 sm:flex-row sm:items-center sm:justify-between sm:px-5" aria-labelledby="market-search-title">
            <div class="flex min-w-0 items-center gap-3.5">
              <span class="flex size-11 shrink-0 items-center justify-center rounded-2xl bg-primary/10 text-primary" aria-hidden="true">
                <span class="icon-[tabler--search] size-5"></span>
              </span>
              <div class="min-w-0">
                <h2 class="text-base font-semibold" id="market-search-title">{__("Search Results")}</h2>
                <p class="mt-1 text-sm leading-relaxed break-words text-base-content/60">
                  {__("Search for")} <span class="font-medium text-base-content">&ldquo;{$query}&rdquo;</span>
                </p>
              </div>
            </div>
            <div class="flex shrink-0 items-center gap-2.5 self-start rounded-xl bg-primary/10 px-3.5 py-2 text-primary sm:self-center">
              <span class="icon-[tabler--building-store] size-4" aria-hidden="true"></span>
              <span class="text-lg leading-none font-bold tabular-nums">{$total}</span>
              <span class="text-xs font-medium">{__("Products")}</span>
            </div>
          </section>
        {/if}

        {if $view == "" && $promoted_products}
          <!-- promoted products -->
          <section class="flex flex-col gap-4" aria-labelledby="market-promoted-title">
            <h2 id="market-promoted-title" class="flex items-center gap-2 text-lg font-semibold">
              <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-warning/15 text-base-content" aria-hidden="true">
                <span class="icon-[tabler--speakerphone] size-4.5"></span>
              </span>
              {__("Promoted Products")}
            </h2>
            <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
              {foreach $promoted_products as $post}
                {include file='__feeds_product.tpl' _boosted=true}
              {/foreach}
            </ul>
          </section>
          <!-- promoted products -->
        {/if}

        <section class="flex flex-col gap-4" aria-labelledby="market-{if $view == "search"}search{else}products{/if}-title">
          {if $view != "search"}
            <h2 id="market-products-title" class="flex items-center gap-2 text-lg font-semibold">
              {if $view == "category"}{__($current_category['category_name'])}{elseif $view == "manage"}{__("My Products")}{else}{__("Discover")}{/if}
              {if $total}<span class="badge badge-soft rounded-full">{$total}</span>{/if}
            </h2>
          {/if}

          {if $rows}
            <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
              {foreach $rows as $post}
                {include file='__feeds_product.tpl'}
              {/foreach}
            </ul>
            {if $pager}{$pager}{/if}
          {else}
            <div class="card border border-base-300 bg-base-100 shadow-none">
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--building-store]"}
            </div>
          {/if}
        </section>
      </div>
      <!-- products -->

    </div>

  {elseif $view == "cart"}

    <!-- shopping cart -->
    <div class="mt-6 grid gap-6 lg:grid-cols-[minmax(0,1fr)_23rem] lg:items-start">
      <div class="flex min-w-0 flex-col gap-6">

        <!-- cart items -->
        <section class="flex flex-col gap-5 rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-base-100 p-5 sm:p-6" aria-labelledby="market-cart-title">
          <div class="flex items-center gap-3">
            <span class="inline-flex size-11 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-primary/10 text-primary" aria-hidden="true">
              <span class="icon-[tabler--shopping-cart] size-5"></span>
            </span>
            <h2 class="grow text-lg font-semibold" id="market-cart-title">{__("Shopping Cart")}</h2>
            {if $cart['items']}
              <span class="badge badge-soft badge-primary rounded-full">{count($cart['items'])}</span>
            {/if}
          </div>
          {if $cart['items']}
            <ul class="flex flex-col gap-3">
              {foreach $cart['items'] as $cart_item}
                <li class="flex flex-wrap items-center gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-base-200/60 p-3 sm:flex-nowrap">
                  <a class="shrink-0" href="{$system['system_url']}/posts/{$cart_item['post']['post_id']}">
                    {if $cart_item['post']['photos_num'] > 0}
                      <img class="size-20 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl object-cover" src="{$system['system_uploads']}/{$cart_item['post']['photos'][0]['source']}" alt="" loading="lazy">
                    {else}
                      <img class="size-20 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl object-cover" src="{$system['system_url']}/content/themes/{$system['theme']}/images/blank/blank_product.png" alt="" loading="lazy">
                    {/if}
                  </a>
                  <div class="min-w-0 grow">
                    <a class="line-clamp-2 font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/posts/{$cart_item['post']['post_id']}" title="{$cart_item['post']['product']['name']}">{$cart_item['post']['product']['name']}</a>
                    <div class="mt-1.5 flex flex-wrap gap-1.5">
                      {if $cart_item['post']['product']['is_digital']}
                        <span class="badge badge-soft badge-primary badge-sm rounded-full">{__("Digital")}</span>
                      {/if}
                      {if $cart_item['post']['product']['status'] == "new"}
                        <span class="badge badge-soft badge-info badge-sm rounded-full">{__("New")}</span>
                      {else}
                        <span class="badge badge-soft badge-sm rounded-full">{__("Used")}</span>
                      {/if}
                    </div>
                    <div class="mt-2 text-lg font-bold text-primary tabular-nums">
                      {if $cart_item['post']['product']['price'] > 0}{$cart_item['post']['product']['price_formatted']}{else}{__("Free")}{/if}
                    </div>
                  </div>
                  <div class="flex shrink-0 items-center gap-2">
                    <label class="flex items-center gap-2 text-sm text-base-content/60">
                      <span>{__("Qty:")}</span>
                      <div class="select select-sm w-20 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-base-100">
                        <select class="min-w-0 ps-0! js_shopping-update-cart" name="quantity" data-id="{$cart_item['product_post_id']}">
                          {for $i=1; $i <= $cart_item['post']['product']['quantity']; $i++}
                            <option value="{$i}" {if $i == $cart_item['quantity']}selected{/if}>{$i}</option>
                          {/for}
                        </select>
                      </div>
                    </label>
                    <button type="button" class="heroui button button--danger-soft button--sm button--icon-only size-7.5 rounded-field corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_shopping-remove-from-cart" data-id="{$cart_item['product_post_id']}" aria-label='{__("Remove")}' title='{__("Remove")}'>
                      <span class="icon-[tabler--trash] size-4.5" aria-hidden="true"></span>
                    </button>
                  </div>
                </li>
              {/foreach}
            </ul>
          {else}
            {include file='_no_data.tpl' _empty_icon="icon-[tabler--shopping-cart]" _empty_title=__("Your cart is empty.") _empty_text=__("Browse the market and add products to your cart")}
            <div class="-mt-8 flex justify-center pb-6">
              <a class="heroui button button--primary button--sm rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/market">
                <span class="icon-[tabler--building-store] size-4" aria-hidden="true"></span>
                {__("Market")}
              </a>
            </div>
          {/if}
        </section>
        <!-- cart items -->

        <!-- addresses -->
        <section class="flex flex-col gap-5 rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-base-100 p-5 sm:p-6" aria-labelledby="market-addresses-title">
          <div class="flex items-center gap-3">
            <span class="inline-flex size-11 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-info/10 text-info" aria-hidden="true">
              <span class="icon-[tabler--map-pin] size-5"></span>
            </span>
            <h2 class="text-lg font-semibold" id="market-addresses-title">{__("Your Addresses")}</h2>
          </div>
          {include file='_addresses.tpl' _small=true}
        </section>
        <!-- addresses -->

      </div>

      <!-- checkout -->
      <aside class="lg:sticky lg:top-24">
        <section class="flex flex-col gap-5 rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-base-100 p-5 sm:p-6" aria-labelledby="market-shipping-title">
          <div class="flex items-center gap-3">
            <span class="inline-flex size-11 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-success/10 text-success" aria-hidden="true">
              <span class="icon-[tabler--truck-delivery] size-5"></span>
            </span>
            <h2 class="text-lg font-semibold" id="market-shipping-title">{__("Shipping Address")}</h2>
          </div>

          {if $addresses}
            <div class="flex flex-col gap-2">
              {foreach $addresses as $address}
                <label class="flex cursor-pointer items-start gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] border border-base-300 p-3 transition-colors hover:border-primary/30 has-checked:border-primary has-checked:bg-primary/5" for="shipping_address-{$address['address_id']}">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-base-200 text-base-content/60" aria-hidden="true">
                    <span class="icon-[tabler--map-pin] size-4.5"></span>
                  </span>
                  <span class="min-w-0 grow">
                    <span class="block truncate text-sm font-semibold" title="{$address['address_title']}">{$address['address_title']}</span>
                    <span class="block text-xs text-base-content/60 [overflow-wrap:anywhere]">{$address['address_details']}, {$address['address_city']} - {$address['address_country']}</span>
                  </span>
                  <input class="radio radio-primary radio-sm mt-2 shrink-0 js_shipping-address" type="radio" name="shipping_address" id="shipping_address-{$address['address_id']}" value="{$address['address_id']}">
                </label>
              {/foreach}
            </div>
            <!-- error -->
            <div class="hidden" id="addresses-error">
              <div class="alert alert-soft alert-error text-sm">{__("Select a shipping address")}</div>
            </div>
            <!-- error -->
          {else}
            <div class="flex items-start gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-warning/15 p-4 text-sm text-base-content/80" role="note">
              <span class="icon-[tabler--map-pin-off] mt-0.5 size-5 shrink-0" aria-hidden="true"></span>
              <span>{__("You have no addresses")}</span>
            </div>
          {/if}

          <div class="flex flex-col gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-base-200/60 p-4 text-sm">
            <div class="flex items-center justify-between gap-3">
              <span class="text-base-content/60">{__("Items")}</span>
              <span class="font-medium tabular-nums">{if $cart['items']}{count($cart['items'])}{else}0{/if}</span>
            </div>
            <div class="flex items-end justify-between gap-3 border-t border-dashed border-base-content/15 pt-3">
              <span class="font-semibold">{__("Total Price")}</span>
              <strong class="text-2xl font-bold tracking-tight tabular-nums">{print_money($cart['total'])}</strong>
            </div>
          </div>

          <button type="button" class="heroui button button--primary button--full-width rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_shopping-checkout" {if !$cart['items']}disabled{/if}>
            <span class="icon-[tabler--lock] size-4" aria-hidden="true"></span>
            {__("Checkout")}
          </button>
        </section>
      </aside>
      <!-- checkout -->
    </div>
    <!-- shopping cart -->

  {elseif $view == "orders" || $view == "sales"}

    {if $view == "sales"}
      <!-- stats -->
      <div class="mt-6 grid gap-4 sm:grid-cols-3">
        <div class="relative flex min-w-0 flex-col gap-5 overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-linear-to-br from-primary/10 via-base-100 to-base-100 p-6">
          <span class="inline-flex size-12 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-primary/15 text-primary" aria-hidden="true">
            <span class="icon-[tabler--file-invoice] size-6"></span>
          </span>
          <div class="min-w-0">
            <div class="text-sm text-base-content/60">{__("Total Orders")}</div>
            <div class="mt-1 truncate text-3xl font-bold tracking-tight tabular-nums" title="{$orders_count}">{$orders_count}</div>
          </div>
        </div>
        <div class="relative flex min-w-0 flex-col gap-5 overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-linear-to-br from-info/10 via-base-100 to-base-100 p-6">
          <span class="inline-flex size-12 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-info/15 text-info" aria-hidden="true">
            <span class="icon-[tabler--calendar-dollar] size-6"></span>
          </span>
          <div class="min-w-0">
            <div class="text-sm text-base-content/60">{__("This Month Earnings")}</div>
            <div class="mt-1 truncate text-3xl font-bold tracking-tight tabular-nums" title="{print_money($monthly_sales)}">{print_money($monthly_sales)}</div>
          </div>
        </div>
        <div class="relative flex min-w-0 flex-col gap-5 overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-primary p-6 text-primary-content dark:[--color-primary:#523ae2]">
          <span class="icon-[tabler--coins] pointer-events-none absolute -end-4 -bottom-4 size-32 text-primary-content/10" aria-hidden="true"></span>
          <span class="inline-flex size-12 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-primary-content/15" aria-hidden="true">
            <span class="icon-[tabler--coins] size-6"></span>
          </span>
          <div class="relative min-w-0">
            <div class="text-sm text-primary-content/70">{__("Total Earnings")}</div>
            <div class="mt-1 truncate text-3xl font-bold tracking-tight tabular-nums" title="{print_money($user->_data['user_market_balance'])}">{print_money($user->_data['user_market_balance'])}</div>
          </div>
        </div>
      </div>
      <!-- stats -->
    {/if}

    <!-- orders -->
    <section class="mt-6 flex flex-col gap-4" aria-labelledby="market-orders-title">
      <div class="flex flex-wrap items-center justify-between gap-3">
        <h2 id="market-orders-title" class="flex flex-wrap items-center gap-2 text-lg font-semibold">
          {if $view == "sales"}{__("Sales Orders")}{else}{__("Orders")}{/if}
          {if !$query}<span class="badge badge-soft rounded-full">{$orders_count}</span>{/if}
          {if $query}<span class="badge badge-soft badge-primary rounded-full">{__("for")}: {$query}</span>{/if}
        </h2>
        <form class="w-full sm:max-w-sm" action="{$system['system_url']}/market/{$view}" method="get" role="search">
          <label class="input w-full">
            <span class="icon-[tabler--search] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <input type="search" class="grow" name="query" value="{$query}" placeholder='{__("Search")}' aria-label='{__("Search")}'>
          </label>
        </form>
      </div>

      {if $orders}
        <div>
          <ul class="flex flex-col gap-4 js_orders-stream">
            {foreach $orders as $order}
              {if $view == "sales"}
                {include file='_order.tpl' sales=true}
              {else}
                {include file='_order.tpl'}
              {/if}
            {/foreach}
          </ul>

          <!-- see-more -->
          {if count($orders) >= $system['max_results']}
            <div class="see-more js_see-more mt-4 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="{if $view == "sales"}sales_orders{else}orders{/if}" data-target-stream=".js_orders-stream" {if $query}data-filter="{$query}"{/if}>
              <span>{__("See More")}</span>
              <div class="loading loading-spinner loading-sm hidden"></div>
            </div>
          {/if}
          <!-- see-more -->
        </div>
      {else}
        <div class="card border border-base-300 bg-base-100 shadow-none">
          {include file='_no_data.tpl' _empty_icon="icon-[tabler--receipt]"}
        </div>
      {/if}
    </section>
    <!-- orders -->

  {/if}

</div>
<!-- page content -->

{include file='_footer.tpl'}
