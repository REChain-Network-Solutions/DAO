{include file='_head.tpl'}
{include file='_header.tpl'}

{if $view == "create"}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  <div class="flex items-center gap-4">
    <span class="inline-flex size-12 shrink-0 items-center justify-center rounded-2xl bg-error/10 text-error" aria-hidden="true">
      <span class="icon-[tabler--broadcast] size-6"></span>
    </span>
    <div class="min-w-0">
      <h1 class="text-2xl font-bold tracking-tight">{__("Go Live")}</h1>
      <p class="text-sm text-base-content/60">{__("Broadcast live video to your audience in real time")}</p>
    </div>
  </div>
  <!-- page heading -->

  <div class="group/live mt-6 grid gap-6 lg:grid-cols-[minmax(0,1fr)_24rem] lg:items-start lg:data-[comments=off]:grid-cols-1" id="js_live-layout">

    <!-- live stream -->
    <section class="card overflow-hidden border border-base-300 bg-neutral-950 shadow-none">
      <div class="relative isolate aspect-video min-h-80 w-full overflow-hidden bg-neutral-950 text-white">

        <!-- live placeholder -->
        <div class="absolute inset-0 -z-10 flex items-center justify-center" aria-hidden="true">
          <span class="absolute inset-0 scale-125 bg-cover bg-center opacity-40 blur-3xl" style="background-image: url('{$user->_data['user_picture']}');"></span>
          <span class="relative size-24 rounded-full bg-cover bg-center shadow-2xl ring-4 ring-white/15 sm:size-32" style="background-image: url('{$user->_data['user_picture']}');"></span>
        </div>
        <!-- live placeholder -->

        <!-- live video -->
        <div class="absolute inset-0 size-full" id="js_live-video"></div>
        <!-- live video -->

        <!-- live counter -->
        <div class="pointer-events-none absolute inset-x-0 top-0 z-10 flex items-start justify-between gap-3 bg-linear-to-b from-black/60 to-transparent p-3 sm:p-4">
          <div class="flex items-center gap-2">
            <span class="group/live offline inline-flex items-center gap-1.5 rounded-full bg-error px-2.5 py-1 text-xs font-bold tracking-wider text-white uppercase shadow-lg shadow-error/30 [&.offline]:bg-black/50 [&.offline]:shadow-none [&.offline]:backdrop-blur-md">
              <span class="size-1.5 animate-pulse rounded-full bg-current group-[.offline]/live:animate-none" aria-hidden="true"></span>
              <span id="js_live-counter-status">{__("Offline")}</span>
              <span class="tabular-nums group-[.offline]/live:hidden" id="js_live-timer">00:00:00</span>
            </span>
            <span class="inline-flex items-center gap-1.5 rounded-full bg-black/50 px-2.5 py-1 text-xs font-semibold text-white backdrop-blur-md">
              <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
              <span class="tabular-nums" id="js_live-counter-number">0</span>
            </span>
          </div>
          <!-- live recording -->
          {if $system['save_live_enabled']}
            <div class="hidden" id="js_live-recording">
              <span class="inline-flex items-center gap-1.5 rounded-full bg-black/50 px-2.5 py-1 text-xs font-semibold text-white backdrop-blur-md">
                <span class="size-2 animate-pulse rounded-full bg-error" aria-hidden="true"></span>
                {__("Recording")}
              </span>
            </div>
          {/if}
          <!-- live recording -->
        </div>
        <!-- live counter -->

        <!-- live status -->
        <div class="pointer-events-none absolute inset-0 z-10 flex items-center justify-center p-4">
          <div class="flex max-w-sm items-center gap-2.5 rounded-full bg-black/60 px-4 py-2.5 text-sm font-medium text-white shadow-lg ring-1 ring-white/10 backdrop-blur-md [&.error]:bg-error [&.success]:bg-success" id="js_live-status" role="status">
            <span class="icon-[tabler--camera] size-5 shrink-0" aria-hidden="true"></span>
            {__("Getting the Camera and Mic permissions")}
            <span class="loading loading-spinner loading-sm shrink-0"></span>
          </div>
        </div>
        <!-- live status -->

        <!-- live reactions -->
        <div class="js_live-reactions pointer-events-none absolute end-2 bottom-24 sm:end-4 z-10 h-3/5 w-24" aria-hidden="true">
          {foreach $system['reactions_enabled'] as $reaction}
            <img src="{$system['reactions'][$reaction['reaction']]['image_url']}" alt="" data-reaction="{$reaction['reaction']}" hidden>
          {/foreach}
        </div>
        <!-- live reactions -->

        <!-- live stream buttons -->
        <div class="absolute inset-x-0 bottom-0 z-20 bg-linear-to-t from-black/70 to-transparent px-3 pt-12 pb-4 sm:pb-5" id="js_live-stream-buttons" hidden>
          <div class="mx-auto flex w-fit items-center gap-2 rounded-full bg-white/10 p-2 shadow-2xl ring-1 ring-white/10 backdrop-blur-xl sm:gap-3">
            <!-- camera selection -->
            <div class="dropdown relative inline-flex [--offset:14] [--placement:top]">
              <button type="button" class="dropdown-toggle heroui button button--tertiary button--lg button--icon-only size-12 rounded-full border-0 bg-white/15 text-white shadow-none hover:bg-white/25 dropdown-open:bg-white dropdown-open:text-neutral-900" id="camera-select-toggle" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Switch Camera")}" title="{__("Switch Camera")}">
                <span class="icon-[tabler--camera-rotate] size-6" aria-hidden="true"></span>
              </button>
              <ul class="dropdown-menu dropdown-open:opacity-100 hidden max-w-80 min-w-60" id="camera-select-menu" role="menu" aria-orientation="vertical" aria-labelledby="camera-select-toggle"></ul>
            </div>
            <!-- camera selection -->
            <!-- mute/unmute mic -->
            <button type="button" class="group/btn heroui button button--tertiary button--lg button--icon-only size-12 rounded-full border-0 bg-white/15 text-white shadow-none hover:bg-white/25 disabled:bg-white/10 disabled:text-white/40 aria-pressed:bg-white aria-pressed:text-neutral-900 aria-pressed:hover:bg-white/90" id="mic-btn" aria-pressed="false" aria-label="{__("Microphone")}" title="{__("Microphone")}" disabled>
              <span class="icon-[tabler--microphone] size-6 group-aria-pressed/btn:hidden" aria-hidden="true"></span>
              <span class="icon-[tabler--microphone-off] hidden size-6 group-aria-pressed/btn:block" aria-hidden="true"></span>
            </button>
            <!-- mute/unmute mic -->
            <!-- mute/unmute cam -->
            <button type="button" class="group/btn heroui button button--tertiary button--lg button--icon-only size-12 rounded-full border-0 bg-white/15 text-white shadow-none hover:bg-white/25 disabled:bg-white/10 disabled:text-white/40 aria-pressed:bg-white aria-pressed:text-neutral-900 aria-pressed:hover:bg-white/90" id="cam-btn" aria-pressed="false" aria-label="{__("Camera")}" title="{__("Camera")}" disabled>
              <span class="icon-[tabler--video] size-6 group-aria-pressed/btn:hidden" aria-hidden="true"></span>
              <span class="icon-[tabler--video-off] hidden size-6 group-aria-pressed/btn:block" aria-hidden="true"></span>
            </button>
            <!-- mute/unmute cam -->
            <!-- share/unshare screen -->
            <button type="button" class="group/btn heroui button button--tertiary button--lg button--icon-only size-12 rounded-full border-0 bg-white/15 text-white shadow-none hover:bg-white/25 disabled:bg-white/10 disabled:text-white/40 aria-pressed:bg-primary aria-pressed:text-primary-content aria-pressed:hover:bg-primary/90 max-md:hidden" id="screen-btn" aria-pressed="false" aria-label="{__("Share Screen")}" title="{__("Share Screen")}" disabled>
              <span class="icon-[tabler--screen-share] size-6 group-aria-pressed/btn:hidden" aria-hidden="true"></span>
              <span class="icon-[tabler--screen-share-off] hidden size-6 group-aria-pressed/btn:block" aria-hidden="true"></span>
            </button>
            <!-- share/unshare screen -->
            <!-- mute/unmute comments -->
            <button type="button" class="group/btn heroui button button--tertiary button--lg button--icon-only size-12 rounded-full border-0 bg-white/15 text-white shadow-none hover:bg-white/25 disabled:bg-white/10 disabled:text-white/40 aria-pressed:bg-white aria-pressed:text-neutral-900 aria-pressed:hover:bg-white/90" id="comments-btn" aria-pressed="false" aria-label="{__("Comments")}" title="{__("Comments")}" disabled>
              <span class="icon-[tabler--message-circle] size-6 group-aria-pressed/btn:hidden" aria-hidden="true"></span>
              <span class="icon-[tabler--message-circle-off] hidden size-6 group-aria-pressed/btn:block" aria-hidden="true"></span>
            </button>
            <!-- mute/unmute comments -->
            <!-- end live -->
            <button type="button" class="heroui button button--danger button--lg button--icon-only size-12 rounded-full hidden border-0 shadow-none" id="js_live-end" aria-label="{__("End")}" title="{__("End")}">
              <span class="icon-[tabler--power] size-6" aria-hidden="true"></span>
            </button>
            <!-- end live -->
          </div>
        </div>
        <!-- live stream buttons -->

      </div>
    </section>
    <!-- live stream -->

    <!-- live sidebar -->
    <div class="flex flex-col gap-6 group-data-[comments=off]/live:hidden">

      <!-- live settings -->
      <section class="card border border-base-300 bg-base-100 shadow-none" id="js_live-settings">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--broadcast]" _title=__("Go Live") _text=__("Set up your stream")}
        <div class="card-body gap-5 pt-6">
          <fieldset class="flex min-w-0 flex-col gap-5" id="js_live-setup">
            <!-- title -->
            <div class="flex flex-col gap-1.5">
              <label class="label-text" for="js_live-title">{__("Title")}</label>
              <input type="text" class="input w-full" id="js_live-title" maxlength="100" placeholder='{__("What is your live about?")}' autocomplete="off">
            </div>
            <!-- title -->
            <!-- description -->
            <div class="flex flex-col gap-1.5">
              <label class="label-text" for="js_live-description">{__("Description")}</label>
              <textarea class="textarea w-full" id="js_live-description" rows="3" maxlength="500" placeholder='{__("Tell viewers more about your live (optional)")}'></textarea>
              <span class="self-end text-xs text-base-content/50 tabular-nums" dir="ltr"><span id="js_live-description-counter">0</span> / 500</span>
            </div>
            <!-- description -->
            <!-- broadcast type -->
            {if $can_rtmp}
              <div class="flex flex-col gap-1.5" role="radiogroup" aria-labelledby="js_live-type-label">
                <span class="label-text" id="js_live-type-label">{__("Broadcast Type")}</span>
                <div class="grid grid-cols-2 gap-2">
                  <label class="flex cursor-pointer flex-col gap-1 rounded-box border border-base-300 p-3 transition-colors hover:bg-base-200 has-checked:border-primary has-checked:bg-primary/10">
                    <input type="radio" class="js_live-type sr-only" name="broadcast_type" value="camera" checked>
                    <span class="icon-[tabler--device-mobile] size-5" aria-hidden="true"></span>
                    <span class="text-sm font-semibold">{__("Camera")}</span>
                    <span class="text-xs text-base-content/60">{__("Go live directly from this device")}</span>
                  </label>
                  <label class="flex cursor-pointer flex-col gap-1 rounded-box border border-base-300 p-3 transition-colors hover:bg-base-200 has-checked:border-primary has-checked:bg-primary/10">
                    <input type="radio" class="js_live-type sr-only" name="broadcast_type" value="rtmp">
                    <span class="icon-[tabler--device-desktop-up] size-5" aria-hidden="true"></span>
                    <span class="text-sm font-semibold">{__("OBS / RTMP")}</span>
                    <span class="text-xs text-base-content/60">{__("Use OBS or any streaming software")}</span>
                  </label>
                </div>
              </div>
              <!-- streaming software -->
              <div class="hidden flex-col gap-3 rounded-box border border-base-300 bg-base-200/50 p-3" id="js_live-rtmp">
                <div class="flex flex-col gap-1.5">
                  <label class="label-text" for="js_live-rtmp-url">{__("Server URL")}</label>
                  {include file='__copy_input.tpl' _id="js_live-rtmp-url" _icon="icon-[tabler--server]" _class="font-mono text-xs"}
                </div>
                <div class="flex flex-col gap-1.5">
                  <label class="label-text" for="js_live-rtmp-key">{__("Stream Key")}</label>
                  {include file='__copy_input.tpl' _id="js_live-rtmp-key" _icon="icon-[tabler--key]" _class="font-mono text-xs [-webkit-text-security:disc]"}
                  <span class="text-xs text-base-content/60">{__("Keep your stream key private, anyone with it can stream to your account")}</span>
                </div>
                <div class="flex items-center justify-between gap-2">
                  <span class="flex min-w-0 items-center gap-2 text-xs font-medium text-base-content/70" id="js_live-rtmp-status" role="status">
                    <span class="loading loading-spinner loading-xs shrink-0"></span>
                    {__("Waiting for your streaming software")}
                  </span>
                  <button type="button" class="heroui button button--ghost button--sm h-6 px-2 text-xs shrink-0" id="js_live-rtmp-reset">
                    <span class="icon-[tabler--refresh] size-4" aria-hidden="true"></span>
                    {__("Reset Key")}
                  </button>
                </div>
              </div>
              <!-- streaming software -->
            {/if}
            <!-- broadcast type -->
            <!-- category -->
            {if $live_categories}
              <div class="flex flex-col gap-1.5" role="radiogroup" aria-labelledby="js_live-category-label">
                <span class="label-text" id="js_live-category-label">{__("Category")}</span>
                <div class="flex flex-wrap gap-2">
                  {foreach $live_categories as $category}
                    <label class="cursor-pointer rounded-full border border-base-300 px-3 py-1 text-sm text-base-content/70 transition-colors hover:bg-base-200 has-checked:border-primary has-checked:bg-primary has-checked:text-primary-content">
                      <input type="radio" class="sr-only" name="live_category" value="{$category['category_id']}" {if $category@first}checked{/if}>
                      {__($category['category_name'])}
                    </label>
                  {/foreach}
                </div>
              </div>
            {/if}
            <!-- category -->
            <!-- audience -->
            {if !$page_id && !$group_id && !$event_id}
              <div class="flex flex-col gap-1.5" role="radiogroup" aria-labelledby="js_live-privacy-label">
                <span class="label-text" id="js_live-privacy-label">{__("Audience")}</span>
                <div class="grid grid-cols-2 gap-2">
                  <label class="flex cursor-pointer items-center gap-2 rounded-box border border-base-300 p-3 text-sm font-semibold transition-colors hover:bg-base-200 has-checked:border-primary has-checked:bg-primary/10">
                    <input type="radio" class="sr-only" name="live_privacy" value="public" checked>
                    <span class="icon-[tabler--world] size-5 shrink-0" aria-hidden="true"></span>
                    {__("Public")}
                  </label>
                  <label class="flex cursor-pointer items-center gap-2 rounded-box border border-base-300 p-3 text-sm font-semibold transition-colors hover:bg-base-200 has-checked:border-primary has-checked:bg-primary/10">
                    <input type="radio" class="sr-only" name="live_privacy" value="friends">
                    <span class="icon-[tabler--users] size-5 shrink-0" aria-hidden="true"></span>
                    {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
                  </label>
                </div>
              </div>
            {/if}
            <!-- audience -->
          </fieldset>
          {if (!$page_id && $user->_data['can_receive_tip']) || $can_be_for_subscriptions || $can_be_paid}
            <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300" id="js_live-options">
              {if !$page_id && $user->_data['can_receive_tip']}
                <label class="flex cursor-pointer items-center gap-3 p-3.5" for="tips_enabled">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200" aria-hidden="true">
                    <span class="icon-[tabler--coin] size-5"></span>
                  </span>
                  <span class="min-w-0 grow">
                    <span class="block text-sm font-medium">{__("Enable Tips")}</span>
                    <span class="block text-xs text-base-content/60">{__("Let viewers send you tips while you are live")}</span>
                  </span>
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="tips_enabled" id="tips_enabled">
                </label>
              {/if}
              {if $can_be_for_subscriptions}
                <label class="flex cursor-pointer items-center gap-3 p-3.5 has-disabled:cursor-not-allowed has-disabled:opacity-50" for="for_subscriptions">
                  <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200" aria-hidden="true">
                    <span class="icon-[tabler--crown] size-5"></span>
                  </span>
                  <span class="min-w-0 grow">
                    <span class="block text-sm font-medium">{__("Subscribers Only")}</span>
                    <span class="block text-xs text-base-content/60">{__("Only your subscribers can watch")}</span>
                  </span>
                  <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="for_subscriptions" id="for_subscriptions">
                </label>
              {/if}
              {if $can_be_paid}
                <div>
                  <label class="flex cursor-pointer items-center gap-3 p-3.5 has-disabled:cursor-not-allowed has-disabled:opacity-50" for="is_paid">
                    <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200" aria-hidden="true">
                      <span class="icon-[tabler--cash] size-5"></span>
                    </span>
                    <span class="min-w-0 grow">
                      <span class="block text-sm font-medium">{__("Paid Live")}</span>
                      <span class="block text-xs text-base-content/60">{__("Viewers pay once to watch")}</span>
                    </span>
                    <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="is_paid" id="is_paid">
                  </label>
                  <div class="hidden px-3.5 pb-3.5" id="js_live-paid-price">
                    <label class="label-text mb-1.5 block" for="js_live-paid-price-input">{__("Price")}</label>
                    <div class="input w-full [--border:1px]">
                      {if $system['system_currency_dir'] != "right"}
                        <span class="my-auto me-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
                      {/if}
                      <input type="text" class="grow" name="post-price" id="js_live-paid-price-input" placeholder="0.00" inputmode="decimal">
                      {if $system['system_currency_dir'] == "right"}
                        <span class="my-auto ms-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
                      {/if}
                    </div>
                  </div>
                </div>
              {/if}
            </div>
          {/if}
          <button type="button" class="heroui button button--danger button--lg button--full-width" id="js_live-start" {if $page_id}data-node-id="{$page_id}" data-node="page"{/if}{if $group_id}data-node-id="{$group_id}" data-node="group"{/if}{if $event_id}data-node-id="{$event_id}" data-node="event"{/if} disabled>
            <span class="icon-[tabler--broadcast] size-5" aria-hidden="true"></span>{__("Go Live")}
          </button>
          <p class="-mt-1 flex items-start justify-center gap-1.5 text-center text-xs text-base-content/60">
            <span class="icon-[tabler--info-circle] mt-px size-4 shrink-0" aria-hidden="true"></span>
            {__("Your live stream will be shared as a post")}
          </p>
        </div>
      </section>
      <!-- live settings -->

      <!-- live comments -->
      <section class="post-comments card hidden overflow-hidden border border-base-300 bg-base-100 shadow-none" id="live-comments">
        <div class="card-header flex items-center gap-2 border-b border-base-300">
          <span class="icon-[tabler--messages] size-5 text-base-content/60" aria-hidden="true"></span>
          <h2 class="card-title flex-1 text-base">{__("Comments")}</h2>
          {if $system['live_moderation_enabled']}
            <button type="button" class="js_modal heroui button button--ghost button--sm" data-url="live/moderate.php?do=settings&host_type={if $page_id}page{else}user{/if}&host_id={if $page_id}{$page_id}{else}{$user->_data['user_id']}{/if}">
              <span class="icon-[tabler--shield] size-4" aria-hidden="true"></span>
              {__("Moderation")}
            </button>
          {/if}
        </div>
        <ul class="js_scroller js_comments js_live-comments peer flex flex-col gap-1 p-4 empty:hidden" data-slimScroll-height="24rem"></ul>
        <div class="hidden flex-col items-center justify-center gap-2 px-6 py-12 text-center text-sm text-base-content/60 peer-empty:flex">
          <span class="icon-[tabler--message-circle] size-8" aria-hidden="true"></span>
          {__("No comments yet")}
        </div>
        <div class="border-t border-base-300 p-3">
          {if $user->_data['can_comment']}
            <div class="comment js_comment-form flex items-end gap-2.5" data-handle="post" data-id="">
              <div class="comment-avatar shrink-0">
                <span class="comment-avatar-picture block size-10 rounded-full bg-cover bg-center" style="background-image:url({$user->_data['user_picture']});" aria-hidden="true"></span>
              </div>
              <div class="comment-data min-w-0 flex-1">
                {include file='__composer.tpl' _context="comment" _size="lg" _class="comment-form"}
              </div>
            </div>
          {else}
            {include file='__feeds_comment.permission.tpl'}
          {/if}
        </div>
      </section>
      <!-- live comments -->

    </div>
    <!-- live sidebar -->

  </div>

</div>
<!-- page content -->

{else}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {if $view == "category"}
    {include file='__page_header.tpl' _title=__($current_category['category_name']) _text=__($current_category['category_description']) _image="live.svg"}
  {elseif $view == "following"}
    {include file='__page_header.tpl' _title=__("Live") _text=__("Live streams from people you follow") _image="live.svg"}
  {elseif $view == "manage"}
    {include file='__page_header.tpl' _title=__("My Lives") _text=__($system['system_description_live']) _image="live.svg"}
  {else}
    {include file='__page_header.tpl' _title=__("Live") _text=__($system['system_description_live']) _image="live.svg"}
  {/if}
  <!-- page heading -->

  <!-- tabs -->
  <div class="mt-6 flex flex-col gap-4 sm:flex-row sm:flex-wrap sm:items-end sm:justify-between sm:gap-3 sm:border-b sm:border-base-300">
    <nav class="tabs tabs-bordered gap-2 border-b border-base-300 sm:gap-6 sm:border-b-0" aria-label='{__("Live")}'>
      <a class="tab -mb-px h-11 min-w-0 flex-1 justify-center gap-1.5 px-0 text-sm font-medium sm:flex-none sm:shrink-0 sm:justify-start{if $view != "following" && $view != "manage"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/live" {if $view != "following" && $view != "manage"}aria-current="page"{/if}>
        <span class="icon-[tabler--compass] size-4 shrink-0" aria-hidden="true"></span>
        <span class="truncate" title="{__("Discover")}">{__("Discover")}</span>
      </a>
      {if $user->_logged_in}
        <a class="tab -mb-px h-11 min-w-0 flex-1 justify-center gap-1.5 px-0 text-sm font-medium sm:flex-none sm:shrink-0 sm:justify-start{if $view == "following"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/live/following" {if $view == "following"}aria-current="page"{/if}>
          <span class="icon-[tabler--user-check] size-4 shrink-0" aria-hidden="true"></span>
          {if $system['friends_enabled']}
            <span class="truncate sm:hidden" title="{__("Following")}">{__("Following")}</span>
            <span class="hidden truncate sm:inline" title="{__("Friends & Following")}">{__("Friends & Following")}</span>
          {else}
            <span class="truncate" title="{__("Following")}">{__("Following")}</span>
          {/if}
        </a>
        <a class="tab -mb-px h-11 min-w-0 flex-1 justify-center gap-1.5 px-0 text-sm font-medium sm:flex-none sm:shrink-0 sm:justify-start{if $view == "manage"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/live/manage" {if $view == "manage"}aria-current="page"{/if}>
          <span class="icon-[tabler--broadcast] size-4 shrink-0" aria-hidden="true"></span>
          <span class="truncate" title="{__("My Lives")}">{__("My Lives")}</span>
        </a>
      {/if}
    </nav>
    {if ($view == "manage" && $system['live_moderation_enabled']) || ($user->_logged_in && $user->_data['can_go_live'])}
      <div class="flex items-center gap-2 sm:mb-2">
        {if $view == "manage" && $system['live_moderation_enabled']}
          <button type="button" class="js_modal heroui button button--tertiary text-base-content button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="live/moderate.php?do=settings&host_type=user&host_id={$user->_data['user_id']}">
            <span class="icon-[tabler--shield] size-4" aria-hidden="true"></span>
            {__("Moderation")}
          </button>
        {/if}
        {if $user->_logged_in && $user->_data['can_go_live']}
          <a class="heroui button button--danger button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/live/create">
            <span class="icon-[tabler--broadcast] size-4" aria-hidden="true"></span>
            {__("Go Live")}
          </a>
        {/if}
      </div>
    {/if}
  </div>
  <!-- tabs -->

  <!-- toolbar -->
  <div class="mt-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <form class="js_search-form w-full sm:max-w-sm" data-handle="live" role="search">
      <label class="input w-full">
        <span class="icon-[tabler--search] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
        <input type="search" class="grow" name="query" placeholder='{__("Search for live streams")}' aria-label='{__("Search for live streams")}' {if $view == "search"}value="{$query}"{/if}>
      </label>
    </form>
    {if $system['newsfeed_location_filter_enabled']}
      <div class="flex flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-center sm:gap-2">
        <!-- country filter -->
        <div class="dropdown relative z-30 inline-flex [&.open]:z-[34] w-full sm:w-auto [--placement:bottom-start] [--strategy:absolute] sm:[--placement:bottom-end] sm:[--strategy:fixed]">
          <button id="live-country-filter" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 hover:bg-primary/5 sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false">
            {if !$selected_country}<span class="icon-[tabler--world] size-4 shrink-0" aria-hidden="true"></span>{/if}
            <span class="min-w-0 grow truncate text-start sm:max-w-32 sm:grow-0" title="{if $selected_country}{$selected_country['country_name_with_flag']}{else}{__("All Countries")}{/if}">{if $selected_country}{$selected_country['country_name_with_flag']}{else}{__("All Countries")}{/if}</span>
            <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
          </button>
          <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 w-full min-w-56 overflow-y-auto p-1 sm:w-auto" role="menu" aria-labelledby="live-country-filter">
            <a class="dropdown-item{if !$selected_country} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?country=all">{__("All Countries")}</a>
            {foreach $countries as $country}
              <a class="dropdown-item{if $selected_country && $selected_country['country_id'] == $country['country_id']} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="?country={$country['country_name_native']}">{$country['country_name_with_flag']}</a>
            {/foreach}
          </div>
        </div>
        <!-- country filter -->
      </div>
    {/if}
  </div>
  <!-- toolbar -->

  {assign var="_live_discovery" value=($view != "following" && $view != "manage")}

  <div class="grid gap-6{if $_live_discovery} mt-3 lg:mt-6 lg:grid-cols-[15rem_minmax(0,1fr)]{else} mt-6{/if} lg:items-start">

    {if $_live_discovery}
      <!-- categories -->
      <aside class="lg:sticky lg:top-24">
        <!-- categories dropdown -->
        <div class="dropdown relative z-20 flex w-full lg:hidden [--placement:bottom-start] [--strategy:absolute]">
          <button id="live-categories-dropdown" type="button" class="dropdown-toggle heroui button button--tertiary w-full border-base-300 bg-base-100 text-base-content hover:border-primary/30 hover:bg-primary/5 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false">
            <span class="icon-[tabler--category-2] size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
            <span class="min-w-0 grow truncate text-start" title="{if $view == "category"}{__($current_category['category_name'])}{else}{__("Categories")}{/if}">{if $view == "category"}{__($current_category['category_name'])}{else}{__("Categories")}{/if}</span>
            <span class="icon-[tabler--chevron-down] size-4 shrink-0 opacity-60" aria-hidden="true"></span>
          </button>
          <div class="dropdown-menu dropdown-open:opacity-100 hidden max-h-80 w-full overflow-y-auto p-1" role="menu" aria-labelledby="live-categories-dropdown">
            {if $view != "category"}
              <a class="dropdown-item dropdown-active" role="menuitem" href="{$system['system_url']}/live" aria-current="page">{__("All")}</a>
            {elseif $current_category['parent']}
              <a class="dropdown-item text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5" role="menuitem" href="{$system['system_url']}/live/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
                <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                <span class="truncate" title="{__($current_category['parent']['category_name'])}">{__($current_category['parent']['category_name'])}</span>
              </a>
            {else}
              <a class="dropdown-item text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5" role="menuitem" href="{$system['system_url']}/live">
                {if $current_category['sub_categories']}
                  <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                {/if}
                {__("All")}
              </a>
            {/if}
            {foreach $live_categories as $category}
              <a class="dropdown-item{if $view == "category" && $current_category['category_id'] == $category['category_id']} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$system['system_url']}/live/category/{$category['category_id']}/{$category['category_url']}" {if $view == "category" && $current_category['category_id'] == $category['category_id']}aria-current="page"{/if}>
                <span class="grow truncate" title="{__($category['category_name'])}">{__($category['category_name'])}</span>
                {if $category['sub_categories']}
                  <span class="icon-[tabler--chevron-right] size-4 shrink-0 opacity-50 rtl:rotate-180" aria-hidden="true"></span>
                {/if}
              </a>
            {/foreach}
          </div>
        </div>
        <!-- categories dropdown -->

        <nav class="card hidden border border-base-300 bg-base-100 shadow-none lg:flex" aria-labelledby="live-categories-title">
          <div class="flex items-center gap-2 border-b border-base-300 px-4 py-3">
            <span class="icon-[tabler--category-2] size-4.5 text-base-content/60" aria-hidden="true"></span>
            <h2 class="text-sm font-semibold" id="live-categories-title">{__("Categories")}</h2>
          </div>
          <ul class="menu menu-sm gap-0.5 p-2">
            {if $view != "category"}
              <li><a class="{if $view == ""}menu-active{else}text-base-content!{/if}" href="{$system['system_url']}/live" {if $view == ""}aria-current="page"{/if}>{__("All")}</a></li>
            {else}
              <li>
                {if $current_category['parent']}
                  <a class="text-base-content!" href="{$system['system_url']}/live/category/{$current_category['parent']['category_id']}/{$current_category['parent']['category_url']}">
                    <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                    <span class="truncate" title="{__($current_category['parent']['category_name'])}">{__($current_category['parent']['category_name'])}</span>
                  </a>
                {else}
                  <a class="text-base-content!" href="{$system['system_url']}/live">
                    {if $current_category['sub_categories']}
                      <span class="icon-[tabler--arrow-left] size-4 shrink-0 rtl:rotate-180" aria-hidden="true"></span>
                    {/if}
                    {__("All")}
                  </a>
                {/if}
              </li>
            {/if}
            {foreach $live_categories as $category}
              <li>
                <a class="{if $view == "category" && $current_category['category_id'] == $category['category_id']}menu-active{else}text-base-content!{/if}" href="{$system['system_url']}/live/category/{$category['category_id']}/{$category['category_url']}" {if $view == "category" && $current_category['category_id'] == $category['category_id']}aria-current="page"{/if}>
                  <span class="grow truncate" title="{__($category['category_name'])}">{__($category['category_name'])}</span>
                  {if $category['sub_categories']}
                    <span class="icon-[tabler--chevron-right] size-4 shrink-0 opacity-50 rtl:rotate-180" aria-hidden="true"></span>
                  {/if}
                </a>
              </li>
            {/foreach}
          </ul>
        </nav>
      </aside>
      <!-- categories -->
    {/if}

    <!-- lives -->
    <div class="flex min-w-0 flex-col gap-8">

      {if $view == "search"}
        <section class="flex min-w-0 flex-col gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] bg-base-100 p-4 sm:flex-row sm:items-center sm:justify-between sm:px-5" aria-labelledby="live-search-title">
          <div class="flex min-w-0 items-center gap-3.5">
            <span class="flex size-11 shrink-0 items-center justify-center rounded-2xl bg-primary/10 text-primary" aria-hidden="true">
              <span class="icon-[tabler--search] size-5"></span>
            </span>
            <div class="min-w-0">
              <h2 class="text-base font-semibold" id="live-search-title">{__("Search Results")}</h2>
              <p class="mt-1 text-sm leading-relaxed break-words text-base-content/60">
                {__("Search for")} <span class="font-medium text-base-content">&ldquo;{$query}&rdquo;</span>
              </p>
            </div>
          </div>
        </section>
      {/if}

      <!-- live now -->
      <section class="flex flex-col gap-4" aria-labelledby="live-now-title">
        <h2 id="live-now-title" class="flex items-center gap-2 text-lg font-semibold">
          <span class="size-2 animate-pulse rounded-full bg-error" aria-hidden="true"></span>
          {__("Live Now")}
        </h2>
        {if $lives_now}
          <div>
            <ul class="grid grid-cols-1 gap-x-4 gap-y-6 sm:grid-cols-2 {if $_live_discovery}xl:grid-cols-3{else}lg:grid-cols-3 xl:grid-cols-4{/if}">
              {foreach $lives_now as $post}
                {include file='__live_card.tpl'}
              {/foreach}
            </ul>
            {if count($lives_now) >= $system['live_results']}
              <div class="see-more js_see-more mt-6 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="live_now" data-filter="{if $view == "following" || $view == "manage"}{$view}{else}discover{/if}" {if $view == "category"}data-category="{$current_category['category_id']}"{/if} {if $selected_country}data-country="{$selected_country['country_id']}"{/if} {if $view == "search"}data-query="{$query}"{/if}>
                <span>{__("See More")}</span>
                <div class="loading loading-spinner loading-sm hidden"></div>
              </div>
            {/if}
          </div>
        {else}
          <div class="card border border-base-300 bg-base-100 shadow-none">
            {include file='_no_data.tpl' _empty_icon="icon-[tabler--broadcast]" _empty_title=__("No one is live right now") _empty_text=__("Please check back a little later")}
          </div>
        {/if}
      </section>
      <!-- live now -->

      <!-- ended -->
      {if $lives_ended}
        <section class="flex flex-col gap-4" aria-labelledby="live-ended-title">
          <div>
            <h2 id="live-ended-title" class="text-lg font-semibold">{__("Ended")}</h2>
            <p class="text-sm text-base-content/60">{__("Streams that have ended")}</p>
          </div>
          <div>
            <ul class="grid grid-cols-1 gap-x-4 gap-y-6 sm:grid-cols-2 {if $_live_discovery}xl:grid-cols-3{else}lg:grid-cols-3 xl:grid-cols-4{/if}">
              {foreach $lives_ended as $post}
                {include file='__live_card.tpl'}
              {/foreach}
            </ul>
            {if count($lives_ended) >= $system['live_results']}
              <div class="see-more js_see-more mt-6 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="live_ended" data-filter="{if $view == "following" || $view == "manage"}{$view}{else}discover{/if}" {if $view == "category"}data-category="{$current_category['category_id']}"{/if} {if $selected_country}data-country="{$selected_country['country_id']}"{/if} {if $view == "search"}data-query="{$query}"{/if}>
                <span>{__("See More")}</span>
                <div class="loading loading-spinner loading-sm hidden"></div>
              </div>
            {/if}
          </div>
        </section>
      {/if}
      <!-- ended -->

    </div>
    <!-- lives -->

  </div>

</div>
<!-- page content -->

{/if}

{include file='_footer.tpl'}
