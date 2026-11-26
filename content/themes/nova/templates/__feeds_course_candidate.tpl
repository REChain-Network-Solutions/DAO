<li class="flex items-start gap-3 py-4 first:pt-0 last:pb-0">
  <a class="shrink-0 rounded-full focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" href="{$system['system_url']}/{$candidate['user_name']}" aria-label="{$candidate['name']}">
    <img class="size-11 rounded-full object-cover" src="{$candidate['user_picture']}" alt="" loading="lazy">
  </a>
  <div class="min-w-0 flex-1 space-y-3">
    <div>
      <a class="rounded-field font-semibold text-base-content! wrap-break-word hover:text-primary! focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" href="{$system['system_url']}/{$candidate['user_name']}">{$candidate['name']}</a>
      <div class="mt-1 flex items-center gap-1.5 text-xs text-base-content/60">
        <span class="icon-[tabler--clock] size-3.5 shrink-0" aria-hidden="true"></span>
        <span class="sr-only">{__("Date")}</span>
        <span class="js_moment" data-time="{$candidate['applied_time']}">{$candidate['applied_time']}</span>
      </div>
    </div>
    <dl class="grid gap-2 text-sm text-base-content/75 sm:grid-cols-2">
      <div class="flex min-w-0 items-start gap-2 sm:col-span-2">
        <dt><span class="icon-[tabler--map-pin] mt-0.5 size-4" aria-hidden="true"></span><span class="sr-only">{__("Location")}</span></dt>
        <dd class="min-w-0 wrap-break-word">{$candidate['location']}</dd>
      </div>
      <div class="flex min-w-0 items-start gap-2">
        <dt><span class="icon-[tabler--phone] mt-0.5 size-4" aria-hidden="true"></span><span class="sr-only">{__("Phone")}</span></dt>
        <dd class="min-w-0 wrap-break-word"><bdi>{$candidate['phone']}</bdi></dd>
      </div>
      <div class="flex min-w-0 items-start gap-2">
        <dt><span class="icon-[tabler--mail] mt-0.5 size-4" aria-hidden="true"></span><span class="sr-only">{__("Email")}</span></dt>
        <dd class="min-w-0 wrap-break-word"><bdi>{$candidate['email']}</bdi></dd>
      </div>
    </dl>
    {if $system['chat_enabled']}
      <button type="button" class="button button--tertiary text-base-content button--sm js_chat-start rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-uid="{$candidate['user_id']}" data-name="{if $system['show_usernames_enabled']}{$candidate['user_name']}{else}{$candidate['user_firstname']} {$candidate['user_lastname']}{/if}" data-link="{$candidate['user_name']}" data-picture="{$candidate['user_picture']}">
        <span class="icon-[tabler--message-circle] size-4" aria-hidden="true"></span>{__("Message")}
      </button>
    {/if}
  </div>
</li>
