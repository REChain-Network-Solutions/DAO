<div class="card">
  {if $sub_view == ""}

    <!-- card-header -->
    <div class="card-header with-icon with-nav">
      <!-- panel title -->
      <div class="mb20">
        <i class="fa fa-star mr5"></i>{__("Merits System")}
      </div>
      <!-- panel title -->

      <!-- panel nav -->
      <ul class="nav nav-tabs">
        <li class="nav-item">
          <a class="nav-link active" href="#General" data-bs-toggle="tab">
            <i class="fa fa-server fa-fw mr5"></i><strong>{__("General")}</strong>
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#Notifications" data-bs-toggle="tab">
            <i class="fa fa-bell fa-fw mr5"></i><strong>{__("Notifications")}</strong>
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#Widgets" data-bs-toggle="tab">
            <i class="fa fa-dice-d6 fa-fw mr5"></i><strong>{__("Widgets")}</strong>
          </a>
        </li>
      </ul>
      <!-- panel nav -->
    </div>
    <!-- card-header -->

    <!-- tab-content -->
    <div class="tab-content">
      <!-- General -->
      <div class="tab-pane active" id="General">
        <form class="js_ajax-forms" data-url="admin/settings.php?edit=merits_settings">
          <div class="card-body">
            <div class="form-table-row">
              <div class="avatar">
                {include file='__svg_icons.tpl' icon="merits" class="main-icon" width="40px" height="40px"}
              </div>
              <div>
                <div class="form-label h6">{__("Merits")}</div>
                <div class="form-text d-none d-sm-block">{__("Turn the merits system on or off")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="merits_enabled">
                  <input type="checkbox" name="merits_enabled" id="merits_enabled" {if $system['merits_enabled']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>

            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Max Merits Per Peroid")}
              </label>
              <div class="col-md-9">
                <input type="text" class="form-control" name="merits_peroid_max" value="{$system['merits_peroid_max']}">
                <div class="form-text">
                  {__("The maximum number of merits that user can have in a merits cycle")}
                </div>
              </div>
            </div>

            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Max Sent Merits Per User")}
              </label>
              <div class="col-md-9">
                <input type="text" class="form-control" name="merits_send_peroid_max" value="{$system['merits_send_peroid_max']}">
                <div class="form-text">
                  {__("The maximum number of merits that can be sent to the same user from same user in a merits cycle")}
                </div>
              </div>
            </div>

            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Periodicity")}
              </label>
              <div class="col-md-9">
                <select class="form-select" name="merits_peroid">
                  <option {if $system['merits_peroid'] == "1"}selected{/if} value="1">{__("Monthly")}</option>
                  <option {if $system['merits_peroid'] == "3"}selected{/if} value="3">{__("Quarterly")}</option>
                  <option {if $system['merits_peroid'] == "6"}selected{/if} value="6">{__("Half Yearly")}</option>
                  <option {if $system['merits_peroid'] == "12"}selected{/if} value="12">{__("Yearly")}</option>
                </select>
                <div class="form-text">
                  {__("Select the peroid of the merits system")}
                </div>
              </div>
            </div>

            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Cycle Reset")}
              </label>
              <div class="col-md-9">
                <select class="form-select" name="merits_peroid_reset">
                  <option {if $system['merits_peroid_reset'] == "1"}selected{/if} value="1">{__("Firt of the month")}</option>
                  <option {if $system['merits_peroid_reset'] == "15"}selected{/if} value="15">{__("Middle of the month")}</option>
                </select>
                <div class="form-text">
                  {__("Start day for every cycle for the merits system")}
                </div>
              </div>
            </div>

            <div class="divider dashed"></div>

            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Cycle Start Date")}
              </label>
              <div class="col-md-9">
                {if $system['merits_enabled']}
                  {$cycle_dates['start_date']}
                {else}
                  {__("N/A")}
                {/if}
              </div>
            </div>

            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Cycle End Date")}
              </label>
              <div class="col-md-9">
                {if $system['merits_enabled']}
                  {$cycle_dates['end_date']}
                {else}
                  {__("N/A")}
                {/if}
              </div>
            </div>

            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Cycle Reset Date")}
              </label>
              <div class="col-md-9">
                {if $system['merits_enabled']}
                  {$cycle_dates['reset_date']}
                {else}
                  {__("N/A")}
                {/if}
              </div>
            </div>

            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Cycle Reminder Date")}
              </label>
              <div class="col-md-9">
                {if $system['merits_enabled']}
                  {$cycle_dates['reminder_date']}
                {else}
                  {__("N/A")}
                {/if}
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
      <!-- General -->

      <!-- Notifications -->
      <div class="tab-pane" id="Notifications">
        <form class="js_ajax-forms" data-url="admin/settings.php?edit=merits_notifications">
          <div class="card-body">
            <div class="form-table-row">
              <div>
                <div class="form-label h6">{__("Merits Credit Recharge")}</div>
                <div class="form-text d-none d-sm-block">{__("Notify when new amounts of merits have been added to users accounts")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="merits_notifications_recharge">
                  <input type="checkbox" name="merits_notifications_recharge" id="merits_notifications_recharge" {if $system['merits_notifications_recharge']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>

            <div class="form-table-row">
              <div>
                <div class="form-label h6">{__("Merits Remainder")}</div>
                <div class="form-text d-none d-sm-block">{__("Remainder to use remaining merits 7 days before each cycle reset")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="merits_notifications_reminder">
                  <input type="checkbox" name="merits_notifications_reminder" id="merits_notifications_reminder" {if $system['merits_notifications_reminder']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>

            <div class="form-table-row">
              <div>
                <div class="form-label h6">{__("Recipient Merits Notification")}</div>
                <div class="form-text d-none d-sm-block">{__("Notify the recipients when they receive a badge")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="merits_notifications_recipient">
                  <input type="checkbox" name="merits_notifications_recipient" id="merits_notifications_recipient" {if $system['merits_notifications_recipient']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>

            <div class="form-table-row">
              <div>
                <div class="form-label h6">{__("Sender Merits Notification")}</div>
                <div class="form-text d-none d-sm-block">{__("Notify the sender when their badge has been received")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="merits_notifications_sender">
                  <input type="checkbox" name="merits_notifications_sender" id="merits_notifications_sender" {if $system['merits_notifications_sender']}checked{/if}>
                  <span class="slider round"></span>
                </label>
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
      <!-- Notifications -->

      <!-- Widgets -->
      <div class="tab-pane" id="Widgets">
        <form class="js_ajax-forms" data-url="admin/settings.php?edit=merits_widgets">
          <div class="card-body">
            <div class="form-table-row">
              <div>
                <div class="form-label h6">{__("Merits Newsfeed Carosel")}</div>
                <div class="form-text d-none d-sm-block">{__("Show at top of newsfeed a carousel of badge categories, including a link to the ranking section")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="merits_widgets_newsfeed">
                  <input type="checkbox" name="merits_widgets_newsfeed" id="merits_widgets_newsfeed" {if $system['merits_widgets_newsfeed']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>

            <div class="form-table-row">
              <div>
                <div class="form-label h6">{__("Personal Balance Widget")}</div>
                <div class="form-text d-none d-sm-block">{__("Post in the right column the personal balance of available badges with a link that pops up to start giving these badges to other users")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="merits_widgets_balance">
                  <input type="checkbox" name="merits_widgets_balance" id="merits_widgets_balance" {if $system['merits_widgets_balance']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>

            <div class="form-table-row">
              <div>
                <div class="form-label h6">{__("Top Winners Widget")}</div>
                <div class="form-text d-none d-sm-block">{__("Post in right column with a carousel the recent winners")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="merits_widgets_winners">
                  <input type="checkbox" name="merits_widgets_winners" id="merits_widgets_winners" {if $system['merits_widgets_winners']}checked{/if}>
                  <span class="slider round"></span>
                </label>
              </div>
            </div>

            <div class="form-table-row">
              <div>
                <div class="form-label h6">{__("Badge Statistics Widget")}</div>
                <div class="form-text d-none d-sm-block">{__("Post annual badge statistics under each user profile picture, the total number of earned badges, badges that have been sent by the user, and the amount of left badges to give in current cycle")}</div>
              </div>
              <div class="text-end">
                <label class="switch" for="merits_widgets_statistics">
                  <input type="checkbox" name="merits_widgets_statistics" id="merits_widgets_statistics" {if $system['merits_widgets_statistics']}checked{/if}>
                  <span class="slider round"></span>
                </label>
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
      <!-- Widgets -->
    </div>

  {elseif $sub_view == "categories"}

    <div class="card-header with-icon">
      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/merits/add_category" class="btn btn-md btn-primary">
          <i class="fa fa-plus"></i><span class="ml5 d-none d-lg-inline-block">{__("Add New Category")}</span>
        </a>
      </div>
      <i class="fa fa-star mr5"></i>{__("Merits System")} &rsaquo; {__("Categories")}
    </div>

    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover js_treegrid">
          <thead>
            <tr>
              <th>{__("Title")}</th>
              <th>{__("Image")}</th>
              <th>{__("Description")}</th>
              <th>{__("Order")}</th>
              <th>{__("Actions")}</th>
            </tr>
          </thead>
          <tbody>
            {if $rows}
              {foreach $rows as $row}
                {include file='__categories.recursive_rows.tpl' _url="merits" _handle="merit_category" _has_image=true}
              {/foreach}
            {else}
              <tr>
                <td colspan="5" class="text-center">
                  {__("No data to show")}
                </td>
              </tr>
            {/if}
          </tbody>
        </table>
      </div>
    </div>

  {elseif $sub_view == "add_category"}

    <div class="card-header with-icon">

      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/merits/categories" class="btn btn-md btn-light">
          <i class="fa fa-arrow-circle-left"></i><span class="ml5 d-none d-lg-inline-block">{__("Go Back")}</span>
        </a>
      </div>
      <i class="fa fa-star mr5"></i>{__("Merits System")} &rsaquo; {__("Categories")} &rsaquo; {__("Add New Category")}
    </div>

    <form class="js_ajax-forms" data-url="admin/merits.php?do=add_category">
      <div class="card-body">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Name")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="category_name">
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="category_description" rows="3"></textarea>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Parent Category")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="category_parent_id">
              <option value="0">{__("Set as a Parent Category")}</option>
              {foreach $categories as $category}
                {include file='__categories.recursive_options.tpl'}
              {/foreach}
            </select>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Image")}
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
              <input type="hidden" class="js_x-image-input" name="category_image" value="">
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Order")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="category_order">
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

  {elseif $sub_view == "edit_category"}

    <div class="card-header with-icon">
      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/merits/categories" class="btn btn-md btn-light">
          <i class="fa fa-arrow-circle-left"></i><span class="ml5 d-none d-lg-inline-block">{__("Go Back")}</span>
        </a>
      </div>
      <i class="fa fa-star mr5"></i>{__("Merits System")} &rsaquo; {__("Categories")} &rsaquo; {$data['category_name']}
    </div>

    <form class="js_ajax-forms" data-url="admin/merits.php?do=edit_category&id={$data['category_id']}">
      <div class="card-body">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Name")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="category_name" value="{$data['category_name']}">
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Description")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" name="category_description" rows="3">{$data['category_description']}</textarea>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Parent Category")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="category_parent_id">
              <option value="0">{__("Set as a Parent Category")}</option>
              {foreach $data["categories"] as $category}
                {include file='__categories.recursive_options.tpl' data_category=$data['category_parent_id']}
              {/foreach}
            </select>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Image")}
          </label>
          <div class="col-md-9">
            {if $data['category_image'] == ''}
              <div class="x-image">
                <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-image-input" name="category_image" value="">
              </div>
            {else}
              <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$data['category_image']}')">
                <button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'></button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-image-input" name="category_image" value="{$data['category_image']}">
              </div>
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Order")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="category_order" value="{$data['category_order']}">
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