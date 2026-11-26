{if $shortcuts}
  <ul class="menu menu-sm w-full bg-transparent p-0">
    {foreach $shortcuts as $_shortcut}
      {if $_shortcut@index < 5}
        {include file='__sidebar_link.tpl' _url=$_shortcut['url'] _image=$_shortcut['picture'] _label=$_shortcut['title']}
      {/if}
    {/foreach}
  </ul>
  {if count($shortcuts) > 5}
    <!-- see more -->
    <ul id="site-shortcuts-more" class="menu menu-sm collapse hidden w-full flex-nowrap overflow-hidden bg-transparent p-0 transition-[height] duration-300" aria-labelledby="site-shortcuts-more-toggle">
      {foreach $shortcuts as $_shortcut}
        {if $_shortcut@index >= 5}
          {include file='__sidebar_link.tpl' _url=$_shortcut['url'] _image=$_shortcut['picture'] _label=$_shortcut['title']}
        {/if}
      {/foreach}
    </ul>
    <button type="button" id="site-shortcuts-more-toggle" class="collapse-toggle flex w-full items-center gap-2.5 rounded-field px-4 py-2 text-sm font-medium text-base-content hover:bg-base-300 overlay-minified:hidden" data-collapse="#site-shortcuts-more" aria-controls="site-shortcuts-more" aria-expanded="false">
      <span class="flex size-7 shrink-0 items-center justify-center rounded-full bg-base-300">
        <span class="icon-[tabler--chevron-down] size-4 transition-transform duration-300 collapse-open:rotate-180" aria-hidden="true"></span>
      </span>
      <span class="collapse-open:hidden">{__("See More")}</span>
      <span class="hidden collapse-open:inline">{__("See Less")}</span>
    </button>
    <!-- see more -->
  {/if}
{/if}
