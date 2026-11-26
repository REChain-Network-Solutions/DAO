<!-- panel nav -->
<div class="tabs tabs--secondary w-full" data-orientation="horizontal">
  <div class="tabs__list-container w-full overflow-x-auto [scrollbar-width:none]! [&::-webkit-scrollbar]:hidden!">
    <div class="tabs__list gap-1" role="tablist" data-orientation="horizontal">
      <a class="tabs__tab js_modal h-10 w-auto shrink-0 gap-1.5 px-3 font-semibold" href="#" role="tab" data-url="live/moderate.php?do=settings&host_type={$host_type}&host_id={$host_id}" {if $_tab == "settings"}data-selected="true" aria-selected="true"{/if}>
        {__("Settings")}
        {if $_tab == "settings"}<span class="tabs__indicator"></span>{/if}
      </a>
      <a class="tabs__tab js_modal h-10 w-auto shrink-0 gap-1.5 px-3 font-semibold" href="#" role="tab" data-url="live/moderate.php?do=restrictions&host_type={$host_type}&host_id={$host_id}" {if $_tab == "restrictions"}data-selected="true" aria-selected="true"{/if}>
        {__("Restricted Users")}
        {if $_tab == "restrictions"}<span class="tabs__indicator"></span>{/if}
      </a>
      <a class="tabs__tab js_modal h-10 w-auto shrink-0 gap-1.5 px-3 font-semibold" href="#" role="tab" data-url="live/moderate.php?do=moderators&host_type={$host_type}&host_id={$host_id}" {if $_tab == "moderators"}data-selected="true" aria-selected="true"{/if}>
        {__("Moderators")}
        {if $_tab == "moderators"}<span class="tabs__indicator"></span>{/if}
      </a>
      <a class="tabs__tab js_modal h-10 w-auto shrink-0 gap-1.5 px-3 font-semibold" href="#" role="tab" data-url="live/moderate.php?do=log&host_type={$host_type}&host_id={$host_id}" {if $_tab == "log"}data-selected="true" aria-selected="true"{/if}>
        {__("Log")}
        {if $_tab == "log"}<span class="tabs__indicator"></span>{/if}
      </a>
    </div>
  </div>
</div>
<!-- panel nav -->
