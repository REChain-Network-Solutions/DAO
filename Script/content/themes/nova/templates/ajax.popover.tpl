{if $type == "user"}
  <!-- user popover -->
  <div class="user-popover-content relative z-[1090] w-80 overflow-hidden rounded-box border border-base-300 bg-base-100 text-base-content shadow-lg">
    <div class="user-card">
      <div class="user-card-cover h-24 bg-linear-to-br from-primary/35 via-primary/10 to-base-200 bg-cover bg-center" {if $profile['user_cover']}style="background-image:url('{$system['system_uploads']}/{$profile['user_cover']}');" {/if}></div>
      <div class="flex items-start gap-3 px-4 pb-4">
        <a class="user-card-avatar -mt-8 block size-16 shrink-0 overflow-hidden rounded-box bg-base-100 p-0.5 ring-1 ring-base-300" href="{$system['system_url']}/{$profile['user_name']}">
          <img class="size-full rounded-[calc(var(--radius-box)-0.125rem)] object-cover" src="{$profile['user_picture']}" alt="{if $system['show_usernames_enabled']}{$profile['user_name']}{else}{$profile['user_firstname']} {$profile['user_lastname']}{/if}">
        </a>
        <div class="user-card-info min-w-0 flex-1 pt-2">
          <div class="flex min-w-0 items-center gap-1">
            <a class="name truncate text-sm font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/{$profile['user_name']}" title="{if $system['show_usernames_enabled']} {$profile['user_name']} {else} {$profile['user_firstname']} {$profile['user_lastname']} {/if}">
              {if $system['show_usernames_enabled']}
                {$profile['user_name']}
              {else}
                {$profile['user_firstname']} {$profile['user_lastname']}
              {/if}
            </a>
            {if $profile['user_verified']}
              {include file='__badge.tpl' _badge="verified" _badge_type="user"}
            {/if}
            {if $profile['user_subscribed']}
              {include file='__badge.tpl' _badge="pro" _badge_package=$profile['package_name']}
            {/if}
          </div>
          <a class="info mt-0.5 block text-xs text-base-content/55! hover:text-primary!" href="{$system['system_url']}/{$profile['user_name']}/followers">{$profile['followers_count']} {__("followers")}</a>
        </div>
      </div>
    </div>

    {if ($profile['mutual_friends_count'] && $profile['mutual_friends_count'] > 0) || ($system['work_info_enabled'] && !is_empty($profile['user_work_title']) && ($profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_work'] == "public" || $profile['we_friends'])) || ($system['location_info_enabled'] && !is_empty($profile['user_hometown']) && ($profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_location'] == "public" || $profile['we_friends']))}
      <div class="user-card-meta flex flex-col gap-2 border-t border-base-300 px-4 py-3 text-xs leading-5 text-base-content/70">
        <!-- mutual friends -->
        {if $profile['mutual_friends_count'] && $profile['mutual_friends_count'] > 0}
          <button type="button" class="js_modal flex min-w-0 max-w-full cursor-pointer items-center gap-2.5 text-start hover:text-primary" data-url="users/mutual_friends.php?uid={$profile['user_id']}">
            {if $profile['mutual_friends']}
              <span class="avatar-group shrink-0 -space-x-2">
                {foreach $profile['mutual_friends'] as $_mutual_friend}
                  <span class="avatar">
                    <span class="size-6 rounded-full ring-2 ring-base-100">
                      <img src="{$_mutual_friend['user_picture']}" alt="" loading="lazy">
                    </span>
                  </span>
                {/foreach}
              </span>
            {else}
              <span class="icon-[tabler--users] size-4 shrink-0 text-base-content/45" aria-hidden="true"></span>
            {/if}
            <span class="truncate" title="{$profile['mutual_friends_count']} {__("mutual friends")}"><span class="font-semibold text-base-content">{$profile['mutual_friends_count']}</span> {__("mutual friends")}</span>
          </button>
        {/if}
        <!-- mutual friends -->

        <!-- work -->
        {if $system['work_info_enabled']}
          {if !is_empty($profile['user_work_title'])}
            {if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_work'] == "public" || $profile['we_friends']}
              <div class="flex items-start gap-2.5">
                <span class="icon-[tabler--briefcase] mt-0.5 size-4 shrink-0 text-base-content/45" aria-hidden="true"></span>
                <span>{$profile['user_work_title']} {__("at")} <span class="font-medium text-base-content">{$profile['user_work_place']}</span></span>
              </div>
            {/if}
          {/if}
        {/if}
        <!-- work -->

        <!-- hometown -->
        {if $system['location_info_enabled']}
          {if !is_empty($profile['user_hometown'])}
            {if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_location'] == "public" || $profile['we_friends']}
              <div class="flex items-start gap-2.5">
                <span class="icon-[tabler--home] mt-0.5 size-4 shrink-0 text-base-content/45" aria-hidden="true"></span>
                <span>{__("From")} <span class="font-medium text-base-content">{$profile['user_hometown']}</span></span>
              </div>
            {/if}
          {/if}
        {/if}
        <!-- hometown -->
      </div>
    {/if}

    <div class="popover-footer flex flex-wrap items-center gap-2 border-t border-base-300 bg-base-200/55 p-3">
      {if $user->_data['user_id'] != $profile['user_id']}
        <!-- add friend -->
        {if $system['friends_enabled']}
          {if $profile['we_friends']}
            {include file='__connection_button.tpl' _state="friends" _uid=$profile['user_id']}
          {elseif $profile['he_request']}
            {include file='__connection_button.tpl' _state="friend_request" _uid=$profile['user_id']}
          {elseif $profile['i_request']}
            {include file='__connection_button.tpl' _state="friend_sent" _uid=$profile['user_id']}
          {else}
            {include file='__connection_button.tpl' _state="friend_add" _uid=$profile['user_id']}
          {/if}
        {/if}
        <!-- add friend -->

        <!-- follow -->
        {if $profile['i_follow']}
          {include file='__connection_button.tpl' _state="following" _uid=$profile['user_id']}
        {else}
          {include file='__connection_button.tpl' _state="follow" _uid=$profile['user_id']}
        {/if}
        <!-- follow -->

        <!-- message -->
        {if $user->_logged_in}
          {if $system['chat_enabled'] && $profile['user_privacy_chat'] == "public" || ($profile['user_privacy_chat'] == "friends" && $profile['we_friends'])}
            <button type="button" class="heroui button button--tertiary button--sm ms-auto rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_chat-start {if !$profile['chat_price']}button--icon-only size-7.5{/if}" data-uid="{$profile['user_id']}" data-name="{if $system['show_usernames_enabled']}{$profile['user_name']}{else}{$profile['user_firstname']} {$profile['user_lastname']}{/if}" data-link="{$profile['user_name']}" data-picture="{$profile['user_picture']}" aria-label='{__("Message")}'>
              <span class="icon-[tabler--message-circle] size-4" aria-hidden="true"></span>
              {if $profile['chat_price']}<small>{print_money($profile['chat_price'])}</small>{/if}
            </button>
          {/if}
        {/if}
        <!-- message -->
      {else}
        <!-- edit -->
        <a href="{$system['system_url']}/settings/profile" class="heroui button button--primary button--sm w-full rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
          <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>{__("Update")}
        </a>
        <!-- edit -->
      {/if}
    </div>
  </div>
  <!-- user popover -->
{else}
  <!-- page popover -->
  <div class="user-popover-content relative z-[1090] w-80 overflow-hidden rounded-box border border-base-300 bg-base-100 text-base-content shadow-lg">
    <div class="user-card">
      <div class="user-card-cover h-24 bg-linear-to-br from-primary/35 via-primary/10 to-base-200 bg-cover bg-center" {if $profile['page_cover']}style="background-image:url('{$system['system_uploads']}/{$profile['page_cover']}');" {/if}></div>
      <div class="flex items-start gap-3 px-4 pb-4">
        <a class="user-card-avatar -mt-8 block size-16 shrink-0 overflow-hidden rounded-box bg-base-100 p-0.5 ring-1 ring-base-300" href="{$system['system_url']}/pages/{$profile['page_name']}">
          <img class="size-full rounded-[calc(var(--radius-box)-0.125rem)] object-cover" src="{$profile['page_picture']}" alt="{$profile['page_title']}">
        </a>
        <div class="user-card-info min-w-0 flex-1 pt-2">
          <div class="flex min-w-0 items-center gap-1">
            <a class="name truncate text-sm font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/pages/{$profile['page_name']}" title="{$profile['page_title']}">{$profile['page_title']}</a>
            {if $profile['page_verified']}
              {include file='__badge.tpl' _badge="verified" _badge_type="page"}
            {/if}
          </div>
          <div class="info mt-0.5 text-xs text-base-content/55">{$profile['page_likes']} {__("Likes")}</div>
        </div>
      </div>
    </div>
    <div class="popover-footer flex items-center gap-2 border-t border-base-300 bg-base-200/55 p-3 [&>.button]:w-full">
      <!-- like -->
      {if $profile['i_like']}
        {include file='__connection_button.tpl' _state="page_liked" _id=$profile['page_id']}
      {else}
        {include file='__connection_button.tpl' _state="page_like" _id=$profile['page_id']}
      {/if}
      <!-- like -->
    </div>
  </div>
  <!-- page popover -->
{/if}
