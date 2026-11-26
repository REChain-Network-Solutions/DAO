<li class="group flex min-w-0 flex-col overflow-hidden rounded-box border border-base-300 {if $_darker}bg-base-200{else}bg-base-100{/if} transition-shadow hover:shadow-md">
  <a class="relative block aspect-[5/2] overflow-hidden bg-linear-to-br from-primary/25 via-primary/10 to-secondary/20 bg-cover bg-center" href="{$system['system_url']}/pages/{$_page['page_name']}" tabindex="-1" aria-hidden="true" {if $_page['page_cover']}style="background-image: url('{$system['system_uploads']}/{$_page['page_cover']}')"{/if}>
    {if $_promoted}
      <span class="badge badge-warning badge-sm absolute start-3 top-3 gap-1 rounded-full">
        <span class="icon-[tabler--speakerphone] size-3"></span>
        {__("Promoted")}
      </span>
    {/if}
  </a>

  <div class="flex grow flex-col gap-3 px-4 pb-4">
    <a class="relative z-1 -mt-8 w-fit shrink-0 rounded-2xl ring-4 {if $_darker}ring-base-200{else}ring-base-100{/if}" href="{$system['system_url']}/pages/{$_page['page_name']}" tabindex="-1" aria-hidden="true">
      <img class="size-16 rounded-2xl bg-base-100 object-cover" src="{$_page['page_picture']}" alt="" loading="lazy">
    </a>
    <div class="min-w-0">
      <div class="flex min-w-0 items-center gap-1">
        <span class="js_user-popover inline-flex min-w-0" data-uid="{$_page['page_id']}" data-type="page">
          <a class="line-clamp-1 font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/pages/{$_page['page_name']}" title="{$_page['page_title']}">{$_page['page_title']}</a>
        </span>
        {if $_page['page_verified']}
          {include file='__badge.tpl' _badge="verified" _badge_type="page" _badge_size=16}
        {/if}
      </div>
      <div class="mt-0.5 flex items-center gap-1 text-xs text-base-content/60">
        {if $_page['monetization_plan']}
          <span class="badge badge-soft badge-info badge-sm rounded-full">{print_money($_page['monetization_plan']['price'])} / {if $_page['monetization_plan']['period_num'] != '1'}{$_page['monetization_plan']['period_num']}{/if} {__($_page['monetization_plan']['period']|ucfirst)}</span>
        {else}
          <span class="icon-[tabler--heart] size-3.5" aria-hidden="true"></span>
          {$_page['page_likes']} {__("Likes")}
        {/if}
      </div>
    </div>
    {if $_page['page_description']}
      <p class="line-clamp-2 text-sm text-base-content/65" title="{$_page['page_description']|strip_tags}">{$_page['page_description']|strip_tags|truncate:140}</p>
    {/if}

    <div class="mt-auto flex pt-1 [&>.button]:grow">
      {if $_connection == "unsubscribe"}
        {if $user->_data['user_id'] == $_page['plan_user_id']}
          <button type="button" class="heroui button button--danger-soft button--sm rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_unsubscribe-plan" data-id="{$_page['plan_id']}">
            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Unsubscribe")}
          </button>
        {/if}
      {elseif $_page['i_like']}
        {include file='__connection_button.tpl' _state="page_liked" _id=$_page['page_id']}
      {else}
        {include file='__connection_button.tpl' _state="page_like" _id=$_page['page_id']}
      {/if}
    </div>
  </div>
</li>
