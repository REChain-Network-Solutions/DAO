{include file='__modal_header.tpl' _icon="icon-[tabler--calendar-plus]" _title=__("Create New Event")}
<form class="js_ajax-forms event-form-modal" data-url="modules/create.php?type=event&do=create">
  <div class="modal__body flex flex-col gap-4">
    <!-- name -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="event-create-title">{__("Name Your Event")}</label>
      <input type="text" class="input w-full [--border:1px]" name="title" id="event-create-title" required>
    </div>
    <!-- name -->
    <!-- start date -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="event-create-start">{__("Start Date")}</label>
      <input type="datetime-local" class="input w-full [--border:1px]" name="start_date" id="event-create-start" required>
    </div>
    <!-- start date -->
    <!-- end date -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="event-create-end">{__("End Date")}</label>
      <input type="datetime-local" class="input w-full [--border:1px]" name="end_date" id="event-create-end" required>
    </div>
    <!-- end date -->
    <!-- type -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="is_online">{__("Event Type")}</label>
      <div class="select w-full min-w-0 [--border:1px]">
        <select class="min-w-0 ps-0!" name="is_online" id="is_online">
          <option value="0">{__("In Person")}</option>
          <option value="1">{__("Online")}</option>
        </select>
      </div>
    </div>
    <!-- type -->
    {if !$page_id}
      <!-- privacy -->
      <div class="min-w-0 w-full">
        <label class="label-text mb-1.5 block px-0" for="event-create-privacy">{__("Select Privacy")}</label>
        <div class="select w-full min-w-0 [--border:1px]">
          <select class="min-w-0 ps-0!" name="privacy" id="event-create-privacy">
            <option value="public">{__("Public Event")}</option>
            <option value="closed">{__("Closed Event")}</option>
            <option value="secret">{__("Secret Event")}</option>
          </select>
        </div>
      </div>
      <!-- privacy -->
    {/if}
    <!-- location -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="location">{__("Location")}</label>
      <input type="text" class="input w-full [--border:1px] js_geocomplete" name="location" id="location">
      <input type="hidden" name="latitude" data-geo="lat">
      <input type="hidden" name="longitude" data-geo="lng">
    </div>
    <!-- location -->
    <!-- category -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="event-create-category">{__("Category")}</label>
      <div class="select w-full min-w-0 [--border:1px]">
        <select class="min-w-0 ps-0!" name="category" id="event-create-category" required>
          <option value="">{__("Select Category")}</option>
          {foreach $categories as $category}
            {include file='__categories.recursive_options.tpl'}
          {/foreach}
        </select>
      </div>
    </div>
    <!-- category -->
    <!-- country -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="event-create-country">{__("Country")}</label>
      <div class="select w-full min-w-0 [--border:1px]">
        <select class="min-w-0 ps-0!" name="country" id="event-create-country" required>
          <option value="none">{__("Select Country")}</option>
          {foreach $countries as $country}
            <option value="{$country['country_id']}" {if $country['country_id'] == $country_fallback_value}selected{/if}>{$country['country_name_with_flag']}</option>
          {/foreach}
        </select>
      </div>
    </div>
    <!-- country -->
    <!-- language -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="event-create-language">{__("Language")}</label>
      <div class="select w-full min-w-0 [--border:1px]">
        <select class="min-w-0 ps-0!" name="language" id="event-create-language" required>
          <option value="none">{__("Select Language")}</option>
          {foreach $languages as $language}
            <option value="{$language['language_id']}" {if $language['language_id'] == $language_fallback_value}selected{/if}>{$language['title']}</option>
          {/foreach}
        </select>
      </div>
    </div>
    <!-- language -->
    <!-- description -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="event-create-description">{__("About")}</label>
      <textarea class="textarea w-full px-3 [--border:1px]" name="description" id="event-create-description"></textarea>
    </div>
    <!-- description -->
    {if $page_id}
      <!-- tickets -->
      <div class="min-w-0 w-full">
        <label class="label-text mb-1.5 block px-0" for="event-create-tickets">{__("Tickets Link")}</label>
        <input type="url" class="input w-full [--border:1px]" name="tickets_link" id="event-create-tickets">
      </div>
      <div class="min-w-0 w-full">
        <label class="label-text mb-1.5 block px-0" for="event-create-prices">{__("Prices Info")}</label>
        <textarea class="textarea w-full px-3 [--border:1px]" name="prices" id="event-create-prices"></textarea>
      </div>
      <!-- tickets -->
    {/if}
    <!-- custom fields -->
    {if $custom_fields}
      {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true _input_class="input w-full [--border:1px]" _select_class="select w-full [--border:1px]" _textarea_class="textarea w-full px-3 [--border:1px]" _label_class="label-text px-0"}
    {/if}
    <!-- custom fields -->
    {if $user->_is_admin}
      <!-- sponsored -->
      <div class="flex items-center gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-base-200/60 p-4">
        <div class="min-w-0 grow">
          <div class="text-sm font-medium text-base-content" id="is_sponsored-label">{__("Sponsored Event")}</div>
          <p class="mt-0.5 text-xs text-base-content/60">{__("Enable this option to add your own host to the event")}</p>
        </div>
        <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px] [--border:1px]" aria-labelledby="is_sponsored-label" name="is_sponsored" id="is_sponsored">
      </div>
      <div id="sponsored_event" class="flex flex-col gap-4 hidden">
        <div class="min-w-0 w-full">
          <label class="label-text mb-1.5 block px-0" for="sponsor_name">{__("Sponsored By")}</label>
          <input type="text" class="input w-full [--border:1px]" name="sponsor_name" id="sponsor_name">
        </div>
        <div class="min-w-0 w-full">
          <label class="label-text mb-1.5 block px-0" for="sponsor_url">{__("Sponsored URL")}</label>
          <input type="url" class="input w-full [--border:1px]" name="sponsor_url" id="sponsor_url">
        </div>
      </div>
      <!-- sponsored -->
    {/if}
    <!-- post -->
    <div class="flex items-center gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-base-200/60 p-4">
      <div class="min-w-0 grow">
        <div class="text-sm font-medium text-base-content" id="create_post-label">{__("Create Post")}</div>
        <p class="mt-0.5 text-xs text-base-content/60">{__("Create a public post after creating this event")}</p>
      </div>
      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px] [--border:1px]" aria-labelledby="create_post-label" name="create_post" id="create_post">
    </div>
    <!-- post -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    {if $page_id}<input type="hidden" name="page_id" value="{$page_id}">{/if}
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Create")}</button>
  </div>
</form>

<script>
  $('#modal .event-form-modal #is_sponsored').on('change', function() {
    $('#modal .event-form-modal #sponsored_event').toggleClass('hidden', !$(this).prop('checked'));
  });
  $('#modal .event-form-modal #is_online').on('change', function() {
    $('#modal .event-form-modal #location').prop('disabled', $(this).val() == '1');
  });
</script>
