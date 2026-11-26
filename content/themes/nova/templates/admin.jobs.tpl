<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-jobs-title">
  {if $sub_view == "add_category" || $sub_view == "edit_category"}
    <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
  {/if}

  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-jobs-title" class="text-2xl font-semibold">
        {if $sub_view == "find"}{__("Find Jobs")}
        {elseif $sub_view == "categories"}{__("Job Categories")}
        {elseif $sub_view == "add_category"}{__("Add New Category")}
        {elseif $sub_view == "edit_category"}{__("Edit Category")}
        {else}{__("Jobs")}{/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "find"}{__("Search results for job titles and descriptions.")}
        {elseif $sub_view == "categories"}{__("Organize jobs into categories that are easy to browse.")}
        {elseif $sub_view == "add_category"}{__("Create a category and place it in the job directory hierarchy.")}
        {elseif $sub_view == "edit_category"}{__("Update this category and its position in the job directory.")}
        {else}{__("Manage community jobs, availability, and categories.")}{/if}
      </p>
    </div>

    {if $sub_view != ""}
    <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
      {if $sub_view == "find"}
        <a href="{$system['system_url']}/{$control_panel['url']}/jobs" class="btn btn-outline"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
      {elseif $sub_view == "categories"}
        <a href="{$system['system_url']}/{$control_panel['url']}/jobs/add_category" class="btn btn-primary"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Category")}</a>
      {elseif $sub_view == "add_category" || $sub_view == "edit_category"}
        <a href="{$system['system_url']}/{$control_panel['url']}/jobs/categories" class="btn btn-outline"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
      {/if}
    </div>
    {/if}
  </header>

  {if $sub_view == "" || $sub_view == "find"}
    {if $sub_view == ""}
      <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-info icon-[tabler--briefcase] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Total Jobs")}">{__("Total Jobs")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['jobs']|number_format}</p></div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-success icon-[tabler--circle-check] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Open Jobs")}">{__("Open Jobs")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['open']|number_format}</p></div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-error icon-[tabler--circle-x] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Closed Jobs")}">{__("Closed Jobs")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['closed']|number_format}</p></div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-neutral icon-[tabler--category] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Categories")}">{__("Categories")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['categories']|number_format}</p></div>
        </article>
      </div>
    {/if}

    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Jobs")}">
      <div class="js-flyonui-datatable-toolbar flex items-center justify-between gap-3 border-b border-base-300 px-5 py-3 max-md:flex-wrap">
        <form class="input max-w-72" action="{$system['system_url']}/{$control_panel['url']}/jobs/find" method="get" role="search">
          <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
          <input type="search" class="grow" name="query" id="admin-jobs-query" value="{if $query}{$query}{/if}" placeholder="{__("Search")}" title="{__("Search by Job Title or Description")}" aria-label="{__("Search by Job Title or Description")}" autocomplete="off">
        </form>
      </div>

      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead><tr><th>{__("Job")}</th><th>{__("Author")}</th><th>{__("Published")}</th><th>{__("Type")}</th><th>{__("Status")}</th><th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th></tr></thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/posts/{$row['post_id']}">
                      {if $row['cover_image']}
                        <img class="admin-list-avatar size-[38px] shrink-0 rounded-md border border-base-300 object-cover" src="{$system['system_uploads']}/{$row['cover_image']}" alt="" width="38" height="38" loading="lazy">
                      {else}
                        <span class="flex size-[38px] shrink-0 items-center justify-center rounded-md border border-base-300 bg-base-200"><span class="icon-[tabler--briefcase] text-base-content/60 size-5" aria-hidden="true"></span></span>
                      {/if}
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5"><span class="admin-list-name truncate text-sm font-semibold" title="{$row['title']}">{$row['title']}</span><span class="admin-list-id text-xs">#{$row['post_id']}</span></span>
                    </a>
                  </td>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-2.5" target="_blank" href="{$row['job_author_url']}">
                      <img class="admin-list-avatar size-[28px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['job_author_picture']}" alt="" width="28" height="28" loading="lazy">
                      <span class="admin-list-name max-w-48 truncate text-sm" title="{$row['job_author_name']}">{$row['job_author_name']}</span>
                    </a>
                  </td>
                  <td><span class="js_moment" data-time="{$row['time']}">{$row['time']}</span></td>
                  <td>{if $row['type_meta']}<span class="badge badge-soft badge-sm rounded-full">{$row['type_meta']}</span>{else}<span class="text-base-content/60">&mdash;</span>{/if}</td>
                  <td>{if $row['available'] == '1'}<span class="badge badge-soft badge-success badge-sm rounded-full">{__("Open")}</span>{else}<span class="badge badge-soft badge-error badge-sm rounded-full">{__("Closed")}</span>{/if}</td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="job-actions-{$row['post_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['title']}"><span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span></button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="job-actions-{$row['post_id']}">
                        <li><a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/posts/{$row['post_id']}"><span class="icon-[tabler--arrow-up-right] size-4" aria-hidden="true"></span>{__("View Job")}</a></li>
                        <li><button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="post" data-id="{$row['post_id']}"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Delete")}</button></li>
                      </ul>
                    </div>
                  </td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
        {if $pager}<div class="admin-list-pager">{$pager}</div>{/if}
      {else}
        <div class="admin-list-empty admin-list-empty-inline flex min-h-64 flex-col items-center justify-center px-6 py-10 text-center" aria-labelledby="admin-jobs-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200"><span class="icon-[tabler--briefcase-off] size-6" aria-hidden="true"></span></div>
          <h2 id="admin-jobs-empty-title">{__("No jobs found")}</h2>
          <p>{if $sub_view == "find"}{__("Try another job title or description.")}{else}{__("Jobs created by your community will appear here.")}{/if}</p>
        </div>
      {/if}
    </section>

  {elseif $sub_view == "categories"}
    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Job Categories")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead><tr><th>{__("Category")}</th><th>{__("Description")}</th><th>{__("Order")}</th><th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th></tr></thead>
            <tbody>{foreach $rows as $row}{include file='__categories.recursive_rows.tpl' _url="jobs" _handle="jobs_category" _style="admin-list"}{/foreach}</tbody>
          </table>
        </div>
      </section>
    {else}
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-job-categories-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200"><span class="icon-[tabler--category] size-6" aria-hidden="true"></span></div>
        <h2 id="admin-job-categories-empty-title">{__("No categories yet")}</h2>
        <p>{__("Add a category to organize jobs in the directory.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/jobs/add_category" class="btn btn-primary btn-sm"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Category")}</a>
      </section>
    {/if}

  {elseif $sub_view == "add_category" || $sub_view == "edit_category"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/jobs.php?do={if $sub_view == "edit_category"}edit_category&amp;id={$data['category_id']}{else}add_category{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="job-category-details-title">
          <h2 id="job-category-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--category] size-5" aria-hidden="true"></span>{__("Category Details")}</h2>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="job-category-name">{__("Name")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input class="input w-full" name="category_name" id="job-category-name" value="{if $sub_view == "edit_category"}{$data['category_name']}{/if}" autocomplete="off"></div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="job-category-description">{__("Description")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><textarea class="textarea w-full" name="category_description" id="job-category-description" rows="4">{if $sub_view == "edit_category"}{$data['category_description']}{/if}</textarea></div>
          </div>
          <div class="grid min-w-0 gap-5 md:grid-cols-2">
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="job-category-parent">{__("Parent Category")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="category_parent_id" id="job-category-parent">
                  <option value="0">{__("Set as a Parent Category")}</option>
                  {if $sub_view == "edit_category"}{foreach $data['categories'] as $category}{include file='__categories.recursive_options.tpl' data_category=$data['category_parent_id']}{/foreach}{else}{foreach $categories as $category}{include file='__categories.recursive_options.tpl'}{/foreach}{/if}
                </select>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="job-category-order">{__("Order")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input class="input w-full" name="category_order" id="job-category-order" value="{if $sub_view == "edit_category"}{$data['category_order']}{/if}" inputmode="numeric"><div class="admin-setting-help text-sm leading-relaxed">{__("Lower numbers appear first.")}</div></div>
            </div>
          </div>
        </div>
        <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
          <div class="admin-settings-feedback w-full min-w-0" aria-live="polite"><div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div><div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div></div>
          <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2"><button type="submit" class="btn btn-primary">{__("Save Changes")}</button></div>
        </div>
      </section>
    </form>
  {/if}

  {if $sub_view == "add_category" || $sub_view == "edit_category"}
    </div>
  {/if}
</section>
