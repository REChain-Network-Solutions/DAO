{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">
  {include file='__listing_page.tpl' _module="offers" _image="offers.svg" _title=__("Offers") _text=__($system['system_description_offers']) _search_placeholder=__("Search for offers") _create_enabled=$system['offers_enabled'] _create_url="posts/offer.php?do=create" _create_label=__("Create Offer") _my_label=__("My Offers") _my_icon="icon-[tabler--discount]" _card="__feeds_offer.tpl" _promoted=$promoted_offers _promoted_title=__("Promoted Offers") _sort2_key="expire-soon" _sort2_label=__("Expire Soon") _sort3_key="expire-latest" _sort3_label=__("Expire Latest") _empty_icon="icon-[tabler--discount]"}
</div>
<!-- page content -->

{include file='_footer.tpl'}
