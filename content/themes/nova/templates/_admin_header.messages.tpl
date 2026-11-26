{if $system['chat_enabled'] && $user->_data['user_privacy_chat'] != "me"}
  <div class="dropdown inline-flex max-md:[--strategy:static] md:relative [--offset:8] [--placement:bottom-end] js_live-messages" data-last-message="{$user->_data['user_live_messages_lastid']}">
    <button type="button" class="dropdown-toggle btn btn-square btn-sm admin-topbar-icon"
            aria-haspopup="menu" aria-expanded="false" aria-label="{__("Messages")}">
      <span class="icon-[tabler--message-circle] size-4.5" aria-hidden="true"></span>
      <span class="counter {if $user->_data['user_live_messages_counter'] == 0}hidden{/if}">
        {$user->_data['user_live_messages_counter']}
      </span>
    </button>
    <div class="dropdown-menu dropdown-open:opacity-100 hidden dropdown-widget p-0 max-md:absolute max-md:inset-x-0 max-md:top-full max-md:mt-0 max-md:w-auto! max-md:max-w-none! max-md:rounded-t-none! max-md:border-x-0! max-md:border-t-0!" role="menu">
      <div class="dropdown-widget-header relative">
        <span class="title">{__("Messages")}</span>
        <a class="btn btn-text btn-circle btn-sm absolute end-3.5 top-1/2 -translate-y-1/2 js_chat-new" href="{$system['system_url']}/messages/new" title='{__("Send a New Message")}' aria-label='{__("Send a New Message")}'>
          <span class="icon-[tabler--edit] size-4.5" aria-hidden="true"></span>
        </a>
      </div>
      <div class="dropdown-widget-body overflow-x-hidden [&_.data-container]:px-4! [&_.data-content]:text-[0.8125rem] [&_.time]:text-[0.6875rem] [&_ul]:min-w-0 [&_ul]:px-2!">
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
      <a class="dropdown-widget-footer" href="{$system['system_url']}/messages">{__("See All")}</a>
    </div>
  </div>
{/if}
