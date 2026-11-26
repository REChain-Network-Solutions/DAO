{include file='__modal_header.tpl' _icon="icon-[tabler--shield]" _title=__("Moderation")}
<div class="modal__body flex flex-col gap-4">
  {include file='__live_moderation_tabs.tpl' _tab="moderators"}
  {if $moderators}
    <ul class="flex flex-col divide-y divide-base-300">
      {foreach $moderators as $moderator}
        <li class="py-2.5" id="live-moderator-{$moderator['user_id']}">
          <form class="js_ajax-forms flex items-center gap-3" data-url="live/moderate.php?do=delete_moderator&host_type={$host_type}&host_id={$host_id}&user_id={$moderator['user_id']}">
            <a class="block size-10 shrink-0 rounded-full bg-cover bg-center" href="{$system['system_url']}/{$moderator['user_name']}" style="background-image:url({$moderator['user_picture']});" aria-label="{$moderator['user_fullname']}"></a>
            <div class="min-w-0 flex-1">
              <a class="block truncate text-sm font-semibold text-base-content!" href="{$system['system_url']}/{$moderator['user_name']}" title="{$moderator['user_fullname']}">{$moderator['user_fullname']}</a>
              <div class="text-xs text-base-content/60"><span class="js_moment" data-time="{$moderator['time']}">{$moderator['time']}</span></div>
            </div>
            <button type="submit" class="button button--tertiary text-base-content button--sm shrink-0 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Remove")}</button>
          </form>
        </li>
      {/foreach}
    </ul>
  {else}
    <div class="flex flex-col items-center justify-center gap-2 py-8 text-center text-sm text-base-content/60">
      <span class="icon-[tabler--shield] size-8" aria-hidden="true"></span>
      {__("No moderators yet, you can make a viewer a moderator from the menu on their comment")}
    </div>
  {/if}
</div>
