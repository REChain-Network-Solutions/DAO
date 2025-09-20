<!-- need payment -->
<div class="{if $paid_image}pg_wrapper overflow-hidden clearfix mt-2 position-relative need-subscription{/if}">
	{if $paid_image}
		<div class="post-media">
			<div class="post-media-image d-block position-relative ratio ratio-1x1">
				<div class="image" style="background-image:url('{$system['system_uploads']}/{$paid_image}');"></div>
			</div>
		</div>
	{/if}
	 
	<div class="p-3 {if $paid_image}position-absolute w-100 h-100 bg-black bg-opacity-50 need-subscription-innr d-flex align-items-center justify-content-center{/if}">
		<div class="{if $paid_image}text-white{else}text-muted{/if} text-center py-5">
			<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="{if $paid_image}text-white{else}text-success text-opacity-75{/if}"><path fill-rule="evenodd" clip-rule="evenodd" d="M7.78894 3.38546C7.87779 3.52092 7.77748 3.75186 7.57686 4.21374C7.49965 4.39151 7.42959 4.57312 7.36705 4.75819C7.29287 4.9777 7.25578 5.08746 7.17738 5.14373C7.09897 5.19999 6.99012 5.19999 6.77242 5.19999H4.18138C3.64164 5.19999 3.2041 5.63651 3.2041 6.17499C3.2041 6.71346 3.64164 7.14998 4.18138 7.14998L15.9776 7.14998C16.8093 7.13732 18.6295 7.14275 19.2563 7.26578C20.1631 7.3874 20.9639 7.65257 21.6051 8.29227C22.2463 8.93197 22.512 9.73091 22.6339 10.6355C22.7501 11.4972 22.75 12.5859 22.75 13.9062V15.9937C22.75 17.314 22.7501 18.4027 22.6339 19.2644C22.512 20.169 22.2463 20.9679 21.6051 21.6076C20.9639 22.2473 20.1631 22.5125 19.2563 22.6341C18.3927 22.75 17.3014 22.75 15.978 22.7499H9.97398C8.19196 22.7499 6.75559 22.75 5.6259 22.5984C4.45303 22.4411 3.4655 22.1046 2.68119 21.3221C1.89687 20.5396 1.55952 19.5543 1.40184 18.3842C1.24996 17.2572 1.24998 15.8241 1.25 14.0463V6.175C1.25 4.55957 2.56262 3.25001 4.18182 3.25001L6.99624 3.25C7.46547 3.25 7.70009 3.25 7.78894 3.38546ZM17.5 12.9998C18.6046 12.9998 19.5 13.8952 19.5 14.9998C19.5 16.1043 18.6046 16.9998 17.5 16.9998C16.3954 16.9998 15.5 16.1043 15.5 14.9998C15.5 13.8952 16.3954 12.9998 17.5 12.9998Z" fill="currentColor"></path><path d="M19.4557 6.03151C19.563 6.0463 19.6555 5.95355 19.6339 5.84742C19.1001 3.22413 16.7803 1.25 13.9994 1.25C11.3264 1.25 9.07932 3.07399 8.43503 5.54525C8.38746 5.72772 8.52962 5.90006 8.7182 5.90006L15.9679 5.90006C16.3968 5.89365 17.0712 5.89192 17.7232 5.90742C18.3197 5.92161 19.0159 5.95164 19.4557 6.03151Z" fill="currentColor"></path></svg>
			<div class="text-md mt-4">
				<h5 class="headline-font m-0">
					{__("PAID POST")}
				</h5>
			</div>
			
			{if $paid_text}
				<div class="post-paid-description mt-2">
					{$paid_text}
				</div>
			{/if}
		
			<div class="mt-3">
				<button class="btn btn-main {if !$user->_logged_in}js_login{/if}" {if $user->_logged_in}data-toggle="modal" data-url="#payment" data-options='{ "handle": "paid_post", "paid_post": "true", "id": {$post_id}, "price": {$price}, "vat": "{get_payment_vat_value($price)}", "fees": "{get_payment_fees_value($price)}", "total": "{get_payment_total_value($price)}", "total_printed": "{get_payment_total_value($price, true)}" }' {/if}>
					{__("PAY TO UNLOCK")} ({print_money($price|number_format:2)})
				</button>
			</div>
		</div>
	</div>
</div>
<!-- need payment -->