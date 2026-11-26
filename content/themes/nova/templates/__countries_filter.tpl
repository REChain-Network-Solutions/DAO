<!-- countries -->
<div class="dropdown relative inline-flex shrink-0 [--offset:8] [--placement:bottom-end]">
  <button type="button" class="dropdown-toggle inline-flex h-8 items-center gap-1.5 rounded-field bg-base-100 px-2.5 transition-colors hover:bg-base-300" title="{if $selected_country}{$selected_country['country_name_with_flag']}{else}{__("All Countries")}{/if}" aria-label="{if $selected_country}{$selected_country['country_name_with_flag']}{else}{__("All Countries")}{/if}" aria-haspopup="menu" aria-expanded="false">
    {if $selected_country && $selected_country['country_flag']}
      <span class="text-base leading-none" aria-hidden="true">{$selected_country['country_flag']}</span>
    {else}
      <span class="icon-[tabler--world] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
    {/if}
    <span class="icon-[tabler--chevron-down] size-3.5 shrink-0 text-base-content/50" aria-hidden="true"></span>
  </button>
  <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 min-w-60 overflow-y-auto p-1" role="menu">
    <a class="dropdown-item{if !$selected_country} dropdown-active{else} text-inherit!{/if}" href="?country=all">
      <span class="icon-[tabler--world] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
      <span class="min-w-0 grow truncate" title="{__("All Countries")}">{__("All Countries")}</span>
      {if !$selected_country}
        <span class="icon-[tabler--check] size-4 shrink-0" aria-hidden="true"></span>
      {/if}
    </a>
    <div class="my-1 border-t border-base-300" role="separator"></div>
    {foreach $countries as $country}
      {$_country_active = ($selected_country && $selected_country['country_id'] == $country['country_id'])}
      <a class="dropdown-item{if $_country_active} dropdown-active{else} text-inherit!{/if}" href="?country={$country['country_name_native']}">
        <span class="min-w-0 grow truncate" title="{$country['country_name_with_flag']}">{$country['country_name_with_flag']}</span>
        {if $_country_active}
          <span class="icon-[tabler--check] size-4 shrink-0" aria-hidden="true"></span>
        {/if}
      </a>
    {/foreach}
  </div>
</div>
<!-- countries -->
