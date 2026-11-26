{$_module_icon = ''}
{if $system['system_theme_icons'] == 'svg' && $_module}
  {if $_variant == "tile"}
    {$_module_icon = $_module|theme_module_icon:'size-14 shrink-0'}
  {else}
    {$_module_icon = $_module|theme_module_icon:'size-6 shrink-0'}
  {/if}
{/if}
{if $_variant == "tile"}
  <a class="group relative flex h-full min-w-0 flex-col gap-5 rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] p-6 text-base-content! transition duration-200 hover:-translate-y-0.5 hover:shadow-md {if $_tone}{$_tone}{else}bg-primary/10 hover:bg-primary/15{/if}" href="{$_url}">
    <span class="absolute end-5 top-5 inline-flex size-8 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-base-100/70 text-base-content/60 opacity-0 transition-opacity group-hover:opacity-100" aria-hidden="true">
      <span class="icon-[tabler--arrow-up-right] size-4 rtl:-scale-x-100"></span>
    </span>
    {if $_module_icon}
      {$_module_icon}
    {else}
      <span class="inline-flex size-14 shrink-0 items-center justify-center rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.25rem] bg-base-100 shadow-sm" aria-hidden="true">
        <span class="{$_icon} size-7 text-primary"></span>
      </span>
    {/if}
    <span class="flex min-w-0 flex-col gap-2">
      <span class="text-2xl font-bold tracking-tight">{$_title}</span>
      <span class="text-sm leading-relaxed text-base-content/70">{$_text}</span>
    </span>
  </a>
{else}
  <li>
    <a class="{if $_active}menu-active{else}text-base-content!{/if}" href="{$_url}" {if $_active}aria-current="page"{/if}>
      {if $_module_icon}
        {$_module_icon}
      {else}
        <span class="{$_icon} size-4.5 shrink-0 text-base-content/60" aria-hidden="true"></span>
      {/if}
      <span class="grow truncate" title="{$_title}">{$_title}</span>
      {if $_external}
        <span class="icon-[tabler--arrow-up-right] size-3.5 shrink-0 opacity-40" aria-hidden="true"></span>
      {/if}
    </a>
  </li>
{/if}
