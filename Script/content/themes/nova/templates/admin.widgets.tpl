<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-widgets-title">
  {if $sub_view == "edit" || $sub_view == "add"}
    <div class="admin-form-layout mx-auto w-full admin-form-layout-wide flex max-w-[64rem] flex-col gap-6">
  {/if}
  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-widgets-title" class="text-2xl font-semibold">
        {if $sub_view == "edit"}
          {$data['title']}
        {elseif $sub_view == "add"}
          {__("Add New widget")}
        {else}
          {__("Widgets")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "edit"}
          {__("Update the widget place, audience, and HTML code.")}
        {elseif $sub_view == "add"}
          {__("Add a custom HTML widget to your website.")}
        {else}
          {__("Manage the custom HTML widgets across your website.")}
        {/if}
      </p>
    </div>

    {if $sub_view == ""}
      <a href="{$system['system_url']}/{$control_panel['url']}/widgets/add" class="btn btn-primary">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Add New widget")}
      </a>
    {else}
      <a href="{$system['system_url']}/{$control_panel['url']}/widgets" class="btn btn-outline">
        <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        {__("Go Back")}
      </a>
    {/if}
  </header>

  {if $sub_view == ""}
    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Widgets")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table js_dataTable admin-list-table">
            <thead>
              <tr>
                <th>{__("Title")}</th>
                <th>{__("Place")}</th>
                <th>{__("Language")}</th>
                <th>{__("Audience")}</th>
                <th>{__("Order")}</th>
                <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <div class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                      <span class="admin-list-name truncate text-sm font-semibold" title="{$row['title']}">{$row['title']}</span>
                      <span class="admin-list-id text-xs">#{number_format($row['widget_id'])}</span>
                    </div>
                  </td>
                  <td>
                    <div class="admin-list-inline flex items-center gap-2 text-sm">
                      {if $row['place'] == "home"}<span class="admin-list-icon icon-[tabler--home] size-4 shrink-0"></span>{__("Home Page")}{/if}
                      {if $row['place'] == "search"}<span class="admin-list-icon icon-[tabler--search] size-4 shrink-0"></span>{__("Search Page")}{/if}
                      {if $row['place'] == "people"}<span class="admin-list-icon icon-[tabler--users] size-4 shrink-0"></span>{__("Discover People Page")}{/if}
                      {if $row['place'] == "notifications"}<span class="admin-list-icon icon-[tabler--bell] size-4 shrink-0"></span>{__("Notifications Page")}{/if}
                      {if $row['place'] == "post"}<span class="admin-list-icon icon-[tabler--file-text] size-4 shrink-0"></span>{__("Post Page")}{/if}
                      {if $row['place'] == "photo"}<span class="admin-list-icon icon-[tabler--photo] size-4 shrink-0"></span>{__("Photo Page")}{/if}
                      {if $row['place'] == "blog"}<span class="admin-list-icon icon-[tabler--news] size-4 shrink-0"></span>{__("Blog Page")}{/if}
                      {if $row['place'] == "directory"}<span class="admin-list-icon icon-[tabler--list-details] size-4 shrink-0"></span>{__("Directory Page")}{/if}
                      {if $row['place'] == "newsfeed_top"}<span class="admin-list-icon icon-[tabler--news] size-4 shrink-0"></span>{__("Newsfeed Top")}{/if}
                      {if $row['place'] == "newfeed_1"}<span class="admin-list-icon icon-[tabler--news] size-4 shrink-0"></span>{__("Posts Feed")} 1{/if}
                      {if $row['place'] == "newfeed_2"}<span class="admin-list-icon icon-[tabler--news] size-4 shrink-0"></span>{__("Posts Feed")} 2{/if}
                      {if $row['place'] == "newfeed_3"}<span class="admin-list-icon icon-[tabler--news] size-4 shrink-0"></span>{__("Posts Feed")} 3{/if}
                    </div>
                  </td>
                  <td>
                    {if $row['language_id'] == 0}{__("All Languages")}{else}{$row['language_title']}{/if}
                  </td>
                  <td>
                    <span class="badge badge-soft badge-sm rounded-full">
                      {if $row['target_audience'] == "all"}{__("All")}{/if}
                      {if $row['target_audience'] == "members"}{__("Members")}{/if}
                      {if $row['target_audience'] == "visitors"}{__("Visitors")}{/if}
                    </span>
                  </td>
                  <td>{$row['place_order']}</td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="widget-actions-{$row['widget_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['title']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="widget-actions-{$row['widget_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/widgets/edit/{$row['widget_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="widget" data-id="{$row['widget_id']}">
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
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-widgets-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--puzzle] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-widgets-empty-title">{__("No widgets yet")}</h2>
        <p>{__("Add your first widget to show custom HTML on your website.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/widgets/add" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New widget")}
        </a>
      </section>
    {/if}

  {elseif $sub_view == "edit" || $sub_view == "add"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/widgets.php?do={if $sub_view == "edit"}edit&amp;id={$data['widget_id']}{else}add{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="widget-details-title">
          <h2 id="widget-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Widget Details")}</h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="widget-title">{__("Title")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="title" id="widget-title" value="{if $sub_view == "edit"}{$data['title']}{/if}" autocomplete="off">
              <div class="admin-setting-help text-sm leading-relaxed">{__("The title of the widget")}</div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="widget-place">{__("Place")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full" name="place" id="widget-place">
                {if $sub_view == "edit"}
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
                {else}
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
                {/if}
              </select>
              <div class="admin-setting-help text-sm leading-relaxed">{__("Where to show this widget")}</div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="widget-language">{__("Language")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full" name="language_id" id="widget-language">
                {if $sub_view == "edit"}
                  <option {if $data['language_id'] == "0"}selected{/if} value="0">{__("All Languages")}</option>
                  {foreach $system['languages'] as $language}
                    <option {if $data['language_id'] == $language['language_id']}selected{/if} value="{$language['language_id']}">{$language['title']}</option>
                  {/foreach}
                {else}
                  <option value="0">{__("All Languages")}</option>
                  {foreach $system['languages'] as $language}
                    <option value="{$language['language_id']}">{$language['title']}</option>
                  {/foreach}
                {/if}
              </select>
              <div class="admin-setting-help text-sm leading-relaxed">{__("For which language this widget will be shown")}</div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="widget-audience">{__("Target Audience")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <select class="select w-full" name="target_audience" id="widget-audience">
                {if $sub_view == "edit"}
                  <option {if $data['target_audience'] == "all"}selected{/if} value="all">{__("Both Members and Visitors")}</option>
                  <option {if $data['target_audience'] == "members"}selected{/if} value="members">{__("Only Members")}</option>
                  <option {if $data['target_audience'] == "visitors"}selected{/if} value="visitors">{__("Only Visitors")}</option>
                {else}
                  <option value="all">{__("Both Members and Visitors")}</option>
                  <option value="members">{__("Only Members")}</option>
                  <option value="visitors">{__("Only Visitors")}</option>
                {/if}
              </select>
              <div class="admin-setting-help text-sm leading-relaxed">{__("For which target audience this widget will be shown")}</div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="widget-order">{__("Order")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input type="text" class="input w-full" name="place_order" id="widget-order" value="{if $sub_view == "edit"}{$data['place_order']}{/if}" autocomplete="off">
              <div class="admin-setting-help text-sm leading-relaxed">{__("The order of this widget in the selected place")}</div>
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="widget-html">{__("HTML")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <textarea class="textarea w-full font-mono text-xs max-md:text-base" name="message" id="widget-html" rows="8">{if $sub_view == "edit"}{$data['code']}{/if}</textarea>
              <div class="admin-setting-help text-sm leading-relaxed">{__("The HTML code of the widget")}</div>
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
