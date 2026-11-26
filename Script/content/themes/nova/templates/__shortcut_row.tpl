<li class="group/shortcut flex items-center gap-3 rounded-xl p-2" data-key="{$_shortcut['node_type']}:{$_shortcut['node_id']}">
  <img class="size-10 shrink-0 rounded-full object-cover transition-opacity group-has-[[value=hidden]:checked]/shortcut:opacity-40" src="{$_shortcut['picture']}" alt="" loading="lazy">
  <span class="min-w-0 flex-1 truncate text-sm font-semibold transition-colors group-has-[[value=hidden]:checked]/shortcut:text-base-content/40" title="{$_shortcut['title']}">{$_shortcut['title']}</span>
  <div class="inline-flex shrink-0 gap-0.5 rounded-full bg-base-200 p-0.5" role="radiogroup" aria-label="{$_shortcut['title']}">
    <span class="tooltip inline-flex [--placement:top]">
      <label class="tooltip-toggle flex size-8 cursor-pointer items-center justify-center rounded-full text-base-content/60 transition-colors hover:text-base-content has-checked:bg-primary has-checked:text-primary-content has-focus-visible:outline-2 has-focus-visible:outline-offset-2 has-focus-visible:outline-primary" aria-label='{__("Sort Automatically")}'>
        <input type="radio" class="js_shortcut-state sr-only" name="shortcut_{$_shortcut['node_type']}_{$_shortcut['node_id']}" value="auto" {if $_shortcut['state'] == "auto"}checked{/if}>
        <span class="icon-[tabler--sparkles] size-4.5" aria-hidden="true"></span>
      </label>
      <span class="tooltip-content tooltip-shown:opacity-100 tooltip-shown:visible" role="tooltip"><span class="tooltip-body px-2 py-1 text-xs font-medium">{__("Sort Automatically")}</span></span>
    </span>
    <span class="tooltip inline-flex [--placement:top]">
      <label class="tooltip-toggle flex size-8 cursor-pointer items-center justify-center rounded-full text-base-content/60 transition-colors hover:text-base-content has-checked:bg-primary has-checked:text-primary-content has-focus-visible:outline-2 has-focus-visible:outline-offset-2 has-focus-visible:outline-primary" aria-label='{__("Pin to Top")}'>
        <input type="radio" class="js_shortcut-state sr-only" name="shortcut_{$_shortcut['node_type']}_{$_shortcut['node_id']}" value="pinned" {if $_shortcut['state'] == "pinned"}checked{/if}>
        <span class="icon-[tabler--pin] size-4.5" aria-hidden="true"></span>
      </label>
      <span class="tooltip-content tooltip-shown:opacity-100 tooltip-shown:visible" role="tooltip"><span class="tooltip-body px-2 py-1 text-xs font-medium">{__("Pin to Top")}</span></span>
    </span>
    <span class="tooltip inline-flex [--placement:top]">
      <label class="tooltip-toggle flex size-8 cursor-pointer items-center justify-center rounded-full text-base-content/60 transition-colors hover:text-base-content has-checked:bg-primary has-checked:text-primary-content has-focus-visible:outline-2 has-focus-visible:outline-offset-2 has-focus-visible:outline-primary" aria-label='{__("Hide")}'>
        <input type="radio" class="js_shortcut-state sr-only" name="shortcut_{$_shortcut['node_type']}_{$_shortcut['node_id']}" value="hidden" {if $_shortcut['state'] == "hidden"}checked{/if}>
        <span class="icon-[tabler--eye-off] size-4.5" aria-hidden="true"></span>
      </label>
      <span class="tooltip-content tooltip-shown:opacity-100 tooltip-shown:visible" role="tooltip"><span class="tooltip-body px-2 py-1 text-xs font-medium">{__("Hide")}</span></span>
    </span>
  </div>
</li>
