<div class="dropdown inline-flex max-md:[--strategy:static] md:relative [--auto-close:inside] [--offset:8] [--placement:bottom-end] js_live-notifications" data-last-id="{$user->_data['user_live_notifications_lastid']}">
  <button type="button" class="dropdown-toggle btn btn-square btn-sm admin-topbar-icon"
          aria-haspopup="menu" aria-expanded="false" aria-label="{__("Notifications")}">
    <span class="icon-[tabler--bell] size-4.5" aria-hidden="true"></span>
    <span class="counter {if $user->_data['user_live_notifications_counter'] == 0}hidden{/if}">
      {$user->_data['user_live_notifications_counter']}
    </span>
  </button>
  <div class="dropdown-menu dropdown-open:opacity-100 hidden dropdown-widget js_dropdown-keepopen p-0 max-md:absolute max-md:inset-x-0 max-md:top-full max-md:mt-0 max-md:w-auto! max-md:max-w-none! max-md:rounded-t-none! max-md:border-x-0! max-md:border-t-0!" role="menu">
    <div class="dropdown-widget-header">
      <span class="title">{__("Notifications")}</span>
    </div>
    <div class="dropdown-widget-body overflow-x-hidden [&_.data-container]:px-4! [&_.data-content]:break-words [&_.data-content]:whitespace-normal [&_.data-content]:text-[0.8125rem] [&_ul]:min-w-0 [&_ul]:px-2!">
      <div class="js_scroller overflow-x-hidden"{if !isset($user->_data['notifications'])} data-lazy="notifications"{/if}>
        {if !isset($user->_data['notifications'])}
          <div class="flex justify-center"><span class="loading loading-spinner my-2.5"></span></div>
        {elseif $user->_data['notifications']}
          <ul>
            {foreach $user->_data['notifications'] as $notification}
              {include file='__feeds_notification.tpl'}
            {/foreach}
          </ul>
        {else}
          {include file='_no_data.tpl' _empty_menu=true _empty_icon="icon-[tabler--bell-off]" _empty_title=__("No notifications") _empty_text=__("You're all caught up")}
        {/if}
      </div>
    </div>
    <a class="dropdown-widget-footer" href="{$system['system_url']}/notifications">{__("See All")}</a>
  </div>
</div>
