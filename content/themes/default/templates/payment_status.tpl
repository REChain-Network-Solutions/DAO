{include file='_head.tpl'}
{include file='_header.tpl'}


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
      <div class="card text-center">
        <div class="card-body">
          {if $view == "pending"}
            <div class="mb20">
              <i class="fa-solid fa-hourglass-end fa-4x" style="color: #f39c12;"></i>
            </div>
            <h2>{__("Payment Pending")}!</h2>
            <p class="text-xlg mt10">{__("Your payment is pending and will be processed soon")}</p>
            <p class="mt10">{__("You will get a notification once the payment is processed")}</p>
          {elseif $view == "failure"}
            <div class="mb20">
              <i class="fa-solid fa-times-circle fa-4x" style="color: #e74c3c;"></i>
            </div>
            <h2>{__("Payment Failed")}!</h2>
            <p class="text-xlg mt10">{__("Your payment has been failed")}</p>
            <p class="mt10">{__("Please try again or contact us for more information")}</p>
          {/if}
          <a class="btn btn-primary rounded-pill" href="{$system['system_url']}">{__("Back to Home")}</a>
        </div>
      </div>
    </div>
    <!-- content panel -->

  </div>
</div>
<!-- page content -->


{include file='_footer.tpl'}