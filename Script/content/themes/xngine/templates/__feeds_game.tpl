{if $_tpl != "list"}
	<li class="col-md-6 col-lg-4 mb-4">
		<a href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}" class="ratio ratio-1x1 d-block">
			<img alt="{$_game['title']}" src="{$_game['thumbnail']}" class="object-cover rounded-4 game_thumb_img" />
		</a>
		
		<div class="text-center mt-2">
			<h5 class="m-0 {if !$_game['played']}mb-1{/if} text-truncate">
				<a class="body-color" href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}" title="{$_game['title']}">{$_game['title']}</a>
			</h5>
			{if $_game['played']}
				<div class="small text-muted mb-1">
					{__("Played")}: <span class="js_moment" data-time="{$_game['last_played_time']}">{$_game['last_played_time']}</span>
				</div>
			{/if}
			<a class="btn btn-sm btn-dark" href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}">
				{__("Play")}
			</a>
		</div>
	</li>
{elseif $_tpl == "list"}
	<li class="feeds-item px-3 side_item_hover side_item_list">
		<div class="d-flex align-items-center justify-content-between x_user_info">
			<div class="d-flex align-items-center position-relative mw-0">
				<a class="position-relative flex-0" href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}">
					<img src="{$_game['thumbnail']}" alt="{$_game['title']}" class="rounded-circle">
				</a>
				<div class="mw-0 text-truncate mx-2 px-1">
					<div class="fw-semibold text-truncate">
						<a href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}" class="body-color">
							{$_game['title']}
						</a>
					</div>
				</div>
			</div>
			<div class="flex-0">
				<!-- buttons -->
				<a class="btn btn-sm btn-dark" href="{$system['system_url']}/games/{$_game['game_id']}/{$_game['title_url']}">
					{__("Play")}
				</a>
				<!-- buttons -->
			</div>
		</div>
	</li>
{/if}