<div class="post-comments py-4">
  {if $user->_logged_in}
    {if $_is_photo}

      <!-- sort comments -->
      {if $photo['comments'] > 0}
        <div class="comments-filter mb-2 flex justify-end">
          <select class="select select-sm js_comments-filter h-8 min-h-8 w-auto border-transparent bg-transparent py-0 ps-2.5 pe-8 text-xs! font-semibold text-base-content/70 shadow-none hover:bg-base-200" data-id="{$photo['photo_id']}">
            <option value="photo_comments">{__("Most Recent")}</option>
            <option value="photo_comments_top">{__("Top Comments")}</option>
            <option value="photo_comments_all">{__("All Comments")}</option>
          </select>
        </div>
      {/if}
      <!-- sort comments -->

      <!-- post comment -->
      {include file='__feeds_comment.form.tpl' _handle='photo' _id=$photo['photo_id']}
      <!-- post comment -->

      <!-- comments loader -->
      <div class="js_comments-filter-loader hidden py-4 text-center">
        <div class="loading loading-spinner loading-lg"></div>
      </div>
      <!-- comments loader -->

      <!-- comments -->
      <ul class="js_comments flex flex-col gap-1 has-[>li]:pt-2">
        {if $photo['comments'] > 0}
          {foreach $photo['photo_comments'] as $comment}
            {include file='__feeds_comment.tpl' _comment=$comment}
          {/foreach}
        {/if}
      </ul>
      <!-- comments -->

      <!-- previous comments -->
      {if $photo['comments'] >= $system['min_results']}
        <div class="js_see-more pb-2 pt-3 text-center" data-get="photo_comments" data-id="{$photo['photo_id']}" data-remove="true" data-target-stream=".js_comments">
          <span class="inline-flex cursor-pointer items-center gap-1.5 rounded-full px-3 py-1.5 text-sm font-semibold text-base-content/70 transition-colors hover:bg-base-200 hover:text-base-content">
            <span class="icon-[tabler--message-circle-up] size-4" aria-hidden="true"></span>
            {__("View previous comments")}
          </span>
          <div class="loading loading-spinner loading-sm hidden"></div>
        </div>
      {/if}
      <!-- previous comments -->

    {else}

      <!-- sort comments -->
      {if $post['comments'] > 0}
        <div class="comments-filter mb-2 flex justify-end">
          <select class="select select-sm js_comments-filter h-8 min-h-8 w-auto border-transparent bg-transparent py-0 ps-2.5 pe-8 text-xs! font-semibold text-base-content/70 shadow-none hover:bg-base-200" data-id="{$post['post_id']}">
            <option value="post_comments">{__("Most Recent")}</option>
            <option value="post_comments_top">{__("Top Comments")}</option>
            <option value="post_comments_all">{__("All Comments")}</option>
          </select>
        </div>
      {/if}
      <!-- sort comments -->

      <!-- post comment -->
      {include file='__feeds_comment.form.tpl' _handle='post' _id=$post['post_id']}
      <!-- post comment -->

      <!-- comments loader -->
      <div class="js_comments-filter-loader hidden py-4 text-center">
        <div class="loading loading-spinner loading-lg"></div>
      </div>
      <!-- comments loader -->

      <!-- live rules -->
      {if $_live_comments && $live_rules}
        <div class="alert alert-soft alert-info mt-2 flex items-start gap-2.5 text-sm" role="note">
          <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
          <div class="min-w-0">
            <div class="font-semibold">{__("Chat Rules")}</div>
            <div class="break-words">{$live_rules|nl2br}</div>
          </div>
        </div>
      {/if}
      <!-- live rules -->

      <!-- comments -->
      <ul class="js_comments flex flex-col gap-1 has-[>li]:pt-2 {if $_live_comments}js_live-comments{/if}">
        {if $post['comments'] > 0}
          {foreach $post['post_comments'] as $comment}
            {include file='__feeds_comment.tpl' _comment=$comment}
          {/foreach}
        {/if}
      </ul>
      <!-- comments -->

      <!-- previous comments -->
      {if $post['comments'] >= $system['min_results']}
        <div class="js_see-more py-3 text-center" data-get="post_comments" data-id="{$post['post_id']}" data-remove="true" data-target-stream=".js_comments">
          <span class="inline-flex cursor-pointer items-center gap-1.5 rounded-full px-3 py-1.5 text-sm font-semibold text-base-content/70 transition-colors hover:bg-base-200 hover:text-base-content">
            <span class="icon-[tabler--message-circle-up] size-4" aria-hidden="true"></span>
            {__("View previous comments")}
          </span>
          <div class="loading loading-spinner loading-sm hidden"></div>
        </div>
      {/if}
      <!-- previous comments -->

    {/if}
  {else}
    <div class="text-sm">
      <a class="font-medium" href="{$system['system_url']}/signin">{__("Please log in to like, share and comment!")}</a>
    </div>
  {/if}
</div>
