<li class="feeds-item group flex min-w-0 flex-col items-center overflow-hidden rounded-box border border-base-300 {if $_darker}bg-base-200{else}bg-base-100{/if} text-center transition-shadow hover:shadow-md" {if isset($_user['id'])}data-id="{$_user['id']}"{/if}>
  {$_card = $_user|user_card_details}
  {$_cover_tones = ['from-violet-400/45 via-fuchsia-300/30 to-sky-300/45', 'from-sky-400/45 via-cyan-300/30 to-emerald-300/40', 'from-amber-300/55 via-orange-300/35 to-rose-300/45', 'from-emerald-300/50 via-teal-300/30 to-sky-300/45', 'from-rose-300/50 via-pink-300/30 to-violet-300/45', 'from-indigo-400/45 via-blue-300/30 to-cyan-300/45']}
  <span class="relative block h-24 w-full overflow-hidden bg-linear-to-br {$_cover_tones[$_user['user_id'] % 6]}" aria-hidden="true">
    <span class="absolute -top-10 start-1/4 size-32 rounded-full bg-white/40 blur-2xl dark:bg-white/10"></span>
    <span class="absolute -bottom-12 -end-6 size-28 rounded-full bg-white/30 blur-2xl dark:bg-white/5"></span>
  </span>
  <a class="relative z-10 -mt-12 shrink-0 rounded-full ring-4 {if $_darker}ring-base-200{else}ring-base-100{/if}" href="{$system['system_url']}/{$_user['user_name']}" aria-label="{if $system['show_usernames_enabled']}{$_user['user_name']}{else}{$_user['user_firstname']} {$_user['user_lastname']}{/if}">
    <img class="size-20 rounded-full object-cover" src="{$_user['user_picture']}" alt="" loading="lazy">
  </a>

  <div class="flex w-full grow flex-col items-center gap-4 px-4 pb-4 pt-3">
    <div class="flex min-w-0 max-w-full flex-col items-center gap-0.5">
      <div class="flex min-w-0 max-w-full items-center justify-center gap-1">
        <span class="js_user-popover min-w-0 truncate" data-uid="{$_user['user_id']}" title="{if $system['show_usernames_enabled']}{$_user['user_name']}{else}{$_user['user_firstname']} {$_user['user_lastname']}{/if}">
          <a class="font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/{$_user['user_name']}">
            {if $system['show_usernames_enabled']}{$_user['user_name']}{else}{$_user['user_firstname']} {$_user['user_lastname']}{/if}
          </a>
        </span>
        {if !empty($_user['user_verified'])}
          {include file='__badge.tpl' _badge="verified" _badge_type="user" _badge_size=16}
        {/if}
        {if !empty($_user['user_subscribed'])}
          {include file='__badge.tpl' _badge="pro" _badge_package=$_user['package_name'] _badge_size=16}
        {/if}
      </div>
      {if !$system['show_usernames_enabled']}
        <span class="max-w-full truncate text-xs text-base-content/50" title="@{$_user['user_name']}">@{$_user['user_name']}</span>
      {/if}
    </div>

    {if $_card['work'] || $_card['location'] || $_card['education']}
      <ul class="flex w-full min-w-0 flex-col items-center gap-1 text-xs text-base-content/70">
        {if $_card['work']}
          <li class="flex min-w-0 max-w-full items-center gap-1.5">
            <span class="icon-[tabler--briefcase] size-3.5 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <span class="truncate" title="{$_card['work']['title']}{if $_card['work']['place']} {__("at")} {$_card['work']['place']}{/if}">{$_card['work']['title']}{if $_card['work']['place']} {__("at")} <span class="font-medium text-base-content">{$_card['work']['place']}</span>{/if}</span>
          </li>
        {/if}
        {if $_card['location']}
          <li class="flex min-w-0 max-w-full items-center gap-1.5">
            <span class="icon-[tabler--map-pin] size-3.5 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <span class="truncate" title="{$_card['location']}">{$_card['location']}</span>
          </li>
        {/if}
        {if $_card['education']}
          <li class="flex min-w-0 max-w-full items-center gap-1.5">
            <span class="icon-[tabler--school] size-3.5 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <span class="truncate" title="{if $_card['education']['major']}{__("Studied")} {$_card['education']['major']} {__("at")} {/if}{$_card['education']['school']}">{if $_card['education']['major']}{__("Studied")} {$_card['education']['major']} {__("at")} {/if}<span class="font-medium text-base-content">{$_card['education']['school']}</span></span>
          </li>
        {/if}
      </ul>
    {/if}

    {if !empty($_user['monetization_plan'])}
      <span class="badge badge-soft badge-info badge-sm rounded-full">
        {if $_user['monetization_plan']['discounted_price']}{print_money($_user['monetization_plan']['discounted_price'])}<span class="ms-1 line-through opacity-70">{/if}{print_money($_user['monetization_plan']['price'])}{if $_user['monetization_plan']['discounted_price']}</span>{/if} / {if $_user['monetization_plan']['period_num'] != '1'}{$_user['monetization_plan']['period_num']}{/if} {__($_user['monetization_plan']['period']|ucfirst)}
      </span>
    {elseif !$_no_action && $_card['mutual_friends_count'] && $_connection != "me"}
      <button type="button" class="js_modal flex min-w-0 max-w-full items-center gap-2 text-xs text-base-content/60 hover:text-primary" data-url="users/mutual_friends.php?uid={$_user['user_id']}">
        {if $_card['mutual_friends']}
          <span class="avatar-group shrink-0 -space-x-2">
            {foreach $_card['mutual_friends'] as $_mutual_friend}
              <span class="avatar">
                <span class="size-6 rounded-full ring-2 {if $_darker}ring-base-200{else}ring-base-100{/if}">
                  <img src="{$_mutual_friend['user_picture']}" alt="" loading="lazy">
                </span>
              </span>
            {/foreach}
          </span>
        {/if}
        <span class="truncate" title="{$_card['mutual_friends_count']} {__("mutual friends")}"><span class="font-semibold text-base-content">{$_card['mutual_friends_count']}</span> {__("mutual friends")}</span>
      </button>
    {/if}

    {if !$_no_action && $user->_logged_in && $_user['user_id'] == $user->_data['user_id']}
      <div class="mt-auto flex w-full pt-1 [&>.button]:grow">
        <a class="heroui button button--tertiary button--sm rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/settings/profile">
          <span class="icon-[tabler--pencil] size-4" aria-hidden="true"></span>{__("Edit Profile")}
        </a>
      </div>
    {elseif !$_no_action && $_connection != "me" && $_connection != "declined"}
      <div class="mt-auto flex w-full flex-wrap justify-center gap-2 pt-1 [&>.button]:grow">
        {if $_connection == "unsubscribe"}
          {if $user->_data['user_id'] == $_user['plan_user_id']}
            <button type="button" class="heroui button button--danger-soft button--sm rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_unsubscribe-plan" data-id="{$_user['plan_id']}">
              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Unsubscribe")}
            </button>
          {/if}
        {elseif $_connection == "request"}
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
          {if $_top_friends}
            <button type="button" class="heroui button button--tertiary [--button-bg:var(--warning-soft)] [--button-bg-hover:var(--warning-soft-hover)] [--button-bg-pressed:var(--warning-soft-hover)] [--button-fg:var(--warning-soft-foreground)] button--sm button--icon-only size-7.5 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] grow-0! {if $_user['top_friend']}js_friend-unfavorite{else}js_friend-favorite{/if}" data-uid="{$_user['user_id']}" aria-label='{__("Top Friends")}' title='{__("Top Friends")}'>
              <span class="{if $_user['top_friend']}icon-[tabler--star-filled]{else}icon-[tabler--star]{/if} size-4" aria-hidden="true"></span>
            </button>
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
        {/if}
      </div>
    {/if}
  </div>
</li>
