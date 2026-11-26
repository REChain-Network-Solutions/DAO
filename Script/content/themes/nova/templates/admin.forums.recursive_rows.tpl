{if !$_depth}{$_depth = 0}{/if}
<tr data-tree-depth="{$_depth}">
  <td>
    <span class="inline-flex items-center gap-1">
      {include file='__tree_toggle.tpl' _has_children=$row['childs']}
      <a class="admin-list-group-title" target="_blank" href="{$system['system_url']}/forums/{$row['forum_id']}/{$row['title_url']}">
        {$row['forum_name']}
      </a>
    </span>
  </td>
  <td>
    {$row['forum_description']|truncate:50}
  </td>
  <td>
    {$row['forum_threads']|number_format}
  </td>
  <td>
    <span class="badge badge-soft badge-primary badge-sm rounded-full">{$row['forum_order']}</span>
  </td>
  <td class="admin-list-actions-column w-14 text-end">
    <div class="dropdown relative inline-flex [--placement:bottom-end]">
      <button id="forum-actions-{$row['forum_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['forum_name']}">
        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
      </button>
      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="forum-actions-{$row['forum_id']}">
        <li>
          <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/forums/edit_forum/{$row['forum_id']}">
            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
            {__("Edit")}
          </a>
        </li>
        <li>
          <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="forum" data-id="{$row['forum_id']}">
            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
            {__("Delete")}
          </button>
        </li>
      </ul>
    </div>
  </td>
</tr>
{if $row['childs']}
  {foreach $row['childs'] as $_row}
    {include file='admin.forums.recursive_rows.tpl' row = $_row _depth=$_depth+1}
  {/foreach}
{/if}
