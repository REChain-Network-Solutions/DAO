{if $_comment['reactions_total_count'] > 0}
  <div class="js_modal" data-url="posts/who_reacts.php?comment_id={$_comment['comment_id']}">
    <div class="reactions-stats flex cursor-pointer items-center">
      {foreach $_comment['reactions'] as $reaction_type => $reaction_count}
        {if $reaction_count > 0}
        <div class="reactions-stats-item relative -ms-1 flex rounded-full bg-base-100 p-px ring-1 ring-base-100 first:ms-0" style="z-index: {10 - $reaction_count@iteration};">
          <div class="inline-emoji no_animation inline-flex size-4">
              {include file='__reaction_emojis.tpl' _reaction=$reaction_type}
            </div>
          </div>
        {/if}
      {/foreach}
      <!-- reactions count -->
      <span>
        {$_comment['reactions_total_count_formatted']}
      </span>
      <!-- reactions count -->
    </div>
  </div>
{/if}
