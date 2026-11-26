<section class="admin-settings-page" aria-labelledby="settings-uploads-title">
  <!-- card-header -->
  <div class="admin-settings-heading grid gap-1.5">
    <h1 id="settings-uploads-title" class="text-2xl font-semibold">
      {__("Uploads Settings")}
    </h1>
    <p class="text-base-content/60 text-sm">{__("Local, cloud, and FTP upload storage.")}</p>
  </div>
  <nav class="tabs admin-settings-nav" role="tablist" aria-label="{__("Uploads Settings")}" aria-orientation="vertical">
    <button type="button" id="settings-uploads-tab-0" class="tab active-tab:tab-active active" data-tab="#General" aria-controls="General" role="tab" aria-selected="true"><span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("General")}</button>
    <button type="button" id="settings-uploads-tab-1" class="tab active-tab:tab-active" data-tab="#Cloud" aria-controls="Cloud" role="tab" aria-selected="false"><span class="icon-[tabler--cloud] size-4" aria-hidden="true"></span>{__("Cloud Hosting")}</button>
    <button type="button" id="settings-uploads-tab-2" class="tab active-tab:tab-active" data-tab="#FTP" aria-controls="FTP" role="tab" aria-selected="false"><span class="icon-[tabler--server-2] size-4" aria-hidden="true"></span>{__("FTP")}</button>
  </nav>
  <!-- card-header -->
  <!-- tabs content -->
  <div class="tab-content">
    <!-- General -->
    <div class="admin-settings-panel js_admin-settings-panel" id="General" role="tabpanel" aria-labelledby="settings-uploads-tab-0" tabindex="0">
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=uploads">
        <div class="alert alert-warning admin-settings-notice [overflow-wrap:anywhere]">
          <div class="icon">
            <span class="icon-[tabler--alert-triangle] size-8" aria-hidden="true"></span>
          </div>
          <div class="text">
            {__("Your server max upload size")} = {$max_upload_size}
            <br>
            {__("You can't upload files larger than")} {$max_upload_size} - {__("To upload larger files, contact your hosting provider")}
          </div>
        </div>
                <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">

          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-uploads-uploads-card-0">
          <h3 id="settings-uploads-uploads-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Paths and limits")}
          </h3>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-1-label" for="settings-uploads-field-1">
                  {__("Uploads Directory")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="uploads_directory" value="{$system['uploads_directory']}" id="settings-uploads-field-1" aria-describedby="settings-uploads-field-1-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-1-help">
                    {__("The path of uploads local directory")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-2-label" for="settings-uploads-field-2">
                  {__("Uploads Prefix")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="uploads_prefix" value="{$system['uploads_prefix']}" id="settings-uploads-field-2" aria-describedby="settings-uploads-field-2-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-2-help">
                    {__("Add a prefix to the uploaded files (No spaces or special characters only like 'mysite' or 'my_site')")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-3-label" for="settings-uploads-field-3">
                  {__("Uploads CDN Endpoint")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="uploads_cdn_url" value="{$system['uploads_cdn_url']}" id="settings-uploads-field-3" aria-describedby="settings-uploads-field-3-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-3-help">
                    {__("Your CDN URL like AWS CloudFront")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-4-label" for="settings-uploads-field-4">
                  {__("Maximum Total Upload Size")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="max_daily_upload_size" id="settings-uploads-field-4" aria-describedby="settings-uploads-field-4-help">
                    <option value="0" {if $upload_size_values['max_daily_upload_size'] == 0}selected{/if}>{__("Unlimited")}</option>
                    {foreach $upload_size_options as $size => $label}
                      <option value="{$size}" {if $upload_size_values['max_daily_upload_size'] == $size}selected{/if}>{$label}</option>
                    {/foreach}
                  </select>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-4-help">
                    {__("The Maximum total size of uploaded files per day per user")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-5-label" for="settings-uploads-field-5">
                  {__("Chunk Upload Size")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="input w-full" name="chunk_upload_size" id="settings-uploads-field-5" aria-describedby="settings-uploads-field-5-help">
                    <option value="10" {if $system['chunk_upload_size'] == 10}selected{/if}>10 MB</option>
                    <option value="20" {if $system['chunk_upload_size'] == 20}selected{/if}>20 MB</option>
                    <option value="50" {if $system['chunk_upload_size'] == 50}selected{/if}>50 MB</option>
                    <option value="100" {if $system['chunk_upload_size'] == 100}selected{/if}>100 MB</option>
                    <option value="200" {if $system['chunk_upload_size'] == 200}selected{/if}>200 MB</option>
                  </select>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-5-help">
                    {__("The size of each chunk of the uploaded file in megabytes")}
                    <br>
                    {__("This is useful for large files to avoid server timeouts")}
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-uploads-uploads-card-1">
          <h3 id="settings-uploads-uploads-card-1" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Photos")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="photos" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="photos_enabled">{__("Photo Upload")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="photos_enabled-help">
                    {__("Enable photo upload to share & upload photos to the site")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="photos_enabled" id="photos_enabled" {if $system['photos_enabled']}checked{/if} class="switch switch-primary" aria-describedby="photos_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="photos" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="comments_photos_enabled">{__("Photo Upload in Comments")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="comments_photos_enabled-help">
                    {__("Enable photo upload in comments")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="comments_photos_enabled" id="comments_photos_enabled" {if $system['comments_photos_enabled']}checked{/if} class="switch switch-primary" aria-describedby="comments_photos_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="photos" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chat_photos_enabled">{__("Photo Upload in Chat")} </label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_photos_enabled-help">
                    {__("Enable photo upload in chat")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="chat_photos_enabled" id="chat_photos_enabled" {if $system['chat_photos_enabled']}checked{/if} class="switch switch-primary" aria-describedby="chat_photos_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="photos" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="tinymce_photos_enabled">{__("Photo Upload in Blogs and Forums")} </label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="tinymce_photos_enabled-help">
                    {__("Enable photo upload in blogs and forums threads")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="tinymce_photos_enabled" id="tinymce_photos_enabled" {if $system['tinymce_photos_enabled']}checked{/if} class="switch switch-primary" aria-describedby="tinymce_photos_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-6-label" for="settings-uploads-field-6">
                  {__("Max Photo Size")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="max_photo_size" id="settings-uploads-field-6" aria-describedby="settings-uploads-field-6-help">
                    {foreach $upload_size_options as $size => $label}
                      <option value="{$size}" {if $upload_size_values['max_photo_size'] == $size}selected{/if}>{$label}</option>
                    {/foreach}
                  </select>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-6-help">
                    {__("The Maximum size of uploaded photo in posts")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-7-label" for="settings-uploads-field-7">
                  {__("Photo Quality")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="uploads_quality" id="settings-uploads-field-7">
                    <option value="high" {if $system['uploads_quality'] == "high"}selected{/if}>{__("High quality photos with low compression")}</option>
                    <option value="medium" {if $system['uploads_quality'] == "medium"}selected{/if}>{__("Medium quality photos with medium compression")}</option>
                    <option value="low" {if $system['uploads_quality'] == "low"}selected{/if}>{__("Low quality photos with high compression")}</option>
                  </select>
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="heif" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="allow_heif_images">{__("Support HEIF/HEIC Images")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="allow_heif_images-help">
                    {__("Enable support for HEIF/HEIC images")}
                    <br>
                    {__("Note: PHP Imagick extension is required to support HEIF/HEIC images")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="allow_heif_images" id="allow_heif_images" {if $system['allow_heif_images']}checked{/if} class="switch switch-primary" aria-describedby="allow_heif_images-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="gif" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="allow_animated_images">{__("Animated Images for Avatars/Covers")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="allow_animated_images-help">
                    {__("Enable user to upload animated images for avarats and covers")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="allow_animated_images" id="allow_animated_images" {if $system['allow_animated_images']}checked{/if} class="switch switch-primary" aria-describedby="allow_animated_images-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="resolution" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="limit_cover_photo">{__("Cover Photo Resolution Limit")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="limit_cover_photo-help">
                    {__("Enable cover photo limit (Minimum width 1296px & Minimum height 360px)")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="limit_cover_photo" id="limit_cover_photo" {if $system['limit_cover_photo']}checked{/if} class="switch switch-primary" aria-describedby="limit_cover_photo-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="crop" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="cover_crop_enabled">{__("Cover Photo Crop")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="cover_crop_enabled-help">
                    {__("Enable cover photo crop")} ({__("Note: If disabled, the cover position will used instead")})
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="cover_crop_enabled" id="cover_crop_enabled" {if $system['cover_crop_enabled']}checked{/if} class="switch switch-primary" aria-describedby="cover_crop_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-8-label" for="settings-uploads-field-8">
                  {__("Max Cover Photo Size")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="max_cover_size" id="settings-uploads-field-8" aria-describedby="settings-uploads-field-8-help">
                    {foreach $upload_size_options as $size => $label}
                      <option value="{$size}" {if $upload_size_values['max_cover_size'] == $size}selected{/if}>{$label}</option>
                    {/foreach}
                  </select>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-8-help">
                    {__("The Maximum size of cover photo")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-9-label" for="settings-uploads-field-9">
                  {__("Max Profile Photo Size")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="max_avatar_size" id="settings-uploads-field-9" aria-describedby="settings-uploads-field-9-help">
                    {foreach $upload_size_options as $size => $label}
                      <option value="{$size}" {if $upload_size_values['max_avatar_size'] == $size}selected{/if}>{$label}</option>
                    {/foreach}
                  </select>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-9-help">
                    {__("The Maximum size of profile photo")}
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-uploads-uploads-card-2">
          <h3 id="settings-uploads-uploads-card-2" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Image watermarking")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="watermark" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="watermark_enabled">{__("Watermark Images")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="watermark_enabled-help">
                    {__("Enable it to add watermark icon to all uploaded photos (except: profile pictures and cover images)")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="watermark_enabled" id="watermark_enabled" {if $system['watermark_enabled']}checked{/if} class="switch switch-primary" aria-describedby="watermark_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-uploads-field-10-label">
                <div class="label-text" id="settings-uploads-field-10-label">
                  {__("Watermark Type")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="watermark_type" id="watermark_icon" value="icon" class="radio radio-primary" {if $system['watermark_type'] == "icon"}checked{/if} aria-describedby="settings-uploads-field-10-help">
                    <label class="label-text" for="watermark_icon">{__("Icon")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="watermark_type" id="watermark_username" value="username" class="radio radio-primary" {if $system['watermark_type'] == "username"}checked{/if} aria-describedby="settings-uploads-field-10-help">
                    <label class="label-text" for="watermark_username">{__("Username")}</label>
                  </div>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-10-help">
                    {__("Note: The username watermark will be repeated diagonally across the image")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-11-label" for="settings-uploads-field-11">
                  {__("Watermark Opacity")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="flex w-full items-center gap-4 sm:max-w-xs">
                    <input type="range" class="range range-primary range-sm [--color-neutral:var(--color-base-content)] grow" name="watermark_opacity" min="0" max="1" step="0.05" value="{$watermark_opacity_value}" id="settings-uploads-field-11" aria-describedby="settings-uploads-field-11-help" oninput="this.nextElementSibling.value = Math.round(this.value * 100) + '%'">
                    <output class="w-12 shrink-0 text-end text-sm font-medium tabular-nums" for="settings-uploads-field-11">{($watermark_opacity_value * 100)|string_format:"%.0f"}%</output>
                  </div>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-11-help">
                    {__("The opacity level of the watermark icon")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-uploads-field-12-label">
                <div class="label-text" id="settings-uploads-field-12-label">
                  {__("Watermark Icon")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if $system['watermark_icon'] == ''}
                  {include file='__x_image.tpl' _x_name="watermark_icon" _x_fit="contain"}
                  {else}
                  {include file='__x_image.tpl' _x_name="watermark_icon" _x_value=$system['watermark_icon'] _x_fit="contain"}
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-12-help">
                    {__("Upload your watermark icon (PNG is recommended)")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-uploads-field-14-label">
                <div class="label-text" id="settings-uploads-field-14-label">
                  {__("Watermark Icon Position")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {include file='__admin_offset_pad.tpl' _x_name="watermark_x" _y_name="watermark_y" _x_value=$watermark_positions['watermark_x'] _y_value=$watermark_positions['watermark_y'] _x_default="95" _y_default="95" _mode="photo" _icon=$system['watermark_icon'] _labelledby="settings-uploads-field-14-label" _help="settings-uploads-field-14-help"}
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-14-help">
                    {__("Drag the watermark to where it should appear on the image")}
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-uploads-uploads-card-3">
          <h3 id="settings-uploads-uploads-card-3" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Image moderation")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="adult" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="adult_images_enabled">{__("Adult Images Detection")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="adult_images_enabled-help">
                    {__("Enable it to detect the adult images and system will blur or delete them")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="adult_images_enabled" id="adult_images_enabled" {if $system['adult_images_enabled']}checked{/if} class="switch switch-primary" aria-describedby="adult_images_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-uploads-field-16-label">
                <div class="label-text" id="settings-uploads-field-16-label">
                  {__("Adult Images Action")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="adult_images_action" id="action_blue" value="blur" class="radio radio-primary" {if $system['adult_images_action'] == "blur"}checked{/if}>
                    <label class="label-text" for="action_blue">{__("Blur")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5 admin-settings-choice-inline m-0 inline-flex">
                    <input type="radio" name="adult_images_action" id="action_delete" value="delete" class="radio radio-primary" {if $system['adult_images_action'] == "delete"}checked{/if}>
                    <label class="label-text" for="action_delete">{__("Delete")}</label>
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-17-label" for="settings-uploads-field-17">
                  {__("Google Vision API Key")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="adult_images_api_key" value="{$system['adult_images_api_key']}" id="settings-uploads-field-17" aria-describedby="settings-uploads-field-17-help">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-uploads-field-17" aria-describedby="settings-uploads-field-17-help">
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-17-help">
                    {__("Your Cloud Vision API Key")}
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-uploads-uploads-card-4">
          <h3 id="settings-uploads-uploads-card-4" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Videos and reels")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="videos" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="videos_enabled">{__("Video Upload")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="videos_enabled-help">
                    {__("Enable video upload to share & upload videos to the site")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="videos_enabled" id="videos_enabled" {if $system['videos_enabled']}checked{/if} class="switch switch-primary" aria-describedby="videos_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
              {include file='__svg_icons.tpl' icon="videos" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chat_videos_enabled">{__("Video Upload in Chat")} </label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_videos_enabled-help">
                    {__("Enable video upload in chat")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="chat_videos_enabled" id="chat_videos_enabled" {if $system['chat_videos_enabled']}checked{/if} class="switch switch-primary" aria-describedby="chat_videos_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="chat_max_media-label" for="chat_max_media">
                  {__("Max media per chat message")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="number" class="input w-full" name="chat_max_media" value="{$system['chat_max_media']|default:10}" min="1" max="50" id="chat_max_media" aria-describedby="chat_max_media-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_max_media-help">
                    {__("The maximum number of photos, videos and files in one chat message")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-18-label" for="settings-uploads-field-18">
                  {__("Max video size")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="max_video_size" id="settings-uploads-field-18" aria-describedby="settings-uploads-field-18-help">
                    {foreach $upload_size_options as $size => $label}
                      <option value="{$size}" {if $upload_size_values['max_video_size'] == $size}selected{/if}>{$label}</option>
                    {/foreach}
                  </select>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-18-help">
                    {__("The Maximum size of uploaded video in posts")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-19-label" for="settings-uploads-field-19">
                  {__("Video extensions")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="video_extensions" value="{$system['video_extensions']}" id="settings-uploads-field-19" aria-describedby="settings-uploads-field-19-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-19-help">
                    {__("Allowed video extensions (separated with comma ',')")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-20-label" for="settings-uploads-field-20">
                  {__("Video Minimum Duration")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="video_minimum_duration" value="{$system['video_minimum_duration']}" id="settings-uploads-field-20" aria-describedby="settings-uploads-field-20-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-20-help">
                    {__("The Minimum duration of the video in seconds (0 for unlimited)")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-21-label" for="settings-uploads-field-21">
                  {__("Video Maximum Duration")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="video_maximum_duration" value="{$system['video_maximum_duration']}" id="settings-uploads-field-21" aria-describedby="settings-uploads-field-21-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-21-help">
                    {__("The Maximum duration of the video in seconds (0 for unlimited)")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-22-label" for="settings-uploads-field-22">
                  {__("Reel Minimum Duration")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="reels_minimum_duration" value="{$system['reels_minimum_duration']}" id="settings-uploads-field-22" aria-describedby="settings-uploads-field-22-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-22-help">
                    {__("The Minimum duration of the reel in seconds (0 for unlimited)")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-23-label" for="settings-uploads-field-23">
                  {__("Reel Maximum Duration")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="reels_maximum_duration" value="{$system['reels_maximum_duration']}" id="settings-uploads-field-23" aria-describedby="settings-uploads-field-23-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-23-help">
                    {__("The Maximum duration of the reel in seconds (0 for unlimited)")}
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-uploads-uploads-card-5">
          <h3 id="settings-uploads-uploads-card-5" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("FFmpeg conversion")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="ffmpeg" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="ffmpeg_enabled">{__("FFMPEG Enabled")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="ffmpeg_enabled-help">
                    {__("Enable FFMPEG to convert and optimize videos to mp4")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="ffmpeg_enabled" id="ffmpeg_enabled" {if $system['ffmpeg_enabled']}checked{/if} class="switch switch-primary" aria-describedby="ffmpeg_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-24-label" for="settings-uploads-field-24">
                  {__("FFMPEG Binary Path")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="ffmpeg_path" value="{$system['ffmpeg_path']}" id="settings-uploads-field-24" aria-describedby="settings-uploads-field-24-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-24-help">
                    {__("Example: Linux(/usr/bin/ffmpeg) or Windows(C:\\ffmpeg\\bin\\ffmpeg.exe)")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-25-label" for="settings-uploads-field-25">
                  {__("FFMPEG Conversion Speed")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="ffmpeg_speed" id="settings-uploads-field-25" aria-describedby="settings-uploads-field-25-help">
                    <option value="ultrafast" {if $system['ffmpeg_speed'] == "ultrafast"}selected{/if}>{__("Ultrafast")}</option>
                    <option value="superfast" {if $system['ffmpeg_speed'] == "superfast"}selected{/if}>{__("Superfast")}</option>
                    <option value="veryfast" {if $system['ffmpeg_speed'] == "veryfast"}selected{/if}>{__("Veryfast")}</option>
                    <option value="faster" {if $system['ffmpeg_speed'] == "faster"}selected{/if}>{__("Faster")}</option>
                    <option value="fast" {if $system['ffmpeg_speed'] == "fast"}selected{/if}>{__("Fast")}</option>
                    <option value="medium" {if $system['ffmpeg_speed'] == "medium"}selected{/if}>{__("Medium")}</option>
                    <option value="slow" {if $system['ffmpeg_speed'] == "slow"}selected{/if}>{__("Slow")}</option>
                    <option value="slower" {if $system['ffmpeg_speed'] == "slower"}selected{/if}>{__("Slower")}</option>
                    <option value="veryslow" {if $system['ffmpeg_speed'] == "veryslow"}selected{/if}>{__("Veryslow")}</option>
                  </select>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-25-help">
                    {__("Slow speed gives you better compression and quality and vice versa")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-uploads-field-26-label">
                <div class="label-text" id="settings-uploads-field-26-label">
                  {__("Video Resolutions")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="ffmpeg_240p_enabled" id="ffmpeg_240p_enabled" {if $system['ffmpeg_240p_enabled']}checked{/if} aria-describedby="settings-uploads-field-26-help">
                    <label class="label-text" for="ffmpeg_240p_enabled">{__("240p Resolution")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="ffmpeg_360p_enabled" id="ffmpeg_360p_enabled" {if $system['ffmpeg_360p_enabled']}checked{/if} aria-describedby="settings-uploads-field-26-help">
                    <label class="label-text" for="ffmpeg_360p_enabled">{__("360p Resolution")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="ffmpeg_480p_enabled" id="ffmpeg_480p_enabled" {if $system['ffmpeg_480p_enabled']}checked{/if} aria-describedby="settings-uploads-field-26-help">
                    <label class="label-text" for="ffmpeg_480p_enabled">{__("480p Resolution")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="ffmpeg_720p_enabled" id="ffmpeg_720p_enabled" {if $system['ffmpeg_720p_enabled']}checked{/if} aria-describedby="settings-uploads-field-26-help">
                    <label class="label-text" for="ffmpeg_720p_enabled">{__("720p Resolution")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="ffmpeg_1080p_enabled" id="ffmpeg_1080p_enabled" {if $system['ffmpeg_1080p_enabled']}checked{/if} aria-describedby="settings-uploads-field-26-help">
                    <label class="label-text" for="ffmpeg_1080p_enabled">{__("1080p Resolution")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="ffmpeg_1440p_enabled" id="ffmpeg_1440p_enabled" {if $system['ffmpeg_1440p_enabled']}checked{/if} aria-describedby="settings-uploads-field-26-help">
                    <label class="label-text" for="ffmpeg_1440p_enabled">{__("1440p Resolution")}</label>
                  </div>
                  <div class="admin-settings-choice my-1 flex items-start gap-2.5">
                    <input type="checkbox" class="checkbox checkbox-primary" name="ffmpeg_2160p_enabled" id="ffmpeg_2160p_enabled" {if $system['ffmpeg_2160p_enabled']}checked{/if} aria-describedby="settings-uploads-field-26-help">
                    <label class="label-text" for="ffmpeg_2160p_enabled">{__("2160p Resolution")}</label>
                  </div>
                  <span class="admin-setting-help text-sm leading-relaxed mt-2.5" id="settings-uploads-field-26-help">
                    {__("Select the resolutions you want to convert your videos to")}
                  </span>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-uploads-uploads-card-6">
          <h3 id="settings-uploads-uploads-card-6" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Video watermarking")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="watermark" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="watermark_videos_enabled">{__("Watermark Videos")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="watermark_videos_enabled-help">
                    {__("Enable it to add watermark icon to all uploaded videos (Note: FFmpeg must be enabled)")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="watermark_videos_enabled" id="watermark_videos_enabled" {if $system['watermark_videos_enabled']}checked{/if} class="switch switch-primary" aria-describedby="watermark_videos_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-uploads-field-27-label">
                <div class="label-text" id="settings-uploads-field-27-label">
                  {__("Watermark Icon")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if $system['watermark_videos_icon'] == ''}
                  {include file='__x_image.tpl' _x_name="watermark_videos_icon" _x_fit="contain"}
                  {else}
                  {include file='__x_image.tpl' _x_name="watermark_videos_icon" _x_value=$system['watermark_videos_icon'] _x_fit="contain"}
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-27-help">
                    {__("Upload your watermark icon (PNG is recommended)")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-29-label" for="settings-uploads-field-29">
                  {__("Watermark Opacity")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <div class="flex w-full items-center gap-4 sm:max-w-xs">
                    <input type="range" class="range range-primary range-sm [--color-neutral:var(--color-base-content)] grow" name="watermark_videos_opacity" min="0" max="1" step="0.05" value="{$watermark_videos_opacity_value}" id="settings-uploads-field-29" aria-describedby="settings-uploads-field-29-help" oninput="this.nextElementSibling.value = Math.round(this.value * 100) + '%'">
                    <output class="w-12 shrink-0 text-end text-sm font-medium tabular-nums" for="settings-uploads-field-29">{($watermark_videos_opacity_value * 100)|string_format:"%.0f"}%</output>
                  </div>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-29-help">
                    {__("The opacity level of the watermark icon")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field" role="group" aria-labelledby="settings-uploads-field-30-label">
                <div class="label-text" id="settings-uploads-field-30-label">
                  {__("Watermark Position")}
                </div>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {include file='__admin_offset_pad.tpl' _x_name="watermark_videos_x" _y_name="watermark_videos_y" _x_value=$watermark_positions['watermark_videos_x'] _y_value=$watermark_positions['watermark_videos_y'] _x_default="50" _y_default="50" _mode="video" _icon=$system['watermark_videos_icon'] _labelledby="settings-uploads-field-30-label" _help="settings-uploads-field-30-help"}
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-30-help">
                    {__("Drag the watermark to where it should appear on the image")}
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-uploads-uploads-card-7">
          <h3 id="settings-uploads-uploads-card-7" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Audio")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="audios" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="audio_enabled">{__("Audio Upload")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="audio_enabled-help">
                    {__("Enable audio upload to share & upload sounds to the site")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="audio_enabled" id="audio_enabled" {if $system['audio_enabled']}checked{/if} class="switch switch-primary" aria-describedby="audio_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-32-label" for="settings-uploads-field-32">
                  {__("Max audio size")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="max_audio_size" id="settings-uploads-field-32" aria-describedby="settings-uploads-field-32-help">
                    {foreach $upload_size_options as $size => $label}
                      <option value="{$size}" {if $upload_size_values['max_audio_size'] == $size}selected{/if}>{$label}</option>
                    {/foreach}
                  </select>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-32-help">
                    {__("The Maximum size of uploaded audio in posts")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-33-label" for="settings-uploads-field-33">
                  {__("Audio extensions")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="audio_extensions" value="{$system['audio_extensions']}" id="settings-uploads-field-33" aria-describedby="settings-uploads-field-33-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-33-help">
                    {__("Allowed audio extensions (separated with comma ',')")}
                  </div>
                </div>
              </div>
        </div>
          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-uploads-uploads-card-8">
          <h3 id="settings-uploads-uploads-card-8" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("Files")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="files" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="file_enabled">{__("File Upload")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="file_enabled-help">
                    {__("Enable file upload to share & upload files to the site")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="file_enabled" id="file_enabled" {if $system['file_enabled']}checked{/if} class="switch switch-primary" aria-describedby="file_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="files" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="chat_files_enabled">{__("File Upload in Chat")} </label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="chat_files_enabled-help">
                    {__("Enable file upload in chat")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="chat_files_enabled" id="chat_files_enabled" {if $system['chat_files_enabled']}checked{/if} class="switch switch-primary" aria-describedby="chat_files_enabled-help">
                </div>
              </div>
              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="security" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="mask_file_path_enabled">{__("Mask Uploaded File Path")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="mask_file_path_enabled-help">
                    {__("Enable it to mask the uploaded file path")}
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="mask_file_path_enabled" id="mask_file_path_enabled" {if $system['mask_file_path_enabled']}checked{/if} class="switch switch-primary" aria-describedby="mask_file_path_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-34-label" for="settings-uploads-field-34">
                  {__("Max file size")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <select class="select w-full" name="max_file_size" id="settings-uploads-field-34" aria-describedby="settings-uploads-field-34-help">
                    {foreach $upload_size_options as $size => $label}
                      <option value="{$size}" {if $upload_size_values['max_file_size'] == $size}selected{/if}>{$label}</option>
                    {/foreach}
                  </select>
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-34-help">
                    {__("The Maximum size of uploaded file in posts")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-35-label" for="settings-uploads-field-35">
                  {__("File extensions")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="file_extensions" value="{$system['file_extensions']}" id="settings-uploads-field-35" aria-describedby="settings-uploads-field-35-help">
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-35-help">
                    {__("Allowed file extensions (separated with comma ',')")}
                  </div>
                </div>
              </div>
        </div>
              <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
          <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
            <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
            </div>
            <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
            </div>
          </div>
          <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
            <button type="button" class="btn btn-outline js_admin-tester" data-handle="ffmpeg">
              <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection (FFMPEG)")}
            </button>
            <button type="button" class="btn btn-outline js_admin-tester" data-handle="google_vision">
              <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection (Vision API)")}
            </button>
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
          </div>
        </div>
            </section>
          </div>
        </div>
      </form>
    </div>
    <!-- General -->
    <!-- Cloud -->
    <div class="admin-settings-panel js_admin-settings-panel hidden" id="Cloud" role="tabpanel" aria-labelledby="settings-uploads-tab-1" tabindex="0">
            <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">

        <div class="alert alert-info admin-settings-card-wide min-w-0 admin-settings-notice [overflow-wrap:anywhere]">
          <div class="icon">
            <span class="icon-[tabler--cloud-upload] size-8" aria-hidden="true"></span>
          </div>
          <div class="text">
            <strong>{__("Cloud Hosting")}</strong>
            <br>
            {__("Before enabling cloud hosting, make sure you upload the whole 'uploads' folder to your bucket")}.
            <br>
            {__("Before disabling cloud hosting, make sure you download the whole 'uploads' folder to your server")}.
          </div>
        </div>
        <!-- S3 -->
        <form class="js_ajax-forms card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none admin-settings-provider-form" data-url="admin/settings.php?edit=s3" aria-labelledby="settings-uploads-s3-card-0">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 id="settings-uploads-s3-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              {__("Amazon S3")}
            </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="aws_s3" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="s3_enabled">{__("Amazon S3 Storage")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="s3_enabled-help">
                  {__("Enable Amazon S3 storage")} ({__("Note: Enable this will disable all other options")})
                </div>
              </div>
              <div class="text-end">
                <input type="checkbox" name="s3_enabled" id="s3_enabled" {if $system['s3_enabled']}checked{/if} class="switch switch-primary" aria-describedby="s3_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-36-label" for="settings-uploads-field-36">
                {__("Bucket Name")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="s3_bucket" value="{$system['s3_bucket']}" id="settings-uploads-field-36" aria-describedby="settings-uploads-field-36-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-36-help">
                  {__("Your Amazon S3 bucket name")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-37-label" for="settings-uploads-field-37">
                {__("Bucket Region")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="s3_region" id="settings-uploads-field-37" aria-describedby="settings-uploads-field-37-help">
                  <option value="us-east-2" {if $system['s3_region'] == "us-east-2"}selected{/if}>US East (Ohio) us-east-2</option>
                  <option value="us-east-1" {if $system['s3_region'] == "us-east-1"}selected{/if}>US East (N. Virginia) us-east-1</option>
                  <option value="us-west-1" {if $system['s3_region'] == "us-west-1"}selected{/if}>US West (N. California) us-west-1</option>
                  <option value="us-west-2" {if $system['s3_region'] == "us-west-2"}selected{/if}>US West (Oregon) us-west-2</option>
                  <option value="ap-east-1" {if $system['s3_region'] == "ap-east-1"}selected{/if}>Asia Pacific (Hong Kong) ap-east-1</option>
                  <option value="ap-south-1" {if $system['s3_region'] == "ap-south-1"}selected{/if}>Asia Pacific (Mumbai) ap-south-1</option>
                  <option value="ap-northeast-3" {if $system['s3_region'] == "ap-northeast-3"}selected{/if}>Asia Pacific (Osaka-Local) ap-northeast-3</option>
                  <option value="ap-northeast-2" {if $system['s3_region'] == "ap-northeast-2"}selected{/if}>Asia Pacific (Seoul) ap-northeast-2</option>
                  <option value="ap-southeast-1" {if $system['s3_region'] == "ap-southeast-1"}selected{/if}>Asia Pacific (Singapore) ap-southeast-1</option>
                  <option value="ap-southeast-2" {if $system['s3_region'] == "ap-southeast-2"}selected{/if}>Asia Pacific (Sydney) ap-southeast-2</option>
                  <option value="ap-northeast-1" {if $system['s3_region'] == "ap-northeast-1"}selected{/if}>Asia Pacific (Tokyo) ap-northeast-1</option>
                  <option value="ca-central-1" {if $system['s3_region'] == "ca-central-1"}selected{/if}>Canada (Central) ca-central-1</option>
                  <option value="eu-central-1" {if $system['s3_region'] == "eu-central-1"}selected{/if}>EU (Frankfurt) eu-central-1</option>
                  <option value="eu-west-1" {if $system['s3_region'] == "eu-west-1"}selected{/if}>EU (Ireland) eu-west-1</option>
                  <option value="eu-west-2" {if $system['s3_region'] == "eu-west-2"}selected{/if}>EU (London) eu-west-2</option>
                  <option value="eu-west-3" {if $system['s3_region'] == "eu-west-3"}selected{/if}>EU (Paris) eu-west-3</option>
                  <option value="eu-north-1" {if $system['s3_region'] == "eu-north-1"}selected{/if}>Europe (Stockholm) eu-north-1</option>
                  <option value="me-south-1" {if $system['s3_region'] == "me-south-1"}selected{/if}>Middle East (Bahrain) me-south-1</option>
                  <option value="sa-east-1" {if $system['s3_region'] == "sa-east-1"}selected{/if}>South America (São Paulo) sa-east-1</option>
                </select>
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-37-help">
                  {__("Your Amazon S3 bucket region")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-38-label" for="settings-uploads-field-38">
                {__("Access Key ID")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                <input type="text" class="input w-full" name="s3_key" value="{$system['s3_key']}" id="settings-uploads-field-38" aria-describedby="settings-uploads-field-38-help">
                {else}
                <input type="password" class="input w-full" value="*********" id="settings-uploads-field-38" aria-describedby="settings-uploads-field-38-help">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-38-help">
                  {__("Your Amazon S3 Access Key ID")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-39-label" for="settings-uploads-field-39">
                {__("Access Key Secret")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                <input type="text" class="input w-full" name="s3_secret" value="{$system['s3_secret']}" id="settings-uploads-field-39" aria-describedby="settings-uploads-field-39-help">
                {else}
                <input type="password" class="input w-full" value="*********" id="settings-uploads-field-39" aria-describedby="settings-uploads-field-39-help">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-39-help">
                  {__("Your Amazon S3 Access Key Secret")}
                </div>
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4 admin-settings-provider-actions">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
              </div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
              </div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="button" class="btn btn-outline js_admin-tester" data-handle="s3">
                <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection")}
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </form>
        <!-- S3 -->
        <!-- Google -->
        <form class="js_ajax-forms card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none admin-settings-provider-form" data-url="admin/settings.php?edit=google_cloud" aria-labelledby="settings-uploads-google_cloud-card-0">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 id="settings-uploads-google_cloud-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              {__("Google Cloud")}
            </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="google_cloud" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="google_cloud_enabled">{__("Google Cloud")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="google_cloud_enabled-help">
                  {__("Enable Google Cloud storage")} ({__("Note: Enable this will disable all other options")})
                </div>
              </div>
              <div class="text-end">
                <input type="checkbox" name="google_cloud_enabled" id="google_cloud_enabled" {if $system['google_cloud_enabled']}checked{/if} class="switch switch-primary" aria-describedby="google_cloud_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-40-label" for="settings-uploads-field-40">
                {__("Bucket Name")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="google_cloud_bucket" value="{$system['google_cloud_bucket']}" id="settings-uploads-field-40" aria-describedby="settings-uploads-field-40-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-40-help">
                  {__("Your Google Cloud bucket name")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-41-label" for="google_cloud_file">
                {__("Google Cloud File")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <textarea name="google_cloud_file" id="google_cloud_file" aria-describedby="settings-uploads-field-41-help">{$system['google_cloud_file']}</textarea>
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-41-help">
                  {__("Your service account keys JSON")}
                </div>
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4 admin-settings-provider-actions">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
              </div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
              </div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="button" class="btn btn-outline js_admin-tester" data-handle="google_cloud">
                <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection")}
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </form>
        <!-- Google -->
        <!-- DigitalOcean -->
        <form class="js_ajax-forms card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none admin-settings-provider-form" data-url="admin/settings.php?edit=digitalocean" aria-labelledby="settings-uploads-digitalocean-card-0">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 id="settings-uploads-digitalocean-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              {__("DigitalOcean")}
            </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="digitalocean" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="digitalocean_enabled">{__("DigitalOcean Space")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="digitalocean_enabled-help">
                  {__("Enable DigitalOcean storage")} ({__("Note: Enable this will disable all other options")})
                </div>
              </div>
              <div class="text-end">
                <input type="checkbox" name="digitalocean_enabled" id="digitalocean_enabled" {if $system['digitalocean_enabled']}checked{/if} class="switch switch-primary" aria-describedby="digitalocean_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-42-label" for="settings-uploads-field-42">
                {__("Space Name")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="digitalocean_space_name" value="{$system['digitalocean_space_name']}" id="settings-uploads-field-42" aria-describedby="settings-uploads-field-42-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-42-help">
                  {__("Your DigitalOcean space name")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-43-label" for="settings-uploads-field-43">
                {__("Space Region")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="digitalocean_space_region" id="settings-uploads-field-43" aria-describedby="settings-uploads-field-43-help">
                  <option value="nyc3" {if $system['digitalocean_space_region'] == "nyc3"}selected{/if}>New York City 3, United States</option>
                  <option value="ams3" {if $system['digitalocean_space_region'] == "ams3"}selected{/if}>Amsterdam 3, Netherlands</option>
                  <option value="sfo2" {if $system['digitalocean_space_region'] == "sfo2"}selected{/if}>San Francisco 2, United States</option>
                  <option value="sfo3" {if $system['digitalocean_space_region'] == "sfo3"}selected{/if}>San Francisco 3, United States</option>
                  <option value="sgp1" {if $system['digitalocean_space_region'] == "sgp1"}selected{/if}>Singapore, Singapore</option>
                  <option value="lon1" {if $system['digitalocean_space_region'] == "lon1"}selected{/if}>London, United Kingdom</option>
                  <option value="fra1" {if $system['digitalocean_space_region'] == "fra1"}selected{/if}>Paris, France</option>
                  <option value="tor1" {if $system['digitalocean_space_region'] == "tor1"}selected{/if}>Toronto, Canada</option>
                  <option value="blr1" {if $system['digitalocean_space_region'] == "blr1"}selected{/if}>Bangalore, India</option>
                  <option value="syd1" {if $system['digitalocean_space_region'] == "syd1"}selected{/if}>Sydney, Australia</option>
                </select>
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-43-help">
                  {__("Your DigitalOcean space region")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-44-label" for="settings-uploads-field-44">
                {__("Access Key ID")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                <input type="text" class="input w-full" name="digitalocean_key" value="{$system['digitalocean_key']}" id="settings-uploads-field-44" aria-describedby="settings-uploads-field-44-help">
                {else}
                <input type="password" class="input w-full" value="*********" id="settings-uploads-field-44" aria-describedby="settings-uploads-field-44-help">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-44-help">
                  {__("Your DigitalOcean Access Key ID")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-45-label" for="settings-uploads-field-45">
                {__("Access Key Secret")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                <input type="text" class="input w-full" name="digitalocean_secret" value="{$system['digitalocean_secret']}" id="settings-uploads-field-45" aria-describedby="settings-uploads-field-45-help">
                {else}
                <input type="password" class="input w-full" value="*********" id="settings-uploads-field-45" aria-describedby="settings-uploads-field-45-help">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-45-help">
                  {__("Your DigitalOcean Access Key Secret")}
                </div>
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4 admin-settings-provider-actions">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
              </div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
              </div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="button" class="btn btn-outline js_admin-tester" data-handle="digitalocean">
                <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection")}
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </form>
        <!-- DigitalOcean -->
        <!-- Wasabi -->
        <form class="js_ajax-forms card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none admin-settings-provider-form" data-url="admin/settings.php?edit=wasabi" aria-labelledby="settings-uploads-wasabi-card-0">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 id="settings-uploads-wasabi-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              {__("Wasabi")}
            </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="wasabi" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="wasabi_enabled">{__("Wasabi")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="wasabi_enabled-help">
                  {__("Enable Wasabi storage")} ({__("Note: Enable this will disable all other options")})
                </div>
              </div>
              <div class="text-end">
                <input type="checkbox" name="wasabi_enabled" id="wasabi_enabled" {if $system['wasabi_enabled']}checked{/if} class="switch switch-primary" aria-describedby="wasabi_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-46-label" for="settings-uploads-field-46">
                {__("Bucket Name")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="wasabi_bucket" value="{$system['wasabi_bucket']}" id="settings-uploads-field-46" aria-describedby="settings-uploads-field-46-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-46-help">
                  {__("Your Wasabi bucket name")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-47-label" for="settings-uploads-field-47">
                {__("Bucket Region")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="wasabi_region" id="settings-uploads-field-47" aria-describedby="settings-uploads-field-47-help">
                  <option value="us-east-1" {if $system['wasabi_region'] == "us-east-1"}selected{/if}>us-east-1</option>
                  <option value="us-east-2" {if $system['wasabi_region'] == "us-east-2"}selected{/if}>us-east-2</option>
                  <option value="us-central-1" {if $system['wasabi_region'] == "us-central-1"}selected{/if}>us-central-1</option>
                  <option value="us-west-1" {if $system['wasabi_region'] == "us-west-1"}selected{/if}>us-west-1</option>
                  <option value="ca-central-1" {if $system['wasabi_region'] == "ca-central-1"}selected{/if}>ca-central-1</option>
                  <option value="eu-central-1" {if $system['wasabi_region'] == "eu-central-1"}selected{/if}>eu-central-1</option>
                  <option value="eu-central-2" {if $system['wasabi_region'] == "eu-central-2"}selected{/if}>eu-central-2</option>
                  <option value="eu-west-1" {if $system['wasabi_region'] == "eu-west-1"}selected{/if}>eu-west-1</option>
                  <option value="eu-west-2" {if $system['wasabi_region'] == "eu-west-2"}selected{/if}>eu-west-2</option>
                  <option value="ap-northeast-1" {if $system['wasabi_region'] == "ap-northeast-1"}selected{/if}>ap-northeast-1</option>
                  <option value="ap-northeast-2" {if $system['wasabi_region'] == "ap-northeast-2"}selected{/if}>ap-northeast-2</option>
                  <option value="ap-southeast-1" {if $system['wasabi_region'] == "ap-southeast-1"}selected{/if}>ap-southeast-1</option>
                  <option value="ap-southeast-2" {if $system['wasabi_region'] == "ap-southeast-2"}selected{/if}>ap-southeast-2</option>
                </select>
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-47-help">
                  {__("Your Wasabi bucket region")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-48-label" for="settings-uploads-field-48">
                {__("Access Key ID")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                <input type="text" class="input w-full" name="wasabi_key" value="{$system['wasabi_key']}" id="settings-uploads-field-48" aria-describedby="settings-uploads-field-48-help">
                {else}
                <input type="password" class="input w-full" value="*********" id="settings-uploads-field-48" aria-describedby="settings-uploads-field-48-help">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-48-help">
                  {__("Your Wasabi Access Key ID")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-49-label" for="settings-uploads-field-49">
                {__("Access Key Secret")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                <input type="text" class="input w-full" name="wasabi_secret" value="{$system['wasabi_secret']}" id="settings-uploads-field-49" aria-describedby="settings-uploads-field-49-help">
                {else}
                <input type="password" class="input w-full" value="*********" id="settings-uploads-field-49" aria-describedby="settings-uploads-field-49-help">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-49-help">
                  {__("Your Wasabi Access Key Secret")}
                </div>
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4 admin-settings-provider-actions">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
              </div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
              </div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="button" class="btn btn-outline js_admin-tester" data-handle="wasabi">
                <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection")}
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </form>
        <!-- Wasabi -->
        <!-- Backblaze -->
        <form class="js_ajax-forms card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none admin-settings-provider-form" data-url="admin/settings.php?edit=backblaze" aria-labelledby="settings-uploads-backblaze-card-0">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 id="settings-uploads-backblaze-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              {__("Backblaze")}
            </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="backblaze" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="backblaze_enabled">{__("Backblaze")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="backblaze_enabled-help">
                  {__("Enable Backblaze storage")} ({__("Note: Enable this will disable all other options")})
                </div>
              </div>
              <div class="text-end">
                <input type="checkbox" name="backblaze_enabled" id="backblaze_enabled" {if $system['backblaze_enabled']}checked{/if} class="switch switch-primary" aria-describedby="backblaze_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-50-label" for="settings-uploads-field-50">
                {__("Bucket Name")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="backblaze_bucket" value="{$system['backblaze_bucket']}" id="settings-uploads-field-50" aria-describedby="settings-uploads-field-50-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-50-help">
                  {__("Your Backblaze bucket name")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-51-label" for="settings-uploads-field-51">
                {__("Bucket Region")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="backblaze_region" id="settings-uploads-field-51" aria-describedby="settings-uploads-field-51-help">
                  <option value="eu-central-003" {if $system['backblaze_region'] == "eu-central-003"}selected{/if}>eu-central-003</option>
                  <option value="us-west-004" {if $system['backblaze_region'] == "us-west-004"}selected{/if}>us-west-004</option>
                  <option value="us-east-005" {if $system['backblaze_region'] == "us-east-005"}selected{/if}>us-east-005</option>
                </select>
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-51-help">
                  {__("Your Backblaze bucket region")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-52-label" for="settings-uploads-field-52">
                {__("Access Key ID")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                <input type="text" class="input w-full" name="backblaze_key" value="{$system['backblaze_key']}" id="settings-uploads-field-52" aria-describedby="settings-uploads-field-52-help">
                {else}
                <input type="password" class="input w-full" value="*********" id="settings-uploads-field-52" aria-describedby="settings-uploads-field-52-help">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-52-help">
                  {__("Your Backblaze Access Key ID")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-53-label" for="settings-uploads-field-53">
                {__("Access Key Secret")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                <input type="text" class="input w-full" name="backblaze_secret" value="{$system['backblaze_secret']}" id="settings-uploads-field-53" aria-describedby="settings-uploads-field-53-help">
                {else}
                <input type="password" class="input w-full" value="*********" id="settings-uploads-field-53" aria-describedby="settings-uploads-field-53-help">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-53-help">
                  {__("Your Backblaze Access Key Secret")}
                </div>
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4 admin-settings-provider-actions">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
              </div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
              </div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="button" class="btn btn-outline js_admin-tester" data-handle="backblaze">
                <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection")}
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </form>
        <!-- Backblaze -->
        <!-- Yandex Cloud -->
        <form class="js_ajax-forms card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none admin-settings-provider-form" data-url="admin/settings.php?edit=yandex_cloud" aria-labelledby="settings-uploads-yandex_cloud-card-0">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 id="settings-uploads-yandex_cloud-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              {__("Yandex Cloud")}
            </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="yandex" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="yandex_cloud_enabled">{__("Yandex Cloud")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="yandex_cloud_enabled-help">
                  {__("Enable Yandex Cloud Storage")} ({__("Note: Enable this will disable all other options")})
                </div>
              </div>
              <div class="text-end">
                <input type="checkbox" name="yandex_cloud_enabled" id="yandex_cloud_enabled" {if $system['yandex_cloud_enabled']}checked{/if} class="switch switch-primary" aria-describedby="yandex_cloud_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-54-label" for="settings-uploads-field-54">
                {__("Bucket Name")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="yandex_cloud_bucket" value="{$system['yandex_cloud_bucket']}" id="settings-uploads-field-54" aria-describedby="settings-uploads-field-54-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-54-help">
                  {__("Your Yandex Cloud bucket name")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-55-label" for="settings-uploads-field-55">
                {__("Bucket Region")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="yandex_cloud_region" id="settings-uploads-field-55" aria-describedby="settings-uploads-field-55-help">
                  <option value="ru-central1" {if $system['yandex_cloud_region'] == "ru-central1"}selected{/if}>ru-central1</option>
                  <option value="kz1" {if $system['yandex_cloud_region'] == "kz1"}selected{/if}>kz1</option>
                </select>
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-55-help">
                  {__("Your Yandex Cloud bucket region")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-56-label" for="settings-uploads-field-56">
                {__("Access Key ID")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                <input type="text" class="input w-full" name="yandex_cloud_key" value="{$system['yandex_cloud_key']}" id="settings-uploads-field-56" aria-describedby="settings-uploads-field-56-help">
                {else}
                <input type="password" class="input w-full" value="*********" id="settings-uploads-field-56" aria-describedby="settings-uploads-field-56-help">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-56-help">
                  {__("Your Yandex Cloud Access Key ID")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-57-label" for="settings-uploads-field-57">
                {__("Access Key Secret")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                {if !$user->_data['user_demo']}
                <input type="text" class="input w-full" name="yandex_cloud_secret" value="{$system['yandex_cloud_secret']}" id="settings-uploads-field-57" aria-describedby="settings-uploads-field-57-help">
                {else}
                <input type="password" class="input w-full" value="*********" id="settings-uploads-field-57" aria-describedby="settings-uploads-field-57-help">
                {/if}
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-57-help">
                  {__("Your Yandex Cloud Access Key Secret")}
                </div>
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4 admin-settings-provider-actions">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
              </div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
              </div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="button" class="btn btn-outline js_admin-tester" data-handle="yandex_cloud">
                <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection")}
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </form>
        <!-- Yandex Cloud -->
        <!-- Cloudflare R2 -->
        <form class="js_ajax-forms card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none admin-settings-provider-form" data-url="admin/settings.php?edit=cloudflare_r2" aria-labelledby="settings-uploads-cloudflare_r2-card-0">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 id="settings-uploads-cloudflare_r2-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              {__("Cloudflare R2")}
            </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="cloudflare" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="cloudflare_r2_enabled">{__("Cloudflare R2")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="cloudflare_r2_enabled-help">
                  {__("Enable Cloudflare R2 storage")} ({__("Note: Enable this will disable all other options")})
                </div>
              </div>
              <div class="text-end">
                <input type="checkbox" name="cloudflare_r2_enabled" id="cloudflare_r2_enabled" {if $system['cloudflare_r2_enabled']}checked{/if} class="switch switch-primary" aria-describedby="cloudflare_r2_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-58-label" for="settings-uploads-field-58">
                {__("Bucket Name")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="cloudflare_r2_bucket" value="{$system['cloudflare_r2_bucket']}" id="settings-uploads-field-58" aria-describedby="settings-uploads-field-58-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-58-help">
                  {__("Your Cloudflare R2 bucket name")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-59-label" for="settings-uploads-field-59">
                {__("Access Key ID")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="cloudflare_r2_key" value="{$system['cloudflare_r2_key']}" id="settings-uploads-field-59" aria-describedby="settings-uploads-field-59-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-59-help">
                  {__("Your Cloudflare R2 Access Key ID")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-60-label" for="settings-uploads-field-60">
                {__("Access Key Secret")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="cloudflare_r2_secret" value="{$system['cloudflare_r2_secret']}" id="settings-uploads-field-60" aria-describedby="settings-uploads-field-60-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-60-help">
                  {__("Your Cloudflare R2 Access Key Secret")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-61-label" for="settings-uploads-field-61">
                {__("Endpoint")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="cloudflare_r2_endpoint" value="{$system['cloudflare_r2_endpoint']}" id="settings-uploads-field-61" aria-describedby="settings-uploads-field-61-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-61-help">
                  {__("Your Cloudflare R2 Endpoint")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-62-label" for="settings-uploads-field-62">
                {__("Custom Domain")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="cloudflare_r2_custom_domain" value="{$system['cloudflare_r2_custom_domain']}" id="settings-uploads-field-62" aria-describedby="settings-uploads-field-62-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-62-help">
                  {__("Your Cloudflare R2 Custom Domain (Example: 'https://cloud.sngine.com')")}
                </div>
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4 admin-settings-provider-actions">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
              </div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
              </div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="button" class="btn btn-outline js_admin-tester" data-handle="cloudflare_r2">
                <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection")}
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </form>
        <!-- Cloudflare R2 -->
        <!-- Pushr -->
        <form class="js_ajax-forms card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none admin-settings-provider-form" data-url="admin/settings.php?edit=pushr" aria-labelledby="settings-uploads-pushr-card-0">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 id="settings-uploads-pushr-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              {__("Pushr")}
            </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="pushr" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="pushr_enabled">{__("Pushr")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="pushr_enabled-help">
                  {__("Enable Pushr")} ({__("Note: Enable this will disable all other options")})
                </div>
              </div>
              <div class="text-end">
                <input type="checkbox" name="pushr_enabled" id="pushr_enabled" {if $system['pushr_enabled']}checked{/if} class="switch switch-primary" aria-describedby="pushr_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-63-label" for="settings-uploads-field-63">
                {__("Bucket Name")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="pushr_bucket" value="{$system['pushr_bucket']}" id="settings-uploads-field-63" aria-describedby="settings-uploads-field-63-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-63-help">
                  {__("Your Pushr bucket name")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-64-label" for="settings-uploads-field-64">
                {__("Access Key")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="pushr_key" value="{$system['pushr_key']}" id="settings-uploads-field-64" aria-describedby="settings-uploads-field-64-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-64-help">
                  {__("Your Pushr Access Key")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-65-label" for="settings-uploads-field-65">
                {__("Secret Key")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="pushr_secret" value="{$system['pushr_secret']}" id="settings-uploads-field-65" aria-describedby="settings-uploads-field-65-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-65-help">
                  {__("Your Pushr Secret Key")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-66-label" for="settings-uploads-field-66">
                {__("Region Endpoint")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="pushr_endpoint" value="{$system['pushr_endpoint']}" id="settings-uploads-field-66" aria-describedby="settings-uploads-field-66-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-66-help">
                  {__("Your Pushr Region Endpoint")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-67-label" for="settings-uploads-field-67">
                {__("CDN Hostname")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="pushr_hostname" value="{$system['pushr_hostname']}" id="settings-uploads-field-67" aria-describedby="settings-uploads-field-67-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-67-help">
                  {__("Your Pushr CDN Hostname (Example: 'https://XXXX.s3.de01.sonic.r-cdn.com')")}
                </div>
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4 admin-settings-provider-actions">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
              </div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
              </div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="button" class="btn btn-outline js_admin-tester" data-handle="pushr">
                <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection")}
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </form>
        <!-- Pushr -->
        <!-- OVH Object Storage -->
        <form class="js_ajax-forms card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none admin-settings-provider-form" data-url="admin/settings.php?edit=ovh" aria-labelledby="settings-uploads-ovh-card-0">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 id="settings-uploads-ovh-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              {__("OVH Object Storage")}
            </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="ovh" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="ovh_enabled">{__("OVH Object Storage")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="ovh_enabled-help">
                  {__("Enable OVH Object Storage")} ({__("Note: Enable this will disable all other options")})
                </div>
              </div>
              <div class="text-end">
                <input type="checkbox" name="ovh_enabled" id="ovh_enabled" {if $system['ovh_enabled']}checked{/if} class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-describedby="ovh_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-74-label" for="settings-uploads-field-74">
                {__("Bucket Name")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="ovh_bucket" value="{$system['ovh_bucket']}" id="settings-uploads-field-74" aria-describedby="settings-uploads-field-74-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-74-help">
                  {__("Your OVH Object Storage bucket name")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-75-label" for="settings-uploads-field-75">
                {__("Bucket Region")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <select class="select w-full" name="ovh_region" id="settings-uploads-field-75" aria-describedby="settings-uploads-field-75-help">
                  <option value="gra" {if $system['ovh_region'] == "gra"}selected{/if}>Gravelines (GRA)</option>
                  <option value="rbx" {if $system['ovh_region'] == "rbx"}selected{/if}>Roubaix (RBX)</option>
                  <option value="sbg" {if $system['ovh_region'] == "sbg"}selected{/if}>Strasbourg (SBG)</option>
                  <option value="eu-west-par" {if $system['ovh_region'] == "eu-west-par"}selected{/if}>Paris (EU-WEST-PAR)</option>
                  <option value="eu-south-mil" {if $system['ovh_region'] == "eu-south-mil"}selected{/if}>Milan (EU-SOUTH-MIL)</option>
                  <option value="de" {if $system['ovh_region'] == "de"}selected{/if}>Frankfurt (DE)</option>
                  <option value="uk" {if $system['ovh_region'] == "uk"}selected{/if}>London (UK)</option>
                  <option value="waw" {if $system['ovh_region'] == "waw"}selected{/if}>Warsaw (WAW)</option>
                  <option value="bhs" {if $system['ovh_region'] == "bhs"}selected{/if}>Beauharnois (BHS)</option>
                  <option value="ca-east-tor" {if $system['ovh_region'] == "ca-east-tor"}selected{/if}>Toronto (CA-EAST-TOR)</option>
                  <option value="sgp" {if $system['ovh_region'] == "sgp"}selected{/if}>Singapore (SGP)</option>
                  <option value="ap-southeast-syd" {if $system['ovh_region'] == "ap-southeast-syd"}selected{/if}>Sydney (AP-SOUTHEAST-SYD)</option>
                  <option value="ap-south-mum" {if $system['ovh_region'] == "ap-south-mum"}selected{/if}>Mumbai (AP-SOUTH-MUM)</option>
                </select>
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-75-help">
                  {__("Your OVH Object Storage bucket region")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-76-label" for="settings-uploads-field-76">
                {__("Access Key")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="ovh_key" value="{$system['ovh_key']}" id="settings-uploads-field-76" aria-describedby="settings-uploads-field-76-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-76-help">
                  {__("Your OVH Object Storage Access Key")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-77-label" for="settings-uploads-field-77">
                {__("Secret Key")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="ovh_secret" value="{$system['ovh_secret']}" id="settings-uploads-field-77" aria-describedby="settings-uploads-field-77-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-77-help">
                  {__("Your OVH Object Storage Secret Key")}
                </div>
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4 admin-settings-provider-actions">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
              </div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
              </div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="button" class="btn btn-outline js_admin-tester" data-handle="ovh">
                <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection")}
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </form>
        <!-- OVH Object Storage -->
        <!-- Bunny Storage -->
        <form class="js_ajax-forms card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none admin-settings-provider-form" data-url="admin/settings.php?edit=bunny" aria-labelledby="settings-uploads-bunny-card-0">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 id="settings-uploads-bunny-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              {__("Bunny Storage")}
            </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="bunny" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="bunny_enabled">{__("Bunny Storage")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="bunny_enabled-help">
                  {__("Enable Bunny Storage")} ({__("Note: Enable this will disable all other options")})<br>
                  {__("S3 compatibility must be enabled when you create the storage zone")}
                </div>
              </div>
              <div class="text-end">
                <input type="checkbox" name="bunny_enabled" id="bunny_enabled" {if $system['bunny_enabled']}checked{/if} class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-describedby="bunny_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-78-label" for="settings-uploads-field-78">
                {__("Storage Zone Name / Bucket")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="bunny_zone" value="{$system['bunny_zone']}" id="settings-uploads-field-78" aria-describedby="settings-uploads-field-78-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-78-help">
                  {__("Access Key ID from your storage zone S3 credentials")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-79-label" for="settings-uploads-field-79">
                {__("Password")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="bunny_password" value="{$system['bunny_password']}" id="settings-uploads-field-79" aria-describedby="settings-uploads-field-79-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-79-help">
                  {__("Secret Access Key from your storage zone S3 credentials (not the Read-only password)")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-80-label" for="settings-uploads-field-80">
                {__("S3 Region Endpoint URL")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="bunny_endpoint" value="{if $system['bunny_region']}https://{$system['bunny_region']}-s3.storage.bunnycdn.com{/if}" placeholder="https://de-s3.storage.bunnycdn.com" id="settings-uploads-field-80" aria-describedby="settings-uploads-field-80-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-80-help">
                  {__("S3 Region Endpoint URL from your storage zone S3 credentials (Example: 'https://de-s3.storage.bunnycdn.com')")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-81-label" for="settings-uploads-field-81">
                {__("Pull Zone URL")} ({__("Optional")})
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="bunny_url" value="{$system['bunny_url']}" placeholder="{if $system['bunny_zone']}https://{$system['bunny_zone']}.b-cdn.net{else}https://example.b-cdn.net{/if}" id="settings-uploads-field-81" aria-describedby="settings-uploads-field-81-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-81-help">
                  {__("The Pull Zone connected to this storage zone. Leave it empty if your Pull Zone has the same name as your storage zone")}
                </div>
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4 admin-settings-provider-actions">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
              </div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
              </div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="button" class="btn btn-outline js_admin-tester" data-handle="bunny">
                <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection")}
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </form>
        <!-- Bunny Storage -->
        <!-- Storj -->
        <form class="js_ajax-forms card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none admin-settings-provider-form" data-url="admin/settings.php?edit=storj" aria-labelledby="settings-uploads-storj-card-0">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <h3 id="settings-uploads-storj-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
              {__("Storj")}
            </h3>

            <div class="admin-setting-switch js_admin-setting-switch">
              <div class="admin-setting-icon">
                {include file='__svg_icons.tpl' icon="storj" width="32px" height="32px"}
              </div>
              <div>
                <label class="admin-setting-label block text-sm font-medium leading-normal" for="storj_enabled">{__("Storj")}</label>
                <div class="admin-setting-help text-sm leading-relaxed" id="storj_enabled-help">
                  {__("Enable Storj storage")} ({__("Note: Enable this will disable all other options")})<br>
                  {__("Uploaded files are served publicly through your bucket share link")}
                </div>
              </div>
              <div class="text-end">
                <input type="checkbox" name="storj_enabled" id="storj_enabled" {if $system['storj_enabled']}checked{/if} class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-describedby="storj_enabled-help">
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-82-label" for="settings-uploads-field-82">
                {__("Bucket Name")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="storj_bucket" value="{$system['storj_bucket']}" id="settings-uploads-field-82" aria-describedby="settings-uploads-field-82-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-82-help">
                  {__("Your Storj bucket name")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-83-label" for="settings-uploads-field-83">
                {__("Access Key")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="storj_key" value="{$system['storj_key']}" id="settings-uploads-field-83" aria-describedby="settings-uploads-field-83-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-83-help">
                  {__("Your Storj S3 credentials Access Key")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-84-label" for="settings-uploads-field-84">
                {__("Secret Key")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="storj_secret" value="{$system['storj_secret']}" id="settings-uploads-field-84" aria-describedby="settings-uploads-field-84-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-84-help">
                  {__("Your Storj S3 credentials Secret Key")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-85-label" for="settings-uploads-field-85">
                {__("Share Link")}
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="storj_url" value="{$system['storj_url']}" placeholder="https://link.storjshare.io/s/KEY/BUCKET" id="settings-uploads-field-85" aria-describedby="settings-uploads-field-85-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-85-help">
                  {__("Paste the link from Share in the Storj console (Example: 'https://link.storjshare.io/s/KEY/BUCKET'), or your custom domain")}
                </div>
              </div>
            </div>
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" id="settings-uploads-field-86-label" for="settings-uploads-field-86">
                {__("Endpoint")} ({__("Optional")})
              </label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input type="text" class="input w-full" name="storj_endpoint" value="{$system['storj_endpoint']}" placeholder="https://gateway.storjshare.io" id="settings-uploads-field-86" aria-describedby="settings-uploads-field-86-help">
                <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-86-help">
                  {__("Leave it empty to use the Storj gateway")}
                </div>
              </div>
            </div>
          </div>
          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4 admin-settings-provider-actions">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
              </div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
              </div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="button" class="btn btn-outline js_admin-tester" data-handle="storj">
                <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection")}
              </button>
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </form>
        <!-- Storj -->
        </div>
      </div>
    </div>
    <!-- Cloud -->
    <!-- FTP -->
    <div class="admin-settings-panel js_admin-settings-panel hidden" id="FTP" role="tabpanel" aria-labelledby="settings-uploads-tab-2" tabindex="0">
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=ftp">
        <div class="alert alert-info admin-settings-notice [overflow-wrap:anywhere]">
          <div class="icon">
            <span class="icon-[tabler--server] size-8" aria-hidden="true"></span>
          </div>
          <div class="text">
            <strong>{__("FTP Storage")}</strong>
            <br>
            {__("Before enabling FTP Storage, make sure you upload the whole 'uploads' folder to your space")}.
            <br>
            {__("Before disabling FTP Storage, make sure you download the whole 'uploads' folder to your server")}.
          </div>
        </div>
                <div class="admin-settings-layout block">
<div class="admin-settings-form flex min-w-0 flex-col gap-4">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">

          <div class="admin-settings-section flex flex-col gap-5 p-6" aria-labelledby="settings-uploads-ftp-card-0">
          <h3 id="settings-uploads-ftp-card-0" class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
            {__("FTP storage")}
          </h3>

              <div class="admin-setting-switch js_admin-setting-switch">
                <div class="admin-setting-icon">
                  {include file='__svg_icons.tpl' icon="server" class="admin-setting-glyph" width="32px" height="32px"}
                </div>
                <div>
                  <label class="admin-setting-label block text-sm font-medium leading-normal" for="ftp_enabled">{__("FTP Storage")}</label>
                  <div class="admin-setting-help text-sm leading-relaxed" id="ftp_enabled-help">
                    {__("Enable FTP Storage upload")} ({__("Note: Enable this will disable all other options")})
                  </div>
                </div>
                <div class="text-end">
                  <input type="checkbox" name="ftp_enabled" id="ftp_enabled" {if $system['ftp_enabled']}checked{/if} class="switch switch-primary" aria-describedby="ftp_enabled-help">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-68-label" for="settings-uploads-field-68">
                  {__("Hostname")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="ftp_hostname" value="{$system['ftp_hostname']}" id="settings-uploads-field-68">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-uploads-field-68">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-69-label" for="settings-uploads-field-69">
                  {__("Port")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input type="text" class="input w-full" name="ftp_port" value="{$system['ftp_port']}" placeholder="21" id="settings-uploads-field-69">
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-70-label" for="settings-uploads-field-70">
                  {__("Username")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="ftp_username" value="{$system['ftp_username']}" id="settings-uploads-field-70">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-uploads-field-70">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-71-label" for="settings-uploads-field-71">
                  {__("Password")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="ftp_password" value="{$system['ftp_password']}" id="settings-uploads-field-71">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-uploads-field-71">
                  {/if}
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-72-label" for="settings-uploads-field-72">
                  {__("FTP Path")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="ftp_path" value="{$system['ftp_path']}" placeholder="./" id="settings-uploads-field-72" aria-describedby="settings-uploads-field-72-help">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-uploads-field-72" aria-describedby="settings-uploads-field-72-help">
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-72-help">
                    {__("The path to your uploads folder (Examples: './' or 'public_html/uploads')")}
                  </div>
                </div>
              </div>
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" id="settings-uploads-field-73-label" for="settings-uploads-field-73">
                  {__("FTP Endpoint")}
                </label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  {if !$user->_data['user_demo']}
                  <input type="text" class="input w-full" name="ftp_endpoint" value="{$system['ftp_endpoint']}" id="settings-uploads-field-73" aria-describedby="settings-uploads-field-73-help">
                  {else}
                  <input type="password" class="input w-full" value="*********" id="settings-uploads-field-73" aria-describedby="settings-uploads-field-73-help">
                  {/if}
                  <div class="admin-setting-help text-sm leading-relaxed" id="settings-uploads-field-73-help">
                    {__("The URL to your uploads folder (Examples: 'https://domain.com/uploads' or 'https://64.233.191.255/uploads')")}
                  </div>
                </div>
              </div>
        </div>
              <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
          <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
            <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none">
            </div>
            <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none">
            </div>
          </div>
          <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
            <button type="button" class="btn btn-outline js_admin-tester" data-handle="ftp">
              <span class="icon-[tabler--plug-connected] size-4" aria-hidden="true"></span> {__("Test Connection")}
            </button>
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
          </div>
        </div>
            </section>
          </div>
        </div>
      </form>
    </div>
    <!-- FTP -->
  </div>
  <!-- tabs content -->
</section>
