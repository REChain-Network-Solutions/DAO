{include file='__modal_header.tpl' _icon="icon-[tabler--shield]" _title=__("Moderation")}
<div class="modal__body flex flex-col gap-4">
  {include file='__live_moderation_tabs.tpl' _tab="restrictions"}
  {if $restrictions}
    <ul class="flex flex-col divide-y divide-base-300">
      {foreach $restrictions as $restriction}
        <li class="py-2.5" id="live-restriction-{$restriction['user_id']}">
          <form class="js_ajax-forms flex items-center gap-3" data-url="live/moderate.php?do=unrestrict&host_type={$host_type}&host_id={$host_id}&user_id={$restriction['user_id']}">
            <a class="block size-10 shrink-0 rounded-full bg-cover bg-center" href="{$system['system_url']}/{$restriction['user_name']}" style="background-image:url({$restriction['user_picture']});" aria-label="{$restriction['user_fullname']}"></a>
            <div class="min-w-0 flex-1">
              <a class="block truncate text-sm font-semibold text-base-content!" href="{$system['system_url']}/{$restriction['user_name']}" title="{$restriction['user_fullname']}">{$restriction['user_fullname']}</a>
              <div class="text-xs text-base-content/60">
                {if $restriction['type'] == "timeout"}
                  {__("Timed out")}
                {elseif $restriction['type'] == "mute"}
                  {__("Muted")}
                {elseif $restriction['type'] == "kick"}
                  {__("Kicked")}
                {else}
                  {__("Banned")}
                {/if}
                &middot; <span class="js_moment" data-time="{$restriction['time']}">{$restriction['time']}</span>
              </div>
            </div>
            <button type="submit" class="button button--tertiary text-base-content button--sm shrink-0 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Remove")}</button>
          </form>
        </li>
      {/foreach}
    </ul>
  {else}
    <div class="flex flex-col items-center justify-center gap-2 py-8 text-center text-sm text-base-content/60">
      <span class="icon-[tabler--user-check] size-8" aria-hidden="true"></span>
      {__("No restricted users")}
    </div>
  {/if}
</div>
