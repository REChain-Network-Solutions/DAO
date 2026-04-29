<div class="modal-header">
  <h6 class="modal-title">
    {include file='__svg_icons.tpl' icon="ai_post" class="main-icon mr10" width="24px" height="24px"}
    {__("Generate Post")}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form class="js_ai-generate-text js_publisher-extender">
  <div class="modal-body">
    {if $system['ai_mode'] == 'sandbox'}
      <div class="alert alert-warning">
        <div class="icon">
          <i class="fa fa-exclamation-triangle fa-2x"></i>
        </div>
        <div class="text">
          <strong>{__("Attention")}</strong><br>
          {__("AI Sandbox Mode enabled. This will simulate AI responses without contacting live APIs")}
        </div>
      </div>
    {/if}
    <div class="row">
      {if $system['ai_text_credit_enabled']}
        <div class="col-12 col-md-5">
          <div class="card-balance">
            <p>
              {__("Available Credits")}
            </p>
            <p class="card-balance-value text-primary">
              <span class="js_ai-credits-balance">{$user->_data['user_ai_credits_balance']}</span>
            </p>
            <p>
              {__("Credits")}
            </p>
            <div class="d-flex justify-content-center mt20">
              <button class="btn btn-md btn-dark w-100" data-toggle="modal" data-size="large" data-url="#ai-credit" data-options='{ "handle": "post", "is_text": "true" }'>
                <i class="fa fa-credit-card fa-fw mr5"></i>{__("Buy Credits")}
              </button>
            </div>
          </div>
        </div>
      {/if}
      <div class="col-12 {if $system['ai_text_credit_enabled']}col-md-7{/if}">
        {if $system['ai_text_credit_enabled']}
          <!-- words balance -->
          <div class="bs-callout bs-callout-warning mt0">
            {__("Remaining")}: <span class="badge badge-sm bg-light text-primary js_ai-words-balance">{floor($user->_data['user_ai_credits_balance']/$system['ai_generated_word_cost'])}</span> {__("Words")}
          </div>
          <!-- words balance -->
        {/if}
        <!-- prompt -->
        <div class="form-group">
          <label class="form-label">{__("Prompt")}</label>
          <textarea class="form-control" name="prompt" rows="3" placeholder="{__("Describe your post, e.g. 'Tell me a joke'")}"></textarea>
        </div>
        <!-- prompt -->
        <!-- max result length -->
        <div class="form-group">
          <label class="form-label">{__("Max Result Length")}</label>
          <input type="number" class="form-control" name="max_result_length">
          {if $system['ai_text_credit_enabled']}
            <div class="form-text">
              {__("Each word costs")} {$system['ai_generated_word_cost']} {__("credits")}
            </div>
          {/if}
        </div>
        <!-- max result length -->
        <!-- generated text -->
        <div class="js_ai-generated-text-container x-hidden">
          <div class="divider"></div>
          <div class="form-group">
            <label class="form-label">{__("Generated Text")}</label>
            <textarea class="form-control js_ai-generated-text" name="generated_text" rows="3" readonly></textarea>
          </div>
        </div>
        <!-- generated text -->
        <!-- error -->
        <div class="alert alert-danger mb0 mt10 x-hidden"></div>
        <!-- error -->
      </div>
    </div>
  </div>
  <div class="modal-footer">
    <input type="hidden" name="handle" value="post">
    <button type="button" class="btn bg-gradient-primary js_ai-use-generated-text x-hidden" data-handle="post">
      {include file='__svg_icons.tpl' icon="ai" class="white-icon mr5" width="16px" height="16px"}
      {__("Use Generated Text")}
    </button>
    <button type="submit" class="btn btn-dark" onclick="event.stopPropagation();">
      {__("Generate")}
    </button>
  </div>
</form>