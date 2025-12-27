<div class="card">
  <div class="card-header with-icon">
    <i class="fa-solid fa-money-check-dollar mr10"></i>{__("Paid Modules")}
  </div>

  <form class="js_ajax-forms" data-url="admin/settings.php?edit=paid_modules">
    <div class="card-body">

      <div class="alert alert-primary">
        <div class="icon">
          <i class="fas fa-money-check-dollar fa-2x"></i>
        </div>
        <div class="text">
          <strong>{__("Paid Modules")}</strong><br>
          {__("Paid modules are used to charge users for certain posts on the platform")}.<br>
          {__("Cost will be deducted from user's wallet balance")}.<br>
          {__("Make sure you have enabled")} <a class="text-warning" href="{$system['system_url']}/{$control_panel['url']}/wallet">{__("Wallet System")}</a>
        </div>
      </div>

      <div class="form-table-row">
        <div class="avatar">
          {include file='__svg_icons.tpl' icon="blogs" class="main-icon" width="40px" height="40px"}
        </div>
        <div>
          <div class="form-label h6">{__("Paid Blogs")}</div>
          <div class="form-text d-none d-sm-block">
            {__("Turn the paid blogs On and Off")}
          </div>
        </div>
        <div class="text-end">
          <label class="switch" for="paid_blogs_enabled">
            <input type="checkbox" name="paid_blogs_enabled" id="paid_blogs_enabled" {if $system['paid_blogs_enabled']}checked{/if}>
            <span class="slider round"></span>
          </label>
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("Cost")} ({$system['system_currency']})
        </label>
        <div class="col-md-9">
          <input type="text" class="form-control" name="paid_blogs_cost" value="{$system['paid_blogs_cost']}">
          <div class="form-text">
            {__("The cost per blog post")}
          </div>
        </div>
      </div>

      <div class="divider"></div>

      <div class="form-table-row">
        <div class="avatar">
          {include file='__svg_icons.tpl' icon="products" class="main-icon" width="40px" height="40px"}
        </div>
        <div>
          <div class="form-label h6">{__("Paid Products")}</div>
          <div class="form-text d-none d-sm-block">
            {__("Turn the paid products On and Off")}
          </div>
        </div>
        <div class="text-end">
          <label class="switch" for="paid_products_enabled">
            <input type="checkbox" name="paid_products_enabled" id="paid_products_enabled" {if $system['paid_products_enabled']}checked{/if}>
            <span class="slider round"></span>
          </label>
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("Cost")} ({$system['system_currency']})
        </label>
        <div class="col-md-9">
          <input type="text" class="form-control" name="paid_products_cost" value="{$system['paid_products_cost']}">
          <div class="form-text">
            {__("The cost per product post")}
          </div>
        </div>
      </div>

      <div class="divider"></div>

      <div class="form-table-row">
        <div class="avatar">
          {include file='__svg_icons.tpl' icon="funding" class="main-icon" width="40px" height="40px"}
        </div>
        <div>
          <div class="form-label h6">{__("Paid Funding")}</div>
          <div class="form-text d-none d-sm-block">
            {__("Turn the paid funding On and Off")}
          </div>
        </div>
        <div class="text-end">
          <label class="switch" for="paid_funding_enabled">
            <input type="checkbox" name="paid_funding_enabled" id="paid_funding_enabled" {if $system['paid_funding_enabled']}checked{/if}>
            <span class="slider round"></span>
          </label>
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("Cost")} ({$system['system_currency']})
        </label>
        <div class="col-md-9">
          <input type="text" class="form-control" name="paid_funding_cost" value="{$system['paid_funding_cost']}">
          <div class="form-text">
            {__("The cost per funding post")}
          </div>
        </div>
      </div>

      <div class="divider"></div>

      <div class="form-table-row">
        <div class="avatar">
          {include file='__svg_icons.tpl' icon="offers" class="main-icon" width="40px" height="40px"}
        </div>
        <div>
          <div class="form-label h6">{__("Paid Offers")}</div>
          <div class="form-text d-none d-sm-block">
            {__("Turn the paid offers On and Off")}
          </div>
        </div>
        <div class="text-end">
          <label class="switch" for="paid_offers_enabled">
            <input type="checkbox" name="paid_offers_enabled" id="paid_offers_enabled" {if $system['paid_offers_enabled']}checked{/if}>
            <span class="slider round"></span>
          </label>
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("Cost")} ({$system['system_currency']})
        </label>
        <div class="col-md-9">
          <input type="text" class="form-control" name="paid_offers_cost" value="{$system['paid_offers_cost']}">
          <div class="form-text">
            {__("The cost per offer post")}
          </div>
        </div>
      </div>

      <div class="divider"></div>

      <div class="form-table-row">
        <div class="avatar">
          {include file='__svg_icons.tpl' icon="jobs" class="main-icon" width="40px" height="40px"}
        </div>
        <div>
          <div class="form-label h6">{__("Paid Jobs")}</div>
          <div class="form-text d-none d-sm-block">
            {__("Turn the paid jobs On and Off")}
          </div>
        </div>
        <div class="text-end">
          <label class="switch" for="paid_jobs_enabled">
            <input type="checkbox" name="paid_jobs_enabled" id="paid_jobs_enabled" {if $system['paid_jobs_enabled']}checked{/if}>
            <span class="slider round"></span>
          </label>
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("Cost")} ({$system['system_currency']})
        </label>
        <div class="col-md-9">
          <input type="text" class="form-control" name="paid_jobs_cost" value="{$system['paid_jobs_cost']}">
          <div class="form-text">
            {__("The cost per job post")}
          </div>
        </div>
      </div>

      <div class="divider"></div>

      <div class="form-table-row">
        <div class="avatar">
          {include file='__svg_icons.tpl' icon="courses" class="main-icon" width="40px" height="40px"}
        </div>
        <div>
          <div class="form-label h6">{__("Paid Courses")}</div>
          <div class="form-text d-none d-sm-block">
            {__("Turn the paid courses On and Off")}
          </div>
        </div>
        <div class="text-end">
          <label class="switch" for="paid_courses_enabled">
            <input type="checkbox" name="paid_courses_enabled" id="paid_courses_enabled" {if $system['paid_courses_enabled']}checked{/if}>
            <span class="slider round"></span>
          </label>
        </div>
      </div>

      <div class="row form-group">
        <label class="col-md-3 form-label">
          {__("Cost")} ({$system['system_currency']})
        </label>
        <div class="col-md-9">
          <input type="text" class="form-control" name="paid_courses_cost" value="{$system['paid_courses_cost']}">
          <div class="form-text">
            {__("The cost per course post")}
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