{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {include file='__page_header.tpl' _title=__("Search") _text=__("Discover new people, create new connections and make new friends") _image="search.svg"}
  <!-- page heading -->

  <!-- search form -->
  <form class="js_search-form mt-6 flex gap-2 rounded-box border border-base-300 bg-base-100 p-2" {if $tab}data-filter="{$tab}"{/if} role="search">
    <label class="input grow border-0 shadow-none focus-within:outline-none">
      <span class="icon-[tabler--search] my-auto me-2 size-4.5 shrink-0 text-base-content/50" aria-hidden="true"></span>
      <input type="search" class="grow" name="query" placeholder='{__("Search")}' aria-label='{__("Search")}' {if $query}value="{$query}"{/if}>
    </label>
    <button type="submit" name="submit" class="heroui button button--primary shrink-0 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
      <span class="icon-[tabler--search] size-4" aria-hidden="true"></span>
      <span class="hidden sm:inline">{__("Search")}</span>
    </button>
  </form>
  <!-- search form -->

  {if $query}
    <!-- tabs -->
    <nav class="tabs tabs-bordered mt-6 gap-1 border-b sm:flex-wrap sm:gap-x-6 border-base-300" aria-label='{__("Search")}'>
      <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $tab == "" || $tab == "posts"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/search/{if $hashtag}hashtag/{/if}{$query}/posts" {if $tab == "" || $tab == "posts"}aria-current="page"{/if}>
        <span class="icon-[tabler--news] size-4" aria-hidden="true"></span>
        <span class="max-w-full truncate" title="{__("Posts")}">{__("Posts")}</span>
      </a>
      <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $tab == "users"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/search/{$query}/users" {if $tab == "users"}aria-current="page"{/if}>
        <span class="icon-[tabler--users] size-4" aria-hidden="true"></span>
        <span class="max-w-full truncate" title="{__("Users")}">{__("Users")}</span>
      </a>
      {if $system['pages_enabled']}
      <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $tab == "pages"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/search/{$query}/pages" {if $tab == "pages"}aria-current="page"{/if}>
        <span class="icon-[tabler--flag] size-4" aria-hidden="true"></span>
        <span class="max-w-full truncate" title="{__("Pages")}">{__("Pages")}</span>
      </a>
      {/if}
      {if $system['groups_enabled']}
      <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $tab == "groups"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/search/{$query}/groups" {if $tab == "groups"}aria-current="page"{/if}>
        <span class="icon-[tabler--users-group] size-4" aria-hidden="true"></span>
        <span class="max-w-full truncate" title="{__("Groups")}">{__("Groups")}</span>
      </a>
      {/if}
      {if $system['events_enabled']}
      <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $tab == "events"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/search/{$query}/events" {if $tab == "events"}aria-current="page"{/if}>
        <span class="icon-[tabler--calendar-event] size-4" aria-hidden="true"></span>
        <span class="max-w-full truncate" title="{__("Events")}">{__("Events")}</span>
      </a>
      {/if}
    </nav>
    <!-- tabs -->
  {/if}

  <div class="mt-6 grid gap-6 lg:grid-cols-[minmax(0,1fr)_20rem] lg:items-start">

    <!-- results -->
    <div class="min-w-0">
      {if $results}
        {if $tab == "" || $tab == "posts"}
          <div>
            <ul class="flex flex-col gap-5">
              {foreach $results as $post}
                {include file='__feeds_post.tpl'}
              {/foreach}
            </ul>
            {if count($results) >= $system['search_results']}
              <div class="see-more js_see-more js_see-more-infinite mt-5 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="search_{$tab}" data-query="{if $hashtag && $tab == "posts"}#{/if}{$query}" {if $type}data-type="{$type}"{/if}>
                <span>{__("More Results")}</span>
                <div class="loading loading-spinner loading-sm hidden"></div>
              </div>
            {/if}
          </div>
        {else}
          <div>
            <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2">
              {if $tab == "users"}
                {foreach $results as $_user}
                  {include file='__people_card.tpl' _connection=$_user['connection']}
                {/foreach}
              {elseif $tab == "pages"}
                {foreach $results as $_page}
                  {include file='__pages_card.tpl'}
                {/foreach}
              {elseif $tab == "groups"}
                {foreach $results as $_group}
                  {include file='__groups_card.tpl'}
                {/foreach}
              {elseif $tab == "events"}
                {foreach $results as $_event}
                  {include file='__feeds_event.tpl' _tpl="box"}
                {/foreach}
              {/if}
            </ul>
            {if count($results) >= $system['search_results']}
              <div class="see-more js_see-more js_see-more-infinite mt-5 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="search_{$tab}" data-query="{if $hashtag && $tab == "posts"}#{/if}{$query}" {if $type}data-type="{$type}"{/if}>
                <span>{__("More Results")}</span>
                <div class="loading loading-spinner loading-sm hidden"></div>
              </div>
            {/if}
          </div>
        {/if}
      {else}
        <div class="card border border-base-300 bg-base-100 shadow-none">
          {include file='_no_data.tpl' _empty_icon="icon-[tabler--search]"}
        </div>
      {/if}
    </div>
    <!-- results -->

    <!-- aside -->
    <aside class="flex flex-col gap-6 lg:sticky lg:top-24">
      {include file='_ads_campaigns.tpl'}
      {include file='_ads.tpl'}
      {include file='_widget.tpl'}
    </aside>
    <!-- aside -->

  </div>

</div>
<!-- page content -->

{include file='_footer.tpl'}
