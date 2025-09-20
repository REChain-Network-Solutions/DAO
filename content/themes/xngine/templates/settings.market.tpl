<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Marketplace")}
	</div>
</div>

<div class="p-3 pt-1">
	<div class="alert alert-secondary">
		<div class="text">
			{if $system['market_money_withdraw_enabled']}
				{__("You can withdraw your money")}
			{/if}
			{if $system['market_money_transfer_enabled']}
				{if $system['market_money_withdraw_enabled']}{__("or")} {/if}
				{__("You can transfer your money to your")} <a class="alert-link" href="{$system['system_url']}/wallet" target="_blank"> {__("wallet")}</a>
			{/if}
		</div>
	</div>

	{if $system['market_money_withdraw_enabled']}
		<div class="heading-small mb-1">
			{__("Withdrawal Request")}
		</div>

		<form class="js_ajax-forms" data-url="users/withdraw.php?type=market">
			<div class="row form-group mb-2">
				<label class="col-md-3 form-label fw-medium">
					{__("Your Balance")}
				</label>
				<div class="col-md-9">
					<h6>
						<span class="badge badge-lg bg-success fw-medium">
							{print_money($user->_data['user_market_balance']|number_format:2)}
						</span>
					</h6>
				</div>
			</div>

			<div class="row form-group mb-2">
				<label class="col-md-3 form-label fw-medium">
					{__("Amount")} ({$system['system_currency']})
				</label>
				<div class="col-md-9">
					<input type="text" class="form-control" name="amount">
					<div class="form-text">
						{__("The minimum withdrawal request amount is")} {print_money($system['market_min_withdrawal'])}
					</div>
				</div>
			</div>

			<div class="row form-group">
				<label class="col-md-3 form-label fw-medium">
					{__("Payment Method")}
				</label>
				<div class="col-md-9">
					{if in_array("paypal", $system['market_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_paypal" value="paypal" class="form-check-input">
							<label class="form-check-label" for="method_paypal">{__("PayPal")}</label>
						</div>
					{/if}
					{if in_array("skrill", $system['market_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_skrill" value="skrill" class="form-check-input">
							<label class="form-check-label" for="method_skrill">{__("Skrill")}</label>
						</div>
					{/if}
					{if in_array("moneypoolscash", $system['market_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_moneypoolscash" value="moneypoolscash" class="form-check-input">
							<label class="form-check-label" for="method_moneypoolscash">{__("MoneyPoolsCash")}</label>
						</div>
					{/if}
					{if in_array("bank", $system['market_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_bank" value="bank" class="form-check-input">
							<label class="form-check-label" for="method_bank">{__("Bank Transfer")}</label>
						</div>
					{/if}
					{if in_array("custom", $system['market_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_custom" value="custom" class="form-check-input">
							<label class="form-check-label" for="method_custom">{__($system['market_payment_method_custom'])}</label>
						</div>
					{/if}
				</div>
			</div>

			<div class="row form-group mb-4">
				<label class="col-md-3 form-label fw-medium">
					{__("Transfer To")}
				</label>
				<div class="col-md-9">
					<input type="text" class="form-control" name="method_value">
				</div>
			</div>

			<div class="row">
				<div class="col-md-9 offset-md-3">
					<button type="submit" class="btn btn-primary">{__("Make a withdrawal")}</button>
				</div>
			</div>

			<!-- success -->
			<div class="alert alert-success mt15 mb0 x-hidden"></div>
			<!-- success -->

			<!-- error -->
			<div class="alert alert-danger mt15 mb0 x-hidden"></div>
			<!-- error -->
		</form>
		
		<hr class="mt-4">

		<div class="heading-small mb-1">
			{__("Withdrawal History")}
		</div>
		{if $payments}
			<div class="table-responsive">
				<table class="table table-hover align-middle">
					<thead>
						<tr>
							<th class="fw-semibold bg-transparent">{__("ID")}</th>
							<th class="fw-semibold bg-transparent">{__("Amount")}</th>
							<th class="fw-semibold bg-transparent">{__("Method")}</th>
							<th class="fw-semibold bg-transparent">{__("Transfer To")}</th>
							<th class="fw-semibold bg-transparent">{__("Time")}</th>
							<th class="fw-semibold bg-transparent">{__("Status")}</th>
						</tr>
					</thead>
					<tbody>
						{foreach $payments as $payment}
							<tr>
								<td class="bg-transparent">{$payment@iteration}</td>
								<td class="bg-transparent">{print_money($payment['amount']|number_format:2)}</td>
								<td class="bg-transparent">
									{if $payment['method'] == "custom"}
										{$system['affiliate_payment_method_custom']}
									{else}
										{$payment['method']|ucfirst}
									{/if}
								</td>
								<td class="bg-transparent">{$payment['method_value']}</td>
								<td class="bg-transparent">
									<span class="js_moment" data-time="{$payment['time']}">{$payment['time']}</span>
								</td>
								<td class="bg-transparent">
									{if $payment['status'] == '0'}
										<span class="badge rounded-pill bg-warning">{__("Pending")}</span>
									{elseif $payment['status'] == '1'}
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

	{else}
		<div class="stat-panel bg-success bg-opacity-10">
			<div class="stat-cell narrow">
				<div class="">{__("Your Market Balance")}</div>
				<div class="h3 m-0 mt-2">{print_money($user->_data['user_market_balance']|number_format:2)}</div>
			</div>
		</div>
	{/if}
</div>