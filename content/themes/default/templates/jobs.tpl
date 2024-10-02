{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page header -->
<div class="page-header">
  <img class="floating-img d-none d-md-block" src="{$system['system_url']}/content/themes/{$system['theme']}/images/headers/undraw_interview_rmcf.svg">
  <div class="circle-2"></div>
  <div class="circle-3"></div>
  <div class="{if $system['fluid_design']}container-fluid{else}container{/if}">
    <h2>{__("Jobs")}</h2>
    <p class="text-xlg">{__($system['system_description_jobs'])}</p>
    <div class="row mt20">
      <div class="col-sm-9 col-lg-6 mx-sm-auto">
        <form class="js_search-form" data-handle="jobs">
          <div class="input-group">
            <input type="text" class="form-control" name="query" placeholder='{__("Search for jobs")}'>
            <button type="submit" class="btn btn-light">{__("Search")}</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
<!-- page header -->

<!-- page content -->
<div class="{if $system['fluid_design']}container-fluid{else}container{/if} sg-offcanvas" style="margin-top: -25px;">

  <div class="position-relative">
    <!-- tabs -->
    <div class="content-tabs rounded-sm shadow-sm clearfix">
      <ul>
        <li class="active">
          <a href="{$system['system_url']}/jobs">{__("Discover")}</a>
        </li>
      </ul>
      {if $user->_data['can_create_jobs']}
        <div class="mt10 float-end">
          <button class="btn btn-md btn-primary d-none d-lg-block" data-toggle="modal" data-url="posts/job.php?do=create">
            <i class="fa fa-plus-circle mr5"></i>{__("Create Job")}
          </button>
          <button class="btn btn-sm btn-icon btn-primary d-block d-lg-none" data-toggle="modal" data-url="posts/job.php?do=create">
            <i class="fa fa-plus-circle"></i>
          </button>
        </div>
      {/if}
    </div>
    <!-- tabs -->
  </div>

  <div class="row">

    <!-- left panel -->
    <div class="col-md-4 col-lg-3 sg-offcanvas-sidebar">
      <!-- categories -->
      <div class="card">
        <div class="card-body with-nav">
          <ul class="side-nav">
            {if $view != "category"}
              <li class="active">
                <a href="{$system['system_url']}/jobs">
                  {__("All")}
                </a>
              </li>
            {else}
              <li>
                {if $current_category['parent']}
                  <a href="{$system['system_url']}/jobs/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
                    <i class="fas fa-arrow-alt-circle-left mr5"></i>{__($current_category['parent']['category_name'])}
                  </a>
                {else}
                  <a href="{$system['system_url']}/jobs">
                    {if $current_category['sub_categories']}<i class="fas fa-arrow-alt-circle-left mr5"></i>{/if}{__("All")}
                  </a>
                {/if}
              </li>
            {/if}
            {foreach $categories as $category}
              <li {if $view == "category" && $current_category['category_id'] == $category['category_id']}class="active" {/if}>
                <a href="{$system['system_url']}/jobs/category/{$category['category_id']}/{$category['category_url']}">
                  {__($category['category_name'])}
                  {if $category['sub_categories']}
                    <span class="float-end"><i class="fas fa-angle-right"></i></span>
                  {/if}
                </a>
              </li>
            {/foreach}
          </ul>
        </div>
      </div>
      <!-- categories -->
    </div>
    <!-- left panel -->

    <!-- right panel -->
    <div class="col-md-8 col-lg-9 sg-offcanvas-mainbar">

      {include file='_ads.tpl'}

      {if $view == "search"}
        <div class="bs-callout bs-callout-info mt0">
          <!-- results counter -->
          <span class="badge rounded-pill badge-lg bg-secondary">{$total}</span> {__("results were found for the search for")} "<strong class="text-primary">{htmlentities($query, ENT_QUOTES, 'utf-8')}</strong>"
          <!-- results counter -->
        </div>
      {/if}

      {if $view == "" && $promoted_jobs}
        <div class="blogs-widget-header">
          <div class="blogs-widget-title">{__("Promoted Jobs")}</div>
        </div>
        <div class="row mb20">
          {foreach $promoted_jobs as $post}
            {include file='__feeds_job.tpl' _boosted=true}
          {/foreach}
        </div>
      {/if}

      <div class="blogs-widget-header clearfix">
        <div class="blogs-widget-title">{__("Jobs")}</div>
        <!-- sort -->
        <div class="float-end">
          <div class="dropdown">
            <button type="button" class="btn btn-sm btn-light dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
              {if !$sort || $sort == "latest"}
                <i class="fas fa-bars fa-fw"></i> {__("Latest")}
              {elseif $sort == "salary-high"}
                <i class="fas fa-sort-amount-down fa-fw"></i> {__("Salary High")}
              {elseif $sort == "salary-low"}
                <i class="fas fa-sort-amount-down-alt fa-fw"></i> {__("Salary Low")}
              {/if}
            </button>
            <div class="dropdown-menu dropdown-menu-end">
              <a href="?{if $selected_country}country={$selected_country['country_name']}&{/if}{if $distance}distance={$distance}&{/if}sort=latest" class="dropdown-item"><i class="fas fa-bars fa-fw mr10"></i>{__("Latest")}</a>
              <a href="?{if $selected_country}country={$selected_country['country_name']}&{/if}{if $distance}distance={$distance}&{/if}sort=salary-high" class="dropdown-item"><i class="fas fa-sort-amount-down fa-fw mr10"></i>{__("Salary High")}</a>
              <a href="?{if $selected_country}country={$selected_country['country_name']}&{/if}{if $distance}distance={$distance}&{/if}sort=salary-low" class="dropdown-item"><i class="fas fa-sort-amount-down-alt fa-fw mr10"></i>{__("Salary Low")}</a>
            </div>
          </div>
        </div>
        <!-- sort -->
        <!-- location filter -->
        {if $user->_logged_in && $system['location_finder_enabled']}
          <div class="float-end">
            <div class="dropdown">
              <button type="button" class="btn btn-sm btn-light dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
                <i class="fa fa-map-marker-alt mr5"></i>{__("Distance")}
              </button>
              <div class="dropdown-menu dropdown-menu-end">
                <form class="ptb15 plr15" method="get" action="?">
                  <div class="form-group">
                    <label class="form-label">{__("Distance")}</label>
                    <div>
                      {if $selected_country}
                        <input type="hidden" name="country" value="{$selected_country['country_name']}">
                      {/if}
                      <div class="d-grid mb10">
                        <input type="range" class="custom-range" min="1" max="5000" name="distance" value="{if $distance}{$distance}{else}5000{/if}" oninput="this.form.distance_value.value=this.value">
                      </div>
                      <div class="input-group">
                        <span class="input-group-text" id="basic-addon1">{if $system['system_distance'] == "mile"}{__("ML")}{else}{__("KM")}{/if}</span>
                        <input disabled type="number" class="form-control" min="1" max="5000" name="distance_value" value="{if $distance}{$distance}{else}5000{/if}" oninput="this.form.distance.value=this.value">
                      </div>
                      {if $sort}
                        <input type="hidden" name="sort" value="{$sort}">
                      {/if}
                    </div>
                  </div>
                  <div class="d-grid">
                    <button type="submit" class="btn btn-sm btn-primary">{__("Filter")}</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        {/if}
        <!-- location filter -->
        <!-- country filter -->
        <div class="float-end">
          <div class="dropdown">
            <button type="button" class="btn btn-sm btn-light dropdown-toggle" data-bs-toggle="dropdown">
              <i class="fa fa-globe fa-fw"></i>
              {if $selected_country}
                <span>{$selected_country['country_name']}</span>
              {else}
                <span>{__("All Countries")}</span>
              {/if}
            </button>
            <div class="dropdown-menu dropdown-menu-end countries-dropdown">
              <div class="js_scroller">
                <a class="dropdown-item" href="?{if $distance}distance={$distance}{if $sort}&{/if}{/if}{if $sort}sort={$sort}{/if}">
                  {__("All Countries")}
                </a>
                {foreach $countries as $country}
                  <a class="dropdown-item" href="?country={$country['country_name_native']}{if $distance}&distance={$distance}{/if}{if $sort}&sort={$sort}{/if}">
                    {$country['country_name']}
                  </a>
                {/foreach}
              </div>
            </div>
          </div>
        </div>
        <!-- country filter -->
      </div>

      {if $rows}
        <div class="row">
          {foreach $rows as $post}
            {include file='__feeds_job.tpl'}
          {/foreach}
        </div>

        {$pager}
      {else}
        {include file='_no_data.tpl'}
      {/if}
    </div>
    <!-- right panel -->

  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}