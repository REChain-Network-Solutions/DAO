<li class="col-md-6 col-lg-3">
  <div class="ui-box darker">
    <div class="img">
      <a href="{$activity['activity_user_url']}">
        <img alt="{$activity['title']}" src="{$activity['activity_user_picture']}" />
      </a>
    </div>
    <div class="mt10">
      <div class="h6">{$activity['title']|truncate:30}</div>
    </div>
    <div class="mt10 text-start" style="background: #fff; padding: 16px; border-radius: 16px;">
      <div class="post-text plr0 js_readmore">{$activity['description']|nl2br}</div>
    </div>
    <div class="mt10">
      <span class="badge bg-light text-primary">{$activity['category']['category_name']}</span>
    </div>
    <div class="mt10">
      <small class="mr5"><i class="fa-regular fa-clock"></i></small><small class="js_moment" data-time="{$activity['created_at']}">{$activity['created_at']}</small>
    </div>
    <div class="mt10">
      <span class="badge {if $activity['status'] == 'pending'}bg-warning{elseif $activity['status'] == 'completed'}bg-success{else}bg-primary{/if}">{if $activity['status'] == 'pending'}{__("Pending Follow Up")}{else}{__($activity['status'])|ucfirst}{/if}</span>
    </div>
    {if $activity['can_edit']}
      <div class="divider"></div>
      <div class="mt10 row g-1">
        {if $activity['status'] != 'completed'}
          <div class="col-12 {if $_small}col-md-8{else}col-md-9{/if} mb5">
            <div class="d-grid">
              <button type="button" class="btn btn-sm btn-primary" data-toggle="modal" data-url="modules/activities.php?do=edit&id={$activity['activity_id']}" class="text-link ml10">
                {__("Edit")}
              </button>
            </div>
          </div>
          <div class="col-12 {if $_small}col-md-4{else}col-md-3{/if}">
            <div class="d-grid">
              <button type="button" class="btn btn-sm btn-danger js_activity-deleter" data-id="{$activity['activity_id']}">
                {include file='__svg_icons.tpl' icon="delete" class="white-icon" width="18px" height="18px"}
              </button>
            </div>
          </div>
        </div>
      {else}
        <div class="col-12">
          <div class="d-grid">
            <button type="button" class="btn btn-sm btn-danger js_activity-deleter" data-id="{$activity['activity_id']}">
              {include file='__svg_icons.tpl' icon="delete" class="white-icon" width="18px" height="18px"}
            </button>
          </div>
        </div>
      {/if}
    {/if}
  </div>
</li>