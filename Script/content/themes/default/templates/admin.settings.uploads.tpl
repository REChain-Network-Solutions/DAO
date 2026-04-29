<!-- card-header -->
<div class="card-header with-icon with-nav">
  <!-- panel title -->
  <div class="mb20">
    <i class="fa fa-cog mr10"></i>{__("Settings")} &rsaquo; {__("Uploads")}
  </div>
  <!-- panel title -->

  <!-- panel nav -->
  <ul class="nav nav-tabs">
    <li class="nav-item">
      <a class="nav-link active" href="#General" data-bs-toggle="tab">
        <i class="fa fa-upload fa-fw mr5"></i><strong class="pr5">{__("General")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#Cloud" data-bs-toggle="tab">
        <i class="fas fa-cloud-upload-alt fa-fw mr5"></i><strong class="pr5">{__("Cloud Hosting")}</strong>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#FTP" data-bs-toggle="tab">
        <i class="fa fa-server fa-fw mr5"></i><strong class="pr5">{__("FTP")}</strong>
      </a>
    </li>
  </ul>
  <!-- panel nav -->
</div>
<!-- card-header -->

<!-- tabs content -->
<div class="tab-content">
  <!-- General -->
  <div class="tab-pane active" id="General">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=uploads">
      <div class="card-body">
        <div class="alert alert-warning">
          <div class="icon">
            <i class="fa fa-exclamation-triangle fa-2x"></i>
          </div>
          <div class="text">
            {__("Your server max upload size")} = {$max_upload_size}<br>
            {__("You can't upload files larger than")} {$max_upload_size} - {__("To upload larger files, contact your hosting provider")}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Uploads Directory")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="uploads_directory" value="{$system['uploads_directory']}">
            <div class="form-text">
              {__("The path of uploads local directory")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Uploads Prefix")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="uploads_prefix" value="{$system['uploads_prefix']}">
            <div class="form-text">
              {__("Add a prefix to the uploaded files (No spaces or special characters only like 'mysite' or 'my_site')")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Uploads CDN Endpoint")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="uploads_cdn_url" value="{$system['uploads_cdn_url']}">
            <div class="form-text">
              {__("Your CDN URL like AWS CloudFront")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Maximum Total Upload Size")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="max_daily_upload_size" value="{$system['max_daily_upload_size']}">
            <div class="form-text">
              {__("The Maximum total size of uploaded files per day per user")} {__("in kilobytes (1M = 1024KB)")} ({__("0 = Unlimited")})
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Chunk Upload Size")}
          </label>
          <div class="col-md-9">
            <select class="form-control" name="chunk_upload_size">
              <option value="10" {if $system['chunk_upload_size'] == 10}selected{/if}>10 MB</option>
              <option value="20" {if $system['chunk_upload_size'] == 20}selected{/if}>20 MB</option>
              <option value="50" {if $system['chunk_upload_size'] == 50}selected{/if}>50 MB</option>
              <option value="100" {if $system['chunk_upload_size'] == 100}selected{/if}>100 MB</option>
              <option value="200" {if $system['chunk_upload_size'] == 200}selected{/if}>200 MB</option>
            </select>
            <div class="form-text">
              {__("The size of each chunk of the uploaded file in megabytes")}<br>
              {__("This is useful for large files to avoid server timeouts")}
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="photos" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Photo Upload")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable photo upload to share & upload photos to the site")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="photos_enabled">
              <input type="checkbox" name="photos_enabled" id="photos_enabled" {if $system['photos_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <div style="width: 40px; height: 40px;"></div>
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Photo Upload in Comments")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable photo upload in comments")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="comments_photos_enabled">
              <input type="checkbox" name="comments_photos_enabled" id="comments_photos_enabled" {if $system['comments_photos_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <div style="width: 40px; height: 40px;"></div>
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Photo Upload in Chat")} </div>
            <div class="form-text d-none d-sm-block">{__("Enable photo upload in chat")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="chat_photos_enabled">
              <input type="checkbox" name="chat_photos_enabled" id="chat_photos_enabled" {if $system['chat_photos_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <div style="width: 40px; height: 40px;"></div>
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Photo Upload in Blogs and Forums")} </div>
            <div class="form-text d-none d-sm-block">{__("Enable photo upload in blogs and forums threads")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="tinymce_photos_enabled">
              <input type="checkbox" name="tinymce_photos_enabled" id="tinymce_photos_enabled" {if $system['tinymce_photos_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Max Photo Size")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="max_photo_size" value="{$system['max_photo_size']}">
            <div class="form-text">
              {__("The Maximum size of uploaded photo in posts")} {__("in kilobytes (1M = 1024KB)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Photo Quality")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="uploads_quality">
              <option value="high" {if $system['uploads_quality'] == "high"}selected{/if}>{__("High quality photos with low compression")}</option>
              <option value="medium" {if $system['uploads_quality'] == "medium"}selected{/if}>{__("Medium quality photos with medium compression")}</option>
              <option value="low" {if $system['uploads_quality'] == "low"}selected{/if}>{__("Low quality photos with high compression")}</option>
            </select>
          </div>
        </div>

        <div class="divider dashed"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="heif" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Support HEIF/HEIC Images")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable support for HEIF/HEIC images")}<br>
              {__("Note: PHP Imagick extension is required to support HEIF/HEIC images")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="allow_heif_images">
              <input type="checkbox" name="allow_heif_images" id="allow_heif_images" {if $system['allow_heif_images']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="divider dashed"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="gif" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Animated Images for Avatars/Covers")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable user to upload animated images for avarats and covers")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="allow_animated_images">
              <input type="checkbox" name="allow_animated_images" id="allow_animated_images" {if $system['allow_animated_images']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="resolution" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Cover Photo Resolution Limit")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable cover photo limit (Minimum width 1296px & Minimum height 360px)")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="limit_cover_photo">
              <input type="checkbox" name="limit_cover_photo" id="limit_cover_photo" {if $system['limit_cover_photo']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="crop" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Cover Photo Crop")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable cover photo crop")} ({__("Note: If disabled, the cover position will used instead")})</div>
          </div>
          <div class="text-end">
            <label class="switch" for="cover_crop_enabled">
              <input type="checkbox" name="cover_crop_enabled" id="cover_crop_enabled" {if $system['cover_crop_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Max Cover Photo Size")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="max_cover_size" value="{$system['max_cover_size']}">
            <div class="form-text">
              {__("The Maximum size of cover photo")} {__("in kilobytes (1 M = 1024 KB)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Max Profile Photo Size")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="max_avatar_size" value="{$system['max_avatar_size']}">
            <div class="form-text">
              {__("The Maximum size of profile photo")} {__("in kilobytes (1 M = 1024 KB)")}
            </div>
          </div>
        </div>

        <div class="divider dashed"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="watermark" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Watermark Images")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable it to add watermark icon to all uploaded photos (except: profile pictures and cover images)")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="watermark_enabled">
              <input type="checkbox" name="watermark_enabled" id="watermark_enabled" {if $system['watermark_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Watermark Type")}
          </label>
          <div class="col-md-9">
            <div class="form-check form-check-inline">
              <input type="radio" name="watermark_type" id="watermark_icon" value="icon" class="form-check-input" {if $system['watermark_type'] == "icon"}checked{/if}>
              <label class="form-check-label" for="watermark_icon">{__("Icon")}</label>
            </div>
            <div class="form-check form-check-inline">
              <input type="radio" name="watermark_type" id="watermark_username" value="username" class="form-check-input" {if $system['watermark_type'] == "username"}checked{/if}>
              <label class="form-check-label" for="watermark_username">{__("Username")}</label>
            </div>
            <div class="form-text">
              {__("Note: The username watermark will be repeated diagonally across the image")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Watermark Opacity")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="watermark_opacity" value="{$system['watermark_opacity']}">
            <div class="form-text">
              {__("The opacity level of the watermark icon (value between 0 - 1)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Watermark Icon")}
          </label>
          <div class="col-md-9">
            {if $system['watermark_icon'] == ''}
              <div class="x-image">
                <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'>

                </button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-uploader-input" name="watermark_icon" value="">
              </div>
            {else}
              <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$system['watermark_icon']}')">
                <button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'>

                </button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-uploader-input" name="watermark_icon" value="{$system['watermark_icon']}">
              </div>
            {/if}
            <div class="form-text">
              {__("Upload your watermark icon (PNG is recommended)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Watermark Icon Position")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="watermark_position">
              <option {if $system['watermark_position'] == "top left"}selected{/if} value="top left">{__("Top Left")}</option>
              <option {if $system['watermark_position'] == "top right"}selected{/if} value="top right">{__("Top Right")}</option>
              <option {if $system['watermark_position'] == "top"}selected{/if} value="top">{__("Top")}</option>
              <option {if $system['watermark_position'] == "bottom left"}selected{/if} value="bottom left">{__("Bottom Left")}</option>
              <option {if $system['watermark_position'] == "bottom right"}selected{/if} value="bottom right">{__("Bottom Right")}</option>
              <option {if $system['watermark_position'] == "bottom"}selected{/if} value="bottom">{__("Bottom")}</option>
              <option {if $system['watermark_position'] == "left"}selected{/if} value="left">{__("Left")}</option>
              <option {if $system['watermark_position'] == "right"}selected{/if} value="right">{__("Right")}</option>
            </select>
            <div class="form-text">
              {__("Select the position (the anchor point) of your watermark icon")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Watermark Icon X Offset")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="watermark_xoffset" value="{$system['watermark_xoffset']}">
            <div class="form-text">
              {__("Horizontal offset in pixels")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Watermark Icon Y Offset")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="watermark_yoffset" value="{$system['watermark_yoffset']}">
            <div class="form-text">
              {__("Vertical offset in pixels")}
            </div>
          </div>
        </div>

        <div class="divider dashed"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="adult" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Adult Images Detection")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable it to detect the adult images and system will blur or delete them")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="adult_images_enabled">
              <input type="checkbox" name="adult_images_enabled" id="adult_images_enabled" {if $system['adult_images_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Adult Images Action")}
          </label>
          <div class="col-md-9">
            <div class="form-check form-check-inline">
              <input type="radio" name="adult_images_action" id="action_blue" value="blur" class="form-check-input" {if $system['adult_images_action'] == "blur"}checked{/if}>
              <label class="form-check-label" for="action_blue">{__("Blur")}</label>
            </div>
            <div class="form-check form-check-inline">
              <input type="radio" name="adult_images_action" id="action_delete" value="delete" class="form-check-input" {if $system['adult_images_action'] == "delete"}checked{/if}>
              <label class="form-check-label" for="action_delete">{__("Delete")}</label>
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Google Vision API Key")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="adult_images_api_key" value="{$system['adult_images_api_key']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("Your Cloud Vision API Key")}
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="videos" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Video Upload")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable video upload to share & upload videos to the site")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="videos_enabled">
              <input type="checkbox" name="videos_enabled" id="videos_enabled" {if $system['videos_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            <div style="width: 40px; height: 40px;"></div>
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Video Upload in Chat")} </div>
            <div class="form-text d-none d-sm-block">{__("Enable video upload in chat")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="chat_videos_enabled">
              <input type="checkbox" name="chat_videos_enabled" id="chat_videos_enabled" {if $system['chat_videos_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Max video size")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="max_video_size" value="{$system['max_video_size']}">
            <div class="form-text">
              {__("The Maximum size of uploaded video in posts")} {__("in kilobytes (1M = 1024KB)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Video extensions")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="video_extensions" value="{$system['video_extensions']}">
            <div class="form-text">
              {__("Allowed video extensions (separated with comma ',')")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Video Minimum Duration")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="video_minimum_duration" value="{$system['video_minimum_duration']}">
            <div class="form-text">
              {__("The Minimum duration of the video in seconds (0 for unlimited)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Video Maximum Duration")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="video_maximum_duration" value="{$system['video_maximum_duration']}">
            <div class="form-text">
              {__("The Maximum duration of the video in seconds (0 for unlimited)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Reel Minimum Duration")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="reels_minimum_duration" value="{$system['reels_minimum_duration']}">
            <div class="form-text">
              {__("The Minimum duration of the reel in seconds (0 for unlimited)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Reel Maximum Duration")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="reels_maximum_duration" value="{$system['reels_maximum_duration']}">
            <div class="form-text">
              {__("The Maximum duration of the reel in seconds (0 for unlimited)")}
            </div>
          </div>
        </div>

        <div class="divider dashed"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="ffmpeg" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("FFMPEG Enabled")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable FFMPEG to convert and optimize videos to mp4")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="ffmpeg_enabled">
              <input type="checkbox" name="ffmpeg_enabled" id="ffmpeg_enabled" {if $system['ffmpeg_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("FFMPEG Binary Path")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="ffmpeg_path" value="{$system['ffmpeg_path']}">
            <div class="form-text">
              {__("Example: Linux(/usr/bin/ffmpeg) or Windows(C:\\ffmpeg\bin\ffmpeg.exe)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("FFMPEG Conversion Speed")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="ffmpeg_speed">
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
            <div class="form-text">
              {__("Slow speed gives you better compression and quality and vice versa")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Video Resolutions")}
          </label>
          <div class="col-md-9">
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="ffmpeg_240p_enabled" id="ffmpeg_240p_enabled" {if $system['ffmpeg_240p_enabled']}checked{/if}>
              <label class="form-check-label" for="ffmpeg_240p_enabled">{__("240p Resolution")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="ffmpeg_360p_enabled" id="ffmpeg_360p_enabled" {if $system['ffmpeg_360p_enabled']}checked{/if}>
              <label class="form-check-label" for="ffmpeg_360p_enabled">{__("360p Resolution")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="ffmpeg_480p_enabled" id="ffmpeg_480p_enabled" {if $system['ffmpeg_480p_enabled']}checked{/if}>
              <label class="form-check-label" for="ffmpeg_480p_enabled">{__("480p Resolution")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="ffmpeg_720p_enabled" id="ffmpeg_720p_enabled" {if $system['ffmpeg_720p_enabled']}checked{/if}>
              <label class="form-check-label" for="ffmpeg_720p_enabled">{__("720p Resolution")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="ffmpeg_1080p_enabled" id="ffmpeg_1080p_enabled" {if $system['ffmpeg_1080p_enabled']}checked{/if}>
              <label class="form-check-label" for="ffmpeg_1080p_enabled">{__("1080p Resolution")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="ffmpeg_1440p_enabled" id="ffmpeg_1440p_enabled" {if $system['ffmpeg_1440p_enabled']}checked{/if}>
              <label class="form-check-label" for="ffmpeg_1440p_enabled">{__("1440p Resolution")}</label>
            </div>
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="ffmpeg_2160p_enabled" id="ffmpeg_2160p_enabled" {if $system['ffmpeg_2160p_enabled']}checked{/if}>
              <label class="form-check-label" for="ffmpeg_2160p_enabled">{__("2160p Resolution")}</label>
            </div>
            <span class="form-text mt10">
              {__("Select the resolutions you want to convert your videos to")}
            </span>
          </div>
        </div>

        <div class="divider dashed"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="watermark" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Watermark Videos")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable it to add watermark icon to all uploaded videos (Note: FFmpeg must be enabled)")}
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="watermark_videos_enabled">
              <input type="checkbox" name="watermark_videos_enabled" id="watermark_videos_enabled" {if $system['watermark_videos_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Watermark Icon")}
          </label>
          <div class="col-md-9">
            {if $system['watermark_videos_icon'] == ''}
              <div class="x-image">
                <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'>

                </button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-uploader-input" name="watermark_videos_icon" value="">
              </div>
            {else}
              <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$system['watermark_videos_icon']}')">
                <button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'>

                </button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-uploader-input" name="watermark_videos_icon" value="{$system['watermark_videos_icon']}">
              </div>
            {/if}
            <div class="form-text">
              {__("Upload your watermark icon (PNG is recommended)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Watermark Position")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="watermark_videos_position">
              <option {if $system['watermark_videos_position'] == "top_left"}selected{/if} value="top_left">{__("Top Left")}</option>
              <option {if $system['watermark_videos_position'] == "top_right"}selected{/if} value="top_right">{__("Top Right")}</option>
              <option {if $system['watermark_videos_position'] == "center"}selected{/if} value="center">{__("Center")}</option>
              <option {if $system['watermark_videos_position'] == "bottom_left"}selected{/if} value="bottom_left">{__("Bottom Left")}</option>
              <option {if $system['watermark_videos_position'] == "bottom_right"}selected{/if} value="bottom_right">{__("Bottom Right")}</option>
            </select>
            <div class="form-text">
              {__("Select the position (the anchor point) of your watermark icon")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Watermark Opacity")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="watermark_videos_opacity" value="{$system['watermark_videos_opacity']}">
            <div class="form-text">
              {__("The opacity level of the watermark icon (value between 0 - 1)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Watermark X Offset")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="watermark_videos_xoffset" value="{$system['watermark_videos_xoffset']}">
            <div class="form-text">
              {__("Horizontal offset in pixels")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Watermark Y Offset")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="watermark_videos_yoffset" value="{$system['watermark_videos_yoffset']}">
            <div class="form-text">
              {__("Vertical offset in pixels")}
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="audios" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Audio Upload")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable audio upload to share & upload sounds to the site")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="audio_enabled">
              <input type="checkbox" name="audio_enabled" id="audio_enabled" {if $system['audio_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Max audio size")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="max_audio_size" value="{$system['max_audio_size']}">
            <div class="form-text">
              {__("The Maximum size of uploaded audio in posts")} {__("in kilobytes (1M = 1024KB)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Audio extensions")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="audio_extensions" value="{$system['audio_extensions']}">
            <div class="form-text">
              {__("Allowed audio extensions (separated with comma ',')")}
            </div>
          </div>
        </div>

        <div class="divider"></div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="files" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("File Upload")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable file upload to share & upload files to the site")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="file_enabled">
              <input type="checkbox" name="file_enabled" id="file_enabled" {if $system['file_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="security" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6 mb5">{__("Mask Uploaded File Path")}</div>
            <div class="form-text d-none d-sm-block">{__("Enable it to mask the uploaded file path")}</div>
          </div>
          <div class="text-end">
            <label class="switch" for="mask_file_path_enabled">
              <input type="checkbox" name="mask_file_path_enabled" id="mask_file_path_enabled" {if $system['mask_file_path_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Max file size")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="max_file_size" value="{$system['max_file_size']}">
            <div class="form-text">
              {__("The Maximum size of uploaded file in posts")} {__("in kilobytes (1M = 1024KB)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("File extensions")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="file_extensions" value="{$system['file_extensions']}">
            <div class="form-text">
              {__("Allowed file extensions (separated with comma ',')")}
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
        <button type="button" class="btn btn-danger js_admin-tester" data-handle="ffmpeg">
          <i class="fa fa-bolt mr10"></i> {__("Test Connection (FFMPEG)")}
        </button>
        <button type="button" class="btn btn-danger js_admin-tester" data-handle="google_vision">
          <i class="fa fa-bolt mr10"></i> {__("Test Connection (Vision API)")}
        </button>
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>
  </div>
  <!-- General -->

  <!-- Cloud -->
  <div class="tab-pane" id="Cloud">
    <div class="card-body">

      <div class="alert alert-primary">
        <div class="icon">
          <i class="fas fa-cloud-upload-alt fa-2x"></i>
        </div>
        <div class="text">
          <strong>{__("Cloud Hosting")}</strong><br>
          {__("Before enabling cloud hosting, make sure you upload the whole 'uploads' folder to your bucket")}.<br>
          {__("Before disabling cloud hosting, make sure you download the whole 'uploads' folder to your server")}.
        </div>
      </div>

      <!-- S3 -->
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=s3">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="aws_s3" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Amazon S3 Storage")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable Amazon S3 storage")} ({__("Note: Enable this will disable all other options")})
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="s3_enabled">
              <input type="checkbox" name="s3_enabled" id="s3_enabled" {if $system['s3_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bucket Name")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="s3_bucket" value="{$system['s3_bucket']}">
            <div class="form-text">
              {__("Your Amazon S3 bucket name")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bucket Region")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="s3_region">
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
            <div class="form-text">
              {__("Your Amazon S3 bucket region")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Access Key ID")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="s3_key" value="{$system['s3_key']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("Your Amazon S3 Access Key ID")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Access Key Secret")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="s3_secret" value="{$system['s3_secret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("Your Amazon S3 Access Key Secret")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label"></label>
          <div class="col-md-9">
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            <button type="button" class="btn btn-danger js_admin-tester" data-handle="s3">
              <i class="fa fa-bolt mr10"></i> {__("Test Connection")}
            </button>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </form>
      <!-- S3 -->

      <div class="divider"></div>

      <!-- Google -->
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=google_cloud">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="google_cloud" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Google Cloud")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable Google Cloud storage")} ({__("Note: Enable this will disable all other options")})
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="google_cloud_enabled">
              <input type="checkbox" name="google_cloud_enabled" id="google_cloud_enabled" {if $system['google_cloud_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bucket Name")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="google_cloud_bucket" value="{$system['google_cloud_bucket']}">
            <div class="form-text">
              {__("Your Google Cloud bucket name")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Google Cloud File")}
          </label>
          <div class="col-md-9">
            <textarea name="google_cloud_file" id="google_cloud_file">{$system['google_cloud_file']}</textarea>
            <div class="form-text">
              {__("Your service account keys JSON")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label"></label>
          <div class="col-md-9">
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            <button type="button" class="btn btn-danger js_admin-tester" data-handle="google_cloud">
              <i class="fa fa-bolt mr10"></i> {__("Test Connection")}
            </button>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </form>
      <!-- Google -->

      <div class="divider"></div>

      <!-- DigitalOcean -->
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=digitalocean">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="digitalocean" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("DigitalOcean Space")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable DigitalOcean storage")} ({__("Note: Enable this will disable all other options")})
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="digitalocean_enabled">
              <input type="checkbox" name="digitalocean_enabled" id="digitalocean_enabled" {if $system['digitalocean_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Space Name")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="digitalocean_space_name" value="{$system['digitalocean_space_name']}">
            <div class="form-text">
              {__("Your DigitalOcean space name")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Space Region")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="digitalocean_space_region">
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
            <div class="form-text">
              {__("Your DigitalOcean space region")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Access Key ID")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="digitalocean_key" value="{$system['digitalocean_key']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("Your DigitalOcean Access Key ID")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Access Key Secret")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="digitalocean_secret" value="{$system['digitalocean_secret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("Your DigitalOcean Access Key Secret")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label"></label>
          <div class="col-md-9">
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            <button type="button" class="btn btn-danger js_admin-tester" data-handle="digitalocean">
              <i class="fa fa-bolt mr10"></i> {__("Test Connection")}
            </button>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mb20 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </form>
      <!-- DigitalOcean -->

      <div class="divider"></div>

      <!-- Wasabi -->
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=wasabi">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="wasabi" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Wasabi")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable Wasabi storage")} ({__("Note: Enable this will disable all other options")})
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="wasabi_enabled">
              <input type="checkbox" name="wasabi_enabled" id="wasabi_enabled" {if $system['wasabi_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bucket Name")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="wasabi_bucket" value="{$system['wasabi_bucket']}">
            <div class="form-text">
              {__("Your Wasabi bucket name")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bucket Region")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="wasabi_region">
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
            <div class="form-text">
              {__("Your Wasabi bucket region")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Access Key ID")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="wasabi_key" value="{$system['wasabi_key']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("Your Wasabi Access Key ID")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Access Key Secret")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="wasabi_secret" value="{$system['wasabi_secret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("Your Wasabi Access Key Secret")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label"></label>
          <div class="col-md-9">
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            <button type="button" class="btn btn-danger js_admin-tester" data-handle="wasabi">
              <i class="fa fa-bolt mr10"></i> {__("Test Connection")}
            </button>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </form>
      <!-- Wasabi -->

      <div class="divider"></div>

      <!-- Backblaze -->
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=backblaze">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="backblaze" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Backblaze")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable Backblaze storage")} ({__("Note: Enable this will disable all other options")})
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="backblaze_enabled">
              <input type="checkbox" name="backblaze_enabled" id="backblaze_enabled" {if $system['backblaze_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bucket Name")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="backblaze_bucket" value="{$system['backblaze_bucket']}">
            <div class="form-text">
              {__("Your Backblaze bucket name")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bucket Region")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="backblaze_region">
              <option value="eu-central-003" {if $system['backblaze_region'] == "eu-central-003"}selected{/if}>eu-central-003</option>
              <option value="us-west-004" {if $system['backblaze_region'] == "us-west-004"}selected{/if}>us-west-004</option>
              <option value="us-east-005" {if $system['backblaze_region'] == "us-east-005"}selected{/if}>us-east-005</option>
            </select>
            <div class="form-text">
              {__("Your Backblaze bucket region")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Access Key ID")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="backblaze_key" value="{$system['backblaze_key']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("Your Backblaze Access Key ID")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Access Key Secret")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="backblaze_secret" value="{$system['backblaze_secret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("Your Backblaze Access Key Secret")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label"></label>
          <div class="col-md-9">
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            <button type="button" class="btn btn-danger js_admin-tester" data-handle="backblaze">
              <i class="fa fa-bolt mr10"></i> {__("Test Connection")}
            </button>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </form>
      <!-- Backblaze -->

      <div class="divider"></div>

      <!-- Yandex Cloud -->
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=yandex_cloud">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="yandex" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Yandex Cloud")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable Yandex Cloud Storage")} ({__("Note: Enable this will disable all other options")})
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="yandex_cloud_enabled">
              <input type="checkbox" name="yandex_cloud_enabled" id="yandex_cloud_enabled" {if $system['yandex_cloud_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bucket Name")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="yandex_cloud_bucket" value="{$system['yandex_cloud_bucket']}">
            <div class="form-text">
              {__("Your Yandex Cloud bucket name")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bucket Region")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="yandex_cloud_region">
              <option value="ru-central1" {if $system['yandex_cloud_region'] == "ru-central1"}selected{/if}>ru-central1</option>
              <option value="kz1" {if $system['yandex_cloud_region'] == "kz1"}selected{/if}>kz1</option>
            </select>
            <div class="form-text">
              {__("Your Yandex Cloud bucket region")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Access Key ID")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="yandex_cloud_key" value="{$system['yandex_cloud_key']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("Your Yandex Cloud Access Key ID")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Access Key Secret")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="yandex_cloud_secret" value="{$system['yandex_cloud_secret']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("Your Yandex Cloud Access Key Secret")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label"></label>
          <div class="col-md-9">
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            <button type="button" class="btn btn-danger js_admin-tester" data-handle="yandex_cloud">
              <i class="fa fa-bolt mr10"></i> {__("Test Connection")}
            </button>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </form>
      <!-- Yandex Cloud -->

      <div class="divider"></div>

      <!-- Cloudflare R2 -->
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=cloudflare_r2">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="cloudflare" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Cloudflare R2")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable Cloudflare R2 storage")} ({__("Note: Enable this will disable all other options")})
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="cloudflare_r2_enabled">
              <input type="checkbox" name="cloudflare_r2_enabled" id="cloudflare_r2_enabled" {if $system['cloudflare_r2_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bucket Name")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="cloudflare_r2_bucket" value="{$system['cloudflare_r2_bucket']}">
            <div class="form-text">
              {__("Your Cloudflare R2 bucket name")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Access Key ID")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="cloudflare_r2_key" value="{$system['cloudflare_r2_key']}">
            <div class="form-text">
              {__("Your Cloudflare R2 Access Key ID")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Access Key Secret")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="cloudflare_r2_secret" value="{$system['cloudflare_r2_secret']}">
            <div class="form-text">
              {__("Your Cloudflare R2 Access Key Secret")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Endpoint")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="cloudflare_r2_endpoint" value="{$system['cloudflare_r2_endpoint']}">
            <div class="form-text">
              {__("Your Cloudflare R2 Endpoint")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Custom Domain")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="cloudflare_r2_custom_domain" value="{$system['cloudflare_r2_custom_domain']}">
            <div class="form-text">
              {__("Your Cloudflare R2 Custom Domain (Example: 'https://cloud.sngine.com')")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label"></label>
          <div class="col-md-9">
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            <button type="button" class="btn btn-danger js_admin-tester" data-handle="cloudflare_r2">
              <i class="fa fa-bolt mr10"></i> {__("Test Connection")}
            </button>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </form>
      <!-- Cloudflare R2 -->

      <div class="divider"></div>

      <!-- Pushr -->
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=pushr">
        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="pushr" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("Pushr")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable Pushr")} ({__("Note: Enable this will disable all other options")})
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="pushr_enabled">
              <input type="checkbox" name="pushr_enabled" id="pushr_enabled" {if $system['pushr_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Bucket Name")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="pushr_bucket" value="{$system['pushr_bucket']}">
            <div class="form-text">
              {__("Your Pushr bucket name")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Access Key")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="pushr_key" value="{$system['pushr_key']}">
            <div class="form-text">
              {__("Your Pushr Access Key")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Secret Key")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="pushr_secret" value="{$system['pushr_secret']}">
            <div class="form-text">
              {__("Your Pushr Secret Key")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Region Endpoint")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="pushr_endpoint" value="{$system['pushr_endpoint']}">
            <div class="form-text">
              {__("Your Pushr Region Endpoint")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("CDN Hostname")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="pushr_hostname" value="{$system['pushr_hostname']}">
            <div class="form-text">
              {__("Your Pushr CDN Hostname (Example: 'https://XXXX.s3.de01.sonic.r-cdn.com')")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label"></label>
          <div class="col-md-9">
            <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            <button type="button" class="btn btn-danger js_admin-tester" data-handle="pushr">
              <i class="fa fa-bolt mr10"></i> {__("Test Connection")}
            </button>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </form>
      <!-- Pushr -->
    </div>
  </div>
  <!-- Cloud -->

  <!-- FTP -->
  <div class="tab-pane" id="FTP">
    <form class="js_ajax-forms" data-url="admin/settings.php?edit=ftp">
      <div class="card-body">
        <div class="alert alert-primary">
          <div class="icon">
            <i class="fa fa-server fa-2x"></i>
          </div>
          <div class="text">
            <strong>{__("FTP Storage")}</strong><br>
            {__("Before enabling FTP Storage, make sure you upload the whole 'uploads' folder to your space")}.<br>
            {__("Before disabling FTP Storage, make sure you download the whole 'uploads' folder to your server")}.
          </div>
        </div>

        <div class="form-table-row">
          <div class="avatar">
            {include file='__svg_icons.tpl' icon="server" class="main-icon" width="40px" height="40px"}
          </div>
          <div>
            <div class="form-label h6">{__("FTP Storage")}</div>
            <div class="form-text d-none d-sm-block">
              {__("Enable FTP Storage upload")} ({__("Note: Enable this will disable all other options")})
            </div>
          </div>
          <div class="text-end">
            <label class="switch" for="ftp_enabled">
              <input type="checkbox" name="ftp_enabled" id="ftp_enabled" {if $system['ftp_enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Hostname")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="ftp_hostname" value="{$system['ftp_hostname']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Port")}
          </label>
          <div class="col-md-9">
            <input type="text" class="form-control" name="ftp_port" value="{$system['ftp_port']}" placeholder="21">
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Username")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="ftp_username" value="{$system['ftp_username']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Password")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="ftp_password" value="{$system['ftp_password']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("FTP Path")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="ftp_path" value="{$system['ftp_path']}" placeholder="./">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("The path to your uploads folder (Examples: './' or 'public_html/uploads')")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("FTP Endpoint")}
          </label>
          <div class="col-md-9">
            {if !$user->_data['user_demo']}
              <input type="text" class="form-control" name="ftp_endpoint" value="{$system['ftp_endpoint']}">
            {else}
              <input type="password" class="form-control" value="*********">
            {/if}
            <div class="form-text">
              {__("The URL to your uploads folder (Examples: 'https://domain.com/uploads' or 'https://64.233.191.255/uploads')")}
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
        <button type="button" class="btn btn-danger js_admin-tester" data-handle="ftp">
          <i class="fa fa-bolt mr10"></i> {__("Test Connection")}
        </button>
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>
  </div>
  <!-- FTP -->
</div>
<!-- tabs content -->