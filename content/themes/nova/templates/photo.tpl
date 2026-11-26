{include file='_head.tpl'}
{include file='_header.tpl'}

{assign var="post" value=$photo['post']}

<!-- page content -->
<div class="mx-auto flex w-full max-w-6xl flex-col items-start gap-6 lg:flex-row">
  <!-- photo -->
  <div class="post min-w-0 w-full overflow-hidden rounded-box bg-base-100 lg:max-w-3xl" data-id="{if $photo['is_single']}{$post['post_id']}{else}{$photo['photo_id']}{/if}">
    {include file='__feeds_post_photo.tpl' standalone=true}
  </div>
  <!-- photo -->

  <!-- right panel -->
  <aside class="flex w-full min-w-0 flex-col gap-5 lg:w-80 lg:shrink-0">
    {include file='_ads_campaigns.tpl'}
    {include file='_ads.tpl'}
    {include file='_widget.tpl'}
  </aside>
  <!-- right panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}
