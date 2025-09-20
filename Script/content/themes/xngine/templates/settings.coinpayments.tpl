<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("CoinPayments Transactions")}
	</div>
</div>

<div class="p-3 pt-1">
	<div class="heading-small mb-1">
		{__("Transactions History")}
	</div>

    {if $coinpayments_transactions}
		<div class="table-responsive">
			<table class="table table-hover align-middle">
				<thead>
					<tr>
						<th class="fw-semibold bg-transparent">{__("ID")}</th>
						<th class="fw-semibold bg-transparent">{__("Product")}</th>
						<th class="fw-semibold bg-transparent">{__("Amount")}</th>
						<th class="fw-semibold bg-transparent">{__("Created")}</th>
						<th class="fw-semibold bg-transparent">{__("Updated")}</th>
						<th class="fw-semibold bg-transparent">{__("Status")}</th>
						<th class="fw-semibold bg-transparent">{__("Status Message")}</th>
					</tr>
				</thead>
				<tbody>
					{foreach $coinpayments_transactions as $transaction}
						<tr>
							<td class="bg-transparent">{$transaction@iteration}</td>
							<td class="bg-transparent">{$transaction['product']}</td>
							<td class="bg-transparent">{print_money($transaction['amount'])}</td>
							<td class="bg-transparent">
								<span class="js_moment" data-time="{$transaction['created_at']}">{$transaction['created_at']}</span>
							</td>
							<td class="bg-transparent">
								<span class="js_moment" data-time="{$transaction['last_update']}">{$transaction['last_update']}</span>
							</td>
							<td class="bg-transparent">
								{if $transaction['status'] == '-1'}
									<span class="badge rounded-pill bg-danger">{__("Error")}</span>
								{elseif $transaction['status'] == '0'}
									<span class="badge rounded-pill bg-info">{__("Processing")}</span>
								{elseif $transaction['status'] == '1'}
									<span class="badge rounded-pill bg-warning">{__("Pending")}</span>
								{elseif $transaction['status'] == '2'}
									<span class="badge rounded-pill bg-success">{__("Complete")}</span>
								{/if}
							</td>
							<td class="bg-transparent">
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