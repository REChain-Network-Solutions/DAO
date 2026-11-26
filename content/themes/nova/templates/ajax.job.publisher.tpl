{include file='__modal_header.tpl' _icon="icon-[tabler--briefcase]" _title=__("Create New Job")}
<form class="js_ajax-forms" data-url="posts/job.php?do=publish">
  <div class="modal__body flex flex-col gap-4">
    {if $system['paid_jobs_enabled']}
      <div class="alert alert-soft alert-warning flex items-start gap-3 text-start" role="alert">
        <span class="icon-[tabler--alert-triangle] size-5 shrink-0" aria-hidden="true"></span>
        <p class="min-w-0">{__("This job post will cost you")} <span class="badge badge-soft">{$system['paid_jobs_cost']} {$system['system_currency']}</span> {__("to publish. The cost will be deducted from your wallet balance")}</p>
      </div>
    {/if}

    <div class="grid gap-4 sm:grid-cols-2">
      <!-- title -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="job-publisher-title">{__("Title")}</label>
        <input name="title" type="text" class="input w-full [--border:1px]" id="job-publisher-title">
      </div>
      <!-- title -->
      <!-- location -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="job-publisher-location">{__("Location")}</label>
        <input name="location" type="text" class="input w-full [--border:1px]" id="job-publisher-location">
      </div>
      <!-- location -->
    </div>
    <!-- salary range -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Salary Range")}</span>
      <div>
        <div class="join w-full">
          <input name="salary_minimum" type="text" class="input join-item w-full [--border:1px]" placeholder="{__("Minimum")}">
          <div class="select join-item w-auto shrink-0 ps-2 [--border:1px]">
            <select class="min-w-0 ps-0!" name="salary_minimum_currency">
              {foreach $currencies as $currency}
                <option value="{$currency['currency_id']}" {if $system['system_currency_id'] == $currency['currency_id']}selected{/if}>{$currency['symbol']} ({$currency['code']})</option>
              {/foreach}
            </select>
          </div>
        </div>
      </div>
      <div class="mt-2">
        <div class="join w-full">
          <input name="salary_maximum" type="text" class="input join-item w-full [--border:1px]" placeholder="{__("Maximum")}">
          <div class="select join-item w-auto shrink-0 ps-2 [--border:1px]">
            <select class="min-w-0 ps-0!" name="salary_maximum_currency">
              {foreach $currencies as $currency}
                <option value="{$currency['currency_id']}" {if $system['system_currency_id'] == $currency['currency_id']}selected{/if}>{$currency['symbol']} ({$currency['code']})</option>
              {/foreach}
            </select>
          </div>
        </div>
      </div>
      <div class="mt-2">
        <div class="select w-full min-w-0 [--border:1px]">
          <select class="min-w-0 ps-0!" name="pay_salary_per">
            <option value="per_hour">{__("Per Hour")}</option>
            <option value="per_day">{__("Per Day")}</option>
            <option value="per_week">{__("Per Week")}</option>
            <option value="per_month">{__("Per Month")}</option>
            <option value="per_year">{__("Per Year")}</option>
          </select>
        </div>
      </div>
    </div>
    <!-- salary range -->
    <div class="grid gap-4 sm:grid-cols-2">
      <!-- type -->
      <div class="min-w-0 w-full">
        <label class="label-text mb-1.5 block px-0" for="job-publisher-type">{__("Type")}</label>
        <div class="select w-full min-w-0 [--border:1px]">
          <select class="min-w-0 ps-0!" name="type" id="job-publisher-type">
            <option value="full_time">{__("Full Time")}</option>
            <option value="part_time">{__("Part Time")}</option>
            <option value="internship">{__("Internship")}</option>
            <option value="volunteer">{__("Volunteer")}</option>
            <option value="contract">{__("Contract")}</option>
          </select>
        </div>
      </div>
      <!-- type -->
      <!-- category -->
      <div class="min-w-0 w-full">
        <label class="label-text mb-1.5 block px-0" for="job-publisher-category">{__("Category")}</label>
        <div class="select w-full min-w-0 [--border:1px]">
          <select class="min-w-0 ps-0!" name="category" id="job-publisher-category">
            {foreach $jobs_categories as $category}
              {include file='__categories.recursive_options.tpl'}
            {/foreach}
          </select>
        </div>
      </div>
      <!-- category -->
    </div>
    <!-- description -->
    <div class="w-full">
      <label class="label-text mb-1.5 block px-0" for="job-publisher-description">{__("Description")}</label>
      <textarea name="description" rows="5" dir="auto" class="textarea w-full px-3 [--border:1px]" id="job-publisher-description"></textarea>
      <p class="mt-1.5 text-sm text-base-content/60">{__("Describe the responsibilities and preferred skills for this job")}</p>
    </div>
    <!-- description -->
    <!-- custom fields -->
    {if $custom_fields}
      {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true _input_class="input w-full [--border:1px]" _select_class="select w-full [--border:1px]" _textarea_class="textarea w-full px-3 [--border:1px]" _label_class="label-text px-0"}
    {/if}
    <!-- custom fields -->
    <!-- questions -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Questions")}</span>
      <div class="flex flex-col gap-3">
        <!-- question #1 -->
        <div class="job-question hidden space-y-2 rounded-box border border-base-300 p-4" data-id="1">
          <span class="block text-sm font-semibold">{__("Question")} #1</span>
          <div class="select w-full min-w-0 [--border:1px]">
            <select class="js_question-type min-w-0 ps-0!" name="question_1_type">
              <option value="free_text">{__("Free Text Question")}</option>
              <option value="yes_no_question">{__("Yes/No Question")}</option>
              <option value="multiple_choice">{__("Multiple Choice Question")}</option>
            </select>
          </div>
          <p class="text-sm text-base-content/60">{__("Select the type of your question")}</p>
          <input name="question_1_title" type="text" class="input w-full [--border:1px]">
          <p class="text-sm text-base-content/60">{__("Ask your question")}</p>
          <div class="hidden js_question-choices">
            <textarea name="question_1_choices" rows="3" dir="auto" class="textarea w-full px-3 [--border:1px]"></textarea>
            <p class="mt-1.5 text-sm text-base-content/60">{__("One option per line")}</p>
          </div>
        </div>
        <!-- question #1 -->
        <!-- question #2 -->
        <div class="job-question hidden space-y-2 rounded-box border border-base-300 p-4" data-id="2">
          <span class="block text-sm font-semibold">{__("Question")} #2</span>
          <div class="select w-full min-w-0 [--border:1px]">
            <select class="js_question-type min-w-0 ps-0!" name="question_2_type">
              <option value="free_text">{__("Free Text Question")}</option>
              <option value="yes_no_question">{__("Yes/No Question")}</option>
              <option value="multiple_choice">{__("Multiple Choice Question")}</option>
            </select>
          </div>
          <p class="text-sm text-base-content/60">{__("Select the type of your question")}</p>
          <input name="question_2_title" type="text" class="input w-full [--border:1px]">
          <p class="text-sm text-base-content/60">{__("Ask your question")}</p>
          <div class="hidden js_question-choices">
            <textarea name="question_2_choices" rows="3" dir="auto" class="textarea w-full px-3 [--border:1px]"></textarea>
            <p class="mt-1.5 text-sm text-base-content/60">{__("One option per line")}</p>
          </div>
        </div>
        <!-- question #2 -->
        <!-- question #3 -->
        <div class="job-question hidden space-y-2 rounded-box border border-base-300 p-4" data-id="3">
          <span class="block text-sm font-semibold">{__("Question")} #3</span>
          <div class="select w-full min-w-0 [--border:1px]">
            <select class="js_question-type min-w-0 ps-0!" name="question_3_type">
              <option value="free_text">{__("Free Text Question")}</option>
              <option value="yes_no_question">{__("Yes/No Question")}</option>
              <option value="multiple_choice">{__("Multiple Choice Question")}</option>
            </select>
          </div>
          <p class="text-sm text-base-content/60">{__("Select the type of your question")}</p>
          <input name="question_3_title" type="text" class="input w-full [--border:1px]">
          <p class="text-sm text-base-content/60">{__("Ask your question")}</p>
          <div class="hidden js_question-choices">
            <textarea name="question_3_choices" rows="3" dir="auto" class="textarea w-full px-3 [--border:1px]"></textarea>
            <p class="mt-1.5 text-sm text-base-content/60">{__("One option per line")}</p>
          </div>
        </div>
        <!-- question #3 -->
        <!-- add question -->
        <button type="button" class="heroui button button--outline button--full-width gap-1.5 border-dashed border-base-300 font-medium text-base-content/70 shadow-none hover:border-primary hover:bg-primary/5 hover:text-primary js_add-job-question"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add Question")}</button>
        <!-- add question -->
      </div>
    </div>
    <!-- questions -->
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
