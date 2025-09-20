<div>
	<div type="button" class="px-3 side_item_list" data-bs-toggle="collapse" data-bs-target=".order_collapse-{$order['order_id']}" aria-expanded="false">
		<div class="row">
			<div class="col-md-4 my-2">
				<div class="fw-semibold mb-1">{__("Order")} #</div>
				{$order['order_hash']}
			</div>

			<div class="col-md-4 my-2">
				<div class="fw-semibold mb-1">{__("Order Placed")}</div>
				{$order['insert_time']}
			</div>

			<div class="col-md-2 my-2">
				<div class="fw-semibold mb-1">{__("Status")}:</div>
				{if $order['status'] == "canceled"}
					<span class="badge bg-danger">{__($order['status'])|ucfirst}</span>
				{elseif $order['status'] == "delivered"}
					<span class="badge bg-success">{__($order['status'])|ucfirst}</span>
				{else}
					<span class="badge bg-info">{__($order['status'])|ucfirst}</span>
				{/if}
			</div>

			<div class="col-md-2 my-2 text-md-end">
				<button class="btn btn-dark">{__("View")}</button>
			</div>
		</div>
	</div>

	<div class="collapse order_collapse-{$order['order_id']}">
		<div class="px-3 pb-3">
			<hr class="hr-2 mt-0">
			<div class="d-flex align-items-start justify-content-between gap-2 mb-3">
				<div>
					{if !$for_admin}
						<!-- update order -->
						{if $sales}
							{if $order['status'] != "delivered" && $order['status'] != "canceled"}
								<button class="btn btn-primary" data-toggle="modal" data-url="users/orders.php?do=edit&id={$order['order_id']}">
									{__("UPDATE")}
								</button>
							{/if}
						{else}
							{if $order['status'] != "delivered" && $order['status'] != "canceled"}
								<button class="btn btn-primary" data-toggle="modal" data-url="users/orders.php?do=edit&id={$order['order_id']}">
									{__("UPDATE")}
								</button>
							{/if}
						{/if}
						<!-- update order -->

						<!-- invoice -->
						<button class="btn btn-link main js_shopping-download-invoice" data-id="{$order['order_id']}">
							{__("INVOICE")}
						</button>
						<!-- invoice -->
					{/if}
				</div>
				<button type="button" class="btn btn-gray border-0 p-2 rounded-circle lh-1 flex-0" data-bs-toggle="collapse" data-bs-target=".order_collapse-{$order['order_id']}">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.0005 4.99988L5.00049 18.9999M5.00049 4.99988L19.0005 18.9999" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
				</button>
			</div>
			
			{if $order['status'] == "shipped"}
				<div class="alert alert-warning">
					<div class="text">
						{__("This order has been shipped and will be marked as delivered automatically after")} <span class="badge bg-light text-primary">{$order['automatic_delivery_days']}</span> {__("days")} ({__("Max")} {$system['market_delivery_days']} {__("days")})
					</div>
				</div>
			{/if}
			
			<div class="row">
				<div class="col-md-5 col-lg-4 mb-4 mb-md-0">
					<!-- Payments -->
					<div class="heading-small">
						{__("Payments")}
					</div>

					<div class="d-flex align-items-center justify-content-between mb5">
						<span>{if $sales}{__("Subtotal")}{else}{__("Total")}{/if}:</span>
						<span class="{if $sales}{else}text-md fw-medium{/if}">
							{print_money(number_format($order['sub_total'], 2))}
						</span>
					</div>
					{if $sales}
						<div class="d-flex align-items-center justify-content-between mb5">
							<span>{__("Commission")}:</span>
							<span>
								- {print_money(number_format($order['total_commission'], 2))}
							</span>
						</div>
			
						<div class="d-flex align-items-center justify-content-between mb-4 pb-1">
							<span>{__("Total")}:</span>
							<span class="text-md fw-medium">
								{print_money(number_format($order['final_price'], 2))}
							</span>
						</div>
					{/if}
					<!-- Payments -->
					
					<!-- Tracking Details -->
					<div class="heading-small mt-4">
						{if $order['is_digital']}
							{__("Download Details")}
						{else}
							{__("Tracking Details")}
						{/if}
					</div>
					<div class="mb-4 pb-1">
						{if $order['is_digital']}
							<div>
								<div><strong class="fw-medium">{__("Download Link")}:</strong></div>
								{if $order['items'][0]['post']['product']['product_file_source']}
									<div>
										<a class="btn btn-sm btn-gray" href="{$system['system_uploads']}/{$order['items'][0]['post']['product']['product_file_source']}" target="_blank">{__("Download")}</a>
									</div>
								{else}
									<div>
										<a class="btn btn-sm btn-gray" href="{$order['items'][0]['post']['product']['product_download_url']}" target="_blank">{__("Download")}</a>
									</div>
								{/if}
							</div>
						{else}
							<div class="mb-2">
								<div><strong class="fw-medium">{__("Tracking Link")}:</strong></div>
								<div>
									{if $order['tracking_link']}<a href="{$order['tracking_link']}" target="_blank">{$order['tracking_link']}</a>{else}{__("N/A")}{/if}
								</div>
							</div>

							<div class="">
								<div><strong class="fw-medium">{__("Tracking Number")}:</strong></div>
								<div>
									{if $order['tracking_number']}{$order['tracking_number']}{else}{__("N/A")}{/if}
								</div>
							</div>
						{/if}
					</div>
					<!-- Tracking Details -->
					
					<!-- Shipping Addresses -->
					<div class="heading-small mb-1">
						{__("Shipping Addresses")}
					</div>
					<div class="x_address m-0 p-3">
						<div class="h6 fw-medium mb-1">{$order['buyer_fullname']}</div>
						<div class="small">{$order['address_details']}</div>
						<div class="small">{$order['address_city']}</div>
						<div class="small">{$order['address_country']}</div>
						<div class="small">{$order['address_zip_code']}</div>
						<div class="small">{$order['address_phone']}</div>
					</div>
					<!-- Shipping Addresses -->
				</div>

				<div class="col-md-7 col-lg-8">
					 <!-- Order Items -->
					<div class="heading-small pb-0">
						{__("Items")}
					</div>

					<div>
						{foreach $order['items'] as $order_item}
							<div class="side_item_list d-flex align-items-start gap-3 x_group_list x_cart_list">
								<a href="{$system['system_url']}/posts/{$order_item['post']['post_id']}" class="flex-0">
									{if $order_item['post']['photos_num'] > 0}
										<img src="{$system['system_uploads']}/{$order_item['post']['photos'][0]['source']}" class="rounded-3">
									{else}
										<img src="{$system['system_url']}/content/themes/{$system['theme']}/images/blank_product.png" class="rounded-3">
									{/if}
								</a>

								<div class="flex-1">
									<div class="">
										<a class="text-md fw-semibold body-color" href="{$system['system_url']}/posts/{$order_item['post']['post_id']}">{$order_item['post']['product']['name']}</a>
										<div class="">
											{if $order_item['post']['product']['price'] > 0}
												{print_money($order_item['post']['product']['price'])}
											{else}
												{__("Free")}
											{/if}
										</div>
									</div>
									<div class="mt-2 pt-1">
										<strong class="fw-medium">{__("Qty:")}</strong>
										{$order_item['quantity']}
									</div>
								</div>
							</div>
						{/foreach}
					</div>
					<!-- Order Items -->
				</div>
			</div>
		</div>
	</div>
	<hr class="m-0">
</div>