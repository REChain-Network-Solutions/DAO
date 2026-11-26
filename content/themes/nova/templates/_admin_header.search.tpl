<div id="admin-palette" class="overlay admin-palette hidden [--body-scroll:false] [--overlay-backdrop:false]"
     role="dialog" aria-modal="true" aria-label="{__("Search")}" tabindex="-1"
     data-label-recent="{__("Recent Searches")}" data-label-empty="{__("No results found")}" data-label-settings="{__("Settings")}" data-label-remove="{__("Remove from recent")}" data-label-clear-all="{__("Clear All")}">
  <div class="admin-palette-dialog js_admin-palette-dialog">

    <!-- search -->
    <div class="admin-palette-search">
      <span class="icon-[tabler--search] admin-palette-search-icon size-5 shrink-0" aria-hidden="true"></span>
      <input type="text" id="admin-palette-input" class="admin-palette-input" autocomplete="off" autofocus
             role="combobox" aria-expanded="true" aria-controls="admin-palette-results"
             aria-autocomplete="list" placeholder="{__("Search or type a command")}">
      <button type="button" class="admin-palette-clear js_admin-palette-clear" aria-label="{__("Clear")}" hidden>
        <span class="icon-[tabler--circle-x] size-5" aria-hidden="true"></span>
      </button>
    </div>
    <!-- search -->

    <!-- results -->
    <div id="admin-palette-results" class="admin-palette-results" role="listbox" aria-label="{__("Search")}"></div>
    <!-- results -->

    <!-- hints -->
    <div class="admin-palette-footer max-sm:hidden!">
      <span class="admin-palette-hint"><kbd class="kbd kbd-sm">esc</kbd>{__("To close")}</span>
      <span class="admin-palette-hint-group">
        <span class="admin-palette-hint">
          <kbd class="kbd kbd-sm"><span class="icon-[tabler--corner-down-left] size-3" aria-hidden="true"></span></kbd>
          {__("To select")}
        </span>
        <span class="admin-palette-hint">
          <kbd class="kbd kbd-sm"><span class="icon-[tabler--arrow-up] size-3" aria-hidden="true"></span></kbd>
          <kbd class="kbd kbd-sm"><span class="icon-[tabler--arrow-down] size-3" aria-hidden="true"></span></kbd>
          {__("To navigate")}
        </span>
      </span>
    </div>
    <!-- hints -->

  </div>
</div>
