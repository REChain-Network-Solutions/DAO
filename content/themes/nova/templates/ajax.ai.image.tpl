{include file='__modal_header.tpl' _icon="icon-[tabler--photo-ai]" _title=__("Generate Image")}
<form class="group js_ai-generate-image js_publisher-extender">
  <div class="modal__body flex flex-col gap-4">
    {include file='__ai_modal_status.tpl' _handle="image" _type="image"}
    <!-- prompt -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="ai-image-prompt">{__("Prompt")}</label>
      <textarea class="textarea w-full resize-none [--border:1px]" name="prompt" rows="3" placeholder="{__("Describe your image, e.g. 'A beautiful sunset over a calm ocean'")}" id="ai-image-prompt"></textarea>
    </div>
    <!-- prompt -->
    <!-- image size -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Image Size")}</span>
      <div class="grid grid-cols-2 gap-2 sm:grid-cols-4">
        <label class="flex cursor-pointer flex-col items-center justify-center gap-2 rounded-field border border-base-content/10 px-2 py-3 text-xs font-medium text-base-content/70 transition-colors hover:border-primary/40 has-checked:border-primary has-checked:bg-primary/5 has-checked:text-primary">
          <input type="radio" class="sr-only" name="image_size" value="auto" checked>
          <span class="flex h-6 items-center" aria-hidden="true"><span class="icon-[tabler--wand] size-5"></span></span>{__("Auto")}
        </label>
        <label class="flex cursor-pointer flex-col items-center justify-center gap-2 rounded-field border border-base-content/10 px-2 py-3 text-xs font-medium text-base-content/70 transition-colors hover:border-primary/40 has-checked:border-primary has-checked:bg-primary/5 has-checked:text-primary">
          <input type="radio" class="sr-only" name="image_size" value="1024x1024">
          <span class="flex h-6 items-center" aria-hidden="true"><span class="block size-5 rounded-[3px] border-2 border-current"></span></span>{__("1024x1024")}
        </label>
        <label class="flex cursor-pointer flex-col items-center justify-center gap-2 rounded-field border border-base-content/10 px-2 py-3 text-xs font-medium text-base-content/70 transition-colors hover:border-primary/40 has-checked:border-primary has-checked:bg-primary/5 has-checked:text-primary">
          <input type="radio" class="sr-only" name="image_size" value="1024x1536">
          <span class="flex h-6 items-center" aria-hidden="true"><span class="block h-6 w-4 rounded-[3px] border-2 border-current"></span></span>{__("1024x1536")}
        </label>
        <label class="flex cursor-pointer flex-col items-center justify-center gap-2 rounded-field border border-base-content/10 px-2 py-3 text-xs font-medium text-base-content/70 transition-colors hover:border-primary/40 has-checked:border-primary has-checked:bg-primary/5 has-checked:text-primary">
          <input type="radio" class="sr-only" name="image_size" value="1536x1024">
          <span class="flex h-6 items-center" aria-hidden="true"><span class="block h-4 w-6 rounded-[3px] border-2 border-current"></span></span>{__("1536x1024")}
        </label>
      </div>
      {if $system['ai_image_credit_enabled']}
        <p class="mt-1.5 flex items-center gap-1.5 text-sm text-base-content/60"><span class="icon-[tabler--info-circle] size-4 shrink-0" aria-hidden="true"></span>{__("Each image costs")} {$system['ai_generated_image_cost']} {__("credits")}</p>
      {/if}
    </div>
    <!-- image size -->
    <!-- generated image -->
    <div class="hidden w-full group-data-generated:block">
      <span class="label-text mb-1.5 flex items-center gap-1.5"><span class="icon-[tabler--sparkles] size-4 text-primary" aria-hidden="true"></span>{__("Generated Image")}</span>
      <div class="flex items-center justify-center overflow-hidden rounded-box border border-primary/25 bg-primary/5 p-2">
        <img class="js_ai-generated-image max-h-80 w-auto max-w-full rounded-field object-contain" src="" alt="{__("Generated Image")}">
      </div>
    </div>
    <!-- generated image -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer flex-wrap gap-2">
    <input type="hidden" name="handle" value="image">
    <button type="button" class="button button--tertiary group-data-generated:hidden" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary group-data-generated:hidden">
      <span class="icon-[tabler--sparkles] size-4" aria-hidden="true"></span>
      {__("Generate")}
    </button>
    <button type="submit" class="button button--tertiary hidden group-data-generated:inline-flex">
      <span class="icon-[tabler--refresh] size-4" aria-hidden="true"></span>
      {__("Regenerate")}
    </button>
    <button type="button" class="button button--primary hidden group-data-generated:inline-flex js_ai-use-generated-image">
      <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
      {__("Use Generated Image")}
    </button>
  </div>
</form>
