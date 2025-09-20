{if $user->_data['can_publish_posts']}
	{if $system['verification_for_posts'] && !$user->_data['user_verified']}
		<div class="px-3 side_item_list x_announcement">
			<div class="mb-2 mx-n1 text-danger">
				<svg width="34" height="34" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12 2C6.49 2 2 6.49 2 12C2 17.51 6.49 22 12 22C17.51 22 22 17.51 22 12C22 6.49 17.51 2 12 2ZM11.25 8C11.25 7.59 11.59 7.25 12 7.25C12.41 7.25 12.75 7.59 12.75 8V13C12.75 13.41 12.41 13.75 12 13.75C11.59 13.75 11.25 13.41 11.25 13V8ZM12.92 16.38C12.87 16.51 12.8 16.61 12.71 16.71C12.61 16.8 12.5 16.87 12.38 16.92C12.26 16.97 12.13 17 12 17C11.87 17 11.74 16.97 11.62 16.92C11.5 16.87 11.39 16.8 11.29 16.71C11.2 16.61 11.13 16.51 11.08 16.38C11.03 16.26 11 16.13 11 16C11 15.87 11.03 15.74 11.08 15.62C11.13 15.5 11.2 15.39 11.29 15.29C11.39 15.2 11.5 15.13 11.62 15.08C11.86 14.98 12.14 14.98 12.38 15.08C12.5 15.13 12.61 15.2 12.71 15.29C12.8 15.39 12.87 15.5 12.92 15.62C12.97 15.74 13 15.87 13 16C13 16.13 12.97 16.26 12.92 16.38Z" fill="currentColor"></path></svg>
			</div>
			<div class="text">
				<div class="fw-semibold text-danger">{__("Account Verification Required")}</div>
				<div class="mt-1 mb-2">{__("To publish posts your account must be verified")}.</div>
				<a href="{$system['system_url']}/settings/verification" class="btn btn-main">{__("Verify Now")}</a>
			</div>
		</div>
	{else}
		<div id="publisher-wapper{if $_modal_mode}-modal{/if}">
			<div class="publisher-overlay fixed-top"></div>

			<div class="x-form bg-white publisher" data-handle="{$_handle}" {if $_id}data-id="{$_id}" {/if} {if $_modal_mode}data-modal-mode="true" {/if} id="publisher-box">

				{if $_modal_mode}
					<!-- publisher close -->
					<div class="publisher-close position-absolute btn btn-gray p-1">
						<button type="button" class="btn-close js_close-publisher-modal"></button>
					</div>
					<!-- publisher close -->
				{/if}

				<!-- publisher loader -->
				<div class="publisher-loader position-absolute w-100 overflow-hidden main_bg_half x_progress">
					<div class="indeterminate"></div>
				</div>
				<!-- publisher loader -->
				
				<div class="side_item_list px-3 pt-3">
					<div class="d-flex align-items-start justify-content-between x_user_info gap-10">
						{if $_handle == "page" || $_post_as_page}
							<img class="publisher-avatar rounded-circle position-relative flex-0" src="{$_avatar}">
						{else}
							<img class="publisher-avatar rounded-circle position-relative flex-0" src="{$user->_data['user_picture']}">
						{/if}
						<div class="flex-1">
							<!-- privacy -->
							<div class="publisher-slider">
								{if $_privacy}
									{if $system['newsfeed_source'] == "default"}
										{if $system['default_privacy'] == "me"}
											<div class="btn-group js_publisher-privacy" data-value="me">
												<button type="button" class="btn btn-sm btn-gray px-2 d-inline-block dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
													<i class="btn-group-icon fa fa-user-lock"></i>&nbsp;&nbsp;<span class="btn-group-text">{__("Only Me")}</span>
												</button>
												<div class="dropdown-menu">
													<div class="dropdown-item pointer" data-value="public">
														<i class="fa fa-globe-americas flex-0"></i>{__("Public")}
													</div>
													<div class="dropdown-item pointer" data-value="friends">
														<i class="fa fa-user-friends flex-0"></i>{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
													</div>
													{if $_handle == 'me'}
														<div class="dropdown-item pointer" data-value="me">
															<i class="fa fa-user-lock flex-0"></i>{__("Only Me")}
														</div>
													{/if}
												</div>
											</div>
										{elseif $system['default_privacy'] == "friends"}
											<div class="btn-group js_publisher-privacy" data-value="friends">
												<button type="button" class="btn btn-sm btn-gray px-2 d-inline-block dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
													<i class="btn-group-icon fa fa-user-friends"></i>&nbsp;&nbsp;<span class="btn-group-text">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</span>
												</button>
												<div class="dropdown-menu">
													<div class="dropdown-item pointer" data-value="public">
														<i class="fa fa-globe-americas flex-0"></i>{__("Public")}
													</div>
													<div class="dropdown-item pointer" data-value="friends">
														<i class="fa fa-user-friends flex-0"></i>{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
													</div>
													{if $_handle == 'me'}
														<div class="dropdown-item pointer" data-value="me">
															<i class="fa fa-user-lock flex-0"></i>{__("Only Me")}
														</div>
													{/if}
												</div>
											</div>
										{else}
											<div class="btn-group js_publisher-privacy" data-value="public">
												<button type="button" class="btn btn-sm btn-gray px-2 d-inline-block dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
													<i class="btn-group-icon fa fa-globe-americas"></i>&nbsp;&nbsp;<span class="btn-group-text">{__("Public")}</span>
												</button>
												<div class="dropdown-menu">
													<div class="dropdown-item pointer" data-value="public">
														<i class="fa fa-globe-americas flex-0"></i>{__("Public")}
													</div>
													<div class="dropdown-item pointer" data-value="friends">
														<i class="fa fa-user-friends flex-0"></i>{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
													</div>
													{if $_handle == 'me'}
														<div class="dropdown-item pointer" data-value="me">
															<i class="fa fa-user-lock flex-0"></i>{__("Only Me")}
														</div>
													{/if}
												</div>
											</div>
										{/if}

										{if $_handle == "me" && $system['anonymous_mode']}
											<button disabled="disabled" type="button" class="btn btn-sm btn-gray px-2 x-hidden js_publisher-privacy-public">
												<i class="btn-group-icon fa fa-globe-americas"></i>&nbsp;&nbsp;<span class="btn-group-text">{__("Public")}</span>
											</button>
										{/if}
									{/if}
								{/if}
							</div>
							<!-- privacy -->
							
							<!-- publisher-message -->
							<div class="publisher-message position-relative">
								<div class="colored-text-wrapper">
									<textarea {if $_modal_mode}autofocus{/if} dir="auto" class="js_autosize js_mention js_publisher-scraper mt-2 w-100 p-0 border-0 bg-transparent" data-init-placeholder='{__("What is on your mind? #Hashtag.. @Mention.. Link..")}' placeholder='{__("What is on your mind? #Hashtag.. @Mention.. Link..")}'>{if $url}{$url}{/if}</textarea>
								</div>
							</div>
							<!-- publisher-message -->
							
							<!-- publisher-slider -->
							<div class="publisher-slider">
								<!-- publisher scraper -->
								<div class="publisher-scraper position-relative"></div>
								<!-- publisher scraper -->

								<!-- post attachments (photos) -->
								<div class="publisher-attachments attachments clearfix x-hidden js_attachments-photos"></div>
								<!-- post attachments -->

								<!-- post attachments (reels) -->
								<div class="publisher-attachments attachments clearfix x-hidden js_attachments-reel"></div>
								<!-- post attachments -->

								<!-- post attachments (videos) -->
								<div class="publisher-attachments attachments clearfix x-hidden js_attachments-video"></div>
								<!-- post attachments -->

								<!-- post attachments (audios) -->
								<div class="publisher-attachments attachments clearfix x-hidden js_attachments-audio"></div>
								<!-- post attachments -->

								<!-- post attachments (files) -->
								<div class="publisher-attachments attachments clearfix x-hidden js_attachments-file"></div>
								<!-- post attachments -->
								
								<!-- post album -->
								<div class="publisher-meta" data-meta="album">
									<input type="text" placeholder='{__("Album title")}'>
								</div>
								<!-- post album -->
								
								<!-- post feelings -->
								<div class="publisher-meta" data-meta="feelings">
									<div class="d-flex align-items-center gap-3 publisher-meta-feelings">
										<div class="main_bg_half position-relative pointer" id="feelings-menu-toggle" data-init-text='{__("What are you doing?")}'>{__("What are you doing?")}</div>
										<div id="feelings-data" style="display: none">
											<input type="text" class="py-0 px-1" placeholder='{__("What are you doing?")}'>
											<span class="pointer"></span>
										</div>
									</div>
									<div id="feelings-menu" class="dropdown-menu w-100 feelings-list">
										<div class="js_scroller">
											{foreach $feelings as $feeling}
												<div class="feeling-item js_feelings-add dropdown-item pointer" data-action="{$feeling['action']}" data-placeholder="{__($feeling['placeholder'])}">
													<div class="icon flex-0">
														<i class="twa m-0 align-middle twa-{$feeling['icon']}"></i>
													</div>
													<div class="data">
														{__($feeling['text'])}
													</div>
												</div>
											{/foreach}
										</div>
									</div>
									<div id="feelings-types" class="dropdown-menu w-100 feelings-list">
										<div class="js_scroller">
											{foreach $feelings_types as $type}
												<div class="feeling-item js_feelings-type dropdown-item pointer" data-type="{$type['action']}" data-icon="{$type['icon']}">
													<div class="icon flex-0">
														<i class="twa m-0 align-middle twa-{$type['icon']}"></i>
													</div>
													<div class="data">
														{__($type['text'])}
													</div>
												</div>
											{/foreach}
										</div>
									</div>
								</div>
								<!-- post feelings -->
								
								<!-- post location -->
								<div class="publisher-meta" data-meta="location">
									<input class="js_geocomplete" type="text" placeholder='{__("Where are you?")}'>
								</div>
								<!-- post location -->
								
								<!-- post colored -->
								<div class="publisher-meta" data-meta="colored">
									{foreach $colored_patterns as $pattern}
										<div class="d-inline-block pointer rounded-circle p-0 colored-pattern-item js_publisher-pattern" onclick="$('.publisher-message.colored textarea').css('height', 'auto');" data-id="{$pattern['pattern_id']}" data-type="{$pattern['type']}" data-background-image="{$pattern['background_image']}" data-background-color-1="{$pattern['background_color_1']}" data-background-color-2="{$pattern['background_color_2']}" data-text-color="{$pattern['text_color']}" {if $pattern['type'] == "color"} style="background-image: linear-gradient(45deg, {$pattern['background_color_1']}, {$pattern['background_color_2']});" {else} style="background-image: url({$system['system_uploads']}/{$pattern['background_image']})" {/if}></div>
									{/foreach}
								</div>
								<!-- post colored -->
								
								<!-- post voice notes -->
								<div class="publisher-meta" data-meta="voice_notes">
									<div class="voice-recording-wrapper" data-handle="publisher">
										<!-- processing message -->
										<div class="x-hidden small fw-medium js_voice-processing-message">
											<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20"><path d="M0 0h24v24H0V0z" fill="none"></path><path fill="#ef4c5d" d="M8 18c.55 0 1-.45 1-1V7c0-.55-.45-1-1-1s-1 .45-1 1v10c0 .55.45 1 1 1zm4 4c.55 0 1-.45 1-1V3c0-.55-.45-1-1-1s-1 .45-1 1v18c0 .55.45 1 1 1zm-8-8c.55 0 1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1v2c0 .55.45 1 1 1zm12 4c.55 0 1-.45 1-1V7c0-.55-.45-1-1-1s-1 .45-1 1v10c0 .55.45 1 1 1zm3-7v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1z"></path></svg> {__("Processing")} {__("Voice Notes")}<span class="loading-dots"></span>
										</div>
										<!-- processing message -->

										<!-- success message -->
										<div class="x-hidden js_voice-success-message">
											<div class="d-flex align-items-center justify-content-between gap-3">
												<div class="d-flex align-items-center small fw-medium gap-1">
													<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20" class="flex-0"><path d="M0 0h24v24H0V0z" fill="none"/><path fill="#1bc3bb" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM9.29 16.29L5.7 12.7c-.39-.39-.39-1.02 0-1.41.39-.39 1.02-.39 1.41 0L10 14.17l6.88-6.88c.39-.39 1.02-.39 1.41 0 .39.39.39 1.02 0 1.41l-7.59 7.59c-.38.39-1.02.39-1.41 0z"/></svg> {__("Voice note recorded successfully")}
												</div>
												<button type="button" class="btn btn-voice-clear js_voice-remove p-0 text-danger text-opacity-75 flex-0">
													<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M19.5825 15.6564C19.5058 16.9096 19.4449 17.9041 19.3202 18.6984C19.1922 19.5131 18.9874 20.1915 18.5777 20.7849C18.2029 21.3278 17.7204 21.786 17.1608 22.1303C16.5491 22.5067 15.8661 22.6713 15.0531 22.75L8.92739 22.7499C8.1135 22.671 7.42972 22.5061 6.8176 22.129C6.25763 21.7841 5.77494 21.3251 5.40028 20.7813C4.99073 20.1869 4.78656 19.5075 4.65957 18.6917C4.53574 17.8962 4.47623 16.9003 4.40122 15.6453L3.75 4.75H20.25L19.5825 15.6564ZM9.5 17.9609C9.08579 17.9609 8.75 17.6252 8.75 17.2109L8.75 11.2109C8.75 10.7967 9.08579 10.4609 9.5 10.4609C9.91421 10.4609 10.25 10.7967 10.25 11.2109L10.25 17.2109C10.25 17.6252 9.91421 17.9609 9.5 17.9609ZM15.25 11.2109C15.25 10.7967 14.9142 10.4609 14.5 10.4609C14.0858 10.4609 13.75 10.7967 13.75 11.2109V17.2109C13.75 17.6252 14.0858 17.9609 14.5 17.9609C14.9142 17.9609 15.25 17.6252 15.25 17.2109V11.2109Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13.3473 1.28277C13.9124 1.33331 14.4435 1.50576 14.8996 1.84591C15.2369 2.09748 15.4712 2.40542 15.6714 2.73893C15.8569 3.04798 16.0437 3.4333 16.2555 3.8704L16.6823 4.7507H21C21.5523 4.7507 22 5.19842 22 5.7507C22 6.30299 21.5523 6.7507 21 6.7507C14.9998 6.7507 9.00019 6.7507 3 6.7507C2.44772 6.7507 2 6.30299 2 5.7507C2 5.19842 2.44772 4.7507 3 4.7507H7.40976L7.76556 3.97016C7.97212 3.51696 8.15403 3.11782 8.33676 2.79754C8.53387 2.45207 8.76721 2.13237 9.10861 1.87046C9.57032 1.51626 10.1121 1.33669 10.6899 1.28409C11.1249 1.24449 11.5634 1.24994 12 1.25064C12.5108 1.25146 12.97 1.24902 13.3473 1.28277ZM9.60776 4.7507H14.4597C14.233 4.28331 14.088 3.98707 13.9566 3.7682C13.7643 3.44787 13.5339 3.30745 13.1691 3.27482C12.9098 3.25163 12.5719 3.2507 12.0345 3.2507C11.4837 3.2507 11.137 3.25166 10.8712 3.27585C10.4971 3.30991 10.2639 3.45568 10.0739 3.78866C9.94941 4.00687 9.81387 4.29897 9.60776 4.7507Z" fill="currentColor"/></svg>
												</button>
											</div>
										</div>
										<!-- success message -->

										<!-- start recording -->
										<div class="btn btn-voice-start btn-main btn-sm js_voice-start">
											<svg xmlns="http://www.w3.org/2000/svg" height="16" viewBox="0 0 24 24" width="16"><path fill="currentColor" d="M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3zm5.91-3c-.49 0-.9.36-.98.85C16.52 14.2 14.47 16 12 16s-4.52-1.8-4.93-4.15c-.08-.49-.49-.85-.98-.85-.61 0-1.09.54-1 1.14.49 3 2.89 5.35 5.91 5.78V20c0 .55.45 1 1 1s1-.45 1-1v-2.08c3.02-.43 5.42-2.78 5.91-5.78.1-.6-.39-1.14-1-1.14z"></path></svg> {__("Record")} {__("Voice Notes")}
										</div>
										<!-- start recording -->

										<!-- stop recording -->
										<div class="btn btn-voice-stop btn-danger btn-sm js_voice-stop" style="display: none">
											<svg xmlns="http://www.w3.org/2000/svg" height="18" viewBox="0 0 24 24" width="18"><path fill="currentColor" d="M8 6h8c1.1 0 2 .9 2 2v8c0 1.1-.9 2-2 2H8c-1.1 0-2-.9-2-2V8c0-1.1.9-2 2-2z"></path></svg> {__("Recording")} <span class="js_voice-timer">00:00</span>
										</div>
										<!-- stop recording -->
									</div>
								</div>
								<!-- post voice notes -->
								
								<!-- post gif -->
								<div class="publisher-meta" data-meta="gif">
									<input class="js_publisher-gif-search" type="text" placeholder='{__("Search GIFs")}'>
								</div>
								<!-- post gif -->
								
								<!-- post poll -->
								<div class="publisher-meta" data-meta="poll">
									<input type="text" placeholder='{__("Add an option")}...'>
								</div>
								<div class="publisher-meta" data-meta="poll">
									<input type="text" placeholder='{__("Add an option")}...'>
								</div>
								<!-- post poll -->
								
								<!-- post reel -->
								<div class="publisher-meta" data-meta="reel">
									<div class="d-flex align-items-center justify-content-between gap-3">
										<div class="d-flex align-items-center small fw-medium gap-1">
											<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20" class="flex-0"><path d="M0 0h24v24H0V0z" fill="none"/><path fill="#1bc3bb" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM9.29 16.29L5.7 12.7c-.39-.39-.39-1.02 0-1.41.39-.39 1.02-.39 1.41 0L10 14.17l6.88-6.88c.39-.39 1.02-.39 1.41 0 .39.39.39 1.02 0 1.41l-7.59 7.59c-.38.39-1.02.39-1.41 0z"/></svg> {__("Reel uploaded successfully")}
										</div>
										<button type="button" class="btn btn-voice-clear js_publisher-attachment-file-remover p-0 text-danger text-opacity-75 flex-0" data-type="reel">
											<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M19.5825 15.6564C19.5058 16.9096 19.4449 17.9041 19.3202 18.6984C19.1922 19.5131 18.9874 20.1915 18.5777 20.7849C18.2029 21.3278 17.7204 21.786 17.1608 22.1303C16.5491 22.5067 15.8661 22.6713 15.0531 22.75L8.92739 22.7499C8.1135 22.671 7.42972 22.5061 6.8176 22.129C6.25763 21.7841 5.77494 21.3251 5.40028 20.7813C4.99073 20.1869 4.78656 19.5075 4.65957 18.6917C4.53574 17.8962 4.47623 16.9003 4.40122 15.6453L3.75 4.75H20.25L19.5825 15.6564ZM9.5 17.9609C9.08579 17.9609 8.75 17.6252 8.75 17.2109L8.75 11.2109C8.75 10.7967 9.08579 10.4609 9.5 10.4609C9.91421 10.4609 10.25 10.7967 10.25 11.2109L10.25 17.2109C10.25 17.6252 9.91421 17.9609 9.5 17.9609ZM15.25 11.2109C15.25 10.7967 14.9142 10.4609 14.5 10.4609C14.0858 10.4609 13.75 10.7967 13.75 11.2109V17.2109C13.75 17.6252 14.0858 17.9609 14.5 17.9609C14.9142 17.9609 15.25 17.6252 15.25 17.2109V11.2109Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13.3473 1.28277C13.9124 1.33331 14.4435 1.50576 14.8996 1.84591C15.2369 2.09748 15.4712 2.40542 15.6714 2.73893C15.8569 3.04798 16.0437 3.4333 16.2555 3.8704L16.6823 4.7507H21C21.5523 4.7507 22 5.19842 22 5.7507C22 6.30299 21.5523 6.7507 21 6.7507C14.9998 6.7507 9.00019 6.7507 3 6.7507C2.44772 6.7507 2 6.30299 2 5.7507C2 5.19842 2.44772 4.7507 3 4.7507H7.40976L7.76556 3.97016C7.97212 3.51696 8.15403 3.11782 8.33676 2.79754C8.53387 2.45207 8.76721 2.13237 9.10861 1.87046C9.57032 1.51626 10.1121 1.33669 10.6899 1.28409C11.1249 1.24449 11.5634 1.24994 12 1.25064C12.5108 1.25146 12.97 1.24902 13.3473 1.28277ZM9.60776 4.7507H14.4597C14.233 4.28331 14.088 3.98707 13.9566 3.7682C13.7643 3.44787 13.5339 3.30745 13.1691 3.27482C12.9098 3.25163 12.5719 3.2507 12.0345 3.2507C11.4837 3.2507 11.137 3.25166 10.8712 3.27585C10.4971 3.30991 10.2639 3.45568 10.0739 3.78866C9.94941 4.00687 9.81387 4.29897 9.60776 4.7507Z" fill="currentColor"/></svg>
										</button>
									</div>
								</div>
								<div class="publisher-custom-thumbnail position-relative overflow-hidden pt-2 publisher-reel-custom-thumbnail">
									<small>{__("Custom Reel Thumbnail")}</small>
									<div class="x-image w-100 mt-1">
										<button type="button" class="close publisher-scraper-remover border-0 position-absolute rounded-circle text-white p-2 m-2 x-hidden js_x-image-remover" title='{__("Remove")}'>
											<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" /></svg>
										</button>
										<div class="x-image-loader">
											<div class="progress x-progress">
												<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
											</div>
										</div>
										<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
										<input type="hidden" class="js_x-image-input" name="video_thumbnail" value="">
									</div>
								</div>
								<!-- post reel -->
								
								<!-- post video -->
								<div class="publisher-meta" data-meta="video">
									<div class="d-flex align-items-center justify-content-between gap-3">
										<div class="d-flex align-items-center small fw-medium gap-1">
											<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20" class="flex-0"><path d="M0 0h24v24H0V0z" fill="none"/><path fill="#1bc3bb" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM9.29 16.29L5.7 12.7c-.39-.39-.39-1.02 0-1.41.39-.39 1.02-.39 1.41 0L10 14.17l6.88-6.88c.39-.39 1.02-.39 1.41 0 .39.39.39 1.02 0 1.41l-7.59 7.59c-.38.39-1.02.39-1.41 0z"/></svg> {__("Video uploaded successfully")}
										</div>
										<button type="button" class="btn btn-voice-clear js_publisher-attachment-file-remover p-0 text-danger text-opacity-75 flex-0" data-type="video">
											<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M19.5825 15.6564C19.5058 16.9096 19.4449 17.9041 19.3202 18.6984C19.1922 19.5131 18.9874 20.1915 18.5777 20.7849C18.2029 21.3278 17.7204 21.786 17.1608 22.1303C16.5491 22.5067 15.8661 22.6713 15.0531 22.75L8.92739 22.7499C8.1135 22.671 7.42972 22.5061 6.8176 22.129C6.25763 21.7841 5.77494 21.3251 5.40028 20.7813C4.99073 20.1869 4.78656 19.5075 4.65957 18.6917C4.53574 17.8962 4.47623 16.9003 4.40122 15.6453L3.75 4.75H20.25L19.5825 15.6564ZM9.5 17.9609C9.08579 17.9609 8.75 17.6252 8.75 17.2109L8.75 11.2109C8.75 10.7967 9.08579 10.4609 9.5 10.4609C9.91421 10.4609 10.25 10.7967 10.25 11.2109L10.25 17.2109C10.25 17.6252 9.91421 17.9609 9.5 17.9609ZM15.25 11.2109C15.25 10.7967 14.9142 10.4609 14.5 10.4609C14.0858 10.4609 13.75 10.7967 13.75 11.2109V17.2109C13.75 17.6252 14.0858 17.9609 14.5 17.9609C14.9142 17.9609 15.25 17.6252 15.25 17.2109V11.2109Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13.3473 1.28277C13.9124 1.33331 14.4435 1.50576 14.8996 1.84591C15.2369 2.09748 15.4712 2.40542 15.6714 2.73893C15.8569 3.04798 16.0437 3.4333 16.2555 3.8704L16.6823 4.7507H21C21.5523 4.7507 22 5.19842 22 5.7507C22 6.30299 21.5523 6.7507 21 6.7507C14.9998 6.7507 9.00019 6.7507 3 6.7507C2.44772 6.7507 2 6.30299 2 5.7507C2 5.19842 2.44772 4.7507 3 4.7507H7.40976L7.76556 3.97016C7.97212 3.51696 8.15403 3.11782 8.33676 2.79754C8.53387 2.45207 8.76721 2.13237 9.10861 1.87046C9.57032 1.51626 10.1121 1.33669 10.6899 1.28409C11.1249 1.24449 11.5634 1.24994 12 1.25064C12.5108 1.25146 12.97 1.24902 13.3473 1.28277ZM9.60776 4.7507H14.4597C14.233 4.28331 14.088 3.98707 13.9566 3.7682C13.7643 3.44787 13.5339 3.30745 13.1691 3.27482C12.9098 3.25163 12.5719 3.2507 12.0345 3.2507C11.4837 3.2507 11.137 3.25166 10.8712 3.27585C10.4971 3.30991 10.2639 3.45568 10.0739 3.78866C9.94941 4.00687 9.81387 4.29897 9.60776 4.7507Z" fill="currentColor"/></svg>
										</button>
									</div>
									<select class="mt-3 px-3" name="video_category" id="video_category">
										{foreach $videos_categories as $category}
											{include file='__categories.recursive_options.tpl'}
										{/foreach}
									</select>
								</div>
								<div class="publisher-custom-thumbnail position-relative overflow-hidden pt-2 publisher-video-custom-thumbnail">
									<small>{__("Custom Video Thumbnail")}</small>
									<div class="x-image w-100 mt-1">
										<button type="button" class="close publisher-scraper-remover border-0 position-absolute rounded-circle text-white p-2 m-2 x-hidden js_x-image-remover" title='{__("Remove")}'>
											<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" /></svg>
										</button>
										<div class="x-image-loader">
											<div class="progress x-progress">
												<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
											</div>
										</div>
										<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
										<input type="hidden" class="js_x-image-input" name="video_thumbnail" value="">
									</div>
								</div>
								<!-- post video -->
								
								<!-- post audio -->
								<div class="publisher-meta" data-meta="audio">
									<div class="d-flex align-items-center justify-content-between gap-3">
										<div class="d-flex align-items-center small fw-medium gap-1">
											<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20" class="flex-0"><path d="M0 0h24v24H0V0z" fill="none"/><path fill="#1bc3bb" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM9.29 16.29L5.7 12.7c-.39-.39-.39-1.02 0-1.41.39-.39 1.02-.39 1.41 0L10 14.17l6.88-6.88c.39-.39 1.02-.39 1.41 0 .39.39.39 1.02 0 1.41l-7.59 7.59c-.38.39-1.02.39-1.41 0z"/></svg> {__("Audio uploaded successfully")}
										</div>
										<button type="button" class="btn btn-voice-clear js_publisher-attachment-file-remover p-0 text-danger text-opacity-75 flex-0" data-type="audio">
											<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M19.5825 15.6564C19.5058 16.9096 19.4449 17.9041 19.3202 18.6984C19.1922 19.5131 18.9874 20.1915 18.5777 20.7849C18.2029 21.3278 17.7204 21.786 17.1608 22.1303C16.5491 22.5067 15.8661 22.6713 15.0531 22.75L8.92739 22.7499C8.1135 22.671 7.42972 22.5061 6.8176 22.129C6.25763 21.7841 5.77494 21.3251 5.40028 20.7813C4.99073 20.1869 4.78656 19.5075 4.65957 18.6917C4.53574 17.8962 4.47623 16.9003 4.40122 15.6453L3.75 4.75H20.25L19.5825 15.6564ZM9.5 17.9609C9.08579 17.9609 8.75 17.6252 8.75 17.2109L8.75 11.2109C8.75 10.7967 9.08579 10.4609 9.5 10.4609C9.91421 10.4609 10.25 10.7967 10.25 11.2109L10.25 17.2109C10.25 17.6252 9.91421 17.9609 9.5 17.9609ZM15.25 11.2109C15.25 10.7967 14.9142 10.4609 14.5 10.4609C14.0858 10.4609 13.75 10.7967 13.75 11.2109V17.2109C13.75 17.6252 14.0858 17.9609 14.5 17.9609C14.9142 17.9609 15.25 17.6252 15.25 17.2109V11.2109Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13.3473 1.28277C13.9124 1.33331 14.4435 1.50576 14.8996 1.84591C15.2369 2.09748 15.4712 2.40542 15.6714 2.73893C15.8569 3.04798 16.0437 3.4333 16.2555 3.8704L16.6823 4.7507H21C21.5523 4.7507 22 5.19842 22 5.7507C22 6.30299 21.5523 6.7507 21 6.7507C14.9998 6.7507 9.00019 6.7507 3 6.7507C2.44772 6.7507 2 6.30299 2 5.7507C2 5.19842 2.44772 4.7507 3 4.7507H7.40976L7.76556 3.97016C7.97212 3.51696 8.15403 3.11782 8.33676 2.79754C8.53387 2.45207 8.76721 2.13237 9.10861 1.87046C9.57032 1.51626 10.1121 1.33669 10.6899 1.28409C11.1249 1.24449 11.5634 1.24994 12 1.25064C12.5108 1.25146 12.97 1.24902 13.3473 1.28277ZM9.60776 4.7507H14.4597C14.233 4.28331 14.088 3.98707 13.9566 3.7682C13.7643 3.44787 13.5339 3.30745 13.1691 3.27482C12.9098 3.25163 12.5719 3.2507 12.0345 3.2507C11.4837 3.2507 11.137 3.25166 10.8712 3.27585C10.4971 3.30991 10.2639 3.45568 10.0739 3.78866C9.94941 4.00687 9.81387 4.29897 9.60776 4.7507Z" fill="currentColor"/></svg>
										</button>
									</div>
								</div>
								<!-- post audio -->
								
								<!-- post file -->
								<div class="publisher-meta" data-meta="file">
									<div class="d-flex align-items-center justify-content-between gap-3">
										<div class="d-flex align-items-center small fw-medium gap-1">
											<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20" class="flex-0"><path d="M0 0h24v24H0V0z" fill="none"/><path fill="#1bc3bb" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM9.29 16.29L5.7 12.7c-.39-.39-.39-1.02 0-1.41.39-.39 1.02-.39 1.41 0L10 14.17l6.88-6.88c.39-.39 1.02-.39 1.41 0 .39.39.39 1.02 0 1.41l-7.59 7.59c-.38.39-1.02.39-1.41 0z"/></svg> {__("File uploaded successfully")}
										</div>
										<button type="button" class="btn btn-voice-clear js_publisher-attachment-file-remover p-0 text-danger text-opacity-75 flex-0" data-type="file">
											<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M19.5825 15.6564C19.5058 16.9096 19.4449 17.9041 19.3202 18.6984C19.1922 19.5131 18.9874 20.1915 18.5777 20.7849C18.2029 21.3278 17.7204 21.786 17.1608 22.1303C16.5491 22.5067 15.8661 22.6713 15.0531 22.75L8.92739 22.7499C8.1135 22.671 7.42972 22.5061 6.8176 22.129C6.25763 21.7841 5.77494 21.3251 5.40028 20.7813C4.99073 20.1869 4.78656 19.5075 4.65957 18.6917C4.53574 17.8962 4.47623 16.9003 4.40122 15.6453L3.75 4.75H20.25L19.5825 15.6564ZM9.5 17.9609C9.08579 17.9609 8.75 17.6252 8.75 17.2109L8.75 11.2109C8.75 10.7967 9.08579 10.4609 9.5 10.4609C9.91421 10.4609 10.25 10.7967 10.25 11.2109L10.25 17.2109C10.25 17.6252 9.91421 17.9609 9.5 17.9609ZM15.25 11.2109C15.25 10.7967 14.9142 10.4609 14.5 10.4609C14.0858 10.4609 13.75 10.7967 13.75 11.2109V17.2109C13.75 17.6252 14.0858 17.9609 14.5 17.9609C14.9142 17.9609 15.25 17.6252 15.25 17.2109V11.2109Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13.3473 1.28277C13.9124 1.33331 14.4435 1.50576 14.8996 1.84591C15.2369 2.09748 15.4712 2.40542 15.6714 2.73893C15.8569 3.04798 16.0437 3.4333 16.2555 3.8704L16.6823 4.7507H21C21.5523 4.7507 22 5.19842 22 5.7507C22 6.30299 21.5523 6.7507 21 6.7507C14.9998 6.7507 9.00019 6.7507 3 6.7507C2.44772 6.7507 2 6.30299 2 5.7507C2 5.19842 2.44772 4.7507 3 4.7507H7.40976L7.76556 3.97016C7.97212 3.51696 8.15403 3.11782 8.33676 2.79754C8.53387 2.45207 8.76721 2.13237 9.10861 1.87046C9.57032 1.51626 10.1121 1.33669 10.6899 1.28409C11.1249 1.24449 11.5634 1.24994 12 1.25064C12.5108 1.25146 12.97 1.24902 13.3473 1.28277ZM9.60776 4.7507H14.4597C14.233 4.28331 14.088 3.98707 13.9566 3.7682C13.7643 3.44787 13.5339 3.30745 13.1691 3.27482C12.9098 3.25163 12.5719 3.2507 12.0345 3.2507C11.4837 3.2507 11.137 3.25166 10.8712 3.27585C10.4971 3.30991 10.2639 3.45568 10.0739 3.78866C9.94941 4.00687 9.81387 4.29897 9.60776 4.7507Z" fill="currentColor"/></svg>
										</button>
									</div>
								</div>
								<!-- post file -->
							</div>
							<!-- publisher-slider -->
						</div>
					</div>
					
					<div class="d-flex">
						<div class="post_empty_space flex-0"></div>
						<div class="flex-1">
							<!-- publisher-slider -->
							<div class="publisher-slider">
								<div class="d-flex align-items-center flex-wrap justify-content-between gap-10 side_item_list">
									<!-- publisher-tools-tabs -->
									<div class="d-flex align-items-center flex-wrap publisher-tools-tabs">
										{if $user->_data['can_add_colored_posts']}
											<div class="publisher-tools-tab js_publisher-tab main position-relative rounded-circle main_bg_half p-2 pointer" data-tab="colored" data-bs-toggle="tooltip" title='{__("Colored Posts")}'>
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C12.8417 22 14 22.1163 14 21C14 20.391 13.6832 19.9212 13.3686 19.4544C12.9082 18.7715 12.4523 18.0953 13 17C13.6667 15.6667 14.7778 15.6667 16.4815 15.6667C17.3334 15.6667 18.3334 15.6667 19.5 15.5C21.601 15.1999 22 13.9084 22 12Z" stroke="currentColor" stroke-width="1.75" /><path d="M7 15.002L7.00868 14.9996" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><circle cx="9.5" cy="8.5" r="1.5" stroke="currentColor" stroke-width="1.75" /><circle cx="16.5" cy="9.5" r="1.5" stroke="currentColor" stroke-width="1.75" /></svg>
											</div>
										{/if}

										{if $user->_data['can_add_reels']}
											<div class="publisher-tools-tab attach overflow-hidden js_publisher-tab main position-relative rounded-circle main_bg_half p-2 pointer" data-tab="reel" data-bs-toggle="tooltip" title='{__("Upload Reel")}'>
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="js_x-uploader" data-handle="publisher" data-type="reel"><path d="M2.50012 7.5H21.5001" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M17.0001 2.5L14.0001 7.5" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M10.0001 2.5L7.00012 7.5" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75"></path><path d="M14.9531 14.8948C14.8016 15.5215 14.0857 15.9644 12.6539 16.8502C11.2697 17.7064 10.5777 18.1346 10.0199 17.9625C9.78934 17.8913 9.57925 17.7562 9.40982 17.57C9 17.1198 9 16.2465 9 14.5C9 12.7535 9 11.8802 9.40982 11.4299C9.57925 11.2438 9.78934 11.1087 10.0199 11.0375C10.5777 10.8654 11.2697 11.2936 12.6539 12.1498C14.0857 13.0356 14.8016 13.4785 14.9531 14.1052C15.0156 14.3639 15.0156 14.6361 14.9531 14.8948Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path></svg>
											</div>
										{/if}

										{if $user->_data['can_add_gif_posts']}
											<div class="publisher-tools-tab js_publisher-tab main position-relative rounded-circle main_bg_half p-1 pointer" data-tab="gif" data-bs-toggle="tooltip" title='{__("GIF")}'>
												<svg xmlns="http://www.w3.org/2000/svg" height="28px" viewBox="0 -960 960 960" width="28px" fill="currentColor"><path d="M468.85-361.15v-237.7H516v237.7h-47.15Zm-219.85 0q-20.3 0-33.76-13.64-13.47-13.63-13.47-33.6v-143.22q0-19.97 13.47-33.6 13.46-13.64 33.76-13.64h110q14.97 0 24.87 9.6t9.9 23.79v13.38H260.85q-4.62 0-8.46 3.85-3.85 3.85-3.85 8.46v119.54q0 4.61 3.85 8.46 3.84 3.85 8.46 3.85h73.46q4.61 0 8.46-3.85 3.85-3.85 3.85-8.46v-58.69h47.15v70.17q0 20.83-14.18 34.21-14.18 13.39-34.44 13.39H249Zm339.23 0v-237.7h171v46.77H635.38v58.85H716v47.15h-80.62v84.93h-47.15Z"/></svg>
											</div>
										{/if}

										{if $user->_data['can_add_activity_posts']}
											<div class="publisher-tools-tab js_publisher-feelings main position-relative rounded-circle main_bg_half p-2 pointer" data-bs-toggle="tooltip" title='{__("Feelings/Activity")}'>
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M12.5 2.01228C12.3344 2.00413 12.1677 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12C22 11.1368 21.8906 10.299 21.685 9.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M8 15C8.91212 16.2144 10.3643 17 12 17C13.6357 17 15.0879 16.2144 16 15" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M10 9.5H8.70711C8.25435 9.5 7.82014 9.67986 7.5 10M14 9.5H15.2929C15.7456 9.5 16.1799 9.67986 16.5 10" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M15.8881 2.33117C16.8267 1.78287 17.6459 2.00383 18.138 2.35579C18.3398 2.50011 18.4406 2.57227 18.5 2.57227C18.5594 2.57227 18.6602 2.50011 18.862 2.35579C19.3541 2.00383 20.1733 1.78287 21.1119 2.33117C22.3437 3.05077 22.6224 5.42474 19.7812 7.42757C19.24 7.80905 18.9694 7.99979 18.5 7.99979C18.0306 7.99979 17.76 7.80905 17.2188 7.42757C14.3776 5.42474 14.6563 3.05077 15.8881 2.33117Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
											</div>
										{/if}

										<div class="dropdown">
											<div class="d-flex align-items-center pointer main x_pub_btn" type="button" data-bs-toggle="dropdown">
												<div class="publisher-tools-tab position-relative rounded-circle main_bg_half p-2 pointer">
													<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M11.9959 12H12.0049" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M15.9998 12H16.0088" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M7.99981 12H8.00879" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12Z" stroke="currentColor" stroke-width="1.75"></path></svg>
												</div>
												<span class="small fw-medium"><small>{__("More")}</small></span>
											</div>
											<div class="dropdown-menu">
												{if !$_quick_mode}
													{if $user->_data['can_go_live']}
														<a class="publisher-tools-tab link js_publisher-tab dropdown-item pointer" data-tab="live" href="{$system['system_url']}/live{if $_handle == "page"}?page_id={$_id}{/if}{if $_handle == "group"}?group_id={$_id}{/if}{if $_handle == "event"}?event_id={$_id}{/if}">
															<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><circle cx="12" cy="12" r="2" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M7.5 8C6.5 9 6 10.5 6 12C6 13.5 6.5 15 7.5 16" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M4.5 6C3 7.5 2 9.5 2 12C2 14.5 3 16.5 4.5 18" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M16.5 16C17.5 15 18 13.5 18 12C18 10.5 17.5 9 16.5 8" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M19.5 18C21 16.5 22 14.5 22 12C22 9.5 21 7.5 19.5 6" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg> {__("Go Live")}
														</a>
													{/if}
													{if $system['voice_notes_posts_enabled']}
														<div class="publisher-tools-tab js_publisher-tab dropdown-item pointer" data-tab="voice_notes">
															<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M17 7V11C17 13.7614 14.7614 16 12 16C9.23858 16 7 13.7614 7 11V7C7 4.23858 9.23858 2 12 2C14.7614 2 17 4.23858 17 7Z" stroke="currentColor" stroke-width="1.75" /><path d="M17 7H14M17 11H14" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M20 11C20 15.4183 16.4183 19 12 19M12 19C7.58172 19 4 15.4183 4 11M12 19V22M12 22H15M12 22H9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg> {__("Voice Notes")}
														</div>
													{/if}
													{if $user->_data['can_write_blogs'] && in_array($_handle, ['me', 'page', 'group','event'])}
														<a class="publisher-tools-tab link js_publisher-tab dropdown-item pointer" data-tab="blog" href='{$system['system_url']}/blogs/new{if $_handle == "page"}?page={$_id}{/if}{if $_handle == "group"}?group={$_id}{/if}{if $_handle == "event"}?event={$_id}{/if}'>
															<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M10.5 8H18.5M10.5 12H13M18.5 12H16M10.5 16H13M18.5 16H16" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M7 7.5H6C4.11438 7.5 3.17157 7.5 2.58579 8.08579C2 8.67157 2 9.61438 2 11.5V18C2 19.3807 3.11929 20.5 4.5 20.5C5.88071 20.5 7 19.3807 7 18V7.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M16 3.5H11C10.07 3.5 9.60504 3.5 9.22354 3.60222C8.18827 3.87962 7.37962 4.68827 7.10222 5.72354C7 6.10504 7 6.57003 7 7.5V18C7 19.3807 5.88071 20.5 4.5 20.5H16C18.8284 20.5 20.2426 20.5 21.1213 19.6213C22 18.7426 22 17.3284 22 14.5V9.5C22 6.67157 22 5.25736 21.1213 4.37868C20.2426 3.5 18.8284 3.5 16 3.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg> {__("Create Blog")}
														</a>
													{/if}
													{if $system['market_enabled'] && in_array($_handle, ['me', 'page', 'group','event'])}
														<div class="publisher-tools-tab link js_publisher-tab dropdown-item pointer" data-tab="product" data-toggle="modal" data-url="posts/product.php?do=create{if $_handle == "page"}&page={$_id}{/if}{if $_handle == "group"}&group={$_id}{/if}{if $_handle == "event"}&event={$_id}{/if}">
															<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3 10.5V15C3 17.8284 3 19.2426 3.87868 20.1213C4.75736 21 6.17157 21 9 21H12.5M21 10.5V12.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M7 17H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M15 18.5H22M18.5 22V15" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M17.7947 2.00254L6.14885 2.03002C4.41069 1.94542 3.96502 3.2116 3.96502 3.83056C3.96502 4.38414 3.88957 5.19117 2.82426 6.70798C1.75895 8.22478 1.839 8.67537 2.43973 9.72544C2.9383 10.5969 4.20643 10.9374 4.86764 10.9946C6.96785 11.0398 7.98968 9.32381 7.98968 8.1178C9.03154 11.1481 11.9946 11.1481 13.3148 10.8016C14.6376 10.4545 15.7707 9.2118 16.0381 8.1178C16.194 9.47735 16.6672 10.2707 18.0653 10.8158C19.5135 11.3805 20.7589 10.5174 21.3838 9.9642C22.0087 9.41096 22.4097 8.18278 21.2958 6.83288C20.5276 5.90195 20.2074 5.02494 20.1023 4.11599C20.0413 3.58931 19.9878 3.02336 19.5961 2.66323C19.0238 2.13691 18.2026 1.97722 17.7947 2.00254Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg> {__("Create Product")}
														</div>
													{/if}
													{if $system['offers_enabled'] && in_array($_handle, ['me', 'page', 'group','event'])}
														<div class="publisher-tools-tab link js_publisher-tab dropdown-item pointer" data-tab="offer" data-toggle="modal" data-url="posts/offer.php?do=create{if $_handle == "page"}&page={$_id}{/if}{if $_handle == "group"}&group={$_id}{/if}{if $_handle == "event"}&event={$_id}{/if}">
															<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7.83152 21.3478L7.31312 20.6576C6.85764 20.0511 5.89044 20.1 5.50569 20.7488C4.96572 21.6595 3.5 21.2966 3.5 20.2523V3.74775C3.5 2.7034 4.96572 2.3405 5.50569 3.25115C5.89044 3.90003 6.85764 3.94888 7.31312 3.34244L7.83152 2.65222C8.48467 1.78259 9.84866 1.78259 10.5018 2.65222L10.5833 2.76076C11.2764 3.68348 12.7236 3.68348 13.4167 2.76076L13.4982 2.65222C14.1513 1.78259 15.5153 1.78259 16.1685 2.65222L16.6869 3.34244C17.1424 3.94888 18.1096 3.90003 18.4943 3.25115C19.0343 2.3405 20.5 2.7034 20.5 3.74774V20.2523C20.5 21.2966 19.0343 21.6595 18.4943 20.7488C18.1096 20.1 17.1424 20.0511 16.6869 20.6576L16.1685 21.3478C15.5153 22.2174 14.1513 22.2174 13.4982 21.3478L13.4167 21.2392C12.7236 20.3165 11.2764 20.3165 10.5833 21.2392L10.5018 21.3478C9.84866 22.2174 8.48467 22.2174 7.83152 21.3478Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M15 9L9 15" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M15 15H14.991M9.00897 9H9" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg> {__("Create Offer")}
														</div>
													{/if}
													{if $system['jobs_enabled'] && in_array($_handle, ['me', 'page', 'group','event'])}
														<div class="publisher-tools-tab link js_publisher-tab dropdown-item pointer" data-tab="job" data-toggle="modal" data-url="posts/job.php?do=create{if $_handle == "page"}&page={$_id}{/if}{if $_handle == "group"}&group={$_id}{/if}{if $_handle == "event"}&event={$_id}{/if}">
															<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3 11L3.15288 14.2269C3.31714 17.6686 3.39927 19.3894 4.55885 20.4447C5.71843 21.5 7.52716 21.5 11.1446 21.5H12.8554C16.4728 21.5 18.2816 21.5 19.4412 20.4447C20.6007 19.3894 20.6829 17.6686 20.8471 14.2269L21 11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M2.84718 10.4431C4.54648 13.6744 8.3792 15 12 15C15.6208 15 19.4535 13.6744 21.1528 10.4431C21.964 8.90056 21.3498 6 19.352 6H4.648C2.65023 6 2.03603 8.90056 2.84718 10.4431Z" stroke="currentColor" stroke-width="1.75"></path><path d="M11.9999 11H12.0089" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M15.9999 6L15.9116 5.69094C15.4716 4.15089 15.2516 3.38087 14.7278 2.94043C14.204 2.5 13.5083 2.5 12.1168 2.5H11.8829C10.4915 2.5 9.79575 2.5 9.27198 2.94043C8.7482 3.38087 8.52819 4.15089 8.08818 5.69094L7.99988 6" stroke="currentColor" stroke-width="1.75"></path></svg> {__("Create Job")}
														</div>
													{/if}
													{if $user->_data['can_create_courses'] && in_array($_handle, ['me', 'page', 'group','event'])}
														<div class="publisher-tools-tab link js_publisher-tab dropdown-item pointer" data-tab="job" data-toggle="modal" data-url="posts/course.php?do=create{if $_handle == "page"}&page={$_id}{/if}{if $_handle == "group"}&group={$_id}{/if}{if $_handle == "event"}&event={$_id}{/if}">
															<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7.50586 4.94531H16.0059C16.8343 4.94531 17.5059 5.61688 17.5059 6.44531V7.94531" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M15.0059 17.9453L14.1488 15.9453M14.1488 15.9453L12.5983 12.3277C12.4992 12.0962 12.2653 11.9453 12.0059 11.9453C11.7465 11.9453 11.5126 12.0962 11.4135 12.3277L9.863 15.9453M14.1488 15.9453H9.863M9.00586 17.9453L9.863 15.9453" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M18.497 2L6.30767 2.00002C5.81071 2.00002 5.30241 2.07294 4.9007 2.36782C3.62698 3.30279 2.64539 5.38801 4.62764 7.2706C5.18421 7.7992 5.96217 7.99082 6.72692 7.99082H18.2835C19.077 7.99082 20.5 8.10439 20.5 10.5273V17.9812C20.5 20.2007 18.7103 22 16.5026 22H7.47246C5.26886 22 3.66619 20.4426 3.53959 18.0713L3.5061 5.16638" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg> {__("Create Course")}
														</div>
													{/if}
												{/if}
												{if $user->_data['can_upload_files']}
													<div class="publisher-tools-tab attach position-relative overflow-hidden js_publisher-tab dropdown-item pointer" data-tab="file">
														<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="js_x-uploader" data-handle="publisher" data-type="file"><path d="M4 12.0004L4 14.5446C4 17.7896 4 19.4121 4.88607 20.5111C5.06508 20.7331 5.26731 20.9354 5.48933 21.1144C6.58831 22.0004 8.21082 22.0004 11.4558 22.0004C12.1614 22.0004 12.5141 22.0004 12.8372 21.8864C12.9044 21.8627 12.9702 21.8354 13.0345 21.8047C13.3436 21.6569 13.593 21.4074 14.0919 20.9085L18.8284 16.172C19.4065 15.5939 19.6955 15.3049 19.8478 14.9374C20 14.5698 20 14.1611 20 13.3436V10.0004C20 6.22919 20 4.34358 18.8284 3.172C17.7693 2.11284 16.1265 2.01122 13.0345 2.00146M13 21.5004V21.0004C13 18.172 13 16.7578 13.8787 15.8791C14.7574 15.0004 16.1716 15.0004 19 15.0004H19.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M4 8.23028V5.46105C4 3.54929 5.567 1.99951 7.5 1.99951C9.433 1.99951 11 3.54929 11 5.46105V9.26874C11 10.2246 10.2165 10.9995 9.25 10.9995C8.2835 10.9995 7.5 10.2246 7.5 9.26874V5.46105" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg> {__("Upload File")}
													</div>
												{/if}
											</div>
										</div>
										
										{if $user->_data['can_schedule_posts'] || ($_handle == "me" && $user->_data['can_add_anonymous_posts']) ||  $system['adult_mode'] || ($_handle != "page" && $user->_data['can_receive_tip']) || (in_array($_handle, ['me', 'page', 'group']) && $_node_can_monetize_content && $_node_monetization_enabled && $_node_monetization_plans > 0) || (in_array($_handle, ['me', 'page', 'group','event']) && $user->_data['can_monetize_content'] && $user->_data['user_monetization_enabled']) }
											<div class="d-flex align-items-center pointer main mx-2 x_pub_btn" type="button" onclick="$(this).toggleClass('active');$('.publisher').toggleClass('large-text');" data-bs-toggle="collapse" data-bs-target="#x_pub_options" aria-controls="x_pub_options" aria-expanded="false">
												<div class="publisher-tools-tab position-relative rounded-circle main_bg_half p-2 pointer">
													<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.3083 4.38394C15.7173 4.38394 15.4217 4.38394 15.1525 4.28405C15.1151 4.27017 15.0783 4.25491 15.042 4.23828C14.781 4.11855 14.5721 3.90959 14.1541 3.49167C13.1922 2.52977 12.7113 2.04882 12.1195 2.00447C12.04 1.99851 11.96 1.99851 11.8805 2.00447C11.2887 2.04882 10.8077 2.52977 9.84585 3.49166C9.42793 3.90959 9.21897 4.11855 8.95797 4.23828C8.92172 4.25491 8.88486 4.27017 8.84747 4.28405C8.57825 4.38394 8.28273 4.38394 7.69171 4.38394H7.58269C6.07478 4.38394 5.32083 4.38394 4.85239 4.85239C4.38394 5.32083 4.38394 6.07478 4.38394 7.58269V7.69171C4.38394 8.28273 4.38394 8.57825 4.28405 8.84747C4.27017 8.88486 4.25491 8.92172 4.23828 8.95797C4.11855 9.21897 3.90959 9.42793 3.49166 9.84585C2.52977 10.8077 2.04882 11.2887 2.00447 11.8805C1.99851 11.96 1.99851 12.04 2.00447 12.1195C2.04882 12.7113 2.52977 13.1922 3.49166 14.1541C3.90959 14.5721 4.11855 14.781 4.23828 15.042C4.25491 15.0783 4.27017 15.1151 4.28405 15.1525C4.38394 15.4217 4.38394 15.7173 4.38394 16.3083V16.4173C4.38394 17.9252 4.38394 18.6792 4.85239 19.1476C5.32083 19.6161 6.07478 19.6161 7.58269 19.6161H7.69171C8.28273 19.6161 8.57825 19.6161 8.84747 19.716C8.88486 19.7298 8.92172 19.7451 8.95797 19.7617C9.21897 19.8815 9.42793 20.0904 9.84585 20.5083C10.8077 21.4702 11.2887 21.9512 11.8805 21.9955C11.96 22.0015 12.0399 22.0015 12.1195 21.9955C12.7113 21.9512 13.1922 21.4702 14.1541 20.5083C14.5721 20.0904 14.781 19.8815 15.042 19.7617C15.0783 19.7451 15.1151 19.7298 15.1525 19.716C15.4217 19.6161 15.7173 19.6161 16.3083 19.6161H16.4173C17.9252 19.6161 18.6792 19.6161 19.1476 19.1476C19.6161 18.6792 19.6161 17.9252 19.6161 16.4173V16.3083C19.6161 15.7173 19.6161 15.4217 19.716 15.1525C19.7298 15.1151 19.7451 15.0783 19.7617 15.042C19.8815 14.781 20.0904 14.5721 20.5083 14.1541C21.4702 13.1922 21.9512 12.7113 21.9955 12.1195C22.0015 12.0399 22.0015 11.96 21.9955 11.8805C21.9512 11.2887 21.4702 10.8077 20.5083 9.84585C20.0904 9.42793 19.8815 9.21897 19.7617 8.95797C19.7451 8.92172 19.7298 8.88486 19.716 8.84747C19.6161 8.57825 19.6161 8.28273 19.6161 7.69171V7.58269C19.6161 6.07478 19.6161 5.32083 19.1476 4.85239C18.6792 4.38394 17.9252 4.38394 16.4173 4.38394H16.3083Z" stroke="currentColor" stroke-width="1.75" /><path d="M15.5 12C15.5 13.933 13.933 15.5 12 15.5C10.067 15.5 8.5 13.933 8.5 12C8.5 10.067 10.067 8.5 12 8.5C13.933 8.5 15.5 10.067 15.5 12Z" stroke="currentColor" stroke-width="1.75" /></svg>
												</div>
												<span class="small fw-medium"><small>{__("Options")}</small></span>
											</div>
										{/if}
									</div>
									
									<div class="d-flex align-items-center flex-0 publisher-tools-tabs">
										<div class="publisher-tools-tab text-muted position-relative rounded-circle main_bg_half p-2 pointer" onclick="x_addSpecial('#','.publisher textarea');">
											<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.75" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>  <line x1="5" y1="9" x2="19" y2="9"></line>  <line x1="5" y1="15" x2="19" y2="15"></line>  <line x1="11" y1="4" x2="7" y2="20"></line>  <line x1="17" y1="4" x2="13" y2="20"></line></svg>
										</div>
										<div class="publisher-tools-tab text-muted position-relative rounded-circle main_bg_half p-2 pointer" onclick="x_addSpecial('@','.publisher textarea');">
											<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.75" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>  <circle cx="12" cy="12" r="4"></circle>  <path d="M16 12v1.5a2.5 2.5 0 0 0 5 0v-1.5a9 9 0 1 0 -5.5 8.28"></path></svg>
										</div>
										<div class="position-relative publisher-emojis">
											<div class="publisher-tools-tab text-muted position-relative rounded-circle main_bg_half p-2 pointer js_emoji-menu-toggle">
												<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.75" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>  <circle cx="12" cy="12" r="9"></circle>  <line x1="9" y1="10" x2="9.01" y2="10"></line>  <line x1="15" y1="10" x2="15.01" y2="10"></line>  <path d="M9.5 15a3.5 3.5 0 0 0 5 0"></path></svg>
											</div>
										</div>
									</div>
									<!-- publisher-tools-tabs -->
								</div>
							  
								<!-- publisher-options -->
								{if $user->_data['can_schedule_posts'] || ($_handle == "me" && $user->_data['can_add_anonymous_posts']) ||  $system['adult_mode'] || ($_handle != "page" && $user->_data['can_receive_tip']) || (in_array($_handle, ['me', 'page', 'group']) && $_node_can_monetize_content && $_node_monetization_enabled && $_node_monetization_plans > 0) || (in_array($_handle, ['me', 'page', 'group','event']) && $user->_data['can_monetize_content'] && $user->_data['user_monetization_enabled']) }
									<div class="collapse" id="x_pub_options">
										<div class="publisher-footer-options">
											<!-- schedule post -->
											{if $user->_data['can_schedule_posts']}
												<div class="form-table-row mb-2 pb-1">
													<div>
														<div class="form-label mb0">{__("Schedule Post")}</div>
														<div class="form-text d-none d-sm-block mt0">{__("Schedule your post for later")}</div>
													</div>
													<div class="text-end align-self-center flex-0">
														<label class="switch" for="is_schedule">
															<input type="checkbox" name="is_schedule" id="is_schedule" class="js_publisher-schedule-toggle">
															<span class="slider round"></span>
														</label>
													</div>
												</div>
												<div class="form-floating mb-3 x-hidden" id="schedule-toggle-wrapper">
													<input type="datetime-local" class="form-control js_publisher-schedule-date" placeholder=" ">
													<label>{__("Date")}</label>
													<div class="form-text">
														{__("Select a date and time for your post")}
													</div>
												</div>
											{/if}
											<!-- schedule post -->
											
											<!-- anonymous post -->
											{if $_handle == "me" && $user->_data['can_add_anonymous_posts']}
												<div class="form-table-row mb-2 pb-1">
													<div>
														<div class="form-label mb0">{__("Anonymous Post")}</div>
														<div class="form-text d-none d-sm-block mt0">{__("Share your post as anonymous post")}</div>
													</div>
													<div class="text-end align-self-center flex-0">
														<label class="switch" for="is_anonymous">
															<input type="checkbox" name="is_anonymous" id="is_anonymous" class="js_publisher-anonymous-toggle">
															<span class="slider round"></span>
														</label>
													</div>
												</div>
											{/if}
											<!-- anonymous post -->

											<!-- adult content -->
											{if $system['adult_mode']}
												<div class="form-table-row mb-2 pb-1" id="adult-toggle-wrapper">
													<div>
														<div class="form-label mb0">{__("Adult Content")}</div>
														<div class="form-text d-none d-sm-block mt0">{__("Share your post as adult content")}</div>
													</div>
													<div class="text-end align-self-center flex-0">
														<label class="switch" for="for_adult">
															<input type="checkbox" name="for_adult" id="for_adult" class="js_publisher-adult-toggle">
															<span class="slider round"></span>
														</label>
													</div>
												</div>
											{/if}
											<!-- adult content -->

											<!-- enable tips -->
											{if $_handle != "page" && $user->_data['can_receive_tip']}
												<div class="form-table-row mb-2 pb-1" id="tips-toggle-wrapper">
													<div>
														<div class="form-label mb0">{__("Enable Tips")}</div>
														<div class="form-text d-none d-sm-block mt0">{__("Allow people to send you tips")}</div>
													</div>
													<div class="text-end align-self-center flex-0">
														<label class="switch" for="tips_enabled">
															<input type="checkbox" name="tips_enabled" id="tips_enabled" class="js_publisher-tips-toggle">
															<span class="slider round"></span>
														</label>
													</div>
												</div>
											{/if}
											<!-- enable tips -->

											<!-- only for subscribers -->
											{if in_array($_handle, ['me', 'page', 'group']) && $_node_can_monetize_content && $_node_monetization_enabled && $_node_monetization_plans > 0 }
												<div class="form-table-row mb-2 pb-1" id="subscribers-toggle-wrapper">
													<div>
														<div class="form-label mb0">{__("Subscribers Only")}</div>
														<div class="form-text d-none d-sm-block mt0">{__("Share this post to")} {if $_handle != "me"}{__($_handle)} {/if}{__("subscribers only")}</div>
													</div>
													<div class="text-end align-self-center flex-0">
														<label class="switch" for="subscribers_only">
															<input type="checkbox" name="subscribers_only" id="subscribers_only" class="js_publisher-subscribers-toggle">
															<span class="slider round"></span>
														</label>
													</div>
												</div>
												<div class="form-group x-hidden" id="subscriptions-image-wrapper">
													<div class="x-image mt-1">
														<button type="button" class="close publisher-scraper-remover border-0 position-absolute rounded-circle text-white p-2 m-2 x-hidden js_x-image-remover" title='{__("Remove")}'>
															<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" /></svg>
														</button>
														<div class="x-image-loader">
															<div class="progress x-progress">
																<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
															</div>
														</div>
														<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image" data-blur="true"></i>
														<input type="hidden" class="js_x-image-input" name="subscriptions_image" value="">
													</div>
													<div class="form-text">
														{__("Upload a preview image for your post (This image will be blured)")}
													</div>
												</div>
											{/if}
											<!-- only for subscribers -->

											<!-- paid post -->
											{if in_array($_handle, ['me', 'page', 'group','event']) && $user->_data['can_monetize_content'] && $user->_data['user_monetization_enabled']}
												<div class="form-table-row mb-2 pb-1" id="paid-toggle-wrapper">
													<div>
														<div class="form-label mb0">{__("Paid Post")}</div>
														<div class="form-text d-none d-sm-block mt0">{__("Set a price to your post")} ({__("subscribers also paying")})</div>
													</div>
													<div class="text-end align-self-center flex-0">
														<label class="switch" for="paid_post">
															<input type="checkbox" name="paid_post" id="paid_post" class="js_publisher-paid-toggle">
															<span class="slider round"></span>
														</label>
													</div>
												</div>

												<div class="form-table-row mb-2 pb-1 x-hidden" id="paid-lock-toggle-wrapper">
													<div>
														<div class="form-label mb0">{__("Only Lock Attached File")}</div>
														<div class="form-text d-none d-sm-block mt0">{__("This option will lock the attached file and disable the preview")}</div>
													</div>
													<div class="text-end align-self-center flex-0">
														<label class="switch" for="paid_post_lock">
															<input type="checkbox" name="paid_post_lock" id="paid_post_lock" class="js_publisher-paid-lock-toggle">
															<span class="slider round"></span>
														</label>
													</div>
												</div>

												<div class="x-hidden" id="paid-price-wrapper">
													<div class="d-flex mb-2 gap-3 x_pub_paid_post">
														<div class="set_desc flex-1 x-hidden" id="paid-text-wrapper">
															<label class="d-block fw-medium mb-2">{__("Description")}</label>
															<textarea class="form-control bg-transparent border-0 p-0" name="paid_post_text" rows="2" placeholder='{__("Paid Post Description")}'></textarea>
														</div>
														<div class="set_price flex-0">
															<label class="d-block fw-medium mb-2">{__('Price')} ({$system['system_currency']})</label>
															<input class="bg-transparent border-0 p-0" type="text" name="paid_post_price" placeholder="0.00">
														</div>
													</div>
												</div>
												<div class="form-group pt-1 x-hidden" id="paid-image-wrapper">
													<div class="x-image">
														<button type="button" class="close publisher-scraper-remover border-0 position-absolute rounded-circle text-white p-2 m-2 x-hidden js_x-image-remover" title='{__("Remove")}'>
															<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" /></svg>
														</button>
													
														<div class="x-image-loader">
															<div class="progress x-progress">
																<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
															</div>
														</div>
														<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image" data-blur="true"></i>
														<input type="hidden" class="js_x-image-input" name="paid_image" value="">
													</div>
													<div class="form-text">
														{__("Upload a preview image for your post (This image will be blured)")}
													</div>
												</div>
											{/if}
											<!-- paid post -->
										</div>
									</div>
								{/if}
								<!-- publisher-options -->
							</div>
							<!-- publisher-slider -->
							
							<!-- publisher-error -->
							<div class="alert alert-danger x-hidden"></div>
							<!-- publisher-error -->
							
							<!-- publisher-footer -->
							<div class="d-flex align-items-center justify-content-between publisher-footer side_item_list pb-0 flex-wrap">
								<div class="d-flex align-items-center publisher-tools-tabs">
									{if $system['photos_enabled']}
										<div class="publisher-tools-tab attach overflow-hidden js_publisher-tab main position-relative rounded-circle main_bg_half p-2 pointer" data-tab="photos" data-bs-toggle="tooltip" title='{__("Upload Photos")}'>
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="js_x-uploader" data-handle="publisher" data-multiple="true"><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75" /><circle cx="16.5" cy="7.5" r="1.5" stroke="currentColor" stroke-width="1.75" /><path d="M16 22C15.3805 19.7749 13.9345 17.7821 11.8765 16.3342C9.65761 14.7729 6.87163 13.9466 4.01569 14.0027C3.67658 14.0019 3.33776 14.0127 3 14.0351" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M13 18C14.7015 16.6733 16.5345 15.9928 18.3862 16.0001C19.4362 15.999 20.4812 16.2216 21.5 16.6617" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /></svg>
										</div>
										{if !$_quick_mode}
											<div class="publisher-tools-tab js_publisher-tab main position-relative rounded-circle main_bg_half p-2 pointer" data-tab="album" data-bs-toggle="tooltip" title='{__("Create Album")}'>
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M6 17.9745C6.1287 19.2829 6.41956 20.1636 7.07691 20.8209C8.25596 22 10.1536 22 13.9489 22C17.7442 22 19.6419 22 20.8209 20.8209C22 19.6419 22 17.7442 22 13.9489C22 10.1536 22 8.25596 20.8209 7.07691C20.1636 6.41956 19.2829 6.1287 17.9745 6" stroke="currentColor" stroke-width="1.75" /><path d="M2 10C2 6.22876 2 4.34315 3.17157 3.17157C4.34315 2 6.22876 2 10 2C13.7712 2 15.6569 2 16.8284 3.17157C18 4.34315 18 6.22876 18 10C18 13.7712 18 15.6569 16.8284 16.8284C15.6569 18 13.7712 18 10 18C6.22876 18 4.34315 18 3.17157 16.8284C2 15.6569 2 13.7712 2 10Z" stroke="currentColor" stroke-width="1.75" /><path d="M2 11.1185C2.61902 11.0398 3.24484 11.001 3.87171 11.0023C6.52365 10.9533 9.11064 11.6763 11.1711 13.0424C13.082 14.3094 14.4247 16.053 15 18" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M12.9998 7H13.0088" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
											</div>
										{/if}
									{/if}
									
									{if $user->_data['can_upload_audios']}
										<div class="publisher-tools-tab attach overflow-hidden js_publisher-tab main position-relative rounded-circle main_bg_half p-2 pointer" data-tab="audio" data-bs-toggle="tooltip" title='{__("Upload Audio")}'>
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="js_x-uploader" data-handle="publisher" data-type="audio"><circle cx="6.5" cy="18.5" r="3.5" stroke="currentColor" stroke-width="1.75" /><circle cx="18" cy="16" r="3" stroke="currentColor" stroke-width="1.75" /><path d="M10 18.5L10 7C10 6.07655 10 5.61483 10.2635 5.32794C10.5269 5.04106 11.0175 4.9992 11.9986 4.91549C16.022 4.57222 18.909 3.26005 20.3553 2.40978C20.6508 2.236 20.7986 2.14912 20.8993 2.20672C21 2.26432 21 2.4315 21 2.76587V16" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M10 10C15.8667 10 19.7778 7.66667 21 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										</div>
									{/if}
									
									{if $user->_data['can_add_polls_posts']}
										<div class="publisher-tools-tab js_publisher-tab main position-relative rounded-circle main_bg_half p-2 pointer" data-tab="poll" data-bs-toggle="tooltip" title='{__("Create Poll")}'>
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3.5 9.5V18.5C3.5 18.9659 3.5 19.1989 3.57612 19.3827C3.67761 19.6277 3.87229 19.8224 4.11732 19.9239C4.30109 20 4.53406 20 5 20C5.46594 20 5.69891 20 5.88268 19.9239C6.12771 19.8224 6.32239 19.6277 6.42388 19.3827C6.5 19.1989 6.5 18.9659 6.5 18.5V9.5C6.5 9.03406 6.5 8.80109 6.42388 8.61732C6.32239 8.37229 6.12771 8.17761 5.88268 8.07612C5.69891 8 5.46594 8 5 8C4.53406 8 4.30109 8 4.11732 8.07612C3.87229 8.17761 3.67761 8.37229 3.57612 8.61732C3.5 8.80109 3.5 9.03406 3.5 9.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="square" stroke-linejoin="round" /><path d="M10.5 5.5V18.4995C10.5 18.9654 10.5 19.1984 10.5761 19.3822C10.6776 19.6272 10.8723 19.8219 11.1173 19.9234C11.3011 19.9995 11.5341 19.9995 12 19.9995C12.4659 19.9995 12.6989 19.9995 12.8827 19.9234C13.1277 19.8219 13.3224 19.6272 13.4239 19.3822C13.5 19.1984 13.5 18.9654 13.5 18.4995V5.5C13.5 5.03406 13.5 4.80109 13.4239 4.61732C13.3224 4.37229 13.1277 4.17761 12.8827 4.07612C12.6989 4 12.4659 4 12 4C11.5341 4 11.3011 4 11.1173 4.07612C10.8723 4.17761 10.6776 4.37229 10.5761 4.61732C10.5 4.80109 10.5 5.03406 10.5 5.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="square" stroke-linejoin="round" /><path d="M17.5 12.5V18.5C17.5 18.9659 17.5 19.1989 17.5761 19.3827C17.6776 19.6277 17.8723 19.8224 18.1173 19.9239C18.3011 20 18.5341 20 19 20C19.4659 20 19.6989 20 19.8827 19.9239C20.1277 19.8224 20.3224 19.6277 20.4239 19.3827C20.5 19.1989 20.5 18.9659 20.5 18.5V12.5C20.5 12.0341 20.5 11.8011 20.4239 11.6173C20.3224 11.3723 20.1277 11.1776 19.8827 11.0761C19.6989 11 19.4659 11 19 11C18.5341 11 18.3011 11 18.1173 11.0761C17.8723 11.1776 17.6776 11.3723 17.5761 11.6173C17.5 11.8011 17.5 12.0341 17.5 12.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="square" stroke-linejoin="round" /></svg>
										</div>
									{/if}
									
									{if $user->_data['can_upload_videos']}
										<div class="publisher-tools-tab attach overflow-hidden js_publisher-tab main position-relative rounded-circle main_bg_half p-2 pointer" data-tab="video" data-bs-toggle="tooltip" title='{__("Upload Video")}'>
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="js_x-uploader" data-handle="publisher" data-type="video"><path d="M11 8L13 8" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M2 11C2 7.70017 2 6.05025 3.02513 5.02513C4.05025 4 5.70017 4 9 4H10C13.2998 4 14.9497 4 15.9749 5.02513C17 6.05025 17 7.70017 17 11V13C17 16.2998 17 17.9497 15.9749 18.9749C14.9497 20 13.2998 20 10 20H9C5.70017 20 4.05025 20 3.02513 18.9749C2 17.9497 2 16.2998 2 13V11Z" stroke="currentColor" stroke-width="1.75" /><path d="M17 8.90585L17.1259 8.80196C19.2417 7.05623 20.2996 6.18336 21.1498 6.60482C22 7.02628 22 8.42355 22 11.2181V12.7819C22 15.5765 22 16.9737 21.1498 17.3952C20.2996 17.8166 19.2417 16.9438 17.1259 15.198L17 15.0941" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
										</div>
									{/if}
									{if $user->_data['can_add_geolocation_posts']}
										<div class="publisher-tools-tab js_publisher-tab main position-relative rounded-circle main_bg_half p-2 pointer" data-tab="location" data-bs-toggle="tooltip" title='{__("Check In")}'>
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M13.6177 21.367C13.1841 21.773 12.6044 22 12.0011 22C11.3978 22 10.8182 21.773 10.3845 21.367C6.41302 17.626 1.09076 13.4469 3.68627 7.37966C5.08963 4.09916 8.45834 2 12.0011 2C15.5439 2 18.9126 4.09916 20.316 7.37966C22.9082 13.4393 17.599 17.6389 13.6177 21.367Z" stroke="currentColor" stroke-width="1.75" /><path d="M15.5 11C15.5 12.933 13.933 14.5 12 14.5C10.067 14.5 8.5 12.933 8.5 11C8.5 9.067 10.067 7.5 12 7.5C13.933 7.5 15.5 9.067 15.5 11Z" stroke="currentColor" stroke-width="1.75" /></svg>
										</div>
									{/if}
								</div>
								
								<!-- publisher-buttons -->
								<div class="publisher-footer-buttons flex-0">
									{if $_post_as_page}
										<input type="hidden" name="post_as_page" value="{$_page_id}">
									{/if}
									<button type="button" class="btn btn-main js_publisher-btn js_publisher">{__("Post")}</button>
								</div>
								<!-- publisher-buttons -->
							</div>
							<!-- publisher-footer -->
						</div>
					</div>
				</div>
			</div>
		</div>
	{/if}
{/if}