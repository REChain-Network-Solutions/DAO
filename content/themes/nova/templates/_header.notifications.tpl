<div class="dropdown inline-flex max-md:[--strategy:static] md:relative [--auto-close:inside] [--offset:10] [--placement:bottom-end] js_live-notifications" data-last-id="{$user->_data['user_live_notifications_lastid']}">
  <span class="heroui inline-flex">
    <button type="button" class="dropdown-toggle site-topbar-icon button button--tertiary button--icon-only relative rounded-2xl! corner-squircle supports-[corner-shape:squircle]:rounded-[2rem]!" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Notifications")}">
      <span class="icon-[tabler--bell] size-5" aria-hidden="true"></span>
      <span class="counter absolute -top-1.25 -end-1.25 z-1 min-w-[18px] h-[18px] px-1.25 rounded-full border-2 border-base-200 bg-error text-[10px] font-semibold leading-[14px] text-white text-center {if $user->_data['user_live_notifications_counter'] == 0}hidden{/if}">
        {$user->_data['user_live_notifications_counter']}
      </span>
    </button>
  </span>
  <div class="dropdown-menu dropdown-open:opacity-100 hidden dropdown-widget js_dropdown-keepopen w-[min(24rem,calc(100vw-1.5rem))] overflow-hidden p-0 max-md:absolute max-md:inset-x-0 max-md:top-full max-md:mt-0 max-md:w-auto max-md:rounded-t-none max-md:border-x-0 max-md:border-t-0 border border-base-content/15 shadow-lg shadow-black/10 dark:shadow-black/25" role="menu">
    <div class="dropdown-widget-header flex flex-wrap items-center gap-2 border-b border-base-300 px-4 py-3.5">
      <span class="title me-auto text-sm font-semibold leading-[1.3]">{__("Notifications")}</span>
    </div>
    <div class="dropdown-widget-body max-h-[22rem] overflow-y-auto overflow-x-hidden [&_.data-container]:px-4! [&_.data-content]:break-words [&_.data-content]:whitespace-normal [&_.data-content]:text-[0.8125rem] [&_ul]:m-0 [&_ul]:min-w-0 [&_ul]:list-none [&_ul]:p-0 [&_ul]:px-2!">
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
    <a class="dropdown-widget-footer block border-t border-base-300 px-3.5 py-2.5 text-center text-[0.8125rem] font-medium text-base-content! hover:bg-base-content/4" href="{$system['system_url']}/notifications">{__("See All")}</a>
  </div>
</div>
