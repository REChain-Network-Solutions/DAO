{include file='__modal_header.tpl' _icon="icon-[tabler--briefcase]" _title=__("Job Candidates")}
<div class="modal__body flex flex-col gap-4">
  {if $candidates}
    <ul>
      {foreach $candidates as $candidate}
        {include file='__feeds_candidate.tpl'}
      {/foreach}
    </ul>

    {if $candidates_count >= $system['max_results']}
      <!-- see-more -->
      {include file='__modal_see_more.tpl' _get="job_candidates" _id=$post_id}
      <!-- see-more -->
    {/if}
  {else}
    {include file='_no_data.tpl' _empty_icon="icon-[tabler--users]"}
  {/if}
</div>
