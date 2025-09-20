{if $_tpl == "box"}
	<li class="col-md-12 {if $_small}col-lg-6{/if} mb-3">
		<div class="x_event_list">
			<div class="position-relative rounded-3 overflow-hidden border">
				<a href="{$system['system_url']}/events/{$_event['event_id']}{if $_search}?ref=qs{/if}" class="d-block w-100 avatar">
					<img alt="{$_event['event_title']}" src="{$_event['event_picture']}" class="w-100 h-100 rounded-3" />
				</a>
				<div class="d-flex align-items-center justify-content-between gap-2 gap-3 position-absolute p-3 pt-5 bottom-0 start-0 end-0 pe-none eventlist_foot">
					<div class="d-flex align-items-center gap-2 mw-0">
						<div class="position-relative bg-white text-center rounded-3 overflow-hidden profle-date-wrapper">
							<span class="d-block text-white fw-semibold text-uppercase lh-1">{__($_event['event_start_date']|date_format:"%b")}</span>
							<b class="d-block fw-bold lh-1">{$_event['event_start_date']|date_format:"%e"}</b>
						</div>
						<div class="bg-white rounded-pill pe-auto x_user_info py-1 info mw-0 text-truncate">
							<a class="h6 mw-0 text-truncate" href="{$system['system_url']}/events/{$_event['event_id']}{if $_search}?ref=qs{/if}">{$_event['event_title']}</a>
							<div class="small text-muted">{$_event['event_interested']} {__("Interested")}</div>
						</div>
					</div>
					<div class="flex-0 pe-auto">
						{if $_event['i_joined']['is_interested']}
							<button type="button" class="btn btn-sm btn-light js_uninterest-event" data-id="{$_event['event_id']}" title='{__("Interested")}'>
								<i class="fa fa-check mr5"></i>
							</button>
						{else}
							<button type="button" class="btn btn-sm btn-primary js_interest-event" data-id="{$_event['event_id']}" title='{__("Interested")}'>
								<i class="fa fa-star mr5"></i>
							</button>
						{/if}
					</div>
				</div>
			</div>
		</div>
	</li>
{elseif $_tpl == "list"}
	<li class="feeds-item px-3 side_item_hover side_item_list">
		<div class="d-flex align-items-center justify-content-between x_user_info {if $_small}small{/if}">
			<div class="d-flex align-items-center position-relative mw-0">
				<a class="position-relative flex-0" href="{$system['system_url']}/events/{$_event['event_id']}{if $_search}?ref=qs{/if}">
					<img src="{$_event['event_picture']}" alt="{$_event['event_title']}" class="rounded-circle">
				</a>
				<div class="mw-0 text-truncate mx-2 px-1">
					<div class="fw-semibold text-truncate">
						<a href="{$system['system_url']}/events/{$_event['event_id']}{if $_search}?ref=qs{/if}" class="body-color">
							{$_event['event_title']}
						</a>
					</div>
					<p class="m-0 text-muted text-truncate small">{$_event['event_interested']} {__("Interested")}</p>
				</div>
			</div>
			<div class="flex-0">
				<!-- buttons -->
				{if $_event['i_joined']['is_interested']}
					<button type="button" class="btn btn-sm btn-light js_uninterest-event" data-id="{$_event['event_id']}">
						{__("Interested")}
					</button>
				{else}
					<button type="button" class="btn btn-sm btn-dark js_interest-event" data-id="{$_event['event_id']}">
						{__("Interested")}
					</button>
				{/if}
				<!-- buttons -->
			</div>
		</div>
	</li>
{/if}