<!-- tabs -->
<div class="mt-6 flex flex-col gap-4 sm:flex-row sm:flex-wrap sm:items-center sm:gap-x-6 sm:gap-y-3 sm:border-b sm:border-base-300">
  <nav class="tabs tabs-bordered min-w-0 gap-1 border-b border-base-300 sm:-mb-px sm:grow sm:gap-6 sm:overflow-x-auto sm:border-b-0" aria-label="{__("Forums")}">
    <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:mb-0 sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "" || $view == "forum"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/forums" {if $view == ""}aria-current="page"{/if}>
      <span class="icon-[tabler--layout-list] size-4 shrink-0" aria-hidden="true"></span>
      <span class="max-w-full truncate" title="{__("Categories")}">{__("Categories")}</span>
    </a>
    <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:mb-0 sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "recent"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/forums/recent" {if $view == "recent"}aria-current="page"{/if}>
      <span class="icon-[tabler--clock] size-4 shrink-0" aria-hidden="true"></span>
      <span class="max-w-full truncate" title="{__("Recent")}">{__("Recent")}</span>
    </a>
    {if $user->_logged_in}
      <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:mb-0 sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "my-threads"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/forums/my-threads" {if $view == "my-threads"}aria-current="page"{/if}>
        <span class="icon-[tabler--file-text] size-4 shrink-0" aria-hidden="true"></span>
        <span class="max-w-full truncate" title="{__("My Threads")}">{__("My Threads")}</span>
      </a>
      <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:mb-0 sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "my-replies"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/forums/my-replies" {if $view == "my-replies"}aria-current="page"{/if}>
        <span class="icon-[tabler--messages] size-4 shrink-0" aria-hidden="true"></span>
        <span class="max-w-full truncate" title="{__("My Replies")}">{__("My Replies")}</span>
      </a>
    {/if}
    <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:mb-0 sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "search" || $view == "search-results"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/forums/search" {if $view == "search" || $view == "search-results"}aria-current="page"{/if}>
      <span class="icon-[tabler--search] size-4 shrink-0" aria-hidden="true"></span>
      <span class="max-w-full truncate" title="{__("Search")}">{__("Search")}</span>
    </a>
  </nav>
  <div class="flex items-center gap-2 sm:mb-2 sm:shrink-0">
    {if $rss_url}
      <a class="heroui button button--tertiary button--sm flex-1 bg-orange-500/10 sm:flex-none text-orange-600 hover:bg-orange-500/15 dark:text-orange-400 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$rss_url}">
        <span class="icon-[tabler--rss] size-4 shrink-0" aria-hidden="true"></span>
        {__("RSS")}
      </a>
    {/if}
    <a class="heroui button button--primary button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/forums/new-thread{if $view == "forum" && $forum['forum_section'] != '0'}/{$forum['forum_id']}{/if}">
      <span class="icon-[tabler--plus] size-4 shrink-0" aria-hidden="true"></span>
      {__("Start a Discussion")}
    </a>
  </div>
</div>
<!-- tabs -->
