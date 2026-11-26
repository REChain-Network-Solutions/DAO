{include file='__modal_header.tpl' _icon="icon-[tabler--school]" _title=__("Create New Course")}
<form class="js_ajax-forms" data-url="posts/course.php?do=publish">
  <div class="modal__body flex flex-col gap-4">
    {if $system['paid_courses_enabled']}
      <div class="alert alert-soft alert-warning flex items-start gap-3 text-start" role="alert">
        <span class="icon-[tabler--alert-triangle] size-5 shrink-0" aria-hidden="true"></span>
        <p class="min-w-0">{__("This course post will cost you")} <span class="badge badge-soft">{$system['paid_courses_cost']} {$system['system_currency']}</span> {__("to publish. The cost will be deducted from your wallet balance")}</p>
      </div>
    {/if}

    <div class="grid gap-4 sm:grid-cols-2">
      <!-- title -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="course-publisher-title">{__("Title")}</label>
        <input name="title" type="text" class="input w-full [--border:1px]" id="course-publisher-title">
      </div>
      <!-- title -->
      <!-- location -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="course-publisher-location">{__("Location")}</label>
        <input name="location" type="text" class="input w-full [--border:1px]" id="course-publisher-location">
      </div>
      <!-- location -->
    </div>
    <!-- fees -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Course Fees")}</span>
      <div>
        <div class="join w-full">
          <input name="fees" type="text" class="input join-item w-full [--border:1px]" placeholder="{__("Course Fees")}">
          <div class="select join-item w-auto shrink-0 [--border:1px]">
            <select class="min-w-0 ps-0!" name="fees_currency">
              {foreach $currencies as $currency}
                <option value="{$currency['currency_id']}" {if $system['system_currency_id'] == $currency['currency_id']}selected{/if}>{$currency['symbol']} ({$currency['code']})</option>
              {/foreach}
            </select>
          </div>
        </div>
      </div>
    </div>
    <!-- fees -->
    <!-- start/end date -->
    <div class="grid gap-4 sm:grid-cols-2">
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="course-publisher-start-date">{__("Start Date")}</label>
        <input type="datetime-local" class="input w-full [--border:1px]" name="start_date" id="course-publisher-start-date">
      </div>
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="course-publisher-end-date">{__("End Date")}</label>
        <input type="datetime-local" class="input w-full [--border:1px]" name="end_date" id="course-publisher-end-date">
      </div>
    </div>
    <!-- start/end date -->
    <!-- category -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="course-publisher-category">{__("Category")}</label>
      <div class="select w-full min-w-0 [--border:1px]">
        <select class="min-w-0 ps-0!" name="category" id="course-publisher-category">
          {foreach $courses_categories as $category}
            {include file='__categories.recursive_options.tpl'}
          {/foreach}
        </select>
      </div>
    </div>
    <!-- category -->
    <!-- description -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="course-publisher-description">{__("Description")}</label>
      <textarea name="description" rows="5" dir="auto" class="textarea w-full px-3 [--border:1px]" id="course-publisher-description"></textarea>
      <p class="mt-1.5 text-sm text-base-content/60">{__("Describe the responsibilities and preferred skills for this course")}</p>
    </div>
    <!-- description -->
    <!-- custom fields -->
    {if $custom_fields}
      {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true _input_class="input w-full [--border:1px]" _select_class="select w-full [--border:1px]" _textarea_class="textarea w-full px-3 [--border:1px]" _label_class="label-text px-0"}
    {/if}
    <!-- custom fields -->
    <!-- cover image -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Cover Image")}</span>
      {include file='__x_image.tpl' _x_name="cover_image"}
    </div>
    <!-- cover image -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    {if $share_to == "page"}
      <input type="hidden" name="handle" value="page">
      <input type="hidden" name="id" value="{$share_to_id}">
    {elseif $share_to == "group"}
      <input type="hidden" name="handle" value="group">
      <input type="hidden" name="id" value="{$share_to_id}">
    {elseif $share_to == "event"}
      <input type="hidden" name="handle" value="event">
      <input type="hidden" name="id" value="{$share_to_id}">
    {/if}
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Publish")}</button>
  </div>
</form>
