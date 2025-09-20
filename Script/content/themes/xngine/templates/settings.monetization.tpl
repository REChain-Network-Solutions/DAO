<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Monetization")}
	</div>
</div>

<div class="p-3 pt-1">
	{if $sub_view == ""}

		<div class="alert alert-secondary">
			<div class="text">
				<p>{__("Now you can earn money via paid posts, paid chat, paid audio/video calls or subscriptions plans.")}</p>
				{if $system['monetization_commission'] > 0}
					<p>{__("There is commission")} <strong><span class="badge rounded-pill bg-warning">{$system['monetization_commission']}%</span></strong> {__("will be deducted")}.</p>
				{/if}
				{if $system['monetization_money_withdraw_enabled']}
					{__("You can")} <a class="alert-link" href="{$system['system_url']}/settings/monetization/payments" target="_blank">{__("withdraw your money")}</a>
				{/if}
				{if $system['monetization_money_transfer_enabled']}
					{if $system['monetization_money_withdraw_enabled']}{__("or")} {/if}
					{__("You can transfer your money to your")} <a class="alert-link" href="{$system['system_url']}/wallet" target="_blank">{__("wallet")}</a>
				{/if}
			</div>
		</div>

		{if $system['verification_for_monetization'] && !$user->_data['user_verified']}
			<div class="alert alert-danger">
				<div class="text">
					<strong>{__("Account Verification Required")}</strong><br>
					{__("To enable monetization your account must be verified")} <a href="{$system['system_url']}/settings/verification">{__("Verify Now")}</a>
				</div>
			</div>
		{/if}

		<div class="heading-small mb-1">
			{__("Monetization Settings")}
		</div>
		<form class="js_ajax-forms" data-url="users/settings.php?edit=monetization">
			<div class="form-table-row mb-2 pb-1">
				<div>
					<div class="form-label mb-0">{__("Monetization")}</div>
					<div class="form-text d-none d-sm-block mt-0">{__("Enable or disable monetization for your content")}</div>
				</div>
				<div class="text-end align-self-center flex-0">
					<label class="switch" for="user_monetization_enabled">
						<input type="checkbox" name="user_monetization_enabled" id="user_monetization_enabled" {if $user->_data['user_monetization_enabled']}checked{/if}>
						<span class="slider round"></span>
					</label>
				</div>
			</div>
			
			<hr>

			<div class="heading-small mb-1">
				{__("Paid Chat")}
			</div>
            <div class="form-floating">
				<input type="text" class="form-control" name="user_monetization_chat_price" value="{$user->_data['user_monetization_chat_price']}" placeholder=" ">
				<label class="form-label">{__("Chat Message")} ({$system['system_currency']})</label>
				<div class="form-text">
					{__("The price you want to charge for each message sent by the user (0 for free)")}
				</div>
            </div>
            
            <div class="form-floating">
				<input type="text" class="form-control" name="user_monetization_call_price" value="{$user->_data['user_monetization_call_price']}" placeholder=" ">
				<label class="form-label">{__("Audio/Video Call")} ({$system['system_currency']})</label>
				<div class="form-text">
					{__("The price you want to charge for each audio/video call by the user (0 for free)")}
				</div>
            </div>
			
			<hr>

			<div class="heading-small mb-1">
				{__("Subscriptions")}
			</div>
            <label class="form-label">{__("Subscriptions Plans")}</label>
			<div class="row payment-plans">
                <div class="col-md-6 mb-4">
					<div data-toggle="modal" data-url="monetization/controller.php?do=add&node_id={$user->_data['user_id']}&node_type=profile" class="payment-plan new h-100 x_adslist pointer p-3">
						<div class="d-flex align-items-center justify-content-center w-100 h-100 flex-column gap-2 fw-medium">
							<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 3C12.5523 3 13 3.44772 13 4V11H20C20.5523 11 21 11.4477 21 12C21 12.5523 20.5523 13 20 13H13V20C13 20.5523 12.5523 21 12 21C11.4477 21 11 20.5523 11 20V13H4C3.44772 13 3 12.5523 3 12C3 11.4477 3.44772 11 4 11H11V4C11 3.44772 11.4477 3 12 3Z" fill="currentColor"/></svg>
							{__("Add New")}
						</div>
					</div>
				</div>
				{foreach $monetization_plans as $plan}
					<div class="col-md-6 mb-4">
						<div class="payment-plan h-100 x_adslist p-3">
							<div class="h5 mb-1 fw-semibold">{__($plan['title'])}</div>
							<div>{print_money($plan['price'])} / {if $plan['period_num'] != '1'}{$plan['period_num']}{/if} {__($plan['period']|ucfirst)}</div>
							{if {$plan['custom_description']}}
								<div class="small">{$plan['custom_description']}</div>
							{/if}
							<div class="d-flex align-items-center mt-3 gap-2">
								<button type="button" class="btn bg-white flex-1" data-toggle="modal" data-url="monetization/controller.php?do=edit&id={$plan['plan_id']}">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg> {__("Edit")}
								</button>
								<button type="button" class="btn bg-white flex-0 rounded-circle p-2 lh-1 js_monetization-deleter" data-id="{$plan['plan_id']}" title='{__("Delete")}'>
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="m-1"><path d="M19.5 5.5L18.8803 15.5251C18.7219 18.0864 18.6428 19.3671 18.0008 20.2879C17.6833 20.7431 17.2747 21.1273 16.8007 21.416C15.8421 22 14.559 22 11.9927 22C9.42312 22 8.1383 22 7.17905 21.4149C6.7048 21.1257 6.296 20.7408 5.97868 20.2848C5.33688 19.3626 5.25945 18.0801 5.10461 15.5152L4.5 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M3 5.5H21M16.0557 5.5L15.3731 4.09173C14.9196 3.15626 14.6928 2.68852 14.3017 2.39681C14.215 2.3321 14.1231 2.27454 14.027 2.2247C13.5939 2 13.0741 2 12.0345 2C10.9688 2 10.436 2 9.99568 2.23412C9.8981 2.28601 9.80498 2.3459 9.71729 2.41317C9.32164 2.7167 9.10063 3.20155 8.65861 4.17126L8.05292 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M9.5 16.5L9.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M14.5 16.5L14.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
								</button>
							</div>
						</div>
					</div>
                {/foreach}
			</div>

			<div class="text-center">
				<button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
			</div>

			<!-- success -->
			<div class="alert alert-success mt15 mb0 x-hidden"></div>
			<!-- success -->

			<!-- error -->
			<div class="alert alert-danger mt15 mb0 x-hidden"></div>
			<!-- error -->
		</form>

		<hr class="my-4">

		<div class="heading-small mb-1">
			{__("Monetization Balance")}
		</div>
		
		<div class="row">
			<!-- subscribers -->
			<div class="col-lg-6">
				<div class="stat-panel bg-info bg-opacity-10">
					<div class="stat-cell narrow">
						<div class="">{__("Profile Subscribers")}</div>
						<div class="h3 m-0 mt-2">{$subscribers_count}</div>
					</div>
				</div>
			</div>
			<!-- subscribers -->

			<!-- money balance -->
			<div class="col-lg-6">
				<div class="stat-panel bg-success bg-opacity-10">
					<div class="stat-cell narrow">
						<div class="">{__("Monetization Money Balance")}</div>
						<div class="h3 m-0 mt-2">{print_money($user->_data['user_monetization_balance']|number_format:2)}</div>
					</div>
				</div>
			</div>
			<!-- monetization balance -->
		</div>

  {elseif $sub_view == "payments"}
		<div class="heading-small mb-1">
			{__("Withdrawal Request")}
		</div>

		<form class="js_ajax-forms" data-url="users/withdraw.php?type=monetization">
			<div class="row form-group mb-2">
				<label class="col-md-3 form-label fw-medium">
					{__("Your Balance")}
				</label>
				<div class="col-md-9">
					<h6>
						<span class="badge badge-lg bg-success fw-medium">
							{print_money($user->_data['user_monetization_balance']|number_format:2)}
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
						{__("The minimum withdrawal request amount is")} {print_money($system['monetization_min_withdrawal'])}
					</div>
				</div>
			</div>

			<div class="row form-group">
				<label class="col-md-3 form-label fw-medium">
					{__("Payment Method")}
				</label>
				<div class="col-md-9">
					{if in_array("paypal", $system['monetization_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_paypal" value="paypal" class="form-check-input">
							<label class="form-check-label" for="method_paypal">{__("PayPal")}</label>
						</div>
					{/if}
					{if in_array("skrill", $system['monetization_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_skrill" value="skrill" class="form-check-input">
							<label class="form-check-label" for="method_skrill">{__("Skrill")}</label>
						</div>
					{/if}
					{if in_array("moneypoolscash", $system['monetization_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_moneypoolscash" value="moneypoolscash" class="form-check-input">
							<label class="form-check-label" for="method_moneypoolscash">{__("MoneyPoolsCash")}</label>
						</div>
					{/if}
					{if in_array("bank", $system['monetization_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_bank" value="bank" class="form-check-input">
							<label class="form-check-label" for="method_bank">{__("Bank Transfer")}</label>
						</div>
					{/if}
					{if in_array("custom", $system['monetization_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_custom" value="custom" class="form-check-input">
							<label class="form-check-label" for="method_custom">{__($system['monetization_payment_method_custom'])}</label>
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
										{$system['monetization_payment_method_custom']}
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

	{elseif $sub_view == "earnings"}
		<div class="row">
			<div class="col-lg-6">
				<div class="stat-panel bg-success bg-opacity-10">
					<div class="stat-cell narrow">
						<div class="">{__("Total Earnings")}</div>
						<div class="h3 m-0 mt-2">{print_money($total_earnings|number_format:2)}</div>
					</div>
				</div>
			</div>
			<div class="col-lg-6">
				<div class="stat-panel bg-info bg-opacity-10">
					<div class="stat-cell narrow">
						<div class="">{__("This Month Earnings")}</div>
						<div class="h3 m-0 mt-2">{print_money($this_month_earnings|number_format:2)}</div>
					</div>
				</div>
			</div>
		</div>

		<div class="heading-small mb-1">
			{__("History")}
		</div>
		{if $earnings}
			<div class="table-responsive">
				<table class="table table-hover align-middle">
					<thead>
						<tr>
							<th class="fw-semibold bg-transparent">{__("ID")}</th>
							<th class="fw-semibold bg-transparent">{__("User")}</th>
							<th class="fw-semibold bg-transparent">{__("Total")}</th>
							<th class="fw-semibold bg-transparent">{__("Commission")}</th>
							<th class="fw-semibold bg-transparent">{__("Earning")}</th>
							<th class="fw-semibold bg-transparent">{__("Time")}</th>
						</tr>
					</thead>
					<tbody>
						{foreach $earnings as $earning}
							<tr>
								<td class="bg-transparent">{$earning@iteration}</td>
								<td class="bg-transparent">
									<a href="{$system['system_url']}/{$earning['user_name']}">
										<img src="{$earning['user_picture']}" class="rounded-circle" width="30" height="30">
										{$earning['user_fullname']}
									</a>
								</td>
								<td class="bg-transparent">{print_money($earning['price']|number_format:2)}</td>
								<td class="bg-transparent">{print_money($earning['commission']|number_format:2)}</td>
								<td class="bg-transparent">{print_money($earning['earning']|number_format:2)}</td>
								<td class="bg-transparent">
									<span class="js_moment" data-time="{$earning['time']}">{$earning['time']}</span>
								</td>
							</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
		{else}
			{include file='_no_transactions.tpl'}
		{/if}

	{/if}
</div>