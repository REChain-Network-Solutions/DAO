{if $system['redirect_to_mobile_apps']}
  <span class="heroui inline-flex md:hidden">
    <button type="button" class="site-topbar-icon button button--tertiary button--icon-only relative rounded-2xl! corner-squircle supports-[corner-shape:squircle]:rounded-[2rem]!" onclick="open_messenger_app()" aria-label="{__("Messages")}">
      <span class="icon-[tabler--message-circle] size-5" aria-hidden="true"></span>
      <span class="counter absolute -top-1.25 -end-1.25 z-1 min-w-[18px] h-[18px] px-1.25 rounded-full border-2 border-base-200 bg-error text-[10px] font-semibold leading-[14px] text-white text-center {if $user->_data['user_live_messages_counter'] == 0}hidden{/if}">
        {$user->_data['user_live_messages_counter']}
      </span>
    </button>
  </span>
{/if}
<div class="dropdown {if $system['redirect_to_mobile_apps']}hidden md:inline-flex{else}inline-flex{/if} max-md:[--strategy:static] md:relative [--offset:10] [--placement:bottom-end] js_live-messages" data-last-message="{$user->_data['user_live_messages_lastid']}">
  <span class="heroui inline-flex">
    <button type="button" class="dropdown-toggle site-topbar-icon button button--tertiary button--icon-only relative rounded-2xl! corner-squircle supports-[corner-shape:squircle]:rounded-[2rem]!" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Messages")}">
      <span class="icon-[tabler--message-circle] size-5" aria-hidden="true"></span>
      <span class="counter absolute -top-1.25 -end-1.25 z-1 min-w-[18px] h-[18px] px-1.25 rounded-full border-2 border-base-200 bg-error text-[10px] font-semibold leading-[14px] text-white text-center {if $user->_data['user_live_messages_counter'] == 0}hidden{/if}">
        {$user->_data['user_live_messages_counter']}
      </span>
    </button>
  </span>
  <div class="dropdown-menu dropdown-open:opacity-100 hidden dropdown-widget w-[min(24rem,calc(100vw-1.5rem))] overflow-hidden p-0 max-md:absolute max-md:inset-x-0 max-md:top-full max-md:mt-0 max-md:w-auto max-md:rounded-t-none max-md:border-x-0 max-md:border-t-0 border border-base-content/15 shadow-lg shadow-black/10 dark:shadow-black/25" role="menu">
    <div class="dropdown-widget-header relative flex flex-wrap items-center gap-2 border-b border-base-300 px-4 py-3.5">
      <span class="title me-auto text-sm font-semibold leading-[1.3]">{__("Messages")}</span>
      <a class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full absolute end-4 top-1/2 -translate-y-1/2 js_chat-new" href="{$system['system_url']}/messages/new" title='{__("Send a New Message")}' aria-label='{__("Send a New Message")}'>
        <span class="icon-[tabler--edit] size-4.5" aria-hidden="true"></span>
      </a>
    </div>
    <div class="dropdown-widget-body max-h-[22rem] overflow-y-auto overflow-x-hidden [&_.data-container]:px-4! [&_.data-content]:text-[0.8125rem] [&_.time]:text-[0.6875rem] [&_ul]:m-0 [&_ul]:min-w-0 [&_ul]:list-none [&_ul]:p-0 [&_ul]:px-2!">
      <div class="js_scroller overflow-x-hidden"{if !isset($user->_data['conversations'])} data-lazy="messages"{/if}>
        {if !isset($user->_data['conversations'])}
          <div class="flex justify-center"><span class="loading loading-spinner my-2.5"></span></div>
        {elseif $user->_data['conversations']}
          <ul>
            {foreach $user->_data['conversations'] as $conversation}
              {include file='__feeds_conversation.tpl'}
            {/foreach}
          </ul>
        {else}
          {include file='_no_data.tpl' _empty_menu=true _empty_icon="icon-[tabler--message-circle-off]" _empty_title=__("No messages") _empty_text=__("Start a conversation with your friends")}
        {/if}
      </div>
    </div>
    <a class="dropdown-widget-footer block border-t border-base-300 px-3.5 py-2.5 text-center text-[0.8125rem] font-medium text-base-content! hover:bg-base-content/4" href="{$system['system_url']}/messages">{__("See All")}</a>
  </div>
</div>
