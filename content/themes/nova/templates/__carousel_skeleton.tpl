<!-- skeleton -->
{if $_type == "daytime"}
  <div class="flex animate-pulse items-start gap-3 rounded-box bg-base-100 p-3 shadow-surface sm:p-4 dark:shadow-none [.daytime\_message~&]:hidden" aria-hidden="true">
    <span class="mt-0.5 block size-10 shrink-0 rounded-full bg-base-content/10"></span>
    <div class="flex min-w-0 grow flex-col gap-2.5 py-1">
      <span class="block h-3.5 w-48 max-w-full rounded-full bg-base-content/10"></span>
      <span class="block h-3 w-3/4 rounded-full bg-base-content/10"></span>
    </div>
  </div>
{else}
  <div class="hidden animate-pulse overflow-hidden peer-[.opacity-0]:flex" aria-hidden="true">
    {if $_type == "movies" || $_type == "games"}
      {for $_i=1 to 5}
        <div class="shrink-0 pe-4 {if $_type == "movies"}w-1/2 sm:w-1/3 md:w-1/4 xl:w-1/5{else}w-full sm:w-1/2 md:w-1/3 xl:w-1/4{/if}">
          <span class="block {if $_type == "movies"}aspect-[2/3]{else}aspect-[16/10]{/if} w-full rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-content/10"></span>
          <span class="mt-3 flex h-[22px] items-center"><span class="block h-3.5 w-3/4 rounded-full bg-base-content/10"></span></span>
          <span class="mt-1 flex h-5 items-center"><span class="block h-3 w-1/2 rounded-full bg-base-content/10"></span></span>
        </div>
      {/for}
    {elseif $_type == "post"}
      <div class="w-full shrink-0 px-1">
        <div class="rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-4 shadow-surface dark:shadow-none">
          <div class="flex items-center gap-3">
            <span class="block size-11 shrink-0 rounded-full bg-base-content/10"></span>
            <div class="flex min-w-0 grow flex-col gap-2">
              <span class="block h-3.5 w-40 max-w-full rounded-full bg-base-content/10"></span>
              <span class="block h-3 w-24 rounded-full bg-base-content/10"></span>
            </div>
          </div>
          <div class="mt-4 flex flex-col gap-2.5">
            <span class="block h-3 w-full rounded-full bg-base-content/10"></span>
            <span class="block h-3 w-11/12 rounded-full bg-base-content/10"></span>
            <span class="block h-3 w-2/3 rounded-full bg-base-content/10"></span>
          </div>
          <span class="mt-4 block aspect-[2/1] w-full rounded-box bg-base-content/10"></span>
          <div class="mt-4 flex items-center justify-around border-t border-base-content/10 pt-3.5 pb-0.5">
            <span class="block h-4 w-16 rounded-full bg-base-content/10"></span>
            <span class="block h-4 w-20 rounded-full bg-base-content/10"></span>
            <span class="block h-4 w-16 rounded-full bg-base-content/10"></span>
          </div>
        </div>
      </div>
    {elseif $_type == "promoted"}
      {for $_i=1 to 6}
        <div class="w-1/3 shrink-0 px-1.5 py-1 sm:w-1/4 md:w-1/5 lg:w-1/6 xl:w-1/3">
          <span class="block aspect-square w-full rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] border border-white/60 bg-base-100/45 dark:border-white/10 dark:bg-white/5"></span>
        </div>
      {/for}
    {else}
      <div class="flex w-full shrink-0 flex-col rounded-[1.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[2.25rem] bg-[#F9F9F9] dark:bg-base-200 p-2">
        <span class="block {$_media} w-full rounded-[1.375rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.875rem] bg-base-content/10"></span>
        <div class="flex flex-col gap-2.5 px-3 {if !$_avatar}pt-4{/if}">
          {if $_avatar}
            <span class="-mt-8 mb-1 block size-16 rounded-2xl bg-base-300 ring-4 ring-[#F9F9F9] dark:ring-base-200"></span>
          {/if}
          <span class="block h-4 w-2/3 rounded-full bg-base-content/10"></span>
          <span class="block h-3 w-2/5 rounded-full bg-base-content/10"></span>
          <span class="mt-1 block h-3 w-full rounded-full bg-base-content/10"></span>
          <span class="block h-3 w-4/5 rounded-full bg-base-content/10"></span>
        </div>
        {if $_footer == "author"}
          <div class="flex items-center gap-2 px-3 pb-2 pt-4">
            <span class="block size-8 shrink-0 rounded-full bg-base-content/10"></span>
            <span class="block h-3 w-24 rounded-full bg-base-content/10"></span>
            <span class="ms-auto block h-3 w-8 rounded-full bg-base-content/10"></span>
          </div>
        {else}
          <div class="px-1 pb-1 pt-4">
            <span class="block h-8 w-full rounded-full bg-base-content/10"></span>
          </div>
        {/if}
      </div>
    {/if}
  </div>
{/if}
<!-- skeleton -->
