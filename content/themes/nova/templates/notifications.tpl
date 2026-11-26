{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {include file='__page_header.tpl' _title=__("Notifications") _image="notifications.svg"}
  <!-- page heading -->

  <div class="mt-6 grid gap-6 lg:grid-cols-[minmax(0,1fr)_20rem] lg:items-start">

    <!-- notifications -->
    <section class="card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none" aria-labelledby="notifications-title">
      <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
        <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
          <span class="icon-[tabler--bell] size-5"></span>
        </span>
        <h2 class="card-title min-w-0 grow text-lg" id="notifications-title">{__("Your Notifications")}</h2>
        {if $user->_data['notifications']}
          <button type="button" class="heroui button button--danger-soft button--sm w-full sm:ms-auto sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] js_delete-all-notifications">
            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
            {__("Delete All")}
          </button>
        {/if}
      </div>
      {if $user->_data['notifications']}
        <div>
          <ul class="divide-y divide-base-300">
            {foreach $user->_data['notifications'] as $notification}
              {include file='__feeds_notification.tpl' _tpl="with-action"}
            {/foreach}
          </ul>

          {if count($user->_data['notifications']) >= $system['max_results']}
            <!-- see-more -->
            <div class="see-more js_see-more flex cursor-pointer items-center justify-center gap-2 border-t border-base-300 py-3.5 text-sm font-semibold transition-colors hover:bg-primary/5 hover:text-primary" data-get="notifications">
              <span>{__("See More")}</span>
              <div class="loading loading-spinner loading-sm hidden"></div>
            </div>
            <!-- see-more -->
          {/if}
        </div>
      {else}
        {include file='_no_data.tpl' _empty_icon="icon-[tabler--bell-off]" _empty_title=__("No notifications")}
      {/if}
    </section>
    <!-- notifications -->

    <!-- aside -->
    <aside class="flex flex-col gap-6 lg:sticky lg:top-24">
      {include file='_ads_campaigns.tpl'}
      {include file='_ads.tpl'}
      {include file='_widget.tpl'}
    </aside>
    <!-- aside -->

  </div>

</div>
<!-- page content -->

{include file='_footer.tpl'}
