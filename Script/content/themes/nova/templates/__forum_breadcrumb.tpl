<nav class="breadcrumbs {if !$_flush}mt-6 {/if}py-0 text-sm" aria-label="{__("Breadcrumb")}">
  <ul>
    <li class="shrink-0">
      <a class="text-base-content/60! hover:text-primary!" href="{$system['system_url']}/forums" title="{__("Forums")}" aria-label="{__("Forums")}">
        <span class="icon-[tabler--home] size-4" aria-hidden="true"></span>
        <span class="hidden sm:inline">{__("Forums")}</span>
      </a>
    </li>
    <li class="breadcrumbs-separator rtl:rotate-180"><span class="icon-[tabler--chevron-right] size-4" aria-hidden="true"></span></li>
    {if ($_parents && ($_forum || $_thread || count($_parents) > 1)) || ($_forum && $_thread)}
      <!-- collapsed -->
      <li class="dropdown relative inline-flex shrink-0 sm:hidden [--placement:bottom-start]">
        <button id="forum-breadcrumb-more" type="button" class="dropdown-toggle heroui button button--ghost button--sm button--icon-only size-7 rounded-[0.5rem] text-base-content/60" aria-haspopup="menu" aria-expanded="false" title="{__("More")}" aria-label="{__("More")}">
          <span class="icon-[tabler--dots] size-4" aria-hidden="true"></span>
        </button>
        <div class="dropdown-menu dropdown-open:opacity-100 hidden min-w-48 max-w-72 p-1" role="menu" aria-labelledby="forum-breadcrumb-more">
          {if $_parents}
            {foreach array_reverse($_parents) as $_parent}
              {if $_forum || $_thread || !$_parent@last}
                <a class="dropdown-item text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5" role="menuitem" href="{$system['system_url']}/forums/{$_parent['forum_id']}/{$_parent['title_url']}">
                  <span class="truncate" title="{__($_parent['forum_name'])}">{__($_parent['forum_name'])}</span>
                </a>
              {/if}
            {/foreach}
          {/if}
          {if $_forum && $_thread}
            <a class="dropdown-item text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5" role="menuitem" href="{$system['system_url']}/forums/{$_forum['forum_id']}/{$_forum['title_url']}">
              <span class="truncate" title="{__($_forum['forum_name'])}">{__($_forum['forum_name'])}</span>
            </a>
          {/if}
        </div>
      </li>
      <li class="breadcrumbs-separator rtl:rotate-180 sm:hidden"><span class="icon-[tabler--chevron-right] size-4" aria-hidden="true"></span></li>
      <!-- collapsed -->
    {/if}
    {if $_parents}
      {foreach array_reverse($_parents) as $_parent}
        {$_crumb_collapsed = ($_forum || $_thread || !$_parent@last)}
        <li class="{if $_crumb_collapsed}max-sm:hidden{else}min-w-0{/if}"><a class="min-w-0 text-base-content/60! hover:text-primary!" href="{$system['system_url']}/forums/{$_parent['forum_id']}/{$_parent['title_url']}"><span class="truncate" title="{__($_parent['forum_name'])}">{__($_parent['forum_name'])}</span></a></li>
        {if $_forum || $_thread || $_current || !$_parent@last}
          <li class="breadcrumbs-separator rtl:rotate-180{if $_crumb_collapsed} max-sm:hidden{/if}"><span class="icon-[tabler--chevron-right] size-4" aria-hidden="true"></span></li>
        {/if}
      {/foreach}
    {/if}
    {if $_forum}
      <li class="{if $_thread}max-sm:hidden{else}min-w-0{/if}"><a class="min-w-0 text-base-content/60! hover:text-primary!" href="{$system['system_url']}/forums/{$_forum['forum_id']}/{$_forum['title_url']}"><span class="truncate" title="{__($_forum['forum_name'])}">{__($_forum['forum_name'])}</span></a></li>
      {if $_thread || $_current}
        <li class="breadcrumbs-separator rtl:rotate-180{if $_thread} max-sm:hidden{/if}"><span class="icon-[tabler--chevron-right] size-4" aria-hidden="true"></span></li>
      {/if}
    {/if}
    {if $_thread}
      <li class="min-w-0"><a class="min-w-0 text-base-content/60! hover:text-primary!" href="{$system['system_url']}/forums/thread/{$_thread['thread_id']}/{$_thread['title_url']}"><span class="truncate sm:max-w-60" title="{$_thread['title']}">{$_thread['title']}</span></a></li>
      {if $_current}
        <li class="breadcrumbs-separator rtl:rotate-180"><span class="icon-[tabler--chevron-right] size-4" aria-hidden="true"></span></li>
      {/if}
    {/if}
    {if $_current}
      <li aria-current="page" class="min-w-0 font-medium text-base-content"><span class="block max-w-72 truncate" title="{$_current}">{$_current}</span></li>
    {/if}
  </ul>
</nav>
