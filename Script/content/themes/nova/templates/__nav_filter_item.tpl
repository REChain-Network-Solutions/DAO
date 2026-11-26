{$_filter_icon = ''}
{if $system['system_theme_icons'] == 'svg'}
  {$_filter_icon = $_module|theme_module_icon:'size-6 shrink-0'}
{/if}
<a class="dropdown-item{if $view == $_view} dropdown-active{else} text-inherit!{/if}" href="{$_url}" {if $view == $_view}aria-current="page"{/if}>
  {if $_filter_icon}
    {$_filter_icon}
  {else}
    <span class="{$_icon} size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
  {/if}
  {$_label}
</a>
