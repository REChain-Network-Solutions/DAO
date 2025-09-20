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
		<div class="notfound-wrapper h-100 d-flex align-items-center justify-content-center p-3">
			<div class="notfound text-center mx-auto">
				{if $view == "pending"}
					<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="text-warning text-opacity-75 mb-4"><path fill-rule="evenodd" clip-rule="evenodd" d="M6.1875 2.25V5.11364C6.1875 8.27672 8.78984 10.8409 12 10.8409C15.2102 10.8409 17.8125 8.27672 17.8125 5.11364V2.25H19.75V5.11364C19.75 9.33108 16.2802 12.75 12 12.75C7.71979 12.75 4.25 9.33108 4.25 5.11364V2.25H6.1875Z" fill="currentColor"/><path d="M4.25 21.75H19.75V18.8864C19.75 14.6689 16.2802 11.25 12 11.25C7.71979 11.25 4.25 14.6689 4.25 18.8864V21.75Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M3 2C3 1.44772 3.44772 1 4 1H20C20.5523 1 21 1.44772 21 2C21 2.55228 20.5523 3 20 3H4C3.44772 3 3 2.55228 3 2ZM3 22C3 21.4477 3.44772 21 4 21H20C20.5523 21 21 21.4477 21 22C21 22.5523 20.5523 23 20 23H4C3.44772 23 3 22.5523 3 22Z" fill="currentColor"/></svg>
					<div class="text-md">
						<h5 class="headline-font m-0">
							{__("Payment Pending")}!
						</h5>
					</div>
					<div class="mt-2 text-muted">
						{__("Your payment is pending and will be processed soon")}. {__("You will get a notification once the payment is processed")}
					</div>
				{elseif !$view == "failure"}
					<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="text-danger text-opacity-75 mb-4"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 22.75C6.06294 22.75 1.25 17.9371 1.25 12C1.25 6.06294 6.06294 1.25 12 1.25C17.9371 1.25 22.75 6.06294 22.75 12C22.75 17.9371 17.9371 22.75 12 22.75ZM15.7071 9.70713C16.0976 9.31662 16.0976 8.68345 15.7071 8.29292C15.3166 7.90238 14.6835 7.90236 14.2929 8.29287L11.9998 10.5858L9.70708 8.29326C9.31655 7.90275 8.68338 7.90277 8.29287 8.29331C7.90236 8.68385 7.90238 9.31701 8.29292 9.70752L10.5855 12L8.29292 14.2925C7.90238 14.683 7.90236 15.3162 8.29287 15.7067C8.68338 16.0972 9.31655 16.0972 9.70708 15.7067L11.9998 13.4142L14.2929 15.7071C14.6835 16.0976 15.3166 16.0976 15.7071 15.7071C16.0976 15.3165 16.0976 14.6834 15.7071 14.2929L13.4141 12L15.7071 9.70713Z" fill="currentColor"/></svg>
					<div class="text-md">
						<h5 class="headline-font m-0">
							{__("Payment Failed")}!
						</h5>
					</div>
					<div class="mt-2 text-muted">
						{__("Your payment has been failed")}. {__("Please try again or contact us for more information")}
					</div>
				{/if}
			
				<div class="mt-5">
					<a class="btn btn-primary" href="{$system['system_url']}">{__("Back to homepage")}</a>
				</div>
			</div>
		</div>
    </div>
    <!-- content panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}