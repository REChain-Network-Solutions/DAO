<div class="grid gap-3 {if $_small}grid-cols-[repeat(auto-fill,minmax(min(100%,13rem),1fr))]{else}sm:grid-cols-2{/if}">
  {foreach $addresses as $address}
    <div class="flex min-w-0 flex-col justify-between gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-base-200/60 p-4">
      <div class="flex min-w-0 flex-col gap-3">
        <div class="flex min-w-0 items-center gap-3">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-primary/10 text-primary" aria-hidden="true">
            <span class="icon-[tabler--map-pin] size-5"></span>
          </span>
          <div class="min-w-0 truncate font-semibold" title="{$address['address_title']}">{$address['address_title']}</div>
        </div>
        <ul class="flex flex-col gap-1.5 text-sm text-base-content/70 [overflow-wrap:anywhere]">
          <li class="flex items-start gap-2">
            <span class="icon-[tabler--home] mt-0.5 size-4 shrink-0 text-base-content/40" aria-hidden="true"></span>
            <span class="min-w-0">{$address['address_details']}</span>
          </li>
          <li class="flex items-start gap-2">
            <span class="icon-[tabler--building-community] mt-0.5 size-4 shrink-0 text-base-content/40" aria-hidden="true"></span>
            <span class="min-w-0">{$address['address_city']}, {$address['address_country']} {$address['address_zip_code']}</span>
          </li>
          {if $address['address_phone']}
            <li class="flex items-start gap-2">
              <span class="icon-[tabler--phone] mt-0.5 size-4 shrink-0 text-base-content/40" aria-hidden="true"></span>
              <span class="min-w-0" dir="ltr">{$address['address_phone']}</span>
            </li>
          {/if}
        </ul>
      </div>
      <div class="flex items-center gap-2">
        <button type="button" class="js_modal heroui button button--tertiary text-base-content button--sm grow rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="users/addresses.php?do=edit&id={$address['address_id']}">
          <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
          {__("Edit")}
        </button>
        <button type="button" class="heroui button button--danger-soft button--sm button--icon-only size-7.5 rounded-field corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_address-deleter" data-id="{$address['address_id']}" aria-label='{__("Delete")}' title='{__("Delete")}'>
          <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
        </button>
      </div>
    </div>
  {/foreach}
  <button type="button" class="js_modal flex {if $_small}min-h-32{else}min-h-40{/if} cursor-pointer flex-col items-center justify-center gap-2 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] border-2 border-dashed border-base-300 p-4 text-primary transition-colors hover:border-primary/40 hover:bg-primary/5" data-url="users/addresses.php?do=add">
    <span class="inline-flex size-10 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-primary/10" aria-hidden="true">
      <span class="icon-[tabler--plus] size-5"></span>
    </span>
    <span class="text-sm font-semibold">{__("Add New Address")}</span>
  </button>
</div>
