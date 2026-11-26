{if $system['system_theme_mode_select']}
  <!-- theme mode -->
  <button type="button" class="js_theme-mode inline-flex min-h-7 cursor-pointer items-center justify-center gap-2 rounded-field border-0 px-1.75 py-0 text-inherit leading-tight {if $_overlay}bg-white/15 backdrop-blur-sm hover:bg-white/25{else}bg-base-200 hover:bg-base-300 hover:text-inherit{/if}" data-mode="{if $system['theme_mode_night']}day{else}night{/if}">
    <span class="icon-[tabler--sun] hidden size-4 shrink-0 dark:inline-block" aria-hidden="true"></span>
    <span class="icon-[tabler--moon] size-4 shrink-0 dark:hidden" aria-hidden="true"></span>
    <span class="sr-only js_theme-mode-text">{if $system['theme_mode_night']}{__("Day Mode")}{else}{__("Night Mode")}{/if}</span>
  </button>
  <!-- theme mode -->
{/if}
