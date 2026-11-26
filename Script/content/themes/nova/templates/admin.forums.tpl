<section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-forums-title">
  {if $sub_view == "add_forum" || $sub_view == "edit_forum"}
    <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
  {/if}

  <header class="admin-list-heading flex items-start justify-between gap-4">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-forums-title" class="text-2xl font-semibold">
        {if $sub_view == "add_forum"}{__("Add New Forum")}
        {elseif $sub_view == "edit_forum"}{__("Edit Forum")}
        {elseif $sub_view == "threads"}{__("Threads")}
        {elseif $sub_view == "find_threads"}{__("Find Threads")}
        {elseif $sub_view == "replies"}{__("Replies")}
        {elseif $sub_view == "find_replies"}{__("Find Replies")}
        {else}{__("Forums")}{/if}
      </h1>
      <p class="text-base-content/60 text-sm">
        {if $sub_view == "add_forum"}{__("Create a forum and place it in the forums directory.")}
        {elseif $sub_view == "edit_forum"}{__("Update this forum and its position in the forums directory.")}
        {elseif $sub_view == "find_threads"}{__("Search results for thread titles and texts.")}
        {elseif $sub_view == "find_replies"}{__("Search results for reply texts.")}
        {else}{__("Manage forums, threads, and replies.")}{/if}
      </p>
    </div>

    <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
      {if $sub_view == ""}
        <a href="{$system['system_url']}/{$control_panel['url']}/forums/add_forum" class="btn btn-primary"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Forum")}</a>
      {elseif $sub_view == "add_forum" || $sub_view == "edit_forum"}
        <a href="{$system['system_url']}/{$control_panel['url']}/forums" class="btn btn-outline"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
      {elseif $sub_view == "find_threads"}
        <a href="{$system['system_url']}/{$control_panel['url']}/forums/threads" class="btn btn-outline"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
      {elseif $sub_view == "find_replies"}
        <a href="{$system['system_url']}/{$control_panel['url']}/forums/replies" class="btn btn-outline"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
      {else}
        <a href="{$system['system_url']}/{$control_panel['url']}/forums" class="btn btn-outline"><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>{__("Go Back")}</a>
      {/if}
    </div>
  </header>

  {if $sub_view == ""}
    <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-info icon-[tabler--messages] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Total Forums")}">{__("Total Forums")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['forums']|number_format}</p></div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-neutral icon-[tabler--category] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Sections")}">{__("Sections")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['sections']|number_format}</p></div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-success icon-[tabler--message-circle] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Threads")}">{__("Threads")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['threads']|number_format}</p></div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-warning icon-[tabler--message] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1"><span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Replies")}">{__("Replies")}</span><p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['replies']|number_format}</p></div>
      </article>
    </div>

    {if $rows}
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Forums")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead><tr><th>{__("Forum")}</th><th>{__("Description")}</th><th>{__("Threads")}</th><th>{__("Order")}</th><th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th></tr></thead>
            <tbody>
              {foreach $rows as $row}
                {include file='admin.forums.recursive_rows.tpl'}
              {/foreach}
            </tbody>
          </table>
        </div>
      </section>
    {else}
      <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none" aria-labelledby="admin-forums-empty-title">
        <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200"><span class="icon-[tabler--messages] size-6" aria-hidden="true"></span></div>
        <h2 id="admin-forums-empty-title">{__("No forums yet")}</h2>
        <p>{__("Add a forum to start the discussion.")}</p>
        <a href="{$system['system_url']}/{$control_panel['url']}/forums/add_forum" class="btn btn-primary btn-sm"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add New Forum")}</a>
      </section>
    {/if}

  {elseif $sub_view == "threads" || $sub_view == "find_threads"}
    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Threads")}">
      <div class="js-flyonui-datatable-toolbar flex items-center justify-between gap-3 border-b border-base-300 px-5 py-3 max-md:flex-wrap">
        <form class="input max-w-72" action="{$system['system_url']}/{$control_panel['url']}/forums/find_threads" method="get" role="search">
          <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
          <input type="search" class="grow" name="query" id="admin-forum-threads-query" value="{if $query}{$query}{/if}" placeholder="{__("Search")}" title="{__("Search by Thread Title or Text")}" aria-label="{__("Search by Thread Title or Text")}" autocomplete="off">
        </form>
      </div>

      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead><tr><th>{__("Thread")}</th><th>{__("Author")}</th><th>{__("Posted")}</th><th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th></tr></thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/forums/thread/{$row['thread_id']}/{$row['thread_title_url']}">
                      <span class="flex size-[38px] shrink-0 items-center justify-center rounded-md border border-base-300 bg-base-200"><span class="icon-[tabler--message-circle] text-base-content/60 size-5" aria-hidden="true"></span></span>
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5"><span class="admin-list-name truncate text-sm font-semibold" title="{$row['title']}">{$row['title']}</span><span class="admin-list-id text-xs">#{$row['thread_id']}</span></span>
                    </a>
                  </td>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-2.5" target="_blank" href="{$row['thread_author_url']}">
                      <img class="admin-list-avatar size-[28px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['thread_author_picture']}" alt="" width="28" height="28" loading="lazy">
                      <span class="admin-list-name max-w-48 truncate text-sm" title="{$row['thread_author_name']}">{$row['thread_author_name']}</span>
                    </a>
                  </td>
                  <td><span class="js_moment" data-time="{$row['time']}">{$row['time']}</span></td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="forum-thread-actions-{$row['thread_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['title']}"><span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span></button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="forum-thread-actions-{$row['thread_id']}">
                        <li><a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/forums/thread/{$row['thread_id']}/{$row['thread_title_url']}"><span class="icon-[tabler--arrow-up-right] size-4" aria-hidden="true"></span>{__("View Thread")}</a></li>
                        <li><button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="forum_thread" data-id="{$row['thread_id']}"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Delete")}</button></li>
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
        <div class="admin-list-empty admin-list-empty-inline flex min-h-64 flex-col items-center justify-center px-6 py-10 text-center" aria-labelledby="admin-forum-threads-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200"><span class="icon-[tabler--message-circle-off] size-6" aria-hidden="true"></span></div>
          <h2 id="admin-forum-threads-empty-title">{__("No threads found")}</h2>
          <p>{if $sub_view == "find_threads"}{__("Try another thread title or text.")}{else}{__("Threads created by your community will appear here.")}{/if}</p>
        </div>
      {/if}
    </section>

  {elseif $sub_view == "replies" || $sub_view == "find_replies"}
    <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Replies")}">
      <div class="js-flyonui-datatable-toolbar flex items-center justify-between gap-3 border-b border-base-300 px-5 py-3 max-md:flex-wrap">
        <form class="input max-w-72" action="{$system['system_url']}/{$control_panel['url']}/forums/find_replies" method="get" role="search">
          <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
          <input type="search" class="grow" name="query" id="admin-forum-replies-query" value="{if $query}{$query}{/if}" placeholder="{__("Search")}" title="{__("Search by Reply Text")}" aria-label="{__("Search by Reply Text")}" autocomplete="off">
        </form>
      </div>

      {if $rows}
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table">
            <thead><tr><th>{__("Reply")}</th><th>{__("Author")}</th><th>{__("Thread")}</th><th>{__("Posted")}</th><th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th></tr></thead>
            <tbody>
              {foreach $rows as $row}
                <tr>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/forums/thread/{$row['thread_id']}/{$row['thread_title_url']}/#reply-{$row['reply_id']}">
                      <span class="flex size-[38px] shrink-0 items-center justify-center rounded-md border border-base-300 bg-base-200"><span class="icon-[tabler--message] text-base-content/60 size-5" aria-hidden="true"></span></span>
                      <span class="admin-list-identity-text grid min-w-32 max-w-md gap-0.5"><span class="admin-list-name truncate text-sm font-semibold" title="{$row['text']}">{$row['text']|strip_tags|truncate:50}</span><span class="admin-list-id text-xs">#{$row['reply_id']}</span></span>
                    </a>
                  </td>
                  <td>
                    <a class="admin-list-identity flex min-w-0 items-center gap-2.5" target="_blank" href="{$row['reply_author_url']}">
                      <img class="admin-list-avatar size-[28px] shrink-0 rounded-full border border-base-300 object-cover" src="{$row['reply_author_picture']}" alt="" width="28" height="28" loading="lazy">
                      <span class="admin-list-name max-w-48 truncate text-sm" title="{$row['reply_author_name']}">{$row['reply_author_name']}</span>
                    </a>
                  </td>
                  <td>
                    <a class="admin-list-name max-w-48 truncate text-sm" target="_blank" href="{$system['system_url']}/forums/thread/{$row['thread_id']}/{$row['thread_title_url']}" title="{$row['title']}">{$row['title']}</a>
                  </td>
                  <td><span class="js_moment" data-time="{$row['time']}">{$row['time']}</span></td>
                  <td class="admin-list-actions-column w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="forum-reply-actions-{$row['reply_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['title']}"><span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span></button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="forum-reply-actions-{$row['reply_id']}">
                        <li><a class="dropdown-item px-2" role="menuitem" target="_blank" href="{$system['system_url']}/forums/thread/{$row['thread_id']}/{$row['thread_title_url']}/#reply-{$row['reply_id']}"><span class="icon-[tabler--arrow-up-right] size-4" aria-hidden="true"></span>{__("View Reply")}</a></li>
                        <li><button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="forum_reply" data-id="{$row['reply_id']}"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Delete")}</button></li>
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
        <div class="admin-list-empty admin-list-empty-inline flex min-h-64 flex-col items-center justify-center px-6 py-10 text-center" aria-labelledby="admin-forum-replies-empty-title">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200"><span class="icon-[tabler--message-off] size-6" aria-hidden="true"></span></div>
          <h2 id="admin-forum-replies-empty-title">{__("No replies found")}</h2>
          <p>{if $sub_view == "find_replies"}{__("Try another reply text.")}{else}{__("Replies posted by your community will appear here.")}{/if}</p>
        </div>
      {/if}
    </section>

  {elseif $sub_view == "add_forum" || $sub_view == "edit_forum"}
    <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/forums.php?do={if $sub_view == "edit_forum"}edit_forum&amp;id={$data['forum_id']}{else}add_forum{/if}">
      <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
        <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="forum-details-title">
          <h2 id="forum-details-title" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title"><span class="icon-[tabler--messages] size-5" aria-hidden="true"></span>{__("Forum Details")}</h2>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="forum-name">{__("Name")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input class="input w-full" name="forum_name" id="forum-name" value="{if $sub_view == "edit_forum"}{$data['forum_name']}{/if}" autocomplete="off"></div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="forum-description">{__("Description")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2"><textarea class="textarea w-full" name="forum_description" id="forum-description" rows="4">{if $sub_view == "edit_forum"}{$data['forum_description']}{/if}</textarea></div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
            <label class="label-text" for="forum-color">{__("Color")}</label>
            <div class="admin-setting-control flex min-w-0 flex-col gap-2">
              <div class="admin-settings-colorpicker js_colorpicker">
                <input type="text" class="input w-full" name="forum_color" id="forum-color" value="{if $sub_view == "edit_forum"}{$data['forum_color']}{/if}" autocomplete="off">
                <input type="color" class="admin-settings-color-swatch" value="{if $sub_view == "edit_forum"}{$data['forum_color']}{/if}" aria-label="{__("Color")}">
              </div>
              <div class="admin-setting-help text-sm leading-relaxed">{__("Leave empty to use the theme color.")}</div>
            </div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="radiogroup" aria-labelledby="forum-icon-label">
            <div class="label-text" id="forum-icon-label">{__("Icon")}</div>
            <div class="admin-setting-control flex min-w-0 flex-wrap gap-2">
              {foreach ['messages' => 'icon-[tabler--messages]', 'speakerphone' => 'icon-[tabler--speakerphone]', 'bulb' => 'icon-[tabler--bulb]', 'help' => 'icon-[tabler--help-circle]', 'lifebuoy' => 'icon-[tabler--lifebuoy]', 'bug' => 'icon-[tabler--bug]', 'code' => 'icon-[tabler--code]', 'palette' => 'icon-[tabler--palette]', 'photo' => 'icon-[tabler--photo]', 'music' => 'icon-[tabler--music]', 'gamepad' => 'icon-[tabler--device-gamepad-2]', 'book' => 'icon-[tabler--book]', 'school' => 'icon-[tabler--school]', 'briefcase' => 'icon-[tabler--briefcase]', 'cart' => 'icon-[tabler--shopping-cart]', 'heart' => 'icon-[tabler--heart]', 'star' => 'icon-[tabler--star]', 'flame' => 'icon-[tabler--flame]', 'world' => 'icon-[tabler--world]', 'coffee' => 'icon-[tabler--coffee]'] as $_icon => $_icon_class}
                <label class="cursor-pointer" title="{$_icon|capitalize}">
                  <input type="radio" class="peer sr-only" name="forum_icon" value="{$_icon}" aria-label="{$_icon|capitalize}" {if ($sub_view == "edit_forum" && $data['forum_icon'] == $_icon) || ($_icon == "messages" && ($sub_view == "add_forum" || !$data['forum_icon']))}checked{/if}>
                  <span class="flex size-10 items-center justify-center rounded-xl border border-base-300 text-base-content/60 peer-checked:border-primary peer-checked:bg-primary/10 peer-checked:text-primary peer-focus-visible:outline-2 peer-focus-visible:outline-primary">
                    <span class="{$_icon_class} size-5" aria-hidden="true"></span>
                  </span>
                </label>
              {/foreach}
            </div>
          </div>
          <div class="grid min-w-0 gap-5 md:grid-cols-2">
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="forum-section">{__("Section")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="forum_section" id="forum-section">
                  <option value="0">{__("Set as a Section")}</option>
                  {if $sub_view == "edit_forum"}
                    {foreach $data['sections'] as $forum}
                      {include file='admin.forums.recursive_options.tpl'}
                    {/foreach}
                  {else}
                    {foreach $forums as $forum}
                      {include file='admin.forums.recursive_options.tpl'}
                    {/foreach}
                  {/if}
                </select>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="forum-order">{__("Order")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2"><input class="input w-full" name="forum_order" id="forum-order" value="{if $sub_view == "edit_forum"}{$data['forum_order']}{/if}" inputmode="numeric"><div class="admin-setting-help text-sm leading-relaxed">{__("Lower numbers appear first.")}</div></div>
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

  {if $sub_view == "add_forum" || $sub_view == "edit_forum"}
    </div>
  {/if}
</section>
