{* PAYMENTS & MONETIZATION MODULE *}

{if $sub_view == ""}
  <section class="admin-settings-page" aria-labelledby="admin-affiliates-title">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-affiliates-title" class="text-2xl font-semibold">{__("Affiliates Settings")}</h1>
      <p class="text-base-content/60 text-sm">{__("Referral levels, payouts, and withdrawal methods.")}</p>
    </div>

    <div class="admin-settings-panel js_admin-settings-panel" role="tabpanel" tabindex="0">
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=affiliates">
        <div class="admin-settings-layout block">
          <div class="admin-settings-form flex min-w-0 flex-col gap-4">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6">
                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="affiliates" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="affiliates_enabled">{__("Affiliates Enabled")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="affiliates_enabled-help">{__("Enable or Disable the affiliates system")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="affiliates_enabled" id="affiliates_enabled" {if $system['affiliates_enabled']}checked{/if} aria-describedby="affiliates_enabled-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="withdrawal" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="affiliates_money_withdraw_enabled">{__("Users Can Withdraw Earned Money")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="affiliates_money_withdraw_enabled-help">{__("If enabled users will be able to withdraw earned money")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="affiliates_money_withdraw_enabled" id="affiliates_money_withdraw_enabled" {if $system['affiliates_money_withdraw_enabled']}checked{/if} aria-describedby="affiliates_money_withdraw_enabled-help">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="affiliates-payment-method-label">
                  <div class="label-text" id="affiliates-payment-method-label">{__("Payment Method")}</div>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                      <input type="checkbox" class="checkbox checkbox-primary" name="method_paypal" id="method_paypal" {if in_array("paypal", $system['affiliate_payment_method_array'])}checked{/if}>
                      <label class="label-text" for="method_paypal">{__("PayPal")}</label>
                    </div>
                    <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                      <input type="checkbox" class="checkbox checkbox-primary" name="method_skrill" id="method_skrill" {if in_array("skrill", $system['affiliate_payment_method_array'])}checked{/if}>
                      <label class="label-text" for="method_skrill">{__("Skrill")}</label>
                    </div>
                    <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                      <input type="checkbox" class="checkbox checkbox-primary" name="method_bank" id="method_bank" {if in_array("bank", $system['affiliate_payment_method_array'])}checked{/if}>
                      <label class="label-text" for="method_bank">{__("Bank Transfer")}</label>
                    </div>
                    <div class="admin-settings-choice my-1 flex items-start gap-2.5" id="js_custome-withdrawal">
                      <input type="checkbox" class="checkbox checkbox-primary" name="method_custom" id="method_custom" {if in_array("custom", $system['affiliate_payment_method_array'])}checked{/if}>
                      <label class="label-text" for="method_custom">{__("Custom Method")}</label>
                    </div>
                    <div class="admin-setting-help text-sm leading-relaxed">{__("Users can send withdrawal requests via any of these methods")}</div>
                  </div>
                </div>

                <div id="js_custome-withdrawal-name" {if !in_array("custom", $system['affiliate_payment_method_array'])}class="hidden"{/if}>
                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                    <label class="label-text" for="affiliate_payment_method_custom">{__("Custom Method Name")}</label>
                    <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                      <input type="text" class="input w-full" name="affiliate_payment_method_custom" id="affiliate_payment_method_custom" value="{$system['affiliate_payment_method_custom']}" aria-describedby="affiliate_payment_method_custom-help">
                      <div id="affiliate_payment_method_custom-help" class="admin-setting-help text-sm leading-relaxed">{__("Set the name of your custom withdrawal payment method")}</div>
                    </div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="affiliates_min_withdrawal">{__("Minimum Withdrawal Request")} ({$system['system_currency']})</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="affiliates_min_withdrawal" id="affiliates_min_withdrawal" value="{$system['affiliates_min_withdrawal']}" aria-describedby="affiliates_min_withdrawal-help" inputmode="decimal">
                    <div id="affiliates_min_withdrawal-help" class="admin-setting-help text-sm leading-relaxed">{__("The minimum amount of money so user can send a withdrawal request")}</div>
                  </div>
                </div>

                {if $licence_monetization && $licence_module_installed}
                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon">
                      {include file='__svg_icons.tpl' icon="wallet" class="admin-setting-glyph" width="32px" height="32px"}
                    </div>
                    <div>
                      <label class="admin-setting-label block text-sm font-medium leading-normal" for="affiliates_money_transfer_enabled">{__("Users Can Transfer Earned Money To Wallet")}</label>
                      <div class="admin-setting-help text-sm leading-relaxed" id="affiliates_money_transfer_enabled-help">
                        {__("If wallet enabled users will be able to transfer earned money to their wallet")}<br>
                        {__("Make sure you have enabled")} <a href="{$system['system_url']}/{$control_panel['url']}/wallet">{__("Wallet System")}</a>
                      </div>
                    </div>
                    <div class="text-end">
                      <input type="checkbox" class="switch switch-primary" name="affiliates_money_transfer_enabled" id="affiliates_money_transfer_enabled" {if $system['affiliates_money_transfer_enabled']}checked{/if} aria-describedby="affiliates_money_transfer_enabled-help">
                    </div>
                  </div>
                {else}
                  {include file='__licence_lock.tpl' _mini=true _title={__("Wallet Transfer")}}
                {/if}

                {if $system['activation_enabled']}
                  <div class="alert alert-warning" role="status">
                    <div class="min-w-0 flex-1">
                      <strong class="block">{__("Account Activation Enabled")}</strong>
                      <span class="mt-0.5 block font-normal">{__("Affiliate earning will not be counted unless the new user activated his account")}.</span>
                    </div>
                  </div>
                {/if}

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="affiliate_type">{__("User Earn Money When")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <select class="select w-full" name="affiliate_type" id="affiliate_type" aria-describedby="affiliate_type-help">
                      <option {if $system['affiliate_type'] == "registration"}selected{/if} value="registration">{__("New User Registered")}</option>
                      <option {if $system['affiliate_type'] == "packages"}selected{/if} value="packages">{__("New User Registered & Bought Pro Package Or Monetized Content")}</option>
                    </select>
                    <div id="affiliate_type-help" class="admin-setting-help text-sm leading-relaxed">{__("Note: Monetized content means subscription packages & paid posts")}.</div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="affiliates_levels">{__("Affiliates Levels")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <select class="select w-full js_affiliates-levels" name="affiliates_levels" id="affiliates_levels" aria-describedby="affiliates_levels-help">
                      {for $level=1 to 10}
                        <option {if $system['affiliates_levels'] == $level}selected{/if} value="{$level}">{$level}</option>
                      {/for}
                    </select>
                    <div id="affiliates_levels-help" class="admin-setting-help text-sm leading-relaxed">{__("How many levels you want to set your affiliates program?")}</div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="affiliate-payment-type-label">
                  <div class="label-text" id="affiliate-payment-type-label">{__("Payment Type")}</div>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                      <input type="radio" class="radio radio-primary" name="affiliate_payment_type" id="affiliate_fixed" value="fixed" {if $system['affiliate_payment_type'] == "fixed"}checked{/if}>
                      <label class="label-text" for="affiliate_fixed">{__("Fixed Price/Referred")}</label>
                    </div>
                    <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                      <input type="radio" class="radio radio-primary" name="affiliate_payment_type" id="affiliate_percentage" value="percentage" {if $system['affiliate_payment_type'] == "percentage"}checked{/if}>
                      <label class="label-text" for="affiliate_percentage">{__("Percentage")} (%)</label>
                    </div>
                    <div class="admin-setting-help text-sm leading-relaxed">{__("Percentage will work only with pro packages & monetized content")}</div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="affiliate-payment-to-label">
                  <div class="label-text" id="affiliate-payment-to-label">{__("Pay The Referrer Who")}</div>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                      <input type="radio" class="radio radio-primary" name="affiliate_payment_to" id="pay_buyer" value="buyer" {if $system['affiliate_payment_to'] == "buyer"}checked{/if}>
                      <label class="label-text" for="pay_buyer">{__("Invited The Buyer")}</label>
                    </div>
                    <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                      <input type="radio" class="radio radio-primary" name="affiliate_payment_to" id="pay_seller" value="seller" {if $system['affiliate_payment_to'] == "seller"}checked{/if}>
                      <label class="label-text" for="pay_seller">{__("Invited The Seller")}</label>
                    </div>
                    <div class="admin-setting-help text-sm leading-relaxed">{__("You can select who will get the money, The referrer who invited the buyer or the referrer who invited the seller")} ({__("Note: This will work only with monetized content")})</div>
                  </div>
                </div>

                {include file='_affiliates_levels.tpl' _affiliate=$system _editor=1}
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
{elseif $sub_view == "payments"}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-affiliates-payments-title">
    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-affiliates-payments-title" class="text-2xl font-semibold">
          {__("Payment Requests")}
          {capture assign="_tip"}{__("You will need to make the payments from your Skrill, Bank Account... etc")}. {__("After making the payment you can mark the payment request as paid")}.{/capture}
          {include file='__admin_tip.tpl' _tip_id="admin-affiliates-payments-tip" _tip_text=$_tip}
        </h1>
        <p class="text-base-content/60 text-sm">{__("Review pending affiliate withdrawal requests.")}</p>
      </div>
    </header>

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
                <th>{__("Referrals")}</th>
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
                  <td>
                    <button type="button" class="js_modal btn btn-text btn-sm" data-url="admin/referrals.php?user_id={$row['user_id']}">{__("Show")}</button>
                  </td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="affiliates-payment-actions-{$row['payment_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} #{$row['payment_id']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="affiliates-payment-actions-{$row['payment_id']}">
                        <li>
                          <button type="button" class="dropdown-item px-2 js_admin-withdraw" role="menuitem" data-type="affiliates" data-handle="approve" data-id="{$row['payment_id']}">
                            <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
                            {__("Mark as Paid")}
                          </button>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-withdraw" role="menuitem" data-type="affiliates" data-handle="decline" data-id="{$row['payment_id']}">
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
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-affiliates-payments-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--users-group] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-affiliates-payments-empty-title">{__("No payment requests")}</h2>
        <p>{__("Pending withdrawal requests will appear here.")}</p>
      </section>
    {/if}
  </section>
{/if}
