<!-- Stories -->
<script id="story-viewer" type="text/template">
  <div class="heroui js_story-viewer group/story fixed inset-0 z-[1080] flex items-center justify-center bg-neutral-950 text-white sm:bg-neutral-950/95 sm:backdrop-blur-sm" role="dialog" aria-modal="true" aria-label='{__("Stories")}' data-loading="true" data-paused="false" data-held="false" data-muted="false" data-video="false" data-sound="false" data-owner="false" data-manage="false" data-reply="false" data-react="true" data-highlightable="false" data-repost="false" data-sheet="false" data-fonts="{$system['system_theme_fonts']}">

    <button type="button" class="js_story-user-prev absolute start-4 top-1/2 z-10 hidden size-11 -translate-y-1/2 items-center justify-center rounded-full bg-white/10 text-white backdrop-blur-md transition hover:bg-white/20 active:scale-95 disabled:pointer-events-none disabled:opacity-0 lg:flex" aria-label='{__("Previous")}'>
      <span class="icon-[tabler--chevron-left] size-6 rtl:rotate-180" aria-hidden="true"></span>
    </button>
    <button type="button" class="js_story-user-next absolute end-4 top-1/2 z-10 hidden size-11 -translate-y-1/2 items-center justify-center rounded-full bg-white/10 text-white backdrop-blur-md transition hover:bg-white/20 active:scale-95 disabled:pointer-events-none disabled:opacity-0 lg:flex" aria-label='{__("Next")}'>
      <span class="icon-[tabler--chevron-right] size-6 rtl:rotate-180" aria-hidden="true"></span>
    </button>

    <div class="js_story-stage relative isolate [container-type:size] h-full w-full overflow-hidden bg-black transition duration-300 ease-out select-none starting:scale-95 starting:opacity-0 sm:h-[min(calc(100dvh-2rem),56rem)] sm:w-[calc(min(100dvh-2rem,56rem)*9/16)] sm:rounded-3xl sm:shadow-2xl">

      <!-- media -->
      <img class="js_story-ambient pointer-events-none absolute inset-0 -z-10 size-full scale-110 object-cover opacity-50 blur-3xl" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" alt="" aria-hidden="true">
      <div class="js_story-backdrop absolute inset-0 -z-10"></div>
      <div class="absolute inset-0 flex items-center justify-center">
        <div class="js_story-media relative flex aspect-[9/16] w-[min(100cqw,calc(100cqh*9/16))] items-center justify-center overflow-hidden [&>*]:max-h-full [&>*]:max-w-full [&>*]:object-contain"></div>
      </div>
      <div class="js_story-surface absolute inset-0 touch-none"></div>
      <div class="pointer-events-none absolute inset-0 flex items-center justify-center">
        <div class="@container relative aspect-[9/16] w-[min(100cqw,calc(100cqh*9/16))] overflow-hidden">
          <img class="js_story-drawing absolute inset-0 hidden size-full" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" alt="" aria-hidden="true">
          <div class="js_story-layers absolute inset-0"></div>
        </div>
      </div>
      <!-- media -->

      <!-- loader -->
      <div class="pointer-events-none absolute inset-0 hidden items-center justify-center group-data-[loading=true]/story:flex">
        <span class="loading loading-spinner loading-lg text-white"></span>
      </div>
      <!-- loader -->

      <!-- header -->
      <div class="pointer-events-none absolute inset-x-0 top-0 z-10 bg-linear-to-b from-black/60 to-transparent px-3 pt-[calc(0.75rem+env(safe-area-inset-top))] pb-10 transition-opacity duration-200 group-data-[held=true]/story:opacity-0">
        <div class="js_story-progress flex gap-1"></div>
        <div class="mt-3 flex items-center gap-2.5">
          <a class="js_story-user-link pointer-events-auto shrink-0" href="#">
            <img class="js_story-user-picture size-9 rounded-full object-cover ring-2 ring-white/30" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" alt="">
          </a>
          <div class="min-w-0 flex-1">
            <a class="js_story-user-link js_story-user-name pointer-events-auto block truncate text-sm font-semibold text-white! drop-shadow-sm" href="#"></a>
            <span class="js_story-time block truncate text-xs text-white/75"></span>
            <a class="js_story-music pointer-events-auto mt-0.5 hidden max-w-full items-center gap-1 text-xs font-medium text-white! drop-shadow-sm [&:not(.hidden)]:inline-flex" target="_blank" rel="noopener nofollow">
              <span class="icon-[tabler--music] size-3.5 shrink-0" aria-hidden="true"></span>
              <span class="truncate"></span>
            </a>
          </div>
          <div class="pointer-events-auto flex shrink-0 items-center gap-0.5">
            <button type="button" class="js_story-mute hidden size-9 items-center justify-center rounded-full text-white transition hover:bg-white/15 group-data-[sound=true]/story:flex" aria-label='{__("Sound")}'>
              <span class="icon-[tabler--volume] size-5 group-data-[muted=true]/story:hidden" aria-hidden="true"></span>
              <span class="icon-[tabler--volume-off] hidden size-5 group-data-[muted=true]/story:block" aria-hidden="true"></span>
            </button>
            <button type="button" class="js_story-toggle flex size-9 items-center justify-center rounded-full text-white transition hover:bg-white/15" aria-label='{__("Pause")}'>
              <span class="icon-[tabler--player-pause-filled] size-5 group-data-[paused=true]/story:hidden" aria-hidden="true"></span>
              <span class="icon-[tabler--player-play-filled] hidden size-5 group-data-[paused=true]/story:block" aria-hidden="true"></span>
            </button>
            <button type="button" class="js_story-report js_modal hidden size-9 items-center justify-center rounded-full text-white transition hover:bg-white/15 group-data-[owner=false]/story:flex" title='{__("Report")}' aria-label='{__("Report")}'>
              <span class="icon-[tabler--flag] size-5" aria-hidden="true"></span>
            </button>
            <button type="button" class="js_story-repost hidden size-9 items-center justify-center rounded-full text-white transition hover:bg-white/15 disabled:opacity-50 group-data-[repost=true]/story:flex" title='{__("Repost")}' aria-label='{__("Repost")}'>
              <span class="icon-[tabler--repeat] size-5" aria-hidden="true"></span>
            </button>
            <button type="button" class="js_story-highlight js_modal hidden size-9 items-center justify-center rounded-full text-white transition hover:bg-white/15 group-data-[highlightable=true]/story:flex" title='{__("Add to Highlight")}' aria-label='{__("Add to Highlight")}'>
              <span class="icon-[tabler--star] size-5" aria-hidden="true"></span>
            </button>
            <button type="button" class="js_story-delete hidden size-9 items-center justify-center rounded-full text-white transition hover:bg-white/15 group-data-[manage=true]/story:flex" title='{__("Delete")}' aria-label='{__("Delete")}'>
              <span class="icon-[tabler--trash] size-5" aria-hidden="true"></span>
            </button>
            <button type="button" class="js_story-close flex size-9 items-center justify-center rounded-full text-white transition hover:bg-white/15" aria-label='{__("Close")}'>
              <span class="icon-[tabler--x] size-6" aria-hidden="true"></span>
            </button>
          </div>
        </div>
      </div>
      <!-- header -->

      <!-- status -->
      <div class="pointer-events-none absolute inset-x-0 bottom-36 z-10 flex justify-center">
        <span class="js_story-status rounded-full bg-black/70 px-4 py-2 text-sm font-medium text-white opacity-0 backdrop-blur-md transition-opacity duration-300 data-[show=true]:opacity-100" role="status"></span>
      </div>
      <!-- status -->

      <!-- footer -->
      <div class="absolute inset-x-0 bottom-0 z-10 bg-linear-to-t from-black/70 to-transparent px-3 pt-12 pb-[calc(0.75rem+env(safe-area-inset-bottom))] transition-opacity duration-200 group-data-[held=true]/story:opacity-0">
        <!-- owner -->
        <div class="hidden justify-center group-data-[owner=true]/story:flex">
          <button type="button" class="js_story-viewers-open inline-flex h-11 items-center gap-2 rounded-full bg-white/15 px-5 text-sm font-semibold text-white backdrop-blur-md transition hover:bg-white/25 active:scale-95">
            <span class="icon-[tabler--eye] size-5" aria-hidden="true"></span>
            <span class="js_story-views-count tabular-nums">0</span>
            <span class="mx-0.5 h-4 w-px bg-white/30" aria-hidden="true"></span>
            <span class="icon-[tabler--heart] size-5" aria-hidden="true"></span>
            <span class="js_story-reactions-count tabular-nums">0</span>
          </button>
        </div>
        <!-- owner -->
        <!-- viewer -->
        <div class="hidden flex-col gap-2.5 group-data-[owner=false]/story:flex">
          <div class="flex items-center justify-center gap-1 group-data-[react=false]/story:hidden">
            {foreach $system['reactions_enabled'] as $reaction}
              <button type="button" class="js_story-react size-10 rounded-full p-1 transition duration-200 hover:-translate-y-1 hover:scale-125 active:scale-95 aria-pressed:bg-white/25 aria-pressed:ring-2 aria-pressed:ring-white" data-reaction="{$reaction['reaction']}" aria-pressed="false" title="{__($reaction['title'])}" aria-label="{__($reaction['title'])}">
                {include file='__reaction_emojis.tpl' _reaction=$reaction['reaction']}
              </button>
            {/foreach}
          </div>
          <form class="js_story-reply hidden items-center gap-2 group-data-[reply=true]/story:flex">
            <input type="text" class="h-11 min-w-0 flex-1 rounded-full border border-white/30 bg-white/10 px-4 text-base text-white outline-none backdrop-blur-md placeholder:text-white/75 md:text-sm focus:border-white/70" maxlength="1000" dir="auto" autocomplete="off" placeholder='{__("Send a reply")}' aria-label='{__("Send a reply")}'>
            <button type="submit" class="flex size-11 shrink-0 items-center justify-center rounded-full bg-white text-neutral-900 transition hover:bg-white/90 active:scale-95 disabled:opacity-60" aria-label='{__("Send")}'>
              <span class="icon-[tabler--send-2] size-5 rtl:-scale-x-100" aria-hidden="true"></span>
            </button>
          </form>
        </div>
        <!-- viewer -->
      </div>
      <!-- footer -->

      <!-- viewers -->
      <div class="js_story-sheet-backdrop absolute inset-0 z-20 hidden bg-black/50 group-data-[sheet=true]/story:block"></div>
      <div class="js_sheet absolute inset-x-0 bottom-0 z-30 flex h-[70%] translate-y-full flex-col rounded-t-3xl bg-base-100 sm:rounded-t-[2.5rem] pb-[env(safe-area-inset-bottom)] text-base-content transition-transform duration-300 group-data-[sheet=true]/story:translate-y-0">
        <div class="js_sheet-grab flex shrink-0 cursor-grab touch-none justify-center pt-2.5 active:cursor-grabbing">
          <span class="h-1 w-10 rounded-full bg-base-content/20"></span>
        </div>
        <div class="flex shrink-0 items-center gap-2 border-b border-base-content/10 px-5 pt-2 pb-3 sm:px-6">
          <h2 class="min-w-0 flex-1 text-base font-semibold">{__("Viewers")} <span class="js_story-sheet-count text-base-content/55"></span></h2>
          <button type="button" class="js_story-sheet-close heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full" aria-label='{__("Close")}'>
            <span class="icon-[tabler--x] size-5" aria-hidden="true"></span>
          </button>
        </div>
        <div class="min-h-0 flex-1 overflow-y-auto overscroll-contain p-2">
          <ul class="js_story-sheet-list flex flex-col"></ul>
          <div class="js_story-sheet-empty hidden flex-col items-center gap-2 px-6 py-10 text-center text-sm text-base-content/60">
            <span class="icon-[tabler--eye-off] size-8" aria-hidden="true"></span>
            {__("No one has viewed this story yet")}
          </div>
          <div class="js_story-sheet-loader flex justify-center py-4"><span class="loading loading-spinner"></span></div>
          <div class="hidden justify-center py-2 [&:not(.hidden)]:flex">
            <button type="button" class="js_story-sheet-more heroui button button--tertiary button--sm">{__("See More")}</button>
          </div>
        </div>
      </div>
      <!-- viewers -->

    </div>
  </div>
</script>
<script id="story-composer" type="text/template">
  <div class="heroui js_composer group/composer fixed inset-0 z-[1080] flex items-center justify-center bg-neutral-950 text-white sm:bg-neutral-950/95 sm:backdrop-blur-sm" role="dialog" aria-modal="true" aria-label='{__("Create story")}' data-step="start" data-type="" data-panel="" data-chrome="true" data-busy="false" data-dragging="false" data-admin="false" data-videos="false" data-music="false" data-library="false" data-friends="false" data-filter-sample="{$system['system_url']}/content/themes/{$system['theme']}/images/stories/filter.jpg" data-muted="false" data-ads="false" data-text="true" data-polls="true" data-fonts="{$system['system_theme_fonts']}">
    <div class="js_composer-stage relative isolate h-full w-full overflow-hidden bg-neutral-900 transition duration-300 ease-out select-none [container-type:size] starting:scale-95 starting:opacity-0 sm:h-[min(calc(100dvh-2rem),56rem)] sm:w-[calc(min(100dvh-2rem,56rem)*9/16)] sm:rounded-3xl sm:shadow-2xl">

      <!-- start -->
      <div class="absolute inset-0 z-40 hidden flex-col bg-base-100 text-base-content group-data-[step=start]/composer:flex">
        <div class="flex items-center gap-3 px-5 pt-[calc(1.25rem+env(safe-area-inset-top))]">
          <h2 class="min-w-0 flex-1 text-xl font-bold">{__("Create story")}</h2>
          {include file='__close_button.tpl' extra_class="static js_composer-close" no_overlay=true}
        </div>
        <div class="flex min-h-0 flex-1 flex-col justify-center gap-4 p-5">
          <button type="button" class="js_composer-pick group/card flex items-center gap-4 rounded-3xl border border-base-content/10 bg-base-100 p-5 text-start transition hover:border-primary/40 hover:bg-primary/5 active:scale-[0.99]">
            <span class="flex size-14 shrink-0 items-center justify-center rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.25rem] bg-linear-to-br from-violet-500 to-fuchsia-500 text-white shadow-lg shadow-fuchsia-500/25 transition group-hover/card:scale-105">
              <span class="icon-[tabler--photo-video] size-7" aria-hidden="true"></span>
            </span>
            <span class="min-w-0 flex-1">
              <span class="hidden text-base font-semibold group-data-[videos=true]/composer:block">{__("Photo or video")}</span>
              <span class="block text-base font-semibold group-data-[videos=true]/composer:hidden">{__("Photo")}</span>
              <span class="block text-sm text-base-content/60">{__("Upload from your device")}</span>
            </span>
            <span class="icon-[tabler--chevron-right] size-5 shrink-0 text-base-content/40 rtl:rotate-180" aria-hidden="true"></span>
          </button>
          <button type="button" class="js_composer-text-story group/card flex items-center group-data-[text=false]/composer:hidden gap-4 rounded-3xl border border-base-content/10 bg-base-100 p-5 text-start transition hover:border-primary/40 hover:bg-primary/5 active:scale-[0.99]">
            <span class="flex size-14 shrink-0 items-center justify-center rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.25rem] bg-linear-to-br from-sky-500 to-indigo-600 text-white shadow-lg shadow-indigo-500/25 transition group-hover/card:scale-105">
              <span class="icon-[tabler--typography] size-7" aria-hidden="true"></span>
            </span>
            <span class="min-w-0 flex-1">
              <span class="block text-base font-semibold">{__("Text story")}</span>
              <span class="block text-sm text-base-content/60">{__("Colours, fonts and stickers")}</span>
            </span>
            <span class="icon-[tabler--chevron-right] size-5 shrink-0 text-base-content/40 rtl:rotate-180" aria-hidden="true"></span>
          </button>
          <div class="js_composer-error alert alert-soft alert-error hidden"></div>
        </div>
        <input type="file" class="js_composer-file hidden" tabindex="-1" aria-hidden="true">
      </div>
      <!-- start -->

      <!-- story -->
      <img class="js_composer-ambient pointer-events-none absolute inset-0 -z-10 hidden size-full scale-110 object-cover opacity-50 blur-3xl" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" alt="" aria-hidden="true">
      <div class="js_composer-backdrop absolute inset-0 -z-10"></div>
      <div class="absolute inset-0 flex items-center justify-center">
        <div class="js_composer-frame @container relative aspect-[9/16] w-[min(100cqw,calc(100cqh*9/16))] overflow-hidden">
          <div class="js_composer-media absolute inset-0 flex items-center justify-center [&>*]:max-h-full [&>*]:max-w-full [&>*]:object-contain"></div>
          <canvas class="js_composer-canvas pointer-events-none absolute inset-0 size-full touch-none group-data-[panel=draw]/composer:pointer-events-auto group-data-[panel=draw]/composer:cursor-crosshair" width="720" height="1280"></canvas>
          <div class="js_composer-layers absolute inset-0 group-data-[panel=draw]/composer:pointer-events-none"></div>
          <div class="js_composer-guide-x pointer-events-none absolute inset-y-0 left-1/2 hidden w-px bg-pink-500"></div>
          <div class="js_composer-guide-y pointer-events-none absolute inset-x-0 top-1/2 hidden h-px bg-pink-500"></div>

          <!-- text -->
          <div class="js_composer-editor group/editor absolute inset-0 z-20 hidden flex-col bg-black/65 backdrop-blur-sm group-data-[panel=text]/composer:flex" data-option="">
            <div class="flex shrink-0 items-center justify-end gap-2 px-3 pt-[calc(0.75rem+env(safe-area-inset-top))]">
              <button type="button" class="js_composer-text-done h-10 rounded-full bg-white px-5 text-sm font-semibold text-neutral-900 transition hover:bg-white/90 active:scale-95">{__("Done")}</button>
            </div>
            <div class="relative flex min-h-0 flex-1 items-center justify-center px-12">
              <div class="absolute start-3 top-1/2 z-10 flex -translate-y-1/2">
                <input type="range" class="js_composer-size h-40 w-6 cursor-pointer accent-white [direction:rtl] [writing-mode:vertical-lr]" min="0.5" max="3" step="0.05" value="1" aria-label='{__("Text size")}'>
              </div>
              <div class="js_composer-input max-h-full w-full overflow-y-auto rounded-[0.35em] px-[0.5em] py-[0.2em] leading-snug break-words whitespace-pre-wrap outline-none empty:before:text-white/50 empty:before:content-[attr(data-placeholder)]" contenteditable="plaintext-only" role="textbox" aria-multiline="true" dir="auto" data-placeholder='{__("Type something")}'></div>
            </div>
            <div class="flex shrink-0 flex-col items-center gap-2.5 px-3 pb-[calc(0.75rem+env(safe-area-inset-bottom))]">
              <div class="js_composer-row hidden w-full min-w-0 items-center gap-2 group-data-[option=font]/editor:flex">
                <div class="flex gap-1 js_composer-row-strip min-w-0 flex-1 touch-pan-x overflow-x-auto overscroll-x-contain scroll-smooth [scrollbar-width:none]! [&::-webkit-scrollbar]:hidden!" role="group" aria-label='{__("Font")}'>
                  <button type="button" class="js_composer-font h-9 shrink-0 rounded-full px-4 text-sm font-semibold text-white transition aria-pressed:bg-white aria-pressed:text-neutral-900" data-font="modern" aria-pressed="false">{__("Modern")}</button>
                  <button type="button" class="js_composer-font h-9 shrink-0 rounded-full px-4 text-sm font-semibold text-white transition aria-pressed:bg-white aria-pressed:text-neutral-900" data-font="classic" aria-pressed="false">{__("Classic")}</button>
                  <button type="button" class="js_composer-font h-9 shrink-0 rounded-full px-4 text-sm font-semibold text-white transition aria-pressed:bg-white aria-pressed:text-neutral-900" data-font="signature" aria-pressed="false">{__("Signature")}</button>
                  <button type="button" class="js_composer-font h-9 shrink-0 rounded-full px-4 text-sm font-semibold text-white transition aria-pressed:bg-white aria-pressed:text-neutral-900" data-font="editorial" aria-pressed="false">{__("Editorial")}</button>
                  <button type="button" class="js_composer-font h-9 shrink-0 rounded-full px-4 text-sm font-semibold text-white transition aria-pressed:bg-white aria-pressed:text-neutral-900" data-font="typewriter" aria-pressed="false">{__("Typewriter")}</button>
                  <button type="button" class="js_composer-font h-9 shrink-0 rounded-full px-4 text-sm font-semibold text-white transition aria-pressed:bg-white aria-pressed:text-neutral-900" data-font="neon" aria-pressed="false">{__("Neon")}</button>
                </div>
                <div class="js_composer-row-nav flex shrink-0 items-center gap-1 pointer-coarse:hidden data-[scrollable=false]:hidden" data-scrollable="false">
                  <button type="button" class="js_composer-row-prev flex size-8 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Previous")}'>
                    <span class="icon-[tabler--chevron-left] size-4.5 rtl:rotate-180" aria-hidden="true"></span>
                  </button>
                  <button type="button" class="js_composer-row-next flex size-8 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Next")}'>
                    <span class="icon-[tabler--chevron-right] size-4.5 rtl:rotate-180" aria-hidden="true"></span>
                  </button>
                </div>
              </div>
              <div class="js_composer-row hidden w-full min-w-0 items-center gap-2 group-data-[option=color]/editor:flex">
                <div class="js_composer-colors flex gap-2 px-1 py-1.5 js_composer-row-strip min-w-0 flex-1 touch-pan-x overflow-x-auto overscroll-x-contain scroll-smooth [scrollbar-width:none]! [&::-webkit-scrollbar]:hidden!" role="group" aria-label='{__("Text colour")}'></div>
                <div class="js_composer-row-nav flex shrink-0 items-center gap-1 pointer-coarse:hidden data-[scrollable=false]:hidden" data-scrollable="false">
                  <button type="button" class="js_composer-row-prev flex size-8 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Previous")}'>
                    <span class="icon-[tabler--chevron-left] size-4.5 rtl:rotate-180" aria-hidden="true"></span>
                  </button>
                  <button type="button" class="js_composer-row-next flex size-8 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Next")}'>
                    <span class="icon-[tabler--chevron-right] size-4.5 rtl:rotate-180" aria-hidden="true"></span>
                  </button>
                </div>
              </div>
              <div class="js_composer-row hidden w-full min-w-0 items-center gap-2 group-data-[option=background]/editor:flex">
                <div class="js_composer-highlights flex gap-2 px-1 py-1.5 js_composer-row-strip min-w-0 flex-1 touch-pan-x overflow-x-auto overscroll-x-contain scroll-smooth [scrollbar-width:none]! [&::-webkit-scrollbar]:hidden!" role="group" aria-label='{__("Background")}'></div>
                <div class="js_composer-row-nav flex shrink-0 items-center gap-1 pointer-coarse:hidden data-[scrollable=false]:hidden" data-scrollable="false">
                  <button type="button" class="js_composer-row-prev flex size-8 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Previous")}'>
                    <span class="icon-[tabler--chevron-left] size-4.5 rtl:rotate-180" aria-hidden="true"></span>
                  </button>
                  <button type="button" class="js_composer-row-next flex size-8 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Next")}'>
                    <span class="icon-[tabler--chevron-right] size-4.5 rtl:rotate-180" aria-hidden="true"></span>
                  </button>
                </div>
              </div>
              <div class="flex items-center gap-1 rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.25rem] bg-neutral-900/80 p-2 backdrop-blur-md" role="toolbar" aria-label='{__("Text")}'>
                <button type="button" class="js_composer-option flex size-11 items-center justify-center rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl text-white transition hover:bg-white/10 aria-pressed:bg-white/20" data-option="font" aria-pressed="false" title='{__("Font")}' aria-label='{__("Font")}'>
                  <span class="icon-[tabler--typography] size-6" aria-hidden="true"></span>
                </button>
                <button type="button" class="js_composer-option flex size-11 items-center justify-center rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl text-white transition hover:bg-white/10 aria-pressed:bg-white/20" data-option="color" aria-pressed="false" title='{__("Text colour")}' aria-label='{__("Text colour")}'>
                  <span class="block size-6 rounded-full bg-[conic-gradient(#ef4444,#f59e0b,#84cc16,#06b6d4,#6366f1,#d946ef,#ef4444)] ring-2 ring-white/80" aria-hidden="true"></span>
                </button>
                <button type="button" class="js_composer-align flex size-11 items-center justify-center rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl text-white transition hover:bg-white/10" title='{__("Alignment")}' aria-label='{__("Alignment")}'>
                  <span class="js_composer-align-icon icon-[tabler--align-center] size-6" aria-hidden="true"></span>
                </button>
                <button type="button" class="js_composer-option flex size-11 items-center justify-center rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl text-white transition hover:bg-white/10 aria-pressed:bg-white/20" data-option="background" aria-pressed="false" title='{__("Background")}' aria-label='{__("Background")}'>
                  <span class="icon-[tabler--highlight] size-6" aria-hidden="true"></span>
                </button>
              </div>
            </div>
          </div>
          <!-- text -->
        </div>
      </div>
      <!-- story -->

      <!-- tools -->
      <div class="group-data-[chrome=false]/composer:hidden">
        <div class="pointer-events-none absolute inset-x-0 top-0 z-10 flex items-center justify-between bg-linear-to-b from-black/45 to-transparent px-3 pt-[calc(0.75rem+env(safe-area-inset-top))] pb-8 [&>*]:pointer-events-auto">
          <button type="button" class="js_composer-back flex size-11 items-center justify-center rounded-full bg-black/45 text-white backdrop-blur-md transition hover:bg-black/60 active:scale-95" aria-label='{__("Back")}'>
            <span class="icon-[tabler--chevron-left] size-5.5 rtl:rotate-180" aria-hidden="true"></span>
          </button>
          <span class="flex-1"></span>
          <button type="button" class="js_composer-sound me-2.5 hidden size-11 items-center justify-center rounded-full bg-black/45 text-white backdrop-blur-md transition hover:bg-black/60 active:scale-95 group-data-[type=video]/composer:flex" title='{__("Sound")}' aria-label='{__("Sound")}'>
            <span class="icon-[tabler--volume] size-5.5 group-data-[muted=true]/composer:hidden" aria-hidden="true"></span>
            <span class="icon-[tabler--volume-off] hidden size-5.5 group-data-[muted=true]/composer:block" aria-hidden="true"></span>
          </button>
          <button type="button" class="js_composer-close flex size-11 items-center justify-center rounded-full bg-black/45 text-white backdrop-blur-md transition hover:bg-black/60 active:scale-95" aria-label='{__("Close")}'>
            <span class="icon-[tabler--x] size-5.5" aria-hidden="true"></span>
          </button>
        </div>
        <div class="absolute end-3 top-[calc(4.5rem+env(safe-area-inset-top))] z-10 flex flex-col gap-2.5">
          <button type="button" class="js_composer-tool flex size-11 items-center justify-center rounded-full bg-black/45 text-white backdrop-blur-md transition hover:bg-black/60 active:scale-95 " data-tool="text" title='{__("Text")}' aria-label='{__("Text")}'>
            <span class="icon-[tabler--typography] size-5.5" aria-hidden="true"></span>
          </button>
          <button type="button" class="js_composer-tool flex size-11 items-center justify-center rounded-full bg-black/45 text-white backdrop-blur-md transition hover:bg-black/60 active:scale-95 " data-tool="stickers" title='{__("Stickers")}' aria-label='{__("Stickers")}'>
            <span class="icon-[tabler--mood-smile] size-5.5" aria-hidden="true"></span>
          </button>
          <button type="button" class="js_composer-tool js_composer-music-tool hidden size-11 items-center justify-center rounded-full bg-black/45 text-white backdrop-blur-md transition hover:bg-black/60 active:scale-95 aria-pressed:bg-white aria-pressed:text-neutral-900 group-data-[music=true]/composer:flex" data-tool="music" aria-pressed="false" title='{__("Music")}' aria-label='{__("Music")}'>
            <span class="icon-[tabler--music] size-5.5" aria-hidden="true"></span>
          </button>
          <button type="button" class="js_composer-tool flex size-11 items-center justify-center rounded-full bg-black/45 text-white backdrop-blur-md transition hover:bg-black/60 active:scale-95 " data-tool="mention" title='{__("Mention")}' aria-label='{__("Mention")}'>
            <span class="icon-[tabler--at] size-5.5" aria-hidden="true"></span>
          </button>
          <button type="button" class="js_composer-tool flex size-11 items-center justify-center rounded-full bg-black/45 text-white backdrop-blur-md transition hover:bg-black/60 active:scale-95 " data-tool="link" title='{__("Link")}' aria-label='{__("Link")}'>
            <span class="icon-[tabler--link] size-5.5" aria-hidden="true"></span>
          </button>
          <button type="button" class="js_composer-tool flex size-11 items-center justify-center rounded-full bg-black/45 text-white backdrop-blur-md transition hover:bg-black/60 active:scale-95 group-data-[polls=false]/composer:hidden" data-tool="poll" title='{__("Poll")}' aria-label='{__("Poll")}'>
            <span class="icon-[tabler--chart-bar] size-5.5" aria-hidden="true"></span>
          </button>
          <button type="button" class="js_composer-tool flex size-11 items-center justify-center rounded-full bg-black/45 text-white backdrop-blur-md transition hover:bg-black/60 active:scale-95 " data-tool="draw" title='{__("Draw")}' aria-label='{__("Draw")}'>
            <span class="icon-[tabler--pencil] size-5.5" aria-hidden="true"></span>
          </button>
          <button type="button" class="js_composer-tool flex size-11 items-center justify-center rounded-full bg-black/45 text-white backdrop-blur-md transition hover:bg-black/60 active:scale-95 group-data-[type=text]/composer:hidden" data-tool="filter" title='{__("Filters")}' aria-label='{__("Filters")}'>
            <span class="icon-[tabler--wand] size-5.5" aria-hidden="true"></span>
          </button>
          <button type="button" class="js_composer-tool flex size-11 items-center justify-center rounded-full bg-black/45 text-white backdrop-blur-md transition hover:bg-black/60 active:scale-95 hidden group-data-[type=text]/composer:flex" data-tool="background" title='{__("Background")}' aria-label='{__("Background")}'>
            <span class="icon-[tabler--palette] size-5.5" aria-hidden="true"></span>
          </button>
        </div>
        <div class="absolute inset-x-0 bottom-0 z-10 flex items-center justify-between gap-2 bg-linear-to-t from-black/55 to-transparent px-3 pt-10 sm:gap-3 pb-[calc(0.75rem+env(safe-area-inset-bottom))]">
          <button type="button" class="js_composer-tool inline-flex h-10 min-w-0 items-center gap-1.5 rounded-full bg-black/45 px-3.5 text-[13px] font-medium text-white backdrop-blur-md transition hover:bg-black/60 active:scale-95 sm:h-11 sm:gap-2 sm:px-4 sm:text-sm" data-tool="audience" title='{__("Who can see this story")}' aria-label='{__("Who can see this story")}'>
            <span class="js_composer-privacy-icon icon-[tabler--world] size-4.5 shrink-0" aria-hidden="true"></span>
            <span class="js_composer-privacy-label truncate"></span>
            <span class="icon-[tabler--speakerphone] hidden size-4.5 shrink-0 group-data-[ads=true]/composer:inline-block" aria-hidden="true"></span>
          </button>
          <span class="min-w-0 flex-1"></span>
          <button type="button" class="js_composer-post inline-flex h-10 shrink-0 items-center gap-1.5 rounded-full bg-white px-5 text-sm font-semibold whitespace-nowrap text-neutral-900 shadow-lg shadow-black/20 transition hover:bg-white/90 active:scale-95 sm:h-11 sm:px-6">
            {__("Post")}
            <span class="icon-[tabler--arrow-right] size-4.5 rtl:rotate-180 max-sm:hidden" aria-hidden="true"></span>
          </button>
        </div>
      </div>
      <!-- tools -->

      <!-- delete -->
      <div class="pointer-events-none absolute inset-x-0 bottom-[calc(1.5rem+env(safe-area-inset-bottom))] z-20 hidden justify-center group-data-[dragging=true]/composer:flex">
        <span class="js_composer-trash flex size-14 items-center justify-center rounded-full bg-black/55 text-white backdrop-blur-md transition data-[active=true]:scale-125 data-[active=true]:bg-error">
          <span class="icon-[tabler--trash] size-6" aria-hidden="true"></span>
        </span>
      </div>
      <!-- delete -->

      <!-- stickers -->
      <div class="js_sheet invisible absolute inset-x-0 bottom-0 z-30 flex translate-y-full max-h-[70%] flex-col gap-3 rounded-t-3xl bg-neutral-900/95 px-4 pt-4 pb-[calc(1rem+env(safe-area-inset-bottom))] sm:rounded-t-[2.5rem] sm:px-5 sm:pt-5 sm:pb-5 backdrop-blur-xl h-[60%] transition-[translate,visibility] duration-300 ease-out group-data-[panel=stickers]/composer:visible group-data-[panel=stickers]/composer:translate-y-0 motion-reduce:transition-none">
        <div class="js_sheet-grab -mt-2 -mb-2 flex shrink-0 cursor-grab touch-none justify-center py-2 active:cursor-grabbing">
          <span class="h-1 w-10 rounded-full bg-white/30"></span>
        </div>
        <div class="flex shrink-0 items-center gap-2">
          <h2 class="min-w-0 flex-1 truncate text-sm font-semibold text-white/80" title='{__("Stickers")}'>{__("Stickers")}</h2>
          <button type="button" class="js_composer-panel-close h-9 rounded-full bg-white px-4 text-sm font-semibold text-neutral-900 transition hover:bg-white/90 active:scale-95">{__("Done")}</button>
        </div>
        <div class="min-h-0 flex-1 overflow-y-auto overscroll-contain">
          <div class="js_composer-emojis grid grid-cols-7 gap-1"></div>
          {$_stickers = $user->get_stickers()}
          {if $_stickers}
            <div class="mt-3 grid grid-cols-4 gap-2 border-t border-white/10 pt-3">
              {foreach $_stickers as $sticker}
                <button type="button" class="js_composer-sticker aspect-square rounded-xl p-1.5 transition hover:bg-white/10 active:scale-95" data-id="{$sticker['sticker_id']}" data-image="{$system['system_uploads']}/{$sticker['image']}" aria-label='{__("Sticker")} {$sticker['sticker_id']}'>
                  <img class="size-full object-contain" src="{$system['system_uploads']}/{$sticker['image']}" alt="" loading="lazy">
                </button>
              {/foreach}
            </div>
          {/if}
        </div>
      </div>
      <!-- stickers -->

      <!-- mention -->
      <div class="js_sheet invisible absolute inset-x-0 bottom-0 z-30 flex translate-y-full max-h-[70%] flex-col gap-3 rounded-t-3xl bg-neutral-900/95 px-4 pt-4 pb-[calc(1rem+env(safe-area-inset-bottom))] sm:rounded-t-[2.5rem] sm:px-5 sm:pt-5 sm:pb-5 backdrop-blur-xl h-[60%] transition-[translate,visibility] duration-300 ease-out group-data-[panel=mention]/composer:visible group-data-[panel=mention]/composer:translate-y-0 motion-reduce:transition-none">
        <div class="js_sheet-grab -mt-2 -mb-2 flex shrink-0 cursor-grab touch-none justify-center py-2 active:cursor-grabbing">
          <span class="h-1 w-10 rounded-full bg-white/30"></span>
        </div>
        <div class="flex shrink-0 items-center gap-2">
          <h2 class="min-w-0 flex-1 truncate text-sm font-semibold text-white/80" title='{__("Mention")}'>{__("Mention")}</h2>
          <button type="button" class="js_composer-panel-close h-9 rounded-full bg-white px-4 text-sm font-semibold text-neutral-900 transition hover:bg-white/90 active:scale-95">{__("Done")}</button>
        </div>
        <input type="text" class="js_composer-mention-input h-11 w-full min-w-0 rounded-full border border-white/20 bg-white/10 px-4 text-base text-white outline-none placeholder:text-white/60 md:text-sm focus:border-white/60" autocomplete="off" dir="auto" placeholder='{__("Search for people")}' aria-label='{__("Search for people")}'>
        <div class="js_composer-mention-list flex min-h-0 flex-1 flex-col overflow-y-auto overscroll-contain"></div>
      </div>
      <!-- mention -->

      <!-- link -->
      <div class="js_sheet invisible absolute inset-x-0 bottom-0 z-30 flex translate-y-full max-h-[70%] flex-col gap-3 rounded-t-3xl bg-neutral-900/95 px-4 pt-4 pb-[calc(1rem+env(safe-area-inset-bottom))] sm:rounded-t-[2.5rem] sm:px-5 sm:pt-5 sm:pb-5 backdrop-blur-xl transition-[translate,visibility] duration-300 ease-out group-data-[panel=link]/composer:visible group-data-[panel=link]/composer:translate-y-0 motion-reduce:transition-none">
        <div class="js_sheet-grab -mt-2 -mb-2 flex shrink-0 cursor-grab touch-none justify-center py-2 active:cursor-grabbing">
          <span class="h-1 w-10 rounded-full bg-white/30"></span>
        </div>
        <div class="flex shrink-0 items-center gap-2">
          <h2 class="min-w-0 flex-1 truncate text-sm font-semibold text-white/80" title='{__("Link")}'>{__("Link")}</h2>
          <button type="button" class="js_composer-panel-close h-9 rounded-full bg-white px-4 text-sm font-semibold text-neutral-900 transition hover:bg-white/90 active:scale-95">{__("Done")}</button>
        </div>
        <form class="js_composer-link-form flex items-center gap-2">
          <input type="url" class="js_composer-link-input h-11 w-full min-w-0 rounded-full border border-white/20 bg-white/10 px-4 text-base text-white outline-none placeholder:text-white/60 md:text-sm focus:border-white/60" autocomplete="off" dir="ltr" placeholder="https://" aria-label='{__("Link")}'>
          <button type="submit" class="h-11 shrink-0 rounded-full bg-primary px-5 text-sm font-semibold text-primary-content transition hover:brightness-110 active:scale-95">{__("Add")}</button>
        </form>
      </div>
      <!-- link -->

      <!-- draw -->
      <div class="js_sheet invisible absolute inset-x-0 bottom-0 z-30 flex translate-y-full max-h-[70%] flex-col gap-3 rounded-t-3xl bg-neutral-900/95 px-4 pt-4 pb-[calc(1rem+env(safe-area-inset-bottom))] sm:rounded-t-[2.5rem] sm:px-5 sm:pt-5 sm:pb-5 backdrop-blur-xl transition-[translate,visibility] duration-300 ease-out group-data-[panel=draw]/composer:visible group-data-[panel=draw]/composer:translate-y-0 motion-reduce:transition-none">
        <div class="js_sheet-grab -mt-2 -mb-2 flex shrink-0 cursor-grab touch-none justify-center py-2 active:cursor-grabbing">
          <span class="h-1 w-10 rounded-full bg-white/30"></span>
        </div>
        <div class="flex shrink-0 items-center gap-2">
          <h2 class="min-w-0 flex-1 truncate text-sm font-semibold text-white/80" title='{__("Draw")}'>{__("Draw")}</h2>
          <button type="button" class="js_composer-panel-close h-9 rounded-full bg-white px-4 text-sm font-semibold text-neutral-900 transition hover:bg-white/90 active:scale-95">{__("Done")}</button>
        </div>
        <div class="flex items-center gap-2">
          <button type="button" class="js_composer-brush inline-flex h-9 items-center gap-1.5 rounded-full bg-white/10 px-3.5 text-sm font-semibold text-white transition aria-pressed:bg-white aria-pressed:text-neutral-900" data-brush="brush" aria-pressed="true"><span class="icon-[tabler--brush] size-4.5" aria-hidden="true"></span>{__("Brush")}</button>
          <button type="button" class="js_composer-brush inline-flex h-9 items-center gap-1.5 rounded-full bg-white/10 px-3.5 text-sm font-semibold text-white transition aria-pressed:bg-white aria-pressed:text-neutral-900" data-brush="eraser" aria-pressed="false"><span class="icon-[tabler--eraser] size-4.5" aria-hidden="true"></span>{__("Eraser")}</button>
          <span class="flex-1"></span>
          <button type="button" class="js_composer-undo inline-flex h-9 items-center gap-1.5 rounded-full px-3 text-sm font-medium text-white/80 transition hover:bg-white/10 hover:text-white"><span class="icon-[tabler--arrow-back-up] size-4.5" aria-hidden="true"></span>{__("Undo")}</button>
          <button type="button" class="js_composer-clear inline-flex h-9 items-center gap-1.5 rounded-full px-3 text-sm font-medium text-white/80 transition hover:bg-white/10 hover:text-white"><span class="icon-[tabler--trash] size-4.5" aria-hidden="true"></span>{__("Clear")}</button>
        </div>
        <div class="js_composer-brush-sizes flex items-center gap-2" role="group" aria-label='{__("Brush size")}'></div>
        <div class="js_composer-row flex min-w-0 items-center gap-2">
                <div class="js_composer-brush-colors flex gap-2 px-1 py-1.5 js_composer-row-strip min-w-0 flex-1 touch-pan-x overflow-x-auto overscroll-x-contain scroll-smooth [scrollbar-width:none]! [&::-webkit-scrollbar]:hidden!" role="group" aria-label='{__("Brush colour")}'></div>
                <div class="js_composer-row-nav flex shrink-0 items-center gap-1 pointer-coarse:hidden data-[scrollable=false]:hidden" data-scrollable="false">
                  <button type="button" class="js_composer-row-prev flex size-8 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Previous")}'>
                    <span class="icon-[tabler--chevron-left] size-4.5 rtl:rotate-180" aria-hidden="true"></span>
                  </button>
                  <button type="button" class="js_composer-row-next flex size-8 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Next")}'>
                    <span class="icon-[tabler--chevron-right] size-4.5 rtl:rotate-180" aria-hidden="true"></span>
                  </button>
                </div>
              </div>
      </div>
      <!-- draw -->

      <!-- filter -->
      <div class="js_sheet invisible absolute inset-x-0 bottom-0 z-30 flex translate-y-full max-h-[70%] flex-col gap-3 rounded-t-3xl bg-neutral-900/95 px-4 pt-4 pb-[calc(1rem+env(safe-area-inset-bottom))] sm:rounded-t-[2.5rem] sm:px-5 sm:pt-5 sm:pb-5 backdrop-blur-xl transition-[translate,visibility] duration-300 ease-out group-data-[panel=filter]/composer:visible group-data-[panel=filter]/composer:translate-y-0 motion-reduce:transition-none">
        <div class="js_sheet-grab -mt-2 -mb-2 flex shrink-0 cursor-grab touch-none justify-center py-2 active:cursor-grabbing">
          <span class="h-1 w-10 rounded-full bg-white/30"></span>
        </div>
        <div class="flex shrink-0 items-center gap-2">
          <h2 class="min-w-0 flex-1 truncate text-sm font-semibold text-white/80" title='{__("Filters")}'>{__("Filters")}</h2>
          <button type="button" class="js_composer-panel-close h-9 rounded-full bg-white px-4 text-sm font-semibold text-neutral-900 transition hover:bg-white/90 active:scale-95">{__("Done")}</button>
        </div>
        <div class="js_composer-row flex min-w-0 items-center gap-2">
                <div class="flex gap-3 p-1 js_composer-row-strip min-w-0 flex-1 touch-pan-x overflow-x-auto overscroll-x-contain scroll-smooth [scrollbar-width:none]! [&::-webkit-scrollbar]:hidden!">
          <button type="button" class="js_composer-filter group/filter flex w-16 shrink-0 flex-col items-center gap-1.5 text-xs text-white/70 aria-pressed:text-white" data-filter="" aria-pressed="false">
            <span class="js_composer-filter-preview block size-16 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-neutral-800 bg-cover bg-center ring-white group-aria-pressed/filter:ring-2"></span>
            <span class="w-full truncate text-center" title='{__("Normal")}'>{__("Normal")}</span>
          </button>
          <button type="button" class="js_composer-filter group/filter flex w-16 shrink-0 flex-col items-center gap-1.5 text-xs text-white/70 aria-pressed:text-white" data-filter="vivid" aria-pressed="false">
            <span class="js_composer-filter-preview block size-16 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-neutral-800 bg-cover bg-center ring-white group-aria-pressed/filter:ring-2"></span>
            <span class="w-full truncate text-center" title='{__("Vivid")}'>{__("Vivid")}</span>
          </button>
          <button type="button" class="js_composer-filter group/filter flex w-16 shrink-0 flex-col items-center gap-1.5 text-xs text-white/70 aria-pressed:text-white" data-filter="warm" aria-pressed="false">
            <span class="js_composer-filter-preview block size-16 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-neutral-800 bg-cover bg-center ring-white group-aria-pressed/filter:ring-2"></span>
            <span class="w-full truncate text-center" title='{__("Warm")}'>{__("Warm")}</span>
          </button>
          <button type="button" class="js_composer-filter group/filter flex w-16 shrink-0 flex-col items-center gap-1.5 text-xs text-white/70 aria-pressed:text-white" data-filter="cool" aria-pressed="false">
            <span class="js_composer-filter-preview block size-16 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-neutral-800 bg-cover bg-center ring-white group-aria-pressed/filter:ring-2"></span>
            <span class="w-full truncate text-center" title='{__("Cool")}'>{__("Cool")}</span>
          </button>
          <button type="button" class="js_composer-filter group/filter flex w-16 shrink-0 flex-col items-center gap-1.5 text-xs text-white/70 aria-pressed:text-white" data-filter="mono" aria-pressed="false">
            <span class="js_composer-filter-preview block size-16 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-neutral-800 bg-cover bg-center ring-white group-aria-pressed/filter:ring-2"></span>
            <span class="w-full truncate text-center" title='{__("Mono")}'>{__("Mono")}</span>
          </button>
          <button type="button" class="js_composer-filter group/filter flex w-16 shrink-0 flex-col items-center gap-1.5 text-xs text-white/70 aria-pressed:text-white" data-filter="noir" aria-pressed="false">
            <span class="js_composer-filter-preview block size-16 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-neutral-800 bg-cover bg-center ring-white group-aria-pressed/filter:ring-2"></span>
            <span class="w-full truncate text-center" title='{__("Noir")}'>{__("Noir")}</span>
          </button>
          <button type="button" class="js_composer-filter group/filter flex w-16 shrink-0 flex-col items-center gap-1.5 text-xs text-white/70 aria-pressed:text-white" data-filter="fade" aria-pressed="false">
            <span class="js_composer-filter-preview block size-16 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-neutral-800 bg-cover bg-center ring-white group-aria-pressed/filter:ring-2"></span>
            <span class="w-full truncate text-center" title='{__("Fade")}'>{__("Fade")}</span>
          </button>
          <button type="button" class="js_composer-filter group/filter flex w-16 shrink-0 flex-col items-center gap-1.5 text-xs text-white/70 aria-pressed:text-white" data-filter="vintage" aria-pressed="false">
            <span class="js_composer-filter-preview block size-16 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-neutral-800 bg-cover bg-center ring-white group-aria-pressed/filter:ring-2"></span>
            <span class="w-full truncate text-center" title='{__("Vintage")}'>{__("Vintage")}</span>
          </button>
          <button type="button" class="js_composer-filter group/filter flex w-16 shrink-0 flex-col items-center gap-1.5 text-xs text-white/70 aria-pressed:text-white" data-filter="dramatic" aria-pressed="false">
            <span class="js_composer-filter-preview block size-16 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-neutral-800 bg-cover bg-center ring-white group-aria-pressed/filter:ring-2"></span>
            <span class="w-full truncate text-center" title='{__("Dramatic")}'>{__("Dramatic")}</span>
          </button>
        </div>
                <div class="js_composer-row-nav flex shrink-0 items-center gap-1 pointer-coarse:hidden data-[scrollable=false]:hidden" data-scrollable="false">
                  <button type="button" class="js_composer-row-prev flex size-8 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Previous")}'>
                    <span class="icon-[tabler--chevron-left] size-4.5 rtl:rotate-180" aria-hidden="true"></span>
                  </button>
                  <button type="button" class="js_composer-row-next flex size-8 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Next")}'>
                    <span class="icon-[tabler--chevron-right] size-4.5 rtl:rotate-180" aria-hidden="true"></span>
                  </button>
                </div>
              </div>
      </div>
      <!-- filter -->

      <!-- background -->
      <div class="js_sheet invisible absolute inset-x-0 bottom-0 z-30 flex translate-y-full max-h-[70%] flex-col gap-3 rounded-t-3xl bg-neutral-900/95 px-4 pt-4 pb-[calc(1rem+env(safe-area-inset-bottom))] sm:rounded-t-[2.5rem] sm:px-5 sm:pt-5 sm:pb-5 backdrop-blur-xl transition-[translate,visibility] duration-300 ease-out group-data-[panel=background]/composer:visible group-data-[panel=background]/composer:translate-y-0 motion-reduce:transition-none">
        <div class="js_sheet-grab -mt-2 -mb-2 flex shrink-0 cursor-grab touch-none justify-center py-2 active:cursor-grabbing">
          <span class="h-1 w-10 rounded-full bg-white/30"></span>
        </div>
        <div class="flex shrink-0 items-center gap-2">
          <h2 class="min-w-0 flex-1 truncate text-sm font-semibold text-white/80" title='{__("Background")}'>{__("Background")}</h2>
          <button type="button" class="js_composer-panel-close h-9 rounded-full bg-white px-4 text-sm font-semibold text-neutral-900 transition hover:bg-white/90 active:scale-95">{__("Done")}</button>
        </div>
        <div class="js_composer-row flex min-w-0 items-center gap-2">
                <div class="js_composer-backgrounds flex gap-3 p-1 js_composer-row-strip min-w-0 flex-1 touch-pan-x overflow-x-auto overscroll-x-contain scroll-smooth [scrollbar-width:none]! [&::-webkit-scrollbar]:hidden!"></div>
                <div class="js_composer-row-nav flex shrink-0 items-center gap-1 pointer-coarse:hidden data-[scrollable=false]:hidden" data-scrollable="false">
                  <button type="button" class="js_composer-row-prev flex size-8 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Previous")}'>
                    <span class="icon-[tabler--chevron-left] size-4.5 rtl:rotate-180" aria-hidden="true"></span>
                  </button>
                  <button type="button" class="js_composer-row-next flex size-8 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20 disabled:pointer-events-none disabled:opacity-40" aria-label='{__("Next")}'>
                    <span class="icon-[tabler--chevron-right] size-4.5 rtl:rotate-180" aria-hidden="true"></span>
                  </button>
                </div>
              </div>
      </div>
      <!-- background -->

      <!-- poll -->
      <div class="js_sheet invisible absolute inset-x-0 bottom-0 z-30 flex translate-y-full max-h-[80%] flex-col gap-3 rounded-t-3xl bg-neutral-900/95 px-4 pt-4 pb-[calc(1rem+env(safe-area-inset-bottom))] sm:rounded-t-[2.5rem] sm:px-5 sm:pt-5 sm:pb-5 backdrop-blur-xl transition-[translate,visibility] duration-300 ease-out group-data-[panel=poll]/composer:visible group-data-[panel=poll]/composer:translate-y-0 motion-reduce:transition-none">
        <div class="js_sheet-grab -mt-2 -mb-2 flex shrink-0 cursor-grab touch-none justify-center py-2 active:cursor-grabbing">
          <span class="h-1 w-10 rounded-full bg-white/30"></span>
        </div>
        <div class="flex shrink-0 items-center gap-2">
          <h2 class="min-w-0 flex-1 truncate text-sm font-semibold text-white/80" title='{__("Poll")}'>{__("Poll")}</h2>
          <button type="button" class="js_composer-panel-close h-9 rounded-full bg-white px-4 text-sm font-semibold text-neutral-900 transition hover:bg-white/90 active:scale-95">{__("Done")}</button>
        </div>
        <form class="js_composer-poll-form flex flex-col gap-2.5">
          <input type="text" class="js_composer-poll-question h-11 w-full min-w-0 rounded-full border border-white/20 bg-white/10 px-4 text-base text-white outline-none placeholder:text-white/60 md:text-sm focus:border-white/60" maxlength="120" autocomplete="off" dir="auto" placeholder='{__("Ask a question")}' aria-label='{__("Ask a question")}'>
          <div class="flex gap-2.5">
            <input type="text" class="js_composer-poll-option h-11 w-full min-w-0 rounded-full border border-white/20 bg-white/10 px-4 text-base text-white outline-none placeholder:text-white/60 md:text-sm focus:border-white/60" maxlength="40" autocomplete="off" dir="auto" value='{__("Yes")}' aria-label='{__("Option")} 1'>
            <input type="text" class="js_composer-poll-option h-11 w-full min-w-0 rounded-full border border-white/20 bg-white/10 px-4 text-base text-white outline-none placeholder:text-white/60 md:text-sm focus:border-white/60" maxlength="40" autocomplete="off" dir="auto" value='{__("No")}' aria-label='{__("Option")} 2'>
          </div>
          <button type="submit" class="h-11 rounded-full bg-primary px-5 text-sm font-semibold text-primary-content transition hover:brightness-110 active:scale-95">{__("Add")}</button>
        </form>
      </div>
      <!-- poll -->
      <!-- audience -->
      <div class="js_sheet invisible absolute inset-x-0 bottom-0 z-30 flex translate-y-full max-h-[80%] flex-col gap-3 rounded-t-3xl bg-neutral-900/95 px-4 pt-4 pb-[calc(1rem+env(safe-area-inset-bottom))] sm:rounded-t-[2.5rem] sm:px-5 sm:pt-5 sm:pb-5 backdrop-blur-xl transition-[translate,visibility] duration-300 ease-out group-data-[panel=audience]/composer:visible group-data-[panel=audience]/composer:translate-y-0 motion-reduce:transition-none">
        <div class="js_sheet-grab -mt-2 -mb-2 flex shrink-0 cursor-grab touch-none justify-center py-2 active:cursor-grabbing">
          <span class="h-1 w-10 rounded-full bg-white/30"></span>
        </div>
        <div class="flex shrink-0 items-center gap-2">
          <h2 class="min-w-0 flex-1 truncate text-sm font-semibold text-white/80" title='{__("Who can see this story")}'>{__("Who can see this story")}</h2>
          <button type="button" class="js_composer-panel-close h-9 rounded-full bg-white px-4 text-sm font-semibold text-neutral-900 transition hover:bg-white/90 active:scale-95">{__("Done")}</button>
        </div>
        <div class="flex min-h-0 flex-col gap-2 overflow-y-auto">
          <button type="button" class="js_composer-privacy flex items-center gap-3 rounded-2xl border border-white/10 p-3 text-start transition hover:bg-white/5 aria-pressed:border-primary aria-pressed:bg-primary/15 " data-privacy="public" data-icon="icon-[tabler--world]" aria-pressed="false">
            <span class="flex size-10 shrink-0 items-center justify-center rounded-full bg-white/10 text-white"><span class="icon-[tabler--world] size-5" aria-hidden="true"></span></span>
            <span class="min-w-0 flex-1">
              <span class="js_composer-privacy-name block text-sm font-semibold text-white">{__("Public")}</span>
              <span class="block text-xs text-white/60">{__("Anyone on the site")}</span>
            </span>
          </button>
          <button type="button" class="js_composer-privacy flex items-center gap-3 rounded-2xl border border-white/10 p-3 text-start transition hover:bg-white/5 aria-pressed:border-primary aria-pressed:bg-primary/15 hidden group-data-[friends=true]/composer:flex" data-privacy="friends" data-icon="icon-[tabler--users]" aria-pressed="false">
            <span class="flex size-10 shrink-0 items-center justify-center rounded-full bg-white/10 text-white"><span class="icon-[tabler--users] size-5" aria-hidden="true"></span></span>
            <span class="min-w-0 flex-1">
              <span class="js_composer-privacy-name block text-sm font-semibold text-white">{__("Friends")}</span>
              <span class="block text-xs text-white/60">{__("Only your friends")}</span>
            </span>
          </button>
          <button type="button" class="js_composer-privacy flex items-center gap-3 rounded-2xl border border-white/10 p-3 text-start transition hover:bg-white/5 aria-pressed:border-primary aria-pressed:bg-primary/15 group-data-[friends=true]/composer:hidden" data-privacy="friends" data-icon="icon-[tabler--users]" aria-pressed="false">
            <span class="flex size-10 shrink-0 items-center justify-center rounded-full bg-white/10 text-white"><span class="icon-[tabler--users] size-5" aria-hidden="true"></span></span>
            <span class="min-w-0 flex-1">
              <span class="js_composer-privacy-name block text-sm font-semibold text-white">{__("Followers")}</span>
              <span class="block text-xs text-white/60">{__("Only people who follow you")}</span>
            </span>
          </button>
          <button type="button" class="js_composer-privacy flex items-center gap-3 rounded-2xl border border-white/10 p-3 text-start transition hover:bg-white/5 aria-pressed:border-primary aria-pressed:bg-primary/15 " data-privacy="close_friends" data-icon="icon-[tabler--star]" aria-pressed="false">
            <span class="flex size-10 shrink-0 items-center justify-center rounded-full bg-white/10 text-white"><span class="icon-[tabler--star] size-5" aria-hidden="true"></span></span>
            <span class="min-w-0 flex-1">
              <span class="js_composer-privacy-name block text-sm font-semibold text-white">{__("Close Friends")}</span>
              <span class="block text-xs text-white/60">{__("Only people in your close friends list")}</span>
            </span>
          </button>
        </div>
        <label class="hidden shrink-0 cursor-pointer items-center gap-3 rounded-2xl border border-white/10 p-3 group-data-[admin=true]/composer:flex">
          <span class="flex size-10 shrink-0 items-center justify-center rounded-full bg-white/10 text-white"><span class="icon-[tabler--speakerphone] size-5" aria-hidden="true"></span></span>
          <span class="min-w-0 flex-1">
            <span class="block text-sm font-semibold text-white" id="composer-ads-label">{__("Ads Story")}</span>
            <span class="block text-xs text-white/60">{__("Share this story as ads so all users see it")}</span>
          </span>
          <input type="checkbox" class="js_composer-ads switch switch-primary shrink-0 [--border:1px] [--radius-selector:9999px]" aria-labelledby="composer-ads-label">
        </label>
        <div class="grid shrink-0 grid-cols-1 gap-2 sm:grid-cols-2">
          <button type="button" class="js_modal inline-flex h-10 min-w-0 items-center justify-center gap-1.5 rounded-full bg-white/10 px-3.5 text-sm font-medium text-white transition hover:bg-white/20" data-url="stories/audience.php?do=manage&type=close"><span class="icon-[tabler--star] size-4.5 shrink-0" aria-hidden="true"></span><span class="whitespace-nowrap">{__("Manage Close Friends")}</span></button>
          <button type="button" class="js_modal inline-flex h-10 min-w-0 items-center justify-center gap-1.5 rounded-full bg-white/10 px-3.5 text-sm font-medium text-white transition hover:bg-white/20" data-url="stories/audience.php?do=manage&type=hidden"><span class="icon-[tabler--eye-off] size-4.5 shrink-0" aria-hidden="true"></span><span class="whitespace-nowrap">{__("Hide Story From")}</span></button>
        </div>
      </div>
      <!-- audience -->
      <!-- music -->
      <div class="js_sheet invisible absolute inset-x-0 bottom-0 z-30 flex translate-y-full h-[78%] flex-col gap-3 rounded-t-3xl bg-neutral-900/95 px-4 pt-4 pb-[calc(1rem+env(safe-area-inset-bottom))] sm:rounded-t-[2.5rem] sm:px-5 sm:pt-5 sm:pb-5 backdrop-blur-xl transition-[translate,visibility] duration-300 ease-out group-data-[panel=music]/composer:visible group-data-[panel=music]/composer:translate-y-0 motion-reduce:transition-none">
        <div class="js_sheet-grab -mt-2 -mb-2 flex shrink-0 cursor-grab touch-none justify-center py-2 active:cursor-grabbing">
          <span class="h-1 w-10 rounded-full bg-white/30"></span>
        </div>
        <div class="flex shrink-0 items-center gap-2">
          <h2 class="min-w-0 flex-1 truncate text-sm font-semibold text-white/80" title='{__("Music")}'>{__("Music")}</h2>
          <button type="button" class="js_composer-panel-close h-9 rounded-full bg-white px-4 text-sm font-semibold text-neutral-900 transition hover:bg-white/90 active:scale-95">{__("Done")}</button>
        </div>
        <div class="js_composer-music-selected hidden shrink-0 items-center gap-3 rounded-2xl bg-white/10 p-2 [&:not(.hidden)]:flex">
          <img class="size-11 shrink-0 rounded-lg bg-white/10 object-cover" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" alt="">
          <span class="min-w-0 flex-1">
            <span class="js_composer-music-selected-title block truncate text-sm font-semibold text-white"></span>
            <span class="js_composer-music-selected-artist block truncate text-xs text-white/65"></span>
          </span>
          <button type="button" class="js_composer-music-remove flex size-9 shrink-0 items-center justify-center rounded-full text-white/80 transition hover:bg-white/10 hover:text-white" title='{__("Remove")}' aria-label='{__("Remove")}'>
            <span class="icon-[tabler--x] size-5" aria-hidden="true"></span>
          </button>
        </div>
        <input type="search" class="js_composer-music-input h-11 w-full min-w-0 rounded-full border border-white/20 bg-white/10 px-4 text-base text-white outline-none placeholder:text-white/60 md:text-sm focus:border-white/60 shrink-0" autocomplete="off" dir="auto" placeholder='{__("Search songs and artists")}' aria-label='{__("Search songs and artists")}'>
        <div class="js_composer-music-tabs flex shrink-0 gap-2">
          <button type="button" class="js_composer-music-tab inline-flex h-9 shrink-0 items-center gap-1.5 rounded-full bg-white/10 px-3.5 text-sm font-semibold text-white transition aria-pressed:bg-primary aria-pressed:text-primary-content" data-tab="trending" aria-pressed="true"><span class="icon-[tabler--trending-up] size-4.5" aria-hidden="true"></span>{__("Trending")}</button>
          <button type="button" class="js_composer-music-tab inline-flex h-9 shrink-0 items-center gap-1.5 rounded-full bg-white/10 px-3.5 text-sm font-semibold text-white transition aria-pressed:bg-primary aria-pressed:text-primary-content hidden group-data-[library=true]/composer:inline-flex" data-tab="library" aria-pressed="false"><span class="icon-[tabler--playlist] size-4.5" aria-hidden="true"></span>{__("Library")}</button>
        </div>
        <div class="min-h-0 flex-1 overflow-y-auto overscroll-contain">
          <div class="js_composer-music-list flex flex-col"></div>
          <div class="js_composer-music-loader hidden justify-center py-6 [&:not(.hidden)]:flex"><span class="loading loading-spinner text-white"></span></div>
          <div class="js_composer-music-empty hidden flex-col items-center gap-2 px-6 py-10 text-center text-sm text-white/60 [&:not(.hidden)]:flex">
            <span class="icon-[tabler--music-off] size-8" aria-hidden="true"></span>
            {__("No tracks found")}
          </div>
        </div>
      </div>
      <!-- music -->

      <!-- progress -->
      <div class="absolute inset-0 z-50 hidden flex-col items-center justify-center gap-4 bg-black/70 backdrop-blur-sm group-data-[busy=true]/composer:flex" role="status">
        <span class="loading loading-spinner loading-lg text-white"></span>
        <span class="js_composer-progress text-sm font-medium text-white"></span>
      </div>
      <!-- progress -->

    </div>
  </div>
</script>
<!-- Stories -->
