{if $_tpl == "with-action"}
  <li class="feeds-action-item relative {if !$notification['seen']}unread bg-primary/5{/if}" data-id="{$notification['notification_id']}">
    <a class="flex items-start gap-3 px-5 py-4 text-base-content! transition-colors hover:bg-base-200/50 sm:px-6" href="{$notification['url']}" {if $notification['action'] == "mass_notification"}target="_blank" {/if}>
      <span class="relative shrink-0">
        <img class="size-12 rounded-full object-cover" src="{$notification['user_picture']}" alt="">
        <span class="absolute -bottom-1 -end-1 flex size-6 items-center justify-center rounded-full border-2 border-base-100 bg-base-100 text-xs text-primary shadow-sm" aria-hidden="true">
          {if $notification['reaction']}
            <span class="inline-emoji no_animation inline-flex size-4">
              {include file='__reaction_emojis.tpl' _reaction=$notification['reaction']}
            </span>
          {else}
            <span class="{$notification['icon']} size-3.5"></span>
          {/if}
        </span>
      </span>
      <span class="min-w-0 grow text-sm">
        <span class="flex flex-wrap items-center gap-1">
          <span class="font-semibold">{$notification['name']}</span>
          {if !$notification['system_notification'] && $notification['user_verified']}
            {include file='__badge.tpl' _badge="verified" _badge_type="user" _badge_size=16}
          {/if}
          {if !$notification['system_notification'] && $notification['user_subscribed']}
            {include file='__badge.tpl' _badge="pro" _badge_package=$notification['package_name'] _badge_size=16}
          {/if}
        </span>
        <span class="mt-0.5 block text-base-content/70">{$notification['message']}</span>
        <span class="mt-1 flex items-center gap-1 text-xs text-base-content/50">
          <span class="icon-[tabler--clock] size-3.5" aria-hidden="true"></span>
          <span class="js_moment" data-time="{$notification['time']}">{$notification['time']}</span>
        </span>
      </span>
      <span class="flex shrink-0 items-center gap-2">
        {if !$notification['seen']}
          <span class="size-2.5 rounded-full bg-primary" aria-hidden="true"></span>
        {/if}
        <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full text-base-content/50 hover:text-error js_notification-deleter" data-id="{$notification['notification_id']}" title='{__("Delete")}' aria-label='{__("Delete")}'>
          <span class="icon-[tabler--trash] size-4.5" aria-hidden="true"></span>
        </button>
      </span>
    </a>
  </li>
{else}
  <li class="feeds-item {if !$notification['seen']}unread{/if}" data-id="{$notification['notification_id']}">
    <a class="data-container flex items-start gap-3 rounded-2xl px-3 py-3 text-base-content! transition-colors hover:bg-base-200" href="{$notification['url']}" {if $notification['action'] == "mass_notification"}target="_blank" {/if}>
      <span class="relative shrink-0">
        <img class="size-12 rounded-full object-cover" src="{$notification['user_picture']}" alt="">
        <span class="absolute -bottom-1 -end-1 flex size-6 items-center justify-center rounded-full border-2 border-base-100 bg-base-100 text-xs text-primary shadow-sm" aria-hidden="true">
          {if $notification['reaction']}
            <span class="inline-emoji no_animation inline-flex size-4">
              {include file='__reaction_emojis.tpl' _reaction=$notification['reaction']}
            </span>
          {else}
            <span class="{$notification['icon']} size-3.5"></span>
          {/if}
        </span>
      </span>
      <span class="data-content min-w-0 grow text-sm">
        <span class="flex flex-wrap items-center gap-1">
          <span class="name font-semibold">{$notification['name']}</span>
          {if !$notification['system_notification'] && $notification['user_verified']}
            {include file='__badge.tpl' _badge="verified" _badge_type="user" _badge_size=16}
          {/if}
          {if !$notification['system_notification'] && $notification['user_subscribed']}
            {include file='__badge.tpl' _badge="pro" _badge_package=$notification['package_name'] _badge_size=16}
          {/if}
        </span>
        <span class="mt-0.5 block text-base-content/70">
          {$notification['message']}
        </span>
        <span class="mt-1 flex items-center gap-1 text-xs text-base-content/50">
          <span class="icon-[tabler--clock] size-3.5" aria-hidden="true"></span>
          <span class="js_moment" data-time="{$notification['time']}">{$notification['time']}</span>
        </span>
      </span>
      {if !$notification['seen']}
        <span class="mt-2 size-2.5 shrink-0 rounded-full bg-primary" aria-hidden="true"></span>
      {/if}
    </a>
  </li>
{/if}
