<div class="px-2 text-xs text-base-content/60">
  <div class="flex items-center justify-between gap-3 border-b border-base-300 pb-3">
    <span class="min-w-0 truncate" title="&copy; {date('Y')} {__($system['system_title'])}">&copy; {date('Y')} {__($system['system_title'])}</span>
    <div class="flex shrink-0 items-center gap-2">
      {if $system['languages']}
        {include file='__language_selector.tpl'}
      {/if}
      {include file='__theme_switcher.tpl'}
    </div>
  </div>
  <ul class="mt-3 flex flex-wrap gap-x-3 gap-y-1.5">
    {if $static_pages}
      {foreach $static_pages as $static_page}
        {if $static_page['page_in_footer']}
          <li>
            <a class="text-base-content/60! hover:text-primary!" href="{$static_page['url']}">
              {__($static_page['page_title'])}
            </a>
          </li>
        {/if}
      {/foreach}
    {/if}
    {if $system['contact_enabled']}
      <li>
        <a class="text-base-content/60! hover:text-primary!" href="{$system['system_url']}/contacts">
          {__("Contact Us")}
        </a>
      </li>
    {/if}
    {if $system['support_center_enabled']}
      <li>
        <a class="text-base-content/60! hover:text-primary!" href="{$system['system_url']}/support">
          {__("Support Center")}
        </a>
      </li>
    {/if}
    {if $system['directory_enabled']}
      <li>
        <a class="text-base-content/60! hover:text-primary!" href="{$system['system_url']}/directory">
          {__("Directory")}
        </a>
      </li>
    {/if}
  </ul>
</div>
