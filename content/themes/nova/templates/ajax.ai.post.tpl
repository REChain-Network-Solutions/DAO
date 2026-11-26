{include file='__modal_header.tpl' _icon="icon-[tabler--sparkles]" _title=__("Generate Post")}
<form class="group js_ai-generate-text js_publisher-extender">
  <div class="modal__body flex flex-col gap-4">
    {include file='__ai_modal_status.tpl' _handle="post" _type="text"}
    <!-- prompt -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="ai-post-prompt">{__("Prompt")}</label>
      <textarea class="textarea w-full resize-none [--border:1px]" name="prompt" rows="3" placeholder="{__("Describe your post, e.g. 'Tell me a joke'")}" id="ai-post-prompt"></textarea>
    </div>
    <!-- prompt -->
    <!-- max result length -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="ai-post-max-result-length">{__("Max Result Length")}</label>
      <div class="flex flex-col gap-1.5 sm:flex-row sm:items-center sm:gap-3">
        <div class="input w-full items-center gap-2 [--border:1px] sm:max-w-44">
          <input type="number" min="1" class="grow" name="max_result_length" id="ai-post-max-result-length">
          <span class="text-base-content/60" aria-hidden="true">{__("Words")}</span>
        </div>
        {if $system['ai_text_credit_enabled']}
          <p class="flex items-center gap-1.5 text-sm text-base-content/60"><span class="icon-[tabler--info-circle] size-4 shrink-0" aria-hidden="true"></span>{__("Each word costs")} {$system['ai_generated_word_cost']} {__("credits")}</p>
        {/if}
      </div>
    </div>
    <!-- max result length -->
    <!-- generated text -->
    <div class="hidden w-full group-data-generated:block">
      <label class="label-text mb-1.5 flex items-center gap-1.5" for="ai-post-generated-text"><span class="icon-[tabler--sparkles] size-4 text-primary" aria-hidden="true"></span>{__("Generated Text")}</label>
      <div class="relative">
        <textarea class="textarea w-full resize-none border-primary/25 bg-primary/5 pe-12 [--border:1px] js_ai-generated-text" name="generated_text" rows="6" id="ai-post-generated-text"></textarea>
        <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-field absolute end-2 top-2 js_clipboard" data-clipboard-target="#ai-post-generated-text" title='{__("Copy")}' aria-label='{__("Copy")}'>
          <span class="js-clipboard-default icon-[tabler--copy] size-4.5" aria-hidden="true"></span>
          <span class="js-clipboard-success icon-[tabler--check] hidden size-4.5 text-success" aria-hidden="true"></span>
        </button>
      </div>
    </div>
    <!-- generated text -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer flex-wrap gap-2">
    <input type="hidden" name="handle" value="post">
    <button type="button" class="button button--tertiary group-data-generated:hidden" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary group-data-generated:hidden" onclick="event.stopPropagation();">
      <span class="icon-[tabler--sparkles] size-4" aria-hidden="true"></span>
      {__("Generate")}
    </button>
    <button type="submit" class="button button--tertiary hidden group-data-generated:inline-flex" onclick="event.stopPropagation();">
      <span class="icon-[tabler--refresh] size-4" aria-hidden="true"></span>
      {__("Regenerate")}
    </button>
    <button type="button" class="button button--primary hidden group-data-generated:inline-flex js_ai-use-generated-text" data-handle="post">
      <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
      {__("Use Generated Text")}
    </button>
  </div>
</form>
