<!-- event settings -->
<div class="flex flex-col gap-6 lg:flex-row lg:items-start">
  <aside class="w-full shrink-0 lg:w-64">
    <nav class="card rounded-3xl border border-base-300 bg-base-100 p-3 shadow-none" aria-label='{__("Event Settings")}'>
      <ul class="menu w-full gap-1 p-0 text-sm font-medium [--radius-field:1rem]">
        <li class="menu-title px-4 pt-1 pb-2 text-[11px]! font-medium! uppercase tracking-wider text-base-content/40!"><span>{__("Event Settings")}</span></li>
        {include file='__settings_nav_item.tpl' _icon="icon-[tabler--settings]" _active=($sub_view == '') _url="{$system['system_url']}/events/{$event['event_id']}/settings" _title=__("Event Settings")}
        {include file='__settings_nav_item.tpl' _danger=true _icon="icon-[tabler--trash]" _active=($sub_view == 'delete') _url="{$system['system_url']}/events/{$event['event_id']}/settings/delete" _title=__("Delete Event")}
      </ul>
    </nav>
  </aside>
  <div class="min-w-0 flex-1 space-y-6">
    {if $sub_view == ''}
      <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
        <form class="js_ajax-forms" data-url="modules/create.php?type=event&do=edit&id={$event['event_id']}">
          {include file='__settings_card_header.tpl' _icon="icon-[tabler--settings]" _title=__("Event Settings") _text=__("Keep your event details up to date")}
          <div class="card-body gap-6 pt-6">
            {if $user->_is_admin}
              <!-- host -->
              <section class="flex flex-col gap-4">
                <h3 class="flex items-center gap-2 text-sm font-semibold">
                  <span class="icon-[tabler--speakerphone] size-5 text-base-content/60" aria-hidden="true"></span>
                  {__("Host")}
                </h3>
                <div class="flex flex-col gap-4 rounded-xl border border-base-300 p-4">
                  <div class="flex items-center gap-4">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                      {include file='__svg_icons.tpl' icon="ads" class="main-icon" width="24px" height="24px"}
                    </span>
                    <div class="min-w-0 grow">
                      <div class="text-sm font-medium" id="is_sponsored-label">{__("Sponsored Event")}</div>
                      <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Enable this option to add your own host to the event")}</p>
                    </div>
                    <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="is_sponsored-label" type="checkbox" name="is_sponsored" id="is_sponsored" {if $event['event_is_sponsored']}checked{/if}>
                  </div>
                  <div id="sponsored_event" class="{if !$event['event_is_sponsored']}hidden{/if}">
                    <div class="grid gap-6 sm:grid-cols-2 sm:ps-14">
                      <div class="w-full">
                        <label class="label-text mb-1.5 block" for="sponsor_name">{__("Sponsored By")}</label>
                        <input type="text" class="input w-full" id="sponsor_name" name="sponsor_name" value="{$event['event_sponsor_name']}">
                      </div>
                      <div class="w-full">
                        <label class="label-text mb-1.5 block" for="sponsor_url">{__("Sponsored URL")}</label>
                        <input type="url" class="input w-full" id="sponsor_url" name="sponsor_url" value="{$event['event_sponsor_url']}" placeholder="https://" dir="ltr">
                      </div>
                    </div>
                  </div>
                </div>
              </section>
              <!-- host -->
            {/if}

            <!-- details -->
            <section class="flex flex-col gap-4 {if $user->_is_admin}border-t border-base-300 pt-6{/if}">
              <h3 class="flex items-center gap-2 text-sm font-semibold">
                <span class="icon-[tabler--calendar-event] size-5 text-base-content/60" aria-hidden="true"></span>
                {__("Event details")}
              </h3>
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="event-title">{__("Name Your Event")}</label>
                <input type="text" class="input w-full" id="event-title" name="title" value="{$event['event_title']}">
              </div>
              <div class="grid gap-6 sm:grid-cols-2">
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="event-edit-start">{__("Start Date")}</label>
                  <input type="datetime-local" class="input w-full" id="event-edit-start" name="start_date" value="{$event['event_start_date']}" required>
                </div>
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="event-edit-end">{__("End Date")}</label>
                  <input type="datetime-local" class="input w-full" id="event-edit-end" name="end_date" value="{$event['event_end_date']}" required>
                </div>
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="is_online">{__("Event Type")}</label>
                  <select class="select w-full" id="is_online" name="is_online">
                    <option value="0" {if $event['event_is_online'] == 0}selected{/if}>{__("In Person")}</option>
                    <option value="1" {if $event['event_is_online'] == 1}selected{/if}>{__("Online")}</option>
                  </select>
                </div>
                {if !$event['event_page']}
                  <div class="w-full">
                    <label class="label-text mb-1.5 block" for="privacy">{__("Select Privacy")}</label>
                    <select class="select w-full" id="privacy" name="privacy">
                      <option value="public" {if $event['event_privacy'] == 'public'}selected{/if}>{__("Public Event")}</option>
                      <option value="closed" {if $event['event_privacy'] == 'closed'}selected{/if}>{__("Closed Event")}</option>
                      <option value="secret" {if $event['event_privacy'] == 'secret'}selected{/if}>{__("Secret Event")}</option>
                    </select>
                  </div>
                {/if}
              </div>
            </section>
            <!-- details -->

            <!-- place -->
            <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
              <h3 class="flex items-center gap-2 text-sm font-semibold">
                <span class="icon-[tabler--map-pin] size-5 text-base-content/60" aria-hidden="true"></span>
                {__("Place and context")}
              </h3>
              <div class="grid gap-6 sm:grid-cols-2">
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="category">{__("Category")}</label>
                  <select class="select w-full" id="category" name="category">
                    {foreach $categories as $category}
                      {include file='__categories.recursive_options.tpl' data_category=$event['event_category']}
                    {/foreach}
                  </select>
                </div>
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="location">{__("Location")}</label>
                  <input type="text" class="input w-full js_geocomplete" id="location" name="location" value="{$event['event_location']}" autocomplete="off" {if $event['event_is_online'] == 1}disabled{/if}>
                  <input type="hidden" name="latitude" data-geo="lat" value="{$event['event_latitude']}">
                  <input type="hidden" name="longitude" data-geo="lng" value="{$event['event_longitude']}">
                </div>
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="country">{__("Country")}</label>
                  <select class="select w-full" id="country" name="country">
                    <option value="none">{__("Select Country")}</option>
                    {foreach $countries as $country}
                      <option value="{$country['country_id']}" {if $event['event_country'] == $country['country_id']}selected{/if}>{$country['country_name_with_flag']}</option>
                    {/foreach}
                  </select>
                </div>
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="language">{__("Language")}</label>
                  <select class="select w-full" id="language" name="language">
                    <option value="none">{__("Select Language")}</option>
                    {foreach $languages as $language}
                      <option value="{$language['language_id']}" {if $event['event_language'] == $language['language_id']}selected{/if}>{$language['title']}</option>
                    {/foreach}
                  </select>
                </div>
              </div>
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="description">{__("About")}</label>
                <textarea class="textarea w-full" id="description" name="description" rows="4" dir="auto">{$event['event_description']}</textarea>
              </div>
              {if $custom_fields['basic']}
                {include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
              {/if}
            </section>
            <!-- place -->

            {if $event['event_page']}
              <!-- tickets -->
              <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
                <h3 class="flex items-center gap-2 text-sm font-semibold">
                  <span class="icon-[tabler--ticket] size-5 text-base-content/60" aria-hidden="true"></span>
                  {__("Tickets")}
                </h3>
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="tickets_link">{__("Tickets Link")}</label>
                  <div class="input w-full items-center gap-2">
                    <span class="icon-[tabler--link] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                    <input type="url" class="grow" id="tickets_link" name="tickets_link" value="{$event['event_tickets_link']}" placeholder="https://" dir="ltr">
                  </div>
                </div>
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="prices">{__("Prices Info")}</label>
                  <textarea class="textarea w-full" id="prices" name="prices" rows="3" dir="auto">{$event['event_prices']}</textarea>
                </div>
              </section>
              <!-- tickets -->
            {/if}

            <!-- publishing -->
            <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
              <h3 class="flex items-center gap-2 text-sm font-semibold">
                <span class="icon-[tabler--adjustments-horizontal] size-5 text-base-content/60" aria-hidden="true"></span>
                {__("Publishing")}
              </h3>
              <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
                {if $system['chat_enabled']}
                  <div class="flex items-center gap-4 p-4">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                      {include file='__svg_icons.tpl' icon="chat" class="main-icon" width="24px" height="24px"}
                    </span>
                    <div class="min-w-0 grow">
                      <div class="text-sm font-medium" id="chatbox_enabled-label">{__("Chat Box")}</div>
                      <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Enable chat box for this event")}</p>
                    </div>
                    <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="chatbox_enabled-label" type="checkbox" name="chatbox_enabled" id="chatbox_enabled" {if $event['chatbox_enabled']}checked{/if}>
                  </div>
                {/if}
                <div class="flex items-center gap-4 p-4">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                    {include file='__svg_icons.tpl' icon="wall_posts" class="main-icon" width="24px" height="24px"}
                  </span>
                  <div class="min-w-0 grow">
                    <div class="text-sm font-medium" id="event_publish_enabled-label">{__("Members Can Publish Posts?")}</div>
                    <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Members can publish posts or only event admin")}</p>
                  </div>
                  <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="event_publish_enabled-label" type="checkbox" name="event_publish_enabled" id="event_publish_enabled" {if $event['event_publish_enabled']}checked{/if}>
                </div>
                <div class="flex items-center gap-4 p-4">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                    {include file='__svg_icons.tpl' icon="verification" class="main-icon" width="24px" height="24px"}
                  </span>
                  <div class="min-w-0 grow">
                    <div class="text-sm font-medium" id="event_publish_approval_enabled-label">{__("Post Approval")}</div>
                    <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("All posts must be approved by the event admin")}</p>
                  </div>
                  <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="event_publish_approval_enabled-label" type="checkbox" name="event_publish_approval_enabled" id="event_publish_approval_enabled" {if $event['event_publish_approval_enabled']}checked{/if}>
                </div>
              </div>
            </section>
            <!-- publishing -->

            <!-- error -->
            <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
            <!-- error -->
          </div>
          <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
            <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
          </div>
        </form>
      </div>
    {elseif $sub_view == 'delete'}
      <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--trash]" _title=__("Delete Event")}
        <div class="card-body gap-6 pt-6">
          <!-- danger zone -->
          <div class="flex flex-col gap-4 rounded-xl border border-error/30 bg-error/5 p-4 sm:flex-row sm:items-center sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-error/10 text-error" aria-hidden="true">
              <span class="icon-[tabler--alert-triangle] size-5"></span>
            </span>
            <div class="min-w-0 grow">
              <div class="text-sm font-semibold text-error">{__("Delete Event")}</div>
              <p class="mt-0.5 text-sm text-base-content/70">{__("Once you delete your event you will no longer can access it again")}</p>
            </div>
            <button type="button" class="heroui button button--danger w-full shrink-0 sm:w-auto js_delete-event rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-id="{$event['event_id']}">
              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
              {__("Delete Event")}
            </button>
          </div>
          <!-- danger zone -->
        </div>
      </div>
    {/if}
  </div>
</div>
<!-- event settings -->
