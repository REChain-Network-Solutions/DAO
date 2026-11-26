<div id="site-palette" class="overlay modal overlay-open:opacity-100 overlay-open:duration-300 hidden" role="dialog" tabindex="-1" aria-modal="true" aria-label="{__("Search")}" data-logged-in="{if $user->_logged_in}1{/if}" data-label-all="{__("See All Results")}" data-label-advanced="{__("Advanced Search")}" data-label-search-for="{__("Search for")}" data-label-recent="{__("Recent Searches")}" data-label-empty="{__("No results found")}" data-label-settings="{__("Settings")}" data-label-commands="{__("Commands")}" data-label-remove="{__("Remove from recent")}" data-label-clear-all="{__("Clear All")}" data-label-clear="{__("Clear")}">
  <div class="modal-dialog">
    <div class="modal-content js_site-palette-dialog overflow-hidden">

      <!-- search -->
      <div class="modal-header block">
        <div class="relative">
          <div class="input items-center gap-2 ps-8 pe-10 rounded-2xl! corner-squircle supports-[corner-shape:squircle]:rounded-[2rem]!">
            <span class="icon-[tabler--search] text-base-content/50 pointer-events-none absolute start-3 top-1/2 size-4 shrink-0 -translate-y-1/2" aria-hidden="true"></span>
            <span class="js_site-palette-chip badge badge-soft badge-sm hidden max-w-40 shrink-0 gap-1 rounded-full font-mono" hidden>
              <span data-chip-label dir="ltr">/settings</span>
              <button type="button" class="js_site-palette-chip-remove inline-flex size-3.5 items-center justify-center rounded-full text-base-content/50 hover:bg-base-content/10 hover:text-base-content" aria-label="{__("Clear")}">
                <span class="icon-[tabler--x] size-3" aria-hidden="true"></span>
              </button>
            </span>
            <input class="min-w-0 grow border-0 bg-transparent p-0 shadow-none outline-none focus:outline-none" type="text" id="site-palette-input" placeholder="{__("Search or type a command")}" role="combobox" aria-expanded="true" aria-controls="site-palette-results" aria-autocomplete="list" value="" autofocus autocomplete="off">
          </div>
          <button type="button" class="js_site-palette-clear absolute end-2 top-1/2 inline-flex -translate-y-1/2 text-base-content/45 hover:text-base-content" aria-label="{__("Clear")}" hidden>
            <span class="icon-[tabler--circle-x] size-5" aria-hidden="true"></span>
          </button>
        </div>
      </div>
      <!-- search -->

      <!-- results -->
      <div id="site-palette-results" class="modal-body mt-0 max-h-72 overflow-y-auto p-1.5" role="listbox" aria-label="{__("Search")}"></div>
      <!-- results -->

      <!-- hints -->
      <div class="hidden items-center justify-between gap-3 border-t border-base-300 px-4 py-2.5 text-xs text-base-content/50 sm:flex">
        <span class="inline-flex items-center gap-1.5"><kbd class="kbd kbd-sm">esc</kbd>{__("To close")}</span>
        <span class="hidden items-center gap-4 sm:inline-flex">
          {if $user->_logged_in}
            <span class="inline-flex items-center gap-1.5">
              <kbd class="kbd kbd-sm">/</kbd>
              {__("Settings")}
            </span>
          {/if}
          <span class="inline-flex items-center gap-1.5">
            <kbd class="kbd kbd-sm"><span class="icon-[tabler--corner-down-left] size-3" aria-hidden="true"></span></kbd>
            {__("To select")}
          </span>
          <span class="inline-flex items-center gap-1.5">
            <kbd class="kbd kbd-sm"><span class="icon-[tabler--arrow-up] size-3" aria-hidden="true"></span></kbd>
            <kbd class="kbd kbd-sm"><span class="icon-[tabler--arrow-down] size-3" aria-hidden="true"></span></kbd>
            {__("To navigate")}
          </span>
        </span>
      </div>
      <!-- hints -->

    </div>
  </div>

  {if $user->_logged_in && $user->_data['search_log']}
    <div id="site-palette-recents-data" hidden>
      {foreach $user->_data['search_log'] as $result}
        {include file='__search_combo_item.tpl' result=$result _source=true}
      {/foreach}
    </div>
  {/if}

  <template id="site-palette-item-tpl">
    <a class="js_site-palette-item dropdown-item hover:bg-base-content/5" href="#">
      <span data-icon class="icon-[tabler--settings] size-4 shrink-0 text-base-content/70" aria-hidden="true"></span>
      <img data-picture class="hidden size-5 shrink-0 rounded-full object-cover" alt="">
      <span data-label class="js_site-palette-label min-w-0 grow truncate text-sm text-base-content"></span>
      <span data-crumb class="hidden shrink-0 text-xs text-base-content/45"></span>
      <span data-badge dir="ltr" class="badge badge-soft badge-sm hidden shrink-0 rounded-full font-mono"></span>
    </a>
  </template>
  <template id="site-palette-search-tpl">
    <a class="js_site-palette-item dropdown-item hover:bg-base-content/5" href="#">
      <span class="icon-[tabler--search] size-4 shrink-0 text-base-content/80" aria-hidden="true"></span>
      <span data-label class="js_site-palette-label min-w-0 grow truncate text-sm text-base-content"></span>
    </a>
  </template>
  <template id="site-palette-recent-tpl">
    <div class="group relative">
      <a class="js_site-palette-item dropdown-item pe-9 hover:bg-base-content/5" href="#" data-recent="1">
        <img data-picture class="size-5 shrink-0 rounded-full object-cover" alt="">
        <span data-label class="js_site-palette-label min-w-0 grow truncate text-sm text-base-content"></span>
      </a>
      <button type="button" class="js_site-palette-remove absolute end-1.5 top-1/2 flex size-6 -translate-y-1/2 items-center justify-center rounded-full text-base-content/45 opacity-0 hover:bg-base-content/10 hover:text-base-content group-hover:opacity-100 group-has-[.dropdown-active]:opacity-100 [@media(hover:none)]:opacity-100" tabindex="-1">
        <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
      </button>
    </div>
  </template>
  <template id="site-palette-heading-tpl">
    <div class="flex items-center justify-between gap-2 px-2.5 py-1.5 text-xs font-medium text-base-content/50" role="presentation">
      <span data-title></span>
      <button type="button" class="js_site-palette-clear-all hidden text-xs font-medium text-base-content/50 hover:text-base-content" data-clear></button>
    </div>
  </template>
  <template id="site-palette-empty-tpl">
    <p class="px-3 py-7 text-center text-sm text-base-content/50"></p>
  </template>
  <span class="hidden rounded-xl bg-base-content/5 bg-warning/30 transition-colors duration-500" aria-hidden="true"></span>
</div>