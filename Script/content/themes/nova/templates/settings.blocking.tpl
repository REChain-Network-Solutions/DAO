<div class="card border border-base-300 bg-base-100 shadow-none">
  <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
      <span class="icon-[tabler--ban] size-5"></span>
    </span>
    <div class="min-w-0 grow">
      <h2 class="card-title text-lg">{__("Blocking")}</h2>
      <p class="text-sm text-base-content/60">{__("People you have blocked")}</p>
    </div>
    {if $blocks}
      <span class="badge badge-soft rounded-full ms-auto shrink-0">{count($blocks)}{if count($blocks) >= $system['max_results']}+{/if}</span>
    {/if}
  </div>
  <div class="card-body gap-6 pt-6">
    <div class="alert alert-warning flex items-start gap-3 leading-5" role="alert">
      <span class="icon-[tabler--alert-triangle] size-5 shrink-0" aria-hidden="true"></span>
      <p class="min-w-0 text-sm">{__("Once you block someone, that person can no longer see things you post on your timeline")}</p>
    </div>
    {if $blocks}
      <div class="flex flex-col gap-3">
        <ul class="flex flex-col gap-1">
          {foreach $blocks as $_user}
            {include file='__feeds_user.tpl' _tpl="list" _connection="blocked"}
          {/foreach}
        </ul>

        <!-- see-more -->
        {if count($blocks) >= $system['max_results']}
          <div class="see-more js_see-more flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="blocks">
            <span>{__("See More")}</span>
            <div class="loading loading-spinner loading-sm hidden"></div>
          </div>
        {/if}
        <!-- see-more -->
      </div>
    {else}
      {include file='_no_data.tpl' _empty_icon="icon-[tabler--user-check]"}
    {/if}
  </div>
</div>
