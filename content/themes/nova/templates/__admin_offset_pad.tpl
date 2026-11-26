<div class="js_offset-pad flex w-full flex-col gap-2 sm:max-w-48" data-default-x="{$_x_default}" data-default-y="{$_y_default}">
  <input type="hidden" class="js_offset-pad-x-input" name="{$_x_name}" value="{$_x_value}">
  <input type="hidden" class="js_offset-pad-y-input" name="{$_y_name}" value="{$_y_value}">
  <div class="flex items-center justify-between gap-3">
    <div class="flex items-center gap-3 text-sm">
      <span><span class="text-base-content/60">X</span> <span class="ms-1 font-semibold tabular-nums"><span class="js_offset-pad-x">{$_x_value}</span>%</span></span>
      <span><span class="text-base-content/60">Y</span> <span class="ms-1 font-semibold tabular-nums"><span class="js_offset-pad-y">{$_y_value}</span>%</span></span>
    </div>
    <button type="button" class="btn btn-sm btn-circle btn-text js_offset-pad-reset" title='{__("Reset")}' aria-label='{__("Reset")}'>
      <span class="icon-[tabler--refresh] size-4" aria-hidden="true"></span>
    </button>
  </div>
  <div class="js_offset-pad-area relative aspect-[4/3] w-full cursor-move touch-none select-none overflow-hidden rounded-[1.5rem] border border-base-300 bg-base-200 outline-none focus-visible:ring-2 focus-visible:ring-primary" dir="ltr" tabindex="0" role="group" aria-labelledby="{$_labelledby}" aria-describedby="{$_help}">
    <div class="absolute inset-[4%] grid grid-cols-9 grid-rows-7 place-items-center" aria-hidden="true">
      {section name=dot loop=63}
        <span class="size-1 rounded-full bg-base-content/15"></span>
      {/section}
    </div>
    <span class="{if $_mode == "video"}icon-[tabler--movie]{else}icon-[tabler--photo]{/if} absolute inset-0 m-auto size-10 text-base-content/15" aria-hidden="true"></span>
    <span class="js_offset-pad-thumb pointer-events-none absolute flex h-[22%] w-[30%] items-center justify-center overflow-hidden rounded-lg bg-primary/85 p-1 shadow-md ring-2 ring-primary/30" style="left: {$_x_value}%; top: {$_y_value}%; transform: translate(-{$_x_value}%, -{$_y_value}%);" aria-hidden="true">
      {if $_icon}
        <img class="max-h-full max-w-full object-contain" src="{$system['system_uploads']}/{$_icon}" alt="">
      {else}
        <span class="icon-[tabler--droplet] size-4 text-primary-content"></span>
      {/if}
    </span>
  </div>
</div>
