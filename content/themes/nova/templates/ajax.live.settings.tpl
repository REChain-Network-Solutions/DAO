{include file='__modal_header.tpl' _icon="icon-[tabler--shield]" _title=__("Moderation")}
<form class="js_ajax-forms" data-url="live/moderate.php?do=save_settings&host_type={$host_type}&host_id={$host_id}">
  <div class="modal__body flex flex-col gap-4">
    {include file='__live_moderation_tabs.tpl' _tab="settings"}
    <!-- slow mode -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="live-slow-mode">{__("Slow Mode")}</label>
      <select class="select w-full [--border:1px]" name="slow_mode" id="live-slow-mode">
        <option value="0" {if $settings['slow_mode'] == 0}selected{/if}>{__("Off")}</option>
        {foreach [5, 10, 30, 60, 120] as $seconds}
          <option value="{$seconds}" {if $settings['slow_mode'] == $seconds}selected{/if}>{$seconds} {__("Seconds")}</option>
        {/foreach}
      </select>
      <div class="mt-1.5 text-sm text-base-content/60">{__("How long each viewer has to wait between comments")}</div>
    </div>
    <!-- slow mode -->
    <!-- blocked words -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="live-blocked-words">{__("Blocked Words")}</label>
      <textarea name="blocked_words" id="live-blocked-words" rows="2" dir="auto" class="textarea w-full [--border:1px]">{$settings['blocked_words']}</textarea>
      <div class="mt-1.5 text-sm text-base-content/60">{__("Separate words with commas, comments that contain any of them will not be posted")}</div>
    </div>
    <!-- blocked words -->
    <!-- block links -->
    <div class="flex items-center justify-between gap-4">
      <label class="label-text" for="live-links-blocked">{__("Block Links")}</label>
      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px] [--border:1px]" name="links_blocked" id="live-links-blocked" {if $settings['links_blocked']}checked{/if}>
    </div>
    <!-- block links -->
    <!-- block repeated comments -->
    <div class="flex items-center justify-between gap-4">
      <label class="label-text" for="live-repeats-blocked">{__("Block Repeated Comments")}</label>
      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px] [--border:1px]" name="repeats_blocked" id="live-repeats-blocked" {if $settings['repeats_blocked']}checked{/if}>
    </div>
    <!-- block repeated comments -->
    <!-- chat rules -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="live-rules">{__("Chat Rules")}</label>
      <textarea name="rules" id="live-rules" rows="3" dir="auto" maxlength="1000" class="textarea w-full [--border:1px]" placeholder="{$system['live_chat_rules']}">{$settings['rules']}</textarea>
      <div class="mt-1.5 text-sm text-base-content/60">{__("Shown to viewers at the top of the chat")}</div>
    </div>
    <!-- chat rules -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Save")}</button>
  </div>
</form>
