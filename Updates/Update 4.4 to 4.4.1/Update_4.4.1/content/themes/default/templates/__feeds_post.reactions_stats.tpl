<div class="js_post-reactions-stats">
  {if isset($photo['reactions_total_count'])}
    {if $photo['reactions_total_count'] > 0}
      <div class="float-start" data-toggle="modal" data-url="posts/who_reacts.php?{if $photo['is_single']}post_id={$post['post_id']}{else}photo_id={$photo['photo_id']}{/if}">
        <div class="reactions-stats">
          {foreach $photo['reactions'] as $reaction_type => $reaction_count}
            {if $reaction_count > 0}
              <div class="reactions-stats-item">
                <div class="inline-emoji no_animation">
                  {include file='__reaction_emojis.tpl' _reaction=$reaction_type}
                </div>
              </div>
            {/if}
          {/foreach}
          <!-- reactions count -->
          <span>
            {$photo['reactions_total_count_formatted']}
          </span>
          <!-- reactions count -->
        </div>
      </div>
    {/if}
  {else}
    {if $post['reactions_total_count'] > 0}
      <div class="float-start" data-toggle="modal" data-url="posts/who_reacts.php?post_id={$post['post_id']}">
        <div class="reactions-stats">
          {foreach $post['reactions'] as $reaction_type => $reaction_count}
            {if $reaction_count > 0}
              <div class="reactions-stats-item">
                <div class="inline-emoji no_animation">
                  {include file='__reaction_emojis.tpl' _reaction=$reaction_type}
                </div>
              </div>
            {/if}
          {/foreach}
          <!-- reactions count -->
          <span>
            {$post['reactions_total_count_formatted']}
          </span>
          <!-- reactions count -->
        </div>
      </div>
    {/if}
  {/if}
</div>