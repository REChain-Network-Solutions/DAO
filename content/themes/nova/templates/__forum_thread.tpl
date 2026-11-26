<li class="flex flex-col gap-4 px-4 py-5 sm:px-6 lg:flex-row lg:items-start lg:gap-6" style="--forum-color: {if $_forum['forum_color']}{$_forum['forum_color']}{else}var(--color-primary){/if}">
  <div class="flex min-w-0 grow items-start gap-4">
    <a class="shrink-0" href="{$system['system_url']}/{$_thread['user_name']}" title="{$_thread['user_fullname']}">
      <img class="size-10 rounded-full object-cover" src="{$_thread['user_picture']}" alt="{$_thread['user_fullname']}" loading="lazy">
    </a>
    <div class="min-w-0 grow">
      <div class="flex min-w-0 items-center gap-1.5">
        <a class="line-clamp-2 text-base leading-snug font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/forums/thread/{$_thread['thread_id']}/{$_thread['title_url']}" title="{$_thread['title']}">{$_thread['title']}</a>
      </div>
      <div class="mt-1.5 flex flex-wrap items-center gap-x-3 gap-y-1.5 text-xs text-base-content/60">
        {if $_show_forum}
          {include file='__forum_tag.tpl' _forum=$_forum}
        {/if}
        <span class="js_moment" data-time="{$_thread['time']}">{$_thread['time']}</span>
        {if $_thread['is_pinned']}
          <span class="inline-flex items-center gap-1 rounded-full bg-amber-500/15 px-2 py-0.5 font-medium text-amber-700 dark:text-amber-400"><span class="icon-[tabler--pin] size-3.5" aria-hidden="true"></span>{__("Pinned")}</span>
        {/if}
        {if $_thread['is_locked']}
          <span class="inline-flex items-center gap-1 rounded-full bg-red-500/10 px-2 py-0.5 font-medium text-red-600 dark:text-red-400"><span class="icon-[tabler--lock] size-3.5" aria-hidden="true"></span>{__("Locked")}</span>
        {/if}
      </div>
    </div>
  </div>
  <div class="flex shrink-0 items-stretch gap-2 lg:w-[31rem]">
    <div class="flex w-18 shrink-0 flex-col items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.25rem] bg-base-200/60 px-2 py-2 text-center">
      <span class="text-base leading-tight font-semibold text-base-content/80" title="{$_thread['likes']|number_format:0}">{$_thread['likes']|abbreviate_count}</span>
      <span class="text-xs text-base-content/60 lowercase">{__("Likes")}</span>
    </div>
    <div class="flex w-18 shrink-0 flex-col items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.25rem] bg-base-200/60 px-2 py-2 text-center">
      <span class="text-base leading-tight font-semibold text-base-content/80" title="{$_thread['replies']|number_format:0}">{$_thread['replies']|abbreviate_count}</span>
      <span class="text-xs text-base-content/60 lowercase">{__("Replies")}</span>
    </div>
    <div class="flex w-18 shrink-0 flex-col items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.25rem] bg-base-200/60 px-2 py-2 text-center">
      <span class="text-base leading-tight font-semibold text-base-content/80" title="{$_thread['views']|number_format:0}">{$_thread['views']|abbreviate_count}</span>
      <span class="text-xs text-base-content/60 lowercase">{__("Views")}</span>
    </div>
    <div class="min-w-0 grow border-s-2 border-base-300 ps-3">
      <div class="flex items-center gap-1.5 text-xs text-base-content/60">
        <a class="shrink-0" href="{$system['system_url']}/{$_thread['last_post']['user_name']}" title="{$_thread['last_post']['user_fullname']}">
          <img class="size-5 rounded-full object-cover" src="{$_thread['last_post']['user_picture']}" alt="{$_thread['last_post']['user_fullname']}" loading="lazy">
        </a>
        <span class="js_moment" data-time="{$_thread['last_post']['time']}">{$_thread['last_post']['time']}</span>
      </div>
      <a class="mt-1 line-clamp-2 text-sm text-base-content/85! hover:text-primary!" href="{$system['system_url']}/forums/thread/{$_thread['thread_id']}/{$_thread['title_url']}{if $_thread['last_post']['reply_id']}#reply-{$_thread['last_post']['reply_id']}{/if}" title="{$_thread['title']}">
        {if $_thread['last_post']['text_snippet']}{$_thread['last_post']['text_snippet']|truncate:120}{else}{$_thread['title']}{/if}
      </a>
    </div>
  </div>
</li>
