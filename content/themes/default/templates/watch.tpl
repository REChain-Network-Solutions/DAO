{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page header -->
<div class="page-header">
  <img class="floating-img d-none d-md-block" src="{$system['system_url']}/content/themes/{$system['theme']}/images/headers/undraw_video-files_cxl9.svg">
  <div class="circle-2"></div>
  <div class="circle-3"></div>
  <div class="{if $system['fluid_design']}container-fluid{else}container{/if}">
    <h2>{__("Watch")}</h2>
    <p class="text-xlg">{__($system['system_description_watch'])}</p>
    <div class="row mt20">
      <div class="col-sm-9 col-lg-6 mx-sm-auto">
        <form class="js_search-form" data-filter="posts" data-type="video">
          <div class="input-group">
            <input type="text" class="form-control" name="query" placeholder='{__("Search for videos")}'>
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
        <li {if $view == "" || $view == "category"}class="active" {/if}>
          <a href="{$system['system_url']}/watch">{__("Discover")}</a>
        </li>
      </ul>
    </div>
    <!-- tabs -->
  </div>

  <div class="row">

    {if $view == "" || $view == "category"}
      <!-- left panel -->
      <div class="col-md-4 col-lg-3 sg-offcanvas-sidebar">
        <!-- categories -->
        <div class="card">
          <div class="card-body with-nav">
            <ul class="side-nav">
              {if $view != "category"}
                <li class="active">
                  <a href="{$system['system_url']}/watch">
                    {__("All")}
                  </a>
                </li>
              {else}
                <li>
                  {if $current_category['parent']}
                    <a href="{$system['system_url']}/watch/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
                      <i class="fas fa-arrow-alt-circle-left mr5"></i>{__($current_category['parent']['category_name'])}
                    </a>
                  {else}
                    <a href="{$system['system_url']}/watch">
                      {if $current_category['sub_categories']}<i class="fas fa-arrow-alt-circle-left mr5"></i>{/if}{__("All")}
                    </a>
                  {/if}
                </li>
              {/if}
              {foreach $categories as $category}
                <li {if $view == "category" && $current_category['category_id'] == $category['category_id']}class="active" {/if}>
                  <a href="{$system['system_url']}/watch/category/{$category['category_id']}/{$category['category_url']}">
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
    {else}
      <!-- side panel -->
      <div class="col-12 d-block d-md-none sg-offcanvas-sidebar mt40">
        {include file='_sidebar.tpl'}
      </div>
      <!-- side panel -->
    {/if}

    <!-- content panel -->
    <div class="{if $view == "" || $view == "category"}col-md-8 col-lg-9 sg-offcanvas-mainbar{else}col-12 sg-offcanvas-mainbar{/if}">

      <div class="posts-filter">
        <span>{$view_title}</span>
        <div class="float-end">
          <!-- location filter -->
          {if $system['newsfeed_location_filter_enabled']}
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
          {/if}
          <!-- location filter -->
        </div>
      </div>

      <!-- content -->
      <div>
        <!-- videos posts -->
        {include file='_posts.tpl' _get="discover" _filter="video" _category=$current_category['category_id'] _load_more="watch" _title=__("Watch") _no_filter=true}
        <!-- videos posts -->
      </div>
      <!-- content -->

    </div>
    <!-- content panel -->

  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}