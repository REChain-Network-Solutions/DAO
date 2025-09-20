{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="row x_content_row">
    <!-- content panel -->
    <div class="col-lg-8">
		<div class="position-sticky x_top_posts">
			<div class="headline-font fw-semibold side_widget_title px-3 py-2 d-flex align-items-center justify-content-between">
				{__("Merits")} {__("Ranking")}
				<button type="button" class="btn btn-gray border-0 p-2 rounded-circle lh-1 flex-0" data-bs-toggle="modal" data-bs-target="#filter_modal">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3 7H6" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M3 17H9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M18 17L21 17" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M15 7L21 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M6 7C6 6.06812 6 5.60218 6.15224 5.23463C6.35523 4.74458 6.74458 4.35523 7.23463 4.15224C7.60218 4 8.06812 4 9 4C9.93188 4 10.3978 4 10.7654 4.15224C11.2554 4.35523 11.6448 4.74458 11.8478 5.23463C12 5.60218 12 6.06812 12 7C12 7.93188 12 8.39782 11.8478 8.76537C11.6448 9.25542 11.2554 9.64477 10.7654 9.84776C10.3978 10 9.93188 10 9 10C8.06812 10 7.60218 10 7.23463 9.84776C6.74458 9.64477 6.35523 9.25542 6.15224 8.76537C6 8.39782 6 7.93188 6 7Z" stroke="currentColor" stroke-width="1.75" /><path d="M12 17C12 16.0681 12 15.6022 12.1522 15.2346C12.3552 14.7446 12.7446 14.3552 13.2346 14.1522C13.6022 14 14.0681 14 15 14C15.9319 14 16.3978 14 16.7654 14.1522C17.2554 14.3552 17.6448 14.7446 17.8478 15.2346C18 15.6022 18 16.0681 18 17C18 17.9319 18 18.3978 17.8478 18.7654C17.6448 19.2554 17.2554 19.6448 16.7654 19.8478C16.3978 20 15.9319 20 15 20C14.0681 20 13.6022 20 13.2346 19.8478C12.7446 19.6448 12.3552 19.2554 12.1522 18.7654C12 18.3978 12 17.9319 12 17Z" stroke="currentColor" stroke-width="1.75" /></svg>
				</button>
			</div>
		</div>
		
		{if $merits_ranking_users}
            <div class="table-responsive">
				<table class="table table-hover">
					<thead>
						<tr>
							<th>{__("Rank")}</th>
							<th>{__("User")}</th>
							<th>{__("Amount")}</th>
						</tr>
					</thead>
					<tbody>
						{foreach $merits_ranking_users as $_user}
							<tr>
								<td>{$_user@iteration}</td>
								<td>
									<a target="_blank" href="{$system['system_url']}/{$_user['user_name']}">
										<img class="tbl-image" src="{$_user['user_picture']}">
										{if $system['show_usernames_enabled']}{$_user['user_name']}{else}{$_user['user_firstname']} {$_user['user_lastname']}{/if}
									</a>
								</td>
								<td>{$_user['count']}</td>
							</tr>
						{/foreach}
					</tbody>
				</table>
            </div>
		{else}
            <div class="p-3">
				<div class="text-muted text-center py-5">
					<svg width="56" height="56" class="text-danger opacity-50" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M13.5647 15.2197C14.1348 15.528 15.0292 16.0116 15.6409 16.5861C16.0219 16.9439 16.4159 17.4432 16.4883 18.0782C16.5665 18.7653 16.2485 19.3856 15.6772 19.9078C14.7182 20.7844 13.5522 21.5 12.0399 21.5H4.96015C3.44779 21.5 2.28177 20.7844 1.3228 19.9078C0.751481 19.3856 0.433458 18.7653 0.511739 18.0782C0.584083 17.4432 0.978131 16.9439 1.35906 16.5861C1.97085 16.0116 2.86511 15.528 3.43523 15.2197C3.56216 15.1511 3.67304 15.0911 3.76114 15.0408C6.66339 13.3828 10.3366 13.3828 13.2389 15.0408C13.3269 15.0911 13.4378 15.1511 13.5647 15.2197Z" fill="currentColor"/><path d="M3.59668 7.37838C3.59668 4.68412 5.79187 2.5 8.49977 2.5C11.2077 2.5 13.4029 4.68412 13.4029 7.37838C13.4029 10.0726 11.2077 12.2568 8.49977 12.2568C5.79187 12.2568 3.59668 10.0726 3.59668 7.37838Z" fill="currentColor"/><path d="M13.7776 10.9656C13.572 11.2407 13.4692 11.3783 13.5081 11.5144C13.5471 11.6506 13.6841 11.7128 13.9581 11.8373C14.5282 12.0963 15.1712 12.2419 15.8515 12.2419C18.1982 12.2419 20.1005 10.5088 20.1005 8.37097C20.1005 6.23309 18.1982 4.5 15.8515 4.5C15.5956 4.5 15.345 4.52061 15.1016 4.56011C14.8001 4.60902 14.6494 4.63347 14.5698 4.75422C14.4902 4.87497 14.5465 5.03357 14.6592 5.35075C14.8816 5.97695 15.0017 6.64504 15.0017 7.33871C15.0017 8.68342 14.5502 9.93204 13.7776 10.9656Z" fill="currentColor"/><path d="M18.893 20.5C20.4249 20.5 21.6164 19.9038 22.6072 19.1596C23.1944 18.7186 23.5791 18.1506 23.4862 17.4806C23.4027 16.8788 22.9563 16.4309 22.5711 16.1336C21.94 15.6466 21.0193 15.2377 20.4392 14.98C20.3111 14.9231 20.1996 14.8735 20.1114 14.8322C18.981 14.3015 17.7373 13.9735 16.4669 13.8483C15.6476 13.7676 15.238 13.7272 15.1443 13.9501C15.0507 14.173 15.4155 14.4118 16.1451 14.8893C16.4221 15.0707 16.6902 15.265 16.9254 15.4673C17.4549 15.9226 18.2313 16.7422 18.3777 17.9186C18.4456 18.4638 18.367 18.9661 18.1903 19.4199C17.9799 19.9603 17.8747 20.2305 17.9657 20.3586C17.9715 20.3668 17.9751 20.3713 17.9816 20.3791C18.0837 20.5 18.3534 20.5 18.893 20.5Z" fill="currentColor"/></svg>
					<div class="post-paid-description mt-3">
						{__("No people available")}
					</div>
				</div>
			</div>
		{/if}
    </div>
    <!-- content panel -->
	
	<!-- right panel -->
	<div class="col-lg-4">
		<!-- upgrade to pro -->	
		{if $system['packages_enabled'] && !$user->_data['user_subscribed']}
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Upgrade to Pro")}
				</h6>
				<div class="px-3 py-0 side_item_list">
					{__("Choose the Plan That's Right for You")}
				</div>
				<div class="px-3 side_item_list">
					<a class="btn btn-main" href="{$system['system_url']}/packages">
						{__("Upgrade")}
					</a>
				</div>
			</div>
		{/if}
		<!-- upgrade to pro -->
		
		{include file='_ads.tpl'}
		{include file='_ads_campaigns.tpl'}
		{include file='_widget.tpl'}
		
		<!-- mini footer -->
		{include file='_footer_mini.tpl'}
		<!-- mini footer -->
	</div>
	<!-- right panel -->
</div>
<!-- page content -->

<!-- search panel -->
<div class="modal fade" id="filter_modal" tabindex="-1">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">{__("Filter")}</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
	  
			<form method="get">
				<div class="modal-body pb-2">
					<div class="form-floating">
						<select class="form-select" name="category" id="category">
							<option value="all">{__("All")}</option>
							{foreach $merits_categories as $category}
								{include file='__categories.recursive_options.tpl' data_category=$config['category']}
							{/foreach}
						</select>
						<label class="form-label">{__("Category")}</label>
					</div>
					<div class="form-floating">
						<input type="date" class="form-control" name="start_date" value="{$config['start_date']}" placeholder=" ">
						<label class="form-label">{__("From")}</label>
					</div>
					<div class="form-floating">
						<input type="date" class="form-control" name="end_date" value="{$config['end_date']}" placeholder=" ">
						<label class="form-label">{__("To")}</label>
					</div>
				</div>
				<div class="modal-footer">
					<button type="submit" class="btn btn-primary">{__("Filter")}</button>
                </div>
			</form>
		</div>
	</div>
</div>
<!-- search panel -->

{include file='_footer.tpl'}