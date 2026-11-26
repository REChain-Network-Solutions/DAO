{include file='__modal_header.tpl' _icon="icon-[tabler--school]" _title=__("Course Candidates")}
<div class="modal__body flex flex-col gap-4">
  {if $candidates}
    <ul class="divide-y divide-base-300">
      {foreach $candidates as $candidate}
        {include file='__feeds_course_candidate.tpl'}
      {/foreach}
    </ul>

    {if $candidates_count > $system['max_results']}
      <!-- see-more -->
      {include file='__modal_see_more.tpl' _get="course_candidates" _id=$post_id}
      <!-- see-more -->
    {/if}
  {else}
    <div role="status">
      {include file='_no_data.tpl' _empty_icon="icon-[tabler--users]" _empty_title=__("No applications yet") _empty_compact=true}
    </div>
  {/if}
</div>
