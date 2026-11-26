<li class="group flex min-w-0 flex-col overflow-hidden rounded-box border border-base-300 {if $_darker}bg-base-200{else}bg-base-100{/if} transition-shadow hover:shadow-md">
  <a class="relative block aspect-[5/2] overflow-hidden bg-linear-to-br from-primary/25 via-primary/10 to-secondary/20 bg-cover bg-center" href="{$system['system_url']}/groups/{$_group['group_name']}" tabindex="-1" aria-hidden="true" {if $_group['group_cover']}style="background-image: url('{$system['system_uploads']}/{$_group['group_cover']}')"{/if}>
    {if $_promoted}
      <span class="badge badge-warning badge-sm absolute start-3 top-3 gap-1 rounded-full">
        <span class="icon-[tabler--speakerphone] size-3"></span>
        {__("Promoted")}
      </span>
    {/if}
    <span class="absolute end-3 top-3 flex items-center gap-1 rounded-full bg-black/50 px-2 py-0.5 text-[11px] font-medium text-white backdrop-blur-sm">
      {if $_group['group_privacy'] == "secret"}
        <span class="icon-[tabler--eye-off] size-3.5"></span>{__("Secret Group")}
      {elseif $_group['group_privacy'] == "closed"}
        <span class="icon-[tabler--lock] size-3.5"></span>{__("Closed Group")}
      {else}
        <span class="icon-[tabler--world] size-3.5"></span>{__("Public Group")}
      {/if}
    </span>
  </a>

  <div class="flex grow flex-col gap-3 px-4 pb-4">
    <a class="relative z-1 -mt-8 w-fit shrink-0 rounded-2xl ring-4 {if $_darker}ring-base-200{else}ring-base-100{/if}" href="{$system['system_url']}/groups/{$_group['group_name']}" tabindex="-1" aria-hidden="true">
      <img class="size-16 rounded-2xl bg-base-100 object-cover" src="{$_group['group_picture']}" alt="" loading="lazy">
    </a>
    <div class="min-w-0">
      <a class="line-clamp-1 font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/groups/{$_group['group_name']}" title="{$_group['group_title']}">{$_group['group_title']}</a>
      <div class="mt-0.5 flex items-center gap-1 text-xs text-base-content/60">
        {if $_group['monetization_plan']}
          <span class="badge badge-soft badge-info badge-sm rounded-full">{print_money($_group['monetization_plan']['price'])} / {if $_group['monetization_plan']['period_num'] != '1'}{$_group['monetization_plan']['period_num']}{/if} {__($_group['monetization_plan']['period']|ucfirst)}</span>
        {else}
          <span class="icon-[tabler--users] size-3.5" aria-hidden="true"></span>
          {$_group['group_members']} {__("Members")}
        {/if}
      </div>
    </div>
    {if $_group['group_description']}
      <p class="line-clamp-2 text-sm text-base-content/65" title="{$_group['group_description']|strip_tags}">{$_group['group_description']|strip_tags|truncate:140}</p>
    {/if}

    <div class="mt-auto flex pt-1 [&>.button]:grow">
      {if $_connection == "unsubscribe"}
        {if $user->_data['user_id'] == $_group['plan_user_id']}
          <button type="button" class="heroui button button--danger-soft button--sm rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_unsubscribe-plan" data-id="{$_group['plan_id']}">
            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Unsubscribe")}
          </button>
        {/if}
      {elseif $_group['i_joined'] == "approved"}
        {include file='__connection_button.tpl' _state="group_joined" _id=$_group['group_id'] _privacy=$_group['group_privacy']}
      {elseif $_group['i_joined'] == "pending"}
        {include file='__connection_button.tpl' _state="group_pending" _id=$_group['group_id'] _privacy=$_group['group_privacy']}
      {elseif $user->_data['user_id'] == $_group['group_admin']}
        {include file='__connection_button.tpl' _state="group_join" _id=$_group['group_id'] _privacy="public"}
      {else}
        {include file='__connection_button.tpl' _state="group_join" _id=$_group['group_id'] _privacy=$_group['group_privacy']}
      {/if}
    </div>
  </div>
</li>
