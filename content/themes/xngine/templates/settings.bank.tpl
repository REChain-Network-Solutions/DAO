<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Bank Transfers")}
	</div>
</div>

<div class="p-3 pt-1">
	<div class="heading-small mb-1">
		{__("Transactions History")}
	</div>

    {if $transfers}
		<div class="table-responsive">
			<table class="table table-hover align-middle">
				<thead>
					<tr>
						<th class="fw-semibold bg-transparent">{__("ID")}</th>
						<th class="fw-semibold bg-transparent">{__("Type")}</th>
						<th class="fw-semibold bg-transparent">{__("Time")}</th>
						<th class="fw-semibold bg-transparent">{__("Status")}</th>
					</tr>
				</thead>
				<tbody>
					{foreach $transfers as $transfer}
						<tr>
							<td class="bg-transparent">{$transfer@iteration}</td>
							<td class="bg-transparent">
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
							<td class="bg-transparent">
								<span class="js_moment" data-time="{$transfer['time']}">{$transfer['time']}</span>
							</td>
							<td class="bg-transparent">
								{if $transfer['status'] == '0'}
									<span class="badge rounded-pill bg-warning">{__("Pending")}</span>
								{elseif $transfer['status'] == '1'}
									<span class="badge rounded-pill bg-success">{__("Approved")}</span>
								{else}
									<span class="badge rounded-pill bg-danger">{__("Declined")}</span>
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