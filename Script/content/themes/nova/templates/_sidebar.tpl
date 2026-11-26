<!-- menu -->
{$_sidebar = $system['sidebar']|sidebar_items:$system['sidebar_more']}
<nav aria-label='{__("Menu")}'>
  <div class="flex items-center justify-between ps-4 pe-2 pb-1 overlay-minified:justify-center overlay-minified:px-0">
    <span class="text-[11px] font-medium uppercase tracking-wider text-base-content/40 overlay-minified:hidden">{__("Explore")}</span>
    <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-field text-base-content/60" aria-controls="site-sidebar" data-overlay-minifier="#site-sidebar" aria-label='{__("Collapse menu")}'>
      <span class="icon-[tabler--layout-sidebar-left-collapse] size-5 overlay-minified:hidden" aria-hidden="true"></span>
      <span class="icon-[tabler--layout-sidebar-left-expand] hidden size-5 overlay-minified:block" aria-hidden="true"></span>
    </button>
  </div>
  <ul class="menu menu-sm accordion w-full bg-transparent p-0" data-accordion-always-open>

    {include file='__sidebar_link.tpl' _url=$system['system_url'] _module="newsfeed" _icon="icon-[tabler--home]" _label=__("News Feed") _active=($page == "index" && in_array($view, ['', 'popular', 'discover']))}

    {foreach $_sidebar['main'] as $_key => $_item}
      {include file='__sidebar_link.tpl' _url=$_item['url'] _module=$_item['module'] _icon=$_item['icon'] _label=$_item['label'] _active=($page == $_item['page'] && (!$_item['views'] || in_array($view, $_item['views'])))}
    {/foreach}
  </ul>

  {$_more_open = false}
  {foreach $_sidebar['more'] as $_item}
    {if $page == $_item['page'] && (!$_item['views'] || in_array($view, $_item['views']))}
      {$_more_open = true}
    {/if}
  {/foreach}
  {$_more_pages = false}
  {if $static_pages}
    {foreach $static_pages as $static_page}
      {if $static_page['page_in_sidebar']}
        {$_more_pages = true}
      {/if}
    {/foreach}
  {/if}

  {if $_sidebar['more'] || $_more_pages}
  <!-- see more -->
  <ul id="site-nav-more" class="menu menu-sm accordion collapse w-full flex-nowrap overflow-hidden bg-transparent p-0 transition-[height] duration-300{if $_more_open} open{else} hidden{/if}" data-accordion-always-open aria-labelledby="site-nav-more-toggle">
    {foreach $_sidebar['more'] as $_key => $_item}
      {include file='__sidebar_link.tpl' _url=$_item['url'] _module=$_item['module'] _icon=$_item['icon'] _label=$_item['label'] _active=($page == $_item['page'] && (!$_item['views'] || in_array($view, $_item['views'])))}
    {/foreach}

    {if $static_pages}
      {foreach $static_pages as $static_page}
        {if $static_page['page_in_sidebar']}
          {include file='__sidebar_link.tpl' _url=$static_page['url'] _image=$static_page['page_icon'] _label=__($static_page['page_title']) _active=($page == "static_page" && $static_page['page_id'] == $static_page_id)}
        {/if}
      {/foreach}
    {/if}
  </ul>
  <button type="button" id="site-nav-more-toggle" class="collapse-toggle flex w-full items-center gap-2.5 rounded-field px-4 py-2 text-sm font-medium text-base-content hover:bg-base-300 overlay-minified:hidden{if $_more_open} open{/if}" data-collapse="#site-nav-more" aria-controls="site-nav-more" aria-expanded="{if $_more_open}true{else}false{/if}">
    <span class="flex size-7 shrink-0 items-center justify-center rounded-full bg-base-300">
      <span class="icon-[tabler--chevron-down] size-4 transition-transform duration-300 collapse-open:rotate-180" aria-hidden="true"></span>
    </span>
    <span class="collapse-open:hidden">{__("See More")}</span>
    <span class="hidden collapse-open:inline">{__("See Less")}</span>
  </button>
  <!-- see more -->
  {/if}

  {if $user->_logged_in}
    <!-- shortcuts -->
    <div class="mx-3 my-2 hidden border-t border-base-300 overlay-minified:block" role="separator"></div>
    <div class="mt-3 flex items-center justify-between ps-4 pe-2 pb-1 overlay-minified:hidden">
      <span class="text-[11px] font-medium uppercase tracking-wider text-base-content/40">{__("Shortcuts")}</span>
      <button type="button" class="js_modal heroui button button--ghost button--sm button--icon-only size-7.5 rounded-field text-base-content/60" data-url="users/shortcuts.php?do=manage" data-size="large" aria-label='{__("Edit your shortcuts")}'>
        <span class="icon-[tabler--pencil] size-4" aria-hidden="true"></span>
      </button>
    </div>
    <div id="site-shortcuts">
      {include file='__sidebar_shortcuts.tpl'}
    </div>
    <!-- shortcuts -->
  {/if}

</nav>
<!-- menu -->
