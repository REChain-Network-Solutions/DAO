{if $result['type'] == "user"}
  {capture assign="_combo_name"}{if $system['show_usernames_enabled']}{$result['user_name']}{else}{$result['user_firstname']} {$result['user_lastname']}{/if}{/capture}
  {capture assign="_combo_href"}{$system['system_url']}/{$result['user_name']}{/capture}
  {assign var="_combo_picture" value=$result['user_picture']}
  {assign var="_combo_gname" value="people"}
  {capture assign="_combo_gtitle"}{__("People")}{/capture}
{elseif $result['type'] == "page"}
  {assign var="_combo_name" value=$result['page_title']}
  {capture assign="_combo_href"}{$system['system_url']}/pages/{$result['page_name']}{/capture}
  {assign var="_combo_picture" value=$result['page_picture']}
  {assign var="_combo_gname" value="pages"}
  {capture assign="_combo_gtitle"}{__("Pages")}{/capture}
{elseif $result['type'] == "group"}
  {assign var="_combo_name" value=$result['group_title']}
  {capture assign="_combo_href"}{$system['system_url']}/groups/{$result['group_name']}{/capture}
  {assign var="_combo_picture" value=$result['group_picture']}
  {assign var="_combo_gname" value="groups"}
  {capture assign="_combo_gtitle"}{__("Groups")}{/capture}
{elseif $result['type'] == "event"}
  {assign var="_combo_name" value=$result['event_title']}
  {capture assign="_combo_href"}{$system['system_url']}/events/{$result['event_id']}{/capture}
  {assign var="_combo_picture" value=$result['event_picture']}
  {assign var="_combo_gname" value="events"}
  {capture assign="_combo_gtitle"}{__("Events")}{/capture}
{/if}

{if $_group_name}
  {assign var="_combo_gname" value=$_group_name}
  {assign var="_combo_gtitle" value=$_group_title}
{/if}

{if $_combo_href}
  {if $_source}
    <span data-log-id="{$result['log_id']}" data-label="{$_combo_name|escape:'html'}" data-url="{$_combo_href}?ref=qs" data-picture="{$_combo_picture|escape:'html'}"></span>
  {elseif $_recent && $result['log_id']}
    <div class="group relative">
      <a class="js_site-palette-item dropdown-item pe-9 hover:bg-base-content/5" href="{$_combo_href}?ref=qs" data-recent="1" data-log-id="{$result['log_id']}">
        <img class="size-5 shrink-0 rounded-full object-cover" src="{$_combo_picture}" alt="">
        <span class="js_site-palette-label min-w-0 grow truncate text-sm text-base-content">{$_combo_name}</span>
      </a>
      <button type="button" class="js_site-palette-remove absolute end-1.5 top-1/2 flex size-6 -translate-y-1/2 items-center justify-center rounded-full text-base-content/45 opacity-0 hover:bg-base-content/10 hover:text-base-content group-hover:opacity-100 group-has-[.dropdown-active]:opacity-100 [@media(hover:none)]:opacity-100" data-log-id="{$result['log_id']}" tabindex="-1" aria-label="{__("Remove from recent")}">
        <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
      </button>
    </div>
  {else}
    <a class="js_site-palette-item dropdown-item hover:bg-base-content/5" href="{$_combo_href}{if $_search}?ref=qs{/if}" data-group="{$_combo_gname}">
      <img class="size-5 shrink-0 rounded-full object-cover" src="{$_combo_picture}" alt="">
      <span class="js_site-palette-label min-w-0 grow truncate text-sm text-base-content">{$_combo_name}</span>
    </a>
  {/if}
{/if}
