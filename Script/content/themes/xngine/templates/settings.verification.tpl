<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Verification")}
	</div>
</div>

{if $case == "verified"}
	<div class="p-3 pt-1">
		<div class="text-center text-muted py-5">
			<svg xmlns="http://www.w3.org/2000/svg" width="56" height="56" enable-background="new 0 0 24 24" viewBox="0 0 24 24" class="main"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
			<div class="text-md mt-4">
				<h4 class="headline-font mb-1">{__("Congratulations")}</h4>
				<p class="m-0">
					{__("This account is verified")}
				</p>
			</div>
		</div>
	</div>
{elseif $case == "pending"}
	<div class="p-3 pt-1">
		<div class="text-center text-muted py-5">
			<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" opacity="0.7"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 1.25C6.06294 1.25 1.25 6.06294 1.25 12C1.25 17.9371 6.06294 22.75 12 22.75C17.9371 22.75 22.75 17.9371 22.75 12C22.75 6.06294 17.9371 1.25 12 1.25ZM13 8C13 7.44772 12.5523 7 12 7C11.4477 7 11 7.44772 11 8V12C11 12.2652 11.1054 12.5196 11.2929 12.7071L13.2929 14.7071C13.6834 15.0976 14.3166 15.0976 14.7071 14.7071C15.0976 14.3166 15.0976 13.6834 14.7071 13.2929L13 11.5858V8Z" fill="currentColor"/></svg>
			<div class="text-md mt-4">
				<h4 class="headline-font mb-1">{__("Pending")}</h4>
				<p class="m-0">
					{__("Your verification request is still awaiting admin approval")}
				</p>
			</div>
		</div>
	</div>
{elseif $case == "request" || "declined"}
	<form class="js_ajax-forms p-3 pt-1" data-url="users/verify.php?node=user">
		{if $case == "declined"}
			<div class="text-center text-muted pt-2">
				<svg width="56" height="56" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="text-danger" opacity="0.7"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 22.75C6.06294 22.75 1.25 17.9371 1.25 12C1.25 6.06294 6.06294 1.25 12 1.25C17.9371 1.25 22.75 6.06294 22.75 12C22.75 17.9371 17.9371 22.75 12 22.75ZM16 13C16.5523 13 17 12.5523 17 12C17 11.4477 16.5523 11 16 11H8C7.44771 11 7 11.4477 7 12C7 12.5523 7.44771 13 8 13H16Z" fill="currentColor"/></svg>
				<div class="text-md mt-4">
					<h4 class="headline-font mb-1">{__("Sorry")}</h4>
					<p class="m-0">
						{__("Your verification request has been declined by the admin")}
					</p>
				</div>
			</div>
			<hr class="my-4">
		{/if}

		{if $system['verification_docs_required']}
			<h6 class="">
				{__("Verification Documents")}
			</h6>

            <div class="row">
				<div class="col-sm-6">
					<label class="form-label">
						{__("Your Photo")}
					</label>
					<div class="x-image w-100">
						<button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
						<div class="x-image-loader">
							<div class="progress x-progress">
								<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
							</div>
						</div>
						<i class="fa fa-camera js_x-uploader" data-handle="x-image"></i>
						<input type="hidden" class="js_x-image-input" name="photo" value="">
					</div>
				</div>
				
				<div class="col-sm-6">
					<label class="form-label">
						{__("Passport or National ID")}
					</label>
					<div class="x-image w-100">
						<button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
						<div class="x-image-loader">
							<div class="progress x-progress">
								<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
							</div>
						</div>
						<i class="fa fa-camera js_x-uploader" data-handle="x-image"></i>
						<input type="hidden" class="js_x-image-input" name="passport" value="">
					</div>
				</div>
            </div>
            <div class="form-text mb-4">
				{__("Please attach your photo and your Passport or National ID")}
            </div>
		{/if}

		<div class="form-floating">
			<textarea class="form-control" name="message" placeholder=" " rows="4"></textarea>
			<label class="form-label">{__("Additional Information")}</label>
			<div class="form-text">
				{__("Please share why your account should be verified")}
			</div>
		</div>

		<!-- success -->
		<div class="alert alert-success mt15 mb0 x-hidden"></div>
		<!-- success -->

		<!-- error -->
		<div class="alert alert-danger mt15 mb0 x-hidden"></div>
		<!-- error -->
		
		<hr class="hr-2">

		<div class="text-end">
			<button type="submit" class="btn btn-primary">
				{__("Send")}
			</button>
		</div>
	</form>
{/if}