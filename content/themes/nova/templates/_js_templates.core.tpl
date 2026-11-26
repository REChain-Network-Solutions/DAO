  <!-- Toasts -->
  <div class="toast-container pointer-events-none fixed bottom-0 start-0 z-80 flex flex-col gap-2 p-3 [&>*]:pointer-events-auto">
  </div>
  <!-- Toasts -->

  <!-- Modals -->
  <div class="heroui">
    <div id="modal" class="overlay hidden overlay-open:opacity-100 overlay-open:duration-200 modal__backdrop modal__backdrop--opaque"
      role="dialog" aria-modal="true" aria-label="{__("Dialog")}" tabindex="-1"
      data-overlay-options='{ "backdropClasses": "overlay-backdrop transition duration-200 fixed inset-0 bg-black/55 overflow-y-auto" }'>
      <div class="modal__container modal__container--scroll-outside overlay-animation-target">
        <div class="modal__dialog modal__dialog--md modal__dialog--scroll-outside" id="modal-dialog">
          <div id="modal-content">
            <div class="modal__body">
              <div class="loading loading-spinner py-2.5"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div id="modal-stacked" class="overlay hidden overlay-open:opacity-100 overlay-open:duration-200 modal__backdrop modal__backdrop--opaque [--z-index-overlay:100010]"
      role="dialog" aria-modal="true" aria-label="{__("Dialog")}" tabindex="-1"
      data-overlay-options='{ "isClosePrev": false, "backdropClasses": "overlay-backdrop transition duration-200 fixed inset-0 bg-black/55 overflow-y-auto" }'>
      <div class="modal__container modal__container--scroll-outside overlay-animation-target">
        <div class="modal__dialog modal__dialog--md modal__dialog--scroll-outside">
          <div id="modal-stacked-content">
            <div class="modal__body">
              <div class="loading loading-spinner py-2.5"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script id="modal-login" type="text/template">
    <div class="modal__header mb-4 flex-row items-center gap-3 [&+.modal\_\_body]:mt-0">
      <span class="modal__icon size-9 rounded-lg bg-base-200 text-base-content" aria-hidden="true"><span class="icon-[tabler--lock] size-5"></span></span>
      <div class="min-w-0 flex-1">
        <h6 class="modal__heading">{__("Not Logged In")}</h6>
      </div>
      {include file='__close_button.tpl' extra_class="static"}
    </div>
    <div class="modal__body flex flex-col gap-4">
      <p class="text-sm text-base-content/70">{__("Please log in to continue")}</p>
    </div>
    <div class="modal__footer justify-end gap-2">
      <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
      <a class="button button--primary text-(--button-fg)!" href="{$system['system_url']}/signin">{__("Login")}</a>
    </div>
  </script>

  <script id="modal-message" type="text/template">
    <div class="modal__header mb-4 flex-row items-center gap-3 [&+.modal\_\_body]:mt-0">
      <span class="modal__icon size-9 rounded-lg bg-base-200 text-base-content" aria-hidden="true"><span class="icon-[tabler--message-circle] size-5"></span></span>
      <div class="min-w-0 flex-1">
        <h6 class="modal__heading">{literal}{{title}}{/literal}</h6>
      </div>
      {include file='__close_button.tpl' extra_class="static"}
    </div>
    <div class="modal__body flex flex-col gap-4">
      <p class="text-sm text-base-content/70">{literal}{{{message}}}{/literal}</p>
    </div>
  </script>

  <script id="modal-success" type="text/template">
    <div class="modal__body flex flex-col items-center gap-3 py-6 text-center">
      {include file='__close_button.tpl'}
      <span class="modal__icon size-14 bg-success/10 text-success" aria-hidden="true"><span class="icon-[tabler--circle-check] size-8"></span></span>
      <h6 class="modal__heading text-lg">{literal}{{title}}{/literal}</h6>
      <p class="text-sm text-base-content/70">{literal}{{{message}}}{/literal}</p>
    </div>
  </script>

  <script id="modal-info" type="text/template">
    <div class="modal__body flex flex-col items-center gap-3 py-6 text-center">
      {include file='__close_button.tpl'}
      <span class="modal__icon size-14 bg-info/10 text-info" aria-hidden="true"><span class="icon-[tabler--info-circle] size-8"></span></span>
      <h6 class="modal__heading text-lg">{literal}{{title}}{/literal}</h6>
      <p class="text-sm text-base-content/70">{literal}{{{message}}}{/literal}</p>
    </div>
  </script>

  <script id="modal-error" type="text/template">
    <div class="modal__body flex flex-col items-center gap-3 py-6 text-center">
      {include file='__close_button.tpl'}
      <span class="modal__icon size-14 bg-error/10 text-error" aria-hidden="true"><span class="icon-[tabler--alert-circle] size-8"></span></span>
      <h6 class="modal__heading text-lg">{literal}{{title}}{/literal}</h6>
      <p class="text-sm text-base-content/70">{literal}{{{message}}}{/literal}</p>
    </div>
  </script>

  <script id="modal-confirm" type="text/template">
    <div class="modal__header mb-4 flex-row items-center gap-3 [&+.modal\_\_body]:mt-0">
      {literal}{{#danger}}{/literal}
      <span class="modal__icon size-9 rounded-lg bg-error/10 text-error" aria-hidden="true"><span class="icon-[tabler--alert-triangle] size-5"></span></span>
      {literal}{{/danger}}{/literal}
      {literal}{{^danger}}{/literal}
      <span class="modal__icon size-9 rounded-lg bg-base-200 text-base-content" aria-hidden="true"><span class="icon-[tabler--help-circle] size-5"></span></span>
      {literal}{{/danger}}{/literal}
      <div class="min-w-0 flex-1">
        <h6 class="modal__heading">{literal}{{title}}{/literal}</h6>
      </div>
      {literal}{{^destructive}}{/literal}
      {include file='__close_button.tpl' extra_class="static"}
      {literal}{{/destructive}}{/literal}
    </div>
    <div class="modal__body flex flex-col gap-4">
      <p class="text-sm text-base-content/70">{literal}{{{message}}}{/literal}</p>
      {literal}{{#password_check}}{/literal}
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="modal-password-check">{__("Confirm Password")}</label>
        <input id="modal-password-check" name="password_check" type="password" class="input w-full [--border:1px]">
      </div>
      {literal}{{/password_check}}{/literal}
    </div>
    <div class="modal__footer justify-end gap-2">
      <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
      <button type="button" class="button {literal}{{#danger}}button--danger{{/danger}}{{^danger}}button--primary{{/danger}}{/literal}" id="modal-confirm-ok">{__("Confirm")}</button>
    </div>
  </script>

  <script id="modal-confirm-payment" type="text/template">
    <div class="modal__header mb-4 flex-row items-center gap-3 [&+.modal\_\_body]:mt-0">
      <span class="modal__icon size-9 rounded-lg bg-base-200 text-base-content" aria-hidden="true"><span class="icon-[tabler--shopping-cart] size-5"></span></span>
      <div class="min-w-0 flex-1">
        <h6 class="modal__heading">{__("Payment Alert")}</h6>
      </div>
      {include file='__close_button.tpl' extra_class="static"}
    </div>
    <div class="modal__body flex flex-col gap-4">
      <p class="text-sm text-base-content/70">{__("You are about to purchase the items, do you want to proceed?")}</p>
    </div>
    <div class="modal__footer justify-end gap-2">
      <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
      <button type="button" class="button button--primary" id="modal-confirm-payment-ok">{__("Confirm")}</button>
    </div>
  </script>

  <script id="modal-loading" type="text/template">
    <div class="modal__body flex justify-center py-6">
      <div class="loading loading-spinner text-primary"></div>
    </div>
  </script>
  <!-- Modals -->

  <!-- Connection Buttons -->
  <script id="connection-button-friend_add" type="text/template">
    {include file='__connection_button.tpl' _state="friend_add" _mustache=true}
  </script>
  <script id="connection-button-friend_sent" type="text/template">
    {include file='__connection_button.tpl' _state="friend_sent" _mustache=true}
  </script>
  <script id="connection-button-friends" type="text/template">
    {include file='__connection_button.tpl' _state="friends" _mustache=true}
  </script>
  <script id="connection-button-follow" type="text/template">
    {include file='__connection_button.tpl' _state="follow" _mustache=true}
  </script>
  <script id="connection-button-following" type="text/template">
    {include file='__connection_button.tpl' _state="following" _mustache=true}
  </script>
  <script id="connection-button-page_like" type="text/template">
    {include file='__connection_button.tpl' _state="page_like" _mustache=true}
  </script>
  <script id="connection-button-page_liked" type="text/template">
    {include file='__connection_button.tpl' _state="page_liked" _mustache=true}
  </script>
  <script id="connection-button-group_join" type="text/template">
    {include file='__connection_button.tpl' _state="group_join" _mustache=true}
  </script>
  <script id="connection-button-group_joined" type="text/template">
    {include file='__connection_button.tpl' _state="group_joined" _mustache=true}
  </script>
  <script id="connection-button-group_pending" type="text/template">
    {include file='__connection_button.tpl' _state="group_pending" _mustache=true}
  </script>
  <script id="connection-button-event_go" type="text/template">
    {include file='__connection_button.tpl' _state="event_go" _mustache=true}
  </script>
  <script id="connection-button-event_going" type="text/template">
    {include file='__connection_button.tpl' _state="event_going" _mustache=true}
  </script>
  <script id="connection-button-event_interest" type="text/template">
    {include file='__connection_button.tpl' _state="event_interest" _mustache=true}
  </script>
  <script id="connection-button-event_interested" type="text/template">
    {include file='__connection_button.tpl' _state="event_interested" _mustache=true}
  </script>
  <script id="connection-button-page_admin_add" type="text/template">
    {include file='__connection_button.tpl' _state="admin_add" _node="page" _mustache=true}
  </script>
  <script id="connection-button-page_admin_remove" type="text/template">
    {include file='__connection_button.tpl' _state="admin_remove" _node="page" _mustache=true}
  </script>
  <script id="connection-button-group_admin_add" type="text/template">
    {include file='__connection_button.tpl' _state="admin_add" _node="group" _mustache=true}
  </script>
  <script id="connection-button-group_admin_remove" type="text/template">
    {include file='__connection_button.tpl' _state="admin_remove" _node="group" _mustache=true}
  </script>
  <!-- Connection Buttons -->

  <!-- Theme Switcher -->
  <script id="theme-switcher" type="text/template">
    {include file='__modal_header.tpl' _icon="icon-[tabler--palette]" _title=__("Theme Switcher")}
    <div class="modal__body flex flex-col gap-4">
      <div class="grid grid-cols-2 gap-4">
        {foreach $system['themes'] as $theme}
          <a href="?theme={$theme['name']}" class="group flex flex-col overflow-hidden rounded-xl border border-base-300 bg-base-100 transition hover:border-primary">
            <span class="relative block aspect-[16/10] w-full overflow-hidden bg-base-200">
              <img class="absolute inset-0 size-full object-cover" src="{$system['system_url']}/content/themes/{$theme['name']}/thumbnail.png" alt="{$theme['title']|default:$theme['name']}" loading="lazy">
            </span>
            <span class="px-3 py-2 text-sm font-medium text-base-content capitalize">{$theme['title']|default:$theme['name']}</span>
          </a>
        {/foreach}
      </div>
    </div>
  </script>
  <!-- Themes -->

  <!-- Search -->
  <script id="search-for" type="text/template">
    <div class="p-2">
      <a class="flex min-h-11 items-center gap-3 rounded-field px-3 text-sm text-base-content! transition-colors hover:bg-base-200" href="{$system['system_url']}/search/{literal}{{#hashtag}}hashtag/{{/hashtag}}{/literal}{literal}{{query}}{/literal}">
        <span class="icon-[tabler--search] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
        <span class="min-w-0 truncate" title="{literal}{{#hashtag}}#{{/hashtag}}{{query}}{/literal}">{__("Search for")} <strong class="font-semibold">{literal}{{#hashtag}}#{{/hashtag}}{/literal}{literal}{{query}}{/literal}</strong></span>
      </a>
    </div>
  </script>
  <!-- Search -->

  <!-- Lightbox -->
  <script id="lightbox" type="text/template">
    <div class="heroui lightbox fixed inset-0 z-[1080] flex items-center justify-center bg-black/85 p-2 backdrop-blur-sm sm:p-4">
      <div class="flex h-full w-full max-w-[120rem] flex-col overflow-hidden rounded-box bg-base-100 shadow-2xl transition duration-300 ease-out starting:scale-95 starting:opacity-0 lg:flex-row">
        <div class="lightbox-preview relative isolate flex min-h-0 min-w-0 flex-1 items-center justify-center overflow-hidden bg-black select-none">
          <img alt="" class="lightbox-ambient pointer-events-none absolute inset-0 -z-10 size-full scale-110 object-cover opacity-40 blur-3xl" src="{literal}{{image}}{/literal}" aria-hidden="true">
          <div class="lightbox-stage flex size-full items-center justify-center transition-transform duration-200 ease-out">
            <img alt="" class="lightbox-image max-h-full max-w-full object-contain transition duration-300 ease-out" src="{literal}{{image}}{/literal}" draggable="false">
          </div>
          <div class="lightbox-loader pointer-events-none absolute inset-0 hidden items-center justify-center [&:not(.hidden)]:flex">
            <span class="loading loading-spinner loading-lg text-white"></span>
          </div>
          <button type="button" class="lightbox-prev js_lightbox-slider flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white absolute start-3 top-1/2 z-10 hidden -translate-y-1/2 sm:start-5" aria-label='{__("Previous")}'>
            <span class="icon-[tabler--chevron-left] size-6 rtl:rotate-180" aria-hidden="true"></span>
          </button>
          <button type="button" class="lightbox-next js_lightbox-slider flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white absolute end-3 top-1/2 z-10 hidden -translate-y-1/2 sm:end-5" aria-label='{__("Next")}'>
            <span class="icon-[tabler--chevron-right] size-6 rtl:rotate-180" aria-hidden="true"></span>
          </button>
          <div class="lightbox-toolbar absolute top-3 end-3 z-10 flex items-center gap-2 sm:top-5 sm:end-5">
            <button type="button" class="js_lightbox-zoom-in flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white" title='{__("Zoom In")}' aria-label='{__("Zoom In")}'><span class="icon-[tabler--zoom-in] size-5" aria-hidden="true"></span></button>
            <button type="button" class="js_lightbox-zoom-out flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white" title='{__("Zoom Out")}' aria-label='{__("Zoom Out")}' disabled><span class="icon-[tabler--zoom-out] size-5" aria-hidden="true"></span></button>
            <button type="button" class="js_lightbox-fullscreen group/fullscreen flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white" title='{__("Fullscreen")}' aria-label='{__("Fullscreen")}'><span class="icon-[tabler--maximize] size-5 group-[.is-fullscreen]/fullscreen:hidden" aria-hidden="true"></span><span class="icon-[tabler--minimize] hidden size-5 group-[.is-fullscreen]/fullscreen:inline-block" aria-hidden="true"></span></button>
            {if !$system['download_images_disabled']}
              <a class="lightbox-download flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white" href="{literal}{{image}}{/literal}" download title='{__("Download")}' aria-label='{__("Download")}'><span class="icon-[tabler--download] size-5" aria-hidden="true"></span></a>
              <a class="lightbox-download flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white" target="_blank" href="{literal}{{image}}{/literal}" title='{__("View Original")}' aria-label='{__("View Original")}'><span class="icon-[tabler--external-link] size-5" aria-hidden="true"></span></a>
            {/if}
          </div>
        </div>
        <div class="lightbox-data relative flex max-h-[45%] w-full shrink-0 flex-col overflow-hidden bg-base-100 lg:max-h-none lg:w-[26rem]">
          {include file='__close_button.tpl' extra_class='js_lightbox-close' no_overlay=true}
          <div class="lightbox-post min-h-0 flex-1 overflow-y-auto">
            <div class="js_scroller" data-slimScroll-height="100%">
              <div class="loading loading-spinner my-2.5"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </script>

  <script id="lightbox-nodata" type="text/template">
    <div class="heroui lightbox fixed inset-0 z-[1080] flex items-center justify-center bg-black/85 p-2 backdrop-blur-sm sm:p-4">
      <div class="lightbox-preview nodata relative isolate flex h-full w-full max-w-[120rem] items-center justify-center overflow-hidden rounded-box bg-black shadow-2xl transition duration-300 ease-out select-none starting:scale-95 starting:opacity-0">
        <img alt="" class="lightbox-ambient pointer-events-none absolute inset-0 -z-10 size-full scale-110 object-cover opacity-40 blur-3xl" src="{literal}{{image}}{/literal}" aria-hidden="true">
        <div class="lightbox-stage flex size-full items-center justify-center transition-transform duration-200 ease-out">
            <img alt="" class="lightbox-image max-h-full max-w-full object-contain transition duration-300 ease-out" src="{literal}{{image}}{/literal}" draggable="false">
            <div class="lightbox-video-stage hidden size-full max-w-full [&_.plyr]:size-full [&_.plyr__video-wrapper]:size-full [&_video]:object-contain"></div>
          </div>
        <div class="lightbox-loader pointer-events-none absolute inset-0 hidden items-center justify-center [&:not(.hidden)]:flex">
          <span class="loading loading-spinner loading-lg text-white"></span>
        </div>
        <button type="button" class="lightbox-prev js_lightbox-nodata-slider flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white absolute top-1/2 z-10 hidden -translate-y-1/2 start-3 sm:start-5" aria-label='{__("Previous")}'>
          <span class="icon-[tabler--chevron-left] size-6 rtl:rotate-180" aria-hidden="true"></span>
        </button>
        <button type="button" class="lightbox-next js_lightbox-nodata-slider flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white absolute top-1/2 z-10 hidden -translate-y-1/2 end-3 sm:end-5" aria-label='{__("Next")}'>
          <span class="icon-[tabler--chevron-right] size-6 rtl:rotate-180" aria-hidden="true"></span>
        </button>
        <div class="lightbox-toolbar absolute top-3 end-3 z-10 flex items-center gap-2 sm:top-5 sm:end-5">
            <button type="button" class="js_lightbox-zoom-in flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white" title='{__("Zoom In")}' aria-label='{__("Zoom In")}'><span class="icon-[tabler--zoom-in] size-5" aria-hidden="true"></span></button>
            <button type="button" class="js_lightbox-zoom-out flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white" title='{__("Zoom Out")}' aria-label='{__("Zoom Out")}' disabled><span class="icon-[tabler--zoom-out] size-5" aria-hidden="true"></span></button>
            <button type="button" class="js_lightbox-fullscreen group/fullscreen flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white" title='{__("Fullscreen")}' aria-label='{__("Fullscreen")}'><span class="icon-[tabler--maximize] size-5 group-[.is-fullscreen]/fullscreen:hidden" aria-hidden="true"></span><span class="icon-[tabler--minimize] hidden size-5 group-[.is-fullscreen]/fullscreen:inline-block" aria-hidden="true"></span></button>
            {if !$system['download_images_disabled'] || !$system['download_videos_disabled']}
              <a class="lightbox-download flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white" data-image="{if $system['download_images_disabled']}0{else}1{/if}" data-video="{if $system['download_videos_disabled']}0{else}1{/if}" href="{literal}{{image}}{/literal}" download title='{__("Download")}' aria-label='{__("Download")}'><span class="icon-[tabler--download] size-5" aria-hidden="true"></span></a>
            {/if}
            <button type="button" class="js_lightbox-close lightbox-exit flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white" aria-label='{__("Close")}'><span class="icon-[tabler--x] size-5" aria-hidden="true"></span></button>
          </div>
      </div>
    </div>
  </script>

  <script id="lightbox-video" type="text/template">
    <div class="heroui lightbox fixed inset-0 z-[1080] flex items-center justify-center bg-black/85 p-2 backdrop-blur-sm sm:p-4">
      <div class="flex h-full w-full max-w-[120rem] flex-col overflow-hidden rounded-box bg-base-100 shadow-2xl transition duration-300 ease-out starting:scale-95 starting:opacity-0 lg:flex-row">
        <div class="lightbox-preview relative isolate flex min-h-0 min-w-0 flex-1 items-center justify-center overflow-hidden bg-black select-none">
          <div class="lightbox-video-stage flex size-full items-center justify-center [--plyr-video-background:transparent] [&_.plyr]:size-full [&_.plyr__video-wrapper]:size-full [&_video]:object-contain">
            <span class="loading loading-spinner loading-lg text-white"></span>
          </div>
          {if !$system['download_videos_disabled']}
            <div class="lightbox-toolbar absolute top-3 end-3 z-10 flex items-center gap-2 sm:top-5 sm:end-5">
              <a class="lightbox-download flex size-11 items-center justify-center rounded-full bg-white/15 text-white! backdrop-blur-md transition hover:bg-white/25 hover:text-white! active:scale-95 disabled:pointer-events-none disabled:opacity-40 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white" href="#" download title='{__("Download")}' aria-label='{__("Download")}'><span class="icon-[tabler--download] size-5" aria-hidden="true"></span></a>
            </div>
          {/if}
        </div>
        <div class="lightbox-data relative flex max-h-[45%] w-full shrink-0 flex-col overflow-hidden bg-base-100 lg:max-h-none lg:w-[26rem]">
          {include file='__close_button.tpl' extra_class='js_lightbox-close' no_overlay=true}
          <div class="lightbox-post min-h-0 flex-1 overflow-y-auto">
            <div class="js_scroller" data-slimScroll-height="100%">
              <div class="loading loading-spinner my-2.5"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </script>

  <script id="lightbox-live" type="text/template">
    <div class="heroui lightbox fixed inset-0 z-[1080] flex items-center justify-center bg-black/85 p-2 backdrop-blur-sm sm:p-4" data-live-post-id="{literal}{{post_id}}{/literal}">
      <div class="flex h-full w-full max-w-[120rem] flex-col overflow-hidden rounded-box bg-base-100 shadow-2xl transition duration-300 ease-out starting:scale-95 starting:opacity-0 lg:flex-row">
        <div class="lightbox-preview with-live js_live-stage group/stage relative isolate min-h-0 min-w-0 flex-1 overflow-hidden bg-neutral-950 text-white">
          <div class="live-stream-video absolute inset-0 size-full" id="js_live-video"></div>
          <!-- live counter -->
          <div class="pointer-events-none absolute inset-x-0 top-0 z-10 flex items-center gap-2 bg-linear-to-b from-black/60 to-transparent p-3 sm:p-4">
            <span class="group/live offline inline-flex items-center gap-1.5 rounded-full bg-error px-2.5 py-1 text-xs font-bold tracking-wider text-white uppercase shadow-lg shadow-error/30 [&.offline]:bg-black/50 [&.offline]:shadow-none [&.offline]:backdrop-blur-md">
              <span class="size-1.5 animate-pulse rounded-full bg-current group-[.offline]/live:animate-none" aria-hidden="true"></span>
              <span id="js_live-counter-status">{__("Offline")}</span>
            </span>
            <span class="inline-flex items-center gap-1.5 rounded-full bg-black/50 px-2.5 py-1 text-xs font-semibold text-white backdrop-blur-md">
              <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
              <span class="tabular-nums" id="js_live-counter-number">0</span>
            </span>
          </div>
          <!-- live counter -->
          <!-- live status -->
          <div class="pointer-events-none absolute inset-0 z-10 flex items-center justify-center p-4">
            <div class="flex max-w-sm items-center gap-2.5 rounded-full bg-black/60 px-4 py-2.5 text-sm font-medium text-white shadow-lg ring-1 ring-white/10 backdrop-blur-md [&.error]:bg-error" id="js_live-status" role="status">
              {__("Loading")}<span class="loading loading-spinner loading-sm shrink-0"></span>
            </div>
          </div>
          <!-- live status -->
          <!-- live reactions -->
          <div class="js_live-reactions pointer-events-none absolute end-1 bottom-16 sm:end-3 z-10 h-3/5 w-24" aria-hidden="true">
            {foreach $system['reactions_enabled'] as $reaction}
              <img src="{$system['reactions'][$reaction['reaction']]['image_url']}" alt="" data-reaction="{$reaction['reaction']}" hidden>
            {/foreach}
          </div>
          <!-- live reactions -->
          <!-- live buttons -->
          <div class="js_live-controls absolute end-3 bottom-3 z-20 transition-opacity duration-300 sm:end-4 sm:bottom-4 [@media(hover:hover)]:opacity-0 [@media(hover:hover)]:group-hover/stage:opacity-100 [@media(hover:hover)]:focus-within:opacity-100" hidden>
            <div class="flex items-center gap-2 rounded-full bg-black/40 p-1.5 shadow-2xl ring-1 ring-white/10 backdrop-blur-xl">
              <button type="button" class="js_live-sound group/btn heroui button button--tertiary button--icon-only size-10 rounded-full border-0 bg-white/15 text-white shadow-none hover:bg-white/25 aria-pressed:bg-white aria-pressed:text-neutral-900 aria-pressed:hover:bg-white/90" aria-pressed="false" title="{__("Sound")}" aria-label="{__("Sound")}">
                <span class="icon-[tabler--volume] size-5 group-aria-pressed/btn:hidden" aria-hidden="true"></span>
                <span class="icon-[tabler--volume-off] hidden size-5 group-aria-pressed/btn:block" aria-hidden="true"></span>
              </button>
              <button type="button" class="js_live-fullscreen group/btn heroui button button--tertiary button--icon-only size-10 rounded-full border-0 bg-white/15 text-white shadow-none hover:bg-white/25" aria-pressed="false" title="{__("Full Screen")}" aria-label="{__("Full Screen")}">
                <span class="icon-[tabler--maximize] size-5 group-aria-pressed/btn:hidden" aria-hidden="true"></span>
                <span class="icon-[tabler--minimize] hidden size-5 group-aria-pressed/btn:block" aria-hidden="true"></span>
              </button>
            </div>
          </div>
          <!-- live buttons -->
        </div>
        <div class="lightbox-data relative flex max-h-[45%] w-full shrink-0 flex-col overflow-hidden bg-base-100 lg:max-h-none lg:w-[26rem]">
          {include file='__close_button.tpl' extra_class='js_lightbox-close' no_overlay=true}
          <div class="lightbox-post min-h-0 flex-1 overflow-y-auto">
            <div class="js_scroller" data-slimScroll-height="100%">
              <div class="loading loading-spinner my-2.5"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </script>
  <!-- Lightbox -->
