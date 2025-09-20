<div class="modal-header">
  <h6 class="modal-title">
    {include file='__svg_icons.tpl' icon="courses" class="main-icon mr10" width="24px" height="24px"}
    {__("Course Candidates")}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<div class="modal-body">
  {if $candidates}
    <ul>
      {foreach $candidates as $candidate}
        {include file='__feeds_candidate.tpl' _for_course=true}
      {/foreach}
    </ul>

    {if $candidates_count >= $system['max_results']}
      <!-- see-more -->
      <div class="alert alert-info see-more js_see-more" data-get="course_candidates" data-id="{$post_id}">
        <span>{__("See More")}</span>
        <div class="loader loader_small x-hidden"></div>
      </div>
      <!-- see-more -->
    {/if}
  {else}
    {include file='_no_data.tpl'}
  {/if}
</div>