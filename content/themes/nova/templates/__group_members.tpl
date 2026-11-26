<!-- group members -->
<section class="card rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
  {include file='__section_head.tpl' _title=__("Members") _group="members" _base="`$system['system_url']`/groups/`$group['group_name']`"}
  <div class="card-body rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-base-100 p-5">
  {if $group['group_privacy'] == 'closed' && $group['i_joined'] != 'approved' && !$group['i_admin']}
    <div class="mb-6 rounded-2xl bg-base-200/60 p-5"><div class="flex items-center gap-2 text-sm font-semibold"><span class="icon-[tabler--lock-open] size-5 text-primary" aria-hidden="true"></span>{__("Closed Group")}</div>{if !is_empty($group['group_description'])}<p class="mt-3 whitespace-pre-line break-words text-sm leading-relaxed text-base-content/70" dir="auto">{$group['group_description']}</p>{/if}</div>
  {/if}
  {if $group['group_members'] > 0}<div><ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">{foreach $group['members'] as $_user}{include file='__feeds_user.tpl' _tpl='box' _connection=$_user['connection'] _darker=true}{/foreach}</ul>{if $group['group_members'] >= $system['max_results_even']}<button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="group_members" data-tpl="box" data-id="{$group['group_id']}"><span>{__("See More")}</span><i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i></button>{/if}</div>{else}{capture name=group_empty}{$group['group_title']} {__("doesn't have members")}{/capture}{include file='_no_data.tpl' _empty_icon='icon-[tabler--users]' _empty_title=$smarty.capture.group_empty}{/if}
  </div>
</section>
<!-- group members -->
