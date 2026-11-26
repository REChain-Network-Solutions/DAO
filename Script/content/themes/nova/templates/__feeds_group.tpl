{if $_tpl == "box"}
  <li class="flex flex-col items-center gap-3 rounded-box border border-base-300 {if $_darker}bg-base-200{else}bg-base-100{/if} p-4 text-center">
    <a class="shrink-0" href="{$system['system_url']}/groups/{$_group['group_name']}{if $_search}?ref=qs{/if}">
      <img class="size-20 rounded-full object-cover" alt="{$_group['group_title']}" src="{$_group['group_picture']}" />
    </a>
    <div class="w-full min-w-0">
      <a class="block truncate font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/groups/{$_group['group_name']}{if $_search}?ref=qs{/if}" title="{$_group['group_title']}">{$_group['group_title']|truncate:30}</a>
      {if $_group['monetization_plan']}
        <div class="mt-2">
          <span class="badge badge-soft badge-info">{print_money($_group['monetization_plan']['price'])} / {if $_group['monetization_plan']['period_num'] != '1'}{$_group['monetization_plan']['period_num']}{/if} {__($_group['monetization_plan']['period']|ucfirst)}</span>
        </div>
      {else}
        <div class="mt-1 text-sm text-base-content/60">{$_group['group_members']} {__("Members")}</div>
      {/if}
    </div>
    <div class="mt-auto flex flex-wrap items-center justify-center gap-2">
      {if $_connection == 'unsubscribe'}
        {if $user->_data['user_id'] == $_group['plan_user_id']}
          <button type="button" class="heroui button button--danger-soft button--sm rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_unsubscribe-plan" data-id="{$_group['plan_id']}">
            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Unsubscribe")}
          </button>
        {/if}
      {else}
        {if $_group['i_joined'] == "approved"}
          {include file='__connection_button.tpl' _state="group_joined" _id=$_group['group_id'] _privacy=$_group['group_privacy']}
        {elseif $_group['i_joined'] == "pending"}
          {include file='__connection_button.tpl' _state="group_pending" _id=$_group['group_id'] _privacy=$_group['group_privacy']}
        {elseif $user->_data['user_id'] == $_group['group_admin']}
          {include file='__connection_button.tpl' _state="group_join" _id=$_group['group_id'] _privacy="public"}
        {else}
          {include file='__connection_button.tpl' _state="group_join" _id=$_group['group_id'] _privacy=$_group['group_privacy']}
        {/if}
      {/if}
    </div>
  </li>
{elseif $_tpl == "list"}
  <li class="feeds-item flex items-center gap-3 rounded-2xl px-3 py-2.5 transition-colors hover:bg-base-200">
    <a class="shrink-0" href="{$system['system_url']}/groups/{$_group['group_name']}{if $_search}?ref=qs{/if}">
      <img class="{if $_small}size-10{else}size-12{/if} rounded-full object-cover" src="{$_group['group_picture']}" alt="{$_group['group_title']}">
    </a>
    <div class="min-w-0 flex-1">
      <span class="name block min-w-0">
        <a class="block truncate text-sm font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/groups/{$_group['group_name']}{if $_search}?ref=qs{/if}" title="{$_group['group_title']}">{$_group['group_title']|truncate:30}</a>
      </span>
      <div class="text-sm text-base-content/60">{$_group['group_members']} {__("Members")}</div>
    </div>
    <div class="ms-auto flex shrink-0 flex-wrap items-center gap-2">
      {if $_group['i_joined'] == "approved"}
        {include file='__connection_button.tpl' _state="group_joined" _id=$_group['group_id'] _privacy=$_group['group_privacy']}
      {elseif $_group['i_joined'] == "pending"}
        {include file='__connection_button.tpl' _state="group_pending" _id=$_group['group_id'] _privacy=$_group['group_privacy']}
      {elseif $user->_data['user_id'] == $_group['group_admin']}
        {include file='__connection_button.tpl' _state="group_join" _id=$_group['group_id'] _privacy="public"}
      {else}
        {include file='__connection_button.tpl' _state="group_join" _id=$_group['group_id'] _privacy=$_group['group_privacy']}
      {/if}
    </div>
  </li>
{/if}
