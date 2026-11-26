{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="mx-auto flex w-full max-w-6xl flex-col items-start gap-6 lg:flex-row">
  <!-- post -->
  <div class="min-w-0 w-full lg:max-w-3xl">
    {include file='__feeds_post.tpl' standalone=true}
    <div class="mt-6">
      {include file='_ads.tpl' ads=$ads_footer}
    </div>
  </div>
  <!-- post -->

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
