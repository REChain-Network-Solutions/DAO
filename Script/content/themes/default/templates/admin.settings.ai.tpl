<!-- card-header -->
<div class="card-header with-icon with-nav">
  <!-- panel title -->
  <div class="mb20">
    <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("AI")}
  </div>
  <!-- panel title -->

  <!-- panel nav -->
  <ul class="nav nav-tabs">
    <li class="nav-item">
      <a class="nav-link active" href="#General" data-bs-toggle="tab">
        <i class="fa-solid fa-cog fa-fw mr5"></i><strong>{__("General")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#APIs" data-bs-toggle="tab">
        <i class="fa-solid fa-code fa-fw mr5"></i><strong>{__("AI APIs")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#Credit" data-bs-toggle="tab">
        <i class="fa-solid fa-coins fa-fw mr5"></i><strong>{__("AI Credit")}</strong>
      </a>
    </li>
  </ul>
  <!-- panel nav -->
</div>
<!-- card-header -->

<!-- tab-content -->
<div class="tab-content">
  <!-- General -->
  <div class="tab-pane active" id="General">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=ai_settings">
      <div class="card-body">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("AI Mode")}
          </label>
          <div class="col-md-9">
            <div class="form-check form-check-inline">
              <input type="radio" name="ai_mode" id="ai_mode_live" value="live" class="form-check-input" {if $system['ai_mode'] == "live"}checked{/if}>
              <label class="form-check-label" for="ai_mode_live">{__("Live")}</label>
            </div>
            <div class="form-check form-check-inline">
              <input type="radio" name="ai_mode" id="ai_mode_sandbox" value="sandbox" class="form-check-input" {if $system['ai_mode'] == "sandbox"}checked{/if}>
              <label class="form-check-label" for="ai_mode_sandbox">{__("Sandbox")}</label>
            </div>
            <div class="form-text">
              {__("AI Sandbox Mode will simulate AI responses without contacting live APIs")}<br>
              {__("This is intended for testing and demonstration purposes only")}
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="ai_post" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("AI Posts")}</div>
            <div class="form-text d-none d-sm-block">{__("Allow users to generate posts using AI")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="ai_posts_enabled">
              <input type="checkbox" name="ai_posts_enabled" id="ai_posts_enabled" {if $system['ai_posts_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("AI Posts Provider")}
          </label>
          <div class="col-md-9">
            <div>
              <!-- OpenAI -->
              <input class="x-hidden input-label" type="radio" name="ai_posts_provider" value="openai" id="ai_posts_openai" {if $system['ai_posts_provider'] == "openai"}checked{/if} />
              <label class="button-label" for="ai_posts_openai">
                <div class="icon">
                  {include file='__svg_icons.tpl' icon="openai" width="32px" height="32px"}
                </div>
                <div class="title">{__("OpenAI")}</div>
              </label>
              <!-- OpenAI -->
            </div>
            <div class="form-text">
              {__("Select your default AI posts provider")}<br />
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="ai_blog" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("AI Blogs")}</div>
            <div class="form-text d-none d-sm-block">{__("Allow users to generate blogs using AI")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="ai_blogs_enabled">
              <input type="checkbox" name="ai_blogs_enabled" id="ai_blogs_enabled" {if $system['ai_blogs_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("AI Blogs Provider")}
          </label>
          <div class="col-md-9">
            <div>
              <!-- OpenAI -->
              <input class="x-hidden input-label" type="radio" name="ai_blogs_provider" value="openai" id="ai_blogs_openai" {if $system['ai_blogs_provider'] == "openai"}checked{/if} />
              <label class="button-label" for="ai_blogs_openai">
                <div class="icon">
                  {include file='__svg_icons.tpl' icon="openai" width="32px" height="32px"}
                </div>
                <div class="title">{__("OpenAI")}</div>
              </label>
              <!-- OpenAI -->
            </div>
            <div class="form-text">
              {__("Select your default AI blogs provider")}<br />
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="ai_image" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("AI Images")}</div>
            <div class="form-text d-none d-sm-block">{__("Allow users to generate images using AI")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="ai_images_enabled">
              <input type="checkbox" name="ai_images_enabled" id="ai_images_enabled" {if $system['ai_images_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("AI Images Provider")}
          </label>
          <div class="col-md-9">
            <div>
              <!-- OpenAI -->
              <input class="x-hidden input-label" type="radio" name="ai_images_provider" value="openai" id="ai_images_openai" {if $system['ai_images_provider'] == "openai"}checked{/if} />
              <label class="button-label" for="ai_images_openai">
                <div class="icon">
                  {include file='__svg_icons.tpl' icon="openai" width="32px" height="32px"}
                </div>
                <div class="title">{__("OpenAI")}</div>
              </label>
              <!-- OpenAI -->
              <!-- Replicate -->
              <input class="x-hidden input-label" type="radio" name="ai_images_provider" value="replicate" id="ai_images_replicate" {if $system['ai_images_provider'] == "replicate"}checked{/if} />
              <label class="button-label" for="ai_images_replicate">
                <div class="icon">
                  {include file='__svg_icons.tpl' icon="replicate" width="52px" height="32px"}
                </div>
                <div class="title">{__("Replicate")}</div>
              </label>
              <!-- Replicate -->
            </div>
            <div class="form-text">
              {__("Select your default AI images provider")}<br />
            </div>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </div>
      <div class="card-footer text-end">
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>
  </div>
  <!-- General -->

  <!-- AI APIs -->
  <div class="tab-pane" id="APIs">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=ai_apis">
      <div class="card-body">
        <div class="heading-small mb20">
          {__("OpenAI API")}
        </div>
        <div class="pl-md-4">
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("OpenAI API Key")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="openai_api_key" value="{$system['openai_api_key']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("OpenAI Text Model")}
            </label>
            <div class="col-md-9">
              <select class="form-control" name="openai_text_model">
                <option value="gpt-5.4-pro" {if $system['openai_text_model'] == "gpt-5.4-pro"}selected{/if}>{__("gpt-5.4-pro")}</option>
                <option value="gpt-5.4" {if $system['openai_text_model'] == "gpt-5.4"}selected{/if}>{__("gpt-5.4")}</option>
                <option value="gpt-5.4-mini" {if $system['openai_text_model'] == "gpt-5.4-mini"}selected{/if}>{__("gpt-5.4-mini")}</option>
                <option value="gpt-5.4-nano" {if $system['openai_text_model'] == "gpt-5.4-nano"}selected{/if}>{__("gpt-5.4-nano")}</option>
                <option value="gpt-5-mini" {if $system['openai_text_model'] == "gpt-5-mini"}selected{/if}>{__("gpt-5-mini")}</option>
                <option value="gpt-5-nano" {if $system['openai_text_model'] == "gpt-5-nano"}selected{/if}>{__("gpt-5-nano")}</option>
                <option value="gpt-5" {if $system['openai_text_model'] == "gpt-5"}selected{/if}>{__("gpt-5")}</option>
                <option value="gpt-4.1" {if $system['openai_text_model'] == "gpt-5"}selected{/if}>{__("gpt-gpt-4.1")}</option>
              </select>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("OpenAI Image Model")}
            </label>
            <div class="col-md-9">
              <select class="form-control" name="openai_image_model">
                <option value="gpt-image-1.5" {if $system['openai_image_model'] == "gpt-image-1.5"}selected{/if}>{__("gpt-image-1.5")}</option>
                <option value="chatgpt-image-latest" {if $system['openai_image_model'] == "chatgpt-image-latest"}selected{/if}>{__("chatgpt-image-latest")}</option>
                <option value="gpt-image-1" {if $system['openai_image_model'] == "gpt-image-1"}selected{/if}>{__("gpt-image-1")}</option>
              </select>
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="heading-small mb20">
          {__("Replicate API")}
        </div>
        <div class="pl-md-4">

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Replicate API Token")}
            </label>
            <div class="col-md-9">
              {if !$user->_data['user_demo']}
                <input type="text" class="form-control" name="replicate_api_token" value="{$system['replicate_api_token']}">
              {else}
                <input type="password" class="form-control" value="*********">
              {/if}
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Replicate Model")}
            </label>
            <div class="col-md-9">
              <select class="form-control" name="replicate_model">
                <option value="black-forest-labs/flux-2-max" {if $system['replicate_model'] == "black-forest-labs/flux-2-max"}selected{/if}>black-forest-labs/flux-2-max</option>
                <option value="black-forest-labs/flux-2-pro" {if $system['replicate_model'] == "black-forest-labs/flux-2-pro"}selected{/if}>black-forest-labs/flux-2-pro</option>
                <option value="black-forest-labs/flux-2-flex" {if $system['replicate_model'] == "black-forest-labs/flux-2-flex"}selected{/if}>black-forest-labs/flux-2-flex</option>
                <option value="bytedance/seedream-4" {if $system['replicate_model'] == "bytedance/seedream-4"}selected{/if}>bytedance/seedream-4</option>
                <option value="prunaai/hidream-l1-fast" {if $system['replicate_model'] == "prunaai/hidream-l1-fast"}selected{/if}>prunaai/hidream-l1-fast</option>
                <option value="xai/grok-imagine-image" {if $system['replicate_model'] == "xai/grok-imagine-image"}selected{/if}>xai/grok-imagine-image</option>
                <option value="qwen/qwen-image" {if $system['replicate_model'] == "qwen/qwen-image"}selected{/if}>qwen/qwen-image</option>
              </select>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Denoising Steps")}
            </label>
            <div class="col-md-9">
              <input type="text" class="form-control" name="replicate_denoising_steps" value="{$system['replicate_denoising_steps']}">
              <div class="form-text">
                {__("Number of denoising steps (Minimum: 1; Maximum: 500)")}
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Guidance Scale")}
            </label>
            <div class="col-md-9">
              <input type="text" class="form-control" name="replicate_guidance_scale" value="{$system['replicate_guidance_scale']}">
              <div class="form-text">
                {__("Guidance scale (Minimum: 1; Maximum: 20)")}
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Seed")}
            </label>
            <div class="col-md-9">
              <input type="text" class="form-control" name="replicate_seed" value="{$system['replicate_seed']}">
              <div class="form-text">
                {__("Seed (Minimum: 0; Maximum: 4294967295), Leave blank to randomize the seed")}
              </div>
            </div>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </div>
      <div class="card-footer text-end">
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>
  </div>
  <!-- AI APIs -->

  <!-- AI Credit -->
  <div class="tab-pane" id="Credit">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=ai_credit">
      <div class="card-body">
        <div class="heading-small mb20">
          {__("AI Credit System")}
        </div>
        <div class="pl-md-4">
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("AI Credit")}/{print_money("1.00")}
            </label>
            <div class="col-md-9">
              <input type="text" class="form-control" name="ai_credit_cost" value="{$system['ai_credit_cost']}">
              <div class="form-text">
                {__("How much AI credits eqaul to")} {print_money("1")}<br>
                {__("Make sure you have configured")} <a href="{$system['system_url']}/{$control_panel['url']}/wallet">{__("Wallet System")}</a>
              </div>
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="heading-small mb20">
          {__("AI Text Credit")}
        </div>
        <div class="pl-md-4">
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="points" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("AI Text Credit")}</div>
              <div class="form-text d-none d-sm-block">
                {__("Turn the AI text credit system On and Off")}
              </div>
            </div>
            <div class="text-end">
              <label class="switch" for="ai_text_credit_enabled">
                <input type="checkbox" name="ai_text_credit_enabled" id="ai_text_credit_enabled" {if $system['ai_text_credit_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Generated Word Cost")}
            </label>
            <div class="col-md-9">
              <input type="text" class="form-control" name="ai_generated_word_cost" value="{$system['ai_generated_word_cost']}">
              <div class="form-text">
                {__("The cost of a generated word (in credits)")}
              </div>
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="heading-small mb20">
          {__("AI Image Credit")}
        </div>
        <div class="pl-md-4">
          <div class="form-table-row">
            <div class="avatar">
              {include file='__svg_icons.tpl' icon="points" class="main-icon" width="40px" height="40px"}
            </div>
            <div>
              <div class="form-label h6">{__("AI Image Credit")}</div>
              <div class="form-text d-none d-sm-block">
                {__("Turn the AI images credit system On and Off")}
              </div>
            </div>
            <div class="text-end">
              <label class="switch" for="ai_image_credit_enabled">
                <input type="checkbox" name="ai_image_credit_enabled" id="ai_image_credit_enabled" {if $system['ai_image_credit_enabled']}checked{/if}>
                <span class="slider round"></span>
              </label>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Generated Image Cost")}
            </label>
            <div class="col-md-9">
              <input type="text" class="form-control" name="ai_generated_image_cost" value="{$system['ai_generated_image_cost']}">
              <div class="form-text">
                {__("The cost of a generated image (in credits)")}
              </div>
            </div>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </div>
      <div class="card-footer text-end">
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>
  </div>
  <!-- AI Credit -->
</div>