<div class="js_post-reactions-stats">
  {if isset($photo['reactions_total_count'])}
    {if $photo['reactions_total_count'] > 0}
      <div class="js_modal" data-url="posts/who_reacts.php?{if $photo['is_single']}post_id={$post['post_id']}{else}photo_id={$photo['photo_id']}{/if}">
        <div class="reactions-stats group/reactions -mx-1.5 -my-1 flex cursor-pointer items-center rounded-full px-1.5 py-1 transition-colors hover:bg-base-200">
          {foreach $photo['reactions'] as $reaction_type => $reaction_count}
            {if $reaction_count > 0}
            <div class="reactions-stats-item relative -ms-1 flex rounded-full bg-base-100 p-0.5 transition-colors first:ms-0 group-hover/reactions:bg-base-200" style="z-index: {10 - $reaction_count@iteration};">
              <div class="inline-emoji no_animation inline-flex size-4.5">
                  {include file='__reaction_emojis.tpl' _reaction=$reaction_type}
                </div>
              </div>
            {/if}
          {/foreach}
          <!-- reactions count -->
          <span class="ms-1.5 transition-colors group-hover/reactions:text-base-content">
            {$photo['reactions_total_count_formatted']}
          </span>
          <!-- reactions count -->
        </div>
      </div>
    {/if}
  {else}
    {if $post['reactions_total_count'] > 0}
      <div class="js_modal" data-url="posts/who_reacts.php?post_id={$post['post_id']}">
        <div class="reactions-stats group/reactions -mx-1.5 -my-1 flex cursor-pointer items-center rounded-full px-1.5 py-1 transition-colors hover:bg-base-200">
          {foreach $post['reactions'] as $reaction_type => $reaction_count}
            {if $reaction_count > 0}
            <div class="reactions-stats-item relative -ms-1 flex rounded-full bg-base-100 p-0.5 transition-colors first:ms-0 group-hover/reactions:bg-base-200" style="z-index: {10 - $reaction_count@iteration};">
              <div class="inline-emoji no_animation inline-flex size-4.5">
                  {include file='__reaction_emojis.tpl' _reaction=$reaction_type}
                </div>
              </div>
            {/if}
          {/foreach}
          <!-- reactions count -->
          <span class="ms-1.5 transition-colors group-hover/reactions:text-base-content">
            {$post['reactions_total_count_formatted']}
          </span>
          <!-- reactions count -->
        </div>
      </div>
    {/if}
  {/if}
</div>
