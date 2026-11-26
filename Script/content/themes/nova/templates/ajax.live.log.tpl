{include file='__modal_header.tpl' _icon="icon-[tabler--shield]" _title=__("Moderation")}
<div class="modal__body flex flex-col gap-4">
  {include file='__live_moderation_tabs.tpl' _tab="log"}
  {if $log}
    <ul class="flex flex-col divide-y divide-base-300">
      {foreach $log as $entry}
        <li class="flex flex-col gap-0.5 py-2.5 text-sm">
          <div>
            <span class="font-semibold">{$entry['moderator_name']}</span>
            <span class="text-base-content/70">
              {if $entry['action'] == "delete_comment"}
                {__("deleted a comment by")}
              {elseif $entry['action'] == "timeout"}
                {__("timed out")}
              {elseif $entry['action'] == "mute"}
                {__("muted")}
              {elseif $entry['action'] == "kick"}
                {__("kicked")}
              {elseif $entry['action'] == "ban"}
                {__("banned")}
              {elseif $entry['action'] == "unrestrict"}
                {__("removed the restriction of")}
              {elseif $entry['action'] == "add_moderator"}
                {__("made a moderator")}
              {elseif $entry['action'] == "remove_moderator"}
                {__("removed the moderator")}
              {else}
                {__("updated the chat settings")}
              {/if}
            </span>
            {if $entry['target_name']}
              <span class="font-semibold">{$entry['target_name']}</span>
            {/if}
            {if $entry['action'] == "timeout" && $entry['details']}
              <span class="text-base-content/70">({$entry['details']} {__("Minutes")})</span>
            {/if}
          </div>
          {if $entry['action'] == "delete_comment" && $entry['details']}
            <div class="truncate text-base-content/60" title="{$entry['details']}">{$entry['details']}</div>
          {/if}
          <small class="js_moment text-xs text-base-content/45" data-time="{$entry['time']}">{$entry['time']}</small>
        </li>
      {/foreach}
    </ul>
    {if $last_log_id}
      <div class="text-center">
        <button type="button" class="js_modal button button--tertiary button--sm" data-url="live/moderate.php?do=log&host_type={$host_type}&host_id={$host_id}&last_log_id={$last_log_id}">{__("Older")}</button>
      </div>
    {/if}
  {else}
    <div class="flex flex-col items-center justify-center gap-2 py-8 text-center text-sm text-base-content/60">
      <span class="icon-[tabler--list-details] size-8" aria-hidden="true"></span>
      {__("No moderation actions yet")}
    </div>
  {/if}
</div>
