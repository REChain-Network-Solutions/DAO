<div class="js_chat-group flex flex-col gap-6" data-cid="{$conversation['conversation_id']}">
  <!-- name -->
  <form class="js_chat-group-rename flex items-end gap-4">
    <span class="flex size-14 shrink-0 overflow-hidden rounded-full bg-base-200">
      {if $conversation['picture']}
        <img class="size-full object-cover" src="{$conversation['picture']}" alt="">
      {else}
        <span class="h-full w-1/2 bg-cover bg-center" style="background-image: url('{$conversation['picture_left']}')"></span>
        <span class="h-full w-1/2 border-s-2 border-base-100 bg-cover bg-center" style="background-image: url('{$conversation['picture_right']}')"></span>
      {/if}
    </span>
    <div class="flex min-w-0 grow flex-col gap-1.5">
      <label class="label-text" for="chat-group-name-{$conversation['conversation_id']}">{__("Name")}</label>
      <div class="flex items-center gap-2">
        <div class="relative min-w-0 grow">
          <input id="chat-group-name-{$conversation['conversation_id']}" name="name" type="text" maxlength="128" value="{$conversation['custom_name']}" class="input w-full [--border:1px] {if $conversation['custom_name']}pe-10{/if}" placeholder="{$conversation['name_list']}">
          {if $conversation['custom_name']}
            <button type="button" class="button button--ghost button--icon-only button--sm absolute end-1 top-1/2 -translate-y-1/2 text-base-content/50 hover:text-base-content js_chat-group-clear" title='{__("Clear")}' aria-label='{__("Clear")}'>
              <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
            </button>
          {/if}
        </div>
        <button type="submit" class="button button--primary button--icon-only shrink-0" title='{__("Save")}' aria-label='{__("Save")}'>
          <span class="icon-[tabler--check] size-5" aria-hidden="true"></span>
        </button>
      </div>
    </div>
  </form>
  <!-- name -->

  <div class="border-t border-base-300" role="separator"></div>

  <!-- add -->
  <div class="flex flex-col gap-1.5">
    <span class="label-text">{__("Add")}</span>
    <div class="flex items-start gap-2">
      <div class="js_autocomplete-tags js_chat-group-add relative flex min-h-10 min-w-0 grow cursor-text flex-wrap items-center gap-1.5 rounded-xl border border-base-300 px-3 py-1.5 transition-colors focus-within:border-primary" data-skipped-ids="{$user->_data['user_id']}{foreach $conversation['recipients'] as $_recipient},{$_recipient['user_id']}{/foreach}">
        <span class="icon-[tabler--search] size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
        <ul class="tags contents [&_li]:inline-flex [&_li]:items-center [&_li]:gap-0.5 [&_li]:rounded-full [&_li]:bg-primary/10 [&_li]:py-0.5 [&_li]:ps-2.5 [&_li]:pe-0.5 [&_li]:text-xs [&_li]:font-medium [&_li]:text-primary"></ul>
        <div class="typeahead min-w-20 grow [&_.dropdown-menu]:absolute [&_.dropdown-menu]:inset-x-0 [&_.dropdown-menu]:top-full [&_.dropdown-menu]:z-50 [&_.dropdown-menu]:mt-1 [&_.dropdown-menu]:max-h-72 [&_.dropdown-menu]:overflow-y-auto [&_.dropdown-menu]:border [&_.dropdown-menu]:border-base-300 [&_.dropdown-menu]:p-0 [&_.dropdown-menu]:text-sm [&_.dropdown-menu]:opacity-100 [&_.dropdown-menu]:shadow-lg [&_.dropdown-menu:empty]:hidden">
          <input type="text" size="1" class="min-w-full border-0 bg-transparent py-0 text-sm leading-5 max-md:text-base outline-none placeholder:text-base-content/50" placeholder='{__("Search")}' aria-label='{__("Search")}'>
        </div>
      </div>
      <button type="button" class="button button--primary shrink-0 js_chat-group-add-btn">{__("Add")}</button>
    </div>
  </div>
  <!-- add -->

  <!-- members -->
  <div class="flex flex-col gap-1.5">
    <div class="flex items-center gap-2">
      <span class="label-text">{__("Members")}</span>
      <span class="badge badge-soft badge-sm rounded-full">{count($conversation['recipients']) + 1}</span>
    </div>
    <ul class="-mx-2 flex max-h-80 flex-col overflow-y-auto">
      <li class="flex items-center gap-3 rounded-xl px-2 py-2">
        <img class="size-10 shrink-0 rounded-full object-cover" src="{$user->_data['user_picture']}" alt="">
        <span class="flex min-w-0 grow items-center gap-2">
          <span class="truncate text-sm font-semibold" title="{if $system['show_usernames_enabled']}{$user->_data['user_name']}{else}{$user->_data['user_firstname']} {$user->_data['user_lastname']}{/if}">{if $system['show_usernames_enabled']}{$user->_data['user_name']}{else}{$user->_data['user_firstname']} {$user->_data['user_lastname']}{/if}</span>
          <span class="badge badge-soft badge-primary badge-xs shrink-0 rounded-full">{__("You")}</span>
        </span>
      </li>
      {foreach $conversation['recipients'] as $_recipient}
        <li class="flex items-center gap-3 rounded-xl px-2 py-2 transition-colors hover:bg-base-200/60">
          <a class="shrink-0" href="{$system['system_url']}/{$_recipient['user_name']}">
            <img class="size-10 rounded-full object-cover" src="{$_recipient['user_picture']}" alt="">
          </a>
          <a class="min-w-0 grow truncate text-sm font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/{$_recipient['user_name']}" title="{if $system['show_usernames_enabled']}{$_recipient['user_name']}{else}{$_recipient['user_firstname']} {$_recipient['user_lastname']}{/if}">{if $system['show_usernames_enabled']}{$_recipient['user_name']}{else}{$_recipient['user_firstname']} {$_recipient['user_lastname']}{/if}</a>
          <button type="button" class="button button--ghost button--icon-only button--sm shrink-0 text-base-content/55 hover:text-error js_chat-group-remove" data-uid="{$_recipient['user_id']}" title='{__("Remove")}' aria-label='{__("Remove")}'>
            <span class="icon-[tabler--user-minus] size-4.5" aria-hidden="true"></span>
          </button>
        </li>
      {/foreach}
    </ul>
  </div>
  <!-- members -->
</div>
