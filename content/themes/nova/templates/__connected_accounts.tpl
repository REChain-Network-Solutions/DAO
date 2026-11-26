<ul class="flex flex-col gap-2">
  {foreach $user->connected_accounts() as $connected_account}
    {if $system['show_usernames_enabled']}
      {$_account_name = $connected_account['user_name']}
    {else}
      {$_account_name = $connected_account['user_firstname']|cat:' '|cat:$connected_account['user_lastname']}
    {/if}
    {$_account_active = ($connected_account['user_id'] == $user->_data['user_id'])}
    <li class="{if $_account_active}order-first{/if}">
      <button type="button" class="js_connected-account-switch group flex w-full items-center gap-3 rounded-[1rem] border p-3 text-start transition-colors {if $_account_active}border-primary/40 bg-primary/5{else}border-base-content/10 hover:border-base-content/20 hover:bg-base-200/60{/if}" data-uid="{$connected_account['user_id']}" {if $_account_active}aria-current="true"{/if}>
        <img class="size-12 shrink-0 rounded-full object-cover {if $_account_active}ring-2 ring-primary ring-offset-2 ring-offset-base-100{/if}" src="{$connected_account['user_picture']}" alt="">
        <span class="flex min-w-0 flex-1 flex-col">
          <span class="flex min-w-0 items-center gap-1">
            <span class="truncate text-sm font-semibold text-base-content" title="{$_account_name}">{$_account_name}</span>
            {if $connected_account['user_verified']}
              {include file='__badge.tpl' _badge="verified" _badge_type="user"}
            {/if}
            {if $connected_account['user_subscribed']}
              {include file='__badge.tpl' _badge="pro" _badge_package=$connected_account['package_name']}
            {/if}
          </span>
          {if !$system['show_usernames_enabled']}
            <span class="truncate text-xs text-base-content/50" title="@{$connected_account['user_name']}">@{$connected_account['user_name']}</span>
          {/if}
        </span>
        {if $_account_active}
          <span class="badge badge-soft badge-primary badge-sm shrink-0 gap-1 rounded-full">
            <span class="icon-[tabler--check] size-3.5" aria-hidden="true"></span>
            {__("Active")}
          </span>
        {else}
          <span class="icon-[tabler--chevron-right] size-5 shrink-0 text-base-content/30 transition group-hover:translate-x-0.5 group-hover:text-base-content/60 rtl:rotate-180 rtl:group-hover:-translate-x-0.5" aria-hidden="true"></span>
        {/if}
      </button>
    </li>
  {/foreach}
  {if $_add_account && $user->_data['user_id'] == $user->_data['user_master_account']}
    <li>
      <button type="button" class="js_modal group flex w-full items-center gap-3 rounded-[1rem] border border-dashed border-base-content/20 p-3 text-start transition-colors hover:border-primary/50 hover:bg-primary/5" data-url="#account-connector">
        <span class="flex size-12 shrink-0 items-center justify-center rounded-full bg-base-200 text-base-content/60 transition-colors group-hover:bg-primary/10 group-hover:text-primary" aria-hidden="true">
          <span class="icon-[tabler--plus] size-5"></span>
        </span>
        <span class="flex-1 text-sm font-semibold text-base-content">{__("Add Account")}</span>
      </button>
    </li>
  {/if}
</ul>
