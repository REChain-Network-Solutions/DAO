{if $sub_view == ""}
  {if $system['packages_enabled'] && $user->_data['user_subscribed']}
    {assign var="points_limit" value=$system['points_limit_pro']}
  {else}
    {assign var="points_limit" value=$system['points_limit_user']}
  {/if}
  <div class="flex flex-col gap-6">
    <div class="card border border-base-300 bg-base-100 shadow-none">
      <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
        <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
          <span class="icon-[tabler--star] size-5"></span>
        </span>
        <div class="min-w-0 grow">
          <h2 class="card-title text-lg">{__("My Points")}</h2>
          <p class="text-sm text-base-content/60">{__("Balance and rewards")}</p>
        </div>
        {if $system['points_per_currency'] > 0 && ($system['points_money_withdraw_enabled'] || $system['points_money_transfer_enabled'])}
          <div class="flex w-full gap-2 sm:ms-auto sm:w-auto sm:shrink-0 sm:flex-wrap">
            {if $system['points_money_transfer_enabled']}
              <a class="heroui button button--outline button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/wallet">
                <span class="icon-[tabler--wallet] size-4" aria-hidden="true"></span>
                {__("Wallet")}
              </a>
            {/if}
            {if $system['points_money_withdraw_enabled']}
              <a class="heroui button button--primary button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/settings/points/payments">
                <span class="icon-[tabler--cash] size-4" aria-hidden="true"></span>
                {__("Make a withdrawal")}
              </a>
            {/if}
          </div>
        {/if}
      </div>
      <div class="card-body gap-6 pt-6">
        <!-- points system -->
        <div class="alert alert-info flex items-start gap-3 leading-5" role="alert">
          <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
          <div class="min-w-0">
            <div class="font-medium">{__("Points System")}</div>
            <ul class="mt-1 flex list-disc flex-col gap-1 ps-4 text-sm">
              {if $system['points_per_currency'] > 0}
                <li>{__("Each")} <strong>{$system['points_per_currency']}</strong> {__("points equal")} <strong>{print_money("1")}</strong></li>
              {/if}
              <li>{__("Your daily points limit is")} <strong>{$points_limit}</strong> {__("Points")}, {__("You have")} <strong>{$remaining_points}</strong> {__("remaining points")}</li>
              <li>{__("Your daily points limit will be reset after 24 hours from your last valid earned action")}</li>
              {if $system['points_per_currency'] > 0 && ($system['points_money_withdraw_enabled'] || $system['points_money_transfer_enabled'])}
                <li>
                  {if $system['points_money_withdraw_enabled']}
                    {__("You can withdraw your money")}
                  {/if}
                  {if $system['points_money_transfer_enabled']}
                    {if $system['points_money_withdraw_enabled']}{__("or")} {/if}
                    {__("You can transfer your money to your")} <a class="link link-animated font-medium" href="{$system['system_url']}/wallet">{__("wallet")}</a>
                  {/if}
                </li>
              {/if}
            </ul>
          </div>
        </div>
        <!-- points system -->

        <!-- balance -->
        <div class="grid gap-4 {if $system['points_per_currency'] > 0}sm:grid-cols-3{else}sm:grid-cols-2{/if}">
          <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-warning" aria-hidden="true">
              <span class="icon-[tabler--star-filled] size-5"></span>
            </span>
            <div class="min-w-0">
              <div class="text-sm text-base-content/60">{__("Points Balance")}</div>
              <div class="truncate text-xl font-semibold" title="{$user->_data['user_points']}">{$user->_data['user_points']}</div>
            </div>
          </div>
          {if $system['points_per_currency'] > 0}
            <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-success" aria-hidden="true">
                <span class="icon-[tabler--coin] size-5"></span>
              </span>
              <div class="min-w-0">
                <div class="text-sm text-base-content/60">{__("Points Money Balance")}</div>
                <div class="truncate text-xl font-semibold" title="{print_money(((1/$system['points_per_currency'])*$user->_data['user_points']))}">{print_money(((1/$system['points_per_currency'])*$user->_data['user_points']))}</div>
              </div>
            </div>
          {/if}
          <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-primary" aria-hidden="true">
              <span class="icon-[tabler--gauge] size-5"></span>
            </span>
            <div class="min-w-0">
              <div class="text-sm text-base-content/60">{__("remaining points")}</div>
              <div class="truncate text-xl font-semibold" title="{$remaining_points} / {$points_limit}">{$remaining_points} <span class="text-sm font-normal text-base-content/60">/ {$points_limit}</span></div>
            </div>
          </div>
        </div>
        <!-- balance -->

        <!-- earning -->
        {if $system['points_per_post'] > 0 || $system['points_per_post_view'] > 0 || $system['points_per_post_comment'] > 0 || $system['points_per_post_reaction'] > 0 || $system['points_per_comment'] > 0 || $system['points_per_reaction'] > 0 || $system['points_per_follow'] > 0 || $system['points_per_referred'] > 0}
          <div class="grid gap-3 sm:grid-cols-2">
            {if $system['points_per_post'] > 0}
              <div class="flex items-center gap-3 rounded-xl border border-base-300 p-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
                  <span class="icon-[tabler--pencil-plus] size-5"></span>
                </span>
                <p class="min-w-0 grow text-sm">{__("For creating a new post")}</p>
                <span class="badge badge-soft badge-primary rounded-full shrink-0">+{$system['points_per_post']} {__("Points")}</span>
              </div>
            {/if}
            {if $system['points_per_post_view'] > 0}
              <div class="flex items-center gap-3 rounded-xl border border-base-300 p-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
                  <span class="icon-[tabler--eye] size-5"></span>
                </span>
                <p class="min-w-0 grow text-sm">{__("For each post view")}</p>
                <span class="badge badge-soft badge-primary rounded-full shrink-0">+{$system['points_per_post_view']} {__("Points")}</span>
              </div>
            {/if}
            {if $system['points_per_post_comment'] > 0}
              <div class="flex items-center gap-3 rounded-xl border border-base-300 p-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
                  <span class="icon-[tabler--message-circle] size-5"></span>
                </span>
                <p class="min-w-0 grow text-sm">{__("For any comment on your post")}</p>
                <span class="badge badge-soft badge-primary rounded-full shrink-0">+{$system['points_per_post_comment']} {__("Points")}</span>
              </div>
            {/if}
            {if $system['points_per_post_reaction'] > 0}
              <div class="flex items-center gap-3 rounded-xl border border-base-300 p-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
                  <span class="icon-[tabler--heart] size-5"></span>
                </span>
                <p class="min-w-0 grow text-sm">{__("For any reaction on your post")}</p>
                <span class="badge badge-soft badge-primary rounded-full shrink-0">+{$system['points_per_post_reaction']} {__("Points")}</span>
              </div>
            {/if}
            {if $system['points_per_comment'] > 0}
              <div class="flex items-center gap-3 rounded-xl border border-base-300 p-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
                  <span class="icon-[tabler--message-plus] size-5"></span>
                </span>
                <p class="min-w-0 grow text-sm">{__("For commenting any post")}</p>
                <span class="badge badge-soft badge-primary rounded-full shrink-0">+{$system['points_per_comment']} {__("Points")}</span>
              </div>
            {/if}
            {if $system['points_per_reaction'] > 0}
              <div class="flex items-center gap-3 rounded-xl border border-base-300 p-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
                  <span class="icon-[tabler--mood-smile] size-5"></span>
                </span>
                <p class="min-w-0 grow text-sm">{__("For reacting on any post")}</p>
                <span class="badge badge-soft badge-primary rounded-full shrink-0">+{$system['points_per_reaction']} {__("Points")}</span>
              </div>
            {/if}
            {if $system['points_per_follow'] > 0}
              <div class="flex items-center gap-3 rounded-xl border border-base-300 p-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
                  <span class="icon-[tabler--user-plus] size-5"></span>
                </span>
                <p class="min-w-0 grow text-sm">{__("For each follower you got")}</p>
                <span class="badge badge-soft badge-primary rounded-full shrink-0">+{$system['points_per_follow']} {__("Points")}</span>
              </div>
            {/if}
            {if $system['points_per_referred'] > 0}
              <div class="flex items-center gap-3 rounded-xl border border-base-300 p-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
                  <span class="icon-[tabler--affiliate] size-5"></span>
                </span>
                <p class="min-w-0 grow text-sm">{__("For referring user")}</p>
                <span class="badge badge-soft badge-primary rounded-full shrink-0">+{$system['points_per_referred']} {__("Points")}</span>
              </div>
            {/if}
          </div>
        {/if}
        <!-- earning -->
      </div>
    </div>

    <!-- points transactions -->
    <div class="card border border-base-300 bg-base-100 shadow-none">
      {include file='__settings_card_header.tpl' _icon="icon-[tabler--arrows-exchange]" _title=__("Points Transactions")}
      <div class="card-body gap-6 pt-6">
        {if $transactions}
          <div class="[&_.js-flyonui-datatable-toolbar]:px-0 [&_.js-flyonui-datatable-footer]:px-0">
            <table class="table table-zebra min-w-[560px] js_dataTable">
              <thead>
                <tr>
                  <th>{__("ID")}</th>
                  <th>{__("Points")}</th>
                  <th>{__("From / To")}</th>
                  <th>{__("Time")}</th>
                </tr>
              </thead>
              <tbody>
                {foreach $transactions as $transaction}
                  <tr>
                    <td>{$transaction@iteration}</td>
                    <td>
                      {if $transaction['is_added']}
                        <span class="badge badge-soft rounded-full badge-lg badge-success">
                          <span class="icon-[tabler--arrow-up-right] size-4" aria-hidden="true"></span>{$transaction['points']}
                        </span>
                      {else}
                        <span class="badge badge-soft rounded-full badge-lg badge-error">
                          <span class="icon-[tabler--arrow-down-right] size-4" aria-hidden="true"></span>{$transaction['points']}
                        </span>
                      {/if}
                    </td>
                    <td>
                      {if $transaction['node_type'] == "post"}
                        {__("Added Post")}
                      {elseif $transaction['node_type'] == "post_view"}
                        {__("Post View")}
                      {elseif $transaction['node_type'] == "post_comment"}
                        {__("Received Comment")}
                      {elseif $transaction['node_type'] == "post_reaction"}
                        {__("Received Reaction")}
                      {elseif $transaction['node_type'] == "comment"}
                        {__("Added Comment")}
                      {elseif $transaction['node_type'] == "posts_reactions"}
                        {__("Added Post Reaction")}
                      {elseif $transaction['node_type'] == "posts_photos_reactions"}
                        {__("Added Post Photo Reaction")}
                      {elseif $transaction['node_type'] == "posts_comments_reactions"}
                        {__("Added Comment Reaction")}
                      {elseif $transaction['node_type'] == "follow"}
                        {__("Followed")}
                      {elseif $transaction['node_type'] == "referred"}
                        {__("Referred User")}
                      {elseif $transaction['node_type'] == "gift"}
                        {if $transaction['is_added']}
                          {__("Received Gift")}
                        {else}
                          {__("Sent Gift")}
                        {/if}
                      {/if}
                    </td>
                    <td class="text-base-content/60"><span class="js_moment" data-time="{$transaction['time']}">{$transaction['time']}</span></td>
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
    <!-- points transactions -->
  </div>
{elseif $sub_view == "payments"}
  <div class="flex flex-col gap-6">
    <div class="card border border-base-300 bg-base-100 shadow-none">
      <form class="js_ajax-forms" data-url="users/withdraw.php?type=points">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--cash]" _title=__("Withdrawal Request") _text=__("Balance and rewards")}
        <div class="card-body gap-6 pt-6">
          <!-- balance -->
          <div class="grid grid-cols-[auto_minmax(0,1fr)] items-center gap-x-4 gap-y-2 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:flex sm:gap-4 sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-success max-sm:row-span-2" aria-hidden="true">
              <span class="icon-[tabler--coin] size-5"></span>
            </span>
            <div class="min-w-0 grow">
              <div class="text-sm text-base-content/60">{__("Your Balance")}</div>
              <div class="truncate text-xl font-semibold" title="{print_money(((1/$system['points_per_currency'])*$user->_data['user_points']))}">{print_money(((1/$system['points_per_currency'])*$user->_data['user_points']))}</div>
            </div>
            <span class="badge badge-soft rounded-full badge-warning col-start-2 shrink-0 justify-self-start">
              <span class="icon-[tabler--star-filled] size-3.5" aria-hidden="true"></span>{$user->_data['user_points']} {__("Points")}
            </span>
          </div>
          <!-- balance -->

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="points-amount">{__("Amount")} ({$system['system_currency']})</label>
            <input type="text" class="input w-full" id="points-amount" name="amount" inputmode="decimal">
            <p class="helper-text">{__("The minimum withdrawal request amount is")} {print_money($system['points_min_withdrawal'])}</p>
          </div>

          <div class="flex flex-col gap-1.5">
            <span class="label-text">{__("Payment Method")}</span>
            <div class="grid gap-3 sm:grid-cols-2">
              {if in_array("paypal", $system['points_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_paypal">
                  <input type="radio" name="method" id="method_paypal" value="paypal" class="radio radio-primary">
                  <span class="icon-[tabler--brand-paypal] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__("PayPal")}</span>
                </label>
              {/if}
              {if in_array("skrill", $system['points_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_skrill">
                  <input type="radio" name="method" id="method_skrill" value="skrill" class="radio radio-primary">
                  <span class="icon-[tabler--credit-card] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__("Skrill")}</span>
                </label>
              {/if}
              {if in_array("bank", $system['points_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_bank">
                  <input type="radio" name="method" id="method_bank" value="bank" class="radio radio-primary">
                  <span class="icon-[tabler--building-bank] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__("Bank Transfer")}</span>
                </label>
              {/if}
              {if in_array("custom", $system['points_payment_method_array'])}
                <label class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 p-3 has-[:checked]:border-primary" for="method_custom">
                  <input type="radio" name="method" id="method_custom" value="custom" class="radio radio-primary">
                  <span class="icon-[tabler--cash] size-5 shrink-0" aria-hidden="true"></span>
                  <span class="text-sm font-medium">{__($system['points_payment_method_custom'])}</span>
                </label>
              {/if}
            </div>
          </div>

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="points-method-value">{__("Transfer To")}</label>
            <input type="text" class="input w-full" id="points-method-value" name="method_value">
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
                        {$system['points_payment_method_custom']}
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
