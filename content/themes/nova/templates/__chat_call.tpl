<div class="js_call-stage relative isolate w-full overflow-hidden bg-neutral-950 text-white select-none max-sm:h-dvh! [&:fullscreen]:h-dvh! {literal}{{#is_video}}{/literal}h-[min(40rem,calc(100dvh-4rem))]{literal}{{/is_video}}{/literal}{literal}{{#is_audio}}{/literal}h-[min(34rem,calc(100dvh-4rem))]{literal}{{/is_audio}}{/literal}" data-type="{literal}{{type}}{/literal}">
  <!-- backdrop -->
  <img class="pointer-events-none absolute inset-0 -z-10 size-full scale-125 object-cover opacity-40 blur-3xl" src="{literal}{{picture}}{/literal}" alt="" aria-hidden="true">
  <div class="pointer-events-none absolute inset-0 -z-10 bg-linear-to-b from-black/40 via-black/20 to-black/80" aria-hidden="true"></div>
  <!-- backdrop -->

  <!-- remote stream -->
  <div class="video-call-stream absolute inset-0 bg-black [&>div]:size-full [&_video]:size-full! [&_video]:object-cover!" hidden></div>
  <div class="js_call-audio" hidden></div>
  <!-- remote stream -->

  <!-- caller info -->
  <div class="js_call-placeholder absolute inset-0 flex flex-col items-center justify-center gap-2 px-6 pb-28 text-center transition-opacity duration-300">
    <p class="flex items-center gap-1.5 text-xs font-medium tracking-[0.18em] text-white/60 uppercase">
      {literal}{{#is_video}}{/literal}<span class="icon-[tabler--video] size-4" aria-hidden="true"></span>{literal}{{/is_video}}{/literal}
      {literal}{{#is_audio}}{/literal}<span class="icon-[tabler--phone] size-4" aria-hidden="true"></span>{literal}{{/is_audio}}{/literal}
      {if $_incoming}{__("Incoming call")}{else}{__("Outgoing call")}{/if}
    </p>
    <div class="relative my-4 grid place-items-center">
      <span class="js_call-pulse absolute size-32 animate-ping rounded-full bg-white/15 [animation-duration:2s]" aria-hidden="true"></span>
      <img class="relative size-32 rounded-full object-cover shadow-2xl ring-4 ring-white/15" src="{literal}{{picture}}{/literal}" alt="{literal}{{name}}{/literal}">
      <span class="js_call-remote-muted absolute end-1 bottom-1 size-8 rounded-full bg-error text-error-content shadow-lg ring-4 ring-neutral-950" hidden>
        <span class="flex size-full items-center justify-center"><span class="icon-[tabler--microphone-off] size-4" aria-hidden="true"></span></span>
      </span>
    </div>
    <h3 class="max-w-full truncate text-2xl font-semibold tracking-tight" title="{literal}{{name}}{/literal}">{literal}{{name}}{/literal}</h3>
    {if $_incoming}
      {literal}{{#is_video}}{/literal}<p class="text-sm text-white/70 tabular-nums js_chat-calling-message">{__("Wants to have video call with you")}</p>{literal}{{/is_video}}{/literal}
      {literal}{{#is_audio}}{/literal}<p class="text-sm text-white/70 tabular-nums js_chat-calling-message">{__("Wants to have audio call with you")}</p>{literal}{{/is_audio}}{/literal}
    {else}
      <p class="text-sm text-white/70 tabular-nums js_chat-calling-message">{__("Connecting")}<span class="loading loading-dots loading-xs ms-1 align-middle" aria-hidden="true"></span></p>
    {/if}
  </div>
  <!-- caller info -->

  <!-- call info -->
  <div class="js_call-topbar pointer-events-none absolute inset-x-0 top-0 flex items-start p-4 opacity-0 transition-opacity duration-300">
    <div class="flex max-w-[calc(100%-8rem)] min-w-0 items-center gap-2.5 rounded-full bg-black/45 py-1.5 ps-1.5 pe-4 shadow-lg ring-1 ring-white/10 backdrop-blur-md sm:max-w-[calc(100%-11rem)]">
      <img class="size-9 shrink-0 rounded-full object-cover" src="{literal}{{picture}}{/literal}" alt="{literal}{{name}}{/literal}">
      <div class="min-w-0">
        <div class="flex items-center gap-1.5">
          <span class="truncate text-sm font-semibold" title="{literal}{{name}}{/literal}">{literal}{{name}}{/literal}</span>
          <span class="js_call-remote-muted shrink-0 text-error" hidden><span class="icon-[tabler--microphone-off] block size-3.5" aria-hidden="true"></span></span>
        </div>
        <div class="flex items-center gap-1.5 text-xs text-white/70">
          <span class="size-1.5 shrink-0 animate-pulse rounded-full bg-error" aria-hidden="true"></span>
          <span class="js_call-timer tabular-nums">00:00:00</span>
        </div>
      </div>
    </div>
  </div>
  <!-- call info -->

  <!-- local stream -->
  <div class="video-call-stream-local absolute end-4 top-4 z-10 aspect-3/4 w-24 overflow-hidden rounded-2xl bg-neutral-800 shadow-2xl ring-1 ring-white/20 sm:w-36 [&>div]:size-full [&_video]:size-full! [&_video]:object-cover! [&>video]:-scale-x-100" hidden></div>
  <div class="js_call-local-off" hidden>
    <div class="absolute end-4 top-4 z-10 flex aspect-3/4 w-24 flex-col items-center justify-center gap-1 rounded-2xl bg-neutral-800 text-white/70 shadow-2xl ring-1 ring-white/20 sm:w-36">
      <span class="icon-[tabler--video-off] size-6" aria-hidden="true"></span>
      <span class="text-[11px]">{__("Camera off")}</span>
    </div>
  </div>
  <!-- local stream -->

  <!-- call ended -->
  <div class="js_call-ended absolute inset-0 z-30" hidden>
    <div class="flex size-full flex-col items-center justify-center gap-3 bg-neutral-950/80 backdrop-blur-sm">
      <span class="flex size-14 items-center justify-center rounded-full bg-error/20 text-error"><span class="icon-[tabler--phone-off] size-7" aria-hidden="true"></span></span>
      <p class="js_call-ended-message text-lg font-semibold"></p>
    </div>
  </div>
  <!-- call ended -->

  <!-- call buttons -->
  <div class="absolute inset-x-0 bottom-0 z-20 bg-linear-to-t from-black/80 via-black/40 to-transparent px-4 pt-16 pb-6">
    <div class="js_call-actions">
      <div class="flex items-start justify-center gap-12">
        {if $_incoming}
          <button type="button" class="js_chat-call-decline flex flex-col items-center gap-2 text-xs font-medium text-white/80 transition hover:scale-105" data-id="{literal}{{id}}{/literal}" data-overlay="#modal">
            <span class="heroui button button--danger button--icon-only rounded-full pointer-events-none size-16 shadow-lg shadow-error/30"><span class="icon-[tabler--phone-off] size-7" aria-hidden="true"></span></span>
            {__("Decline")}
          </button>
          <button type="button" class="js_chat-call-answer flex flex-col items-center gap-2 text-xs font-medium text-white/80 transition hover:scale-105" data-id="{literal}{{id}}{/literal}">
            <span class="heroui button button--primary [--button-bg:var(--success)] [--button-bg-hover:var(--success-hover)] [--button-bg-pressed:var(--success-hover)] [--button-fg:var(--success-foreground)] button--icon-only rounded-full pointer-events-none size-16 animate-bounce shadow-lg shadow-success/30 [animation-duration:1.4s]">
              {literal}{{#is_video}}{/literal}<span class="icon-[tabler--video] size-7" aria-hidden="true"></span>{literal}{{/is_video}}{/literal}
              {literal}{{#is_audio}}{/literal}<span class="icon-[tabler--phone] size-7" aria-hidden="true"></span>{literal}{{/is_audio}}{/literal}
            </span>
            {__("Accept")}
          </button>
        {else}
          <button type="button" class="js_chat-call-cancel flex flex-col items-center gap-2 text-xs font-medium text-white/80 transition hover:scale-105" data-overlay="#modal" hidden>
            <span class="heroui button button--danger button--icon-only rounded-full pointer-events-none size-16 shadow-lg shadow-error/30"><span class="icon-[tabler--phone-off] size-7" aria-hidden="true"></span></span>
            {__("Cancel")}
          </button>
          <button type="button" class="js_chat-call-close flex flex-col items-center gap-2 text-xs font-medium text-white/80 transition hover:scale-105" data-overlay="#modal" hidden>
            <span class="heroui button button--tertiary button--icon-only rounded-full pointer-events-none size-16 border-0 bg-white/15 text-white shadow-none"><span class="icon-[tabler--x] size-7" aria-hidden="true"></span></span>
            {__("Close")}
          </button>
        {/if}
      </div>
    </div>

    <div class="js_call-controls" hidden>
      <div class="mx-auto flex w-fit items-center gap-2 rounded-full bg-white/10 p-2 shadow-2xl ring-1 ring-white/10 backdrop-blur-xl sm:gap-3">
        <button type="button" class="js_call-mic group/btn heroui button button--tertiary button--lg button--icon-only size-12 rounded-full border-0 bg-white/15 text-white shadow-none hover:bg-white/25 aria-pressed:bg-white aria-pressed:text-neutral-900 aria-pressed:hover:bg-white/90" aria-pressed="false" title="{__("Microphone")}" aria-label="{__("Microphone")}">
          <span class="icon-[tabler--microphone] size-6 group-aria-pressed/btn:hidden" aria-hidden="true"></span>
          <span class="icon-[tabler--microphone-off] hidden size-6 group-aria-pressed/btn:block" aria-hidden="true"></span>
        </button>
        <button type="button" class="js_chat-call-end heroui button button--danger button--lg h-14 rounded-full px-6 shadow-lg shadow-error/30" title="{__("End")}" aria-label="{__("End")}">
          <span class="icon-[tabler--phone-off] size-6" aria-hidden="true"></span>
          <span class="max-sm:hidden">{__("End")}</span>
        </button>
        {literal}{{#is_video}}{/literal}
        <button type="button" class="js_call-camera group/btn heroui button button--tertiary button--lg button--icon-only size-12 rounded-full border-0 bg-white/15 text-white shadow-none hover:bg-white/25 aria-pressed:bg-white aria-pressed:text-neutral-900 aria-pressed:hover:bg-white/90" aria-pressed="false" title="{__("Camera")}" aria-label="{__("Camera")}">
          <span class="icon-[tabler--video] size-6 group-aria-pressed/btn:hidden" aria-hidden="true"></span>
          <span class="icon-[tabler--video-off] hidden size-6 group-aria-pressed/btn:block" aria-hidden="true"></span>
        </button>
        {literal}{{/is_video}}{/literal}
        <button type="button" class="js_call-fullscreen group/btn heroui button button--tertiary button--lg button--icon-only size-12 rounded-full border-0 bg-white/15 text-white shadow-none hover:bg-white/25" aria-pressed="false" title="{__("Full Screen")}" aria-label="{__("Full Screen")}">
          <span class="icon-[tabler--maximize] size-6 group-aria-pressed/btn:hidden" aria-hidden="true"></span>
          <span class="icon-[tabler--minimize] hidden size-6 group-aria-pressed/btn:block" aria-hidden="true"></span>
        </button>
      </div>
    </div>
  </div>
  <!-- call buttons -->
</div>
