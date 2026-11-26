{$_toggle_icon = ''}
{if $system['system_theme_icons'] == 'svg' && $_module}
  {$_toggle_icon = $_module|theme_module_icon:'size-7 max-w-none shrink-0'}
{/if}
{if $_toggle_icon}
  {$_toggle_icon}
{elseif $_icon}
  <span class="{$_icon} size-7 shrink-0{if !$_active} text-base-content/60{/if}" aria-hidden="true"></span>
{/if}
<span class="min-w-0 grow truncate overlay-minified:hidden" title="{$_label}">{$_label}</span>
<span class="icon-[tabler--chevron-down] accordion-item-active:rotate-180 size-4 shrink-0 transition-transform duration-300 overlay-minified:hidden{if $_active} text-primary{else} text-base-content/50{/if}" aria-hidden="true"></span>
