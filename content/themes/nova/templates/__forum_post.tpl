<article class="group flex gap-3 sm:gap-4 js_forum-post{if $_hidden} hidden{/if}" {if $_id}id="{$_id}"{/if} data-ord="{$_ord}" data-time="{$_post['time']}">
  <div class="flex shrink-0 flex-col items-center">
    <a href="{$system['system_url']}/{$_post['user_name']}">
      <img class="size-10 rounded-full object-cover" src="{$_post['user_picture']}" alt="">
    </a>
    {if !$_last}
      <span class="mt-2 w-px grow bg-base-300" aria-hidden="true"></span>
    {/if}
  </div>
  <div class="min-w-0 grow{if !$_last} mb-6 border-b border-base-300 pb-3{/if}">
    <!-- author -->
    <div class="flex flex-wrap items-center gap-x-1.5 gap-y-1 text-sm">
      <a class="max-w-full truncate font-semibold text-primary!" href="{$system['system_url']}/{$_post['user_name']}" title="{$_post['user_fullname']}">{$_post['user_fullname']}</a>
      {if $_post['user_group'] == 1}
        <span class="badge badge-soft badge-error badge-sm gap-1 rounded-full"><span class="icon-[tabler--shield-check] size-3.5" aria-hidden="true"></span>{__("Admin")}</span>
      {elseif $_post['user_group'] == 2}
        <span class="badge badge-soft badge-info badge-sm gap-1 rounded-full"><span class="icon-[tabler--shield-half] size-3.5" aria-hidden="true"></span>{__("Moderator")}</span>
      {/if}
      <span class="text-base-content/60">{__("wrote")} <span class="js_moment" data-time="{$_post['time']}">{$_post['time']}</span></span>
      <a class="ms-auto text-base-content/50! hover:text-primary!" href="{$_link}" title='{__("Link")}'>#{$_index}</a>
    </div>
    <!-- author -->

    {if $_post['reply_to']}
      <!-- quote -->
      <div class="mt-2">
        {include file='__forum_quote.tpl' _quote=$_post['reply_to'] _quote_url=$_thread_url}
      </div>
      <!-- quote -->
    {/if}

    <!-- content -->
    <div class="mt-2 min-w-0 break-words text-sm leading-relaxed text-base-content/85 [&_a]:text-primary [&_a]:underline [&_blockquote]:border-s-4 [&_blockquote]:border-base-300 [&_blockquote]:ps-4 [&_img]:h-auto [&_img]:max-w-full [&_img]:rounded-xl [&_ol]:list-decimal [&_ol]:ps-6 [&_p]:mb-3 [&_pre]:overflow-x-auto [&_pre]:rounded-xl [&_pre]:bg-base-200 [&_pre]:p-4 [&_ul]:list-disc [&_ul]:ps-6">
      {$_post['parsed_text']}
    </div>
    <!-- content -->

    <!-- actions -->
    <div class="mt-2 flex min-h-8 items-center justify-end gap-0.5">
      <span class="-ms-2 me-auto flex items-center gap-0.5 transition-opacity [@media(hover:hover)]:opacity-0 group-focus-within:opacity-100 group-hover:opacity-100">
        {if $_manage}
          <a class="heroui button button--ghost button--sm button--icon-only size-8 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$_edit}" title='{__("Edit")}' aria-label='{__("Edit")}'>
            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
          </a>
          {if $_handle == "reply"}
            <button type="button" class="heroui button button--ghost button--sm button--icon-only size-8 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] text-error js_delete-forum" data-handle="{$_handle}" data-id="{$_post_id}" title='{__("Delete")}' aria-label='{__("Delete")}'>
              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
            </button>
          {/if}
        {else}
          <button type="button" class="heroui button button--ghost button--sm button--icon-only size-8 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_modal" data-url="data/report.php?do=create&handle=forum_{$_handle}&id={$_post_id}" title='{__("Report")}' aria-label='{__("Report")}'>
            <span class="icon-[tabler--flag] size-4" aria-hidden="true"></span>
          </button>
        {/if}
      </span>
      {if $_can_reply}
        <a class="heroui button button--ghost button--sm rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] transition-opacity [@media(hover:hover)]:opacity-0 group-focus-within:opacity-100 group-hover:opacity-100 js_forum-reply-to" href="#forum-reply" {if $_handle == "reply"}data-id="{$_post_id}" data-name="{$_post['user_fullname']}" data-picture="{$_post['user_picture']}" data-text="{$_post['text_snippet']|truncate:300}"{/if}>
          <span class="icon-[tabler--arrow-back-up] size-4" aria-hidden="true"></span>
          {__("Reply")}
        </a>
      {/if}
      {if $user->_logged_in}
        <button type="button" class="heroui button button--ghost button--sm rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_forum-like{if $_post['i_like']} text-primary{/if}" data-handle="{$_handle}" data-id="{$_post_id}" aria-pressed="{if $_post['i_like']}true{else}false{/if}" title='{__("Like")}' aria-label='{__("Like")}'>
          <span class="icon-[tabler--thumb-up] size-4" aria-hidden="true"></span>
          <span class="js_forum-likes">{$_post['likes']}</span>
        </button>
      {elseif $_post['likes'] > 0}
        <span class="flex items-center gap-1 px-2 text-sm text-base-content/60" title='{__("Likes")}'><span class="icon-[tabler--thumb-up] size-4" aria-hidden="true"></span>{$_post['likes']}</span>
      {/if}
    </div>
    <!-- actions -->
  </div>
</article>
