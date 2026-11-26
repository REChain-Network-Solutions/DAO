<div class="js_chat-pin-wrap shrink-0">
  {if $conversation['pinned_message']}
    <div class="js_chat-pin flex items-center gap-2 border-b border-base-300 bg-base-100 px-4 py-2 sm:px-5">
      <button type="button" class="js_chat-pin-jump group/pin flex min-w-0 grow items-center gap-3 rounded-field py-0.5 text-start" data-id="{$conversation['pinned_message']['message_id']}">
        <span class="flex size-8 shrink-0 items-center justify-center rounded-lg bg-primary/10 text-primary" aria-hidden="true">
          <span class="icon-[tabler--pinned] size-4"></span>
        </span>
        <span class="min-w-0">
          <span class="block truncate text-xs font-semibold text-primary" title="{$conversation['pinned_message']['user_fullname']}">{$conversation['pinned_message']['user_fullname']}</span>
          <span class="block truncate text-sm text-base-content/70 transition-colors group-hover/pin:text-base-content" title="{if $conversation['pinned_message']['message_orginal_decoded']}{$conversation['pinned_message']['message_orginal_decoded']|escape:'html'}{else}{__("Message")}{/if}">{if $conversation['pinned_message']['message_orginal_decoded']}{$conversation['pinned_message']['message_orginal_decoded']|escape:'html'}{else}{__("Message")}{/if}</span>
        </span>
      </button>
      <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full shrink-0 text-base-content/50 hover:text-base-content js_unpin-message" data-cid="{$conversation['conversation_id']}" title="{__("Unpin")}" aria-label="{__("Unpin")}">
        <span class="icon-[tabler--pinned-off] size-4.5" aria-hidden="true"></span>
      </button>
    </div>
  {/if}
</div>
