<div class="card">
  <div class="card-header with-icon">
    {if $sub_view == ""}
      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/widgets/add" class="btn btn-md btn-primary">
          <i class="fa fa-plus mr5"></i>{__("Add New widget")}
        </a>
      </div>
    {else}
      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/widgets" class="btn btn-md btn-light">
          <i class="fa fa-arrow-circle-left mr5"></i>{__("Go Back")}
        </a>
      </div>
    {/if}
    <i class="fa fa-puzzle-piece mr10"></i>{__("Widgets")}
    {if $sub_view == "edit"} &rsaquo; {$data['title']}{/if}
    {if $sub_view == "add"} &rsaquo; {__("Add New widget")}{/if}
  </div>

  {if $sub_view == ""}

    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover js_dataTable">
          <thead>
            <tr>
              <th>{__("ID")}</th>
              <th>{__("Title")}</th>
              <th>{__("Place")}</th>
              <th>{__("Langauge")}</th>
              <th>{__("Audience")}</th>
              <th>{__("Order")}</th>
              <th>{__("Actions")}</th>
            </tr>
          </thead>
          <tbody>
            {foreach $rows as $row}
              <tr>
                <td>{$row['widget_id']}</td>
                <td>{$row['title']}</td>
                <td>
                  {if $row['place'] == "home"}<i class='fa fa-home fa-fw mr5'></i>{__("Home Page")}{/if}
                  {if $row['place'] == "search"}<i class='fa fa-search fa-fw mr5'></i>{__("Search Page")}{/if}
                  {if $row['place'] == "people"}<i class='fa fa-users fa-fw mr5'></i>{__("Discover People Page")}{/if}
                  {if $row['place'] == "notifications"}<i class='fa fa-bell fa-fw mr5'></i>{__("Notifications Page")}{/if}
                  {if $row['place'] == "post"}<i class='fa fa-file-powerpoint fa-fw mr5'></i>{__("Post Page")}{/if}
                  {if $row['place'] == "photo"}<i class='fa fa-file-image fa-fw mr5'></i>{__("Photo Page")}{/if}
                  {if $row['place'] == "blog"}<i class='fa fa-file-alt fa-fw mr5'></i>{__("Blog Page")}{/if}
                  {if $row['place'] == "directory"}<i class='fa fa-th-list fa-fw mr5'></i>{__("Directory Page")}{/if}
                  {if $row['place'] == "newsfeed_top"}<i class='fa fa-newspaper fa-fw mr5'></i>{__("Newsfeed Top")}{/if}
                  {if $row['place'] == "newfeed_1"}<i class='fa fa-newspaper fa-fw mr5'></i>{__("Posts Feed")} 1{/if}
                  {if $row['place'] == "newfeed_2"}<i class='fa fa-newspaper fa-fw mr5'></i>{__("Posts Feed")} 2{/if}
                  {if $row['place'] == "newfeed_3"}<i class='fa fa-newspaper fa-fw mr5'></i>{__("Posts Feed")} 3{/if}
                </td>
                <td>
                  {if $row['language_id'] == 0}{__("All Languages")}{else}{$row['language_title']}{/if}
                </td>
                <td>
                  {if $row['target_audience'] == "all"}{__("All")}{/if}
                  {if $row['target_audience'] == "members"}{__("Members")}{/if}
                  {if $row['target_audience'] == "visitors"}{__("Visitors")}{/if}
                </td>
                <td>{$row['place_order']}</td>
                <td>
                  <a data-bs-toggle="tooltip" title='{__("Edit")}' href="{$system['system_url']}/{$control_panel['url']}/widgets/edit/{$row['widget_id']}" class="btn btn-sm btn-icon btn-rounded btn-primary">
                    <i class="fa fa-pencil-alt"></i>
                  </a>
                  <button data-bs-toggle="tooltip" title='{__("Delete")}' class="btn btn-sm btn-icon btn-rounded btn-danger js_admin-deleter" data-handle="widget" data-id="{$row['widget_id']}">
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

    <form class="js_ajax-forms" data-url="admin/widgets.php?do=edit&id={$data['widget_id']}">
      <div class="card-body">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Title")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="title" value="{$data['title']}">
            <div class="form-text text-muted">{__("The title of the widget")}</div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Place")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="place">
              <option {if $data['place'] == "home"}selected{/if} value="home">{__("Home")}</option>
              <option {if $data['place'] == "search"}selected{/if} value="search">{__("Search")}</option>
              <option {if $data['place'] == "people"}selected{/if} value="people">{__("Discover People")}</option>
              <option {if $data['place'] == "notifications"}selected{/if} value="notifications">{__("Notifications")}</option>
              <option {if $data['place'] == "post"}selected{/if} value="post">{__("Post")}</option>
              <option {if $data['place'] == "photo"}selected{/if} value="photo">{__("Photo")}</option>
              <option {if $data['place'] == "blog"}selected{/if} value="blog">{__("Blog Page")}</option>
              <option {if $data['place'] == "directory"}selected{/if} value="directory">{__("Directory")}</option>
              <option {if $data['place'] == "newsfeed_top"}selected{/if} value="newsfeed_top">{__("Newsfeed Top")}</option>
              <option {if $data['place'] == "newfeed_1"}selected{/if} value="newfeed_1">{__("Posts Feed")} 1</option>
              <option {if $data['place'] == "newfeed_2"}selected{/if} value="newfeed_2">{__("Posts Feed")} 2</option>
              <option {if $data['place'] == "newfeed_3"}selected{/if} value="newfeed_3">{__("Posts Feed")} 3</option>
            </select>
            <div class="form-text text-muted">{__("Where to show this widget")}</div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Language")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="language_id">
              <option {if $data['language_id'] == "0"}selected{/if} value="0">{__("All Languages")}</option>
              {foreach $system['languages'] as $language}
                <option {if $data['language_id'] == $language['language_id']}selected{/if} value="{$language['language_id']}">{$language['title']}</option>
              {/foreach}
            </select>
            <div class="form-text text-muted">{__("For whcih language this widget will be shown")}</div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Target Audience")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="target_audience">
              <option {if $data['target_audience'] == "all"}selected{/if} value="all">{__("Both Members and Visitors")}</option>
              <option {if $data['target_audience'] == "members"}selected{/if} value="members">{__("Only Members")}</option>
              <option {if $data['target_audience'] == "visitors"}selected{/if} value="visitors">{__("Only Visitors")}</option>
            </select>
            <div class="form-text text-muted">{__("For whcih target audience this widget will be shown")}</div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Order")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="place_order" value="{$data['place_order']}">
            <div class="form-text text-muted">{__("The order of this widget in the selected place")}</div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("HTML")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="message" rows="8">{$data['code']}</textarea>
            <div class="form-text text-muted">{__("The HTML code of the widget")}</div>
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

    <form class="js_ajax-forms" data-url="admin/widgets.php?do=add">
      <div class="card-body">

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Title")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="title">
            <div class="form-text text-muted">{__("The title of the widget")}</div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Place")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="place">
              <option value="home">{__("Home")}</option>
              <option value="search">{__("Search")}</option>
              <option value="people">{__("Discover People")}</option>
              <option value="notifications">{__("Notifications")}</option>
              <option value="post">{__("Post")}</option>
              <option value="photo">{__("Photo")}</option>
              <option value="blog">{__("Blog Page")}</option>
              <option value="directory">{__("Directory")}</option>
              <option value="newsfeed_top">{__("Newsfeed Top")}</option>
              <option value="newfeed_1">{__("Posts Feed")} 1</option>
              <option value="newfeed_2">{__("Posts Feed")} 2</option>
              <option value="newfeed_3">{__("Posts Feed")} 3</option>
            </select>
            <div class="form-text text-muted">{__("Where to show this widget")}</div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Language")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="language_id">
              <option value="0">{__("All Languages")}</option>
              {foreach $system['languages'] as $language}
                <option value="{$language['language_id']}">{$language['title']}</option>
              {/foreach}
            </select>
            <div class="form-text text-muted">{__("For whcih language this widget will be shown")}</div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Target Audience")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="target_audience">
              <option value="all">{__("Both Members and Visitors")}</option>
              <option value="members">{__("Only Members")}</option>
              <option value="visitors">{__("Only Visitors")}</option>
            </select>
            <div class="form-text text-muted">{__("For whcih target audience this widget will be shown")}</div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Order")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="place_order">
            <div class="form-text text-muted">{__("The order of this widget in the selected place")}</div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("HTML")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="message" rows="8"></textarea>
            <div class="form-text text-muted">{__("The HTML code of the widget")}</div>
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