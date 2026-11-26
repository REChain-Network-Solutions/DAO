<!-- no data -->
<div class="flex flex-col items-center justify-center text-center {if $_empty_mini}px-4 py-3{elseif $_empty_menu}h-full px-4 py-5{elseif $_empty_compact}px-4 py-8{else}px-6 py-14{/if}">
  <div class="relative flex items-center justify-center {if $_empty_mini}size-12{elseif $_empty_menu}size-16{elseif $_empty_compact}size-20{else}size-28{/if}" aria-hidden="true">
    <span class="absolute inset-0 rounded-full bg-primary/5"></span>
    <span class="absolute rounded-full bg-primary/10 {if $_empty_mini}inset-1.5{elseif $_empty_menu}inset-2.5{elseif $_empty_compact}inset-3{else}inset-4{/if}"></span>
    <span class="relative flex items-center justify-center rounded-box bg-base-100 text-primary shadow-sm ring-1 ring-primary/15 {if $_empty_mini}size-8{elseif $_empty_menu}size-10{elseif $_empty_compact}size-11{else}size-14{/if}">
      <span class="{if $_empty_icon}{$_empty_icon}{else}icon-[tabler--inbox]{/if} {if $_empty_mini}size-4{elseif $_empty_menu}size-4.5{elseif $_empty_compact}size-5{else}size-7{/if}"></span>
    </span>
  </div>
  <h3 class="no-data {if $_empty_mini}mt-2 text-xs font-normal text-base-content/55{elseif $_empty_menu}mt-3 text-sm font-semibold{elseif $_empty_compact}mt-4 text-sm font-semibold sm:text-base{else}mt-5 text-sm font-semibold sm:text-base{/if}">{if $_empty_title}{$_empty_title}{else}{__("No data to show")}{/if}</h3>
  {if $_empty_text}
    <p class="max-w-sm text-base-content/60 {if $_empty_mini}mt-0.5 text-[11px]{elseif $_empty_menu}mt-1 text-xs{elseif $_empty_compact}mt-1 text-xs sm:text-sm{else}mt-1.5 text-xs sm:text-sm{/if}">{$_empty_text}</p>
  {/if}
</div>
<!-- no data -->
