<div class="card-header with-icon">
  {include file='__svg_icons.tpl' icon="points" class="main-icon mr15" width="24px" height="24px"}
  {__("Points")}
</div>
<div class="card-body">
  {if $sub_view == ""}
    <div class="alert alert-info">
      <div class="text">
        <strong>{__("Points System")}</strong><br>
        {if $system['points_per_currency'] > 0}
          {__("Each")} <strong>{$system['points_per_currency']}</strong> {__("points equal")} <strong>{print_money("1")}</strong>.
          <br>
        {/if}
        {__("Your daily points limit is")} <strong><span class="badge rounded-pill bg-warning">{if $system['packages_enabled'] && $user->_data['user_subscribed']}{$system['points_limit_pro']}{else}{$system['points_limit_user']}{/if}</span></strong> {__("Points")}, {__("You have")} <strong><span class="badge rounded-pill bg-danger">{$remaining_points}</span></strong> {__("remaining points")}
        <br>
        {__("Your daily points limit will be reset after 24 hours from your last valid earned action")}
        <br>
        {if $system['points_per_currency'] > 0 && $system['points_money_withdraw_enabled']}
          {__("You can withdraw your money")}
        {/if}
        {if $system['points_per_currency'] > 0 && $system['points_money_transfer_enabled']}
          {if $system['points_money_withdraw_enabled']}{__("or")} {/if}
          {__("You can transfer your money to your")} <a class="alert-link" href="{$system['system_url']}/wallet" target="_blank"><i class="fa fa-wallet"></i> {__("wallet")}</a>
        {/if}
      </div>
    </div>

    <div class="row">
      {if $system['points_per_post'] > 0}
        <div class="col-sm-6">
          <div class="stat-panel border">
            <div class="stat-cell">
              <i class="fa fa-newspaper icon bg-gradient-success"></i>
              <span class="text-xxlg">{$system['points_per_post']}</span><br>
              <span class="text-lg">{__("Points")}</span><br>
              <span>{__("For creating a new post")}</span>
            </div>
          </div>
        </div>
      {/if}
      {if $system['points_per_post_view'] > 0}
        <div class="col-sm-6">
          <div class="stat-panel border">
            <div class="stat-cell">
              <i class="fa fa-eye icon bg-gradient-success"></i>
              <span class="text-xxlg">{$system['points_per_post_view']}</span><br>
              <span class="text-lg">{__("Points")}</span><br>
              <span>{__("For each post view")}</span>
            </div>
          </div>
        </div>
      {/if}
      {if $system['points_per_post_comment'] > 0}
        <div class="col-sm-6">
          <div class="stat-panel border">
            <div class="stat-cell">
              <i class="fa fa-comments icon bg-gradient-primary"></i>
              <span class="text-xxlg">{$system['points_per_post_comment']}</span><br>
              <span class="text-lg">{__("Points")}</span><br>
              <span>{__("For any comment on your post")}</span>
            </div>
          </div>
        </div>
      {/if}
      {if $system['points_per_post_reaction'] > 0}
        <div class="col-sm-6">
          <div class="stat-panel border">
            <div class="stat-cell">
              <i class="fa fa-smile icon bg-gradient-danger"></i>
              <span class="text-xxlg">{$system['points_per_post_reaction']}</span><br>
              <span class="text-lg">{__("Points")}</span><br>
              <span>{__("For any reaction on your post")}</span>
            </div>
          </div>
        </div>
      {/if}
      {if $system['points_per_comment'] > 0}
        <div class="col-sm-6">
          <div class="stat-panel border">
            <div class="stat-cell">
              <i class="fa fa-comments icon bg-gradient-primary"></i>
              <span class="text-xxlg">{$system['points_per_comment']}</span><br>
              <span class="text-lg">{__("Points")}</span><br>
              <span>{__("For commenting any post")}</span>
            </div>
          </div>
        </div>
      {/if}
      {if $system['points_per_reaction'] > 0}
        <div class="col-sm-6">
          <div class="stat-panel border">
            <div class="stat-cell">
              <i class="fa fa-smile icon bg-gradient-danger"></i>
              <span class="text-xxlg">{$system['points_per_reaction']}</span><br>
              <span class="text-lg">{__("Points")}</span><br>
              <span>{__("For reacting on any post")}</span>
            </div>
          </div>
        </div>
      {/if}
      {if $system['points_per_follow'] > 0}
        <div class="col-sm-6">
          <div class="stat-panel border">
            <div class="stat-cell">
              <i class="fa fa-users icon bg-gradient-warning"></i>
              <span class="text-xxlg">{$system['points_per_follow']}</span><br>
              <span class="text-lg">{__("Points")}</span><br>
              <span>{__("For each follower you got")}</span>
            </div>
          </div>
        </div>
      {/if}
      {if $system['points_per_referred'] > 0}
        <div class="col-sm-6">
          <div class="stat-panel border">
            <div class="stat-cell">
              <i class="fa fa-exchange-alt icon bg-gradient-purple"></i>
              <span class="text-xxlg">{$system['points_per_referred']}</span><br>
              <span class="text-lg">{__("Points")}</span><br>
              <span>{__("For referring user")}</span>
            </div>
          </div>
        </div>
      {/if}
    </div>

    <div class="row mt20">
      <!-- points balance -->
      <div class="{if $system['points_per_currency'] > 0}col-sm-6{else}col-sm-12{/if}">
        <div class="section-title mb20">
          {__("Points Balance")}
        </div>
        <div class="stat-panel bg-gradient-teal">
          <div class="stat-cell">
            <i class="fa fa-piggy-bank bg-icon"></i>
            <div class="h3 mtb10">
              {$user->_data['user_points']} {__("Points")}
            </div>
          </div>
        </div>
      </div>
      <!-- points balance -->

      <!-- money balance -->
      {if $system['points_per_currency']}
        <div class="col-sm-6">
          <div class="section-title mb20">
            {__("Points Money Balance")}
          </div>
          <div class="stat-panel bg-primary">
            <div class="stat-cell">
              <i class="fa fas fa-donate bg-icon"></i>
              <div class="h3 mtb10">
                {print_money(((1/$system['points_per_currency'])*$user->_data['user_points'])|number_format:2)}
              </div>
            </div>
          </div>
        </div>
      {/if}
      <!-- money balance -->
    </div>

    <!-- points transactions -->
    <div class="mtb20">
      <div class="section-title mt10 mb20">
        {__("Points Transactions")}
      </div>
      {if $transactions}
        <div class="table-responsive">
          <table class="table table-striped table-bordered table-hover js_dataTable">
            <thead>
              <tr>
                <th>{__("ID")}</th>
                <th>{__("Points")}</th>
                <th>{__("From")}</th>
                <th>{__("Time")}</th>
              </tr>
            </thead>
            <tbody>
              {foreach $transactions as $transaction}
                <tr>
                  <td>{$transaction@iteration}</td>
                  <td><span class="badge rounded-pill badge-lg bg-light text-primary">{$transaction['points']}</span></td>
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
                    {/if}
                  </td>
                  <td><span class="js_moment" data-time="{$transaction['time']}">{$transaction['time']}</span></td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
      {else}
        {include file='_no_transactions.tpl'}
      {/if}
    </div>
    <!-- points transactions -->
  {elseif $sub_view == "payments"}
    <div class="heading-small mb20">
      {__("Withdrawal Request")}
    </div>
    <div class="pl-md-4">
      <form class="js_ajax-forms" data-url="users/withdraw.php?type=points">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Your Balance")}
          </label>
          <div class="col-md-9">
            <h6>
              <span class="badge badge-lg bg-info">
                {print_money(((1/$system['points_per_currency'])*$user->_data['user_points'])|number_format:2)}
              </span>
            </h6>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
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
          <label class="col-md-3 form-label">
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

        <div class="row form-group">
          <label class="col-md-3 form-label">
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
    </div>

    <div class="divider"></div>

    <div class="heading-small mb20">
      {__("Withdrawal History")}
    </div>
    <div class="pl-md-4">
      {if $payments}
        <div class="table-responsive mt20">
          <table class="table table-striped table-bordered table-hover">
            <thead>
              <tr>
                <th>{__("ID")}</th>
                <th>{__("Amount")}</th>
                <th>{__("Method")}</th>
                <th>{__("Transfer To")}</th>
                <th>{__("Time")}</th>
                <th>{__("Status")}</th>
              </tr>
            </thead>
            <tbody>
              {foreach $payments as $payment}
                <tr>
                  <td>{$payment@iteration}</td>
                  <td>{print_money($payment['amount']|number_format:2)}</td>
                  <td>
                    {if $payment['method'] == "custom"}
                      {$system['points_payment_method_custom']}
                    {else}
                      {$payment['method']|ucfirst}
                    {/if}
                  </td>
                  <td>{$payment['method_value']}</td>
                  <td>
                    <span class="js_moment" data-time="{$payment['time']}">{$payment['time']}</span>
                  </td>
                  <td>
                    {if $payment['status'] == '0'}
                      <span class="badge rounded-pill badge-lg bg-warning">{__("Pending")}</span>
                    {elseif $payment['status'] == '1'}
                      <span class="badge rounded-pill badge-lg bg-success">{__("Approved")}</span>
                    {else}
                      <span class="badge rounded-pill badge-lg bg-danger">{__("Declined")}</span>
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
  {/if}
</div>