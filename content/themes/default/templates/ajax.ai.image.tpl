<div class="modal-header">
  <h6 class="modal-title">
    {include file='__svg_icons.tpl' icon="ai_image" class="main-icon mr10" width="24px" height="24px"}
    {__("Generate Image")}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form class="js_ai-generate-image js_publisher-extender">
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
      {if $system['ai_image_credit_enabled']}
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
            <div class="d-flex justify-content-center mt10">
              <button class="btn btn-md btn-dark w-100" data-toggle="modal" data-size="large" data-url="#ai-credit" data-options='{ "handle": "image", "is_image": "true" }'>
                <i class="fa fa-credit-card fa-fw mr5"></i>{__("Buy Credits")}
              </button>
            </div>
          </div>
        </div>
      {/if}
      <div class="col-12 {if $system['ai_image_credit_enabled']}col-md-7{/if}">
        {if $system['ai_image_credit_enabled']}
          <!-- images balance -->
          <div class="bs-callout bs-callout-warning mt0">
            {__("Remaining")}: <span class="badge badge-sm bg-light text-primary js_ai-images-balance">{floor($user->_data['user_ai_credits_balance']/$system['ai_generated_image_cost'])}</span> {__("Images")}
          </div>
          <!-- images balance -->
        {/if}
        <!-- prompt -->
        <div class="form-group">
          <label class="form-label">{__("Prompt")}</label>
          <textarea class="form-control" name="prompt" rows="3" placeholder="{__("Describe your image, e.g. 'A beautiful sunset over a calm ocean'")}"></textarea>
        </div>
        <!-- prompt -->
        <!-- image size -->
        <div class="form-group">
          <label class="form-label">{__("Image Size")}</label>
          <select class="form-control" name="image_size">
            <option value="auto">{__("Auto")}</option>
            <option value="1024x1024">{__("1024x1024")}</option>
            <option value="1024x1536">{__("1024x1536")}</option>
            <option value="1536x1024">{__("1536x1024")}</option>
          </select>
          {if $system['ai_image_credit_enabled']}
            <div class="form-text">
              {__("Each image costs")} {$system['ai_generated_image_cost']} {__("credits")}
            </div>
          {/if}
        </div>
        <!-- image size -->
        <!-- generated image -->
        <div class="js_ai-generated-image-container x-hidden">
          <div class="divider"></div>
          <div class="form-group">
            <label class="form-label">{__("Generated Image")}</label>
            <div>
              <img class="img-thumbnail js_ai-generated-image" src="" width="120px">
            </div>
          </div>
        </div>
        <!-- generated image -->
        <!-- error -->
        <div class="alert alert-danger mb0 mt10 x-hidden"></div>
        <!-- error -->
      </div>
    </div>
  </div>
  <div class="modal-footer">
    <input type="hidden" name="handle" value="image">
    <button type="button" class="btn bg-gradient-primary js_ai-use-generated-image x-hidden">
      {include file='__svg_icons.tpl' icon="ai" class="white-icon mr5" width="16px" height="16px"}
      {__("Use Generated Image")}
    </button>
    <button type="submit" class="btn btn-dark">
      {__("Generate")}
    </button>
  </div>
</form>