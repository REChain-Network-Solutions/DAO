{include file='__modal_header.tpl' _icon="icon-[tabler--mood-smile]" _title=__("Reactions")}
<div class="modal__body flex flex-col gap-4">
  <!-- panel nav -->
  <div class="tabs tabs--secondary w-full" data-orientation="horizontal">
    <div class="tabs__list-container w-full overflow-x-auto [scrollbar-width:none]! [&::-webkit-scrollbar]:hidden!">
      <div class="tabs__list gap-1" role="tablist" data-orientation="horizontal">
        <a class="tabs__tab js_modal h-10 w-auto shrink-0 gap-1.5 px-3 font-semibold" href="#" role="tab" data-url="posts/who_reacts.php?{$get}={$id}&reaction_type=all" {if $reaction_type == "all"}data-selected="true" aria-selected="true"{/if}>
          {__("All")}
          <span class="text-base-content/60">{$reactions_counts['all']|abbreviate_count}</span>
          {if $reaction_type == "all"}<span class="tabs__indicator"></span>{/if}
        </a>
        {foreach $system['reactions_enabled'] as $reaction}
          {if $reactions_counts[$reaction['reaction']] > 0 || $reaction_type == $reaction['reaction']}
            <a class="tabs__tab js_modal h-10 w-auto shrink-0 gap-1.5 px-3 font-semibold" href="#" role="tab" data-url="posts/who_reacts.php?{$get}={$id}&reaction_type={$reaction['reaction']}" title="{__($reaction['title'])}" {if $reaction_type == $reaction['reaction']}data-selected="true" aria-selected="true"{/if}>
              <span class="inline-emoji no_animation inline-flex size-5">
                {include file='__reaction_emojis.tpl' _reaction=$reaction['reaction']}
              </span>
              <span class="text-base-content/60">{$reactions_counts[$reaction['reaction']]|abbreviate_count}</span>
              {if $reaction_type == $reaction['reaction']}<span class="tabs__indicator" style="background-color: {$reaction['color']};"></span>{/if}
            </a>
          {/if}
        {/foreach}
      </div>
    </div>
  </div>
  <!-- panel nav -->

  {if $users}
    <ul class="-mx-3 flex flex-col">
      {foreach $users as $_user}
        {include file='__feeds_user.tpl' _tpl="list" _connection=$_user["connection"] _reaction=$_user["reaction"]}
      {/foreach}
    </ul>

    {if count($users) >= $system['max_results']}
      <!-- see-more -->
      {include file='__modal_see_more.tpl' _get="`$handle`_reactions" _filter=$reaction_type _id=$id}
      <!-- see-more -->
    {/if}
  {else}
    {include file='_no_data.tpl' _empty_icon="icon-[tabler--mood-smile]" _empty_title=__("No reactions yet")}
  {/if}
</div>
