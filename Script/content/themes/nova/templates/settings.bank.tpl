<div class="card border border-base-300 bg-base-100 shadow-none">
  {include file='__settings_card_header.tpl' _icon="icon-[tabler--building-bank]" _title=__("Bank Transfers") _text=__("Bank payouts")}
  <div class="card-body gap-6 pt-6">
    {if $transfers}
      <h3 class="text-sm font-semibold">{__("Transactions History")}</h3>
      <div class="overflow-x-auto">
        <table class="table">
          <thead>
            <tr>
              <th>{__("ID")}</th>
              <th>{__("Type")}</th>
              <th>{__("Time")}</th>
              <th>{__("Status")}</th>
            </tr>
          </thead>
          <tbody>
            {foreach $transfers as $transfer}
              <tr>
                <td>{$transfer@iteration}</td>
                <td>
                  {if $transfer['handle'] == "packages"}
                    {__($transfer['package_name'])} {__("Package")} = <strong>{print_money($transfer['package_price'])}</strong>
                  {elseif $transfer['handle'] == "wallet"}
                    {__("Add Wallet Balance")} = <strong>{print_money($transfer['price'])}</strong>
                  {elseif $transfer['handle'] == "donate"}
                    {__("Funding Donation")} = <strong>{print_money($transfer['price'])}</strong>
                  {elseif $transfer['handle'] == "subscribe"}
                    {__("Subscribe")} = <strong>{print_money($transfer['price'])}</strong>
                  {elseif $transfer['handle'] == "paid_post"}
                    {__("Paid Post")} = <strong>{print_money($transfer['price'])}</strong>
                  {elseif $transfer['handle'] == "movies"}
                    {__("Movies")} = <strong>{print_money($transfer['price'])}</strong>
                  {/if}
                </td>
                <td>
                  <span class="js_moment" data-time="{$transfer['time']}">{$transfer['time']}</span>
                </td>
                <td>
                  {if $transfer['status'] == '0'}
                    <span class="badge badge-soft rounded-full badge-lg badge-warning">{__("Pending")}</span>
                  {elseif $transfer['status'] == '1'}
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
