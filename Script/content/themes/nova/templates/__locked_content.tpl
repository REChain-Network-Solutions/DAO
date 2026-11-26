<!-- locked content -->
{if $_image}
  <div class="locked-content relative isolate flex {if $_compact}min-h-64{else}min-h-[24rem] sm:min-h-[28rem]{/if} items-end overflow-hidden {if $_framed && !$_preview}rounded-b-box{/if}">
    <img class="absolute inset-0 -z-10 size-full object-cover" src="{$system['system_uploads']}/{$_image}" alt="" loading="lazy">
    <div class="absolute inset-0 -z-10 bg-linear-to-t from-black/85 via-black/45 to-black/10" aria-hidden="true"></div>
    <div class="flex w-full flex-col items-center px-5 pt-10 pb-6 text-center text-white sm:px-8 sm:pb-8 [&_.js\_readmore-toggle]:text-white">
      <span class="flex size-14 items-center justify-center rounded-full bg-white/15 ring-1 ring-white/25 backdrop-blur-md" aria-hidden="true">
        <span class="{$_icon} size-7"></span>
      </span>
      <h3 class="mt-4 text-lg leading-snug font-semibold text-white">{$_title}</h3>
      {if $_meta}
        <p class="mt-1 text-sm text-white/70">{$_meta}</p>
      {/if}
      {if $_text}
        <div class="js_readmore mt-2 max-w-md text-sm leading-relaxed whitespace-pre-line text-white/85" data-lines="3" dir="auto">{$_text}</div>
      {/if}
      {if !is_empty($_cta)}
        <div class="mt-5 flex w-full justify-center">{$_cta}</div>
      {/if}
    </div>
  </div>
{else}
  <div class="locked-content {if $_framed}px-4 {if $_preview}pb-1{else}pb-4{/if}{/if}">
    <div class="overflow-hidden {if $_framed}rounded-box border border-primary/15 bg-linear-to-b from-primary/[0.06] to-primary/[0.02]{/if}">
      <div class="space-y-2 {if $_compact}px-5 pt-5{else}px-6 pt-6{/if} blur-[2px] select-none mask-b-from-20%" aria-hidden="true">
        <div class="h-2 w-11/12 rounded-full bg-base-content/10"></div>
        <div class="h-2 w-full rounded-full bg-base-content/10"></div>
        <div class="h-2 w-9/12 rounded-full bg-base-content/10"></div>
        {if !$_compact}
          <div class="h-2 w-10/12 rounded-full bg-base-content/10"></div>
        {/if}
      </div>
      <div class="flex flex-col items-center text-center {if $_compact}px-5 pt-3 pb-5{else}px-6 pt-4 pb-6{/if}">
        <span class="flex {if $_compact}size-11{else}size-12{/if} items-center justify-center rounded-full bg-primary/10 text-primary ring-4 ring-primary/5" aria-hidden="true">
          <span class="{$_icon} size-6"></span>
        </span>
        <h3 class="mt-3 text-base leading-snug font-semibold text-base-content">{$_title}</h3>
        {if $_meta}
          <p class="mt-0.5 text-xs font-medium tracking-wide text-base-content/50 uppercase">{$_meta}</p>
        {/if}
        {if $_text}
          <div class="js_readmore mt-2 max-w-md text-sm leading-relaxed whitespace-pre-line text-base-content/70" data-lines="3" dir="auto">{$_text}</div>
        {/if}
        {if !is_empty($_cta)}
          <div class="mt-5 flex w-full justify-center">{$_cta}</div>
        {/if}
      </div>
    </div>
  </div>
{/if}
<!-- locked content -->
