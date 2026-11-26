{if $_tpl == "box"}
  {include file='__people_card.tpl'}
{elseif $_tpl == "list"}
  <li class="feeds-item grid grid-cols-[auto_minmax(0,1fr)] items-center gap-x-3 gap-y-2 sm:flex sm:gap-3 rounded-2xl px-3 py-2.5 transition-colors hover:bg-base-200" {if $_user['id']}data-id="{$_user['id']}" {/if}>
    <a class="relative shrink-0 max-sm:row-span-2" href="{$system['system_url']}/{$_user['user_name']}{if $_search}?ref=qs{/if}">
      <img class="{if $_small}size-10{else}size-12{/if} rounded-full object-cover" src="{$_user['user_picture']}" alt="">
      {if $_reaction}
        <span class="data-reaction absolute -bottom-1 -end-1 flex rounded-full bg-base-100 p-0.5">
          <span class="inline-emoji no_animation inline-flex size-4.5">
            {include file='__reaction_emojis.tpl' _reaction=$_reaction}
          </span>
        </span>
      {/if}
    </a>
    <div class="min-w-0 flex-1">
      <div class="flex min-w-0 flex-wrap items-center gap-1">
        <span class="name js_user-popover inline-flex min-w-0" data-uid="{$_user['user_id']}">
          <a class="truncate text-sm font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/{$_user['user_name']}{if $_search}?ref=qs{/if}" title="{if $system['show_usernames_enabled']} {$_user['user_name']} {else} {$_user['user_firstname']} {$_user['user_lastname']} {/if}">
            {if $system['show_usernames_enabled']}
              {$_user['user_name']}
            {else}
              {$_user['user_firstname']} {$_user['user_lastname']}
            {/if}
          </a>
        </span>
        {if $_user['user_verified']}
          {include file='__badge.tpl' _badge="verified" _badge_type="user"}
        {/if}
        {if $_user['user_subscribed']}
          {include file='__badge.tpl' _badge="pro" _badge_package=$_user['package_name']}
        {/if}
        {if $_user['permission']}<span class="badge badge-soft badge-warning shrink-0">{__($_user['permission'])|ucfirst}</span>{/if}
      </div>
      {if $_connection != "me" && $_user['mutual_friends_count'] > 0}
        <div class="text-xs">
          <span class="js_modal cursor-pointer text-base-content/60 hover:text-base-content hover:underline" data-url="users/mutual_friends.php?uid={$_user['user_id']}">{$_user['mutual_friends_count']} {__("mutual friends")}</span>
        </div>
      {/if}
      {if $_donation}
        <div class="mt-1 flex flex-wrap items-center gap-2 text-sm text-base-content/60">
          <span class="badge badge-soft badge-success">{print_money($_donation)}</span>
          <span class="js_moment" data-time="{$_donation_time}">{$_donation_time}</span>
        </div>
      {/if}
      {if $_merits_count}
        <div class="text-sm text-base-content/60">
          {$_merits_count} {__("Merits")}
        </div>
      {/if}
    </div>
    <div class="col-start-2 flex flex-wrap items-center gap-2 sm:ms-auto sm:shrink-0 [&:not(:has(*))]:hidden max-sm:[&_.button]:h-7! max-sm:[&_.button]:gap-1.5! max-sm:[&_.button]:px-2.5! max-sm:[&_.button]:text-xs!">
      <!-- buttons -->
      {if $_connection == "request"}
        {include file='__connection_button.tpl' _state="friend_request" _uid=$_user['user_id']}
      {elseif $_connection == "add"}
        {if $system['friends_enabled']}
          {include file='__connection_button.tpl' _state="friend_add" _uid=$_user['user_id']}
        {else}
          {include file='__connection_button.tpl' _state="follow" _uid=$_user['user_id']}
        {/if}
      {elseif $_connection == "cancel"}
        {include file='__connection_button.tpl' _state="friend_sent" _uid=$_user['user_id']}
      {elseif $_connection == "remove"}
        {if $system['friends_enabled']}
          {include file='__connection_button.tpl' _state="friends" _uid=$_user['user_id']}
        {else}
          {include file='__connection_button.tpl' _state="following" _uid=$_user['user_id']}
        {/if}
      {elseif $_connection == "follow"}
        {include file='__connection_button.tpl' _state="follow" _uid=$_user['user_id']}
      {elseif $_connection == "unfollow"}
        {include file='__connection_button.tpl' _state="following" _uid=$_user['user_id']}
      {elseif $_connection == "blocked"}
        {include file='__connection_button.tpl' _state="unblock" _uid=$_user['user_id']}
      {elseif $_connection == "page_invite"}
        {include file='__connection_button.tpl' _state="invite" _node="page" _id=$_user['node_id'] _uid=$_user['user_id']}
      {elseif $_connection == "page_manage"}
        {include file='__connection_button.tpl' _state="member_remove" _node="page" _id=$_user['node_id'] _uid=$_user['user_id']}
        {if $_user['i_admin']}
          {include file='__connection_button.tpl' _state="admin_remove" _node="page" _id=$_user['node_id'] _uid=$_user['user_id']}
        {else}
          {include file='__connection_button.tpl' _state="admin_add" _node="page" _id=$_user['node_id'] _uid=$_user['user_id']}
        {/if}
      {elseif $_connection == "group_invite"}
        {include file='__connection_button.tpl' _state="invite" _node="group" _id=$_user['node_id'] _uid=$_user['user_id']}
      {elseif $_connection == "group_request"}
        {include file='__connection_button.tpl' _state="group_request" _id=$_user['node_id'] _uid=$_user['user_id']}
      {elseif $_connection == "group_manage"}
        {include file='__connection_button.tpl' _state="member_remove" _node="group" _id=$_user['node_id'] _uid=$_user['user_id']}
        {if $_user['i_admin']}
          {include file='__connection_button.tpl' _state="admin_remove" _node="group" _id=$_user['node_id'] _uid=$_user['user_id']}
        {else}
          {include file='__connection_button.tpl' _state="admin_add" _node="group" _id=$_user['node_id'] _uid=$_user['user_id']}
        {/if}
      {elseif $_connection == "event_invite"}
        {include file='__connection_button.tpl' _state="invite" _node="event" _id=$_user['node_id'] _uid=$_user['user_id']}
      {elseif $_connection == "connected_account_remove"}
        {include file='__connection_button.tpl' _state="account_remove" _uid=$_user['user_id']}
      {elseif $_connection == "connected_account_revoke"}
        {include file='__connection_button.tpl' _state="account_revoke"}
      {/if}
      {if $_merit_category}
        <img class="size-8 rounded-full object-cover" src="{$system['system_uploads']}/{$_merit_category['category_image']}" width="32" height="32" title="{$_merit_category['category_name']}" alt="{$_merit_category['category_name']}" />
      {/if}
      <!-- buttons -->
    </div>
  </li>
{/if}
