{$_online_count = 0}
{$_offline_count = 0}
{foreach $sidebar_friends as $_user}{if $_user['user_is_online']}{$_online_count = $_online_count + 1}{else}{$_offline_count = $_offline_count + 1}{/if}{/foreach}

{if $sidebar_friends}
  <!-- contacts header -->
  <div class="relative mx-2 mb-1.5 flex h-8 items-center">
    <span class="absolute inset-y-0 start-0 flex w-[3.7rem] items-center justify-center transition-opacity duration-150 group-hover/chat:opacity-0 group-has-[:focus-visible]/chat:opacity-0 group-has-[.dropdown.open]/chat:opacity-0">
      <span class="relative inline-flex text-base-content/50">
        <span class="icon-[tabler--users] size-5" aria-hidden="true"></span>
        <span class="js_chat-online-header absolute -end-2 -top-1.5 h-4 min-w-4 items-center justify-center rounded-full bg-success px-1 text-[10px] font-semibold leading-none text-success-content ring-2 ring-base-100 {if $_online_count}flex{else}hidden{/if}" title="{__("Online")}"><span class="js_chat-online-count">{$_online_count}</span></span>
      </span>
    </span>
    <span class="flex w-full items-center justify-between gap-2 overflow-hidden whitespace-nowrap px-2 opacity-0 transition-opacity duration-150 group-hover/chat:opacity-100 group-has-[:focus-visible]/chat:opacity-100 group-has-[.dropdown.open]/chat:opacity-100 group-hover/chat:delay-200 group-has-[:focus-visible]/chat:delay-200 group-has-[.dropdown.open]/chat:delay-200">
      <span class="text-xs font-semibold text-base-content/60">{__("Contacts")}</span>
      <span class="js_chat-online-header badge badge-soft badge-success badge-sm shrink-0 items-center gap-1 rounded-full font-semibold {if $_online_count}flex{else}hidden{/if}">
        <span class="size-1.5 rounded-full bg-success" aria-hidden="true"></span>{__("Online")} <span class="js_chat-online-count">{$_online_count}</span>
      </span>
    </span>
  </div>
  <!-- contacts header -->
{/if}

{foreach ['online', 'offline'] as $_status}
  <div class="js_chat-contacts-{$_status} flex flex-col gap-0.5{if $_status == 'offline'} opacity-60 transition-opacity group-hover/chat:opacity-100 group-has-[:focus-visible]/chat:opacity-100 group-has-[.dropdown.open]/chat:opacity-100{if $_offline_count && $_online_count} mt-2 before:mx-4 before:mb-2 before:block before:border-t before:border-base-content/10{/if}{/if}">
    {foreach $sidebar_friends as $_user}
      {if ($_status == 'online' && $_user['user_is_online']) || ($_status == 'offline' && !$_user['user_is_online'])}
        {if $system['show_usernames_enabled']}{$_name = $_user['user_name']}{else}{$_name = "`$_user['user_firstname']` `$_user['user_lastname']`"}{/if}
        <button type="button" class="js_chat-start mx-2 flex w-[calc(100%-1rem)] items-center rounded-xl py-1 transition-colors hover:bg-base-200" data-uid="{$_user['user_id']}" data-name="{$_name}" data-link="{$_user['user_name']}" data-picture="{$_user['user_picture']}" title="{$_name}" aria-label="{$_name}">
          <span class="grid w-[3.7rem] shrink-0 place-items-center">
            <span class="relative inline-flex">
              <img class="size-10 rounded-full object-cover" src="{$_user['user_picture']}" alt="">
              {if $_status == 'online'}
                <span class="absolute bottom-0 end-0 size-3 rounded-full bg-success ring-2 ring-base-100 group-[.disabled]/chat:hidden"></span>
              {/if}
            </span>
          </span>
          <span class="min-w-0 flex-1 overflow-hidden whitespace-nowrap pe-3 text-start opacity-0 transition-opacity duration-150 group-hover/chat:opacity-100 group-has-[:focus-visible]/chat:opacity-100 group-has-[.dropdown.open]/chat:opacity-100 group-hover/chat:delay-200 group-has-[:focus-visible]/chat:delay-200 group-has-[.dropdown.open]/chat:delay-200">
            <span class="block truncate text-sm font-medium" title="{$_name}">{$_name}</span>
            {if $system['chat_status_enabled'] && $_status == 'offline'}
              <span class="js_moment block truncate text-xs text-base-content/50" data-time="{$_user['user_last_seen']}">{$_user['user_last_seen']}</span>
            {/if}
          </span>
        </button>
      {/if}
    {/foreach}
  </div>
{/foreach}
