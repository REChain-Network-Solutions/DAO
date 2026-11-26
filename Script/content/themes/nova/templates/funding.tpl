{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">
  {include file='__listing_page.tpl' _module="funding" _image="funding.svg" _title=__("Funding") _text=__($system['system_description_funding']) _search_placeholder=__("Search for funding") _create_enabled=$system['funding_enabled'] _create_url="posts/funding.php?do=create" _create_label=__("Create Funding") _my_label=__("My Funding") _my_icon="icon-[tabler--coin]" _card="__feeds_funding.tpl" _promoted=$promoted_funding _promoted_title=__("Promoted Funding") _sort2_key="amount-high" _sort2_label=__("Amount High") _sort3_key="amount-low" _sort3_label=__("Amount Low") _empty_icon="icon-[tabler--coin]"}
</div>
<!-- page content -->

{include file='_footer.tpl'}
