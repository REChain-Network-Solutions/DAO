<div class="min-w-0 overflow-hidden rounded-xl border border-base-300 bg-base-200/50" dir="ltr">
  <div class="flex items-center justify-between gap-3 border-b border-base-300 bg-base-100/60 px-4 py-1.5">
    <span class="flex items-center gap-2 font-mono text-[11px] font-semibold uppercase tracking-wider text-base-content/50">
      <span class="icon-[tabler--code] size-3.5" aria-hidden="true"></span>
      {$_lang}
    </span>
    <button type="button" class="heroui button button--ghost button--sm h-6 px-2 text-xs gap-1 text-base-content/60 js_clipboard" data-clipboard-target="#{$_id}" data-clipboard-success-text='{__("Copied")}'>
      <span class="js-clipboard-default icon-[tabler--copy] size-3.5" aria-hidden="true"></span>
      <span class="js-clipboard-success icon-[tabler--check] hidden size-3.5 text-success" aria-hidden="true"></span>
      <span class="js-clipboard-success-text">{__("Copy")}</span>
    </button>
  </div>
  <pre class="overflow-x-auto px-4 py-3.5 text-[13px] leading-6"><code class="font-mono text-base-content/85" id="{$_id}">{$_code}</code></pre>
</div>
