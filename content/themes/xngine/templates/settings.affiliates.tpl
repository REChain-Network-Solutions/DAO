<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Affiliates")}
	</div>
</div>

<div class="p-3 pt-1">
	{if $sub_view == ""}
		<div class="text">
			<p>
				{__("Earn up to")}
				{if $system['affiliate_type'] == "registration"}
					{print_money($system['affiliates_per_user']|number_format:2)} ({__("Level 1")})
					{if $system['affiliates_levels'] >= 2}
						, {print_money($system['affiliates_per_user_2']|number_format:2)} ({__("Level 2")})
					{/if}
					{if $system['affiliates_levels'] >= 3}
						, {print_money($system['affiliates_per_user_3']|number_format:2)} ({__("Level 3")})
					{/if}
					{if $system['affiliates_levels'] >= 4}
						, {print_money($system['affiliates_per_user_4']|number_format:2)} ({__("Level 4")})
					{/if}
					{if $system['affiliates_levels'] >= 5}
						, {print_money($system['affiliates_per_user_5']|number_format:2)} ({__("Level 5")})
					{/if}
					{__("For each user you will refer")}.<br>
					{__("You will be paid when")} {__("new user registered")}
				{else}
					{if $system['affiliate_payment_type'] == "fixed"}
						{print_money($system['affiliates_per_user']|number_format:2)} ({__("Level 1")})
						{if $system['affiliates_levels'] >= 2}
						  , {print_money($system['affiliates_per_user_2']|number_format:2)} ({__("Level 2")})
						{/if}
						{if $system['affiliates_levels'] >= 3}
						  ,{print_money($system['affiliates_per_user_3']|number_format:2)} ({__("Level 3")})
						{/if}
						{if $system['affiliates_levels'] >= 4}
						  , {print_money($system['affiliates_per_user_4']|number_format:2)} ({__("Level 4")})
						{/if}
						{if $system['affiliates_levels'] >= 5}
						  , {print_money($system['affiliates_per_user_5']|number_format:2)} ({__("Level 5")})
						{/if}
						{__("For each user you will refer")}.<br>
					{else}
						{$system['affiliates_percentage']}% ({__("Level 1")})
						{if $system['affiliates_levels'] >= 2}
						, {$system['affiliates_percentage_2']}% ({__("Level 2")})
						{/if}
						{if $system['affiliates_levels'] >= 3}
						, {$system['affiliates_percentage_3']}% ({__("Level 3")})
						{/if}
						{if $system['affiliates_levels'] >= 4}
						, {$system['affiliates_percentage_4']}% ({__("Level 4")})
						{/if}
						{if $system['affiliates_levels'] >= 5}
						, {$system['affiliates_percentage_5']}% ({__("Level 5")})
						{/if}
						{__("From the package or monetized content price of your refered user")}.<br>
					{/if}
					{__("You will be paid when")} {__("new user registered & bought a package or monetized content")}
				{/if}
			</p>
			{if $system['affiliates_money_withdraw_enabled']}
				{__("You can withdraw your money")}
			{/if}
			{if $system['affiliates_money_transfer_enabled']}
				{if $system['affiliates_money_withdraw_enabled']}{__("or")} {/if}
				{__("You can transfer your money to your")} <a class="alert-link" href="{$system['system_url']}/wallet" target="_blank">{__("wallet")}</a>
			{/if}
		</div>
		
		<hr>
		
		<div class="d-flex align-items-center gap-2">
			<div class="form-floating flex-1 m-0">
				<input type="text" disabled class="form-control" value="{$system['system_url']}/?ref={$user->_data['user_name']}" placeholder=" ">
				<label class="">{__("Your affiliate link is")}</label>
			</div>
			<button data-bs-toggle="tooltip" title='{__("Copy")}' class="btn btn-gray border-0 p-2 rounded-circle lh-1 flex-0 js_clipboard" data-clipboard-text="{$system['system_url']}/?ref={$user->_data['user_name']}">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="m-1"><path d="M9 15C9 12.1716 9 10.7574 9.87868 9.87868C10.7574 9 12.1716 9 15 9L16 9C18.8284 9 20.2426 9 21.1213 9.87868C22 10.7574 22 12.1716 22 15V16C22 18.8284 22 20.2426 21.1213 21.1213C20.2426 22 18.8284 22 16 22H15C12.1716 22 10.7574 22 9.87868 21.1213C9 20.2426 9 18.8284 9 16L9 15Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M16.9999 9C16.9975 6.04291 16.9528 4.51121 16.092 3.46243C15.9258 3.25989 15.7401 3.07418 15.5376 2.90796C14.4312 2 12.7875 2 9.5 2C6.21252 2 4.56878 2 3.46243 2.90796C3.25989 3.07417 3.07418 3.25989 2.90796 3.46243C2 4.56878 2 6.21252 2 9.5C2 12.7875 2 14.4312 2.90796 15.5376C3.07417 15.7401 3.25989 15.9258 3.46243 16.092C4.51121 16.9528 6.04291 16.9975 9 16.9999" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
			</button>
		</div>
		
		<div class="row">
			<div class="col-md-6 mt-4">
				<div class="heading-small mb-1">
					{__("Share")}
				</div>
				{include file='__social_share.tpl' _link="{$system['system_url']}/?ref%3D{$user->_data['user_name']}"}
			</div>
			<div class="col-md-6 mt-4">
				<div class="stat-panel bg-success bg-opacity-10">
					<div class="stat-cell narrow">
						<div class="">{__("Affiliates Money Balance")}</div>
						<div class="h3 m-0 mt-2">{print_money($user->_data['user_affiliate_balance']|number_format:2)}</div>
					</div>
				</div>
			</div>
		</div>

		<hr>

		{if count($affiliates) > 0}
			<ul>
				{foreach $affiliates as $_user}
					{include file='__feeds_user.tpl' _tpl="list" _connection=$_user["connection"]}
				{/foreach}
			</ul>
		{else}
			<div class="p-3">
				<div class="text-center text-muted py-5">
					<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M7.50337 13.1474C7.21627 13.3013 6.93491 13.4624 6.72814 13.5903C6.23354 13.8795 5.30191 14.4241 4.62889 15.1082C4.19456 15.5497 3.6236 16.2837 3.51733 17.2933C3.48451 17.6051 3.49934 17.9036 3.55304 18.1871C3.60678 18.4709 3.63366 18.6128 3.56186 18.6872C3.49006 18.7616 3.37042 18.7434 3.13114 18.707C2.10732 18.5512 1.41543 17.9931 0.847642 17.3845C0.423078 16.9295 0.203787 16.4061 0.258175 15.8464C0.30924 15.3208 0.59019 14.8976 0.871177 14.5882C1.31466 14.0998 1.96834 13.686 2.35981 13.4381C2.44345 13.3852 2.51514 13.3398 2.57023 13.3029C4.04765 12.3132 5.8097 12.0212 7.45505 12.427C7.84296 12.5226 8.03691 12.5704 8.05406 12.7068C8.0712 12.8431 7.88193 12.9445 7.50337 13.1474Z" fill="currentColor"/><path d="M6.48741 5.28631C6.67712 5.31484 6.77197 5.3291 6.8207 5.4079C6.86944 5.48671 6.83547 5.59136 6.76754 5.80068C6.59386 6.33583 6.5 6.90695 6.5 7.5C6.5 8.73995 6.91032 9.88407 7.60259 10.804C7.73465 10.9795 7.80068 11.0672 7.78033 11.1575C7.75999 11.2478 7.67509 11.2922 7.5053 11.3811C7.05526 11.6167 6.5432 11.75 6 11.75C4.20507 11.75 2.75 10.2949 2.75 8.5C2.75 6.70507 4.20507 5.25 6 5.25C6.16566 5.25 6.32842 5.26239 6.48741 5.28631Z" fill="currentColor"/><path d="M16.4971 13.1474C16.7842 13.3013 17.0655 13.4624 17.2723 13.5903C17.7669 13.8795 18.6985 14.4241 19.3715 15.1082C19.8059 15.5497 20.3768 16.2837 20.4831 17.2933C20.5159 17.6051 20.5011 17.9036 20.4474 18.1871C20.3937 18.4709 20.3668 18.6128 20.4386 18.6872C20.5104 18.7616 20.63 18.7434 20.8693 18.707C21.8931 18.5512 22.585 17.9931 23.1528 17.3845C23.5774 16.9295 23.7967 16.4061 23.7423 15.8464C23.6912 15.3208 23.4102 14.8976 23.1293 14.5882C22.6858 14.0998 22.0321 13.686 21.6406 13.4381C21.557 13.3852 21.4853 13.3398 21.4302 13.3029C19.9528 12.3132 18.1907 12.0212 16.5454 12.427C16.1575 12.5226 15.9635 12.5704 15.9464 12.7068C15.9292 12.8431 16.1185 12.9445 16.4971 13.1474Z" fill="currentColor"/><path d="M16.3978 10.804C16.2657 10.9795 16.1997 11.0672 16.22 11.1575C16.2404 11.2478 16.3253 11.2922 16.495 11.3811C16.9451 11.6167 17.4572 11.75 18.0003 11.75C19.7953 11.75 21.2503 10.2949 21.2503 8.5C21.2503 6.70507 19.7953 5.25 18.0003 5.25C17.8347 5.25 17.6719 5.26239 17.5129 5.28631C17.3232 5.31484 17.2284 5.3291 17.1796 5.4079C17.1309 5.48671 17.1649 5.59136 17.2328 5.80068C17.4065 6.33583 17.5003 6.90695 17.5003 7.5C17.5003 8.73995 17.09 9.88407 16.3978 10.804Z" fill="currentColor"/><path d="M7.69146 14.4733C10.3292 12.8422 13.675 12.8422 16.3127 14.4733C16.3905 14.5214 16.489 14.579 16.6022 14.6452L16.6022 14.6452C17.1145 14.945 17.9276 15.4208 18.4826 15.9849C18.8311 16.3391 19.1787 16.8221 19.242 17.4242C19.3099 18.0683 19.0365 18.6646 18.5149 19.1806C17.6533 20.033 16.5859 20.75 15.1865 20.75H8.81773C7.41827 20.75 6.35094 20.033 5.48932 19.1806C4.96775 18.6646 4.69435 18.0683 4.76215 17.4242C4.82553 16.8221 5.17313 16.3391 5.52165 15.9849C6.07655 15.4208 6.88974 14.945 7.40201 14.6452L7.40204 14.6452C7.51521 14.579 7.6137 14.5214 7.69146 14.4733Z" fill="currentColor"/><path d="M7.75177 7.5C7.75177 5.15279 9.65456 3.25 12.0018 3.25C14.349 3.25 16.2518 5.15279 16.2518 7.5C16.2518 9.84721 14.349 11.75 12.0018 11.75C9.65456 11.75 7.75177 9.84721 7.75177 7.5Z" fill="currentColor"/></svg>
					<div class="text-md mt-4">
						<h5 class="headline-font m-0">
							{__("No affiliates")}
						</h5>
					</div>
				</div>
			</div>
		{/if}

		<!-- see-more -->
		{if count($affiliates) >= $system['max_results']}
			<div class="alert alert-info see-more js_see-more" data-uid="{$user->_data['user_id']}" data-get="affiliates">
				<span>{__("See More")}</span>
				<div class="loader loader_small x-hidden"></div>
			</div>
		{/if}
		<!-- see-more -->
		
	{elseif $sub_view == "payments"}
		<div class="heading-small mb-1">
			{__("Withdrawal Request")}
		</div>

		<form class="js_ajax-forms" data-url="users/withdraw.php?type=affiliates">
			<div class="row form-group mb-2">
				<label class="col-md-3 form-label fw-medium">
					{__("Your Balance")}
				</label>
				<div class="col-md-9">
					<h6>
						<span class="badge badge-lg bg-success fw-medium">
							{print_money($user->_data['user_affiliate_balance']|number_format:2)}
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
						{__("The minimum withdrawal request amount is")} {print_money($system['affiliates_min_withdrawal'])}
					</div>
				</div>
			</div>

			<div class="row form-group">
				<label class="col-md-3 form-label fw-medium">
					{__("Payment Method")}
				</label>
				<div class="col-md-9">
					{if in_array("paypal", $system['affiliate_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_paypal" value="paypal" class="form-check-input">
							<label class="form-check-label" for="method_paypal">{__("PayPal")}</label>
						</div>
					{/if}
					{if in_array("skrill", $system['affiliate_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_skrill" value="skrill" class="form-check-input">
							<label class="form-check-label" for="method_skrill">{__("Skrill")}</label>
						</div>
					{/if}
					{if in_array("moneypoolscash", $system['affiliate_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_moneypoolscash" value="moneypoolscash" class="form-check-input">
							<label class="form-check-label" for="method_moneypoolscash">{__("MoneyPoolsCash")}</label>
						</div>
					{/if}
					{if in_array("bank", $system['affiliate_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_bank" value="bank" class="form-check-input">
							<label class="form-check-label" for="method_bank">{__("Bank Transfer")}</label>
						</div>
					{/if}
					{if in_array("custom", $system['affiliate_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_custom" value="custom" class="form-check-input">
							<label class="form-check-label" for="method_custom">{__($system['affiliate_payment_method_custom'])}</label>
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
							<th class="fw-semibold bg-transparent" class="fw-semibold bg-transparent">{__("Amount")}</th>
							<th class="fw-semibold bg-transparent">{__("Method")}</th>
							<th class="fw-semibold bg-transparent">{__("Transfer To")}</th>
							<th class="fw-semibold bg-transparent" class="fw-semibold bg-transparent">{__("Time")}</th>
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
		
	{/if}
</div>