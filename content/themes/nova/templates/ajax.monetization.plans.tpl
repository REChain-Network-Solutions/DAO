{include file='__modal_header.tpl' _icon="icon-[tabler--coin]" _title=__("Monetization Plans")}
<div class="modal__body flex flex-col gap-4">
  <div class="grid gap-3 sm:grid-cols-2">
    {foreach $monetization_plans as $plan}
      <article class="flex min-w-0 flex-col gap-3 rounded-box border border-base-300 bg-base-100 p-4">
        <div class="min-w-0">
          <h3 class="m-0 truncate text-sm font-semibold text-base-content" title="{$plan['title']}">{__($plan['title'])}</h3>
          <p class="m-0 mt-1 text-sm text-base-content/60">
            {if $plan['discounted_price']}<span class="font-semibold text-base-content">{print_money($plan['discounted_price'])}</span> <span class="line-through">{print_money($plan['price'])}</span>{else}<span class="font-semibold text-base-content">{print_money($plan['price'])}</span>{/if} / {if $plan['period_num'] != '1'}{$plan['period_num']}{/if} {__($plan['period']|ucfirst)}
          </p>
        </div>
        {if {$plan['custom_description']}}
          <p class="m-0 text-sm leading-relaxed text-base-content/60">{$plan['custom_description']}</p>
        {/if}
        <div class="mt-auto border-t border-base-300 pt-3">
          {if $plan['price'] == 0}
            <button type="button" class="button button--tertiary text-base-content button--full-width js_sneak-peak rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-id="{$plan['plan_id']}">
              <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
              {__("Sneak Peak")}
            </button>
          {else}
            {if $plan['discounted_price']}
              <button type="button" class="button button--primary button--full-width js_modal" data-url="#payment" data-options='{ "handle": "subscribe", "subscribe": "true", "id": {$plan['plan_id']}, "price": {$plan['discounted_price']}, "vat": "{get_payment_vat_value($plan['discounted_price'])}", "fees": "{get_payment_fees_value($plan['discounted_price'])}", "total": "{get_payment_total_value($plan['discounted_price'])}", "total_printed": "{get_payment_total_value($plan['discounted_price'], true)}" }'>
                <span class="icon-[tabler--credit-card] size-4" aria-hidden="true"></span>
                {__("Subscribe")}
              </button>
            {else}
              <button type="button" class="button button--primary button--full-width js_modal" data-url="#payment" data-options='{ "handle": "subscribe", "subscribe": "true", "id": {$plan['plan_id']}, "price": {$plan['price']}, "vat": "{get_payment_vat_value($plan['price'])}", "fees": "{get_payment_fees_value($plan['price'])}", "total": "{get_payment_total_value($plan['price'])}", "total_printed": "{get_payment_total_value($plan['price'], true)}" }'>
                <span class="icon-[tabler--credit-card] size-4" aria-hidden="true"></span>
                {__("Subscribe")}
              </button>
            {/if}
          {/if}
        </div>
      </article>
    {/foreach}
  </div>
</div>
