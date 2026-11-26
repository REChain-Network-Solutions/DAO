{if $system['market_money_withdraw_enabled']}
  <div class="flex flex-col gap-6">
    <div class="card border border-base-300 bg-base-100 shadow-none">
      <form class="js_ajax-forms" data-url="users/withdraw.php?type=market">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--cash]" _title=__("Withdrawal Request") _text=__("Orders and shopping")}
        <div class="card-body gap-6 pt-6">
          <div class="alert alert-info flex items-start gap-3 leading-5" role="alert">
            <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
            <div class="min-w-0">
              <div class="font-medium">{__("Marketplace System")}</div>
              <p class="mt-0.5 text-sm">
                {if $system['market_money_withdraw_enabled']}
                  {__("You can withdraw your money")}
                {/if}
                {if $system['market_money_transfer_enabled']}
                  {if $system['market_money_withdraw_enabled']}{__("or")} {/if}
                  {__("You can transfer your money to your")} <a class="link link-animated font-medium" href="{$system['system_url']}/wallet">{__("wallet")}</a>
                {/if}
              </p>
            </div>
          </div>

          <!-- balance -->
          <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-success" aria-hidden="true">
              <span class="icon-[tabler--coin] size-5"></span>
            </span>
            <div class="min-w-0">
              <div class="text-sm text-base-content/60">{__("Your Balance")}</div>
              <div class="truncate text-xl font-semibold" title="{print_money($user->_data['user_market_balance'])}">{print_money($user->_data['user_market_balance'])}</div>
            </div>
          </div>
          <!-- balance -->

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="market-amount">{__("Amount")} ({$system['system_currency']})</label>
            <input type="text" class="input w-full" id="market-amount" name="amount" inputmode="decimal">
            <p class="helper-text">{__("The minimum withdrawal request amount is")} {print_money($system['market_min_withdrawal'])}</p>
          </div>

          <div class="flex flex-col gap-1.5">
            <span class="label-text">{__("Payment Method")}</span>
            <div class="grid gap-3 sm:grid-cols-2">
              {if in_array("paypal", $system['market_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_paypal">
                  <input type="radio" name="method" id="method_paypal" value="paypal" class="radio radio-primary">
                  <span class="icon-[tabler--brand-paypal] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__("PayPal")}</span>
                </label>
              {/if}
              {if in_array("skrill", $system['market_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_skrill">
                  <input type="radio" name="method" id="method_skrill" value="skrill" class="radio radio-primary">
                  <span class="icon-[tabler--credit-card] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__("Skrill")}</span>
                </label>
              {/if}
              {if in_array("bank", $system['market_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_bank">
                  <input type="radio" name="method" id="method_bank" value="bank" class="radio radio-primary">
                  <span class="icon-[tabler--building-bank] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__("Bank Transfer")}</span>
                </label>
              {/if}
              {if in_array("custom", $system['market_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_custom">
                  <input type="radio" name="method" id="method_custom" value="custom" class="radio radio-primary">
                  <span class="icon-[tabler--cash] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__($system['market_payment_method_custom'])}</span>
                </label>
              {/if}
            </div>
          </div>

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="market-method-value">{__("Transfer To")}</label>
            <input type="text" class="input w-full" id="market-method-value" name="method_value">
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
                        {$system['market_payment_method_custom']}
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
{else}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    {include file='__settings_card_header.tpl' _icon="icon-[tabler--building-store]" _title=__("Marketplace") _text=__("Orders and shopping")}
    <div class="card-body gap-6 pt-6">
      <div class="alert alert-info flex items-start gap-3 leading-5" role="alert">
        <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
        <div class="min-w-0">
          <div class="font-medium">{__("Marketplace System")}</div>
          <p class="mt-0.5 text-sm">
            {if $system['market_money_withdraw_enabled']}
              {__("You can withdraw your money")}
            {/if}
            {if $system['market_money_transfer_enabled']}
              {if $system['market_money_withdraw_enabled']}{__("or")} {/if}
              {__("You can transfer your money to your")} <a class="link link-animated font-medium" href="{$system['system_url']}/wallet">{__("wallet")}</a>
            {/if}
          </p>
        </div>
      </div>

      <!-- money balance -->
      <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
        <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-success" aria-hidden="true">
          <span class="icon-[tabler--coin] size-5"></span>
        </span>
        <div class="min-w-0 grow">
          <div class="text-sm text-base-content/60">{__("Your Market Balance")}</div>
          <div class="truncate text-xl font-semibold" title="{print_money($user->_data['user_market_balance'])}">{print_money($user->_data['user_market_balance'])}</div>
        </div>
        {if $system['market_money_transfer_enabled']}
          <a class="heroui button button--outline button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/wallet">
            <span class="icon-[tabler--wallet] size-4" aria-hidden="true"></span>
            {__("Wallet")}
          </a>
        {/if}
      </div>
      <!-- money balance -->
    </div>
  </div>
{/if}
