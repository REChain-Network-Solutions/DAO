{for $_i=1 to $_depth}<span class="inline-block w-5 shrink-0" aria-hidden="true"></span>{/for}
{if $_has_children}
  <button type="button" class="js_tree-toggle heroui button button--ghost button--sm button--icon-only size-6 rounded-full shrink-0 [&[aria-expanded=false]>span]:-rotate-90 rtl:[&[aria-expanded=false]>span]:rotate-90" aria-expanded="true" aria-label='{__("Toggle")}'>
    <span class="icon-[tabler--chevron-down] size-4 transition-transform" aria-hidden="true"></span>
  </button>
{else}
  <span class="inline-block w-6 shrink-0" aria-hidden="true"></span>
{/if}
