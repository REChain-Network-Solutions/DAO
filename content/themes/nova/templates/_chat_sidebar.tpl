{if $user->_logged_in && $system['chat_enabled'] && $user->_data['user_privacy_chat'] != "me"}
  <!-- chat sidebar -->
  <aside class="chat-sidebar {if !$user->_data['user_chat_enabled']}disabled{/if} group/chat sticky top-16 hidden h-[calc(100dvh-4rem)] w-[4.7rem] shrink-0 min-[1200px]:block" aria-label="{__("Chat")}">
    <div class="absolute inset-y-0 end-0 z-30 flex w-[4.7rem] flex-col overflow-hidden border-s border-base-content/10 bg-base-100 transition-[width,box-shadow] duration-200 ease-out motion-reduce:transition-none group-hover/chat:w-[17rem] group-has-[:focus-visible]/chat:w-[17rem] group-has-[.dropdown.open]/chat:w-[17rem] group-hover/chat:shadow-xl group-has-[:focus-visible]/chat:shadow-xl group-has-[.dropdown.open]/chat:shadow-xl group-hover/chat:delay-100 group-has-[:focus-visible]/chat:delay-100 group-has-[.dropdown.open]/chat:delay-100">
      <div class="chat-sidebar-content min-h-0 w-full flex-1 group-[.disabled]/chat:opacity-30">
        <div class="js_scroller overflow-x-hidden py-3 [scrollbar-width:none]! [&::-webkit-scrollbar]:hidden! group-hover/chat:[scrollbar-width:thin]! group-has-[:focus-visible]/chat:[scrollbar-width:thin]! group-has-[.dropdown.open]/chat:[scrollbar-width:thin]! group-hover/chat:[&::-webkit-scrollbar]:block group-has-[:focus-visible]/chat:[&::-webkit-scrollbar]:block group-has-[.dropdown.open]/chat:[&::-webkit-scrollbar]:block" data-slimScroll-height="100%">
          {include file='ajax.chat.master.sidebar.tpl'}
        </div>
      </div>
      <!-- footer -->
      <div class="flex shrink-0 flex-col items-center gap-1 border-t border-base-content/10 p-2">
        <a class="js_chat-new flex h-10 w-10 items-center overflow-hidden rounded-full transition-[width,background-color] duration-200 ease-out motion-reduce:transition-none group-hover/chat:w-full group-has-[:focus-visible]/chat:w-full group-has-[.dropdown.open]/chat:w-full group-hover/chat:delay-100 group-has-[:focus-visible]/chat:delay-100 group-has-[.dropdown.open]/chat:delay-100 bg-primary/10 text-primary! hover:bg-primary/15" href="{$system['system_url']}/messages/new" title="{__("New Message")}" aria-label="{__("New Message")}">
          <span class="grid size-10 shrink-0 place-items-center"><span class="icon-[tabler--message-plus] size-5" aria-hidden="true"></span></span>
          <span class="min-w-0 truncate pe-4 text-sm font-semibold opacity-0 transition-opacity duration-150 group-hover/chat:opacity-100 group-has-[:focus-visible]/chat:opacity-100 group-has-[.dropdown.open]/chat:opacity-100 group-hover/chat:delay-200 group-has-[:focus-visible]/chat:delay-200 group-has-[.dropdown.open]/chat:delay-200">{__("New Message")}</span>
        </a>
        <div class="dropdown relative flex w-full justify-center [--offset:8] [--placement:top-start]">
          <button type="button" class="dropdown-toggle flex h-10 w-10 items-center overflow-hidden rounded-full transition-[width,background-color] duration-200 ease-out motion-reduce:transition-none group-hover/chat:w-full group-has-[:focus-visible]/chat:w-full group-has-[.dropdown.open]/chat:w-full group-hover/chat:delay-100 group-has-[:focus-visible]/chat:delay-100 group-has-[.dropdown.open]/chat:delay-100 text-base-content/70 hover:bg-base-200 hover:text-base-content dropdown-open:bg-base-200" aria-haspopup="menu" aria-expanded="false" title="{__("Settings")}" aria-label="{__("Settings")}">
            <span class="grid size-10 shrink-0 place-items-center"><span class="icon-[tabler--settings] size-5" aria-hidden="true"></span></span>
            <span class="min-w-0 truncate pe-4 text-sm font-medium opacity-0 transition-opacity duration-150 group-hover/chat:opacity-100 group-has-[:focus-visible]/chat:opacity-100 group-has-[.dropdown.open]/chat:opacity-100 group-hover/chat:delay-200 group-has-[:focus-visible]/chat:delay-200 group-has-[.dropdown.open]/chat:delay-200">{__("Settings")}</span>
          </button>
          <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-60 rounded-box border border-base-content/10 bg-base-100 p-1 shadow-xl" role="menu">
            <a class="dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-[13px] font-medium text-base-content!" href="{$system['system_url']}/settings/blocking" role="menuitem">
              <span class="icon-[tabler--ban] size-4 shrink-0 text-base-content/55" aria-hidden="true"></span>{__("Manage Blocking")}
            </a>
            <a class="dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-[13px] font-medium text-base-content!" href="{$system['system_url']}/settings/privacy" role="menuitem">
              <span class="icon-[tabler--lock] size-4 shrink-0 text-base-content/55" aria-hidden="true"></span>{__("Privacy Settings")}
            </a>
            <div class="-mx-1 my-1 border-t border-base-content/10" role="separator"></div>
            <button type="button" class="dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-[13px] font-medium js_chat-toggle" data-status="{if $user->_data['user_chat_enabled']}on{else}off{/if}" role="menuitem">
              <span class="icon-[tabler--eye-off] size-4 shrink-0 text-base-content/55 group-[.disabled]/chat:hidden" aria-hidden="true"></span>
              <span class="icon-[tabler--eye] hidden size-4 shrink-0 text-base-content/55 group-[.disabled]/chat:inline-block" aria-hidden="true"></span>
              <span class="js_chat-toggle-text">{if $user->_data['user_chat_enabled']}{__("Turn Off Active Status")}{else}{__("Turn On Active Status")}{/if}</span>
            </button>
          </div>
        </div>
      </div>
      <!-- footer -->
    </div>
  </aside>
  <!-- chat sidebar -->
{/if}
