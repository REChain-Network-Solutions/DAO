<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Points")}
	</div>
</div>

<div class="p-3 pt-1">
	{if $sub_view == ""}
		<div class="alert alert-secondary">
			<div class="text">
				{if $system['points_per_currency'] > 0}
					<p>
						{__("Each")} <strong>{$system['points_per_currency']}</strong> {__("points equal")} <strong>{print_money("1")}</strong>.
					</p>
				{/if}
				<p>
					{__("Your daily points limit is")} <strong><span class="badge rounded-pill bg-warning">{if $system['packages_enabled'] && $user->_data['user_subscribed']}{$system['points_limit_pro']}{else}{$system['points_limit_user']}{/if}</span></strong> {__("Points")}, {__("You have")} <strong><span class="badge rounded-pill bg-danger">{$remaining_points}</span></strong> {__("remaining points")}
				</p>
				<p>
					{__("Your daily points limit will be reset after 24 hours from your last valid earned action")}
				</p>
				{if $system['points_per_currency'] > 0 && $system['points_money_withdraw_enabled']}
				  {__("You can withdraw your money")}
				{/if}
				{if $system['points_per_currency'] > 0 && $system['points_money_transfer_enabled']}
					{if $system['points_money_withdraw_enabled']}{__("or")} {/if}
					{__("You can transfer your money to your")} <a class="alert-link" href="{$system['system_url']}/wallet" target="_blank"> {__("wallet")}</a>
				{/if}
			</div>
		</div>

		<div class="row">
			{if $system['points_per_post'] > 0}
				<div class="col-lg-6">
					<div class="stat-panel x_address">
						<div class="stat-cell p-3">
							<i class="fa fa-newspaper icon bg-gradient-success"></i>
							<span class="text-xxlg">{$system['points_per_post']}</span><br>
							<span class="text-lg">{__("Points")}</span><br>
							<span>{__("For creating a new post")}</span>
						</div>
					</div>
				</div>
			{/if}
			{if $system['points_per_post_view'] > 0}
				<div class="col-lg-6">
					<div class="stat-panel x_address">
						<div class="stat-cell p-3">
							<i class="fa fa-eye icon bg-gradient-success"></i>
							<span class="text-xxlg">{$system['points_per_post_view']}</span><br>
							<span class="text-lg">{__("Points")}</span><br>
							<span>{__("For each post view")}</span>
						</div>
					</div>
				</div>
			{/if}
			{if $system['points_per_post_comment'] > 0}
				<div class="col-lg-6">
					<div class="stat-panel x_address">
						<div class="stat-cell p-3">
							<i class="fa fa-comments icon bg-gradient-primary"></i>
							<span class="text-xxlg">{$system['points_per_post_comment']}</span><br>
							<span class="text-lg">{__("Points")}</span><br>
							<span>{__("For any comment on your post")}</span>
						</div>
					</div>
				</div>
			{/if}
			{if $system['points_per_post_reaction'] > 0}
				<div class="col-lg-6">
					<div class="stat-panel x_address">
						<div class="stat-cell p-3">
							<i class="fa fa-smile icon bg-gradient-danger"></i>
							<span class="text-xxlg">{$system['points_per_post_reaction']}</span><br>
							<span class="text-lg">{__("Points")}</span><br>
							<span>{__("For any reaction on your post")}</span>
						</div>
					</div>
				</div>
			{/if}
			{if $system['points_per_comment'] > 0}
				<div class="col-lg-6">
					<div class="stat-panel x_address">
						<div class="stat-cell p-3">
							<i class="fa fa-comments icon bg-gradient-primary"></i>
							<span class="text-xxlg">{$system['points_per_comment']}</span><br>
							<span class="text-lg">{__("Points")}</span><br>
							<span>{__("For commenting any post")}</span>
						</div>
					</div>
				</div>
			{/if}
			{if $system['points_per_reaction'] > 0}
				<div class="col-lg-6">
					<div class="stat-panel x_address">
						<div class="stat-cell p-3">
							<i class="fa fa-smile icon bg-gradient-danger"></i>
							<span class="text-xxlg">{$system['points_per_reaction']}</span><br>
							<span class="text-lg">{__("Points")}</span><br>
							<span>{__("For reacting on any post")}</span>
						</div>
					</div>
				</div>
			{/if}
			{if $system['points_per_follow'] > 0}
				<div class="col-lg-6">
					<div class="stat-panel x_address">
						<div class="stat-cell p-3">
							<i class="fa fa-users icon bg-gradient-warning"></i>
							<span class="text-xxlg">{$system['points_per_follow']}</span><br>
							<span class="text-lg">{__("Points")}</span><br>
							<span>{__("For each follower you got")}</span>
						</div>
					</div>
				</div>
			{/if}
			{if $system['points_per_referred'] > 0}
				<div class="col-lg-6">
					<div class="stat-panel x_address">
						<div class="stat-cell p-3">
							<i class="fa fa-exchange-alt icon bg-gradient-purple"></i>
							<span class="text-xxlg">{$system['points_per_referred']}</span><br>
							<span class="text-lg">{__("Points")}</span><br>
							<span>{__("For referring user")}</span>
						</div>
					</div>
				</div>
			{/if}
		</div>
		
		<hr class="mt-2">

		<div class="row">
			<!-- points balance -->
			<div class="{if $system['points_per_currency'] > 0}col-sm-6{else}col-sm-12{/if}">
				<div class="stat-panel bg-warning bg-opacity-10">
					<div class="stat-cell narrow">
						<div class="">{__("Points Balance")}</div>
						<div class="h3 m-0 mt-2">{$user->_data['user_points']}</div>
					</div>
				</div>
			</div>
			<!-- points balance -->

			<!-- money balance -->
			{if $system['points_per_currency']}
				<div class="col-sm-6">
					<div class="stat-panel bg-success bg-opacity-10">
						<div class="stat-cell narrow">
							<div class="">{__("Points Money Balance")}</div>
							<div class="h3 m-0 mt-2">{print_money(((1/$system['points_per_currency'])*$user->_data['user_points'])|number_format:2)}</div>
						</div>
					</div>
				</div>
			{/if}
			<!-- money balance -->
		</div>
		
		<hr class="mt-2">

		<!-- points transactions -->
		<div class="heading-small mb-1">
			{__("Points Transactions")}
		</div>
		{if $transactions}
			<div class="table-responsive">
				<table class="table table-hover align-middle js_dataTable">
					<thead>
						<tr>
							<th class="fw-semibold bg-transparent">{__("ID")}</th>
							<th class="fw-semibold bg-transparent">{__("Points")}</th>
							<th class="fw-semibold bg-transparent">{__("From")}</th>
							<th class="fw-semibold bg-transparent">{__("Time")}</th>
						</tr>
					</thead>
					<tbody>
						{foreach $transactions as $transaction}
							<tr>
								<td class="bg-transparent">{$transaction@iteration}</td>
								<td class="bg-transparent"><span class="badge rounded-pill bg-light text-primary">{$transaction['points']}</span></td>
								<td class="bg-transparent">
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
									{/if}
								</td>
								<td class="bg-transparent"><span class="js_moment" data-time="{$transaction['time']}">{$transaction['time']}</span></td>
							</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
		{else}
			{include file='_no_transactions.tpl'}
		{/if}

		<!-- points transactions -->
		
	{elseif $sub_view == "payments"}
	
		<div class="heading-small mb-1">
			{__("Withdrawal Request")}
		</div>

		<form class="js_ajax-forms" data-url="users/withdraw.php?type=points">
			<div class="row form-group mb-2">
				<label class="col-md-3 form-label fw-medium">
					{__("Your Balance")}
				</label>
				<div class="col-md-9">
					<h6>
						<span class="badge badge-lg bg-success fw-medium">
							{print_money(((1/$system['points_per_currency'])*$user->_data['user_points'])|number_format:2)}
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
						{__("The minimum withdrawal request amount is")} {print_money($system['points_min_withdrawal'])}
					</div>
				</div>
			</div>

			<div class="row form-group">
				<label class="col-md-3 form-label fw-medium">
					{__("Payment Method")}
				</label>
				<div class="col-md-9">
					{if in_array("paypal", $system['points_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_paypal" value="paypal" class="form-check-input">
							<label class="form-check-label" for="method_paypal">{__("PayPal")}</label>
						</div>
					{/if}
					{if in_array("skrill", $system['points_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_skrill" value="skrill" class="form-check-input">
							<label class="form-check-label" for="method_skrill">{__("Skrill")}</label>
						</div>
					{/if}
					{if in_array("moneypoolscash", $system['points_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_moneypoolscash" value="moneypoolscash" class="form-check-input">
							<label class="form-check-label" for="method_moneypoolscash">{__("MoneyPoolsCash")}</label>
						</div>
					{/if}
					{if in_array("bank", $system['points_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_bank" value="bank" class="form-check-input">
							<label class="form-check-label" for="method_bank">{__("Bank Transfer")}</label>
						</div>
					{/if}
					{if in_array("custom", $system['points_payment_method_array'])}
						<div class="form-check form-check-inline">
							<input type="radio" name="method" id="method_custom" value="custom" class="form-check-input">
							<label class="form-check-label" for="method_custom">{__($system['points_payment_method_custom'])}</label>
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
				<table class="table table-striped table-bordered table-hover">
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
										{$system['points_payment_method_custom']}
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