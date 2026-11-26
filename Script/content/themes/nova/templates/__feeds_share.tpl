<li class="flex items-start gap-3 rounded-2xl px-3 py-2.5 transition-colors hover:bg-base-200">
  <a class="shrink-0" href="{$_post['post_author_url']}">
    <img class="size-10 rounded-full object-cover" src="{$_post['post_author_picture']}" alt="" loading="lazy">
  </a>
  <div class="min-w-0 flex-1">
    <div class="flex min-w-0 flex-wrap items-center gap-1">
      <span class="inline-flex min-w-0 {if $_post['user_type'] == 'user'}js_user-popover{/if}" {if $_post['user_type'] == 'user'}data-uid="{$_post['author_id']}"{/if}>
        <a class="truncate text-sm font-semibold text-base-content! hover:text-primary!" href="{$_post['post_author_url']}" title="{$_post['post_author_name']}">{$_post['post_author_name']}</a>
      </span>
      {if $_post['post_author_verified']}
        {include file='__badge.tpl' _badge="verified" _badge_type=$_post['user_type'] _badge_size=16}
      {/if}
      {if $_post['user_type'] == 'user' && $_post['user_subscribed']}
        {include file='__badge.tpl' _badge="pro" _badge_package=$_post['package_name'] _badge_size=16}
      {/if}
    </div>
    <time class="js_moment block text-xs text-base-content/60" data-time="{$_post['time']}">{$_post['time']}</time>
    {if $_post['text']}
      <div class="mt-1.5 line-clamp-3 break-words text-sm text-base-content/80" dir="auto" title="{$_post['text_plain']}">{$_post['text']}</div>
    {/if}
  </div>
  <a class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full shrink-0" href="{$system['system_url']}/posts/{$_post['post_id']}" title='{__("View Post")}' aria-label='{__("View Post")}'>
    <span class="icon-[tabler--arrow-up-right] size-4.5 rtl:-scale-x-100" aria-hidden="true"></span>
  </a>
</li>
