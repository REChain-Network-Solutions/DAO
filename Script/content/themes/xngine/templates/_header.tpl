{if !$user->_logged_in}
	<body data-hash-tok="{$session_hash['token']}" data-hash-pos="{$session_hash['position']}" {if $system['theme_mode_night']}data-bs-theme="dark" {/if} class="{if $system['theme_mode_night']}night-mode{/if} visitor n_chat {if $page == 'index' && !$system['newsfeed_public']}index-body{/if}" {if $page == 'profile' && $system['system_profile_background_enabled'] && $profile['user_profile_background']}style="background: url({$profile['user_profile_background']}) fixed !important; background-size: 100% auto;" {/if}>
{else}
    <body data-hash-tok="{$session_hash['token']}" data-hash-pos="{$session_hash['position']}" data-chat-enabled="{$user->_data['user_chat_enabled']}" {if $system['theme_mode_night']}data-bs-theme="dark" {/if} class="{if $system['theme_mode_night']}night-mode{/if} {if !$system['chat_enabled'] || $user->_data['user_privacy_chat'] == "me"}n_chat{/if}{if $system['activation_enabled'] && !$system['activation_required'] && !$user->_data['user_activated']} n_activated{/if}{if !$system['system_live']} n_live{/if}" {if $page == 'profile' && $system['system_profile_background_enabled'] && $profile['user_profile_background']}style="background: url({$profile['user_profile_background']}) fixed !important; background-size: 100% auto;" {/if} {if $url}onload="initialize_scraper()" {/if}>
    {/if}
		<!-- main wrapper -->
		<div class="main-wrapper">
			{if $user->_logged_in && $system['activation_enabled'] && !$system['activation_required'] && !$user->_data['user_activated']}
				<!-- top-bar -->
				<div class="top-bar position-fixed text-dark">
					<div class="{if $system['fluid_design']}container-fluid{else}container{/if}">
						<div class="row">
							<div class="col-sm-7 d-none d-sm-block">
								{if $system['activation_type'] == "email"}
									{__("Please go to")} <span class="main fw-medium">{$user->_data['user_email']}</span> {__("to complete the activation process")}.
								{else}
									{__("Please check the SMS on your phone")} <strong>{$user->_data['user_phone']}</strong> {__("to complete the activation process")}.
								{/if}
							</div>
							<div class="col-sm-5 text-md-end">
								{if $system['activation_type'] == "email"}
									<span class="btn btn-main btn-sm" data-toggle="modal" data-url="core/activation_email_resend.php">
										{__("Resend Verification Email")}
									</span>
									<span class="mx-1"></span>
									<span class="btn btn-main btn-sm" data-toggle="modal" data-url="#activation-email-reset">
										{__("Change Email")}
									</span>
								{else}
									<span class="btn btn-main btn-sm" data-toggle="modal" data-url="#activation-phone">{__("Enter Code")}</span>
									{if $user->_data['user_phone']}
										<span class="mx-1"></span>
										<span class="btn btn-main btn-sm" data-toggle="modal" data-url="core/activation_phone_resend.php">
											{__("Resend SMS")}
										</span>
									{/if}
									<span class="mx-1"></span>
									<span class="btn btn-main btn-sm" data-toggle="modal" data-url="#activation-phone-reset">
										{__("Change Phone Number")}
									</span>
								{/if}
							</div>
						</div>
					</div>
				</div>
				<!-- top-bar -->
			{/if}
			
			{if !$system['system_live']}
				<!-- top-bar alert-->
				<div class="top-bar position-fixed text-white danger">
					<div class="{if $system['fluid_design']}container-fluid{else}container{/if}">
						<i class="fa fa-exclamation-triangle fa-lg pr5"></i>
						<span class="d-none d-sm-inline">{__("The system has been shut down")}.</span>
						<span>{__("Turn it on from")}</span> <a href="{$system['system_url']}/admincp/settings">{__("Admin Panel")}</a>
					</div>
				</div>
				<!-- top-bar alert-->
			{/if}
			
			{if $user->_login_as}
				<!-- bottom-bar alert-->
				<div class="bottom-bar position-fixed">
					<div class="container rounded-4 text-white p-2 p-md-3 d-flex align-items-center gap-2 gap-md-3 logged-as-container">
						<span class="flex-0">{__("You are currently logged in as")} <a href="{$system['system_url']}/{$user->_data['user_name']}">{$user->_data['user_fullname']}</a></span>
						<button class="btn btn-sm btn-warning flex-0 js_login-as" data-handle="revoke">
							{__("Switch Back")}
						</button>
					</div>
				</div>
				<!-- bottom-bar alert-->
			{/if}

			<!-- container -->
			<div class="{if $page != "app_oauth" && $page != "sign" && $page != "reset"}{if !$user->_logged_in && !$system['newsfeed_public'] && $page == "index"}{else}{if $system['fluid_design']}container-fluid x_cf_p{else}{if $page == "admin"}container-fluid x_cf_p{else}container{/if}{/if}{/if}{/if}">
				<!-- search-wrapper -->
				{if $page != "app_oauth" && $page != "sign" && $page != "reset"}
					{if !$user->_logged_in && !$system['newsfeed_public'] && $page == "index"}
					{else}
						{if $user->_logged_in || (!$user->_logged_in && $system['system_public']) }
							<div class="w-100 pe-none search-wrapper-prnt d-flex align-items-center justify-content-end">
								{include file='_header.search.tpl'}
								<button type="button" class="d-none p-0 bg-transparent border-0 flex-0 pe-auto x_mobi_search" onclick="$('body').toggleClass('search_open')">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none" class="srch_ico"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"></path></svg>
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none" class="d-none srch_close_ico"><path d="M19.0005 4.99988L5.00049 18.9999M5.00049 4.99988L19.0005 18.9999" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
								</button>
							</div>
						{/if}
					{/if}
				{/if}
				<!-- search-wrapper -->

				<!-- row -->
				<div class="row m-0">
					<!-- main-header -->
					{if $page != "app_oauth" && $page != "sign" && $page != "reset"}
						{if $page != "index" || ($user->_logged_in || $system['newsfeed_public'])}
						<div class="p-0 flex-0 x-sidebar-width">
							<div class="position-fixed h-100 x-sidebar-fixed">
								<div class="px-2 d-flex flex-column justify-content-between h-100 x-sidebar">
									<div class="position-relative main-header">
										<!-- logo-wrapper -->
										<div class="position-relative overflow-hidden logo-wrapper">
											<!-- logo -->
											<a href="{$system['system_url']}" class="position-relative d-inline-block main_bg_half logo">
												{if $system['system_logo']}
													<img class="logo-light x_logo_pc" src="{$system['system_uploads']}/{$system['system_logo']}" alt="{__($system['system_title'])}">
													{if !$system['system_logo_dark']}
														<img class="logo-dark x_logo_pc" src="{$system['system_uploads']}/{$system['system_logo']}" alt="{__($system['system_title'])}">
													{else}
														<img class="logo-dark x_logo_pc" src="{$system['system_uploads']}/{$system['system_logo_dark']}" alt="{$system['system_title']}">
													{/if}
													
													{if $system['system_favicon_default']}
														<img class="x_logo_mobi" src="{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png" alt="{__($system['system_title'])}"/>
													{elseif $system['system_favicon']}
														<img class="x_logo_mobi" src="{$system['system_uploads']}/{$system['system_favicon']}" alt="{__($system['system_title'])}"/>
													{/if}
												{else}
													{__($system['system_title'])}
												{/if}
											</a>
											<!-- logo -->
										</div>
										<!-- logo-wrapper -->
										
										<div class="x_sidebar_links">
											<a href="{$system['system_url']}" class="d-block py-1 body-color x_side_links {if $page == "index" && $view == ""}fw-semibold main{/if}">
												<div class="d-inline-flex align-items-center position-relative main_bg_half">
													<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="27" height="27" color="currentColor" fill="none">
														{if $page == "index" && $view == ""}
															<path d="M9.52623 2.04919C10.352 1.54964 11.1263 1.25 12.0001 1.25C12.8739 1.25 13.6481 1.54964 14.4739 2.04919C15.2737 2.53302 16.1878 3.2468 17.3352 4.14286L18.5185 5.06682C19.8945 6.14061 20.7839 6.83466 21.2676 7.82756C21.7511 8.82002 21.7507 9.95006 21.7501 11.6999L21.7501 14.033V14.033C21.7501 15.8785 21.7501 17.3396 21.597 18.4829C21.4395 19.6591 21.1077 20.6109 20.3599 21.3617C19.1696 22.5568 18.2059 22.7147 15.7782 22.7499C15.5774 22.7528 15.3838 22.6751 15.2408 22.5342C15.0978 22.3932 15.0173 22.2008 15.0173 22V18.0057C15.0173 17.5295 15.0169 17.2099 15 16.9624C15 16.1323 14.2672 15.773 13.8105 15.773C13.5631 15.7561 12.4763 15.7557 12.0001 15.7557C11.2738 15.7557 10.4542 15.7561 10.2067 15.773C9.74992 15.773 9.01729 16.1278 9.01729 16.9624C9.00041 17.2099 9 17.5295 9 18.0057V22C9 22.2008 8.91948 22.3932 8.77646 22.5342C8.63345 22.6751 8.43989 22.7528 8.23911 22.7499C5.81142 22.7147 4.83057 22.5568 3.64026 21.3617C2.89243 20.6109 2.56067 19.6591 2.40316 18.4829C2.25005 17.3395 2.25006 15.8784 2.25008 14.033L2.25008 11.8846L2.25004 11.6999C2.24947 9.95007 2.2491 8.82002 2.73256 7.82756C3.21624 6.83466 4.10564 6.14061 5.48164 5.06683L6.66493 4.14286L6.66494 4.14285C7.81241 3.24679 8.72645 2.53302 9.52623 2.04919Z" fill="currentColor"/>
														{else}
															<path d="M7.08848 4.76364L6.08847 5.54453C4.57182 6.72887 3.81348 7.32105 3.40674 8.15601C3 8.99097 3 9.95552 3 11.8846V13.9767C3 17.763 3 19.6562 4.17157 20.8325C5.11466 21.7793 6.52043 21.964 9 22V18.0057C9 17.0738 9 16.6078 9.15224 16.2403C9.35523 15.7502 9.74458 15.3609 10.2346 15.1579C10.6022 15.0057 11.0681 15.0057 12 15.0057C12.9319 15.0057 13.3978 15.0057 13.7654 15.1579C14.2554 15.3609 14.6448 15.7502 14.8478 16.2403C15 16.6078 15 17.0738 15 18.0057V22C17.4796 21.964 18.8853 21.7793 19.8284 20.8325C21 19.6562 21 17.763 21 13.9767V11.8846C21 9.95552 21 8.99097 20.5933 8.15601C20.1865 7.32105 19.4282 6.72887 17.9115 5.54453L16.9115 4.76364C14.5521 2.92121 13.3724 2 12 2C10.6276 2 9.44787 2.92121 7.08848 4.76364Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round" />
														{/if}
													</svg>
													<span class="text">{__("Home")}</span>
												</div>
											</a>
											{if $user->_logged_in}
												<!-- messages -->
												{if $system['chat_enabled'] && $user->_data['user_privacy_chat'] != "me"}
													{include file='_header.messages.tpl'}
												{/if}
												<!-- messages -->

												<!-- notifications -->
												{include file='_header.notifications.tpl'}
												<!-- notifications -->
												
												<!-- friend requests -->
												{if $system['friends_enabled']}
													{include file='_header.friend_requests.tpl'}
												{/if}
												<!-- friend requests -->
											{/if}
											
											<!-- side panel -->
											{include file='_sidebar.tpl'}
											<!-- side panel -->
											
											{if $user->_logged_in}
												{if $user->_data['can_publish_posts'] || $user->_data['can_go_live'] || $user->_data['can_add_stories'] || $user->_data['can_write_blogs'] || $system['market_enabled'] || $user->_data['can_raise_funding'] || $user->_data['can_create_ads'] || $system['pages_enabled'] || $system['groups_enabled'] || $system['events_enabled']}
													<!-- add -->
													<div class="dropup my-3 x_side_create">
														<a class="btn btn-main w-100 dropdownMenuButton" href="#" data-bs-toggle="dropdown">
															<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none" class="x-hidden"><path d="M15.2141 5.98239L16.6158 4.58063C17.39 3.80646 18.6452 3.80646 19.4194 4.58063C20.1935 5.3548 20.1935 6.60998 19.4194 7.38415L18.0176 8.78591M15.2141 5.98239L6.98023 14.2163C5.93493 15.2616 5.41226 15.7842 5.05637 16.4211C4.70047 17.058 4.3424 18.5619 4 20C5.43809 19.6576 6.94199 19.2995 7.57889 18.9436C8.21579 18.5877 8.73844 18.0651 9.78375 17.0198L18.0176 8.78591M15.2141 5.98239L18.0176 8.78591" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M11 20H17" stroke="currentColor" stroke-width="2" stroke-linecap="round" /></svg>
															<span>{__("Create")}</span>
														</a>
														<div class="dropdown-menu x_side_create_menu">
															{if $user->_data['can_publish_posts']}
															  <div class="dropdown-item pointer" data-toggle="modal" data-url="posts/publisher.php">
																<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M15.2141 5.98239L16.6158 4.58063C17.39 3.80646 18.6452 3.80646 19.4194 4.58063C20.1935 5.3548 20.1935 6.60998 19.4194 7.38415L18.0176 8.78591M15.2141 5.98239L6.98023 14.2163C5.93493 15.2616 5.41226 15.7842 5.05637 16.4211C4.70047 17.058 4.3424 18.5619 4 20C5.43809 19.6576 6.94199 19.2995 7.57889 18.9436C8.21579 18.5877 8.73844 18.0651 9.78375 17.0198L18.0176 8.78591M15.2141 5.98239L18.0176 8.78591" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M11 20H17" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
																{__("Create Post")}
															  </div>
															{/if}
															{if $user->_data['can_go_live']}
															  <a class="dropdown-item" href="{$system['system_url']}/live">
																<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><circle cx="12" cy="12" r="2" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></circle><path d="M7.5 8C6.5 9 6 10.5 6 12C6 13.5 6.5 15 7.5 16" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M4.5 6C3 7.5 2 9.5 2 12C2 14.5 3 16.5 4.5 18" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M16.5 16C17.5 15 18 13.5 18 12C18 10.5 17.5 9 16.5 8" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M19.5 18C21 16.5 22 14.5 22 12C22 9.5 21 7.5 19.5 6" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
																{__("Create Live")}
															  </a>
															{/if}
															{if $user->_data['can_add_stories']}
															  <div class="dropdown-item pointer" data-toggle="modal" data-url="posts/story.php?do=create">
																<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M12 22C6.47715 22 2.00004 17.5228 2.00004 12C2.00004 6.47715 6.47719 2 12 2C16.4777 2 20.2257 4.94289 21.5 9H19" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M12 8V12L14 14" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M21.9551 13C21.9848 12.6709 22 12.3373 22 12M15 22C15.3416 21.8876 15.6753 21.7564 16 21.6078M20.7906 17C20.9835 16.6284 21.1555 16.2433 21.305 15.8462M18.1925 20.2292C18.5369 19.9441 18.8631 19.6358 19.1688 19.3065" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
																{__("Create Story")}
															  </div>
															{/if}
															{if $user->_data['can_write_blogs']}
															  <a class="dropdown-item" href="{$system['system_url']}/blogs/new">
																<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M10.5 8H18.5M10.5 12H13M18.5 12H16M10.5 16H13M18.5 16H16" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M7 7.5H6C4.11438 7.5 3.17157 7.5 2.58579 8.08579C2 8.67157 2 9.61438 2 11.5V18C2 19.3807 3.11929 20.5 4.5 20.5C5.88071 20.5 7 19.3807 7 18V7.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M16 3.5H11C10.07 3.5 9.60504 3.5 9.22354 3.60222C8.18827 3.87962 7.37962 4.68827 7.10222 5.72354C7 6.10504 7 6.57003 7 7.5V18C7 19.3807 5.88071 20.5 4.5 20.5H16C18.8284 20.5 20.2426 20.5 21.1213 19.6213C22 18.7426 22 17.3284 22 14.5V9.5C22 6.67157 22 5.25736 21.1213 4.37868C20.2426 3.5 18.8284 3.5 16 3.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
																{__("Create Blog")}
															  </a>
															{/if}
															{if $system['market_enabled']}
															  <div class="dropdown-item pointer" data-toggle="modal" data-url="posts/product.php?do=create">
																<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3 10.5V15C3 17.8284 3 19.2426 3.87868 20.1213C4.75736 21 6.17157 21 9 21H12.5M21 10.5V12.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M7 17H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M15 18.5H22M18.5 22V15" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M17.7947 2.00254L6.14885 2.03002C4.41069 1.94542 3.96502 3.2116 3.96502 3.83056C3.96502 4.38414 3.88957 5.19117 2.82426 6.70798C1.75895 8.22478 1.839 8.67537 2.43973 9.72544C2.9383 10.5969 4.20643 10.9374 4.86764 10.9946C6.96785 11.0398 7.98968 9.32381 7.98968 8.1178C9.03154 11.1481 11.9946 11.1481 13.3148 10.8016C14.6376 10.4545 15.7707 9.2118 16.0381 8.1178C16.194 9.47735 16.6672 10.2707 18.0653 10.8158C19.5135 11.3805 20.7589 10.5174 21.3838 9.9642C22.0087 9.41096 22.4097 8.18278 21.2958 6.83288C20.5276 5.90195 20.2074 5.02494 20.1023 4.11599C20.0413 3.58931 19.9878 3.02336 19.5961 2.66323C19.0238 2.13691 18.2026 1.97722 17.7947 2.00254Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
																{__("Create Product")}
															  </div>
															{/if}
															{if $user->_data['can_raise_funding']}
															  <div class="dropdown-item pointer" data-toggle="modal" data-url="posts/funding.php?do=create">
																<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.5 16V12.0059C19.5 10.5195 19.5 9.77627 19.2444 9.09603C18.9888 8.4158 18.4994 7.85648 17.5206 6.73784L16 5H8L6.47939 6.73784C5.50058 7.85648 5.01118 8.4158 4.75559 9.09603C4.5 9.77627 4.5 10.5195 4.5 12.0059V16C4.5 18.8284 4.5 20.2426 5.37868 21.1213C6.25736 22 7.67157 22 10.5 22H13.5C16.3284 22 17.7426 22 18.6213 21.1213C19.5 20.2426 19.5 18.8284 19.5 16Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M9.5 15.6831C9.5 16.9125 11.3539 17.9204 13.1325 17.3553C14.9112 16.7901 14.6497 15.1248 14.0463 14.4708C13.4429 13.8169 12.555 13.9265 11.5399 13.8751C9.25873 13.7594 9.09769 11.5722 10.9447 10.7069C12.2997 10.072 14.0379 10.8862 14.2381 12M11.971 9.5V10.4777M11.971 17.7204V18.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M7.5 2H16.5C16.9659 2 17.1989 2 17.3827 2.07612C17.6277 2.17761 17.8224 2.37229 17.9239 2.61732C18 2.80109 18 3.03406 18 3.5C18 3.96594 18 4.19891 17.9239 4.38268C17.8224 4.62771 17.6277 4.82239 17.3827 4.92388C17.1989 5 16.9659 5 16.5 5H7.5C7.03406 5 6.80109 5 6.61732 4.92388C6.37229 4.82239 6.17761 4.62771 6.07612 4.38268C6 4.19891 6 3.96594 6 3.5C6 3.03406 6 2.80109 6.07612 2.61732C6.17761 2.37229 6.37229 2.17761 6.61732 2.07612C6.80109 2 7.03406 2 7.5 2Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
																{__("Create Funding")}
															  </div>
															{/if}
															{if $user->_data['can_create_ads']}
															  <a class="dropdown-item" href="{$system['system_url']}/ads/new">
																<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M14.9263 2.91103L8.27352 6.10452C7.76151 6.35029 7.21443 6.41187 6.65675 6.28693C6.29177 6.20517 6.10926 6.16429 5.9623 6.14751C4.13743 5.93912 3 7.38342 3 9.04427V9.95573C3 11.6166 4.13743 13.0609 5.9623 12.8525C6.10926 12.8357 6.29178 12.7948 6.65675 12.7131C7.21443 12.5881 7.76151 12.6497 8.27352 12.8955L14.9263 16.089C16.4534 16.8221 17.217 17.1886 18.0684 16.9029C18.9197 16.6172 19.2119 16.0041 19.7964 14.778C21.4012 11.4112 21.4012 7.58885 19.7964 4.22196C19.2119 2.99586 18.9197 2.38281 18.0684 2.0971C17.217 1.8114 16.4534 2.17794 14.9263 2.91103Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M11.4581 20.7709L9.96674 22C6.60515 19.3339 7.01583 18.0625 7.01583 13H8.14966C8.60978 15.8609 9.69512 17.216 11.1927 18.197C12.1152 18.8012 12.3054 20.0725 11.4581 20.7709Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M7.5 12.5V6.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
																{__("Create Ads")}
															  </a>
															{/if}
															{if $system['pages_enabled']}
															  <div class="dropdown-item pointer" data-toggle="modal" data-url="modules/add.php?type=page">
																<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M15.8785 3L10.2827 3C7.32099 3 5.84015 3 4.92007 3.87868C4 4.75736 4 6.17157 4 9L4.10619 15L15.8785 15C18.1016 15 19.2131 15 19.6847 14.4255C19.8152 14.2666 19.9108 14.0841 19.9656 13.889C20.1639 13.184 19.497 12.3348 18.1631 10.6364L18.1631 10.6364C17.6083 9.92985 17.3309 9.57659 17.2814 9.1751C17.2671 9.05877 17.2671 8.94123 17.2814 8.8249C17.3309 8.42341 17.6083 8.07015 18.1631 7.36364L18.1631 7.36364C19.497 5.66521 20.1639 4.816 19.9656 4.11098C19.9108 3.91591 19.8152 3.73342 19.6847 3.57447C19.2131 3 18.1016 3 15.8785 3L15.8785 3Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M4 21L4 8" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
																{__("Create Page")}
															  </div>
															{/if}
															{if $system['groups_enabled']}
															  <div class="dropdown-item pointer" data-toggle="modal" data-url="modules/add.php?type=group">
																<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7.5 19.5C7.5 18.5344 7.82853 17.5576 8.63092 17.0204C9.59321 16.3761 10.7524 16 12 16C13.2476 16 14.4068 16.3761 15.3691 17.0204C16.1715 17.5576 16.5 18.5344 16.5 19.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><circle cx="12" cy="11" r="2.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></circle><path d="M17.5 11C18.6101 11 19.6415 11.3769 20.4974 12.0224C21.2229 12.5696 21.5 13.4951 21.5 14.4038V14.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><circle cx="17.5" cy="6.5" r="2" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></circle><path d="M6.5 11C5.38987 11 4.35846 11.3769 3.50256 12.0224C2.77706 12.5696 2.5 13.4951 2.5 14.4038V14.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><circle cx="6.5" cy="6.5" r="2" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></circle></svg>
																{__("Create Group")}
															  </div>
															{/if}
															{if $system['events_enabled']}
															  <div class="dropdown-item pointer" data-toggle="modal" data-url="modules/add.php?type=event">
																<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M18 2V4M6 2V4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M11.9955 13H12.0045M11.9955 17H12.0045M15.991 13H16M8 13H8.00897M8 17H8.00897" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M3.5 8H20.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M2.5 12.2432C2.5 7.88594 2.5 5.70728 3.75212 4.35364C5.00424 3 7.01949 3 11.05 3H12.95C16.9805 3 18.9958 3 20.2479 4.35364C21.5 5.70728 21.5 7.88594 21.5 12.2432V12.7568C21.5 17.1141 21.5 19.2927 20.2479 20.6464C18.9958 22 16.9805 22 12.95 22H11.05C7.01949 22 5.00424 22 3.75212 20.6464C2.5 19.2927 2.5 17.1141 2.5 12.7568V12.2432Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M3 8H21" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
																{__("Create Event")}
															  </div>
															{/if}
														</div>
													</div>
													<!-- add -->
												{/if}
											{/if}
										</div>
									</div>
						
									<!-- user-menu -->
									<div class="py-1 x_user_mobi_menu">
										<div class="dropup my-2">
											{include file='_user_menu.tpl'}
										</div>
									</div>
									<!-- user-menu -->
								</div>
							</div>
						</div>
						{/if}
					{/if}
					<!-- main-header -->

					<!-- right column -->
					<div class="p-0 flex-0 {if $page != "app_oauth" && $page != "sign" && $page != "reset"}{if !$user->_logged_in && !$system['newsfeed_public'] && $page == "index"}{else}x-content-width{/if}{/if}">
						<!-- ads -->
						{include file='_ads.tpl' _ads=$ads_master['header'] _master=true}
						<!-- ads -->