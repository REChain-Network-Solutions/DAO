{if $view == "moderator" && $target['is_moderator']}
  {include file='__modal_header.tpl' _icon="icon-[tabler--shield]" _title=__("Remove Moderator")}
{elseif $view == "moderator"}
  {include file='__modal_header.tpl' _icon="icon-[tabler--shield]" _title=__("Make Moderator")}
{elseif $target['restriction'] && $target['restriction']['type'] == $view}
  {include file='__modal_header.tpl' _icon="icon-[tabler--message-circle-off]" _title=__("Remove Restriction")}
{elseif $view == "timeout"}
  {include file='__modal_header.tpl' _icon="icon-[tabler--clock-pause]" _title=__("Timeout")}
{elseif $view == "mute"}
  {include file='__modal_header.tpl' _icon="icon-[tabler--message-circle-off]" _title=__("Mute")}
{elseif $view == "kick"}
  {include file='__modal_header.tpl' _icon="icon-[tabler--user-minus]" _title=__("Kick") _danger=true}
{else}
  {include file='__modal_header.tpl' _icon="icon-[tabler--ban]" _title=__("Ban") _danger=true}
{/if}
<form class="js_ajax-forms" data-url="live/moderate.php?do=submit&post_id={$post_id}&user_id={$target['user_id']}">
  <div class="modal__body flex flex-col gap-4">
    {if $view == "moderator"}
      <!-- moderator -->
      <input type="hidden" name="action" value="{if $target['is_moderator']}remove_moderator{else}add_moderator{/if}">
      <p class="text-sm text-base-content/70">
        <span class="font-semibold text-base-content">{$target['user_fullname']}</span>
        {if $target['is_moderator']}
          {__("will no longer be able to moderate your live streams")}
        {else}
          {__("will be able to delete comments and timeout, mute, kick or ban viewers in your live streams")}
        {/if}
      </p>
      <!-- moderator -->
    {elseif $target['restriction'] && $target['restriction']['type'] == $view}
      <!-- restriction -->
      <input type="hidden" name="action" value="unrestrict">
      <p class="text-sm text-base-content/70">
        <span class="font-semibold text-base-content">{$target['user_fullname']}</span>
        {if $target['restriction']['type'] == "timeout"}
          {__("is timed out and will be able to comment again")}
        {elseif $target['restriction']['type'] == "mute"}
          {__("is muted and will be able to comment again")}
        {elseif $target['restriction']['type'] == "kick"}
          {__("is kicked and will be able to join this live again")}
        {else}
          {__("is banned and will be able to join your live streams again")}
        {/if}
      </p>
      <!-- restriction -->
    {elseif $view == "timeout"}
      <!-- timeout -->
      <input type="hidden" name="action" value="timeout">
      <p class="text-sm text-base-content/70">
        <span class="font-semibold text-base-content">{$target['user_fullname']}</span>
        {__("will not be able to comment in your live streams for the selected time")}
      </p>
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="live-timeout-duration">{__("Duration")}</label>
        <select class="select w-full [--border:1px]" name="duration" id="live-timeout-duration">
          <option value="1">1 {__("Minute")}</option>
          <option value="5" selected>5 {__("Minutes")}</option>
          <option value="10">10 {__("Minutes")}</option>
          <option value="30">30 {__("Minutes")}</option>
          <option value="60">60 {__("Minutes")}</option>
        </select>
      </div>
      <!-- timeout -->
    {elseif $view == "mute"}
      <!-- mute -->
      <input type="hidden" name="action" value="mute">
      <p class="text-sm text-base-content/70">
        <span class="font-semibold text-base-content">{$target['user_fullname']}</span>
        {__("will not be able to comment until this live ends")}
      </p>
      <!-- mute -->
    {elseif $view == "kick"}
      <!-- kick -->
      <input type="hidden" name="action" value="kick">
      <p class="text-sm text-base-content/70">
        <span class="font-semibold text-base-content">{$target['user_fullname']}</span>
        {__("will be removed from this live and will not be able to join it again")}
      </p>
      <!-- kick -->
    {else}
      <!-- ban -->
      <input type="hidden" name="action" value="ban">
      <p class="text-sm text-base-content/70">
        <span class="font-semibold text-base-content">{$target['user_fullname']}</span>
        {__("will be removed and will not be able to join or comment on any of your live streams")}
      </p>
      <!-- ban -->
    {/if}
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    {if ($view == "kick" || $view == "ban") && (!$target['restriction'] || $target['restriction']['type'] != $view)}
      <button type="submit" class="button button--danger">{__("Confirm")}</button>
    {else}
      <button type="submit" class="button button--primary">{__("Confirm")}</button>
    {/if}
  </div>
</form>
