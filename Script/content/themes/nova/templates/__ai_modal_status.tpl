{if $system['ai_mode'] == 'sandbox'}
  <!-- sandbox -->
  <div class="flex items-start gap-2.5 rounded-box bg-warning/10 px-3 py-2.5 text-sm" role="alert">
    <span class="icon-[tabler--flask] mt-0.5 size-4 shrink-0 text-warning" aria-hidden="true"></span>
    <p class="min-w-0 leading-5 text-base-content/75"><span class="font-semibold text-base-content">{__("Attention")}:</span> {__("AI Sandbox Mode enabled. This will simulate AI responses without contacting live APIs")}</p>
  </div>
  <!-- sandbox -->
{/if}
{if ($_type == "image" && $system['ai_image_credit_enabled']) || ($_type == "text" && $system['ai_text_credit_enabled'])}
  <!-- credits -->
  <div class="flex items-center gap-3 rounded-box border border-base-content/10 p-3">
    <span class="flex size-10 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-linear-to-br from-primary to-fuchsia-500 text-white shadow-sm" aria-hidden="true"><span class="icon-[tabler--coins] size-5"></span></span>
    <div class="min-w-0 flex-1">
      <p class="truncate text-sm font-semibold text-base-content"><span class="js_ai-credits-balance">{$user->_data['user_ai_credits_balance']}</span> {__("Credits")}</p>
      <p class="truncate text-xs text-base-content/60">
        {__("Remaining")}:
        {if $_type == "image"}
          <span class="js_ai-images-balance font-semibold text-primary">{floor($user->_data['user_ai_credits_balance']/$system['ai_generated_image_cost'])}</span> {__("Images")}
        {else}
          <span class="js_ai-words-balance font-semibold text-primary">{floor($user->_data['user_ai_credits_balance']/$system['ai_generated_word_cost'])}</span> {__("Words")}
        {/if}
      </p>
    </div>
    <button type="button" class="button button--tertiary button--sm shrink-0 js_modal rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] text-base-100 [--button-bg:var(--color-base-content)] [--button-bg-hover:color-mix(in_oklab,var(--color-base-content)_85%,transparent)] [--button-bg-pressed:color-mix(in_oklab,var(--color-base-content)_85%,transparent)] [--button-fg:var(--color-base-100)]" data-size="large" data-url="#ai-credit" data-options='{ "handle": "{$_handle}", {if $_type == "image"}"is_image"{else}"is_text"{/if}: "true" }'>
      <span class="icon-[tabler--credit-card] size-4" aria-hidden="true"></span>
      {__("Buy Credits")}
    </button>
  </div>
  <!-- credits -->
{/if}
