{if $_mode == "post"}
  <div class="mx-4 flex items-center gap-3 rounded-2xl border border-base-300 bg-base-100 p-3 {if $_combo}mt-3{/if}">
    <span class="flex size-12 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary" aria-hidden="true">
      {if $_file['type']}
        <span class="text-xs font-semibold">{$_file['type']}</span>
      {else}
        <span class="icon-[tabler--file] size-6"></span>
      {/if}
    </span>
    <span class="min-w-0 grow">
      <span class="block truncate text-sm font-semibold" title="{if $_file['name']}{$_file['name']}{else}{__("Download File")}{/if}">{if $_file['name']}{$_file['name']}{else}{__("Download File")}{/if}</span>
      {if $_file['type'] || $_file['size_formatted']}
        <span class="mt-0.5 block truncate text-xs text-base-content/55" title="{if $_file['type']}{$_file['type']}{/if}{if $_file['type'] && $_file['size_formatted']} · {/if}{if $_file['size_formatted']}{$_file['size_formatted']}{/if}">{if $_file['type']}{$_file['type']}{/if}{if $_file['type'] && $_file['size_formatted']} · {/if}{if $_file['size_formatted']}{$_file['size_formatted']}{/if}</span>
      {/if}
    </span>
    {$_action}
  </div>
{else}
  <a class="flex w-full items-center gap-3 rounded-2xl border border-base-300 bg-base-100 p-2 text-base-content! transition-colors hover:bg-base-200" href="{$_href}" target="_blank"{if $_file['name']} download="{$_file['name']}"{else} download{/if}>
    <span class="flex size-10 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary" aria-hidden="true">
      {if $_file['type']}
        <span class="text-xs font-semibold">{$_file['type']}</span>
      {else}
        <span class="icon-[tabler--file] size-5"></span>
      {/if}
    </span>
    <span class="min-w-0 grow">
      <span class="block truncate text-sm font-semibold" title="{if $_file['name']}{$_file['name']}{else}{__("Download File")}{/if}">{if $_file['name']}{$_file['name']}{else}{__("Download File")}{/if}</span>
      {if $_file['type'] || $_file['size_formatted']}
        <span class="mt-0.5 block truncate text-xs text-base-content/55" title="{if $_file['type']}{$_file['type']}{/if}{if $_file['type'] && $_file['size_formatted']} · {/if}{if $_file['size_formatted']}{$_file['size_formatted']}{/if}">{if $_file['type']}{$_file['type']}{/if}{if $_file['type'] && $_file['size_formatted']} · {/if}{if $_file['size_formatted']}{$_file['size_formatted']}{/if}</span>
      {/if}
    </span>
  </a>
{/if}
