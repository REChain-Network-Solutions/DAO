{if $user->_logged_in}
	<a href="{$system['system_url']}/saved" class="d-block py-1 body-color x_side_links x_hide_saved_link x_hide_mobi_side_link {if $page == "index" && $view == "saved"}fw-semibold main{/if}">
		<div class="d-inline-flex align-items-center position-relative main_bg_half">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="27" height="27" color="currentColor" fill="none">
				{if $page == "index" && $view == "saved"}
					<path d="M16.4854 1.39731C15.348 1.24998 13.8393 1.24999 12 1.25C10.1607 1.24999 8.652 1.24998 7.51458 1.39731C6.34712 1.54853 5.40051 1.86672 4.65121 2.58863C3.898 3.31431 3.56243 4.23743 3.40365 5.37525C3.38356 5.51919 3.3661 5.66833 3.35092 5.8228C3.33154 6.02004 3.32185 6.11866 3.38139 6.18433C3.44092 6.25 3.54199 6.25 3.74412 6.25H20.2559C20.458 6.25 20.5591 6.25 20.6186 6.18433C20.6782 6.11866 20.6685 6.02004 20.6491 5.8228C20.6339 5.66833 20.6164 5.51919 20.5964 5.37525C20.4376 4.23743 20.102 3.31431 19.3488 2.58863C18.5995 1.86672 17.6529 1.54853 16.4854 1.39731Z" fill="currentColor"/><path d="M20.7458 8.1438C20.7441 7.95852 20.7433 7.86588 20.6848 7.80794C20.6263 7.75 20.5333 7.75 20.3472 7.75H3.65284C3.46674 7.75 3.37368 7.75 3.31522 7.80794C3.25675 7.86588 3.25591 7.95852 3.25424 8.1438C3.24999 8.61366 3.25 9.115 3.25001 9.64943L3.25 18.0458C3.24996 19.1433 3.24993 20.0553 3.35533 20.7405C3.46438 21.4495 3.71857 22.1395 4.41958 22.5139C5.04476 22.8477 5.7324 22.7798 6.31544 22.6028C6.90514 22.4238 7.50454 22.0989 8.05335 21.7521C8.60739 21.402 9.15065 21.0029 9.623 20.6538C10.0858 20.3117 10.5131 19.9958 10.7969 19.8249C11.1965 19.5843 11.4488 19.4335 11.6533 19.3371C11.842 19.2482 11.9337 19.234 12 19.234C12.0663 19.234 12.158 19.2482 12.3467 19.3371C12.5513 19.4335 12.8035 19.5843 13.2031 19.8249C13.4869 19.9958 13.9142 20.3117 14.377 20.6538C14.8494 21.0029 15.3926 21.402 15.9467 21.7521C16.4955 22.0989 17.0949 22.4238 17.6846 22.6028C18.2676 22.7798 18.9553 22.8477 19.5804 22.5139C20.2814 22.1395 20.5356 21.4495 20.6447 20.7405C20.7501 20.0553 20.75 19.1434 20.75 18.0458V9.64945C20.75 9.11501 20.75 8.61366 20.7458 8.1438Z" fill="currentColor"/>
				{else}
					<path d="M4 17.9808V9.70753C4 6.07416 4 4.25748 5.17157 3.12874C6.34315 2 8.22876 2 12 2C15.7712 2 17.6569 2 18.8284 3.12874C20 4.25748 20 6.07416 20 9.70753V17.9808C20 20.2867 20 21.4396 19.2272 21.8523C17.7305 22.6514 14.9232 19.9852 13.59 19.1824C12.8168 18.7168 12.4302 18.484 12 18.484C11.5698 18.484 11.1832 18.7168 10.41 19.1824C9.0768 19.9852 6.26947 22.6514 4.77285 21.8523C4 21.4396 4 20.2867 4 17.9808Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M4 7H20" stroke="currentColor" stroke-width="2" />
				{/if}
			</svg>
			<span class="text">{__("Saved")}</span>
		</div>
	</a>
	
	{if $system['packages_enabled'] && !$user->_data['user_subscribed']}
		<a href="{$system['system_url']}/packages" class="d-block py-1 body-color x_side_links x_hide_pro_link x_hide_mobi_side_link {if $page == "packages"}fw-semibold main{/if}">
			<div class="d-inline-flex align-items-center position-relative main_bg_half">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="27" height="27" color="currentColor" fill="none">
					{if $page == "packages"}
						<path fill-rule="evenodd" clip-rule="evenodd" d="M11.9998 1C11.2796 1 10.8376 1.5264 10.5503 1.97988C10.2554 2.4452 9.95117 3.1155 9.59009 3.91103L9.59009 3.91103C9.44988 4.2199 9.31383 4.53229 9.17756 4.84518C8.86046 5.57329 8.54218 6.30411 8.16755 6.99964C7.88171 7.53032 7.37683 7.83299 6.76135 7.61455C6.52927 7.53218 6.23722 7.40295 5.79615 7.20692C5.69004 7.15975 5.57926 7.10711 5.46493 7.05277C4.85848 6.76458 4.15216 6.42892 3.51264 6.61189C2.88386 6.79179 2.43635 7.31426 2.28943 7.92532C2.20015 8.29667 2.27799 8.67764 2.36923 9.00553C2.46354 9.3445 2.61703 9.76929 2.80214 10.2816L2.80216 10.2816L4.49446 14.9652L4.49447 14.9652L4.49448 14.9653C4.83952 15.9202 5.11802 16.691 5.40655 17.2893C5.99655 18.5128 6.92686 19.2598 8.2897 19.4248C8.91068 19.5 9.67242 19.5 10.5984 19.5H13.4012C14.3272 19.5 15.089 19.5 15.7099 19.4248C17.0728 19.2598 18.0031 18.5128 18.5931 17.2893C18.8816 16.691 19.1601 15.9202 19.5052 14.9651L21.1975 10.2816L21.1975 10.2815C21.3826 9.76926 21.5361 9.34449 21.6304 9.00553C21.7216 8.67764 21.7995 8.29667 21.7102 7.92532C21.5633 7.31426 21.1158 6.79179 20.487 6.61189C19.8539 6.43075 19.15 6.76336 18.5495 7.04714C18.4411 7.09835 18.3361 7.14797 18.2355 7.19269C18.174 7.22 18.1126 7.24761 18.0512 7.27524C17.7834 7.39565 17.5147 7.51644 17.2383 7.61455C16.6228 7.83299 16.1179 7.53032 15.8321 6.99964C15.4574 6.3041 15.1392 5.57327 14.8221 4.84515C14.6858 4.53226 14.5497 4.21987 14.4095 3.911L14.4095 3.91099C14.0485 3.11548 13.7442 2.44519 13.4494 1.97988C13.162 1.5264 12.72 1 11.9998 1ZM11.999 13C11.1743 13 10.5057 13.6716 10.5057 14.5C10.5057 15.3284 11.1743 16 11.999 16H12.0124C12.8372 16 13.5057 15.3284 13.5057 14.5C13.5057 13.6716 12.8372 13 12.0124 13H11.999Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M5.99976 21.9998C5.99976 21.4475 6.44747 20.9998 6.99976 20.9998H16.9998C17.552 20.9998 17.9998 21.4475 17.9998 21.9998C17.9998 22.552 17.552 22.9998 16.9998 22.9998H6.99976C6.44747 22.9998 5.99976 22.552 5.99976 21.9998Z" fill="currentColor"/>
					{else}
						<path d="M3.51819 10.3058C3.13013 9.23176 2.9361 8.69476 3.01884 8.35065C3.10933 7.97427 3.377 7.68084 3.71913 7.58296C4.03193 7.49346 4.51853 7.70973 5.49173 8.14227C6.35253 8.52486 6.78293 8.71615 7.18732 8.70551C7.63257 8.69379 8.06088 8.51524 8.4016 8.19931C8.71105 7.91237 8.91861 7.45513 9.33373 6.54064L10.2486 4.52525C11.0128 2.84175 11.3949 2 12 2C12.6051 2 12.9872 2.84175 13.7514 4.52525L14.6663 6.54064C15.0814 7.45513 15.289 7.91237 15.5984 8.19931C15.9391 8.51524 16.3674 8.69379 16.8127 8.70551C17.2171 8.71615 17.6475 8.52486 18.5083 8.14227C19.4815 7.70973 19.9681 7.49346 20.2809 7.58296C20.623 7.68084 20.8907 7.97427 20.9812 8.35065C21.0639 8.69476 20.8699 9.23176 20.4818 10.3057L18.8138 14.9222C18.1002 16.897 17.7435 17.8844 16.9968 18.4422C16.2502 19 15.2854 19 13.3558 19H10.6442C8.71459 19 7.74977 19 7.00315 18.4422C6.25654 17.8844 5.89977 16.897 5.18622 14.9222L3.51819 10.3058Z" stroke="currentColor" stroke-width="2" /><path d="M12 14H12.009" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M7 22H17" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
					{/if}
				</svg>
				<span class="text">{__("Upgrade to Pro")}</span>
			</div>
		</a>
	{/if}
	
	{if $user->_data['can_boost_posts'] && $user->_data['user_subscribed']}
		<a href="{$system['system_url']}/boosted/posts" class="d-block py-1 body-color x_side_links x_hide_pro_link x_hide_mobi_side_link {if $page == "index" && $view == "boosted_posts"}fw-semibold main{/if}">
			<div class="d-inline-flex align-items-center position-relative main_bg_half">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="27" height="27" color="currentColor" fill="none">
					{if $page == "index" && $view == "boosted_posts"}
						<path d="M13.6076 1.14723C14.3143 1.44842 14.7969 2.16259 14.7969 3.01681L14.7976 9.78474C14.7976 9.89519 14.8871 9.98472 14.9976 9.98472H18.0993C18.9851 9.98472 19.5954 10.5826 19.8466 11.2101C20.0974 11.8369 20.0636 12.642 19.5628 13.2849L12.5645 22.2678C12.0032 22.9883 11.1205 23.1629 10.3917 22.8523C9.68508 22.5511 9.20248 21.8369 9.20248 20.9827L9.20181 14.2148C9.2018 14.1043 9.11226 14.0148 9.00181 14.0148H5.90003C5.01422 14.0148 4.40394 13.4169 4.1528 12.7894C3.90193 12.1626 3.93574 11.3575 4.43658 10.7146L11.4348 1.73169C11.9962 1.01115 12.8788 0.83658 13.6076 1.14723Z" fill="currentColor"/>
					{else}
						<path d="M5.22576 11.3294L12.224 2.34651C12.7713 1.64397 13.7972 2.08124 13.7972 3.01707V9.96994C13.7972 10.5305 14.1995 10.985 14.6958 10.985H18.0996C18.8729 10.985 19.2851 12.0149 18.7742 12.6706L11.776 21.6535C11.2287 22.356 10.2028 21.9188 10.2028 20.9829V14.0301C10.2028 13.4695 9.80048 13.015 9.3042 13.015H5.90035C5.12711 13.015 4.71494 11.9851 5.22576 11.3294Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
					{/if}
				</svg>
				<span class="text">{__("Boosted")}</span>
			</div>
		</a>
	{/if}
{/if}

{if $system['reels_enabled']}
	<a href="{$system['system_url']}/reels" class="d-block py-1 body-color x_side_links {if $page == "reels"}fw-semibold main{/if}">
		<div class="d-inline-flex align-items-center position-relative main_bg_half">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="27" height="27" color="currentColor" fill="none">
				{if $page == "reels"}
					<path fill-rule="evenodd" clip-rule="evenodd" d="M11.6525 1.81436C11.7667 1.74949 11.9052 1.7491 12.1823 1.74831L12.3881 1.74771C13.3696 1.74474 14.3524 1.74177 15.333 1.77893C15.7678 1.7954 15.9853 1.80364 16.0666 1.95457C16.148 2.1055 16.0338 2.29421 15.8055 2.67164L13.4793 6.51698L13.4793 6.51699C13.3368 6.75265 13.2655 6.87048 13.1512 6.93493C13.0368 6.99938 12.8991 6.99938 12.6237 6.99938H9.17267C8.85945 6.99938 8.70283 6.99938 8.64539 6.89792C8.58794 6.79646 8.66852 6.66217 8.82967 6.39359L11.325 2.2347C11.4672 1.99773 11.5383 1.87924 11.6525 1.81436ZM9.0907 1.87017C9.03003 1.76805 8.87165 1.77393 8.5549 1.7857C7.86371 1.81139 7.2436 1.85519 6.68802 1.92989C5.31137 2.11497 4.21911 2.50201 3.36091 3.36021C2.49797 4.22315 2.12446 5.37886 1.94949 6.5566C1.91938 6.75928 1.90433 6.86062 1.96417 6.93C2.024 6.99938 2.12901 6.99938 2.33901 6.99938H5.59742C5.87539 6.99938 6.01438 6.99938 6.1294 6.93391C6.24441 6.86844 6.31537 6.74893 6.45728 6.5099L8.90681 2.38419C9.06985 2.10959 9.15137 1.97229 9.0907 1.87017ZM19.1711 2.39311C18.8653 2.26727 18.7124 2.20434 18.5375 2.2612C18.3627 2.31805 18.2656 2.47586 18.0714 2.79148L15.857 6.38975C15.691 6.65958 15.608 6.79451 15.6652 6.89694C15.7224 6.99938 15.8809 6.99938 16.1977 6.99938H21.661C21.871 6.99938 21.976 6.99938 22.0358 6.93C22.0957 6.86062 22.0806 6.75928 22.0505 6.55661C21.8756 5.37886 21.502 4.22314 20.6391 3.36021C20.2103 2.93141 19.7231 2.62024 19.1711 2.39311ZM22.1183 9.11482C22.2352 9.23025 22.2374 9.4131 22.2419 9.77879C22.25 10.4432 22.25 11.1628 22.25 11.9419V11.942V11.942V11.9421V12.0565C22.25 14.2472 22.25 15.9679 22.0694 17.3113C21.8843 18.6879 21.4973 19.7802 20.6391 20.6384C19.7809 21.4966 18.6886 21.8836 17.312 22.0687C15.9686 22.2493 14.2479 22.2493 12.0572 22.2493H11.9428C9.7521 22.2493 8.03144 22.2493 6.68802 22.0687C5.31137 21.8836 4.21911 21.4966 3.36091 20.6384C2.50272 19.7802 2.11568 18.6879 1.93059 17.3113C1.74998 15.9679 1.74999 14.2472 1.75 12.0565V11.9421V11.942C1.75 11.1629 1.74999 10.4432 1.75811 9.77879C1.76259 9.4131 1.76482 9.23025 1.88167 9.11482C1.99853 8.99938 2.18305 8.99938 2.5521 8.99938H21.4479C21.8169 8.99938 22.0015 8.99938 22.1183 9.11482ZM12.6539 16.8502C14.0857 15.9644 14.8016 15.5215 14.9531 14.8948C15.0156 14.6361 15.0156 14.3639 14.9531 14.1052C14.8016 13.4785 14.0857 13.0356 12.6539 12.1498C11.2697 11.2936 10.5777 10.8654 10.0199 11.0375C9.78934 11.1087 9.57925 11.2438 9.40982 11.4299C9 11.8802 9 12.7535 9 14.5C9 16.2465 9 17.1198 9.40982 17.57C9.57925 17.7562 9.78934 17.8913 10.0199 17.9625C10.5777 18.1346 11.2697 17.7064 12.6539 16.8502Z" fill="currentColor"/>
				{else}
					<path d="M2.50012 7.5H21.5001" stroke="currentColor" stroke-width="2" stroke-linejoin="round" /><path d="M17.0001 2.5L14.0001 7.5" stroke="currentColor" stroke-width="2" stroke-linejoin="round" /><path d="M10.0001 2.5L7.00012 7.5" stroke="currentColor" stroke-width="2" stroke-linejoin="round" /><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="2" /><path d="M14.9531 14.8948C14.8016 15.5215 14.0857 15.9644 12.6539 16.8502C11.2697 17.7064 10.5777 18.1346 10.0199 17.9625C9.78934 17.8913 9.57925 17.7562 9.40982 17.57C9 17.1198 9 16.2465 9 14.5C9 12.7535 9 11.8802 9.40982 11.4299C9.57925 11.2438 9.78934 11.1087 10.0199 11.0375C10.5777 10.8654 11.2697 11.2936 12.6539 12.1498C14.0857 13.0356 14.8016 13.4785 14.9531 14.1052C15.0156 14.3639 15.0156 14.6361 14.9531 14.8948Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round" />
				{/if}
			</svg>
			<span class="text">{__("Reels")}</span>
		</div>
	</a>
{/if}

{if $system['groups_enabled']}
	<a href="{$system['system_url']}/groups" class="d-block py-1 body-color x_side_links x_hide_groups_link x_hide_mobi_side_link {if $page == "groups"}fw-semibold main{/if}">
		<div class="d-inline-flex align-items-center position-relative main_bg_half">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="27" height="27" color="currentColor" fill="none">
				{if $page == "groups"}
					<path d="M8.21365 16.3972C9.29579 15.6726 10.5995 15.25 12 15.25C13.4005 15.25 14.7042 15.6726 15.7864 16.3972C16.8749 17.126 17.25 18.3957 17.25 19.5C17.25 19.9142 16.9142 20.25 16.5 20.25H7.5C7.08579 20.25 6.75 19.9142 6.75 19.5C6.75 18.3957 7.12515 17.126 8.21365 16.3972Z" fill="currentColor"/><path d="M8.75 11C8.75 9.20507 10.2051 7.75 12 7.75C13.7949 7.75 15.25 9.20507 15.25 11C15.25 12.7949 13.7949 14.25 12 14.25C10.2051 14.25 8.75 12.7949 8.75 11Z" fill="currentColor"/><path d="M14.75 6.5C14.75 4.98122 15.9812 3.75 17.5 3.75C19.0188 3.75 20.25 4.98122 20.25 6.5C20.25 8.01878 19.0188 9.25 17.5 9.25C15.9812 9.25 14.75 8.01878 14.75 6.5Z" fill="currentColor"/><path d="M3.75 6.5C3.75 4.98122 4.98122 3.75 6.5 3.75C8.01878 3.75 9.25 4.98122 9.25 6.5C9.25 8.01878 8.01878 9.25 6.5 9.25C4.98122 9.25 3.75 8.01878 3.75 6.5Z" fill="currentColor"/><path d="M7.54682 10.3485C7.51597 10.5612 7.5 10.7787 7.5 11C7.5 12.4176 8.15548 13.6821 9.17989 14.5069C8.6532 14.7034 8.15246 14.9533 7.68468 15.25H2.5C2.08579 15.25 1.75 14.9142 1.75 14.5C1.75 13.4263 2.07 12.1626 3.05401 11.4213C4.02988 10.6863 5.21666 10.25 6.5 10.25C6.85725 10.25 7.20701 10.2838 7.54682 10.3485Z" fill="currentColor"/><path d="M16.3153 15.25H21.5C21.9142 15.25 22.25 14.9142 22.25 14.5C22.25 13.4263 21.93 12.1626 20.946 11.4213C19.9701 10.6863 18.7834 10.25 17.5 10.25C17.1428 10.25 16.793 10.2838 16.4532 10.3485C16.4841 10.5612 16.5 10.7787 16.5 11C16.5 12.4176 15.8445 13.6821 14.8201 14.5069C15.3468 14.7034 15.8476 14.9533 16.3153 15.25Z" fill="currentColor"/>
				{else}
					<path d="M7.5 19.5C7.5 18.5344 7.82853 17.5576 8.63092 17.0204C9.59321 16.3761 10.7524 16 12 16C13.2476 16 14.4068 16.3761 15.3691 17.0204C16.1715 17.5576 16.5 18.5344 16.5 19.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><circle cx="12" cy="11" r="2.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M17.5 11C18.6101 11 19.6415 11.3769 20.4974 12.0224C21.2229 12.5696 21.5 13.4951 21.5 14.4038V14.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><circle cx="17.5" cy="6.5" r="2" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M6.5 11C5.38987 11 4.35846 11.3769 3.50256 12.0224C2.77706 12.5696 2.5 13.4951 2.5 14.4038V14.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><circle cx="6.5" cy="6.5" r="2" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
				{/if}
			</svg>
			<span class="text">{__("Groups")}</span>
		</div>
	</a>
{/if}

{if $system['pages_enabled']}
	<a href="{$system['system_url']}/pages" class="d-block py-1 body-color x_side_links x_hide_pages_link x_hide_mobi_side_link {if $page == "pages"}fw-semibold main{/if}">
		<div class="d-inline-flex align-items-center position-relative main_bg_half">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="27" height="27" color="currentColor" fill="none">
				{if $page == "pages"}
					<path d="M3.25 20.75C3.25 21.3023 3.69772 21.75 4.25 21.75C4.80229 21.75 5.25 21.3023 5.25 20.75L5.25 16.05C5.25 15.8843 5.38432 15.75 5.55 15.75L15.929 15.75C16.9976 15.75 17.8671 15.75 18.5254 15.6731C19.1789 15.5968 19.8334 15.4265 20.2644 14.9014C20.4597 14.6636 20.6043 14.3885 20.6876 14.092C20.8752 13.4248 20.613 12.7991 20.2815 12.2484C19.9486 11.6956 19.3919 10.9867 18.7531 10.1733C18.4666 9.80843 18.2854 9.57646 18.1648 9.3876C18.0517 9.21053 18.0316 9.1304 18.0258 9.08349C18.019 9.028 18.019 8.972 18.0258 8.91651C18.0316 8.8696 18.0517 8.78947 18.1648 8.6124C18.2854 8.42354 18.4665 8.19169 18.753 7.82686C19.3919 7.01337 19.9486 6.30448 20.2815 5.75161C20.613 5.20093 20.8752 4.57516 20.6876 3.90796C20.6043 3.61154 20.4597 3.33643 20.2644 3.09857C19.8334 2.57354 19.1789 2.40321 18.5254 2.32687C17.867 2.24997 16.9976 2.24998 15.9289 2.25H10.2297C8.79382 2.24998 7.64349 2.24997 6.74026 2.36594C5.80776 2.48567 5.02581 2.74063 4.40209 3.33629C3.77351 3.93659 3.49997 4.69704 3.37233 5.60363C3.2911 6.18067 3.2638 6.86128 3.25463 7.65317L3.25 20.75Z" fill="currentColor"/>
				{else}
					<path d="M15.8785 3L10.2827 3C7.32099 3 5.84015 3 4.92007 3.87868C4 4.75736 4 6.17157 4 9L4.10619 15L15.8785 15C18.1016 15 19.2131 15 19.6847 14.4255C19.8152 14.2666 19.9108 14.0841 19.9656 13.889C20.1639 13.184 19.497 12.3348 18.1631 10.6364L18.1631 10.6364C17.6083 9.92985 17.3309 9.57659 17.2814 9.1751C17.2671 9.05877 17.2671 8.94123 17.2814 8.8249C17.3309 8.42341 17.6083 8.07015 18.1631 7.36364L18.1631 7.36364C19.497 5.66521 20.1639 4.816 19.9656 4.11098C19.9108 3.91591 19.8152 3.73342 19.6847 3.57447C19.2131 3 18.1016 3 15.8785 3L15.8785 3Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M4 21L4 8" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
				{/if}
			</svg>
			<span class="text">{__("Pages")}</span>
		</div>
	</a>
{/if}

{if $system['market_enabled']}
	<a href="{$system['system_url']}/market" class="d-block py-1 body-color x_side_links x_hide_market_link x_hide_mobi_side_link {if $page == "market"}fw-semibold main{/if}">
		<div class="d-inline-flex align-items-center position-relative main_bg_half">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="27" height="27" color="currentColor" fill="none">
				{if $page == "market"}
					<path fill-rule="evenodd" clip-rule="evenodd" d="M3 9.75C3.55229 9.75 4 10.1977 4 10.75V15.25C4 16.6925 4.00213 17.6737 4.10092 18.4086C4.19585 19.1146 4.36322 19.4416 4.58579 19.6642C4.80836 19.8868 5.13538 20.0542 5.84143 20.1491C6.57625 20.2479 7.55752 20.25 9 20.25H15C16.4425 20.25 17.4238 20.2479 18.1586 20.1491C18.8646 20.0542 19.1916 19.8868 19.4142 19.6642C19.6368 19.4416 19.8042 19.1146 19.8991 18.4086C19.9979 17.6737 20 16.6925 20 15.25V10.75C20 10.1977 20.4477 9.75 21 9.75C21.5523 9.75 22 10.1977 22 10.75V15.3205C22 16.6747 22.0001 17.7913 21.8813 18.6751C21.7565 19.6029 21.4845 20.4223 20.8284 21.0784C20.1723 21.7345 19.3529 22.0065 18.4251 22.1312C17.5413 22.2501 16.4247 22.25 15.0706 22.25H8.92943C7.57531 22.25 6.4587 22.2501 5.57494 22.1312C4.64711 22.0065 3.82768 21.7345 3.17158 21.0784C2.51547 20.4223 2.2435 19.6029 2.11875 18.6751C1.99994 17.7913 1.99997 16.6747 2 15.3206L2 10.75C2 10.1977 2.44772 9.75 3 9.75Z" fill="currentColor"/><path d="M3.19143 4.45934C3.19143 2.95786 4.41603 1.75 5.91512 1.75H18.0849C19.584 1.75 20.8086 2.95786 20.8086 4.45934C20.8086 5.00972 20.9532 5.55089 21.2287 6.02939L22.2149 7.74274C22.4737 8.19195 22.6839 8.55669 22.7347 9.16669C22.7553 9.41456 22.7576 9.62312 22.726 9.82441C22.6958 10.0172 22.6381 10.1717 22.5956 10.2854L22.5894 10.3023C22.0565 11.7329 20.6723 12.75 19.0513 12.75C17.695 12.75 16.5023 12.037 15.8374 10.9644C14.9338 12.0575 13.5446 12.75 12 12.75C10.4554 12.75 9.06617 12.0575 8.16259 10.9644C7.49773 12.037 6.30506 12.75 4.94875 12.75C3.32768 12.75 1.94355 11.7329 1.41065 10.3022L1.40436 10.2854C1.3619 10.1717 1.30421 10.0172 1.27397 9.82441C1.2424 9.62312 1.24469 9.41457 1.26533 9.16669C1.31613 8.55668 1.52628 8.19195 1.78509 7.74274L2.77133 6.02939C3.04677 5.55089 3.19143 5.00972 3.19143 4.45934Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M6 17.5C6 16.9477 6.44772 16.5 7 16.5H11C11.5523 16.5 12 16.9477 12 17.5C12 18.0523 11.5523 18.5 11 18.5H7C6.44772 18.5 6 18.0523 6 17.5Z" fill="currentColor"/>
				{else}
					<path d="M3.00003 10.9866V15.4932C3.00003 18.3257 3.00003 19.742 3.87871 20.622C4.75739 21.502 6.1716 21.502 9.00003 21.502H15C17.8284 21.502 19.2426 21.502 20.1213 20.622C21 19.742 21 18.3257 21 15.4932V10.9866" stroke="currentColor" stroke-width="2" /><path d="M7.00003 17.9741H11" stroke="currentColor" stroke-width="2" stroke-linecap="round" /><path d="M17.7957 2.50049L6.14986 2.52954C4.41169 2.44011 3.96603 3.77859 3.96603 4.4329C3.96603 5.01809 3.89058 5.8712 2.82527 7.47462C1.75996 9.07804 1.84001 9.55437 2.44074 10.6644C2.93931 11.5857 4.20744 11.9455 4.86865 12.0061C6.96886 12.0538 7.99068 10.2398 7.99068 8.96495C9.03254 12.1683 11.9956 12.1683 13.3158 11.802C14.6386 11.435 15.7717 10.1214 16.0391 8.96495C16.195 10.4021 16.6682 11.2408 18.0663 11.817C19.5145 12.4139 20.7599 11.5016 21.3848 10.9168C22.0097 10.332 22.4107 9.03364 21.2968 7.60666C20.5286 6.62257 20.2084 5.69548 20.1033 4.73462C20.0423 4.17787 19.9888 3.57961 19.5972 3.1989C19.0248 2.64253 18.2036 2.47372 17.7957 2.50049Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
				{/if}
			</svg>
			<span class="text">{__("Market")}</span>
		</div>
	</a>
{/if}

<div class="dropup">
	<a href="javascript:void(0);" class="d-block py-1 body-color x_side_links dropdownMoreMenuButton dropdownMenuButton" data-bs-toggle="dropdown">
		<div class="d-inline-flex align-items-center position-relative main_bg_half">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="27" height="27" color="currentColor" fill="none">
				<path d="M11.9959 12H12.0049" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M15.9998 12H16.0088" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M7.99981 12H8.00879" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12Z" stroke="currentColor" stroke-width="2" />
			</svg>
			<span class="text">{__("See More")}</span>
		</div>
	</a>

	<div class="dropdown-menu x_side_more_menu">
		{if $user->_logged_in}
			<a class='dropdown-item d-none x_show_saved_link {if $page == "index" && $view == "saved"}active {/if}' href="{$system['system_url']}/saved">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M4 17.9808V9.70753C4 6.07416 4 4.25748 5.17157 3.12874C6.34315 2 8.22876 2 12 2C15.7712 2 17.6569 2 18.8284 3.12874C20 4.25748 20 6.07416 20 9.70753V17.9808C20 20.2867 20 21.4396 19.2272 21.8523C17.7305 22.6514 14.9232 19.9852 13.59 19.1824C12.8168 18.7168 12.4302 18.484 12 18.484C11.5698 18.484 11.1832 18.7168 10.41 19.1824C9.0768 19.9852 6.26947 22.6514 4.77285 21.8523C4 21.4396 4 20.2867 4 17.9808Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M4 7H20" stroke="currentColor" stroke-width="2" /></svg>
				{__("Saved")}
			</a>
		
			{if $system['packages_enabled'] && !$user->_data['user_subscribed']}
				<a class='dropdown-item d-none x_show_pro_link {if $page == "packages"}active {/if}' href="{$system['system_url']}/packages">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3.51819 10.3058C3.13013 9.23176 2.9361 8.69476 3.01884 8.35065C3.10933 7.97427 3.377 7.68084 3.71913 7.58296C4.03193 7.49346 4.51853 7.70973 5.49173 8.14227C6.35253 8.52486 6.78293 8.71615 7.18732 8.70551C7.63257 8.69379 8.06088 8.51524 8.4016 8.19931C8.71105 7.91237 8.91861 7.45513 9.33373 6.54064L10.2486 4.52525C11.0128 2.84175 11.3949 2 12 2C12.6051 2 12.9872 2.84175 13.7514 4.52525L14.6663 6.54064C15.0814 7.45513 15.289 7.91237 15.5984 8.19931C15.9391 8.51524 16.3674 8.69379 16.8127 8.70551C17.2171 8.71615 17.6475 8.52486 18.5083 8.14227C19.4815 7.70973 19.9681 7.49346 20.2809 7.58296C20.623 7.68084 20.8907 7.97427 20.9812 8.35065C21.0639 8.69476 20.8699 9.23176 20.4818 10.3057L18.8138 14.9222C18.1002 16.897 17.7435 17.8844 16.9968 18.4422C16.2502 19 15.2854 19 13.3558 19H10.6442C8.71459 19 7.74977 19 7.00315 18.4422C6.25654 17.8844 5.89977 16.897 5.18622 14.9222L3.51819 10.3058Z" stroke="currentColor" stroke-width="2" /><path d="M12 14H12.009" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M7 22H17" stroke="currentColor" stroke-width="2" stroke-linecap="round" /></svg>
					{__("Upgrade to Pro")}
				</a>
			{/if}
		{/if}
		
		{if $system['groups_enabled']}
			<a class='dropdown-item d-none x_show_groups_link {if $page == "groups"}active {/if}' href="{$system['system_url']}/groups">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7.5 19.5C7.5 18.5344 7.82853 17.5576 8.63092 17.0204C9.59321 16.3761 10.7524 16 12 16C13.2476 16 14.4068 16.3761 15.3691 17.0204C16.1715 17.5576 16.5 18.5344 16.5 19.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><circle cx="12" cy="11" r="2.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M17.5 11C18.6101 11 19.6415 11.3769 20.4974 12.0224C21.2229 12.5696 21.5 13.4951 21.5 14.4038V14.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><circle cx="17.5" cy="6.5" r="2" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M6.5 11C5.38987 11 4.35846 11.3769 3.50256 12.0224C2.77706 12.5696 2.5 13.4951 2.5 14.4038V14.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><circle cx="6.5" cy="6.5" r="2" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
				{__("Groups")}
			</a>
		{/if}
		{if $system['pages_enabled']}
			<a class='dropdown-item d-none x_show_pages_link {if $page == "pages"}active {/if}' href="{$system['system_url']}/pages">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M15.8785 3L10.2827 3C7.32099 3 5.84015 3 4.92007 3.87868C4 4.75736 4 6.17157 4 9L4.10619 15L15.8785 15C18.1016 15 19.2131 15 19.6847 14.4255C19.8152 14.2666 19.9108 14.0841 19.9656 13.889C20.1639 13.184 19.497 12.3348 18.1631 10.6364L18.1631 10.6364C17.6083 9.92985 17.3309 9.57659 17.2814 9.1751C17.2671 9.05877 17.2671 8.94123 17.2814 8.8249C17.3309 8.42341 17.6083 8.07015 18.1631 7.36364L18.1631 7.36364C19.497 5.66521 20.1639 4.816 19.9656 4.11098C19.9108 3.91591 19.8152 3.73342 19.6847 3.57447C19.2131 3 18.1016 3 15.8785 3L15.8785 3Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M4 21L4 8" stroke="currentColor" stroke-width="2" stroke-linecap="round" /></svg>
				{__("Pages")}
			</a>
		{/if}
		{if $system['market_enabled']}
			<a class='dropdown-item d-none x_show_market_link {if $page == "market"}active {/if}' href="{$system['system_url']}/market">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3.00003 10.9866V15.4932C3.00003 18.3257 3.00003 19.742 3.87871 20.622C4.75739 21.502 6.1716 21.502 9.00003 21.502H15C17.8284 21.502 19.2426 21.502 20.1213 20.622C21 19.742 21 18.3257 21 15.4932V10.9866" stroke="currentColor" stroke-width="2" /><path d="M7.00003 17.9741H11" stroke="currentColor" stroke-width="2" stroke-linecap="round" /><path d="M17.7957 2.50049L6.14986 2.52954C4.41169 2.44011 3.96603 3.77859 3.96603 4.4329C3.96603 5.01809 3.89058 5.8712 2.82527 7.47462C1.75996 9.07804 1.84001 9.55437 2.44074 10.6644C2.93931 11.5857 4.20744 11.9455 4.86865 12.0061C6.96886 12.0538 7.99068 10.2398 7.99068 8.96495C9.03254 12.1683 11.9956 12.1683 13.3158 11.802C14.6386 11.435 15.7717 10.1214 16.0391 8.96495C16.195 10.4021 16.6682 11.2408 18.0663 11.817C19.5145 12.4139 20.7599 11.5016 21.3848 10.9168C22.0097 10.332 22.4107 9.03364 21.2968 7.60666C20.5286 6.62257 20.2084 5.69548 20.1033 4.73462C20.0423 4.17787 19.9888 3.57961 19.5972 3.1989C19.0248 2.64253 18.2036 2.47372 17.7957 2.50049Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
				{__("Market")}
			</a>
		{/if}

		{if $user->_data['can_schedule_posts']}
			<a class='dropdown-item {if $page == "index" && $view == "scheduled"}active {/if}' href="{$system['system_url']}/scheduled">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M16 2V6M8 2V6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M21 12C21 8.22876 21 6.34315 19.8284 5.17157C18.6569 4 16.7712 4 13 4H11C7.22876 4 5.34315 4 4.17157 5.17157C3 6.34315 3 8.22876 3 12V14C3 17.7712 3 19.6569 4.17157 20.8284C5.34315 22 7.22876 22 11 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M3 10H21" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M18.2671 18.7011L17 18V16.2668M21 18C21 20.2091 19.2091 22 17 22C14.7909 22 13 20.2091 13 18C13 15.7909 14.7909 14 17 14C19.2091 14 21 15.7909 21 18Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg>
				{__("Scheduled")}
			</a>
		{/if}

		{if $user->_data['can_write_blogs']}
			<a class='dropdown-item {if $page == "index" && $view == "blogs"}active {/if}' href="{$system['system_url']}/my/blogs">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.7502 11V10C19.7502 6.22876 19.7502 4.34315 18.5786 3.17157C17.407 2 15.5214 2 11.7502 2H10.7503C6.97907 2 5.09346 2 3.92189 3.17156C2.75032 4.34312 2.7503 6.22872 2.75027 9.99993L2.75024 14C2.7502 17.7712 2.75019 19.6568 3.92172 20.8284C5.09329 21.9999 6.97897 22 10.7502 22" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M7.25024 7H15.2502M7.25024 12H15.2502" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M13.2502 20.8268V22H14.4236C14.833 22 15.0377 22 15.2217 21.9238C15.4058 21.8475 15.5505 21.7028 15.84 21.4134L20.6636 16.5894C20.9366 16.3164 21.0731 16.1799 21.1461 16.0327C21.285 15.7525 21.285 15.4236 21.1461 15.1434C21.0731 14.9961 20.9366 14.8596 20.6636 14.5866C20.3905 14.3136 20.254 14.1771 20.1067 14.1041C19.8265 13.9653 19.4975 13.9653 19.2173 14.1041C19.0701 14.1771 18.9335 14.3136 18.6605 14.5866L18.6605 14.5866L13.8369 19.4106C13.5474 19.7 13.4027 19.8447 13.3265 20.0287C13.2502 20.2128 13.2502 20.4174 13.2502 20.8268Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /></svg>
				{__("My Blogs")}
			</a>
		{/if}
		{if $user->_data['can_sell_products']}
			<a class='dropdown-item {if $page == "index" && $view == "products"}active {/if}' href="{$system['system_url']}/my/products">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3 2H4.30116C5.48672 2 6.0795 2 6.4814 2.37142C6.88331 2.74285 6.96165 3.36307 7.11834 4.60351L8.24573 13.5287C8.45464 15.1826 8.5591 16.0095 9.09497 16.5048C9.63085 17 10.4212 17 12.002 17H22" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><circle cx="11.5" cy="19.5" r="1.5" stroke="currentColor" stroke-width="1.75" /><circle cx="18.5" cy="19.5" r="1.5" stroke="currentColor" stroke-width="1.75" /><path d="M18 14H16C14.1144 14 13.1716 14 12.5858 13.4142C12 12.8284 12 11.8856 12 10V8C12 6.11438 12 5.17157 12.5858 4.58579C13.1716 4 14.1144 4 16 4H18C19.8856 4 20.8284 4 21.4142 4.58579C22 5.17157 22 6.11438 22 8V10C22 11.8856 22 12.8284 21.4142 13.4142C20.8284 14 19.8856 14 18 14Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M16.5 7L17.5 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
				{__("My Products")}
			</a>
		{/if}
		{if $user->_data['can_raise_funding']}
			<a class='dropdown-item {if $page == "index" && $view == "funding"}active {/if}' href="{$system['system_url']}/my/funding">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.5 16V12.0059C19.5 10.5195 19.5 9.77627 19.2444 9.09603C18.9888 8.4158 18.4994 7.85648 17.5206 6.73784L16 5H8L6.47939 6.73784C5.50058 7.85648 5.01118 8.4158 4.75559 9.09603C4.5 9.77627 4.5 10.5195 4.5 12.0059V16C4.5 18.8284 4.5 20.2426 5.37868 21.1213C6.25736 22 7.67157 22 10.5 22H13.5C16.3284 22 17.7426 22 18.6213 21.1213C19.5 20.2426 19.5 18.8284 19.5 16Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M9.5 15.6831C9.5 16.9125 11.3539 17.9204 13.1325 17.3553C14.9112 16.7901 14.6497 15.1248 14.0463 14.4708C13.4429 13.8169 12.555 13.9265 11.5399 13.8751C9.25873 13.7594 9.09769 11.5722 10.9447 10.7069C12.2997 10.072 14.0379 10.8862 14.2381 12M11.971 9.5V10.4777M11.971 17.7204V18.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M7.5 2H16.5C16.9659 2 17.1989 2 17.3827 2.07612C17.6277 2.17761 17.8224 2.37229 17.9239 2.61732C18 2.80109 18 3.03406 18 3.5C18 3.96594 18 4.19891 17.9239 4.38268C17.8224 4.62771 17.6277 4.82239 17.3827 4.92388C17.1989 5 16.9659 5 16.5 5H7.5C7.03406 5 6.80109 5 6.61732 4.92388C6.37229 4.82239 6.17761 4.62771 6.07612 4.38268C6 4.19891 6 3.96594 6 3.5C6 3.03406 6 2.80109 6.07612 2.61732C6.17761 2.37229 6.37229 2.17761 6.61732 2.07612C6.80109 2 7.03406 2 7.5 2Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
				{__("My Funding")}
			</a>
		{/if}

		{if $user->_data['can_create_offers']}
			<a class='dropdown-item {if $page == "index" && $view == "offers"}active {/if}' href="{$system['system_url']}/my/offers">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M10.9961 10H11.0111M10.9998 16H11.0148" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /><path d="M7 13H15" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><circle cx="1.5" cy="1.5" r="1.5" transform="matrix(1 0 0 -1 16 8)" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M2.77423 11.1439C1.77108 12.2643 1.7495 13.9546 2.67016 15.1437C4.49711 17.5033 6.49674 19.5029 8.85633 21.3298C10.0454 22.2505 11.7357 22.2289 12.8561 21.2258C15.8979 18.5022 18.6835 15.6559 21.3719 12.5279C21.6377 12.2187 21.8039 11.8397 21.8412 11.4336C22.0062 9.63798 22.3452 4.46467 20.9403 3.05974C19.5353 1.65481 14.362 1.99377 12.5664 2.15876C12.1603 2.19608 11.7813 2.36233 11.472 2.62811C8.34412 5.31646 5.49781 8.10211 2.77423 11.1439Z" stroke="currentColor" stroke-width="1.75" /></svg>
				{__("My Offers")}
			</a>
		{/if}

		{if $user->_data['can_create_jobs']}
			<a class='dropdown-item {if $page == "index" && $view == "jobs"}active {/if}' href="{$system['system_url']}/my/jobs">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M6.5 9H5.5M10.5 9H9.5M6.5 6H5.5M10.5 6H9.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"></path><path d="M18.5 15H17.5M18.5 11H17.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"></path><path d="M14 8V22H18C19.8856 22 20.8284 22 21.4142 21.4142C22 20.8284 22 19.8856 22 18V12C22 10.1144 22 9.17157 21.4142 8.58579C20.8284 8 19.8856 8 18 8H14ZM14 8C14 5.17157 14 3.75736 13.1213 2.87868C12.2426 2 10.8284 2 8 2C5.17157 2 3.75736 2 2.87868 2.87868C2 3.75736 2 5.17157 2 8V10" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M8.02485 13.9545C8.02485 15.0583 7.12945 15.953 6.02491 15.953C4.92038 15.953 4.02497 15.0583 4.02497 13.9545C4.02497 12.8508 4.92038 11.9561 6.02491 11.9561C7.12945 11.9561 8.02485 12.8508 8.02485 13.9545Z" stroke="currentColor" stroke-width="2" stroke-linecap="round"></path><path d="M2.06982 20.2101C3.12817 18.582 4.80886 17.9718 6.02491 17.973C7.24097 17.9743 8.8724 18.582 9.93075 20.2101C9.99917 20.3154 10.018 20.445 9.95628 20.5544C9.70877 20.993 8.94028 21.8633 8.38522 21.9223C7.74746 21.9901 6.07914 21.9996 6.0262 21.9999C5.97322 21.9996 4.2534 21.9901 3.61535 21.9223C3.06029 21.8633 2.2918 20.993 2.04429 20.5544C1.98254 20.445 2.00139 20.3154 2.06982 20.2101Z" stroke="currentColor" stroke-width="2" stroke-linecap="round"></path></svg>
				{__("My Jobs")}
			</a>
		{/if}

		{if $user->_data['can_create_courses']}
			<a class='dropdown-item {if $page == "index" && $view == "courses"}active {/if}' href="{$system['system_url']}/my/courses">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7.5 4.94531H16C16.8284 4.94531 17.5 5.61688 17.5 6.44531V7.94531" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M15 12.9453H9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M12 16.9453H9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M18.497 2L6.30767 2.00002C5.81071 2.00002 5.30241 2.07294 4.9007 2.36782C3.62698 3.30279 2.64539 5.38801 4.62764 7.2706C5.18421 7.7992 5.96217 7.99082 6.72692 7.99082H18.2835C19.077 7.99082 20.5 8.10439 20.5 10.5273V17.9812C20.5 20.2007 18.7103 22 16.5026 22H7.47246C5.26886 22 3.66619 20.4426 3.53959 18.0713L3.5061 5.16638" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
				{__("My Courses")}
			</a>
		{/if}

		{if $user->_logged_in}
			{if $system['memories_enabled']}
				<a class='dropdown-item {if $page == "index" && $view == "memories"}active {/if}' href="{$system['system_url']}/memories">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M5.04798 8.60657L2.53784 8.45376C4.33712 3.70477 9.503 0.999914 14.5396 2.34474C19.904 3.77711 23.0904 9.26107 21.6565 14.5935C20.2227 19.926 14.7116 23.0876 9.3472 21.6553C5.36419 20.5917 2.58192 17.2946 2 13.4844" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M12 8V12L14 14" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
					{__("Memories")}
				</a>
			{/if}
		
			{if $user->_data['can_create_ads']}
				<a class='dropdown-item {if $page == "ads"}active {/if}' href="{$system['system_url']}/ads">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M14.9263 2.91103L8.27352 6.10452C7.76151 6.35029 7.21443 6.41187 6.65675 6.28693C6.29177 6.20517 6.10926 6.16429 5.9623 6.14751C4.13743 5.93912 3 7.38342 3 9.04427V9.95573C3 11.6166 4.13743 13.0609 5.9623 12.8525C6.10926 12.8357 6.29178 12.7948 6.65675 12.7131C7.21443 12.5881 7.76151 12.6497 8.27352 12.8955L14.9263 16.089C16.4534 16.8221 17.217 17.1886 18.0684 16.9029C18.9197 16.6172 19.2119 16.0041 19.7964 14.778C21.4012 11.4112 21.4012 7.58885 19.7964 4.22196C19.2119 2.99586 18.9197 2.38281 18.0684 2.0971C17.217 1.8114 16.4534 2.17794 14.9263 2.91103Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M11.4581 20.7709L9.96674 22C6.60515 19.3339 7.01583 18.0625 7.01583 13H8.14966C8.60978 15.8609 9.69512 17.216 11.1927 18.197C12.1152 18.8012 12.3054 20.0725 11.4581 20.7709Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M7.5 12.5V6.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
					{__("Ads Manager")}
				</a>
			{/if}
			{if $system['packages_enabled']}
				<a class='dropdown-item {if $page == "index" && $view == "boosted_posts"}active {/if}' href="{$system['system_url']}/boosted/posts">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M5.22576 11.3294L12.224 2.34651C12.7713 1.64397 13.7972 2.08124 13.7972 3.01707V9.96994C13.7972 10.5305 14.1995 10.985 14.6958 10.985H18.0996C18.8729 10.985 19.2851 12.0149 18.7742 12.6706L11.776 21.6535C11.2287 22.356 10.2028 21.9188 10.2028 20.9829V14.0301C10.2028 13.4695 9.80048 13.015 9.3042 13.015H5.90035C5.12711 13.015 4.71494 11.9851 5.22576 11.3294Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
					{__("Boosted")}
				</a>
			{/if}
		{/if}
		
		{if $user->_logged_in}
			<a class='dropdown-item {if $page == "people"}active {/if}' href="{$system['system_url']}/people">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7.78256 17.1112C6.68218 17.743 3.79706 19.0331 5.55429 20.6474C6.41269 21.436 7.36872 22 8.57068 22H15.4293C16.6313 22 17.5873 21.436 18.4457 20.6474C20.2029 19.0331 17.3178 17.743 16.2174 17.1112C13.6371 15.6296 10.3629 15.6296 7.78256 17.1112Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M15.5 10C15.5 11.933 13.933 13.5 12 13.5C10.067 13.5 8.5 11.933 8.5 10C8.5 8.067 10.067 6.5 12 6.5C13.933 6.5 15.5 8.067 15.5 10Z" stroke="currentColor" stroke-width="1.75" /><path d="M2.854 16C2.30501 14.7664 2 13.401 2 11.9646C2 6.46129 6.47715 2 12 2C17.5228 2 22 6.46129 22 11.9646C22 13.401 21.695 14.7664 21.146 16" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
				{__("People")}
			</a>
		{/if}

		{if $system['events_enabled']}
			<a class='dropdown-item {if $page == "events"}active {/if}' href="{$system['system_url']}/events">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M18 2V4M6 2V4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M11.9955 13H12.0045M11.9955 17H12.0045M15.991 13H16M8 13H8.00897M8 17H8.00897" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M3.5 8H20.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M2.5 12.2432C2.5 7.88594 2.5 5.70728 3.75212 4.35364C5.00424 3 7.01949 3 11.05 3H12.95C16.9805 3 18.9958 3 20.2479 4.35364C21.5 5.70728 21.5 7.88594 21.5 12.2432V12.7568C21.5 17.1141 21.5 19.2927 20.2479 20.6464C18.9958 22 16.9805 22 12.95 22H11.05C7.01949 22 5.00424 22 3.75212 20.6464C2.5 19.2927 2.5 17.1141 2.5 12.7568V12.2432Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M3 8H21" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
				{__("Events")}
			</a>
		{/if}
	 
		{if $user->_logged_in}
			{if $system['watch_enabled']}
				<a class='dropdown-item {if $page == "index" && $view == "watch"}active {/if}' href="{$system['system_url']}/watch">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M11 8L13 8" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M2 11C2 7.70017 2 6.05025 3.02513 5.02513C4.05025 4 5.70017 4 9 4H10C13.2998 4 14.9497 4 15.9749 5.02513C17 6.05025 17 7.70017 17 11V13C17 16.2998 17 17.9497 15.9749 18.9749C14.9497 20 13.2998 20 10 20H9C5.70017 20 4.05025 20 3.02513 18.9749C2 17.9497 2 16.2998 2 13V11Z" stroke="currentColor" stroke-width="1.75"></path><path d="M17 8.90585L17.1259 8.80196C19.2417 7.05623 20.2996 6.18336 21.1498 6.60482C22 7.02628 22 8.42355 22 11.2181V12.7819C22 15.5765 22 16.9737 21.1498 17.3952C20.2996 17.8166 19.2417 16.9438 17.1259 15.198L17 15.0941" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
					{__("Watch")}
				</a>
			{/if}
		{/if}

		{if $system['blogs_enabled']}
			<a class='dropdown-item {if $page == "blogs"}active {/if}' href="{$system['system_url']}/blogs">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M10.5 8H18.5M10.5 12H13M18.5 12H16M10.5 16H13M18.5 16H16" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M7 7.5H6C4.11438 7.5 3.17157 7.5 2.58579 8.08579C2 8.67157 2 9.61438 2 11.5V18C2 19.3807 3.11929 20.5 4.5 20.5C5.88071 20.5 7 19.3807 7 18V7.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M16 3.5H11C10.07 3.5 9.60504 3.5 9.22354 3.60222C8.18827 3.87962 7.37962 4.68827 7.10222 5.72354C7 6.10504 7 6.57003 7 7.5V18C7 19.3807 5.88071 20.5 4.5 20.5H16C18.8284 20.5 20.2426 20.5 21.1213 19.6213C22 18.7426 22 17.3284 22 14.5V9.5C22 6.67157 22 5.25736 21.1213 4.37868C20.2426 3.5 18.8284 3.5 16 3.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
				{__("Blogs")}
			</a>
		{/if}

		{if $system['funding_enabled']}
			<a class='dropdown-item {if $page == "funding"}active {/if}' href="{$system['system_url']}/funding">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M8.39559 2.55196C9.8705 1.63811 11.1578 2.00638 11.9311 2.59299C12.2482 2.83351 12.4067 2.95378 12.5 2.95378C12.5933 2.95378 12.7518 2.83351 13.0689 2.59299C13.8422 2.00638 15.1295 1.63811 16.6044 2.55196C18.5401 3.75128 18.9781 7.7079 14.5133 11.046C13.6629 11.6818 13.2377 11.9996 12.5 11.9996C11.7623 11.9996 11.3371 11.6818 10.4867 11.046C6.02195 7.7079 6.45994 3.75128 8.39559 2.55196Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M4 14H6.39482C6.68897 14 6.97908 14.0663 7.24217 14.1936L9.28415 15.1816C9.54724 15.3089 9.83735 15.3751 10.1315 15.3751H11.1741C12.1825 15.3751 13 16.1662 13 17.142C13 17.1814 12.973 17.2161 12.9338 17.2269L10.3929 17.9295C9.93707 18.0555 9.449 18.0116 9.025 17.8064L6.84211 16.7503" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M13 16.5L17.5928 15.0889C18.407 14.8352 19.2871 15.136 19.7971 15.8423C20.1659 16.3529 20.0157 17.0842 19.4785 17.3942L11.9629 21.7305C11.4849 22.0063 10.9209 22.0736 10.3952 21.9176L4 20.0199" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
				{__("Funding")}
			</a>
		{/if}

		{if $system['offers_enabled']}
			<a class='dropdown-item {if $page == "offers"}active {/if}' href="{$system['system_url']}/offers">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7.83152 21.3478L7.31312 20.6576C6.85764 20.0511 5.89044 20.1 5.50569 20.7488C4.96572 21.6595 3.5 21.2966 3.5 20.2523V3.74775C3.5 2.7034 4.96572 2.3405 5.50569 3.25115C5.89044 3.90003 6.85764 3.94888 7.31312 3.34244L7.83152 2.65222C8.48467 1.78259 9.84866 1.78259 10.5018 2.65222L10.5833 2.76076C11.2764 3.68348 12.7236 3.68348 13.4167 2.76076L13.4982 2.65222C14.1513 1.78259 15.5153 1.78259 16.1685 2.65222L16.6869 3.34244C17.1424 3.94888 18.1096 3.90003 18.4943 3.25115C19.0343 2.3405 20.5 2.7034 20.5 3.74774V20.2523C20.5 21.2966 19.0343 21.6595 18.4943 20.7488C18.1096 20.1 17.1424 20.0511 16.6869 20.6576L16.1685 21.3478C15.5153 22.2174 14.1513 22.2174 13.4982 21.3478L13.4167 21.2392C12.7236 20.3165 11.2764 20.3165 10.5833 21.2392L10.5018 21.3478C9.84866 22.2174 8.48467 22.2174 7.83152 21.3478Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M15 9L9 15" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M15 15H14.991M9.00897 9H9" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg>
				{__("Offers")}
			</a>
		{/if}

		{if $system['jobs_enabled']}
			<a class='dropdown-item {if $page == "jobs"}active {/if}' href="{$system['system_url']}/jobs">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M3 11L3.15288 14.2269C3.31714 17.6686 3.39927 19.3894 4.55885 20.4447C5.71843 21.5 7.52716 21.5 11.1446 21.5H12.8554C16.4728 21.5 18.2816 21.5 19.4412 20.4447C20.6007 19.3894 20.6829 17.6686 20.8471 14.2269L21 11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M2.84718 10.4431C4.54648 13.6744 8.3792 15 12 15C15.6208 15 19.4535 13.6744 21.1528 10.4431C21.964 8.90056 21.3498 6 19.352 6H4.648C2.65023 6 2.03603 8.90056 2.84718 10.4431Z" stroke="currentColor" stroke-width="1.75"></path><path d="M11.9999 11H12.0089" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M15.9999 6L15.9116 5.69094C15.4716 4.15089 15.2516 3.38087 14.7278 2.94043C14.204 2.5 13.5083 2.5 12.1168 2.5H11.8829C10.4915 2.5 9.79575 2.5 9.27198 2.94043C8.7482 3.38087 8.52819 4.15089 8.08818 5.69094L7.99988 6" stroke="currentColor" stroke-width="1.75"></path></svg>
				{__("Jobs")}
			</a>
		{/if}

		{if $system['courses_enabled']}
			<a class='dropdown-item {if $page == "courses"}active {/if}' href="{$system['system_url']}/courses">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7.50586 4.94531H16.0059C16.8343 4.94531 17.5059 5.61688 17.5059 6.44531V7.94531" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M15.0059 17.9453L14.1488 15.9453M14.1488 15.9453L12.5983 12.3277C12.4992 12.0962 12.2653 11.9453 12.0059 11.9453C11.7465 11.9453 11.5126 12.0962 11.4135 12.3277L9.863 15.9453M14.1488 15.9453H9.863M9.00586 17.9453L9.863 15.9453" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M18.497 2L6.30767 2.00002C5.81071 2.00002 5.30241 2.07294 4.9007 2.36782C3.62698 3.30279 2.64539 5.38801 4.62764 7.2706C5.18421 7.7992 5.96217 7.99082 6.72692 7.99082H18.2835C19.077 7.99082 20.5 8.10439 20.5 10.5273V17.9812C20.5 20.2007 18.7103 22 16.5026 22H7.47246C5.26886 22 3.66619 20.4426 3.53959 18.0713L3.5061 5.16638" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
				{__("Courses")}
			</a>
		{/if}

		{if $system['forums_enabled']}
			<a class='dropdown-item {if $page == "forums"}active {/if}' href="{$system['system_url']}/forums">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M7.79098 19C7.46464 18.8681 7.28441 18.8042 7.18359 18.8166C7.05968 18.8317 6.8799 18.9637 6.52034 19.2275C5.88637 19.6928 5.0877 20.027 3.90328 19.9983C3.30437 19.9838 3.00491 19.9765 2.87085 19.749C2.73679 19.5216 2.90376 19.2067 3.23769 18.5769C3.70083 17.7034 3.99427 16.7035 3.54963 15.9023C2.78384 14.7578 2.13336 13.4025 2.0383 11.9387C1.98723 11.1522 1.98723 10.3377 2.0383 9.55121C2.29929 5.53215 5.47105 2.33076 9.45292 2.06733C10.8086 1.97765 12.2269 1.97746 13.5854 2.06733C17.5503 2.32964 20.712 5.50498 20.9965 9.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M14.6976 21.6471C12.1878 21.4862 10.1886 19.5298 10.0241 17.0737C9.99195 16.593 9.99195 16.0953 10.0241 15.6146C10.1886 13.1585 12.1878 11.2021 14.6976 11.0411C15.5539 10.9862 16.4479 10.9863 17.3024 11.0411C19.8122 11.2021 21.8114 13.1585 21.9759 15.6146C22.008 16.0953 22.008 16.593 21.9759 17.0737C21.9159 17.9682 21.5059 18.7965 21.0233 19.4958C20.743 19.9854 20.928 20.5965 21.2199 21.1303C21.4304 21.5152 21.5356 21.7076 21.4511 21.8466C21.3666 21.9857 21.1778 21.9901 20.8003 21.999C20.0538 22.0165 19.5504 21.8123 19.1508 21.5279C18.9242 21.3667 18.8108 21.2861 18.7327 21.2768C18.6546 21.2675 18.5009 21.3286 18.1936 21.4507C17.9174 21.5605 17.5966 21.6283 17.3024 21.6471C16.4479 21.702 15.5539 21.7021 14.6976 21.6471Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /></svg>
				{__("Forums")}
			</a>
		{/if}

		{if $system['movies_enabled']}
			<a class='dropdown-item {if $page == "movies"}active {/if}' href="{$system['system_url']}/movies">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75" /><path d="M2.5 7H21.5" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M2.5 17H21.5" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" /><path d="M12 17L12 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M8 7L8 3M16 7L16 3" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M8 21L8 17M16 21L16 17" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
				{__("Movies")}
			</a>
		{/if}

		{if $system['games_enabled']}
			<a class='dropdown-item {if $page == "games"}active {/if}' href="{$system['system_url']}/games">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M2.00825 15.8092C2.23114 12.3161 2.88737 9.7599 3.44345 8.27511C3.72419 7.5255 4.32818 6.96728 5.10145 6.78021C9.40147 5.73993 14.5986 5.73993 18.8986 6.78021C19.6719 6.96728 20.2759 7.5255 20.5566 8.27511C21.1127 9.7599 21.7689 12.3161 21.9918 15.8092C22.1251 17.8989 20.6148 19.0503 18.9429 19.8925C17.878 20.4289 17.0591 18.8457 16.5155 17.6203C16.2185 16.9508 15.5667 16.5356 14.8281 16.5356H9.17196C8.43331 16.5356 7.78158 16.9508 7.48456 17.6203C6.94089 18.8457 6.122 20.4289 5.05711 19.8925C3.40215 19.0588 1.87384 17.9157 2.00825 15.8092Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M5 4.5L6.96285 4M19 4.5L17 4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M9 13L7.5 11.5M7.5 11.5L6 10M7.5 11.5L6 13M7.5 11.5L9 10" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M15.9881 10H15.9971" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M17.9881 13H17.9971" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
				{__("Games")}
			</a>
		{/if}
		
		{if $system['merits_enabled']}
			<a class='dropdown-item {if $page == "merits"}active {/if}' href="{$system['system_url']}/merits">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12Z" stroke="currentColor" stroke-width="1.75"></path><path d="M12.8638 7.72209L13.7437 9.49644C13.8637 9.74344 14.1837 9.98035 14.4536 10.0257L16.0485 10.2929C17.0684 10.4643 17.3083 11.2103 16.5734 11.9462L15.3335 13.1964C15.1236 13.4081 15.0086 13.8164 15.0736 14.1087L15.4285 15.6562C15.7085 16.8812 15.0636 17.355 13.9887 16.7148L12.4939 15.8226C12.2239 15.6613 11.7789 15.6613 11.504 15.8226L10.0091 16.7148C8.93925 17.355 8.28932 16.8761 8.56929 15.6562L8.92425 14.1087C8.98925 13.8164 8.87426 13.4081 8.66428 13.1964L7.42442 11.9462C6.6945 11.2103 6.92947 10.4643 7.94936 10.2929L9.54419 10.0257C9.80916 9.98035 10.1291 9.74344 10.2491 9.49644L11.129 7.72209C11.609 6.7593 12.3889 6.7593 12.8638 7.72209Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
				{__("Merits")}
			</a>
		{/if}
	  
		{if $static_pages}
			{foreach $static_pages as $static_page}
				{if $static_page['page_in_sidebar']}
					<a class='dropdown-item {if $page == "static_page" && $static_page['page_id'] == $static_page_id}active {/if}' href="{$static_page['url']}">
						<img width="20" height="20" class="flex-0" src="{$static_page['page_icon']}">
						{__($static_page['page_title'])}
					</a>
				{/if}
			{/foreach}
		{/if}
	</div>
</div>