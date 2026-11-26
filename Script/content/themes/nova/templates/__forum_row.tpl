<li class="flex flex-col gap-4 px-4 py-5 sm:px-6 lg:flex-row lg:items-start lg:gap-6" style="--forum-color: {if $_forum['forum_color']}{$_forum['forum_color']}{else}var(--color-primary){/if}">
  <div class="flex min-w-0 grow items-start gap-4">
    <span class="inline-flex size-11 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.25rem] bg-(--forum-color)/10 text-(--forum-color)" aria-hidden="true">
      <span class="{include file='__forum_icon.tpl' _icon=$_forum['forum_icon']} size-5"></span>
    </span>
    <div class="min-w-0 grow">
      <a class="text-base leading-snug font-semibold text-base-content! hover:text-(--forum-color)!" href="{$system['system_url']}/forums/{$_forum['forum_id']}/{$_forum['title_url']}">{__($_forum['forum_name'])}</a>
      {if $_forum['forum_description']}
        <p class="mt-0.5 text-sm text-base-content/60">{__($_forum['forum_description'])|nl2br}</p>
      {/if}
      {if $_forum['childs']}
        <ul class="mt-3 grid gap-x-6 gap-y-1.5 sm:grid-cols-2">
          {foreach $_forum['childs'] as $__forum}
            <li class="min-w-0">
              <a class="flex items-center gap-1.5 text-sm font-medium text-base-content! hover:text-(--forum-color)!" href="{$system['system_url']}/forums/{$__forum['forum_id']}/{$__forum['title_url']}">
                <span class="icon-[tabler--caret-right-filled] size-3.5 shrink-0 text-(--forum-color) rtl:rotate-180" aria-hidden="true"></span>
                <span class="truncate" title="{__($__forum['forum_name'])}">{__($__forum['forum_name'])}</span>
              </a>
            </li>
          {/foreach}
        </ul>
      {/if}
    </div>
  </div>
  <div class="flex shrink-0 items-stretch gap-2 lg:w-96">
    <div class="flex w-18 shrink-0 flex-col items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.25rem] bg-base-200/60 px-2 py-2 text-center">
      <span class="text-base leading-tight font-semibold text-base-content/80" title="{$_forum['total_threads']|number_format:0}">{$_forum['total_threads']|abbreviate_count}</span>
      <span class="text-xs text-base-content/60 lowercase">{__("Threads")}</span>
    </div>
    <div class="flex w-18 shrink-0 flex-col items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.25rem] bg-base-200/60 px-2 py-2 text-center">
      <span class="text-base leading-tight font-semibold text-base-content/80" title="{$_forum['total_replies']|number_format:0}">{$_forum['total_replies']|abbreviate_count}</span>
      <span class="text-xs text-base-content/60 lowercase">{__("Replies")}</span>
    </div>
    <div class="min-w-0 grow border-s-2 border-(--forum-color) ps-3">
      {if $_forum['last_post']}
        <div class="flex items-center gap-1.5 text-xs text-base-content/60">
          <a class="shrink-0" href="{$system['system_url']}/{$_forum['last_post']['user_name']}" title="{$_forum['last_post']['user_fullname']}">
            <img class="size-5 rounded-full object-cover" src="{$_forum['last_post']['user_picture']}" alt="{$_forum['last_post']['user_fullname']}" loading="lazy">
          </a>
          <span class="js_moment" data-time="{$_forum['last_post']['time']}">{$_forum['last_post']['time']}</span>
        </div>
        <a class="mt-1 line-clamp-2 text-sm text-base-content/85! hover:text-(--forum-color)!" href="{$system['system_url']}/forums/thread/{$_forum['last_post']['thread_id']}/{$_forum['last_post']['title_url']}{if $_forum['last_post']['reply_id']}#reply-{$_forum['last_post']['reply_id']}{/if}" title="{$_forum['last_post']['title']}">
          {if $_forum['last_post']['text_snippet']}{$_forum['last_post']['text_snippet']|truncate:120}{else}{$_forum['last_post']['title']}{/if}
        </a>
      {else}
        <p class="text-sm text-base-content/50">{__("No Threads")}</p>
      {/if}
    </div>
  </div>
</li>
