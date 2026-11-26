<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-custom-fields-title">
  {if $sub_view == "edit" || $sub_view == "add"}
    <div class="admin-form-layout mx-auto w-full admin-form-layout-wide flex max-w-[64rem] flex-col gap-6">
  {/if}
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-custom-fields-title" class="text-2xl font-semibold">
        {if $sub_view == "edit"}
          {$data['label']}
        {elseif $sub_view == "add"}
          {__("Add New Field")}
        {else}
          {__("Custom Fields")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "edit"}
          {__("Update this custom field and where it appears.")}
        {elseif $sub_view == "add"}
          {__("Create a custom field for users, pages, groups, and more.")}
        {else}
          {__("Manage the custom fields across your website.")}
        {/if}
      </p>
    </div>

    {if $sub_view == ""}
      <a href="{$system['system_url']}/{$control_panel['url']}/custom_fields/add" class="btn btn-primary">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Add New Field")}
      </a>
    {else}
      <a href="{$system['system_url']}/{$control_panel['url']}/custom_fields" class="btn btn-outline">
        <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        {__("Go Back")}
      </a>
    {/if}
  </header>

  {if $sub_view == ""}
    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Custom Fields")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table js_dataTable admin-list-table">
            <thead>
              <tr>
                <th>{__("Label")}</th>
                <th>{__("For")}</th>
                <th>{__("Type")}</th>
                <th>{__("Place")}</th>
                <th>{__("Order")}</th>
                <th>{__("Mandatory")}</th>
                <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <div class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                      <span class="admin-list-name truncate text-sm font-semibold" title="{$row['label']}">{$row['label']}</span>
                      <span class="admin-list-id text-xs">#{number_format($row['field_id'])}</span>
                    </div>
                  </td>
                  <td>
                    <div class="admin-list-inline flex items-center gap-2 text-sm">
                      {if $row['field_for'] == "user"}<span class="admin-list-icon icon-[tabler--user] size-4 shrink-0"></span>{__("User")}{/if}
                      {if $row['field_for'] == "page"}<span class="admin-list-icon icon-[tabler--flag] size-4 shrink-0"></span>{__("Page")}{/if}
                      {if $row['field_for'] == "group"}<span class="admin-list-icon icon-[tabler--users-group] size-4 shrink-0"></span>{__("Group")}{/if}
                      {if $row['field_for'] == "event"}<span class="admin-list-icon icon-[tabler--calendar-event] size-4 shrink-0"></span>{__("Event")}{/if}
                      {if $row['field_for'] == "product"}<span class="admin-list-icon icon-[tabler--shopping-cart] size-4 shrink-0"></span>{__("Product")}{/if}
                      {if $row['field_for'] == "job"}<span class="admin-list-icon icon-[tabler--briefcase] size-4 shrink-0"></span>{__("Job")}{/if}
                      {if $row['field_for'] == "offer"}<span class="admin-list-icon icon-[tabler--tag] size-4 shrink-0"></span>{__("Offer")}{/if}
                      {if $row['field_for'] == "course"}<span class="admin-list-icon icon-[tabler--book] size-4 shrink-0"></span>{__("Course")}{/if}
                    </div>
                  </td>
                  <td>
                    <span class="badge badge-soft badge-sm rounded-full">
                      {if $row['type'] == "textbox"}{__("Text Box")}{/if}
                      {if $row['type'] == "textarea"}{__("Text Area")}{/if}
                      {if $row['type'] == "selectbox"}{__("Select Box")}{/if}
                      {if $row['type'] == "multipleselectbox"}{__("Multiple Select")}{/if}
                    </span>
                  </td>
                  <td>
                    {if $row['place'] == "basic"}{__("Basic Info")}{/if}
                    {if $row['place'] == "work"}{__("Work Info")}{/if}
                    {if $row['place'] == "location"}{__("Location Info")}{/if}
                    {if $row['place'] == "education"}{__("Education Info")}{/if}
                    {if $row['place'] == "other"}{__("Other Info")}{/if}
                  </td>
                  <td>{$row['field_order']}</td>
                  <td>
                    {if $row['mandatory']}
                      <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Yes")}</span>
                    {else}
                      <span class="badge badge-soft badge-sm rounded-full">{__("No")}</span>
                    {/if}
                  </td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="custom-field-actions-{$row['field_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['label']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="custom-field-actions-{$row['field_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/custom_fields/edit/{$row['field_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="custom_field" data-id="{$row['field_id']}">
                            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                            {__("Delete")}
                          </button>
                        </li>
                      </ul>
                    </div>
                  </td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
      </section>
    {else}
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-custom-fields-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--menu-2] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-custom-fields-empty-title">{__("No fields yet")}</h2>
        <p>{__("Add your first custom field to make it available across your website.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/custom_fields/add" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Field")}
        </a>
      </section>
    {/if}

  {elseif $sub_view == "edit" || $sub_view == "add"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/custom_fields.php?do={if $sub_view == "edit"}edit&amp;id={$data['field_id']}{else}add{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="custom-field-details-title">
          <h2 id="custom-field-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Field Details")}</h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="js_field-for">{__("Field For")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full" id="js_field-for" name="field_for">
                {if $sub_view == "edit"}
                  <option {if $data['field_for'] == "user"}selected{/if} value="user">{__("User")}</option>
                  <option {if $data['field_for'] == "page"}selected{/if} value="page">{__("Page")}</option>
                  <option {if $data['field_for'] == "group"}selected{/if} value="group">{__("Group")}</option>
                  <option {if $data['field_for'] == "event"}selected{/if} value="event">{__("Event")}</option>
                  <option {if $data['field_for'] == "product"}selected{/if} value="product">{__("Product")}</option>
                  <option {if $data['field_for'] == "job"}selected{/if} value="job">{__("Job")}</option>
                  <option {if $data['field_for'] == "offer"}selected{/if} value="offer">{__("Offer")}</option>
                  <option {if $data['field_for'] == "course"}selected{/if} value="course">{__("Course")}</option>
                {else}
                  <option value="user">{__("User")}</option>
                  <option value="page">{__("Page")}</option>
                  <option value="group">{__("Group")}</option>
                  <option value="event">{__("Event")}</option>
                  <option value="product">{__("Product")}</option>
                  <option value="job">{__("Job")}</option>
                  <option value="offer">{__("Offer")}</option>
                  <option value="course">{__("Course")}</option>
                {/if}
              </select>
              <div class="admin-setting-help text-sm leading-relaxed">{__("Where you want to use this field for")}</div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="custom-field-label">{__("Label")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="label" id="custom-field-label" value="{if $sub_view == "edit"}{$data['label']}{/if}" autocomplete="off">
              {if $sub_view == "add"}
                <div class="admin-setting-help text-sm leading-relaxed">{__("The label of your custom field, also will be used as a placeholder")}</div>
              {/if}
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="js_field-type">{__("Type")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full" id="js_field-type" name="type">
                {if $sub_view == "edit"}
                  <option {if $data['type'] == "textbox"}selected{/if} value="textbox">{__("Text Box")}</option>
                  <option {if $data['type'] == "textarea"}selected{/if} value="textarea">{__("Text Area")}</option>
                  <option {if $data['type'] == "selectbox"}selected{/if} value="selectbox">{__("Select Box")}</option>
                  <option {if $data['type'] == "multipleselectbox"}selected{/if} value="multipleselectbox">{__("Multiple Select")}</option>
                {else}
                  <option value="textbox">{__("Text Box")}</option>
                  <option value="textarea">{__("Text Area")}</option>
                  <option value="selectbox">{__("Select Box")}</option>
                  <option value="multipleselectbox">{__("Multiple Select")}</option>
                {/if}
              </select>
              {if $sub_view == "add"}
                <div class="admin-setting-help text-sm leading-relaxed">{__("The type of your custom field")}</div>
              {/if}
            </div>
          </div>

          <div id="js_field-select-options" {if $sub_view == "add" || ($sub_view == "edit" && $data['type'] != 'selectbox' && $data['type'] != 'multipleselectbox')}class="hidden"{/if}>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="custom-field-options">{__("Select Options")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea class="textarea w-full" rows="5" name="select_options" id="custom-field-options">{if $sub_view == "edit"}{$data['select_options']}{/if}</textarea>
                <div class="admin-setting-help text-sm leading-relaxed">{__("One option per line")}</div>
              </div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="custom-field-description">{__("Description")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <textarea class="textarea w-full" rows="3" name="description" id="custom-field-description">{if $sub_view == "edit"}{$data['description']}{/if}</textarea>
              <div class="admin-setting-help text-sm leading-relaxed">{__("The description will show under the field")}</div>
            </div>
          </div>

          <div id="js_field-place" {if $sub_view == "edit" && $data['field_for'] != 'user'}class="hidden"{/if}>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="custom-field-place">{__("Place")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="place" id="custom-field-place">
                  {if $sub_view == "edit"}
                    <option {if $data['place'] == "basic"}selected{/if} value="basic">{__("Basic Info")}</option>
                    <option {if $data['place'] == "work"}selected{/if} value="work">{__("Work Info")}</option>
                    <option {if $data['place'] == "location"}selected{/if} value="location">{__("Location Info")}</option>
                    <option {if $data['place'] == "education"}selected{/if} value="education">{__("Education Info")}</option>
                    <option {if $data['place'] == "other"}selected{/if} value="other">{__("Other Info")}</option>
                  {else}
                    <option value="basic">{__("Basic Info")}</option>
                    <option value="work">{__("Work Info")}</option>
                    <option value="location">{__("Location Info")}</option>
                    <option value="education">{__("Education Info")}</option>
                    <option value="other">{__("Other Info")}</option>
                  {/if}
                </select>
                <div class="admin-setting-help text-sm leading-relaxed">{__("Field place in settings page")}</div>
              </div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="custom-field-length">{__("Value Length")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="length" id="custom-field-length" value="{if $sub_view == "edit"}{$data['length']}{else}32{/if}" autocomplete="off">
              <div class="admin-setting-help text-sm leading-relaxed">{__("Default value is 32, and max value is 1000")}</div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="custom-field-order">{__("Order")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="field_order" id="custom-field-order" value="{if $sub_view == "edit"}{$data['field_order']}{else}1{/if}" autocomplete="off">
              <div class="admin-setting-help text-sm leading-relaxed">{__("The order of this field, custom fields will be displayed in ascending order")}</div>
            </div>
          </div>
        </div>

        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="custom-field-visibility-title">
          <h2 id="custom-field-visibility-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Visibility")}</h2>

          <div id="js_field-clickable" {if $sub_view == "add" || ($sub_view == "edit" && $data['type'] != 'textbox')}class="hidden"{/if}>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="is_link">{__("Clickable")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="is_link-help">{__("Make the value shows as link")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary" name="is_link" id="is_link" {if $sub_view == "edit" && $data['is_link']}checked{/if} aria-describedby="is_link-help">
              </div>
            </div>
          </div>

          <div class="admin-setting-switch js_admin-setting-switch">
            <div>
              <label class="admin-setting-label block text-sm font-medium leading-normal" for="mandatory">{__("Mandatory")}</label>
              <div class="admin-setting-help text-sm leading-relaxed" id="mandatory-help">{__("User must fill the field")}</div>
            </div>
            <div class="text-end">
              <input type="checkbox" class="switch switch-primary" name="mandatory" id="mandatory" {if $sub_view == "edit" && $data['mandatory']}checked{/if} aria-describedby="mandatory-help">
            </div>
          </div>

          <div id="js_field-showin" {if $sub_view == "edit" && in_array($data['field_for'], ['product', 'job', 'offer', 'course'])}class="hidden"{/if}>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="in_registration">{__("Show in Registration")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="in_registration-help">{__("Show the field in the user registration, create page, create group or create event")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary" name="in_registration" id="in_registration" {if $sub_view == "edit" && $data['in_registration']}checked{/if} aria-describedby="in_registration-help">
              </div>
            </div>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="in_profile">{__("Show in Target Page")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="in_profile-help">{__("Show the field in the user's profile, page, group or event")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary" name="in_profile" id="in_profile" {if $sub_view == "edit" && $data['in_profile']}checked{/if} aria-describedby="in_profile-help">
              </div>
            </div>
          </div>

          <div id="js_field-searchable" {if $sub_view == "edit" && $data['field_for'] != "user"}class="hidden"{/if}>
            <div class="admin-setting-switch js_admin-setting-switch">
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="in_search">{__("Show in Search")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="in_search-help">{__("Show the field in the find people page")}</div>
              </div>
              <div class="text-end">
                <input type="checkbox" class="switch switch-primary" name="in_search" id="in_search" {if $sub_view == "edit" && $data['in_search']}checked{/if} aria-describedby="in_search-help">
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
  {if $sub_view == "edit" || $sub_view == "add"}
    </div>
  {/if}
</section>
