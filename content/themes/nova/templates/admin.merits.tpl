{if $sub_view == ""}
  <section class="admin-settings-page" aria-labelledby="admin-merits-title">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-merits-title" class="text-2xl font-semibold">{__("Merits Settings")}</h1>
      <p class="text-base-content/60 text-sm">{__("Cycles, notifications, and widgets for the merits system.")}</p>
    </div>

    <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Merits Settings")}" aria-orientation="vertical">
      <button type="button" id="merits-tab-general" class="tab active-tab:tab-active active" data-tab="#General" aria-controls="General" role="tab" aria-selected="true">
        <span class="icon-[tabler--star] size-4" aria-hidden="true"></span>{__("General")}
      </button>
      <button type="button" id="merits-tab-notifications" class="tab active-tab:tab-active" data-tab="#Notifications" aria-controls="Notifications" role="tab" aria-selected="false">
        <span class="icon-[tabler--bell] size-4" aria-hidden="true"></span>{__("Notifications")}
      </button>
      <button type="button" id="merits-tab-widgets" class="tab active-tab:tab-active" data-tab="#Widgets" aria-controls="Widgets" role="tab" aria-selected="false">
        <span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("Widgets")}
      </button>
    </nav>

    <div class="admin-settings-panel js_admin-settings-panel" id="General" role="tabpanel" tabindex="0">
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=merits_settings">
        <div class="admin-settings-layout block">
          <div class="admin-settings-form flex min-w-0 flex-col gap-4">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6">
                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon">
                    {include file='__svg_icons.tpl' icon="merits" class="admin-setting-glyph" width="32px" height="32px"}
                  </div>
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="merits_enabled">{__("Merits")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="merits_enabled-help">{__("Turn the merits system on or off")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="merits_enabled" id="merits_enabled" {if $system['merits_enabled']}checked{/if} aria-describedby="merits_enabled-help">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="merits_peroid_max">{__("Max Merits Per Peroid")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="merits_peroid_max" id="merits_peroid_max" value="{$system['merits_peroid_max']}" aria-describedby="merits_peroid_max-help" inputmode="numeric">
                    <div id="merits_peroid_max-help" class="admin-setting-help text-sm leading-relaxed">{__("The maximum number of merits that user can have in a merits cycle")}</div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="merits_send_peroid_max">{__("Max Sent Merits Per User")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="merits_send_peroid_max" id="merits_send_peroid_max" value="{$system['merits_send_peroid_max']}" aria-describedby="merits_send_peroid_max-help" inputmode="numeric">
                    <div id="merits_send_peroid_max-help" class="admin-setting-help text-sm leading-relaxed">{__("The maximum number of merits that can be sent to the same user from same user in a merits cycle")}</div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="merits_peroid">{__("Periodicity")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <select class="select w-full" name="merits_peroid" id="merits_peroid" aria-describedby="merits_peroid-help">
                      <option {if $system['merits_peroid'] == "1"}selected{/if} value="1">{__("Monthly")}</option>
                      <option {if $system['merits_peroid'] == "3"}selected{/if} value="3">{__("Quarterly")}</option>
                      <option {if $system['merits_peroid'] == "6"}selected{/if} value="6">{__("Half Yearly")}</option>
                      <option {if $system['merits_peroid'] == "12"}selected{/if} value="12">{__("Yearly")}</option>
                    </select>
                    <div id="merits_peroid-help" class="admin-setting-help text-sm leading-relaxed">{__("Select the peroid of the merits system")}</div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="merits_peroid_reset">{__("Cycle Reset")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <select class="select w-full" name="merits_peroid_reset" id="merits_peroid_reset" aria-describedby="merits_peroid_reset-help">
                      <option {if $system['merits_peroid_reset'] == "1"}selected{/if} value="1">{__("Firt of the month")}</option>
                      <option {if $system['merits_peroid_reset'] == "15"}selected{/if} value="15">{__("Middle of the month")}</option>
                    </select>
                    <div id="merits_peroid_reset-help" class="admin-setting-help text-sm leading-relaxed">{__("Start day for every cycle for the merits system")}</div>
                  </div>
                </div>

                <div class="grid min-w-0 gap-4 sm:grid-cols-2">
                  <div class="admin-setting-field flex min-w-0 flex-col gap-1">
                    <div class="label-text">{__("Cycle Start Date")}</div>
                    <div class="text-sm">{if $system['merits_enabled']}{$cycle_dates['start_date']}{else}{__("N/A")}{/if}</div>
                  </div>
                  <div class="admin-setting-field flex min-w-0 flex-col gap-1">
                    <div class="label-text">{__("Cycle End Date")}</div>
                    <div class="text-sm">{if $system['merits_enabled']}{$cycle_dates['end_date']}{else}{__("N/A")}{/if}</div>
                  </div>
                  <div class="admin-setting-field flex min-w-0 flex-col gap-1">
                    <div class="label-text">{__("Cycle Reset Date")}</div>
                    <div class="text-sm">{if $system['merits_enabled']}{$cycle_dates['reset_date']}{else}{__("N/A")}{/if}</div>
                  </div>
                  <div class="admin-setting-field flex min-w-0 flex-col gap-1">
                    <div class="label-text">{__("Cycle Reminder Date")}</div>
                    <div class="text-sm">{if $system['merits_enabled']}{$cycle_dates['reminder_date']}{else}{__("N/A")}{/if}</div>
                  </div>
                </div>
              </div>

              <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
                <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                  <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                  <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
                </div>
                <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                  <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                </div>
              </div>
            </section>
          </div>
        </div>
      </form>
    </div>

    <div class="admin-settings-panel js_admin-settings-panel hidden" id="Notifications" role="tabpanel" tabindex="0">
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=merits_notifications">
        <div class="admin-settings-layout block">
          <div class="admin-settings-form flex min-w-0 flex-col gap-4">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
                <div class="admin-setting-switch js_admin-setting-switch">
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="merits_notifications_recharge">{__("Merits Credit Recharge")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="merits_notifications_recharge-help">{__("Notify when new amounts of merits have been added to users accounts")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="merits_notifications_recharge" id="merits_notifications_recharge" {if $system['merits_notifications_recharge']}checked{/if} aria-describedby="merits_notifications_recharge-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="merits_notifications_reminder">{__("Merits Remainder")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="merits_notifications_reminder-help">{__("Remainder to use remaining merits 7 days before each cycle reset")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="merits_notifications_reminder" id="merits_notifications_reminder" {if $system['merits_notifications_reminder']}checked{/if} aria-describedby="merits_notifications_reminder-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="merits_notifications_recipient">{__("Recipient Merits Notification")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="merits_notifications_recipient-help">{__("Notify the recipients when they receive a badge")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="merits_notifications_recipient" id="merits_notifications_recipient" {if $system['merits_notifications_recipient']}checked{/if} aria-describedby="merits_notifications_recipient-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="merits_notifications_sender">{__("Sender Merits Notification")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="merits_notifications_sender-help">{__("Notify the sender when their badge has been received")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="merits_notifications_sender" id="merits_notifications_sender" {if $system['merits_notifications_sender']}checked{/if} aria-describedby="merits_notifications_sender-help">
                  </div>
                </div>
              </div>

              <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
                <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                  <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                  <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
                </div>
                <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                  <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                </div>
              </div>
            </section>
          </div>
        </div>
      </form>
    </div>

    <div class="admin-settings-panel js_admin-settings-panel hidden" id="Widgets" role="tabpanel" tabindex="0">
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=merits_widgets">
        <div class="admin-settings-layout block">
          <div class="admin-settings-form flex min-w-0 flex-col gap-4">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
                <div class="admin-setting-switch js_admin-setting-switch">
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="merits_widgets_balance">{__("Personal Balance Widget")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="merits_widgets_balance-help">{__("Post in the right column the personal balance of available badges with a link that pops up to start giving these badges to other users")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="merits_widgets_balance" id="merits_widgets_balance" {if $system['merits_widgets_balance']}checked{/if} aria-describedby="merits_widgets_balance-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="merits_widgets_winners">{__("Top Winners Widget")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="merits_widgets_winners-help">{__("Post in right column with a carousel the recent winners")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="merits_widgets_winners" id="merits_widgets_winners" {if $system['merits_widgets_winners']}checked{/if} aria-describedby="merits_widgets_winners-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="merits_widgets_statistics">{__("Badge Statistics Widget")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="merits_widgets_statistics-help">{__("Post annual badge statistics under each user profile picture, the total number of earned badges, badges that have been sent by the user, and the amount of left badges to give in current cycle")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="merits_widgets_statistics" id="merits_widgets_statistics" {if $system['merits_widgets_statistics']}checked{/if} aria-describedby="merits_widgets_statistics-help">
                  </div>
                </div>
              </div>

              <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
                <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                  <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                  <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
                </div>
                <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                  <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                </div>
              </div>
            </section>
          </div>
        </div>
      </form>
    </div>
  </section>
{else}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-merits-title">
    {if $sub_view == "add_category" || $sub_view == "edit_category"}
      <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
    {/if}

    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-merits-title" class="text-2xl font-semibold">
          {if $sub_view == "add_category"}{__("Add New Category")}
          {elseif $sub_view == "edit_category"}{__("Edit Category")}
          {else}{__("Categories")}{/if}
        </h1>
        <p class="text-base-content/60 text-sm">
          {if $sub_view == "add_category"}{__("Create a category for merits.")}
          {elseif $sub_view == "edit_category"}{__("Update this category and its position.")}
          {else}{__("Organize merits into categories.")}{/if}
        </p>
      </div>

      <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
        {if $sub_view == "categories"}
          <a href="{$system['system_url']}/{$control_panel['url']}/merits/add_category" class="btn btn-primary">
            <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
            {__("Add New Category")}
          </a>
        {elseif $sub_view == "add_category" || $sub_view == "edit_category"}
          <a href="{$system['system_url']}/{$control_panel['url']}/merits/categories" class="btn btn-outline">
            <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
            {__("Go Back")}
          </a>
        {/if}
      </div>
    </header>

    {if $sub_view == "categories"}
      {if $rows}
        <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Categories")}">
          <div class="admin-list-table-wrap w-full overflow-x-auto">
            <table class="table admin-list-table">
              <thead>
                <tr>
                  <th>{__("Category")}</th>
                  <th>{__("Image")}</th>
                  <th>{__("Description")}</th>
                  <th>{__("Order")}</th>
                  <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
                </tr>
              </thead>
              <tbody>
                {foreach $rows as $row}
                  {include file='__categories.recursive_rows.tpl' _url="merits" _handle="merit_category" _has_image=true _style="admin-list"}
                {/foreach}
              </tbody>
            </table>
          </div>
        </section>
      {else}
        <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-merits-categories-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--category] size-6" aria-hidden="true"></span>
          </div>
          <h2 id="admin-merits-categories-empty-title">{__("No categories yet")}</h2>
          <p>{__("Add a category to organize merits.")}</p>
          <a href="{$system['system_url']}/{$control_panel['url']}/merits/add_category" class="btn btn-primary btn-sm">
            <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
            {__("Add New Category")}
          </a>
        </section>
      {/if}

    {elseif $sub_view == "add_category" || $sub_view == "edit_category"}
      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/merits.php?do={if $sub_view == "edit_category"}edit_category&amp;id={$data['category_id']}{else}add_category{/if}">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="merits-category-details-title">
            <h2 id="merits-category-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              <span class="icon-[tabler--category] size-5" aria-hidden="true"></span>
              {__("Category Details")}
            </h2>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="merits-category-name">{__("Name")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input class="input w-full" name="category_name" id="merits-category-name" value="{if $sub_view == "edit_category"}{$data['category_name']}{/if}" autocomplete="off">
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="merits-category-description">{__("Description")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea class="textarea w-full" name="category_description" id="merits-category-description" rows="4">{if $sub_view == "edit_category"}{$data['category_description']}{/if}</textarea>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="merits-category-image-label">
              <div class="label-text" id="merits-category-image-label">{__("Image")}</div>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if $sub_view == "edit_category" && $data['category_image'] != ''}
                  {include file='__x_image.tpl' _x_name="category_image" _x_value=$data['category_image'] _x_fit="contain"}
                {else}
                  {include file='__x_image.tpl' _x_name="category_image" _x_fit="contain"}
                {/if}
              </div>
            </div>

            <div class="grid min-w-0 gap-5 md:grid-cols-2">
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="merits-category-parent">{__("Parent Category")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="category_parent_id" id="merits-category-parent">
                    <option value="0">{__("Set as a Parent Category")}</option>
                    {if $sub_view == "edit_category"}
                      {foreach $data['categories'] as $category}{include file='__categories.recursive_options.tpl' data_category=$data['category_parent_id']}{/foreach}
                    {else}
                      {foreach $categories as $category}{include file='__categories.recursive_options.tpl'}{/foreach}
                    {/if}
                  </select>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="merits-category-order">{__("Order")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input class="input w-full" name="category_order" id="merits-category-order" value="{if $sub_view == "edit_category"}{$data['category_order']}{/if}" inputmode="numeric">
                  <div class="admin-setting-help text-sm leading-relaxed">{__("Lower numbers appear first.")}</div>
                </div>
              </div>
            </div>
          </div>

          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </section>
      </form>
    {/if}

    {if $sub_view == "add_category" || $sub_view == "edit_category"}
      </div>
    {/if}
  </section>
{/if}
