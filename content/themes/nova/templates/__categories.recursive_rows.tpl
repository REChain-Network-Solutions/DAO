{if !$_depth}{$_depth = 0}{/if}
<tr data-tree-depth="{$_depth}">
  {if $_style == "admin-list"}
    <td>
      <span class="inline-flex items-center gap-1">
        {include file='__tree_toggle.tpl' _has_children=$row['sub_categories']}
        <span class="admin-list-group-title">{$row['category_name']}</span>
      </span>
    </td>
    {if $_has_image}
      <td>
        {if {$row['category_image']}}
          <img class="admin-list-avatar size-[30px] shrink-0 rounded-full border border-base-300 object-cover" src="{$system['system_uploads']}/{$row['category_image']}" alt="" width="30" height="30" loading="lazy">
        {else}
          <span class="text-base-content/50">{__("N/A")}</span>
        {/if}
      </td>
    {/if}
    <td>
      {$row['category_description']|truncate:50}
    </td>
    <td>
      <span class="badge badge-soft badge-primary badge-sm rounded-full">{$row['category_order']}</span>
    </td>
    <td class="admin-list-actions-column w-14 text-end">
      <div class="dropdown relative inline-flex [--placement:bottom-end]">
        <button id="category-actions-{$row['category_id']}" type="button" class="dropdown-toggle heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['category_name']}">
          <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
        </button>
        <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="category-actions-{$row['category_id']}">
          <li>
            <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/{$_url}/edit_{if $_edit_slug}{$_edit_slug}_{/if}category/{$row['category_id']}">
              <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
              {__("Edit")}
            </a>
          </li>
          <li>
            <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="{$_handle}" data-id="{$row['category_id']}">
              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
              {__("Delete")}
            </button>
          </li>
        </ul>
      </div>
    </td>
  {else}
    <td>
      <span class="inline-flex items-center gap-1">
        {include file='__tree_toggle.tpl' _has_children=$row['sub_categories']}
        {$row['category_name']}
      </span>
    </td>
    {if $_has_image}
      <td>
        {if {$row['category_image']}}
          <img class="img-thumbnail table-img-thumbnail" src="{$system['system_uploads']}/{$row['category_image']}" width="64px" height="64px">
        {else}
          N/A
        {/if}
      </td>
    {/if}
    <td>
      {$row['category_description']|truncate:50}
    </td>
    <td>
      <span class="badge rounded-full badge-lg bg-info">{$row['category_order']}</span>
    </td>
    <td>
      <span class="tooltip inline-flex [--placement:top]">
        <a aria-label='{__("Edit")}' href="{$system['system_url']}/{$control_panel['url']}/{$_url}/edit_{if $_edit_slug}{$_edit_slug}_{/if}category/{$row['category_id']}" class="tooltip-toggle heroui button button--primary button--sm button--icon-only size-7.5 rounded-full rounded-full">
          <span class="icon-[tabler--pencil] size-4" aria-hidden="true"></span>
        </a>
        <span class="tooltip-content tooltip-shown:opacity-100 tooltip-shown:visible" role="tooltip"><span class="tooltip-body px-2 py-1 text-xs font-medium">{__("Edit")}</span></span>
      </span>
      <span class="tooltip inline-flex [--placement:top]">
        <button aria-label='{__("Delete")}' class="tooltip-toggle heroui button button--danger button--sm button--icon-only size-7.5 rounded-full rounded-full js_admin-deleter" data-handle="{$_handle}" data-id="{$row['category_id']}">
          <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
        </button>
        <span class="tooltip-content tooltip-shown:opacity-100 tooltip-shown:visible" role="tooltip"><span class="tooltip-body px-2 py-1 text-xs font-medium">{__("Delete")}</span></span>
      </span>
    </td>
  {/if}
</tr>
{if $row['sub_categories']}
  {foreach $row['sub_categories'] as $_row}
    {include file='__categories.recursive_rows.tpl' row=$_row _url=$_url _handle=$_handle _has_image=$_has_image _edit_slug=$_edit_slug _style=$_style _depth=$_depth+1}
  {/foreach}
{/if}
