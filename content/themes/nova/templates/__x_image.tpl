{if !$_x_handle}{assign var="_x_handle" value="x-image"}{/if}
{if $_x_handle == "x-image" && $_x_value}{if $_x_preview}{assign var="_x_image_preview" value=$_x_preview}{else}{assign var="_x_image_preview" value="`$system['system_uploads']`/`$_x_value`"}{/if}{else}{assign var="_x_image_preview" value=""}{/if}
<div class="x-image relative flex shrink-0 items-center justify-center overflow-hidden rounded-box border border-dashed border-base-300 bg-base-200 {if $_x_fit == "contain"}bg-contain{else}bg-cover{/if} bg-center bg-no-repeat transition-colors hover:border-primary/50 focus-within:border-primary {if $_x_class}{$_x_class}{else}size-28{/if} [&>.x-uploader]:absolute [&>.x-uploader]:inset-0 [&>.x-uploader]:z-10 [&>.x-uploader]:flex [&>.x-uploader]:items-center [&>.x-uploader]:justify-center [&>.x-uploader>input[type=file]]:absolute [&>.x-uploader>input[type=file]]:inset-0 [&>.x-uploader>input[type=file]]:size-full [&>.x-uploader>input[type=file]]:cursor-pointer [&>.x-uploader>input[type=file]]:opacity-0" {if $_x_label}role="group" aria-label="{$_x_label}"{/if} {if $_x_image_preview}style="background-image: url('{$_x_image_preview}');"{/if}>
  <span class="js_x-uploader pointer-events-none flex size-10 items-center justify-center rounded-full bg-base-100/90 text-base-content/70 shadow-sm" data-handle="{$_x_handle}" {if $_x_type}data-type="{$_x_type}"{/if} {if $_x_blur}data-blur="true"{/if}>
    <span class="{if $_x_handle == "x-image"}icon-[tabler--camera-plus]{else}icon-[tabler--upload]{/if} size-5" aria-hidden="true"></span>
  </span>
  {if $_x_handle != "x-image"}
    <span class="x-image-success {if !$_x_value}hidden {/if}pointer-events-none absolute inset-x-2 bottom-2 z-20 [&:not(.hidden)]:inline-flex items-center justify-center gap-1 truncate rounded-full bg-success px-2 py-0.5 text-xs font-medium text-success-content" title='{__("Uploaded Successfully")}'>
      <span class="icon-[tabler--circle-check-filled] size-3.5 shrink-0" aria-hidden="true"></span>
      <span class="truncate">{__("Uploaded Successfully")}</span>
    </span>
  {/if}
  <div class="x-image-loader absolute inset-0 z-20 hidden items-center justify-center bg-base-100/95 px-3 [&:not(.hidden)]:flex">
    <div class="flex w-full max-w-48 flex-col gap-1.5">
      <div class="flex items-center justify-between gap-2 text-xs font-medium">
        <span class="js_x-image-status min-w-0 truncate animate-shimmer [animation-duration:3s] bg-[linear-gradient(90deg,var(--color-base-content)_0%,var(--color-base-content)_12%,var(--color-base-300)_25%,var(--color-base-content)_38%,var(--color-base-content)_62%,var(--color-base-300)_75%,var(--color-base-content)_88%,var(--color-base-content)_100%)] bg-size-[200%_100%] bg-clip-text text-transparent motion-reduce:animate-none" role="status"></span>
        <span class="js_x-image-percent shrink-0 tabular-nums text-base-content"></span>
      </div>
      <div class="js_x-image-progress progress h-1.5 w-full bg-base-300" role="progressbar" aria-label='{__("Upload progress")}' aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
        <div class="js_x-image-bar progress-bar progress-primary transition-[width] duration-200 motion-reduce:transition-none" style="width: 0%"></div>
      </div>
    </div>
  </div>
  <button type="button" class="{if $_x_handle == "x-video"}js_x-video-remover{else}js_x-image-remover{/if} heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full absolute end-1.5 top-1.5 z-30 border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100 {if !$_x_value}hidden{/if}" title='{__("Remove")}' aria-label='{__("Remove")}'>
    <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
  </button>
  <input type="hidden" class="js_x-uploader-input" name="{$_x_name}" value="{$_x_value}" {if $_x_input_id}id="{$_x_input_id}"{/if}>
</div>
