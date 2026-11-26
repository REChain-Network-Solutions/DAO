{if $_get}
  {if $posts}
    <ul class="flex flex-col gap-5">
      {foreach $posts as $post}
        {include file='__feeds_post.tpl'}
      {/foreach}
    </ul>

    <!-- see-more -->
    <div class="see-more js_see-more mt-5 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary {if $user->_logged_in}js_see-more-infinite{/if}" data-get="{$_get}" data-filter="{$_filter}" {if $_category}data-category="{$_category}" {/if}{if $_country}data-country="{$_country}" {/if}{if $_id}data-id="{$_id}" {/if}>
      <span>{__("More Stories")}</span>
      <div class="loading loading-spinner loading-sm hidden"></div>
    </div>
    <!-- see-more -->
  {else}
    <ul>
      <li class="rounded-box bg-base-100 p-4">
        {include file='_no_data.tpl' _empty_icon="icon-[tabler--news]" _empty_title=__("No posts yet") _empty_text=__("Follow people and pages to see their posts here")}
      </li>
    </ul>
  {/if}
{else}
  {foreach $posts as $post}
    {include file='__feeds_post.tpl'}
  {/foreach}
{/if}
