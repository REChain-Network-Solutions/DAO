<li class="job-candidate-wrapper">
  <div class="job-candidate-header">
    <div class="job-candidate-avatar">
      <a class="post-avatar-picture large" href="{$system['system_url']}/{$candidate['user_name']}" style="background-image:url({$candidate['user_picture']});"></a>
    </div>
    <div class="job-candidate-info">
      <div class="name">
        <a href="{$system['system_url']}/{$candidate['user_name']}">{$candidate['name']}</a>
      </div>
      <div class="row mb10">
        <div class="col-md-6">
          <span class="icon-[tabler--map-pin] size-4 me-1.25 text-[#1f9cff]" aria-hidden="true"></span>{$candidate['location']}
        </div>
        <div class="col-md-6">
          <span class="icon-[tabler--clock] size-4 me-1.25 text-[#ffc107]" aria-hidden="true"></span><span class="js_moment" data-time="{$candidate['applied_time']}">{$candidate['applied_time']}</span>
        </div>
      </div>
      <div class="row mb10">
        <div class="col-md-6">
          <span class="icon-[tabler--phone] size-4 me-1.25 text-[#2bb431]" aria-hidden="true"></span>{$candidate['phone']}
        </div>
        <div class="col-md-6">
          <span class="icon-[tabler--mail] size-4 me-1.25 text-[#009688]" aria-hidden="true"></span>{$candidate['email']}
        </div>
      </div>
      <div>
        <!-- message -->
        {if $system['chat_enabled']}
          <button type="button" class="heroui button button--primary button--sm rounded-full js_chat-start" data-uid="{$candidate['user_id']}" data-name="{if $system['show_usernames_enabled']}{$candidate['user_name']}{else}{$candidate['user_firstname']} {$candidate['user_lastname']}{/if}" data-link="{$candidate['user_name']}" data-picture="{$candidate['user_picture']}">
            <span class="icon-[tabler--messages] size-4 me-1.25" aria-hidden="true"></span>{__("Message")}
          </button>
        {/if}
        <!-- message -->
        <!-- resume -->
        {if $candidate['cv']}
          <a href="{$system['system_uploads']}/{$candidate['cv']}" class="heroui button button--primary [--button-bg:var(--success)] [--button-bg-hover:var(--success-hover)] [--button-bg-pressed:var(--success-hover)] [--button-fg:var(--success-foreground)] button--sm rounded-full" target="_blank">
            <span class="icon-[tabler--paperclip] size-4 me-1.25" aria-hidden="true"></span>{__("Download CV")}
          </a>
        {/if}
        <!-- resume -->
      </div>
    </div>
  </div>
  {if !$_for_course}
    <div class="divider mtb20"></div>
    <div class="job-question">
      <div class="mb10">
        <div class="question">{__("Where did you work?")}</div>
        <div class="answer">{$candidate['work_place']}</div>
      </div>
      <div class="row mb10">
        <div class="col-md-4">
          <div class="question">{__("Position")}</div>
          <div class="answer">{$candidate['work_position']}</div>
        </div>
        <div class="col-md-4">
          <div class="question">{__("From")}</div>
          <div class="answer">{$candidate['work_from']}</div>
        </div>
        <div class="col-md-4">
          <div class="question">{__("To")}</div>
          <div class="answer">{if $candidate['work_now']}{__("Till Now")}{else}{$candidate['work_to']}{/if}</div>
        </div>
      </div>
      <div class="question">{__("Description")}</div>
      <div class="answer">{$candidate['work_description']}</div>
    </div>
    <!-- questions -->
    {if $candidate['question_1_title'] || $candidate['question_2_title'] || $candidate['question_3_title']}
      <div class="divider mtb20"></div>
      <div>
        <!-- question #1 -->
        {if $candidate['question_1_title']}
          <div class="job-question">
            <div class="question">{$candidate['question_1_title']}</div>
            <div class="answer">
              {$candidate['question_1_answer']}
            </div>
          </div>
        {/if}
        <!-- question #1 -->
        <!-- question #2 -->
        {if $candidate['question_2_title']}
          <div class="job-question">
            <div class="question">{$candidate['question_2_title']}</div>
            <div class="answer">
              {$candidate['question_2_answer']}
            </div>
          </div>
        {/if}
        <!-- question #2 -->
        <!-- question #3 -->
        {if $candidate['question_3_title']}
          <div class="job-question">
            <div class="question">{$candidate['question_3_title']}</div>
            <div class="answer">
              {$candidate['question_3_answer']}
            </div>
          </div>
        {/if}
        <!-- question #3 -->
      </div>
    {/if}
    <!-- questions -->
  {/if}
</li>
