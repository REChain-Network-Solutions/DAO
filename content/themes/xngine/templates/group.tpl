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
		<div class="profile-header position-relative">
			<!-- profile-cover -->
			<div class="profile-cover-wrapper x_adslist position-relative overflow-hidden rounded-0">
				{if $group['group_cover_id']}
					<!-- full-cover -->
					<img class="js_position-cover-full x-hidden" src="{$group['group_cover_full']}">
					<!-- full-cover -->

					<!-- cropped-cover -->
					<img class="js_position-cover-cropped js_lightbox" data-init-position="{$group['group_cover_position']}" data-id="{$group['group_cover_id']}" data-image="{$group['group_cover_full']}" data-context="album" src="{$group['group_cover']}" alt="{$group['group_title']}">
					<!-- cropped-cover -->
				{/if}

				{if $group['i_admin']}
					<!-- buttons -->
					<div class="profile-cover-buttons d-flex align-items-center gap-2 position-absolute m-2 m-md-3 top-0">
						<div class="profile-cover-change">
							<button type="button" class="btn bg-black text-white border-0 p-2 rounded-circle lh-1 flex-0" data-bs-toggle="dropdown" data-display="static">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M11.9256 1.5H12.0745H12.0745C14.2504 1.49998 15.9852 1.49996 17.3453 1.68282C18.7497 1.87164 19.9035 2.27175 20.8159 3.18414C21.7283 4.09653 22.1284 5.25033 22.3172 6.65471C22.5 8.01485 22.5 9.74959 22.5 11.9256V12.0744C22.5 14.2504 22.5 15.9852 22.3172 17.3453C22.1284 18.7497 21.7283 19.9035 20.8159 20.8159C19.9035 21.7283 18.7497 22.1284 17.3453 22.3172C15.9851 22.5 14.2504 22.5 12.0744 22.5H11.9256C9.74959 22.5 8.01485 22.5 6.65471 22.3172C5.25033 22.1284 4.09653 21.7283 3.18414 20.8159C2.27175 19.9035 1.87164 18.7497 1.68282 17.3453C1.49996 15.9852 1.49998 14.2504 1.5 12.0745V12.0745V11.9256V11.9255C1.49998 9.74958 1.49996 8.01484 1.68282 6.65471C1.87164 5.25033 2.27175 4.09653 3.18414 3.18414C4.09653 2.27175 5.25033 1.87164 6.65471 1.68282C8.01484 1.49996 9.74958 1.49998 11.9255 1.5H11.9256ZM14.5 7.5C14.5 6.39543 15.3954 5.5 16.5 5.5C17.6046 5.5 18.5 6.39543 18.5 7.5C18.5 8.60457 17.6046 9.5 16.5 9.5C15.3954 9.5 14.5 8.60457 14.5 7.5ZM18.3837 16.7501C19.0353 16.7494 19.692 16.8447 20.3408 17.0367L20.3352 17.0788C20.1762 18.2614 19.8807 18.9228 19.4019 19.4017C18.923 19.8805 18.2616 20.176 17.079 20.335C16.8154 20.3705 16.5334 20.3983 16.2302 20.4201C15.8204 19.4898 15.2721 18.615 14.6026 17.8175C15.8435 17.0978 17.1185 16.7451 18.3837 16.7501ZM3.51758 14.7603C3.537 15.6726 3.57813 16.4312 3.6652 17.0788C3.82419 18.2614 4.1197 18.9228 4.59856 19.4017C5.07741 19.8805 5.73881 20.176 6.92141 20.335C8.13278 20.4979 9.73277 20.5 12.0002 20.5C12.9843 20.5 13.8427 20.4996 14.5981 20.4858C13.8891 19.1287 12.8178 17.9128 11.4459 16.9476C9.36457 15.4832 6.73674 14.6994 4.03132 14.7525L4.01487 14.7527C3.849 14.7523 3.6832 14.7548 3.51758 14.7603Z" fill="currentColor"/></svg>
							</button>
							<div class="dropdown-menu action-dropdown-menu">
								<!-- upload -->
								<div class="dropdown-item pointer align-items-start js_x-uploader" data-handle="cover-group" data-id="{$group['group_id']}">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M13 3.00231C12.5299 3 12.0307 3 11.5 3C7.02166 3 4.78249 3 3.39124 4.39124C2 5.78249 2 8.02166 2 12.5C2 16.9783 2 19.2175 3.39124 20.6088C4.78249 22 7.02166 22 11.5 22C15.9783 22 18.2175 22 19.6088 20.6088C20.9472 19.2703 20.998 17.147 20.9999 13" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M2 14.1354C2.61902 14.0455 3.24484 14.0011 3.87171 14.0027C6.52365 13.9466 9.11064 14.7729 11.1711 16.3342C13.082 17.7821 14.4247 19.7749 15 22" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M21 16.8962C19.8246 16.3009 18.6088 15.9988 17.3862 16.0001C15.5345 15.9928 13.7015 16.6733 12 18" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M17 4.5C17.4915 3.9943 18.7998 2 19.5 2M22 4.5C21.5085 3.9943 20.2002 2 19.5 2M19.5 2V10" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
									<div class="action">
										{__("Upload Photo")}
										<div class="action-desc">{__("Upload a new photo")}</div>
									</div>
								</div>
								<!-- upload -->
								<!-- select -->
								<div class="dropdown-item pointer align-items-start" data-toggle="modal" data-url="users/photos.php?filter=cover&type=group&id={$group['group_id']}">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M6 17.9745C6.1287 19.2829 6.41956 20.1636 7.07691 20.8209C8.25596 22 10.1536 22 13.9489 22C17.7442 22 19.6419 22 20.8209 20.8209C22 19.6419 22 17.7442 22 13.9489C22 10.1536 22 8.25596 20.8209 7.07691C20.1636 6.41956 19.2829 6.1287 17.9745 6" stroke="currentColor" stroke-width="1.75" /><path d="M2 10C2 6.22876 2 4.34315 3.17157 3.17157C4.34315 2 6.22876 2 10 2C13.7712 2 15.6569 2 16.8284 3.17157C18 4.34315 18 6.22876 18 10C18 13.7712 18 15.6569 16.8284 16.8284C15.6569 18 13.7712 18 10 18C6.22876 18 4.34315 18 3.17157 16.8284C2 15.6569 2 13.7712 2 10Z" stroke="currentColor" stroke-width="1.75" /><path d="M2 11.1185C2.61902 11.0398 3.24484 11.001 3.87171 11.0023C6.52365 10.9533 9.11064 11.6763 11.1711 13.0424C13.082 14.3094 14.4247 16.053 15 18" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M12.9998 7H13.0088" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
									<div class="action">
										{__("Select Photo")}
										<div class="action-desc">{__("Select a photo")}</div>
									</div>
								</div>
								<!-- select -->
							</div>
						</div>
						<div class="profile-cover-position {if !$group['group_cover']}x-hidden{/if}">
							<input class="js_position-picture-val" type="hidden" name="position-picture-val">
							<button type="button" class="btn bg-black text-white border-0 p-2 rounded-circle lh-1 flex-0 js_init-position-picture" data-handle="group" data-id="{$group['group_id']}">
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
						<div class="profile-cover-delete {if !$group['group_cover']}x-hidden{/if}">
							<button type="button" class="btn bg-black text-white border-0 p-2 rounded-circle lh-1 flex-0 js_delete-cover" data-handle="cover-group" data-id="{$group['group_id']}">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M19.5825 15.6564C19.5058 16.9096 19.4449 17.9041 19.3202 18.6984C19.1922 19.5131 18.9874 20.1915 18.5777 20.7849C18.2029 21.3278 17.7204 21.786 17.1608 22.1303C16.5491 22.5067 15.8661 22.6713 15.0531 22.75L8.92739 22.7499C8.1135 22.671 7.42972 22.5061 6.8176 22.129C6.25763 21.7841 5.77494 21.3251 5.40028 20.7813C4.99073 20.1869 4.78656 19.5075 4.65957 18.6917C4.53574 17.8962 4.47623 16.9003 4.40122 15.6453L3.75 4.75H20.25L19.5825 15.6564ZM9.5 17.9609C9.08579 17.9609 8.75 17.6252 8.75 17.2109L8.75 11.2109C8.75 10.7967 9.08579 10.4609 9.5 10.4609C9.91421 10.4609 10.25 10.7967 10.25 11.2109L10.25 17.2109C10.25 17.6252 9.91421 17.9609 9.5 17.9609ZM15.25 11.2109C15.25 10.7967 14.9142 10.4609 14.5 10.4609C14.0858 10.4609 13.75 10.7967 13.75 11.2109V17.2109C13.75 17.6252 14.0858 17.9609 14.5 17.9609C14.9142 17.9609 15.25 17.6252 15.25 17.2109V11.2109Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13.3473 1.28277C13.9124 1.33331 14.4435 1.50576 14.8996 1.84591C15.2369 2.09748 15.4712 2.40542 15.6714 2.73893C15.8569 3.04798 16.0437 3.4333 16.2555 3.8704L16.6823 4.7507H21C21.5523 4.7507 22 5.19842 22 5.7507C22 6.30299 21.5523 6.7507 21 6.7507C14.9998 6.7507 9.00019 6.7507 3 6.7507C2.44772 6.7507 2 6.30299 2 5.7507C2 5.19842 2.44772 4.7507 3 4.7507H7.40976L7.76556 3.97016C7.97212 3.51696 8.15403 3.11782 8.33676 2.79754C8.53387 2.45207 8.76721 2.13237 9.10861 1.87046C9.57032 1.51626 10.1121 1.33669 10.6899 1.28409C11.1249 1.24449 11.5634 1.24994 12 1.25064C12.5108 1.25146 12.97 1.24902 13.3473 1.28277ZM9.60776 4.7507H14.4597C14.233 4.28331 14.088 3.98707 13.9566 3.7682C13.7643 3.44787 13.5339 3.30745 13.1691 3.27482C12.9098 3.25163 12.5719 3.2507 12.0345 3.2507C11.4837 3.2507 11.137 3.25166 10.8712 3.27585C10.4971 3.30991 10.2639 3.45568 10.0739 3.78866C9.94941 4.00687 9.81387 4.29897 9.60776 4.7507Z" fill="currentColor"/></svg>
							</button>
						</div>
					</div>

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
		
			<div Class="p-3 position-relative">
				<!-- profile-avatar -->
				<div class="profile-avatar-wrapper rounded-3 bg-white p-1 position-relative mb-2">
					<img {if $group['group_picture_id']} class="js_lightbox pointer rounded-3" data-id="{$group['group_picture_id']}" data-context="album" data-image="{$group['group_picture_full']}" {elseif !$group['group_picture_default']} class="js_lightbox-nodata rounded-3" data-image="{$group['group_picture']}" {else} class="rounded-3"{/if} src="{$group['group_picture']}" alt="{$group['group_title']}">

					{if $group['i_admin']}
						<!-- buttons -->
						<div class="profile-avatar-change position-absolute">
							<button type="button" class="btn bg-black text-white border-0 p-2 rounded-circle lh-1 flex-0" data-bs-toggle="dropdown" data-display="static">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M11.9256 1.5H12.0745H12.0745C14.2504 1.49998 15.9852 1.49996 17.3453 1.68282C18.7497 1.87164 19.9035 2.27175 20.8159 3.18414C21.7283 4.09653 22.1284 5.25033 22.3172 6.65471C22.5 8.01485 22.5 9.74959 22.5 11.9256V12.0744C22.5 14.2504 22.5 15.9852 22.3172 17.3453C22.1284 18.7497 21.7283 19.9035 20.8159 20.8159C19.9035 21.7283 18.7497 22.1284 17.3453 22.3172C15.9851 22.5 14.2504 22.5 12.0744 22.5H11.9256C9.74959 22.5 8.01485 22.5 6.65471 22.3172C5.25033 22.1284 4.09653 21.7283 3.18414 20.8159C2.27175 19.9035 1.87164 18.7497 1.68282 17.3453C1.49996 15.9852 1.49998 14.2504 1.5 12.0745V12.0745V11.9256V11.9255C1.49998 9.74958 1.49996 8.01484 1.68282 6.65471C1.87164 5.25033 2.27175 4.09653 3.18414 3.18414C4.09653 2.27175 5.25033 1.87164 6.65471 1.68282C8.01484 1.49996 9.74958 1.49998 11.9255 1.5H11.9256ZM14.5 7.5C14.5 6.39543 15.3954 5.5 16.5 5.5C17.6046 5.5 18.5 6.39543 18.5 7.5C18.5 8.60457 17.6046 9.5 16.5 9.5C15.3954 9.5 14.5 8.60457 14.5 7.5ZM18.3837 16.7501C19.0353 16.7494 19.692 16.8447 20.3408 17.0367L20.3352 17.0788C20.1762 18.2614 19.8807 18.9228 19.4019 19.4017C18.923 19.8805 18.2616 20.176 17.079 20.335C16.8154 20.3705 16.5334 20.3983 16.2302 20.4201C15.8204 19.4898 15.2721 18.615 14.6026 17.8175C15.8435 17.0978 17.1185 16.7451 18.3837 16.7501ZM3.51758 14.7603C3.537 15.6726 3.57813 16.4312 3.6652 17.0788C3.82419 18.2614 4.1197 18.9228 4.59856 19.4017C5.07741 19.8805 5.73881 20.176 6.92141 20.335C8.13278 20.4979 9.73277 20.5 12.0002 20.5C12.9843 20.5 13.8427 20.4996 14.5981 20.4858C13.8891 19.1287 12.8178 17.9128 11.4459 16.9476C9.36457 15.4832 6.73674 14.6994 4.03132 14.7525L4.01487 14.7527C3.849 14.7523 3.6832 14.7548 3.51758 14.7603Z" fill="currentColor"/></svg>
							</button>
							<div class="dropdown-menu action-dropdown-menu">
								<!-- upload -->
								<div class="dropdown-item pointer align-items-start js_x-uploader" data-handle="picture-group" data-id="{$group['group_id']}">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M13 3.00231C12.5299 3 12.0307 3 11.5 3C7.02166 3 4.78249 3 3.39124 4.39124C2 5.78249 2 8.02166 2 12.5C2 16.9783 2 19.2175 3.39124 20.6088C4.78249 22 7.02166 22 11.5 22C15.9783 22 18.2175 22 19.6088 20.6088C20.9472 19.2703 20.998 17.147 20.9999 13" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M2 14.1354C2.61902 14.0455 3.24484 14.0011 3.87171 14.0027C6.52365 13.9466 9.11064 14.7729 11.1711 16.3342C13.082 17.7821 14.4247 19.7749 15 22" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M21 16.8962C19.8246 16.3009 18.6088 15.9988 17.3862 16.0001C15.5345 15.9928 13.7015 16.6733 12 18" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M17 4.5C17.4915 3.9943 18.7998 2 19.5 2M22 4.5C21.5085 3.9943 20.2002 2 19.5 2M19.5 2V10" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
									<div class="action">
										{__("Upload Photo")}
										<div class="action-desc">{__("Upload a new photo")}</div>
									</div>
								</div>
								<!-- upload -->
								<!-- select -->
								<div class="dropdown-item pointer align-items-start" data-toggle="modal" data-url="users/photos.php?filter=avatar&type=group&id={$group['group_id']}">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M6 17.9745C6.1287 19.2829 6.41956 20.1636 7.07691 20.8209C8.25596 22 10.1536 22 13.9489 22C17.7442 22 19.6419 22 20.8209 20.8209C22 19.6419 22 17.7442 22 13.9489C22 10.1536 22 8.25596 20.8209 7.07691C20.1636 6.41956 19.2829 6.1287 17.9745 6" stroke="currentColor" stroke-width="1.75" /><path d="M2 10C2 6.22876 2 4.34315 3.17157 3.17157C4.34315 2 6.22876 2 10 2C13.7712 2 15.6569 2 16.8284 3.17157C18 4.34315 18 6.22876 18 10C18 13.7712 18 15.6569 16.8284 16.8284C15.6569 18 13.7712 18 10 18C6.22876 18 4.34315 18 3.17157 16.8284C2 15.6569 2 13.7712 2 10Z" stroke="currentColor" stroke-width="1.75" /><path d="M2 11.1185C2.61902 11.0398 3.24484 11.001 3.87171 11.0023C6.52365 10.9533 9.11064 11.6763 11.1711 13.0424C13.082 14.3094 14.4247 16.053 15 18" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M12.9998 7H13.0088" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
									<div class="action">
										{__("Select Photo")}
										<div class="action-desc">{__("Select a photo")}</div>
									</div>
								</div>
								<!-- select -->
								<div class="{if $group['group_picture_default']}x-hidden{/if}">
									<div class="dropdown-divider"></div>
									<div class="dropdown-item pointer js_init-crop-picture" data-image="{$group['group_picture_full']}" data-handle="group" data-id="{$group['group_id']}">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M4 2V4M22 20H20M16.5 20H10C7.17157 20 5.75736 20 4.87868 19.1213C4 18.2426 4 16.8284 4 14V7.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M20 22L20 12C20 8.22877 20 6.34315 18.8284 5.17158C17.6569 4 15.7712 4 12 4L2 4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										{__("Crop photo")}
									</div>
									<div class="dropdown-item pointer js_delete-picture" data-handle="picture-group" data-id="{$group['group_id']}">
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
					<a href="{$system['system_url']}/groups/{$group['group_name']}" class="body-color h3 fw-bold m-0 align-middle">{$group['group_title']}</a>
				</div>
				<!-- profile-name -->
				
				<div class="mt-1">
					{if $group['group_privacy'] == "public"}
						{__("Public Group")}
					{elseif $group['group_privacy'] == "closed"}
						{__("Closed Group")}
					{elseif $group['group_privacy'] == "secret"}
						{__("Secret Group")}
					{/if}
					<span class="fw-bold mx-1">·</span>
					{__($group['group_category_name'])}
				</div>
				
				{if !is_empty($group['group_description'])}
					<div class="about-bio mt-2">
						<div class="js_readmore overflow-hidden">
							{$group['group_description']|nl2br}
						</div>
					</div>
                {/if}
				
				<div class="mt-2">
					<a href="{$system['system_url']}/groups/{$group['group_name']}/members" class="body-color small">
						<span class="fw-semibold">{$group['group_members']}</span>
						<span class="text-muted">{__("members")}</span>
					</a>
				</div>
				
		
				<!-- profile-buttons -->
				<div class="profile-buttons-wrapper position-absolute d-flex align-items-center gap-2 flex-wrap">
					<!-- join -->
					{if $group['i_joined'] == "approved"}
						<button type="button" class="btn btn-success btn-delete js_leave-group" data-id="{$group['group_id']}" data-privacy="{$group['group_privacy']}">
							<span class="">{__("Joined")}</span>
						</button>
					{elseif $group['i_joined'] == "pending"}
						<button type="button" class="btn btn-warning js_leave-group" data-id="{$group['group_id']}" data-privacy="{$group['group_privacy']}">
							<span class="">{__("Pending")}</span>
						</button>
					{else}
						<button type="button" class="btn btn-success js_join-group" data-id="{$group['group_id']}" data-privacy="{if $group['i_admin']}public{else}{$group['group_privacy']}{/if}">
							<span class="">{__("Join")}</span>
						</button>
					{/if}
					<!-- join -->

					<!-- review -->
					{if $system['groups_reviews_enabled']}
						{if !$group['i_admin']}
							<button type="button" class="btn btn-gray" data-toggle="modal" data-url="modules/review.php?do=review&id={$group['group_id']}&type=group">
								<span class="">{__("Review")}</span>
							</button>
						{/if}
					{/if}
					<!-- review -->

					<!-- report menu -->
					<div class="dropdown">
						<button type="button" class="btn btn-gray rounded-circle p-2" data-bs-toggle="dropdown" data-display="static">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none"><path d="M11.9959 12H12.0049" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M17.9998 12H18.0088" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.99981 12H6.00879" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path></svg>
						</button>
						<div class="dropdown-menu dropdown-menu-end action-dropdown-menu">
							<!-- share -->
							<div class="dropdown-item pointer align-items-start" data-toggle="modal" data-url="modules/share.php?node_type=group&node_username={$group['group_name']}">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M18 7C18.7745 7.16058 19.3588 7.42859 19.8284 7.87589C21 8.99181 21 10.7879 21 14.38C21 17.9721 21 19.7681 19.8284 20.8841C18.6569 22 16.7712 22 13 22H11C7.22876 22 5.34315 22 4.17157 20.8841C3 19.7681 3 17.9721 3 14.38C3 10.7879 3 8.99181 4.17157 7.87589C4.64118 7.42859 5.2255 7.16058 6 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M12.0253 2.00052L12 14M12.0253 2.00052C11.8627 1.99379 11.6991 2.05191 11.5533 2.17492C10.6469 2.94006 9 4.92886 9 4.92886M12.0253 2.00052C12.1711 2.00657 12.3162 2.06476 12.4468 2.17508C13.3531 2.94037 15 4.92886 15 4.92886" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
								<div class="action">
									{__("Share")}
									<div class="action-desc">{__("Share this group")}</div>
								</div>
							</div>
							<!-- share -->
							{if $user->_logged_in}
								{if !$group['i_admin']}
									<!-- report -->
									<div class="dropdown-item pointer align-items-start" data-toggle="modal" data-url="data/report.php?do=create&handle=group&id={$group['group_id']}">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M12 16H12.009" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M12 13V8" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M15.1528 4.28405C13.9789 3.84839 13.4577 2.10473 12.1198 2.00447C12.0403 1.99851 11.9603 1.99851 11.8808 2.00447C10.5429 2.10474 10.0217 3.84829 8.8478 4.28405C7.60482 4.74524 5.90521 3.79988 4.85272 4.85239C3.83967 5.86542 4.73613 7.62993 4.28438 8.84747C3.82256 10.0915 1.89134 10.6061 2.0048 12.1195C2.10506 13.4574 3.84872 13.9786 4.28438 15.1525C4.73615 16.37 3.83962 18.1346 4.85272 19.1476C5.90506 20.2001 7.60478 19.2551 8.8478 19.7159C10.0214 20.1522 10.5431 21.8954 11.8808 21.9955C11.9603 22.0015 12.0403 22.0015 12.1198 21.9955C13.4575 21.8954 13.9793 20.1521 15.1528 19.7159C16.3704 19.2645 18.1351 20.1607 19.1479 19.1476C20.2352 18.0605 19.1876 16.2981 19.762 15.042C20.2929 13.8855 22.1063 13.3439 21.9958 11.8805C21.8957 10.5428 20.1525 10.021 19.7162 8.84747C19.2554 7.60445 20.2004 5.90473 19.1479 4.85239C18.0955 3.79983 16.3958 4.74527 15.1528 4.28405Z" stroke="currentColor" stroke-width="1.75" /></svg>
										<div class="action">
											{__("Report")}
											<div class="action-desc">{__("Report this to admins")}</div>
										</div>
									</div>
									<!-- report -->
									<!-- manage -->
									{if $user->_is_admin}
										<div class="dropdown-divider"></div>
										<a class="dropdown-item" href="{$system['system_url']}/admincp/groups/edit_group/{$group['group_id']}">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
											{__("Edit in Admin Panel")}
										</a>
									{elseif $user->_is_moderator}
										<div class="dropdown-divider"></div>
										<a class="dropdown-item" href="{$system['system_url']}/modcp/groups/edit_group/{$group['group_id']}">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
											{__("Edit in Moderator Panel")}
										</a>
									{/if}
									<!-- manage -->
								{else}
									<!-- settings -->
									<div class="dropdown-divider"></div>
									<a class="dropdown-item" href="{$system['system_url']}/groups/{$group['group_name']}/settings">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M15.5 12C15.5 13.933 13.933 15.5 12 15.5C10.067 15.5 8.5 13.933 8.5 12C8.5 10.067 10.067 8.5 12 8.5C13.933 8.5 15.5 10.067 15.5 12Z" stroke="currentColor" stroke-width="1.75"></path><path d="M21.011 14.0965C21.5329 13.9558 21.7939 13.8854 21.8969 13.7508C22 13.6163 22 13.3998 22 12.9669V11.0332C22 10.6003 22 10.3838 21.8969 10.2493C21.7938 10.1147 21.5329 10.0443 21.011 9.90358C19.0606 9.37759 17.8399 7.33851 18.3433 5.40087C18.4817 4.86799 18.5509 4.60156 18.4848 4.44529C18.4187 4.28902 18.2291 4.18134 17.8497 3.96596L16.125 2.98673C15.7528 2.77539 15.5667 2.66972 15.3997 2.69222C15.2326 2.71472 15.0442 2.90273 14.6672 3.27873C13.208 4.73448 10.7936 4.73442 9.33434 3.27864C8.95743 2.90263 8.76898 2.71463 8.60193 2.69212C8.43489 2.66962 8.24877 2.77529 7.87653 2.98663L6.15184 3.96587C5.77253 4.18123 5.58287 4.28891 5.51678 4.44515C5.45068 4.6014 5.51987 4.86787 5.65825 5.4008C6.16137 7.3385 4.93972 9.37763 2.98902 9.9036C2.46712 10.0443 2.20617 10.1147 2.10308 10.2492C2 10.3838 2 10.6003 2 11.0332V12.9669C2 13.3998 2 13.6163 2.10308 13.7508C2.20615 13.8854 2.46711 13.9558 2.98902 14.0965C4.9394 14.6225 6.16008 16.6616 5.65672 18.5992C5.51829 19.1321 5.44907 19.3985 5.51516 19.5548C5.58126 19.7111 5.77092 19.8188 6.15025 20.0341L7.87495 21.0134C8.24721 21.2247 8.43334 21.3304 8.6004 21.3079C8.76746 21.2854 8.95588 21.0973 9.33271 20.7213C10.7927 19.2644 13.2088 19.2643 14.6689 20.7212C15.0457 21.0973 15.2341 21.2853 15.4012 21.3078C15.5682 21.3303 15.7544 21.2246 16.1266 21.0133L17.8513 20.034C18.2307 19.8187 18.4204 19.711 18.4864 19.5547C18.5525 19.3984 18.4833 19.132 18.3448 18.5991C17.8412 16.6616 19.0609 14.6226 21.011 14.0965Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
										{__("Settings")}
									</a>
									<!-- settings -->
								{/if}
							{/if}
						</div>
					</div>
					<!-- report menu -->
				</div>
				<!-- profile-buttons -->
			</div>
		</div>
		<!-- profile-header -->

		<!-- profile-tabs -->
		<div class="position-sticky x_top_posts profile-tabs-wrapper">
			<div class="d-flex align-items-center justify-content-center">
				{if $group['group_privacy'] == "closed" && $group['i_joined'] != "approved" && !$group['i_admin'] && !$user->_is_admin && !$user->_is_moderator}
					
				{else}
					<div {if $view == ""}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/groups/{$group['group_name']}" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Timeline")}</span>
						</a>
					</div>
					<div {if $view == "photos" || $view == "albums" || $view == "album"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/groups/{$group['group_name']}/photos" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Photos")}</span>
						</a>
					</div>
					{if $system['videos_enabled']}
						<div {if $view == "videos" || $view == "reels"}class="active fw-semibold" {/if}>
							<a href="{$system['system_url']}/groups/{$group['group_name']}/videos" class="body-color side_item_hover w-100 text-center d-block">
								<span class="position-relative d-inline-block py-3">{__("Videos")}</span>
							</a>
						</div>
					{elseif $system['reels_enabled']}
						<div {if $view == "reels"}class="active fw-semibold" {/if}>
							<a href="{$system['system_url']}/groups/{$group['group_name']}/reels" class="body-color side_item_hover w-100 text-center d-block">
								<span class="position-relative d-inline-block py-3">{__("Reels")}</span>
							</a>
						</div>
					{/if}
					{if $system['market_enabled']}
						<div {if $view == "products"}class="active fw-semibold" {/if}>
							<a href="{$system['system_url']}/groups/{$group['group_name']}/products" class="body-color side_item_hover w-100 text-center d-block">
								<span class="position-relative d-inline-block py-3">{__("Store")}</span>
							</a>
						</div>
					{/if}
					{if $system['groups_reviews_enabled']}
						<div {if $view == "reviews"}class="active fw-semibold" {/if}>
							<a href="{$system['system_url']}/groups/{$group['group_name']}/reviews" class="body-color side_item_hover w-100 text-center d-block">
								<span class="position-relative d-inline-block py-3">{__("Reviews")}</span>
							</a>
						</div>
					{/if}
					<div {if $view == "members" || $view == "invites"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/groups/{$group['group_name']}/members" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Members")}</span>
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
				<div class="col-lg-4 px-lg-3 py-3 order-2 js_sticky-sidebar">
					<!-- subscribe -->
					{if $user->_logged_in && !$group['i_admin'] && $group['has_subscriptions_plans']}
						<button class="btn btn-primary mb-3 w-100" data-toggle="modal" data-url="monetization/controller.php?do=get_plans&node_id={$group['group_id']}&node_type=group" data-size="large">
							{__("SUBSCRIBE")} {__("STARTING FROM")} ({print_money($group['group_monetization_min_price']|number_format:2)})
						</button>
					{/if}
					<!-- subscribe -->
					
					<!-- search -->
					<div class="mb-3">
						<form action="{$system['system_url']}/groups/{$group['group_name']}/search" method="get">
							<div class="position-relative">
								<input type="search" class="form-control shadow-none rounded-pill x_search_filter" name="query" placeholder='{__("Search")}' autocomplete="off" {if $query}value="{$query}" {/if}>
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"></path></svg>
							</div>
						</form>
					</div>
					<!-- search -->
					
					<!-- chatbox -->
					{if $system['chat_enabled'] && $group['chatbox_enabled']}
						{include file='_chatbox.tpl' _node_type="group" _node=$group}
					{/if}
					<!-- chatbox -->
					
					<!-- ads -->
					{include file='_ads.tpl'}
					<!-- ads -->

					<!-- panel [about] -->
					<div class="mb-3 overflow-hidden content">
						<ul class="px-3 side_item_list">
							<!-- posts -->
							<div class="d-flex align-items-start gap-2 mb-2">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M12.8809 7.01656L17.6538 8.28825M11.8578 10.8134L14.2442 11.4492M11.9765 17.9664L12.9311 18.2208C15.631 18.9401 16.981 19.2998 18.0445 18.6893C19.108 18.0787 19.4698 16.7363 20.1932 14.0516L21.2163 10.2548C21.9398 7.57005 22.3015 6.22768 21.6875 5.17016C21.0735 4.11264 19.7235 3.75295 17.0235 3.03358L16.0689 2.77924C13.369 2.05986 12.019 1.70018 10.9555 2.31074C9.89196 2.9213 9.53023 4.26367 8.80678 6.94841L7.78366 10.7452C7.0602 13.4299 6.69848 14.7723 7.3125 15.8298C7.92652 16.8874 9.27651 17.2471 11.9765 17.9664Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M12 20.9462L11.0477 21.2055C8.35403 21.939 7.00722 22.3057 5.94619 21.6832C4.88517 21.0607 4.52429 19.692 3.80253 16.9546L2.78182 13.0833C2.06006 10.3459 1.69918 8.97718 2.31177 7.89892C2.84167 6.96619 4 7.00015 5.5 7.00003" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
								{$group['posts_count']} {__("Posts")}
							</div>
							<!-- posts -->
							<!-- photos -->
							<div class="d-flex align-items-start gap-2">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75"></path><circle cx="16.5" cy="7.5" r="1.5" stroke="currentColor" stroke-width="1.75"></circle><path d="M16 22C15.3805 19.7749 13.9345 17.7821 11.8765 16.3342C9.65761 14.7729 6.87163 13.9466 4.01569 14.0027C3.67658 14.0019 3.33776 14.0127 3 14.0351" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M13 18C14.7015 16.6733 16.5345 15.9928 18.3862 16.0001C19.4362 15.999 20.4812 16.2216 21.5 16.6617" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path></svg>
								{$group['photos_count']} {__("Photos")}
							</div>
							<!-- photos -->
							{if $system['videos_enabled']}
								<!-- videos -->
								<div class="d-flex align-items-start gap-2 mt-2">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M11 8L13 8" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M2 11C2 7.70017 2 6.05025 3.02513 5.02513C4.05025 4 5.70017 4 9 4H10C13.2998 4 14.9497 4 15.9749 5.02513C17 6.05025 17 7.70017 17 11V13C17 16.2998 17 17.9497 15.9749 18.9749C14.9497 20 13.2998 20 10 20H9C5.70017 20 4.05025 20 3.02513 18.9749C2 17.9497 2 16.2998 2 13V11Z" stroke="currentColor" stroke-width="1.75"></path><path d="M17 8.90585L17.1259 8.80196C19.2417 7.05623 20.2996 6.18336 21.1498 6.60482C22 7.02628 22 8.42355 22 11.2181V12.7819C22 15.5765 22 16.9737 21.1498 17.3952C20.2996 17.8166 19.2417 16.9438 17.1259 15.198L17 15.0941" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
									{$group['videos_count']} {__("Videos")}
								</div>
								<!-- videos -->
							{/if}
							{if $system['groups_reviews_enabled']}
								<!-- reviews -->
								<div class="d-flex align-items-start gap-2 mt-2">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M13.7276 3.44418L15.4874 6.99288C15.7274 7.48687 16.3673 7.9607 16.9073 8.05143L20.0969 8.58575C22.1367 8.92853 22.6167 10.4206 21.1468 11.8925L18.6671 14.3927C18.2471 14.8161 18.0172 15.6327 18.1471 16.2175L18.8571 19.3125C19.417 21.7623 18.1271 22.71 15.9774 21.4296L12.9877 19.6452C12.4478 19.3226 11.5579 19.3226 11.0079 19.6452L8.01827 21.4296C5.8785 22.71 4.57865 21.7522 5.13859 19.3125L5.84851 16.2175C5.97849 15.6327 5.74852 14.8161 5.32856 14.3927L2.84884 11.8925C1.389 10.4206 1.85895 8.92853 3.89872 8.58575L7.08837 8.05143C7.61831 7.9607 8.25824 7.48687 8.49821 6.99288L10.258 3.44418C11.2179 1.51861 12.7777 1.51861 13.7276 3.44418Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
									{$group['reviews_count']} {__("Reviews")}
									{if $group['group_rate']}
										<span class="review-stars small">
											<i class="fa fa-star {if $group['group_rate'] >= 1}checked{/if}"></i>
											<i class="fa fa-star {if $group['group_rate'] >= 2}checked{/if}"></i>
											<i class="fa fa-star {if $group['group_rate'] >= 3}checked{/if}"></i>
											<i class="fa fa-star {if $group['group_rate'] >= 4}checked{/if}"></i>
											<i class="fa fa-star {if $group['group_rate'] >= 5}checked{/if}"></i>
										</span>
										<span class="badge bg-light text-primary">{$group['group_rate']|number_format:1}</span>
									{/if}
								</div>
								<!-- reviews -->
							{/if}
						</ul>
					</div>
					<!-- panel [about] -->

					<!-- custom fields [basic] -->
					{if $custom_fields['basic']}
						<div class="mb-3 overflow-hidden content">
							<h6 class="headline-font fw-semibold m-0 side_widget_title">
								{__("Info")}
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
					<!-- custom fields [basic] -->

					<!-- invite friends -->
					{if $group['i_joined'] == "approved" && $group['invites']}
						<div class="mb-3 overflow-hidden content">
							<h6 class="headline-font fw-semibold m-0 side_widget_title">
								<a href="{$system['system_url']}/groups/{$group['group_name']}/invites" class="body-color">{__("Invite Friends")}</a>
							</h6>
							<ul>
								{foreach $group['invites'] as $_user}
									{include file='__feeds_user.tpl' _tpl="list" _connection=$_user["connection"] _small=true}
								{/foreach}
							</ul>
						</div>
					{/if}
					<!-- invite friends -->

					<!-- photos -->
					{if $group['photos']}
						<div class="mb-3 overflow-hidden content panel-photos">
							<h6 class="headline-font fw-semibold m-0 side_widget_title">
								<a href="{$system['system_url']}/groups/{$group['group_name']}/photos" class="body-color">{__("Photos")}</a>
							</h6>
							<div class="px-3 side_item_list">
								<div class="row">
									{foreach $group['photos'] as $photo}
										{include file='__feeds_photo.tpl' _context="photos" _small=true}
									{/foreach}
								</div>
							</div>
						</div>
					{/if}
					<!-- photos -->

					<!-- mini footer -->
					{include file='_footer_mini.tpl'}
					<!-- mini footer -->
				</div>
				<!-- left panel -->

				<!-- right panel -->
				<div class="col-lg-8 order-1">

					<!-- super admin alert -->
					{if $user->_data['user_group'] < 3 && ($group['group_privacy'] == "secret" || $group['group_privacy'] == "closed") && ($group['i_joined'] != "approved" && !$group['i_admin']) }
						<div class="p-3 pb-0">
							<div class="alert alert-warning">
								<button type="button" class="btn-close float-end" data-dismiss="alert" aria-label="Close"></button>
								<div class="text align-middle">
									{__("You can access this as your account is system admin account!")}
								</div>
							</div>
						</div>
					{/if}
					<!-- super admin alert -->

					{if $get == "posts_group"}
						<!-- group requests -->
						{if $group['i_admin'] && $group['total_requests'] > 0}
							<div class="p-3 pb-0">
								<div class="alert alert-secondary">
									<div class="text">
										<a href="{$system['system_url']}/groups/{$group['group_name']}/settings/requests" class="alert-link">
											{$group['total_requests']} {if $group['total_requests'] == 1}{__("person")}{else}{__("persons")}{/if} {__("wants to join this group")}
										</a>
									</div>
								</div>
							</div>
						{/if}
						<!-- group requests -->

						<!-- group pending posts -->
						{if $group['pending_posts'] > 0}
							<div class="p-3 pb-0">
								<div class="alert alert-secondary">
									<div class="text">
										<a href="?pending" class="alert-link">
											{if $group['i_admin']}
												{$group['pending_posts']} {if $group['pending_posts'] == 1}{__("post")}{else}{__("posts")}{/if} {__("pending needs your approval")}
											{else}
												{__("You have")} {$group['pending_posts']} {if $group['pending_posts'] == 1}{__("post")}{else}{__("posts")}{/if} {__("pending")}
											{/if}
										</a>
									</div>
								</div>
							</div>
						{/if}
						<!-- group pending posts -->

						<!-- publisher -->
						{if $group['i_joined'] == "approved" && ($group['group_publish_enabled'] OR (!$group['group_publish_enabled'] && $group['i_admin']))}
							{include file='_publisher.tpl' _handle="group" _id=$group['group_id'] _node_can_monetize_content=$group['can_monetize_content'] _node_monetization_enabled=$group['group_monetization_enabled'] _node_monetization_plans=$group['group_monetization_plans']}
						{/if}
						<!-- publisher -->

						<!-- pinned post -->
						{if $pinned_post}
							{include file='_pinned_post.tpl' post=$pinned_post _get="posts_group"}
						{/if}
						<!-- pinned post -->

						<!-- posts -->
						{include file='_posts.tpl' _get="posts_group" _id=$group['group_id']}
						<!-- posts -->
					{else}
						<!-- posts -->
						{include file='_posts.tpl' _get=$get _id=$group['group_id'] _title=__("Pending Posts")}
						<!-- posts -->
					{/if}
				</div>
				<!-- right panel -->

			{elseif $view == "photos"}
				<!-- photos -->
				<div class="col-12 p-0">
					{if $group['needs_subscription']}
						{include file='_need_subscription.tpl' node_type='group' node_id=$group['group_id'] price=$group['group_monetization_min_price']}
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
											<a class="dropdown-item active" href="{$system['system_url']}/groups/{$group['group_name']}/photos">{__("Photos")}</a>
											<a class="dropdown-item" href="{$system['system_url']}/groups/{$group['group_name']}/albums">{__("Albums")}</a>
										</div>
									</div>
								</div>
							</div>
							
							{if $group['photos']}
								<ul class="row">
									{foreach $group['photos'] as $photo}
										{include file='__feeds_photo.tpl' _context="photos"}
									{/foreach}
								</ul>
								<!-- see-more -->
								<div class="alert alert-post see-more js_see-more" data-get="photos" data-id="{$group['group_id']}" data-type='group'>
									<span>{__("See More")}</span>
									<div class="loader loader_small x-hidden"></div>
								</div>
								<!-- see-more -->
							{else}
								<div class="text-center text-muted py-5">
									<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
									<div class="text-md mt-4">
										<h5 class="headline-font m-0">
											{$group['group_title']} {__("doesn't have photos")}
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
					{if $group['needs_subscription']}
						{include file='_need_subscription.tpl' node_type='group' node_id=$group['group_id'] price=$group['group_monetization_min_price']}
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
											<a class="dropdown-item" href="{$system['system_url']}/groups/{$group['group_name']}/photos">{__("Photos")}</a>
											<a class="dropdown-item active" href="{$system['system_url']}/groups/{$group['group_name']}/albums">{__("Albums")}</a>
										</div>
									</div>
								</div>
							</div>

							{if $group['albums']}
								<ul class="row">
									{foreach $group['albums'] as $album}
										{include file='__feeds_album.tpl'}
									{/foreach}
								</ul>
								{if count($group['albums']) >= $system['max_results_even']}
									<!-- see-more -->
									<div class="alert alert-post see-more js_see-more" data-get="albums" data-id="{$group['group_id']}" data-type='group'>
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
											{$group['group_title']} {__("doesn't have albums")}
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
					{if $group['needs_subscription']}
						{include file='_need_subscription.tpl' node_type='group' node_id=$group['group_id'] price=$group['group_monetization_min_price']}
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
											<a class="dropdown-item" href="{$system['system_url']}/groups/{$group['group_name']}/photos">{__("Photos")}</a>
											<a class="dropdown-item" href="{$system['system_url']}/groups/{$group['group_name']}/albums">{__("Albums")}</a>
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
					{if $group['needs_subscription']}
						{include file='_need_subscription.tpl' node_type='group' node_id=$group['group_id'] price=$group['group_monetization_min_price']}
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
												<a class="dropdown-item active" href="{$system['system_url']}/groups/{$group['group_name']}/videos">{__("Videos")}</a>
												<a class="dropdown-item" href="{$system['system_url']}/groups/{$group['group_name']}/reels">{__("Reels")}</a>
											</div>
										</div>
									</div>
								{/if}
							</div>

							{if $group['videos']}
								<ul class="row">
									{foreach $group['videos'] as $video}
										{include file='__feeds_video.tpl'}
									{/foreach}
								</ul>
								<!-- see-more -->
								<div class="alert alert-post see-more js_see-more" data-get="videos" data-id="{$group['group_id']}" data-type='group'>
									<span>{__("See More")}</span>
									<div class="loader loader_small x-hidden"></div>
								</div>
								<!-- see-more -->
						  {else}
								<div class="text-center text-muted py-5">
									<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
									<div class="text-md mt-4">
										<h5 class="headline-font m-0">
											{$group['group_title']} {__("doesn't have videos")}
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
					{if $group['needs_subscription']}
						{include file='_need_subscription.tpl' node_type='group' node_id=$group['group_id'] price=$group['group_monetization_min_price']}
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
												<a class="dropdown-item" href="{$system['system_url']}/groups/{$group['group_name']}/videos">{__("Videos")}</a>
												<a class="dropdown-item active" href="{$system['system_url']}/groups/{$group['group_name']}/reels">{__("Reels")}</a>
											</div>
										</div>
									</div>
								{/if}
							</div>

							{if $group['reels']}
								<ul class="row">
									{foreach $group['reels'] as $video}
										{include file='__feeds_video.tpl' _is_reel=true}
									{/foreach}
								</ul>
								<!-- see-more -->
								<div class="alert alert-post see-more js_see-more" data-get="videos_reels" data-id="{$group['group_id']}" data-type='group'>
									<span>{__("See More")}</span>
									<div class="loader loader_small x-hidden"></div>
								</div>
								<!-- see-more -->
						  {else}
								<div class="text-center text-muted py-5">
									<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
									<div class="text-md mt-4">
										<h5 class="headline-font m-0">
											{$group['group_title']} {__("doesn't have reels")}
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
						{include file='_need_subscription.tpl' node_type='group' node_id=$group['group_id'] price=$group['group_monetization_min_price']}
					{else}
						<div class="px-3 pb-3">
							<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
								<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Store")}</span>
							</div>
						
							<!-- search -->
							<div class="mb-3">
								<form action="{$system['system_url']}/groups/{$group['group_name']}/search" method="get">
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
								<div class="alert alert-post see-more js_see-more" data-get="products_group" data-id="{$group['group_id']}">
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

			{elseif $view == "reviews"}
				<!-- reviews -->
				<div class="col-12 p-0">
					<div class="px-3 pb-3">
						<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
							<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Reviews")}</span>
						</div>
						
						<div class="d-flex align-items-center flex-wrap justify-content-between p-3 gap-3 x_adslist">
							<div>
								<p class="mb-1 fw-medium">{__("Rating")}</p>
								<div class="d-flex gap-2">
									<h4 class="m-0 lh-1 mt-1">{$group['group_rate']|number_format:1}</h4>
									<span class="d-flex align-items-center review-stars gap-1">
										<i class="fa fa-star {if $group['group_rate'] >= 1}checked{/if}"></i>
										<i class="fa fa-star {if $group['group_rate'] >= 2}checked{/if}"></i>
										<i class="fa fa-star {if $group['group_rate'] >= 3}checked{/if}"></i>
										<i class="fa fa-star {if $group['group_rate'] >= 4}checked{/if}"></i>
										<i class="fa fa-star {if $group['group_rate'] >= 5}checked{/if}"></i>
									</span>
								</div>
								<small class="text-muted">{__("Based on")} {__($group['reviews_count'])} {__("Reviews")}</small>
							</div>
							{if !$group['i_admin']}
								<button type="button" class="btn btn-primary" data-toggle="modal" data-url="modules/review.php?do=review&id={$group['group_id']}&type=group">{__("Add")} {__("Review")}</button>
							{/if}
						</div>
						
						{if $group['reviews_count'] > 0}
							<ul class="row">
								{foreach $group['reviews'] as $_review}
									{include file='__feeds_review.tpl' _darker=true}
								{/foreach}
							</ul>
							{if $group['reviews_count'] >= $system['max_results_even']}
								<!-- see-more -->
								<div class="alert alert-post see-more mt0 mb20 js_see-more" data-get="reviews" data-id="{$group['group_id']}" data-type="group">
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
										{$group['group_title']} {__("doesn't have reviews")}
									</h5>
								</div>
							</div>
						{/if}
					</div>
				</div>
				<!-- reviews -->

			{elseif $view == "members"}
				<!-- members -->
				<div class="col-12 p-0">
					<div class="px-3 pb-3">
						<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
							<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Members")}</span>
							<div class="d-flex align-items-center flex-0 gap-10">
								<div class="dropdown">
									<button type="button" class="btn lh-1 p-2 px-3 btn-gray dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
										<span class="btn-group-text">{__("Members")}</span>
										<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.99977 9.00005L11.9998 15L17.9998 9" stroke="currentColor" stroke-width="1.75" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
									</button>
									<div class="dropdown-menu dropdown-menu-end">
										<a class="dropdown-item active" href="{$system['system_url']}/groups/{$group['group_name']}/members">
											{__("Members")}
											<span class="badge rounded-pill bg-info">{$group['group_members']}</span>
										</a>
										{if $group['has_subscriptions_plans']}
											<a class="dropdown-item" href="{$system['system_url']}/groups/{$group['group_name']}/subscribers">{__("Subscribers")}</a>
										{/if}
										{if $group['i_joined'] == "approved"}
											<a class="dropdown-item" href="{$system['system_url']}/groups/{$group['group_name']}/invites">{__("Invites")}</a>
										{/if}
									</div>
								</div>
							</div>
						</div>

						{if $group['group_members'] > 0}
							<ul class="row">
								{foreach $group['members'] as $_user}
									{include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true}
								{/foreach}
							</ul>

							{if $group['group_members'] >= $system['max_results_even']}
								<!-- see-more -->
								<div class="alert alert-post see-more js_see-more" data-get="group_members" data-id="{$group['group_id']}">
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
										{$group['group_title']} {__("doesn't have members")}
									</h5>
								</div>
							</div>
						{/if}
					</div>
				</div>
				<!-- members -->

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
										<a class="dropdown-item" href="{$system['system_url']}/groups/{$group['group_name']}/members">{__("Members")}</a>
										<a class="dropdown-item active" href="{$system['system_url']}/groups/{$group['group_name']}/subscribers">
											{__("Subscribers")}
											<span class="badge rounded-pill bg-info">{$group['subscribers_count']}</span>
										</a>
										{if $group['i_joined'] == "approved"}
											<a class="dropdown-item" href="{$system['system_url']}/groups/{$group['group_name']}/invites">{__("Invites")}</a>
										{/if}
									</div>
								</div>
							</div>
						</div>
						
						{if $group['subscribers_count'] > 0}
							<ul class="row">
								{foreach $group['subscribers'] as $_user}
									{include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true}
								{/foreach}
							</ul>
							{if count($group['subscribers']) >= $system['max_results_even']}
								<!-- see-more -->
								<div class="alert alert-post see-more mt0 mb20 js_see-more" data-get="subscribers" data-uid="{$group['group_id']}" data-type="group">
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
										{$group['group_title']} {__("doesn't have subscribers")}
									</h5>
								</div>
							</div>
						{/if}
					</div>
				</div>
				<!-- subscribers -->

			{elseif $view == "invites"}
				<!-- invites -->
				<div class="col-12 p-0">
					<div class="px-3 pb-3">
						<div class="d-flex align-items-center justify-content-between py-3 gap-10 border-0">
							<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Invites")}</span>
							<div class="d-flex align-items-center flex-0 gap-10">
								<div class="dropdown">
									<button type="button" class="btn lh-1 p-2 px-3 btn-gray dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
										<span class="btn-group-text">{__("Invites")}</span>
										<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5.99977 9.00005L11.9998 15L17.9998 9" stroke="currentColor" stroke-width="1.75" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
									</button>
									<div class="dropdown-menu dropdown-menu-end">
										<a class="dropdown-item" href="{$system['system_url']}/groups/{$group['group_name']}/members">{__("Members")}</a>
										{if $group['has_subscriptions_plans']}
											<a class="dropdown-item" href="{$system['system_url']}/groups/{$group['group_name']}/subscribers">{__("Subscribers")}</a>
										{/if}
										<a class="dropdown-item active" href="{$system['system_url']}/groups/{$group['group_name']}/invites">{__("Invites")}</a>
									</div>
								</div>
							</div>
						</div>

						{if $group['invites']}
							<ul class="row">
								{foreach $group['invites'] as $_user}
									{include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true}
								{/foreach}
							</ul>

							{if count($group['invites']) >= $system['max_results_even']}
								<!-- see-more -->
								<div class="alert alert-post see-more js_see-more" data-get="group_invites" data-id="{$group['group_id']}">
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
										{__("No friends to invite")}
									</h5>
								</div>
							</div>
						{/if}
					</div>
				</div>
				<!-- invites -->

			{elseif $view == "search"}

				<!-- left panel -->
				<div class="col-lg-4 px-lg-3 py-3 order-2 js_sticky-sidebar">
					<!-- search -->
					<div class="mb-3">
						<form action="{$system['system_url']}/groups/{$group['group_name']}/search" method="get">
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
				<div class="col-lg-8 order-1 order-lg-2">
					<!-- posts -->
					{include file='_posts.tpl' _get="posts_group" _id=$group['group_id'] _title=__("Search Results") _query=$query _filter=$filter}
					<!-- posts -->
				</div>
				<!-- right panel -->

			{elseif $view == "settings"}
				<div class="col-12 p-0">
					<div class="w-100 d-flex bg-white no_hide_settings">
						<div class="x_menu_sidebar flex-0 no_hide">
							<div class="p-3 w-100">
								<div class="headline-font fw-semibold side_widget_title p-0">
									{__("Settings")}
								</div>
							</div>
							
							<ul class="side-nav x_settings pb-3">
								<li {if $sub_view == ""}class="active" {/if}>
									<a href="{$system['system_url']}/groups/{$group['group_name']}/settings" class="main_bg_half position-relative">
										{__("Group Settings")}
									</a>
								</li>
								{if $group['group_privacy'] != "public"}
									<li {if $sub_view == "requests"}class="active" {/if}>
										<a href="{$system['system_url']}/groups/{$group['group_name']}/settings/requests" class="main_bg_half position-relative">
											{__("Join Requests")}
										</a>
									</li>
								{/if}
								<li {if $sub_view == "members"}class="active" {/if}>
									<a href="{$system['system_url']}/groups/{$group['group_name']}/settings/members" class="main_bg_half position-relative">
										{__("Members")}
									</a>
								</li>
								{if $user->_data['can_monetize_content']}
									<li {if $sub_view == "monetization"}class="active" {/if}>
										<a href="{$system['system_url']}/groups/{$group['group_name']}/settings/monetization" class="main_bg_half position-relative">
											{__("Monetization")}
										</a>
									</li>
								{/if}
								{if $user->_data['user_id'] == $group['group_admin']}
									<li {if $sub_view == "delete"}class="active" {/if}>
										<a href="{$system['system_url']}/groups/{$group['group_name']}/settings/delete" class="main_bg_half position-relative">
											{__("Delete Group")}
										</a>
									</li>
								{/if}
							</ul>
						</div>
						<div class="x_menu_sidebar_content flex-1">
							{if $sub_view == ""}
								<div class="p-3 w-100">
									<div class="headline-font fw-semibold side_widget_title p-0">
										{__("Group Settings")}
									</div>
								</div>
								
								<form class="js_ajax-forms p-3 pt-1" data-url="modules/create.php?type=group&do=edit&edit=settings&id={$group['group_id']}">
									<div class="form-floating">
										<input type="text" class="form-control" name="title" id="title" placeholder='{__("Name of your group")}' value="{$group['group_title']}">
										<label class="form-label" for="title">{__("Name Your Group")}</label>
									</div>
									<div class="form-floating">
										<input type="text" class="form-control" name="username" id="username" value="{$group['group_name']}" placeholder=" ">
										<label class="form-label" for="username">{__("Group Username")}</label>
										<div class="form-text">
											{__("Can only contain alphanumeric characters (A–Z, 0–9) and periods ('.')")}
										</div>
									</div>
									<div class="form-floating">
										<select class="form-select" name="privacy">
											<option {if $group['group_privacy'] == "public"}selected{/if} value="public">{__("Public Group")}</option>
											<option {if $group['group_privacy'] == "closed"}selected{/if} value="closed">{__("Closed Group")}</option>
											<option {if $group['group_privacy'] == "secret"}selected{/if} value="secret">{__("Secret Group")}</option>
										</select>
										<label class="form-label" for="privacy">{__("Select Privacy")}</label>
										<div class="form-text">
											({__("Note: Change group privacy to public will approve any pending join requests")})
										</div>
									</div>
									<div class="form-floating">
										<select class="form-select" name="category" id="category">
											{foreach $categories as $category}
												{include file='__categories.recursive_options.tpl' data_category=$group['group_category']}
											{/foreach}
										</select>
										<label class="form-label" for="title">{__("Category")}</label>
									</div>
									<div class="form-floating">
										<select class="form-select" name="country">
											<option value="none">{__("Select Country")}</option>
											{foreach $countries as $country}
												<option value="{$country['country_id']}" {if $group['group_country'] == $country['country_id']}selected{/if}>{$country['country_name']}</option>
											{/foreach}
										</select>
										<label class="form-label" for="country">{__("Country")}</label>
									</div>
									<div class="form-floating">
										<select class="form-select" name="language">
											<option value="none">{__("Select Language")}</option>
											{foreach $languages as $language}
												<option value="{$language['language_id']}" {if $group['group_language'] == $language['language_id']}selected{/if}>{$language['title']}</option>
											{/foreach}
										</select>
										<label class="form-label" for="language">{__("Language")}</label>
									</div>
									<div class="form-floating">
										<textarea class="form-control" name="description" id="description" rows="4" placeholder=" ">{$group['group_description']}</textarea>
										<label class="form-label" for="description">{__("About")}</label>
									</div>
									<!-- custom fields -->
									{if $custom_fields['basic']}
										{include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
									{/if}
									<!-- custom fields -->

									<hr>

									{if $system['chat_enabled']}
										<div class="form-table-row mb-2 pb-1">
											<div>
											  <div class="form-label mb-0">{__("Chat Box")}</div>
											  <div class="form-text d-none d-sm-block mt-0">{__("Enable chat box for this group")}</div>
											</div>
											<div class="text-end align-self-center flex-0">
												<label class="switch" for="chatbox_enabled">
													<input type="checkbox" name="chatbox_enabled" id="chatbox_enabled" {if $group['chatbox_enabled']}checked{/if}>
													<span class="slider round"></span>
												</label>
											</div>
										</div>
									{/if}

									<div class="form-table-row mb-2 pb-1">
										<div>
											<div class="form-label mb-0">{__("Members Can Publish Posts?")}</div>
											<div class="form-text d-none d-sm-block mt-0">{__("Members can publish posts or only group admins")}</div>
										</div>
										<div class="text-end align-self-center flex-0">
											<label class="switch" for="group_publish_enabled">
												<input type="checkbox" name="group_publish_enabled" id="group_publish_enabled" {if $group['group_publish_enabled']}checked{/if}>
												<span class="slider round"></span>
											</label>
										</div>
									</div>

									<div class="form-table-row mb-2 pb-1">
										<div>
											<div class="form-label mb-0">{__("Post Approval")}</div>
											<div class="form-text d-none d-sm-block mt-0">
												{__("All posts must be approved by a group admin")}<br>
												({__("Note: Disable it will approve any pending posts")})
											</div>
										</div>
										<div class="text-end align-self-center flex-0">
											<label class="switch" for="group_publish_approval_enabled">
												<input type="checkbox" name="group_publish_approval_enabled" id="group_publish_approval_enabled" {if $group['group_publish_approval_enabled']}checked{/if}>
												<span class="slider round"></span>
											</label>
										</div>
									</div>

									<!-- error -->
									<div class="alert alert-danger mt15 mb0 x-hidden"></div>
									<!-- error -->
									
									<hr class="hr-2">

									<div class="text-end">
										<button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
									</div>
								</form>
								
							{elseif $sub_view == "requests"}
								<div class="p-3 w-100">
									<div class="headline-font fw-semibold side_widget_title p-0">
										{__("Member Requests")}
									</div>
								</div>
								
								{if $group['requests']}
									<ul>
										{foreach $group['requests'] as $_user}
											{include file='__feeds_user.tpl' _tpl="list" _connection=$_user["connection"]}
										{/foreach}
									</ul>

									{if count($group['requests']) >= $system['max_results']}
										<!-- see-more -->
										<div class="px-3">
											<div class="alert alert-post see-more js_see-more" data-get="group_requests" data-id="{$group['group_id']}">
												<span>{__("See More")}</span>
												<div class="loader loader_small x-hidden"></div>
											</div>
										</div>
										<!-- see-more -->
									{/if}
								{else}
									<div class="text-center text-muted py-5">
										<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
										<div class="text-md mt-4">
											<h5 class="headline-font m-0">
												{__("No Requests")}
											</h5>
										</div>
									</div>
								{/if}

							{elseif $sub_view == "members"}
								<div class="p-3 w-100">
									<div class="headline-font fw-semibold side_widget_title p-0">
										{__("Members")}
									</div>
								</div>
								
								<!-- admins -->
								<div class="heading-small mb-1 px-3">
									{__("Admins")} <span class="text-muted">({$group['group_admins_count']})</span>
								</div>
								{if $group['group_admins']}
									<ul>
										{foreach $group['group_admins'] as $_user}
											{include file='__feeds_user.tpl' _tpl="list" _connection=$_user["connection"]}
										{/foreach}
									</ul>

									{if $group['group_admins_count'] >= $system['max_results_even']}
										<!-- see-more -->
										<div class="px-3">
											<div class="alert alert-post see-more js_see-more" data-get="group_admins" data-id="{$group['group_id']}">
												<span>{__("See More")}</span>
												<div class="loader loader_small x-hidden"></div>
											</div>
										</div>
										<!-- see-more -->
									{/if}
								{else}
									<div class="text-center text-muted py-5">
										<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
										<div class="text-md mt-4">
											<h5 class="headline-font m-0">
												{$group['group_title']} {__("doesn't have admins")}
											</h5>
										</div>
									</div>
								{/if}
								<!-- admins -->

								<hr>

								<!-- members -->
								<div class="heading-small mb-1 px-3">
									{__("All Members")} <span class="text-muted">({$group['group_members']})</span>
								</div>
								{if $group['group_members'] > 0}
									<ul>
										{foreach $group['members'] as $_user}
											{include file='__feeds_user.tpl' _tpl="list" _connection=$_user["connection"]}
										{/foreach}
									</ul>

									{if $group['group_members'] >= $system['max_results_even']}
										<!-- see-more -->
										<div class="px-3">
											<div class="alert alert-post see-more js_see-more" data-get="group_members_manage" data-id="{$group['group_id']}">
												<span>{__("See More")}</span>
												<div class="loader loader_small x-hidden"></div>
											</div>
										</div>
										<!-- see-more -->
									{/if}
								{else}
									<div class="text-center text-muted py-5">
										<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.5"><path d="M19.0253 1.25C19.4697 1.24999 19.8408 1.24999 20.1454 1.27077C20.4625 1.29241 20.762 1.33905 21.0524 1.45933C21.7262 1.73844 22.2616 2.27379 22.5407 2.94762C22.661 3.23801 22.7076 3.53754 22.7292 3.85464C22.75 4.15925 22.75 4.53028 22.75 4.97474V9.02526C22.75 9.46972 22.75 9.84075 22.7292 10.1454C22.7076 10.4625 22.661 10.762 22.5407 11.0524C22.2616 11.7262 21.7262 12.2616 21.0524 12.5407C20.762 12.661 20.4625 12.7076 20.1454 12.7292C19.8408 12.75 19.4697 12.75 19.0253 12.75H18.9747C18.5303 12.75 18.1592 12.75 17.8546 12.7292C17.5375 12.7076 17.238 12.661 16.9476 12.5407C16.2738 12.2616 15.7384 11.7262 15.4593 11.0524C15.339 10.762 15.2924 10.4625 15.2708 10.1454C15.25 9.84076 15.25 9.46972 15.25 9.02526V9.02525V4.97475V4.97474C15.25 4.53028 15.25 4.15925 15.2708 3.85464C15.2924 3.53754 15.339 3.23801 15.4593 2.94762C15.7384 2.27379 16.2738 1.73844 16.9476 1.45933C17.238 1.33905 17.5375 1.29241 17.8546 1.27077C18.1592 1.24999 18.5303 1.24999 18.9747 1.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path opacity="0.4" d="M19.0253 15.25C19.4697 15.25 19.8408 15.25 20.1454 15.2708C20.4625 15.2924 20.762 15.339 21.0524 15.4593C21.7262 15.7384 22.2616 16.2738 22.5407 16.9476C22.661 17.238 22.7076 17.5375 22.7292 17.8546C22.75 18.1592 22.75 18.5303 22.75 18.9747V19.0253C22.75 19.4697 22.75 19.8408 22.7292 20.1454C22.7076 20.4625 22.661 20.762 22.5407 21.0524C22.2616 21.7262 21.7262 22.2616 21.0524 22.5407C20.762 22.661 20.4625 22.7076 20.1454 22.7292C19.8408 22.75 19.4697 22.75 19.0253 22.75H18.9747C18.5303 22.75 18.1592 22.75 17.8546 22.7292C17.5375 22.7076 17.238 22.661 16.9476 22.5407C16.2738 22.2616 15.7384 21.7262 15.4593 21.0524C15.339 20.762 15.2924 20.4625 15.2708 20.1454C15.25 19.8408 15.25 19.4697 15.25 19.0253V19.0253V18.9747V18.9747C15.25 18.5303 15.25 18.1592 15.2708 17.8546C15.2924 17.5375 15.339 17.238 15.4593 16.9476C15.7384 16.2738 16.2738 15.7384 16.9476 15.4593C17.238 15.339 17.5375 15.2924 17.8546 15.2708C18.1592 15.25 18.5303 15.25 18.9747 15.25H18.9747H19.0253H19.0253Z" fill="currentColor"/><path d="M8.05203 11.25C8.9505 11.25 9.69971 11.2499 10.2945 11.3299C10.9223 11.4143 11.4891 11.6 11.9445 12.0555C12.4 12.5109 12.5857 13.0777 12.6701 13.7055C12.7501 14.3003 12.75 15.0495 12.75 15.948V15.948V18.052V18.052C12.75 18.9505 12.7501 19.6997 12.6701 20.2945C12.5857 20.9223 12.4 21.4891 11.9445 21.9445C11.4891 22.4 10.9223 22.5857 10.2945 22.6701C9.69971 22.7501 8.9505 22.75 8.05203 22.75H8.052H5.94801H5.94798C5.04951 22.75 4.3003 22.7501 3.70552 22.6701C3.07773 22.5857 2.51093 22.4 2.05546 21.9445C1.59999 21.4891 1.41432 20.9223 1.32991 20.2945C1.24995 19.6997 1.24997 18.9505 1.25 18.052V18.052V15.948V15.948C1.24997 15.0495 1.24995 14.3003 1.32991 13.7055C1.41432 13.0777 1.59999 12.5109 2.05546 12.0555C2.51093 11.6 3.07773 11.4143 3.70552 11.3299C4.3003 11.2499 5.04951 11.25 5.94797 11.25H5.948H8.052H8.05203Z" fill="currentColor"/><path opacity="0.4" d="M9.02526 1.25C9.46972 1.24999 9.84076 1.24999 10.1454 1.27077C10.4625 1.29241 10.762 1.33905 11.0524 1.45933C11.7262 1.73844 12.2616 2.27379 12.5407 2.94762C12.661 3.23801 12.7076 3.53754 12.7292 3.85464C12.75 4.15925 12.75 4.53028 12.75 4.97474V5.02526C12.75 5.46972 12.75 5.84075 12.7292 6.14537C12.7076 6.46247 12.661 6.76199 12.5407 7.05238C12.2616 7.72621 11.7262 8.26156 11.0524 8.54067C10.762 8.66095 10.4625 8.7076 10.1454 8.72923C9.84075 8.75001 9.46972 8.75001 9.02526 8.75H4.97474C4.53028 8.75001 4.15925 8.75001 3.85464 8.72923C3.53754 8.7076 3.23801 8.66095 2.94762 8.54067C2.27379 8.26156 1.73844 7.72621 1.45933 7.05238C1.33905 6.76199 1.29241 6.46247 1.27077 6.14537C1.24999 5.84075 1.24999 5.46972 1.25 5.02526V5.02525V4.97475V4.97474C1.24999 4.53028 1.24999 4.15925 1.27077 3.85464C1.29241 3.53754 1.33905 3.23801 1.45933 2.94762C1.73844 2.27379 2.27379 1.73844 2.94762 1.45933C3.23801 1.33905 3.53754 1.29241 3.85464 1.27077C4.15925 1.24999 4.53028 1.24999 4.97474 1.25H4.97475H9.02525H9.02526Z" fill="currentColor"/></svg>
										<div class="text-md mt-4">
											<h5 class="headline-font m-0">
												{$group['group_title']} {__("doesn't have members")}
											</h5>
										</div>
									</div>
								{/if}
								<!-- members -->

							{elseif $sub_view == "monetization"}
								<div class="p-3 w-100">
									<div class="headline-font fw-semibold side_widget_title p-0">
										{__("Monetization")}
									</div>
								</div>
								
								<div class="p-3 pt-1">
									<div class="alert alert-secondary">
										<div class="text">
											<p>
												{__("Now you can earn money from your content. Via paid posts or subscriptions plans.")}
											</p>
											{if $system['monetization_commission'] > 0}
												<p>
													{__("There is commission")} <strong><span class="badge rounded-pill bg-warning">{$system['monetization_commission']}%</span></strong> {__("will be deducted")}.
												</p>
											{/if}
											{if $system['monetization_money_withdraw_enabled']}
												{__("You can")} <a class="alert-link" href="{$system['system_url']}/settings/monetization/payments" target="_blank">{__("withdraw your money")}</a>
											{/if}
											{if $system['monetization_money_transfer_enabled']}
												{if $system['monetization_money_withdraw_enabled']}{__("or")} {/if}
												{__("You can transfer your money to your")} <a class="alert-link" href="{$system['system_url']}/wallet" target="_blank"> {__("wallet")}</a>
											{/if}
										</div>
									</div>

									<div class="alert alert-info">
										<div class="text pt5">
											{__("Only super admin can manage monetization and money goes to his monetization money balance")}.
										</div>
									</div>

									<div class="heading-small mb-1">
										{__("Monetization Settings")}
									</div>
									<form class="js_ajax-forms" data-url="modules/create.php?type=group&do=edit&edit=monetization&id={$group['group_id']}">
										<div class="form-table-row mb-2 pb-1">
											<div>
												<div class="form-label mb-0">{__("Monetization")}</div>
												<div class="form-text d-none d-sm-block mt-0">{__("Enable or disable monetization for your content")}</div>
											</div>
											<div class="text-end align-self-center flex-0">
												<label class="switch" for="group_monetization_enabled">
													<input type="checkbox" name="group_monetization_enabled" id="group_monetization_enabled" {if $group['group_monetization_enabled']}checked{/if}>
													<span class="slider round"></span>
												</label>
											</div>
										</div>
										
										<hr>
										
										<div class="heading-small mb-1">
											{__("Subscriptions")}
										</div>
										<label class="form-label">
											{__("Subscriptions Plans")}
										</label>

										<div class="row payment-plans">
											<div class="col-md-6 mb-4">
												<div data-toggle="modal" data-url="monetization/controller.php?do=add&node_id={$group['group_id']}&node_type=group" class="payment-plan new h-100 x_adslist pointer p-3">
													<div class="d-flex align-items-center justify-content-center w-100 h-100 flex-column gap-2 fw-medium">
														<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 3C12.5523 3 13 3.44772 13 4V11H20C20.5523 11 21 11.4477 21 12C21 12.5523 20.5523 13 20 13H13V20C13 20.5523 12.5523 21 12 21C11.4477 21 11 20.5523 11 20V13H4C3.44772 13 3 12.5523 3 12C3 11.4477 3.44772 11 4 11H11V4C11 3.44772 11.4477 3 12 3Z" fill="currentColor"></path></svg>
														{__("Add new plan")}
													</div>
												</div>
											</div>
											{foreach $monetization_plans as $plan}
												<div class="col-md-6 mb-4">
													<div class="payment-plan h-100 x_adslist p-3">
														<div class="h5 mb-1 fw-semibold">{__($plan['title'])}</div>
														<div class="">{print_money($plan['price'])} / {if $plan['period_num'] != '1'}{$plan['period_num']}{/if} {__($plan['period']|ucfirst)}</div>
														{if {$plan['custom_description']}}
															<div class="small">{$plan['custom_description']}</div>
														{/if}
														<div class="d-flex align-items-center mt-3 gap-2">
															<button type="button" class="btn bg-white flex-1" data-toggle="modal" data-url="monetization/controller.php?do=edit&id={$plan['plan_id']}">
																<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg> {__("Edit")}
															</button>
															<button type="button" class="btn bg-white flex-0 rounded-circle p-2 lh-1 js_monetization-deleter" data-id="{$plan['plan_id']}" title='{__("Delete")}'>
																<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="m-1"><path d="M19.5 5.5L18.8803 15.5251C18.7219 18.0864 18.6428 19.3671 18.0008 20.2879C17.6833 20.7431 17.2747 21.1273 16.8007 21.416C15.8421 22 14.559 22 11.9927 22C9.42312 22 8.1383 22 7.17905 21.4149C6.7048 21.1257 6.296 20.7408 5.97868 20.2848C5.33688 19.3626 5.25945 18.0801 5.10461 15.5152L4.5 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M3 5.5H21M16.0557 5.5L15.3731 4.09173C14.9196 3.15626 14.6928 2.68852 14.3017 2.39681C14.215 2.3321 14.1231 2.27454 14.027 2.2247C13.5939 2 13.0741 2 12.0345 2C10.9688 2 10.436 2 9.99568 2.23412C9.8981 2.28601 9.80498 2.3459 9.71729 2.41317C9.32164 2.7167 9.10063 3.20155 8.65861 4.17126L8.05292 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M9.5 16.5L9.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M14.5 16.5L14.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
															</button>
														</div>
													</div>
												</div>
											{/foreach}
										</div>

										<div class="text-center">
											<button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
										</div>

										<!-- success -->
										<div class="alert alert-success mt15 mb0 x-hidden"></div>
										<!-- success -->

										<!-- error -->
										<div class="alert alert-danger mt15 mb0 x-hidden"></div>
										<!-- error -->
									</form>
									
									<hr class="my-4">

									<div class="heading-small mb-1">
										{__("Monetization Balance")}
									</div>
									
									<div class="row">
										<!-- subscribers -->
										<div class="col-lg-6">
											<div class="stat-panel bg-info bg-opacity-10">
												<div class="stat-cell narrow">
													<div class="">{__("Group Subscribers")}</div>
													<div class="h3 m-0 mt-2">{$subscribers_count}</div>
												</div>
											</div>
										</div>
										<!-- subscribers -->

										<!-- money balance -->
										<div class="col-lg-6">
											<div class="stat-panel bg-success bg-opacity-10">
												<div class="stat-cell narrow">
													<div class="">{__("Monetization Money Balance")}</div>
													<div class="h3 m-0 mt-2">{print_money($user->_data['user_monetization_balance']|number_format:2)}</div>
												</div>
											</div>
										</div>
										<!-- monetization balance -->
									</div>
								</div>
								
							{elseif $sub_view == "delete"}
								<div class="p-3 w-100">
									<div class="headline-font fw-semibold side_widget_title p-0">
										{__("Delete Group")}
									</div>
								</div>
								
								<div class="p-3 pt-1">
									<div class="alert alert-secondary">
										<div class="text">
											{__("Once you delete your group you will no longer can access it again")}
										</div>
									</div>

									<div class="text-center">
										<button class="btn btn-danger js_delete-group" data-id="{$group['group_id']}">
											{__("Delete Group")}
										</button>
									</div>
								</div>
							{/if}
						</div>
					</div>
				</div>
			{/if}
			<!-- view content -->
		</div>
		<!-- profile-content -->
    </div>
    <!-- content panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}