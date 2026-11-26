{if $sub_view == ""}
  <div class="card border border-base-300 bg-base-100 shadow-none">
    <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
      <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
        <span class="icon-[tabler--affiliate] size-5"></span>
      </span>
      <div class="min-w-0 grow">
        <h2 class="card-title text-lg">{__("My Affiliates")}</h2>
        <p class="text-sm text-base-content/60">{__("Your referral link and payouts")}</p>
      </div>
      {if $system['affiliates_money_withdraw_enabled'] || $system['affiliates_money_transfer_enabled']}
        <div class="flex w-full gap-2 sm:ms-auto sm:w-auto sm:shrink-0 sm:flex-wrap">
          {if $system['affiliates_money_transfer_enabled']}
            <a class="heroui button button--outline button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/wallet">
              <span class="icon-[tabler--wallet] size-4" aria-hidden="true"></span>
              {__("Wallet")}
            </a>
          {/if}
          {if $system['affiliates_money_withdraw_enabled']}
            <a class="heroui button button--primary button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/settings/affiliates/payments">
              <span class="icon-[tabler--cash] size-4" aria-hidden="true"></span>
              {__("Make a withdrawal")}
            </a>
          {/if}
        </div>
      {/if}
    </div>
    <div class="card-body gap-6 pt-6">
      <!-- affiliates system -->
      <div class="alert alert-info flex items-start gap-3 leading-5" role="alert">
        <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
        <div class="min-w-0 grow">
          <div class="font-medium">{__("Affiliates System")}</div>
          <p class="mt-0.5 text-sm">
            {if $system['affiliate_type'] == "registration"}
              {__("For each user you will refer")}. {__("You will be paid when")} {__("new user registered")}
            {else}
              {if $system['affiliate_payment_type'] == "fixed"}
                {__("For each user you will refer")}.
              {else}
                {__("From the package or monetized content price of your refered user")}.
              {/if}
              {__("You will be paid when")} {__("new user registered & bought a package or monetized content")}
            {/if}
          </p>
          {if $system['affiliates_money_withdraw_enabled'] || $system['affiliates_money_transfer_enabled']}
            <p class="mt-1 text-sm">
              {if $system['affiliates_money_withdraw_enabled']}
                {__("You can withdraw your money")}
              {/if}
              {if $system['affiliates_money_transfer_enabled']}
                {if $system['affiliates_money_withdraw_enabled']}{__("or")} {/if}
                {__("You can transfer your money to your")} <a class="link link-animated font-medium" href="{$system['system_url']}/wallet">{__("wallet")}</a>
              {/if}
            </p>
          {/if}
        </div>
      </div>
      <!-- affiliates system -->

      <!-- balance -->
      <div class="grid gap-4 sm:grid-cols-2">
        <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-success" aria-hidden="true">
            <span class="icon-[tabler--coin] size-5"></span>
          </span>
          <div class="min-w-0">
            <div class="text-sm text-base-content/60">{__("Affiliates Money Balance")}</div>
            <div class="truncate text-xl font-semibold" title="{print_money($user->_data['user_affiliate_balance'])}">{print_money($user->_data['user_affiliate_balance'])}</div>
          </div>
        </div>
        <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-primary" aria-hidden="true">
            <span class="icon-[tabler--users] size-5"></span>
          </span>
          <div class="min-w-0">
            <div class="text-sm text-base-content/60">{__("Affiliates")}</div>
            <div class="truncate text-xl font-semibold" title="{count($affiliates)}{if count($affiliates) >= $system['max_results']}+{/if}">{count($affiliates)}{if count($affiliates) >= $system['max_results']}+{/if}</div>
          </div>
        </div>
      </div>
      <!-- balance -->

      <!-- affiliate link -->
      <div class="flex flex-col gap-4 rounded-xl border border-base-300 p-4 sm:p-5">
        <div class="w-full">
          <label class="label-text mb-1.5 block" for="affiliate-link">{__("Your affiliate link is")}</label>
          {include file='__copy_input.tpl' _id="affiliate-link" _value="{$system['system_url']}/?ref={$user->_data['user_name']}"}
        </div>
        <div class="flex flex-wrap items-center gap-3 border-t border-base-300 pt-4">
          <span class="text-sm font-medium">{__("Share")}</span>
          <div class="flex flex-wrap items-center gap-2">
            {include file='__social_share.tpl' _link="{$system['system_url']}/?ref={$user->_data['user_name']}"}
          </div>
        </div>
      </div>
      <!-- affiliate link -->

      <!-- levels -->
      <div class="flex flex-col gap-3">
        <h3 class="text-sm font-semibold">{__("Earn up to")}</h3>
        <div class="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-5">
          {if $system['affiliates_levels'] > 1}{assign var="affiliates_levels" value=$system['affiliates_levels']}{else}{assign var="affiliates_levels" value=1}{/if}
          {for $level=1 to $affiliates_levels}
            <div class="flex flex-col gap-1 rounded-xl border border-base-300 p-3{if $level == 1} max-sm:col-span-2{/if}">
              <span class="text-xs text-base-content/60">{__("Level %s")|replace:'%s':$level}</span>
              <span class="text-base font-semibold">
                {if $system['affiliate_type'] == "registration" || $system['affiliate_payment_type'] == "fixed"}
                  {if $level == 1}{print_money($system['affiliates_per_user'])}{else}{print_money($system["affiliates_per_user_`$level`"])}{/if}
                {else}
                  {if $level == 1}{$system['affiliates_percentage']}{else}{$system["affiliates_percentage_`$level`"]}{/if}%
                {/if}
              </span>
            </div>
          {/for}
        </div>
      </div>
      <!-- levels -->

      <!-- affiliates -->
      <div class="flex flex-col gap-3">
        <h3 class="text-sm font-semibold">{__("My Affiliates")}</h3>
        {if count($affiliates) > 0}
          <ul class="flex flex-col gap-1">
            {foreach $affiliates as $_user}
              {include file='__feeds_user.tpl' _tpl="list" _connection=$_user["connection"]}
            {/foreach}
          </ul>
        {else}
          <div class="flex flex-col items-center justify-center gap-2 rounded-xl border border-dashed border-base-300 px-6 py-10 text-center">
            <span class="icon-[tabler--users] size-8 text-base-content/40" aria-hidden="true"></span>
            <p class="text-sm text-base-content/60">{__("No affiliates")}</p>
          </div>
        {/if}

        <!-- see-more -->
        {if count($affiliates) >= $system['max_results']}
          <div class="see-more js_see-more flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-uid="{$user->_data['user_id']}" data-get="affiliates">
            <span>{__("See More")}</span>
            <div class="loading loading-spinner loading-sm hidden"></div>
          </div>
        {/if}
        <!-- see-more -->
      </div>
      <!-- affiliates -->
    </div>
  </div>
{elseif $sub_view == "payments"}
  <div class="flex flex-col gap-6">
    <div class="card border border-base-300 bg-base-100 shadow-none">
      <form class="js_ajax-forms" data-url="users/withdraw.php?type=affiliates">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--cash]" _title=__("Withdrawal Request") _text=__("Your referral link and payouts")}
        <div class="card-body gap-6 pt-6">
          <!-- balance -->
          <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-success" aria-hidden="true">
              <span class="icon-[tabler--coin] size-5"></span>
            </span>
            <div class="min-w-0">
              <div class="text-sm text-base-content/60">{__("Your Balance")}</div>
              <div class="truncate text-xl font-semibold" title="{print_money($user->_data['user_affiliate_balance'])}">{print_money($user->_data['user_affiliate_balance'])}</div>
            </div>
          </div>
          <!-- balance -->

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="affiliates-amount">{__("Amount")} ({$system['system_currency']})</label>
            <input type="text" class="input w-full" id="affiliates-amount" name="amount" inputmode="decimal">
            <p class="helper-text">{__("The minimum withdrawal request amount is")} {print_money($system['affiliates_min_withdrawal'])}</p>
          </div>

          <div class="flex flex-col gap-1.5">
            <span class="label-text">{__("Payment Method")}</span>
            <div class="grid gap-3 sm:grid-cols-2">
              {if in_array("paypal", $system['affiliate_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_paypal">
                  <input type="radio" name="method" id="method_paypal" value="paypal" class="radio radio-primary">
                  <span class="icon-[tabler--brand-paypal] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__("PayPal")}</span>
                </label>
              {/if}
              {if in_array("skrill", $system['affiliate_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_skrill">
                  <input type="radio" name="method" id="method_skrill" value="skrill" class="radio radio-primary">
                  <span class="icon-[tabler--credit-card] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__("Skrill")}</span>
                </label>
              {/if}
              {if in_array("bank", $system['affiliate_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_bank">
                  <input type="radio" name="method" id="method_bank" value="bank" class="radio radio-primary">
                  <span class="icon-[tabler--building-bank] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__("Bank Transfer")}</span>
                </label>
              {/if}
              {if in_array("custom", $system['affiliate_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_custom">
                  <input type="radio" name="method" id="method_custom" value="custom" class="radio radio-primary">
                  <span class="icon-[tabler--cash] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__($system['affiliate_payment_method_custom'])}</span>
                </label>
              {/if}
            </div>
          </div>

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="affiliates-method-value">{__("Transfer To")}</label>
            <input type="text" class="input w-full" id="affiliates-method-value" name="method_value">
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
                        {$system['affiliate_payment_method_custom']}
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
{/if}
