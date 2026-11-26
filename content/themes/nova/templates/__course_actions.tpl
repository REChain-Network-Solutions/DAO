{if $_course_post['manage_post']}
  <button type="button" class="js_modal heroui button button--tertiary w-full justify-between gap-3 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] {if $_small}button--sm{else}h-auto min-h-10{/if}" data-size="large" data-url="posts/course.php?do=candidates&post_id={$_course_post['post_id']}" title="{__("View Candidates")}">
    <span class="inline-flex min-w-0 items-center gap-2"><span class="icon-[tabler--users] size-4 shrink-0" aria-hidden="true"></span><span class="truncate">{__("View Candidates")}</span></span>
    <span class="inline-flex shrink-0 items-center gap-1.5"><span class="rounded-full bg-primary px-2 py-0.5 text-xs leading-4 font-semibold text-primary-content tabular-nums">{$_course_post['course']['candidates_count']}</span><span class="icon-[tabler--chevron-right] size-4 text-base-content/50 rtl:rotate-180" aria-hidden="true"></span></span>
  </button>
{elseif $_course_post['course']['i_applied']}
  <button type="button" class="heroui button button--tertiary text-base-content rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] {if $_small}button--sm{else}h-auto min-h-10 whitespace-normal{/if}" disabled>{__("Application submitted")}</button>
{elseif !$_course_post['course']['available']}
  <button type="button" class="heroui button button--tertiary rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] {if $_small}button--sm{else}h-auto min-h-10 whitespace-normal{/if}" disabled>{__("Closed")}</button>
{elseif $user->_logged_in}
  <button type="button" class="js_modal js_course-enroll heroui button button--primary rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] {if $_small}button--sm{else}h-auto min-h-10 whitespace-normal{/if}" data-course-application="{$_course_post['post_id']}" data-size="large" data-url="posts/course.php?do=application&post_id={$_course_post['post_id']}">{__("Apply to course")}</button>
{else}
  <button type="button" class="js_login heroui button button--primary rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] {if $_small}button--sm{else}h-auto min-h-10 whitespace-normal{/if}">{__("Apply to course")}</button>
{/if}
