<div class="card">
  <div class="card-header with-icon">
    {if $sub_view == ""}
      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/static/add" class="btn btn-md btn-primary">
          <i class="fa fa-plus mr5"></i>{__("Add New Page")}
        </a>
      </div>
    {else}
      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/static" class="btn btn-md btn-light">
          <i class="fa fa-arrow-circle-left mr5"></i>{__("Go Back")}
        </a>
      </div>
    {/if}
    <i class="fa fa-file mr10"></i>{__("Static Pages")}
    {if $sub_view == "edit"} &rsaquo; {$data['page_title']}{/if}
    {if $sub_view == "add"} &rsaquo; {__("Add New Page")}{/if}
  </div>

  {if $sub_view == ""}

    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover js_dataTable">
          <thead>
            <tr>
              <th>{__("ID")}</th>
              <th>{__("Page Title")}</th>
              <th>{__("Is Redirect")}</th>
              <th>{__("In Footer")}</th>
              <th>{__("In Sidebar")}</th>
              <th>{__("Order")}</th>
              <th>{__("Actions")}</th>
            </tr>
          </thead>
          <tbody>
            {foreach $rows as $row}
              <tr>
                <td>{$row['page_id']}</td>
                <td>
                  <a target="_blank" href="{$row['url']}">
                    {$row['page_title']}
                  </a>
                </td>
                <td>
                  {if $row['page_is_redirect']}
                    <span class="badge rounded-pill badge-lg bg-success">{__("Yes")}</span>
                  {else}
                    <span class="badge rounded-pill badge-lg bg-danger">{__("No")}</span>
                  {/if}
                <td>
                  {if $row['page_in_footer']}
                    <span class="badge rounded-pill badge-lg bg-success">{__("Yes")}</span>
                  {else}
                    <span class="badge rounded-pill badge-lg bg-danger">{__("No")}</span>
                  {/if}
                </td>
                <td>
                  {if $row['page_in_sidebar']}
                    <span class="badge rounded-pill badge-lg bg-success">{__("Yes")}</span>
                  {else}
                    <span class="badge rounded-pill badge-lg bg-danger">{__("No")}</span>
                  {/if}
                <td>{$row['page_order']}</td>
                <td>
                  <a data-bs-toggle="tooltip" title='{__("Edit")}' href="{$system['system_url']}/{$control_panel['url']}/static/edit/{$row['page_id']}" class="btn btn-sm btn-icon btn-rounded btn-primary">
                    <i class="fa fa-pencil-alt"></i>
                  </a>
                  <button data-bs-toggle="tooltip" title='{__("Delete")}' class="btn btn-sm btn-icon btn-rounded btn-danger js_admin-deleter" data-handle="static_page" data-id="{$row['page_id']}">
                    <i class="fa fa-trash-alt"></i>
                  </button>
                </td>
              </tr>
            {/foreach}
          </tbody>
        </table>
      </div>
    </div>

  {elseif $sub_view == "edit"}

    <form class="js_ajax-forms" data-url="admin/static.php?do=edit&id={$data['page_id']}">
      <div class="card-body">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Page Title")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="page_title" value="{$data['page_title']}">
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Redirect Link")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="js_page-is-redirect">
              <input type="checkbox" name="page_is_redirect" id="js_page-is-redirect" {if $data['page_is_redirect']}checked{/if}>
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Enable this option if you want to create a page that redirects to an external link")}
            </div>
          </div>
        </div>

        <div id="js_page-redirect" {if !$data['page_is_redirect']}class="x-hidden" {/if}>
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Redirect URL")}
            </label>
            <div class="col-md-9">
              <input class="form-control" name="page_redirect_url" value="{$data['page_redirect_url']}">
              <div class="form-text">
                {__("The URL to redirect to")}
              </div>
            </div>
          </div>
        </div>

        <div id="js_page-not-redirect" {if $data['page_is_redirect']}class="x-hidden" {/if}>
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Web Address")}
            </label>
            <div class="col-md-9">
              <div class="input-group">
                <span class="input-group-text d-none d-sm-block">{$system['system_url']}/static/</span>
                <input type="text" class="form-control" name="page_url" value="{$data['page_url']}">
              </div>
              <div class="form-text">
                {__("Valid web address must be a-z0-9_.")}
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Page Content")}
            </label>
            <div class="col-md-9">
              <textarea class="form-control js_wysiwyg-advanced" name="page_text">{$data['page_text']}</textarea>
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Add to Footer Menu")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="page_in_footer">
              <input type="checkbox" name="page_in_footer" id="page_in_footer" {if $data['page_in_footer']}checked{/if}>
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Show the page in the footer menu")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Add to Sidebar Menu")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="page_in_sidebar">
              <input type="checkbox" name="page_in_sidebar" id="page_in_sidebar" {if $data['page_in_sidebar']}checked{/if}>
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Show the page in the sidebar menu")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Sidebar Icon")}
          </label>
          <div class="col-md-9">
            {if $data['page_icon'] == ''}
              <div class="x-image">
                <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-image-input" name="page_icon" value="">
              </div>
            {else}
              <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$data['page_icon']}')">
                <button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'></button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-image-input" name="page_icon" value="{$data['page_icon']}">
              </div>
            {/if}
            <div class="form-text">
              {__("The perfect size for your gift image should be (wdith: 48px & height: 48px)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Order")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="page_order" value="{$data['page_order']}">
            <div class="form-text">
              {__("The order of the page in the footer/sidebar menu")}
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

  {elseif $sub_view == "add"}

    <form class="js_ajax-forms" data-url="admin/static.php?do=add">
      <div class="card-body">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Page Title")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="page_title">
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Redirect Link")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="js_page-is-redirect">
              <input type="checkbox" name="page_is_redirect" id="js_page-is-redirect">
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Enable this option if you want to create a page that redirects to an external link")}
            </div>
          </div>
        </div>

        <div id="js_page-redirect" class="x-hidden">
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Redirect URL")}
            </label>
            <div class="col-md-9">
              <input class="form-control" name="page_redirect_url">
              <div class="form-text">
                {__("The URL to redirect to")}
              </div>
            </div>
          </div>
        </div>

        <div id="js_page-not-redirect">
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Web Address")}
            </label>
            <div class="col-md-9">
              <div class="input-group">
                <span class="input-group-text d-none d-sm-block">{$system['system_url']}/static/</span>
                <input type="text" class="form-control" name="page_url">
              </div>
              <div class="form-text">
                {__("Valid web address must be a-z0-9_.")}
              </div>
            </div>
          </div>
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Page Content")}
            </label>
            <div class="col-md-9">
              <textarea class="form-control js_wysiwyg-advanced" name="page_text"></textarea>
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Add to Footer Menu")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="page_in_footer">
              <input type="checkbox" name="page_in_footer" id="page_in_footer">
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Show the page in the footer menu")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Add to Sidebar Menu")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="page_in_sidebar">
              <input type="checkbox" name="page_in_sidebar" id="page_in_sidebar">
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Show the page in the sidebar menu")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Sidebar Icon")}
          </label>
          <div class="col-md-9">
            <div class="x-image">
              <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
              <div class="x-image-loader">
                <div class="progress x-progress">
                  <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
              </div>
              <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
              <input type="hidden" class="js_x-image-input" name="page_icon" value="">
            </div>
            <div class="form-text">
              {__("The perfect size for your icon (wdith: 48px & height: 48px)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Order")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="page_order">
            <div class="form-text">
              {__("The order of the page in the footer/sidebar menu")}
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

  {/if}
</div>