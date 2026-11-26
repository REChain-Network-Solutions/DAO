<button type="button" class="close-button close-button--default modal__close-trigger rounded-full{if $extra_class} {$extra_class}{/if}"{if !$no_overlay} data-overlay="#modal"{/if} aria-label="{if $aria}{$aria}{else}{__("Close")}{/if}">
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" /></svg>
</button>
