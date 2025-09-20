<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Invitations")}
	</div>
	<div class="mt-2">
		<button data-toggle="modal" data-url="users/invitations.php?do=generate" class="btn btn-sm btn-primary">
			{__("Generate New Code")}
		</button>
	</div>
</div>

<div class="p-3 pt-1">
	<div class="alert alert-secondary">
		<div class="text">
			<strong>{__("Invitations System")}</strong><br>
			{__("You have")} <strong><span class="badge rounded-pill bg-danger">{if $system['invitation_user_limit'] == 0}{__("Unlimited")}{else}{$system['invitation_user_limit']}{/if}</span></strong> {__("invitations")} {if $system['invitation_user_limit'] != 0}{__("every")} {__($system['invitation_expire_period']|ucfirst)}{/if}
		</div>
	</div>

	<div class="row">
		<div class="col-lg-6">
			<div class="stat-panel x_address">
				<div class="stat-cell p-3">
					<i class="fa fa-mail-bulk icon bg-gradient-success"></i>
					<span class="text-xxlg">{if $system['invitation_user_limit'] == 0}<i class="fas fa-infinity"></i>{else}{$invitation_codes_stats['available']}{/if}</span><br>
					<span>{__("Available Invitations")}</span>
				</div>
			</div>
		</div>
		<div class="col-lg-6">
			<div class="stat-panel x_address">
				<div class="stat-cell p-3">
					<i class="fa fa-envelope icon bg-gradient-primary"></i>
					<span class="text-xxlg">{$invitation_codes_stats['generated']}</span><br>
					<span>{__("Generated Invitations")}</span>
				</div>
			</div>
		</div>
		<div class="col-lg-12">
			<div class="stat-panel x_address">
				<div class="stat-cell p-3">
					<i class="fa fa-envelope-open-text icon bg-gradient-danger"></i>
					<span class="text-xxlg">{$invitation_codes_stats['used']}</span><br>
					<span>{__("Used Invitations")}</span>
				</div>
			</div>
		</div>
	</div>

	<div class="heading-small mb-1">
		{__("Your Invitations Codes")}
	</div>
	{if $invitation_codes}
		<div class="table-responsive">
			<table class="table table-hover align-middle">
				<thead>
					<tr>
						<th class="fw-semibold bg-transparent">{__("Invitation Code")}</th>
						<th class="fw-semibold bg-transparent">{__("Used")}</th>
						<th class="fw-semibold bg-transparent">{__("Used By")}</th>
						<th class="fw-semibold bg-transparent"></th>
					</tr>
				</thead>
				<tbody>
					{foreach $invitation_codes as $invitation_code}
						<tr>
							<td class="bg-transparent">
								<div><span class="badge rounded-pill badge-lg bg-secondary">{$invitation_code['code']}</span></div>
								<div class="small">{$invitation_code['created_date']|date_format:"%e %B %Y"}</div>
							</td>
							<td class="bg-transparent">
								{if $invitation_code['used']}
									<span class="badge rounded-pill bg-danger">{__("Yes")}</span>
								{else}
									<span class="badge rounded-pill bg-success">{__("No")}</span>
								{/if}
							</td>
							<td class="bg-transparent">
								{if $invitation_code['used']}
									<a target="_blank" href="{$system['system_url']}/{$invitation_code['user_name']}">
										<img class="tbl-image" src="{$invitation_code['user_picture']}">
										{$invitation_code['user_firstname']} {$invitation_code['user_lastname']}
									</a>
								{/if}
							</td>
							<td class="bg-transparent text-end">
								{if !$invitation_code['used']}
									<button data-bs-toggle="tooltip" title='{__("Share")}' class="btn btn-gray border-0 p-2 rounded-circle lh-1 js_session-deleter" data-toggle="modal" data-url="users/invitations.php?do=share&code={$invitation_code['code']}{if $system['affiliates_enabled']}&ref={$user->_data['user_name']}{/if}">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M18 7C18.7745 7.16058 19.3588 7.42859 19.8284 7.87589C21 8.99181 21 10.7879 21 14.38C21 17.9721 21 19.7681 19.8284 20.8841C18.6569 22 16.7712 22 13 22H11C7.22876 22 5.34315 22 4.17157 20.8841C3 19.7681 3 17.9721 3 14.38C3 10.7879 3 8.99181 4.17157 7.87589C4.64118 7.42859 5.2255 7.16058 6 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M12.0253 2.00052L12 14M12.0253 2.00052C11.8627 1.99379 11.6991 2.05191 11.5533 2.17492C10.6469 2.94006 9 4.92886 9 4.92886M12.0253 2.00052C12.1711 2.00657 12.3162 2.06476 12.4468 2.17508C13.3531 2.94037 15 4.92886 15 4.92886" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
									</button>
								{/if}
							</td>
						</tr>
					{/foreach}
				</tbody>
			</table>
		</div>
	{else}
		{include file='_no_data.tpl'}
	{/if}
</div>