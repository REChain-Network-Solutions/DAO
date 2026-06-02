{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
  .ccbill-status-wrap {
    max-width: 520px;
    margin: 0 auto;
    padding: 48px 32px;
  }

  .ccbill-icon-wrap {
    width: 88px;
    height: 88px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 28px;
  }

  .ccbill-icon-wrap.pending {
    background: rgba(243, 156, 18, .12);
  }

  .ccbill-icon-wrap.paid {
    background: rgba(46, 204, 113, .12);
  }

  .ccbill-icon-wrap.failed {
    background: rgba(231, 76, 60, .12);
  }

  .ccbill-status-wrap h2 {
    font-size: 1.6rem;
    font-weight: 700;
    margin-bottom: 10px;
  }

  .ccbill-status-wrap .sub {
    color: #888;
    font-size: .97rem;
    line-height: 1.6;
  }

  .ccbill-pulse-bar {
    height: 4px;
    border-radius: 4px;
    background: #f0f0f0;
    overflow: hidden;
    margin: 28px auto 0;
    max-width: 260px;
  }

  .ccbill-pulse-bar span {
    display: block;
    height: 100%;
    width: 40%;
    background: linear-gradient(90deg, transparent, #f39c12, transparent);
    border-radius: 4px;
    animation: ccbill-sweep 1.6s ease-in-out infinite;
  }

  @keyframes ccbill-sweep {
    0% {
      transform: translateX(-100%);
    }

    100% {
      transform: translateX(360%);
    }
  }

  .ccbill-check-msg {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    font-size: .88rem;
    padding: 7px 16px;
    border-radius: 20px;
    margin-top: 20px;
    font-weight: 500;
  }

  .ccbill-check-msg.info {
    background: #f5f5f5;
    color: #666;
  }

  .ccbill-check-msg.success {
    background: rgba(46, 204, 113, .12);
    color: #27ae60;
  }

  .ccbill-check-msg.danger {
    background: rgba(231, 76, 60, .12);
    color: #c0392b;
  }
</style>

<!-- page content -->
<div class="{if $system['fluid_design']}container-fluid{else}container{/if} mt20 sg-offcanvas">
  <div class="row">

    <!-- side panel -->
    <div class="col-12 d-block d-sm-none sg-offcanvas-sidebar">
      {include file='_sidebar.tpl'}
    </div>
    <!-- side panel -->

    <!-- content panel -->
    <div class="col-12 sg-offcanvas-mainbar">
      <div class="card">
        <div class="card-body text-center">
          <div class="ccbill-status-wrap">

            {if $payment['payment_status'] == 'pending'}
              <div class="ccbill-icon-wrap pending">
                <i class="fa-solid fa-hourglass-half fa-2x" style="color:#f39c12;"></i>
              </div>
              <h2>{__("Payment Pending")}</h2>
              <p class="sub">{__("Your payment is being processed. This usually takes just a moment — please stay on this page.")}</p>
              <div id="ccbill-status-checker">
                <div class="ccbill-pulse-bar"><span></span></div>
                <div id="ccbill-check-msg" class="ccbill-check-msg info">
                  <i class="fa-solid fa-circle-notch fa-spin"></i> {__("Checking payment status")}...
                </div>
              </div>

            {elseif $payment['payment_status'] == 'paid'}
              <div class="ccbill-icon-wrap paid">
                <i class="fa-solid fa-check fa-2x" style="color:#2ecc71;"></i>
              </div>
              <h2>{__("Payment Successful")}</h2>
              <p class="sub">{__("Your payment has been confirmed. You will be redirected to the payment page shortly.")}</p>
              <a class="btn btn-success rounded-pill mt20" href="{$payment['success_url']}">{__("Continue")}</a>

            {elseif $payment['payment_status'] == 'failed'}
              <div class="ccbill-icon-wrap failed">
                <i class="fa-solid fa-xmark fa-2x" style="color:#e74c3c;"></i>
              </div>
              <h2>{__("Payment Failed")}</h2>
              <p class="sub">{__("Something went wrong with your payment. Please try again or contact support for assistance.")}</p>
            {/if}

          </div>
        </div>
      </div>
    </div>
    <!-- content panel -->

  </div>
</div>
<!-- page content -->


{if $payment['payment_status'] == 'pending'}
  <script>
    var ccbillStatusInterval = setInterval(function() {
      var statusCheckUrl = api['payments/ccbill_status_check'] + '?' + window.location.search.slice(1);
      $.post(statusCheckUrl, {}, function(response) {
        if (response.callback) {
          clearInterval(ccbillStatusInterval);
          $('.ccbill-pulse-bar').hide();
          $('#ccbill-check-msg').removeClass('info danger').addClass('success').html('<i class="fa-solid fa-check"></i> {__("Payment confirmed! Redirecting")}...');
          eval(response.callback);
        } else if (response.payment_status && response.payment_status !== 'pending') {
          clearInterval(ccbillStatusInterval);
          location.reload();
        } else {
          $('#ccbill-check-msg').removeClass('danger').addClass('info').html('<i class="fa-solid fa-circle-notch fa-spin"></i> {__("Still processing")} &mdash; {__("checking again in 5 seconds")}...');
        }
      }).fail(function() {
        $('#ccbill-check-msg').removeClass('info success').addClass('danger').html('<i class="fa-solid fa-triangle-exclamation"></i> {__("Could not reach the server, retrying")}...');
      });
    }, 5000);
  </script>
{/if}

{include file='_footer.tpl'}