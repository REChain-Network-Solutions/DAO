<div class="col-sm-6 col-md-4 col-lg-3 mb-3">
	<div class="album-card x_adslist overflow-hidden">
		{if $album['cover']['blur']}<div class="x-blured">{/if}
		<a class="album-cover d-block w-100 h-100" href="{$system['system_url']}/{$album['path']}/album/{$album['album_id']}" style="background-image:url({$album['cover']['source']});"></a>
		{if $album['cover']['blur']}</div>{/if}
		<div class="album-details p-2">
			<div class="text-truncate">
				<a href="{$system['system_url']}/{$album['path']}/album/{$album['album_id']}" class="fw-medium body-color">{__($album['title'])}</a>
			</div>
			<div class="d-flex align-items-center justify-content-between text-muted small">
				{$album['photos_count']} {__("photos")}
				<div class="">
					{if $album['privacy'] == "me"}
						<i class="fa fa-user-lock" data-bs-toggle="tooltip" title='{__("Shared with")}: {__("Only Me")}'></i>
					{elseif $album['privacy'] == "friends"}
						<i class="fa fa-user-friends" data-bs-toggle="tooltip" title='{__("Shared with")}: {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}'></i>
					{elseif $album['privacy'] == "public"}
						<i class="fa fa-globe-americas" data-bs-toggle="tooltip" title='{__("Shared with")}: {__("Public")}'></i>
					{elseif $album['privacy'] == "custom"}
						<i class="fa fa-cog" data-bs-toggle="tooltip" title='{__("Shared with")} {__("Custom People")}'></i>
					{/if}
				</div>
			</div>
		</div>
	</div>
</div>