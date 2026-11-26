{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {if $view == ""}
    {include file='__page_header.tpl' _title=__("Wallet") _text=__("Send and Transfer Money") _image="wallet.svg"}
  {else}
    {include file='__page_header.tpl' _title=__("Wallet Payments") _text=__("Send and Transfer Money") _image="wallet.svg"}
  {/if}
  <!-- page heading -->

  <!-- tabs -->
  {if $system['wallet_withdrawal_enabled']}
    <nav class="tabs tabs-bordered mt-6 gap-2 border-b border-base-300 sm:gap-6" aria-label="{__("Wallet")}">
      <a class="tab -mb-px h-11 min-w-0 flex-1 justify-center gap-1.5 px-0 text-sm font-medium sm:flex-none sm:shrink-0 sm:justify-start{if $view == ""} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/wallet" {if $view == ""}aria-current="page"{/if}>
        <span class="icon-[tabler--wallet] size-4 shrink-0" aria-hidden="true"></span>
        <span class="truncate" title="{__("Wallet")}">{__("Wallet")}</span>
      </a>
      <a class="tab -mb-px h-11 min-w-0 flex-1 justify-center gap-1.5 px-0 text-sm font-medium sm:flex-none sm:shrink-0 sm:justify-start{if $view == "payments"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/wallet/payments" {if $view == "payments"}aria-current="page"{/if}>
        <span class="icon-[tabler--building-bank] size-4 shrink-0" aria-hidden="true"></span>
        <span class="truncate" title="{__("Payments")}">{__("Payments")}</span>
      </a>
    </nav>
  {/if}
  <!-- tabs -->

  {if $view == ""}

    <!-- wallet -->
    {if $wallet_transfer_amount || $wallet_replenish_amount || $wallet_withdraw_affiliates_amount || $wallet_withdraw_points_amount || $wallet_withdraw_market_amount || $wallet_withdraw_funding_amount || $wallet_withdraw_monetization_amount || $wallet_package_payment_amount || $wallet_monetization_payment_amount || $wallet_paid_post_amount || $wallet_donate_amount || $wallet_marketplace_amount}
      <div class="alert alert-soft alert-success mt-6 flex items-start gap-3" role="status">
        <span class="icon-[tabler--circle-check] mt-0.5 size-5 shrink-0" aria-hidden="true"></span>
        <span>
          {if $wallet_transfer_amount}
            {__("Your")} <strong>{print_money($wallet_transfer_amount)}</strong> {__("transfer transaction successfuly sent")}
          {elseif $wallet_replenish_amount}
            {__("Congratulation! Your wallet credit replenished successfully with")} <strong>{print_money($wallet_replenish_amount)}</strong>
          {elseif $wallet_withdraw_affiliates_amount}
            {__("Congratulation! Your wallet credit replenished successfully with")} <strong>{print_money($wallet_withdraw_affiliates_amount)}</strong> {__("from your affiliates credit")}
          {elseif $wallet_withdraw_points_amount}
            {__("Congratulation! Your wallet credit replenished successfully with")} <strong>{print_money($wallet_withdraw_points_amount)}</strong> {__("from your points credit")}
          {elseif $wallet_withdraw_market_amount}
            {__("Congratulation! Your wallet credit replenished successfully with")} <strong>{print_money($wallet_withdraw_market_amount)}</strong> {__("from your market credit")}
          {elseif $wallet_withdraw_funding_amount}
            {__("Congratulation! Your wallet credit replenished successfully with")} <strong>{print_money($wallet_withdraw_funding_amount)}</strong> {__("from your funding credit")}
          {elseif $wallet_withdraw_monetization_amount}
            {__("Congratulation! Your wallet credit replenished successfully with")} <strong>{print_money($wallet_withdraw_monetization_amount)}</strong> {__("from your monetization credit")}
          {elseif $wallet_package_payment_amount}
            {__("Your")} <strong>{print_money($wallet_package_payment_amount)}</strong> {__("payment transaction successfuly done")}
          {elseif $wallet_monetization_payment_amount}
            {__("Your")} <strong>{print_money($wallet_monetization_payment_amount)}</strong> {__("payment transaction successfuly done")}
          {elseif $wallet_paid_post_amount}
            {__("Your")} <strong>{print_money($wallet_paid_post_amount)}</strong> {__("payment transaction successfuly done")}
          {elseif $wallet_donate_amount}
            {__("Your")} <strong>{print_money($wallet_donate_amount)}</strong> {__("payment transaction successfuly done")}
          {elseif $wallet_marketplace_amount}
            {__("Your")} <strong>{print_money($wallet_marketplace_amount)}</strong> {__("payment transaction successfuly done")}
          {/if}
        </span>
      </div>
    {/if}

    {$_has_credits = ($system['affiliates_enabled'] && $system['affiliates_money_transfer_enabled']) || ($system['points_enabled'] && $system['points_per_currency'] > 0 && $system['points_money_transfer_enabled']) || ($user->_data['can_sell_products'] && $system['market_money_transfer_enabled'] && $system['market_shopping_cart_enabled']) || ($user->_data['can_raise_funding'] && $system['funding_money_transfer_enabled']) || ($user->_data['can_monetize_content'] && $system['monetization_money_transfer_enabled'])}
    <div class="mt-6 grid gap-6 lg:grid-cols-3 lg:items-start">

      <!-- balance -->
      <div class="flex flex-col gap-6">
        {$_received = 0}{$_sent = 0}
        {foreach $transactions as $_transaction}
          {if $_transaction['type'] == "out"}{$_sent = $_sent + $_transaction['amount']}{else}{$_received = $_received + $_transaction['amount']}{/if}
        {/foreach}
        <section class="card border-0 bg-primary text-primary-content shadow-none dark:[--color-primary:#523ae2]" aria-labelledby="wallet-credit-label">
          <div class="card-header flex items-center gap-3 border-b border-primary-content/15">
            {$_wallet_icon = ''}{if $system['system_theme_icons'] == 'svg'}{$_wallet_icon = 'wallet'|theme_module_icon:'size-10 max-w-none shrink-0'}{/if}
            {if $_wallet_icon}
              {$_wallet_icon}
            {else}
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-primary-content/15" aria-hidden="true">
                <span class="icon-[tabler--wallet] size-5"></span>
              </span>
            {/if}
            <div class="min-w-0">
              <h2 class="card-title text-lg text-primary-content" id="wallet-credit-label">{__("Your Credit")}</h2>
              <p class="text-sm text-primary-content/70">{__("Send and Transfer Money")}</p>
            </div>
          </div>
          <div class="card-body gap-5 pt-6">
            <div class="min-w-0">
              <span class="text-sm text-primary-content/70">{__("Wallet Balance")}</span>
              <p class="mt-1 truncate text-4xl font-bold tracking-tight" title="{print_money($user->_data['user_wallet_balance'])|regex_replace:'/(\.\d{2})/':'$1'}">{print_money($user->_data['user_wallet_balance'])|regex_replace:'/(\.\d{2})/':'<span class="text-primary-content/50">$1</span>'}</p>
              {if $transactions}
                <p class="mt-1.5 flex items-center gap-1.5 text-xs text-primary-content/70">
                  <span class="size-1.5 rounded-full bg-success" aria-hidden="true"></span>
                  <span>{__("Updated")} <span class="js_moment" data-time="{$transactions[0]['date']}">{$transactions[0]['date']}</span></span>
                </p>
              {/if}
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div class="flex min-w-0 items-center gap-3 rounded-xl bg-primary-content/10 p-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-primary-content text-success" aria-hidden="true">
                  <span class="icon-[tabler--arrow-down-left] size-4.5"></span>
                </span>
                <div class="min-w-0">
                  <div class="text-xs text-primary-content/70">{__("Received")}</div>
                  <div class="truncate text-sm font-semibold" title="{print_money($_received)}">{print_money($_received)}</div>
                </div>
              </div>
              <div class="flex min-w-0 items-center gap-3 rounded-xl bg-primary-content/10 p-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-primary-content text-error" aria-hidden="true">
                  <span class="icon-[tabler--arrow-up-right] size-4.5"></span>
                </span>
                <div class="min-w-0">
                  <div class="text-xs text-primary-content/70">{__("Sent")}</div>
                  <div class="truncate text-sm font-semibold" title="{print_money($_sent)}">{print_money($_sent)}</div>
                </div>
              </div>
            </div>
          </div>
          <div class="card-footer grid gap-2 border-t border-primary-content/15 pt-5 {if $system['wallet_transfer_enabled']}grid-cols-2{/if}">
            <button type="button" class="js_modal heroui button button--tertiary w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] border-0 bg-primary-content text-primary shadow-none hover:bg-primary-content/90" data-url="#wallet-replenish">
              <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
              {__("Add Funds")}
            </button>
            {if $system['wallet_transfer_enabled']}
              <button type="button" class="js_modal heroui button button--tertiary w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] border-0 bg-primary-content/15 text-primary-content shadow-none hover:bg-primary-content/25" data-url="#wallet-transfer">
                <span class="icon-[tabler--arrow-up-right] size-4" aria-hidden="true"></span>
                {__("Send Money")}
              </button>
            {/if}
          </div>
        </section>

      {if $_has_credits}
        <!-- credits -->
        <section class="card border border-base-300 bg-base-100 shadow-none" aria-labelledby="wallet-credits-heading">
          <div class="card-header flex items-center gap-3 border-b border-base-300">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
              <span class="icon-[tabler--transfer-in] size-5"></span>
            </span>
            <div class="min-w-0">
              <h2 class="card-title text-lg" id="wallet-credits-heading">{__("Credits")}</h2>
              <p class="text-xs text-base-content/60">{__("Move your earnings to your wallet")}</p>
            </div>
          </div>
          <ul class="menu gap-1 p-2">
            {if $system['affiliates_enabled'] && $system['affiliates_money_transfer_enabled']}
              <li>
                {$_credit_icon = ''}{if $system['system_theme_icons'] == 'svg'}{$_credit_icon = 'affiliates'|theme_module_icon:'size-9 max-w-none shrink-0'}{/if}
                <button type="button" class="js_modal flex items-center gap-3 rounded-xl px-3 py-2.5" data-url="#wallet-withdraw-affiliates">
                  {if $_credit_icon}
                    {$_credit_icon}
                  {else}
                    <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary" aria-hidden="true"><span class="icon-[tabler--users] size-5"></span></span>
                  {/if}
                  <span class="grow text-start font-medium">{__("Affiliates Credit")}</span>
                  <span class="icon-[tabler--chevron-right] size-4 text-base-content/40 rtl:rotate-180" aria-hidden="true"></span>
                </button>
              </li>
            {/if}
            {if $system['points_enabled'] && $system['points_per_currency'] > 0 && $system['points_money_transfer_enabled']}
              <li>
                {$_credit_icon = ''}{if $system['system_theme_icons'] == 'svg'}{$_credit_icon = 'points'|theme_module_icon:'size-9 max-w-none shrink-0'}{/if}
                <button type="button" class="js_modal flex items-center gap-3 rounded-xl px-3 py-2.5" data-url="#wallet-withdraw-points">
                  {if $_credit_icon}
                    {$_credit_icon}
                  {else}
                    <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl bg-warning/10 text-warning" aria-hidden="true"><span class="icon-[tabler--coin] size-5"></span></span>
                  {/if}
                  <span class="grow text-start font-medium">{__("Points Credit")}</span>
                  <span class="icon-[tabler--chevron-right] size-4 text-base-content/40 rtl:rotate-180" aria-hidden="true"></span>
                </button>
              </li>
            {/if}
            {if $user->_data['can_sell_products'] && $system['market_money_transfer_enabled'] && $system['market_shopping_cart_enabled']}
              <li>
                {$_credit_icon = ''}{if $system['system_theme_icons'] == 'svg'}{$_credit_icon = 'marketplace'|theme_module_icon:'size-9 max-w-none shrink-0'}{/if}
                <button type="button" class="js_modal flex items-center gap-3 rounded-xl px-3 py-2.5" data-url="#wallet-withdraw-market">
                  {if $_credit_icon}
                    {$_credit_icon}
                  {else}
                    <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl bg-info/10 text-info" aria-hidden="true"><span class="icon-[tabler--shopping-bag] size-5"></span></span>
                  {/if}
                  <span class="grow text-start font-medium">{__("Marketplace Credit")}</span>
                  <span class="icon-[tabler--chevron-right] size-4 text-base-content/40 rtl:rotate-180" aria-hidden="true"></span>
                </button>
              </li>
            {/if}
            {if $user->_data['can_raise_funding'] && $system['funding_money_transfer_enabled']}
              <li>
                {$_credit_icon = ''}{if $system['system_theme_icons'] == 'svg'}{$_credit_icon = 'funding'|theme_module_icon:'size-9 max-w-none shrink-0'}{/if}
                <button type="button" class="js_modal flex items-center gap-3 rounded-xl px-3 py-2.5" data-url="#wallet-withdraw-funding">
                  {if $_credit_icon}
                    {$_credit_icon}
                  {else}
                    <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl bg-error/10 text-error" aria-hidden="true"><span class="icon-[tabler--heart-handshake] size-5"></span></span>
                  {/if}
                  <span class="grow text-start font-medium">{__("Funding Credit")}</span>
                  <span class="icon-[tabler--chevron-right] size-4 text-base-content/40 rtl:rotate-180" aria-hidden="true"></span>
                </button>
              </li>
            {/if}
            {if $user->_data['can_monetize_content'] && $system['monetization_money_transfer_enabled']}
              <li>
                {$_credit_icon = ''}{if $system['system_theme_icons'] == 'svg'}{$_credit_icon = 'monetization'|theme_module_icon:'size-9 max-w-none shrink-0'}{/if}
                <button type="button" class="js_modal flex items-center gap-3 rounded-xl px-3 py-2.5" data-url="#wallet-withdraw-monetization">
                  {if $_credit_icon}
                    {$_credit_icon}
                  {else}
                    <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl bg-success/10 text-success" aria-hidden="true"><span class="icon-[tabler--currency-dollar] size-5"></span></span>
                  {/if}
                  <span class="grow text-start font-medium">{__("Monetization Credit")}</span>
                  <span class="icon-[tabler--chevron-right] size-4 text-base-content/40 rtl:rotate-180" aria-hidden="true"></span>
                </button>
              </li>
            {/if}
          </ul>
        </section>
        <!-- credits -->
      {/if}
      </div>
      <!-- balance -->

      <!-- transactions -->
      <section class="card min-w-0 border border-base-300 bg-base-100 shadow-none lg:col-span-2" aria-labelledby="wallet-activity-heading">
        <div class="card-header flex items-center gap-3 border-b border-base-300">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
            <span class="icon-[tabler--receipt] size-5"></span>
          </span>
          <div class="min-w-0">
            <h2 class="card-title text-lg" id="wallet-activity-heading">{__("Wallet Transactions")}</h2>
          </div>
        </div>
        {if $transactions}
          <ul class="divide-y divide-base-300">
            {foreach $transactions as $transaction}
              {include file='__wallet_transaction.tpl'}
            {/foreach}
          </ul>
        {else}
          {include file='_no_transactions.tpl'}
        {/if}
      </section>
      <!-- transactions -->

    </div>
    <!-- wallet -->

  {elseif $view == "payments"}

    <!-- payments -->
    <div class="mt-6 grid gap-6 lg:grid-cols-5 lg:items-start">

      <div class="card border border-base-300 bg-base-100 shadow-none lg:col-span-2">
        <form class="js_ajax-forms" data-url="users/withdraw.php?type=wallet">
          {include file='__settings_card_header.tpl' _icon="icon-[tabler--cash]" _title=__("Withdrawal Request")}
          <div class="card-body gap-6 pt-6">
            <!-- balance -->
            <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-primary" aria-hidden="true">
                <span class="icon-[tabler--wallet] size-5"></span>
              </span>
              <div class="min-w-0">
                <div class="text-sm text-base-content/60">{__("Your Balance")}</div>
                <div class="truncate text-xl font-semibold" title="{print_money($user->_data['user_wallet_balance'])}">{print_money($user->_data['user_wallet_balance'])}</div>
              </div>
            </div>
            <!-- balance -->

            <div class="w-full">
              <label class="label-text mb-1.5 block" for="wallet-withdraw-amount">{__("Amount")} ({$system['system_currency']})</label>
              <input type="text" class="input w-full" id="wallet-withdraw-amount" name="amount" inputmode="decimal">
              <p class="helper-text">{__("The minimum withdrawal request amount is")} {print_money($system['wallet_min_withdrawal'])}</p>
            </div>

            <div class="flex flex-col gap-1.5">
              <span class="label-text">{__("Payment Method")}</span>
              <div class="grid gap-3 sm:grid-cols-2">
                {if in_array("paypal", $system['wallet_payment_method_array'])}
                  <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_paypal">
                    <input type="radio" name="method" id="method_paypal" value="paypal" class="radio radio-primary">
                    <span class="icon-[tabler--brand-paypal] size-5 shrink-0" aria-hidden="true"></span>
                    <span class="text-sm font-medium">{__("PayPal")}</span>
                  </label>
                {/if}
                {if in_array("skrill", $system['wallet_payment_method_array'])}
                  <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_skrill">
                    <input type="radio" name="method" id="method_skrill" value="skrill" class="radio radio-primary">
                    <span class="icon-[tabler--credit-card] size-5 shrink-0" aria-hidden="true"></span>
                    <span class="text-sm font-medium">{__("Skrill")}</span>
                  </label>
                {/if}
                {if in_array("bank", $system['wallet_payment_method_array'])}
                  <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_bank">
                    <input type="radio" name="method" id="method_bank" value="bank" class="radio radio-primary">
                    <span class="icon-[tabler--building-bank] size-5 shrink-0" aria-hidden="true"></span>
                    <span class="text-sm font-medium">{__("Bank Transfer")}</span>
                  </label>
                {/if}
                {if in_array("custom", $system['wallet_payment_method_array'])}
                  <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_custom">
                    <input type="radio" name="method" id="method_custom" value="custom" class="radio radio-primary">
                    <span class="icon-[tabler--cash] size-5 shrink-0" aria-hidden="true"></span>
                    <span class="text-sm font-medium">{__($system['wallet_payment_method_custom'])}</span>
                  </label>
                {/if}
              </div>
            </div>

            <div class="w-full">
              <label class="label-text mb-1.5 block" for="wallet-withdraw-to">{__("Transfer To")}</label>
              <input type="text" class="input w-full" id="wallet-withdraw-to" name="method_value">
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

      <div class="card min-w-0 border border-base-300 bg-base-100 shadow-none lg:col-span-3">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--history]" _title=__("Withdrawal History")}
        {if $payments}
          <div class="w-full overflow-x-auto">
            <table class="table min-w-[560px]">
              <thead>
                <tr>
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
                    <td class="whitespace-nowrap font-semibold">{print_money($payment['amount'])}</td>
                    <td>
                      <span class="inline-flex items-center gap-2 whitespace-nowrap">
                        {if $payment['method'] == "paypal"}
                          <span class="icon-[tabler--brand-paypal] size-4.5 text-base-content/60" aria-hidden="true"></span>
                        {elseif $payment['method'] == "skrill"}
                          <span class="icon-[tabler--credit-card] size-4.5 text-base-content/60" aria-hidden="true"></span>
                        {elseif $payment['method'] == "bank"}
                          <span class="icon-[tabler--building-bank] size-4.5 text-base-content/60" aria-hidden="true"></span>
                        {else}
                          <span class="icon-[tabler--cash] size-4.5 text-base-content/60" aria-hidden="true"></span>
                        {/if}
                        {if $payment['method'] == "custom"}
                          {$system['wallet_payment_method_custom']}
                        {else}
                          {$payment['method']|ucfirst}
                        {/if}
                      </span>
                    </td>
                    <td class="max-w-48 truncate" title="{$payment['method_value']}">{$payment['method_value']}</td>
                    <td class="whitespace-nowrap text-base-content/60">
                      <span class="js_moment" data-time="{$payment['time']}">{$payment['time']}</span>
                    </td>
                    <td class="text-end">
                      {if $payment['status'] == '0'}
                        <span class="badge badge-soft badge-warning gap-1.5 whitespace-nowrap rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("Pending")}</span>
                      {elseif $payment['status'] == '1'}
                        <span class="badge badge-soft badge-success gap-1.5 whitespace-nowrap rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("Approved")}</span>
                      {else}
                        <span class="badge badge-soft badge-error gap-1.5 whitespace-nowrap rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("Declined")}</span>
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
    <!-- payments -->

  {/if}

</div>
<!-- page content -->

{include file='_footer.tpl'}
