{if $system['friends_enabled']}
  <div class="dropdown inline-flex max-md:[--strategy:static] md:relative [--auto-close:inside] [--offset:8] [--placement:bottom-end] js_live-requests" data-last-id="{$user->_data['user_live_requests_lastid']}">
    <button type="button" class="dropdown-toggle btn btn-square btn-sm admin-topbar-icon"
            aria-haspopup="menu" aria-expanded="false" aria-label="{__("Friend Requests")}">
      <span class="icon-[tabler--user-plus] size-4.5" aria-hidden="true"></span>
      <span class="counter {if $user->_data['user_live_requests_counter'] == 0}hidden{/if}">
        {$user->_data['user_live_requests_counter']}
      </span>
    </button>
    <div class="dropdown-menu dropdown-open:opacity-100 hidden dropdown-widget js_dropdown-keepopen w-96! max-w-[min(24rem,calc(100vw-1.5rem))]! p-0 max-md:absolute max-md:inset-x-0 max-md:top-full max-md:mt-0 max-md:w-auto! max-md:max-w-none! max-md:rounded-t-none! max-md:border-x-0! max-md:border-t-0!" role="menu">
      <div class="dropdown-widget-header">
        <span class="title">{__("Friend Requests")}</span>
      </div>
      <div class="dropdown-widget-body overflow-x-hidden [&_.feeds-item]:px-4! [&_ul]:min-w-0 [&_ul]:px-2! [&_.button]:h-7 [&_.button]:text-xs [&_.button:not(.button--icon-only)]:px-2.5 [&_.button--icon-only]:w-7">
        <div class="js_scroller overflow-x-hidden"{if !isset($user->_data['friend_requests'])} data-lazy="friend_requests"{/if}>
          {if !isset($user->_data['friend_requests'])}
            <div class="flex justify-center"><span class="loading loading-spinner my-2.5"></span></div>
          {elseif $user->_data['friend_requests']}
            <ul>
              {foreach $user->_data['friend_requests'] as $_user}
                {include file='__feeds_user.tpl' _tpl="list" _connection="request"}
              {/foreach}
            </ul>
          {else}
            {include file='_no_data.tpl' _empty_menu=true _empty_icon="icon-[tabler--user-plus]" _empty_title=__("No new requests") _empty_text=__("New friend requests will show up here")}
          {/if}
        </div>
      </div>
      <a class="dropdown-widget-footer" href="{$system['system_url']}/people/friend_requests">{__("See All")}</a>
    </div>
  </div>
{/if}
