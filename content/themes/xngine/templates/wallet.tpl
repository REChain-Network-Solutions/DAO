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
		<div class="position-sticky x_top_posts">
			<div class="headline-font fw-semibold side_widget_title p-3">
				{__("Wallet")}
			</div>
			
			<div class="d-flex align-items-center justify-content-center">
				<div {if $view == ""}class="active fw-semibold"{/if}>
					<a href="{$system['system_url']}/wallet" class="body-color side_item_hover w-100 text-center d-block">
						<span class="position-relative d-inline-block py-3">{__("Wallet")}</span>
					</a>
				</div>
				{if $system['wallet_withdrawal_enabled']}
					<div {if $view == "payments"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/wallet/payments" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Payments")}</span>
						</a>
					</div>
				{/if}
			</div>
		</div>

		{if $view == ""}

			<!-- wallet -->
			<div class="p-3">
				{if $wallet_transfer_amount}
					<div class="alert alert-success mb20">
						<i class="fas fa-check-circle mr5"></i>
						{__("Your")} <span class="badge rounded-pill bg-secondary">{print_money($wallet_transfer_amount|number_format:2)}</span> {__("transfer transaction successfuly sent")}
					</div>
				{/if}
				{if $wallet_replenish_amount}
					<div class="alert alert-success mb20">
						<i class="fas fa-check-circle mr5"></i>
						{__("Congratulation! Your wallet credit replenished successfully with")} <span class="badge rounded-pill bg-secondary">{print_money($wallet_replenish_amount|number_format:2)}</span>
					</div>
				{/if}
				{if $wallet_withdraw_affiliates_amount}
					<div class="alert alert-success mb20">
						<i class="fas fa-check-circle mr5"></i>
						{__("Congratulation! Your wallet credit replenished successfully with")} <span class="badge rounded-pill bg-secondary">{print_money($wallet_withdraw_affiliates_amount|number_format:2)}</span> {__("from your affiliates credit")}
					</div>
				{/if}
				{if $wallet_withdraw_points_amount}
					<div class="alert alert-success mb20">
						<i class="fas fa-check-circle mr5"></i>
						{__("Congratulation! Your wallet credit replenished successfully with")} <span class="badge rounded-pill bg-secondary">{print_money($wallet_withdraw_points_amount|number_format:2)}</span> {__("from your points credit")}
					</div>
				{/if}
				{if $wallet_withdraw_market_amount}
					<div class="alert alert-success mb20">
						<i class="fas fa-check-circle mr5"></i>
						{__("Congratulation! Your wallet credit replenished successfully with")} <span class="badge rounded-pill bg-secondary">{print_money($wallet_withdraw_market_amount|number_format:2)}</span> {__("from your market credit")}
					</div>
				{/if}
				{if $wallet_withdraw_funding_amount}
					<div class="alert alert-success mb20">
						<i class="fas fa-check-circle mr5"></i>
						{__("Congratulation! Your wallet credit replenished successfully with")} <span class="badge rounded-pill bg-secondary">{print_money($wallet_withdraw_funding_amount|number_format:2)}</span> {__("from your funding credit")}
					</div>
				{/if}
				{if $wallet_withdraw_monetization_amount}
					<div class="alert alert-success mb20">
						<i class="fas fa-check-circle mr5"></i>
						{__("Congratulation! Your wallet credit replenished successfully with")} <span class="badge rounded-pill bg-secondary">{print_money($wallet_withdraw_monetization_amount|number_format:2)}</span> {__("from your monetization credit")}
					</div>
				{/if}
				{if $wallet_package_payment_amount}
					<div class="alert alert-success mb20">
						<i class="fas fa-check-circle mr5"></i>
						{__("Your")} <span class="badge rounded-pill bg-secondary">{print_money($wallet_package_payment_amount|number_format:2)}</span> {__("payment transaction successfuly done")}
					</div>
				{/if}
				{if $wallet_monetization_payment_amount}
					<div class="alert alert-success mb20">
						<i class="fas fa-check-circle mr5"></i>
						{__("Your")} <span class="badge rounded-pill bg-secondary">{print_money($wallet_monetization_payment_amount|number_format:2)}</span> {__("payment transaction successfuly done")}
					</div>
				{/if}
				{if $wallet_paid_post_amount}
					<div class="alert alert-success mb20">
						<i class="fas fa-check-circle mr5"></i>
						{__("Your")} <span class="badge rounded-pill bg-secondary">{print_money($wallet_paid_post_amount|number_format:2)}</span> {__("payment transaction successfuly done")}
					</div>
				{/if}
				{if $wallet_donate_amount}
					<div class="alert alert-success mb20">
						<i class="fas fa-check-circle mr5"></i>
						{__("Your")} <span class="badge rounded-pill bg-secondary">{print_money($wallet_donate_amount|number_format:2)}</span> {__("payment transaction successfuly done")}
					</div>
				{/if}
				{if $wallet_marketplace_amount}
					<div class="alert alert-success mb20">
						<i class="fas fa-check-circle mr5"></i>
						{__("Your")} <span class="badge rounded-pill bg-secondary">{print_money($wallet_marketplace_amount|number_format:2)}</span> {__("payment transaction successfuly done")}
					</div>
				{/if}
				
				<div class="d-flex align-items-center justify-content-between mb-1 flex-wrap gap-2">
					<div class="heading-small">
						{__("Your Credit")}
					</div>
					{if $system['wallet_transfer_enabled']}
						<button class="btn btn-sm btn-success" data-toggle="modal" data-url="#wallet-transfer">
							{__("Send Money")}
						</button>
					{/if}
				</div>
                <div class="display-4 fw-medium mb-4">
					{print_money($user->_data['user_wallet_balance']|number_format:2)}
				</div>

				<!-- send & recieve money -->
                <div class="row">
					<div class="col-md-6 col-lg-4 mb-3">
						<button class="btn btn-gray w-100" data-toggle="modal" data-url="#wallet-replenish">
							<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M2.375 5.77614C2.375 4.556 3.14362 3.38901 4.41249 3.01245C6.36472 2.4331 9.91912 1.58254 14.7933 1.16863C15.6175 1.09642 17.0516 0.970784 18.012 2.14128C18.7163 2.99967 18.8804 4.17689 18.8749 5.16205C18.8719 5.67955 18.8215 6.19671 18.7467 6.67504C18.7022 6.95936 18.6799 7.10152 18.7413 7.19734C18.8027 7.29316 18.9455 7.33356 19.2311 7.41436C19.876 7.5968 20.4347 7.87644 20.8679 8.34366C21.4237 8.94312 21.6584 9.69115 21.7684 10.5743C21.875 11.4308 21.875 12.5211 21.875 13.88V16.0044C21.875 17.398 21.875 18.5269 21.744 19.4161C21.6068 20.3471 21.3128 21.1219 20.6472 21.7301C19.989 22.3316 19.2223 22.5602 18.3193 22.6135C17.467 22.6639 16.3513 22.5549 15.0629 22.4289C13.4935 22.2756 11.81 22.0529 10.1096 21.7359C9.87886 21.6929 9.76349 21.6713 9.69424 21.588C9.625 21.5047 9.625 21.3863 9.625 21.1496V20.9767C9.625 20.6939 9.625 20.5524 9.71287 20.4646C9.80074 20.3767 9.94216 20.3767 10.225 20.3767H11.125C12.5057 20.3767 13.625 19.2574 13.625 17.8767C13.625 16.496 12.5057 15.3767 11.125 15.3767H10.225C9.94216 15.3767 9.80074 15.3767 9.71287 15.2888C9.625 15.201 9.625 15.0596 9.625 14.7767V13.8767C9.625 12.496 8.50571 11.3767 7.125 11.3767C5.74429 11.3767 4.625 12.496 4.625 13.8767V14.7767C4.625 15.0596 4.625 15.201 4.53713 15.2888C4.44926 15.3767 4.30784 15.3767 4.025 15.3767H3.125C3.03872 15.3767 2.95346 15.3811 2.86944 15.3896L2.86938 15.3896C2.73995 15.4028 2.67523 15.4093 2.64516 15.4063C2.49736 15.3915 2.41065 15.3132 2.38103 15.1676C2.375 15.138 2.375 15.0873 2.375 14.9859V5.77614ZM15.9665 3.02636C15.683 2.98142 15.3467 3.0034 14.8662 3.04421C10.1434 3.44528 6.82086 4.2587 4.98308 4.80409C4.90099 4.82845 4.82174 4.86641 4.7483 4.91634C4.5771 5.03275 4.49149 5.09095 4.52899 5.28491C4.56649 5.47887 4.71175 5.51061 5.00227 5.57411C7.35233 6.08772 10.9667 6.63928 15.1809 6.9313C15.5299 6.95548 15.8647 6.97867 16.1841 7.0024C16.4358 7.0211 16.5617 7.03046 16.6531 6.95899C16.7444 6.88753 16.7647 6.76878 16.8053 6.53129C16.8799 6.09453 16.9314 5.6178 16.934 5.1518C16.9389 4.2894 16.7748 3.65138 16.4907 3.30522C16.3563 3.14134 16.2034 3.06392 15.9665 3.02636ZM16.625 12.875C17.7296 12.875 18.625 13.7704 18.625 14.875C18.625 15.9796 17.7296 16.875 16.625 16.875C15.5204 16.875 14.625 15.9796 14.625 14.875C14.625 13.7704 15.5204 12.875 16.625 12.875Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M7.125 12.875C7.67728 12.875 8.125 13.3227 8.125 13.875L8.125 16.875H11.125C11.6773 16.875 12.125 17.3227 12.125 17.875C12.125 18.4273 11.6773 18.875 11.125 18.875H8.125V21.875C8.125 22.4273 7.67729 22.875 7.125 22.875C6.57272 22.875 6.125 22.4273 6.125 21.875V18.875H3.125C2.57272 18.875 2.125 18.4273 2.125 17.875C2.125 17.3227 2.57272 16.875 3.125 16.875H6.125L6.125 13.875C6.125 13.3227 6.57272 12.875 7.125 12.875Z" fill="currentColor"/></svg>
							{__("Replenish Credit")}
						</button>
					</div>
					
					{if $system['affiliates_enabled'] && $system['affiliates_money_transfer_enabled']}
						<div class="col-md-6 col-lg-4 mb-3">
							<button class="btn btn-gray w-100" data-toggle="modal" data-url="#wallet-withdraw-affiliates">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M7.50337 13.1474C7.21627 13.3013 6.93491 13.4624 6.72814 13.5903C6.23354 13.8795 5.30191 14.4241 4.62889 15.1082C4.19456 15.5497 3.6236 16.2837 3.51733 17.2933C3.48451 17.6051 3.49934 17.9036 3.55304 18.1871C3.60678 18.4709 3.63366 18.6128 3.56186 18.6872C3.49006 18.7616 3.37042 18.7434 3.13114 18.707C2.10732 18.5512 1.41543 17.9931 0.847642 17.3845C0.423078 16.9295 0.203787 16.4061 0.258175 15.8464C0.30924 15.3208 0.59019 14.8976 0.871177 14.5882C1.31466 14.0998 1.96834 13.686 2.35981 13.4381C2.44345 13.3852 2.51514 13.3398 2.57023 13.3029C4.04765 12.3132 5.8097 12.0212 7.45505 12.427C7.84296 12.5226 8.03691 12.5704 8.05406 12.7068C8.0712 12.8431 7.88193 12.9445 7.50337 13.1474Z" fill="currentColor"></path><path d="M6.48741 5.28631C6.67712 5.31484 6.77197 5.3291 6.8207 5.4079C6.86944 5.48671 6.83547 5.59136 6.76754 5.80068C6.59386 6.33583 6.5 6.90695 6.5 7.5C6.5 8.73995 6.91032 9.88407 7.60259 10.804C7.73465 10.9795 7.80068 11.0672 7.78033 11.1575C7.75999 11.2478 7.67509 11.2922 7.5053 11.3811C7.05526 11.6167 6.5432 11.75 6 11.75C4.20507 11.75 2.75 10.2949 2.75 8.5C2.75 6.70507 4.20507 5.25 6 5.25C6.16566 5.25 6.32842 5.26239 6.48741 5.28631Z" fill="currentColor"></path><path d="M16.4971 13.1474C16.7842 13.3013 17.0655 13.4624 17.2723 13.5903C17.7669 13.8795 18.6985 14.4241 19.3715 15.1082C19.8059 15.5497 20.3768 16.2837 20.4831 17.2933C20.5159 17.6051 20.5011 17.9036 20.4474 18.1871C20.3937 18.4709 20.3668 18.6128 20.4386 18.6872C20.5104 18.7616 20.63 18.7434 20.8693 18.707C21.8931 18.5512 22.585 17.9931 23.1528 17.3845C23.5774 16.9295 23.7967 16.4061 23.7423 15.8464C23.6912 15.3208 23.4102 14.8976 23.1293 14.5882C22.6858 14.0998 22.0321 13.686 21.6406 13.4381C21.557 13.3852 21.4853 13.3398 21.4302 13.3029C19.9528 12.3132 18.1907 12.0212 16.5454 12.427C16.1575 12.5226 15.9635 12.5704 15.9464 12.7068C15.9292 12.8431 16.1185 12.9445 16.4971 13.1474Z" fill="currentColor"></path><path d="M16.3978 10.804C16.2657 10.9795 16.1997 11.0672 16.22 11.1575C16.2404 11.2478 16.3253 11.2922 16.495 11.3811C16.9451 11.6167 17.4572 11.75 18.0003 11.75C19.7953 11.75 21.2503 10.2949 21.2503 8.5C21.2503 6.70507 19.7953 5.25 18.0003 5.25C17.8347 5.25 17.6719 5.26239 17.5129 5.28631C17.3232 5.31484 17.2284 5.3291 17.1796 5.4079C17.1309 5.48671 17.1649 5.59136 17.2328 5.80068C17.4065 6.33583 17.5003 6.90695 17.5003 7.5C17.5003 8.73995 17.09 9.88407 16.3978 10.804Z" fill="currentColor"></path><path d="M7.69146 14.4733C10.3292 12.8422 13.675 12.8422 16.3127 14.4733C16.3905 14.5214 16.489 14.579 16.6022 14.6452L16.6022 14.6452C17.1145 14.945 17.9276 15.4208 18.4826 15.9849C18.8311 16.3391 19.1787 16.8221 19.242 17.4242C19.3099 18.0683 19.0365 18.6646 18.5149 19.1806C17.6533 20.033 16.5859 20.75 15.1865 20.75H8.81773C7.41827 20.75 6.35094 20.033 5.48932 19.1806C4.96775 18.6646 4.69435 18.0683 4.76215 17.4242C4.82553 16.8221 5.17313 16.3391 5.52165 15.9849C6.07655 15.4208 6.88974 14.945 7.40201 14.6452L7.40204 14.6452C7.51521 14.579 7.6137 14.5214 7.69146 14.4733Z" fill="currentColor"></path><path d="M7.75177 7.5C7.75177 5.15279 9.65456 3.25 12.0018 3.25C14.349 3.25 16.2518 5.15279 16.2518 7.5C16.2518 9.84721 14.349 11.75 12.0018 11.75C9.65456 11.75 7.75177 9.84721 7.75177 7.5Z" fill="currentColor"></path></svg>
								{__("Affiliates Credit")}
							</button>
						</div>
					{/if}
					
					{if $system['points_enabled'] && $system['points_per_currency'] > 0 && $system['points_money_transfer_enabled']}
						<div class="col-md-6 col-lg-4 mb-3">
							<button class="btn btn-gray w-100" data-toggle="modal" data-url="#wallet-withdraw-points">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M2.98518 10.205C3.25477 9.87578 3.38957 9.71117 3.52054 9.75808C3.65152 9.80499 3.65113 10.0334 3.65034 10.4901C3.65033 10.4959 3.65032 10.5017 3.65032 10.5075C3.65032 15.9432 8.05682 20.3497 13.4925 20.3497C13.4983 20.3497 13.5041 20.3497 13.5099 20.3497C13.9666 20.3489 14.195 20.3485 14.2419 20.4795C14.2888 20.6104 14.1242 20.7452 13.795 21.0148C12.4705 22.0994 10.777 22.7502 8.9315 22.7502C4.68901 22.7502 1.24979 19.311 1.24979 15.0685C1.24979 13.223 1.90057 11.5295 2.98518 10.205Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13.9998 1.25021C9.16729 1.25021 5.24979 5.16772 5.24979 10.0002C5.24979 14.8327 9.16729 18.7502 13.9998 18.7502C18.8323 18.7502 22.7498 14.8327 22.7498 10.0002C22.7498 5.16772 18.8323 1.25021 13.9998 1.25021ZM14.7349 6.00021C14.7349 5.586 14.3991 5.25021 13.9849 5.25021C13.5706 5.25021 13.2349 5.586 13.2349 6.00021L13.2349 6.24154C12.2127 6.52453 11.3877 7.37238 11.3877 8.50244C11.3877 9.09286 11.5613 9.69279 12.0899 10.1143C12.58 10.5051 13.2476 10.6352 13.9849 10.6352C14.5986 10.6352 14.8987 10.7459 15.0379 10.8533C15.1337 10.9273 15.2499 11.0732 15.2499 11.4983C15.2499 11.8491 15.1281 12.017 14.9752 12.1258C14.7842 12.2615 14.4549 12.3615 13.9849 12.3615C13.2343 12.3615 12.8018 11.9346 12.7327 11.618C12.6443 11.2133 12.2446 10.9569 11.84 11.0453C11.4353 11.1336 11.1789 11.5333 11.2672 11.938C11.4753 12.8911 12.2886 13.5446 13.2349 13.7724V14.0002C13.2349 14.4144 13.5706 14.7502 13.9849 14.7502C14.3991 14.7502 14.7349 14.4144 14.7349 14.0002V13.7962C15.1304 13.7232 15.5137 13.5833 15.8443 13.3483C16.4207 12.9385 16.7499 12.2998 16.7499 11.4983C16.7499 10.7712 16.5304 10.1105 15.9545 9.66596C15.4219 9.25485 14.7145 9.13516 13.9849 9.13516C13.3787 9.13516 13.1227 9.01933 13.0251 8.94149C12.966 8.89438 12.8877 8.80296 12.8877 8.50244C12.8877 8.11792 13.2803 7.63928 13.9849 7.63928C14.6033 7.63928 14.9994 8.02282 15.0689 8.3698C15.1503 8.77594 15.5455 9.0392 15.9517 8.95782C16.3578 8.87643 16.6211 8.48121 16.5397 8.07507C16.3555 7.15608 15.6243 6.48479 14.7349 6.24037V6.00021Z" fill="currentColor"/></svg>
								{__("Points Credit")}
							</button>
						</div>
					{/if}
					
					{if $user->_data['can_sell_products'] && $system['market_money_transfer_enabled'] && $system['market_shopping_cart_enabled']}
						<div class="col-md-6 col-lg-4 mb-3">
							<button class="btn btn-gray w-100" data-toggle="modal" data-url="#wallet-withdraw-market">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M3 9.75C3.55229 9.75 4 10.1977 4 10.75V15.25C4 16.6925 4.00213 17.6737 4.10092 18.4086C4.19585 19.1146 4.36322 19.4416 4.58579 19.6642C4.80836 19.8868 5.13538 20.0542 5.84143 20.1491C6.57625 20.2479 7.55752 20.25 9 20.25H15C16.4425 20.25 17.4238 20.2479 18.1586 20.1491C18.8646 20.0542 19.1916 19.8868 19.4142 19.6642C19.6368 19.4416 19.8042 19.1146 19.8991 18.4086C19.9979 17.6737 20 16.6925 20 15.25V10.75C20 10.1977 20.4477 9.75 21 9.75C21.5523 9.75 22 10.1977 22 10.75V15.3205C22 16.6747 22.0001 17.7913 21.8813 18.6751C21.7565 19.6029 21.4845 20.4223 20.8284 21.0784C20.1723 21.7345 19.3529 22.0065 18.4251 22.1312C17.5413 22.2501 16.4247 22.25 15.0706 22.25H8.92943C7.57531 22.25 6.4587 22.2501 5.57494 22.1312C4.64711 22.0065 3.82768 21.7345 3.17158 21.0784C2.51547 20.4223 2.2435 19.6029 2.11875 18.6751C1.99994 17.7913 1.99997 16.6747 2 15.3206L2 10.75C2 10.1977 2.44772 9.75 3 9.75Z" fill="currentColor"></path><path d="M3.19143 4.45934C3.19143 2.95786 4.41603 1.75 5.91512 1.75H18.0849C19.584 1.75 20.8086 2.95786 20.8086 4.45934C20.8086 5.00972 20.9532 5.55089 21.2287 6.02939L22.2149 7.74274C22.4737 8.19195 22.6839 8.55669 22.7347 9.16669C22.7553 9.41456 22.7576 9.62312 22.726 9.82441C22.6958 10.0172 22.6381 10.1717 22.5956 10.2854L22.5894 10.3023C22.0565 11.7329 20.6723 12.75 19.0513 12.75C17.695 12.75 16.5023 12.037 15.8374 10.9644C14.9338 12.0575 13.5446 12.75 12 12.75C10.4554 12.75 9.06617 12.0575 8.16259 10.9644C7.49773 12.037 6.30506 12.75 4.94875 12.75C3.32768 12.75 1.94355 11.7329 1.41065 10.3022L1.40436 10.2854C1.3619 10.1717 1.30421 10.0172 1.27397 9.82441C1.2424 9.62312 1.24469 9.41457 1.26533 9.16669C1.31613 8.55668 1.52628 8.19195 1.78509 7.74274L2.77133 6.02939C3.04677 5.55089 3.19143 5.00972 3.19143 4.45934Z" fill="currentColor"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M6 17.5C6 16.9477 6.44772 16.5 7 16.5H11C11.5523 16.5 12 16.9477 12 17.5C12 18.0523 11.5523 18.5 11 18.5H7C6.44772 18.5 6 18.0523 6 17.5Z" fill="currentColor"></path></svg>
								{__("Marketplace Credit")}
							</button>
						</div>
					{/if}
					
					{if $user->_data['can_raise_funding'] && $system['funding_money_transfer_enabled']}
						<div class="col-md-6 col-lg-4 mb-3">
							<button class="btn btn-gray w-100" data-toggle="modal" data-url="#wallet-withdraw-funding">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12.6172 1.96367C13.6005 1.25022 15.2246 0.833417 17.001 1.88616C18.2699 2.63818 18.9411 4.17763 18.704 5.88548C18.4648 7.60882 17.3173 9.51201 14.9639 11.195C14.1924 11.7477 13.4912 12.25 12.5016 12.25C11.512 12.25 10.8107 11.7477 10.0392 11.195C7.68578 9.51201 6.53831 7.60882 6.29908 5.88548C6.062 4.17763 6.7332 2.63818 8.00213 1.88616C9.77849 0.833417 11.4026 1.25022 12.3859 1.96367L12.5016 2.04742L12.6172 1.96367Z" fill="currentColor"></path><path d="M5.95526 13.25C5.52244 13.25 5.12561 13.2499 4.8028 13.2933C4.44732 13.3411 4.07159 13.4535 3.76257 13.7626C3.45355 14.0716 3.3411 14.4473 3.29331 14.8028C3.24991 15.1256 3.24995 15.5224 3.25 15.9553L3.25 18.5635C3.24996 18.8917 3.24993 19.1992 3.27988 19.4561C3.31321 19.7421 3.39038 20.0427 3.59756 20.3203C3.80474 20.5979 4.07102 20.7574 4.33569 20.8707C4.57351 20.9725 4.8683 21.06 5.18291 21.1533L10.1818 22.6366C10.9063 22.8516 11.6827 22.7581 12.3377 22.3802L19.8533 18.0438C20.7865 17.5054 21.0266 16.2638 20.4051 15.4032C19.7123 14.4437 18.5017 14.0209 17.3712 14.3724L17.3697 14.3729L15.2442 15.0259C14.9956 15.1023 14.8712 15.1405 14.8322 15.2122C14.7933 15.2839 14.8398 15.4474 14.9328 15.7743C15.0037 16.0236 15.0121 16.2627 15 16.3973C15 17.3786 14.331 18.171 13.4667 18.4099L10.9258 19.1124C10.0041 19.3673 9.01687 19.2796 8.15388 18.8621L6.5336 18.0781C6.22288 17.9278 6.09286 17.554 6.2432 17.2433C6.39354 16.9326 6.7673 16.8026 7.07802 16.9529L8.69831 17.7369C9.28692 18.0217 9.96218 18.082 10.5927 17.9076L13.1336 17.2051C13.4837 17.1083 13.75 16.7884 13.75 16.3973C13.75 14.9842 12.5733 14.6252 11.1741 14.6252L10.1315 14.6251C9.94974 14.6251 9.77138 14.5841 9.61081 14.5064L7.56883 13.5184C7.20322 13.3415 6.80136 13.25 6.39483 13.25L5.95526 13.25Z" fill="currentColor"></path></svg>
								{__("Funding Credit")}
							</button>
						</div>
					{/if}
					
					{if $user->_data['can_monetize_content'] && $system['monetization_money_transfer_enabled']}
						<div class="col-md-6 col-lg-4 mb-3">
							<button class="btn btn-gray w-100" data-toggle="modal" data-url="#wallet-withdraw-monetization">
								<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"><path fill-rule="evenodd" clip-rule="evenodd" d="M17.9694 3.3786C16.8308 3.24998 15.3865 3.24999 13.5475 3.25H10.4525C8.61345 3.24999 7.16917 3.24998 6.03058 3.3786C4.86842 3.50988 3.926 3.78362 3.14263 4.40229C2.90811 4.58749 2.69068 4.79205 2.49298 5.0138C1.82681 5.76101 1.52932 6.66669 1.38763 7.77785C1.24998 8.85727 1.24999 10.2233 1.25 11.9473V11.9473V12.0527V12.0527C1.24999 13.7768 1.24998 15.1427 1.38763 16.2222C1.52932 17.3333 1.82681 18.239 2.49298 18.9862C2.69068 19.2079 2.90811 19.4125 3.14263 19.5977C3.926 20.2164 4.86842 20.4901 6.03058 20.6214C7.16917 20.75 8.61345 20.75 10.4525 20.75H13.5475C15.3866 20.75 16.8308 20.75 17.9694 20.6214C19.1316 20.4901 20.074 20.2164 20.8574 19.5977C21.0919 19.4125 21.3093 19.208 21.507 18.9862C22.1732 18.239 22.4707 17.3333 22.6124 16.2222C22.75 15.1427 22.75 13.7768 22.75 12.0528V11.9473C22.75 10.2232 22.75 8.85727 22.6124 7.77785C22.4707 6.66669 22.1732 5.76101 21.507 5.0138C21.3093 4.79205 21.0919 4.58749 20.8574 4.40229C20.074 3.78362 19.1316 3.50988 17.9694 3.3786ZM12 9C10.3431 9 9 10.3431 9 12C9 13.6569 10.3431 15 12 15C13.6569 15 15 13.6569 15 12C15 10.3431 13.6569 9 12 9ZM4.25 12C4.25 11.5858 4.58579 11.25 5 11.25H6C6.41421 11.25 6.75 11.5858 6.75 12C6.75 12.4142 6.41421 12.75 6 12.75H5C4.58579 12.75 4.25 12.4142 4.25 12ZM18 11.25C17.5858 11.25 17.25 11.5858 17.25 12C17.25 12.4142 17.5858 12.75 18 12.75H19C19.4142 12.75 19.75 12.4142 19.75 12C19.75 11.5858 19.4142 11.25 19 11.25H18Z" fill="currentColor"/></svg>
								{__("Monetization Credit")}
							</button>
						</div>
					{/if}
                </div>
				<!-- send & recieve money -->
				
				<hr class="mt-2">

				<!-- wallet transactions -->
                <div class="heading-small mb-1">
					{__("Wallet Transactions")}
                </div>
                {if $transactions}
					<div class="table-responsive">
						<table class="table table-hover align-middle js_dataTable">
							<thead>
								<tr>
									<th class="fw-semibold bg-transparent">{__("ID")}</th>
									<th class="fw-semibold bg-transparent">{__("Amount")}</th>
									<th class="fw-semibold bg-transparent">{__("From / To")}</th>
									<th class="fw-semibold bg-transparent">{__("Time")}</th>
								</tr>
							</thead>
							<tbody>
								{foreach $transactions as $transaction}
									<tr>
										<td class="bg-transparent">{$transaction['transaction_id']}</td>
										<td class="bg-transparent">
											{if $transaction['type'] == "out"}
												<span class="badge rounded-pill bg-danger mr5"><i class="far fa-arrow-alt-circle-down"></i></span>
												<strong class="text-danger">{if $transaction['amount']}{print_money($transaction['amount']|number_format:2)}{/if}</strong>
											{else}
												<span class="badge rounded-pill bg-success mr5"><i class="far fa-arrow-alt-circle-up"></i></span>
												<strong class="text-success">{if $transaction['amount']}{print_money($transaction['amount']|number_format:2)}{/if}</strong>
											{/if}
										</td>
										<td class="bg-transparent">
											{if $transaction['type'] == "out"}
												<span class="badge rounded-pill bg-danger mr10">{__("To")}</span>
											{else}
												<span class="badge rounded-pill bg-success mr10">{__("From")}</span>
											{/if}
											{if $transaction['node_type'] == "user" || $transaction['node_type'] == "tip"}
												{if $transaction['node_type'] == "tip"}
													<span class="badge rounded-pill bg-secondary mr10">{__("Tip")}</span>
												{/if}
												<a target="_blank" href="{$system['system_url']}/{$transaction['user_name']}">
													<img class="tbl-image" src="{$transaction['user_picture']}" style="float: none;">
													{if $system['show_usernames_enabled']}
														{$transaction['user_name']}
													{else}
														{$transaction['user_firstname']} {$transaction['user_lastname']}
													{/if}
												</a>
											{elseif $transaction['node_type'] == "recharge"}
												{__("Replenish Credit")}
											{elseif $transaction['node_type'] == "withdraw_wallet"}
												{__("Wallet Withdrawal")}
											{elseif $transaction['node_type'] == "withdraw_affiliates"}
												{__("Affiliates Credit")}
											{elseif $transaction['node_type'] == "withdraw_points"}
												{__("Points Credit")}
											{elseif $transaction['node_type'] == "withdraw_market"}
												{__("Market Credit")}
											{elseif $transaction['node_type'] == "withdraw_funding"}
												{__("Funding Credit")}
											{elseif $transaction['node_type'] == "withdraw_monetization"}
												{__("Monetization Credit")}
											{elseif $transaction['node_type'] == "package_payment"}
												{__("Buy Pro Package")}
											{elseif $transaction['node_type'] == "subscribe_profile" || $transaction['node_type'] == "subscribe_user"}
												{__("Subscribe to Profile")}
											{elseif $transaction['node_type'] == "subscribe_page"}
												{__("Subscribe to Page")}
											{elseif $transaction['node_type'] == "subscribe_group"}
												{__("Subscribe to Group")}
											{elseif $transaction['node_type'] == "paid_post"}
												{__("Paid Post")}
											{elseif $transaction['node_type'] == "donate"}
												{__("Donate")}
											{elseif $transaction['node_type'] == "market" || $transaction['node_type'] == "market_payment"}
												{__("Market Purchase")}
											{elseif $transaction['node_type'] == "paid_chat_message"}
												{__("Paid Chat Message")}
											{elseif $transaction['node_type'] == "paid_call"}
												{__("Paid Call")}
											{/if}
										</td>
										<td class="bg-transparent"><span class="js_moment" data-time="{$transaction['date']}">{$transaction['date']}</span></td>
									</tr>
								{/foreach}
							</tbody>
						</table>
					</div>
                {else}
					{include file='_no_transactions.tpl'}
                {/if}
				<!-- wallet transactions -->
			</div>
			<!-- wallet -->

		{elseif $view == "payments"}

			<!-- payments -->
			<div class="p-3">
				<div class="heading-small mb-1">
					{__("Withdrawal Request")}
				</div>
		
				<form class="js_ajax-forms" data-url="users/withdraw.php?type=wallet">
					<div class="row form-group mb-2">
						<label class="col-md-3 form-label fw-medium">
							{__("Your Balance")}
						</label>
						<div class="col-md-9">
							<h6>
								<span class="badge badge-lg bg-success fw-medium">
									{print_money($user->_data['user_wallet_balance']|number_format:2)}
								</span>
							</h6>
						</div>
					</div>

					<div class="row form-group mb-2">
						<label class="col-md-3 form-label fw-medium">
							{__("Amount")} ({$system['system_currency']})
						</label>
						<div class="col-md-9">
							<input type="text" class="form-control" name="amount">
							<div class="form-text">
								{__("The minimum withdrawal request amount is")} {print_money($system['wallet_min_withdrawal'])}
							</div>
						</div>
					</div>

					<div class="row form-group">
						<label class="col-md-3 form-label fw-medium">
							{__("Payment Method")}
						</label>
						<div class="col-md-9">
							{if in_array("paypal", $system['wallet_payment_method_array'])}
								<div class="form-check form-check-inline">
									<input type="radio" name="method" id="method_paypal" value="paypal" class="form-check-input">
									<label class="form-check-label" for="method_paypal">{__("PayPal")}</label>
								</div>
							{/if}
							{if in_array("skrill", $system['wallet_payment_method_array'])}
								<div class="form-check form-check-inline">
									<input type="radio" name="method" id="method_skrill" value="skrill" class="form-check-input">
									<label class="form-check-label" for="method_skrill">{__("Skrill")}</label>
								</div>
							{/if}
							{if in_array("moneypoolscash", $system['wallet_payment_method_array'])}
								<div class="form-check form-check-inline">
									<input type="radio" name="method" id="method_moneypoolscash" value="moneypoolscash" class="form-check-input">
									<label class="form-check-label" for="method_moneypoolscash">{__("MoneyPoolsCash")}</label>
								</div>
							{/if}
							{if in_array("bank", $system['wallet_payment_method_array'])}
								<div class="form-check form-check-inline">
									<input type="radio" name="method" id="method_bank" value="bank" class="form-check-input">
									<label class="form-check-label" for="method_bank">{__("Bank Transfer")}</label>
								</div>
							{/if}
							{if in_array("custom", $system['wallet_payment_method_array'])}
								<div class="form-check form-check-inline">
									<input type="radio" name="method" id="method_custom" value="custom" class="form-check-input">
									<label class="form-check-label" for="method_custom">{__($system['wallet_payment_method_custom'])}</label>
								</div>
							{/if}
						</div>
					</div>

					<div class="row form-group mb-4">
						<label class="col-md-3 form-label fw-medium">
							{__("Transfer To")}
						</label>
						<div class="col-md-9">
							<input type="text" class="form-control" name="method_value">
						</div>
					</div>

					<div class="row">
						<div class="col-md-9 offset-md-3">
							<button type="submit" class="btn btn-primary">{__("Make a withdrawal")}</button>
						</div>
					</div>
	
					<!-- success -->
					<div class="alert alert-success mt15 mb0 x-hidden"></div>
					<!-- success -->

					<!-- error -->
					<div class="alert alert-danger mt15 mb0 x-hidden"></div>
					<!-- error -->
				</form>
				
				<hr class="mt-4">

				<div class="heading-small mb-1">
					{__("Withdrawal History")}
				</div>
				{if $payments}
					<div class="table-responsive">
						<table class="table table-hover align-middle">
							<thead>
								<tr>
									<th class="fw-semibold bg-transparent">{__("ID")}</th>
									<th class="fw-semibold bg-transparent">{__("Amount")}</th>
									<th class="fw-semibold bg-transparent">{__("Method")}</th>
									<th class="fw-semibold bg-transparent">{__("Transfer To")}</th>
									<th class="fw-semibold bg-transparent">{__("Time")}</th>
									<th class="fw-semibold bg-transparent">{__("Status")}</th>
								</tr>
							</thead>
							<tbody>
								{foreach $payments as $payment}
									<tr>
										<td class="bg-transparent">{$payment@iteration}</td>
										<td class="bg-transparent">{print_money($payment['amount']|number_format:2)}</td>
										<td class="bg-transparent">
											{if $payment['method'] == "custom"}
												{$system['wallet_payment_method_custom']}
											{else}
												{$payment['method']|ucfirst}
											{/if}
										</td>
										<td class="bg-transparent">{$payment['method_value']}</td>
										<td class="bg-transparent">
											<span class="js_moment" data-time="{$payment['time']}">{$payment['time']}</span>
										</td>
										<td class="bg-transparent">
											{if $payment['status'] == '0'}
												<span class="badge rounded-pill bg-warning">{__("Pending")}</span>
											{elseif $payment['status'] == '1'}
												<span class="badge rounded-pill bg-success">{__("Approved")}</span>
											{else}
												<span class="badge rounded-pill bg-danger">{__("Declined")}</span>
											{/if}
										</td>
									</tr>
								{/foreach}
							</tbody>
						</table>
					</div>
				{else}
					{include file='_no_transactions.tpl'}
				{/if}
			</div>
			<!-- payments -->

		{/if}
    </div>
    <!-- content panel -->

</div>
<!-- page content -->

{include file='_footer.tpl'}