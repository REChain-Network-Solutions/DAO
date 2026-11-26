{include file='__modal_header.tpl' _icon="icon-[tabler--briefcase]" _title=__("Edit Job")}
<form class="js_ajax-forms" data-url="posts/edit.php">
  <div class="modal__body flex flex-col gap-4">
    <div class="grid gap-4 sm:grid-cols-2">
      <!-- title -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="job-editor-title">{__("Job Title")}</label>
        <input name="title" type="text" class="input w-full [--border:1px]" value="{$post['job']['title']}" id="job-editor-title">
      </div>
      <!-- title -->
      <!-- location -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="job-editor-location">{__("Location")}</label>
        <input name="location" type="text" class="input w-full [--border:1px]" value="{$post['job']['location']}" id="job-editor-location">
      </div>
      <!-- location -->
    </div>
    <!-- salary range -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Salary Range")}</span>
      <div>
        <div class="join w-full">
          <input name="salary_minimum" type="text" class="input join-item w-full [--border:1px]" placeholder="{__("Minimum")}" value="{$post['job']['salary_minimum']}">
          <div class="select join-item w-auto shrink-0 ps-2 [--border:1px]">
            <select class="min-w-0 ps-0!" name="salary_minimum_currency">
              {foreach $currencies as $currency}
                <option value="{$currency['currency_id']}" {if $post['job']['salary_minimum_currency']['currency_id'] == $currency['currency_id']}selected{/if}>{$currency['symbol']} ({$currency['code']})</option>
              {/foreach}
            </select>
          </div>
        </div>
      </div>
      <div class="mt-2">
        <div class="join w-full">
          <input name="salary_maximum" type="text" class="input join-item w-full [--border:1px]" placeholder="{__("Maximum")}" value="{$post['job']['salary_maximum']}">
          <div class="select join-item w-auto shrink-0 ps-2 [--border:1px]">
            <select class="min-w-0 ps-0!" name="salary_maximum_currency">
              {foreach $currencies as $currency}
                <option value="{$currency['currency_id']}" {if $post['job']['salary_maximum_currency']['currency_id'] == $currency['currency_id']}selected{/if}>{$currency['symbol']} ({$currency['code']})</option>
              {/foreach}
            </select>
          </div>
        </div>
      </div>
      <div class="mt-2">
        <div class="select w-full min-w-0 [--border:1px]">
          <select class="min-w-0 ps-0!" name="pay_salary_per">
            <option value="per_hour" {if $post['job']['pay_salary_per'] == "per_hour"}selected{/if}>{__("Per Hour")}</option>
            <option value="per_day" {if $post['job']['pay_salary_per'] == "per_day"}selected{/if}>{__("Per Day")}</option>
            <option value="per_week" {if $post['job']['pay_salary_per'] == "per_week"}selected{/if}>{__("Per Week")}</option>
            <option value="per_month" {if $post['job']['pay_salary_per'] == "per_month"}selected{/if}>{__("Per Month")}</option>
            <option value="per_year" {if $post['job']['pay_salary_per'] == "per_year"}selected{/if}>{__("Per Year")}</option>
          </select>
        </div>
      </div>
    </div>
    <!-- salary range -->
    <div class="grid gap-4 sm:grid-cols-2">
      <!-- type -->
      <div class="min-w-0 w-full">
        <label class="label-text mb-1.5 block px-0" for="job-editor-type">{__("Job Type")}</label>
        <div class="select w-full min-w-0 [--border:1px]">
          <select class="min-w-0 ps-0!" name="type" id="job-editor-type">
            <option value="full_time" {if $post['job']['type'] == "full_time"}selected{/if}>{__("Full Time")}</option>
            <option value="part_time" {if $post['job']['type'] == "part_time"}selected{/if}>{__("Part Time")}</option>
            <option value="internship" {if $post['job']['type'] == "internship"}selected{/if}>{__("Internship")}</option>
            <option value="volunteer" {if $post['job']['type'] == "volunteer"}selected{/if}>{__("Volunteer")}</option>
            <option value="contract" {if $post['job']['type'] == "contract"}selected{/if}>{__("Contract")}</option>
          </select>
        </div>
      </div>
      <!-- type -->
      <!-- category -->
      <div class="min-w-0 w-full">
        <label class="label-text mb-1.5 block px-0" for="job-editor-category">{__("Category")}</label>
        <div class="select w-full min-w-0 [--border:1px]">
          <select class="min-w-0 ps-0!" name="category" id="job-editor-category">
            {foreach $jobs_categories as $category}
              {include file='__categories.recursive_options.tpl' data_category=$post['job']['category_id']}
            {/foreach}
          </select>
        </div>
      </div>
      <!-- category -->
    </div>
    <!-- description -->
    <div class="w-full">
      <label class="label-text mb-1.5 block px-0" for="job-editor-description">{__("Description")}</label>
      <textarea name="description" rows="5" dir="auto" class="textarea w-full px-3 [--border:1px]" id="job-editor-description">{$post['text_plain']}</textarea>
      <p class="mt-1.5 text-sm text-base-content/60">{__("Describe the responsibilities and preferred skills for this job")}</p>
    </div>
    <!-- description -->
    <!-- custom fields -->
    {if $custom_fields['basic']}
      {include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
    {/if}
    <!-- custom fields -->
    <!-- questions -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Questions")}</span>
      <div class="flex flex-col gap-3">
        <!-- question #1 -->
        <div class="job-question space-y-2 rounded-box border border-base-300 p-4 {if !$post['job']['question_1_title']}hidden{/if}" data-id="1">
          <span class="block text-sm font-semibold">{__("Question")} #1</span>
          <div class="select w-full min-w-0 [--border:1px]">
            <select class="js_question-type min-w-0 ps-0!" name="question_1_type">
              <option value="free_text" {if $post['job']['question_1_type'] == "free_text"}selected{/if}>{__("Free Text Question")}</option>
              <option value="yes_no_question" {if $post['job']['question_1_type'] == "yes_no_question"}selected{/if}>{__("Yes/No Question")}</option>
              <option value="multiple_choice" {if $post['job']['question_1_type'] == "multiple_choice"}selected{/if}>{__("Multiple Choice Question")}</option>
            </select>
          </div>
          <p class="text-sm text-base-content/60">{__("Select the type of your question")}</p>
          <input name="question_1_title" type="text" class="input w-full [--border:1px]" value="{$post['job']['question_1_title']}">
          <p class="text-sm text-base-content/60">{__("Ask your question")}</p>
          <div class="{if $post['job']['question_1_type'] !="multiple_choice"}hidden{/if} js_question-choices">
            <textarea name="question_1_choices" rows="3" dir="auto" class="textarea w-full px-3 [--border:1px]">{$post['job']['question_1_choices']}</textarea>
            <p class="mt-1.5 text-sm text-base-content/60">{__("One option per line")}</p>
          </div>
        </div>
        <!-- question #1 -->
        <!-- question #2 -->
        <div class="job-question space-y-2 rounded-box border border-base-300 p-4 {if !$post['job']['question_2_title']}hidden{/if}" data-id="2">
          <span class="block text-sm font-semibold">{__("Question")} #2</span>
          <div class="select w-full min-w-0 [--border:1px]">
            <select class="js_question-type min-w-0 ps-0!" name="question_2_type">
              <option value="free_text" {if $post['job']['question_2_type'] == "free_text"}selected{/if}>{__("Free Text Question")}</option>
              <option value="yes_no_question" {if $post['job']['question_2_type'] == "yes_no_question"}selected{/if}>{__("Yes/No Question")}</option>
              <option value="multiple_choice" {if $post['job']['question_2_type'] == "multiple_choice"}selected{/if}>{__("Multiple Choice Question")}</option>
            </select>
          </div>
          <p class="text-sm text-base-content/60">{__("Select the type of your question")}</p>
          <input name="question_2_title" type="text" class="input w-full [--border:1px]" value="{$post['job']['question_2_title']}">
          <p class="text-sm text-base-content/60">{__("Ask your question")}</p>
          <div class="{if $post['job']['question_2_type'] !="multiple_choice"}hidden{/if} js_question-choices">
            <textarea name="question_2_choices" rows="3" dir="auto" class="textarea w-full px-3 [--border:1px]">{$post['job']['question_2_choices']}</textarea>
            <p class="mt-1.5 text-sm text-base-content/60">{__("One option per line")}</p>
          </div>
        </div>
        <!-- question #2 -->
        <!-- question #3 -->
        <div class="job-question space-y-2 rounded-box border border-base-300 p-4 {if !$post['job']['question_3_title']}hidden{/if}" data-id="3">
          <span class="block text-sm font-semibold">{__("Question")} #3</span>
          <div class="select w-full min-w-0 [--border:1px]">
            <select class="js_question-type min-w-0 ps-0!" name="question_3_type">
              <option value="free_text" {if $post['job']['question_3_type'] == "free_text"}selected{/if}>{__("Free Text Question")}</option>
              <option value="yes_no_question" {if $post['job']['question_3_type'] == "yes_no_question"}selected{/if}>{__("Yes/No Question")}</option>
              <option value="multiple_choice" {if $post['job']['question_3_type'] == "multiple_choice"}selected{/if}>{__("Multiple Choice Question")}</option>
            </select>
          </div>
          <p class="text-sm text-base-content/60">{__("Select the type of your question")}</p>
          <input name="question_3_title" type="text" class="input w-full [--border:1px]" value="{$post['job']['question_3_title']}">
          <p class="text-sm text-base-content/60">{__("Ask your question")}</p>
          <div class="{if $post['job']['question_3_type'] !="multiple_choice"}hidden{/if} js_question-choices">
            <textarea name="question_3_choices" rows="3" dir="auto" class="textarea w-full px-3 [--border:1px]">{$post['job']['question_3_choices']}</textarea>
            <p class="mt-1.5 text-sm text-base-content/60">{__("One option per line")}</p>
          </div>
        </div>
        <!-- question #3 -->
        <!-- add question -->
        {if !$post['job']['question_1_title'] || !$post['job']['question_2_title'] || !$post['job']['question_3_title']}
          <button type="button" class="heroui button button--outline button--full-width gap-1.5 border-dashed border-base-300 font-medium text-base-content/70 shadow-none hover:border-primary hover:bg-primary/5 hover:text-primary js_add-job-question"><span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>{__("Add Question")}</button>
        {/if}
        <!-- add question -->
      </div>
    </div>
    <!-- questions -->
    <!-- cover image -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Cover Image")}</span>
      {include file='__x_image.tpl' _x_name="cover_image" _x_value=$post['job']['cover_image']}
    </div>
    <!-- cover image -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <input type="hidden" name="handle" value="job">
    <input type="hidden" name="id" value="{$post['post_id']}">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Save")}</button>
  </div>
</form>
