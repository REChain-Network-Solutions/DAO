{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {if $view == "forum"}
    {include file='__page_header.tpl' _title=__($forum['forum_name']) _text=__($forum['forum_description']) _image="forums.svg"}
  {else}
    {include file='__page_header.tpl' _title=__("Forums") _text=__($system['system_description_forums']) _image="forums.svg"}
  {/if}
  <!-- page heading -->

  {if $view == "" || $view == "recent" || $view == "forum" || $view == "my-threads" || $view == "my-replies" || $view == "search" || $view == "search-results"}

    {include file='__forum_nav.tpl'}

    <div class="mt-6 flex min-w-0 flex-col gap-4">

        {if $view == ""}

          <div class="flex flex-col gap-6 lg:flex-row lg:items-start">

            <div class="flex min-w-0 grow flex-col gap-4">
              <!-- forums -->
              {if $forums}
                {foreach $forums as $_section}
                  <section class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none" aria-label="{__($_section['forum_name'])}">
                    {include file='__card_header.tpl' _card_title=__($_section['forum_name']) _card_url="`$system['system_url']`/forums/`$_section['forum_id']`/`$_section['title_url']`"}
                    <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 block p-0">
                      {if $_section['childs']}
                        <ul class="divide-y divide-base-300">
                          {foreach $_section['childs'] as $_forum}
                            {include file='__forum_row.tpl'}
                          {/foreach}
                        </ul>
                      {else}
                        {include file='_no_data.tpl' _empty_icon="icon-[tabler--messages]" _empty_compact=true}
                      {/if}
                    </div>
                  </section>
                {/foreach}
              {else}
                <div class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 shadow-none">
                  {include file='_no_data.tpl' _empty_icon="icon-[tabler--messages]"}
                </div>
              {/if}
              <!-- forums -->
            </div>

            {if $recent_threads || $system['forums_online_enabled'] || $system['forums_statistics_enabled']}
              <!-- forums meta -->
              <aside class="flex flex-col gap-4 lg:sticky lg:top-24 lg:w-80 lg:shrink-0">
                {if $recent_threads}
                  <div class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none text-sm">
                    {include file='__card_header.tpl' _card_title=__("Recent") _card_url="`$system['system_url']`/forums/recent" _card_label=__("See All")}
                    <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 block p-3">
                      <ul class="flex flex-col gap-0.5">
                        {foreach $recent_threads as $_recent}
                          <li>
                            <a class="flex items-center gap-3 rounded-2xl p-2 text-base-content! hover:bg-base-200" href="{$system['system_url']}/forums/thread/{$_recent['thread_id']}/{$_recent['title_url']}">
                              <img class="size-9 shrink-0 rounded-full object-cover" src="{$_recent['user_picture']}" alt="{$_recent['user_fullname']}" loading="lazy">
                              <span class="min-w-0 grow">
                                <span class="block truncate font-medium" title="{$_recent['title']}">{$_recent['title']}</span>
                                <span class="flex items-center gap-2 text-xs text-base-content/60">
                                  <span class="js_moment" data-time="{$_recent['last_reply']}">{$_recent['last_reply']}</span>
                                  <span class="flex items-center gap-1" title='{__("Replies")}'><span class="icon-[tabler--message-circle] size-3.5" aria-hidden="true"></span>{$_recent['replies']|abbreviate_count}</span>
                                </span>
                              </span>
                            </a>
                          </li>
                        {/foreach}
                      </ul>
                    </div>
                  </div>
                {/if}
                {if $system['forums_statistics_enabled']}
                  <div class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none text-sm">
                    {include file='__card_header.tpl' _card_title=__("Statistics")}
                    <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 flex flex-col gap-2 p-3">
                      <div class="flex items-center gap-3 rounded-[1.375rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.875rem] bg-[#F9F9F9] dark:bg-base-200 p-2">
                        <span class="inline-flex size-11 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.25rem] bg-base-100 text-primary" aria-hidden="true"><span class="icon-[tabler--file-text] size-5"></span></span>
                        <span class="min-w-0 grow text-base-content/60">{__("Threads")}</span>
                        <span class="pe-3 text-base font-semibold" title="{$insights['threads']|number_format:0}">{$insights['threads']|abbreviate_count}</span>
                      </div>
                      <div class="flex items-center gap-3 rounded-[1.375rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.875rem] bg-[#F9F9F9] dark:bg-base-200 p-2">
                        <span class="inline-flex size-11 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.25rem] bg-base-100 text-info" aria-hidden="true"><span class="icon-[tabler--message-circle] size-5"></span></span>
                        <span class="min-w-0 grow text-base-content/60">{__("Replies")}</span>
                        <span class="pe-3 text-base font-semibold" title="{$insights['replies']|number_format:0}">{$insights['replies']|abbreviate_count}</span>
                      </div>
                      <div class="flex items-center gap-3 rounded-[1.375rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.875rem] bg-[#F9F9F9] dark:bg-base-200 p-2">
                        <span class="inline-flex size-11 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.25rem] bg-base-100 text-success" aria-hidden="true"><span class="icon-[tabler--users] size-5"></span></span>
                        <span class="min-w-0 grow text-base-content/60">{__("Members")}</span>
                        <span class="pe-3 text-base font-semibold" title="{$insights['users']|number_format:0}">{$insights['users']|abbreviate_count}</span>
                      </div>
                    </div>
                  </div>
                {/if}
                {if $system['forums_online_enabled']}
                  <div class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none text-sm">
                    {include file='__card_header.tpl' _card_title=__("Who's online") _card_count=count($online_users)}
                    <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 block p-3">
                      {if $online_users}
                        <ul class="flex max-h-80 flex-col gap-0.5 overflow-y-auto">
                          {foreach $online_users as $_user}
                            {capture assign="_online_name"}{if $system['show_usernames_enabled']}{$_user['user_name']}{else}{$_user['user_firstname']} {$_user['user_lastname']}{/if}{/capture}
                            <li>
                              <a class="flex items-center gap-3 rounded-2xl p-2 text-base-content! hover:bg-base-200" href="{$system['system_url']}/{$_user['user_name']}">
                                <span class="relative shrink-0">
                                  <img class="size-9 rounded-full object-cover" src="{$_user['user_picture']}" alt="" loading="lazy">
                                  <span class="absolute end-0 bottom-0 size-2.5 rounded-full bg-success ring-2 ring-base-100" aria-hidden="true"></span>
                                </span>
                                <span class="min-w-0 truncate font-medium" title="{$_online_name}">{$_online_name}</span>
                              </a>
                            </li>
                          {/foreach}
                        </ul>
                      {else}
                        {include file='_no_data.tpl' _empty_icon="icon-[tabler--users]" _empty_compact=true}
                      {/if}
                    </div>
                  </div>
                {/if}
              </aside>
              <!-- forums meta -->
            {/if}

          </div>

        {elseif $view == "recent"}

          <!-- threads -->
          <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none" aria-label="{__("Recent")}">
            <div class="flex items-center gap-3 px-5 py-2.5">
              <h2 class="min-w-0 grow truncate text-sm font-semibold" title="{__("Recent")}">{__("Recent")}</h2>
              {include file='__forum_sort.tpl' _url="`$system['system_url']`/forums/recent"}
            </div>
            <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] overflow-hidden bg-base-100 block p-0">
              {if $threads}
                <ul class="divide-y divide-base-300">
                  {foreach $threads as $thread}
                    {include file='__forum_thread.tpl' _thread=$thread _forum=$thread['forum'] _show_forum=true}
                  {/foreach}
                </ul>
              {else}
                {include file='_no_data.tpl' _empty_icon="icon-[tabler--messages]" _empty_title=__("No Threads")}
              {/if}
            </div>
          </section>
          {if $pager}{$pager}{/if}
          <!-- threads -->

        {elseif $view == "forum"}

          {include file='__forum_breadcrumb.tpl' _parents=$forum['parents'] _current=__($forum['forum_name']) _flush=true}

          <!-- childs (forums|sub-forums) -->
          {if $forum['childs']}
            <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none overflow-hidden" aria-label="{__("Forums")}">
              {include file='__card_header.tpl' _card_title=__("Forums")}
              <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 block p-0">
                <ul class="divide-y divide-base-300">
                  {foreach $forum['childs'] as $_forum}
                    {include file='__forum_row.tpl'}
                  {/foreach}
                </ul>
              </div>
            </section>
          {/if}
          <!-- childs (forums|sub-forums) -->

          <!-- threads -->
          {if $forum['forum_section'] != '0'}
            <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none" aria-label="{__("Threads")}">
              <div class="flex items-center gap-3 px-5 py-2.5">
                <h2 class="min-w-0 grow truncate text-sm font-semibold" title="{__("Threads")}">{__("Threads")}</h2>
                {include file='__forum_sort.tpl' _url="`$system['system_url']`/forums/`$forum['forum_id']`/`$forum['title_url']`"}
              </div>
              <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] overflow-hidden bg-base-100 block p-0">
                {if $forum['threads']}
                  <ul class="divide-y divide-base-300">
                    {foreach $forum['threads'] as $thread}
                      {include file='__forum_thread.tpl' _thread=$thread _forum=$forum _show_forum=false}
                    {/foreach}
                  </ul>
                {else}
                  {include file='_no_data.tpl' _empty_icon="icon-[tabler--file-text]" _empty_title=__("No Threads")}
                {/if}
              </div>
            </section>
            {if $pager}{$pager}{/if}
          {/if}
          <!-- threads -->

        {elseif $view == "my-threads"}

          <!-- threads -->
          <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none overflow-hidden" aria-label="{__("My Threads")}">
            {include file='__card_header.tpl' _card_title=__("My Threads")}
            <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 block p-0">
              {if $threads}
                <ul class="divide-y divide-base-300">
                  {foreach $threads as $thread}
                    {include file='__forum_thread.tpl' _thread=$thread _forum=$thread['forum'] _show_forum=true}
                  {/foreach}
                </ul>
              {else}
                {include file='_no_data.tpl' _empty_icon="icon-[tabler--file-text]" _empty_title=__("No Threads")}
              {/if}
            </div>
          </section>
          {if $pager}{$pager}{/if}
          <!-- threads -->

        {elseif $view == "my-replies"}

          <!-- replies -->
          <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none overflow-hidden" aria-label="{__("My Replies")}">
            {include file='__card_header.tpl' _card_title=__("My Replies")}
            <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 block p-0">
              {if $replies}
                <ul class="divide-y divide-base-300">
                  {foreach $replies as $reply}
                    {include file='__forum_result.tpl' _thread=$reply['thread'] _time=$reply['time'] _snippet=$reply['text_snippet'] _link="`$system['system_url']`/forums/thread/`$reply['thread']['thread_id']`/`$reply['thread']['title_url']`#reply-`$reply['reply_id']`"}
                  {/foreach}
                </ul>
              {else}
                {include file='_no_data.tpl' _empty_icon="icon-[tabler--messages]"}
              {/if}
            </div>
          </section>
          {if $pager}{$pager}{/if}
          <!-- replies -->

        {elseif $view == "search"}

          <!-- search -->
          <div class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none overflow-hidden">
            <form action="{$system['system_url']}/forums/search-results" method="get">
              {include file='__card_header.tpl' _card_title=__("Search")}
              <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 gap-6 p-5 sm:p-6">
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="forum-search-query">{__("Keyword(s)")}</label>
                  <label class="input w-full">
                    <span class="icon-[tabler--search] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
                    <input type="search" class="grow" name="query" id="forum-search-query" required autofocus>
                  </label>
                </div>
                <div class="grid gap-6 sm:grid-cols-2">
                  <div class="w-full">
                    <label class="label-text mb-1.5 block" for="forum-search-type">{__("Search For")}</label>
                    <select class="select w-full" name="type" id="forum-search-type">
                      <option value="threads">{__("Threads")}</option>
                      <option value="replies">{__("Replies")}</option>
                    </select>
                  </div>
                  <div class="w-full">
                    <label class="label-text mb-1.5 block" for="forum-search-forum">{__("Search in Forum(s)")}</label>
                    <select class="select w-full" name="forum" id="forum-search-forum">
                      <option value="all">{__("Search All Forums")}</option>
                      {foreach $forums as $forum}
                        {include file='admin.forums.recursive_options.tpl'}
                      {/foreach}
                    </select>
                  </div>
                </div>
                <label class="flex w-fit cursor-pointer items-center gap-2" for="recursive">
                  <input type="checkbox" class="checkbox checkbox-primary checkbox-sm shrink-0" name="recursive" id="recursive">
                  <span class="label-text">{__("Also search in child forums")}</span>
                </label>
              </div>
              <div class="flex justify-end gap-3 bg-base-100 px-5 pb-5 sm:px-6 sm:pb-6">
                <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
                  <span class="icon-[tabler--search] size-4" aria-hidden="true"></span>
                  {__("Search")}
                </button>
              </div>
            </form>
          </div>
          <!-- search -->

        {elseif $view == "search-results"}

          <!-- search results -->
          {capture assign="_search_title"}{__("Search Results")}: {$query}{/capture}
          {if !$total}{$total = 0}{/if}
          <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none overflow-hidden" aria-label="{__("Search Results")}">
            {include file='__card_header.tpl' _card_title=$_search_title _card_count=$total}
            <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 block p-0">
              {if $results}
                <ul class="divide-y divide-base-300">
                  {if $type == "threads"}
                    {foreach $results as $thread}
                      {include file='__forum_thread.tpl' _thread=$thread _forum=$thread['forum'] _show_forum=true}
                    {/foreach}
                  {else}
                    {foreach $results as $reply}
                      {include file='__forum_result.tpl' _thread=$reply['thread'] _time=$reply['time'] _snippet=$reply['text_snippet'] _link="`$system['system_url']`/forums/thread/`$reply['thread']['thread_id']`/`$reply['thread']['title_url']`#reply-`$reply['reply_id']`"}
                    {/foreach}
                  {/if}
                </ul>
              {else}
                {include file='_no_data.tpl' _empty_icon="icon-[tabler--search]"}
              {/if}
            </div>
          </section>
          {if $pager}{$pager}{/if}
          <!-- search results -->

        {/if}

    </div>

  {elseif $view == "thread"}

    {include file='__forum_breadcrumb.tpl' _parents=$thread['forum']['parents'] _forum=$thread['forum']}

    {$_can_reply = false}
    {if $user->_logged_in && $user->_data['can_use_forums']}
      {if !$thread['is_locked'] || $thread['moderate_thread']}
        {$_can_reply = true}
      {/if}
    {/if}

    {$_thread_url = "`$system['system_url']`/forums/thread/`$thread['thread_id']`/`$thread['title_url']`"}

    <!-- thread title -->
    <div class="mt-4 min-w-0" style="--forum-color: {if $thread['forum']['forum_color']}{$thread['forum']['forum_color']}{else}var(--color-primary){/if}">
      <h2 class="text-xl font-bold tracking-tight break-words sm:text-2xl">{$thread['title']}</h2>
      <div class="mt-3 flex items-start gap-3 lg:pe-68">
        <div class="flex min-w-0 grow flex-wrap items-center gap-2 text-xs">
          <a class="inline-flex max-w-56 items-center gap-1.5 rounded-md bg-(--forum-color) px-2 py-1 font-semibold text-white!" href="{$system['system_url']}/forums/{$thread['forum']['forum_id']}/{$thread['forum']['title_url']}">
            <span class="{include file='__forum_icon.tpl' _icon=$thread['forum']['forum_icon']} size-3.5 shrink-0" aria-hidden="true"></span>
            <span class="truncate" title="{__($thread['forum']['forum_name'])}">{__($thread['forum']['forum_name'])}</span>
          </a>
          <span class="rounded-md border border-base-300 bg-base-100 px-2 py-1 text-base-content/70"><strong class="font-semibold text-base-content">{$navigator['total']|abbreviate_count}</strong> {__("Posts")}</span>
          <span class="rounded-md border border-base-300 bg-base-100 px-2 py-1 text-base-content/70"><strong class="font-semibold text-base-content">{$thread['posters']|abbreviate_count}</strong> {__("Posters")}</span>
          <span class="rounded-md border border-base-300 bg-base-100 px-2 py-1 text-base-content/70"><strong class="font-semibold text-base-content">{$thread['views']|abbreviate_count}</strong> {__("Views")}</span>
          {if $rss_url}
            <a class="inline-flex items-center rounded-md border border-base-300 bg-base-100 px-2 py-1 text-orange-600! hover:bg-orange-500/10 dark:text-orange-400!" href="{$rss_url}" title='{__("RSS")}' aria-label='{__("RSS")}'>
              <span class="icon-[tabler--rss] size-4" aria-hidden="true"></span>
            </a>
          {/if}
          {if $thread['is_pinned']}
            <span class="inline-flex items-center gap-1 rounded-md bg-amber-500/15 px-2 py-1 font-medium text-amber-700 dark:text-amber-400"><span class="icon-[tabler--pin] size-3.5" aria-hidden="true"></span>{__("Pinned")}</span>
          {/if}
          {if $thread['is_locked']}
            <span class="inline-flex items-center gap-1 rounded-md bg-red-500/10 px-2 py-1 font-medium text-red-600 dark:text-red-400"><span class="icon-[tabler--lock] size-3.5" aria-hidden="true"></span>{__("Locked")}</span>
          {/if}
        </div>
        {if $thread['moderate_thread'] || $thread['manage_thread']}
          <div class="dropdown relative inline-flex shrink-0 [--placement:bottom-end]">
            <button type="button" class="dropdown-toggle heroui button button--tertiary button--sm button--icon-only size-8 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" id="forum-thread-menu" aria-haspopup="menu" aria-expanded="false" aria-label='{__("More")}'>
              <span class="icon-[tabler--dots] size-4" aria-hidden="true"></span>
            </button>
            <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-48 rounded-2xl border border-base-300 bg-base-100 p-2 shadow-lg" role="menu" aria-labelledby="forum-thread-menu">
              {if $thread['moderate_thread']}
                <button type="button" class="dropdown-close dropdown-item flex w-full items-center gap-2.5 rounded-xl px-3 py-2 text-start text-sm font-medium js_forum-thread-action" role="menuitem" data-do="{if $thread['is_pinned']}unpin{else}pin{/if}" data-id="{$thread['thread_id']}">
                  <span class="{if $thread['is_pinned']}icon-[tabler--pinned-off]{else}icon-[tabler--pin]{/if} size-4.5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                  {if $thread['is_pinned']}{__("Unpin")}{else}{__("Pin")}{/if}
                </button>
                <button type="button" class="dropdown-close dropdown-item flex w-full items-center gap-2.5 rounded-xl px-3 py-2 text-start text-sm font-medium js_forum-thread-action" role="menuitem" data-do="{if $thread['is_locked']}unlock{else}lock{/if}" data-id="{$thread['thread_id']}">
                  <span class="{if $thread['is_locked']}icon-[tabler--lock-open]{else}icon-[tabler--lock]{/if} size-4.5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                  {if $thread['is_locked']}{__("Unlock")}{else}{__("Lock")}{/if}
                </button>
              {/if}
              {if $thread['manage_thread']}
                <button type="button" class="dropdown-close dropdown-item flex w-full items-center gap-2.5 rounded-xl px-3 py-2 text-start text-sm font-medium text-error js_delete-forum" role="menuitem" data-handle="thread" data-id="{$thread['thread_id']}">
                  <span class="icon-[tabler--trash] size-4.5 shrink-0" aria-hidden="true"></span>
                  {__("Delete")}
                </button>
              {/if}
            </div>
          </div>
        {/if}
      </div>
    </div>
    <!-- thread title -->

    <div class="mt-6 flex flex-col gap-6 lg:flex-row lg:items-start lg:gap-8">

      <div class="flex min-w-0 grow flex-col gap-4">

        <!-- thread -->
        <div class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-4 shadow-none sm:p-6">
          {include file='__forum_post.tpl' _post=$thread _post_id=$thread['thread_id'] _handle="thread" _manage=$thread['manage_thread'] _edit="`$system['system_url']`/forums/edit-thread/`$thread['thread_id']`" _link=$_thread_url _id="" _index=1 _ord=1 _last=($thread['replies'] == 0) _hidden=($thread['replies'] > 0 && $selected_page != 1)}
          {if $thread['replies'] > 0}
            {foreach $thread['thread_replies'] as $reply}
              {if $navigator['sort'] == "newest"}
                {$_index = $navigator['total'] - $navigator['offset'] - $reply@iteration + 1}
              {else}
                {$_index = $navigator['offset'] + $reply@iteration + 1}
              {/if}
              {$_ord = $navigator['offset'] + $reply@iteration + 1}
              {include file='__forum_post.tpl' _post=$reply _post_id=$reply['reply_id'] _handle="reply" _manage=$reply['manage_reply'] _edit="`$system['system_url']`/forums/edit-reply/`$reply['reply_id']`" _link="`$_thread_url`#reply-`$reply['reply_id']`" _id="reply-`$reply['reply_id']`" _index=$_index _ord=$_ord _last=$reply@last _hidden=false}
            {/foreach}
          {/if}
        </div>
        {if $thread['replies'] > 0 && $pager}{$pager}{/if}
        <!-- thread -->

        <!-- reply -->
        {if $thread['is_locked']}
          <div class="flex items-center gap-3 rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 p-3" role="status">
            <span class="inline-flex size-11 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.25rem] bg-base-100 text-base-content/70" aria-hidden="true"><span class="icon-[tabler--lock] size-5"></span></span>
            <div class="min-w-0 text-sm">
              <div class="font-semibold">{__("This thread is locked")}</div>
              <div class="text-base-content/60">{__("New replies are no longer accepted")}</div>
            </div>
          </div>
        {/if}
        {if $_can_reply}
          <div class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none overflow-hidden" id="forum-reply">
            {include file='__card_header.tpl' _card_title=__("Post Reply")}
            <form class="js_ajax-forms rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] flex gap-3 bg-base-100 p-4 sm:gap-4 sm:p-6" data-url="forums/reply.php?do=create&id={$thread['thread_id']}">
              <img class="hidden size-10 shrink-0 rounded-full object-cover sm:block" src="{$user->_data['user_picture']}" alt="">
              <div class="flex min-w-0 grow flex-col gap-4">
                <!-- quote -->
                <input type="hidden" name="reply_to_id" value="">
                <div class="hidden items-start gap-2 js_forum-reply-quote">
                  <div class="min-w-0 grow rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-base-200/60 px-4 py-3 text-sm">
                    <div class="flex min-w-0 items-center gap-1.5 text-xs text-base-content/60">
                      <img class="size-5 shrink-0 rounded-full object-cover js_forum-reply-quote-picture" src="" alt="">
                      <span class="truncate font-semibold text-base-content js_forum-reply-quote-name"></span>
                      <span class="shrink-0">{__("said")}:</span>
                    </div>
                    <p class="mt-1.5 line-clamp-3 text-base-content/75 js_forum-reply-quote-text"></p>
                  </div>
                  <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 shrink-0 rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-[0.75rem] js_forum-reply-cancel" title='{__("Cancel")}' aria-label='{__("Cancel")}'>
                    <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
                  </button>
                </div>
                <!-- quote -->
                <textarea class="textarea js_wysiwyg w-full" name="text" id="forum-editor" aria-label="{__("Post Reply")}"></textarea>

                <!-- error -->
                <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
                <!-- error -->

                <div class="flex justify-end">
                  <button type="submit" class="heroui button button--primary rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
                    <span class="icon-[tabler--arrow-back-up] size-4" aria-hidden="true"></span>
                    {__("Post Reply")}
                  </button>
                </div>
              </div>
            </form>
          </div>
        {/if}
        <!-- reply -->

      </div>

      <!-- thread sidebar -->
      <aside class="flex flex-col gap-4 lg:sticky lg:top-24 lg:w-60 lg:shrink-0">
        {if $_can_reply}
          <a class="heroui button button--primary rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] w-full max-lg:hidden" href="#forum-reply">
            <span class="icon-[tabler--arrow-back-up] size-4" aria-hidden="true"></span>
            {__("Post Reply")}
          </a>
        {elseif !$user->_logged_in}
          <a class="heroui button button--primary rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] w-full" href="{$system['system_url']}/signin">
            <span class="icon-[tabler--login-2] size-4" aria-hidden="true"></span>
            {__("Log in to reply")}
          </a>
        {/if}
        {if $navigator['sort'] == "newest"}
          <a class="flex items-center gap-2.5 px-1 text-sm font-medium text-base-content! hover:text-primary!" href="{$_thread_url}">
            <span class="icon-[tabler--sort-descending] size-5 text-primary" aria-hidden="true"></span>
            {__("Newest to Oldest")}
          </a>
        {else}
          <a class="flex items-center gap-2.5 px-1 text-sm font-medium text-base-content! hover:text-primary!" href="{$_thread_url}?sort=newest">
            <span class="icon-[tabler--sort-ascending] size-5 text-primary" aria-hidden="true"></span>
            {__("Oldest to Newest")}
          </a>
        {/if}

        <!-- navigator -->
        <nav class="hidden flex-col border-t border-base-300 pt-4 text-sm lg:flex js_forum-scrubber" aria-label="{__("Posts")}" data-total="{$navigator['total']}" data-per-page="{$navigator['per_page']}" data-sort="{$navigator['sort']}" data-url="{$_thread_url}">
          <a class="flex items-center gap-2.5 text-base-content/60! hover:text-primary!" href="{$_thread_url}?sort={$navigator['sort']}">
            <span class="icon-[tabler--chevrons-up] size-5" aria-hidden="true"></span>
            {__("Original Post")}
          </a>
          <div class="relative my-2 h-64 cursor-pointer touch-none select-none js_forum-scrubber-track">
            <span class="absolute inset-y-0 start-2.5 w-px -translate-x-1/2 bg-base-300 rtl:translate-x-1/2" aria-hidden="true"></span>
            <div class="absolute inset-x-0 top-0 flex h-11 cursor-grab items-center gap-3 active:cursor-grabbing js_forum-scrubber-handle" role="slider" tabindex="0" aria-orientation="vertical" aria-label="{__("Posts")}" aria-valuemin="1" aria-valuemax="{$navigator['total']}" aria-valuenow="1">
              <span class="ms-1.5 h-full w-2 shrink-0 rounded-full bg-primary" aria-hidden="true"></span>
              <span class="min-w-0">
                <span class="block truncate font-semibold"><span class="js_forum-scrubber-index">1</span> {__("of")} {$navigator['total']|number_format:0} {__("Posts")}</span>
                <span class="block truncate text-xs text-base-content/60 js_forum-scrubber-date"></span>
              </span>
            </div>
          </div>
          <a class="flex items-center gap-2.5 text-base-content/60! hover:text-primary!" href="{$_thread_url}?sort={$navigator['sort']}&page={$navigator['last_page']}&post={$navigator['total']}">
            <span class="icon-[tabler--chevrons-down] size-5" aria-hidden="true"></span>
            {if $navigator['sort'] == "newest"}{__("Oldest")}{else}{__("Now")}{/if}
          </a>
        </nav>
        <!-- navigator -->
      </aside>
      <!-- thread sidebar -->

    </div>

    {if $thread['suggested_threads']}
      <!-- suggested threads -->
      <section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none mt-8 overflow-hidden" aria-label="{__("Suggested Threads")}">
        {include file='__card_header.tpl' _card_title=__("Suggested Threads")}
        <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 block p-0">
          <ul class="divide-y divide-base-300">
            {foreach $thread['suggested_threads'] as $_suggested}
              {include file='__forum_thread.tpl' _thread=$_suggested _forum=$_suggested['forum'] _show_forum=true}
            {/foreach}
          </ul>
        </div>
      </section>
      <!-- suggested threads -->
    {/if}

  {elseif $view == "new-thread" || $view == "edit-thread" || $view == "new-reply" || $view == "edit-reply"}

    {if $view == "new-thread"}
      {include file='__forum_breadcrumb.tpl' _parents=$forum['parents'] _forum=$forum _current=__("Start a Discussion")}
    {elseif $view == "edit-thread"}
      {include file='__forum_breadcrumb.tpl' _parents=$thread['forum']['parents'] _forum=$thread['forum'] _thread=$thread _current=__("Edit Thread")}
    {elseif $view == "new-reply"}
      {include file='__forum_breadcrumb.tpl' _parents=$thread['forum']['parents'] _forum=$thread['forum'] _thread=$thread _current=__("Post Reply")}
    {else}
      {include file='__forum_breadcrumb.tpl' _parents=$reply['thread']['forum']['parents'] _forum=$reply['thread']['forum'] _thread=$reply['thread'] _current=__("Edit Reply")}
    {/if}

    <!-- editor -->
    <div class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none mx-auto mt-4 max-w-4xl overflow-hidden">
      <form class="js_ajax-forms" data-url="{if $view == "new-thread"}forums/thread.php?do=create{elseif $view == "edit-thread"}forums/thread.php?do=edit&id={$thread['thread_id']}{elseif $view == "new-reply"}forums/reply.php?do=create&id={$thread['thread_id']}{else}forums/reply.php?do=edit&id={$reply['reply_id']}{/if}">
        {if $view == "new-thread"}
          {include file='__card_header.tpl' _card_title=__("Start a Discussion")}
        {elseif $view == "edit-thread"}
          {include file='__card_header.tpl' _card_title=__("Edit Thread")}
        {elseif $view == "new-reply"}
          {include file='__card_header.tpl' _card_title=__("Post Reply")}
        {else}
          {include file='__card_header.tpl' _card_title=__("Edit Reply")}
        {/if}
        <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 gap-6 p-5 sm:p-6">
          {if $view == "new-thread"}
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="forum-thread-forum">{__("Forum")}</label>
              <select class="select w-full" name="forum_id" id="forum-thread-forum">
                <option value="">{__("Select Forum")}</option>
                {foreach $forums as $_section}
                  {include file='__forum_options.tpl' _node=$_section _selected=$forum['forum_id']}
                {/foreach}
              </select>
            </div>
          {/if}
          {if $view == "new-thread" || $view == "edit-thread"}
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="forum-thread-title">{__("Title")}</label>
              <input type="text" class="input w-full" name="title" id="forum-thread-title" value="{if $view == "edit-thread"}{$thread['title']}{/if}">
            </div>
          {/if}
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="forum-editor">{__("Content")}</label>
            <textarea class="textarea js_wysiwyg w-full" name="text" id="forum-editor">{if $view == "edit-thread"}{$thread['text']}{elseif $view == "edit-reply"}{$reply['text']}{/if}</textarea>
          </div>

          <!-- error -->
          <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
          <!-- error -->
        </div>
        <div class="flex justify-end gap-3 bg-base-100 px-5 pb-5 sm:px-6 sm:pb-6">
          <button type="submit" class="heroui button button--primary rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
            {if $view == "new-thread"}{__("Publish")}{elseif $view == "new-reply"}{__("Reply")}{else}{__("Update")}{/if}
          </button>
        </div>
      </form>
    </div>
    <!-- editor -->

  {/if}

</div>
<!-- page content -->

{include file='_footer.tpl'}
