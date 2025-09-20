{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
.search-wrapper-prnt {
display: none !important
}
</style>

<!-- page content -->
<div class="row x_content_row">
    <!-- content panel -->
    <div class="col-lg-12 w-100">
		<div class="d-flex align-items-center p-3 position-sticky x_top_posts">
			<div class="d-flex align-items-center justify-content-between gap-10 position-relative">
				<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Ads Manager")}</span>
				<span class="flex-0">
					{if $view == "new" || $view == "edit"}
						<a href="{$system['system_url']}/ads" class="btn btn-sm flex-0">
							<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg> <span class="my2">{__("Go Back")}</span>
						</a>
					{else}
						<a href="{$system['system_url']}/ads/new" class="btn btn-sm btn-primary flex-0 d-none d-md-flex">
							<span class="my2">{__("New Campaign")}</span>
						</a>
						<a href="{$system['system_url']}/ads/new" class="btn btn-primary flex-0 p-2 rounded-circle lh-1 d-md-none">
							<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 3C12.5523 3 13 3.44772 13 4V11H20C20.5523 11 21 11.4477 21 12C21 12.5523 20.5523 13 20 13H13V20C13 20.5523 12.5523 21 12 21C11.4477 21 11 20.5523 11 20V13H4C3.44772 13 3 12.5523 3 12C3 11.4477 3.44772 11 4 11H11V4C11 3.44772 11.4477 3 12 3Z" fill="currentColor"/></svg>
						</a>
					{/if}
				</span>
			</div>
		</div>
		
		<!-- adblock-warning-message -->
		<div class="adblock-warning-message mx-3 mt-3 mb-0">
			{__("Turn off the ad blocker or add this web page's URL as an exception so you use ads system without any problems")}, {__("After you turn off the ad blocker, you'll need to refresh your screen")}
		</div>
		<!-- adblock-warning-message -->

		{if $view == ""}

			<!-- ads campaigns -->
			<div class="px-3 pt-3 headline-font fw-semibold h4 m-0">
				{__("My Campaigns")}
			</div>
			
            {if $campaigns}
				<div class="p-3">
					<div class="row">
						{foreach $campaigns as $campaign}
							<div class="col-lg-6 col-md-6 mb-3">
								<div class="x_adslist p-3">
									<div class="d-flex mb-2 align-items-center justify-content-between">
										<div>
											{if $campaign['campaign_is_declined']}
												<span class="badge rounded-pill bg-danger bg-opacity-75 fw-medium">{__("Declined")}</span>
											{else}
												{if !$campaign['campaign_is_approved']}
													<span class="badge rounded-pill bg-warning text-dark bg-opacity-75 fw-medium">{__("Approval Pending")}</span>
												{else}
													{if $campaign['campaign_is_active']}
														<span class="badge rounded-pill bg-success bg-opacity-75 fw-medium">{__("Active")}</span>
													{else}
														<span class="badge rounded-pill bg-danger bg-opacity-75 fw-medium">{__("Not Active")}</span>
													{/if}
												{/if}
											{/if}
										</div>
										<div class="dropdown flex-0">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none" data-bs-toggle="dropdown" data-display="static" class="pointer position-relative"><path d="M11.9959 12H12.0049" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M17.9998 12H18.0088" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.99981 12H6.00879" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path></svg>
											<div class="dropdown-menu dropdown-menu-end" role="menu">
												<a href="{$system['system_url']}/ads/edit/{$campaign['campaign_id']}" class="dropdown-item pointer">
													<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg> {__("Edit")}
												</a>
												<div class="dropdown-item pointer js_ads-delete-campaign" data-id="{$campaign['campaign_id']}">
													<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.5 5.5L18.8803 15.5251C18.7219 18.0864 18.6428 19.3671 18.0008 20.2879C17.6833 20.7431 17.2747 21.1273 16.8007 21.416C15.8421 22 14.559 22 11.9927 22C9.42312 22 8.1383 22 7.17905 21.4149C6.7048 21.1257 6.296 20.7408 5.97868 20.2848C5.33688 19.3626 5.25945 18.0801 5.10461 15.5152L4.5 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M3 5.5H21M16.0557 5.5L15.3731 4.09173C14.9196 3.15626 14.6928 2.68852 14.3017 2.39681C14.215 2.3321 14.1231 2.27454 14.027 2.2247C13.5939 2 13.0741 2 12.0345 2C10.9688 2 10.436 2 9.99568 2.23412C9.8981 2.28601 9.80498 2.3459 9.71729 2.41317C9.32164 2.7167 9.10063 3.20155 8.65861 4.17126L8.05292 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M9.5 16.5L9.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M14.5 16.5L14.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg> {__("Delete")}
												</div>
												<div class="dropdown-divider"></div>
												{if $campaign['campaign_is_approved']}
													{if $campaign['campaign_is_active']}
														<div class="dropdown-item pointer js_ads-stop-campaign" data-id="{$campaign['campaign_id']}">
															<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.75" /><path d="M9.38886 15.1629C9.89331 15.5 10.5955 15.5 12 15.5C13.4045 15.5 14.1067 15.5 14.6111 15.1629C14.8295 15.017 15.017 14.8295 15.1629 14.6111C15.5 14.1067 15.5 13.4045 15.5 12C15.5 10.5955 15.5 9.89331 15.1629 9.38886C15.017 9.17048 14.8295 8.98298 14.6111 8.83706C14.1067 8.5 13.4045 8.5 12 8.5C10.5955 8.5 9.89331 8.5 9.38886 8.83706C9.17048 8.98298 8.98298 9.17048 8.83706 9.38886C8.5 9.89331 8.5 10.5955 8.5 12C8.5 13.4045 8.5 14.1067 8.83706 14.6111C8.98298 14.8295 9.17048 15.017 9.38886 15.1629Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg> {__("Stop")}
														</div>
													{else}
														<div class="dropdown-item pointer js_ads-resume-campaign" data-id="{$campaign['campaign_id']}">
															<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.75" /><path d="M15.9453 12.3948C15.7686 13.0215 14.9333 13.4644 13.2629 14.3502C11.648 15.2064 10.8406 15.6346 10.1899 15.4625C9.9209 15.3913 9.6758 15.2562 9.47812 15.0701C9 14.6198 9 13.7465 9 12C9 10.2535 9 9.38018 9.47812 8.92995C9.6758 8.74381 9.9209 8.60868 10.1899 8.53753C10.8406 8.36544 11.648 8.79357 13.2629 9.64983C14.9333 10.5356 15.7686 10.9785 15.9453 11.6052C16.0182 11.8639 16.0182 12.1361 15.9453 12.3948Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /></svg> {__("Resume")}
														</div>
													{/if}
												{/if}
											</div>
										</div>
									</div>
									
									<div class="h5 m-0 text-truncate"><a href="{$system['system_url']}/ads/edit/{$campaign['campaign_id']}" class="body-color">{$campaign['campaign_title']}</a></div>
									<div class="small">{$campaign['campaign_start_date']|date_format:"%e/%m/%Y"} - {$campaign['campaign_end_date']|date_format:"%e/%m/%Y"}</div>
									
									<div class="d-flex align-items-center gap-2 mt-2 text-muted">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M16 14C16 14.8284 16.6716 15.5 17.5 15.5C18.3284 15.5 19 14.8284 19 14C19 13.1716 18.3284 12.5 17.5 12.5C16.6716 12.5 16 13.1716 16 14Z" stroke="currentColor" stroke-width="1.75" /><path d="M10 7H16C18.8284 7 20.2426 7 21.1213 7.87868C22 8.75736 22 10.1716 22 13V15C22 17.8284 22 19.2426 21.1213 20.1213C20.2426 21 18.8284 21 16 21H10C6.22876 21 4.34315 21 3.17157 19.8284C2 18.6569 2 16.7712 2 13V11C2 7.22876 2 5.34315 3.17157 4.17157C4.34315 3 6.22876 3 10 3H14C14.93 3 15.395 3 15.7765 3.10222C16.8117 3.37962 17.6204 4.18827 17.8978 5.22354C18 5.60504 18 6.07003 18 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
										<span class="mw-0">{__("Spend")} {print_money($campaign['campaign_spend']|number_format:2)}</span>
									</div>
									<div class="d-flex align-items-center gap-2 mt-1 text-muted">
										{if $campaign['campaign_bidding'] == "click"}
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M13.0342 20.8715C11.0574 21.0082 9.09878 11.7891 10.4437 10.444C11.7886 9.09888 21.0083 11.0561 20.8717 13.0329C20.7776 14.3275 18.5864 14.8396 18.6504 15.9902C18.6691 16.3272 19.0948 16.6343 19.9462 17.2485C20.5377 17.6754 21.141 18.0899 21.7224 18.5304C21.9545 18.7062 22.0461 19.0018 21.978 19.2805C21.6507 20.619 20.6249 21.6493 19.2809 21.978C19.0022 22.0462 18.7066 21.9545 18.5308 21.7224C18.0905 21.1408 17.676 20.5375 17.2492 19.9459C16.635 19.0944 16.328 18.6686 15.991 18.6499C14.8406 18.5859 14.3286 20.7775 13.0342 20.8715Z" stroke="currentColor" stroke-width="1.75" /><path d="M7.05139 16C4.12629 15.1008 2 12.3774 2 9.15744C2 5.20449 5.20449 2 9.15744 2C12.3774 2 15.1008 4.12629 16 7.05139" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M11 6.95491C10.4754 6.36883 9.71316 6 8.86472 6C7.28258 6 6 7.28258 6 8.86472C6 9.71316 6.36883 10.4754 6.95491 11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
											<span class="mw-0">{$campaign['campaign_clicks']} {__("Clicks")}</span>
										{else}
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M21.544 11.045C21.848 11.4713 22 11.6845 22 12C22 12.3155 21.848 12.5287 21.544 12.955C20.1779 14.8706 16.6892 19 12 19C7.31078 19 3.8221 14.8706 2.45604 12.955C2.15201 12.5287 2 12.3155 2 12C2 11.6845 2.15201 11.4713 2.45604 11.045C3.8221 9.12944 7.31078 5 12 5C16.6892 5 20.1779 9.12944 21.544 11.045Z" stroke="currentColor" stroke-width="1.75" /><path d="M15 12C15 10.3431 13.6569 9 12 9C10.3431 9 9 10.3431 9 12C9 13.6569 10.3431 15 12 15C13.6569 15 15 13.6569 15 12Z" stroke="currentColor" stroke-width="1.75" /></svg>
											<span class="mw-0">{$campaign['campaign_views']} {__("Views")}</span>
										{/if}
									</div>
									<div class="d-flex align-items-center gap-2 mt-1 text-muted">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M18 2V4M6 2V4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M11.9955 13H12.0045M11.9955 17H12.0045M15.991 13H16M8 13H8.00897M8 17H8.00897" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M3.5 8H20.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M2.5 12.2432C2.5 7.88594 2.5 5.70728 3.75212 4.35364C5.00424 3 7.01949 3 11.05 3H12.95C16.9805 3 18.9958 3 20.2479 4.35364C21.5 5.70728 21.5 7.88594 21.5 12.2432V12.7568C21.5 17.1141 21.5 19.2927 20.2479 20.6464C18.9958 22 16.9805 22 12.95 22H11.05C7.01949 22 5.00424 22 3.75212 20.6464C2.5 19.2927 2.5 17.1141 2.5 12.7568V12.2432Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M3 8H21" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										<span class="mw-0">
											{__("Created")}
											<span class="js_moment" data-time="{$campaign['campaign_created_date']}">
												{$campaign['campaign_created_date']}
											</span>
										</span>
									</div>
								</div>
							</div>
						{/foreach}
					</div>
				</div>
            {else}
				{include file='_no_data.tpl'}
            {/if}
			<!-- ads campaigns -->

		{elseif $view == "new"}

			<!-- new campaign -->
			<div class="px-3 pt-3 headline-font fw-semibold h4 m-0">
				{__("New Campaign")}
			</div>
			
			<div class="p-3">
				<form class="js_ajax-forms" data-url="ads/campaign.php?do=create">
					{if $user->_data['user_wallet_balance'] == 0}
						<div class="bs-callout bs-callout-danger mt0">
							{__("Your current wallet credit is")}: <strong>{print_money($user->_data['user_wallet_balance']|number_format:2)}</strong> {__("You need to")} <a href="{$system['system_url']}/wallet">{__("Replenish your wallet credit")}</a>
						</div>
					{/if}

					{if $system['ads_approval_enabled']}
						<div class="bs-callout bs-callout-warning mt0">
							{__("Your campaign will need to be approved by admin before publishing")}
						</div>
					{/if}

					<div class="row">
						<!-- campaign details & target audience -->
						<div class="col-md-6 mb-3 mb-md-0">
							<!-- campaign details -->
							<div class="form-floating">
								<input type="text" class="form-control" name="campaign_title" id="campaign_title" placeholder=" ">
								<label class="form-label" for="campaign_title">{__("Campaign Title")}</label>
								<div class="form-text">
									{__("Set a title for your campaign")}
								</div>
							</div>

							<div class="form-floating">
								<input type="datetime-local" class="form-control" name="campaign_start_date" placeholder=" ">
								<label class="form-label" for="campaign_start_date">{__("Campaign Start Date")}</label>
								<div class="form-text">
									{__("Set Campaign start datetime (UTC)")}
								</div>
							</div>

							<div class="form-floating">
								<input type="datetime-local" class="form-control" name="campaign_end_date" placeholder=" ">
								<label class="form-label" for="campaign_end_date">{__("Campaign End Date")}</label>
								<div class="form-text">
									{__("Set Campaign end datetime (UTC)")}
								</div>
							</div>
				  
							<div class="form-floating">
								<input type="text" class="form-control" placeholder="0.00" min="1.00" max="1000" name="campaign_budget">
								<label class="form-label" for="campaign_budget">{__("Campaign Budget")} ({$system['system_currency_symbol']})</label>
								<div class="form-text">
									{__("Set a budget for your campaign, campaign will be paused if reached its limit")}
								</div>
							</div>
				  
							<div class="form-floating">
								<select class="form-select" name="campaign_bidding">
									<option value="click">{__("Pay Per Click")} ({print_money($system['ads_cost_click'])})</option>
									<option value="view">{__("Pay Per View")} ({print_money($system['ads_cost_view'])})</option>
								</select>
								<label class="form-label" for="campaign_bidding">{__("Campaign Bidding")}</label>
							</div>
							<!-- campaign details -->

							<!-- target audience -->
							<div class="form-floating">
								<select class="form-select" multiple name="audience_countries[]" id="js_ads-audience-countries">
									{foreach $countries as $country}
										<option value="{$country['country_id']}">{$country['country_name']}</option>
									{/foreach}
								</select>
								<label class="form-label" for="audience_countries">{__("Audience Country")}</label>
							</div>
							
							<div class="form-floating {if $system['genders_disabled']}x-hidden{/if}">
								<select class="form-select" name="audience_gender" id="js_ads-audience-gender">
									<option value="all">{__("All")}</option>
									{foreach $genders as $gender}
										<option value="{$gender['gender_id']}">{$gender['gender_name']}</option>
									{/foreach}
								</select>
								<label class="form-label" for="audience_gender">{__("Audience Gender")}</label>
							</div>
				  
							{if $system['relationship_info_enabled']}
								<div class="form-floating">
									<select class="form-select" name="audience_relationship" id="js_ads-audience-relationship">
										<option value="all">{__("All")}</option>
										<option value="single">{__("Single")}</option>
										<option value="relationship">{__("In a relationship")}</option>
										<option value="married">{__("Married")}</option>
										<option value="complicated">{__("It's complicated")}</option>
										<option value="separated">{__("Separated")}</option>
										<option value="divorced">{__("Divorced")}</option>
										<option value="widowed">{__("Widowed")}</option>
									</select>
									<label class="form-label" for="audience_relationship">{__("Audience Relationship")}</label>
								</div>
							{/if}
							
							<div class="form-group">
								<label class="form-label" for="potential_reach">{__("Potential Reach")}</label>
								<div class="d-flex align-items-center justify-content-between gap-2">
									<div class="d-flex align-items-center gap-1">
										<span class="badge rounded-pill bg-success" id="js_ads-potential-reach">{$potential_reach}</span> {__("People")}
									</div>
									<div class="flex-0 lh-1 x-hidden" id="js_ads-potential-reach-loader">
										<div class="spinner-border spinner-border-sm small opacity-50"></div>
									</div>
								</div>
							</div>
							<!-- target audience -->
						</div>
						<!-- campaign details & target audience -->

						<!-- ads details -->
						<div class="col-md-6">
							<div class="form-floating">
								<input type="text" class="form-control" name="ads_title" id="ads_title" placeholder=" ">
								<label class="form-label" for="ads_title">{__("Ads Title")}</label>
								<div class="form-text">
									{__("Set a title for your ads")}
								</div>
							</div>
						  
							<div class="form-floating">
								<textarea class="form-control" name="ads_description" rows="6" placeholder=" "></textarea>
								<label class="form-label" for="ads_description">{__("Ads Description")}</label>
								<div class="form-text">
									{__("Set a description for your ads (maximum 200 characters)")}
								</div>
							</div>
						  
							<div class="form-floating">
								<select class="form-select" name="ads_type" id="js_campaign-type">
									<option value="url">{__("URL")}</option>
									<option value="post">{__("Post")}</option>
									<option value="page">{__("Page")}</option>
									<option value="group">{__("Group")}</option>
									<option value="event">{__("Event")}</option>
								</select>
								<label class="form-label" for="ads_type">{__("Advertise For")}</label>
								<div class="form-text">
									{__("You can advertise for a URL or one of your posts, pages, groups or events")}
								</div>
							</div>
						  
							<div class="form-floating" id="js_campaign-type-url">
								<input type="text" class="form-control" name="ads_url" placeholder=" ">
								<label class="form-label" for="ads_url">{__("Target URL")}</label>
								<div class="form-text">
									{__("Enter your URL you want to advertise for")}
								</div>
							</div>
							
							<div class="form-floating x-hidden" id="js_campaign-type-post">
								<input type="text" class="form-control" name="ads_post_url" placeholder=" ">
								<label class="form-label" for="ads_post_url">{__("Target post URL")}</label>
								<div class="form-text">
									{__("Enter your post URL you want to advertise for")}
								</div>
							</div>
						  
							<div class="form-floating x-hidden" id="js_campaign-type-page">
								<select class="form-select" name="ads_page">
									<option value="none">{__("Select Page")}</option>
									{foreach $pages as $page}
										<option value="{$page['page_id']}">{__($page['page_title'])}</option>
									{/foreach}
								</select>
								<label class="form-label" for="ads_page">{__("Target Page")}</label>
								<div class="form-text">
									{__("Select one of your pages you want to advertise for")}
								</div>
							</div>
						  
							<div class="form-floating x-hidden" id="js_campaign-type-group">
								<select class="form-select" name="ads_group">
									<option value="none">{__("Select Group")}</option>
									{foreach $groups as $group}
										<option value="{$group['group_id']}">{__($group['group_title'])}</option>
									{/foreach}
								</select>
								<label class="form-label" for="ads_group">{__("Target Group")}</label>
								<div class="form-text">
									{__("Select one of your groups you want to advertise for")}
								</div>
							</div>
				  
							<div class="form-floating x-hidden" id="js_campaign-type-event">
								<select class="form-select" name="ads_event">
									<option value="none">{__("Select Event")}</option>
									{foreach $events as $event}
										<option value="{$event['event_id']}">{__($event['event_title'])}</option>
									{/foreach}
								</select>
								<label class="form-label" for="ads_event">{__("Target Event")}</label>
								<div class="form-text">
									{__("Select one of your events you want to advertise for")}
								</div>
							</div>
				  
							<div class="form-floating" id="js_campaign-placement">
								<select class="form-select" name="ads_placement">
									<option value="newsfeed">{__("Newsfeed")}</option>
									<option value="sidebar">{__("Sidebar")}</option>
								</select>
								<label class="form-label" for="ads_placement">{__("Ads Placement")}</label>
							</div>
				  
							<div class="form-group" id="js_campaign-image">
								<label class="form-label" for="ads_image">{__("Ads Image")}</label>
								<div class="x-image">
									<button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
									<div class="x-image-loader">
										<div class="progress x-progress">
											<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
										</div>
									</div>
									<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
									<input type="hidden" class="js_x-image-input" name="ads_image">
								</div>
								<div class="form-text">
									{__("The image of your ads, supported formats (JPG, PNG, GIF)")}
								</div>
							</div>
						</div>
						<!-- ads details -->
					</div>

					<!-- error -->
					<div class="alert alert-danger mt15 mb0 x-hidden"></div>
					<!-- error -->
					
					<hr class="hr-2">

					<div class="text-end">
						<button type="submit" class="btn btn-primary">
							{__("Publish")}
						</button>
					</div>
				</form>
			</div>
			<!-- new campaign -->

		{elseif $view == "edit"}

			<!-- edit campaign -->
			<div class="px-3 pt-3 headline-font fw-semibold h4 m-0">
				{__("Edit Campaign")}
			</div>
			
			<div class="p-3">
				<form class="js_ajax-forms" data-url="ads/campaign.php?do=edit&id={$campaign['campaign_id']}">
					{if $user->_data['user_wallet_balance'] == 0}
						<div class="bs-callout bs-callout-danger mt0">
							{__("Your current wallet credit is")}: <strong>{print_money($user->_data['user_wallet_balance']|number_format:2)}</strong> {__("You need to")} <a href="{$system['system_url']}/wallet">{__("Replenish your wallet credit")}</a>
						</div>
					{/if}

					{if $system['ads_approval_enabled']}
						<div class="bs-callout bs-callout-warning mt0">
							{__("Your campaign will need to be approved by admin before publishing")}
						</div>
					{/if}

					<div class="row">
						<!-- campaign details & target audience -->
						<div class="col-md-6 mb-3 mb-md-0">
							<!-- campaign details -->
							<div class="form-floating">
								<input type="text" class="form-control" name="campaign_title" value="{$campaign['campaign_title']}" placeholder=" ">
								<label class="form-label" for="campaign_title">{__("Campaign Title")}</label>
								<div class="form-text">
									{__("Set a title for your campaign")}
								</div>
							</div>
							
							<div class="form-floating">
								<input type="datetime-local" class="form-control" name="campaign_start_date" value="{$campaign['campaign_start_date']}" placeholder=" ">
								<label class="form-label" for="campaign_start_date">{__("Campaign Start Date")}</label>
								<div class="form-text">
									{__("Set Campaign start datetime (UTC)")}
								</div>
							</div>
						  
							<div class="form-floating">
								<input type="datetime-local" class="form-control" name="campaign_end_date" value="{$campaign['campaign_end_date']}" placeholder=" ">
								<label class="form-label" for="campaign_end_date">{__("Campaign End Date")}</label>
								<div class="form-text">
									{__("Set Campaign end datetime (UTC)")}
								</div>
							</div>
						  
							<div class="form-floating">
								<input type="text" class="form-control" placeholder="0.00" min="1.00" max="1000" name="campaign_budget" value="{$campaign['campaign_budget']}">
								<label class="form-label" for="campaign_budget">{__("Campaign Budget")} ({$system['system_currency_symbol']})</label>
								<div class="form-text">
									{__("Set a budget for your campaign, campaign will be paused if reached its limit")}
								</div>
							</div>
						  
							<div class="form-floating">
								<select class="form-select" name="campaign_bidding">
									<option {if $campaign['campaign_bidding'] == "click"}selected{/if} value="click">{__("Pay Per Click")} ({print_money($system['ads_cost_click'])})</option>
									<option {if $campaign['campaign_bidding'] == "view"}selected{/if} value="view">{__("Pay Per View")} ({print_money($system['ads_cost_view'])})</option>
								</select>
								<label class="form-label" for="campaign_bidding">{__("Campaign Bidding")}</label>
							</div>
							<!-- campaign details -->

							<!-- target audience -->
							<div class="form-floating">
								<select class="form-select" multiple name="audience_countries[]" id="js_ads-audience-countries">
									{foreach $countries as $country}
										<option {if in_array($country['country_id'], $campaign['audience_countries'])}selected{/if} value="{$country['country_id']}">{$country['country_name']}</option>
									{/foreach}
								</select>
								<label class="form-label" for="audience_countries">{__("Audience Country")}</label>
							</div>
						  
							<div class="form-floating {if $system['genders_disabled']}x-hidden{/if}">
								<select class="form-select" name="audience_gender" id="js_ads-audience-gender">
									<option {if $campaign['audience_gender'] == "all"}selected{/if} value="all">{__("All")}</option>
									{foreach $genders as $gender}
										<option {if $campaign['audience_gender'] == $gender['gender_id']}selected{/if} value="{$gender['gender_id']}">{$gender['gender_name']}</option>
									{/foreach}
								</select>
								<label class="form-label" for="audience_gender">{__("Audience Gender")}</label>
							</div>
						  
							{if $system['relationship_info_enabled']}
								<div class="form-floating">
									<select class="form-select" name="audience_relationship" id="js_ads-audience-relationship">
										<option {if $campaign['audience_relationship'] == "all"}selected{/if} value="all">{__("All")}</option>
										<option {if $campaign['audience_relationship'] == "single"}selected{/if} value="single">{__("Single")}</option>
										<option {if $campaign['audience_relationship'] == "relationship"}selected{/if} value="relationship">{__("In a relationship")}</option>
										<option {if $campaign['audience_relationship'] == "married"}selected{/if} value="married">{__("Married")}</option>
										<option {if $campaign['audience_relationship'] == "complicated"}selected{/if} value="complicated">{__("It's complicated")}</option>
										<option {if $campaign['audience_relationship'] == "separated"}selected{/if} value="separated">{__("Separated")}</option>
										<option {if $campaign['audience_relationship'] == "divorced"}selected{/if} value="divorced">{__("Divorced")}</option>
										<option {if $campaign['audience_relationship'] == "widowed"}selected{/if} value="widowed">{__("Widowed")}</option>
									</select>
									<label class="form-label" for="audience_relationship">{__("Audience Relationship")}</label>
								</div>
							{/if}
							
							<div class="form-group">
								<label class="form-label" for="potential_reach">{__("Potential Reach")}</label>
								<div class="d-flex align-items-center justify-content-between gap-2">
									<div class="d-flex align-items-center gap-1">
										<span class="badge rounded-pill bg-success" id="js_ads-potential-reach">{$campaign['campaign_potential_reach']}</span> {__("People")}
									</div>
									<div class="flex-0 lh-1 x-hidden" id="js_ads-potential-reach-loader">
										<div class="spinner-border spinner-border-sm small opacity-50"></div>
									</div>
								</div>
							</div>
							<!-- target audience -->
						</div>
						<!-- campaign details & target audience -->

						<!-- ads details -->
						<div class="col-md-6">
							<div class="form-floating">
								<input type="text" class="form-control" name="ads_title" id="ads_title" value="{$campaign['ads_title']}" placeholder=" ">
								<label class="form-label" for="ads_title">{__("Ads Title")}</label>
								<div class="form-text">
									{__("Set a title for your ads")}
								</div>
							</div>
						  
							<div class="form-floating">
								<textarea class="form-control" name="ads_description" rows="6" placeholder=" ">{$campaign['ads_description']}</textarea>
								<label class="form-label" for="ads_description">{__("Ads Description")}</label>
								<div class="form-text">
									{__("Set a description for your ads (maximum 200 characters)")}
								</div>
							</div>
							
							<div class="form-floating">
								<select class="form-select" name="ads_type" id="js_campaign-type">
									<option {if $campaign['ads_type'] == "url"}selected{/if} value="url">{__("URL")}</option>
									<option {if $campaign['ads_type'] == "post"}selected{/if} value="post">{__("Post")}</option>
									<option {if $campaign['ads_type'] == "page"}selected{/if} value="page">{__("Page")}</option>
									<option {if $campaign['ads_type'] == "group"}selected{/if} value="group">{__("Group")}</option>
									<option {if $campaign['ads_type'] == "event"}selected{/if} value="event">{__("Event")}</option>
								</select>
								<label class="form-label" for="ads_type">{__("Advertise For")}</label>
								<div class="form-text">
									{__("You can advertise for a URL or one of your pages, groups or events")}
								</div>
							</div>
						  
							<div class="form-floating {if $campaign['ads_type'] != 'url'}x-hidden{/if}" id="js_campaign-type-url">
								<input type="text" class="form-control" name="ads_url" value="{$campaign['ads_url']}" placeholder=" ">
								<label class="form-label" for="ads_url">{__("Target URL")}</label>
								<div class="form-text">
									{__("Enter your URL you want to advertise for")}
								</div>
							</div>
							
							<div class="form-floating {if $campaign['ads_type'] != 'post'}x-hidden{/if}" id="js_campaign-type-post">
								<input type="text" class="form-control" name="ads_post_url" value="{$campaign['ads_post_url']}" placeholder=" ">
								<label class="form-label" for="ads_post_url">{__("Target post URL")}</label>
								<div class="form-text">
									{__("Enter your post URL you want to advertise for")}
								</div>
							</div>
						  
							<div class="form-floating {if $campaign['ads_type'] != 'page'}x-hidden{/if}" id="js_campaign-type-page">
								<select class="form-select" name="ads_page">
									<option value="none">{__("Select Page")}</option>
									{foreach $pages as $page}
										<option {if $campaign['ads_page'] == $page['page_id']}selected{/if} value="{$page['page_id']}">{__($page['page_title'])}</option>
									{/foreach}
								</select>
								<label class="form-label" for="ads_page">{__("Target Page")}</label>
								<div class="form-text">
									{__("Select one of your pages you want to advertise for")}
								</div>
							</div>
						  
							<div class="form-floating {if $campaign['ads_type'] != 'group'}x-hidden{/if}" id="js_campaign-type-group">
								<select class="form-select" name="ads_group">
									<option value="none">{__("Select Group")}</option>
									{foreach $groups as $group}
										<option {if $campaign['ads_group'] == $group['group_id']}selected{/if} value="{$group['group_id']}">{__($group['group_title'])}</option>
									{/foreach}
								</select>
								<label class="form-label" for="ads_group">{__("Target Group")}</label>
								<div class="form-text">
									{__("Select one of your groups you want to advertise for")}
								</div>
							</div>
						  
							<div class="form-floating {if $campaign['ads_type'] != 'event'}x-hidden{/if}" id="js_campaign-type-event">
								<select class="form-select" name="ads_event">
									<option value="none">{__("Select Event")}</option>
									{foreach $events as $event}
										<option {if $campaign['ads_event'] == $event['event_id']}selected{/if} value="{$event['event_id']}">{__($event['event_title'])}</option>
									{/foreach}
								</select>
								<label class="form-label" for="ads_event">{__("Target Event")}</label>
								<div class="form-text">
									{__("Select one of your events you want to advertise for")}
								</div>
							</div>
						  
							<div class="form-floating {if $campaign['ads_type'] == 'post'}x-hidden{/if}" id="js_campaign-placement">
								<select class="form-select" name="ads_placement">
									<option {if $campaign['ads_placement'] == "newsfeed"}selected{/if} value="newsfeed">{__("Newsfeed")}</option>
									<option {if $campaign['ads_placement'] == "sidebar"}selected{/if} value="sidebar">{__("Sidebar")}</option>
								</select>
								<label class="form-label" for="ads_placement">{__("Ads Placement")}</label>
							</div>
						  
							<div class="form-group {if $campaign['ads_type'] == 'post'}x-hidden{/if}" id="js_campaign-image">
								<label class="form-label" for="ads_image">{__("Ads Image")}</label>
								{if $campaign['ads_image'] == ''}
									<div class="x-image">
										<button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
										<div class="x-image-loader">
											<div class="progress x-progress">
												<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
											</div>
										</div>
										<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
										<input type="hidden" class="js_x-image-input" name="ads_image">
									</div>
								{else}
									<div class="x-image" style="background-image: url('{$system['system_uploads']}/{$campaign['ads_image']}')">
										<button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'></button>
										<div class="x-image-loader">
											<div class="progress x-progress">
												<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
											</div>
										</div>
										<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
										<input type="hidden" class="js_x-image-input" name="ads_image" value="{$campaign['ads_image']}">
									</div>
								{/if}
								<div class="form-text">
									{__("The image of your ads, supported formats (JPG, PNG, GIF)")}
								</div>
							</div>
						</div>
						<!-- ads details -->
					</div>

					<!-- success -->
					<div class="alert alert-success mt15 mb0 x-hidden"></div>
					<!-- success -->

					<!-- error -->
					<div class="alert alert-danger mt15 mb0 x-hidden"></div>
					<!-- error -->
					
					<hr class="hr-2">
					
					<div class="text-end">
						<button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
					</div>
				</form>
			</div>
			<!-- edit campaign -->

		{/if}
    </div>
    <!-- content panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}