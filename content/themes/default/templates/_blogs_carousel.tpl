<div class="card">
  <div class="card-header bg-transparent">
    <div class="float-end">
      <small><a href="{$system['system_url']}/blogs">{__("See All")}</a></small>
    </div>
    {__("Latest Blogs")}
  </div>
  <div class="card-body ptb0 plr5">
    <div id="blogs-carousel" class="carousel slide" data-bs-ride="carousel">
      <div class="carousel-inner">
        {foreach $latest_blogs as $index => $blog}
          <div class="carousel-item {if $index == 0}active{/if}">
            <div class="post-media list mb0">
              <div class="post-media-image-wrapper">
                <a class="post-media-image" href="{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}">
                  <div style="padding-top: 50%; background-position: center center; background-size: cover; background-image:url('{$blog['blog']['parsed_cover']}');"></div>
                </a>
                {if $blog['blog']['category_id']}
                  <div class="post-media-image-meta">
                    <a class="blog-category" href="{$system['system_url']}/blogs/category/{$blog['blog']['category_id']}/{$blog['blog']['category_url']}">
                      {__($blog['blog']['category_name'])}
                    </a>
                  </div>
                {/if}
              </div>
              <div class="post-media-meta">
                <a class="title mb5" href="{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}">{$blog['blog']['title']}</a>
                <div class="text mb5">
                  {$blog['blog']['text_snippet']|truncate:100}
                </div>
                <div class="info">
                  {__("By")}
                  <span class="js_user-popover pr10" data-type="{$blog['user_type']}" data-uid="{$blog['user_id']}">
                    <a href="{$blog['post_author_url']}">{$blog['post_author_name']}</a>
                  </span>
                  <i class="fa fa-clock pr5"></i><span class="js_moment pr10" data-time="{$blog['time']}">{$blog['time']}</span>
                </div>
              </div>
            </div>
          </div>
        {/foreach}
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#blogs-carousel" data-bs-slide="prev" style="left: -10px;">
        <span class="carousel-control-prev-icon" style="background-color: rgba(0, 0, 0, 0.15); border-radius: 50%; width: 1.5rem; height: 1.5rem;"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#blogs-carousel" data-bs-slide="next" style="right: -10px;">
        <span class="carousel-control-next-icon" style="background-color: rgba(0, 0, 0, 0.15); border-radius: 50%; width: 1.5rem; height: 1.5rem;"></span>
      </button>
    </div>
  </div>
</div>