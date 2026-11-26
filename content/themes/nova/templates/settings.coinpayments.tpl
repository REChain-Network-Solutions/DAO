<div class="card border border-base-300 bg-base-100 shadow-none">
  {include file='__settings_card_header.tpl' _icon="icon-[tabler--currency-bitcoin]" _title=__("CoinPayments") _text=__("Crypto deposits")}
  <div class="card-body gap-6 pt-6">
    {if $coinpayments_transactions}
      <h3 class="text-sm font-semibold">{__("Transactions History")}</h3>
      <div class="overflow-x-auto">
        <table class="table">
          <thead>
            <tr>
              <th>{__("ID")}</th>
              <th>{__("Product")}</th>
              <th>{__("Amount")}</th>
              <th>{__("Created")}</th>
              <th>{__("Updated")}</th>
              <th>{__("Status")}</th>
              <th>{__("Status Message")}</th>
            </tr>
          </thead>
          <tbody>
            {foreach $coinpayments_transactions as $transaction}
              <tr>
                <td>{$transaction@iteration}</td>
                <td>{$transaction['product']}</td>
                <td>{print_money($transaction['amount'])}</td>
                <td>
                  <span class="js_moment" data-time="{$transaction['created_at']}">{$transaction['created_at']}</span>
                </td>
                <td>
                  <span class="js_moment" data-time="{$transaction['last_update']}">{$transaction['last_update']}</span>
                </td>
                <td>
                  {if $transaction['status'] == '-1'}
                    <span class="badge badge-soft rounded-full badge-lg badge-error">{__("Error")}</span>
                  {elseif $transaction['status'] == '0'}
                    <span class="badge badge-soft rounded-full badge-lg badge-primary">{__("Processing")}</span>
                  {elseif $transaction['status'] == '1'}
                    <span class="badge badge-soft rounded-full badge-lg badge-warning">{__("Pending")}</span>
                  {elseif $transaction['status'] == '2'}
                    <span class="badge badge-soft rounded-full badge-lg badge-success">{__("Complete")}</span>
                  {/if}
                </td>
                <td>
                  {if $transaction['status'] == '-1'}
                    {__("Error while processing your payment")}
                  {else}
                    {$transaction['status_message']}
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
