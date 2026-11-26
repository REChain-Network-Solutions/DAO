<li>
  {$_module_icon = ''}
  {if $system['system_theme_icons'] == 'svg' && $_module}
    {$_module_icon = $_module|theme_module_icon:'size-10 shrink-0'}
  {/if}
  <a {if $_class}href="#" class="{$_class} dropdown-item items-center gap-3 whitespace-normal text-base-content!" {elseif $_modal}href="#" class="js_modal dropdown-item items-center gap-3 whitespace-normal text-base-content!" data-url="{$_modal}" {if $_size}data-size="{$_size}" {/if}{if $_static}data-static="true" {/if}{else}href="{$_url}" class="dropdown-item items-center gap-3 whitespace-normal text-base-content!" {/if}role="menuitem">
    {if $_module_icon}
      {$_module_icon}
    {else}
      <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-field {$_color}"><span class="{$_icon} size-5" aria-hidden="true"></span></span>
    {/if}
    <span class="flex min-w-0 grow flex-col gap-0.5">
      <span class="text-sm font-semibold">{$_label}</span>
      {if $_desc}
        <span class="text-xs font-normal text-base-content/60">{$_desc}</span>
      {/if}
    </span>
    {if $_paid}
      <span class="badge badge-xs badge-soft badge-error shrink-0">{__("Paid")}</span>
    {/if}
  </a>
</li>
