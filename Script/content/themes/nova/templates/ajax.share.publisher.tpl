{include file='__modal_header.tpl' _icon="icon-[tabler--share]" _title=__("Share")}
<form class="js_ajax-forms group/share" data-url="posts/share.php?do=publish&post_id={$post['post_id']}">
  <div class="modal__body flex flex-col gap-4">
    <!-- share links -->
    {if $photo}
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="share-photo-link">{__("Photo link")}</label>
        {include file='__copy_input.tpl' _id="share-photo-link" _value="{$system['system_url']}/photos/{$photo['photo_id']}" _icon="icon-[tabler--photo]"}
      </div>
    {/if}
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="share-post-link">{__("Post link")}</label>
      {include file='__copy_input.tpl' _id="share-post-link" _value=$post['share_link']}
    </div>
    {if $system['social_share_enabled']}
      <div class="flex items-center justify-between gap-2">
        {include file='__social_share.tpl' _link=$post['share_link']}
      </div>
    {/if}
    {if $post['embedded_video_link']}
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="share-embed-code">{__("Embed Code")}</label>
        <div class="relative">
          <textarea readonly class="textarea w-full resize-none pe-12 font-mono text-xs leading-relaxed [--border:1px]" id="share-embed-code" rows="4" dir="ltr">{$post['embedded_video_iframe']}</textarea>
          <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-field absolute end-2 top-2 js_clipboard" data-clipboard-target="#share-embed-code" title='{__("Copy")}' aria-label='{__("Copy")}'>
            <span class="js-clipboard-default icon-[tabler--copy] size-4.5" aria-hidden="true"></span>
            <span class="js-clipboard-success icon-[tabler--check] hidden size-4.5 text-success" aria-hidden="true"></span>
          </button>
        </div>
      </div>
    {/if}
    <!-- share links -->

    <hr class="separator">

    <!-- share to options -->
    {if ($system['pages_enabled'] && $pages) || ($system['groups_enabled'] && $groups) || ($system['events_enabled'] && $events)}
      <fieldset class="min-w-0 w-full">
        <legend class="label-text mb-2 block">{__("Share to")}</legend>
        <div class="grid grid-cols-1 gap-2.5 sm:grid-cols-2">
          <label class="flex min-w-0 cursor-pointer items-start gap-3 rounded-2xl border border-base-300 bg-base-100 p-3.5 text-start transition-colors hover:border-primary/40 hover:bg-base-200/60 has-checked:border-primary has-checked:bg-primary/5 has-checked:ring-1 has-checked:ring-primary has-[:focus-visible]:outline-2 has-[:focus-visible]:outline-offset-2 has-[:focus-visible]:outline-primary" for="share-to-timeline">
            <span class="flex size-10 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary">
              <span class="icon-[tabler--news] size-5" aria-hidden="true"></span>
            </span>
            <span class="min-w-0 flex-1 self-center">
              <span class="block text-sm font-semibold text-base-content wrap-break-word">{__("Timeline")}</span>
              <span class="mt-0.5 block text-xs leading-relaxed text-base-content/60 wrap-break-word">{__("Your profile")}</span>
            </span>
            <input type="radio" name="share_to" id="share-to-timeline" value="timeline" class="radio radio-primary radio-sm mt-0.5 shrink-0 [--border:1px]" checked="checked">
          </label>
          {if $system['pages_enabled'] && $pages}
            <label class="flex min-w-0 cursor-pointer items-start gap-3 rounded-2xl border border-base-300 bg-base-100 p-3.5 text-start transition-colors hover:border-primary/40 hover:bg-base-200/60 has-checked:border-primary has-checked:bg-primary/5 has-checked:ring-1 has-checked:ring-primary has-[:focus-visible]:outline-2 has-[:focus-visible]:outline-offset-2 has-[:focus-visible]:outline-primary" for="share-to-page">
              <span class="flex size-10 shrink-0 items-center justify-center rounded-xl bg-info/10 text-info">
                <span class="icon-[tabler--flag] size-5" aria-hidden="true"></span>
              </span>
              <span class="min-w-0 flex-1 self-center">
                <span class="block text-sm font-semibold text-base-content wrap-break-word">{__("Page")}</span>
                <span class="mt-0.5 block text-xs leading-relaxed text-base-content/60 wrap-break-word">{__("A page you manage")}</span>
              </span>
              <input type="radio" name="share_to" id="share-to-page" value="page" class="radio radio-primary radio-sm mt-0.5 shrink-0 [--border:1px]">
            </label>
          {/if}
          {if $system['groups_enabled'] && $groups}
            <label class="flex min-w-0 cursor-pointer items-start gap-3 rounded-2xl border border-base-300 bg-base-100 p-3.5 text-start transition-colors hover:border-primary/40 hover:bg-base-200/60 has-checked:border-primary has-checked:bg-primary/5 has-checked:ring-1 has-checked:ring-primary has-[:focus-visible]:outline-2 has-[:focus-visible]:outline-offset-2 has-[:focus-visible]:outline-primary" for="share-to-group">
              <span class="flex size-10 shrink-0 items-center justify-center rounded-xl bg-success/10 text-success">
                <span class="icon-[tabler--users-group] size-5" aria-hidden="true"></span>
              </span>
              <span class="min-w-0 flex-1 self-center">
                <span class="block text-sm font-semibold text-base-content wrap-break-word">{__("Group")}</span>
                <span class="mt-0.5 block text-xs leading-relaxed text-base-content/60 wrap-break-word">{__("A group you joined")}</span>
              </span>
              <input type="radio" name="share_to" id="share-to-group" value="group" class="radio radio-primary radio-sm mt-0.5 shrink-0 [--border:1px]">
            </label>
          {/if}
          {if $system['events_enabled'] && $events}
            <label class="flex min-w-0 cursor-pointer items-start gap-3 rounded-2xl border border-base-300 bg-base-100 p-3.5 text-start transition-colors hover:border-primary/40 hover:bg-base-200/60 has-checked:border-primary has-checked:bg-primary/5 has-checked:ring-1 has-checked:ring-primary has-[:focus-visible]:outline-2 has-[:focus-visible]:outline-offset-2 has-[:focus-visible]:outline-primary" for="share-to-event">
              <span class="flex size-10 shrink-0 items-center justify-center rounded-xl bg-accent/10 text-accent">
                <span class="icon-[tabler--calendar-event] size-5" aria-hidden="true"></span>
              </span>
              <span class="min-w-0 flex-1 self-center">
                <span class="block text-sm font-semibold text-base-content wrap-break-word">{__("Event")}</span>
                <span class="mt-0.5 block text-xs leading-relaxed text-base-content/60 wrap-break-word">{__("An event you joined")}</span>
              </span>
              <input type="radio" name="share_to" id="share-to-event" value="event" class="radio radio-primary radio-sm mt-0.5 shrink-0 [--border:1px]">
            </label>
          {/if}
        </div>
      </fieldset>
    {else}
      <input type="hidden" name="share_to" value="timeline">
    {/if}
    <!-- share to options -->

    {if $system['pages_enabled'] && $pages}
      <div id="js_share-to-page" class="hidden group-has-[#share-to-page:checked]/share:block">
        <label class="label-text mb-1.5 block" for="share-publisher-page">{__("Select Page")}</label>
        <select class="select w-full [--border:1px]" name="page" id="share-publisher-page">
          {foreach $pages as $page}
            <option value="{$page['page_id']}">{$page['page_title']}</option>
          {/foreach}
        </select>
      </div>
    {/if}

    {if $system['groups_enabled'] && $groups}
      <div id="js_share-to-group" class="hidden group-has-[#share-to-group:checked]/share:block">
        <label class="label-text mb-1.5 block" for="share-publisher-group">{__("Select Group")}</label>
        <select class="select w-full [--border:1px]" name="group" id="share-publisher-group">
          {foreach $groups as $group}
            <option value="{$group['group_id']}">{$group['group_title']}</option>
          {/foreach}
        </select>
      </div>
    {/if}

    {if $system['events_enabled'] && $events}
      <div id="js_share-to-event" class="hidden group-has-[#share-to-event:checked]/share:block">
        <label class="label-text mb-1.5 block" for="share-publisher-event">{__("Select Event")}</label>
        <select class="select w-full [--border:1px]" name="event" id="share-publisher-event">
          {foreach $events as $event}
            <option value="{$event['event_id']}">{$event['event_title']}</option>
          {/foreach}
        </select>
      </div>
    {/if}

    <!-- message -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="share-publisher-message">{__("Message")}</label>
      <textarea name="message" rows="3" dir="auto" class="textarea w-full [--border:1px]" id="share-publisher-message"></textarea>
    </div>
    <!-- message -->

    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden" role="alert"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Share")}</button>
  </div>
</form>
