{include file='__modal_header.tpl' _icon="icon-[tabler--school]" _title=__("Edit Course")}
<form class="js_ajax-forms" data-url="posts/edit.php">
  <div class="modal__body flex flex-col gap-4">
    <div class="grid gap-4 sm:grid-cols-2">
      <!-- title -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="course-editor-title">{__("Title")}</label>
        <input name="title" type="text" class="input w-full [--border:1px]" value="{$post['course']['title']}" id="course-editor-title">
      </div>
      <!-- title -->
      <!-- location -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="course-editor-location">{__("Location")}</label>
        <input name="location" type="text" class="input w-full [--border:1px]" value="{$post['course']['location']}" id="course-editor-location">
      </div>
      <!-- location -->
    </div>
    <!-- fees -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Course Fees")}</span>
      <div>
        <div class="join w-full">
          <input name="fees" type="text" class="input join-item w-full [--border:1px]" placeholder="{__("Course Fees")}" value="{$post['course']['fees']}">
          <div class="select join-item w-auto shrink-0 [--border:1px]">
            <select class="min-w-0 ps-0!" name="fees_currency">
              {foreach $currencies as $currency}
                <option value="{$currency['currency_id']}" {if $post['course']['fees_currency']['currency_id'] == $currency['currency_id']}selected{/if}>{$currency['symbol']} ({$currency['code']})</option>
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
        <label class="label-text mb-1.5 block" for="course-editor-start-date">{__("Start Date")}</label>
        <input type="datetime-local" class="input w-full [--border:1px]" name="start_date" value="{$post['course']['start_date']}" id="course-editor-start-date">
      </div>
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="course-editor-end-date">{__("End Date")}</label>
        <input type="datetime-local" class="input w-full [--border:1px]" name="end_date" value="{$post['course']['end_date']}" id="course-editor-end-date">
      </div>
    </div>
    <!-- start/end date -->
    <!-- category -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="course-editor-category">{__("Category")}</label>
      <div class="select w-full min-w-0 [--border:1px]">
        <select class="min-w-0 ps-0!" name="category" id="course-editor-category">
          {foreach $courses_categories as $category}
            {include file='__categories.recursive_options.tpl' data_category=$post['course']['category_id']}
          {/foreach}
        </select>
      </div>
    </div>
    <!-- category -->
    <!-- description -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="course-editor-description">{__("Description")}</label>
      <textarea name="description" rows="5" dir="auto" class="textarea w-full px-3 [--border:1px]" id="course-editor-description">{$post['text_plain']}</textarea>
      <p class="mt-1.5 text-sm text-base-content/60">{__("Describe the responsibilities and preferred skills for this course")}</p>
    </div>
    <!-- description -->
    <!-- custom fields -->
    {if $custom_fields['basic']}
      {include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
    {/if}
    <!-- custom fields -->
    <!-- cover image -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Cover Image")}</span>
      {include file='__x_image.tpl' _x_name="cover_image" _x_value=$post['course']['cover_image']}
    </div>
    <!-- cover image -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <input type="hidden" name="handle" value="course">
    <input type="hidden" name="id" value="{$post['post_id']}">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Save")}</button>
  </div>
</form>
