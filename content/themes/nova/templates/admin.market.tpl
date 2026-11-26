{* PAYMENTS & MONETIZATION MODULE *}

{if $sub_view == ""}
  <section class="admin-settings-page" aria-labelledby="admin-market-title">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-market-title" class="text-2xl font-semibold">{__("Marketplace Settings")}</h1>
      <p class="text-base-content/60 text-sm">{__("Cart, payouts, and marketplace commissions.")}</p>
    </div>

    <div class="admin-settings-panel js_admin-settings-panel" role="tabpanel" tabindex="0">
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=market">
        <div class="admin-settings-layout block">
          <div class="admin-settings-form flex min-w-0 flex-col gap-4">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6">
                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="market" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="market_enabled">{__("Marketplace")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="market_enabled-help">{__("Turn the marketplace On and Off")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="market_enabled" id="market_enabled" {if $system['market_enabled']}checked{/if} aria-describedby="market_enabled-help">
                  </div>
                </div>

                {if $licence_monetization && $licence_module_installed}
                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon">
                      {include file='__svg_icons.tpl' icon="products" class="admin-setting-glyph" width="32px" height="32px"}
                    </div>
                    <div>
                      <label class="admin-setting-label block text-sm font-medium leading-normal" for="market_shopping_cart_enabled">{__("Shopping Cart")}</label>
                      <div class="admin-setting-help text-sm leading-relaxed" id="market_shopping_cart_enabled-help">
                        {__("Turn the shopping cart On and Off")}<br>
                        {__("Note: If disabled buyers can only contact sellers to buy products")}
                      </div>
                    </div>
                    <div class="text-end">
                      <input type="checkbox" class="switch switch-primary" name="market_shopping_cart_enabled" id="market_shopping_cart_enabled" {if $system['market_shopping_cart_enabled']}checked{/if} aria-describedby="market_shopping_cart_enabled-help">
                    </div>
                  </div>

                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon">
                      {include file='__svg_icons.tpl' icon="download" class="admin-setting-glyph" width="32px" height="32px"}
                    </div>
                    <div>
                      <label class="admin-setting-label block text-sm font-medium leading-normal" for="market_digital_products_enabled">{__("Digital Products")}</label>
                      <div class="admin-setting-help text-sm leading-relaxed" id="market_digital_products_enabled-help">{__("Turn the digital products sales On and Off")}</div>
                    </div>
                    <div class="text-end">
                      <input type="checkbox" class="switch switch-primary" name="market_digital_products_enabled" id="market_digital_products_enabled" {if $system['market_digital_products_enabled']}checked{/if} aria-describedby="market_digital_products_enabled-help">
                    </div>
                  </div>

                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon">
                      {include file='__svg_icons.tpl' icon="wallet" class="admin-setting-glyph" width="32px" height="32px"}
                    </div>
                    <div>
                      <label class="admin-setting-label block text-sm font-medium leading-normal" for="market_wallet_payment_enabled">{__("Users Can Buy From Wallet Balance")}</label>
                      <div class="admin-setting-help text-sm leading-relaxed" id="market_wallet_payment_enabled-help">
                        {__("Enable users to buy from their wallet balance")}<br>
                        {__("Make sure you have enabled")} <a href="{$system['system_url']}/{$control_panel['url']}/wallet">{__("Wallet System")}</a>
                      </div>
                    </div>
                    <div class="text-end">
                      <input type="checkbox" class="switch switch-primary" name="market_wallet_payment_enabled" id="market_wallet_payment_enabled" {if $system['market_wallet_payment_enabled']}checked{/if} aria-describedby="market_wallet_payment_enabled-help">
                    </div>
                  </div>

                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon">
                      {include file='__svg_icons.tpl' icon="money-bag" class="admin-setting-glyph" width="32px" height="32px"}
                    </div>
                    <div>
                      <label class="admin-setting-label block text-sm font-medium leading-normal" for="market_cod_payment_enabled">{__("Users Select Cash On Delivery")}</label>
                      <div class="admin-setting-help text-sm leading-relaxed" id="market_cod_payment_enabled-help">
                        {__("Enable users to pay with cash on delivery")}<br>
                        {__("Note: If enabled commission will not be taken")}
                      </div>
                    </div>
                    <div class="text-end">
                      <input type="checkbox" class="switch switch-primary" name="market_cod_payment_enabled" id="market_cod_payment_enabled" {if $system['market_cod_payment_enabled']}checked{/if} aria-describedby="market_cod_payment_enabled-help">
                    </div>
                  </div>

                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                    <label class="label-text" for="market_delivery_days">{__("Days To Automatic Delivery")}</label>
                    <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                      <input type="text" class="input w-full" name="market_delivery_days" id="market_delivery_days" value="{$system['market_delivery_days']}" inputmode="numeric" aria-describedby="market_delivery_days-help">
                      <div id="market_delivery_days-help" class="admin-setting-help text-sm leading-relaxed">
                        {__("After how many days the order will be marked as delivered automatically")}<br>
                        {__("Note: This will only work if the order status is not changed manually after shipped")}
                      </div>
                    </div>
                  </div>

                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon">
                      {include file='__svg_icons.tpl' icon="withdrawal" class="admin-setting-glyph" width="32px" height="32px"}
                    </div>
                    <div>
                      <label class="admin-setting-label block text-sm font-medium leading-normal" for="market_money_withdraw_enabled">{__("Users Can Withdraw Earned Money")}</label>
                      <div class="admin-setting-help text-sm leading-relaxed" id="market_money_withdraw_enabled-help">{__("If enabled users will be able to withdraw earned money")}</div>
                    </div>
                    <div class="text-end">
                      <input type="checkbox" class="switch switch-primary" name="market_money_withdraw_enabled" id="market_money_withdraw_enabled" {if $system['market_money_withdraw_enabled']}checked{/if} aria-describedby="market_money_withdraw_enabled-help">
                    </div>
                  </div>

                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="market-payment-method-label">
                    <div class="label-text" id="market-payment-method-label">{__("Payment Method")}</div>
                    <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                      <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                        <input type="checkbox" class="checkbox checkbox-primary" name="method_paypal" id="method_paypal" {if in_array("paypal", $system['market_payment_method_array'])}checked{/if}>
                        <label class="label-text" for="method_paypal">{__("PayPal")}</label>
                      </div>
                      <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                        <input type="checkbox" class="checkbox checkbox-primary" name="method_skrill" id="method_skrill" {if in_array("skrill", $system['market_payment_method_array'])}checked{/if}>
                        <label class="label-text" for="method_skrill">{__("Skrill")}</label>
                      </div>
                      <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                        <input type="checkbox" class="checkbox checkbox-primary" name="method_bank" id="method_bank" {if in_array("bank", $system['market_payment_method_array'])}checked{/if}>
                        <label class="label-text" for="method_bank">{__("Bank Transfer")}</label>
                      </div>
                      <div class="admin-settings-choice my-1 flex items-start gap-2.5" id="js_custome-withdrawal">
                        <input type="checkbox" class="checkbox checkbox-primary" name="method_custom" id="method_custom" {if in_array("custom", $system['market_payment_method_array'])}checked{/if}>
                        <label class="label-text" for="method_custom">{__("Custom Method")}</label>
                      </div>
                      <div class="admin-setting-help text-sm leading-relaxed">{__("Users can send withdrawal requests via any of these methods")}</div>
                    </div>
                  </div>

                  <div id="js_custome-withdrawal-name" {if !in_array("custom", $system['market_payment_method_array'])}class="hidden"{/if}>
                    <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                      <label class="label-text" for="market_payment_method_custom">{__("Custom Method Name")}</label>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <input type="text" class="input w-full" name="market_payment_method_custom" id="market_payment_method_custom" value="{$system['market_payment_method_custom']}" aria-describedby="market_payment_method_custom-help">
                        <div id="market_payment_method_custom-help" class="admin-setting-help text-sm leading-relaxed">{__("Set the name of your custom withdrawal payment method")}</div>
                      </div>
                    </div>
                  </div>

                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                    <label class="label-text" for="market_min_withdrawal">{__("Minimum Withdrawal Request")} ({$system['system_currency']})</label>
                    <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                      <input type="text" class="input w-full" name="market_min_withdrawal" id="market_min_withdrawal" value="{$system['market_min_withdrawal']}" inputmode="decimal" aria-describedby="market_min_withdrawal-help">
                      <div id="market_min_withdrawal-help" class="admin-setting-help text-sm leading-relaxed">{__("The minimum amount of money so user can send a withdrawal request")}</div>
                    </div>
                  </div>

                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon">
                      {include file='__svg_icons.tpl' icon="wallet" class="admin-setting-glyph" width="32px" height="32px"}
                    </div>
                    <div>
                      <label class="admin-setting-label block text-sm font-medium leading-normal" for="market_money_transfer_enabled">{__("Users Can Transfer Earned Money To Wallet")}</label>
                      <div class="admin-setting-help text-sm leading-relaxed" id="market_money_transfer_enabled-help">
                        {__("If wallet enabled users will be able to transfer earned money to their wallet")}<br>
                        {__("Make sure you have enabled")} <a href="{$system['system_url']}/{$control_panel['url']}/wallet">{__("Wallet System")}</a>
                      </div>
                    </div>
                    <div class="text-end">
                      <input type="checkbox" class="switch switch-primary" name="market_money_transfer_enabled" id="market_money_transfer_enabled" {if $system['market_money_transfer_enabled']}checked{/if} aria-describedby="market_money_transfer_enabled-help">
                    </div>
                  </div>

                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                    <label class="label-text" for="market_commission">{__("Commission")} (%)</label>
                    <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                      <input type="text" class="input w-full" name="market_commission" id="market_commission" value="{$system['market_commission']}" inputmode="decimal" aria-describedby="market_commission-help">
                      <div id="market_commission-help" class="admin-setting-help text-sm leading-relaxed">{__("Leave it 0 if you don't want to get any commissions")}</div>
                    </div>
                  </div>
                {else}
                  {include file='__licence_lock.tpl' _mini=true _title={__("Shopping Cart")}}
                {/if}
              </div>

              <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
                <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                  <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                  <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
                </div>
                <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                  <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                </div>
              </div>
            </section>
          </div>
        </div>
      </form>
    </div>
  </section>

{elseif $sub_view == "products" || $sub_view == "find"}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-market-products-title">
    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-market-products-title" class="text-2xl font-semibold">{if $sub_view == "find"}{__("Find")}{else}{__("Products")}{/if}</h1>
        <p class="text-base-content/60 text-sm">{if $sub_view == "find"}{__("Search results for product names, descriptions, and locations.")}{else}{__("Review marketplace products.")}{/if}</p>
      </div>
      {if $sub_view == "find"}
        <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
          <a href="{$system['system_url']}/{$control_panel['url']}/market/products" class="btn btn-outline">
            <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
            {__("Go Back")}
          </a>
        </div>
      {/if}
    </header>

    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Products")}">
      <div class="js-flyonui-datatable-toolbar flex items-center justify-between gap-3 border-b border-base-300 px-5 py-3 max-md:flex-wrap">
        <form class="input max-w-72" action="{$system['system_url']}/{$control_panel['url']}/market/find" method="get" role="search">
          <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
          <input type="search" class="grow" name="query" id="admin-market-products-query" value="{if $query}{$query}{/if}" placeholder="{__("Search")}" title="{__("Search by Product Name, Description or Location")}" aria-label="{__("Search by Product Name, Description or Location")}" autocomplete="off">
        </form>
      </div>

      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("ID")}</th>
                <th>{__("Author")}</th>
                <th>{__("Title")}</th>
                <th>{__("Time")}</th>
                <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td><span class="admin-list-name text-sm font-semibold">#{$row['post_id']}</span></td>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$row['post_author_url']}">
                      <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['post_author_picture']}" alt="" width="30" height="30" loading="lazy">
                      <span class="admin-list-name max-w-48 truncate text-sm" title="{$row['post_author_name']}">{$row['post_author_name']}</span>
                    </a>
                  </td>
                  <td>
                    <span class="admin-list-name max-w-md truncate text-sm" title="{$row['name']}">{$row['name']|truncate:30}</span>
                  </td>
                  <td><span class="js_moment" data-time="{$row['time']}">{$row['time']}</span></td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="market-product-actions-{$row['post_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['name']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="market-product-actions-{$row['post_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/posts/{$row['post_id']}" target="_blank">
                            <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
                            {__("View")}
                          </a>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="post" data-id="{$row['post_id']}">
                            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                            {__("Delete")}
                          </button>
                        </li>
                      </ul>
                    </div>
                  </td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
        {if $pager}<div class="admin-list-pager">{$pager}</div>{/if}
      {else}
        <section class="admin-list-empty flex min-h-[240px] flex-col items-center justify-center px-6 py-10 text-center" aria-labelledby="admin-market-products-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--tag] size-6" aria-hidden="true"></span>
          </div>
          <h2 id="admin-market-products-empty-title">{__("No products")}</h2>
          <p>{__("Marketplace products will appear here.")}</p>
        </section>
      {/if}
    </section>
  </section>

{elseif $sub_view == "orders" || $sub_view == "find_orders"}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-market-orders-title">
    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-market-orders-title" class="text-2xl font-semibold">{if $sub_view == "find_orders"}{__("Find Orders")}{else}{__("Orders")}{/if}</h1>
        <p class="text-base-content/60 text-sm">{if $sub_view == "find_orders"}{__("Search results for order IDs.")}{else}{__("Review marketplace orders.")}{/if}</p>
      </div>
      {if $sub_view == "find_orders"}
        <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
          <a href="{$system['system_url']}/{$control_panel['url']}/market/orders" class="btn btn-outline">
            <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
            {__("Go Back")}
          </a>
        </div>
      {/if}
    </header>

    {if $licence_monetization && $licence_module_installed}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Orders")}">
        <div class="js-flyonui-datatable-toolbar flex items-center justify-between gap-3 border-b border-base-300 px-5 py-3 max-md:flex-wrap">
          <form class="input max-w-72" action="{$system['system_url']}/{$control_panel['url']}/market/find_orders" method="get" role="search">
            <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
            <input type="search" class="grow" name="query" id="admin-market-orders-query" value="{if $query}{$query}{/if}" placeholder="{__("Search")}" title="{__("Search by Order ID")}" aria-label="{__("Search by Order ID")}" autocomplete="off">
          </form>
        </div>

        {if $rows}
          <div class="admin-list-table-wrap w-full overflow-x-auto">
            <table class="table admin-list-table">
              <thead>
                <tr>
                  <th>{__("Order ID")}</th>
                  <th>{__("Seller")}</th>
                  <th>{__("Buyer")}</th>
                  <th>{__("Status")}</th>
                  <th>{__("Subtotal")}</th>
                  <th>{__("Time")}</th>
                  <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
                </tr>
              </thead>
              <tbody>
                {foreach $rows as $row}
                  <tr>
                    <td><span class="admin-list-name max-w-48 truncate text-sm font-semibold" title="{$row['order_hash']}">{$row['order_hash']}</span></td>
                    <td>
                      <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/{$row['seller_username']}">
                        <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['seller_picture']}" alt="" width="30" height="30" loading="lazy">
                        <span class="admin-list-name max-w-48 truncate text-sm" title="{$row['seller_fullname']}">{$row['seller_fullname']}</span>
                      </a>
                    </td>
                    <td>
                      <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/{$row['buyer_username']}">
                        <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['buyer_picture']}" alt="" width="30" height="30" loading="lazy">
                        <span class="admin-list-name max-w-48 truncate text-sm" title="{$row['buyer_fullname']}">{$row['buyer_fullname']}</span>
                      </a>
                    </td>
                    <td>
                      {if $row['status'] == "canceled"}
                        <span class="badge badge-soft badge-error badge-sm rounded-full">{__($row['status'])|ucfirst}</span>
                      {elseif $row['status'] == "delivered"}
                        <span class="badge badge-soft badge-success badge-sm rounded-full">{__($row['status'])|ucfirst}</span>
                      {else}
                        <span class="badge badge-soft badge-info badge-sm rounded-full">{__($row['status'])|ucfirst}</span>
                      {/if}
                    </td>
                    <td>{print_money($row['sub_total'])}</td>
                    <td><span class="js_moment" data-time="{$row['insert_time']}">{$row['insert_time']}</span></td>
                    <td class="admin-list-actions-column w-14 text-end">
                      <div class="dropdown relative inline-flex [--placement:bottom-end]">
                        <button id="market-order-actions-{$row['order_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['order_hash']}">
                          <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                        </button>
                        <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="market-order-actions-{$row['order_id']}">
                          <li>
                            <button type="button" class="dropdown-item px-2 js_modal" role="menuitem" data-url="users/orders.php?do=view&id={$row['order_id']}" data-size="extra-large">
                              <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
                              {__("View")}
                            </button>
                          </li>
                          {if $row['status'] != "delivered" && $row['status'] != "canceled"}
                            <li>
                              <button type="button" class="dropdown-item px-2 js_modal" role="menuitem" data-url="users/orders.php?do=edit&id={$row['order_id']}">
                                <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                                {__("Edit")}
                              </button>
                            </li>
                          {/if}
                          <li>
                            <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="order" data-id="{$row['order_id']}">
                              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                              {__("Delete")}
                            </button>
                          </li>
                        </ul>
                      </div>
                    </td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
          {if $pager}<div class="admin-list-pager">{$pager}</div>{/if}
        {else}
          <section class="admin-list-empty flex min-h-[240px] flex-col items-center justify-center px-6 py-10 text-center" aria-labelledby="admin-market-orders-empty-title">
            <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
              <span class="icon-[tabler--inbox] size-6" aria-hidden="true"></span>
            </div>
            <h2 id="admin-market-orders-empty-title">{__("No orders")}</h2>
            <p>{__("Marketplace orders will appear here.")}</p>
          </section>
        {/if}
      </section>
    {else}
      {include file='__licence_lock.tpl'}
    {/if}
  </section>

{elseif $sub_view == "categories"}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-market-categories-title">
    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-market-categories-title" class="text-2xl font-semibold">{__("Categories")}</h1>
        <p class="text-base-content/60 text-sm">{__("Organize marketplace products into categories.")}</p>
      </div>
      <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
        <a href="{$system['system_url']}/{$control_panel['url']}/market/add_category" class="btn btn-primary">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Category")}
        </a>
      </div>
    </header>

    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Categories")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("Title")}</th>
                <th>{__("Description")}</th>
                <th>{__("Order")}</th>
                <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                {include file='__categories.recursive_rows.tpl' _url="market" _handle="market_category" _style="admin-list"}
              {/foreach}
            </tbody>
          </table>
        </div>
      </section>
    {else}
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-market-categories-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--category] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-market-categories-empty-title">{__("No categories yet")}</h2>
        <p>{__("Add a category to organize products.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/market/add_category" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Category")}
        </a>
      </section>
    {/if}
  </section>

{elseif $sub_view == "add_category" || $sub_view == "edit_category"}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-market-category-title">
    <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
      <header class="admin-list-heading flex items-start justify-between gap-4">
        <div class="admin-settings-heading grid gap-1.5">
          <h1 id="admin-market-category-title" class="text-2xl font-semibold">{if $sub_view == "edit_category"}{__("Edit Category")}{else}{__("Add New Category")}{/if}</h1>
          <p class="text-base-content/60 text-sm">{if $sub_view == "edit_category"}{__("Update this category and its position.")}{else}{__("Create a category for marketplace products.")}{/if}</p>
        </div>
        <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
          <a href="{$system['system_url']}/{$control_panel['url']}/market/categories" class="btn btn-outline">
            <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
            {__("Go Back")}
          </a>
        </div>
      </header>

      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/market.php?do={if $sub_view == "edit_category"}edit_category&amp;id={$data['category_id']}{else}add_category{/if}">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="admin-market-category-details-title">
            <h2 id="admin-market-category-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              <span class="icon-[tabler--category] size-5" aria-hidden="true"></span>
              {__("Category Details")}
            </h2>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="market-category-name">{__("Name")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input class="input w-full" name="category_name" id="market-category-name" value="{if $sub_view == "edit_category"}{$data['category_name']}{/if}" autocomplete="off">
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="market-category-description">{__("Description")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea class="textarea w-full" name="category_description" id="market-category-description" rows="3">{if $sub_view == "edit_category"}{$data['category_description']}{/if}</textarea>
              </div>
            </div>

            <div class="grid min-w-0 gap-5 md:grid-cols-2">
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="market-category-parent">{__("Parent Category")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="category_parent_id" id="market-category-parent">
                    <option value="0">{__("Set as a Parent Category")}</option>
                    {if $sub_view == "edit_category"}
                      {foreach $data['categories'] as $category}{include file='__categories.recursive_options.tpl' data_category=$data['category_parent_id']}{/foreach}
                    {else}
                      {foreach $categories as $category}{include file='__categories.recursive_options.tpl'}{/foreach}
                    {/if}
                  </select>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="market-category-order">{__("Order")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input class="input w-full" name="category_order" id="market-category-order" value="{if $sub_view == "edit_category"}{$data['category_order']}{/if}" inputmode="numeric">
                </div>
              </div>
            </div>
          </div>

          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </section>
      </form>
    </div>
  </section>

{elseif $sub_view == "payments"}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-market-payments-title">
    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-market-payments-title" class="text-2xl font-semibold">
          {__("Payment Requests")}
          {if $licence_monetization && $licence_module_installed}
          {capture assign="_tip"}{__("You will need to make the payments from your Skrill, Bank Account... etc")}. {__("After making the payment you can mark the payment request as paid")}.{/capture}
          {include file='__admin_tip.tpl' _tip_id="admin-market-payments-tip" _tip_text=$_tip}
          {/if}
        </h1>
        <p class="text-base-content/60 text-sm">{__("Review pending marketplace withdrawal requests.")}</p>
      </div>
    </header>

    {if $licence_monetization && $licence_module_installed}
      <div class="alert alert-warning" role="status">
        <div class="min-w-0 flex-1">{__("PayPal support automatic payout APIs so no need to make them manually")}.</div>
      </div>

      {if $rows}
        <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Payment Requests")}">
          <div class="admin-list-table-wrap w-full overflow-x-auto">
            <table class="table js_dataTable admin-list-table">
              <thead>
                <tr>
                  <th>{__("ID")}</th>
                  <th>{__("User")}</th>
                  <th>{__("Amount")}</th>
                  <th>{__("Method")}</th>
                  <th>{__("Transfer To")}</th>
                  <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
                </tr>
              </thead>
              <tbody>
                {foreach $rows as $row}
                  <tr>
                    <td><span class="admin-list-name text-sm font-semibold">#{$row['payment_id']}</span></td>
                    <td>
                      <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/{$row['user_name']}">
                        <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['user_picture']}" alt="" width="30" height="30" loading="lazy">
                        <span class="admin-list-name max-w-48 truncate text-sm" title="{if $system['show_usernames_enabled']}{$row['user_name']}{else}{$row['user_firstname']} {$row['user_lastname']}{/if}">
                          {if $system['show_usernames_enabled']}{$row['user_name']}{else}{$row['user_firstname']} {$row['user_lastname']}{/if}
                        </span>
                      </a>
                    </td>
                    <td>{print_money($row['amount'])}</td>
                    <td>
                      <span class="badge badge-soft badge-sm rounded-full {if $row['method_color'] == "danger"}badge-error{elseif $row['method_color'] == "info"}badge-info{elseif $row['method_color'] == "warning"}badge-warning{else}badge-primary{/if}">{$row['method']|ucfirst}</span>
                    </td>
                    <td><span class="text-sm [overflow-wrap:anywhere]">{$row['method_value']}</span></td>
                    <td class="admin-list-actions-column w-14 text-end">
                      <div class="dropdown relative inline-flex [--placement:bottom-end]">
                        <button id="market-payment-actions-{$row['payment_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} #{$row['payment_id']}">
                          <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                        </button>
                        <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="market-payment-actions-{$row['payment_id']}">
                          <li>
                            <button type="button" class="dropdown-item px-2 js_admin-withdraw" role="menuitem" data-type="market" data-handle="approve" data-id="{$row['payment_id']}">
                              <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
                              {__("Mark as Paid")}
                            </button>
                          </li>
                          <li>
                            <button type="button" class="dropdown-item px-2 text-error js_admin-withdraw" role="menuitem" data-type="market" data-handle="decline" data-id="{$row['payment_id']}">
                              <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
                              {__("Decline")}
                            </button>
                          </li>
                        </ul>
                      </div>
                    </td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        </section>
      {else}
        <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-market-payments-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--coin] size-6" aria-hidden="true"></span>
          </div>
          <h2 id="admin-market-payments-empty-title">{__("No payment requests")}</h2>
          <p>{__("Pending withdrawal requests will appear here.")}</p>
        </section>
      {/if}
    {else}
      {include file='__licence_lock.tpl'}
    {/if}
  </section>
{/if}
