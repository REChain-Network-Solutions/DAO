<div id="publisher-wapper-modal" class="flex min-h-0 flex-1">
  <div class="x-form publisher relative flex min-h-0 w-full flex-col overflow-hidden [&_.x-uploader]:relative [&_.x-uploader]:cursor-pointer [&_.x-uploader]:overflow-hidden [&_.x-uploader>input[type=file]]:absolute [&_.x-uploader>input[type=file]]:inset-0 [&_.x-uploader>input[type=file]]:z-10 [&_.x-uploader>input[type=file]]:size-full [&_.x-uploader>input[type=file]]:cursor-pointer [&_.x-uploader>input[type=file]]:opacity-0 [&_.x-progress]:h-1.5 [&_.x-progress]:overflow-hidden [&_.x-progress]:rounded-full [&_.x-progress]:bg-base-300 [&_.progress-bar]:h-full [&_.progress-bar]:bg-primary" data-id="{$cid}" data-modal-mode="true">

    <!-- publisher loader -->
    <div class="publisher-loader absolute inset-0 z-40 hidden bg-base-100/80 backdrop-blur-sm">
      <div class="flex size-full items-center justify-center">
        <div class="loading loading-spinner loading-lg text-primary"></div>
      </div>
    </div>
    <!-- publisher loader -->

    <!-- publisher-identity -->
    <div class="flex shrink-0 items-center gap-3 px-4 pt-4 sm:px-5">
      <img class="size-11 shrink-0 rounded-full object-cover" src="{$user->_data['user_picture']}" alt="">
      <div class="min-w-0 flex-1">
        <div class="truncate text-sm font-semibold text-base-content" title="{$user->_data['user_fullname']}">{$user->_data['user_fullname']}</div>
        <div class="mt-1 flex">
          <span class="badge badge-soft badge-success badge-lg min-w-0 gap-1 rounded-full text-xs font-medium">
            <span class="icon-[tabler--message-dollar] size-3.5 shrink-0" aria-hidden="true"></span>
            <span class="truncate" title="{__("Send a Paid Message")}">{__("Send a Paid Message")}</span>
          </span>
        </div>
      </div>
    </div>
    <!-- publisher-identity -->

    <!-- publisher-message -->
    <div class="publisher-message flex shrink-0 px-4 py-3 sm:px-5">
      <textarea autofocus dir="auto" class="js_autosize min-h-24 w-full resize-none bg-transparent p-0 text-base leading-6 text-base-content outline-none placeholder:text-base-content/45" data-init-placeholder='{__("Write a message")}' placeholder='{__("Write a message")}'></textarea>
    </div>
    <!-- publisher-message -->

    <!-- publisher content -->
    <div class="publisher-slider min-h-0 flex-1 overflow-y-auto [&_.publisher-attachments>ul]:m-0 [&_.publisher-attachments>ul]:grid [&_.publisher-attachments>ul]:list-none [&_.publisher-attachments>ul]:grid-cols-2 [&_.publisher-attachments>ul]:gap-2 [&_.publisher-attachments>ul]:p-0 sm:[&_.publisher-attachments>ul]:grid-cols-3">
      <div class="publisher-attachments attachments mx-4 mb-2.5 hidden sm:mx-5 js_attachments-photos"></div>
      <div class="publisher-attachments attachments mx-4 mb-2.5 hidden sm:mx-5 js_attachments-video"></div>
      <div class="publisher-attachments attachments mx-4 mb-2.5 hidden sm:mx-5 js_attachments-audio"></div>
      <div class="publisher-attachments attachments mx-4 mb-2.5 hidden sm:mx-5 js_attachments-file"></div>

      <!-- upload states -->
      <div class="publisher-meta mx-4 mb-2.5 hidden items-center gap-2.5 rounded-field bg-success/10 px-3 py-2 text-sm font-medium text-success sm:mx-5" data-meta="video">
        <span class="icon-[tabler--circle-check] size-5 shrink-0" aria-hidden="true"></span>
        <span class="min-w-0 flex-1">{__("Video uploaded successfully")}</span>
        <button class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full js_publisher-attachment-file-remover border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100" type="button" data-type="video" aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
      </div>
      <div class="publisher-meta mx-4 mb-2.5 hidden items-center gap-2.5 rounded-field bg-success/10 px-3 py-2 text-sm font-medium text-success sm:mx-5" data-meta="audio">
        <span class="icon-[tabler--circle-check] size-5 shrink-0" aria-hidden="true"></span>
        <span class="min-w-0 flex-1">{__("Audio uploaded successfully")}</span>
        <button class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full js_publisher-attachment-file-remover border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100" type="button" data-type="audio" aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
      </div>
      <div class="publisher-meta mx-4 mb-2.5 hidden items-center gap-2.5 rounded-field bg-success/10 px-3 py-2 text-sm font-medium text-success sm:mx-5" data-meta="file">
        <span class="icon-[tabler--circle-check] size-5 shrink-0" aria-hidden="true"></span>
        <span class="min-w-0 flex-1">{__("File uploaded successfully")}</span>
        <button class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full js_publisher-attachment-file-remover border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100" type="button" data-type="file" aria-label='{__("Remove")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
      </div>
      <!-- upload states -->

      <!-- message settings -->
      <div class="publisher-footer-options space-y-3 px-4 py-3 sm:px-5 [--color-neutral:var(--color-base-content)] [&_.switch:disabled]:before:bg-current">
        {if $system['adult_mode']}
          <div class="grid grid-cols-[auto_minmax(0,1fr)_auto] items-center gap-3 rounded-[1rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.5rem] bg-base-200/60 px-3 py-2.5" id="adult-toggle-wrapper">
            <span class="flex size-9 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-current/20 text-error"><span class="icon-[tabler--rating-18-plus] size-5" aria-hidden="true"></span></span>
            <div class="min-w-0">
              <div class="text-sm font-medium">{__("Adult Content")}</div>
              <div class="hidden text-xs text-base-content/55 sm:block">{__("Share your post as adult content")}</div>
            </div>
            <label class="inline-flex" for="for_adult">
              <input type="checkbox" name="for_adult" id="for_adult" class="switch switch-primary shrink-0 [--border:1px] [--radius-selector:9999px] js_publisher-adult-toggle">
            </label>
          </div>
        {/if}

        <div class="space-y-1.5" id="paid-price-wrapper">
          <label class="label-text" for="paid-message-price">{__("Price")} ({$system['system_currency']})</label>
          <input type="text" class="input w-full [--border:1px]" id="paid-message-price" name="paid_price" placeholder="0.00">
        </div>
        <div class="space-y-1.5" id="paid-text-wrapper">
          <label class="label-text" for="paid-message-description">{__("Paid Content Description")}</label>
          <textarea class="textarea min-h-20 w-full [--border:1px]" id="paid-message-description" name="paid_text" rows="3" placeholder='{__("Paid Content Description")}'></textarea>
        </div>
        <div class="space-y-1.5" id="paid-image-wrapper">
          <span class="label-text">{__("Preview Image")}</span>
          {include file='__x_image.tpl' _x_name="paid_image" _x_class="min-h-32 w-full" _x_blur=true}
          <div class="text-xs text-base-content/55">{__("Upload a preview image for your content (This image will be blured)")}</div>
        </div>
      </div>
      <!-- message settings -->

      <div class="alert alert-soft alert-error alert-danger publisher-error mx-4 mb-0 hidden text-start sm:mx-5" role="alert"></div>

      <!-- publisher footer -->
      <div class="publisher-footer-buttons sticky bottom-0 z-20 flex items-center gap-2 border-t border-base-300 bg-base-100 px-3 py-2.5 sm:px-4">
        <div class="publisher-tools-tabs flex min-w-0 flex-1 items-center gap-0.5 [&>.publisher-tools-tab.attach]:overflow-hidden [&>.publisher-tools-tab.attach>.x-uploader]:absolute [&>.publisher-tools-tab.attach>.x-uploader]:inset-0 [&_.publisher-tools-tab.active]:bg-current/15 [&_.publisher-tools-tab.activated]:bg-primary/10 [&_.publisher-tools-tab.activated]:text-primary [&_.publisher-tools-tab.disabled]:pointer-events-none [&_.publisher-tools-tab.disabled]:opacity-40">
          {if $system['photos_enabled']}
            <div class="publisher-tools-tab attach relative size-9 shrink-0 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full text-success transition-colors hover:bg-current/15 js_publisher-tab js_publisher-images-uploader" data-tab="photos">
              <span class="js_x-uploader heroui button button--ghost button--icon-only rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full size-9 text-success shadow-none" data-handle="publisher" data-multiple="true" title='{__("Photos")}' aria-label='{__("Photos")}'>
                <span class="icon-[tabler--photo] size-5 pointer-events-none" aria-hidden="true"></span>
              </span>
            </div>
          {/if}
          {if $user->_data['can_upload_videos']}
            <div class="publisher-tools-tab attach relative size-9 shrink-0 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full text-error transition-colors hover:bg-current/15 js_publisher-tab" data-tab="video">
              <span class="js_x-uploader heroui button button--ghost button--icon-only rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full size-9 text-error shadow-none" data-handle="publisher" data-type="video" title='{__("Video")}' aria-label='{__("Video")}'>
                <span class="icon-[tabler--video] size-5 pointer-events-none" aria-hidden="true"></span>
              </span>
            </div>
          {/if}
          {if $user->_data['can_upload_audios']}
            <div class="publisher-tools-tab attach relative size-9 shrink-0 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full text-secondary transition-colors hover:bg-current/15 js_publisher-tab" data-tab="audio">
              <span class="js_x-uploader heroui button button--ghost button--icon-only rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full size-9 text-secondary shadow-none" data-handle="publisher" data-type="audio" title='{__("Audio")}' aria-label='{__("Audio")}'>
                <span class="icon-[tabler--music] size-5 pointer-events-none" aria-hidden="true"></span>
              </span>
            </div>
          {/if}
          {if $user->_data['can_upload_files']}
            <div class="publisher-tools-tab attach relative size-9 shrink-0 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full text-info transition-colors hover:bg-current/15 js_publisher-tab" data-tab="file">
              <span class="js_x-uploader heroui button button--ghost button--icon-only rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full size-9 text-info shadow-none" data-handle="publisher" data-type="file" title='{__("File")}' aria-label='{__("File")}'>
                <span class="icon-[tabler--paperclip] size-5 pointer-events-none" aria-hidden="true"></span>
              </span>
            </div>
          {/if}
        </div>
        <button type="button" class="button button--primary h-9 min-w-24 shrink-0 px-5 js_publisher-btn js_post-paid-message">{__("Send")}</button>
      </div>
      <!-- publisher footer -->
    </div>
    <!-- publisher content -->
  </div>
</div>
