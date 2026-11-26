<!-- photo layout -->
<div class="js_publisher-photo-layout mx-4 mb-3 hidden sm:mx-5" data-presets="{$photo_layout_presets_json|escape:'html'}">
  <div class="js_photo-layout-toolbar mb-3 flex items-center justify-between gap-3">
    <span class="text-sm font-semibold">{__("Photo layout")}</span>
    <div class="dropdown relative inline-flex [--placement:bottom-end] [--strategy:fixed]">
      <button type="button" class="dropdown-toggle heroui button button--tertiary button--sm gap-2" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Photo layout")}">
        <span class="js_photo-layout-icon icon-[tabler--layout-sidebar] size-4" aria-hidden="true"></span>
        <span class="js_photo-layout-label">{__("Classic")}</span>
        <span class="icon-[tabler--chevron-down] size-4" aria-hidden="true"></span>
      </button>
      <div class="dropdown-menu dropdown-open:opacity-100 hidden z-80 min-w-48" role="menu" aria-label="{__("Photo layout")}">
        {foreach ['classic' => ['label' => __('Classic'), 'icon' => 'icon-[tabler--layout-sidebar]'], 'columns' => ['label' => __('Columns'), 'icon' => 'icon-[tabler--columns-3]'], 'frame' => ['label' => __('Frame'), 'icon' => 'icon-[tabler--layout-bottombar]']] as $layout_id => $layout}
          <button type="button" class="js_photo-layout-option dropdown-item flex items-center gap-3" data-layout="{$layout_id}" data-icon="{$layout['icon']}" role="menuitemradio" aria-checked="{if $layout_id == 'classic'}true{else}false{/if}">
            <span class="{$layout['icon']} size-5" aria-hidden="true"></span>
            <span class="js_photo-layout-name flex-1">{$layout['label']}</span>
            <span class="js_photo-layout-check icon-[tabler--check] size-4 text-primary {if $layout_id != 'classic'}invisible{/if}" aria-hidden="true"></span>
          </button>
        {/foreach}
      </div>
    </div>
  </div>
  <div class="js_photo-layout-preview overflow-hidden rounded-box bg-base-200" role="img" aria-label="{__("Photo preview")}"></div>
  <p class="js_photo-layout-help mt-3 text-xs text-base-content/60">{__("Drag photos to reorder. The first photo is featured.")}</p>
  <span class="js_photo-order-status sr-only" role="status" data-message="{__("Photo moved to position %s")}"></span>
</div>
<!-- photo layout -->
