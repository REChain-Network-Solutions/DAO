<div class="pointer-events-none absolute inset-0 isolate overflow-hidden bg-neutral-950 text-white">
  <img class="absolute inset-0 -z-10 size-full scale-125 object-cover opacity-40 blur-3xl" src="{$_picture}" alt="" aria-hidden="true">
  <div class="absolute inset-0 -z-10 bg-linear-to-b from-black/40 via-black/20 to-black/80" aria-hidden="true"></div>
  <div class="flex size-full flex-col items-center justify-center gap-2 px-4 text-center">
    <div class="relative grid place-items-center{if $_size == "lg"} mb-2{/if}">
      {if $_live}
        <span class="absolute animate-ping rounded-full bg-white/15 [animation-duration:2s]{if $_size == "lg"} size-24 sm:size-28{else} size-16{/if}" aria-hidden="true"></span>
      {/if}
      <img class="relative rounded-full object-cover shadow-2xl ring-4 ring-white/15{if $_size == "lg"} size-24 sm:size-28{else} size-16{/if}" src="{$_picture}" alt="">
    </div>
    {if $_size == "lg"}
      <h3 class="max-w-full truncate text-lg font-semibold tracking-tight sm:text-xl" title="{$_name}">{$_name}</h3>
      {if $_live}
        <span class="inline-flex items-center gap-1.5 rounded-full bg-error px-3 py-1 text-xs font-bold tracking-wider uppercase shadow-lg shadow-error/30">
          <span class="size-1.5 animate-pulse rounded-full bg-current" aria-hidden="true"></span>
          {__("Live")}
        </span>
      {else}
        <span class="text-sm text-white/70">{__("Live Ended")}</span>
      {/if}
    {/if}
  </div>
</div>
