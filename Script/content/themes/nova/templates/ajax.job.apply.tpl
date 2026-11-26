{include file='__modal_header.tpl' _icon="icon-[tabler--briefcase]" _title=__("Job Apply")}
<form class="js_ajax-forms" data-url="posts/job.php?do=apply&post_id={$post['post_id']}">
  <div class="modal__body flex flex-col gap-4">
    <!-- your information -->
    <h3 class="text-sm font-semibold text-base-content">{__("Your Information")}</h3>
    <div class="grid gap-4 sm:grid-cols-2">
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="job-apply-name">{__("Name")}</label>
        <input name="name" id="job-apply-name" type="text" class="input w-full [--border:1px]" value="{$user->_data['user_fullname']}">
      </div>
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="job-apply-location">{__("Location")}</label>
        <input name="location" id="job-apply-location" type="text" class="input w-full [--border:1px]">
      </div>
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="job-apply-phone">{__("Phone")}</label>
        <input name="phone" id="job-apply-phone" type="text" class="input w-full [--border:1px]" value="{$user->_data['user_phone']}">
      </div>
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="job-apply-email">{__("Email")}</label>
        <input name="email" id="job-apply-email" type="text" class="input w-full [--border:1px]" value="{$user->_data['user_email']}">
      </div>
    </div>
    <!-- your information -->

    <hr class="separator">

    <!-- your experience -->
    <div class="flex items-center gap-2">
      <h3 class="text-sm font-semibold text-base-content">{__("Your Experience")}</h3>
      <span class="badge badge-soft badge-sm">{__("Optional")}</span>
    </div>
    <div class="grid gap-4 sm:grid-cols-2">
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="job-apply-work-place">{__("Where did you work?")}</label>
        <input name="work_place" id="job-apply-work-place" type="text" class="input w-full [--border:1px]">
      </div>
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="job-apply-work-position">{__("Position")}</label>
        <input name="work_position" id="job-apply-work-position" type="text" class="input w-full [--border:1px]">
      </div>
    </div>
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="job-apply-work-description">{__("Description")}</label>
      <textarea name="work_description" id="job-apply-work-description" rows="5" dir="auto" class="textarea w-full [--border:1px]"></textarea>
    </div>
    <div class="grid gap-4 sm:grid-cols-2">
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="job-apply-work-from">{__("From")}</label>
        <div class="select w-full [--border:1px]">
          <select class="min-w-0 ps-0!" name="work_from" id="job-apply-work-from">
            {$i=2022}
            {while $i >= 1970}
              <option value="{$i}">{$i}</option>
              {$i--}
            {/while}
          </select>
        </div>
      </div>
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="job-apply-work-to">{__("To")}</label>
        <div class="select w-full [--border:1px]">
          <select class="min-w-0 ps-0!" name="work_to" id="job-apply-work-to">
            {$i=2022}
            {while $i >= 1970}
              <option value="{$i}">{$i}</option>
              {$i--}
            {/while}
          </select>
        </div>
        <label class="mt-2 flex cursor-pointer items-center gap-2 text-sm" for="work_now">
          <input type="checkbox" class="checkbox checkbox-primary checkbox-sm [--border:1px]" name="work_now" id="work_now">
          {__("I currently work here")}
        </label>
      </div>
    </div>
    <!-- your experience -->

    <!-- questions -->
    {if $post['job']['question_1_title'] || $post['job']['question_2_title'] || $post['job']['question_3_title']}
      <hr class="separator">
      <div class="flex items-center gap-2">
        <h3 class="text-sm font-semibold text-base-content">{__("Job Questions")}</h3>
        <span class="badge badge-soft badge-sm">{__("Required")}</span>
      </div>
      <div class="flex flex-col gap-4">
          <!-- question #1 -->
          {if $post['job']['question_1_title']}
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="question_1_answer">{$post['job']['question_1_title']}</label>
              {if $post['job']['question_1_type'] == "free_text"}
                <textarea name="question_1_answer" id="question_1_answer" rows="3" dir="auto" class="textarea w-full [--border:1px]"></textarea>
              {elseif $post['job']['question_1_type'] == "yes_no_question"}
                <div class="flex items-center gap-6">
                  <label class="flex cursor-pointer items-center gap-2 text-sm" for="question_1_yes">
                    <input type="radio" name="question_1_answer" id="question_1_yes" value="yes" class="radio radio-primary radio-sm [--border:1px]">
                    {__("Yes")}
                  </label>
                  <label class="flex cursor-pointer items-center gap-2 text-sm" for="question_1_no">
                    <input type="radio" name="question_1_answer" id="question_1_no" value="no" class="radio radio-primary radio-sm [--border:1px]">
                    {__("No")}
                  </label>
                </div>
              {else}
                <div class="select w-full [--border:1px]">
                  <select class="min-w-0 ps-0!" name="question_1_answer" id="question_1_answer">
                    {foreach $post['job']['question_1_options'] as $id => $value}
                      <option value="{$id}">{$value}</option>
                    {/foreach}
                  </select>
                </div>
              {/if}
            </div>
          {/if}
          <!-- question #1 -->
          <!-- question #2 -->
          {if $post['job']['question_2_title']}
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="question_2_answer">{$post['job']['question_2_title']}</label>
              {if $post['job']['question_2_type'] == "free_text"}
                <textarea name="question_2_answer" id="question_2_answer" rows="3" dir="auto" class="textarea w-full [--border:1px]"></textarea>
              {elseif $post['job']['question_2_type'] == "yes_no_question"}
                <div class="flex items-center gap-6">
                  <label class="flex cursor-pointer items-center gap-2 text-sm" for="question_2_yes">
                    <input type="radio" name="question_2_answer" id="question_2_yes" value="yes" class="radio radio-primary radio-sm [--border:1px]">
                    {__("Yes")}
                  </label>
                  <label class="flex cursor-pointer items-center gap-2 text-sm" for="question_2_no">
                    <input type="radio" name="question_2_answer" id="question_2_no" value="no" class="radio radio-primary radio-sm [--border:1px]">
                    {__("No")}
                  </label>
                </div>
              {else}
                <div class="select w-full [--border:1px]">
                  <select class="min-w-0 ps-0!" name="question_2_answer" id="question_2_answer">
                    {foreach $post['job']['question_2_options'] as $id => $value}
                      <option value="{$id}">{$value}</option>
                    {/foreach}
                  </select>
                </div>
              {/if}
            </div>
          {/if}
          <!-- question #2 -->
          <!-- question #3 -->
          {if $post['job']['question_3_title']}
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="question_3_answer">{$post['job']['question_3_title']}</label>
              {if $post['job']['question_3_type'] == "free_text"}
                <textarea name="question_3_answer" id="question_3_answer" rows="3" dir="auto" class="textarea w-full [--border:1px]"></textarea>
              {elseif $post['job']['question_3_type'] == "yes_no_question"}
                <div class="flex items-center gap-6">
                  <label class="flex cursor-pointer items-center gap-2 text-sm" for="question_3_yes">
                    <input type="radio" name="question_3_answer" id="question_3_yes" value="yes" class="radio radio-primary radio-sm [--border:1px]">
                    {__("Yes")}
                  </label>
                  <label class="flex cursor-pointer items-center gap-2 text-sm" for="question_3_no">
                    <input type="radio" name="question_3_answer" id="question_3_no" value="no" class="radio radio-primary radio-sm [--border:1px]">
                    {__("No")}
                  </label>
                </div>
              {else}
                <div class="select w-full [--border:1px]">
                  <select class="min-w-0 ps-0!" name="question_3_answer" id="question_3_answer">
                    {foreach $post['job']['question_3_options'] as $id => $value}
                      <option value="{$id}">{$value}</option>
                    {/foreach}
                  </select>
                </div>
              {/if}
            </div>
          {/if}
          <!-- question #3 -->
      </div>
    {/if}
    <!-- questions -->

    <hr class="separator">

    <!-- CV attachment -->
    <div class="flex items-center gap-2">
      <h3 class="text-sm font-semibold text-base-content">{__("CV Attachment")}</h3>
      <span class="badge badge-soft badge-sm">{__("Optional")}</span>
    </div>
    <div class="w-full">
      <div class="label-text mb-1.5 block" id="job-apply-cv-label">{__("Upload your CV")}</div>
      {include file='__x_image.tpl' _x_name="cv" _x_handle="x-file" _x_type="file"}
      <p class="mt-1.5 text-sm text-base-content/60">{__("Allowed file types")}: {$system['file_extensions']}</p>
    </div>
    <!-- CV attachment -->

    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Apply")}</button>
  </div>
</form>
