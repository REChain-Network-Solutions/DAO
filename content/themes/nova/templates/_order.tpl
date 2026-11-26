<li class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
  <!-- order header -->
  <div class="flex flex-wrap items-center gap-x-4 gap-y-3 border-b border-base-300 px-5 py-4">
    <div class="flex min-w-0 grow items-center gap-3">
      <span class="inline-flex size-11 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-primary/10 text-primary" aria-hidden="true">
        <span class="icon-[tabler--receipt] size-5"></span>
      </span>
      <div class="min-w-0">
        <div class="flex flex-wrap items-center gap-2">
          <span class="text-sm font-semibold">{__("Order")} <span class="break-all font-mono">#{$order['order_hash']}</span></span>
          {if $order['status'] == "canceled"}
            <span class="badge badge-soft badge-error badge-sm gap-1.5 rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__($order['status'])|ucfirst}</span>
          {elseif $order['status'] == "delivered"}
            <span class="badge badge-soft badge-success badge-sm gap-1.5 rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__($order['status'])|ucfirst}</span>
          {else}
            <span class="badge badge-soft badge-info badge-sm gap-1.5 rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__($order['status'])|ucfirst}</span>
          {/if}
        </div>
        <div class="mt-0.5 text-xs text-base-content/60">{__("Order Placed")} · {$order['insert_time']}</div>
      </div>
    </div>
    {if !$for_admin}
      <div class="flex flex-wrap items-center gap-2">
        <!-- update order -->
        {if $order['status'] != "delivered" && $order['status'] != "canceled"}
          <button type="button" class="js_modal heroui button button--tertiary text-base-content button--sm rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="users/orders.php?do=edit&id={$order['order_id']}">
            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
            {__("Update")}
          </button>
        {/if}
        <!-- update order -->

        <!-- invoice -->
        <button type="button" class="heroui button button--tertiary [--button-bg:var(--success-soft)] [--button-bg-hover:var(--success-soft-hover)] [--button-bg-pressed:var(--success-soft-hover)] [--button-fg:var(--success-soft-foreground)] button--sm rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_shopping-download-invoice" data-id="{$order['order_id']}">
          <span class="icon-[tabler--file-download] size-4" aria-hidden="true"></span>
          {__("Invoice")}
        </button>
        <!-- invoice -->
      </div>
    {/if}
  </div>
  <!-- order header -->

  <div class="flex flex-col gap-6 p-6">
    <!-- progress -->
    {if $order['status'] == "canceled"}
      <div class="flex items-center gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-error/10 px-4 py-3 text-sm font-medium text-error" role="note">
        <span class="icon-[tabler--circle-x] size-5 shrink-0" aria-hidden="true"></span>
        {__("This order has been canceled")}
      </div>
    {else}
      {$_order_steps = ['placed' => 'icon-[tabler--receipt]', 'accepted' => 'icon-[tabler--circle-check]', 'packed' => 'icon-[tabler--package]', 'shipped' => 'icon-[tabler--truck-delivery]', 'delivered' => 'icon-[tabler--home-check]']}
      {$_order_step = 1}
      {$_order_index = 0}
      {foreach $_order_steps as $_order_status => $_order_icon}
        {$_order_index = $_order_index + 1}
        {if $_order_status == $order['status']}{$_order_step = $_order_index}{/if}
      {/foreach}
      <ol class="grid grid-cols-5 gap-1.5" aria-label='{__("Status")}'>
        {foreach $_order_steps as $_step => $_step_icon}
          <li class="flex min-w-0 flex-col gap-2" {if $_step_icon@iteration == $_order_step}aria-current="step"{/if}>
            <span class="h-1.5 w-full rounded-full {if $_step_icon@iteration <= $_order_step}bg-primary{else}bg-base-300{/if}" aria-hidden="true"></span>
            <span class="flex min-w-0 items-center gap-1.5 text-xs font-medium {if $_step_icon@iteration == $_order_step}text-primary{elseif $_step_icon@iteration < $_order_step}text-base-content{else}text-base-content/40{/if}">
              <span class="{$_step_icon} hidden size-4 shrink-0 sm:inline-block" aria-hidden="true"></span>
              <span class="truncate" title="{__($_step)|ucfirst}">{__($_step)|ucfirst}</span>
            </span>
          </li>
        {/foreach}
      </ol>
    {/if}
    <!-- progress -->

    {if $order['status'] == "shipped"}
      <div class="flex items-start gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-warning/15 px-4 py-3 text-sm text-base-content/80" role="note">
        <span class="icon-[tabler--truck-delivery] mt-0.5 size-5 shrink-0" aria-hidden="true"></span>
        <span>
          {__("This order has been shipped and will be marked as delivered automatically after")} <strong>{$order['automatic_delivery_days']}</strong> {__("days")} ({__("Max")} {$system['market_delivery_days']} {__("days")})
        </span>
      </div>
    {/if}

    <div class="grid gap-4 md:grid-cols-3">
      <!-- tracking details -->
      <section class="flex min-w-0 flex-col gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] border border-base-300 bg-base-100 p-5">
        {if $order['is_digital']}
        <div class="flex items-center gap-3">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-info/10 text-info" aria-hidden="true">
            <span class="icon-[tabler--download] size-5"></span>
          </span>
          <h3 class="font-semibold">{__("Download Details")}</h3>
        </div>
          <div class="mt-auto flex flex-col gap-3">
            <span class="text-sm text-base-content/60">{__("Download Link")}</span>
            {if $order['items'][0]['post']['product']['product_file_source']}
              <a class="heroui button button--tertiary [--button-bg:color-mix(in_oklab,var(--color-info)_10%,transparent)] [--button-bg-hover:color-mix(in_oklab,var(--color-info)_20%,transparent)] [--button-bg-pressed:color-mix(in_oklab,var(--color-info)_20%,transparent)] [--button-fg:var(--color-info)] w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_uploads']}/{$order['items'][0]['post']['product']['product_file_source']}" target="_blank"><span class="icon-[tabler--download] size-4" aria-hidden="true"></span>{__("Download")}</a>
            {else}
              <a class="heroui button button--tertiary [--button-bg:color-mix(in_oklab,var(--color-info)_10%,transparent)] [--button-bg-hover:color-mix(in_oklab,var(--color-info)_20%,transparent)] [--button-bg-pressed:color-mix(in_oklab,var(--color-info)_20%,transparent)] [--button-fg:var(--color-info)] w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$order['items'][0]['post']['product']['product_download_url']}" target="_blank"><span class="icon-[tabler--download] size-4" aria-hidden="true"></span>{__("Download")}</a>
            {/if}
          </div>
        {else}
        <div class="flex items-center gap-3">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-info/10 text-info" aria-hidden="true">
            <span class="icon-[tabler--map-route] size-5"></span>
          </span>
          <h3 class="font-semibold">{__("Tracking Details")}</h3>
        </div>
          <dl class="flex flex-col gap-3 text-sm">
            <div class="flex flex-col gap-0.5">
              <dt class="text-xs text-base-content/50">{__("Tracking Number")}</dt>
              <dd class="break-all font-semibold">{if $order['tracking_number']}{$order['tracking_number']}{else}<span class="font-normal text-base-content/40">{__("N/A")}</span>{/if}</dd>
            </div>
            <div class="flex flex-col gap-0.5">
              <dt class="text-xs text-base-content/50">{__("Tracking Link")}</dt>
              <dd class="break-all font-medium">{if $order['tracking_link']}<a class="text-primary hover:underline" href="{$order['tracking_link']}" target="_blank">{$order['tracking_link']}</a>{else}<span class="text-base-content/40">{__("N/A")}</span>{/if}</dd>
            </div>
          </dl>
        {/if}
      </section>
      <!-- tracking details -->

      <!-- shipping address -->
      <section class="flex min-w-0 flex-col gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] border border-base-300 bg-base-100 p-5">
        <div class="flex items-center gap-3">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-primary/10 text-primary" aria-hidden="true">
            <span class="icon-[tabler--map-pin] size-5"></span>
          </span>
          <h3 class="font-semibold">{__("Shipping Addresses")}</h3>
        </div>
        <address class="flex flex-col gap-1 text-sm not-italic text-base-content/70 [overflow-wrap:anywhere]">
          <strong class="text-base-content">{$order['buyer_fullname']}</strong>
          <span>{$order['address_details']}</span>
          <span>{$order['address_city']}, {$order['address_country']} {$order['address_zip_code']}</span>
          <span class="mt-1 inline-flex items-center gap-1.5" dir="ltr"><span class="icon-[tabler--phone] size-4 shrink-0 text-base-content/40" aria-hidden="true"></span>{$order['address_phone']}</span>
        </address>
      </section>
      <!-- shipping address -->

      <!-- payments -->
      <section class="flex min-w-0 flex-col gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] border border-base-300 bg-base-100 p-5">
        <div class="flex items-center gap-3">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-success/10 text-success" aria-hidden="true">
            <span class="icon-[tabler--wallet] size-5"></span>
          </span>
          <h3 class="font-semibold">{__("Payment")}</h3>
        </div>
        {if $sales}
          <div class="flex flex-col gap-2.5 text-sm">
            <div class="flex items-center justify-between gap-3">
              <span class="text-base-content/60">{__("Subtotal")}</span>
              <span class="font-medium tabular-nums">{print_money($order['sub_total'])}</span>
            </div>
            {if $order['total_commission'] > 0}
              <div class="flex items-center justify-between gap-3">
                <span class="text-base-content/60">{__("Commission")}</span>
                <span class="font-medium text-error tabular-nums">- {print_money($order['total_commission'])}</span>
              </div>
            {/if}
          </div>
        {/if}
        <div class="mt-auto flex items-end justify-between gap-3 border-t border-dashed border-base-content/15 pt-4">
          <span class="text-sm font-semibold">{__("Total")}</span>
          <strong class="text-2xl font-bold tracking-tight text-success tabular-nums">{if $sales}{print_money($order['final_price'])}{else}{print_money($order['sub_total'])}{/if}</strong>
        </div>
      </section>
      <!-- payments -->
    </div>

    <!-- items -->
    <section class="flex flex-col gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] border border-base-300 bg-base-100 p-5">
        <div class="flex items-center gap-3">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-accent/10 text-accent" aria-hidden="true">
            <span class="icon-[tabler--package] size-5"></span>
          </span>
          <h3 class="grow font-semibold">{__("Items")}</h3>
          <span class="badge badge-soft rounded-full">{$order['items']|count}</span>
        </div>
      <ul class="flex flex-col gap-3">
        {foreach $order['items'] as $order_item}
          <li class="flex items-center gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-base-200/60 p-3">
            <a class="shrink-0" href="{$system['system_url']}/posts/{$order_item['post']['post_id']}">
              {if $order_item['post']['photos_num'] > 0}
                <img class="size-16 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl object-cover" src="{$system['system_uploads']}/{$order_item['post']['photos'][0]['source']}" alt="" loading="lazy">
              {else}
                <img class="size-16 rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl object-cover" src="{$system['system_url']}/content/themes/{$system['theme']}/images/blank/blank_product.png" alt="" loading="lazy">
              {/if}
            </a>
            <div class="min-w-0 grow">
              <a class="block truncate font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/posts/{$order_item['post']['post_id']}" title="{$order_item['post']['product']['name']}">{$order_item['post']['product']['name']}</a>
              <div class="mt-1.5 flex flex-wrap items-center gap-2 text-xs text-base-content/60">
                {if $order_item['post']['product']['status'] == "new"}
                  <span class="badge badge-soft badge-info badge-sm rounded-full">{__("New")}</span>
                {else}
                  <span class="badge badge-soft badge-sm rounded-full">{__("Used")}</span>
                {/if}
                <span class="badge badge-soft badge-sm rounded-full">{__("Qty:")} {$order_item['quantity']}</span>
              </div>
            </div>
            <strong class="shrink-0 text-base tabular-nums">
              {if $order_item['post']['product']['price'] > 0}{$order_item['post']['product']['price_formatted']}{else}{__("Free")}{/if}
            </strong>
          </li>
        {/foreach}
      </ul>
    </section>
    <!-- items -->
  </div>
</li>
