<!-- card-header -->
<div class="card-header with-icon with-nav">
  <!-- panel title -->
  <div class="mb20">
    <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("Payments")}
  </div>
  <!-- panel title -->

  <!-- panel nav -->
  <ul class="nav nav-tabs">
    <li class="nav-item">
      <a class="nav-link active" href="#Settings" data-bs-toggle="tab">
        <i class="fa fa-cog fa-fw mr5"></i><strong class="pr5">{__("Settings")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#Payments" data-bs-toggle="tab">
        <i class="fa fa-credit-card fa-fw mr5"></i><strong class="pr5">{__("Online Payments")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#Bank" data-bs-toggle="tab">
        <i class="fa fa-university fa-fw mr5"></i><strong class="pr5">{__("Bank Transfers")}</strong>
      </a>
    </li>
  </ul>
  <!-- panel nav -->
</div>
<!-- card-header -->

<!-- tabs content -->
<div class="tab-content">
  <!-- Settings -->
  <div class="tab-pane active" id="Settings">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=payments_settings">
      <div class="card-body">
        <div class="heading-small mb20">
          {__("Fees")}
        </div>
        <div class="pl-md-4">
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="withdrawal" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Payment Fees")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable/Disable Payment Fees")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="payment_fees_enabled">
                <input type="checkbox" name="payment_fees_enabled" id="payment_fees_enabled" {if $system['payment_fees_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Fees Percentage")} (%)
            </label>
            <div class="col-md-9">
              <input type="text" class="form-control" name="payment_fees_percentage" value="{$system['payment_fees_percentage']}">
              <div class="form-text">
                {__("Percentage of fees to be added to the payment amount")}
              </div>
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="heading-small mb20">
          {__("VAT")}
        </div>
        <div class="pl-md-4">
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="vat" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("VAT Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable/Disable VAT")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="payment_vat_enabled">
                <input type="checkbox" name="payment_vat_enabled" id="payment_vat_enabled" {if $system['payment_vat_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="map" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("VAT By User Country")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable/Disable VAT by user country")} (<a href="{$system['system_url']}/{$control_panel['url']}/countries">{__("Manage Countries VAT")}</a>)</div>
            </div>
            <div class="text-end">
              <label class="switch" for="payment_country_vat_enabled">
                <input type="checkbox" name="payment_country_vat_enabled" id="payment_country_vat_enabled" {if $system['payment_country_vat_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Default VAT Percentage")} (%)
            </label>
            <div class="col-md-9">
              <input type="text" class="form-control" name="payment_vat_percentage" value="{$system['payment_vat_percentage']}">
              <div class="form-text">
                {__("Note: If VAT By User Country enabled then VAT will be calculated based on user country VAT")}<br>
                {__("Note: If user didn't select his country then VAT will be calculated based on default VAT percentage")}<br>
                {__("Note: If country VAT is not set then VAT will be calculated based on default VAT percentage")}<br>
              </div>
            </div>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </div>
      <div class="card-footer text-end">
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>
  </div>
  <!-- Settings -->

  <!-- Payments -->
  <div class="tab-pane" id="Payments">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=payments_methods">
      <div class="card-body">

        <!-- PayPal -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="paypal" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Paypal Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via Paypal")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="paypal_enabled">
                <input type="checkbox" name="paypal_enabled" id="paypal_enabled" {if $system['paypal_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="withdrawal" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Paypal Payouts")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable automatic payouts for PayPal withdrawal requests")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="paypal_payouts_enabled">
                <input type="checkbox" name="paypal_payouts_enabled" id="paypal_payouts_enabled" {if $system['paypal_payouts_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Paypal Mode")}
            </label>
            <div class="col-md-9">
              <div class="form-check form-check-inline">
                <input type="radio" name="paypal_mode" id="paypal_live" value="live" class="form-check-input" {if $system['paypal_mode'] == "live"}checked{/if}>
                <label class="form-check-label" for="paypal_live">{__("Live")}</label>
              </div>
              <div class="form-check form-check-inline">
                <input type="radio" name="paypal_mode" id="paypal_sandbox" value="sandbox" class="form-check-input" {if $system['paypal_mode'] == "sandbox"}checked{/if}>
                <label class="form-check-label" for="paypal_sandbox">{__("Sandbox")}</label>
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("PayPal Client ID")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="paypal_id" value="{$system['paypal_id']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("PayPal Secret Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="paypal_secret" value="{$system['paypal_secret']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("PayPal Webhook Id")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="paypal_webhook" value="{$system['paypal_webhook']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>
        <!-- PayPal -->

        <div class="divider"></div>

        <!-- Stripe -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="stripe" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Stripe Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via Credit Card")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="creditcard_enabled">
                <input type="checkbox" name="creditcard_enabled" id="creditcard_enabled" {if $system['creditcard_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="alipay" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Alipay Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via Alipay")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="alipay_enabled">
                <input type="checkbox" name="alipay_enabled" id="alipay_enabled" {if $system['alipay_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="form-table-row">
            <div>
              <div class="form-label h6">{__("Stripe Payment Element")}</div>
              <div class="form-text d-none d-sm-block">
                {__("Enable Stripe Payment Element")} (<a target="_blank" href="https://docs.stripe.com/payments/payment-element">{__("Read More")}</a>)
              </div>
            </div>
            <div class="text-end">
              <label class="switch" for="stripe_payment_element_enabled">
                <input type="checkbox" name="stripe_payment_element_enabled" id="stripe_payment_element_enabled" {if $system['stripe_payment_element_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Stripe Mode")}
            </label>
            <div class="col-md-9">
              <div class="form-check form-check-inline">
                <input type="radio" name="stripe_mode" id="stripe_live" value="live" class="form-check-input" {if $system['stripe_mode'] == "live"}checked{/if}>
                <label class="form-check-label" for="stripe_live">{__("Live")}</label>
              </div>
              <div class="form-check form-check-inline">
                <input type="radio" name="stripe_mode" id="stripe_test" value="test" class="form-check-input" {if $system['stripe_mode'] == "test"}checked{/if}>
                <label class="form-check-label" for="stripe_test">{__("Test")}</label>
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Test Secret Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="stripe_test_secret" value="{$system['stripe_test_secret']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
              <div class="form-text">
                {__("Stripe secret key that starts with sk_")}
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Test Publishable Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="stripe_test_publishable" value="{$system['stripe_test_publishable']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
              <div class="form-text">
                {__("Stripe publishable key that starts with pk_")}
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Live Secret Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="stripe_live_secret" value="{$system['stripe_live_secret']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
              <div class="form-text">
                {__("Stripe secret key that starts with sk_")}
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Live Publishable Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="stripe_live_publishable" value="{$system['stripe_live_publishable']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
              <div class="form-text">
                {__("Stripe publishable key that starts with pk_")}
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Webhook Signing Secret")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="stripe_webhook" value="{$system['stripe_webhook']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
              <div class="form-text">
                {__("Stripe webhook signing secret that starts with whsec_")}
              </div>
            </div>
          </div>
        </div>
        <!-- Stripe -->

        <div class="divider"></div>

        <!-- Paystack -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="paystack" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Paystack Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via Paystack")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="paystack_enabled">
                <input type="checkbox" name="paystack_enabled" id="paystack_enabled" {if $system['paystack_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Secret Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="paystack_secret" value="{$system['paystack_secret']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
              <div class="form-text">
                {__("Paystack secret key that starts with sk_")}
              </div>
            </div>
          </div>
        </div>
        <!-- Paystack -->

        <div class="divider"></div>

        <!-- 2Checkout (Verifone) -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="2co" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("2Checkout Enabled")} ({__("Verifone")})</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via 2Checkout")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="2checkout_enabled">
                <input type="checkbox" name="2checkout_enabled" id="2checkout_enabled" {if $system['2checkout_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("2Checkout Mode")}
            </label>
            <div class="col-md-9">
              <div class="form-check form-check-inline">
                <input type="radio" name="2checkout_mode" id="2checkout_live" value="live" class="form-check-input" {if $system['2checkout_mode'] == "live"}checked{/if}>
                <label class="form-check-label" for="2checkout_live">{__("Live")}</label>
              </div>
              <div class="form-check form-check-inline">
                <input type="radio" name="2checkout_mode" id="2checkout_sandbox" value="sandbox" class="form-check-input" {if $system['2checkout_mode'] == "sandbox"}checked{/if}>
                <label class="form-check-label" for="2checkout_sandbox">{__("Demo")}</label>
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Merchant Code")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="2checkout_merchant_code" value="{$system['2checkout_merchant_code']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("API Publishable Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="2checkout_publishable_key" value="{$system['2checkout_publishable_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("API Private Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="2checkout_private_key" value="{$system['2checkout_private_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>
        <!-- 2Checkout (Verifone) -->

        <div class="divider"></div>

        <!-- Authorize.net -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="authorize.net" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Authorize.net Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via Authorize.net")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="authorize_net_enabled">
                <input type="checkbox" name="authorize_net_enabled" id="authorize_net_enabled" {if $system['authorize_net_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Authorize.net Mode")}
            </label>
            <div class="col-md-9">
              <div class="form-check form-check-inline">
                <input type="radio" name="authorize_net_mode" id="authorize_net_live" value="live" class="form-check-input" {if $system['authorize_net_mode'] == "live"}checked{/if}>
                <label class="form-check-label" for="authorize_net_live">{__("Live")}</label>
              </div>
              <div class="form-check form-check-inline">
                <input type="radio" name="authorize_net_mode" id="authorize_net_sandbox" value="sandbox" class="form-check-input" {if $system['authorize_net_mode'] == "sandbox"}checked{/if}>
                <label class="form-check-label" for="authorize_net_sandbox">{__("Sandbox")}</label>
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("API Login ID")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="authorize_net_api_login_id" value="{$system['authorize_net_api_login_id']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Transaction Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="authorize_net_transaction_key" value="{$system['authorize_net_transaction_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>
        <!-- Authorize.net -->

        <div class="divider"></div>

        <!-- Razorpay -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="razorpay" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Razorpay Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via Razorpay")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="razorpay_enabled">
                <input type="checkbox" name="razorpay_enabled" id="razorpay_enabled" {if $system['razorpay_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Key ID")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="razorpay_key_id" value="{$system['razorpay_key_id']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Key Secret")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="razorpay_key_secret" value="{$system['razorpay_key_secret']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>
        <!-- Razorpay -->

        <div class="divider"></div>

        <!-- Cashfree -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="cashfree" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Cashfree Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via Cashfree")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="cashfree_enabled">
                <input type="checkbox" name="cashfree_enabled" id="cashfree_enabled" {if $system['cashfree_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Cashfree Mode")}
            </label>
            <div class="col-md-9">
              <div class="form-check form-check-inline">
                <input type="radio" name="cashfree_mode" id="Cashfree_live" value="live" class="form-check-input" {if $system['cashfree_mode'] == "live"}checked{/if}>
                <label class="form-check-label" for="Cashfree_live">{__("Live")}</label>
              </div>
              <div class="form-check form-check-inline">
                <input type="radio" name="cashfree_mode" id="Cashfree_sandbox" value="sandbox" class="form-check-input" {if $system['cashfree_mode'] == "sandbox"}checked{/if}>
                <label class="form-check-label" for="Cashfree_sandbox">{__("Sandbox")}</label>
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Client ID")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="cashfree_client_id" value="{$system['cashfree_client_id']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Client Secret")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="cashfree_client_secret" value="{$system['cashfree_client_secret']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>
        <!-- Cashfree -->

        <div class="divider"></div>

        <!-- Shift4 -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="shift4" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Shift4 Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via Shift4")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="shift4_enabled">
                <input type="checkbox" name="shift4_enabled" id="shift4_enabled" {if $system['shift4_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("API Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="shift4_api_key" value="{$system['shift4_api_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("API Secret")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="shift4_api_secret" value="{$system['shift4_api_secret']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>
        <!-- Shift4 -->

        <div class="divider"></div>

        <!-- MyFatoorah -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="myfatoorah" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("MyFatoorah Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via MyFatoorah")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="myfatoorah_enabled">
                <input type="checkbox" name="myfatoorah_enabled" id="myfatoorah_enabled" {if $system['myfatoorah_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("MyFatoorah Mode")}
            </label>
            <div class="col-md-9">
              <div class="form-check form-check-inline">
                <input type="radio" name="myfatoorah_mode" id="myfatoorah_live" value="live" class="form-check-input" {if $system['myfatoorah_mode'] == "live"}checked{/if}>
                <label class="form-check-label" for="myfatoorah_live">{__("Live")}</label>
              </div>
              <div class="form-check form-check-inline">
                <input type="radio" name="myfatoorah_mode" id="myfatoorah_test" value="test" class="form-check-input" {if $system['myfatoorah_mode'] == "test"}checked{/if}>
                <label class="form-check-label" for="myfatoorah_test">{__("Test")}</label>
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Test Token")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="myfatoorah_test_token" value="{$system['myfatoorah_test_token']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
              <div class="form-text">
                {__("MyFatoorah test token")} ({__("For more info check the docs")}: <a href="https://docs.myfatoorah.com/docs/test-token" target="_blank">{__("API Documentation")}</a>)
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Live Token")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="myfatoorah_live_token" value="{$system['myfatoorah_live_token']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
              <div class="form-text">
                {__("MyFatoorah live token")} ({__("For more info check the docs")}: <a href="https://docs.myfatoorah.com/docs/live-token" target="_blank">{__("API Documentation")}</a>
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Live API URL")}
            </label>
            <div class="col-md-9">
              <input type="text" class="form-control" name="myfatoorah_live_api_url" value="{$system['myfatoorah_live_api_url']}">
              <div class="form-text">
                {__("MyFatoorah live API URL")} ({__("For more info check the docs")}: <a href="https://docs.myfatoorah.com/docs/live-token" target="_blank">{__("API Documentation")}</a>)
              </div>
            </div>
          </div>
        </div>
        <!-- MyFatoorah -->

        <div class="divider"></div>

        <!-- Epayco -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              <img height="40px" src="{$system['system_url']}/content/themes/{$system['theme']}/images/icons/epayco.png">
            </div>
            <div>
              <div class="form-label h6">{__("Epayco Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via Epayco")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="epayco_enabled">
                <input type="checkbox" name="epayco_enabled" id="epayco_enabled" {if $system['epayco_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Epayco Mode")}
            </label>
            <div class="col-md-9">
              <div class="form-check form-check-inline">
                <input type="radio" name="epayco_mode" id="epayco_live" value="live" class="form-check-input" {if $system['epayco_mode'] == "live"}checked{/if}>
                <label class="form-check-label" for="epayco_live">{__("Live")}</label>
              </div>
              <div class="form-check form-check-inline">
                <input type="radio" name="epayco_mode" id="epayco_test" value="test" class="form-check-input" {if $system['epayco_mode'] == "test"}checked{/if}>
                <label class="form-check-label" for="epayco_test">{__("Test")}</label>
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Public Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="epayco_public_key" value="{$system['epayco_public_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Private Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="epayco_private_key" value="{$system['epayco_private_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>
        <!-- Epayco -->

        <div class="divider"></div>

        <!-- Flutterwave -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="flutterwave" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Flutterwave Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via Flutterwave")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="flutterwave_enabled">
                <input type="checkbox" name="flutterwave_enabled" id="flutterwave_enabled" {if $system['flutterwave_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Flutterwave Mode")}
            </label>
            <div class="col-md-9">
              <div class="form-check form-check-inline">
                <input type="radio" name="flutterwave_mode" id="flutterwave_live" value="live" class="form-check-input" {if $system['flutterwave_mode'] == "live"}checked{/if}>
                <label class="form-check-label" for="flutterwave_live">{__("Live")}</label>
              </div>
              <div class="form-check form-check-inline">
                <input type="radio" name="flutterwave_mode" id="flutterwave_test" value="test" class="form-check-input" {if $system['flutterwave_mode'] == "test"}checked{/if}>
                <label class="form-check-label" for="flutterwave_test">{__("Test")}</label>
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Public Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="flutterwave_public_key" value="{$system['flutterwave_public_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Secret Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="flutterwave_secret_key" value="{$system['flutterwave_secret_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Encryption Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="flutterwave_encryption_key" value="{$system['flutterwave_encryption_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>
        <!-- Flutterwave -->

        <div class="divider"></div>

        <!-- Verotel -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              <img width="40px" src="{$system['system_url']}/content/themes/{$system['theme']}/images/icons/verotel.png">
            </div>
            <div>
              <div class="form-label h6">{__("Verotel Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via Verotel")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="verotel_enabled">
                <input type="checkbox" name="verotel_enabled" id="verotel_enabled" {if $system['verotel_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Shop ID")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="verotel_shop_id" value="{$system['verotel_shop_id']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Signature Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="verotel_signature_key" value="{$system['verotel_signature_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>
        <!-- Verotel -->

        <div class="divider"></div>

        <!-- MercadoPago -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="mercadopago" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("MercadoPago Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via MercadoPago")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="mercadopago_enabled">
                <input type="checkbox" name="mercadopago_enabled" id="mercadopago_enabled" {if $system['mercadopago_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Public Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="mercadopago_public_key" value="{$system['mercadopago_public_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Access Token")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="mercadopago_access_token" value="{$system['mercadopago_access_token']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>
        <!-- MercadoPago -->

        <div class="divider"></div>

        <!-- Plisio -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="plisio" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Plisio Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via Plisio")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="plisio_enabled">
                <input type="checkbox" name="plisio_enabled" id="plisio_enabled" {if $system['plisio_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Secret Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="plisio_secret_key" value="{$system['plisio_secret_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>
        <!-- Plisio -->

        <div class="divider"></div>

        <!-- CoinPayments -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="bitcoin" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("CoinPayments Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via CoinPayments")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="coinpayments_enabled">
                <input type="checkbox" name="coinpayments_enabled" id="coinpayments_enabled" {if $system['coinpayments_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Merchant ID")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="coinpayments_merchant_id" value="{$system['coinpayments_merchant_id']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("IPN Secret")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="coinpayments_ipn_secret" value="{$system['coinpayments_ipn_secret']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>
        <!-- CoinPayments -->

        <div class="divider"></div>

        <!-- Coinbase -->
        <div>
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="coinbase" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("Coinbase Enabled")}</div>
              <div class="form-text d-none d-sm-block">{__("Enable payments via Coinbase")}</div>
            </div>
            <div class="text-end">
              <label class="switch" for="coinbase_enabled">
                <input type="checkbox" name="coinbase_enabled" id="coinbase_enabled" {if $system['coinbase_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("API Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="coinbase_api_key" value="{$system['coinbase_api_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>
        </div>
        <!-- Coinbase -->

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </div>
      <div class="card-footer text-end">
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>
  </div>
  <!-- Payments -->

  <!-- Bank -->
  <div class="tab-pane" id="Bank">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=bank">
      <div class="card-body">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="bank" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Bank Transfers Enabled")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable payments via Bank Transfers")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="bank_transfers_enabled">
              <input type="checkbox" name="bank_transfers_enabled" id="bank_transfers_enabled" {if $system['bank_transfers_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bank Name")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="bank_name" value="{$system['bank_name']}">
            <div class="form-text">
              {__("Your Bank Name")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bank Account Number")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="bank_account_number" value="{$system['bank_account_number']}">
            <div class="form-text">
              {__("Your Bank Account Number")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bank Account Name")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="bank_account_name" value="{$system['bank_account_name']}">
            <div class="form-text">
              {__("Your Bank Account Name")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bank Account Routing Code")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="bank_account_routing" value="{$system['bank_account_routing']}">
            <div class="form-text">
              {__("Your Bank Account Routing Code or SWIFT Code")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bank Account Country")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="bank_account_country" value="{$system['bank_account_country']}">
            <div class="form-text">
              {__("Your Bank Account Country")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Transfer Note")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="bank_transfer_note" rows="5">{$system['bank_transfer_note']}</textarea>
            <div class="form-text">
              {__("This note will be displayed to the user while upload his bank transfer receipt")}
            </div>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </div>
      <div class="card-footer text-end">
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>
  </div>
  <!-- Bank -->
</div>