{if $sub_view == ""}
  <div class="flex flex-col gap-6">
    <!-- monetization balance -->
    <div class="card border border-base-300 bg-base-100 shadow-none">
      <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
        <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
          <span class="icon-[tabler--wallet] size-5"></span>
        </span>
        <div class="min-w-0 grow">
          <h2 class="card-title text-lg">{__("Monetization Balance")}</h2>
          <p class="text-sm text-base-content/60">{__("Plans, coupons, and earnings")}</p>
        </div>
        {if $system['monetization_money_withdraw_enabled'] || $system['monetization_money_transfer_enabled']}
          <div class="flex w-full gap-2 sm:ms-auto sm:w-auto sm:shrink-0 sm:flex-wrap">
            {if $system['monetization_money_transfer_enabled']}
              <a class="heroui button button--outline button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/wallet">
                <span class="icon-[tabler--wallet] size-4" aria-hidden="true"></span>
                {__("Wallet")}
              </a>
            {/if}
            {if $system['monetization_money_withdraw_enabled']}
              <a class="heroui button button--primary button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/settings/monetization/payments">
                <span class="icon-[tabler--cash] size-4" aria-hidden="true"></span>
                {__("Make a withdrawal")}
              </a>
            {/if}
          </div>
        {/if}
      </div>
      <div class="card-body pt-6">
        <div class="grid gap-4 sm:grid-cols-2">
          <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-success" aria-hidden="true">
              <span class="icon-[tabler--coin] size-5"></span>
            </span>
            <div class="min-w-0">
              <div class="text-sm text-base-content/60">{__("Monetization Money Balance")}</div>
              <div class="truncate text-xl font-semibold" title="{print_money($user->_data['user_monetization_balance'])}">{print_money($user->_data['user_monetization_balance'])}</div>
            </div>
          </div>
          <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-primary" aria-hidden="true">
              <span class="icon-[tabler--users] size-5"></span>
            </span>
            <div class="min-w-0">
              <div class="text-sm text-base-content/60">{__("Profile Subscribers")}</div>
              <div class="truncate text-xl font-semibold" title="{$subscribers_count}">{$subscribers_count}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- monetization balance -->

    <div class="card border border-base-300 bg-base-100 shadow-none">
      <form class="js_ajax-forms" data-url="users/settings.php?edit=monetization">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--coin]" _title=__("Monetization Settings") _text=__("Plans, coupons, and earnings")}
        <div class="card-body gap-6 pt-6">
          <div class="alert alert-info flex items-start gap-3 leading-5" role="alert">
            <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
            <div class="min-w-0">
              <div class="font-medium">{__("Monetization")}</div>
              <ul class="mt-1 flex list-disc flex-col gap-1 ps-4 text-sm">
                <li>{__("Now you can earn money via paid posts, paid chat, paid audio/video calls or subscriptions plans.")}</li>
                {if $system['monetization_commission'] > 0}
                  <li>{__("There is commission")} <strong>{$system['monetization_commission']}%</strong> {__("will be deducted")}.</li>
                {/if}
                {if $system['monetization_money_withdraw_enabled'] || $system['monetization_money_transfer_enabled']}
                  <li>
                    {if $system['monetization_money_withdraw_enabled']}
                      {__("You can")} <a class="link link-animated font-medium" href="{$system['system_url']}/settings/monetization/payments">{__("withdraw your money")}</a>
                    {/if}
                    {if $system['monetization_money_transfer_enabled']}
                      {if $system['monetization_money_withdraw_enabled']}{__("or")} {/if}
                      {__("You can transfer your money to your")} <a class="link link-animated font-medium" href="{$system['system_url']}/wallet">{__("wallet")}</a>
                    {/if}
                  </li>
                {/if}
              </ul>
            </div>
          </div>

          {if $system['verification_for_monetization'] && !$user->_data['user_verified']}
            <div class="alert alert-error flex flex-wrap items-center gap-3 leading-5" role="alert">
              <span class="icon-[tabler--alert-circle] size-5 shrink-0" aria-hidden="true"></span>
              <div class="min-w-0 grow">
                <div class="font-medium">{__("Account Verification Required")}</div>
                <p class="mt-0.5 text-sm">{__("To enable monetization your account must be verified")}</p>
              </div>
              <a class="heroui button button--danger button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/settings/verification">
                <span class="icon-[tabler--rosette-discount-check] size-4" aria-hidden="true"></span>
                {__("Verify Now")}
              </a>
            </div>
          {/if}

          <!-- general -->
          <div class="flex flex-col divide-y divide-base-300 rounded-xl border border-base-300">
            <div class="flex items-center gap-4 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                {include file='__svg_icons.tpl' icon="monetization" class="main-icon" width="24px" height="24px"}
              </span>
              <div class="min-w-0 grow">
                <div class="text-sm font-medium" id="user_monetization_enabled-label">{__("Monetization")}</div>
                <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Enable or disable monetization for your content")}</p>
              </div>
              <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="user_monetization_enabled-label" type="checkbox" name="user_monetization_enabled" id="user_monetization_enabled" {if $user->_data['user_monetization_enabled']}checked{/if}>
            </div>
            <div class="flex flex-col gap-4 p-4">
              <div class="flex items-center gap-4">
                <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                  {include file='__svg_icons.tpl' icon="offers" class="main-icon" width="24px" height="24px"}
                </span>
                <div class="min-w-0 grow">
                  <div class="text-sm font-medium" id="user_monetization_discount_enabled-label">{__("Global Discount")}</div>
                  <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Enable or disable global discount for subscriptions plans and paid posts")}</p>
                </div>
                <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="user_monetization_discount_enabled-label" type="checkbox" name="user_monetization_discount_enabled" id="user_monetization_discount_enabled" {if $user->_data['user_monetization_discount_enabled']}checked{/if}>
              </div>
              <div class="w-full sm:ps-14">
                <label class="label-text mb-1.5 block" for="user_monetization_discount_percent">{__("Discount Percent")}</label>
                <div class="input w-full items-center gap-2 sm:max-w-48">
                  <input type="number" min="1" max="99" class="grow" id="user_monetization_discount_percent" name="user_monetization_discount_percent" value="{$user->_data['user_monetization_discount_percent']}">
                  <span class="text-base-content/60" aria-hidden="true">%</span>
                </div>
                <p class="helper-text">{__("The discount percent to apply to all monetized content (min 1, max 99)")}</p>
              </div>
            </div>
          </div>
          <!-- general -->

          <!-- paid chat -->
          <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
            <h3 class="flex items-center gap-2 text-sm font-semibold">
              <span class="icon-[tabler--message-dollar] size-5 text-base-content/60" aria-hidden="true"></span>
              {__("Paid Chat")}
            </h3>
            <div class="grid gap-6 sm:grid-cols-2">
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="user_monetization_chat_price">{__("Chat Message")}</label>
                <div class="input w-full items-center gap-2">
                  <input type="text" class="grow" id="user_monetization_chat_price" name="user_monetization_chat_price" inputmode="decimal" value="{$user->_data['user_monetization_chat_price']}">
                  <span class="text-sm text-base-content/60">{$system['system_currency']}</span>
                </div>
                <p class="helper-text">{__("Price per message (0 for free)")}</p>
              </div>
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="user_monetization_call_price">{__("Audio/Video Call")}</label>
                <div class="input w-full items-center gap-2">
                  <input type="text" class="grow" id="user_monetization_call_price" name="user_monetization_call_price" inputmode="decimal" value="{$user->_data['user_monetization_call_price']}">
                  <span class="text-sm text-base-content/60">{$system['system_currency']}</span>
                </div>
                <p class="helper-text">{__("Price per call (0 for free)")}</p>
              </div>
            </div>
          </section>
          <!-- paid chat -->

          <!-- subscriptions -->
          <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
            <h3 class="flex items-center gap-2 text-sm font-semibold">
              <span class="icon-[tabler--crown] size-5 text-base-content/60" aria-hidden="true"></span>
              {__("Subscriptions Plans")}
            </h3>
            {include file='__monetization_plans.tpl' _node_id=$user->_data['user_id'] _node_type='profile'}
          </section>
          <!-- subscriptions -->

          <!-- success -->
          <div class="alert alert-success hidden items-center" role="status"></div>
          <!-- success -->

          <!-- error -->
          <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
          <!-- error -->
        </div>
        <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
          <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
        </div>
      </form>
    </div>
  </div>

{elseif $sub_view == "coupons"}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
      <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
        <span class="icon-[tabler--ticket] size-5"></span>
      </span>
      <div class="min-w-0 grow">
        <h2 class="card-title text-lg">{__("Coupons")}</h2>
        <p class="text-sm text-base-content/60">{__("Plans, coupons, and earnings")}</p>
      </div>
      <button type="button" data-url="monetization/controller.php?do=add_coupon&node_id={$user->_data['user_id']}&node_type=profile" class="js_modal heroui button button--primary button--sm w-full sm:ms-auto sm:w-auto shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Generate New Coupon")}
      </button>
    </div>
    <div class="card-body gap-6 pt-6">
      {if $coupons}
        <div class="[&_.js-flyonui-datatable-toolbar]:px-0 [&_.js-flyonui-datatable-footer]:px-0">
          <table class="table table-zebra min-w-[720px] js_dataTable">
            <thead>
              <tr>
                <th>{__("Code")}</th>
                <th>{__("Discount")}</th>
                <th>{__("Created")}</th>
                <th>{__("Usage Details")}</th>
                <th>{__("One Time")}</th>
                <th class="text-end">{__("Actions")}</th>
              </tr>
            </thead>
            <tbody>
              {foreach $coupons as $coupon}
                <tr>
                  <td>
                    <code class="rounded-lg border border-base-300 bg-base-200/60 px-2 py-1 text-sm font-semibold tracking-wider" dir="ltr">{$coupon['coupon_code']}</code>
                  </td>
                  <td>
                    <span class="badge badge-soft rounded-full badge-lg badge-primary">
                      <span class="icon-[tabler--discount] size-4" aria-hidden="true"></span>{$coupon['discount_percent']}%
                    </span>
                  </td>
                  <td class="text-base-content/60">{$coupon['created_date']|date_format:"%e %B %Y"}</td>
                  <td>
                    {if $coupon['usage_counter'] > 0}
                      <button type="button" data-url="monetization/controller.php?do=coupon_users&coupon_id={$coupon['coupon_id']}" class="js_modal heroui button button--tertiary [--button-bg:var(--success-soft)] [--button-bg-hover:var(--success-soft-hover)] [--button-bg-pressed:var(--success-soft-hover)] [--button-fg:var(--success-soft-foreground)] button--sm rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
                        <span class="icon-[tabler--users] size-4" aria-hidden="true"></span>
                        {$coupon['usage_counter']} {__("Users")}
                      </button>
                    {else}
                      <span class="inline-flex items-center gap-1.5 text-sm text-base-content/60">
                        <span class="icon-[tabler--user-off] size-4" aria-hidden="true"></span>
                        {__("No One")}
                      </span>
                    {/if}
                  </td>
                  <td>
                    {if $coupon['is_onetime']}
                      <span class="inline-flex size-7 items-center justify-center rounded-full bg-success/10 text-success" title='{__("Yes")}'>
                        <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
                      </span>
                    {else}
                      <span class="inline-flex size-7 items-center justify-center rounded-full bg-base-200 text-base-content/50" title='{__("No")}'>
                        <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
                      </span>
                    {/if}
                  </td>
                  <td>
                    <div class="flex items-center justify-end gap-2">
                      <!-- share -->
                      <button type="button" data-url="monetization/controller.php?do=share_coupon&coupon_id={$coupon['coupon_id']}" class="js_modal heroui button button--tertiary text-base-content button--sm button--icon-only size-7.5 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-label='{__("Share")}' title='{__("Share")}'>
                        <span class="icon-[tabler--link] size-4" aria-hidden="true"></span>
                      </button>
                      <!-- share -->
                      <!-- delete -->
                      <button type="button" class="heroui button button--danger-soft button--sm button--icon-only size-7.5 js_monetization-coupon-deleter rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-id="{$coupon['coupon_id']}" aria-label='{__("Delete")}' title='{__("Delete")}'>
                        <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                      </button>
                      <!-- delete -->
                    </div>
                  </td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
      {else}
        {include file='_no_data.tpl' _empty_icon="icon-[tabler--ticket]"}
      {/if}
    </div>
  </div>

{elseif $sub_view == "payments"}
  <div class="flex flex-col gap-6">
    <div class="card border border-base-300 bg-base-100 shadow-none">
      <form class="js_ajax-forms" data-url="users/withdraw.php?type=monetization">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--cash]" _title=__("Withdrawal Request") _text=__("Plans, coupons, and earnings")}
        <div class="card-body gap-6 pt-6">
          <!-- balance -->
          <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-success" aria-hidden="true">
              <span class="icon-[tabler--coin] size-5"></span>
            </span>
            <div class="min-w-0">
              <div class="text-sm text-base-content/60">{__("Your Balance")}</div>
              <div class="truncate text-xl font-semibold" title="{print_money($user->_data['user_monetization_balance'])}">{print_money($user->_data['user_monetization_balance'])}</div>
            </div>
          </div>
          <!-- balance -->

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="monetization-amount">{__("Amount")} ({$system['system_currency']})</label>
            <input type="text" class="input w-full" id="monetization-amount" name="amount" inputmode="decimal">
            <p class="helper-text">{__("The minimum withdrawal request amount is")} {print_money($system['monetization_min_withdrawal'])}</p>
          </div>

          <div class="flex flex-col gap-1.5">
            <span class="label-text">{__("Payment Method")}</span>
            <div class="grid gap-3 sm:grid-cols-2">
              {if in_array("paypal", $system['monetization_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_paypal">
                  <input type="radio" name="method" id="method_paypal" value="paypal" class="radio radio-primary">
                  <span class="icon-[tabler--brand-paypal] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__("PayPal")}</span>
                </label>
              {/if}
              {if in_array("skrill", $system['monetization_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_skrill">
                  <input type="radio" name="method" id="method_skrill" value="skrill" class="radio radio-primary">
                  <span class="icon-[tabler--credit-card] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__("Skrill")}</span>
                </label>
              {/if}
              {if in_array("bank", $system['monetization_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_bank">
                  <input type="radio" name="method" id="method_bank" value="bank" class="radio radio-primary">
                  <span class="icon-[tabler--building-bank] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__("Bank Transfer")}</span>
                </label>
              {/if}
              {if in_array("custom", $system['monetization_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_custom">
                  <input type="radio" name="method" id="method_custom" value="custom" class="radio radio-primary">
                  <span class="icon-[tabler--cash] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__($system['monetization_payment_method_custom'])}</span>
                </label>
              {/if}
            </div>
          </div>

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="monetization-method-value">{__("Transfer To")}</label>
            <input type="text" class="input w-full" id="monetization-method-value" name="method_value">
          </div>

          <!-- success -->
          <div class="alert alert-success hidden items-center" role="status"></div>
          <!-- success -->

          <!-- error -->
          <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
          <!-- error -->
        </div>
        <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
          <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
            <span class="icon-[tabler--send] size-4" aria-hidden="true"></span>
            {__("Make a withdrawal")}
          </button>
        </div>
      </form>
    </div>

    <div class="card border border-base-300 bg-base-100 shadow-none">
      {include file='__settings_card_header.tpl' _icon="icon-[tabler--history]" _title=__("Withdrawal History")}
      <div class="card-body gap-6 pt-6">
        {if $payments}
          <div class="overflow-x-auto">
            <table class="table table-zebra min-w-[720px]">
              <thead>
                <tr>
                  <th>{__("ID")}</th>
                  <th>{__("Amount")}</th>
                  <th>{__("Method")}</th>
                  <th>{__("Transfer To")}</th>
                  <th>{__("Time")}</th>
                  <th class="text-end">{__("Status")}</th>
                </tr>
              </thead>
              <tbody>
                {foreach $payments as $payment}
                  <tr>
                    <td>{$payment@iteration}</td>
                    <td class="font-medium">{print_money($payment['amount'])}</td>
                    <td>
                      {if $payment['method'] == "custom"}
                        {$system['monetization_payment_method_custom']}
                      {else}
                        {$payment['method']|ucfirst}
                      {/if}
                    </td>
                    <td class="max-w-56 truncate" title="{$payment['method_value']}">{$payment['method_value']}</td>
                    <td class="text-base-content/60">
                      <span class="js_moment" data-time="{$payment['time']}">{$payment['time']}</span>
                    </td>
                    <td class="text-end">
                      {if $payment['status'] == '0'}
                        <span class="badge badge-soft rounded-full badge-lg badge-warning">{__("Pending")}</span>
                      {elseif $payment['status'] == '1'}
                        <span class="badge badge-soft rounded-full badge-lg badge-success">{__("Approved")}</span>
                      {else}
                        <span class="badge badge-soft rounded-full badge-lg badge-error">{__("Declined")}</span>
                      {/if}
                    </td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        {else}
          {include file='_no_transactions.tpl'}
        {/if}
      </div>
    </div>
  </div>

{elseif $sub_view == "earnings"}
  <div class="flex flex-col gap-6">
    <div class="card border border-base-300 bg-base-100 shadow-none">
      {include file='__settings_card_header.tpl' _icon="icon-[tabler--chart-line]" _title=__("Earnings") _text=__("Plans, coupons, and earnings")}
      <div class="card-body pt-6">
        <div class="grid gap-4 sm:grid-cols-2">
          <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-success" aria-hidden="true">
              <span class="icon-[tabler--coins] size-5"></span>
            </span>
            <div class="min-w-0">
              <div class="text-sm text-base-content/60">{__("Total Earnings")}</div>
              <div class="truncate text-xl font-semibold" title="{print_money($total_earnings)}">{print_money($total_earnings)}</div>
            </div>
          </div>
          <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-primary" aria-hidden="true">
              <span class="icon-[tabler--calendar-dollar] size-5"></span>
            </span>
            <div class="min-w-0">
              <div class="text-sm text-base-content/60">{__("This Month Earnings")}</div>
              <div class="truncate text-xl font-semibold" title="{print_money($this_month_earnings)}">{print_money($this_month_earnings)}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="card border border-base-300 bg-base-100 shadow-none">
      {include file='__settings_card_header.tpl' _icon="icon-[tabler--history]" _title=__("History")}
      <div class="card-body gap-6 pt-6">
        {if $earnings}
          <div class="overflow-x-auto">
            <table class="table table-zebra min-w-[720px]">
              <thead>
                <tr>
                  <th>{__("ID")}</th>
                  <th>{__("User")}</th>
                  <th>{__("Total")}</th>
                  <th>{__("Commission")}</th>
                  <th>{__("Earning")}</th>
                  <th class="text-end">{__("Time")}</th>
                </tr>
              </thead>
              <tbody>
                {foreach $earnings as $earning}
                  <tr>
                    <td>{$earning@iteration}</td>
                    <td>
                      <a class="flex min-w-0 items-center gap-2.5 text-base-content! hover:text-primary!" href="{$system['system_url']}/{$earning['user_name']}">
                        <img src="{$earning['user_picture']}" class="size-8 shrink-0 rounded-full object-cover" alt="">
                        <span class="truncate text-sm font-medium" title="{$earning['user_fullname']}">{$earning['user_fullname']}</span>
                      </a>
                    </td>
                    <td>{print_money($earning['price'])}</td>
                    <td{if $earning['commission'] > 0} class="text-error"{/if}>{if $earning['commission'] > 0}-{/if}{print_money($earning['commission'])}</td>
                    <td>
                      <span class="badge badge-soft rounded-full badge-lg badge-success">{print_money($earning['earning'])}</span>
                    </td>
                    <td class="text-end text-base-content/60">
                      <span class="js_moment" data-time="{$earning['time']}">{$earning['time']}</span>
                    </td>
                  </tr>
                {/foreach}
              </tbody>
            </table>
          </div>
        {else}
          {include file='_no_transactions.tpl'}
        {/if}
      </div>
    </div>
  </div>

{/if}
