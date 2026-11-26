{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">
  {include file='__listing_page.tpl' _module="jobs" _image="jobs.svg" _title=__("Jobs") _text=__($system['system_description_jobs']) _search_placeholder=__("Search for jobs") _create_enabled=$system['jobs_enabled'] _create_url="posts/job.php?do=create" _create_label=__("Create Job") _my_label=__("My Jobs") _my_icon="icon-[tabler--briefcase]" _card="__feeds_job.tpl" _promoted=$promoted_jobs _promoted_title=__("Promoted Jobs") _sort2_key="salary-high" _sort2_label=__("Salary High") _sort3_key="salary-low" _sort3_label=__("Salary Low") _empty_icon="icon-[tabler--briefcase]"}
</div>
<!-- page content -->

{include file='_footer.tpl'}
