<div class="flex items-center gap-3 px-5 py-3.5">
  <h2 class="flex min-w-0 grow items-center gap-2 text-sm font-semibold">
    {if $_card_url && !$_card_label}
      <a class="truncate text-base-content! hover:text-primary!" href="{$_card_url}" title="{$_card_title}">{$_card_title}</a>
    {else}
      <span class="truncate" title="{$_card_title}">{$_card_title}</span>
    {/if}
    {if isset($_card_count)}
      <span class="badge badge-soft badge-sm shrink-0 rounded-full">{$_card_count}</span>
    {/if}
  </h2>
  {if $_card_arrows}
    <div class="flex shrink-0 items-center gap-1.5">
      <button type="button" class="carousel-prev static heroui button {$_card_arrow_class|default:'button--tertiary text-base-content'} button--sm button--icon-only size-6 rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-[0.75rem]" aria-label='{__("Previous")}'>
        <span class="icon-[tabler--chevron-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
      </button>
      <button type="button" class="carousel-next static heroui button {$_card_arrow_class|default:'button--tertiary text-base-content'} button--sm button--icon-only size-6 rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-[0.75rem]" aria-label='{__("Next")}'>
        <span class="icon-[tabler--chevron-right] size-4 rtl:rotate-180" aria-hidden="true"></span>
      </button>
    </div>
  {/if}
  {if $_card_url && $_card_label}
    <a class="inline-flex shrink-0 items-center gap-1 text-xs font-medium text-base-content/60! hover:text-primary!" href="{$_card_url}">
      {$_card_label}
      <span class="icon-[tabler--arrow-right] size-3.5 rtl:rotate-180" aria-hidden="true"></span>
    </a>
  {/if}
</div>
