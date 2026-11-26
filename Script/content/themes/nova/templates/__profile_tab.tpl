<li class="shrink-0 snap-start">
  {if $_modal_url}
    <button type="button" class="js_modal inline-flex h-12 items-center justify-center gap-2 rounded-2xl px-3 text-sm leading-none font-semibold whitespace-nowrap transition-colors sm:px-4 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $_active}bg-primary/10 text-primary! hover:bg-primary/15{else}text-base-content/70! hover:bg-base-200 hover:text-base-content!{/if}" data-url="{$_modal_url}">
      <span class="{$_icon} block size-5 shrink-0" aria-hidden="true"></span>
      <span>{$_label}</span>
    </button>
  {else}
    <a class="inline-flex h-12 items-center justify-center gap-2 rounded-2xl px-3 text-sm leading-none font-semibold whitespace-nowrap transition-colors sm:px-4 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $_active}bg-primary/10 text-primary! hover:bg-primary/15{else}text-base-content/70! hover:bg-base-200 hover:text-base-content!{/if}" href="{$_url}" {if $_active}aria-current="page"{/if}>
      <span class="{$_icon} block size-5 shrink-0" aria-hidden="true"></span>
      <span>{$_label}</span>
    </a>
  {/if}
</li>
