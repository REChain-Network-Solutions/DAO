{if $_post['for_subscriptions']}
	<div class="main fw-bold small mb-2 d-flex align-items-center gap-1">
		<svg width="14" height="14" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M17.9982 13.25C18.67 13.25 19.12 13.7533 19.3627 14.245L19.3632 14.2459L20.0587 15.6484L20.0645 15.654C20.0693 15.6583 20.0749 15.663 20.0811 15.6676C20.0874 15.6722 20.0935 15.6763 20.0992 15.6798L20.1075 15.6844L21.3626 15.8947C21.9028 15.9855 22.4905 16.275 22.6893 16.8985C22.8877 17.521 22.5775 18.0974 22.1899 18.486L22.1889 18.487L21.2132 19.4708C21.2098 19.4778 21.2053 19.4888 21.2014 19.5027C21.197 19.5181 21.1949 19.5314 21.1942 19.5401L21.4735 20.7579C21.5995 21.3093 21.6116 22.0753 21.0171 22.5123C20.4194 22.9516 19.6913 22.7048 19.2061 22.4159L18.0294 21.7135C18.0283 21.702 18.0142 21.6859 17.9668 21.7142L16.7916 22.4156C16.3047 22.7069 15.5783 22.9496 14.9815 22.5106C14.3883 22.0742 14.397 21.3106 14.524 20.7572L14.8031 19.5401C14.8024 19.5314 14.8003 19.5181 14.7959 19.5027C14.792 19.4888 14.7875 19.4778 14.7841 19.4708L13.8065 18.4851C13.4213 18.0967 13.1123 17.5211 13.3091 16.8998C13.5068 16.2757 14.0941 15.9855 14.6351 15.8946L15.8859 15.6851L15.893 15.681C15.8987 15.6775 15.9049 15.6734 15.9113 15.6687C15.9176 15.6639 15.9233 15.6592 15.9282 15.6547L15.9345 15.6487L16.6315 14.2431C16.8762 13.7522 17.3273 13.25 17.9982 13.25Z" fill="currentColor"/><path d="M5.74919 6.5C5.74919 3.6005 8.0997 1.25 10.9992 1.25C13.8987 1.25 16.2492 3.6005 16.2492 6.5C16.2492 9.39949 13.8987 11.75 10.9992 11.75C8.0997 11.75 5.74919 9.39949 5.74919 6.5Z" fill="currentColor"/><path d="M14.439 14.3825C14.489 14.3525 14.514 14.3375 14.5301 14.3244C14.702 14.1856 14.6657 13.9073 14.4639 13.8172C14.4449 13.8087 14.4182 13.801 14.3648 13.7855C13.8202 13.628 13.0833 13.4302 12.6038 13.3625C11.5399 13.2125 10.4581 13.2125 9.39427 13.3625C7.9298 13.5691 6.49773 14.0602 5.19288 14.8372C5.07659 14.9064 4.93296 14.9874 4.77034 15.0792C4.05753 15.4813 2.9799 16.0893 2.24174 16.8118C1.78007 17.2637 1.34141 17.8592 1.26167 18.5888C1.17686 19.3646 1.51533 20.0927 2.19434 20.7396C3.36579 21.8556 4.77158 22.75 6.58989 22.75H12.2935C12.7003 22.75 12.9037 22.75 12.9933 22.6475C13.083 22.545 13.0507 22.3047 12.9861 21.8241C12.9094 21.2541 12.9885 20.7329 13.0599 20.4219L13.0898 20.2912C13.126 20.1337 13.144 20.055 13.1229 19.9808C13.1017 19.9066 13.0448 19.8493 12.931 19.7346L12.7395 19.5414C12.1778 18.9751 11.4358 17.84 11.8771 16.4469C12.3097 15.081 13.5273 14.5747 14.322 14.4264C14.3312 14.4247 14.3358 14.4238 14.339 14.4232C14.3713 14.4164 14.398 14.4063 14.4267 14.3899C14.4295 14.3883 14.4327 14.3864 14.439 14.3825Z" fill="currentColor"/></svg>
		{__("Subscriptions")}
	</div>
{/if}
{if $_post['is_paid']}
	<div class="text-success text-opacity-75 fw-bold small mb-2 d-flex align-items-center gap-1">
		<svg width="14" height="14" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M7.78894 3.38546C7.87779 3.52092 7.77748 3.75186 7.57686 4.21374C7.49965 4.39151 7.42959 4.57312 7.36705 4.75819C7.29287 4.9777 7.25578 5.08746 7.17738 5.14373C7.09897 5.19999 6.99012 5.19999 6.77242 5.19999H4.18138C3.64164 5.19999 3.2041 5.63651 3.2041 6.17499C3.2041 6.71346 3.64164 7.14998 4.18138 7.14998L15.9776 7.14998C16.8093 7.13732 18.6295 7.14275 19.2563 7.26578C20.1631 7.3874 20.9639 7.65257 21.6051 8.29227C22.2463 8.93197 22.512 9.73091 22.6339 10.6355C22.7501 11.4972 22.75 12.5859 22.75 13.9062V15.9937C22.75 17.314 22.7501 18.4027 22.6339 19.2644C22.512 20.169 22.2463 20.9679 21.6051 21.6076C20.9639 22.2473 20.1631 22.5125 19.2563 22.6341C18.3927 22.75 17.3014 22.75 15.978 22.7499H9.97398C8.19196 22.7499 6.75559 22.75 5.6259 22.5984C4.45303 22.4411 3.4655 22.1046 2.68119 21.3221C1.89687 20.5396 1.55952 19.5543 1.40184 18.3842C1.24996 17.2572 1.24998 15.8241 1.25 14.0463V6.175C1.25 4.55957 2.56262 3.25001 4.18182 3.25001L6.99624 3.25C7.46547 3.25 7.70009 3.25 7.78894 3.38546ZM17.5 12.9998C18.6046 12.9998 19.5 13.8952 19.5 14.9998C19.5 16.1043 18.6046 16.9998 17.5 16.9998C16.3954 16.9998 15.5 16.1043 15.5 14.9998C15.5 13.8952 16.3954 12.9998 17.5 12.9998Z" fill="currentColor"/><path d="M19.4557 6.03151C19.563 6.0463 19.6555 5.95355 19.6339 5.84742C19.1001 3.22413 16.7803 1.25 13.9994 1.25C11.3264 1.25 9.07932 3.07399 8.43503 5.54525C8.38746 5.72772 8.52962 5.90006 8.7182 5.90006L15.9679 5.90006C16.3968 5.89365 17.0712 5.89192 17.7232 5.90742C18.3197 5.92161 19.0159 5.95164 19.4557 6.03151Z" fill="currentColor"/></svg>
		{__("Paid")}
	</div>
{/if}
{if $_post['for_adult']}
	<div class="text-danger text-opacity-75 fw-bold small mb-2 d-flex align-items-center gap-1">
		<svg width="14" height="14" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 4.25C11.0058 4.25 10.0648 4.41965 9.18654 4.70497C8.93836 4.78559 8.74992 4.98943 8.689 5.24317C8.62807 5.49691 8.70342 5.76408 8.88794 5.9486L18.9086 15.9693C19.2008 16.2614 19.6741 16.2623 19.9673 15.9713C20.9298 15.016 21.7239 13.9948 22.2078 13.3163C22.461 12.9642 22.75 12.5622 22.75 12C22.75 11.4378 22.4077 10.9616 22.1546 10.6095C21.4487 9.61974 20.1869 8.04576 18.4797 6.71298C16.774 5.38141 14.5706 4.25 12 4.25ZM7.27775 6.21709C7.02388 5.96322 6.62572 5.92487 6.32806 6.12561C4.20574 7.55694 2.60227 9.54781 1.79219 10.6837C1.53904 11.0358 1.25 11.4378 1.25 12C1.25 12.5622 1.59226 13.0384 1.84541 13.3905C2.55126 14.3803 3.81313 15.9542 5.52031 17.287C7.22595 18.6186 9.42944 19.75 12 19.75C14.1829 19.75 16.1016 18.9335 17.6719 17.8744C17.8576 17.7491 17.9776 17.5475 17.9991 17.3245C18.0206 17.1015 17.9413 16.8806 17.7829 16.7223L7.27775 6.21709ZM9.52944 9.5C8.8934 10.136 8.5 11.0147 8.5 11.9853C8.5 13.9264 10.0736 15.5 12.0147 15.5C12.9853 15.5 13.864 15.1066 14.5 14.4706L9.52944 9.5Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M2.29289 2.29289C2.68342 1.90237 3.31658 1.90237 3.70711 2.29289L21.7071 20.2929C22.0976 20.6834 22.0976 21.3166 21.7071 21.7071C21.3166 22.0976 20.6834 22.0976 20.2929 21.7071L2.29289 3.70711C1.90237 3.31658 1.90237 2.68342 2.29289 2.29289Z" fill="currentColor"/></svg>
		{__("Adult")}
	</div>
{/if}

<!-- post header -->
<div class="d-flex justify-content-between x_user_info post-header">
	<div class="d-flex position-relative mw-0">
		<!-- post picture -->
		<div class="post-avatar position-relative flex-0">
			{if $_post['is_anonymous']}
				<div class="post-avatar-anonymous text-white rounded-circle overflow-hidden d-flex align-items-center justify-content-center">
					<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M7.13889 16.124C6.065 16.124 5.19444 16.9635 5.19444 17.999C5.19444 19.0346 6.065 19.874 7.13889 19.874C8.21278 19.874 9.08333 19.0346 9.08333 17.999C9.08333 16.9635 8.21278 16.124 7.13889 16.124ZM3.25 17.999C3.25 15.928 4.99112 14.249 7.13889 14.249C8.57833 14.249 9.83511 15.0031 10.5075 16.124H13.4925C14.1649 15.0031 15.4217 14.249 16.8611 14.249C19.0089 14.249 20.75 15.928 20.75 17.999C20.75 20.0701 19.0089 21.749 16.8611 21.749C14.7133 21.749 12.9722 20.0701 12.9722 17.999L11.0278 17.999C11.0278 20.0701 9.28666 21.749 7.13889 21.749C4.99112 21.749 3.25 20.0701 3.25 17.999ZM16.8611 16.124C15.7872 16.124 14.9167 16.9635 14.9167 17.999C14.9167 19.0346 15.7872 19.874 16.8611 19.874C17.935 19.874 18.8056 19.0346 18.8056 17.999C18.8056 16.9635 17.935 16.124 16.8611 16.124Z" fill="currentColor"/><path d="M5.31634 4.59645C5.6103 2.70968 7.67269 1.66315 9.35347 2.59225L9.96847 2.93221C11.2351 3.63236 12.7647 3.63236 14.0313 2.93221L14.6463 2.59225C16.3271 1.66315 18.3895 2.70968 18.6834 4.59644L19.7409 11.384C19.7788 11.6271 19.695 11.8734 19.5167 12.043C19.3383 12.2125 19.0882 12.2838 18.8472 12.2337C16.7318 11.7939 10.9673 11.1659 5.13538 12.2371C4.89638 12.281 4.65092 12.2064 4.47679 12.0369C4.30265 11.8674 4.22142 11.6241 4.25883 11.384L5.31634 4.59645Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M12.0005 11.9989C8.22613 11.9989 4.89604 12.6584 2.66477 13.6566C2.18196 13.8726 1.59501 13.6972 1.35376 13.265C1.11251 12.8327 1.30834 12.3072 1.79114 12.0912C4.3613 10.9414 8.00877 10.249 12.0005 10.249C15.9922 10.249 19.6397 10.9414 22.2098 12.0912C22.6926 12.3072 22.8885 12.8327 22.6472 13.265C22.406 13.6972 21.819 13.8726 21.3362 13.6566C19.1049 12.6584 15.7748 11.9989 12.0005 11.9989Z" fill="currentColor"/></svg>
				</div>
			{else}
				<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$_post['post_author_url']}" style="background-image:url({$_post['post_author_picture']});"></a>
				{if $_post['post_author_online']}<span class="online-dot position-absolute rounded-circle"></span>{/if}
			{/if}
		</div>
		<!-- post picture -->
		<div class="mw-0 mx-2">
			<!-- post meta -->
			<div class="post-meta">
				<!-- post author -->
				{if $_post['is_anonymous']}
					<span class="post-author fw-semibold">{__("Anonymous")}</span>
				{else}
					<span class="js_user-popover" data-type="{$_post['user_type']}" data-uid="{$_post['user_id']}">
						<a class="post-author fw-semibold body-color" href="{$_post['post_author_url']}">{$_post['post_author_name']}</a>
					</span>
					{if $_post['post_author_verified']}
						<span class="verified-badge" data-bs-toggle="tooltip" {if $_post['user_type'] == "user"}title='{__("Verified User")}'{else}title='{__("Verified Page")}'{/if}>
							<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
						</span>
					{/if}
					{if $_post['user_subscribed']}
						<span class="pro-badge" data-bs-toggle="tooltip" title='{__($_post['package_name'])} {__("Member")}'>
							<svg xmlns='http://www.w3.org/2000/svg' height='17' viewBox='0 0 24 24' width='17'><path d='M0 0h24v24H0z' fill='none'></path><path fill='currentColor' d='M12 2.02c-5.51 0-9.98 4.47-9.98 9.98s4.47 9.98 9.98 9.98 9.98-4.47 9.98-9.98S17.51 2.02 12 2.02zm-.52 15.86v-4.14H8.82c-.37 0-.62-.4-.44-.73l3.68-7.17c.23-.47.94-.3.94.23v4.19h2.54c.37 0 .61.39.45.72l-3.56 7.12c-.24.48-.95.31-.95-.22z'></path></svg>
						</span>
					{/if}
					{if $_post['user_type'] == "user"}
						<span class="text-muted small">@{$_post['user_name']}</span>
					{/if}
					{if $_post['user_type'] == "page"}
						<span class="text-muted small">@{$_post['page_name']}</span>
					{/if}
				{/if}
				<!-- post author -->

				<!-- post-title -->
				<span class="post-title small">
					{if !$_shared && $_post['post_type'] == "shared"}
						{__("shared")}
						
						<span class="d-none">
							{if $_post['origin']['is_anonymous']}
								{__("Anonymous post")}
							{else}
								<span class="js_user-popover" data-type="{$_post['origin']['user_type']}" data-uid="{$_post['origin']['user_id']}">
									<a href="{$_post['origin']['post_author_url']}">
										{$_post['origin']['post_author_name']}
									</a>{__("'s")}
								</span>
								<a href="{$system['system_url']}/posts/{$_post['origin']['post_id']}">
									{if $_post['origin']['post_type'] == 'link'}
										{__("link")}

									{elseif $_post['origin']['post_type'] == 'media'}
										{if $_post['origin']['media']['media_type'] != "soundcloud"}
											{__("video")}
										{else}
											{__("song")}
										{/if}

									{elseif $_post['origin']['post_type'] == 'photos'}
										{if $_post['origin']['photos_num'] > 1}{__("photos")}{else}{__("photo")}{/if}

									{elseif $_post['origin']['post_type'] == 'album'}
										{__("album")}

									{elseif $_post['origin']['post_type'] == 'poll'}
										{__("poll")}

									{elseif $_post['origin']['post_type'] == 'reel'}
										{__("reel")}

									{elseif $_post['origin']['post_type'] == 'video'}
										{__("video")}

									{elseif $_post['origin']['post_type'] == 'audio'}
										{__("audio")}

									{elseif $_post['origin']['post_type'] == 'file'}
										{__("file")}

									{else}
										{__("post")}
									{/if}
								</a>
							{/if}
						</span>

					{elseif $_post['post_type'] == "link"}
						{__("shared a link")}

					{elseif $_post['post_type'] == "live"}
						{if $_post['live']['live_ended']}
							{__("was live")}
						{else}
							{__("is live now")}
						{/if}

					{elseif $_post['post_type'] == "photos"}
						{if $_post['photos_num'] == 1}
							{__("added a photo")}
						{else}
							{__("added")} {$_post['photos_num']} {__("photos")}
						{/if}

					{elseif $_post['post_type'] == "album"}
						{__("added")} {$_post['photos_num']} {__("photos to the album")}: <a href="{$system['system_url']}/{$_post['album']['path']}/album/{$_post['album']['album_id']}">{$_post['album']['title']}</a>

					{elseif $_post['post_type'] == "profile_picture"}
						{__("updated the profile picture")}

					{elseif $_post['post_type'] == "profile_cover"}
						{__("updated the cover photo")}

					{elseif $_post['post_type'] == "page_picture"}
						{__("updated page picture")}

					{elseif $_post['post_type'] == "page_cover"}
						{__("updated cover photo")}

					{elseif $_post['post_type'] == "group_picture"}
						{__("updated group picture")}

					{elseif $_post['post_type'] == "group_cover"}
						{__("updated group cover")}

					{elseif $_post['post_type'] == "event_cover"}
						{__("updated event cover")}

					{elseif $_post['post_type'] == "article"}
						{__("added blog")} {if $_post['blog']['category_name']}{__("in")} <a href="{$system['system_url']}/blogs/category/{$_post['blog']['category_id']}/{$_post['blog']['category_url']}">{__($_post['blog']['category_name'])}</a>{/if}

					{elseif $_post['post_type'] == "product"}
						{__("added product for sale")}

					{elseif $_post['post_type'] == "funding"}
						{__("raised funding request")}

					{elseif $_post['post_type'] == "offer"}
						{__("added offer")}

					{elseif $_post['post_type'] == "job"}
						{__("added job")}

					{elseif $_post['post_type'] == "course"}
						{__("added course")}

					{elseif $_post['post_type'] == "poll"}
						{__("added poll")}

					{elseif $_post['post_type'] == "reel"}
						{__("added reel")}

					{elseif $_post['post_type'] == "video"}
						{__("added video")} {if $_post['video']['category_name']}{__("in")} {__($_post['video']['category_name'])}{/if}

					{elseif $_post['post_type'] == "audio"}
						{__("added audio")}

					{elseif $_post['post_type'] == "file"}
						{__("added file")}
						
					{elseif $_post['post_type'] == "merit"}
						{__("sent merit")} {if $_post['merit']['category_name']}"{__($_post['merit']['category_name'])}"{/if}
						
					{elseif $_post['post_type'] == "group"}
						{__("created group")}

					  {elseif $_post['post_type'] == "event"}
						{__("created event")}
		
					{/if}

					{if $_get != 'posts_group' && $_post['in_group']}
						<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M9.00005 6L15 12L9 18" stroke="currentColor" stroke-width="2.5" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
						<a href="{$system['system_url']}/groups/{$_post['group_name']}">{$_post['group_title']}</a>
					{elseif $_get != 'posts_event' && $_post['in_event']}
						<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M9.00005 6L15 12L9 18" stroke="currentColor" stroke-width="2.5" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
						<a href="{$system['system_url']}/events/{$_post['event_id']}">{$_post['event_title']}</a>
					{elseif $_post['in_wall']}
						<svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M9.00005 6L15 12L9 18" stroke="currentColor" stroke-width="2.5" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
						<span class="js_user-popover" data-type="user" data-uid="{$_post['wall_id']}">
							<a href="{$system['system_url']}/{$_post['wall_username']}">{$_post['wall_fullname']}</a>
						</span>
					{/if}
				</span>
				<!-- post-title -->

				<!-- post feeling -->
				{if $_post['feeling_action']}
					<span class="post-title small">
						{if $_post['post_type'] != "" && $_post['post_type'] != "map"  && $_post['post_type'] != "media"} & {/if}{__("is")} {__($_post["feeling_action"])} {__($_post["feeling_value"])} <i class="twa twa-md twa-{$_post['feeling_icon']}"></i>
					</span>
				{/if}
				<!-- post feeling -->

				<!-- post time & location & privacy -->
				<div class="post-time text-muted">
					<a href="{$system['system_url']}/posts/{$_post['post_id']}" class="js_moment text-muted" data-time="{$_post['time']}">{$_post['time']}</a>
					{if $_post['location']}
						<span class="fw-bold mx-1">·</span> <span>{$_post['location']}</span>
					{/if}
					{if $system['post_translation_enabled']}
						<span class="fw-bold mx-1">·</span> <span class="text-link js_translator">{__("Translate")}</span>
					{/if}
					{if $system['newsfeed_source'] == "default"}
						<span class="fw-bold mx-1">·</span>
						{if !$_post['is_anonymous'] && !$_shared && $_post['manage_post'] && $_post['user_type'] == 'user' && !$_post['in_group'] && !$_post['in_event'] && $_post['post_type'] != "article" && $_post['post_type'] != "product" && $_post['post_type'] != "funding"}
							<!-- privacy -->
							{if $_post['privacy'] == "me"}
								<div class="btn-group" data-bs-toggle="tooltip" data-value="me" title='{__("Shared with: Only Me")}'>
									<button type="button" class="btn p-0 dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
										<i class="btn-group-icon fa fa-user-lock flex-0 text-muted privacy-icon"></i>
									</button>
									<div class="dropdown-menu">
										<div class="dropdown-item pointer js_edit-privacy" data-title='{__("Shared with: Public")}' data-value="public">
											<i class="fa fa-globe-americas flex-0"></i> {__("Public")}
										</div>
										<div class="dropdown-item pointer js_edit-privacy" data-title='{if $system['friends_enabled']}{__("Shared with: Friends")}{else}{__("Shared with: Followers")}{/if}' data-value="friends">
											<i class="fa fa-user-friends flex-0"></i> {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
										</div>
										<div class="dropdown-item pointer js_edit-privacy" data-title='{__("Shared with: Only Me")}' data-value="me">
											<i class="fa fa-user-lock flex-0"></i> {__("Only Me")}
										</div>
									</div>
								</div>
							{elseif $_post['privacy'] == "friends"}
								<div class="btn-group" data-bs-toggle="tooltip" data-value="friends" title='{if $system['friends_enabled']}{__("Shared with: Friends")}{else}{__("Shared with: Followers")}{/if}'>
									<button type="button" class="btn p-0 dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
										<i class="btn-group-icon fa fa-user-friends flex-0 text-muted privacy-icon"></i>
									</button>
									<div class="dropdown-menu">
										<div class="dropdown-item pointer js_edit-privacy" data-title='{__("Shared with: Public")}' data-value="public">
											<i class="fa fa-globe-americas flex-0"></i> {__("Public")}
										</div>
										<div class="dropdown-item pointer js_edit-privacy" data-title='{if $system['friends_enabled']}{__("Shared with: Friends")}{else}{__("Shared with: Followers")}{/if}' data-value="friends">
											<i class="fa fa-user-friends flex-0"></i> {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
										</div>
										<div class="dropdown-item pointer js_edit-privacy" data-title='{__("Shared with: Only Me")}' data-value="me">
											<i class="fa fa-user-lock flex-0"></i> {__("Only Me")}
										</div>
									</div>
								</div>
							{elseif $_post['privacy'] == "public"}
								<div class="btn-group" data-bs-toggle="tooltip" data-value="public" title='{__("Shared with: Public")}'>
									<button type="button" class="btn p-0 dropdown-toggle" data-bs-toggle="dropdown" data-display="static">
										<i class="btn-group-icon fa fa-globe-americas flex-0 text-muted privacy-icon"></i>
									</button>
									<div class="dropdown-menu">
										<div class="dropdown-item pointer js_edit-privacy" data-title='{__("Shared with: Public")}' data-value="public">
											<i class="fa fa-globe-americas flex-0"></i> {__("Public")}
										</div>
										<div class="dropdown-item pointer js_edit-privacy" data-title='{if $system['friends_enabled']}{__("Shared with: Friends")}{else}{__("Shared with: Followers")}{/if}' data-value="friends">
											<i class="fa fa-user-friends flex-0"></i> {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
										</div>
										<div class="dropdown-item pointer js_edit-privacy" data-title='{__("Shared with: Only Me")}' data-value="me">
											<i class="fa fa-user-lock flex-0"></i> {__("Only Me")}
										</div>
									</div>
								</div>
							{/if}
							<!-- privacy -->
						{else}
							{if $_post['privacy'] == "me"}
								<i class="fa fa-user-lock flex-0 privacy-icon" data-bs-toggle="tooltip" title='{__("Shared with")} {__("Only Me")}'></i>
							{elseif $_post['privacy'] == "friends"}
								<i class="fa fa-user-friends flex-0 privacy-icon" data-bs-toggle="tooltip" title='{__("Shared with")} {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}'></i>
							{elseif $_post['privacy'] == "public"}
								<i class="fa fa-globe-americas flex-0 privacy-icon" data-bs-toggle="tooltip" title='{__("Shared with")} {__("Public")}'></i>
							{elseif $_post['privacy'] == "custom"}
								<i class="fa fa-cog privacy-icon" data-bs-toggle="tooltip" title='{__("Shared with")} {__("Custom People")}'></i>
							{/if}
						{/if}
					{/if}

					{if $system['posts_reviews_enabled'] && $post['post_type'] != "product"}
						{if $_post['post_rate']}
							<span class="fw-bold mx-1">·</span>
							<span class="review-stars small">
								<i class="fa fa-star {if $_post['post_rate'] >= 1}checked{/if}"></i>
								<i class="fa fa-star {if $_post['post_rate'] >= 2}checked{/if}"></i>
								<i class="fa fa-star {if $_post['post_rate'] >= 3}checked{/if}"></i>
								<i class="fa fa-star {if $_post['post_rate'] >= 4}checked{/if}"></i>
								<i class="fa fa-star {if $_post['post_rate'] >= 5}checked{/if}"></i>
							</span>
							<span class="fw-medium small">{$_post['post_rate']|number_format:1}</span>
						{/if}
					{/if}
				</div>
				<!-- post time & location & privacy -->
			</div>
			<!-- post meta -->
		</div>
	</div>
	
	<!-- post menu -->
    {if $user->_logged_in && !$_shared && $_get != "posts_information"}
		<div class="flex-0 dropdown">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" color="currentColor" fill="none" data-bs-toggle="dropdown" data-display="static" class="pointer position-relative"><path d="M11.9959 12H12.0049" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M17.9998 12H18.0088" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.99981 12H6.00879" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"></path></svg>
			<div class="dropdown-menu dropdown-menu-end action-dropdown-menu">
				{if $_post['manage_post'] && $_post['post_type'] == "product"}
					{if $_post['product']['available']}
						<div class="dropdown-item pointer action js_sold-post">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M12 22C11.1818 22 10.4002 21.6698 8.83693 21.0095C4.94564 19.3657 3 18.5438 3 17.1613C3 16.7742 3 10.0645 3 7M12 22C12.8182 22 13.5998 21.6698 15.1631 21.0095C19.0544 19.3657 21 18.5438 21 17.1613V7M12 22L12 11.3548" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M8.32592 9.69138L5.40472 8.27785C3.80157 7.5021 3 7.11423 3 6.5C3 5.88577 3.80157 5.4979 5.40472 4.72215L8.32592 3.30862C10.1288 2.43621 11.0303 2 12 2C12.9697 2 13.8712 2.4362 15.6741 3.30862L18.5953 4.72215C20.1984 5.4979 21 5.88577 21 6.5C21 7.11423 20.1984 7.5021 18.5953 8.27785L15.6741 9.69138C13.8712 10.5638 12.9697 11 12 11C11.0303 11 10.1288 10.5638 8.32592 9.69138Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M6 12L8 13" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M17 4L7 9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
							<span>{__("Mark as Sold")}</span>
						</div>
					{else}
						<div class="dropdown-item pointer action js_unsold-post">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M12 22C11.1818 22 10.4002 21.6698 8.83693 21.0095C4.94564 19.3657 3 18.5438 3 17.1613C3 16.7742 3 10.0645 3 7M12 22C12.8182 22 13.5998 21.6698 15.1631 21.0095C19.0544 19.3657 21 18.5438 21 17.1613V7M12 22L12 11.3548" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M8.32592 9.69138L5.40472 8.27785C3.80157 7.5021 3 7.11423 3 6.5C3 5.88577 3.80157 5.4979 5.40472 4.72215L8.32592 3.30862C10.1288 2.43621 11.0303 2 12 2C12.9697 2 13.8712 2.4362 15.6741 3.30862L18.5953 4.72215C20.1984 5.4979 21 5.88577 21 6.5C21 7.11423 20.1984 7.5021 18.5953 8.27785L15.6741 9.69138C13.8712 10.5638 12.9697 11 12 11C11.0303 11 10.1288 10.5638 8.32592 9.69138Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M6 12L8 13" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M17 4L7 9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
							<span>{__("Mark as Available")}</span>
						</div>
					{/if}
					<div class="dropdown-divider"></div>
				{/if}
				{if $_post['manage_post'] && $_post['post_type'] == "job"}
					{if $_post['job']['available']}
						<div class="dropdown-item pointer action js_closed-post">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3 11L3.15288 14.2269C3.31714 17.6686 3.39927 19.3894 4.55885 20.4447C5.71843 21.5 7.52716 21.5 11.1446 21.5H12.8554C16.4728 21.5 18.2816 21.5 19.4412 20.4447C20.6007 19.3894 20.6829 17.6686 20.8471 14.2269L21 11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M2.84718 10.4431C4.54648 13.6744 8.3792 15 12 15C15.6208 15 19.4535 13.6744 21.1528 10.4431C21.964 8.90056 21.3498 6 19.352 6H4.648C2.65023 6 2.03603 8.90056 2.84718 10.4431Z" stroke="currentColor" stroke-width="1.75"></path><path d="M11.9999 11H12.0089" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M15.9999 6L15.9116 5.69094C15.4716 4.15089 15.2516 3.38087 14.7278 2.94043C14.204 2.5 13.5083 2.5 12.1168 2.5H11.8829C10.4915 2.5 9.79575 2.5 9.27198 2.94043C8.7482 3.38087 8.52819 4.15089 8.08818 5.69094L7.99988 6" stroke="currentColor" stroke-width="1.75"></path></svg>
							<span>{__("Mark as Closed")}</span>
						</div>
					{else}
						<div class="dropdown-item pointer action js_unclosed-post">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3 11L3.15288 14.2269C3.31714 17.6686 3.39927 19.3894 4.55885 20.4447C5.71843 21.5 7.52716 21.5 11.1446 21.5H12.8554C16.4728 21.5 18.2816 21.5 19.4412 20.4447C20.6007 19.3894 20.6829 17.6686 20.8471 14.2269L21 11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M2.84718 10.4431C4.54648 13.6744 8.3792 15 12 15C15.6208 15 19.4535 13.6744 21.1528 10.4431C21.964 8.90056 21.3498 6 19.352 6H4.648C2.65023 6 2.03603 8.90056 2.84718 10.4431Z" stroke="currentColor" stroke-width="1.75"></path><path d="M11.9999 11H12.0089" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M15.9999 6L15.9116 5.69094C15.4716 4.15089 15.2516 3.38087 14.7278 2.94043C14.204 2.5 13.5083 2.5 12.1168 2.5H11.8829C10.4915 2.5 9.79575 2.5 9.27198 2.94043C8.7482 3.38087 8.52819 4.15089 8.08818 5.69094L7.99988 6" stroke="currentColor" stroke-width="1.75"></path></svg>
							<span>{__("Mark as Available")}</span>
						</div>
					{/if}
					<div class="dropdown-divider"></div>
				{/if}
				{if $_post['manage_post'] && $_post['post_type'] == "course"}
					{if $_post['course']['available']}
						<div class="dropdown-item pointer action js_closed-post">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7.50586 4.94531H16.0059C16.8343 4.94531 17.5059 5.61688 17.5059 6.44531V7.94531" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M15.0059 17.9453L14.1488 15.9453M14.1488 15.9453L12.5983 12.3277C12.4992 12.0962 12.2653 11.9453 12.0059 11.9453C11.7465 11.9453 11.5126 12.0962 11.4135 12.3277L9.863 15.9453M14.1488 15.9453H9.863M9.00586 17.9453L9.863 15.9453" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M18.497 2L6.30767 2.00002C5.81071 2.00002 5.30241 2.07294 4.9007 2.36782C3.62698 3.30279 2.64539 5.38801 4.62764 7.2706C5.18421 7.7992 5.96217 7.99082 6.72692 7.99082H18.2835C19.077 7.99082 20.5 8.10439 20.5 10.5273V17.9812C20.5 20.2007 18.7103 22 16.5026 22H7.47246C5.26886 22 3.66619 20.4426 3.53959 18.0713L3.5061 5.16638" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
							<span>{__("Mark as Closed")}</span>
						</div>
					{else}
						<div class="dropdown-item pointer action js_unclosed-post">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7.50586 4.94531H16.0059C16.8343 4.94531 17.5059 5.61688 17.5059 6.44531V7.94531" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M15.0059 17.9453L14.1488 15.9453M14.1488 15.9453L12.5983 12.3277C12.4992 12.0962 12.2653 11.9453 12.0059 11.9453C11.7465 11.9453 11.5126 12.0962 11.4135 12.3277L9.863 15.9453M14.1488 15.9453H9.863M9.00586 17.9453L9.863 15.9453" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M18.497 2L6.30767 2.00002C5.81071 2.00002 5.30241 2.07294 4.9007 2.36782C3.62698 3.30279 2.64539 5.38801 4.62764 7.2706C5.18421 7.7992 5.96217 7.99082 6.72692 7.99082H18.2835C19.077 7.99082 20.5 8.10439 20.5 10.5273V17.9812C20.5 20.2007 18.7103 22 16.5026 22H7.47246C5.26886 22 3.66619 20.4426 3.53959 18.0713L3.5061 5.16638" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
							<span>{__("Mark as Available")}</span>
						</div>
					{/if}
					<div class="dropdown-divider"></div>
				{/if}
				{if $_post['i_save']}
					<div href="#" class="dropdown-item pointer action js_unsave-post">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M4 17.9808V9.70753C4 6.07416 4 4.25748 5.17157 3.12874C6.34315 2 8.22876 2 12 2C15.7712 2 17.6569 2 18.8284 3.12874C20 4.25748 20 6.07416 20 9.70753V17.9808C20 20.2867 20 21.4396 19.2272 21.8523C17.7305 22.6514 14.9232 19.9852 13.59 19.1824C12.8168 18.7168 12.4302 18.484 12 18.484C11.5698 18.484 11.1832 18.7168 10.41 19.1824C9.0768 19.9852 6.26947 22.6514 4.77285 21.8523C4 21.4396 4 20.2867 4 17.9808Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M4 7H20" stroke="currentColor" stroke-width="1.75"></path></svg>
						<span>{__("Unsave Post")}</span>
					</div>
				{else}
					<div class="dropdown-item pointer action js_save-post">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M4 17.9808V9.70753C4 6.07416 4 4.25748 5.17157 3.12874C6.34315 2 8.22876 2 12 2C15.7712 2 17.6569 2 18.8284 3.12874C20 4.25748 20 6.07416 20 9.70753V17.9808C20 20.2867 20 21.4396 19.2272 21.8523C17.7305 22.6514 14.9232 19.9852 13.59 19.1824C12.8168 18.7168 12.4302 18.484 12 18.484C11.5698 18.484 11.1832 18.7168 10.41 19.1824C9.0768 19.9852 6.26947 22.6514 4.77285 21.8523C4 21.4396 4 20.2867 4 17.9808Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M4 7H20" stroke="currentColor" stroke-width="1.75"></path></svg>
						<span>{__("Save Post")}</span>
					</div>
				{/if}
				<div class="dropdown-divider"></div>
				{if $_post['manage_post']}
					<!-- Boost -->
					{if !$_post['still_scheduled']}
						{if $system['packages_enabled'] && !$_post['in_group'] && !$_post['in_event']}
							{if $_post['boosted']}
								<div class="dropdown-item pointer action js_unboost-post">
									<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M5.22576 11.3294L12.224 2.34651C12.7713 1.64397 13.7972 2.08124 13.7972 3.01707V9.96994C13.7972 10.5305 14.1995 10.985 14.6958 10.985H18.0996C18.8729 10.985 19.2851 12.0149 18.7742 12.6706L11.776 21.6535C11.2287 22.356 10.2028 21.9188 10.2028 20.9829V14.0301C10.2028 13.4695 9.80048 13.015 9.3042 13.015H5.90035C5.12711 13.015 4.71494 11.9851 5.22576 11.3294Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
									<span>{__("Unboost Post")}</span>
								</div>
							{else}
								{if $user->_data['can_boost_posts']}
									<div class="dropdown-item pointer action js_boost-post">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M5.22576 11.3294L12.224 2.34651C12.7713 1.64397 13.7972 2.08124 13.7972 3.01707V9.96994C13.7972 10.5305 14.1995 10.985 14.6958 10.985H18.0996C18.8729 10.985 19.2851 12.0149 18.7742 12.6706L11.776 21.6535C11.2287 22.356 10.2028 21.9188 10.2028 20.9829V14.0301C10.2028 13.4695 9.80048 13.015 9.3042 13.015H5.90035C5.12711 13.015 4.71494 11.9851 5.22576 11.3294Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										<span>{__("Boost Post")}</span>
									</div>
								{else}
									<a href="{$system['system_url']}/packages" class="dropdown-item action">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M5.22576 11.3294L12.224 2.34651C12.7713 1.64397 13.7972 2.08124 13.7972 3.01707V9.96994C13.7972 10.5305 14.1995 10.985 14.6958 10.985H18.0996C18.8729 10.985 19.2851 12.0149 18.7742 12.6706L11.776 21.6535C11.2287 22.356 10.2028 21.9188 10.2028 20.9829V14.0301C10.2028 13.4695 9.80048 13.015 9.3042 13.015H5.90035C5.12711 13.015 4.71494 11.9851 5.22576 11.3294Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										<span>{__("Boost Post")}</span>
									</a>
								{/if}
							{/if}
						{/if}
					{/if}
					<!-- Boost -->
					<!-- Pin -->
					{if !$_post['still_scheduled']}
						{if !$_post['is_anonymous']}
							{if (!$_post['in_group'] && !$_post['in_event']) || ($_post['in_group'] && $_post['is_group_admin']) || ($_post['in_event'] && $_post['is_event_admin'])}
								{if $_post['pinned']}
									<div class="dropdown-item pointer action js_unpin-post">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M12 16V21" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M8 5.2918C8 5.02079 8 4.88529 8.01312 4.77132C8.1194 3.84789 8.84789 3.1194 9.77133 3.01312C9.88529 3 10.0208 3 10.2918 3H13.7082C13.9792 3 14.1147 3 14.2287 3.01312C15.1521 3.1194 15.8806 3.84789 15.9869 4.77132C16 4.88529 16 5.02079 16 5.2918C16 5.37885 16 5.42237 15.9967 5.46264C15.9708 5.78281 15.7927 6.07104 15.5179 6.2374C15.4834 6.25832 15.4444 6.27779 15.3666 6.31672L15.1055 6.44726C14.7021 6.64897 14.5003 6.74983 14.3681 6.90564C14.26 7.03286 14.1856 7.18509 14.1515 7.34846C14.1097 7.54854 14.1539 7.76968 14.2424 8.21197L15 12H15.3333C15.9533 12 16.2633 12 16.5176 12.0681C17.2078 12.2531 17.7469 12.7922 17.9319 13.4824C18 13.7367 18 14.0467 18 14.6667C18 14.9767 18 15.1317 17.9659 15.2588C17.8735 15.6039 17.6039 15.8735 17.2588 15.9659C17.1317 16 16.9767 16 16.6667 16H7.33333C7.02334 16 6.86835 16 6.74118 15.9659C6.39609 15.8735 6.12654 15.6039 6.03407 15.2588C6 15.1317 6 14.9767 6 14.6667C6 14.0467 6 13.7367 6.06815 13.4824C6.25308 12.7922 6.79218 12.2531 7.48236 12.0681C7.73669 12 8.04669 12 8.66667 12H9L9.75761 8.21197C9.84606 7.76968 9.89029 7.54854 9.84852 7.34846C9.81441 7.18509 9.73995 7.03286 9.63194 6.90564C9.49965 6.74983 9.29794 6.64897 8.89452 6.44726L8.63344 6.31672C8.55558 6.27779 8.51665 6.25832 8.48208 6.2374C8.20731 6.07104 8.02917 5.78281 8.00326 5.46264C8 5.42237 8 5.37885 8 5.2918Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										<span>{__("Unpin Post")}</span>
									</div>
								{else}
									<div class="dropdown-item pointer action js_pin-post">
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M12 16V21" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M8 5.2918C8 5.02079 8 4.88529 8.01312 4.77132C8.1194 3.84789 8.84789 3.1194 9.77133 3.01312C9.88529 3 10.0208 3 10.2918 3H13.7082C13.9792 3 14.1147 3 14.2287 3.01312C15.1521 3.1194 15.8806 3.84789 15.9869 4.77132C16 4.88529 16 5.02079 16 5.2918C16 5.37885 16 5.42237 15.9967 5.46264C15.9708 5.78281 15.7927 6.07104 15.5179 6.2374C15.4834 6.25832 15.4444 6.27779 15.3666 6.31672L15.1055 6.44726C14.7021 6.64897 14.5003 6.74983 14.3681 6.90564C14.26 7.03286 14.1856 7.18509 14.1515 7.34846C14.1097 7.54854 14.1539 7.76968 14.2424 8.21197L15 12H15.3333C15.9533 12 16.2633 12 16.5176 12.0681C17.2078 12.2531 17.7469 12.7922 17.9319 13.4824C18 13.7367 18 14.0467 18 14.6667C18 14.9767 18 15.1317 17.9659 15.2588C17.8735 15.6039 17.6039 15.8735 17.2588 15.9659C17.1317 16 16.9767 16 16.6667 16H7.33333C7.02334 16 6.86835 16 6.74118 15.9659C6.39609 15.8735 6.12654 15.6039 6.03407 15.2588C6 15.1317 6 14.9767 6 14.6667C6 14.0467 6 13.7367 6.06815 13.4824C6.25308 12.7922 6.79218 12.2531 7.48236 12.0681C7.73669 12 8.04669 12 8.66667 12H9L9.75761 8.21197C9.84606 7.76968 9.89029 7.54854 9.84852 7.34846C9.81441 7.18509 9.73995 7.03286 9.63194 6.90564C9.49965 6.74983 9.29794 6.64897 8.89452 6.44726L8.63344 6.31672C8.55558 6.27779 8.51665 6.25832 8.48208 6.2374C8.20731 6.07104 8.02917 5.78281 8.00326 5.46264C8 5.42237 8 5.37885 8 5.2918Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
										<span>{__("Pin Post")}</span>
									</div>
								{/if}
							{/if}
						{/if}
					{/if}
					<!-- Pin -->
					<!-- Edit -->
					{if $_post['post_type'] == "article"}
						<a href="{$system['system_url']}/blogs/edit/{$_post['post_id']}" class="dropdown-item pointer action">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
							<span>{__("Edit Blog")}</span>
						</a>
					{elseif $_post['post_type'] == "product"}
						<div class="dropdown-item pointer action" data-toggle="modal" data-url="posts/product.php?do=edit&post_id={$_post['post_id']}">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
							<span>{__("Edit Product")}</span>
						</div>
					{elseif $_post['post_type'] == "funding"}
						<div class="dropdown-item pointer action" data-toggle="modal" data-url="posts/funding.php?do=edit&post_id={$_post['post_id']}">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
							<span>{__("Edit Funding")}</span>
						</div>
					{elseif $_post['post_type'] == "offer"}
						<div class="dropdown-item pointer action" data-toggle="modal" data-url="posts/offer.php?do=edit&post_id={$_post['post_id']}">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
							<span>{__("Edit Offer")}</span>
						</div>
					{elseif $_post['post_type'] == "job"}
						<div class="dropdown-item pointer action" data-toggle="modal" data-url="posts/job.php?do=edit&post_id={$_post['post_id']}">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
							<span>{__("Edit Job")}</span>
						</div>
					{elseif $_post['post_type'] == "course"}
						<div class="dropdown-item pointer action" data-toggle="modal" data-url="posts/course.php?do=edit&post_id={$_post['post_id']}">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
							<span>{__("Edit Course")}</span>
						</div>
					{else}
						<div class="dropdown-item pointer action js_edit-post">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
							<span>{__("Edit Post")}</span>
						</div>
					{/if}
					<!-- Edit -->
					<!-- Monetization -->
					{if $_post['can_be_for_subscriptions']}
						{if $_post['for_subscriptions']}
							<div class="dropdown-item pointer action js_unmonetize-post">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M12.5 22H6.59087C5.04549 22 3.81631 21.248 2.71266 20.1966C0.453365 18.0441 4.1628 16.324 5.57757 15.4816C7.827 14.1422 10.4865 13.7109 13 14.1878" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M15.5 6.5C15.5 8.98528 13.4853 11 11 11C8.51472 11 6.5 8.98528 6.5 6.5C6.5 4.01472 8.51472 2 11 2C13.4853 2 15.5 4.01472 15.5 6.5Z" stroke="currentColor" stroke-width="1.75" /><path d="M18.6911 14.5777L19.395 15.9972C19.491 16.1947 19.7469 16.3843 19.9629 16.4206L21.2388 16.6343C22.0547 16.7714 22.2467 17.3682 21.6587 17.957L20.6668 18.9571C20.4989 19.1265 20.4069 19.4531 20.4589 19.687L20.7428 20.925C20.9668 21.9049 20.4509 22.284 19.591 21.7718L18.3951 21.0581C18.1791 20.929 17.8232 20.929 17.6032 21.0581L16.4073 21.7718C15.5514 22.284 15.0315 21.9009 15.2554 20.925L15.5394 19.687C15.5914 19.4531 15.4994 19.1265 15.3314 18.9571L14.3395 17.957C13.7556 17.3682 13.9436 16.7714 14.7595 16.6343L16.0353 16.4206C16.2473 16.3843 16.5033 16.1947 16.5993 15.9972L17.3032 14.5777C17.6872 13.8074 18.3111 13.8074 18.6911 14.5777Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
								<span>{__("For Everyone")}</span>
							</div>
						{else}
							<div class="dropdown-item pointer action js_monetize-post">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M12.5 22H6.59087C5.04549 22 3.81631 21.248 2.71266 20.1966C0.453365 18.0441 4.1628 16.324 5.57757 15.4816C7.827 14.1422 10.4865 13.7109 13 14.1878" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M15.5 6.5C15.5 8.98528 13.4853 11 11 11C8.51472 11 6.5 8.98528 6.5 6.5C6.5 4.01472 8.51472 2 11 2C13.4853 2 15.5 4.01472 15.5 6.5Z" stroke="currentColor" stroke-width="1.75" /><path d="M18.6911 14.5777L19.395 15.9972C19.491 16.1947 19.7469 16.3843 19.9629 16.4206L21.2388 16.6343C22.0547 16.7714 22.2467 17.3682 21.6587 17.957L20.6668 18.9571C20.4989 19.1265 20.4069 19.4531 20.4589 19.687L20.7428 20.925C20.9668 21.9049 20.4509 22.284 19.591 21.7718L18.3951 21.0581C18.1791 20.929 17.8232 20.929 17.6032 21.0581L16.4073 21.7718C15.5514 22.284 15.0315 21.9009 15.2554 20.925L15.5394 19.687C15.5914 19.4531 15.4994 19.1265 15.3314 18.9571L14.3395 17.957C13.7556 17.3682 13.9436 16.7714 14.7595 16.6343L16.0353 16.4206C16.2473 16.3843 16.5033 16.1947 16.5993 15.9972L17.3032 14.5777C17.6872 13.8074 18.3111 13.8074 18.6911 14.5777Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
								<span>{__("For Subscribers Only")}</span>
							</div>
						{/if}
					{/if}
					<!-- Monetization -->
					<!-- Delete -->
					<div class="dropdown-item pointer action js_delete-post">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.5 5.5L18.8803 15.5251C18.7219 18.0864 18.6428 19.3671 18.0008 20.2879C17.6833 20.7431 17.2747 21.1273 16.8007 21.416C15.8421 22 14.559 22 11.9927 22C9.42312 22 8.1383 22 7.17905 21.4149C6.7048 21.1257 6.296 20.7408 5.97868 20.2848C5.33688 19.3626 5.25945 18.0801 5.10461 15.5152L4.5 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M3 5.5H21M16.0557 5.5L15.3731 4.09173C14.9196 3.15626 14.6928 2.68852 14.3017 2.39681C14.215 2.3321 14.1231 2.27454 14.027 2.2247C13.5939 2 13.0741 2 12.0345 2C10.9688 2 10.436 2 9.99568 2.23412C9.8981 2.28601 9.80498 2.3459 9.71729 2.41317C9.32164 2.7167 9.10063 3.20155 8.65861 4.17126L8.05292 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M9.5 16.5L9.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M14.5 16.5L14.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
						<span>{__("Delete Post")}</span>
					</div>
					<!-- Delete -->
					<!-- Hide -->
					{if $_post['user_type'] == "user" && !$_post['in_group'] && !$_post['in_event'] && !$_post['is_anonymous']}
						{if $_post['is_hidden']}
							<div class="dropdown-item pointer action js_allow-post">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.439 15.439C20.3636 14.5212 21.0775 13.6091 21.544 12.955C21.848 12.5287 22 12.3155 22 12C22 11.6845 21.848 11.4713 21.544 11.045C20.1779 9.12944 16.6892 5 12 5C11.0922 5 10.2294 5.15476 9.41827 5.41827M6.74742 6.74742C4.73118 8.1072 3.24215 9.94266 2.45604 11.045C2.15201 11.4713 2 11.6845 2 12C2 12.3155 2.15201 12.5287 2.45604 12.955C3.8221 14.8706 7.31078 19 12 19C13.9908 19 15.7651 18.2557 17.2526 17.2526" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M9.85786 10C9.32783 10.53 9 11.2623 9 12.0711C9 13.6887 10.3113 15 11.9289 15C12.7377 15 13.47 14.6722 14 14.1421" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M3 3L21 21" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
								<span>{__("Allow on Timeline")}</span>
							</div>
						{else}
							<div class="dropdown-item pointer action js_disallow-post">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.439 15.439C20.3636 14.5212 21.0775 13.6091 21.544 12.955C21.848 12.5287 22 12.3155 22 12C22 11.6845 21.848 11.4713 21.544 11.045C20.1779 9.12944 16.6892 5 12 5C11.0922 5 10.2294 5.15476 9.41827 5.41827M6.74742 6.74742C4.73118 8.1072 3.24215 9.94266 2.45604 11.045C2.15201 11.4713 2 11.6845 2 12C2 12.3155 2.15201 12.5287 2.45604 12.955C3.8221 14.8706 7.31078 19 12 19C13.9908 19 15.7651 18.2557 17.2526 17.2526" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M9.85786 10C9.32783 10.53 9 11.2623 9 12.0711C9 13.6887 10.3113 15 11.9289 15C12.7377 15 13.47 14.6722 14 14.1421" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M3 3L21 21" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
								<span>{__("Hide from Timeline")}</span>
							</div>
						{/if}
					{/if}
					<!-- Hide -->
					<!-- Disable Comments -->
					{if $_post['comments_disabled']}
						<div class="dropdown-item pointer action js_enable-post-comments">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M18 19.6543C16.8738 20.3575 15.5698 20.7975 14.1706 20.8905C12.7435 20.9854 11.2536 20.9852 9.8294 20.8905C9.33896 20.8579 8.8044 20.7409 8.34401 20.5513C7.83177 20.3403 7.5756 20.2348 7.44544 20.2508C7.31527 20.2668 7.1264 20.4061 6.74868 20.6846C6.08268 21.1757 5.24367 21.5285 3.99943 21.4982C3.37026 21.4829 3.05568 21.4752 2.91484 21.2351C2.77401 20.995 2.94941 20.6626 3.30021 19.9978C3.78674 19.0758 4.09501 18.0203 3.62791 17.1746C2.82343 15.9666 2.1401 14.536 2.04024 12.9909C1.98659 12.1607 1.98659 11.3009 2.04024 10.4707C2.16123 8.5986 2.8777 6.84362 4 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M6.5 3.51873C7.5057 2.98397 8.63273 2.65062 9.8294 2.57107C11.2536 2.47641 12.7435 2.47621 14.1706 2.57107C18.3536 2.84913 21.6856 6.22838 21.9598 10.4707C22.0134 11.3009 22.0134 12.1607 21.9598 12.9909C21.8508 14.6771 21.2587 16.227 20.3221 17.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M2 3L22 23" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
							<span>{__("Turn on Commenting")}</span>
						</div>
					{else}
						<div class="dropdown-item pointer action js_disable-post-comments">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M18 19.6543C16.8738 20.3575 15.5698 20.7975 14.1706 20.8905C12.7435 20.9854 11.2536 20.9852 9.8294 20.8905C9.33896 20.8579 8.8044 20.7409 8.34401 20.5513C7.83177 20.3403 7.5756 20.2348 7.44544 20.2508C7.31527 20.2668 7.1264 20.4061 6.74868 20.6846C6.08268 21.1757 5.24367 21.5285 3.99943 21.4982C3.37026 21.4829 3.05568 21.4752 2.91484 21.2351C2.77401 20.995 2.94941 20.6626 3.30021 19.9978C3.78674 19.0758 4.09501 18.0203 3.62791 17.1746C2.82343 15.9666 2.1401 14.536 2.04024 12.9909C1.98659 12.1607 1.98659 11.3009 2.04024 10.4707C2.16123 8.5986 2.8777 6.84362 4 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M6.5 3.51873C7.5057 2.98397 8.63273 2.65062 9.8294 2.57107C11.2536 2.47641 12.7435 2.47621 14.1706 2.57107C18.3536 2.84913 21.6856 6.22838 21.9598 10.4707C22.0134 11.3009 22.0134 12.1607 21.9598 12.9909C21.8508 14.6771 21.2587 16.227 20.3221 17.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M2 3L22 23" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
							<span>{__("Turn off Commenting")}</span>
						</div>
					{/if}
					<!-- Disable Comments -->
				{else}
					{if $_post['user_type'] == "user" && !$_post['is_anonymous']}
						<div class="dropdown-item pointer align-items-start js_hide-author" data-author-id="{$_post['user_id']}" data-author-name="{$_post['post_author_name']}">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M5.18007 15.2964C3.92249 16.0335 0.625213 17.5386 2.63348 19.422C3.6145 20.342 4.7071 21 6.08077 21H13.9192C15.2929 21 16.3855 20.342 17.3665 19.422C19.3748 17.5386 16.0775 16.0335 14.8199 15.2964C11.8709 13.5679 8.12906 13.5679 5.18007 15.2964Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M14 7C14 9.20914 12.2091 11 10 11C7.79086 11 6 9.20914 6 7C6 4.79086 7.79086 3 10 3C12.2091 3 14 4.79086 14 7Z" stroke="currentColor" stroke-width="1.75" /><path d="M22 4.5L19.5 7M19.5 7L17 9.5M19.5 7L22 9.5M19.5 7L17 4.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
							<div class="action">
								{__("Unfollow")} {if $system['show_usernames_enabled']}{$_post['user_name']}{else}{$_post['user_firstname']}{/if}
								<div class="action-desc">{__("Stop seeing posts but stay friends")}</div>
							</div>
						</div>
					{/if}
					<div class="dropdown-item pointer js_hide-post align-items-start">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.439 15.439C20.3636 14.5212 21.0775 13.6091 21.544 12.955C21.848 12.5287 22 12.3155 22 12C22 11.6845 21.848 11.4713 21.544 11.045C20.1779 9.12944 16.6892 5 12 5C11.0922 5 10.2294 5.15476 9.41827 5.41827M6.74742 6.74742C4.73118 8.1072 3.24215 9.94266 2.45604 11.045C2.15201 11.4713 2 11.6845 2 12C2 12.3155 2.15201 12.5287 2.45604 12.955C3.8221 14.8706 7.31078 19 12 19C13.9908 19 15.7651 18.2557 17.2526 17.2526" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M9.85786 10C9.32783 10.53 9 11.2623 9 12.0711C9 13.6887 10.3113 15 11.9289 15C12.7377 15 13.47 14.6722 14 14.1421" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M3 3L21 21" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
						<div class="action">
							<div>{__("Hide this post")}</div>
							<div class="action-desc">{__("See fewer posts like this")}</div>
						</div>
					</div>
					<div class="dropdown-item action pointer" data-toggle="modal" data-url="data/report.php?do=create&handle=post&id={$_post['post_id']}">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M5.32171 9.6829C7.73539 5.41196 8.94222 3.27648 10.5983 2.72678C11.5093 2.42437 12.4907 2.42437 13.4017 2.72678C15.0578 3.27648 16.2646 5.41196 18.6783 9.6829C21.092 13.9538 22.2988 16.0893 21.9368 17.8293C21.7376 18.7866 21.2469 19.6548 20.535 20.3097C19.241 21.5 16.8274 21.5 12 21.5C7.17265 21.5 4.75897 21.5 3.46496 20.3097C2.75308 19.6548 2.26239 18.7866 2.06322 17.8293C1.70119 16.0893 2.90803 13.9538 5.32171 9.6829Z" stroke="currentColor" stroke-width="1.75" /><path d="M11.992 16H12.001" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M12 13L12 8.99997" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
						<span>{__("Report post")}</span>
					</div>
				{/if}
				<div class="dropdown-divider"></div>
				<a href="{$system['system_url']}/posts/{$_post['post_id']}" target="_blank" class="dropdown-item pointer action">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M11.1188 2.99805C6.55944 3.45084 2.99854 7.29857 2.99854 11.9782C2.99854 16.9624 7.03806 21.0029 12.0211 21.0029C16.6995 21.0029 20.5464 17.4412 20.9991 12.8807" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M20.5576 3.4943L11.0483 13.0595M20.5576 3.4943C20.0635 2.99954 16.7351 3.04566 16.0315 3.05567M20.5576 3.4943C21.0517 3.98905 21.0056 7.32199 20.9956 8.0266" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
					<span>{__("Open post in new tab")}</span>
				</a>
				{if $_post['is_anonymous'] && ($user->_is_admin || $user->_is_moderator)}
					<div class="dropdown-divider"></div>
					<a href="{$_post['post_author_url']}" target="_blank" class="dropdown-item pointer action">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M6.57757 15.4816C5.1628 16.324 1.45336 18.0441 3.71266 20.1966C4.81631 21.248 6.04549 22 7.59087 22H16.4091C17.9545 22 19.1837 21.248 20.2873 20.1966C22.5466 18.0441 18.8372 16.324 17.4224 15.4816C14.1048 13.5061 9.89519 13.5061 6.57757 15.4816Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M16.5 6.5C16.5 8.98528 14.4853 11 12 11C9.51472 11 7.5 8.98528 7.5 6.5C7.5 4.01472 9.51472 2 12 2C14.4853 2 16.5 4.01472 16.5 6.5Z" stroke="currentColor" stroke-width="1.75" /></svg>
						<span>{__("Open Author Profile")}</span>
					</a>
				{/if}
			</div>
		</div>
    {/if}
    <!-- post menu -->
</div>
<!-- post header -->

<div class="d-flex">
	<div class="post_empty_space flex-0"></div>
	<div class="flex-1">
		{if $_post['can_get_details'] }
			{if $_post['needs_pro_package']}
				{include file='_need_pro_package.tpl' _manage = true}
			{elseif $_post['needs_permission']}
				{include file='_need_permission.tpl'}
			{else}
				<!-- post text -->
				{if !in_array($_post['post_type'], ['product', 'funding', 'offer', 'job', 'course'])}
					{if !$_shared}
						{include file='__feeds_post.text.tpl'}
					{else}
						{if $_post['colored_pattern']}
							<div class="post-colored" {if $_post['colored_pattern']['type'] == "color"} style="background-image: linear-gradient(45deg, {$_post['colored_pattern']['background_color_1']}, {$_post['colored_pattern']['background_color_2']});" {else} style="background-image: url({$system['system_uploads']}/{$_post['colored_pattern']['background_image']})" {/if}>
								<div class="post-colored-text-wrapper js_scroller" data-slimScroll-height="240">
									<div class="post-text" dir="auto" style="color: {$_post['colored_pattern']['text_color']};">
										{$_post['text']}
									</div>
								</div>
							</div>
						{else}
							<div class="post-text js_readmore" dir="auto">{$_post['text']}</div>
						{/if}
						<div class="post-text-translation x-hidden" dir="auto"></div>
					{/if}
				{/if}
				<!-- post text -->

				{if !$_shared && $_post['post_type'] == "shared" && $_post['origin']}
					<div class="post-snippet mt-2 {if in_array($_post['origin']['post_type'], ['product', 'funding', 'job', 'course', 'poll'])}{/if}">
						{if $_snippet}
							<div class="post-snippet-toggle p-2 text-link small text-center main fw-medium js_show-attachments">{__("Show Attachments")}</div>
						{/if}
						<div {if $_snippet}class="x-hidden" {/if}>
							{include file='__feeds_post.body.tpl' _post=$_post['origin'] _shared=true}
						</div>
					</div>
				{/if}

				{if $_post['post_type'] == "link" && $_post['link']}
					<div class="mt-2">
						<div class="post-media">
							{if $_post['link']['source_thumbnail']}
								<a class="post-media-image d-block position-relative" href="{$_post['link']['source_url']}" target="_blank" rel="nofollow">
									<img src="{$_post['link']['source_thumbnail']}">
									<div class="source text-truncate text-white m-2 position-absolute">{$_post['link']['source_title']}</div>
								</a>
							{/if}
							<div class="post-media-meta w-100 pt-1">
								<a class="title d-inline-block" href="{$_post['link']['source_url']}" target="_blank" rel="nofollow">{$_post['link']['source_host']}</a>
								<div class="text overflow-hidden text-muted">{$_post['link']['source_text']}</div>
							</div>
						</div>
					</div>
				{/if}

				{if $_post['post_type'] == "media" && $_post['media']}
					<div class="mt-2">
						{if $_post['media']['source_type'] == "photo"}
							<div class="post-media">
								<div class="post-media-image position-relative" >
									<img src="{$_post['media']['source_url']}">
									<a class="source text-truncate text-white m-2 position-absolute d-block" href="{$_post['media']['source_url']}" target="_blank" rel="nofollow">{$_post['media']['source_provider']}</a>
								</div>
							</div>
						{else}
							{if $_post['media']['source_provider'] == "YouTube"}
								{$_post['media']['vidoe_id'] = get_youtube_id($_post['media']['source_html'])}
								{if $system['smart_yt_player']}
									<div class="youtube-player position-relative overflow-hidden js_youtube-player" data-id="{$_post['media']['vidoe_id']}">
										<img class="position-absolute w-100 m-auto d-block pointer" src="https://i.ytimg.com/vi/{$_post['media']['vidoe_id']}/hqdefault.jpg">
										<div class="play position-absolute pointer"><svg xmlns="http://www.w3.org/2000/svg" width="78" height="78" viewBox="0 0 24 24"><path fill="currentColor" d="M10,15L15.19,12L10,9V15M21.56,7.17C21.69,7.64 21.78,8.27 21.84,9.07C21.91,9.87 21.94,10.56 21.94,11.16L22,12C22,14.19 21.84,15.8 21.56,16.83C21.31,17.73 20.73,18.31 19.83,18.56C19.36,18.69 18.5,18.78 17.18,18.84C15.88,18.91 14.69,18.94 13.59,18.94L12,19C7.81,19 5.2,18.84 4.17,18.56C3.27,18.31 2.69,17.73 2.44,16.83C2.31,16.36 2.22,15.73 2.16,14.93C2.09,14.13 2.06,13.44 2.06,12.84L2,12C2,9.81 2.16,8.2 2.44,7.17C2.69,6.27 3.27,5.69 4.17,5.44C4.64,5.31 5.5,5.22 6.82,5.16C8.12,5.09 9.31,5.06 10.41,5.06L12,5C16.19,5 18.8,5.16 19.83,5.44C20.73,5.69 21.31,6.27 21.56,7.17Z" /></svg></div>
									</div>
								{else}
									<div class="post-media">
										{if $system['disable_yt_player']}
											<div class="plyr__video-embed js_video-plyr-youtube" data-plyr-provider="youtube" data-plyr-embed-id="{$_post['media']['vidoe_id']}"></div>
										{else}
											<div class="ratio ratio-16x9">
												{html_entity_decode($_post['media']['source_html'], ENT_QUOTES)}
											</div>
										{/if}
									</div>
								{/if}
							{elseif in_array($_post['media']['source_provider'], ["Vimeo", "Twitch", "Rumble.com", "Banned.Video", "Brighteon", "Odysee", "Gab TV"])}
								<div class="post-media">
									<div class="ratio ratio-16x9">
										{html_entity_decode($_post['media']['source_html'], ENT_QUOTES)}
									</div>
								</div>
							{elseif $_post['media']['source_provider'] == "Facebook"}
								<div class="embed-facebook-wrapper">
									{html_entity_decode($_post['media']['source_html'], ENT_QUOTES)}
									<div class="embed-facebook-placeholder ptb30">
										<div class="d-flex justify-content-center">
											<div class="spinner-grow"></div>
										</div>
									</div>
								</div>
							{else}
								<div class="embed-iframe-wrapper">
									{html_entity_decode($_post['media']['source_html'], ENT_QUOTES)}
								</div>
							{/if}
						{/if}
					</div>
				{/if}

				{if $_post['post_type'] == "live" && $_post['live']}
					{if $system['save_live_enabled'] && $_post['live']['live_ended'] && $_post['live']['live_recorded']}
						<div class="mt-2">
							<video class="js_video-plyr" id="video-{$_post['live']['live_id']}{if $pinned || $boosted}-{$_post['post_id']}{/if}" {if $_post['live']['video_thumbnail']}poster="{$system['system_uploads']}/{$_post['live']['video_thumbnail']}" {/if} playsinline controls preload="auto">
								<source src="{$system['system_agora_uploads']}/{$_post['live']['agora_file']}" type="application/x-mpegURL">
							</video>
						</div>
					{else}
						<div class="youtube-player overflow-hidden position-relative with-live js_lightbox-live mt-2">
							<img class="position-absolute w-100 m-auto d-block pointer" src="{$system['system_uploads']}/{$_post['live']['video_thumbnail']}">
							<div class="play position-absolute pointer"><svg xmlns="http://www.w3.org/2000/svg" height="68" viewBox="0 0 24 24" width="68"><path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 13.5v-7c0-.41.47-.65.8-.4l4.67 3.5c.27.2.27.6 0 .8l-4.67 3.5c-.33.25-.8.01-.8-.4z"></path></svg></div>
						</div>
					{/if}
				{/if}

				{if ($_post['post_type'] == "photos" || $_post['post_type'] == "album" || $_post['post_type'] == "profile_picture" || $_post['post_type'] == "profile_cover" || $_post['post_type'] == "page_picture" || $_post['post_type'] == "page_cover" || $_post['post_type'] == "group_picture" || $_post['post_type'] == "group_cover" || $_post['post_type'] == "event_cover" || $_post['post_type'] == "product" || $_post['post_type'] == "combo") && $_post['photos_num'] > 0}
					<div class="mt-2">
						{include file='__feeds_post.body.photos.tpl'}
					</div>
				{/if}

				{if $_post['post_type'] == "map"}
					<div class="post-map d-flex overflow-hidden mt-2">
						<iframe width="100%" height="300" frameborder="0" style="border:0;" src="https://www.google.com/maps/embed/v1/place?key={$system['geolocation_key']}&amp;q={$_post['location']}"></iframe>
					</div>
				{/if}

				{if $_post['post_type'] == "article" && $_post['blog']}
					<div class="mt-2">
						<div class="post-media">
							<a class="post-media-image d-block position-relative" href="{$system['system_url']}/blogs/{$_post['post_id']}/{$_post['blog']['title_url']}">
								<div class="ratio ratio-16x9">
									{if $_post['blog']['cover']}
										<div class="image" style="background-image:url('{$system['system_uploads']}/{$_post['blog']['cover']}');"></div>
									{else}
										<div class="image" style="background-image:url('{$system['system_url']}/content/themes/{$system['theme']}/images/blank_blog.png');"></div>
									{/if}
								</div>
								<div class="source text-truncate text-white m-2 position-absolute">{$_post['blog']['title']}</div>
							</a>
							<div class="post-media-meta w-100 pt-1 d-none">
								<a class="text overflow-hidden text-muted d-inline-block" href="{$system['system_url']}/blogs/{$_post['post_id']}/{$_post['blog']['title_url']}">{$_post['blog']['text_snippet']|truncate:400}</a>
							</div>
						</div>
					</div>
				{/if}

				{if $_post['post_type'] == "product" && $_post['product']}
					<div class="post-product-container mt-2">
						<h3 class="headline-font">{$_post['product']['name']}</h3>
						<h5 class="main {if $system['posts_reviews_enabled']}mb-0{/if}">
							{if $_post['product']['price'] > 0}
								{print_money($_post['product']['price'])}
							{else}
								{__("Free")}
							{/if}
						</h5>
						
						{if $system['posts_reviews_enabled']}
							<div class="d-inline-flex align-items-center gap-2 small mb-2 pointer" data-toggle="modal" data-url="posts/who_reviews.php?post_id={$post['post_id']}">
								<span class="review-stars small">
									<i class="fa fa-star {if $_post['post_rate'] >= 1}checked{/if}"></i>
									<i class="fa fa-star {if $_post['post_rate'] >= 2}checked{/if}"></i>
									<i class="fa fa-star {if $_post['post_rate'] >= 3}checked{/if}"></i>
									<i class="fa fa-star {if $_post['post_rate'] >= 4}checked{/if}"></i>
									<i class="fa fa-star {if $_post['post_rate'] >= 5}checked{/if}"></i>
								</span>
								<span class="">{$_post['post_rate']|number_format:1} ({$post['reviews_count']} {__("Reviews")})</span>
							</div>
						{/if}
				
						<!-- post text -->
						{if !$_shared}
							{include file='__feeds_post.text.tpl'}
						{else}
							<div class="post-text js_readmore text-muted" dir="auto">{$_post['text']}</div>
							<div class="post-text-translation x-hidden" dir="auto"></div>
						{/if}
						<!-- post text -->
						
						{if $_post['author_id'] != $user->_data['user_id'] }
							<div class="mt-3 d-flex gap-3">
								{if $system['market_shopping_cart_enabled']}
									{if $_post['product']['available'] && $_post['product']['quantity'] > 0}
										<button type="button" class="btn btn-main flex-1 js_shopping-add-to-cart" data-id="{$_post['post_id']}">
											{if $_post['product']['is_digital']}
												{__("Buy & Download")}
											{else}
												{__("Buy")}
											{/if}
										</button>
									{else}
										<button type="button" class="btn btn-main flex-1" disabled>
											{__("Currently unavailable")}
										</button>
									{/if}
								{/if}
								{if $system['chat_enabled'] && $_post['user_type'] == 'user'}
									<button type="button" class="btn btn-gray flex-0 js_chat-start" data-uid="{$_post['author_id']}" data-name="{$_post['post_author_name']}" data-link="{$_post['user_name']}" data-picture="{$_post['post_author_picture']}" title='{__("Contact Seller")}'>
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M8 13.5H16M8 8.5H12" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M6.09881 19C4.7987 18.8721 3.82475 18.4816 3.17157 17.8284C2 16.6569 2 14.7712 2 11V10.5C2 6.72876 2 4.84315 3.17157 3.67157C4.34315 2.5 6.22876 2.5 10 2.5H14C17.7712 2.5 19.6569 2.5 20.8284 3.67157C22 4.84315 22 6.72876 22 10.5V11C22 14.7712 22 16.6569 20.8284 17.8284C19.6569 19 17.7712 19 14 19C13.4395 19.0125 12.9931 19.0551 12.5546 19.155C11.3562 19.4309 10.2465 20.0441 9.14987 20.5789C7.58729 21.3408 6.806 21.7218 6.31569 21.3651C5.37769 20.6665 6.29454 18.5019 6.5 17.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
										{if !$system['market_shopping_cart_enabled']}
											{__("Contact Seller")}
										{/if}
									</button>
								{/if}
							</div>
						{/if}
				
						<div class="mt-3 d-flex align-items-center gap-2 small">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M12 22C11.1818 22 10.4002 21.6698 8.83693 21.0095C4.94564 19.3657 3 18.5438 3 17.1613C3 16.7742 3 10.0645 3 7M12 22C12.8182 22 13.5998 21.6698 15.1631 21.0095C19.0544 19.3657 21 18.5438 21 17.1613V7M12 22L12 11.3548" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M8.32592 9.69138L5.40472 8.27785C3.80157 7.5021 3 7.11423 3 6.5C3 5.88577 3.80157 5.4979 5.40472 4.72215L8.32592 3.30862C10.1288 2.43621 11.0303 2 12 2C12.9697 2 13.8712 2.4362 15.6741 3.30862L18.5953 4.72215C20.1984 5.4979 21 5.88577 21 6.5C21 7.11423 20.1984 7.5021 18.5953 8.27785L15.6741 9.69138C13.8712 10.5638 12.9697 11 12 11C11.0303 11 10.1288 10.5638 8.32592 9.69138Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M6 12L8 13" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M17 4L7 9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
							<div class="d-flex ws-nowrap">
								{if $_post['product']['available']}
									{if $_post['product']['quantity'] > 0}
										<span class="text-success text-opacity-75">{__("In stock")}</span>
									{else}
										<span class="text-danger">{__("Out of stock")}</span>
									{/if}
								{else}
									<span class="text-danger">{__("SOLD")}</span>
								{/if}
				  
								{if $_post['product']['is_digital']}
									<span class="fw-bold mx-2">·</span><span>{__("Digital")}</span>
								{/if}
								
								{if $_post['product']['status'] == "new"}
									<span class="fw-bold mx-2">·</span><span>{__("New")}</span>
								{else}
									<span class="fw-bold mx-2">·</span><span>{__("Used")}</span>
								{/if}
							</div>
						</div>
						{if $_post['product']['location']}
							<div class="mt-2 d-flex align-items-center gap-2 small">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M14.5 9C14.5 10.3807 13.3807 11.5 12 11.5C10.6193 11.5 9.5 10.3807 9.5 9C9.5 7.61929 10.6193 6.5 12 6.5C13.3807 6.5 14.5 7.61929 14.5 9Z" stroke="currentColor" stroke-width="1.75"></path><path d="M18.2222 17C19.6167 18.9885 20.2838 20.0475 19.8865 20.8999C19.8466 20.9854 19.7999 21.0679 19.7469 21.1467C19.1724 22 17.6875 22 14.7178 22H9.28223C6.31251 22 4.82765 22 4.25311 21.1467C4.20005 21.0679 4.15339 20.9854 4.11355 20.8999C3.71619 20.0475 4.38326 18.9885 5.77778 17" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M13.2574 17.4936C12.9201 17.8184 12.4693 18 12.0002 18C11.531 18 11.0802 17.8184 10.7429 17.4936C7.6543 14.5008 3.51519 11.1575 5.53371 6.30373C6.6251 3.67932 9.24494 2 12.0002 2C14.7554 2 17.3752 3.67933 18.4666 6.30373C20.4826 11.1514 16.3536 14.5111 13.2574 17.4936Z" stroke="currentColor" stroke-width="1.75"></path></svg>
								{$_post['product']['location']}
							</div>
						{/if}
						<div class="mt-2 d-flex align-items-center gap-2 small">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="#currentColor" fill="none"><circle cx="1.5" cy="1.5" r="1.5" transform="matrix(1 0 0 -1 16 8.00024)" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M2.77423 11.1439C1.77108 12.2643 1.7495 13.9546 2.67016 15.1437C4.49711 17.5033 6.49674 19.5029 8.85633 21.3298C10.0454 22.2505 11.7357 22.2289 12.8561 21.2258C15.8979 18.5022 18.6835 15.6559 21.3719 12.5279C21.6377 12.2187 21.8039 11.8397 21.8412 11.4336C22.0062 9.63798 22.3452 4.46467 20.9403 3.05974C19.5353 1.65481 14.362 1.99377 12.5664 2.15876C12.1603 2.19608 11.7813 2.36233 11.472 2.62811C8.34412 5.31646 5.49781 8.10211 2.77423 11.1439Z" stroke="currentColor" stroke-width="1.75" /><path d="M7.00002 14.0002L10 17.0002" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
							<a href="{$system['system_url']}/market/category/{$_post['product']['category_id']}/{$_post['product']['category_url']}" class="body-color">{__($_post['product']['category_name'])}</a>
						</div>
				
						<!-- custom fileds -->
						{if $_post['custom_fields']['basic']}
							<div class="post-custom-fileds-wrapper mt-3">
								{foreach $_post['custom_fields']['basic'] as $custom_field}
									{if $custom_field['value']}
										<div>
											<div class="fw-medium">{__($custom_field['label'])}</div>
											{if $custom_field['type'] == "textbox" && $custom_field['is_link']}
												<a href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
											{elseif $custom_field['type'] == "multipleselectbox"}
												{__($custom_field['value_string']|trim)}
											{else}
												{__($custom_field['value']|trim)}
											{/if}
										</div>
									{/if}
								{/foreach}
							</div>
						{/if}
						<!-- custom fileds -->
					</div>
				{/if}

				{if $_post['post_type'] == "funding" && $_post['funding']}
					<div class="mt-2">
						<div class="post-media">
							<a class="post-media-image d-block position-relative ratio ratio-16x9" href="{$system['system_url']}/posts/{$_post['post_id']}" target="_blank">
								<div class="image" style="background-image:url('{$system['system_uploads']}/{$_post['funding']['cover_image']}');"></div>
							</a>
						</div>
						<div class="post-funding-meta mt-2">
							<h3 class="headline-font mb-1">{$_post['funding']['title']}</h3>

							<!-- post text -->
							{if !$_shared}
								{include file='__feeds_post.text.tpl'}
							{else}
								<div class="post-text js_readmore text-muted" dir="auto">{$_post['text']}</div>
								<div class="post-text-translation x-hidden" dir="auto"></div>
							{/if}
							<!-- post text -->
							
							{if $user->_logged_in && $_post['author_id'] != $user->_data['user_id'] }
								<div class="mt-3">
									<button type="button" class="btn btn-main w-100" data-toggle="modal" data-url="#funding-donate" data-options='{ "post_id": {$_post["post_id"]} }'>
										{__("Donate")}
									</button>
								</div>
							{/if}

							<div class="funding-completion mt-3 p-2 rounded-3">
								<div class="d-flex align-items-center justify-content-between gap-3">
									<div class="fw-medium">{print_money($_post['funding']['raised_amount'])} {__("Raised of")} {print_money($_post['funding']['amount'])}</div>
									<span class="flex-0 small">{$_post['funding']['funding_completion']}%</span>
								</div>
								<div class="progress mt-2">
									<div class="progress-bar bg-success bg-opacity-75" role="progressbar" aria-valuenow="{$_post['funding']['funding_completion']}" aria-valuemin="0" aria-valuemax="100" style="width: {$_post['funding']['funding_completion']}%"></div>
								</div>
							</div>
						</div>
					</div>
				{/if}

				{if $_post['post_type'] == "offer" && $_post['offer']}
					<div class="mt-2">
						{if $_post['photos_num'] == 1}
							<div class="post-media">
								<div class="post-media-image d-block position-relative ratio ratio-16x9">
									<div class="image" style="background-image:url('{$system['system_uploads']}/{$_post['offer']['thumbnail']}');"></div>
								</div>
							</div>
						{else $_post['photos']}
							{include file='__feeds_post.body.photos.tpl'}
						{/if}
						
						<h3 class="headline-font mt-2">{$_post['offer']['meta_title']}</h3>
						{if $_post['offer']['price']}
							<h6 class="">
								{__("From")} <span class="main">{print_money($_post['offer']['price'])}</span>
							</h6>
						{/if}
						{if $_post['offer']['end_date']}
							<h6 class="">
								{__("Expires")}: <span class="">{$_post['offer']['end_date']|date_format:$system['system_date_format']}</span>
							</h6>
						{/if}
						<!-- custom fileds -->
						{if $_post['custom_fields']['basic']}
							<div class="post-custom-fileds-wrapper mt-3">
								{foreach $_post['custom_fields']['basic'] as $custom_field}
									{if $custom_field['value']}
										<div>
											<div class="fw-medium">{__($custom_field['label'])}</div>
											{if $custom_field['type'] == "textbox" && $custom_field['is_link']}
												<a href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
											{elseif $custom_field['type'] == "multipleselectbox"}
												{__($custom_field['value_string']|trim)}
											{else}
												{__($custom_field['value']|trim)}
											{/if}
										</div>
									{/if}
								{/foreach}
							</div>
						{/if}
						<!-- custom fileds -->
						
						<!-- post text -->
						{if !$_shared}
							{include file='__feeds_post.text.tpl'}
						{else}
							<div class="post-text js_readmore text-muted" dir="auto">{$_post['text']}</div>
							<div class="post-text-translation x-hidden" dir="auto"></div>
						{/if}
						<!-- post text -->
					</div>
				{/if}

				{if $_post['post_type'] == "job" && $_post['job']}
					<div class="mt-2">
						<div class="post-media">
							<a class="post-media-image d-block position-relative ratio ratio-16x9" href="{$system['system_url']}/posts/{$_post['post_id']}" target="_blank">
								<div class="image" style="background-image:url('{$system['system_uploads']}/{$_post['job']['cover_image']}');"></div>
							</a>
						</div>
						<div class="post-job-meta">
							<h3 class="headline-font mt-2">{$_post['job']['title']}</h3>
							<h6 class="">
								<span class="main">{print_money($_post['job']['salary_minimum'], $_post['job']['salary_minimum_currency']['symbol'], $_post['job']['salary_minimum_currency']['dir'])} - {print_money($_post['job']['salary_maximum'], $_post['job']['salary_maximum_currency']['symbol'], $_post['job']['salary_maximum_currency']['dir'])}</span> / {$_post['job']['pay_salary_per_meta']} 
							</h6>
							
							<!-- custom fileds -->
							{if $_post['custom_fields']['basic']}
								<div class="post-custom-fileds-wrapper mt-3">
									{foreach $_post['custom_fields']['basic'] as $custom_field}
										{if $custom_field['value']}
											<div>
												<div class="fw-medium">{__($custom_field['label'])}</div>
												{if $custom_field['type'] == "textbox" && $custom_field['is_link']}
													<a href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
												{elseif $custom_field['type'] == "multipleselectbox"}
													{__($custom_field['value_string']|trim)}
												{else}
													{__($custom_field['value']|trim)}
												{/if}
											</div>
										{/if}
									{/foreach}
								</div>
							{/if}
							<!-- custom fileds -->
							
							<div class="post-job-wrapper align-items-center flex-wrap d-flex p-2 rounded-3">
								<div class="post-job-details p-1 text-center">
									<div class="fw-semibold small">
										{__("Location")}
									</div>
									<div class="text-muted">
										{$_post['job']['location']}
									</div>
								</div>
								<div class="post-job-details p-1 text-center">
									<div class="fw-semibold small">
										{__("Type")}
									</div>
									<div class="text-muted">
										{$_post['job']['type_meta']}
									</div>
								</div>
								<div class="post-job-details p-1 text-center">
									<div class="fw-semibold small">
										{__("Status")}
									</div>
									<div class="">
										{if $_post['job']['available']}
											<span class="badge bg-success small">{__("Open")}</span>
										{else}
											<span class="badge bg-danger small">{__("Closed")}</span>
										{/if}
									</div>
								</div>
							</div>
							
							{if $_post['author_id'] == $user->_data['user_id']}
								<div class="mt-3 mb-2">
								  <button type="button" class="btn btn-main w-100 js_job-apply" data-toggle="modal" data-size="large" data-url="posts/job.php?do=candidates&post_id={$_post['post_id']}" {if $_post['job']['candidates_count'] == 0}disabled{/if}>
										{__("View Candidates")} ({$_post['job']['candidates_count']})
								  </button>
								</div>
							{/if}
							{if $user->_logged_in && $_post['job']['available'] &&  $_post['author_id'] != $user->_data['user_id'] }
								<div class="mt-3 mb-2">
									<button type="button" class="btn btn-main w-100 js_job-apply" data-toggle="modal" data-size="large" data-url="posts/job.php?do=application&post_id={$_post['post_id']}">
										{__("Apply Now")}
									</button>
								</div>
							{/if}
							
							<!-- post text -->
							{if !$_shared}
								{include file='__feeds_post.text.tpl'}
							{else}
								<div class="post-text js_readmore text-muted" dir="auto">{$_post['text']}</div>
								<div class="post-text-translation x-hidden" dir="auto"></div>
							{/if}
							<!-- post text -->
						</div>
					</div>
				{/if}

				{if $_post['post_type'] == "course" && $_post['course']}
					<div class="mt-2">
						<div class="post-media">
							<a class="post-media-image d-block position-relative ratio ratio-16x9" href="{$system['system_url']}/posts/{$_post['post_id']}" target="_blank">
								<div class="image" style="background-image:url('{$system['system_uploads']}/{$_post['course']['cover_image']}');"></div>
							</a>
						</div>
						<div class="post-course-meta">
							<h3 class="headline-font mt-2">{$_post['course']['title']}</h3>
							<h6 class="">
								<span class="main">{print_money($_post['course']['fees'], $_post['course']['fees_currency']['symbol'], $_post['course']['fees_currency']['dir'])}</span>
							</h6>
							
							<!-- custom fileds -->
							{if $_post['custom_fields']['basic']}
								<div class="post-custom-fileds-wrapper mt-3">
									{foreach $_post['custom_fields']['basic'] as $custom_field}
										{if $custom_field['value']}
											<div>
												<div class="fw-medium">{__($custom_field['label'])}</div>
												{if $custom_field['type'] == "textbox" && $custom_field['is_link']}
													<a href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
												{elseif $custom_field['type'] == "multipleselectbox"}
													{__($custom_field['value_string']|trim)}
												{else}
													{__($custom_field['value']|trim)}
												{/if}
											</div>
										{/if}
									{/foreach}
								</div>
							{/if}
							<!-- custom fileds -->
							
							<div class="post-job-wrapper align-items-center flex-wrap d-flex p-2 rounded-3">
								<div class="post-job-details p-1 text-center">
									<div class="fw-semibold small">
										{__("Location")}
									</div>
									<div class="text-muted">
										{$_post['course']['location']}
									</div>
								</div>
								<div class="post-job-details p-1 text-center">
									<div class="fw-semibold small">
										{__("Date")}
									</div>
									<div class="text-muted">
										{$_post['course']['start_date']|date_format:"%e"} {$_post['course']['start_date']|date_format:"%b"} - {$_post['course']['end_date']|date_format:"%e"} {$_post['course']['end_date']|date_format:"%b"} {$_post['course']['end_date']|date_format:"%Y"}
									</div>
								</div>
								<div class="post-job-details p-1 text-center">
									<div class="fw-semibold small">
										{__("Status")}
									</div>
									<div class="">
										{if $_post['course']['available']}
											<span class="badge bg-success small">{__("Open")}</span>
										{else}
											<span class="badge bg-danger small">{__("Closed")}</span>
										{/if}
									</div>
								</div>
							</div>
				  
							{if $_post['author_id'] == $user->_data['user_id']}
								<div class="mt-3 mb-2">
									<button type="button" class="btn btn-main w-100 js_course-enroll" data-toggle="modal" data-size="large" data-url="posts/course.php?do=candidates&post_id={$_post['post_id']}" {if $_post['course']['candidates_count'] == 0}disabled{/if}>
										{__("View Candidates")} ({$_post['course']['candidates_count']})
									</button>
								</div>
							{/if}
							{if $user->_logged_in && $_post['course']['available'] &&  $_post['author_id'] != $user->_data['user_id'] }
								<div class="mt-3 mb-2">
									<button type="button" class="btn btn-main w-100 js_course-enroll" data-toggle="modal" data-size="large" data-url="posts/course.php?do=application&post_id={$_post['post_id']}">
										{__("Enroll Now")}
									</button>
								</div>
							{/if}
				  
							<!-- post text -->
							{if !$_shared}
								{include file='__feeds_post.text.tpl'}
							{else}
								<div class="post-text js_readmore text-muted" dir="auto">{$_post['text']}</div>
								<div class="post-text-translation x-hidden" dir="auto"></div>
							{/if}
							<!-- post text -->
						</div>
					</div>
				{/if}

				{if $_post['post_type'] == "poll" && $_post['poll']}
					<div class="poll-options d-flex flex-column gap-2 mt-2" data-poll-votes="{$_post['poll']['votes']}">
						{foreach $_post['poll']['options'] as $option}
							<div class="d-flex align-items-center gap-2">
								<div class="poll-option flex-1 js_poll-vote" data-id="{$option['option_id']}" data-option-votes="{$option['votes']}">
									<input type="radio" name="poll_{if $boosted}boosted_{/if}_{$_post['poll']['poll_id']}" id="option_{$option['option_id']}" class="d-none" {if $option['checked']}checked{/if}>
									<label class="rounded-pill p-2 fw-medium w-100 position-relative pointer" for="option_{$option['option_id']}">
										<div class="percentage-bg position-absolute h-100 rounded-pill" {if $_post['poll']['votes'] > 0} style="width: {($option['votes']/$_post['poll']['votes'])*100}%" {/if}></div>
										<span class="d-flex align-items-center gap-2"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12.0572 1.75H12.0572C14.2479 1.74999 15.9686 1.74998 17.312 1.93059C18.6886 2.11568 19.7809 2.50272 20.6391 3.36091C21.4973 4.21911 21.8843 5.31137 22.0694 6.68802C22.25 8.03144 22.25 9.75214 22.25 11.9428V12.0572C22.25 14.2479 22.25 15.9686 22.0694 17.312C21.8843 18.6886 21.4973 19.7809 20.6391 20.6391C19.7809 21.4973 18.6886 21.8843 17.312 22.0694C15.9686 22.25 14.2479 22.25 12.0572 22.25H11.9428C9.7521 22.25 8.03144 22.25 6.68802 22.0694C5.31137 21.8843 4.21911 21.4973 3.36091 20.6391C2.50272 19.7809 2.11568 18.6886 1.93059 17.312C1.74998 15.9686 1.74999 14.2479 1.75 12.0572V12.0572V11.9428V11.9428C1.74999 9.75211 1.74998 8.03144 1.93059 6.68802C2.11568 5.31137 2.50272 4.21911 3.36091 3.36091C4.21911 2.50272 5.31137 2.11568 6.68802 1.93059C8.03144 1.74998 9.75212 1.74999 11.9428 1.75H11.9428H12.0572ZM16.6757 8.26285C17.0828 8.63604 17.1103 9.26861 16.7372 9.67573L11.2372 15.6757C11.0528 15.8768 10.7944 15.9938 10.5217 15.9998C10.249 16.0057 9.98576 15.9 9.79289 15.7071L7.29289 13.2071C6.90237 12.8166 6.90237 12.1834 7.29289 11.7929C7.68342 11.4024 8.31658 11.4024 8.70711 11.7929L10.4686 13.5544L15.2628 8.32428C15.636 7.91716 16.2686 7.88966 16.6757 8.26285Z" fill="currentColor"/></svg>{$option['text']}</span>
									</label>
								</div>
								<div class="poll-voters flex-0">
									<div class="more text-center pointer fw-medium rounded-pill" data-toggle="modal" data-url="posts/who_votes.php?option_id={$option['option_id']}">{$option['votes']}</div>
								</div>
							</div>
						{/foreach}
					</div>
				{/if}

				{if $_post['post_type'] == "reel" && $_post['reel']}
					<div class="post-video-reel vertical-reel mt-2">
						<video class="w-100 js_video-plyr" id="reel-{$_post['reel']['reel_id']}{if $pinned || $boosted}-{$_post['post_id']}{/if}" {if $user->_logged_in}onplay="update_media_views('reel', {$_post['reel']['reel_id']})" {/if} {if $_post['reel']['thumbnail']}data-poster="{$system['system_uploads']}/{$_post['reel']['thumbnail']}" {/if} playsinline controls preload="auto">
							{if empty($_post['reel']['source_240p']) && empty($_post['reel']['source_360p']) && empty($_post['reel']['source_480p']) && empty($_post['reel']['source_720p']) && empty($_post['reel']['source_1080p']) && empty($_post['reel']['source_1440p']) && empty($_post['reel']['source_2160p'])}
								<source src="{$system['system_uploads']}/{$_post['reel']['source']}" type="video/mp4">
							{/if}
							{if $_post['reel']['source_240p']}
								<source src="{$system['system_uploads']}/{$_post['reel']['source_240p']}" type="video/mp4" size="240">
							{/if}
							{if $_post['reel']['source_360p']}
								<source src="{$system['system_uploads']}/{$_post['reel']['source_360p']}" type="video/mp4" size="360">
							{/if}
							{if $_post['reel']['source_480p']}
								<source src="{$system['system_uploads']}/{$_post['reel']['source_480p']}" type="video/mp4" size="480">
							{/if}
							{if $_post['reel']['source_720p']}
								<source src="{$system['system_uploads']}/{$_post['reel']['source_720p']}" type="video/mp4" size="720">
							{/if}
							{if $_post['reel']['source_1080p']}
								<source src="{$system['system_uploads']}/{$_post['reel']['source_1080p']}" type="video/mp4" size="1080">
							{/if}
							{if $_post['reel']['source_1440p']}
								<source src="{$system['system_uploads']}/{$_post['reel']['source_1440p']}" type="video/mp4" size="1440">
							{/if}
							{if $_post['reel']['source_2160p']}
								<source src="{$system['system_uploads']}/{$_post['reel']['source_2160p']}" type="video/mp4" size="2160">
							{/if}
						</video>
					</div>
				{/if}

				{if ($_post['post_type'] == "video" || $_post['post_type'] == "combo") && $_post['video']}
					<div class="post-video-reel mt-2">
						<video class="w-100 js_video-plyr" id="video-{$_post['video']['video_id']}{if $pinned || $boosted}-{$_post['post_id']}{/if}" {if $user->_logged_in}onplay="update_media_views('video', {$_post['video']['video_id']})" {/if} {if $_post['video']['thumbnail']}data-poster="{$system['system_uploads']}/{$_post['video']['thumbnail']}" {/if} playsinline controls preload="auto">
							{if empty($_post['video']['source_240p']) && empty($_post['video']['source_360p']) && empty($_post['video']['source_480p']) && empty($_post['video']['source_720p']) && empty($_post['video']['source_1080p']) && empty($_post['video']['source_1440p']) && empty($_post['video']['source_2160p'])}
								<source src="{$system['system_uploads']}/{$_post['video']['source']}" type="video/mp4">
							{/if}
							{if $_post['video']['source_240p']}
								<source src="{$system['system_uploads']}/{$_post['video']['source_240p']}" type="video/mp4" size="240">
							{/if}
							{if $_post['video']['source_360p']}
								<source src="{$system['system_uploads']}/{$_post['video']['source_360p']}" type="video/mp4" size="360">
							{/if}
							{if $_post['video']['source_480p']}
								<source src="{$system['system_uploads']}/{$_post['video']['source_480p']}" type="video/mp4" size="480">
							{/if}
							{if $_post['video']['source_720p']}
								<source src="{$system['system_uploads']}/{$_post['video']['source_720p']}" type="video/mp4" size="720">
							{/if}
							{if $_post['video']['source_1080p']}
								<source src="{$system['system_uploads']}/{$_post['video']['source_1080p']}" type="video/mp4" size="1080">
							{/if}
							{if $_post['video']['source_1440p']}
								<source src="{$system['system_uploads']}/{$_post['video']['source_1440p']}" type="video/mp4" size="1440">
							{/if}
							{if $_post['video']['source_2160p']}
								<source src="{$system['system_uploads']}/{$_post['video']['source_2160p']}" type="video/mp4" size="2160">
							{/if}
						</video>
					</div>
				{/if}

				{if ($_post['post_type'] == "audio" || $_post['post_type'] == "combo") && $_post['audio']}
					<div class="mt-2 lh-1">
						<audio class="py-2 rounded-3 js_audio w-100" id="audio-{$_post['audio']['audio_id']}" {if $user->_logged_in}onplay="update_media_views('audio', {$_post['audio']['audio_id']})" {/if} controls preload="auto">
							<source src="{$system['system_uploads']}/{$_post['audio']['source']}" type="audio/mpeg">
							<source src="{$system['system_uploads']}/{$_post['audio']['source']}" type="audio/mp3">
							{__("Your browser does not support HTML5 audio")}
						</audio>
					</div>
				{/if}

				{if ($_post['post_type'] == "file" || $_post['post_type'] == "combo") && $_post['file']}
					<div class="post-downloader d-flex align-items-center gap-3 rounded-3 p-3 mt-2">
						<div class="icon d-flex align-items-center justify-content-center flex-0 position-relative main main_bg_half">
							<svg width="38" height="38" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="position-relative"><path opacity="0.4" d="M4 12.0004L4 14.5446C4 17.7896 4 19.4121 4.88607 20.5111C5.06508 20.7331 5.26731 20.9354 5.48933 21.1144C6.58831 22.0004 8.21082 22.0004 11.4558 22.0004C12.1614 22.0004 12.5141 22.0004 12.8372 21.8864C12.9044 21.8627 12.9702 21.8354 13.0345 21.8047C13.3436 21.6569 13.593 21.4074 14.0919 20.9085L18.8284 16.172C19.4065 15.5939 19.6955 15.3049 19.8478 14.9374C20 14.5698 20 14.1611 20 13.3436V10.0004C20 6.22919 20 4.34358 18.8284 3.172C17.7693 2.11284 16.1265 2.01122 13.0345 2.00146M13 21.5004V21.0004C13 18.172 13 16.7578 13.8787 15.8791C14.7574 15.0004 16.1716 15.0004 19 15.0004H19.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M4 8.23028V5.46105C4 3.54929 5.567 1.99951 7.5 1.99951C9.433 1.99951 11 3.54929 11 5.46105V9.26874C11 10.2246 10.2165 10.9995 9.25 10.9995C8.2835 10.9995 7.5 10.2246 7.5 9.26874V5.46105" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
						</div>
						<div class="info">
							<div class="fw-medium">{__("File Type")}: {get_extension({$_post['file']['source']})}</div>
							{if $_post['needs_payment']}
								<button class="btn btn-main btn-sm mt-1 {if !$user->_logged_in}js_login{/if}" {if $user->_logged_in}data-toggle="modal" data-url="#payment" data-options='{ "handle": "paid_post", "paid_post": "true", "id": {$_post['post_id']}, "price": {$_post['post_price']}, "vat": "{get_payment_vat_value($_post['post_price'])}", "fees": "{get_payment_fees_value($_post['post_price'])}", "total": "{get_payment_total_value($_post['post_price'])}", "total_printed": "{get_payment_total_value($_post['post_price'], true)}" }' {/if}>
									{__("PAY TO DOWNLOAD")} ({print_money($_post['post_price']|number_format:2)})
								</button>
							{else}
								<a class="btn btn-main btn-sm mt-1 text-no-underline" href="{if $system['mask_file_path_enabled']}{$system['system_url']}/downloads.php?id={$_post['post_id']}{else}{$system['system_uploads']}/{$_post['file']['source']}{/if}">{__("Download")}</a>
							{/if}
						</div>
					</div>
				{/if}
			
				{if $_post['post_type'] == "merit" && $_post['merit']['image'] && $_post['merit']['message']}
					<div class="mt-2">
						<div class="post-media">
							<div class="post-media-image d-block position-relative ratio ratio-16x9">
								{if $_post['merit']['image']}
									<div class="image" style="background-image:url('{$system['system_uploads']}/{$_post['merit']['image']}');"></div>
								{/if}
							</div>
						</div>
						{if {$_post['merit']['message']}}
							<div class="post-merit-meta">
								<div class="merit-description">
									<!-- post text -->
									<div class="post-text js_readmore text-muted" dir="auto">{$_post['merit']['message']}</div>
									<div class="post-text-translation x-hidden" dir="auto"></div>
									<!-- post text -->
								</div>
							</div>
						{/if}
				  </div>
				{/if}

				{if $_post['post_type'] == "group" && $_post['group']}
					<div class="p-3 side_item_list d-flex align-items-start gap-3 x_group_list border rounded-3 mt-2">
						{if $_post['group']['group_cover']}
							<a href="{$system['system_url']}/groups/{$_post['group']['group_name']}" class="flex-0">
								<img alt="{$_post['group']['group_title']}" src="{$system['system_uploads']}/{$_post['group']['group_cover']}" class="rounded-3" />
							</a>
						{/if}

						<div class="flex-1">
							<div class="">
								<a class="text-md fw-semibold body-color" href="{$system['system_url']}/groups/{$_post['group']['group_name']}">{$_post['group']['group_title']}</a>
								<div class="text-muted small" type="button" data-toggle="modal" data-url="modules/who_members.php?group_id={$_post['group']['group_id']}">{$_post['group']['group_members_formatted']} {__("Members")}</div>
							</div>
							<div class="mt-2 pt-1">
								{if $_post['group']['i_joined'] == "approved"}
									<button type="button" class="btn btn-success js_leave-group" data-id="{$_post['group']['group_id']}" data-privacy="{$_post['group']['group_privacy']}">
										<i class="fa fa-check"></i>{__("Joined")}
									</button>
								{elseif $_post['group']['i_joined'] == "pending"}
									<button type="button" class="btn btn-warning js_leave-group" data-id="{$_post['group']['group_id']}" data-privacy="{$_post['group']['group_privacy']}">
										<i class="fa fa-clock"></i>{__("Pending")}
									</button>
								{else}
									<button type="button" class="btn btn-dark js_join-group" data-id="{$_post['group']['group_id']}" data-privacy="{if $_post['group']['i_admin']}public{else}{$_post['group']['group_privacy']}{/if}">
										<i class="fa fa-user-plus"></i>{__("Join")}
									</button>
								{/if}
							</div>
						</div>
					</div>
				{/if}

				{if $_post['post_type'] == "event" && $_post['event']}
					<div class="x_event_list mt-2">
						<div class="position-relative rounded-3 overflow-hidden border">
							<a href="{$system['system_url']}/events/{$_post['event']['event_id']}" class="d-block w-100 avatar x_adslist rounded-0">
								{if $_post['event']['event_cover']}
									<img alt="{$_post['event']['event_title']}" src="{$system['system_uploads']}/{$_post['event']['event_cover']}" class="w-100 h-100 rounded-3" />
								{/if}
							</a>
							<div class="d-flex align-items-center justify-content-between gap-2 gap-3 position-absolute p-3 pt-5 bottom-0 start-0 end-0 pe-none eventlist_foot">
								<div class="d-flex align-items-center gap-2 mw-0">
									<div class="position-relative bg-white text-center rounded-3 overflow-hidden profle-date-wrapper">
										<span class="d-block text-white fw-semibold text-uppercase lh-1">{__($_post['event']['event_start_date']|date_format:"%b")}</span>
										<b class="d-block fw-bold lh-1">{$_post['event']['event_start_date']|date_format:"%e"}</b>
									</div>
									<div class="bg-white rounded-pill pe-auto x_user_info py-1 info mw-0 text-truncate">
										<a class="h6 mw-0 text-truncate" href="{$system['system_url']}/events/{$_post['event']['event_id']}">{$_post['event']['event_title']}</a>
										<div class="small text-muted" type="button" data-toggle="modal" data-url="modules/who_interested.php?event_id={$_post['event']['event_id']}">{$_post['event']['event_interested_formatted']} {__("Interested")}</div>
									</div>
								</div>
								<div class="flex-0 pe-auto">
									{if $_post['event']['i_joined']['is_interested']}
										<button type="button" class="btn btn-sm btn-light js_uninterest-event" data-id="{$_post['event']['event_id']}" title='{__("Interested")}'>
											<i class="fa fa-check mr5"></i>
										</button>
									{else}
										<button type="button" class="btn btn-sm btn-primary js_interest-event" data-id="{$_post['event']['event_id']}" title='{__("Interested")}'>
											<i class="fa fa-star mr5"></i>
										</button>
									{/if}
								</div>
							</div>
						</div>
					</div>
				{/if}
			{/if}

		{else}

			{if $_post['needs_payment']}
				{include file='_need_payment.tpl' post_id=$_post['post_id'] price=$_post['post_price'] paid_text=$_post['paid_text'] paid_image=$_post['paid_image']}
			{elseif $_post['needs_subscription']}
				{include file='_need_subscription.tpl' node_type=$_post['needs_subscription_type'] node_id=$_post['needs_subscription_id'] price=$_post['needs_subscription_price'] subscriptions_image=$_post['subscriptions_image']}
			{elseif $_post['needs_age_verification']}
				{include file='_need_age_verification.tpl'}
			{/if}

		{/if}
	</div>
</div>