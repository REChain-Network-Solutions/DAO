{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">
  {include file='__listing_page.tpl' _module="courses" _image="courses.svg" _title=__("Courses") _text=__($system['system_description_courses']) _search_placeholder=__("Search for courses") _create_enabled=$system['courses_enabled'] _create_url="posts/course.php?do=create" _create_label=__("Create Course") _my_label=__("My Courses") _my_icon="icon-[tabler--school]" _card="__feeds_course.tpl" _promoted=$promoted_courses _promoted_title=__("Promoted Courses") _sort2_key="price-high" _sort2_label=__("Price High") _sort3_key="price-low" _sort3_label=__("Price Low") _empty_icon="icon-[tabler--school]"}
</div>
<!-- page content -->

{include file='_footer.tpl'}
