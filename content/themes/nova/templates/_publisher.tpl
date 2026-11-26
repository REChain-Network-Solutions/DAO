{if !isset($publisher_edit)}{assign var="publisher_edit" value=false}{/if}
{if $publisher_edit || $user->_data['can_publish_posts']}
  {if !$publisher_edit && $system['verification_for_posts'] && !$user->_data['user_verified']}
    <div class="alert alert-soft alert-error flex items-start gap-3 rounded-box" role="alert">
      <span class="icon-[tabler--alert-circle] mt-0.5 size-5 shrink-0" aria-hidden="true"></span>
      <div class="min-w-0">
        <strong class="block font-semibold">{__("Account Verification Required")}</strong>
        <span class="text-sm">{__("To publish posts your account must be verified")} <a class="font-medium text-inherit! underline" href="{$system['system_url']}/settings/verification">{__("Verify Now")}</a></span>
      </div>
    </div>
  {else}
    <div id="publisher-wapper{if $_modal_mode}-modal{/if}" class="{if $_modal_mode}flex min-h-0 flex-1{else}mb-5{/if}">
      <div class="x-form publisher relative flex min-h-0 w-full flex-col overflow-hidden {if !$_modal_mode}rounded-box bg-base-100 shadow-surface dark:shadow-none{/if} [&_.x-uploader]:relative [&_.x-uploader]:cursor-pointer [&_.x-uploader]:overflow-hidden [&_.x-uploader>input[type=file]]:absolute [&_.x-uploader>input[type=file]]:inset-0 [&_.x-uploader>input[type=file]]:z-10 [&_.x-uploader>input[type=file]]:size-full [&_.x-uploader>input[type=file]]:cursor-pointer [&_.x-uploader>input[type=file]]:opacity-0 [&_.x-progress]:h-1.5 [&_.x-progress]:overflow-hidden [&_.x-progress]:rounded-full [&_.x-progress]:bg-base-300 [&_.progress-bar]:h-full [&_.progress-bar]:bg-primary" data-handle="{$_handle}" {if $_id}data-id="{$_id}" {/if} {if $_modal_mode}data-modal-mode="true"{/if} id="publisher-box">

        <!-- publisher loader -->
        <div class="publisher-loader absolute inset-0 z-40 hidden bg-base-100/80 backdrop-blur-sm">
          <div class="flex size-full items-center justify-center">
            <div class="loading loading-spinner loading-lg text-primary"></div>
          </div>
        </div>
        <!-- publisher loader -->

        <!-- publisher-identity -->
        <div class="flex shrink-0 items-center gap-3 px-4 pt-4 sm:px-5">
          <img class="size-11 shrink-0 rounded-full object-cover" src="{if $_avatar}{$_avatar}{else}{$user->_data['user_picture']}{/if}" alt="">
          <div class="min-w-0 flex-1">
            <div class="truncate text-sm font-semibold text-base-content" title="{if $_name}{$_name}{else}{$user->_data['user_fullname']}{/if}">{if $_name}{$_name}{else}{$user->_data['user_fullname']}{/if}</div>
            {if ($_privacy && $system['newsfeed_source'] == "default") || $_target}
              <div class="mt-1 flex min-w-0 items-center gap-1.5">
                {if $_privacy && $system['newsfeed_source'] == "default"}
                  <select class="select select-sm w-auto min-w-0 rounded-full text-xs font-medium [--border:1px] js_publisher-privacy" name="privacy" aria-label='{__("Privacy")}'>
                    <option value="public"{if $system['default_privacy'] == "public"} selected{/if}>{__("Public")}</option>
                    <option value="friends"{if $system['default_privacy'] == "friends"} selected{/if}>{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
                    {if $_handle == 'me'}
                      <option value="me"{if $system['default_privacy'] == "me"} selected{/if}>{__("Only Me")}</option>
                    {/if}
                  </select>
                  {if $_handle == "me" && $system['anonymous_mode']}
                    <select class="select select-sm hidden w-auto min-w-0 rounded-full text-xs font-medium [--border:1px] js_publisher-privacy-public" disabled aria-label='{__("Privacy")}'>
                      <option value="public" selected>{__("Public")}</option>
                    </select>
                  {/if}
                {/if}
                {if $_target}
                  <span class="badge badge-soft badge-primary badge-lg min-w-0 gap-1 rounded-full text-xs font-medium">
                    <span class="icon-[tabler--{if $_handle == "event"}calendar-event{elseif $_handle == "user"}user{else}users-group{/if}] size-3.5 shrink-0" aria-hidden="true"></span>
                    <span class="truncate" title="{$_target}">{$_target}</span>
                  </span>
                {/if}
              </div>
            {/if}
          </div>
        </div>
        <!-- publisher-identity -->

        <!-- publisher-message -->
        <div class="publisher-message flex shrink-0 px-4 py-3 sm:px-5 [&.colored]:mx-4 [&.colored]:mt-3 [&.colored]:mb-1 [&.colored]:min-h-60 [&.colored]:items-center [&.colored]:rounded-box [&.colored]:bg-cover [&.colored]:bg-center [&.colored]:px-6 [&.colored]:text-center sm:[&.colored]:mx-5">
          <div class="colored-text-wrapper min-w-0 flex-1 text-base-content [.colored_&]:text-inherit">
            <div class="quill-editor js_quill font-[inherit]! [&_.ql-tooltip]:z-30 [&_.ql-tooltip-arrow]:hidden! text-[0.9375rem]! leading-6! sm:text-base! [&_.ql-editor]:p-0! [&_.ql-editor]:text-start! [&_.ql-editor]:leading-6! [&_.ql-editor_h1]:text-xl! [&_.ql-editor_h1]:leading-7! [&_.ql-editor_h1]:font-bold [&_.ql-editor_h2]:text-lg! [&_.ql-editor_h2]:leading-7! [&_.ql-editor_h2]:font-semibold [&_.ql-editor_ol]:p-0! [&_.ql-editor.ql-blank]:before:left-0! [&_.ql-editor.ql-blank]:before:right-0! [&_.ql-editor.ql-blank]:before:not-italic! [&_.ql-editor.ql-blank]:before:text-inherit! [&_.ql-editor.ql-blank]:before:opacity-50 {if $_modal_mode}[&_.ql-editor]:min-h-24 [&_.ql-editor]:max-h-[35dvh] [.publisher:has(.publisher-scraper:not(:empty),.publisher-attachments_li)_&_.ql-editor]:min-h-0{else}[&_.ql-editor]:min-h-12{/if} [.colored_&]:text-xl! [.colored_&]:font-semibold [.colored_&_.ql-editor]:min-h-0 [.colored_&_.ql-editor]:text-center! [.colored_&_.ql-editor_p]:text-center! [.colored_&_.ql-editor]:leading-8!"></div>
            <input type="hidden" class="js_publisher-hidden-editor" value="">
            <textarea style="display: none;" {if $_modal_mode}autofocus{/if} dir="auto" class="js_autosize js_mentions js_publisher-scraper" data-init-placeholder='{__("What is on your mind?")}' placeholder='{__("What is on your mind?")}'>{if $url}{$url|escape:'html'}{/if}</textarea>
          </div>
        </div>
        <!-- publisher-message -->
        <div class="flex justify-end px-4 pb-2 sm:px-5">{include file='__emoji_trigger.tpl'}</div>

        <!-- publisher-slider -->
        <div class="publisher-slider {if !$_modal_mode}hidden{/if} min-h-0 flex-1 {if $_modal_mode}overflow-y-auto{/if} [&_.publisher-meta]:hidden [&_.publisher-meta]:mx-4 [&_.publisher-meta]:mb-2.5 [&_.publisher-meta]:flex [&_.publisher-meta]:items-center [&_.publisher-meta]:gap-2.5 sm:[&_.publisher-meta]:mx-5 [&_.publisher-meta[data-meta=feelings]]:flex-col [&_.publisher-meta[data-meta=feelings]]:items-stretch [&_.publisher-meta[data-meta=colored]]:flex-wrap [&_.publisher-meta_input]:min-w-0 [&_.publisher-meta_input]:flex-1 [&_.publisher-meta_input]:text-sm [&_.publisher-meta_input]:outline-none [&_.publisher-meta_select]:w-full [&_.publisher-meta_select]:rounded-field [&_.publisher-meta_select]:border [&_.publisher-meta_select]:border-base-300 [&_.publisher-meta_select]:bg-base-100 [&_.publisher-meta_select]:px-3 [&_.publisher-meta_select]:py-2 [&_.publisher-attachments>ul]:m-0 [&_.publisher-attachments>ul]:grid [&_.publisher-attachments>ul]:list-none [&_.publisher-attachments>ul]:grid-cols-2 [&_.publisher-attachments>ul]:gap-2 [&_.publisher-attachments>ul]:p-0 sm:[&_.publisher-attachments>ul]:grid-cols-3 [&_.publisher-attachments_li]:relative [&_.publisher-attachments_li]:overflow-hidden [&_.publisher-attachments_li]:rounded-box [&_.publisher-attachments_li]:bg-base-200 [&_.publisher-attachments_img]:aspect-square [&_.publisher-attachments_img]:size-full [&_.publisher-attachments_img]:object-cover [&_.publisher-attachments_.button]:absolute [&_.publisher-attachments_.button]:end-1.5 [&_.publisher-attachments_.button]:top-1.5">

          <!-- publisher scraper -->
          <div class="publisher-scraper relative mx-4 mb-2.5 hidden overflow-hidden rounded-box border border-base-300 bg-base-100 sm:mx-5"></div>
          <!-- publisher scraper -->

          <!-- post attachments (photos) -->
          {include file='__publisher_photo_layout.tpl'}
          <div class="publisher-attachments attachments mx-4 mb-2.5 hidden sm:mx-5 js_attachments-photos"></div>
          <!-- post attachments -->

          <!-- post attachments (reels) -->
          <div class="publisher-attachments attachments mx-4 mb-2.5 hidden sm:mx-5 js_attachments-reel"></div>
          <!-- post attachments -->

          <!-- post attachments (videos) -->
          <div class="publisher-attachments attachments mx-4 mb-2.5 hidden sm:mx-5 js_attachments-video"></div>
          <!-- post attachments -->

          <!-- post attachments (audios) -->
          <div class="publisher-attachments attachments mx-4 mb-2.5 hidden sm:mx-5 js_attachments-audio"></div>
          <!-- post attachments -->

          <!-- post attachments (files) -->
          <div class="publisher-attachments attachments mx-4 mb-2.5 hidden sm:mx-5 js_attachments-file"></div>
          <!-- post attachments -->

          <!-- post album -->
          <div class="publisher-meta" data-meta="album">
            <div class="flex w-full items-center gap-2.5">
              <span class="flex size-10 shrink-0 items-center justify-center rounded-field bg-info/10 text-info"><span class="icon-[tabler--photo-plus] size-5" aria-hidden="true"></span></span>
              <input class="input w-full [--border:1px]" type="text" placeholder='{__("Album title")}'>
            </div>
          </div>
          <!-- post album -->

          <!-- post feelings -->
          <div class="publisher-meta" data-meta="feelings">
            <div class="flex w-full flex-col gap-2 rounded-box bg-base-200/60 p-2">
              <button type="button" id="feelings-menu-toggle" class="flex h-10 w-full items-center rounded-field border border-base-300 bg-base-100 px-3 text-start text-sm font-medium text-base-content/70 transition-colors hover:border-base-content/25 [&.active]:text-base-content" data-init-text='{__("What are you doing?")}'>{__("What are you doing?")}</button>
              <div id="feelings-data" class="flex h-10 items-center rounded-field border border-base-300 bg-base-100 px-3" style="display: none">
                <input type="text" class="no-icon h-full w-full bg-transparent text-sm outline-none max-md:text-base" placeholder='{__("What are you doing?")}'>
                <span class="flex items-center gap-2 text-sm font-medium"></span>
              </div>
              <div id="feelings-menu">
                <ul class="feelings-list m-0 grid list-none grid-cols-2 gap-1.5 p-0 sm:grid-cols-3">
                  {foreach $feelings as $feeling}
                    {$_feeling_icon = ''}{if $system['system_theme_icons'] == 'svg'}{$_feeling_icon = $feeling['action']|lower|regex_replace:'/ .*$/':''|theme_module_icon:'size-5 shrink-0':'publisher'}{/if}
                    <li class="feeling-item js_feelings-add flex min-w-0 cursor-pointer items-center gap-2.5 rounded-field bg-base-100 px-3 py-2 text-sm font-medium transition-colors hover:bg-base-300/70" data-action="{$feeling['action']}" data-placeholder="{__($feeling['placeholder'])}">
                      {if $_feeling_icon}{$_feeling_icon}{else}<span class="inline-block text-lg">{get_feeling_emoji($feeling['icon'])}</span>{/if}
                      <span class="data min-w-0 truncate" title="{__($feeling['text'])}">{__($feeling['text'])}</span>
                    </li>
                  {/foreach}
                </ul>
              </div>
              <div id="feelings-types" style="display: none">
                <ul class="feelings-list m-0 grid list-none grid-cols-2 gap-1.5 p-0 sm:grid-cols-3">
                  {foreach $feelings_types as $type}
                    {$_feeling_icon = ''}{if $system['system_theme_icons'] == 'svg'}{$_feeling_icon = $type['action']|lower|regex_replace:'/ .*$/':''|theme_module_icon:'size-5 shrink-0':'publisher'}{/if}
                    <li class="feeling-item js_feelings-type flex min-w-0 cursor-pointer items-center gap-2.5 rounded-field bg-base-100 px-3 py-2 text-sm font-medium transition-colors hover:bg-base-300/70" data-type="{$type['action']}" data-emoji="{get_feeling_emoji($type['icon'])}">
                      {if $_feeling_icon}{$_feeling_icon}{else}<span class="inline-block text-lg">{get_feeling_emoji($type['icon'])}</span>{/if}
                      <span class="data min-w-0 truncate" title="{__($type['text'])}">{__($type['text'])}</span>
                    </li>
                  {/foreach}
                </ul>
              </div>
            </div>
          </div>
          <!-- post feelings -->

          <!-- post location -->
          <div class="publisher-meta" data-meta="location">
            <div class="flex w-full items-center gap-2.5">
              <span class="flex size-10 shrink-0 items-center justify-center rounded-field bg-info/10 text-info"><span class="icon-[tabler--map-pin] size-5" aria-hidden="true"></span></span>
              <input class="js_geocomplete input w-full [--border:1px]" type="text" placeholder='{__("Where are you?")}'>
              <input type="hidden" data-geo="lat">
              <input type="hidden" data-geo="lng">
            </div>
          </div>
          <!-- post location -->

          <!-- post colored -->
          <div class="publisher-meta" data-meta="colored">
            <div class="flex w-full flex-wrap items-center gap-1.5">
            {foreach $colored_patterns as $pattern}
              <button type="button" class="colored-pattern-item js_publisher-pattern size-9 rounded-lg border-2 border-base-100 bg-cover bg-center shadow-sm transition hover:scale-105 [&.active]:ring-2 [&.active]:ring-primary [&.active]:ring-offset-2 [&.active]:ring-offset-base-100" aria-label='{__("Colored Posts")}' data-id="{$pattern['pattern_id']}" data-type="{$pattern['type']}" data-background-image="{$pattern['background_image']}" data-background-color-1="{$pattern['background_color_1']}" data-background-color-2="{$pattern['background_color_2']}" data-text-color="{$pattern['text_color']}" {if $pattern['type'] == "color"} style="background-image: linear-gradient(45deg, {$pattern['background_color_1']}, {$pattern['background_color_2']});" {else} style="background-image: url({$system['system_uploads']}/{$pattern['background_image']})" {/if}></button>
            {/foreach}
            </div>
          </div>
          <!-- post colored -->

          <!-- post voice notes -->
          <div class="publisher-meta" data-meta="voice_notes">
            <div class="voice-recording-wrapper w-full rounded-xl bg-base-200 p-2.5 text-sm" data-handle="publisher">
              <div class="hidden js_voice-processing-message">
                <span class="inline-flex items-center gap-2">
                  <span class="icon-[tabler--upload] size-4 shrink-0" aria-hidden="true"></span>
                  {__("Processing")}<span class="loading loading-dots loading-xs" aria-hidden="true"></span>
                </span>
              </div>
              <div class="hidden js_voice-success-message">
                <span class="flex items-center gap-2">
                  <span class="icon-[tabler--circle-check] size-4 shrink-0 text-success" aria-hidden="true"></span>
                  <span class="min-w-0 flex-1">{__("Voice note recorded successfully")}</span>
                  <button type="button" class="heroui button button--tertiary button--sm button--icon-only size-6 rounded-full ms-auto js_voice-remove" aria-label="{__("Remove")}">
                    <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
                  </button>
                </span>
              </div>
              <button type="button" class="heroui button button--danger-soft button--sm btn-voice-start js_voice-start">
                <span class="icon-[tabler--microphone] size-4" aria-hidden="true"></span>{__("Record")}
              </button>
              <button type="button" class="heroui button button--danger button--sm btn-voice-stop js_voice-stop" style="display: none">
                <span class="icon-[tabler--player-stop] size-4" aria-hidden="true"></span>{__("Recording")} <span class="js_voice-timer">00:00</span>
              </button>
            </div>
          </div>
          <!-- post voice notes -->

          <!-- post gif -->
          <div class="publisher-meta" data-meta="gif">
            <div class="flex w-full flex-wrap items-center gap-2.5">
              <span class="flex size-10 shrink-0 items-center justify-center rounded-field bg-primary/10 text-primary"><span class="icon-[tabler--gif] size-5" aria-hidden="true"></span></span>
              <input class="js_publisher-gif-search input min-w-0 flex-1 [--border:1px]" type="text" placeholder='{__("Search GIFs")}'>
            </div>
          </div>
          <!-- post gif -->

          <!-- post poll -->
          <div class="publisher-meta" data-meta="poll">
            <div class="flex w-full items-center gap-2.5">
              <span class="flex size-10 shrink-0 items-center justify-center rounded-field bg-warning/10 text-warning"><span class="icon-[tabler--plus] size-5" aria-hidden="true"></span></span>
              <input class="input w-full [--border:1px]" type="text" placeholder='{__("Add an option")}...'>
            </div>
          </div>
          <div class="publisher-meta" data-meta="poll">
            <div class="flex w-full items-center gap-2.5">
              <span class="flex size-10 shrink-0 items-center justify-center rounded-field bg-warning/10 text-warning"><span class="icon-[tabler--plus] size-5" aria-hidden="true"></span></span>
              <input class="input w-full [--border:1px]" type="text" placeholder='{__("Add an option")}...'>
            </div>
          </div>
          <!-- post poll -->

          <!-- post reel -->
          <div class="publisher-meta" data-meta="reel">
            <div class="flex w-full items-center gap-2.5 rounded-field bg-success/10 px-3 py-2">
              <span class="icon-[tabler--circle-check] size-5 shrink-0 text-success" aria-hidden="true"></span>
              <span class="min-w-0 flex-1 text-sm font-medium text-success">{__("Reel uploaded successfully")}</span>
              <button type="button" class="heroui button button--tertiary button--sm button--icon-only size-6 rounded-full js_publisher-attachment-file-remover" data-type="reel" aria-label="{__("Remove")}"><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
            </div>
          </div>
          <div class="publisher-custom-thumbnail publisher-reel-custom-thumbnail mx-4 mb-2.5 hidden rounded-box border border-base-300 bg-base-100 p-3 text-sm font-medium sm:mx-5">
            <div class="mb-2">{__("Custom Reel Thumbnail")}</div>
            {include file='__x_image.tpl' _x_name="video_thumbnail" _x_class="min-h-32 w-full"}
          </div>
          <!-- post reel -->

          <!-- post video -->
          <div class="publisher-meta" data-meta="video">
            <div class="flex w-full items-center gap-2.5 rounded-field bg-success/10 px-3 py-2">
              <span class="icon-[tabler--circle-check] size-5 shrink-0 text-success" aria-hidden="true"></span>
              <span class="min-w-0 flex-1 text-sm font-medium text-success">{__("Video uploaded successfully")}</span>
              <button type="button" class="heroui button button--tertiary button--sm button--icon-only size-6 rounded-full js_publisher-attachment-file-remover" data-type="video" aria-label="{__("Remove")}"><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
            </div>
          </div>
          <div class="publisher-meta" data-meta="video">
            <select class="input [--border:1px]" name="video_category" id="video_category">
              {foreach $videos_categories as $category}
                {include file='__categories.recursive_options.tpl'}
              {/foreach}
            </select>
          </div>
          <div class="publisher-custom-thumbnail publisher-video-custom-thumbnail mx-4 mb-2.5 hidden rounded-box border border-base-300 bg-base-100 p-3 text-sm font-medium sm:mx-5">
            <div class="mb-2">{__("Custom Video Thumbnail")}</div>
            {include file='__x_image.tpl' _x_name="video_thumbnail" _x_class="min-h-32 w-full"}
          </div>
          <!-- post video -->

          <!-- post audio -->
          <div class="publisher-meta" data-meta="audio">
            <div class="flex w-full items-center gap-2.5 rounded-field bg-success/10 px-3 py-2">
              <span class="icon-[tabler--circle-check] size-5 shrink-0 text-success" aria-hidden="true"></span>
              <span class="min-w-0 flex-1 text-sm font-medium text-success">{__("Audio uploaded successfully")}</span>
              <button type="button" class="heroui button button--tertiary button--sm button--icon-only size-6 rounded-full js_publisher-attachment-file-remover" data-type="audio" aria-label="{__("Remove")}"><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
            </div>
          </div>
          <!-- post audio -->

          <!-- post file -->
          <div class="publisher-meta" data-meta="file">
            <div class="flex w-full items-center gap-2.5 rounded-field bg-success/10 px-3 py-2">
              <span class="icon-[tabler--circle-check] size-5 shrink-0 text-success" aria-hidden="true"></span>
              <span class="min-w-0 flex-1 text-sm font-medium text-success">{__("File uploaded successfully")}</span>
              <button type="button" class="heroui button button--tertiary button--sm button--icon-only size-6 rounded-full js_publisher-attachment-file-remover" data-type="file" aria-label="{__("Remove")}"><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
            </div>
          </div>
          <!-- post file -->

          <!-- publisher-footer -->
          <div class="publisher-footer mt-auto bg-base-100">
            <div class="accordion" id="publisher-settings{if $_modal_mode}-modal{/if}">
              <div class="accordion-item border-0 bg-transparent shadow-none">
                {if $user->_data['can_schedule_posts'] || ($_handle == "me" && $user->_data['can_add_anonymous_posts']) || $system['adult_mode'] || ($_handle != "page" && $user->_data['can_receive_tip']) || (in_array($_handle, ['me', 'page', 'group']) && $_node_can_monetize_content && $_node_monetization_enabled && $_node_monetization_plans > 0) || (in_array($_handle, ['me', 'page', 'group', 'event']) && $user->_data['can_monetize_content'] && $user->_data['user_monetization_enabled']) || (in_array($_handle, ['me', 'group', 'event']) && $user->_data['can_add_collaborative_posts'])}
                  <div id="publisher-settings-content{if $_modal_mode}-modal{/if}" class="accordion-content hidden w-full overflow-hidden border-t border-base-300" role="region">
                    <div class="publisher-footer-options space-y-2 px-4 py-3 sm:px-5 [--color-neutral:var(--color-base-content)] [&_.switch:disabled]:before:bg-current [&_.form-table-row]:grid [&_.form-table-row]:grid-cols-[auto_minmax(0,1fr)_auto] [&_.form-table-row]:items-center [&_.form-table-row]:gap-3 [&_.form-table-row]:rounded-[1rem] [&_.form-table-row]:corner-squircle [&_.form-table-row]:supports-[corner-shape:squircle]:rounded-[1.5rem] [&_.form-table-row]:bg-base-200/60 [&_.form-table-row]:px-3 [&_.form-table-row]:py-2.5 [&_.form-table-row_.avatar]:flex [&_.form-table-row_.avatar]:size-9 [&_.form-table-row_.avatar]:items-center [&_.form-table-row_.avatar]:justify-center [&_.form-table-row_.avatar]:rounded-[0.75rem] [&_.form-table-row_.avatar]:corner-squircle [&_.form-table-row_.avatar]:supports-[corner-shape:squircle]:rounded-full [&_.form-table-row_.avatar]:bg-current/20 [&_.input]:w-full [&_.input]:[--border:1px] [&_.text-muted]:text-base-content/55">

                      <!-- schedule post -->
                      {if $user->_data['can_schedule_posts'] && (!$publisher_edit || $publisher_edit['still_scheduled'])}
                        <div class="form-table-row">
                          <div class="avatar text-info">
                            <span class="icon-[tabler--calendar-time] size-5" aria-hidden="true"></span>
                          </div>
                          <div class="min-w-0">
                            <div class="text-sm font-medium">{__("Schedule Post")}</div>
                            <div class="hidden text-xs text-muted sm:block">{__("Schedule your post for later")}</div>
                          </div>
                          <div>
                            <label class="inline-flex" for="is_schedule">
                              <input type="checkbox" name="is_schedule" id="is_schedule" class="switch switch-primary shrink-0 [--border:1px] [--radius-selector:9999px] js_publisher-schedule-toggle">
                            </label>
                          </div>
                        </div>
                        <div class="space-y-1.5 hidden" id="schedule-toggle-wrapper">
                          <input type="datetime-local" class="input js_publisher-schedule-date">
                          <div class="text-xs text-muted">{__("Select a date and time for your post")}</div>
                        </div>
                      {/if}
                      <!-- schedule post -->

                      <!-- anonymous post -->
                      {if !$publisher_edit && $_handle == "me" && $user->_data['can_add_anonymous_posts']}
                        <div class="form-table-row" id="anonymous-toggle-wrapper">
                          <div class="avatar text-secondary">
                            <span class="icon-[tabler--user-off] size-5" aria-hidden="true"></span>
                          </div>
                          <div class="min-w-0">
                            <div class="text-sm font-medium">{__("Anonymous Post")}</div>
                            <div class="hidden text-xs text-muted sm:block">{__("Share your post as anonymous post")}</div>
                          </div>
                          <div>
                            <label class="inline-flex" for="is_anonymous">
                              <input type="checkbox" name="is_anonymous" id="is_anonymous" class="switch switch-primary shrink-0 [--border:1px] [--radius-selector:9999px] js_publisher-anonymous-toggle">
                            </label>
                          </div>
                        </div>
                      {/if}
                      <!-- anonymous post -->

                      <!-- adult content -->
                      {if $system['adult_mode']}
                        <div class="form-table-row" id="adult-toggle-wrapper">
                          <div class="avatar text-error">
                            <span class="icon-[tabler--rating-18-plus] size-5" aria-hidden="true"></span>
                          </div>
                          <div class="min-w-0">
                            <div class="text-sm font-medium">{__("Adult Content")}</div>
                            <div class="hidden text-xs text-muted sm:block">{__("Share your post as adult content")}</div>
                          </div>
                          <div>
                            <label class="inline-flex" for="for_adult">
                              <input type="checkbox" name="for_adult" id="for_adult" class="switch switch-primary shrink-0 [--border:1px] [--radius-selector:9999px] js_publisher-adult-toggle">
                            </label>
                          </div>
                        </div>
                      {/if}
                      <!-- adult content -->

                      <!-- enable tips -->
                      {if $_handle != "page" && $user->_data['can_receive_tip']}
                        <div class="form-table-row" id="tips-toggle-wrapper">
                          <div class="avatar text-warning">
                            <span class="icon-[tabler--coin] size-5" aria-hidden="true"></span>
                          </div>
                          <div class="min-w-0">
                            <div class="text-sm font-medium">{__("Enable Tips")}</div>
                            <div class="hidden text-xs text-muted sm:block">{__("Allow people to send you tips")}</div>
                          </div>
                          <div>
                            <label class="inline-flex" for="tips_enabled">
                              <input type="checkbox" name="tips_enabled" id="tips_enabled" class="switch switch-primary shrink-0 [--border:1px] [--radius-selector:9999px] js_publisher-tips-toggle">
                            </label>
                          </div>
                        </div>
                      {/if}
                      <!-- enable tips -->

                      <!-- only for subscribers -->
                      {if in_array($_handle, ['me', 'page', 'group']) && $_node_can_monetize_content && $_node_monetization_enabled && $_node_monetization_plans > 0}
                        <div class="form-table-row" id="subscribers-toggle-wrapper">
                          <div class="avatar text-accent">
                            <span class="icon-[tabler--users] size-5" aria-hidden="true"></span>
                          </div>
                          <div class="min-w-0">
                            <div class="text-sm font-medium">{__("Subscribers Only")}</div>
                            <div class="hidden text-xs text-muted sm:block">{__("Share this post to")} {if $_handle != "me"}{__($_handle)} {/if}{__("subscribers only")}</div>
                          </div>
                          <div>
                            <label class="inline-flex" for="subscribers_only">
                              <input type="checkbox" name="subscribers_only" id="subscribers_only" class="switch switch-primary shrink-0 [--border:1px] [--radius-selector:9999px] js_publisher-subscribers-toggle">
                            </label>
                          </div>
                        </div>
                        <div class="space-y-1.5 hidden" id="subscriptions-image-wrapper">
                          {include file='__x_image.tpl' _x_name="subscriptions_image" _x_class="min-h-32 w-full" _x_blur=true}
                          <div class="text-xs text-muted">{__("Upload a preview image for your content (This image will be blured)")}</div>
                        </div>
                      {/if}
                      <!-- only for subscribers -->

                      <!-- paid post -->
                      {if in_array($_handle, ['me', 'page', 'group', 'event']) && $user->_data['can_monetize_content'] && $user->_data['user_monetization_enabled']}
                        <div class="form-table-row" id="paid-toggle-wrapper">
                          <div class="avatar text-success">
                            <span class="icon-[tabler--currency-dollar] size-5" aria-hidden="true"></span>
                          </div>
                          <div class="min-w-0">
                            <div class="text-sm font-medium">{__("Paid Post")}</div>
                            <div class="hidden text-xs text-muted sm:block">{__("Set a price to your post")} ({__("subscribers also paying")})</div>
                          </div>
                          <div>
                            <label class="inline-flex" for="paid_post">
                              <input type="checkbox" name="paid_post" id="paid_post" class="switch switch-primary shrink-0 [--border:1px] [--radius-selector:9999px] js_publisher-paid-toggle">
                            </label>
                          </div>
                        </div>
                        <div class="hidden" id="paid-lock-toggle-wrapper">
                          <div class="form-table-row">
                            <div class="avatar text-success">
                              <span class="icon-[tabler--lock] size-5" aria-hidden="true"></span>
                            </div>
                            <div class="min-w-0">
                              <div class="text-sm font-medium">{__("Only Lock Attached File")}</div>
                              <div class="hidden text-xs text-muted sm:block">{__("This option will lock the attached file and disable the preview")}</div>
                            </div>
                            <div>
                              <label class="inline-flex" for="paid_post_lock">
                                <input type="checkbox" name="paid_post_lock" id="paid_post_lock" class="switch switch-primary shrink-0 [--border:1px] [--radius-selector:9999px] js_publisher-paid-lock-toggle">
                              </label>
                            </div>
                          </div>
                        </div>
                        <div class="space-y-1.5 hidden" id="paid-price-wrapper">
                          <input type="text" class="input" name="paid_post_price" placeholder="{__("Price")} ({$system['system_currency']})">
                        </div>
                        <div class="space-y-1.5 hidden" id="paid-text-wrapper">
                          <textarea class="textarea min-h-20 w-full [--border:1px]" name="paid_post_text" rows="3" placeholder="{__("Paid Content Description")}"></textarea>
                        </div>
                        <div class="space-y-1.5 hidden" id="paid-image-wrapper">
                          {include file='__x_image.tpl' _x_name="paid_image" _x_class="min-h-32 w-full" _x_blur=true}
                          <div class="text-xs text-muted">{__("Upload a preview image for your content (This image will be blured)")}</div>
                        </div>
                      {/if}
                      <!-- paid post -->

                      <!-- collaborative post -->
                      {if in_array($_handle, ['me', 'group', 'event']) && $user->_data['can_add_collaborative_posts']}
                        <div class="form-table-row" id="collaborative-toggle-wrapper">
                          <div class="avatar text-primary">
                            <span class="icon-[tabler--users-plus] size-5" aria-hidden="true"></span>
                          </div>
                          <div class="min-w-0">
                            <div class="text-sm font-medium">{__("Collaborative Post")}</div>
                            <div class="hidden text-xs text-muted sm:block">{__("Share your post with others")}</div>
                          </div>
                          <div>
                            <label class="inline-flex" for="collaborative_post">
                              <input type="checkbox" name="collaborative_post" id="collaborative_post" class="switch switch-primary shrink-0 [--border:1px] [--radius-selector:9999px] js_publisher-collaborative-toggle">
                            </label>
                          </div>
                        </div>
                        <div class="space-y-1.5 hidden" id="collaborative-users-wrapper">
                          <input type="text" class="js_tagify-ajax hidden min-h-10 w-full items-center! rounded-field bg-base-100 text-sm max-md:text-base [--placeholder-color-focus:color-mix(in_oklab,var(--color-base-content)_35%,transparent)]! [--placeholder-color:color-mix(in_oklab,var(--color-base-content)_45%,transparent)]! [--tag-bg:var(--color-base-200)]! [--tag-border-radius:9999px]! [--tag-hover:var(--color-base-300)]! [--tag-remove-btn-color:var(--color-base-content)]! [--tag-text-color:var(--color-base-content)]! [--tags-border-color:var(--color-base-300)]! [--tags-focus-border-color:var(--color-primary)]! [--tags-hover-border-color:color-mix(in_oklab,var(--color-base-content)_25%,transparent)]!" data-handle="collaborative_users" name="collaborative_users" {if $publisher_edit}value="{$publisher_edit['collaborative_json']|escape:'html'}"{/if} placeholder='{__("Search")}'>
                          <div class="text-xs text-muted">{__("Enter the users to collaborate with")}</div>
                        </div>
                        {if $user->_data['can_monetize_content'] && $user->_data['user_monetization_enabled']}
                          <div class="space-y-1.5 hidden" id="collaborative-percent-wrapper">
                            <input type="number" min="0" max="100" class="input" name="collaborative_percent">
                            <div class="text-xs text-muted">{__("Enter the % of the revenue that you want to give to the collaborators (only for paid posts)")}</div>
                          </div>
                        {/if}
                      {/if}
                      <!-- collaborative post -->

                    </div>
                  </div>
                {/if}

                <!-- publisher-error -->
                <div class="alert alert-soft alert-error alert-danger publisher-error mx-4 mb-0 mt-2 hidden text-start sm:mx-5" role="alert"></div>
                <!-- publisher-error -->

                <!-- publisher-buttons -->
                <div class="publisher-footer-buttons {if $_modal_mode}sticky bottom-0{/if} z-20 flex flex-wrap items-center gap-x-2 gap-y-2.5 border-t border-base-300 bg-base-100 px-3 py-2.5 sm:px-4">
                  <div class="publisher-tools-tabs flex min-w-0 items-center gap-0.5 max-sm:w-full max-sm:justify-between [&>.publisher-tools-tab.attach]:overflow-hidden [&>.publisher-tools-tab.attach>.x-uploader]:absolute [&>.publisher-tools-tab.attach>.x-uploader]:inset-0 [&_.publisher-tools-tab.active]:bg-current/15 [&_.publisher-tools-tab.activated]:bg-primary/10 [&_.publisher-tools-tab.activated]:text-primary [&_.publisher-tools-tab.disabled]:pointer-events-none [&_.publisher-tools-tab.disabled]:opacity-40">
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
                    {if $user->_data['can_add_activity_posts']}
                      <button type="button" class="publisher-tools-tab heroui button button--ghost button--icon-only rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full size-9 text-warning shadow-none hover:bg-current/15 js_publisher-feelings" title='{__("Feelings/Activity")}' aria-label='{__("Feelings/Activity")}'>
                        <span class="icon-[tabler--mood-smile] size-5" aria-hidden="true"></span>
                      </button>
                    {/if}
                    {if $user->_data['can_add_geolocation_posts']}
                      <button type="button" class="publisher-tools-tab heroui button button--ghost button--icon-only rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full size-9 text-info shadow-none hover:bg-current/15 js_publisher-tab" data-tab="location" title='{__("Check In")}' aria-label='{__("Check In")}'>
                        <span class="icon-[tabler--map-pin] size-5" aria-hidden="true"></span>
                      </button>
                    {/if}
                    {if $user->_data['can_add_colored_posts']}
                      <button type="button" class="publisher-tools-tab heroui button button--ghost button--icon-only rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full size-9 text-secondary shadow-none hover:bg-current/15 js_publisher-tab" data-tab="colored" title='{__("Colored")}' aria-label='{__("Colored")}'>
                        <span class="icon-[tabler--palette] size-5" aria-hidden="true"></span>
                      </button>
                    {/if}
                    {if $user->_data['can_add_polls_posts']}
                      <button type="button" class="publisher-tools-tab heroui button button--ghost button--icon-only rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full size-9 text-accent shadow-none hover:bg-current/15 js_publisher-tab" data-tab="poll" title='{__("Poll")}' aria-label='{__("Poll")}'>
                        <span class="icon-[tabler--chart-bar] size-5" aria-hidden="true"></span>
                      </button>
                    {/if}

                    {if $user->_data['can_go_live'] || $system['photos_enabled'] || $system['ai_images_enabled'] || $system['ai_posts_enabled'] || $user->_data['can_add_rich_text_posts'] || $user->_data['can_add_gif_posts'] || $system['voice_notes_posts_enabled'] || $user->_data['can_add_reels'] || $user->_data['can_upload_audios'] || $user->_data['can_upload_files'] || ($system['blogs_enabled'] && in_array($_handle, ['me', 'page', 'group', 'event'])) || ($system['market_enabled'] && in_array($_handle, ['me', 'page', 'group', 'event'])) || ($system['funding_enabled'] && $_handle == "me") || ($system['offers_enabled'] && in_array($_handle, ['me', 'page', 'group', 'event'])) || ($system['jobs_enabled'] && in_array($_handle, ['me', 'page', 'group', 'event'])) || ($system['courses_enabled'] && in_array($_handle, ['me', 'page', 'group', 'event']))}
                      <div class="dropdown relative inline-flex shrink-0 [--offset:8] [--placement:top-end] sm:[--placement:top-start] [--strategy:fixed]">
                        <button type="button" class="dropdown-toggle heroui button button--ghost button--icon-only rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full size-9 text-base-content/70 shadow-none hover:bg-current/15" aria-haspopup="menu" aria-expanded="false" title='{__("More")}' aria-label='{__("More")}'>
                          <span class="icon-[tabler--dots] size-5" aria-hidden="true"></span>
                        </button>
                        <div class="dropdown-menu dropdown-open:opacity-100 hidden z-30 w-[min(22rem,calc(100vw-1.5rem))] overflow-hidden border border-base-content/15 p-0 shadow-lg shadow-black/10 dark:shadow-black/25" role="menu">
                          <div class="border-b border-base-300 px-3 py-2.5">
                            <h2 class="text-sm font-semibold">{__("More")}</h2>
                          </div>
                          <div class="max-h-[min(22rem,calc(100dvh-10rem))] overflow-y-auto p-1.5 [&_.publisher-tools-tab]:relative [&_.publisher-tools-tab]:flex [&_.publisher-tools-tab]:min-w-0 [&_.publisher-tools-tab]:w-full [&_.publisher-tools-tab]:cursor-pointer [&_.publisher-tools-tab]:items-center [&_.publisher-tools-tab]:gap-2.5 [&_.publisher-tools-tab]:rounded-xl [&_.publisher-tools-tab]:px-2.5 [&_.publisher-tools-tab]:py-2 [&_.publisher-tools-tab]:text-start [&_.publisher-tools-tab]:text-sm [&_.publisher-tools-tab]:font-medium [&_.publisher-tools-tab]:text-base-content! [&_.publisher-tools-tab]:no-underline [&_.publisher-tools-tab]:transition-colors [&_.publisher-tools-tab:hover]:bg-base-200 [&_.publisher-tools-tab>.x-uploader]:w-full">
                            <div class="grid grid-cols-2 gap-0.5">
                              {if $system['ai_images_enabled']}
                                <button type="button" class="js_modal publisher-tools-tab link js_publisher-tab col-span-2" data-tab="ai_image" data-size="large" data-stacked="true" data-url="ai/modal.php?handle=image" role="menuitem">
                                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-linear-to-br from-primary to-fuchsia-500 text-white shadow-sm"><span class="icon-[tabler--photo-ai] size-4" aria-hidden="true"></span></span>
                                  <span class="flex min-w-0 flex-1 flex-col">
                                    <span class="truncate bg-linear-to-r from-primary via-fuchsia-500 to-primary bg-size-[200%_100%] bg-clip-text font-semibold text-transparent animate-shimmer motion-reduce:animate-none" title="{__("Generate Image")}">{__("Generate Image")}</span>
                                    <span class="truncate text-xs font-normal text-base-content/60" title="{__("Create an image from a text prompt")}">{__("Create an image from a text prompt")}</span>
                                  </span>
                                </button>
                              {/if}
                              {if $system['ai_posts_enabled']}
                                <button type="button" class="js_modal publisher-tools-tab link js_publisher-tab col-span-2" data-tab="ai" data-size="large" data-stacked="true" data-url="ai/modal.php?handle=post" role="menuitem">
                                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-linear-to-br from-primary to-fuchsia-500 text-white shadow-sm"><span class="icon-[tabler--sparkles] size-4" aria-hidden="true"></span></span>
                                  <span class="flex min-w-0 flex-1 flex-col">
                                    <span class="truncate bg-linear-to-r from-primary via-fuchsia-500 to-primary bg-size-[200%_100%] bg-clip-text font-semibold text-transparent animate-shimmer motion-reduce:animate-none" title="{__("Generate Post")}">{__("Generate Post")}</span>
                                    <span class="truncate text-xs font-normal text-base-content/60" title="{__("Let AI write your post")}">{__("Let AI write your post")}</span>
                                  </span>
                                </button>
                              {/if}
                              {if $system['ai_images_enabled'] || $system['ai_posts_enabled']}
                                <div class="col-span-2 mx-2.5 my-1 border-t border-base-300" role="separator"></div>
                              {/if}
                              {if $user->_data['can_go_live']}
                                <a class="publisher-tools-tab link js_publisher-tab" data-tab="live" href="{$system['system_url']}/live/create{if $_handle == "page"}?page_id={$_id}{/if}{if $_handle == "group"}?group_id={$_id}{/if}{if $_handle == "event"}?event_id={$_id}{/if}" role="menuitem">
                                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-error/15 text-error"><span class="icon-[tabler--broadcast] size-4" aria-hidden="true"></span></span>
                                  <span class="min-w-0 flex-1 truncate" title="{__("Go Live")}">{__("Go Live")}</span>
                                  <span class="size-1.5 shrink-0 rounded-full bg-error animate-pulse" aria-hidden="true"></span>
                                </a>
                              {/if}
                              {if $system['photos_enabled']}
                                <button type="button" class="publisher-tools-tab js_publisher-tab" data-tab="album" role="menuitem">
                                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-info/15 text-info"><span class="icon-[tabler--photo-plus] size-4" aria-hidden="true"></span></span>
                                  <span class="truncate" title="{__("Album")}">{__("Album")}</span>
                                </button>
                              {/if}
                              {if $user->_data['can_add_rich_text_posts']}
                                <button type="button" class="js_modal publisher-tools-tab js_publisher-tab" data-tab="rich_text" data-size="extra-large" data-static="true" data-url="posts/rich_text.php?do=create{if $_handle == "page"}&page={$_id}{/if}{if $_handle == "group"}&group={$_id}{/if}{if $_handle == "event"}&event={$_id}{/if}" role="menuitem">
                                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-info/15 text-info"><span class="icon-[tabler--file-type-html] size-4" aria-hidden="true"></span></span>
                                  <span class="truncate" title="{__("Rich Text")}">{__("Rich Text")}</span>
                                </button>
                              {/if}
                              {if $user->_data['can_add_gif_posts']}
                                <button type="button" class="publisher-tools-tab js_publisher-tab" data-tab="gif" role="menuitem">
                                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-primary/15 text-primary"><span class="icon-[tabler--gif] size-4" aria-hidden="true"></span></span>
                                  <span class="truncate" title="{__("GIF")}">{__("GIF")}</span>
                                </button>
                              {/if}
                              {if $system['voice_notes_posts_enabled']}
                                <button type="button" class="publisher-tools-tab js_publisher-tab" data-tab="voice_notes" role="menuitem">
                                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-error/15 text-error"><span class="icon-[tabler--microphone] size-4" aria-hidden="true"></span></span>
                                  <span class="truncate" title="{__("Voice")}">{__("Voice")}</span>
                                </button>
                              {/if}
                              {if $user->_data['can_add_reels']}
                                <div class="publisher-tools-tab attach js_publisher-tab" data-tab="reel" role="menuitem">
                                  <span class="js_x-uploader flex w-full items-center gap-2.5" data-handle="publisher" data-type="reel">
                                    <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-accent/15 text-accent"><span class="icon-[tabler--movie] size-4 pointer-events-none" aria-hidden="true"></span></span>
                                    <span class="truncate" title="{__("Reel")}">{__("Reel")}</span>
                                  </span>
                                </div>
                              {/if}
                              {if $user->_data['can_upload_audios']}
                                <div class="publisher-tools-tab attach js_publisher-tab" data-tab="audio" role="menuitem">
                                  <span class="js_x-uploader flex w-full items-center gap-2.5" data-handle="publisher" data-type="audio">
                                    <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-secondary/15 text-secondary"><span class="icon-[tabler--music] size-4 pointer-events-none" aria-hidden="true"></span></span>
                                    <span class="truncate" title="{__("Audio")}">{__("Audio")}</span>
                                  </span>
                                </div>
                              {/if}
                              {if $user->_data['can_upload_files']}
                                <div class="publisher-tools-tab attach js_publisher-tab" data-tab="file" role="menuitem">
                                  <span class="js_x-uploader flex w-full items-center gap-2.5" data-handle="publisher" data-type="file">
                                    <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-info/15 text-info"><span class="icon-[tabler--paperclip] size-4 pointer-events-none" aria-hidden="true"></span></span>
                                    <span class="truncate" title="{__("File")}">{__("File")}</span>
                                  </span>
                                </div>
                              {/if}
                              {if $system['blogs_enabled'] && in_array($_handle, ['me', 'page', 'group', 'event'])}
                                <a class="publisher-tools-tab link js_publisher-tab" data-tab="blog" href='{$system['system_url']}/blogs/new{if $_handle == "page"}?page={$_id}{/if}{if $_handle == "group"}?group={$_id}{/if}{if $_handle == "event"}?event={$_id}{/if}' role="menuitem">
                                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-primary/15 text-primary"><span class="icon-[tabler--article] size-4" aria-hidden="true"></span></span>
                                  <span class="min-w-0 flex-1 truncate" title="{__("Blog")}">{__("Blog")}</span>
                                  {if $system['paid_blogs_enabled']}<span class="badge badge-soft badge-error badge-xs">{__("Paid")}</span>{/if}
                                </a>
                              {/if}
                              {if $system['market_enabled'] && in_array($_handle, ['me', 'page', 'group', 'event'])}
                                <button type="button" class="js_modal publisher-tools-tab link js_publisher-tab" data-tab="product" data-url="posts/product.php?do=create{if $_handle == "page"}&page={$_id}{/if}{if $_handle == "group"}&group={$_id}{/if}{if $_handle == "event"}&event={$_id}{/if}" role="menuitem">
                                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-success/15 text-success"><span class="icon-[tabler--shopping-bag] size-4" aria-hidden="true"></span></span>
                                  <span class="min-w-0 flex-1 truncate" title="{__("Product")}">{__("Product")}</span>
                                  {if $system['paid_products_enabled']}<span class="badge badge-soft badge-error badge-xs">{__("Paid")}</span>{/if}
                                </button>
                              {/if}
                              {if $system['funding_enabled'] && $_handle == "me"}
                                <button type="button" class="js_modal publisher-tools-tab link js_publisher-tab" data-tab="funding" data-url="posts/funding.php?do=create" role="menuitem">
                                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-error/15 text-error"><span class="icon-[tabler--heart-dollar] size-4" aria-hidden="true"></span></span>
                                  <span class="min-w-0 flex-1 truncate" title="{__("Funding")}">{__("Funding")}</span>
                                  {if $system['paid_funding_enabled']}<span class="badge badge-soft badge-error badge-xs">{__("Paid")}</span>{/if}
                                </button>
                              {/if}
                              {if $system['offers_enabled'] && in_array($_handle, ['me', 'page', 'group', 'event'])}
                                <button type="button" class="js_modal publisher-tools-tab link js_publisher-tab" data-tab="offer" data-url="posts/offer.php?do=create{if $_handle == "page"}&page={$_id}{/if}{if $_handle == "group"}&group={$_id}{/if}{if $_handle == "event"}&event={$_id}{/if}" role="menuitem">
                                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-accent/15 text-accent"><span class="icon-[tabler--discount-2] size-4" aria-hidden="true"></span></span>
                                  <span class="min-w-0 flex-1 truncate" title="{__("Offer")}">{__("Offer")}</span>
                                  {if $system['paid_offers_enabled']}<span class="badge badge-soft badge-error badge-xs">{__("Paid")}</span>{/if}
                                </button>
                              {/if}
                              {if $system['jobs_enabled'] && in_array($_handle, ['me', 'page', 'group', 'event'])}
                                <button type="button" class="js_modal publisher-tools-tab link js_publisher-tab" data-tab="job" data-url="posts/job.php?do=create{if $_handle == "page"}&page={$_id}{/if}{if $_handle == "group"}&group={$_id}{/if}{if $_handle == "event"}&event={$_id}{/if}" role="menuitem">
                                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-info/15 text-info"><span class="icon-[tabler--briefcase] size-4" aria-hidden="true"></span></span>
                                  <span class="min-w-0 flex-1 truncate" title="{__("Job")}">{__("Job")}</span>
                                  {if $system['paid_jobs_enabled']}<span class="badge badge-soft badge-error badge-xs">{__("Paid")}</span>{/if}
                                </button>
                              {/if}
                              {if $system['courses_enabled'] && in_array($_handle, ['me', 'page', 'group', 'event'])}
                                <button type="button" class="js_modal publisher-tools-tab link js_publisher-tab" data-tab="job" data-url="posts/course.php?do=create{if $_handle == "page"}&page={$_id}{/if}{if $_handle == "group"}&group={$_id}{/if}{if $_handle == "event"}&event={$_id}{/if}" role="menuitem">
                                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full bg-warning/15 text-warning"><span class="icon-[tabler--school] size-4" aria-hidden="true"></span></span>
                                  <span class="min-w-0 flex-1 truncate" title="{__("Course")}">{__("Course")}</span>
                                  {if $system['paid_courses_enabled']}<span class="badge badge-soft badge-error badge-xs">{__("Paid")}</span>{/if}
                                </button>
                              {/if}
                            </div>
                          </div>
                        </div>
                      </div>
                    {/if}
                  </div>
                  <div class="ms-auto flex items-center gap-2 max-sm:w-full">
                    {if $user->_data['can_schedule_posts'] || ($_handle == "me" && $user->_data['can_add_anonymous_posts']) || $system['adult_mode'] || ($_handle != "page" && $user->_data['can_receive_tip']) || (in_array($_handle, ['me', 'page', 'group']) && $_node_can_monetize_content && $_node_monetization_enabled && $_node_monetization_plans > 0) || (in_array($_handle, ['me', 'page', 'group', 'event']) && $user->_data['can_monetize_content'] && $user->_data['user_monetization_enabled']) || (in_array($_handle, ['me', 'group', 'event']) && $user->_data['can_add_collaborative_posts'])}
                      <button type="button" class="accordion-toggle heroui button button--ghost button--icon-only rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-full size-9 shrink-0 p-0 text-base-content/70 shadow-none hover:bg-base-200" aria-expanded="false" aria-controls="publisher-settings-content{if $_modal_mode}-modal{/if}" title='{__("Advanced Settings")}' aria-label='{__("Advanced Settings")}'>
                        <span class="icon-[tabler--adjustments-horizontal] size-5" aria-hidden="true"></span>
                      </button>
                    {/if}
                    {if $_post_as_page}
                      <input type="hidden" name="post_as_page" value="{$_page_id}">
                    {/if}
                    <button type="button" class="heroui button button--primary h-9 min-w-24 px-5 max-sm:flex-1 js_publisher-btn js_publisher">{if $publisher_edit}{__("Save Changes")}{else}{__("Post")}{/if}</button>
                  </div>
                </div>
                <!-- publisher-buttons -->
              </div>
            </div>
          </div>
          <!-- publisher-footer -->
        </div>
        <!-- publisher-slider -->
      </div>
    </div>
  {/if}
{/if}
