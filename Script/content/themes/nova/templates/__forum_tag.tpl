<a class="inline-flex max-w-48 items-center gap-1 rounded-full bg-(--forum-color)/10 px-2 py-0.5 text-xs font-medium text-(--forum-color)! hover:bg-(--forum-color)/20" style="--forum-color: {if $_forum['forum_color']}{$_forum['forum_color']}{else}var(--color-primary){/if}" href="{$system['system_url']}/forums/{$_forum['forum_id']}/{$_forum['title_url']}">
  <span class="{include file='__forum_icon.tpl' _icon=$_forum['forum_icon']} size-3.5 shrink-0" aria-hidden="true"></span>
  <span class="truncate" title="{__($_forum['forum_name'])}">{__($_forum['forum_name'])}</span>
</a>
