<div class="col-md-6">
  <div class="ui-box {if $_darker}darker{/if}">
    <div class="img">
      <a href="{$system['system_url']}/{$_review['user_name']}">
        <img alt="" src="{$_review['user_picture']}" />
      </a>
    </div>
    <div class="mt10">
      <span class="js_user-popover" data-uid="{$_review['user_id']}">
        <a class="h6" href="{$system['system_url']}/{$_review['user_name']}">
          {$_review['user_fullname']}
        </a>
      </span>
      {if $_review['user_verified']}
        <span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified User")}'>
          {include file='__svg_icons.tpl' icon="verified_badge" width="20px" height="20px"}
        </span>
      {/if}
      {if $_review['user_subscribed']}
        <span class="pro-badge" data-bs-toggle="tooltip" title='{__("Pro User")}'>
          {include file='__svg_icons.tpl' icon="pro_badge" width="20px" height="20px"}
        </span>
      {/if}
    </div>
    <!-- time -->
    <div class="mt5">
      <i class="fa-regular fa-clock mr5"></i><small class="js_moment" data-time="{$_review['time']}">{$_review['time']}</small>
    </div>
    <!-- time -->
    <!-- rating -->
    <div class="review-stars mt10">
      <i class="fa fa-star {if $_review['rate'] >= 1}checked{/if}"></i>
      <i class="fa fa-star {if $_review['rate'] >= 2}checked{/if}"></i>
      <i class="fa fa-star {if $_review['rate'] >= 3}checked{/if}"></i>
      <i class="fa fa-star {if $_review['rate'] >= 4}checked{/if}"></i>
      <i class="fa fa-star {if $_review['rate'] >= 5}checked{/if}"></i>
    </div>
    <!-- rating -->
    <!-- review -->
    {if $_review['review']}
      <div class="review-review mt10">
        {$_review['review']}
      </div>
    {/if}
    <!-- review -->
    <!-- photos -->
    {if $_review['photos']}
      <div class="review-photos mt10">
        {foreach $_review['photos'] as $_photo}
          <span class="pointer js_lightbox-nodata" data-image="{$system['system_uploads']}/{$_photo['source']}">
            <img src="{$system['system_uploads']}/{$_photo['source']}">
          </span>
        {/foreach}
      </div>
    {/if}
    <!-- photos -->
    <!-- reply -->
    {if $_review['reply']}
      <div class="divider dashed mtb10"></div>
      <div class="review-reply">
        <div class="data-container">
          <a class="data-avatar" href="{$system['system_url']}/pages/{$_review['page_name']}">
            <img src="{$_review['page_picture']}" alt="">
          </a>
          <div class="data-content text-start">
            <div>
              <span class="name js_user-popover" data-type="page" data-uid="{$_review['page_id']}">
                <a href="{$system['system_url']}/pages/{$_review['page_name']}">
                  {$_review['page_title']}
                </a>
              </span>
              {if $_review['page_verified']}
                <span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified Page")}'>
                  {include file='__svg_icons.tpl' icon="verified_badge" width="20px" height="20px"}
                </span>
              {/if}
            </div>
            <div class="mt5">
              {$_review['reply']}
            </div>
          </div>
        </div>
      </div>
    {/if}
    <!-- reply -->
    <!-- actions -->
    {if $_review['page_admin'] == $user->_data['user_id'] && !$_review['reply']}
      <div class="divider dashed mtb10"></div>
      <button type="button" class="btn btn-sm btn-primary rounded-pill" data-toggle="modal" data-url="modules/review.php?do=reply&id={$_review['review_id']}">
        <i class="fa fa-comment mr5"></i>{__("Reply")}
      </button>
    {/if}
    <!-- actions -->
  </div>
</div>