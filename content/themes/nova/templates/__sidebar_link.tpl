<li>
  {$_module_icon = ''}
  {if !$_image && $system['system_theme_icons'] == 'svg' && $_module}
    {$_module_icon = $_module|theme_module_icon:'size-7 max-w-none shrink-0'}
  {/if}
  {$_highlight = ($_active && !$_sub)}
  <a href="{$_url}" class="gap-2.5 px-4 py-2 overlay-minified:justify-center overlay-minified:px-0{if $_sub} text-[13px]{/if}{if $_highlight} bg-primary/10 font-semibold text-primary! hover:bg-primary/15{else} font-medium text-base-content! hover:bg-base-300{/if}" aria-label="{$_label|escape}" {if $_active}aria-current="page" {/if}>
    {if $_image}
      <img class="size-7 max-w-none shrink-0 rounded-md object-cover" src="{$_image}" alt="">
    {elseif $_module_icon}
      {$_module_icon}
    {elseif $_icon}
      <span class="{$_icon} size-7 shrink-0{if !$_highlight} text-base-content/60{/if}" aria-hidden="true"></span>
    {/if}
    <span class="min-w-0 grow truncate overlay-minified:hidden" title="{$_label}">{$_label}</span>
    {if $_active && $_sub}
      <span class="icon-[tabler--check] size-4 shrink-0 text-primary overlay-minified:hidden" aria-hidden="true"></span>
    {/if}
  </a>
</li>
