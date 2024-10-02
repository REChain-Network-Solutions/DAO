{include file='_head.tpl'}
{include file='_header.tpl'}

{if $view == ""}
  <!-- page header -->
  <div class="page-header">
    <img class="floating-img d-none d-md-block" src="{$system['system_url']}/content/themes/{$system['theme']}/images/headers/undraw_transfer_money_rywa.svg">
    <div class="circle-2"></div>
    <div class="circle-3"></div>
    <div class="inner">
      <h2>{__("Funding")}</h2>
      <p class="text-xlg">{__($system['system_description_funding'])}</p>
    </div>
  </div>
  <!-- page header -->
{/if}


<!-- page content -->
<div class="{if $system['fluid_design']}container-fluid{else}container{/if} mt20 sg-offcanvas">
  <div class="row">

    <!-- side panel -->
    <div class="col-12 d-block d-md-none sg-offcanvas-sidebar">
      {include file='_sidebar.tpl'}
    </div>
    <!-- side panel -->

    <!-- content panel -->
    <div class="col-12 sg-offcanvas-mainbar">
      <!-- location filter -->
      {if $system['newsfeed_location_filter_enabled']}
        <div class="posts-filter">
          <span>{__("Funding")}</span>
          <div class="float-end">
            <a href="#" data-bs-toggle="dropdown" class="countries-filter">
              <i class="fa fa-globe fa-fw"></i>
              {if $selected_country}
                <span>{$selected_country['country_name']}</span>
              {else}
                <span>{__("All Countries")}</span>
              {/if}
            </a>
            <div class="dropdown-menu dropdown-menu-end countries-dropdown">
              <div class="js_scroller">
                <a class="dropdown-item" href="?country=all">
                  {__("All Countries")}
                </a>
                {foreach $countries as $country}
                  <a class="dropdown-item" href="?country={$country['country_name_native']}">
                    {$country['country_name']}
                  </a>
                {/foreach}
              </div>
            </div>
          </div>
        </div>
      {/if}
      <!-- location filter -->

      <div class="blogs-wrapper">
        {if $funding_requests}
          <ul class="row">
            <!-- funding -->
            {foreach $funding_requests as $funding}
              {include file='__feeds_funding.tpl' _iteration=$funding@iteration}
            {/foreach}
            <!-- funding -->
          </ul>

          <!-- see-more -->
          <div class="alert alert-post see-more js_see-more" data-get="funding" data-country="{if $selected_country}{$selected_country['country_id']}{else}all{/if}">
            <span>{__("More Funding")}</span>
            <div class="loader loader_small x-hidden"></div>
          </div>
          <!-- see-more -->
        {else}
          {include file='_no_data.tpl'}
        {/if}
      </div>
    </div>
    <!-- content panel -->

  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}