<li>
  {$_side_icon = ''}
  {if $system['system_theme_icons'] == 'svg' && $_module}
    {$_side_icon = $_module|theme_module_icon:'size-9 shrink-0'}
  {/if}
  <a class="dropdown-item text-inherit!{if $_active} dropdown-active{/if}" href="{$_url}" {if $_active}aria-current="page" {/if}>
    {if $_side_icon}
      {$_side_icon}
    {else}
      <span class="{$_icon} size-9 shrink-0 text-base-content/60" aria-hidden="true"></span>
    {/if}
    {$_label}
  </a>
</li>
