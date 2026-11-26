<div class="rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-base-200/60 px-4 py-3 text-sm">
  <div class="flex min-w-0 items-center gap-1.5 text-xs text-base-content/60">
    <img class="size-5 shrink-0 rounded-full object-cover" src="{$_quote['user_picture']}" alt="" loading="lazy">
    <a class="truncate font-semibold text-base-content! hover:text-primary!" href="{$_quote_url}#reply-{$_quote['reply_id']}" title="{$_quote['user_fullname']}">{$_quote['user_fullname']}</a>
    <span class="shrink-0">{__("said")}:</span>
  </div>
  <p class="mt-1.5 line-clamp-3 text-base-content/75" title="{$_quote['text_snippet']}">{$_quote['text_snippet']|truncate:300}</p>
</div>
