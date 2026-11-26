<div class="input w-full items-center gap-2 pe-1.5 [--border:1px]">
  <span class="{if $_icon}{$_icon}{else}icon-[tabler--link]{/if} size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
  <input type="text" readonly class="min-w-0 grow {$_class}" id="{$_id}" dir="ltr" value="{$_value|escape:'html'}" title="{$_value|escape:'html'}">
  <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-field shrink-0 js_clipboard" data-clipboard-target="#{$_id}" title='{__("Copy")}' aria-label='{__("Copy")}'>
    <span class="js-clipboard-default icon-[tabler--copy] size-4.5" aria-hidden="true"></span>
    <span class="js-clipboard-success icon-[tabler--check] hidden size-4.5 text-success" aria-hidden="true"></span>
  </button>
</div>
