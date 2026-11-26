<li class="flex flex-col gap-2 px-4 py-4 sm:px-5">
  <div class="flex flex-wrap items-center justify-between gap-2 text-xs text-base-content/60">
    {include file='__forum_tag.tpl' _forum=$_thread['forum']}
    <span class="flex items-center gap-1">
      <span class="icon-[tabler--clock] size-3.5" aria-hidden="true"></span>
      <span class="js_moment" data-time="{$_time}">{$_time}</span>
    </span>
  </div>
  <a class="block truncate font-semibold text-base-content! hover:text-primary!" href="{$_link}" title="{$_thread['title']}">{$_thread['title']}</a>
  {if $_snippet}
    <p class="line-clamp-3 border-s-2 border-base-300 ps-3 text-sm text-base-content/75" title="{$_snippet}">{$_snippet|truncate:300}</p>
  {/if}
</li>
