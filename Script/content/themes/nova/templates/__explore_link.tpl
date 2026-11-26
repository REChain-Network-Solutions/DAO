<li>
  {$_module_icon = ''}
  {if !$_image && $system['system_theme_icons'] == 'svg' && $_module}
    {$_module_icon = $_module|theme_module_icon:'size-10 shrink-0'}
  {/if}
  <a href="{$_url}" class="dropdown-item items-start gap-3 whitespace-normal {if $_active}dropdown-active{else}text-base-content!{/if}" {if $_active}aria-current="page" {/if}>
    {if $_image}
      <img class="size-10 shrink-0 rounded-field object-cover" src="{$_image}" alt="">
    {elseif $_module_icon}
      {$_module_icon}
    {else}
      <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-field {$_color}"><span class="{$_icon} size-5" aria-hidden="true"></span></span>
    {/if}
    <span class="flex min-w-0 flex-col gap-0.5">
      <span class="text-sm font-semibold">{$_label}</span>
      {if $_desc}
        <span class="text-xs font-normal text-base-content/60">{$_desc}</span>
      {/if}
    </span>
  </a>
</li>
