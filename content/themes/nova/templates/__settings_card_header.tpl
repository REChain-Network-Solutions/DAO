<div class="card-header flex items-center gap-3 border-b border-base-300">
  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
    <span class="{$_icon} size-5"></span>
  </span>
  <div class="min-w-0">
    <h2 class="card-title text-lg">{$_title}</h2>
    {if $_text}
      <p class="{if $_text_class}{$_text_class}{else}text-sm{/if} text-base-content/60">{$_text}</p>
    {/if}
  </div>
</div>
