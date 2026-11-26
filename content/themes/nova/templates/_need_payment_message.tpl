<!-- need payment message -->
{if $discounted_price}{$_pay_price = $discounted_price}{else}{$_pay_price = $price}{/if}
<div class="chat-paid-message relative isolate w-64 max-w-full overflow-hidden rounded-2xl {if !$paid_image}border border-primary/15 bg-primary/[0.04]{/if}">
  {if $paid_image}
    <img class="absolute inset-0 -z-10 size-full object-cover" src="{$system['system_uploads']}/{$paid_image}" alt="" loading="lazy">
    <div class="absolute inset-0 -z-10 bg-linear-to-t from-black/85 via-black/50 to-black/20" aria-hidden="true"></div>
  {/if}
  <div class="flex flex-col items-center gap-2 px-4 py-5 text-center {if $paid_image}text-white{/if}">
    <span class="flex size-10 items-center justify-center rounded-full {if $paid_image}bg-white/15 ring-1 ring-white/25 backdrop-blur-md{else}bg-primary/10 text-primary{/if}" aria-hidden="true">
      <span class="icon-[tabler--lock] size-5"></span>
    </span>
    <p class="text-sm font-semibold">{__("Paid message")}</p>
    {if $paid_text}
      <p class="line-clamp-2 text-xs leading-relaxed {if $paid_image}text-white/80{else}text-base-content/60{/if}" dir="auto" title="{$paid_text|strip_tags}">{$paid_text}</p>
    {/if}
    <button type="button" class="js_modal heroui button button--primary button--sm mt-1 h-auto min-h-9 max-w-full gap-1.5 rounded-full px-4 py-1.5 leading-snug whitespace-normal text-balance {if !$user->_logged_in}js_login{/if}" {if $user->_logged_in} data-url="#payment" data-options='{ "handle": "paid_message", "paid_message": "true", "id": {$message_id}, "price": {$_pay_price}, "vat": "{get_payment_vat_value($_pay_price)}", "fees": "{get_payment_fees_value($_pay_price)}", "total": "{get_payment_total_value($_pay_price)}", "total_printed": "{get_payment_total_value($_pay_price, true)}" }' {/if}>
      <span class="icon-[tabler--lock-open] size-4 shrink-0" aria-hidden="true"></span>
      <span>{__("Unlock for")} <span class="font-semibold">{print_money($_pay_price)}</span>{if $discounted_price} <span class="ms-1 font-normal line-through opacity-70">{print_money($price)}</span>{/if}</span>
    </button>
  </div>
</div>
<!-- need payment message -->
