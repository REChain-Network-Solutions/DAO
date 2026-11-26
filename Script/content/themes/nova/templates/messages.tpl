{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="sg-offcanvas group/offcanvas flex min-h-0 flex-1 flex-col overflow-hidden {if $view == "message" && $sub_view == "all"}active{/if}">
  <div class="card flex min-h-0 flex-1 flex-row overflow-hidden border border-base-300 bg-base-100 shadow-none">

    <!-- threads -->
    <div class="sg-offcanvas-sidebar hidden h-full min-h-0 w-full shrink-0 flex-col border-e border-base-300 max-lg:group-[.active]/offcanvas:flex lg:flex lg:w-80 xl:w-88">
      <div class="flex shrink-0 flex-col gap-3 px-4 pb-3 pt-4">
        <div class="flex items-center gap-0.5">
          <h1 class="min-w-0 grow text-xl font-bold tracking-tight">{__("Messages")}</h1>
          <a class="heroui button button--ghost button--icon-only size-10 rounded-full text-base-content/70 hover:text-primary js_chat-new" href="{$system['system_url']}/messages/new" title='{__("New Message")}' aria-label='{__("New Message")}'>
            <span class="icon-[tabler--edit] size-5" aria-hidden="true"></span>
          </a>
        </div>
        <label class="input w-full rounded-full">
          <span class="icon-[tabler--search] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
          <input type="search" class="js_chat-threads-search grow" placeholder='{__("Search")}' aria-label='{__("Search")}' autocomplete="off">
        </label>
        <div class="flex flex-wrap gap-1.5" role="group" aria-label='{__("Messages")}'>
          <button type="button" class="js_chat-threads-filter heroui button button--tertiary button--sm h-7 rounded-full border-0 bg-base-200 px-3 text-base-content/70 shadow-none hover:bg-base-300 aria-pressed:bg-primary aria-pressed:text-primary-content" data-filter="all" aria-pressed="true">
            <span class="icon-[tabler--inbox] size-3.5" aria-hidden="true"></span>{__("All")}
          </button>
          <button type="button" class="js_chat-threads-filter heroui button button--tertiary button--sm h-7 rounded-full border-0 bg-base-200 px-3 text-base-content/70 shadow-none hover:bg-base-300 aria-pressed:bg-primary aria-pressed:text-primary-content" data-filter="unread" aria-pressed="false">
            <span class="icon-[tabler--mail] size-3.5" aria-hidden="true"></span>{__("Unread")}
          </button>
          <button type="button" class="js_chat-threads-filter heroui button button--tertiary button--sm h-7 rounded-full border-0 bg-base-200 px-3 text-base-content/70 shadow-none hover:bg-base-300 aria-pressed:bg-primary aria-pressed:text-primary-content" data-filter="groups" aria-pressed="false">
            <span class="icon-[tabler--users-group] size-3.5" aria-hidden="true"></span>{__("Groups")}
          </button>
        </div>
      </div>
      <div class="js_live-messages-alt min-h-0 flex-1">
        <div class="js_scroller h-full px-2 pb-2" data-slimScroll-height="100%">
          {if $user->_data['conversations']}
            <ul class="m-0 flex list-none flex-col gap-1 p-0">
              {foreach $user->_data['conversations'] as $_conversation}
                {include file='__feeds_conversation.tpl' conversation=$_conversation _active_cid=$conversation['conversation_id']}
              {/foreach}
            </ul>
            {if count($user->_data['conversations']) >= $system['max_results']}
              <!-- see-more -->
              <div class="see-more js_see-more mx-1 mt-2 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-2.5 text-xs font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="conversations">
                <span>{__("Load Older Threads")}</span>
                <div class="loading loading-spinner loading-sm hidden"></div>
              </div>
              <!-- see-more -->
            {/if}
          {else}
            {include file='_no_data.tpl' _empty_icon="icon-[tabler--message-circle-off]" _empty_title=__("No messages")}
          {/if}
        </div>
      </div>
    </div>
    <!-- threads -->

    <!-- conversation -->
    <div class="sg-offcanvas-mainbar js_conversation-container flex min-h-0 min-w-0 flex-1 flex-col overflow-hidden max-lg:group-[.active]/offcanvas:hidden lg:flex">
      {if $view == "new" && $recipient_page}
        <div class="card panel-messages flex min-h-0 flex-1 flex-col overflow-hidden rounded-none border-0 bg-base-100 shadow-none" data-page-id="{$recipient_page['page_id']}">
          <div class="flex h-18 shrink-0 items-center gap-3 border-b border-base-300 px-4 sm:px-5">
            <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full -ms-1 lg:hidden" data-bs-toggle="sg-offcanvas" title='{__("Back To Messages")}' aria-label='{__("Back To Messages")}'>
              <span class="icon-[tabler--chevron-left] size-5 rtl:rotate-180" aria-hidden="true"></span>
            </button>
            <span class="flex size-11 shrink-0 overflow-hidden rounded-full bg-base-200">
              <img class="size-full object-cover" src="{$recipient_page['page_picture']}" alt="">
            </span>
            <div class="min-w-0 grow">
              <div class="truncate font-semibold leading-tight [&_a]:text-base-content! [&_a:hover]:text-primary!" title="{$recipient_page['page_title']}">
                <a href="{$system['system_url']}/pages/{$recipient_page['page_name']}">{$recipient_page['page_title']}</a>
              </div>
              <div class="mt-0.5 truncate text-xs text-base-content/55">{__("Page")}</div>
            </div>
          </div>
          <div class="js_chat-pin-wrap shrink-0"></div>
          <div class="chat-conversations js_scroller flex min-h-0 flex-1 flex-col overflow-y-auto bg-linear-to-b from-base-200/40 to-base-100 px-4 py-4 sm:px-6" data-slimScroll-height="100%">
            <ul class="m-0 mt-auto flex list-none flex-col gap-3 p-0"></ul>
          </div>
          <div class="shrink-0">
            {include file='__chat_composer.tpl' _layout="page" _show_typing=false}
          </div>
        </div>
      {elseif $view == "new"}
        <div class="card panel-messages fresh flex min-h-0 flex-1 flex-col overflow-hidden rounded-none border-0 bg-base-100 shadow-none">
          <div class="flex h-18 shrink-0 items-center gap-3 border-b border-base-300 px-4 sm:px-5">
            <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full -ms-1 lg:hidden" data-bs-toggle="sg-offcanvas" title='{__("Back To Messages")}' aria-label='{__("Back To Messages")}'>
              <span class="icon-[tabler--chevron-left] size-5 rtl:rotate-180" aria-hidden="true"></span>
            </button>
            <h2 class="text-lg font-semibold">{__("New Message")}</h2>
          </div>
          <div class="chat-to js_autocomplete-tags relative flex min-h-14 shrink-0 cursor-text flex-wrap items-center gap-1.5 border-b border-base-300 px-4 py-2.5 sm:px-5">
            <div class="to text-sm font-medium text-base-content/60">{__("To")}:</div>
            <ul class="tags contents [&_li]:inline-flex [&_li]:items-center [&_li]:gap-1 [&_li]:rounded-full [&_li]:bg-primary/10 [&_li]:py-1 [&_li]:ps-2.5 [&_li]:pe-1 [&_li]:text-xs [&_li]:font-medium [&_li]:text-primary">
              {if $recipient}
                <li data-uid="{$recipient['user_id']}">{$recipient['user_fullname']}<button class="heroui button button--ghost [--button-fg:var(--accent)] button--sm button--icon-only rounded-full size-5 min-h-0 js_tag-remove" type="button" title="{__("Remove")}" aria-label="{__("Remove")}"><span class="icon-[tabler--x] size-3.5" aria-hidden="true"></span></button></li>
              {/if}
            </ul>
            <div class="typeahead min-w-24 grow [&_.dropdown-menu]:start-4 [&_.dropdown-menu]:w-72 [&_.dropdown-menu]:max-w-[calc(100%-2rem)] sm:[&_.dropdown-menu]:start-5 [&_.dropdown-menu]:absolute [&_.dropdown-menu]:top-full [&_.dropdown-menu]:z-50 [&_.dropdown-menu]:mt-1 [&_.dropdown-menu]:max-h-72 [&_.dropdown-menu]:overflow-y-auto [&_.dropdown-menu]:border [&_.dropdown-menu]:border-base-300 [&_.dropdown-menu]:p-0 [&_.dropdown-menu]:text-sm [&_.dropdown-menu]:opacity-100 [&_.dropdown-menu]:shadow-lg [&_.dropdown-menu:empty]:hidden">
              <input type="text" size="1" autofocus class="min-w-20 border-0 bg-transparent text-sm outline-none max-md:text-base">
            </div>
          </div>
          <div class="js_chat-pin-wrap shrink-0"></div>
          <div class="chat-conversations js_scroller flex min-h-0 flex-1 flex-col overflow-y-auto bg-linear-to-b from-base-200/40 to-base-100 px-4 py-4 sm:px-6" data-slimScroll-height="100%"></div>
          <div class="shrink-0">
            {include file='__chat_composer.tpl' _layout="page" _show_typing=false}
          </div>
        </div>
      {else}
        {if $conversation}
          {include file='ajax.chat.conversation.tpl'}
        {else}
          <div class="flex h-full min-h-0 flex-col items-center justify-center bg-linear-to-b from-base-200/40 to-base-100">
            {include file='_no_data.tpl' _empty_icon="icon-[tabler--message-circle-off]" _empty_title=__("No Conversation Selected") _empty_text=__("Choose a thread or start a new message")}
            <a class="heroui button button--primary mb-10 js_chat-new" href="{$system['system_url']}/messages/new">
              <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
              {__("New Message")}
            </a>
          </div>
        {/if}
      {/if}
    </div>
    <!-- conversation -->

  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}
