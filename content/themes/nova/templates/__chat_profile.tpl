<aside class="js_chat-profile flex min-h-0 w-80 shrink-0 overflow-hidden border-s border-base-300 bg-base-100 transition-[width,translate,visibility] duration-300 ease-out motion-reduce:transition-none max-xl:invisible max-xl:fixed max-xl:inset-y-0 max-xl:end-0 max-xl:z-50 max-xl:translate-x-full max-xl:shadow-2xl max-xl:rtl:-translate-x-full [&.is-open]:visible [&.is-open]:translate-x-0 xl:[&.is-closed]:invisible xl:[&.is-closed]:w-0 xl:[&.is-closed]:border-s-0" aria-label='{__("Info")}'>
  <div class="flex h-full w-80 shrink-0 flex-col overflow-y-auto">
    <div class="flex h-18 shrink-0 items-center justify-between gap-3 border-b border-base-300 px-5">
      <h2 class="text-base font-semibold">{__("Info")}</h2>
      <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full js_chat-profile-toggle" title='{__("Close")}' aria-label='{__("Close")}'>
        <span class="icon-[tabler--x] size-5" aria-hidden="true"></span>
      </button>
    </div>

    {if $_profile['is_group']}
      <!-- identity -->
      <div class="flex flex-col items-center gap-1 px-5 pt-6 text-center">
        <span class="relative rounded-full bg-linear-to-br from-primary via-secondary to-accent p-[3px]">
          <span class="flex size-24 overflow-hidden rounded-full border-4 border-base-100 bg-base-200">
            {if $conversation['picture']}
              <img class="size-full object-cover" src="{$conversation['picture']}" alt="">
            {else}
              <span class="h-full w-1/2 bg-cover bg-center" style="background-image: url('{$conversation['picture_left']}')"></span>
              <span class="h-full w-1/2 border-s-2 border-base-100 bg-cover bg-center" style="background-image: url('{$conversation['picture_right']}')"></span>
            {/if}
          </span>
        </span>
        <div class="mt-3 flex max-w-full items-center justify-center gap-1">
          <span class="js_chat-title truncate text-lg font-semibold" title="{$conversation['name']}">{$conversation['name']}</span>
          <button type="button" class="heroui button button--ghost button--sm button--icon-only size-6 rounded-full shrink-0 text-base-content/55 hover:text-primary js_modal" data-url="chat/conversation.php?do=group&conversation_id={$conversation['conversation_id']}" title='{__("Edit")}' aria-label='{__("Edit")}'>
            <span class="icon-[tabler--pencil] size-4" aria-hidden="true"></span>
          </button>
        </div>
        <span class="text-xs text-base-content/60">{$_profile['members_count']} {__("Members")}</span>
      </div>
      <!-- identity -->


      <!-- members -->
      <section class="mt-5 border-t border-base-300 px-5 py-5">
        <h3 class="mb-3 flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-base-content/50"><span class="icon-[tabler--users] size-4" aria-hidden="true"></span>{__("Members")}</h3>
        <ul class="-mx-2 flex max-h-72 flex-col overflow-y-auto">
          <li class="flex items-center gap-3 rounded-xl px-2 py-1.5">
            <img class="size-9 shrink-0 rounded-full object-cover" src="{$user->_data['user_picture']}" alt="">
            <span class="flex min-w-0 grow items-center gap-2">
              <span class="truncate text-sm font-medium" title="{if $system['show_usernames_enabled']}{$user->_data['user_name']}{else}{$user->_data['user_firstname']} {$user->_data['user_lastname']}{/if}">{if $system['show_usernames_enabled']}{$user->_data['user_name']}{else}{$user->_data['user_firstname']} {$user->_data['user_lastname']}{/if}</span>
              <span class="badge badge-soft badge-primary badge-xs shrink-0 rounded-full">{__("You")}</span>
            </span>
          </li>
          {foreach $conversation['recipients'] as $_recipient}
            <li>
              <a class="flex items-center gap-3 rounded-xl px-2 py-1.5 text-base-content! transition-colors hover:bg-base-200/60" href="{$system['system_url']}/{$_recipient['user_name']}">
                <img class="size-9 shrink-0 rounded-full object-cover" src="{$_recipient['user_picture']}" alt="">
                <span class="min-w-0 grow truncate text-sm font-medium" title="{if $system['show_usernames_enabled']}{$_recipient['user_name']}{else}{$_recipient['user_firstname']} {$_recipient['user_lastname']}{/if}">{if $system['show_usernames_enabled']}{$_recipient['user_name']}{else}{$_recipient['user_firstname']} {$_recipient['user_lastname']}{/if}</span>
              </a>
            </li>
          {/foreach}
        </ul>
        <button type="button" class="heroui button button--tertiary [--button-bg:var(--accent-soft)] [--button-bg-hover:var(--accent-soft-hover)] [--button-bg-pressed:var(--accent-soft-hover)] [--button-fg:var(--accent-soft-foreground)] button--sm rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] mt-3 w-full js_modal" data-url="chat/conversation.php?do=group&conversation_id={$conversation['conversation_id']}">
          <span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("Manage")}
        </button>
      </section>
      <!-- members -->

      <!-- media -->
      <section class="border-t border-base-300 px-5 py-5">
        <div class="mb-3 flex items-center justify-between gap-3">
          <h3 class="flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-base-content/50"><span class="icon-[tabler--photo] size-4" aria-hidden="true"></span>{__("Media")}</h3>
          {if $_profile['photos']}
            <span class="badge badge-soft badge-primary badge-xs shrink-0 rounded-full">{$_profile['photos_count']}</span>
          {/if}
        </div>
        {if $_profile['photos']}
          <div class="grid grid-cols-3 gap-0.5 overflow-hidden rounded-2xl">
            {foreach $_profile['photos'] as $_photo}
              <span class="js_lightbox-nodata group/media relative block aspect-square cursor-pointer overflow-hidden bg-base-200 {if $_photo@first && $_profile['photos']|count >= 3}col-span-2 row-span-2{/if}" data-image="{$system['system_uploads']}/{$_photo['image']}">
                <img class="size-full object-cover transition-transform duration-300 ease-out group-hover/media:scale-105" src="{$system['system_uploads']}/{$_photo['image']}" alt="" loading="lazy">
                {if $_photo@last && $_profile['photos_count'] > $_profile['photos']|count}
                  <span class="absolute inset-0 flex items-center justify-center bg-black/55 text-sm font-semibold text-white">+{$_profile['photos_count'] - $_profile['photos']|count}</span>
                {/if}
              </span>
            {/foreach}
          </div>
        {else}
          {include file='_no_data.tpl' _empty_icon="icon-[tabler--photo-off]" _empty_mini=true}
        {/if}
      </section>
      <!-- media -->

      <!-- about -->
      <section class="border-t border-base-300 px-5 py-5">
        <h3 class="mb-3 flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-base-content/50"><span class="icon-[tabler--info-circle] size-4" aria-hidden="true"></span>{__("About")}</h3>
        <dl class="grid grid-cols-2 gap-2">
          <div class="flex flex-col gap-2 rounded-2xl bg-base-200/60 p-3 last:odd:col-span-2">
            <span class="flex size-9 items-center justify-center rounded-xl bg-primary/10 text-primary"><span class="icon-[tabler--message-circle] size-5" aria-hidden="true"></span></span>
            <div class="flex flex-col-reverse">
              <dt class="text-xs text-base-content/60">{__("Messages")}</dt>
              <dd class="text-sm font-semibold">{$conversation['total_messages']}</dd>
            </div>
          </div>
          <div class="flex flex-col gap-2 rounded-2xl bg-base-200/60 p-3 last:odd:col-span-2">
            <span class="flex size-9 items-center justify-center rounded-xl bg-primary/10 text-primary"><span class="icon-[tabler--photo] size-5" aria-hidden="true"></span></span>
            <div class="flex flex-col-reverse">
              <dt class="text-xs text-base-content/60">{__("Photos")}</dt>
              <dd class="text-sm font-semibold">{$_profile['photos_count']}</dd>
            </div>
          </div>
          <div class="flex flex-col gap-2 rounded-2xl bg-base-200/60 p-3 last:odd:col-span-2">
            <span class="flex size-9 items-center justify-center rounded-xl bg-primary/10 text-primary"><span class="icon-[tabler--users] size-5" aria-hidden="true"></span></span>
            <div class="flex flex-col-reverse">
              <dt class="text-xs text-base-content/60">{__("Members")}</dt>
              <dd class="text-sm font-semibold">{$_profile['members_count']}</dd>
            </div>
          </div>
        </dl>
      </section>
      <!-- about -->
    {else}
      <!-- identity -->
      <div class="flex flex-col items-center gap-1 px-5 pt-6 text-center">
        <a class="relative rounded-full bg-linear-to-br from-primary via-secondary to-accent p-[3px]" href="{$system['system_url']}/{$_profile['user_name']}">
          <img class="size-24 rounded-full border-4 border-base-100 object-cover" src="{$_profile['user_picture']}" alt="">
          {if $conversation['user_is_online']}
            <span class="absolute bottom-2 end-2 size-4 rounded-full border-[3px] border-base-100 bg-success" aria-hidden="true"></span>
          {/if}
        </a>
        <div class="mt-3 flex max-w-full items-center justify-center gap-1">
          <a class="truncate text-lg font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/{$_profile['user_name']}" title="{$_profile['user_fullname']}">{$_profile['user_fullname']}</a>
          {if $_profile['user_verified']}
            {include file='__badge.tpl' _badge="verified" _badge_type="user" _badge_size=16}
          {/if}
          {if $_profile['user_subscribed']}
            {include file='__badge.tpl' _badge="pro" _badge_package=$_profile['package_name'] _badge_size=16}
          {/if}
        </div>
        <span class="text-xs text-base-content/60">
          {if $conversation['user_is_online']}
            <span class="inline-flex items-center gap-1.5"><span class="size-2 rounded-full bg-success" aria-hidden="true"></span>{__("Online")}</span>
          {elseif $conversation['user_last_seen']}
            {__("Active")} <span class="js_moment" data-time="{$conversation['user_last_seen']}">{$conversation['user_last_seen']}</span>
          {else}
            {__("Offline")}
          {/if}
        </span>
        {if $_profile['user_biography']}
          <p class="mt-2 line-clamp-3 text-sm leading-relaxed text-base-content/70" dir="auto" title="{$_profile['user_biography']}">{$_profile['user_biography']}</p>
        {/if}
      </div>
      <!-- identity -->


      <!-- actions -->
      <div class="flex flex-wrap items-center justify-center gap-2 px-5 pt-4">
        <a class="heroui button button--tertiary [--button-bg:var(--accent-soft)] [--button-bg-hover:var(--accent-soft-hover)] [--button-bg-pressed:var(--accent-soft-hover)] [--button-fg:var(--accent-soft-foreground)] button--sm rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/{$_profile['user_name']}">
          <span class="icon-[tabler--user] size-4" aria-hidden="true"></span>{__("Profile")}
        </a>
        {if $system['friends_enabled'] && $_profile['connection'] == "add"}
          {include file='__connection_button.tpl' _state="friend_add" _uid=$_profile['user_id']}
        {elseif $system['friends_enabled'] && $_profile['connection'] == "cancel"}
          {include file='__connection_button.tpl' _state="friend_sent" _uid=$_profile['user_id']}
        {elseif $system['friends_enabled'] && $_profile['connection'] == "remove"}
          {include file='__connection_button.tpl' _state="friends" _uid=$_profile['user_id']}
        {elseif $_profile['connection'] == "follow"}
          {include file='__connection_button.tpl' _state="follow" _uid=$_profile['user_id']}
        {elseif $_profile['connection'] == "unfollow"}
          {include file='__connection_button.tpl' _state="following" _uid=$_profile['user_id']}
        {/if}
      </div>
      <!-- actions -->

      <!-- media -->
      <section class="mt-5 border-t border-base-300 px-5 py-5">
        <div class="mb-3 flex items-center justify-between gap-3">
          <h3 class="flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-base-content/50"><span class="icon-[tabler--photo] size-4" aria-hidden="true"></span>{__("Media")}</h3>
          {if $_profile['photos']}
            <span class="badge badge-soft badge-primary badge-xs shrink-0 rounded-full">{$_profile['photos_count']}</span>
          {/if}
        </div>
        {if $_profile['photos']}
          <div class="grid grid-cols-3 gap-0.5 overflow-hidden rounded-2xl">
            {foreach $_profile['photos'] as $_photo}
              <span class="js_lightbox-nodata group/media relative block aspect-square cursor-pointer overflow-hidden bg-base-200 {if $_photo@first && $_profile['photos']|count >= 3}col-span-2 row-span-2{/if}" data-image="{$system['system_uploads']}/{$_photo['image']}">
                <img class="size-full object-cover transition-transform duration-300 ease-out group-hover/media:scale-105" src="{$system['system_uploads']}/{$_photo['image']}" alt="" loading="lazy">
                {if $_photo@last && $_profile['photos_count'] > $_profile['photos']|count}
                  <span class="absolute inset-0 flex items-center justify-center bg-black/55 text-sm font-semibold text-white">+{$_profile['photos_count'] - $_profile['photos']|count}</span>
                {/if}
              </span>
            {/foreach}
          </div>
        {else}
          {include file='_no_data.tpl' _empty_icon="icon-[tabler--photo-off]" _empty_mini=true}
        {/if}
      </section>
      <!-- media -->

      <!-- about -->
      <section class="border-t border-base-300 px-5 py-5">
        <h3 class="mb-3 flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-base-content/50"><span class="icon-[tabler--info-circle] size-4" aria-hidden="true"></span>{__("About")}</h3>
        <dl class="grid grid-cols-2 gap-2">
          <div class="flex flex-col gap-2 rounded-2xl bg-base-200/60 p-3 last:odd:col-span-2">
            <span class="flex size-9 items-center justify-center rounded-xl bg-primary/10 text-primary"><span class="icon-[tabler--message-circle] size-5" aria-hidden="true"></span></span>
            <div class="flex flex-col-reverse">
              <dt class="text-xs text-base-content/60">{__("Messages")}</dt>
              <dd class="text-sm font-semibold">{$conversation['total_messages']}</dd>
            </div>
          </div>
          <div class="flex flex-col gap-2 rounded-2xl bg-base-200/60 p-3 last:odd:col-span-2">
            <span class="flex size-9 items-center justify-center rounded-xl bg-primary/10 text-primary"><span class="icon-[tabler--photo] size-5" aria-hidden="true"></span></span>
            <div class="flex flex-col-reverse">
              <dt class="text-xs text-base-content/60">{__("Photos")}</dt>
              <dd class="text-sm font-semibold">{$_profile['photos_count']}</dd>
            </div>
          </div>
          <div class="flex flex-col gap-2 rounded-2xl bg-base-200/60 p-3 last:odd:col-span-2">
            <span class="flex size-9 items-center justify-center rounded-xl {if $conversation['user_is_online']}bg-success/10 text-success{else}bg-base-content/10 text-base-content/60{/if}"><span class="icon-[tabler--activity] size-5" aria-hidden="true"></span></span>
            <div class="flex flex-col-reverse">
              <dt class="text-xs text-base-content/60">{__("Status")}</dt>
              <dd class="text-sm font-semibold">{if $conversation['user_is_online']}{__("Online")}{else}{__("Offline")}{/if}</dd>
            </div>
          </div>
          {if $_profile['user_registered']}
            <div class="flex flex-col gap-2 rounded-2xl bg-base-200/60 p-3 last:odd:col-span-2">
              <span class="flex size-9 items-center justify-center rounded-xl bg-primary/10 text-primary"><span class="icon-[tabler--calendar] size-5" aria-hidden="true"></span></span>
              <div class="flex flex-col-reverse">
                <dt class="text-xs text-base-content/60">{__("Joined")}</dt>
                <dd class="text-sm font-semibold"><span class="js_moment" data-time="{$_profile['user_registered']}">{$_profile['user_registered']}</span></dd>
              </div>
            </div>
          {/if}
        </dl>
      </section>
      <!-- about -->
    {/if}

    <!-- report -->
    <section class="mt-auto flex flex-col gap-2 border-t border-base-300 px-5 py-4">
      {if $_profile['is_group'] && !$conversation['node_id']}
        <button type="button" class="js_chat-group-remove heroui button button--danger-soft button--sm rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] w-full" data-cid="{$conversation['conversation_id']}" data-uid="{$user->_data['user_id']}">
          <span class="icon-[tabler--logout] size-4" aria-hidden="true"></span>{__("Leave")}
        </button>
      {/if}
      <button type="button" class="js_modal heroui button button--danger-soft button--sm rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] w-full" data-url="data/report.php?do=create&handle=conversation&id={$conversation['conversation_id']}">
        <span class="icon-[tabler--flag] size-4" aria-hidden="true"></span>{__("Report")}
      </button>
    </section>
    <!-- report -->
  </div>
</aside>
