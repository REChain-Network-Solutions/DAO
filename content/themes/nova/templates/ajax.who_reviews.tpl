{include file='__modal_header.tpl' _icon="icon-[tabler--star]" _title=__("Post Reviews")}
<div class="modal__body flex flex-col gap-4">
  {if $post['reviews_count'] > 0}
    <ul class="flex flex-col gap-3">
      {foreach $post['reviews'] as $_review}
        {include file='__feeds_review.tpl'}
      {/foreach}
    </ul>
    {if $post['reviews_count'] >= $system['max_results_even']}
      <!-- see-more -->
      {include file='__modal_see_more.tpl' _get="reviews" _id=$post['post_id'] _type="post"}
      <!-- see-more -->
    {/if}
  {else}
    {capture assign=_empty_title}{__("this post")} {__("doesn't have reviews")}{/capture}
    {include file='_no_data.tpl' _empty_icon="icon-[tabler--star]" _empty_title=$_empty_title}
  {/if}
</div>
