{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="row x_content_row">
    <!-- content panel -->
    <div class="col-lg-8">
		<div class="d-flex align-items-center p-3 position-sticky x_top_posts">
			<div class="d-flex align-items-center gap-3 position-relative mw-0">
				<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Contact Us")}</span>
			</div>
		</div>
		
		<div class="p-3">
			<p class="">{__("Contact us and we will contact you back")}</p>
			<form class="js_ajax-forms" data-url="core/contact.php">
				<div class="form-floating">
					<input type="text" class="form-control" name="name" placeholder=" ">
					<label class="form-label">{__("Name")} <span class="text-danger small">*</span></label>
				</div>

				<div class="form-floating">
					<input type="email" class="form-control" name="email" placeholder=" ">
					<label class="form-label">{__("Email")} <span class="text-danger small">*</span></label>
				</div>

				<div class="form-floating">
					<input type="text" class="form-control" name="subject" placeholder=" ">
					<label class="form-label">{__("Subject")} <span class="text-danger small">*</span></label>
				</div>

				<div class="form-floating">
					<textarea class="form-control" name="message" rows="5" placeholder=" "></textarea>
					<label class="form-label">{__("Message")} <span class="text-danger small">*</span></label>
				</div>

				{if $system['reCAPTCHA_enabled']}
					<div class="form-group">
						<!-- reCAPTCHA -->
						<script src='https://www.google.com/recaptcha/api.js' async defer></script>
						<div class="g-recaptcha" data-sitekey="{$system['reCAPTCHA_site_key']}"></div>
						<!-- reCAPTCHA -->
					</div>
				{/if}
				
				{if $system['turnstile_enabled']}
					<div class="form-group">
						<!-- Turnstile -->
						<script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
						<div class="cf-turnstile" data-sitekey="{$system['turnstile_site_key']}" data-callback="javascriptCallback"></div>
						<!-- Turnstile -->
					</div>
				{/if}

				<!-- success -->
				<div class="alert alert-success mt15 mb0 x-hidden"></div>
				<!-- success -->

				<!-- error -->
				<div class="alert alert-danger mt15 mb0 x-hidden"></div>
				<!-- error -->
				
				<hr class="hr-2">
				
				<div class="text-end">
					<button type="submit" class="btn btn-primary">{__("Send")}</button>
				</div>
			</form>
		</div>
    </div>
    <!-- content panel -->
	
	<!-- right panel -->
	<div class="col-lg-4 js_sticky-sidebar">
		<!-- upgrade to pro -->	
		{if $system['packages_enabled'] && !$user->_data['user_subscribed']}
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Upgrade to Pro")}
				</h6>
				<div class="px-3 py-0 side_item_list">
					{__("Choose the Plan That's Right for You")}
				</div>
				<div class="px-3 side_item_list">
					<a class="btn btn-main" href="{$system['system_url']}/packages">
						{__("Upgrade")}
					</a>
				</div>
			</div>
		{/if}
		<!-- upgrade to pro -->
		
		<!-- trending -->
		{if $trending_hashtags}
            {include file='_trending_widget.tpl'}
		{/if}
		<!-- trending -->

		{include file='_ads.tpl'}
		{include file='_ads_campaigns.tpl'}
		{include file='_widget.tpl'}
		
		<!-- mini footer -->
		{include file='_footer_mini.tpl'}
		<!-- mini footer -->
	</div>
	<!-- right panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}