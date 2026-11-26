{* PAYMENTS & MONETIZATION MODULE *}

{if $sub_view == "" || $sub_view == "users_ads"}
  {if $licence_monetization && is_file("content/themes/`$system.theme`/templates/admin.ads.users.tpl")}
    {include file='admin.ads.users.tpl'}
  {else}
    <section class="admin-settings-page" aria-labelledby="admin-ads-lock-title">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-ads-lock-title" class="text-2xl font-semibold">{if $sub_view == "users_ads"}{__("Users Ads")}{else}{__("Ads Settings")}{/if}</h1>
        <p class="text-base-content/60 text-sm">{__("Campaigns and user ads require a monetization licence.")}</p>
      </div>
      {include file='__licence_lock.tpl'}
    </section>
  {/if}

{elseif $sub_view == "system_ads"}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-ads-system-title">
    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-ads-system-title" class="text-2xl font-semibold">{__("System Ads")}</h1>
        <p class="text-base-content/60 text-sm">{__("Site-wide ad placements.")}</p>
      </div>
      <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
        <a href="{$system['system_url']}/{$control_panel['url']}/ads/add" class="btn btn-primary">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Ads")}
        </a>
      </div>
    </header>

    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("System Ads")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table js_dataTable admin-list-table">
            <thead>
              <tr>
                <th>{__("ID")}</th>
                <th>{__("Title")}</th>
                <th>{__("Place")}</th>
                <th>{__("Date")}</th>
                <th data-orderable="false" class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td><span class="admin-list-name text-sm font-semibold">#{$row['ads_id']}</span></td>
                  <td><span class="admin-list-name max-w-md truncate text-sm" title="{$row['title']}">{$row['title']}</span></td>
                  <td>
                    <span class="badge badge-soft badge-sm rounded-full">
                      {if $row['place'] == "home"}{__("Home Page")}
                      {elseif $row['place'] == "search"}{__("Search Page")}
                      {elseif $row['place'] == "people"}{__("Discover People Page")}
                      {elseif $row['place'] == "notifications"}{__("Notifications Page")}
                      {elseif $row['place'] == "post"}{__("Post (Right Panel)")}
                      {elseif $row['place'] == "post_footer"}{__("Post (Footer)")}
                      {elseif $row['place'] == "photo"}{__("Photo Page")}
                      {elseif $row['place'] == "pages"}{__("Pages")}
                      {elseif $row['place'] == "groups"}{__("Groups")}
                      {elseif $row['place'] == "directory"}{__("Directory Page")}
                      {elseif $row['place'] == "market"}{__("Market Page")}
                      {elseif $row['place'] == "offers"}{__("Offers Page")}
                      {elseif $row['place'] == "jobs"}{__("Jobs Page")}
                      {elseif $row['place'] == "courses"}{__("Courses Page")}
                      {elseif $row['place'] == "movies"}{__("Movies Page")}
                      {elseif $row['place'] == "dating"}{__("Dating Page")}
                      {elseif $row['place'] == "newfeed_1"}{__("Posts Feed")} 1
                      {elseif $row['place'] == "newfeed_2"}{__("Posts Feed")} 2
                      {elseif $row['place'] == "newfeed_3"}{__("Posts Feed")} 3
                      {elseif $row['place'] == "blog"}{__("Blog (Right Panel)")}
                      {elseif $row['place'] == "blog_footer"}{__("Blog (Footer)")}
                      {elseif $row['place'] == "header"}{__("Header")}
                      {elseif $row['place'] == "footer"}{__("Footer")}
                      {else}{$row['place']}{/if}
                    </span>
                  </td>
                  <td>{$row['time']|date_format:"%e %B %Y"}</td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="ads-system-actions-{$row['ads_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['title']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="ads-system-actions-{$row['ads_id']}">
                        <li>
                          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/ads/edit/{$row['ads_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        <li>
                          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="ads_system" data-id="{$row['ads_id']}">
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
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-ads-system-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--layout] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-ads-system-empty-title">{__("No system ads")}</h2>
        <p>{__("Add a placement to show ads on the site.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/ads/add" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Ads")}
        </a>
      </section>
    {/if}
  </section>

{elseif $sub_view == "add" || $sub_view == "edit"}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-ads-form-title">
    <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
      <header class="admin-list-heading flex items-start justify-between gap-4">
        <div class="admin-settings-heading grid gap-1.5">
          <h1 id="admin-ads-form-title" class="text-2xl font-semibold">{if $sub_view == "edit"}{$data['title']}{else}{__("Add New Ads")}{/if}</h1>
          <p class="text-base-content/60 text-sm">{if $sub_view == "edit"}{__("Update this system ad and its placement.")}{else}{__("Create a system ad placement.")}{/if}</p>
        </div>
        <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
          <a href="{$system['system_url']}/{$control_panel['url']}/ads/system_ads" class="btn btn-outline">
            <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
            {__("Go Back")}
          </a>
        </div>
      </header>

      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/ads.php?do={if $sub_view == "edit"}edit&amp;id={$data['ads_id']}{else}add{/if}">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="admin-ads-details-title">
            <h2 id="admin-ads-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              <span class="icon-[tabler--layout] size-5" aria-hidden="true"></span>
              {__("Ad Details")}
            </h2>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="ads-title">{__("Title")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input class="input w-full" name="title" id="ads-title" value="{if $sub_view == "edit"}{$data['title']}{/if}" autocomplete="off">
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="js_ads-place">{__("Place")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="place" id="js_ads-place">
                  <option {if $sub_view == "edit" && $data['place'] == "home"}selected{/if} value="home">{__("Home")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "search"}selected{/if} value="search">{__("Search")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "people"}selected{/if} value="people">{__("Discover People")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "notifications"}selected{/if} value="notifications">{__("Notifications")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "post"}selected{/if} value="post">{__("Post (Right Panel)")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "post_footer"}selected{/if} value="post_footer">{__("Post (Footer)")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "photo"}selected{/if} value="photo">{__("Photo")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "pages"}selected{/if} value="pages">{__("Pages")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "groups"}selected{/if} value="groups">{__("Groups")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "directory"}selected{/if} value="directory">{__("Directory")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "market"}selected{/if} value="market">{__("Marketplace")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "offers"}selected{/if} value="offers">{__("Offers")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "jobs"}selected{/if} value="jobs">{__("Jobs")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "courses"}selected{/if} value="courses">{__("Courses")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "movies"}selected{/if} value="movies">{__("Movies")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "games"}selected{/if} value="games">{__("Games")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "dating"}selected{/if} value="dating">{__("Dating")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "newfeed_1"}selected{/if} value="newfeed_1">{__("Posts Feed")} 1</option>
                  <option {if $sub_view == "edit" && $data['place'] == "newfeed_2"}selected{/if} value="newfeed_2">{__("Posts Feed")} 2</option>
                  <option {if $sub_view == "edit" && $data['place'] == "newfeed_3"}selected{/if} value="newfeed_3">{__("Posts Feed")} 3</option>
                  <option {if $sub_view == "edit" && $data['place'] == "blog"}selected{/if} value="blog">{__("Blog (Right Panel)")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "blog_footer"}selected{/if} value="blog_footer">{__("Blog (Footer)")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "header"}selected{/if} value="header">{__("Header")}</option>
                  <option {if $sub_view == "edit" && $data['place'] == "footer"}selected{/if} value="footer">{__("Footer")}</option>
                </select>
              </div>
            </div>

            <div id="js_selected-pages" {if $sub_view == "add" || !$data['ads_pages_ids']}class="hidden"{/if}>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="ads_pages_ids">{__("Select Pages")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="js_tagify-ajax hidden" data-handle="pages" name="ads_pages_ids" id="ads_pages_ids" value="{if $sub_view == "edit"}{$data['ads_pages_ids']}{/if}">
                  <div class="admin-setting-help text-sm leading-relaxed">{__("Search for pages you want to show this ads")}</div>
                </div>
              </div>
            </div>

            <div id="js_selected-groups" {if $sub_view == "add" || !$data['ads_groups_ids']}class="hidden"{/if}>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="ads_groups_ids">{__("Select Groups")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="js_tagify-ajax hidden" data-handle="groups" name="ads_groups_ids" id="ads_groups_ids" value="{if $sub_view == "edit"}{$data['ads_groups_ids']}{/if}">
                  <div class="admin-setting-help text-sm leading-relaxed">{__("Search for groups you want to show this ads")}</div>
                </div>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="ads-message">{__("HTML")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea class="textarea w-full" name="message" id="ads-message" rows="8">{if $sub_view == "edit"}{$data['code']}{/if}</textarea>
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
    </div>
  </section>
{/if}
