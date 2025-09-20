<div class="mb-3 overflow-hidden content">
	<h6 class="headline-font fw-semibold m-0 side_widget_title">
		{__("Trending")}
    </h6>
    {foreach $trending_hashtags as $hashtag}
		<a class="body-color px-3 d-block side_item_hover side_item_list" href="{$system['system_url']}/search/hashtag/{$hashtag['hashtag']}">
			<div class="hash fw-semibold">
				#{$hashtag['hashtag']}
			</div>
			<div class="frequency text-muted small">
				{$hashtag['frequency']} {__("Posts")}
			</div>
		</a>
    {/foreach}
</div>