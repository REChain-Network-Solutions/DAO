{include file='_head.tpl'}
{include file='_header.tpl'}


<!-- page content -->
<div class="{if $system['fluid_design']}container-fluid{else}container{/if} mt20 sg-offcanvas">
  <div class="row">

    <!-- content panel -->
    <div class="col-12 sg-offcanvas-mainbar">
      <div class="card text-center">
        <div class="card-body">
          {if $view == "pending"}
            <div class="mb20">
              <span class="icon-[tabler--hourglass-low] size-16 text-[#f39c12]" aria-hidden="true"></span>
            </div>
            <h2>{__("Payment Pending")}!</h2>
            <p class="text-xlg mt10">{__("Your payment is pending and will be processed soon")}</p>
            <p class="mt10">{__("You will get a notification once the payment is processed")}</p>
          {elseif $view == "failure"}
            <div class="mb20">
              <span class="icon-[tabler--circle-x] size-16 text-[#e74c3c]" aria-hidden="true"></span>
            </div>
            <h2>{__("Payment Failed")}!</h2>
            <p class="text-xlg mt10">{__("Your payment has been failed")}</p>
            <p class="mt10">{__("Please try again or contact us for more information")}</p>
          {/if}
          <a class="heroui button button--primary rounded-full" href="{$system['system_url']}">{__("Back to Home")}</a>
        </div>
      </div>
    </div>
    <!-- content panel -->

  </div>
</div>
<!-- page content -->


{include file='_footer.tpl'}