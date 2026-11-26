<div class="card border border-base-300 bg-base-100 shadow-none">
  <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
      <span class="icon-[tabler--map-pin] size-5"></span>
    </span>
    <div class="min-w-0 grow">
      <h2 class="card-title text-lg">{__("Your Addresses")}</h2>
      <p class="text-sm text-base-content/60">{__("Shipping and billing addresses")}</p>
    </div>
    {if $addresses}
      <span class="badge badge-soft rounded-full ms-auto shrink-0">{count($addresses)}</span>
    {/if}
  </div>
  <div class="card-body gap-6 pt-6">
    {include file='_addresses.tpl'}
  </div>
</div>
