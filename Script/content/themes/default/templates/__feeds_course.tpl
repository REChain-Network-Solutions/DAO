<div class="col-md-6 col-lg-4">
  <div class="card product {if $_boosted}boosted{/if}">
    {if $_boosted}
      <div class="boosted-icon" data-bs-toggle="tooltip" title="{__("Promoted")}">
        <i class="fa fa-bullhorn"></i>
      </div>
    {/if}
    {if $post['needs_subscription']}
      <a href="{$system['system_url']}/posts/{$post['post_id']}">
        <div class="ptb20 plr20">
          {include file='_need_subscription.tpl'}
        </div>
      </a>
    {else}
      <div class="product-image">
        <div class="product-price">
          {print_money($post['course']['fees'], $post['course']['fees_currency']['symbol'], $post['course']['fees_currency']['dir'])}
        </div>
        <img src="{$system['system_uploads']}/{$post['course']['cover_image']}">
        <div class="product-overlay">
          <a class="btn btn-sm btn-outline-secondary rounded-pill" href="{$system['system_url']}/posts/{$post['post_id']}">
            {__("More")}
          </a>
          {if $post['author_id'] != $user->_data['user_id'] }
            <button type="button" class="btn btn-sm btn-info rounded-pill js_course-enroll" data-toggle="modal" data-size="large" data-url="posts/course.php?do=application&post_id={$post['post_id']}">
              {__("Enroll Now")}
            </button>
          {/if}
        </div>
      </div>
      <div class="product-info">
        <div class="product-meta">
          <a href="{$system['system_url']}/posts/{$post['post_id']}" class="title">{$post['course']['title']}</a>
        </div>
        <div class="product-meta">
          <i class="fa fa-map-marker fa-fw mr5" style="color: #1f9cff;"></i>{if $post['course']['location']}{$post['course']['location']}{else}{__("N/A")}{/if}
        </div>
        {if $system['posts_reviews_enabled']}
          <div class="product-meta">
            {include file='__svg_icons.tpl' icon="star" class="main-icon mr5" width="24px" height="24px"}
            <span>{$post['reviews_count']} {__("Reviews")}</span>
            {if $post['post_rate']}
              <span class="review-stars small ml5">
                <i class="fa fa-star {if $post['post_rate'] >= 1}checked{/if}"></i>
                <i class="fa fa-star {if $post['post_rate'] >= 2}checked{/if}"></i>
                <i class="fa fa-star {if $post['post_rate'] >= 3}checked{/if}"></i>
                <i class="fa fa-star {if $post['post_rate'] >= 4}checked{/if}"></i>
                <i class="fa fa-star {if $post['post_rate'] >= 5}checked{/if}"></i>
              </span>
              <span class="badge bg-light text-primary">{$post['post_rate']|number_format:1}</span>
            {/if}
          </div>
        {/if}
      </div>
    {/if}
  </div>
</div>