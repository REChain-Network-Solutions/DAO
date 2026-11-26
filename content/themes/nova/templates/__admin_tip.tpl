<span class="dropdown relative inline-flex align-middle [--placement:bottom-start] [--auto-close:inside] [--mega-menu:true]">
  <button id="{$_tip_id}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-xs" aria-haspopup="dialog" aria-expanded="false" aria-label="{__("More information")}">
    <span class="icon-[tabler--info-circle] size-4.5" aria-hidden="true"></span>
  </button>
  <span class="dropdown-menu dropdown-open:opacity-100 z-50 hidden rounded-none bg-transparent p-0 pe-4 shadow-none" role="dialog" aria-labelledby="{$_tip_id}">
    <span class="block w-72 max-w-[calc(100vw-2rem)] rounded-box border border-base-300 bg-base-100 p-4 text-start text-sm font-normal leading-relaxed tracking-normal text-wrap whitespace-normal text-base-content/80 shadow-lg">{$_tip_text}</span>
  </span>
</span>
