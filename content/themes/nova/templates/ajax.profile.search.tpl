<form action="{$system['system_url']}{$search['url']}/search" method="get" role="search">
  {include file='__close_button.tpl'}
  <div class="modal__body flex flex-col items-center px-2 pt-6 pb-4 text-center">
    <!-- intro -->
    <img class="size-20 rounded-full object-cover ring-1 ring-base-content/10" src="{$search['picture']}" alt="">
    <h6 class="mt-4 text-lg font-semibold tracking-tight">{__("Looking for something?")}</h6>
    <p class="mt-1 max-w-sm text-sm leading-relaxed text-base-content/60">
      {__("Search posts, photos and other visible activity of")} <span class="block font-medium text-base-content">{$search['name']}</span>
    </p>
    <!-- intro -->

    <!-- query -->
    <div class="input input-lg mt-6 w-full rounded-full [--border:1px]">
      <span class="icon-[tabler--search] my-auto me-2 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
      <input type="text" class="grow" name="query" id="profile-search-query" placeholder="{__("Search for")}" aria-label="{__("Search for")}" value="{$query}" autocomplete="off" enterkeyhint="search" autofocus>
      <button type="submit" class="heroui button button--primary button--sm my-auto -me-2 ms-2 shrink-0 rounded-full">{__("Search")}</button>
    </div>
    <!-- query -->
  </div>
</form>
