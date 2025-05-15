{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="{if $system['fluid_design']}container-fluid{else}container{/if} mt20 sg-offcanvas">
  <div class="row">

    <!-- left panel -->
    <div class="col-md-4 col-lg-3 sg-offcanvas-sidebar js_sticky-sidebar">
      {include file='_sidebar.tpl'}
    </div>
    <!-- left panel -->

    <!-- content panel -->
    <div class="col-md-8 col-lg-9 sg-offcanvas-mainbar">

      <!-- content -->
      <div class="card">
        <div class="card-header bg-transparent">
          <strong>{__("Ranking")}</strong>
        </div>
        <div class="card-body">
          <form method="get" class="row row-cols-lg-auto g-3 align-items-center">
            <div class="col-12">
              <select class="form-select" name="category" id="category">
                <option value="all">{__("All")}</option>
                {foreach $merits_categories as $category}
                  {include file='__categories.recursive_options.tpl' data_category=$config['category']}
                {/foreach}
              </select>
            </div>
            <div class="col-12">
              <!-- start date picker -->
              <div class="input-group">
                <span class="input-group-text">{__("From")}</span>
                <input type="date" class="form-control" name="start_date" value="{$config['start_date']}" />
              </div>
              <!-- start date picker -->
            </div>
            <div class="col-12">
              <!-- end date picker -->
              <div class="input-group">
                <span class="input-group-text">{__("To")}</span>
                <input type="date" class="form-control" name="end_date" value="{$config['end_date']}" />
              </div>
              <!-- end date picker -->
            </div>
            <div class="col-12">
              <button type="submit" class="btn btn-md btn-primary">{__("Filter")}</button>
            </div>
          </form>
          {if $merits_ranking_users}
            <div class="table-responsive mt20">
              <table class="table table-striped table-bordered table-hover">
                <thead>
                  <tr>
                    <th>{__("Rank")}</th>
                    <th>{__("User")}</th>
                    <th>{__("Amount")}</th>
                  </tr>
                </thead>
                <tbody>
                  {foreach $merits_ranking_users as $_user}
                    <tr>
                      <td>{$_user@iteration}</td>
                      <td>
                        <a target="_blank" href="{$system['system_url']}/{$_user['user_name']}">
                          <img class="tbl-image" src="{$_user['user_picture']}">
                          {if $system['show_usernames_enabled']}{$_user['user_name']}{else}{$_user['user_firstname']} {$_user['user_lastname']}{/if}
                        </a>
                      </td>
                      <td>{$_user['count']}</td>
                    </tr>
                  {/foreach}
                </tbody>
              </table>
            </div>
          {else}
            <p class="text-center text-muted mt20">
              {__("No people available")}
            </p>
          {/if}
        </div>
      </div>
      <!-- content -->
    </div>
    <!-- content panel -->

  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}