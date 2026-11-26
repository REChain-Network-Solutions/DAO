{include file='__modal_header.tpl' _icon="icon-[tabler--writing]" _title=__("Generate Blog")}
<form class="group js_ai-generate-text">
  <div class="modal__body flex flex-col gap-4">
    {include file='__ai_modal_status.tpl' _handle="blog" _type="text"}
    <!-- prompt -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="ai-blog-prompt">{__("Prompt")}</label>
      <textarea class="textarea w-full resize-none [--border:1px]" name="prompt" rows="3" placeholder="{__("Describe your post, e.g. 'Tell me a joke'")}" id="ai-blog-prompt"></textarea>
    </div>
    <!-- prompt -->
    <!-- max result length -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="ai-blog-max-result-length">{__("Max Result Length")}</label>
      <div class="flex flex-col gap-1.5 sm:flex-row sm:items-center sm:gap-3">
        <div class="input w-full items-center gap-2 [--border:1px] sm:max-w-44">
          <input type="number" min="1" class="grow" name="max_result_length" id="ai-blog-max-result-length">
          <span class="text-base-content/60" aria-hidden="true">{__("Words")}</span>
        </div>
        {if $system['ai_text_credit_enabled']}
          <p class="flex items-center gap-1.5 text-sm text-base-content/60"><span class="icon-[tabler--info-circle] size-4 shrink-0" aria-hidden="true"></span>{__("Each word costs")} {$system['ai_generated_word_cost']} {__("credits")}</p>
        {/if}
      </div>
    </div>
    <!-- max result length -->
    <!-- generated text -->
    <div class="hidden w-full flex-col gap-4 group-data-generated:flex">
      <div class="w-full">
        <label class="label-text mb-1.5 flex items-center gap-1.5" for="ai-blog-generated-title"><span class="icon-[tabler--sparkles] size-4 text-primary" aria-hidden="true"></span>{__("Generated Title")}</label>
        <input type="text" class="input w-full border-primary/25 bg-primary/5 [--border:1px] js_ai-generated-title" name="generated_title" id="ai-blog-generated-title">
      </div>
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="ai-blog-generated-text">{__("Generated Text")}</label>
        <div class="relative">
          <textarea class="textarea w-full resize-none border-primary/25 bg-primary/5 pe-12 [--border:1px] js_ai-generated-text" name="generated_text" rows="6" id="ai-blog-generated-text"></textarea>
          <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-field absolute end-2 top-2 js_clipboard" data-clipboard-target="#ai-blog-generated-text" title='{__("Copy")}' aria-label='{__("Copy")}'>
            <span class="js-clipboard-default icon-[tabler--copy] size-4.5" aria-hidden="true"></span>
            <span class="js-clipboard-success icon-[tabler--check] hidden size-4.5 text-success" aria-hidden="true"></span>
          </button>
        </div>
      </div>
    </div>
    <!-- generated text -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer flex-wrap gap-2">
    <input type="hidden" name="handle" value="blog">
    <button type="button" class="button button--tertiary group-data-generated:hidden" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary group-data-generated:hidden" onclick="event.stopPropagation();">
      <span class="icon-[tabler--sparkles] size-4" aria-hidden="true"></span>
      {__("Generate")}
    </button>
    <button type="submit" class="button button--tertiary hidden group-data-generated:inline-flex" onclick="event.stopPropagation();">
      <span class="icon-[tabler--refresh] size-4" aria-hidden="true"></span>
      {__("Regenerate")}
    </button>
    <button type="button" class="button button--primary hidden group-data-generated:inline-flex js_ai-use-generated-text" data-handle="blog">
      <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
      {__("Use Generated Text")}
    </button>
  </div>
</form>
