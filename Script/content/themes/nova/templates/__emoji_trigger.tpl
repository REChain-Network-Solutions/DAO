<div class="dropdown relative inline-flex [--scope:window] [--strategy:fixed] [--placement:top-end] [--auto-close:inside] [--has-autofocus:false]">
  <button type="button" class="dropdown-toggle js_emoji-menu-toggle heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full"{if $_gifs} data-gifs="true"{/if} aria-haspopup="dialog" aria-expanded="false" aria-label='{__("Insert an emoji")}' title='{__("Insert an emoji")}'>
    <span class="icon-[tabler--mood-smile] size-5" aria-hidden="true"></span>
  </button>
  <div class="dropdown-menu emoji-menu dropdown-open:opacity-100 hidden z-[100001] w-80 max-w-[calc(100vw-1rem)] overflow-hidden rounded-box border border-base-300 bg-base-100 p-0 text-base-content shadow-xl" role="dialog" aria-label='{__("Emojis")}'>
    <div class="flex items-center gap-2 p-4 text-sm" role="status"><span class="loading loading-spinner loading-sm" aria-hidden="true"></span>{__("Loading emojis")}</div>
  </div>
</div>
