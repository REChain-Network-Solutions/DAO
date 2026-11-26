<section class="admin-settings-page" aria-labelledby="settings-ai-title">
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-ai-title" class="text-2xl font-semibold">{__("AI Settings")}</h1>
    <p class="text-base-content/60 text-sm">{__("AI features, APIs, and credit pricing.")}</p>
  </div>
  <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("AI Settings")}" aria-orientation="vertical">
    <button type="button" id="settings-ai-tab-0" class="tab active-tab:tab-active active" data-tab="#General" aria-controls="General" role="tab" aria-selected="true"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("General")}</button>
    <button type="button" id="settings-ai-tab-1" class="tab active-tab:tab-active" data-tab="#APIs" aria-controls="APIs" role="tab" aria-selected="false"><span class="icon-[tabler--code] size-4" aria-hidden="true"></span>{__("AI APIs")}</button>
    <button type="button" id="settings-ai-tab-2" class="tab active-tab:tab-active" data-tab="#Credit" aria-controls="Credit" role="tab" aria-selected="false"><span class="icon-[tabler--coins] size-4" aria-hidden="true"></span>{__("AI Credit")}</button>
  </nav>
  <div class="admin-settings-panel js_admin-settings-panel" id="General" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=ai_settings">
      <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="ai_mode-label">
                <div class="label-text" id="ai_mode-label">{__("AI Mode")}</div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="ai_mode" id="ai_mode_live" value="live" class="radio radio-primary" {if $system['ai_mode'] == "live"}checked{/if} aria-describedby="ai_mode-help">
                    <label class="label-text" for="ai_mode_live">{__("Live")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="ai_mode" id="ai_mode_sandbox" value="sandbox" class="radio radio-primary" {if $system['ai_mode'] == "sandbox"}checked{/if} aria-describedby="ai_mode-help">
                    <label class="label-text" for="ai_mode_sandbox">{__("Sandbox")}</label>
                  </div>
                  <div class="admin-setting-help text-sm leading-relaxed" id="ai_mode-help">
                    {__("AI Sandbox Mode will simulate AI responses without contacting live APIs")}<br>
                    {__("This is intended for testing and demonstration purposes only")}
                  </div>
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="ai_post" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="ai_posts_enabled">{__("AI Posts")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="ai_posts_enabled-help">{__("Allow users to generate posts using AI")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="ai_posts_enabled" id="ai_posts_enabled" {if $system['ai_posts_enabled']}checked{/if} aria-describedby="ai_posts_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="ai_posts_provider">{__("AI Posts Provider")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="ai_posts_provider" id="ai_posts_provider" aria-describedby="ai_posts_provider-help">
                    <option value="openai" {if $system['ai_posts_provider'] == "openai"}selected{/if}>{__("OpenAI")}</option>
                  </select>
                  <div class="admin-setting-help text-sm leading-relaxed" id="ai_posts_provider-help">{__("Select your default AI posts provider")}</div>
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="ai_blog" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="ai_blogs_enabled">{__("AI Blogs")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="ai_blogs_enabled-help">{__("Allow users to generate blogs using AI")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="ai_blogs_enabled" id="ai_blogs_enabled" {if $system['ai_blogs_enabled']}checked{/if} aria-describedby="ai_blogs_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="ai_blogs_provider">{__("AI Blogs Provider")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="ai_blogs_provider" id="ai_blogs_provider" aria-describedby="ai_blogs_provider-help">
                    <option value="openai" {if $system['ai_blogs_provider'] == "openai"}selected{/if}>{__("OpenAI")}</option>
                  </select>
                  <div class="admin-setting-help text-sm leading-relaxed" id="ai_blogs_provider-help">{__("Select your default AI blogs provider")}</div>
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="ai_image" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="ai_images_enabled">{__("AI Images")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="ai_images_enabled-help">{__("Allow users to generate images using AI")}</div>
                </div>
                <div class="text-end">
                  <input type="checkbox" class="switch switch-primary" name="ai_images_enabled" id="ai_images_enabled" {if $system['ai_images_enabled']}checked{/if} aria-describedby="ai_images_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="ai_images_provider">{__("AI Images Provider")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="ai_images_provider" id="ai_images_provider" aria-describedby="ai_images_provider-help">
                    <option value="openai" {if $system['ai_images_provider'] == "openai"}selected{/if}>{__("OpenAI")}</option>
                    <option value="replicate" {if $system['ai_images_provider'] == "replicate"}selected{/if}>{__("Replicate")}</option>
                  </select>
                  <div class="admin-setting-help text-sm leading-relaxed" id="ai_images_provider-help">{__("Select your default AI images provider")}</div>
                </div>
              </div>
            </div>
            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
              <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
              </div>
              <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
              </div>
            </div>
          </section>
        </div>
      </div>
    </form>
  </div>
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="APIs" role="tabpanel" tabindex="0">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=ai_apis">
      <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
          <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <h3 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("OpenAI API")}</h3>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="openai_api_key">{__("OpenAI API Key")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="openai_api_key" id="openai_api_key" value="{$system['openai_api_key']}">
                  {else}
                    <input type="password" class="input w-full" id="openai_api_key" value="*********">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="openai_text_model">{__("OpenAI Text Model")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="openai_text_model" id="openai_text_model">
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
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="openai_image_model">{__("OpenAI Image Model")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="openai_image_model" id="openai_image_model">
                    <option value="gpt-image-1.5" {if $system['openai_image_model'] == "gpt-image-1.5"}selected{/if}>{__("gpt-image-1.5")}</option>
                    <option value="chatgpt-image-latest" {if $system['openai_image_model'] == "chatgpt-image-latest"}selected{/if}>{__("chatgpt-image-latest")}</option>
                    <option value="gpt-image-1" {if $system['openai_image_model'] == "gpt-image-1"}selected{/if}>{__("gpt-image-1")}</option>
                  </select>
                </div>
              </div>
            </div>
            <div class="admin-settings-section flex flex-col gap-5 p-6">
              <h3 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">{__("Replicate API")}</h3>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="replicate_api_token">{__("Replicate API Token")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                    <input type="text" class="input w-full" name="replicate_api_token" id="replicate_api_token" value="{$system['replicate_api_token']}">
                  {else}
                    <input type="password" class="input w-full" id="replicate_api_token" value="*********">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="replicate_model">{__("Replicate Model")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="replicate_model" id="replicate_model">
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
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="replicate_denoising_steps">{__("Denoising Steps")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="replicate_denoising_steps" id="replicate_denoising_steps" value="{$system['replicate_denoising_steps']}" aria-describedby="replicate_denoising_steps-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="replicate_denoising_steps-help">{__("Number of denoising steps (Minimum: 1; Maximum: 500)")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="replicate_guidance_scale">{__("Guidance Scale")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="replicate_guidance_scale" id="replicate_guidance_scale" value="{$system['replicate_guidance_scale']}" aria-describedby="replicate_guidance_scale-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="replicate_guidance_scale-help">{__("Guidance scale (Minimum: 1; Maximum: 20)")}</div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="replicate_seed">{__("Seed")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="replicate_seed" id="replicate_seed" value="{$system['replicate_seed']}" aria-describedby="replicate_seed-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="replicate_seed-help">{__("Seed (Minimum: 0; Maximum: 4294967295), Leave blank to randomize the seed")}</div>
                </div>
              </div>
            </div>
            <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
              <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
              </div>
              <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
              </div>
            </div>
          </section>
        </div>
      </div>
    </form>
  </div>
  <div class="admin-settings-panel js_admin-settings-panel hidden" id="Credit" role="tabpanel" tabindex="0">
    {if $licence_monetization && is_file("content/themes/`$system.theme`/templates/admin.settings.ai.credit.tpl")}
      {include file='admin.settings.ai.credit.tpl'}
    {else}
      {include file='__licence_lock.tpl'}
    {/if}
  </div>
</section>
