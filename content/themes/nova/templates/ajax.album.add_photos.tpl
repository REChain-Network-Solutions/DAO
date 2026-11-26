<div class="modal__header shrink-0 flex-row items-center gap-2.5 border-b border-base-300 px-4 py-3 sm:px-5">
  <h6 class="modal__heading min-w-0 flex-1 text-base font-semibold text-base-content">{__("Add Photos")}</h6>
  {include file='__close_button.tpl' extra_class="static"}
</div>

<div class="modal__body flex min-h-0 flex-col overflow-hidden p-0">
  <div class="x-form publisher mini relative flex min-h-0 w-full flex-1 flex-col overflow-hidden [&_.x-uploader]:relative [&_.x-uploader]:cursor-pointer [&_.x-uploader]:overflow-hidden [&_.x-uploader>input[type=file]]:absolute [&_.x-uploader>input[type=file]]:inset-0 [&_.x-uploader>input[type=file]]:z-10 [&_.x-uploader>input[type=file]]:size-full [&_.x-uploader>input[type=file]]:cursor-pointer [&_.x-uploader>input[type=file]]:opacity-0 [&_.x-progress]:h-1.5 [&_.x-progress]:overflow-hidden [&_.x-progress]:rounded-full [&_.x-progress]:bg-base-300 [&_.progress-bar]:h-full [&_.progress-bar]:bg-primary" data-id="{$album['album_id']}">

    <!-- publisher-identity -->
    <div class="flex shrink-0 items-center gap-3 px-4 pt-4 sm:px-5">
      <img class="size-11 shrink-0 rounded-full object-cover" src="{$user->_data['user_picture']}" alt="">
      <div class="min-w-0 flex-1">
        <div class="truncate text-sm font-semibold text-base-content" title="{$user->_data['user_fullname']}">{$user->_data['user_fullname']}</div>
        <div class="mt-1 flex min-w-0 items-center gap-1.5">
          {if $album['user_type'] == 'user' && !$album['in_group'] && !$album['in_event']}
            <select class="select select-sm w-auto min-w-0 rounded-full text-xs font-medium [--border:1px] js_publisher-privacy" name="privacy" aria-label='{__("Privacy")}'>
              <option value="public">{__("Public")}</option>
              <option value="friends" selected>{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</option>
              <option value="me">{__("Only Me")}</option>
            </select>
          {elseif $album['privacy'] == "custom"}
            <select class="select select-sm w-auto min-w-0 rounded-full text-xs font-medium [--border:1px] js_publisher-privacy" name="privacy" disabled aria-label='{__("Privacy")}'>
              <option value="custom" selected>{__("Custom")}</option>
            </select>
          {elseif $album['privacy'] == "public"}
            <select class="select select-sm w-auto min-w-0 rounded-full text-xs font-medium [--border:1px] js_publisher-privacy" name="privacy" disabled aria-label='{__("Privacy")}'>
              <option value="public" selected>{__("Public")}</option>
            </select>
          {/if}
          <span class="badge badge-soft badge-primary badge-lg min-w-0 gap-1 rounded-full text-xs font-medium">
            <span class="icon-[tabler--photo-plus] size-3.5 shrink-0" aria-hidden="true"></span>
            <span class="truncate" title="{__($album['title'])}">{__($album['title'])}</span>
          </span>
        </div>
      </div>
    </div>
    <!-- publisher-identity -->

    <!-- publisher-message -->
    <div class="publisher-message flex shrink-0 px-4 py-3 sm:px-5">
      <textarea dir="auto" autofocus class="js_autosize js_mentions min-h-24 max-h-[35dvh] w-full resize-none bg-transparent text-[0.9375rem] leading-6 text-base-content outline-none placeholder:text-base-content/50 sm:text-base" placeholder='{__("What is on your mind?")}'></textarea>
    </div>
    <!-- publisher-message -->
    <div class="flex justify-end px-4 pb-2 sm:px-5">{include file='__emoji_trigger.tpl'}</div>

    <!-- publisher-body -->
    <div class="flex min-h-0 flex-1 flex-col overflow-y-auto [&_.publisher-meta]:hidden [&_.publisher-meta]:mx-4 [&_.publisher-meta]:mb-2.5 [&_.publisher-meta]:flex [&_.publisher-meta]:items-center [&_.publisher-meta]:gap-2.5 sm:[&_.publisher-meta]:mx-5 [&_.publisher-meta[data-meta=feelings]]:flex-col [&_.publisher-meta[data-meta=feelings]]:items-stretch [&_.publisher-meta[data-meta=colored]]:flex-wrap [&_.publisher-meta_input]:min-w-0 [&_.publisher-meta_input]:flex-1 [&_.publisher-meta_input]:text-sm [&_.publisher-meta_input]:outline-none [&_.publisher-meta_select]:w-full [&_.publisher-meta_select]:rounded-field [&_.publisher-meta_select]:border [&_.publisher-meta_select]:border-base-300 [&_.publisher-meta_select]:bg-base-100 [&_.publisher-meta_select]:px-3 [&_.publisher-meta_select]:py-2 [&_.publisher-attachments>ul]:m-0 [&_.publisher-attachments>ul]:grid [&_.publisher-attachments>ul]:list-none [&_.publisher-attachments>ul]:grid-cols-2 [&_.publisher-attachments>ul]:gap-2 [&_.publisher-attachments>ul]:p-0 sm:[&_.publisher-attachments>ul]:grid-cols-3 [&_.publisher-attachments_li]:relative [&_.publisher-attachments_li]:overflow-hidden [&_.publisher-attachments_li]:rounded-box [&_.publisher-attachments_li]:bg-base-200 [&_.publisher-attachments_img]:aspect-square [&_.publisher-attachments_img]:size-full [&_.publisher-attachments_img]:object-cover [&_.publisher-attachments_.button]:absolute [&_.publisher-attachments_.button]:end-1.5 [&_.publisher-attachments_.button]:top-1.5">

      <!-- post attachments (photos) -->
      <div class="publisher-attachments attachments mx-4 mb-2.5 hidden sm:mx-5 js_attachments-photos"></div>
      <!-- post attachments -->

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

      <!-- publisher-buttons -->
      <div class="publisher-footer-buttons sticky bottom-0 z-20 mt-auto flex flex-wrap items-center gap-x-2 gap-y-2.5 border-t border-base-300 bg-base-100 px-3 py-2.5 sm:px-4">
        <div class="publisher-tools-tabs flex min-w-0 items-center gap-0.5 [&>.publisher-tools-tab.attach]:overflow-hidden [&>.publisher-tools-tab.attach>.x-uploader]:absolute [&>.publisher-tools-tab.attach>.x-uploader]:inset-0 [&_.publisher-tools-tab.active]:bg-current/15 [&_.publisher-tools-tab.activated]:bg-primary/10 [&_.publisher-tools-tab.activated]:text-primary [&_.publisher-tools-tab.disabled]:pointer-events-none [&_.publisher-tools-tab.disabled]:opacity-40">
          {if $system['photos_enabled']}
            <div class="publisher-tools-tab attach relative size-9 shrink-0 rounded-full text-success transition-colors hover:bg-base-200 js_publisher-tab" data-tab="photos">
              <span class="js_x-uploader heroui button button--ghost button--icon-only rounded-full size-9 text-success shadow-none hover:bg-base-200" data-handle="publisher" data-multiple="true" title='{__("Photos")}' aria-label='{__("Photos")}'>
                <span class="icon-[tabler--photo] size-5 pointer-events-none" aria-hidden="true"></span>
              </span>
            </div>
          {/if}
          {if $user->_data['can_add_activity_posts']}
            <button type="button" class="publisher-tools-tab heroui button button--ghost button--icon-only rounded-full size-9 text-warning shadow-none hover:bg-base-200 js_publisher-feelings" title='{__("Feelings/Activity")}' aria-label='{__("Feelings/Activity")}'>
              <span class="icon-[tabler--mood-smile] size-5" aria-hidden="true"></span>
            </button>
          {/if}
          {if $user->_data['can_add_geolocation_posts']}
            <button type="button" class="publisher-tools-tab heroui button button--ghost button--icon-only rounded-full size-9 text-info shadow-none hover:bg-base-200 js_publisher-tab" data-tab="location" title='{__("Check In")}' aria-label='{__("Check In")}'>
              <span class="icon-[tabler--map-pin] size-5" aria-hidden="true"></span>
            </button>
          {/if}
        </div>
        <button type="button" class="heroui button button--primary ms-auto h-9 min-w-24 px-5 js_publisher-btn js_publisher-album">{__("Post")}</button>
      </div>
      <!-- publisher-buttons -->
    </div>
    <!-- publisher-body -->
  </div>
</div>
