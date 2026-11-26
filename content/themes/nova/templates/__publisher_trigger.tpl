{if $user->_data['can_publish_posts']}
  {if $system['verification_for_posts'] && !$user->_data['user_verified']}
    <div class="alert alert-soft alert-error flex items-start gap-3 rounded-box" role="alert">
      <span class="icon-[tabler--alert-circle] mt-0.5 size-5 shrink-0" aria-hidden="true"></span>
      <div class="min-w-0">
        <strong class="block font-semibold">{__("Account Verification Required")}</strong>
        <span class="text-sm">{__("To publish posts your account must be verified")} <a class="font-medium text-inherit! underline" href="{$system['system_url']}/settings/verification">{__("Verify Now")}</a></span>
      </div>
    </div>
  {else}
    {if $_handle && $_handle != "me"}
      {assign var="_publisher_query" value="handle=`$_handle`&id=`$_id`"}
    {else}
      {assign var="_publisher_query" value=""}
    {/if}
    <div {if $page == "index"}id="publisher-trigger"{/if} class="flex items-center gap-2 rounded-box bg-base-100 p-3 shadow-surface sm:gap-3 sm:px-4 dark:shadow-none">
      <img class="size-11 shrink-0 rounded-full object-cover" src="{$_avatar}" alt="{$_name}" title="{$_name}">
      <button type="button" class="js_modal js_publisher-trigger flex h-11 min-w-0 flex-1 cursor-text items-center rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[2rem] border border-transparent bg-base-200 px-4 text-start text-sm text-base-content/60 transition-colors hover:border-base-300" data-static="true" data-size="publisher" data-url="posts/publisher.php{if $_publisher_query || $url}?{/if}{if $_publisher_query}{$_publisher_query}{/if}{if $url}{if $_publisher_query}&{/if}url={$url|escape:'url'}{/if}">
        <span class="truncate" title="{__("What is on your mind?")}">{__("What is on your mind?")}</span>
      </button>
      <div class="flex shrink-0 items-center">
        {if $system['photos_enabled']}
          <button type="button" class="js_modal heroui button button--ghost button--icon-only rounded-full size-10 text-success hover:bg-base-200" data-static="true" data-size="publisher" data-url="posts/publisher.php?{if $_publisher_query}{$_publisher_query}&{/if}mode=photos" title='{__("Photos")}' aria-label='{__("Photos")}'>
            <span class="icon-[tabler--photo] size-6" aria-hidden="true"></span>
          </button>
        {/if}
        {if $user->_data['can_upload_videos']}
          <button type="button" class="js_modal heroui button button--ghost button--icon-only rounded-full size-10 text-error hover:bg-base-200" data-static="true" data-size="publisher" data-url="posts/publisher.php?{if $_publisher_query}{$_publisher_query}&{/if}mode=video" title='{__("Video")}' aria-label='{__("Video")}'>
            <span class="icon-[tabler--video] size-6" aria-hidden="true"></span>
          </button>
        {/if}
        {if $user->_data['can_go_live'] && in_array($_handle, ['me', 'page', 'group', 'event'])}
          <a class="heroui button button--ghost button--icon-only rounded-full size-10 text-accent hover:bg-base-200" href="{$system['system_url']}/live/create{if $_handle == "page"}?page_id={$_id}{/if}{if $_handle == "group"}?group_id={$_id}{/if}{if $_handle == "event"}?event_id={$_id}{/if}" title='{__("Go Live")}' aria-label='{__("Go Live")}'>
            <span class="icon-[tabler--broadcast] size-6" aria-hidden="true"></span>
          </a>
        {elseif $user->_data['can_add_activity_posts']}
          <button type="button" class="js_modal heroui button button--ghost button--icon-only rounded-full size-10 text-warning hover:bg-base-200" data-static="true" data-size="publisher" data-url="posts/publisher.php?{if $_publisher_query}{$_publisher_query}&{/if}mode=feelings" title='{__("Feelings/Activity")}' aria-label='{__("Feelings/Activity")}'>
            <span class="icon-[tabler--mood-smile] size-6" aria-hidden="true"></span>
          </button>
        {/if}
      </div>
    </div>
    {if $page == "index" && $daytime_msg_enabled}
      {include file='__carousel_skeleton.tpl' _type="daytime"}
    {/if}
  {/if}
{/if}
