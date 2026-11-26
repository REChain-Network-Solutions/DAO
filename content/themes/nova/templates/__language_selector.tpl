<!-- language -->
<div class="dropdown relative inline-flex [--offset:8] [--placement:top-start] [--strategy:absolute]">
  <button type="button" class="dropdown-toggle inline-flex min-h-7 cursor-pointer items-center justify-center gap-2 rounded-field border-0 px-2 py-0 text-inherit leading-tight {if $_overlay}bg-white/15 backdrop-blur-sm hover:bg-white/25{else}bg-base-200 hover:bg-base-300 hover:text-inherit{/if}" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Language")}">
    <img class="size-5 shrink-0 rounded-field object-cover" width="20" height="20" src="{$system['language']['flag']}" alt="">
    <span>{$system['language']['title']}</span>
  </button>
  <ul class="dropdown-menu dropdown-open:opacity-100 hidden left-0 top-0 max-h-[22rem] w-64 overflow-y-auto rounded-box border border-base-300 bg-base-100 p-1 shadow-[0_8px_24px_rgb(0_0_0/0.08),0_1px_2px_rgb(0_0_0/0.04)]" role="menu">
    {foreach $system['languages'] as $language}
      <li>
        <a class="dropdown-item min-h-[2.125rem] gap-2 rounded-field px-2.5 py-[7px] text-[0.8125rem] leading-snug font-normal text-base-content! hover:bg-base-200 focus-visible:bg-base-200" href="?lang={$language['code']}"{if $system['language']['code'] == $language['code']} aria-current="true"{/if}>
          <img class="size-[1.125rem] shrink-0 rounded-field object-cover" width="18" height="18" src="{$language['flag']}" alt="">
          <span class="min-w-0 flex-1 truncate" title="{$language['title']}">{$language['title']}</span>
          {if $system['language']['code'] == $language['code']}
            <span class="icon-[tabler--check] ms-auto size-4 shrink-0 opacity-55" aria-hidden="true"></span>
          {/if}
        </a>
      </li>
    {/foreach}
  </ul>
</div>
<!-- language -->
