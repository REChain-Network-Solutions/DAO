<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-reports-title">
  {if $sub_view == "add_category" || $sub_view == "edit_category"}
    <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
  {/if}

  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-reports-title" class="text-2xl font-semibold">
        {if $sub_view == "categories"}
          {__("Reports Categories")}
        {elseif $sub_view == "add_category"}
          {__("Add New Category")}
        {elseif $sub_view == "edit_category"}
          {__("Edit Category")}
        {else}
          {__("Reports")}
        {/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "categories"}
          {__("Organize the reasons members can pick when they report something.")}
        {elseif $sub_view == "add_category"}
          {__("Create a reason members can pick when they report something.")}
        {elseif $sub_view == "edit_category"}
          {__("Update the name, parent and order of this category.")}
        {else}
          {__("Review reported members and content, then act on each report.")}
        {/if}
      </p>
    </div>

    {if $sub_view == ""}
      {if $rows}
        <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2 max-md:hidden">
          <button type="button" class="btn btn-outline js_admin-deleter" data-handle="reports" data-confirm-title='{__("Mark as Safe")}' data-delete-message='{__("Are you sure you want to mark all reports as safe?")}'>
            <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
            {__("Mark All As Safe")}
          </button>
        </div>
      {/if}
    {elseif $sub_view == "categories"}
      <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
        <a href="{$system['system_url']}/{$control_panel['url']}/reports/add_category" class="btn btn-primary">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Category")}
        </a>
      </div>
    {elseif $sub_view == "add_category" || $sub_view == "edit_category"}
      <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
        <a href="{$system['system_url']}/{$control_panel['url']}/reports/categories" class="btn btn-outline">
          <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
          {__("Go Back")}
        </a>
      </div>
    {/if}
  </header>

  {if $sub_view == ""}

    <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-error icon-[tabler--flag] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Reports")}">{__("Reports")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['reports']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-warning icon-[tabler--user-exclamation] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Reported Accounts")}">{__("Reported Accounts")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['accounts']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-info icon-[tabler--message-report] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Reported Content")}">{__("Reported Content")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['content']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-neutral icon-[tabler--clock] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Last 7 Days")}">{__("Last 7 Days")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['recent']|number_format}</p>
        </div>
      </article>
    </div>

    {if $rows}
      <button type="button" class="btn btn-outline w-full js_admin-deleter md:hidden" data-handle="reports" data-confirm-title='{__("Mark as Safe")}' data-delete-message='{__("Are you sure you want to mark all reports as safe?")}'>
        <span class="icon-[tabler--checks] size-4" aria-hidden="true"></span>
        {__("Mark All As Safe")}
      </button>
    {/if}

    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Reports")}">
      <!-- filters -->
      <div class="js-flyonui-datatable-toolbar border-base-300 flex items-center justify-between gap-3 border-b px-5 py-3 max-md:flex-wrap">
        <form class="admin-list-filters-inline flex flex-wrap items-center gap-2" action="{$system['system_url']}/{$control_panel['url']}/reports" method="get" role="search">
          <label class="input max-w-60">
            <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
            <input type="search" class="grow" name="query" id="admin-reports-query" value="{$query}" placeholder="{__("Search")}" title="{__("Search by Report ID, Reporter or Reason")}" aria-label="{__("Search by Report ID, Reporter or Reason")}" autocomplete="off">
          </label>
          <select class="select" name="type" aria-label="{__("Type")}">
            <option value="">{__("All Types")}</option>
            <option value="user"{if $type == "user"} selected{/if}>{__("User")}</option>
            <option value="page"{if $type == "page"} selected{/if}>{__("Page")}</option>
            <option value="group"{if $type == "group"} selected{/if}>{__("Group")}</option>
            <option value="event"{if $type == "event"} selected{/if}>{__("Event")}</option>
            <option value="post"{if $type == "post"} selected{/if}>{__("Post")}</option>
            <option value="comment"{if $type == "comment"} selected{/if}>{__("Comment")}</option>
            <option value="message"{if $type == "message"} selected{/if}>{__("Message")}</option>
            <option value="conversation"{if $type == "conversation"} selected{/if}>{__("Conversation")}</option>
            <option value="forum_thread"{if $type == "forum_thread"} selected{/if}>{__("Forum Thread")}</option>
            <option value="forum_reply"{if $type == "forum_reply"} selected{/if}>{__("Forum Reply")}</option>
            <option value="ads_campaign"{if $type == "ads_campaign"} selected{/if}>{__("Ads Campaign")}</option>
          </select>
          <select class="select" name="category" aria-label="{__("Reason")}">
            <option value="">{__("All Reasons")}</option>
            {foreach $categories as $category}
              {include file='__categories.recursive_options.tpl' data_category=$category_id}
            {/foreach}
          </select>
          <button type="submit" class="btn btn-outline h-9 min-h-9">
            <span class="icon-[tabler--filter] size-4" aria-hidden="true"></span>
            {__("Filter")}
          </button>
          {if $type || $category_id || $query}
            <a href="{$system['system_url']}/{$control_panel['url']}/reports" class="btn btn-outline h-9 min-h-9">
              <span class="icon-[tabler--refresh] size-4" aria-hidden="true"></span>
              {__("Reset")}
            </a>
          {/if}
        </form>
      </div>
      <!-- filters -->

      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("Reported Item")}</th>
                <th>{__("Type")}</th>
                <th>{__("Reported By")}</th>
                <th>{__("Reason")}</th>
                <th>{__("Time")}</th>
                <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    {if $row['node_type'] == "user"}
                      <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/{$row['node']['user_name']}">
                        <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['node']['user_picture']}" alt="" width="30" height="30" loading="lazy">
                        <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                          <span class="admin-list-name truncate text-sm font-semibold" title="{if $system['show_usernames_enabled']}{$row['node']['user_name']}{else}{$row['node']['user_firstname']} {$row['node']['user_lastname']}{/if}">{if $system['show_usernames_enabled']}{$row['node']['user_name']}{else}{$row['node']['user_firstname']} {$row['node']['user_lastname']}{/if}</span>
                          <span class="admin-list-id text-xs">#{$row['node_id']}</span>
                        </span>
                      </a>
                    {elseif $row['node_type'] == "page"}
                      <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/pages/{$row['node']['page_name']}">
                        <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['node']['page_picture']}" alt="" width="30" height="30" loading="lazy">
                        <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                          <span class="admin-list-name truncate text-sm font-semibold" title="{$row['node']['page_title']}">{$row['node']['page_title']}</span>
                          <span class="admin-list-id text-xs">#{$row['node_id']}</span>
                        </span>
                      </a>
                    {elseif $row['node_type'] == "group"}
                      <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/groups/{$row['node']['group_name']}">
                        <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['node']['group_picture']}" alt="" width="30" height="30" loading="lazy">
                        <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                          <span class="admin-list-name truncate text-sm font-semibold" title="{$row['node']['group_title']}">{$row['node']['group_title']}</span>
                          <span class="admin-list-id text-xs">#{$row['node_id']}</span>
                        </span>
                      </a>
                    {elseif $row['node_type'] == "event"}
                      <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/events/{$row['node_id']}">
                        <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['node']['event_picture']}" alt="" width="30" height="30" loading="lazy">
                        <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                          <span class="admin-list-name truncate text-sm font-semibold" title="{$row['node']['event_title']}">{$row['node']['event_title']}</span>
                          <span class="admin-list-id text-xs">#{$row['node_id']}</span>
                        </span>
                      </a>
                    {else}
                      {if $row['node_type'] == "post"}
                        {assign var=node_icon value="icon-[tabler--news]"}
                      {elseif $row['node_type'] == "comment"}
                        {assign var=node_icon value="icon-[tabler--message-circle]"}
                      {elseif $row['node_type'] == "forum_thread"}
                        {assign var=node_icon value="icon-[tabler--messages]"}
                      {elseif $row['node_type'] == "forum_reply"}
                        {assign var=node_icon value="icon-[tabler--message-reply]"}
                      {elseif $row['node_type'] == "ads_campaign"}
                        {assign var=node_icon value="icon-[tabler--speakerphone]"}
                      {elseif $row['node_type'] == "story"}
                        {assign var=node_icon value="icon-[tabler--history-toggle]"}
                      {elseif $row['node_type'] == "message"}
                        {assign var=node_icon value="icon-[tabler--message]"}
                      {elseif $row['node_type'] == "conversation"}
                        {assign var=node_icon value="icon-[tabler--messages]"}
                      {else}
                        {assign var=node_icon value="icon-[tabler--file-unknown]"}
                      {/if}
                      {if $row['node_type'] == "message" || $row['node_type'] == "conversation"}
                        <button type="button" class="js_modal admin-list-identity flex min-w-0 cursor-pointer items-center gap-3 border-0 bg-transparent p-0 text-start text-inherit" data-url="admin/reports.php?do=view&id={$row['report_id']}" data-size="large">
                          <span class="flex size-[30px] shrink-0 items-center justify-center rounded-full border border-base-300 bg-base-200">
                            <span class="{$node_icon} size-4" aria-hidden="true"></span>
                          </span>
                          <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                            <span class="admin-list-name truncate text-sm font-semibold" title="{$row['node']['name']}">{$row['node']['name']}</span>
                            <span class="admin-list-id text-xs">#{$row['node_id']}</span>
                          </span>
                        </button>
                      {elseif $row['url']}
                        <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$row['url']}">
                          <span class="flex size-[30px] shrink-0 items-center justify-center rounded-full border border-base-300 bg-base-200">
                            <span class="{$node_icon} size-4" aria-hidden="true"></span>
                          </span>
                          <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                            <span class="admin-list-name truncate text-sm font-semibold" title="{$row['node']['name']}">{$row['node']['name']}</span>
                            <span class="admin-list-id text-xs">#{$row['node_id']}</span>
                          </span>
                        </a>
                      {else}
                        <span class="admin-list-identity flex min-w-0 items-center gap-3">
                          <span class="flex size-[30px] shrink-0 items-center justify-center rounded-full border border-base-300 bg-base-200">
                            <span class="{$node_icon} size-4" aria-hidden="true"></span>
                          </span>
                          <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                            <span class="admin-list-name truncate text-sm font-semibold" title="{$row['node']['name']}">{$row['node']['name']}</span>
                            <span class="admin-list-id text-xs">#{$row['node_id']}</span>
                          </span>
                        </span>
                      {/if}
                    {/if}
                  </td>
                  <td>
                    {if $row['node_type'] == "user"}
                      {assign var=node_badge value="badge-primary"}
                    {elseif $row['node_type'] == "page"}
                      {assign var=node_badge value="badge-info"}
                    {elseif $row['node_type'] == "group" || $row['node_type'] == "ads_campaign"}
                      {assign var=node_badge value="badge-warning"}
                    {elseif $row['node_type'] == "event"}
                      {assign var=node_badge value="badge-success"}
                    {elseif $row['node_type'] == "post"}
                      {assign var=node_badge value="badge-error"}
                    {elseif $row['node_type'] == "message"}
                      {assign var=node_badge value="badge-info"}
                    {else}
                      {assign var=node_badge value="bg-base-200 text-base-content"}
                    {/if}
                    <span class="badge badge-soft {$node_badge} badge-sm rounded-full">{$row['node']['name']}</span>
                  </td>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/{$row['user_name']}">
                      <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['user_picture']}" alt="" width="30" height="30" loading="lazy">
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5">
                        <span class="admin-list-name truncate text-sm font-semibold" title="{if $system['show_usernames_enabled']}{$row['user_name']}{else}{$row['user_firstname']} {$row['user_lastname']}{/if}">{if $system['show_usernames_enabled']}{$row['user_name']}{else}{$row['user_firstname']} {$row['user_lastname']}{/if}</span>
                        <span class="admin-list-id text-xs">{__("Report")} #{$row['report_id']}</span>
                      </span>
                    </a>
                  </td>
                  <td>
                    <div class="grid min-w-0 max-w-xs gap-1">
                      {if $row['category_name']}
                        <span><span class="badge badge-soft badge-sm rounded-full">{__($row['category_name'])}</span></span>
                      {/if}
                      {if $row['reason']}
                        <span class="text-base-content/60 truncate text-xs" title="{$row['reason']}">{$row['reason']}</span>
                      {/if}
                    </div>
                  </td>
                  <td>{$row['time']|date_format:"%e %B %Y"}</td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="report-actions-{$row['report_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} #{$row['report_id']}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="report-actions-{$row['report_id']}">
                        {if $row['node_type'] == "user"}
                          <li>
                            <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/{$row['node']['user_name']}">
                              <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
                              {__("View")}
                            </a>
                          </li>
                          <li>
                            <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/{$control_panel['url']}/users/edit/{$row['node_id']}">
                              <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                              {__("Edit")}
                            </a>
                          </li>
                        {elseif $row['node_type'] == "page"}
                          <li>
                            <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/pages/{$row['node']['page_name']}">
                              <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
                              {__("View")}
                            </a>
                          </li>
                          <li>
                            <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/{$control_panel['url']}/pages/edit_page/{$row['node_id']}">
                              <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                              {__("Edit")}
                            </a>
                          </li>
                        {elseif $row['node_type'] == "group"}
                          <li>
                            <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/groups/{$row['node']['group_name']}">
                              <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
                              {__("View")}
                            </a>
                          </li>
                          <li>
                            <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/{$control_panel['url']}/groups/edit_group/{$row['node_id']}">
                              <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                              {__("Edit")}
                            </a>
                          </li>
                        {elseif $row['node_type'] == "event"}
                          <li>
                            <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/events/{$row['node_id']}">
                              <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
                              {__("View")}
                            </a>
                          </li>
                          <li>
                            <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/{$control_panel['url']}/events/edit_event/{$row['node_id']}">
                              <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                              {__("Edit")}
                            </a>
                          </li>
                        {elseif $row['node_type'] == "message" || $row['node_type'] == "conversation"}
                          <li>
                            <button type="button" class="dropdown-item px-2 js_modal" role="menuitem" data-url="admin/reports.php?do=view&id={$row['report_id']}" data-size="large">
                              <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
                              {__("View")}
                            </button>
                          </li>
                        {elseif $row['url']}
                          <li>
                            <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$row['url']}">
                              <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
                              {__("View")}
                            </a>
                          </li>
                          {if $row['node_type'] == "forum_thread"}
                            <li>
                              <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/forums/edit-thread/{$row['node_id']}">
                                <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                                {__("Edit")}
                              </a>
                            </li>
                          {elseif $row['node_type'] == "forum_reply"}
                            <li>
                              <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/forums/edit-reply/{$row['node_id']}">
                                <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                                {__("Edit")}
                              </a>
                            </li>
                          {elseif $row['node_type'] == "ads_campaign"}
                            <li>
                              <a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/ads/edit/{$row['node_id']}">
                                <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                                {__("Edit")}
                              </a>
                            </li>
                          {/if}
                        {/if}
                        <li>
                          <button type="button" class="dropdown-item px-2 js_admin-deleter" role="menuitem" data-handle="report" data-id="{$row['report_id']}" data-confirm-title='{__("Mark as Safe")}' data-delete-message='{__("Are you sure you want to mark this report as safe?")}'>
                            <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
                            {__("Mark as Safe")}
                          </button>
                        </li>
                        {if $row['node_type'] == "user" || $row['node_type'] == "page" || $row['node_type'] == "group" || $row['node_type'] == "event" || $row['node_type'] == "post" || $row['node_type'] == "comment" || $row['node_type'] == "forum_thread" || $row['node_type'] == "forum_reply" || $row['node_type'] == "ads_campaign" || $row['node_type'] == "story"}
                          <li>
                            <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="{$row['node_type']}" data-id="{$row['node_id']}" data-node="{$row['report_id']}">
                              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                              {__("Delete")}
                            </button>
                          </li>
                        {/if}
                      </ul>
                    </div>
                  </td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
        {if $pager}
          <div class="admin-list-pager">{$pager}</div>
        {/if}
      {else}
        <div class="admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none admin-list-empty-inline min-h-60 border-0 bg-transparent" aria-labelledby="admin-reports-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--flag] size-6" aria-hidden="true"></span>
          </div>
          <h2 id="admin-reports-empty-title">
            {if $type || $category_id || $query}
              {__("No reports found")}
            {else}
              {__("No reports yet")}
            {/if}
          </h2>
          <p>
            {if $type || $category_id || $query}
              {__("Try another keyword, type or reason.")}
            {else}
              {__("Nothing has been reported by your members so far.")}
            {/if}
          </p>
        </div>
      {/if}
    </section>

  {elseif $sub_view == "categories"}

    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Reports Categories")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead>
              <tr>
                <th>{__("Category")}</th>
                <th>{__("Description")}</th>
                <th>{__("Order")}</th>
                <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $rows as $row}
                {include file='__categories.recursive_rows.tpl' _url="reports" _handle="report_category" _style="admin-list"}
              {/foreach}
            </tbody>
          </table>
        </div>
      </section>
    {else}
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-reports-categories-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
          <span class="icon-[tabler--category] size-6" aria-hidden="true"></span>
        </div>
        <h2 id="admin-reports-categories-empty-title">{__("No categories yet")}</h2>
        <p>{__("Add a category to give members a reason to pick when reporting.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/reports/add_category" class="btn btn-primary btn-sm">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Add New Category")}
        </a>
      </section>
    {/if}

  {elseif $sub_view == "add_category" || $sub_view == "edit_category"}

    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/reports.php?do={if $sub_view == "edit_category"}edit_category&amp;id={$data['category_id']}{else}add_category{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="report-category-details-title">
          <h2 id="report-category-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            <span class="icon-[tabler--category] size-5" aria-hidden="true"></span>
            {__("Category Details")}
          </h2>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="report-category-name">{__("Name")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <input class="input w-full" name="category_name" id="report-category-name" value="{if $sub_view == "edit_category"}{$data['category_name']}{/if}" autocomplete="off">
            </div>
          </div>

          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="report-category-description">{__("Description")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <textarea class="textarea w-full" name="category_description" id="report-category-description" rows="4">{if $sub_view == "edit_category"}{$data['category_description']}{/if}</textarea>
            </div>
          </div>

          <div class="grid min-w-0 gap-5 md:grid-cols-2">
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="report-category-parent">{__("Parent Category")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="category_parent_id" id="report-category-parent">
                  <option value="0">{__("Set as a Parent Category")}</option>
                  {if $sub_view == "edit_category"}{foreach $data['categories'] as $category}{include file='__categories.recursive_options.tpl' data_category=$data['category_parent_id']}{/foreach}{else}{foreach $categories as $category}{include file='__categories.recursive_options.tpl'}{/foreach}{/if}
                </select>
              </div>
            </div>

            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="report-category-order">{__("Order")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input class="input w-full" name="category_order" id="report-category-order" value="{if $sub_view == "edit_category"}{$data['category_order']}{/if}" inputmode="numeric">
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
