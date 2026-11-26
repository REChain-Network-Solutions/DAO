<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-pages-title">
  {if $sub_view == "add_category" || $sub_view == "edit_category"}
    <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
  {/if}

  {if $sub_view != "edit_page"}
    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-pages-title" class="text-2xl font-semibold">
          {if $sub_view == "find"}{__("Find Pages")}
          {elseif $sub_view == "categories"}{__("Page Categories")}
          {elseif $sub_view == "add_category"}{__("Add New Category")}
          {elseif $sub_view == "edit_category"}{__("Edit Category")}
          {else}{__("Pages")}{/if}
        </h1>
        <p class="text-base-content/60 text-sm">
          {if $sub_view == "find"}{__("Search results for page titles and web addresses.")}
          {elseif $sub_view == "categories"}{__("Organize pages into categories that are easy to browse.")}
          {elseif $sub_view == "add_category"}{__("Create a category and place it in the page directory hierarchy.")}
          {elseif $sub_view == "edit_category"}{__("Update this category and its position in the page directory.")}
          {else}{__("Manage community pages, ownership, and verification.")}{/if}
        </p>
      </div>
      <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
        {if $sub_view == "find"}
          <a href="{$system['system_url']}/{$control_panel['url']}/pages" class="btn btn-outline"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
        {elseif $sub_view == "categories"}
          <a href="{$system['system_url']}/{$control_panel['url']}/pages/add_category" class="btn btn-primary"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Category")}</a>
        {elseif $sub_view == "add_category" || $sub_view == "edit_category"}
          <a href="{$system['system_url']}/{$control_panel['url']}/pages/categories" class="btn btn-outline"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
        {/if}
      </div>
    </header>
  {/if}

  {if $sub_view == "" || $sub_view == "find"}
    {if $sub_view == ""}
      <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-3 lg:gap-5">
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-info icon-[tabler--flag] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Pages")}">{__("Pages")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['pages']|number_format}</p></div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-success icon-[tabler--rosette-discount-check] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Verified Pages")}">{__("Verified Pages")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['pages_verified']|number_format}</p></div>
        </article>
        <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
          <span class="admin-stat-icon is-error icon-[tabler--heart] size-6 shrink-0" aria-hidden="true"></span>
          <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Total Likes")}">{__("Total Likes")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['pages_likes']|number_format}</p></div>
        </article>
      </div>
    {/if}

    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Pages")}">
      <div class="js-flyonui-datatable-toolbar flex items-center justify-between gap-3 border-b border-base-300 px-5 py-3 max-md:flex-wrap">
        <form class="input max-w-72" action="{$system['system_url']}/{$control_panel['url']}/pages/find" method="get" role="search">
          <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
          <input type="search" class="grow" name="query" id="admin-pages-query" placeholder="{__("Search")}" title="{__("Search by Page Web Address or Title")}" aria-label="{__("Search by Page Web Address or Title")}" autocomplete="off">
        </form>
      </div>
      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead><tr><th>{__("Page")}</th><th>{__("Admin")}</th><th>{__("Likes")}</th><th>{__("Verified")}</th><th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th></tr></thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/pages/{$row['page_name']}">
                      <img class="admin-list-avatar size-[34px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['page_picture']}" alt="" width="34" height="34" loading="lazy">
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5"><span class="admin-list-name truncate text-sm font-semibold" title="{$row['page_title']}">{$row['page_title']}</span><span class="admin-list-id text-xs">@{$row['page_name']} (#{$row['page_id']})</span></span>
                    </a>
                  </td>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-2.5" target="_blank" href="{$system['system_url']}/{$row['user_name']}">
                      <img class="admin-list-avatar size-[28px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['user_picture']}" alt="" width="28" height="28" loading="lazy">
                      <span class="admin-list-name max-w-48 truncate text-sm" title="{if $system['show_usernames_enabled']}{$row['user_name']}{else}{$row['user_firstname']} {$row['user_lastname']}{/if}">{if $system['show_usernames_enabled']}{$row['user_name']}{else}{$row['user_firstname']} {$row['user_lastname']}{/if}</span>
                    </a>
                  </td>
                  <td><span class="admin-list-inline inline-flex items-center gap-1.5"><span class="icon-[tabler--heart] size-4 opacity-60" aria-hidden="true"></span>{$row['page_likes']|number_format}</span></td>
                  <td>{if $row['page_verified']}<span class="badge badge-soft badge-success badge-sm gap-1 rounded-full"><span class="icon-[tabler--check] size-3.5" aria-hidden="true"></span>{__("Yes")}</span>{else}<span class="badge badge-soft badge-sm rounded-full">{__("No")}</span>{/if}</td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="page-actions-{$row['page_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['page_title']}"><span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span></button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="page-actions-{$row['page_id']}">
                        <li><a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/pages/{$row['page_name']}"><span class="icon-[tabler--arrow-up-right] size-4" aria-hidden="true"></span>{__("View Page")}</a></li>
                        <li><a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/pages/edit_page/{$row['page_id']}"><span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>{__("Edit")}</a></li>
                        <li><button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="page" data-id="{$row['page_id']}"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Delete")}</button></li>
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
        <div class="admin-list-empty admin-list-empty-inline flex min-h-64 flex-col items-center justify-center px-6 py-10 text-center" aria-labelledby="admin-pages-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200"><span class="icon-[tabler--flag-off] size-6" aria-hidden="true"></span></div>
          <h2 id="admin-pages-empty-title">{__("No pages found")}</h2>
          <p>{if $sub_view == "find"}{__("Try another page title or web address.")}{else}{__("Pages created by your community will appear here.")}{/if}</p>
        </div>
      {/if}
    </section>

  {elseif $sub_view == "edit_page"}
    <header class="admin-user-hero admin-page-hero flex min-w-0 flex-col gap-5 border-b border-base-300 pb-5 sm:flex-row sm:items-center sm:justify-between" aria-labelledby="admin-pages-title">
      <div class="admin-user-hero-identity flex min-w-0 items-center gap-4">
        <a class="admin-user-summary-photo size-16 shrink-0 overflow-hidden rounded-full border border-base-300 bg-base-200 focus-visible:outline-2 focus-visible:outline-offset-2" href="{$system['system_url']}/pages/{$data['page_name']}" target="_blank" aria-label="{__("View Page")}: {$data['page_title']}"><img src="{$data['page_picture']}" alt="{$data['page_title']}"></a>
        <div class="min-w-0">
          <h1 id="admin-pages-title" class="m-0 truncate text-2xl font-semibold" title="{$data['page_title']}"><a class="text-inherit hover:underline focus-visible:underline focus-visible:outline-none" href="{$system['system_url']}/pages/{$data['page_name']}" target="_blank">{$data['page_title']}</a></h1>
          <div class="admin-user-hero-meta mt-1 flex min-w-0 flex-wrap items-center gap-2">
            <a class="admin-user-summary-handle truncate" href="{$system['system_url']}/pages/{$data['page_name']}" target="_blank" title="@{$data['page_name']}">@{$data['page_name']}</a>
            {if $data['page_verified']}<span class="badge badge-soft badge-info badge-sm rounded-full admin-user-hero-badge is-verified"><span class="icon-[tabler--rosette-discount-check] size-3.5" aria-hidden="true"></span>{__("Verified")}</span>{/if}
          </div>
        </div>
      </div>
      <div class="admin-user-hero-actions flex shrink-0 flex-wrap items-center gap-2">
        <a class="btn btn-outline" href="{$system['system_url']}/{$control_panel['url']}/pages"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
      </div>
    </header>

    <div class="admin-user-edit admin-page-edit grid w-full gap-6">
      <div class="admin-user-edit-aside flex min-w-0 flex-col gap-4 lg:sticky lg:top-[5.5rem]">
        <aside class="admin-user-summary flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6" aria-label="{__("Page summary")}">
          <div class="admin-user-sidebar-heading flex min-w-0 items-center gap-3"><div class="admin-user-sidebar-heading-icon flex size-8 shrink-0 items-center justify-center rounded-md border border-base-300 bg-base-100"><span class="icon-[tabler--flag] size-4" aria-hidden="true"></span></div><h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug">{__("Page Details")}</h2></div>
          <ul class="admin-user-summary-list grid gap-3">
            <li><span class="admin-user-summary-label"><span class="icon-[tabler--id] size-3.5" aria-hidden="true"></span>{__("Page ID")}</span><span class="admin-user-summary-value flex items-center justify-end gap-1"><span>{$data['page_id']}</span><button type="button" class="admin-user-copy-button js_clipboard" data-clipboard-text="{$data['page_id']}" title="{__("Copy")}" aria-label="{__("Copy")} {__("Page ID")}"><span class="js-clipboard-default icon-[tabler--copy] size-3.5" aria-hidden="true"></span><span class="js-clipboard-success icon-[tabler--check] hidden size-3.5 text-success" aria-hidden="true"></span></button></span></li>
            <li><span class="admin-user-summary-label"><span class="icon-[tabler--calendar] size-3.5" aria-hidden="true"></span>{__("Created")}</span><span class="admin-user-summary-value">{$data['page_date']|date_format:"%e %B %Y"}</span></li>
            <li><span class="admin-user-summary-label"><span class="icon-[tabler--heart] size-3.5" aria-hidden="true"></span>{__("Likes")}</span><span class="admin-user-summary-value">{$data['page_likes']|number_format}</span></li>
            <li><span class="admin-user-summary-label"><span class="icon-[tabler--user] size-3.5" aria-hidden="true"></span>{__("Created By")}</span><span class="admin-user-summary-value"><a class="admin-user-referrer" href="{$system['system_url']}/{$data['user_name']}" target="_blank"><img class="admin-list-avatar size-[22px] shrink-0 rounded-full object-cover" src="{$data['user_picture']}" alt="" width="22" height="22" loading="lazy"><span>{if $system['show_usernames_enabled']}{$data['user_name']}{else}{$data['user_firstname']} {$data['user_lastname']}{/if}</span></a></span></li>
          </ul>
          <div class="admin-user-summary-actions grid gap-2 border-t border-base-300 pt-5">
            <a class="btn btn-outline w-full" href="{$system['system_url']}/pages/{$data['page_name']}" target="_blank"><span class="icon-[tabler--arrow-up-right] size-4" aria-hidden="true"></span>{__("View Page")}</a>
            <a class="btn btn-outline w-full" href="{$system['system_url']}/pages/{$data['page_name']}/settings" target="_blank"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("Settings")}</a>
          </div>
        </aside>
        <section class="admin-user-danger flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6" aria-labelledby="admin-page-danger-title">
          <div class="admin-user-sidebar-heading flex min-w-0 items-center gap-3"><div class="admin-user-sidebar-heading-icon is-danger flex size-8 shrink-0 items-center justify-center rounded-md border bg-base-100"><span class="icon-[tabler--alert-triangle] size-4" aria-hidden="true"></span></div><h2 id="admin-page-danger-title" class="m-0 text-sm font-semibold leading-snug text-error">{__("Danger Zone")}</h2></div>
          <p class="admin-setting-help m-0 text-sm leading-relaxed">{__("Deleting posts or this page cannot be undone.")}</p>
          <div class="admin-user-summary-actions grid gap-2">
            <button type="button" class="btn w-full text-error admin-user-danger-action js_admin-deleter" data-handle="page_posts" data-id="{$data['page_id']}" data-delete-message="{__("Are you sure you want to delete all posts?")}"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Delete Posts")}</button>
            <button type="button" class="btn w-full text-error admin-user-danger-action js_admin-deleter" data-handle="page" data-id="{$data['page_id']}" data-redirect="{$system['system_url']}/{$control_panel['url']}/pages"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Delete Page")}</button>
          </div>
        </section>
      </div>

      <div class="admin-user-edit-main flex min-w-0 flex-col gap-6">
        <nav class="tabs admin-settings-nav admin-user-edit-nav" role="tablist" aria-label="{__("Page Settings")}" aria-orientation="horizontal">
          <button type="button" id="pages-tab-settings" class="tab active-tab:tab-active active" data-tab="#page-settings" aria-controls="page-settings" role="tab" aria-selected="true"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("Settings")}</button>
          <button type="button" id="pages-tab-info" class="tab active-tab:tab-active" data-tab="#page-info" aria-controls="page-info" role="tab" aria-selected="false"><span class="icon-[tabler--info-circle] size-4" aria-hidden="true"></span>{__("Info")}</button>
          {if $system['monetization_enabled']}<button type="button" id="pages-tab-monetization" class="tab active-tab:tab-active" data-tab="#page-monetization" aria-controls="page-monetization" role="tab" aria-selected="false"><span class="icon-[tabler--coins] size-4" aria-hidden="true"></span>{__("Monetization")}</button>{/if}
        </nav>

        <div id="page-settings" class="admin-settings-panel js_admin-settings-panel" role="tabpanel" aria-labelledby="pages-tab-settings" tabindex="0">
          <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/pages.php?do=edit_page&amp;edit=settings&amp;id={$data['page_id']}">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="page-status-title">
                <h2 id="page-status-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--rosette-discount-check] size-5" aria-hidden="true"></span>{__("Page Status")}</h2>
                <div class="admin-setting-switch js_admin-setting-switch">
                  <div class="admin-setting-icon"><span class="icon-[tabler--rosette-discount-check] size-6" aria-hidden="true"></span></div>
                  <div><label class="admin-setting-label block text-sm font-medium leading-normal" for="page_verified">{__("Verified Page")}</label><div id="page_verified-help" class="admin-setting-help text-sm leading-relaxed">{__("If enabled this page will have a verified badge")}</div></div>
                  <div class="text-end"><input type="checkbox" class="switch switch-primary" name="page_verified" id="page_verified" {if $data['page_verified']}checked{/if} aria-describedby="page_verified-help"></div>
                </div>
                {if $system['tips_enabled']}
                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon"><span class="icon-[tabler--tip-jar] size-6" aria-hidden="true"></span></div>
                    <div><label class="admin-setting-label block text-sm font-medium leading-normal" for="page_tips_enabled">{__("Tips Enabled")}</label><div id="page_tips_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Allow the send tips button on your page")}</div></div>
                    <div class="text-end"><input type="checkbox" class="switch switch-primary" name="page_tips_enabled" id="page_tips_enabled" {if $data['page_tips_enabled']}checked{/if} aria-describedby="page_tips_enabled-help"></div>
                  </div>
                {/if}
                {if $system['pages_messages_enabled']}
                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon"><span class="icon-[tabler--message-circle] size-6" aria-hidden="true"></span></div>
                    <div><label class="admin-setting-label block text-sm font-medium leading-normal" for="page_messages_enabled">{__("Messages Enabled")}</label><div id="page_messages_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Allow people to message your page")}</div></div>
                    <div class="text-end"><input type="checkbox" class="switch switch-primary" name="page_messages_enabled" id="page_messages_enabled" {if $data['page_messages_enabled']}checked{/if} aria-describedby="page_messages_enabled-help"></div>
                  </div>
                {/if}
              </div>
              <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="page-identity-title">
                <h2 id="page-identity-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--flag] size-5" aria-hidden="true"></span>{__("Page Identity")}</h2>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="page-title">{__("Name Your Page")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input class="input w-full" name="title" id="page-title" value="{$data['page_title']}" autocomplete="off"></div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="page-username">{__("Page Username")}</label>
                  <div class="admin-setting-control join w-full min-w-0" dir="ltr"><span class="join-item hidden max-w-64 sm:flex min-w-10 shrink-0 items-center justify-center border border-e-0 border-base-300 bg-base-200 px-3 text-sm text-base-content/60 [[data-theme=admin-dark]_&]:border-base-content/30"><span class="truncate whitespace-nowrap" title="{$system['system_url']}/pages/">{$system['system_url']}/pages/</span></span><input type="text" class="input join-item min-w-0 flex-1" name="username" id="page-username" value="{$data['page_name']}" autocomplete="off"></div>
                </div>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="page-category">{__("Category")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2"><select class="select w-full" name="category" id="page-category">{foreach $data['categories'] as $category}{include file='__categories.recursive_options.tpl' data_category=$data['page_category']}{/foreach}</select></div>
                </div>
              </div>
              <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
                <div class="admin-settings-feedback w-full min-w-0" aria-live="polite"><div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div><div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div></div>
                <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2"><button type="submit" class="btn btn-primary">{__("Save Changes")}</button></div>
              </div>
            </section>
          </form>
        </div>

        <div id="page-info" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="pages-tab-info" tabindex="0">
          <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/pages.php?do=edit_page&amp;edit=info&amp;id={$data['page_id']}">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="page-business-title">
                <h2 id="page-business-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--building-store] size-5" aria-hidden="true"></span>{__("Business Details")}</h2>
                <div class="grid min-w-0 gap-5 md:grid-cols-2">
                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field"><label class="label-text" for="page-company">{__("Company")}</label><input type="text" class="input w-full" name="company" id="page-company" value="{$data['page_company']}"></div>
                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field"><label class="label-text" for="page-phone">{__("Phone")}</label><input type="text" class="input w-full" name="phone" id="page-phone" value="{$data['page_phone']}"></div>
                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field"><label class="label-text" for="page-website">{__("Website")}</label><input type="text" class="input w-full" name="website" id="page-website" value="{$data['page_website']}" inputmode="url"></div>
                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field"><label class="label-text" for="page-location">{__("Location")}</label><input type="text" class="input w-full js_geocomplete" name="location" id="page-location" value="{$data['page_location']}"><input type="hidden" name="latitude" data-geo="lat" value="{$data['page_latitude']}"><input type="hidden" name="longitude" data-geo="lng" value="{$data['page_longitude']}"></div>
                </div>
              </div>
              <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="page-localization-title">
                <h2 id="page-localization-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--world] size-5" aria-hidden="true"></span>{__("Localization")}</h2>
                <div class="grid min-w-0 gap-5 md:grid-cols-2">
                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field"><label class="label-text" for="page-country">{__("Country")}</label><select class="select w-full" name="country" id="page-country"><option value="none">{__("Select Country")}</option>{foreach $data['countries'] as $country}<option value="{$country['country_id']}" {if $data['page_country'] == $country['country_id']}selected{/if}>{$country['country_name_with_flag']}</option>{/foreach}</select></div>
                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field"><label class="label-text" for="page-language">{__("Language")}</label><select class="select w-full" name="language" id="page-language"><option value="none">{__("Select Language")}</option>{foreach $languages as $language}<option value="{$language['language_id']}" {if $data['page_language'] == $language['language_id']}selected{/if}>{$language['title']}</option>{/foreach}</select></div>
                </div>
              </div>
              <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="page-about-title">
                <h2 id="page-about-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--file-description] size-5" aria-hidden="true"></span>{__("About")}</h2>
                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field"><label class="label-text" for="page-description">{__("About")}</label><textarea class="textarea w-full" name="description" id="page-description" rows="5">{$data['page_description']}</textarea></div>
                {if $custom_fields['basic']}{include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}{/if}
              </div>
              <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
                <div class="admin-settings-feedback w-full min-w-0" aria-live="polite"><div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div><div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div></div>
                <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2"><button type="submit" class="btn btn-primary">{__("Save Changes")}</button></div>
              </div>
            </section>
          </form>
        </div>

        {if $system['monetization_enabled']}
          <div id="page-monetization" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="pages-tab-monetization" tabindex="0">
            {if $data['can_monetize_content']}
              <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/pages.php?do=edit_page&amp;edit=monetization&amp;id={$data['page_id']}">
                {if $data['page_monetization_discount_enabled']}<input type="hidden" name="page_monetization_discount_enabled" value="1">{/if}
                <input type="hidden" name="page_monetization_discount_percent" value="{$data['page_monetization_discount_percent']}">
                <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
                  <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="page-monetization-title">
                    <h2 id="page-monetization-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--coins] size-5" aria-hidden="true"></span>{__("Monetization")}</h2>
                    <div class="admin-setting-switch js_admin-setting-switch">
                      <div class="admin-setting-icon"><span class="icon-[tabler--coin] size-6" aria-hidden="true"></span></div>
                      <div><label class="admin-setting-label block text-sm font-medium leading-normal" for="page_monetization_enabled">{__("Monetization")}</label><div id="page_monetization_enabled-help" class="admin-setting-help text-sm leading-relaxed">{__("Enable or disable monetization for your content")}</div></div>
                      <div class="text-end"><input type="checkbox" class="switch switch-primary" name="page_monetization_enabled" id="page_monetization_enabled" {if $data['page_monetization_enabled']}checked{/if} aria-describedby="page_monetization_enabled-help"></div>
                    </div>
                  </div>
                  <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="page-plans-title">
                    <div class="grid gap-1"><h2 id="page-plans-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--credit-card] size-5" aria-hidden="true"></span>{__("Payment Plans")}</h2><p class="admin-setting-help m-0 text-sm leading-relaxed">{__("Plans people can choose to support this page.")}</p></div>
                    {include file='__monetization_plans.tpl' _node_id=$data['page_id'] _node_type='page'}
                  </div>
                  <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
                    <div class="admin-settings-feedback w-full min-w-0" aria-live="polite"><div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div><div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div></div>
                    <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2"><button type="submit" class="btn btn-primary">{__("Save Changes")}</button></div>
                  </div>
                </section>
              </form>
            {else}
              <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="page-monetization-unavailable-title">
                <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200"><span class="icon-[tabler--coin-off] size-6" aria-hidden="true"></span></div>
                <h2 id="page-monetization-unavailable-title">{__("Monetization unavailable")}</h2><p>{__("This page super admin is not eligible for monetization")}</p>
              </section>
            {/if}
          </div>
        {/if}
      </div>
    </div>

  {elseif $sub_view == "categories"}
    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Page Categories")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead><tr><th>{__("Category")}</th><th>{__("Description")}</th><th>{__("Order")}</th><th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th></tr></thead>
            <tbody>{foreach $rows as $row}{include file='__categories.recursive_rows.tpl' _url="pages" _handle="page_category" _style="admin-list"}{/foreach}</tbody>
          </table>
        </div>
      </section>
    {else}
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-page-categories-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200"><span class="icon-[tabler--category] size-6" aria-hidden="true"></span></div>
        <h2 id="admin-page-categories-empty-title">{__("No categories yet")}</h2>
        <p>{__("Add a category to organize pages in the directory.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/pages/add_category" class="btn btn-primary btn-sm"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Category")}</a>
      </section>
    {/if}

  {elseif $sub_view == "add_category" || $sub_view == "edit_category"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/pages.php?do={if $sub_view == "edit_category"}edit_category&amp;id={$data['category_id']}{else}add_category{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="page-category-details-title">
          <h2 id="page-category-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--category] size-5" aria-hidden="true"></span>{__("Category Details")}</h2>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="page-category-name">{__("Name")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input class="input w-full" name="category_name" id="page-category-name" value="{if $sub_view == "edit_category"}{$data['category_name']}{/if}" autocomplete="off"></div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="page-category-description">{__("Description")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><textarea class="textarea w-full" name="category_description" id="page-category-description" rows="4">{if $sub_view == "edit_category"}{$data['category_description']}{/if}</textarea></div>
          </div>
          <div class="grid min-w-0 gap-5 md:grid-cols-2">
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="page-category-parent">{__("Parent Category")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="category_parent_id" id="page-category-parent">
                  <option value="0">{__("Set as a Parent Category")}</option>
                  {if $sub_view == "edit_category"}{foreach $data['categories'] as $category}{include file='__categories.recursive_options.tpl' data_category=$data['category_parent_id']}{/foreach}{else}{foreach $categories as $category}{include file='__categories.recursive_options.tpl'}{/foreach}{/if}
                </select>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="page-category-order">{__("Order")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input class="input w-full" name="category_order" id="page-category-order" value="{if $sub_view == "edit_category"}{$data['category_order']}{/if}" inputmode="numeric"><div class="admin-setting-help text-sm leading-relaxed">{__("Lower numbers appear first.")}</div></div>
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
