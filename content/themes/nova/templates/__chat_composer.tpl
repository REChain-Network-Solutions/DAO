{if $_show_typing}
  <div class="chat-typing hidden px-4 py-1.5 text-xs text-base-content/55">
    <span class="inline-flex items-center gap-1.5">
      <span class="loading loading-dots loading-xs text-primary" aria-hidden="true"></span>
      <span><span class="js_chat-typing-users"></span> {__("Typing")}</span>
    </span>
  </div>
{/if}
{if $_layout == "page"}
  {include file='__composer.tpl' _context="chat" _size="lg" _class="chat-form border-t border-base-300 bg-base-100 px-3 py-3 sm:px-4"}
{else}
  {include file='__composer.tpl' _context="chat" _size="sm" _class="chat-form border-t border-base-300 p-2"}
{/if}
