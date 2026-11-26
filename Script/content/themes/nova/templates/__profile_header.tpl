<!-- profile header -->
<section class="rounded-3xl bg-base-100 pb-4 sm:pb-6" aria-labelledby="profile-name">
  <!-- profile-cover -->
  <div class="profile-cover-wrapper group/cover relative aspect-[3/1] overflow-hidden rounded-t-3xl bg-linear-to-br from-primary/35 via-primary/10 to-base-200 sm:aspect-[18/5] [&>img]:absolute [&>img]:start-0 [&>img]:top-0 [&>img]:w-full [&>.js\_position-cover-cropped]:h-full [&>.js\_position-cover-cropped]:object-cover [&>.js\_position-cover-full]:h-auto [&>.js\_position-cover-full]:cursor-move [&>.js\_position-cover-full]:touch-none [&>.js\_position-cover-full]:select-none">
    {if $profile['user_cover_id']}
      <!-- full-cover -->
      <img alt="" class="js_position-cover-full hidden" src="{$profile['user_cover_full']}">
      <!-- full-cover -->

      <!-- cropped-cover -->
      <img class="js_position-cover-cropped {if $user->_logged_in && $profile['user_cover_lightbox']}js_lightbox cursor-pointer{/if}" data-init-position="{$profile['user_cover_position']}" data-id="{$profile['user_cover_id']}" data-image="{$profile['user_cover_full']}" data-context="album" src="{$profile['user_cover']}" alt="{$profile['name']}">
      <!-- cropped-cover -->
    {/if}
    {if $profile['user_id'] == $user->_data['user_id']}
      <!-- buttons -->
      <div class="absolute end-3 top-3 z-20 flex flex-wrap items-center justify-end gap-2 sm:end-5 sm:top-5">
        <div class="profile-cover-change dropdown relative inline-flex pointer-events-none opacity-0 transition-opacity group-hover/cover:pointer-events-auto group-hover/cover:opacity-100 focus-within:pointer-events-auto focus-within:opacity-100 dropdown-open:pointer-events-auto dropdown-open:opacity-100 [@media(hover:none)]:pointer-events-auto [@media(hover:none)]:opacity-100 [--placement:bottom-end] [--strategy:fixed]">
          <button type="button" class="dropdown-toggle heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full border-transparent bg-base-100 text-base-content shadow-sm" aria-haspopup="menu" aria-expanded="false" aria-label='{__("Edit Cover")}' id="profile-cover-menu"><span class="icon-[tabler--edit] size-4" aria-hidden="true"></span></button>
          <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-60 max-w-[calc(100vw-2rem)] rounded-2xl border border-base-300 bg-base-100 p-2 shadow-lg [&_.x-uploader]:relative [&_.x-uploader:hover>.dropdown-item]:bg-neutral/10 [&_.x-uploader:focus-within>.dropdown-item]:bg-neutral/10 [&_.x-uploader]:cursor-pointer [&_.x-uploader]:overflow-hidden [&_.x-uploader>input[type=file]]:absolute [&_.x-uploader>input[type=file]]:inset-0 [&_.x-uploader>input[type=file]]:z-10 [&_.x-uploader>input[type=file]]:size-full [&_.x-uploader>input[type=file]]:cursor-pointer [&_.x-uploader>input[type=file]]:opacity-0" aria-labelledby="profile-cover-menu">
            <!-- upload -->
            <div class="dropdown-item flex h-11 cursor-pointer items-center gap-3 rounded-xl px-3 text-sm font-medium js_x-uploader" data-handle="cover-user">
              <span class="icon-[tabler--upload] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
              <span>{__("Upload Photo")}</span>
            </div>
            <!-- upload -->
            <!-- select -->
            <button type="button" class="js_modal dropdown-close dropdown-item flex h-11 w-full items-center gap-3 rounded-xl px-3 text-start text-sm font-medium" data-url="users/photos.php?filter=cover&type=user&id={$profile['user_id']}">
              <span class="icon-[tabler--photo] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
              <span>{__("Select Photo")}</span>
            </button>
            <!-- select -->
            <div class="profile-cover-position {if !$profile['user_cover']}hidden{/if}">
              <input class="js_position-picture-val" type="hidden" name="position-picture-val">
              <button type="button" class="dropdown-item dropdown-close flex h-11 w-full items-center gap-3 rounded-xl px-3 text-start text-sm font-medium js_init-position-picture" data-handle="user" data-id="{$profile['user_id']}">
                <span class="icon-[tabler--crop] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                <span>{__("Reposition")}</span>
              </button>
            </div>
            <div class="profile-cover-delete border-t border-base-300 pt-1 {if !$profile['user_cover']}hidden{/if}">
              <button type="button" class="dropdown-item dropdown-close flex h-11 w-full items-center gap-3 rounded-xl px-3 text-start text-sm font-medium text-error! hover:bg-error/10! focus-visible:bg-error/10! js_delete-cover" data-handle="cover-user">
                <span class="icon-[tabler--trash] size-5 shrink-0" aria-hidden="true"></span>
                <span>{__("Delete")}</span>
              </button>
            </div>
          </div>
        </div>
        <div class="profile-cover-position-buttons hidden">
          <button type="button" class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full border-transparent bg-base-100 text-base-content shadow-sm js_save-position-picture" aria-label='{__("Save")}'><span class="icon-[tabler--check] size-4" aria-hidden="true"></span></button>
        </div>
        <div class="profile-cover-position-buttons hidden">
          <button type="button" class="heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full border-transparent bg-base-100 text-base-content shadow-sm js_cancel-position-picture" aria-label='{__("Cancel")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
        </div>
      </div>
      <!-- buttons -->

      <!-- loaders -->
      <div class="profile-cover-change-loader absolute inset-0 z-30 hidden bg-base-100/80 px-8 pt-[12%]">
        <div class="progress x-progress h-2 w-full bg-base-300">
          <div class="progress-bar h-full rounded-full bg-primary" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
        </div>
      </div>
      <div class="profile-cover-position-loader pointer-events-none absolute inset-x-3 bottom-3 z-10 hidden rounded-field bg-black/60 px-3 py-2 text-center text-xs text-white">
        <span class="icon-[tabler--arrows-move] me-1 inline-block size-4 align-middle" aria-hidden="true"></span>{__("Drag to reposition cover")}
      </div>
      <!-- loaders -->
    {/if}
  </div>
  <!-- profile-cover -->

  <div class="grid min-w-0 gap-6 px-4 sm:px-6 sm:grid-cols-[10rem_minmax(0,1fr)] sm:gap-x-8 xl:grid-cols-[13rem_minmax(0,1fr)]">
    <!-- profile-avatar -->
    <div class="profile-avatar-wrapper group/avatar relative z-10 -mt-12 size-32 shrink-0 rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[3rem] bg-base-200 ring-8 ring-base-100 sm:-mt-16 sm:size-40 xl:-mt-20 xl:size-52 [&>img]:size-full [&>img]:rounded-[inherit] [&>img]:corner-squircle [&>img]:object-cover">
      {if $profile['stories']['active']}
        <span class="absolute -inset-1.5 -z-10 rounded-[inherit] corner-squircle bg-linear-to-tr {if $profile['stories']['seen']}from-base-content/25 to-base-content/25{else}from-amber-400 via-rose-500 to-fuchsia-600{/if}" aria-hidden="true"></span>
        <div class="dropdown absolute inset-0 rounded-[inherit] corner-squircle [--placement:bottom-start] [--strategy:fixed]">
          <button type="button" class="dropdown-toggle block size-full cursor-pointer rounded-[inherit] corner-squircle focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-primary" aria-haspopup="menu" aria-expanded="false" aria-label="{$profile['name']}" id="profile-story-menu">
            <img class="size-full rounded-[inherit] corner-squircle object-cover" src="{$profile['user_picture']}" alt="{$profile['name']}">
          </button>
          <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-60 max-w-[calc(100vw-2rem)] rounded-2xl border border-base-300 bg-base-100 p-2 shadow-lg" role="menu" aria-orientation="vertical" aria-labelledby="profile-story-menu">
            <button type="button" class="js_story-open dropdown-close dropdown-item flex h-11 w-full items-center gap-3 rounded-xl px-3 text-start text-sm font-medium" role="menuitem" data-user-id="{$profile['user_id']}">
              <span class="icon-[tabler--history-toggle] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
              <span>{__("View story")}</span>
            </button>
            {if $profile['user_picture_id'] && $user->_logged_in && $profile['user_picture_lightbox']}
              <button type="button" class="js_lightbox dropdown-close dropdown-item flex h-11 w-full items-center gap-3 rounded-xl px-3 text-start text-sm font-medium" role="menuitem" data-id="{$profile['user_picture_id']}" data-context="album" data-image="{$profile['user_picture_full']}">
                <span class="icon-[tabler--user-square] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                <span>{__("See profile picture")}</span>
              </button>
            {elseif !$profile['user_picture_id'] && !$profile['user_picture_default']}
              <button type="button" class="js_lightbox-nodata dropdown-close dropdown-item flex h-11 w-full items-center gap-3 rounded-xl px-3 text-start text-sm font-medium" role="menuitem" data-image="{$profile['user_picture']}">
                <span class="icon-[tabler--user-square] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                <span>{__("See profile picture")}</span>
              </button>
            {/if}
          </div>
        </div>
      {else}
        <img {if $profile['user_picture_id']} {if $user->_logged_in && $profile['user_picture_lightbox']}class="js_lightbox cursor-pointer" {/if} data-id="{$profile['user_picture_id']}" data-context="album" data-image="{$profile['user_picture_full']}" {elseif !$profile['user_picture_default']} class="js_lightbox-nodata cursor-pointer" data-image="{$profile['user_picture']}" {/if} src="{$profile['user_picture']}" alt="{$profile['name']}">
      {/if}

      {if $profile['user_id'] == $user->_data['user_id']}
        <!-- buttons -->
        <div class="absolute end-2 bottom-2 z-20 sm:end-3 sm:bottom-3">
          <div class="profile-avatar-change dropdown relative inline-flex pointer-events-none opacity-0 transition-opacity group-hover/avatar:pointer-events-auto group-hover/avatar:opacity-100 focus-within:pointer-events-auto focus-within:opacity-100 dropdown-open:pointer-events-auto dropdown-open:opacity-100 [@media(hover:none)]:pointer-events-auto [@media(hover:none)]:opacity-100 [--placement:bottom-start] [--strategy:fixed]">
            <button type="button" class="dropdown-toggle heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full border-transparent bg-base-100 text-base-content shadow-sm" aria-haspopup="menu" aria-expanded="false" aria-label='{__("Edit Picture")}' id="profile-avatar-menu"><span class="icon-[tabler--edit] size-4" aria-hidden="true"></span></button>
            <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-60 max-w-[calc(100vw-2rem)] rounded-2xl border border-base-300 bg-base-100 p-2 shadow-lg [&_.x-uploader]:relative [&_.x-uploader:hover>.dropdown-item]:bg-neutral/10 [&_.x-uploader:focus-within>.dropdown-item]:bg-neutral/10 [&_.x-uploader]:cursor-pointer [&_.x-uploader]:overflow-hidden [&_.x-uploader>input[type=file]]:absolute [&_.x-uploader>input[type=file]]:inset-0 [&_.x-uploader>input[type=file]]:z-10 [&_.x-uploader>input[type=file]]:size-full [&_.x-uploader>input[type=file]]:cursor-pointer [&_.x-uploader>input[type=file]]:opacity-0" aria-labelledby="profile-avatar-menu">
              <!-- upload -->
              <div class="dropdown-item flex h-11 cursor-pointer items-center gap-3 rounded-xl px-3 text-sm font-medium js_x-uploader" data-handle="picture-user">
                <span class="icon-[tabler--upload] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                <span>{__("Upload Photo")}</span>
              </div>
              <!-- upload -->
              <!-- select -->
              <button type="button" class="js_modal dropdown-close dropdown-item flex h-11 w-full items-center gap-3 rounded-xl px-3 text-start text-sm font-medium" data-url="users/photos.php?filter=avatar&type=user&id={$profile['user_id']}">
                <span class="icon-[tabler--photo] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                <span>{__("Select Photo")}</span>
              </button>
              <!-- select -->
              <div class="profile-avatar-crop {if $profile['user_picture_default'] || !$profile['user_picture_id']}hidden{/if}">
                <button type="button" class="dropdown-item dropdown-close flex h-11 w-full items-center gap-3 rounded-xl px-3 text-start text-sm font-medium js_init-crop-picture" data-image="{$profile['user_picture_full']}" data-handle="user" data-id="{$profile['user_id']}">
                  <span class="icon-[tabler--crop] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                  <span>{__("Crop")}</span>
                </button>
              </div>
              <div class="profile-avatar-delete border-t border-base-300 pt-1 {if $profile['user_picture_default']}hidden{/if}">
                <button type="button" class="dropdown-item dropdown-close flex h-11 w-full items-center gap-3 rounded-xl px-3 text-start text-sm font-medium text-error! hover:bg-error/10! focus-visible:bg-error/10! js_delete-picture" data-handle="picture-user">
                  <span class="icon-[tabler--trash] size-5 shrink-0" aria-hidden="true"></span>
                  <span>{__("Delete")}</span>
                </button>
              </div>
            </div>
          </div>
        </div>
        <!-- buttons -->
        <!-- loaders -->
        <div class="profile-avatar-change-loader absolute inset-0 z-30 hidden rounded-[inherit] corner-squircle bg-base-100/80 px-3 pt-[45%]">
          <div class="progress x-progress h-2 w-full bg-base-300">
            <div class="progress-bar h-full rounded-full bg-primary" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
          </div>
        </div>
        <!-- loaders -->
      {/if}
    </div>
    <!-- profile-avatar -->

    <div class="min-w-0 sm:pt-6 xl:grid xl:grid-cols-[minmax(0,1fr)_auto] xl:gap-x-6">
      <!-- profile-name -->
      <div class="min-w-0 xl:col-start-1">
        <h1 class="inline-flex flex-wrap items-center gap-2 text-2xl sm:text-3xl font-bold tracking-tight" id="profile-name">
          <a class="min-w-0 text-base-content! [overflow-wrap:anywhere]" href="{$system['system_url']}/{$profile['user_name']}">{$profile['name']}</a>
          {if $profile['user_verified']}
            {include file='__badge.tpl' _badge="verified" _badge_type="user" _badge_size=20}
          {/if}
          {if $profile['user_subscribed']}
            {include file='__badge.tpl' _badge="pro" _badge_package=$profile['package_name'] _badge_href="{$system['system_url']}/packages" _badge_size=20}
          {/if}
        </h1>
        <div class="mt-1 flex flex-wrap items-center gap-2 text-sm text-base-content/60">
          <span class="break-all" dir="auto">@{$profile['user_name']}</span>
          {if $profile['custom_user_group']}
            <span class="badge badge-soft badge-primary badge-sm rounded-full">{__($profile['custom_user_group']['user_group_title'])}</span>
          {/if}
        </div>
      </div>
      <!-- profile-name -->

      <!-- profile-stats -->
      <div class="mt-2 flex xl:col-span-2 flex-wrap items-center gap-x-1.5 text-sm font-semibold text-base-content">
        <a class="link link-animated font-semibold! text-base-content!" href="{$system['system_url']}/{$profile['user_name']}/followers"><span class="tabular-nums">{abbreviate_count($profile['followers_count'])}</span> {__("followers")}</a>
        <span class="text-base-content/40" aria-hidden="true">&middot;</span>
        <a class="link link-animated font-semibold! text-base-content!" href="{$system['system_url']}/{$profile['user_name']}/followings"><span class="tabular-nums">{abbreviate_count($profile['followings_count'])}</span> {__("following")}</a>
        {if $system['friends_enabled']}
          <span class="text-base-content/40" aria-hidden="true">&middot;</span>
          <a class="link link-animated font-semibold! text-base-content!" href="{$system['system_url']}/{$profile['user_name']}/friends"><span class="tabular-nums">{abbreviate_count($profile['friends_count'])}</span> {__("friends")}</a>
        {/if}
      </div>
      <!-- profile-stats -->

      <!-- profile-meta -->
      {assign var="_show_work" value=($system['work_info_enabled'] && !is_empty($profile['user_work_title']) && ($profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_work'] == "public" || ($profile['user_privacy_work'] == "friends" && $profile['we_friends'])))}
      {assign var="_show_location" value=($system['location_info_enabled'] && !is_empty($profile['user_current_city']) && ($profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_location'] == "public" || ($profile['user_privacy_location'] == "friends" && $profile['we_friends'])))}
      {assign var="_show_education" value=($system['education_info_enabled'] && !is_empty($profile['user_edu_school']) && ($profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_education'] == "public" || ($profile['user_privacy_education'] == "friends" && $profile['we_friends'])))}
      {assign var="_show_website" value=($system['website_info_enabled'] && !is_empty($profile['user_website']))}
      {if $_show_work || $_show_location || $_show_education || $_show_website}
        <ul class="mt-2 flex xl:col-span-2 flex-wrap items-center gap-x-4 gap-y-1 text-sm text-base-content">
          {if $_show_work}
            <li class="inline-flex min-w-0 items-center gap-1.5">
              <span class="icon-[tabler--briefcase-filled] size-4 shrink-0" aria-hidden="true"></span>
              <span class="min-w-0 [overflow-wrap:anywhere]">
                {$profile['user_work_title']}
                {if $profile['user_work_place']}
                  {__("at")}
                  {if $profile['user_work_url']}
                    <a class="link link-animated text-base-content!" target="_blank" rel="nofollow noopener" href="{$profile['user_work_url']}">{$profile['user_work_place']}</a>
                  {else}
                    <span class="font-medium">{$profile['user_work_place']}</span>
                  {/if}
                {/if}
              </span>
            </li>
          {/if}
          {if $_show_location}
            <li class="inline-flex min-w-0 items-center gap-1.5">
              <span class="icon-[tabler--map-pin-filled] size-4 shrink-0" aria-hidden="true"></span>
              <span class="min-w-0 [overflow-wrap:anywhere]">{$profile['user_current_city']}</span>
            </li>
          {/if}
          {if $_show_education}
            <li class="flex basis-full min-w-0 items-center gap-1.5">
              <span class="icon-[tabler--school] size-4 shrink-0" aria-hidden="true"></span>
              <span class="min-w-0 [overflow-wrap:anywhere]">{if $profile['user_edu_major']}{__("Studied")} {$profile['user_edu_major']} {__("at")} {/if}<span class="font-medium">{$profile['user_edu_school']}</span></span>
            </li>
          {/if}
          {if $_show_website}
            <li class="flex basis-full min-w-0 items-center gap-1.5">
              <span class="icon-[tabler--link] size-4 shrink-0" aria-hidden="true"></span>
              <a class="link link-animated min-w-0 font-normal! text-base-content! [overflow-wrap:anywhere]" target="_blank" rel="nofollow noopener" href="{$profile['user_website']}">{$profile['user_website']|regex_replace:"#^https?://(www\.)?#i":""|regex_replace:"#/$#":""}</a>
            </li>
          {/if}
        </ul>
      {/if}
      <!-- profile-meta -->

      <!-- mutual friends -->
      {if $profile['mutual_friends_count'] && $profile['mutual_friends_count'] > 0}
        <div class="mt-4 flex xl:col-span-2">
          <button type="button" class="js_modal inline-flex items-center gap-2.5 text-sm text-base-content/60 hover:text-primary" data-url="users/mutual_friends.php?uid={$profile['user_id']}">
            {if $profile['mutual_friends']}
              <span class="avatar-group -space-x-3">
                {foreach $profile['mutual_friends'] as $_mutual_friend}
                  {if $_mutual_friend@iteration > 3}{break}{/if}
                  <span class="avatar">
                    <span class="size-8 rounded-full ring-2 ring-base-100">
                      <img src="{$_mutual_friend['user_picture']}" alt="" loading="lazy">
                    </span>
                  </span>
                {/foreach}
              </span>
            {/if}
            <span>{$profile['mutual_friends_count']} {__("mutual friends")}</span>
          </button>
        </div>
      {/if}
      <!-- mutual friends -->

      <!-- highlights -->
      {if $profile['stories']['highlights']}
        <div class="mt-5 min-w-0 border-t border-base-300 pt-4 xl:col-span-2">
          <h2 class="flex items-center gap-1.5 text-xs font-semibold tracking-wide text-base-content/50 uppercase">
            <span class="icon-[tabler--star] size-4" aria-hidden="true"></span>
            {__("Highlights")}
          </h2>
          <div class="-mx-1 mt-2 flex touch-pan-x gap-4 overflow-x-auto overscroll-x-contain scroll-smooth p-1 [scrollbar-width:none]! [&::-webkit-scrollbar]:hidden!">
            {foreach $profile['stories']['highlights'] as $highlight}
              <button type="button" class="js_story-open flex w-18 shrink-0 flex-col items-center gap-1.5" data-highlight-id="{$highlight['highlight_id']}">
                <span class="flex size-16 items-center justify-center overflow-hidden rounded-full bg-linear-to-br from-primary to-accent text-white ring-2 ring-base-300 ring-offset-2 ring-offset-base-100 transition active:scale-95">
                  {if $highlight['cover']}
                    <img class="size-full object-cover" src="{$highlight['cover']}" alt="" loading="lazy">
                  {else}
                    <span class="icon-[tabler--star] size-6" aria-hidden="true"></span>
                  {/if}
                </span>
                <span class="w-full truncate text-center text-xs font-medium" title="{$highlight['title']}">{$highlight['title']}</span>
              </button>
            {/foreach}
          </div>
        </div>
      {/if}
      <!-- highlights -->

      <!-- profile-buttons -->
      <div class="profile-buttons-wrapper mt-5 flex w-full flex-wrap items-center gap-2 max-sm:[&>[data-size]:not(.button--icon-only)]:grow max-sm:[&>[data-size]:not(.button--icon-only)]:basis-[calc(50%-0.25rem)] xl:col-start-2 xl:row-start-1 xl:mt-0 xl:w-auto xl:justify-end xl:self-center">
        {if $user->_logged_in}
          {if $user->_data['user_id'] != $profile['user_id']}
            <!-- add friend -->
            {if $system['friends_enabled']}
              {if $profile['we_friends']}
                {include file='__connection_button.tpl' _state="friends" _uid=$profile['user_id'] _btn_size="md"}
              {elseif $profile['he_request']}
                {include file='__connection_button.tpl' _state="friend_request" _uid=$profile['user_id'] _btn_size="md"}
              {elseif $profile['i_request']}
                {include file='__connection_button.tpl' _state="friend_sent" _uid=$profile['user_id'] _btn_size="md"}
              {elseif !$profile['friendship_declined']}
                {include file='__connection_button.tpl' _state="friend_add" _uid=$profile['user_id'] _btn_size="md"}
              {/if}
            {/if}
            <!-- add friend -->

            <!-- follow -->
            {if $profile['i_follow']}
              {include file='__connection_button.tpl' _state="following" _uid=$profile['user_id'] _btn_size="md"}
            {else}
              {include file='__connection_button.tpl' _state="follow" _uid=$profile['user_id'] _btn_size="md"}
            {/if}
            <!-- follow -->

            <!-- message -->
            {if $system['chat_enabled'] && $profile['user_privacy_chat'] == "public" || ($profile['user_privacy_chat'] == "friends" && $profile['we_friends'])}
              <button type="button" class="heroui button button--tertiary max-sm:flex-1 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_chat-start" data-uid="{$profile['user_id']}" data-name="{$profile['name']}" data-link="{$profile['user_name']}" data-picture="{$profile['user_picture']}">
                <span class="icon-[tabler--message-circle] size-4" aria-hidden="true"></span>
                <span>{__("Message")}</span>
                {if $profile['chat_price']}<small class="badge badge-sm rounded-2xl">{print_money($profile['chat_price'])}</small>{/if}
              </button>
            {/if}
            <!-- message -->

            <!-- poke & report & block menu -->
            <div class="dropdown relative inline-flex shrink-0 [--placement:bottom-end]">
              <button type="button" class="dropdown-toggle heroui button button--tertiary button--icon-only size-10 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false" aria-label='{__("More")}' id="profile-actions-menu">
                <span class="icon-[tabler--dots] size-4" aria-hidden="true"></span>
              </button>
              <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-72 max-w-[calc(100vw-2rem)] rounded-2xl border border-base-300 bg-base-100 p-2 shadow-lg" aria-labelledby="profile-actions-menu">
                <!-- poke -->
                {if $system['pokes_enabled'] && !$profile['i_poked']}
                  {if $profile['user_privacy_poke'] == "public" || ($profile['user_privacy_poke'] == "friends" && $profile['we_friends'])}
                    <button type="button" class="dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium js_poke" data-id="{$profile['user_id']}" data-name="{$profile['name']}">
                      <span class="icon-[tabler--hand-finger] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                      <span class="min-w-0">
                        <span class="block">{__("Poke")}</span>
                        <span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{__("Let them know you are here")}</span>
                      </span>
                    </button>
                  {/if}
                {/if}
                <!-- poke -->
                <!-- share -->
                <button type="button" class="js_modal dropdown-close dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium" data-url="modules/share.php?node_type=user&node_username={$profile['user_name']}">
                  <span class="icon-[tabler--share-3] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                  <span class="min-w-0">
                        <span class="block">{__("Share")}</span>
                        <span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{__("Share this profile")}</span>
                      </span>
                </button>
                <!-- share -->
                <!-- report -->
                <button type="button" class="js_modal dropdown-close dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium" data-url="data/report.php?do=create&handle=user&id={$profile['user_id']}">
                  <span class="icon-[tabler--flag] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                  <span class="min-w-0">
                        <span class="block">{__("Report")}</span>
                        <span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{__("Report this to admins")}</span>
                      </span>
                </button>
                <!-- report -->
                <!-- block -->
                <button type="button" class="dropdown-close dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium js_block-user" data-uid="{$profile['user_id']}">
                  <span class="icon-[tabler--ban] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                  <span class="min-w-0">
                        <span class="block">{__("Block")}</span>
                        <span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{__("This user won't be able to reach you")}</span>
                      </span>
                </button>
                <!-- block -->
                <!-- manage -->
                {if $user->_is_admin || $user->_is_moderator}
                  <div class="my-1 border-t border-base-300"></div>
                {/if}
                {if $user->_is_admin}
                  <a class="dropdown-close dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium text-base-content!" href="{$system['system_url']}/admincp/users/edit/{$profile['user_id']}">
                    <span class="icon-[tabler--user-cog] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                    <span class="min-w-0">
                      <span class="block">{__("Manage")}</span>
                      <span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{__("Edit in Admin Panel")}</span>
                    </span>
                  </a>
                {elseif $user->_is_moderator}
                  <a class="dropdown-close dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium text-base-content!" href="{$system['system_url']}/modcp/users/edit/{$profile['user_id']}">
                    <span class="icon-[tabler--user-cog] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                    <span class="min-w-0">
                      <span class="block">{__("Manage")}</span>
                      <span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{__("Edit in Moderator Panel")}</span>
                    </span>
                  </a>
                {/if}
                <!-- manage -->
              </div>
            </div>
            <!-- poke & report & block menu -->
          {else}
            <!-- edit -->
            <a href="{$system['system_url']}/settings/profile" class="heroui button button--tertiary w-full sm:w-auto rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
              <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
              {__("Edit Profile")}
            </a>
            <!-- edit -->
          {/if}
        {/if}
      </div>
      <!-- profile-buttons -->

      <!-- support -->
      {if $user->_logged_in && $user->_data['user_id'] != $profile['user_id']}
        {if $profile['has_subscriptions_plans'] || ($profile['can_receive_tips'] && $profile['user_tips_enabled']) || ($system['gifts_enabled'] && $user->_data['can_send_gifts'] && ($profile['user_privacy_gifts'] == "public" || ($profile['user_privacy_gifts'] == "friends" && $profile['we_friends'])))}
          <div class="mt-4 flex flex-wrap xl:col-span-2 items-center gap-2 border-t border-base-300 pt-4">
            <!-- subscribe -->
            {if $profile['has_subscriptions_plans']}
              <button type="button" class="js_modal heroui button button--primary h-auto min-h-10 max-w-full rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] py-2 whitespace-normal" data-url="monetization/controller.php?do=get_plans&node_id={$profile['user_id']}&node_type=profile" data-size="large">
                <span class="icon-[tabler--crown] size-4" aria-hidden="true"></span>
                <span>{__("SUBSCRIBE FOR")} {if $profile['user_monetization_discount_enabled']}{print_money($profile['user_monetization_min_price'] * (1 - $profile['user_monetization_discount_percent'] / 100))}{/if}{if $profile['user_monetization_discount_enabled']}<span class="ms-1 line-through opacity-70">{/if}{print_money($profile['user_monetization_min_price'])}{if $profile['user_monetization_discount_enabled']}</span>{/if}</span>
              </button>
            {/if}
            <!-- subscribe -->

            <div class="flex flex-wrap gap-2 max-sm:w-full max-sm:flex-nowrap max-sm:*:flex-1">
              <!-- tips -->
              {if $profile['can_receive_tips'] && $profile['user_tips_enabled']}
                <button type="button" class="js_modal heroui button button--tertiary rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] group relative overflow-visible border-0 pe-16 bg-linear-to-r from-orange-500 to-rose-500 text-white hover:brightness-105" data-url="#send-tip" data-options='{ "id": "{$profile['user_id']}"}'>
                  <img class="pointer-events-none absolute -top-1.5 end-3 size-10 -rotate-12 drop-shadow-sm transition-transform duration-300 group-hover:scale-110 group-hover:-rotate-6 rtl:rotate-12" src="{$system['system_url']}/content/themes/{$system['theme']}/images/svg/buttons/coin.svg" alt="" aria-hidden="true">
                  {__("Send a Tip")}
                </button>
              {/if}
              <!-- tips -->

              <!-- gifts -->
              {if $system['gifts_enabled'] && $user->_data['can_send_gifts'] && ($profile['user_privacy_gifts'] == "public" || ($profile['user_privacy_gifts'] == "friends" && $profile['we_friends']))}
                <button type="button" class="js_modal heroui button button--tertiary rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] group relative overflow-visible border-0 pe-16 bg-linear-to-r from-fuchsia-500 to-violet-600 text-white hover:brightness-105" data-url="#gifts" data-options='{ "uid": {$profile["user_id"]} }'>
                  <img class="pointer-events-none absolute -top-3 end-1.5 size-12 -rotate-12 drop-shadow-sm transition-transform duration-300 group-hover:scale-110 group-hover:-rotate-6 rtl:rotate-12" src="{$system['system_url']}/content/themes/{$system['theme']}/images/svg/buttons/gift.svg" alt="" aria-hidden="true">
                  {__("Send a Gift")}
                </button>
              {/if}
              <!-- gifts -->
            </div>
          </div>
        {/if}
      {/if}
      <!-- support -->
    </div>
  </div>
</section>
<!-- profile header -->
