{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page header -->
<div class="page-header">
  <img class="floating-img d-none d-md-block" src="{$system['system_url']}/content/themes/{$system['theme']}/images/headers/undraw_check_boxes_re_v40f.svg">
  <div class="circle-2"></div>
  <div class="circle-3"></div>
  <div class="inner">
    <h2>{__("Pending Approval")}</h2>
    <p class="text-xlg">{__("Your account is pending approval")}</p>
  </div>
</div>
<!-- page header -->

<!-- page content -->
<div class="{if $system['fluid_design']}container-fluid{else}container{/if}" style="margin-top: -25px;">
  <div class="row">
    <div class="col-12 col-md-10 mx-md-auto">
      <div class="card shadow">
        <div class="card-body text-center">
          <p class="text-xlg mt10 mb30">
            {__("Your account is pending approval. You will receive a notification once your account is approved")}
          </p>
        </div>
      </div>
    </div>
  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}