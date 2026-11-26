{if $_tpl == "list"}
  <li class="feeds-item flex items-center gap-3 rounded-2xl px-3 py-2.5 transition-colors hover:bg-base-200">
    <a class="shrink-0" href="{$system['system_url']}/pages/{$_page['page_name']}{if $_search}?ref=qs{/if}">
      <img class="{if $_small}size-10{else}size-12{/if} rounded-full object-cover" src="{$_page['page_picture']}" alt="{$_page['page_title']}">
    </a>
    <div class="min-w-0 flex-1">
      <div class="flex min-w-0 items-center gap-1">
        <span class="name js_user-popover inline-flex min-w-0" data-uid="{$_page['page_id']}" data-type="page">
          <a class="truncate text-sm font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/pages/{$_page['page_name']}{if $_search}?ref=qs{/if}" title="{$_page['page_title']}">{$_page['page_title']|truncate:30}</a>
        </span>
        {if $_page['page_verified']}
          {include file='__badge.tpl' _badge="verified" _badge_type="page"}
        {/if}
      </div>
      <div class="text-sm text-base-content/60">{$_page['page_likes']} {__("Likes")}</div>
    </div>
    <div class="ms-auto flex shrink-0 flex-wrap items-center gap-2">
      {if $_page['i_like']}
        {include file='__connection_button.tpl' _state="page_liked" _id=$_page['page_id']}
      {else}
        {include file='__connection_button.tpl' _state="page_like" _id=$_page['page_id']}
      {/if}
    </div>
  </li>
{/if}
