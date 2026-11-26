{capture assign="_people_open"}0{/capture}
{capture assign="_pages_open"}0{/capture}
{capture assign="_groups_open"}0{/capture}
{capture assign="_events_open"}0{/capture}
{foreach $results as $result}
  {if $result['type'] == "user"}
    {if $_people_open == "0"}
      <div class="px-2.5 py-1.5 text-xs font-medium text-base-content/50" role="presentation">{__("People")}</div>
      {capture assign="_people_open"}1{/capture}
    {/if}
  {elseif $result['type'] == "page"}
    {if $_pages_open == "0"}
      <div class="px-2.5 py-1.5 text-xs font-medium text-base-content/50" role="presentation">{__("Pages")}</div>
      {capture assign="_pages_open"}1{/capture}
    {/if}
  {elseif $result['type'] == "group"}
    {if $_groups_open == "0"}
      <div class="px-2.5 py-1.5 text-xs font-medium text-base-content/50" role="presentation">{__("Groups")}</div>
      {capture assign="_groups_open"}1{/capture}
    {/if}
  {elseif $result['type'] == "event"}
    {if $_events_open == "0"}
      <div class="px-2.5 py-1.5 text-xs font-medium text-base-content/50" role="presentation">{__("Events")}</div>
      {capture assign="_events_open"}1{/capture}
    {/if}
  {/if}
  {include file='__search_combo_item.tpl' result=$result _search=true}
{/foreach}
{if $query}
  {capture assign="_more_href"}{$system['system_url']}/search/{$query}{/capture}
  {capture assign="_more_label"}{__("See All Results")}{/capture}
  <div class="px-2.5 py-1.5 text-xs font-medium text-base-content/50" role="presentation">{__("Search")}</div>
  {include file='__search_combo_more.tpl' combo_more_href=$_more_href combo_more_label=$_more_label}
{/if}
