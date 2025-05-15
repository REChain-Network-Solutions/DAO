{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<!-- page content -->
<div class="{if $system['fluid_design']}container-fluid{else}container{/if} mt20 sg-offcanvas">
  <div class="row">

    <!-- left panel -->
    <div class="col-md-4 col-lg-3 sg-offcanvas-sidebar js_sticky-sidebar">
      {include file='_sidebar.tpl'}
    </div>
    <!-- left panel -->

    <!-- content panel -->
    <div class="col-md-8 col-lg-9 sg-offcanvas-mainbar">

      <div class="reels-wrapper">
        {if $posts}
          <div class="reels-loader" data-offset="1">{__("Loading")} <span class="spinner-grow spinner-grow-sm ml-3"></span></div>
          {foreach $posts as $post}
            {include file='__feeds_reel.tpl' _iteration=$post@iteration}
          {/foreach}
        {else}
          <div class="mtb30">
            {include file='_no_data.tpl'} </div>
        {/if}
      </div>
    </div>
    <!-- content panel -->

  </div>
</div>
<!-- page content -->
<!--page content-->

{include file='_footer.tpl'}

<script>
  var first_id = $('.reel-container').first().data('id');
  if (first_id) {
    var url = site_path + '/reels/' + first_id;
    window.history.pushState({ state: 'new' }, '', url);
  }
</script>