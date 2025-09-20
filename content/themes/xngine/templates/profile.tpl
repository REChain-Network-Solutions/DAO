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
		<!-- profile-header -->
		<div class="profile-header position-relative bg-white">
			<!-- profile-cover -->
			<div class="profile-cover-wrapper x_adslist position-relative overflow-hidden rounded-0">
				{if $profile['user_cover_id']}
					<!-- full-cover -->
					<img class="js_position-cover-full x-hidden" src="{$profile['user_cover_full']}">
					<!-- full-cover -->

					<!-- cropped-cover -->
					<img class="js_position-cover-cropped {if $user->_logged_in && $profile['user_cover_lightbox']}js_lightbox{/if}" data-init-position="{$profile['user_cover_position']}" data-id="{$profile['user_cover_id']}" data-image="{$profile['user_cover_full']}" data-context="album" src="{$profile['user_cover']}" alt="{$profile['name']}">
					<!-- cropped-cover -->
				{/if}

				{if $profile['user_id'] == $user->_data['user_id']}
					<!-- buttons -->
					<div class="profile-cover-buttons d-flex align-items-center gap-2 position-absolute m-2 m-md-3 top-0">
						<div class="profile-cover-change">
							<button type="button" class="btn bg-black text-white border-0 p-2 rounded-circle lh-1 flex-0" data-bs-toggle="dropdown" data-display="static">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M11.9256 1.5H12.0745H12.0745C14.2504 1.49998 15.9852 1.49996 17.3453 1.68282C18.7497 1.87164 19.9035 2.27175 20.8159 3.18414C21.7283 4.09653 22.1284 5.25033 22.3172 6.65471C22.5 8.01485 22.5 9.74959 22.5 11.9256V12.0744C22.5 14.2504 22.5 15.9852 22.3172 17.3453C22.1284 18.7497 21.7283 19.9035 20.8159 20.8159C19.9035 21.7283 18.7497 22.1284 17.3453 22.3172C15.9851 22.5 14.2504 22.5 12.0744 22.5H11.9256C9.74959 22.5 8.01485 22.5 6.65471 22.3172C5.25033 22.1284 4.09653 21.7283 3.18414 20.8159C2.27175 19.9035 1.87164 18.7497 1.68282 17.3453C1.49996 15.9852 1.49998 14.2504 1.5 12.0745V12.0745V11.9256V11.9255C1.49998 9.74958 1.49996 8.01484 1.68282 6.65471C1.87164 5.25033 2.27175 4.09653 3.18414 3.18414C4.09653 2.27175 5.25033 1.87164 6.65471 1.68282C8.01484 1.49996 9.74958 1.49998 11.9255 1.5H11.9256ZM14.5 7.5C14.5 6.39543 15.3954 5.5 16.5 5.5C17.6046 5.5 18.5 6.39543 18.5 7.5C18.5 8.60457 17.6046 9.5 16.5 9.5C15.3954 9.5 14.5 8.60457 14.5 7.5ZM18.3837 16.7501C19.0353 16.7494 19.692 16.8447 20.3408 17.0367L20.3352 17.0788C20.1762 18.2614 19.8807 18.9228 19.4019 19.4017C18.923 19.8805 18.2616 20.176 17.079 20.335C16.8154 20.3705 16.5334 20.3983 16.2302 20.4201C15.8204 19.4898 15.2721 18.615 14.6026 17.8175C15.8435 17.0978 17.1185 16.7451 18.3837 16.7501ZM3.51758 14.7603C3.537 15.6726 3.57813 16.4312 3.6652 17.0788C3.82419 18.2614 4.1197 18.9228 4.59856 19.4017C5.07741 19.8805 5.73881 20.176 6.92141 20.335C8.13278 20.4979 9.73277 20.5 12.0002 20.5C12.9843 20.5 13.8427 20.4996 14.5981 20.4858C13.8891 19.1287 12.8178 17.9128 11.4459 16.9476C9.36457 15.4832 6.73674 14.6994 4.03132 14.7525L4.01487 14.7527C3.849 14.7523 3.6832 14.7548 3.51758 14.7603Z" fill="currentColor"/></svg>
							</button>
							<div class="dropdown-menu action-dropdown-menu">
								<!-- upload -->
								<div class="dropdown-item pointer align-items-start js_x-uploader" data-handle="cover-user">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M13 3.00231C12.5299 3 12.0307 3 11.5 3C7.02166 3 4.78249 3 3.39124 4.39124C2 5.78249 2 8.02166 2 12.5C2 16.9783 2 19.2175 3.39124 20.6088C4.78249 22 7.02166 22 11.5 22C15.9783 22 18.2175 22 19.6088 20.6088C20.9472 19.2703 20.998 17.147 20.9999 13" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M2 14.1354C2.61902 14.0455 3.24484 14.0011 3.87171 14.0027C6.52365 13.9466 9.11064 14.7729 11.1711 16.3342C13.082 17.7821 14.4247 19.7749 15 22" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M21 16.8962C19.8246 16.3009 18.6088 15.9988 17.3862 16.0001C15.5345 15.9928 13.7015 16.6733 12 18" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M17 4.5C17.4915 3.9943 18.7998 2 19.5 2M22 4.5C21.5085 3.9943 20.2002 2 19.5 2M19.5 2V10" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
									<div class="action">
										{__("Upload Photo")}
										<div class="action-desc">{__("Upload a new photo")}</div>
									</div>
								</div>
								<!-- upload -->
								<!-- select -->
								<div class="dropdown-item pointer align-items-start" data-toggle="modal" data-url="users/photos.php?filter=cover&type=user&id={$profile['user_id']}">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M6 17.9745C6.1287 19.2829 6.41956 20.1636 7.07691 20.8209C8.25596 22 10.1536 22 13.9489 22C17.7442 22 19.6419 22 20.8209 20.8209C22 19.6419 22 17.7442 22 13.9489C22 10.1536 22 8.25596 20.8209 7.07691C20.1636 6.41956 19.2829 6.1287 17.9745 6" stroke="currentColor" stroke-width="1.75" /><path d="M2 10C2 6.22876 2 4.34315 3.17157 3.17157C4.34315 2 6.22876 2 10 2C13.7712 2 15.6569 2 16.8284 3.17157C18 4.34315 18 6.22876 18 10C18 13.7712 18 15.6569 16.8284 16.8284C15.6569 18 13.7712 18 10 18C6.22876 18 4.34315 18 3.17157 16.8284C2 15.6569 2 13.7712 2 10Z" stroke="currentColor" stroke-width="1.75" /><path d="M2 11.1185C2.61902 11.0398 3.24484 11.001 3.87171 11.0023C6.52365 10.9533 9.11064 11.6763 11.1711 13.0424C13.082 14.3094 14.4247 16.053 15 18" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M12.9998 7H13.0088" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
									<div class="action">
										{__("Select Photo")}
										<div class="action-desc">{__("Select a photo")}</div>
									</div>
								</div>
								<!-- select -->
							</div>
						</div>
						<div class="profile-cover-position {if !$profile['user_cover']}x-hidden{/if}">
							<input class="js_position-picture-val" type="hidden" name="position-picture-val">
							<button type="button" class="btn bg-black text-white border-0 p-2 rounded-circle lh-1 flex-0 js_init-position-picture" data-handle="user" data-id="{$profile['user_id']}">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8.43505 5.50658C8.16255 5.81853 8.19452 6.29233 8.50647 6.56483C8.64875 6.68913 8.82471 6.75008 8.99988 6.75001H10.3999C10.6827 6.75001 10.8241 6.75001 10.912 6.83788C10.9999 6.92575 10.9999 7.06717 10.9999 7.35001V9.00013C10.9999 9.55241 11.4476 10.0001 11.9999 10.0001C12.5522 10.0001 12.9999 9.55241 12.9999 9.00013V7.35001C12.9999 7.06717 12.9999 6.92575 13.0877 6.83788C13.1756 6.75001 13.317 6.75001 13.5999 6.75001H15.0007C15.1756 6.7499 15.3512 6.68895 15.4933 6.56483C15.8053 6.29233 15.8372 5.81853 15.5647 5.50658L13.8296 3.52028C13.5504 3.20068 13.2929 2.90574 13.0541 2.69718C12.7948 2.47076 12.4525 2.25 11.9999 2.25C11.5472 2.25 11.205 2.47076 10.9457 2.69718C10.7069 2.90574 10.4493 3.20068 10.1702 3.52028L8.43505 5.50658Z" fill="currentColor"/><path d="M8.43505 18.4934C8.16255 18.1815 8.19452 17.7077 8.50647 17.4352C8.64875 17.3109 8.82471 17.2499 8.99988 17.25H10.3999C10.6827 17.25 10.8241 17.25 10.912 17.1621C10.9999 17.0743 10.9999 16.9328 10.9999 16.65V14.9999C10.9999 14.4476 11.4476 13.9999 11.9999 13.9999C12.5522 13.9999 12.9999 14.4476 12.9999 14.9999V16.65C12.9999 16.9328 12.9999 17.0743 13.0877 17.1621C13.1756 17.25 13.317 17.25 13.5999 17.25H15.0007C15.1756 17.2501 15.3512 17.3111 15.4933 17.4352C15.8053 17.7077 15.8372 18.1815 15.5647 18.4934L13.8296 20.4797C13.5504 20.7993 13.2929 21.0943 13.0541 21.3028C12.7948 21.5292 12.4525 21.75 11.9999 21.75C11.5472 21.75 11.205 21.5292 10.9457 21.3028C10.7069 21.0943 10.4493 20.7993 10.1702 20.4797L8.43505 18.4934Z" fill="currentColor"/><path d="M18.4935 8.43518C18.1816 8.16267 17.7078 8.19464 17.4353 8.50659C17.311 8.64888 17.25 8.82483 17.2501 9L17.2501 10.4C17.2501 10.6828 17.2501 10.8243 17.1622 10.9121C17.0744 11 16.933 11 16.6501 11L15 11C14.4477 11 14 11.4477 14 12C14 12.5523 14.4477 13 15 13L16.6501 13C16.933 13 17.0744 13 17.1622 13.0879C17.2501 13.1757 17.2501 13.3172 17.2501 13.6L17.2501 15.0008C17.2502 15.1757 17.3112 15.3514 17.4353 15.4934C17.7078 15.8054 18.1816 15.8374 18.4935 15.5648L20.4798 13.8297C20.7994 13.5506 21.0944 13.293 21.3029 13.0542C21.5294 12.7949 21.7501 12.4527 21.7501 12C21.7501 11.5474 21.5294 11.2051 21.3029 10.9458C21.0944 10.707 20.7994 10.4495 20.4798 10.1703L18.4935 8.43518Z" fill="currentColor"/><path d="M5.5067 8.43518C5.81865 8.16267 6.29245 8.19464 6.56496 8.50659C6.68925 8.64888 6.7502 8.82483 6.75013 9L6.75013 10.4C6.75013 10.6828 6.75013 10.8243 6.838 10.9121C6.92587 11 7.06729 11 7.35013 11L9.00025 11C9.55254 11 10.0003 11.4477 10.0003 12C10.0003 12.5523 9.55254 13 9.00025 13L7.35013 13C7.06729 13 6.92587 13 6.838 13.0879C6.75013 13.1757 6.75013 13.3172 6.75013 13.6L6.75013 15.0008C6.75002 15.1757 6.68907 15.3514 6.56496 15.4934C6.29245 15.8054 5.81865 15.8374 5.5067 15.5648L3.52041 13.8297C3.2008 13.5506 2.90586 13.293 2.6973 13.0542C2.47088 12.7949 2.25012 12.4527 2.25012 12C2.25012 11.5474 2.47088 11.2051 2.6973 10.9458C2.90586 10.707 3.2008 10.4495 3.52041 10.1703L5.5067 8.43518Z" fill="currentColor"/></svg>
							</button>
						</div>
						<div class="profile-cover-position-buttons">
							<button type="button" class="btn bg-black text-white border-0 p-2 rounded-circle lh-1 flex-0 js_save-position-picture">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path xmlns="http://www.w3.org/2000/svg" fill-rule="evenodd" clip-rule="evenodd" d="M19.6905 5.77665C20.09 6.15799 20.1047 6.79098 19.7234 7.19048L9.22336 18.1905C9.03745 18.3852 8.78086 18.4968 8.51163 18.4999C8.2424 18.5031 7.98328 18.3975 7.79289 18.2071L4.29289 14.7071C3.90237 14.3166 3.90237 13.6834 4.29289 13.2929C4.68342 12.9024 5.31658 12.9024 5.70711 13.2929L8.48336 16.0692L18.2766 5.80953C18.658 5.41003 19.291 5.39531 19.6905 5.77665Z" fill="currentColor"/></svg>
							</button>
						</div>
						<div class="profile-cover-position-buttons">
							<button type="button" class="btn bg-black text-white border-0 p-2 rounded-circle lh-1 flex-0 js_cancel-position-picture">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.0005 4.99988L5.00049 18.9999M5.00049 4.99988L19.0005 18.9999" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
							</button>
						</div>
						<div class="profile-cover-delete {if !$profile['user_cover']}x-hidden{/if}">
							<button type="button" class="btn bg-black text-white border-0 p-2 rounded-circle lh-1 flex-0 js_delete-cover" data-handle="cover-user">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M19.5825 15.6564C19.5058 16.9096 19.4449 17.9041 19.3202 18.6984C19.1922 19.5131 18.9874 20.1915 18.5777 20.7849C18.2029 21.3278 17.7204 21.786 17.1608 22.1303C16.5491 22.5067 15.8661 22.6713 15.0531 22.75L8.92739 22.7499C8.1135 22.671 7.42972 22.5061 6.8176 22.129C6.25763 21.7841 5.77494 21.3251 5.40028 20.7813C4.99073 20.1869 4.78656 19.5075 4.65957 18.6917C4.53574 17.8962 4.47623 16.9003 4.40122 15.6453L3.75 4.75H20.25L19.5825 15.6564ZM9.5 17.9609C9.08579 17.9609 8.75 17.6252 8.75 17.2109L8.75 11.2109C8.75 10.7967 9.08579 10.4609 9.5 10.4609C9.91421 10.4609 10.25 10.7967 10.25 11.2109L10.25 17.2109C10.25 17.6252 9.91421 17.9609 9.5 17.9609ZM15.25 11.2109C15.25 10.7967 14.9142 10.4609 14.5 10.4609C14.0858 10.4609 13.75 10.7967 13.75 11.2109V17.2109C13.75 17.6252 14.0858 17.9609 14.5 17.9609C14.9142 17.9609 15.25 17.6252 15.25 17.2109V11.2109Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13.3473 1.28277C13.9124 1.33331 14.4435 1.50576 14.8996 1.84591C15.2369 2.09748 15.4712 2.40542 15.6714 2.73893C15.8569 3.04798 16.0437 3.4333 16.2555 3.8704L16.6823 4.7507H21C21.5523 4.7507 22 5.19842 22 5.7507C22 6.30299 21.5523 6.7507 21 6.7507C14.9998 6.7507 9.00019 6.7507 3 6.7507C2.44772 6.7507 2 6.30299 2 5.7507C2 5.19842 2.44772 4.7507 3 4.7507H7.40976L7.76556 3.97016C7.97212 3.51696 8.15403 3.11782 8.33676 2.79754C8.53387 2.45207 8.76721 2.13237 9.10861 1.87046C9.57032 1.51626 10.1121 1.33669 10.6899 1.28409C11.1249 1.24449 11.5634 1.24994 12 1.25064C12.5108 1.25146 12.97 1.24902 13.3473 1.28277ZM9.60776 4.7507H14.4597C14.233 4.28331 14.088 3.98707 13.9566 3.7682C13.7643 3.44787 13.5339 3.30745 13.1691 3.27482C12.9098 3.25163 12.5719 3.2507 12.0345 3.2507C11.4837 3.2507 11.137 3.25166 10.8712 3.27585C10.4971 3.30991 10.2639 3.45568 10.0739 3.78866C9.94941 4.00687 9.81387 4.29897 9.60776 4.7507Z" fill="currentColor"/></svg>
							</button>
						</div>
					</div>
					<!-- buttons -->

					<!-- loaders -->
					<div class="profile-cover-change-loader position-absolute w-100 h-100 top-0 bottom-0 bg-black bg-opacity-50">
						<div class="progress x-progress bg-white bg-opacity-50">
							<div class="progress-bar bg-white" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
						</div>
					</div>
					<div class="profile-cover-position-loader position-absolute top-0 end-0 m-2 m-md-3 bg-black bg-opacity-50 rounded text-white py-2 px-3 small">
						<small class="d-flex align-items-center gap-2">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" color="currentColor" fill="none"><path d="M22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12Z" stroke="currentColor" stroke-width="1.75" /><path d="M12.2422 17V12C12.2422 11.5286 12.2422 11.2929 12.0957 11.1464C11.9493 11 11.7136 11 11.2422 11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M11.992 8H12.001" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
							{__("Drag to reposition cover")}
						</small>
					</div>
					<!-- loaders -->
				{/if}
			</div>
			<!-- profile-cover -->
			
			<div class="p-3 position-relative">
				<!-- profile-avatar -->
				<div class="profile-avatar-wrapper rounded-circle bg-white p-1 position-relative mb-2">
					<img {if $profile['user_picture_id']} {if $user->_logged_in && $profile['user_picture_lightbox']}class="js_lightbox pointer" {/if} data-id="{$profile['user_picture_id']}" data-context="album" data-image="{$profile['user_picture_full']}" {elseif !$profile['user_picture_default']} class="js_lightbox-nodata" data-image="{$profile['user_picture']}" {/if} src="{$profile['user_picture']}" alt="{$profile['name']}">

					{if $profile['user_id'] == $user->_data['user_id']}
						<!-- buttons -->
						<div class="profile-avatar-change position-absolute">
							<button type="button" class="btn bg-black text-white border-0 p-2 rounded-circle lh-1 flex-0" data-bs-toggle="dropdown" data-display="static">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M11.9256 1.5H12.0745H12.0745C14.2504 1.49998 15.9852 1.49996 17.3453 1.68282C18.7497 1.87164 19.9035 2.27175 20.8159 3.18414C21.7283 4.09653 22.1284 5.25033 22.3172 6.65471C22.5 8.01485 22.5 9.74959 22.5 11.9256V12.0744C22.5 14.2504 22.5 15.9852 22.3172 17.3453C22.1284 18.7497 21.7283 19.9035 20.8159 20.8159C19.9035 21.7283 18.7497 22.1284 17.3453 22.3172C15.9851 22.5 14.2504 22.5 12.0744 22.5H11.9256C9.74959 22.5 8.01485 22.5 6.65471 22.3172C5.25033 22.1284 4.09653 21.7283 3.18414 20.8159C2.27175 19.9035 1.87164 18.7497 1.68282 17.3453C1.49996 15.9852 1.49998 14.2504 1.5 12.0745V12.0745V11.9256V11.9255C1.49998 9.74958 1.49996 8.01484 1.68282 6.65471C1.87164 5.25033 2.27175 4.09653 3.18414 3.18414C4.09653 2.27175 5.25033 1.87164 6.65471 1.68282C8.01484 1.49996 9.74958 1.49998 11.9255 1.5H11.9256ZM14.5 7.5C14.5 6.39543 15.3954 5.5 16.5 5.5C17.6046 5.5 18.5 6.39543 18.5 7.5C18.5 8.60457 17.6046 9.5 16.5 9.5C15.3954 9.5 14.5 8.60457 14.5 7.5ZM18.3837 16.7501C19.0353 16.7494 19.692 16.8447 20.3408 17.0367L20.3352 17.0788C20.1762 18.2614 19.8807 18.9228 19.4019 19.4017C18.923 19.8805 18.2616 20.176 17.079 20.335C16.8154 20.3705 16.5334 20.3983 16.2302 20.4201C15.8204 19.4898 15.2721 18.615 14.6026 17.8175C15.8435 17.0978 17.1185 16.7451 18.3837 16.7501ZM3.51758 14.7603C3.537 15.6726 3.57813 16.4312 3.6652 17.0788C3.82419 18.2614 4.1197 18.9228 4.59856 19.4017C5.07741 19.8805 5.73881 20.176 6.92141 20.335C8.13278 20.4979 9.73277 20.5 12.0002 20.5C12.9843 20.5 13.8427 20.4996 14.5981 20.4858C13.8891 19.1287 12.8178 17.9128 11.4459 16.9476C9.36457 15.4832 6.73674 14.6994 4.03132 14.7525L4.01487 14.7527C3.849 14.7523 3.6832 14.7548 3.51758 14.7603Z" fill="currentColor"/></svg>
							</button>
							<div class="dropdown-menu action-dropdown-menu">
								<!-- upload -->
								<div class="dropdown-item pointer align-items-start js_x-uploader" data-handle="picture-user">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M13 3.00231C12.5299 3 12.0307 3 11.5 3C7.02166 3 4.78249 3 3.39124 4.39124C2 5.78249 2 8.02166 2 12.5C2 16.9783 2 19.2175 3.39124 20.6088C4.78249 22 7.02166 22 11.5 22C15.9783 22 18.2175 22 19.6088 20.6088C20.9472 19.2703 20.998 17.147 20.9999 13" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M2 14.1354C2.61902 14.0455 3.24484 14.0011 3.87171 14.0027C6.52365 13.9466 9.11064 14.7729 11.1711 16.3342C13.082 17.7821 14.4247 19.7749 15 22" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M21 16.8962C19.8246 16.3009 18.6088 15.9988 17.3862 16.0001C15.5345 15.9928 13.7015 16.6733 12 18" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M17 4.5C17.4915 3.9943 18.7998 2 19.5 2M22 4.5C21.5085 3.9943 20.2002 2 19.5 2M19.5 2V10" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
									<div class="action">
										{__("Upload Photo")}
										<div class="action-desc">{__("Upload a new photo")}</div>
									</div>
								</div>
								<!-- upload -->
								<!-- select -->
								<div class="dropdown-item pointer align-items-start" data-toggle="modal" data-url="users/photos.php?filter=avatar&type=user&id={$profile['user_id']}">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M6 17.9745C6.1287 19.2829 6.41956 20.1636 7.07691 20.8209C8.25596 22 10.1536 22 13.9489 22C17.7442 22 19.6419 22 20.8209 20.8209C22 19.6419 22 17.7442 22 13.9489C22 10.1536 22 8.25596 20.8209 7.07691C20.1636 6.41956 19.2829 6.1287 17.9745 6" stroke="currentColor" stroke-width="1.75" /><path d="M2 10C2 6.22876 2 4.34315 3.17157 3.17157C4.34315 2 6.22876 2 10 2C13.7712 2 15.6569 2 16.8284 3.17157C18 4.34315 18 6.22876 18 10C18 13.7712 18 15.6569 16.8284 16.8284C15.6569 18 13.7712 18 10 18C6.22876 18 4.34315 18 3.17157 16.8284C2 15.6569 2 13.7712 2 10Z" stroke="currentColor" stroke-width="1.75" /><path d="M2 11.1185C2.61902 11.0398 3.24484 11.001 3.87171 11.0023C6.52365 10.9533 9.11064 11.6763 11.1711 13.0424C13.082 14.3094 14.4247 16.053 15 18" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M12.9998 7H13.0088" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
									<div class="action">
										{__("Select Photo")}
										<div class="action-desc">{__("Select a photo")}</div>
									</div>
								</div>
								<!-- select -->
								<div class="{if $profile['user_picture_default'] || !$profile['user_picture_id']}x-hidden{/if}">
									<div class="dropdown-divider"></div>
									<div class="dropdown-item pointer js_init-crop-picture" data-image="{$profile['user_picture_full']}" data-handle="user" data-id="{$profile['user_id']}">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M4 2V4M22 20H20M16.5 20H10C7.17157 20 5.75736 20 4.87868 19.1213C4 18.2426 4 16.8284 4 14V7.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M20 22L20 12C20 8.22877 20 6.34315 18.8284 5.17158C17.6569 4 15.7712 4 12 4L2 4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										{__("Crop photo")}
									</div>
								</div>
								<div class="{if $profile['user_picture_default']}x-hidden{/if}">
									<div class="dropdown-item pointer js_delete-picture" data-handle="picture-user">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.5 5.5L18.8803 15.5251C18.7219 18.0864 18.6428 19.3671 18.0008 20.2879C17.6833 20.7431 17.2747 21.1273 16.8007 21.416C15.8421 22 14.559 22 11.9927 22C9.42312 22 8.1383 22 7.17905 21.4149C6.7048 21.1257 6.296 20.7408 5.97868 20.2848C5.33688 19.3626 5.25945 18.0801 5.10461 15.5152L4.5 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M3 5.5H21M16.0557 5.5L15.3731 4.09173C14.9196 3.15626 14.6928 2.68852 14.3017 2.39681C14.215 2.3321 14.1231 2.27454 14.027 2.2247C13.5939 2 13.0741 2 12.0345 2C10.9688 2 10.436 2 9.99568 2.23412C9.8981 2.28601 9.80498 2.3459 9.71729 2.41317C9.32164 2.7167 9.10063 3.20155 8.65861 4.17126L8.05292 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M9.5 16.5L9.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M14.5 16.5L14.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
										{__("Delete photo")}
									</div>
								</div>
							</div>
						</div>
						<!-- buttons -->
						<!-- loaders -->
						<div class="profile-avatar-change-loader position-absolute w-100 h-100 top-0 bottom-0 bg-black bg-opacity-50 rounded-circle">
							<div class="progress x-progress bg-white bg-opacity-50">
								<div class="progress-bar bg-white" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
							</div>
						</div>
						<!-- loaders -->
					{/if}
				</div>
				<!-- profile-avatar -->
				
				<!-- profile-name -->
				<div class="profile-name-wrapper">
					<a href="{$system['system_url']}/{$profile['user_name']}" class="body-color h3 fw-bold m-0 align-middle">{$profile['name']}</a>
					{if $profile['user_verified']}
						<span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified User")}'>
							<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
						</span>
					{/if}
					{if $profile['user_subscribed']}
						<a class="pro-badge" href="{$system['system_url']}/packages" data-bs-toggle="tooltip" title="{__($profile['package_name'])} {__("Member")}">
							<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20"><path d="M0 0h24v24H0z" fill="none"></path><path fill="currentColor" d="M12 2.02c-5.51 0-9.98 4.47-9.98 9.98s4.47 9.98 9.98 9.98 9.98-4.47 9.98-9.98S17.51 2.02 12 2.02zm-.52 15.86v-4.14H8.82c-.37 0-.62-.4-.44-.73l3.68-7.17c.23-.47.94-.3.94.23v4.19h2.54c.37 0 .61.39.45.72l-3.56 7.12c-.24.48-.95.31-.95-.22z"></path></svg>
						</a>
					{/if}
					{if $profile['custom_user_group']}
						<a class="badge bg-primary">{__($profile['custom_user_group']['user_group_title'])}</a>
					{/if}
				</div>
				<!-- profile-name -->
				
				<p class="mb-0 text-muted">@{$profile['user_name']}</p>
				
				{if $system['biography_info_enabled']}
					{if !is_empty($profile['user_biography'])}
						<div class="about-bio mt-2">
							<div class="js_readmore overflow-hidden">
								{$profile['user_biography']|nl2br}
							</div>
						</div>
					{/if}
                {/if}
				
				<div class="d-flex align-items-center mt-2 text-muted w-100 flex-wrap x_page_mini_info">
					<!-- posts -->
                    <div class="d-flex align-items-center gap-1 flex-0">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M12.8809 7.01656L17.6538 8.28825M11.8578 10.8134L14.2442 11.4492M11.9765 17.9664L12.9311 18.2208C15.631 18.9401 16.981 19.2998 18.0445 18.6893C19.108 18.0787 19.4698 16.7363 20.1932 14.0516L21.2163 10.2548C21.9398 7.57005 22.3015 6.22768 21.6875 5.17016C21.0735 4.11264 19.7235 3.75295 17.0235 3.03358L16.0689 2.77924C13.369 2.05986 12.019 1.70018 10.9555 2.31074C9.89196 2.9213 9.53023 4.26367 8.80678 6.94841L7.78366 10.7452C7.0602 13.4299 6.69848 14.7723 7.3125 15.8298C7.92652 16.8874 9.27651 17.2471 11.9765 17.9664Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M12 20.9462L11.0477 21.2055C8.35403 21.939 7.00722 22.3057 5.94619 21.6832C4.88517 21.0607 4.52429 19.692 3.80253 16.9546L2.78182 13.0833C2.06006 10.3459 1.69918 8.97718 2.31177 7.89892C2.84167 6.96619 4 7.00015 5.5 7.00003" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
						{$profile['posts_count']} <span class="d-none d-md-inline-block">{__("Posts")}</span>
                    </div>
					<!-- posts -->
					<!-- photos -->
                    <div class="d-flex align-items-center gap-1 flex-0">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75"></path><circle cx="16.5" cy="7.5" r="1.5" stroke="currentColor" stroke-width="1.75"></circle><path d="M16 22C15.3805 19.7749 13.9345 17.7821 11.8765 16.3342C9.65761 14.7729 6.87163 13.9466 4.01569 14.0027C3.67658 14.0019 3.33776 14.0127 3 14.0351" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M13 18C14.7015 16.6733 16.5345 15.9928 18.3862 16.0001C19.4362 15.999 20.4812 16.2216 21.5 16.6617" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path></svg>
						{$profile['photos_count']} <span class="d-none d-md-inline-block">{__("Photos")}</span>
                    </div>
					<!-- photos -->
					{if $system['videos_enabled']}
						<!-- videos -->
						<div class="d-flex align-items-center gap-1 flex-0">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M11 8L13 8" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M2 11C2 7.70017 2 6.05025 3.02513 5.02513C4.05025 4 5.70017 4 9 4H10C13.2998 4 14.9497 4 15.9749 5.02513C17 6.05025 17 7.70017 17 11V13C17 16.2998 17 17.9497 15.9749 18.9749C14.9497 20 13.2998 20 10 20H9C5.70017 20 4.05025 20 3.02513 18.9749C2 17.9497 2 16.2998 2 13V11Z" stroke="currentColor" stroke-width="1.75"></path><path d="M17 8.90585L17.1259 8.80196C19.2417 7.05623 20.2996 6.18336 21.1498 6.60482C22 7.02628 22 8.42355 22 11.2181V12.7819C22 15.5765 22 16.9737 21.1498 17.3952C20.2996 17.8166 19.2417 16.9438 17.1259 15.198L17 15.0941" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
							{$profile['videos_count']} <span class="d-none d-md-inline-block">{__("Videos")}</span>
						</div>
						<!-- videos -->
					{/if}
				</div>
				
				<div class="d-flex align-items-center mt-1 text-muted w-100 flex-wrap x_page_mini_info">
					{if $system['location_info_enabled']}
						{if $profile['user_current_city']}
							{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_location'] == "public" || ($profile['user_privacy_location'] == "friends" && $profile['we_friends'])}
								<div class="d-flex align-items-center gap-1 flex-0">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M8.9995 22L8.74887 18.4911C8.61412 16.6046 10.1082 15 11.9995 15C13.8908 15 15.3849 16.6046 15.2501 18.4911L14.9995 22" stroke="currentColor" stroke-width="1.75" /><path d="M2.35157 13.2135C1.99855 10.9162 1.82204 9.76763 2.25635 8.74938C2.69065 7.73112 3.65421 7.03443 5.58132 5.64106L7.02117 4.6C9.41847 2.86667 10.6171 2 12.0002 2C13.3832 2 14.5819 2.86667 16.9792 4.6L18.419 5.64106C20.3462 7.03443 21.3097 7.73112 21.744 8.74938C22.1783 9.76763 22.0018 10.9162 21.6488 13.2135L21.3478 15.1724C20.8473 18.4289 20.5971 20.0572 19.4292 21.0286C18.2613 22 16.5538 22 13.139 22H10.8614C7.44652 22 5.73909 22 4.57118 21.0286C3.40327 20.0572 3.15305 18.4289 2.65261 15.1724L2.35157 13.2135Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /></svg>
									{__("Lives in")} {$profile['user_current_city']}
								</div>
							{/if}
						{/if}

						{if $profile['user_hometown']}
							{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_location'] == "public" || ($profile['user_privacy_location'] == "friends" && $profile['we_friends'])}
								<div class="d-flex align-items-center gap-1 flex-0">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M13.6177 21.367C13.1841 21.773 12.6044 22 12.0011 22C11.3978 22 10.8182 21.773 10.3845 21.367C6.41302 17.626 1.09076 13.4469 3.68627 7.37966C5.08963 4.09916 8.45834 2 12.0011 2C15.5439 2 18.9126 4.09916 20.316 7.37966C22.9082 13.4393 17.599 17.6389 13.6177 21.367Z" stroke="currentColor" stroke-width="1.75" /><path d="M15.5 11C15.5 12.933 13.933 14.5 12 14.5C10.067 14.5 8.5 12.933 8.5 11C8.5 9.067 10.067 7.5 12 7.5C13.933 7.5 15.5 9.067 15.5 11Z" stroke="currentColor" stroke-width="1.75" /></svg>
									{__("From")} {$profile['user_hometown']}
								</div>
							{/if}
						{/if}
					{/if}
					
					{if !$system['genders_disabled']}
						{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_gender'] == "public" || ($profile['user_privacy_gender'] == "friends" && $profile['we_friends'])}
							<div class="d-flex align-items-center gap-1 flex-0">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M18.5 20V17.9704C18.5 16.7281 17.9407 15.5099 16.8103 14.9946C15.4315 14.3661 13.7779 14 12 14C10.2221 14 8.5685 14.3661 7.18968 14.9946C6.05927 15.5099 5.5 16.7281 5.5 17.9704V20" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><circle cx="12" cy="7.5" r="3.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
								{$profile['user_gender']}
							</div>
						{/if}
					{/if}
					
					{if $system['relationship_info_enabled']}
						{if $profile['user_relationship']}
							{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_relationship'] == "public" || ($profile['user_privacy_relationship'] == "friends" && $profile['we_friends'])}
								<div class="d-flex align-items-center gap-1 flex-0">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M19.4626 3.99415C16.7809 2.34923 14.4404 3.01211 13.0344 4.06801C12.4578 4.50096 12.1696 4.71743 12 4.71743C11.8304 4.71743 11.5422 4.50096 10.9656 4.06801C9.55962 3.01211 7.21909 2.34923 4.53744 3.99415C1.01807 6.15294 0.221721 13.2749 8.33953 19.2834C9.88572 20.4278 10.6588 21 12 21C13.3412 21 14.1143 20.4278 15.6605 19.2834C23.7783 13.2749 22.9819 6.15294 19.4626 3.99415Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
									{if $profile['user_relationship'] == "relationship"}
										{__("In a relationship")}
									{elseif $profile['user_relationship'] == "complicated"}
										{__("It's complicated")}
									{else}
										{__($profile['user_relationship']|ucfirst)}
									{/if}
								</div>
							{/if}
						{/if}
					{/if}
					
					{if $profile['user_birthdate'] != null}
						{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_birthdate'] == "public" || ($profile['user_privacy_birthdate'] == "friends" && $profile['we_friends'])}
							<div class="d-flex align-items-center gap-1 flex-0">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M13.5 4.5C13.5 5.32843 12.8284 6 12 6C11.1716 6 10.5 5.32843 10.5 4.5C10.5 3.67157 12 2 12 2C12 2 13.5 3.67157 13.5 4.5Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M12 6V9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M17.6667 14C19.2315 14 20.5 12.8807 20.5 11.5C20.5 10.1193 19.2315 9 17.6667 9H6.33333C4.76853 9 3.5 10.1193 3.5 11.5C3.5 12.8807 4.76853 14 6.33333 14C7.70408 14 8.90415 13.1411 9.16667 12C9.42919 13.1411 10.6293 14 12 14C13.3707 14 14.5708 13.1411 14.8333 12C15.0959 13.1411 16.2959 14 17.6667 14Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M5 14L5.52089 16.5796C6.04532 19.1768 6.30754 20.4754 7.19608 21.2377C8.08462 22 9.33608 22 11.839 22H12.161C14.6639 22 15.9154 22 16.8039 21.2377C17.6925 20.4754 17.9547 19.1768 18.4791 16.5796L19 14" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
								{$profile['user_birthdate']|date_format:$system['system_date_format']}
							</div>
						{/if}
					{/if}
					
					{if $system['website_info_enabled']}
						{if $profile['user_website']}
							<div class="d-flex align-items-center gap-1 flex-0">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M9.14339 10.691L9.35031 10.4841C11.329 8.50532 14.5372 8.50532 16.5159 10.4841C18.4947 12.4628 18.4947 15.671 16.5159 17.6497L13.6497 20.5159C11.671 22.4947 8.46279 22.4947 6.48405 20.5159C4.50532 18.5372 4.50532 15.329 6.48405 13.3503L6.9484 12.886" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M17.0516 11.114L17.5159 10.6497C19.4947 8.67095 19.4947 5.46279 17.5159 3.48405C15.5372 1.50532 12.329 1.50532 10.3503 3.48405L7.48405 6.35031C5.50532 8.32904 5.50532 11.5372 7.48405 13.5159C9.46279 15.4947 12.671 15.4947 14.6497 13.5159L14.8566 13.309" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
								<a target="_blank" href="{$profile['user_website']}">{$profile['user_website']}</a>
							</div>
						{/if}
					{/if}
				</div>
				
				{if $view == ""}
					<div class="mt-2">
						<a href="{$system['system_url']}/{$profile['user_name']}/followers" class="body-color small">
							<span class="fw-semibold">{$profile['followers_count']}</span>
							<span class="text-muted">{__("Followers")}</span>
						</a>
					</div>
				{/if}
				
				<!-- profile-buttons -->
				<div class="profile-buttons-wrapper position-absolute d-flex align-items-center gap-2 flex-wrap">
					{if $user->_logged_in}
						{if $user->_data['user_id'] != $profile['user_id']}
							<!-- add friend -->
							{if $system['friends_enabled']}
								{if $profile['we_friends']}
									<button type="button" class="btn btn-success btn-delete js_friend-remove" data-uid="{$profile['user_id']}">
										<span class="">{__("Friends")}</span>
									</button>
								{elseif $profile['he_request']}
									<button type="button" class="btn btn-primary js_friend-accept" data-uid="{$profile['user_id']}">
										<span class="">{__("Confirm")}</span>
									</button>
									<button type="button" class="btn btn-danger js_friend-decline" data-uid="{$profile['user_id']}">
										<span class="">{__("Decline")}</span>
									</button>
								{elseif $profile['i_request']}
									<button type="button" class="btn btn-gray js_friend-cancel" data-uid="{$profile['user_id']}">
										<span class="">{__("Sent")}</span>
									</button>
								{elseif !$profile['friendship_declined']}
									<button type="button" class="btn btn-success js_friend-add" data-uid="{$profile['user_id']}">
										<span class="">{__("Add Friend")}</span>
									</button>
								{/if}
							{/if}
							<!-- add friend -->

							<!-- follow -->
							{if $profile['i_follow']}
								<button type="button" class="btn btn-gray js_unfollow" data-uid="{$profile['user_id']}">
									{__("Following")}
								</button>
							{else}
								<button type="button" class="btn btn-gray js_follow" data-uid="{$profile['user_id']}">
									{__("Follow")}
								</button>
							{/if}
							<!-- follow -->
							
							<!-- message -->
							{if $user->_logged_in}
								{if $system['chat_enabled'] && $profile['user_privacy_chat'] == "public" || ($profile['user_privacy_chat'] == "friends" && $profile['we_friends'])}
									<button type="button" {if $profile['chat_price']}title="{print_money($profile['chat_price'])}"{/if} class="btn btn-gray rounded-circle p-2 js_chat-start" data-uid="{$profile['user_id']}" data-name="{$profile['name']}" data-link="{$profile['user_name']}" data-picture="{$profile['user_picture']}">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none"><path d="M8 13.5H16M8 8.5H12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path d="M6.09881 19C4.7987 18.8721 3.82475 18.4816 3.17157 17.8284C2 16.6569 2 14.7712 2 11V10.5C2 6.72876 2 4.84315 3.17157 3.67157C4.34315 2.5 6.22876 2.5 10 2.5H14C17.7712 2.5 19.6569 2.5 20.8284 3.67157C22 4.84315 22 6.72876 22 10.5V11C22 14.7712 22 16.6569 20.8284 17.8284C19.6569 19 17.7712 19 14 19C13.4395 19.0125 12.9931 19.0551 12.5546 19.155C11.3562 19.4309 10.2465 20.0441 9.14987 20.5789C7.58729 21.3408 6.806 21.7218 6.31569 21.3651C5.37769 20.6665 6.29454 18.5019 6.5 17.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"></path></svg>
									</button>
								{/if}
							{/if}
							<!-- message -->
							
							<!-- gifts -->
							{if $system['gifts_enabled']}
								{if $user->_data['can_send_gifts'] && ($profile['user_privacy_gifts'] == "public" || ($profile['user_privacy_gifts'] == "friends" && $profile['we_friends']))}
									<button type="button" class="btn btn-gray rounded-circle p-2" title='{__("Send a Gift")}' data-toggle="modal" data-url="#gifts" data-options='{ "uid": {$profile["user_id"]} }'>
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none"><path d="M4 11V15C4 18.2998 4 19.9497 5.02513 20.9749C6.05025 22 7.70017 22 11 22H13C16.2998 22 17.9497 22 18.9749 20.9749C20 19.9497 20 18.2998 20 15V11" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /><path d="M3 9C3 8.25231 3 7.87846 3.20096 7.6C3.33261 7.41758 3.52197 7.26609 3.75 7.16077C4.09808 7 4.56538 7 5.5 7H18.5C19.4346 7 19.9019 7 20.25 7.16077C20.478 7.26609 20.6674 7.41758 20.799 7.6C21 7.87846 21 8.25231 21 9C21 9.74769 21 10.1215 20.799 10.4C20.6674 10.5824 20.478 10.7339 20.25 10.8392C19.9019 11 19.4346 11 18.5 11H5.5C4.56538 11 4.09808 11 3.75 10.8392C3.52197 10.7339 3.33261 10.5824 3.20096 10.4C3 10.1215 3 9.74769 3 9Z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round" /><path d="M6 3.78571C6 2.79949 6.79949 2 7.78571 2H8.14286C10.2731 2 12 3.7269 12 5.85714V7H9.21429C7.43908 7 6 5.56091 6 3.78571Z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round" /><path d="M18 3.78571C18 2.79949 17.2005 2 16.2143 2H15.8571C13.7269 2 12 3.7269 12 5.85714V7H14.7857C16.5609 7 18 5.56091 18 3.78571Z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round" /><path d="M12 11L12 22" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg>
									</button>
								{/if}
							{/if}
							<!-- gifts -->

							<!-- poke & report & block menu -->
							<div class="dropdown">
								<button type="button" class="btn btn-gray rounded-circle p-2" data-bs-toggle="dropdown" data-display="static">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none"><path d="M11.9959 12H12.0049" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M17.9998 12H18.0088" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.99981 12H6.00879" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path></svg>
								</button>
								<div class="dropdown-menu dropdown-menu-end action-dropdown-menu">
									<!-- poke -->
									{if $system['pokes_enabled'] && !$profile['i_poked']}
										{if $profile['user_privacy_poke'] == "public" || ($profile['user_privacy_poke'] == "friends" && $profile['we_friends'])}
											<div class="dropdown-item pointer align-items-start js_poke" data-id="{$profile['user_id']}" data-name="{$profile['name']}">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M2 8.83415H2.94868C3.59418 8.83415 4.22251 8.62541 4.74055 8.23886L9.64341 4.58042C10.2089 4.15849 10.9104 3.82148 11.5581 4.10005C12.6065 4.551 13.2876 5.82324 11.7157 7.38045L10.0063 8.97804L20.4294 8.97804C22.4726 9.03427 22.5739 12.3231 20.4294 12.4637H14.4894C14.6805 13.9441 13.6371 20.9177 9.21687 19.9012C9.00686 19.8529 8.79375 19.8047 8.58346 19.7576C7.6647 19.5519 6.02726 18.9439 5.06998 18.2735C4.07344 17.5755 3.08083 17.8218 2 17.8218" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												<div class="action">
													{__("Poke")}
													<div class="action-desc">{__("Let them know you are here")}</div>
												</div>
											</div>
										{/if}
									{/if}
									<!-- poke -->
									
									<!-- share -->
									<div class="dropdown-item pointer align-items-start" data-toggle="modal" data-url="modules/share.php?node_type=user&node_username={$profile['user_name']}">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M18 7C18.7745 7.16058 19.3588 7.42859 19.8284 7.87589C21 8.99181 21 10.7879 21 14.38C21 17.9721 21 19.7681 19.8284 20.8841C18.6569 22 16.7712 22 13 22H11C7.22876 22 5.34315 22 4.17157 20.8841C3 19.7681 3 17.9721 3 14.38C3 10.7879 3 8.99181 4.17157 7.87589C4.64118 7.42859 5.2255 7.16058 6 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M12.0253 2.00052L12 14M12.0253 2.00052C11.8627 1.99379 11.6991 2.05191 11.5533 2.17492C10.6469 2.94006 9 4.92886 9 4.92886M12.0253 2.00052C12.1711 2.00657 12.3162 2.06476 12.4468 2.17508C13.3531 2.94037 15 4.92886 15 4.92886" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
										<div class="action">
											{__("Share")}
											<div class="action-desc">{__("Share this profile")}</div>
										</div>
									</div>
									<!-- share -->
									
									<!-- report -->
									<div class="dropdown-item pointer align-items-start" data-toggle="modal" data-url="data/report.php?do=create&handle=user&id={$profile['user_id']}">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M12 16H12.009" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M12 13V8" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M15.1528 4.28405C13.9789 3.84839 13.4577 2.10473 12.1198 2.00447C12.0403 1.99851 11.9603 1.99851 11.8808 2.00447C10.5429 2.10474 10.0217 3.84829 8.8478 4.28405C7.60482 4.74524 5.90521 3.79988 4.85272 4.85239C3.83967 5.86542 4.73613 7.62993 4.28438 8.84747C3.82256 10.0915 1.89134 10.6061 2.0048 12.1195C2.10506 13.4574 3.84872 13.9786 4.28438 15.1525C4.73615 16.37 3.83962 18.1346 4.85272 19.1476C5.90506 20.2001 7.60478 19.2551 8.8478 19.7159C10.0214 20.1522 10.5431 21.8954 11.8808 21.9955C11.9603 22.0015 12.0403 22.0015 12.1198 21.9955C13.4575 21.8954 13.9793 20.1521 15.1528 19.7159C16.3704 19.2645 18.1351 20.1607 19.1479 19.1476C20.2352 18.0605 19.1876 16.2981 19.762 15.042C20.2929 13.8855 22.1063 13.3439 21.9958 11.8805C21.8957 10.5428 20.1525 10.021 19.7162 8.84747C19.2554 7.60445 20.2004 5.90473 19.1479 4.85239C18.0955 3.79983 16.3958 4.74527 15.1528 4.28405Z" stroke="currentColor" stroke-width="1.75" /></svg>
										<div class="action">
											{__("Report")}
											<div class="action-desc">{__("Report this to admins")}</div>
										</div>
									</div>
									<!-- report -->
								  
									<!-- block -->
									<div class="dropdown-item pointer align-items-start js_block-user" data-uid="{$profile['user_id']}">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M5.25 5L19.25 19" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M22.25 12C22.25 6.47715 17.7728 2 12.25 2C6.72715 2 2.25 6.47715 2.25 12C2.25 17.5228 6.72715 22 12.25 22C17.7728 22 22.25 17.5228 22.25 12Z" stroke="currentColor" stroke-width="1.75" /></svg>
										<div class="action">
											{__("Block")}
											<div class="action-desc">{__("This user won't be able to reach you")}</div>
										</div>
									</div>
									<!-- block -->
									
									<!-- manage -->
									{if $user->_is_admin}
										<div class="dropdown-divider"></div>
										<a class="dropdown-item" href="{$system['system_url']}/admincp/users/edit/{$profile['user_id']}">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M10.5 22H6.59087C5.04549 22 3.81631 21.248 2.71266 20.1966C0.453365 18.0441 4.1628 16.324 5.57757 15.4816C8.12805 13.9629 11.2057 13.6118 14 14.4281" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M16.5 6.5C16.5 8.98528 14.4853 11 12 11C9.51472 11 7.5 8.98528 7.5 6.5C7.5 4.01472 9.51472 2 12 2C14.4853 2 16.5 4.01472 16.5 6.5Z" stroke="currentColor" stroke-width="1.75" /><path d="M18.4332 13.8485C18.7685 13.4851 18.9362 13.3035 19.1143 13.1975C19.5442 12.9418 20.0736 12.9339 20.5107 13.1765C20.6918 13.2771 20.8646 13.4537 21.2103 13.8067C21.5559 14.1598 21.7287 14.3364 21.8272 14.5214C22.0647 14.9679 22.0569 15.5087 21.8066 15.9478C21.7029 16.1298 21.5251 16.3011 21.1694 16.6437L16.9378 20.7194C16.2638 21.3686 15.9268 21.6932 15.5056 21.8577C15.0845 22.0222 14.6214 22.0101 13.6954 21.9859L13.5694 21.9826C13.2875 21.9752 13.1466 21.9715 13.0646 21.8785C12.9827 21.7855 12.9939 21.6419 13.0162 21.3548L13.0284 21.1988C13.0914 20.3906 13.1228 19.9865 13.2807 19.6232C13.4385 19.2599 13.7107 18.965 14.2552 18.375L18.4332 13.8485Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /></svg>
											{__("Edit in Admin Panel")}
										</a>
									{elseif $user->_is_moderator}
										<div class="dropdown-divider"></div>
										<a class="dropdown-item" href="{$system['system_url']}/modcp/users/edit/{$profile['user_id']}">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M10.5 22H6.59087C5.04549 22 3.81631 21.248 2.71266 20.1966C0.453365 18.0441 4.1628 16.324 5.57757 15.4816C8.12805 13.9629 11.2057 13.6118 14 14.4281" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M16.5 6.5C16.5 8.98528 14.4853 11 12 11C9.51472 11 7.5 8.98528 7.5 6.5C7.5 4.01472 9.51472 2 12 2C14.4853 2 16.5 4.01472 16.5 6.5Z" stroke="currentColor" stroke-width="1.75" /><path d="M18.4332 13.8485C18.7685 13.4851 18.9362 13.3035 19.1143 13.1975C19.5442 12.9418 20.0736 12.9339 20.5107 13.1765C20.6918 13.2771 20.8646 13.4537 21.2103 13.8067C21.5559 14.1598 21.7287 14.3364 21.8272 14.5214C22.0647 14.9679 22.0569 15.5087 21.8066 15.9478C21.7029 16.1298 21.5251 16.3011 21.1694 16.6437L16.9378 20.7194C16.2638 21.3686 15.9268 21.6932 15.5056 21.8577C15.0845 22.0222 14.6214 22.0101 13.6954 21.9859L13.5694 21.9826C13.2875 21.9752 13.1466 21.9715 13.0646 21.8785C12.9827 21.7855 12.9939 21.6419 13.0162 21.3548L13.0284 21.1988C13.0914 20.3906 13.1228 19.9865 13.2807 19.6232C13.4385 19.2599 13.7107 18.965 14.2552 18.375L18.4332 13.8485Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /></svg>
											{__("Edit in Moderator Panel")}
										</a>
									{/if}
									<!-- manage -->
								</div>
							</div>
							<!-- poke & report & block menu -->
						{else}
							<!-- edit -->
							<a href="{$system['system_url']}/settings/profile" class="btn btn-gray">
								{__("Edit")}
							</a>
							<!-- edit -->
						{/if}
					{/if}
				</div>
				<!-- profile-buttons -->
			</div>
		</div>
		<!-- profile-header -->

		<!-- profile-tabs -->
		<div class="position-sticky x_top_posts profile-tabs-wrapper">
			<div class="d-flex align-items-center justify-content-center">
				<div {if $view == ""}class="active fw-semibold" {/if}>
					<a href="{$system['system_url']}/{$profile['user_name']}" class="body-color side_item_hover w-100 text-center d-block">
						<span class="position-relative d-inline-block py-3">{__("Timeline")}</span>
					</a>
				</div>
				<div {if $view == "friends" || $view == "followers" || $view == "followings"}class="active fw-semibold" {/if}>
					<a href="{$system['system_url']}/{$profile['user_name']}/{if $system['friends_enabled']}friends{else}followers{/if}" class="body-color side_item_hover w-100 text-center d-block">
						<span class="position-relative d-inline-block py-3">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</span>
					</a>
				</div>
				<div {if $view == "photos" || $view == "albums" || $view == "album"}class="active fw-semibold" {/if}>
					<a href="{$system['system_url']}/{$profile['user_name']}/photos" class="body-color side_item_hover w-100 text-center d-block">
						<span class="position-relative d-inline-block py-3">{__("Photos")}</span>
					</a>
				</div>
				{if $system['videos_enabled']}
					<div {if $view == "videos" || $view == "reels"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/{$profile['user_name']}/videos" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Videos")}</span>
						</a>
					</div>
				{elseif $system['reels_enabled']}
					<div {if $view == "reels"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/{$profile['user_name']}/reels" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Reels")}</span>
						</a>
					</div>
				{/if}
				{if $profile['can_sell_products']}
					<div {if $view == "products"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/{$profile['user_name']}/products" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Products")}</span>
						</a>
					</div>
				{/if}
				{if $system['pages_enabled']}
					<div {if $view == "pages"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/{$profile['user_name']}/pages" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Pages")}</span>
						</a>
					</div>
				{/if}
				{if $system['groups_enabled']}
					<div {if $view == "groups"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/{$profile['user_name']}/groups" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Groups")}</span>
						</a>
					</div>
				{/if}
				{if $system['events_enabled']}
					<div {if $view == "events"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/{$profile['user_name']}/events" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Events")}</span>
						</a>
					</div>
				{/if}
			</div>
		</div>
		<!-- profile-tabs -->

		<!-- profile-content -->
		<div class="row x_content_row">
			<!-- view content -->
			{if $view == ""}

				<!-- left panel -->
				<div class="col-lg-4 px-lg-3 py-3 order-2 x_sidebar_order js_sticky-sidebar">
					<!-- subscribe -->
					{if $user->_logged_in && $user->_data['user_id'] != $profile['user_id'] && $profile['has_subscriptions_plans']}
						<button class="btn btn-primary mb-3 w-100" data-toggle="modal" data-url="monetization/controller.php?do=get_plans&node_id={$profile['user_id']}&node_type=profile" data-size="large">
							{__("SUBSCRIBE")} {__("STARTING FROM")} ({print_money($profile['user_monetization_min_price']|number_format:2)})
						</button>
					{/if}
					<!-- subscribe -->

					<!-- tips -->
					{if $user->_logged_in && $user->_data['user_id'] != $profile['user_id'] && $profile['can_receive_tips'] && $profile['user_tips_enabled']}
						<button type="button" class="btn btn-primary mb-3 w-100" data-toggle="modal" data-url="#send-tip" data-options='{ "id": "{$profile['user_id']}"}'>
						  {__("Send a Tip")}
						</button>
					{/if}
					<!-- tips -->

					<!-- search -->
					<div class="mb-3">
						<form action="{$system['system_url']}/{$profile['user_name']}/search" method="get">
							<div class="position-relative">
								<input type="search" class="form-control shadow-none rounded-pill x_search_filter" name="query" placeholder='{__("Search")}'>
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"></path></svg>
							</div>
						</form>
					</div>
					<!-- search -->

					{if $system['merits_enabled'] && $system['merits_widgets_statistics'] && $profile['user_id'] == $user->_data['user_id']}
						<!-- panel [merits] -->
						<div class="mb-3 overflow-hidden content">
							<h6 class="headline-font fw-semibold m-0 side_widget_title">
								{__("Merits")}
							</h6>
				
							<div class="row text-center">
								<div class="col-4 mb-3">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none"><path d="M13.7276 3.44418L15.4874 6.99288C15.7274 7.48687 16.3673 7.9607 16.9073 8.05143L20.0969 8.58575C22.1367 8.92853 22.6167 10.4206 21.1468 11.8925L18.6671 14.3927C18.2471 14.8161 18.0172 15.6327 18.1471 16.2175L18.8571 19.3125C19.417 21.7623 18.1271 22.71 15.9774 21.4296L12.9877 19.6452C12.4478 19.3226 11.5579 19.3226 11.0079 19.6452L8.01827 21.4296C5.8785 22.71 4.57865 21.7522 5.13859 19.3125L5.84851 16.2175C5.97849 15.6327 5.74852 14.8161 5.32856 14.3927L2.84884 11.8925C1.389 10.4206 1.85895 8.92853 3.89872 8.58575L7.08837 8.05143C7.61831 7.9607 8.25824 7.48687 8.49821 6.99288L10.258 3.44418C11.2179 1.51861 12.7777 1.51861 13.7276 3.44418Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg>
									<div class="mt-2">
										<div class="fw-medium small">{__("Received")}</div>
										<div><span class="main fw-semibold">{$user->_data['merits_balance']['received']}</span></div>
									</div>
								</div>
								<div class="col-4 mb-3">
									<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M11.9961 1.25C13.0454 1.25 13.8719 2.04253 14.3995 3.11191L16.1616 6.66516C16.215 6.77513 16.3417 6.92998 16.5321 7.07164C16.7223 7.21315 16.9086 7.29121 17.0311 7.3118L20.2207 7.84613C21.3729 8.03973 22.3386 8.60449 22.6521 9.5879C22.9653 10.5705 22.5064 11.5916 21.6778 12.4216L21.677 12.4225L19.1991 14.9209C19.1009 15.0199 18.9909 15.2064 18.9219 15.4494C18.8534 15.6908 18.8473 15.9107 18.8784 16.0527L18.8788 16.0547L19.5877 19.1454C19.8818 20.4317 19.7843 21.7073 18.8771 22.3742C17.9667 23.0433 16.7227 22.7467 15.5925 22.0736L12.6026 20.289C12.477 20.214 12.2614 20.1532 12.0011 20.1532C11.7427 20.1532 11.5226 20.2132 11.3888 20.291L11.3869 20.2921L8.40288 22.0732C7.27405 22.7487 6.03154 23.04 5.12111 22.3702C4.21449 21.7032 4.11214 20.43 4.40711 19.1447L5.1159 16.0547L5.11633 16.0527C5.14741 15.9107 5.14133 15.6908 5.0728 15.4494C5.0038 15.2064 4.89379 15.0199 4.79558 14.9209L2.31585 12.4206C1.49265 11.5906 1.03521 10.5704 1.34595 9.58925C1.65759 8.60525 2.62143 8.0398 3.77433 7.84606L6.96132 7.31219L6.96233 7.31202C7.07917 7.29175 7.2627 7.21456 7.45248 7.07268C7.64261 6.93054 7.76959 6.77535 7.82312 6.66516L7.82582 6.65967L9.58562 3.11097L9.58632 3.10957C10.119 2.04108 10.948 1.25 11.9961 1.25Z" fill="currentColor"/></svg>
									<div class="mt-2">
										<div class="fw-medium small">{__("Sent")}</div>
										<div><span class="main fw-semibold">{$user->_data['merits_balance']['sent']}</span></div>
									</div>
								</div>
								<div class="col-4 mb-3">
									<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M11.9979 1.25001L12 1.25L12.0034 1.25C12.4176 1.25 12.7534 1.58579 12.7534 2V19.4031L8.40699 22.0736C7.27683 22.7467 6.0328 23.0433 5.12244 22.3742C4.21519 21.7073 4.11776 20.4318 4.41178 19.1454L5.12072 16.0547L5.12115 16.0528C5.24843 15.4978 4.96035 15.0669 4.8004 14.9209L2.32248 12.4225L2.32151 12.4215C1.4931 11.5915 1.03422 10.5704 1.34745 9.5879C1.66095 8.60449 2.62664 8.03974 3.77877 7.84613L6.96842 7.31181C7.16455 7.28519 7.61357 7.11749 7.84061 6.65966L9.59975 3.11238C10.1265 2.04505 10.9512 1.25291 11.9979 1.25001Z" fill="currentColor"/><path d="M14.6668 5.30909C15.0379 5.12507 15.4879 5.27672 15.6719 5.64781L16.1764 6.66515C16.2299 6.77535 16.3569 6.93055 16.547 7.07269C16.7368 7.21456 16.9203 7.29175 17.0372 7.31202L17.0382 7.31219L20.2252 7.84606C21.3781 8.0398 22.3419 8.60525 22.6536 9.58926C22.9643 10.5704 22.5069 11.5906 21.6837 12.4206L19.2039 14.9209C19.1057 15.0199 18.9957 15.2064 18.9267 15.4494C18.8582 15.6908 18.8521 15.9107 18.8832 16.0528L18.8836 16.0547L19.5924 19.1447C19.8874 20.4301 19.785 21.7032 18.8784 22.3702C17.968 23.04 16.7255 22.7487 15.5966 22.0732L14.6156 21.4877C14.2599 21.2754 14.1437 20.8149 14.356 20.4593C14.5683 20.1036 15.0287 19.9874 15.3844 20.1996L16.3661 20.7856C17.377 21.3905 17.8551 21.2609 17.9895 21.162C18.1278 21.0603 18.3954 20.6347 18.1304 19.4803L17.4193 16.3802C17.3209 15.9375 17.3651 15.4576 17.4837 15.0398C17.6022 14.6224 17.8172 14.189 18.1389 13.8646L20.6187 11.3644C21.2553 10.7225 21.2928 10.2607 21.2236 10.0422C21.1553 9.82646 20.8639 9.47442 19.977 9.32539L16.7877 8.79113L16.7851 8.79068C16.3719 8.71994 15.971 8.51489 15.6489 8.27407C15.3274 8.03375 15.0153 7.70613 14.8286 7.32363L14.3281 6.31422C14.1441 5.94313 14.2957 5.49312 14.6668 5.30909Z" fill="currentColor"/></svg>
									<div class="mt-2">
										<div class="fw-medium small">{__("Left")}</div>
										<div><span class="main fw-semibold">{$user->_data['merits_balance']['remining']}</span></div>
									</div>
								</div>
							</div>
							<div class="px-3 pb-3 text-center">
								<button class="btn btn-primary" data-toggle="modal" data-size="large" data-url="users/merits.php?do=publish">
									{__("Send Merit")}
								</button>
							</div>
						</div>
						<!-- panel [merits] -->
					{/if}

					<!-- panel [profile completion] -->
					{if isset($profile['profile_completion']) && $profile['profile_completion'] < 100}
						<div class="mb-3 overflow-hidden content">
							<h6 class="headline-font fw-semibold m-0 side_widget_title d-flex align-items-center justify-content-between">
								<div>
									{__("Profile Completion")}
								</div>
								<span class="small fw-normal">
									<small>{$profile['profile_completion']}%</small>
								</span>
							</h6>
							<div class="px-3 side_item_list pt-1">
								<div class="progress mb-3">
									<div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="{$profile['profile_completion']}" aria-valuemin="0" aria-valuemax="100" style="width: {$profile['profile_completion']}%"></div>
								</div>
								{if $system['verification_for_posts']}
									<div class="mt-2">
										{if !$profile['user_verified']}
											<a href="{$system['system_url']}/settings/verification" class="d-inline-flex align-items-center gap-2 body-color">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M12 4V20M20 12H4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												{__("Verify your account to add content")}
											</a>
										{else}
											<span class="text-decoration-line-through d-inline-flex align-items-center gap-2 text-muted">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M5 14L8.5 17.5L19 6.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												{__("Verify your account to add content")}
											</span>
										{/if}
									</div>
								{/if}
								
								<div class="mt-2">
									{if $profile['user_picture_default']}
										<span class="pointer d-inline-flex align-items-center gap-2 js_profile-image-trigger">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M12 4V20M20 12H4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
											{__("Add your profile picture")}
										</span>
									{else}
										<span class="text-decoration-line-through d-inline-flex align-items-center gap-2 text-muted">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M5 14L8.5 17.5L19 6.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
											{__("Add your profile picture")}
										</span>
									{/if}
								</div>
								
								<div class="mt-2">
									{if $profile['user_cover_default']}
										<span class="pointer d-inline-flex align-items-center gap-2 js_profile-cover-trigger">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M12 4V20M20 12H4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
											{__("Add your profile cover")}
										</span>
									{else}
										<span class="text-decoration-line-through d-inline-flex align-items-center gap-2 text-muted">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M5 14L8.5 17.5L19 6.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
											{__("Add your profile cover")}
										</span>
									{/if}
								</div>
								
								{if $system['biography_info_enabled']}
									<div class="mt-2">
										{if !$profile['user_biography']}
											<a href="{$system['system_url']}/settings/profile" class="d-inline-flex align-items-center gap-2 body-color">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M12 4V20M20 12H4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												{__("Add your biography")}
											</a>
										{else}
											<span class="text-decoration-line-through d-inline-flex align-items-center gap-2 text-muted">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M5 14L8.5 17.5L19 6.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												{__("Add your biography")}
											</span>
										{/if}
									</div>
								{/if}
								
								<div class="mt-2">
									{if !$profile['user_birthdate']}
										<a href="{$system['system_url']}/settings/profile" class="d-inline-flex align-items-center gap-2 body-color">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M12 4V20M20 12H4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
											{__("Add your birthdate")}
										</a>
									{else}
										<span class="text-decoration-line-through d-inline-flex align-items-center gap-2 text-muted">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M5 14L8.5 17.5L19 6.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
											{__("Add your birthdate")}
										</span>
									{/if}
								</div>
								
								{if $system['relationship_info_enabled']}
									<div class="mt-2">
										{if !$profile['user_relationship']}
											<a href="{$system['system_url']}/settings/profile" class="d-inline-flex align-items-center gap-2 body-color">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M12 4V20M20 12H4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												{__("Add your relationship")}
											</a>
										{else}
											<span class="text-decoration-line-through d-inline-flex align-items-center gap-2 text-muted">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M5 14L8.5 17.5L19 6.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												{__("Add your relationship")}
											</span>
										{/if}
									</div>
								{/if}
								
								{if $system['work_info_enabled']}
									<div class="mt-2">
										{if !$profile['user_work_title'] || !$profile['user_work_place']}
											<a href="{$system['system_url']}/settings/profile/work" class="d-inline-flex align-items-center gap-2 body-color">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M12 4V20M20 12H4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												{__("Add your work info")}
											</a>
										{else}
											<span class="text-decoration-line-through d-inline-flex align-items-center gap-2 text-muted">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M5 14L8.5 17.5L19 6.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												{__("Add your work info")}
											</span>
										{/if}
									</div>
								{/if}
								
								{if $system['location_info_enabled']}
									<div class="mt-2">
										{if !$profile['user_current_city'] || !$profile['user_hometown']}
											<a href="{$system['system_url']}/settings/profile/location" class="d-inline-flex align-items-center gap-2 body-color">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M12 4V20M20 12H4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												{__("Add your location info")}
											</a>
										{else}
											<span class="text-decoration-line-through d-inline-flex align-items-center gap-2 text-muted">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M5 14L8.5 17.5L19 6.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												{__("Add your location info")}
											</span>
										{/if}
									</div>
								{/if}
								
								{if $system['education_info_enabled']}
									<div class="mt-2">
										{if !$profile['user_edu_major'] || !$profile['user_edu_school']}
											<a href="{$system['system_url']}/settings/profile/education" class="d-inline-flex align-items-center gap-2 body-color">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M12 4V20M20 12H4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												{__("Add your education info")}
											</a>
										{else}
											<span class="text-decoration-line-through d-inline-flex align-items-center gap-2 text-muted">
												<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M5 14L8.5 17.5L19 6.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
												{__("Add your education info")}
											</span>
										{/if}
									</div>
								{/if}
							</div>
						</div>
					{/if}
					<!-- panel [profile completion] -->

					<!-- panel [about] -->
					{if $system['work_info_enabled'] || $system['education_info_enabled']}
						{if $profile['user_work_title'] || $profile['user_edu_major']}
							<div class="mb-3 overflow-hidden content">
								<ul class="px-3 side_item_list">
									<!-- info -->
									{if $system['work_info_enabled']}
										{if $profile['user_work_title']}
											{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_work'] == "public" || ($profile['user_privacy_work'] == "friends" && $profile['we_friends'])}
												<div class="d-flex align-items-start gap-2">
													<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M3 11L3.15288 14.2269C3.31714 17.6686 3.39927 19.3894 4.55885 20.4447C5.71843 21.5 7.52716 21.5 11.1446 21.5H12.8554C16.4728 21.5 18.2816 21.5 19.4412 20.4447C20.6007 19.3894 20.6829 17.6686 20.8471 14.2269L21 11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M2.84718 10.4431C4.54648 13.6744 8.3792 15 12 15C15.6208 15 19.4535 13.6744 21.1528 10.4431C21.964 8.90056 21.3498 6 19.352 6H4.648C2.65023 6 2.03603 8.90056 2.84718 10.4431Z" stroke="currentColor" stroke-width="1.75"></path><path d="M11.9999 11H12.0089" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M15.9999 6L15.9116 5.69094C15.4716 4.15089 15.2516 3.38087 14.7278 2.94043C14.204 2.5 13.5083 2.5 12.1168 2.5H11.8829C10.4915 2.5 9.79575 2.5 9.27198 2.94043C8.7482 3.38087 8.52819 4.15089 8.08818 5.69094L7.99988 6" stroke="currentColor" stroke-width="1.75"></path></svg>
													{$profile['user_work_title']}
													{if $profile['user_work_place']}
														{__("at")}
														{if $profile['user_work_url']}
															<a target="_blank" href="{$profile['user_work_url']}">{$profile['user_work_place']}</a>
														{else}
															<span>{$profile['user_work_place']}</span>
														{/if}
													{/if}
												</div>
											{/if}
										{/if}
									{/if}
								  
									{if $system['education_info_enabled']}
										{if $profile['user_edu_major']}
											{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_education'] == "public" || ($profile['user_privacy_education'] == "friends" && $profile['we_friends'])}
												<div class="d-flex align-items-start gap-2 mt-2">
													<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="flex-0"><path d="M2 8C2 9.34178 10.0949 13 11.9861 13C13.8772 13 21.9722 9.34178 21.9722 8C21.9722 6.65822 13.8772 3 11.9861 3C10.0949 3 2 6.65822 2 8Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M5.99414 11L6.23925 16.6299C6.24415 16.7426 6.25634 16.8555 6.28901 16.9635C6.38998 17.2973 6.57608 17.6006 6.86 17.8044C9.08146 19.3985 14.8901 19.3985 17.1115 17.8044C17.3956 17.6006 17.5816 17.2973 17.6826 16.9635C17.7152 16.8555 17.7274 16.7426 17.7324 16.6299L17.9774 11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M20.4734 9.5V16.5M20.4734 16.5C19.6814 17.9463 19.3312 18.7212 18.9755 20C18.8983 20.455 18.9596 20.6843 19.2732 20.8879C19.4006 20.9706 19.5537 21 19.7055 21H21.2259C21.3876 21 21.5507 20.9663 21.6838 20.8745C21.9753 20.6735 22.0503 20.453 21.9713 20C21.6595 18.8126 21.2623 18.0008 20.4734 16.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
													<div>
													{__("Studied")} {$profile['user_edu_major']}
													{__("at")} <span class="fw-semibold">{$profile['user_edu_school']}</span>
													{if $profile['user_edu_class']}
													  <div class="small text-muted">
														{__("Class of")} {$profile['user_edu_class']}
													  </div>
													{/if}
													</div>
												</div>
											{/if}
										{/if}
									{/if}
									<!-- info -->
								</ul>
							</div>
						{/if}
					{/if}
					<!-- panel [about] -->

					<!-- custom fields [basic] -->
					{if $custom_fields['basic']}
						{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_basic'] == "public" || ($profile['user_privacy_basic'] == "friends" && $profile['we_friends'])}
							<div class="mb-3 overflow-hidden content">
								<h6 class="headline-font fw-semibold m-0 side_widget_title">
									{__("Basic Info")}
								</h6>
								<ul class="">
									{foreach $custom_fields['basic'] as $custom_field}
										{if $custom_field['value']}
											<li class="feeds-item px-3 side_item_list">
												<div class="mb-1 fw-medium">{__($custom_field['label'])}</div>
												{if $custom_field['type'] == "textbox" && $custom_field['is_link']}
													<a href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
												{elseif $custom_field['type'] == "multipleselectbox"}
													{__($custom_field['value_string']|trim)}
												{else}
													{__($custom_field['value']|trim)}
												{/if}
											</li>
										{/if}
									{/foreach}
								</ul>
							</div>
						{/if}
					{/if}
					<!-- custom fields [basic] -->

					<!-- custom fields [work] -->
					{if $custom_fields['work']}
						{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_work'] == "public" || ($profile['user_privacy_work'] == "friends" && $profile['we_friends'])}
							<div class="mb-3 overflow-hidden content">
								<h6 class="headline-font fw-semibold m-0 side_widget_title">
									{__("Work Info")}
								</h6>
								<ul class="">
									{foreach $custom_fields['work'] as $custom_field}
										{if $custom_field['value']}
											<li class="feeds-item px-3 side_item_list">
												<div class="mb-1 fw-medium">{__($custom_field['label'])}</div>
												{if $custom_field['type'] == "textbox" && $custom_field['is_link']}
													<a href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
												{elseif $custom_field['type'] == "multipleselectbox"}
													{__($custom_field['value_string']|trim)}
												{else}
													{__($custom_field['value']|trim)}
												{/if}
											</li>
										{/if}
									{/foreach}
								</ul>
							</div>
						{/if}
					{/if}
					<!-- custom fields [work] -->

					<!-- custom fields [location] -->
					{if $custom_fields['location']}
						{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_location'] == "public" || ($profile['user_privacy_location'] == "friends" && $profile['we_friends'])}
							<div class="mb-3 overflow-hidden content">
								<h6 class="headline-font fw-semibold m-0 side_widget_title">
									{__("Location Info")}
								</h6>
								<ul class="">
									{foreach $custom_fields['location'] as $custom_field}
										{if $custom_field['value']}
											<li class="feeds-item px-3 side_item_list">
												<div class="mb-1 fw-medium">{__($custom_field['label'])}</div>
												{if $custom_field['type'] == "textbox" && $custom_field['is_link']}
													<a href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
												{elseif $custom_field['type'] == "multipleselectbox"}
													{__($custom_field['value_string']|trim)}
												{else}
													{__($custom_field['value']|trim)}
												{/if}
											</li>
										{/if}
									{/foreach}
								</ul>
							</div>
						{/if}
					{/if}
					<!-- custom fields [location] -->

					<!-- custom fields [education] -->
					{if $custom_fields['education']}
						{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_education'] == "public" || ($profile['user_privacy_education'] == "friends" && $profile['we_friends'])}
							<div class="mb-3 overflow-hidden content">
								<h6 class="headline-font fw-semibold m-0 side_widget_title">
									{__("Education Info")}
								</h6>
								<ul class="">
									{foreach $custom_fields['education'] as $custom_field}
										{if $custom_field['value']}
											<li class="feeds-item px-3 side_item_list">
												<div class="mb-1 fw-medium">{__($custom_field['label'])}</div>
												{if $custom_field['type'] == "textbox" && $custom_field['is_link']}
													<a href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
												{elseif $custom_field['type'] == "multipleselectbox"}
													{__($custom_field['value_string']|trim)}
												{else}
													{__($custom_field['value']|trim)}
												{/if}
											</li>
										{/if}
									{/foreach}
								</ul>
							</div>
						{/if}
					{/if}
					<!-- custom fields [education] -->

					<!-- custom fields [other] -->
					{if $custom_fields['other']}
						{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_other'] == "public" || ($profile['user_privacy_other'] == "friends" && $profile['we_friends'])}
							<div class="mb-3 overflow-hidden content">
								<h6 class="headline-font fw-semibold m-0 side_widget_title">
									{__("Other Info")}
								</h6>
								<ul class="">
									{foreach $custom_fields['other'] as $custom_field}
										{if $custom_field['value']}
											<li class="feeds-item px-3 side_item_list">
												<div class="mb-1 fw-medium">{__($custom_field['label'])}</div>
												{if $custom_field['type'] == "textbox" && $custom_field['is_link']}
													<a href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
												{elseif $custom_field['type'] == "multipleselectbox"}
													{__($custom_field['value_string']|trim)}
												{else}
													{__($custom_field['value']|trim)}
												{/if}
											</li>
										{/if}
									{/foreach}
								</ul>
							</div>
						{/if}
					{/if}
					<!-- custom fields [other] -->

					<!-- social links -->
					{if $system['social_info_enabled']}
						{if $profile['user_social_facebook'] || $profile['user_social_twitter'] || $profile['user_social_youtube'] || $profile['user_social_instagram'] || $profile['user_social_twitch'] || $profile['user_social_linkedin'] || $profile['user_social_vkontakte']}
							<div class="mb-3 overflow-hidden content">
								<h6 class="headline-font fw-semibold m-0 side_widget_title">
									{__("Social Links")}
								</h6>
								<div class="d-flex align-items-center gap-3 px-3 side_item_list">
									{if $profile['user_social_facebook']}
										<a target="_blank" href="{$profile['user_social_facebook']}" class="lh-1">
											{include file='__svg_icons.tpl' icon="facebook" width="24px" height="24px"}
										</a>
									{/if}
									{if $profile['user_social_twitter']}
										<a target="_blank" href="{$profile['user_social_twitter']}" class="lh-1 body-color">
											{include file='__svg_icons.tpl' icon="x" width="24px" height="24px"}
										</a>
									{/if}
									{if $profile['user_social_youtube']}
										<a target="_blank" href="{$profile['user_social_youtube']}" class="lh-1">
											{include file='__svg_icons.tpl' icon="youtube" width="24px" height="24px"}
										</a>
									{/if}
									{if $profile['user_social_instagram']}
										<a target="_blank" href="{$profile['user_social_instagram']}" class="lh-1">
											{include file='__svg_icons.tpl' icon="instagram" width="24px" height="24px"}
										</a>
									{/if}
									{if $profile['user_social_twitch']}
										<a target="_blank" href="{$profile['user_social_twitch']}" class="lh-1">
											{include file='__svg_icons.tpl' icon="twitch" width="24px" height="24px"}
										</a>
									{/if}
									{if $profile['user_social_linkedin']}
										<a target="_blank" href="{$profile['user_social_linkedin']}" class="lh-1">
											{include file='__svg_icons.tpl' icon="linkedin" width="24px" height="24px"}
										</a>
									{/if}
									{if $profile['user_social_vkontakte']}
										<a target="_blank" href="{$profile['user_social_vkontakte']}" class="lh-1">
											{include file='__svg_icons.tpl' icon="vk" width="24px" height="24px"}
										</a>
									{/if}
								</div>
							</div>
						{/if}
					{/if}
					<!-- social links -->

					<!-- photos -->
					{if $profile['photos']}
						<div class="mb-3 overflow-hidden content panel-photos d-none d-md-block">
							<h6 class="headline-font fw-semibold m-0 side_widget_title">
								<a href="{$system['system_url']}/{$profile['user_name']}/photos" class="body-color">{__("Photos")}</a>
							</h6>
							<div class="px-3 side_item_list">
								<div class="row">
									{foreach $profile['photos'] as $photo}
										{include file='__feeds_photo.tpl' _context="photos" _small=true}
									{/foreach}
								</div>
							</div>
						</div>
					{/if}
					<!-- photos -->
					
					{include file='_ads.tpl'}
					{include file='_ads_campaigns.tpl'}
					{include file='_widget.tpl'}

					<!-- mini footer -->
					{include file='_footer_mini.tpl'}
					<!-- mini footer -->
				</div>
				<!-- left panel -->

				<!-- right panel -->
				<div class="col-lg-8 order-1 ">

					<!-- publisher -->
					{if $user->_logged_in}
						{if $user->_data['user_id'] == $profile['user_id']}
							{include file='_publisher.tpl' _handle="me" _node_can_monetize_content=$user->_data['can_monetize_content'] _node_monetization_enabled=$user->_data['user_monetization_enabled'] _node_monetization_plans=$user->_data['user_monetization_plans'] _privacy=true}
						{elseif $system['wall_posts_enabled'] && ( $profile['user_privacy_wall'] == 'friends' && $profile['we_friends'] || $profile['user_privacy_wall'] == 'public' )}
							{include file='_publisher.tpl' _handle="user" _id=$profile['user_id'] _privacy=true}
						{/if}
					{/if}
					<!-- publisher -->

					<!-- pinned post -->
					{if $pinned_post}
						{include file='_pinned_post.tpl' post=$pinned_post}
					{/if}
					<!-- pinned post -->

					<!-- posts -->
					{include file='_posts.tpl' _get="posts_profile" _id=$profile['user_id']}
					<!-- posts -->

				</div>
				<!-- right panel -->

			{elseif $view == "friends"}
			
				<!-- friends -->
				<div class="col-12 p-0">
					<div class="px-3 pb-3">
						<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
							<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Friends")}</span>
							<div class="d-flex align-items-center flex-0 gap-10">
								<div class="dropdown">
									<button type="button" class="btn lh-1 p-2 px-3 btn-gray dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
										<span class="btn-group-text">{__("Friends")}</span>
										<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.99977 9.00005L11.9998 15L17.9998 9" stroke="currentColor" stroke-width="1.75" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
									</button>
									<div class="dropdown-menu dropdown-menu-end">
										<a class="dropdown-item active" href="{$system['system_url']}/{$profile['user_name']}/friends">
											{__("Friends")}
											<span class="badge rounded-pill bg-info">{$profile['friends_count']}</span>
										</a>
										<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/followers">{__("Followers")}</a>
										<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/followings">{__("Followings")}</a>
										{if $profile['has_subscriptions_plans']}
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/subscribers">{__("Subscribers")}</a>
										{/if}
										{if $system['monetization_enabled']}
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/subscriptions">{__("Subscriptions")}</a>
										{/if}
									</div>
								</div>
							</div>
						</div>
	
						{if $profile['friends']}
							<ul class="row">
								{foreach $profile['friends'] as $_user}
									{include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _top_friends=true _darker=true}
								{/foreach}
							</ul>
							{if $profile['friends_count'] >= $system['max_results_even']}
								<!-- see-more -->
								<div class="alert alert-post see-more mt0 mb20 js_see-more" data-get="friends" data-uid="{$profile['user_id']}">
									<span>{__("See More")}</span>
									<div class="loader loader_small x-hidden"></div>
								</div>
								<!-- see-more -->
							{/if}
						{else}
							<div class="text-center text-muted py-5">
								<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
								<div class="text-md mt-4">
									<h5 class="headline-font m-0">
										{$profile['name']} {__("doesn't have friends")}
									</h5>
								</div>
							</div>
						{/if}
					</div>
				</div>
				<!-- friends -->

			{elseif $view == "followers"}
				<!-- followers -->
				<div class="col-12 p-0">
					<div class="px-3 pb-3">
						<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
							<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Followers")}</span>
							<div class="d-flex align-items-center flex-0 gap-10">
								<div class="dropdown">
									<button type="button" class="btn lh-1 p-2 px-3 btn-gray dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
										<span class="btn-group-text">{__("Followers")}</span>
										<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.99977 9.00005L11.9998 15L17.9998 9" stroke="currentColor" stroke-width="1.75" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
									</button>
									<div class="dropdown-menu dropdown-menu-end">
										{if $system['friends_enabled']}
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/friends">{__("Friends")}</a>
										{/if}
										<a class="dropdown-item active" href="{$system['system_url']}/{$profile['user_name']}/followers">
											{__("Followers")}
											<span class="badge rounded-pill bg-info">{$profile['followers_count']}</span>
										</a>
										<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/followings">{__("Followings")}</a>
										{if $profile['has_subscriptions_plans']}
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/subscribers">{__("Subscribers")}</a>
										{/if}
										{if $system['monetization_enabled']}
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/subscriptions">{__("Subscriptions")}</a>
										{/if}
									</div>
								</div>
							</div>
						</div>
						
						{if $profile['followers']}
							<ul class="row">
								{foreach $profile['followers'] as $_user}
									{include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true}
								{/foreach}
							</ul>

							{if $profile['followers_count'] >= $system['max_results_even']}
								<!-- see-more -->
								<div class="alert alert-post see-more mt0 mb20 js_see-more" data-get="followers" data-uid="{$profile['user_id']}">
									<span>{__("See More")}</span>
									<div class="loader loader_small x-hidden"></div>
								</div>
								<!-- see-more -->
							{/if}
						{else}
							<div class="text-center text-muted py-5">
								<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
								<div class="text-md mt-4">
									<h5 class="headline-font m-0">
										{$profile['name']} {__("doesn't have followers")}
									</h5>
								</div>
							</div>
						{/if}
					</div>
				</div>
				<!-- followers -->

			{elseif $view == "followings"}
				<!-- followings -->
				<div class="col-12 p-0">
					<div class="px-3 pb-3">
						<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
							<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Followings")}</span>
							<div class="d-flex align-items-center flex-0 gap-10">
								<div class="dropdown">
									<button type="button" class="btn lh-1 p-2 px-3 btn-gray dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
										<span class="btn-group-text">{__("Followings")}</span>
										<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.99977 9.00005L11.9998 15L17.9998 9" stroke="currentColor" stroke-width="1.75" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
									</button>
									<div class="dropdown-menu dropdown-menu-end">
										{if $system['friends_enabled']}
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/friends">{__("Friends")}</a>
										{/if}
										<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/followers">{__("Followers")}</a>
										<a class="dropdown-item active" href="{$system['system_url']}/{$profile['user_name']}/followings">
											{__("Followings")}
											<span class="badge rounded-pill bg-info">{$profile['followings_count']}</span>
										</a>
										{if $profile['has_subscriptions_plans']}
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/subscribers">{__("Subscribers")}</a>
										{/if}
										{if $system['monetization_enabled']}
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/subscriptions">{__("Subscriptions")}</a>
										{/if}
									</div>
								</div>
							</div>
						</div>
						
						{if $profile['followings']}
							<ul class="row">
								{foreach $profile['followings'] as $_user}
									{include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true}
								{/foreach}
							</ul>

							{if $profile['followings_count'] >= $system['max_results_even']}
								<!-- see-more -->
								<div class="alert alert-post see-more mt0 mb20 js_see-more" data-get="followings" data-uid="{$profile['user_id']}">
									<span>{__("See More")}</span>
									<div class="loader loader_small x-hidden"></div>
								</div>
								<!-- see-more -->
							{/if}
						{else}
							<div class="text-center text-muted py-5">
								<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
								<div class="text-md mt-4">
									<h5 class="headline-font m-0">
										{$profile['name']} {__("doesn't have followings")}
									</h5>
								</div>
							</div>
						{/if}
					</div>
				</div>
				<!-- followings -->

			{elseif $view == "subscribers"}
				<!-- subscribers -->
				<div class="col-12 p-0">
					<div class="px-3 pb-3">
						<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
							<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Subscribers")}</span>
							<div class="d-flex align-items-center flex-0 gap-10">
								<div class="dropdown">
									<button type="button" class="btn lh-1 p-2 px-3 btn-gray dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
										<span class="btn-group-text">{__("Subscribers")}</span>
										<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.99977 9.00005L11.9998 15L17.9998 9" stroke="currentColor" stroke-width="1.75" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
									</button>
									<div class="dropdown-menu dropdown-menu-end">
										{if $system['friends_enabled']}
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/friends">{__("Friends")}</a>
										{/if}
										<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/followers">{__("Followers")}</a>
										<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/followings">{__("Followings")}</a>
										<a class="dropdown-item active" href="{$system['system_url']}/{$profile['user_name']}/subscribers">
											{__("Subscribers")}
											<span class="badge rounded-pill bg-info">{$profile['subscribers_count']}</span>
										</a>
										{if $system['monetization_enabled']}
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/subscriptions">{__("Subscriptions")}</a>
										{/if}
									</div>
								</div>
							</div>
						</div>
						
						{if $profile['subscribers']}
							<ul class="row">
								{foreach $profile['subscribers'] as $_user}
									{include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true}
								{/foreach}
							</ul>
							{if $profile['subscribers_count'] >= $system['max_results_even']}
								<!-- see-more -->
								<div class="alert alert-post see-more mt0 mb20 js_see-more" data-get="subscribers" data-uid="{$profile['user_id']}" data-type="user">
									<span>{__("See More")}</span>
									<div class="loader loader_small x-hidden"></div>
								</div>
								<!-- see-more -->
							{/if}
						{else}
							<div class="text-center text-muted py-5">
								<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
								<div class="text-md mt-4">
									<h5 class="headline-font m-0">
										{$profile['name']} {__("doesn't have subscribers")}
									</h5>
								</div>
							</div>
						{/if}
					</div>
				</div>
				<!-- subscribers -->

			{elseif $view == "subscriptions"}
				<!-- subscriptions -->
				<div class="col-12 p-0">
					<div class="px-3 pb-3">
						<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
							<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Subscriptions")}</span>
							<div class="d-flex align-items-center flex-0 gap-10">
								<div class="dropdown">
									<button type="button" class="btn lh-1 p-2 px-3 btn-gray dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
										<span class="btn-group-text">{__("Subscriptions")}</span>
										<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.99977 9.00005L11.9998 15L17.9998 9" stroke="currentColor" stroke-width="1.75" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
									</button>
									<div class="dropdown-menu dropdown-menu-end">
										{if $system['friends_enabled']}
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/friends">{__("Friends")}</a>
										{/if}
										<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/followers">{__("Followers")}</a>
										<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/followings">{__("Followings")}</a>
										{if $profile['has_subscriptions_plans']}
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/subscribers">{__("Subscribers")}</a>
										{/if}
										<a class="dropdown-item active" href="{$system['system_url']}/{$profile['user_name']}/subscriptions">
											{__("Subscriptions")}
											<span class="badge rounded-pill bg-info">{$profile['subscriptions_count']}</span>
										</a>
									</div>
								</div>
							</div>
						</div>
						
						{if $profile['subscriptions']}
							<ul class="row">
								{foreach $profile['subscriptions'] as $_subscription}
									{if $_subscription['node_type'] == "profile"}
										{include file='__feeds_user.tpl' _user=$_subscription _tpl="box" _connection='unsubscribe' _darker=true}
									{elseif $_subscription['node_type'] == "page"}
										{include file='__feeds_page.tpl' _page=$_subscription _tpl="box" _connection='unsubscribe' _darker=true}
									{elseif $_subscription['node_type'] == "group"}
										{include file='__feeds_group.tpl' _group=$_subscription _tpl="box" _connection='unsubscribe' _darker=true}
									{/if}
								{/foreach}
							</ul>
							{if $profile['subscriptions_count'] >= $system['max_results_even']}
								<!-- see-more -->
								<div class="alert alert-post see-more mt0 mb20 js_see-more" data-get="subscriptions" data-uid="{$profile['user_id']}">
									<span>{__("See More")}</span>
									<div class="loader loader_small x-hidden"></div>
								</div>
								<!-- see-more -->
							{/if}
						{else}
							<div class="text-center text-muted py-5">
								<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
								<div class="text-md mt-4">
									<h5 class="headline-font m-0">
										{$profile['name']} {__("doesn't have subscriptions")}
									</h5>
								</div>
							</div>
						{/if}
					</div>
				</div>
				<!-- subscriptions -->

			{elseif $view == "photos"}
				<!-- photos -->
				<div class="col-12 p-0">
					{if $profile['needs_subscription']}
						{include file='_need_subscription.tpl' node_type='profile' node_id=$profile['user_id'] price=$profile['user_monetization_min_price']}
					{else}
						<div class="px-3 pb-3 panel-photos">
							<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
								<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Photos")}</span>
								<div class="d-flex align-items-center flex-0 gap-10">
									<div class="dropdown">
										<button type="button" class="btn lh-1 p-2 px-3 btn-gray dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
											<span class="btn-group-text">{__("Photos")}</span>
											<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.99977 9.00005L11.9998 15L17.9998 9" stroke="currentColor" stroke-width="1.75" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
										</button>
										<div class="dropdown-menu dropdown-menu-end">
											<a class="dropdown-item active" href="{$system['system_url']}/{$profile['user_name']}/photos">{__("Photos")}</a>
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/albums">{__("Albums")}</a>
										</div>
									</div>
								</div>
							</div>
						
							{if $profile['photos']}
								<ul class="row">
									{foreach $profile['photos'] as $photo}
										{include file='__feeds_photo.tpl' _context="photos" _can_pin=true}
									{/foreach}
								</ul>
								<!-- see-more -->
								<div class="alert alert-post see-more mt20 js_see-more" data-get="photos" data-id="{$profile['user_id']}" data-type='user'>
									<span>{__("See More")}</span>
									<div class="loader loader_small x-hidden"></div>
								</div>
								<!-- see-more -->
							{else}
								<div class="text-center text-muted py-5">
									<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
									<div class="text-md mt-4">
										<h5 class="headline-font m-0">
											{$profile['name']} {__("doesn't have photos")}
										</h5>
									</div>
								</div>
							{/if}
						</div>
					{/if}
				</div>
				<!-- photos -->

			{elseif $view == "albums"}
				<!-- albums -->
				<div class="col-12 p-0">
					{if $profile['needs_subscription']}
						{include file='_need_subscription.tpl' node_type='profile' node_id=$profile['user_id'] price=$profile['user_monetization_min_price']}
					{else}
						<div class="px-3 pb-3">
							<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
								<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Photos")}</span>
								<div class="d-flex align-items-center flex-0 gap-10">
									<div class="dropdown">
										<button type="button" class="btn lh-1 p-2 px-3 btn-gray dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
											<span class="btn-group-text">{__("Albums")}</span>
											<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.99977 9.00005L11.9998 15L17.9998 9" stroke="currentColor" stroke-width="1.75" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
										</button>
										<div class="dropdown-menu dropdown-menu-end">
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/photos">{__("Photos")}</a>
											<a class="dropdown-item active" href="{$system['system_url']}/{$profile['user_name']}/albums">{__("Albums")}</a>
										</div>
									</div>
								</div>
							</div>
							
							{if $profile['albums']}
								<ul class="row">
									{foreach $profile['albums'] as $album}
										{include file='__feeds_album.tpl'}
									{/foreach}
								</ul>
								{if count($profile['albums']) >= $system['max_results_even']}
									<!-- see-more -->
									<div class="alert alert-post see-more js_see-more" data-get="albums" data-id="{$profile['user_id']}" data-type='user'>
										<span>{__("See More")}</span>
										<div class="loader loader_small x-hidden"></div>
									</div>
									<!-- see-more -->
								{/if}
							{else}
								<div class="text-center text-muted py-5">
									<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
									<div class="text-md mt-4">
										<h5 class="headline-font m-0">
											{$profile['name']} {__("doesn't have albums")}
										</h5>
									</div>
								</div>
							{/if}
						</div>
					{/if}
				</div>
				<!-- albums -->

			{elseif $view == "album"}
				<!-- albums -->
				<div class="col-12 p-0">
					{if $profile['needs_subscription']}
						{include file='_need_subscription.tpl' node_type='profile' node_id=$profile['user_id'] price=$profile['user_monetization_min_price']}
					{else}
						<div class="px-3 pb-3 panel-photos">
							<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
								<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Photos")}</span>
								<div class="d-flex align-items-center flex-0 gap-10">
									<div class="dropdown">
										<button type="button" class="btn lh-1 p-2 px-3 btn-gray dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
											<span class="btn-group-text">{__("Albums")}</span>
											<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.99977 9.00005L11.9998 15L17.9998 9" stroke="currentColor" stroke-width="1.75" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
										</button>
										<div class="dropdown-menu dropdown-menu-end">
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/photos">{__("Photos")}</a>
											<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/albums">{__("Albums")}</a>
										</div>
									</div>
								</div>
							</div>

							{include file='_album.tpl'}
						</div>
					{/if}
				</div>
				<!-- albums -->

			{elseif $view == "videos"}
				<!-- videos -->
				<div class="col-12 p-0">
					{if $profile['needs_subscription']}
						{include file='_need_subscription.tpl' node_type='profile' node_id=$profile['user_id'] price=$profile['user_monetization_min_price']}
					{else}
						<div class="px-3 pb-3 panel-videos">
							<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
								<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Videos")}</span>
								{if $system['reels_enabled']}
									<div class="d-flex align-items-center flex-0 gap-10">
										<div class="dropdown">
											<button type="button" class="btn lh-1 p-2 px-3 btn-gray dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
												<span class="btn-group-text">{__("Videos")}</span>
												<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.99977 9.00005L11.9998 15L17.9998 9" stroke="currentColor" stroke-width="1.75" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
											</button>
											<div class="dropdown-menu dropdown-menu-end">
												<a class="dropdown-item active" href="{$system['system_url']}/{$profile['user_name']}/videos">{__("Videos")}</a>
												<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/reels">{__("Reels")}</a>
											</div>
										</div>
									</div>
								{/if}
							</div>
							
							{if $profile['videos']}
								<ul class="row">
									{foreach $profile['videos'] as $video}
										{include file='__feeds_video.tpl'}
									{/foreach}
								</ul>
								<!-- see-more -->
								<div class="alert alert-post see-more js_see-more" data-get="videos" data-id="{$profile['user_id']}" data-type='user'>
									<span>{__("See More")}</span>
									<div class="loader loader_small x-hidden"></div>
								</div>
								<!-- see-more -->
							{else}
								<div class="text-center text-muted py-5">
									<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
									<div class="text-md mt-4">
										<h5 class="headline-font m-0">
											{$profile['name']} {__("doesn't have videos")}
										</h5>
									</div>
								</div>
							{/if}
						</div>
					{/if}
				</div>
				<!-- videos -->

			{elseif $view == "reels"}
				<!-- reels -->
				<div class="col-12 p-0">
					{if $profile['needs_subscription']}
						{include file='_need_subscription.tpl' node_type='profile' node_id=$profile['user_id'] price=$profile['user_monetization_min_price']}
					{else}
						<div class="px-3 pb-3 panel-videos">
							<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
								<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Reels")}</span>
								{if $system['videos_enabled']}
									<div class="d-flex align-items-center flex-0 gap-10">
										<div class="dropdown">
											<button type="button" class="btn lh-1 p-2 px-3 btn-gray dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
												<span class="btn-group-text">{__("Reels")}</span>
												<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.99977 9.00005L11.9998 15L17.9998 9" stroke="currentColor" stroke-width="1.75" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
											</button>
											<div class="dropdown-menu dropdown-menu-end">
												<a class="dropdown-item" href="{$system['system_url']}/{$profile['user_name']}/videos">{__("Videos")}</a>
												<a class="dropdown-item active" href="{$system['system_url']}/{$profile['user_name']}/reels">{__("Reels")}</a>
											</div>
										</div>
									</div>
								{/if}
							</div>

							{if $profile['reels']}
								<ul class="row">
									{foreach $profile['reels'] as $video}
										{include file='__feeds_video.tpl' _is_reel=true}
									{/foreach}
								</ul>
								<!-- see-more -->
								<div class="alert alert-post see-more js_see-more" data-get="videos_reels" data-id="{$profile['user_id']}" data-type='user'>
									<span>{__("See More")}</span>
									<div class="loader loader_small x-hidden"></div>
								</div>
								<!-- see-more -->
							{else}
								<div class="text-center text-muted py-5">
									<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
									<div class="text-md mt-4">
										<h5 class="headline-font m-0">
											{$profile['name']} {__("doesn't have reels")}
										</h5>
									</div>
								</div>
							{/if}
						</div>
					{/if}
				</div>
				<!-- reels -->

			{elseif $view == "products"}
				<!-- products -->
				<div class="col-12 p-0">
					{if $profile['needs_subscription']}
						{include file='_need_subscription.tpl' node_type='profile' node_id=$profile['user_id'] price=$profile['user_monetization_min_price']}
					{else}
						<div class="px-3 pb-3">
							<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
								<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Products")}</span>
							</div>
						
							<!-- search -->
							<div class="mb-3">
								<form action="{$system['system_url']}/{$profile['user_name']}/search" method="get">
									<div class="position-relative">
										<input type="search" class="form-control shadow-none rounded-pill x_search_filter" name="query" placeholder='{__("Search")}'>
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"></path></svg>
										<input type="hidden" name="filter" value="product">
									</div>
								</form>
							</div>
							<!-- search -->

							{if $posts}
								<ul class="row">
									{foreach $posts as $post}
										{include file='__feeds_product.tpl'}
									{/foreach}
								</ul>

								<!-- see-more -->
								<div class="alert alert-post see-more js_see-more" data-get="products_profile" data-id="{$profile['user_id']}">
									<span>{__("See More")}</span>
									<div class="loader loader_small x-hidden"></div>
								</div>
								<!-- see-more -->
							{else}
								{include file='_no_data.tpl'}
							{/if}
						</div>
					{/if}
				</div>
				<!-- products -->

			{elseif $view == "pages"}
				<!-- pages -->
				<div class="col-12 p-0">
					<div class="pb-3">
						<div class="d-flex align-items-center justify-content-between p-3 gap-10 border-0">
							<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Pages")}</span>
						</div>
							
						{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_pages'] == "public" || ($profile['user_privacy_pages'] == "friends" && $profile['we_friends'])}
							{if count($profile['pages']) > 0}
								{foreach $profile['pages'] as $_page}
									{include file='__feeds_page.tpl' _tpl="box" _darker=true}
								{/foreach}

								{if count($profile['pages']) >= $system['max_results_even']}
									<!-- see-more -->
									<div class="alert alert-post see-more js_see-more" data-get="profile_pages" data-uid="{$profile['user_id']}">
										<span>{__("See More")}</span>
										<div class="loader loader_small x-hidden"></div>
									</div>
									<!-- see-more -->
								{/if}
							{else}
								{include file='_no_data.tpl'}
							{/if}
						{else}
							{include file='_no_data.tpl'}
						{/if}
					</div>
				</div>
				<!-- pages -->

			{elseif $view == "groups"}
				<!-- groups -->
				<div class="col-12 p-0">
					<div class="pb-3">
						<div class="d-flex align-items-center justify-content-between p-3 gap-10 border-0">
							<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Groups")}</span>
						</div>
						
						{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_groups'] == "public" || ($profile['user_privacy_groups'] == "friends" && $profile['we_friends'])}
							{if count($profile['groups']) > 0}
								{foreach $profile['groups'] as $_group}
									{include file='__feeds_group.tpl' _tpl="box" _darker=true}
								{/foreach}

								{if count($profile['groups']) >= $system['max_results_even']}
									<!-- see-more -->
									<div class="alert alert-post see-more js_see-more" data-get="profile_groups" data-uid="{$profile['user_id']}">
										<span>{__("See More")}</span>
										<div class="loader loader_small x-hidden"></div>
									</div>
									<!-- see-more -->
								{/if}
							{else}
								{include file='_no_data.tpl'}
							{/if}
						{else}
							{include file='_no_data.tpl'}
						{/if}
					</div>
				</div>
				<!-- groups -->

			{elseif $view == "events"}
				<!-- events -->
				<div class="col-12 p-0">
					<div class="px-3 pb-3">
						<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
							<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Events")}</span>
						</div>
						
						{if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_events'] == "public" || ($profile['user_privacy_events'] == "friends" && $profile['we_friends'])}
							{if count($profile['events']) > 0}
								<ul class="row">
									{foreach $profile['events'] as $_event}
										{include file='__feeds_event.tpl' _tpl="box" _darker=true _small=true}
									{/foreach}
								</ul>

								{if count($profile['events']) >= $system['max_results_even']}
									<!-- see-more -->
									<div class="alert alert-post see-more js_see-more" data-get="profile_events" data-uid="{$profile['user_id']}">
										<span>{__("See More")}</span>
										<div class="loader loader_small x-hidden"></div>
									</div>
									<!-- see-more -->
								{/if}
							{else}
								{include file='_no_data.tpl'}
							{/if}
						{else}
							{include file='_no_data.tpl'}
						{/if}
					</div>
				</div>
				<!-- events -->

			{elseif $view == "search"}

				<!-- left panel -->
				<div class="col-lg-4 px-lg-3 py-3 order-2 js_sticky-sidebar">
					<!-- search -->
					<div class="mb-3">
						<form action="{$system['system_url']}/{$profile['user_name']}/search" method="get">
							<div class="position-relative">
								<input type="search" class="form-control shadow-none rounded-pill x_search_filter" name="query" placeholder='{__("Search")}' {if $query}value="{$query}" {/if}>
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"></path></svg>
							</div>
						</form>
					</div>
					<!-- search -->

					<!-- mini footer -->
					{include file='_footer_mini.tpl'}
					<!-- mini footer -->
				</div>
				<!-- left panel -->

				<!-- right panel -->
				<div class="col-lg-8 order-1">
					<!-- posts -->
					{include file='_posts.tpl' _get="posts_profile" _id=$profile['user_id'] _title=__("Search Results") _query=$query _filter=$filter}
					<!-- posts -->
				</div>
				<!-- right panel -->

			{/if}
			<!-- view content -->
		</div>
		<!-- profile-content -->
    </div>
    <!-- content panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}

{if $gift}
	<script>
		$(function() {
			modal('#gift');
		});
	</script>
{/if}