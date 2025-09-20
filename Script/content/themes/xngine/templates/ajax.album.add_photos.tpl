<div class="modal-body pt-2">
	<div class="x-form bg-white publisher mini border-0 rounded-4 mt-3" data-id="{$album['album_id']}">
		<div class="side_item_list p-3">
			<div class="d-flex align-items-start justify-content-between x_user_info gap-10">
				<div class="flex-1">
					<!-- privacy -->
					<div class="publisher-slider d-flex align-items-center justify-content-between">
						{if $album['user_type'] == 'user' && !$album['in_group'] && !$album['in_event']}
							<div class="btn-group" data-value="friends">
								<button type="button" class="btn btn-sm btn-gray px-2 d-inline-block dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
									<i class="btn-group-icon fa fa-user-friends"></i>&nbsp;&nbsp;<span class="btn-group-text">{__("Friends")}</span>
								</button>
								<div class="dropdown-menu">
									<div class="dropdown-item pointer" data-value="public">
										<i class="fa fa-globe-americas flex-0"></i>{__("Public")}
									</div>
									<div class="dropdown-item pointer" data-value="friends">
										<i class="fa fa-user-friends flex-0"></i>{__("Friends")}
									</div>
									<div class="dropdown-item pointer" data-value="me">
										<i class="fa fa-user-lock flex-0"></i>{__("Only Me")}
									</div>
								</div>
							</div>
						{else}
							{if $album['privacy'] == "custom"}
								<div class="btn-group" data-value="custom">
									<button type="button" class="btn btn-sm btn-gray px-2">
										<i class="btn-group-icon fa fa-cog"></i>&nbsp;&nbsp;<span class="btn-group-text">{__("Custom")}</span>
									</button>
								</div>
							{elseif $album['privacy'] == "public"}
								<div class="btn-group" data-value="public">
									<button type="button" class="btn btn-sm btn-gray px-2">
										<i class="btn-group-icon fa fa-globe-americas"></i>&nbsp;&nbsp;<span class="btn-group-text">{__("Public")}</span>
									</button>
								</div>
							{/if}
						{/if}
						
						<!-- publisher close -->
						<div class="publisher-close">
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button>
						</div>
						<!-- publisher close -->
					</div>
					<!-- privacy -->
					<!-- publisher-message -->
					<div class="publisher-message no-avatar position-relative">
						<textarea dir="auto" class="js_autosize js_mention mt-2 w-100 p-0 border-0 bg-transparent" placeholder='{__("What is on your mind? #Hashtag.. @Mention.. Link..")}'></textarea>
					</div>
					<!-- publisher-message -->
					
					<!-- publisher-slider -->
					<div class="publisher-slider d-block">
						<!-- post attachments -->
						<div class="publisher-attachments attachments clearfix x-hidden js_attachments-photos"></div>
						<!-- post attachments -->
						
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
					</div>
					<!-- publisher-slider -->
				</div>
			</div>
			
			<div class="d-flex">
				<div class="flex-1">
					<!-- publisher-slider -->
					<div class="publisher-slider d-block">
						<div class="d-flex align-items-center flex-wrap justify-content-between gap-10 side_item_list">
							<div class="d-flex align-items-center publisher-tools-tabs">
								{if $system['photos_enabled']}
									<div class="publisher-tools-tab attach overflow-hidden js_publisher-tab main position-relative rounded-circle main_bg_half p-2 pointer" data-tab="photos" title='{__("Upload Photos")}'>
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="js_x-uploader" data-handle="publisher" data-multiple="true"><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75" /><circle cx="16.5" cy="7.5" r="1.5" stroke="currentColor" stroke-width="1.75" /><path d="M16 22C15.3805 19.7749 13.9345 17.7821 11.8765 16.3342C9.65761 14.7729 6.87163 13.9466 4.01569 14.0027C3.67658 14.0019 3.33776 14.0127 3 14.0351" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M13 18C14.7015 16.6733 16.5345 15.9928 18.3862 16.0001C19.4362 15.999 20.4812 16.2216 21.5 16.6617" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /></svg>
									</div>
								{/if}
								{if $system['activity_posts_enabled']}
									<div class="publisher-tools-tab js_publisher-feelings main position-relative rounded-circle main_bg_half p-2 pointer" title='{__("Feelings/Activity")}'>
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M12.5 2.01228C12.3344 2.00413 12.1677 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12C22 11.1368 21.8906 10.299 21.685 9.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M8 15C8.91212 16.2144 10.3643 17 12 17C13.6357 17 15.0879 16.2144 16 15" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M10 9.5H8.70711C8.25435 9.5 7.82014 9.67986 7.5 10M14 9.5H15.2929C15.7456 9.5 16.1799 9.67986 16.5 10" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M15.8881 2.33117C16.8267 1.78287 17.6459 2.00383 18.138 2.35579C18.3398 2.50011 18.4406 2.57227 18.5 2.57227C18.5594 2.57227 18.6602 2.50011 18.862 2.35579C19.3541 2.00383 20.1733 1.78287 21.1119 2.33117C22.3437 3.05077 22.6224 5.42474 19.7812 7.42757C19.24 7.80905 18.9694 7.99979 18.5 7.99979C18.0306 7.99979 17.76 7.80905 17.2188 7.42757C14.3776 5.42474 14.6563 3.05077 15.8881 2.33117Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
									</div>
								{/if}
								{if $system['geolocation_enabled']}
									<div class="publisher-tools-tab js_publisher-tab main position-relative rounded-circle main_bg_half p-2 pointer" data-tab="location" title='{__("Check In")}'>
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M13.6177 21.367C13.1841 21.773 12.6044 22 12.0011 22C11.3978 22 10.8182 21.773 10.3845 21.367C6.41302 17.626 1.09076 13.4469 3.68627 7.37966C5.08963 4.09916 8.45834 2 12.0011 2C15.5439 2 18.9126 4.09916 20.316 7.37966C22.9082 13.4393 17.599 17.6389 13.6177 21.367Z" stroke="currentColor" stroke-width="1.75" /><path d="M15.5 11C15.5 12.933 13.933 14.5 12 14.5C10.067 14.5 8.5 12.933 8.5 11C8.5 9.067 10.067 7.5 12 7.5C13.933 7.5 15.5 9.067 15.5 11Z" stroke="currentColor" stroke-width="1.75" /></svg>
									</div>
								{/if}
							</div>
							<div class="d-flex align-items-center flex-0 publisher-tools-tabs">
								<div class="publisher-tools-tab text-muted position-relative rounded-circle main_bg_half p-2 pointer" onclick="x_addSpecial('#','.publisher textarea');">
									<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.75" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>  <line x1="5" y1="9" x2="19" y2="9"></line>  <line x1="5" y1="15" x2="19" y2="15"></line>  <line x1="11" y1="4" x2="7" y2="20"></line>  <line x1="17" y1="4" x2="13" y2="20"></line></svg>
								</div>
								<div class="position-relative publisher-emojis">
									<div class="publisher-tools-tab text-muted position-relative rounded-circle main_bg_half p-2 pointer js_emoji-menu-toggle">
										<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.75" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>  <circle cx="12" cy="12" r="9"></circle>  <line x1="9" y1="10" x2="9.01" y2="10"></line>  <line x1="15" y1="10" x2="15.01" y2="10"></line>  <path d="M9.5 15a3.5 3.5 0 0 0 5 0"></path></svg>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- publisher-slider -->	
				</div>
			</div>
			
			<!-- publisher-footer -->
			<div class="publisher-footer">
				<!-- publisher-buttons -->
				<button type="button" class="btn btn-primary w-100 js_publisher-btn js_publisher-album">{__("Post")}</button>
				<!-- publisher-buttons -->
			</div>
			<!-- publisher-footer -->
		</div>
	</div>
</div>