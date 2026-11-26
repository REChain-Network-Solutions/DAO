{if $user->_data['can_comment']}
  <div class="comment js_comment-form flex items-end gap-2.5 {if $post['comments_disabled']}hidden{/if}" data-handle="{$_handle}" data-id="{$_id}">
    <div class="comment-avatar shrink-0">
      {if $post['user_type'] == "page" && $post['is_page_admin']}
        <a class="comment-avatar-picture block size-10 rounded-full bg-cover bg-center" href="{$post['post_author_url']}" style="background-image:url({$post['post_author_picture']});" aria-label="{$post['post_author_name']}"></a>
      {else}
        <a class="comment-avatar-picture block size-10 rounded-full bg-cover bg-center" href="{$system['system_url']}/{$user->_data['user_name']}" style="background-image:url({$user->_data['user_picture']});" aria-label="{$user->_data['user_fullname']}"></a>
      {/if}
    </div>
    <div class="comment-data min-w-0 flex-1">
      {include file='__composer.tpl' _context="comment" _size="lg" _class="comment-form"}
    </div>
  </div>
  <div class="js_comment-disabled-msg py-3 text-center text-sm text-base-content/55 {if !$post['comments_disabled']}hidden{/if}">
    {__("Commenting has been turned off for this post")}.
  </div>
{else}
  {include file='__feeds_comment.permission.tpl'}
{/if}
