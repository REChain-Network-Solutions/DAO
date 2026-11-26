<ul class="menu menu-sm p-1">
  {foreach $users as $_user}
    <li>
      <div class="data-container clickable small {if $type == 'tags'}js_tag-add{else}js_autocomplete-add{/if} flex cursor-pointer items-center gap-2.5 rounded-field px-2 py-1.5" data-uid="{$_user['user_id']}" data-name="{if $system['show_usernames_enabled']}{$_user['user_name']}{else}{$_user['user_firstname']} {$_user['user_lastname']}{/if}" {if $_user['chat_price']}data-chat-price="{$_user['chat_price']}" {/if} {if $_user['call_price']}data-call-price="{$_user['call_price']}" {/if}>
        <div class="data-avatar size-8 shrink-0 overflow-hidden rounded-full bg-base-200">
          <img class="size-full object-cover" src="{$_user['user_picture']}" alt="">
        </div>
        <div class="data-content min-w-0">
          <div class="truncate font-semibold" title="{if $system['show_usernames_enabled']}{$_user['user_name']}{else}{$_user['user_firstname']} {$_user['user_lastname']}{/if}">{if $system['show_usernames_enabled']}{$_user['user_name']}{else}{$_user['user_firstname']} {$_user['user_lastname']}{/if}</div>
        </div>
      </div>
    </li>
  {/foreach}
</ul>
