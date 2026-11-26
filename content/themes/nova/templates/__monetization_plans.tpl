<div class="flex flex-col gap-3">
  {foreach $monetization_plans as $plan}
    <article class="grid grid-cols-[auto_minmax(0,1fr)_auto] items-center gap-x-4 gap-y-3 sm:flex sm:flex-wrap rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl border border-base-300 bg-base-100 p-4">
      <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-primary/10 text-primary" aria-hidden="true">
        <span class="icon-[tabler--crown] size-5"></span>
      </span>
      <div class="min-w-0 grow sm:basis-40">
        <h3 class="truncate text-sm font-semibold" title="{__($plan['title'])}">{__($plan['title'])}</h3>
        {if $plan['custom_description']}
          <p class="mt-0.5 truncate text-sm text-base-content/60" title="{$plan['custom_description']}">{$plan['custom_description']}</p>
        {/if}
      </div>
      <div class="shrink-0 text-end max-sm:order-last max-sm:col-span-3 max-sm:flex max-sm:items-baseline max-sm:gap-1.5 max-sm:border-t max-sm:border-base-300 max-sm:pt-3 max-sm:text-start">
        <div class="text-base font-semibold">{print_money($plan['price'])}</div>
        <div class="text-xs text-base-content/60">{__("per")} {if $plan['period_num'] != '1'}{$plan['period_num']}{/if} {__($plan['period']|ucfirst)}</div>
      </div>
      <div class="flex shrink-0 items-center gap-1">
        <button type="button" data-url="monetization/controller.php?do=edit_plan&amp;id={$plan['plan_id']}" class="js_modal heroui button button--ghost button--sm button--icon-only rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" title='{__("Edit")}' aria-label='{__("Edit")}'>
          <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
        </button>
        <button type="button" class="heroui button button--ghost button--sm button--icon-only rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] text-error js_monetization-deleter" data-id="{$plan['plan_id']}" title='{__("Delete")}' aria-label='{__("Delete")}'>
          <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
        </button>
      </div>
    </article>
  {/foreach}
  <button type="button" data-url="monetization/controller.php?do=add_plan&amp;node_id={$_node_id}&amp;node_type={$_node_type}" class="js_modal flex cursor-pointer items-center justify-center gap-2 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl border border-dashed border-base-300 p-4 text-sm font-medium text-base-content/70 transition-colors hover:border-primary/40 hover:bg-primary/5 hover:text-primary focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary/50">
    <span class="icon-[tabler--plus] size-5" aria-hidden="true"></span>
    {__("Add new plan")}
  </button>
</div>
