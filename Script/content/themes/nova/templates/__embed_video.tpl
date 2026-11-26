<video class="js_video-plyr" id="video-{$post['video']['video_id']}-{$post['post_id']}" {if $post['video']['thumbnail']}data-poster="{$system['system_uploads']}/{$post['video']['thumbnail']}" {/if} playsinline controls preload="auto">
  {if empty($post['video']['source_240p']) && empty($post['video']['source_360p']) && empty($post['video']['source_480p']) && empty($post['video']['source_720p']) && empty($post['video']['source_1080p']) && empty($post['video']['source_1440p']) && empty($post['video']['source_2160p'])}
    <source src="{$system['system_uploads']}/{$post['video']['source']}" type="video/mp4">
  {/if}
  {if $post['video']['source_240p']}
    <source src="{$system['system_uploads']}/{$post['video']['source_240p']}" type="video/mp4" size="240">
  {/if}
  {if $post['video']['source_360p']}
    <source src="{$system['system_uploads']}/{$post['video']['source_360p']}" type="video/mp4" size="360">
  {/if}
  {if $post['video']['source_480p']}
    <source src="{$system['system_uploads']}/{$post['video']['source_480p']}" type="video/mp4" size="480">
  {/if}
  {if $post['video']['source_720p']}
    <source src="{$system['system_uploads']}/{$post['video']['source_720p']}" type="video/mp4" size="720">
  {/if}
  {if $post['video']['source_1080p']}
    <source src="{$system['system_uploads']}/{$post['video']['source_1080p']}" type="video/mp4" size="1080">
  {/if}
  {if $post['video']['source_1440p']}
    <source src="{$system['system_uploads']}/{$post['video']['source_1440p']}" type="video/mp4" size="1440">
  {/if}
  {if $post['video']['source_2160p']}
    <source src="{$system['system_uploads']}/{$post['video']['source_2160p']}" type="video/mp4" size="2160">
  {/if}
</video>