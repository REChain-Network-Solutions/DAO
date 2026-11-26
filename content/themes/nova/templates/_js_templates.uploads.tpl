<!-- attachment upload -->
<script id="attachment-upload-item" type="text/template">
  <li class="item js_upload-item relative min-w-0 overflow-hidden rounded-box border border-base-300 bg-base-100 {literal}{{#compact}}w-56 max-w-full{{/compact}}{/literal}" data-upload-id="{literal}{{id}}{/literal}" data-src="{literal}{{id}}{/literal}"{literal}{{#document}} data-document="true"{{/document}}{/literal}>
    <div class="js_upload-media relative overflow-hidden bg-base-200 {literal}{{#image}}aspect-square{{/image}}{{#video}}aspect-video{{/video}}{{#document}}h-20{{/document}}{/literal}">
      <div class="js_upload-fallback absolute inset-0 flex items-center justify-center text-base-content/40"><span class="{literal}{{icon}}{/literal} size-9" aria-hidden="true"></span></div>
      {literal}{{#reorder}}{/literal}
        <span class="js_photo-drag absolute start-1.5 top-1.5 z-10 flex size-8 touch-none cursor-grab items-center justify-center rounded-full bg-base-100/90 text-base-content shadow-sm active:cursor-grabbing" aria-hidden="true"><span class="icon-[tabler--grip-vertical] size-4"></span></span>
        <span class="js_photo-position absolute bottom-1.5 start-1.5 rounded-full bg-black/60 px-2 py-0.5 text-xs text-white"></span>
        <span class="js_photo-featured absolute bottom-1.5 end-1.5 rounded-full bg-primary px-2 py-0.5 text-xs text-primary-content">{__("Featured")}</span>
      {literal}{{/reorder}}{/literal}
    </div>
    <button type="button" class="js_upload-remove heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full absolute! end-1.5! top-1.5! z-10 border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100" title='{__("Remove")}' aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
    <div class="space-y-2 p-2.5">
      <div class="truncate text-xs font-medium" title="{literal}{{name}}{/literal}">{literal}{{name}}{/literal}</div>
      <div class="text-xs text-base-content/55">{literal}{{size}}{/literal}</div>
      <div class="flex items-center gap-1.5 text-xs">
        <span class="js_upload-spinner loading loading-spinner loading-xs hidden motion-reduce:animate-none" aria-hidden="true"></span>
        <span class="js_upload-state min-w-0 flex-1" role="status"></span>
        <span class="js_upload-percent tabular-nums" aria-hidden="true">0%</span>
      </div>
      <div class="js_upload-progress progress h-1.5 bg-base-300" role="progressbar" aria-label='{__("Upload progress")}' aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
        <div class="js_upload-bar progress-bar progress-primary transition-[width] duration-150 motion-reduce:transition-none" style="width: 0%"></div>
      </div>
      <p class="js_upload-error hidden text-xs wrap-anywhere text-error" role="alert"></p>
      <button type="button" class="js_upload-retry heroui button button--tertiary button--sm static! hidden w-full">{__("Retry")}</button>
    </div>
    {literal}{{#reorder}}{/literal}
      <div class="flex items-center justify-center gap-1 border-t border-base-300 p-1">
        <button type="button" class="js_photo-move heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full static!" data-direction="earlier" title='{__("Move earlier")}' aria-label='{__("Move earlier")}'><span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span></button>
        <button type="button" class="js_photo-move heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full static!" data-direction="first" title='{__("Make first")}' aria-label='{__("Make first")}'><span class="icon-[tabler--star] size-4" aria-hidden="true"></span></button>
        <button type="button" class="js_photo-move heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full static!" data-direction="later" title='{__("Move later")}' aria-label='{__("Move later")}'><span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span></button>
      </div>
    {literal}{{/reorder}}{/literal}
  </li>
</script>
<!-- attachment upload -->

<!-- attachment gif -->
<script id="attachment-gif-item" type="text/template">
  <li class="item relative w-36! min-w-0 overflow-hidden rounded-box border border-base-300 bg-base-200" data-gif-item>
    <img class="block max-h-36 w-full object-cover" src="{literal}{{src}}{/literal}" alt="GIF">
    <button type="button" class="js_gif-remove heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full absolute! end-1.5! top-1.5! z-10 border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100" title='{__("Remove")}' aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
    <span class="absolute bottom-1.5 start-1.5 rounded-full bg-black/60 px-2 py-0.5 text-[10px] font-semibold text-white">GIF</span>
  </li>
</script>
<!-- attachment gif -->
