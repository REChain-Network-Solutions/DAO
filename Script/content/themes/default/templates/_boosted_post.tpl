{if !$_no_title}
  <!-- posts-filter -->
  <div class="posts-filter">
    <span>{__("Promoted Posts")}</span>
  </div>
  <!-- posts-filter -->
{/if}

{include file='__feeds_post.tpl' standalone=true boosted=true}