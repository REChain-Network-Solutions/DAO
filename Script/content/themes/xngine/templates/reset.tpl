{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="container mt30">
	<div class="row">
		<div class="col-md-6 col-lg-5 mx-md-auto">
			<!-- reset form -->
			<div class="card-register bg-white rounded-3 mb-4">
				<!-- logo-wrapper -->
				<div class="position-relative overflow-hidden logo-wrapper text-center mb-4 pb-2">
					<!-- logo -->
					<a href="{$system['system_url']}" class="position-relative d-inline-block p-0 logo">
						{if $system['system_logo']}
							<img class="logo-light x_logo_pc" src="{$system['system_uploads']}/{$system['system_logo']}" alt="{__($system['system_title'])}">
							{if !$system['system_logo_dark']}
								<img class="logo-dark x_logo_pc" src="{$system['system_uploads']}/{$system['system_logo']}" alt="{__($system['system_title'])}">
							{else}
								<img class="logo-dark x_logo_pc" src="{$system['system_uploads']}/{$system['system_logo_dark']}" alt="{$system['system_title']}">
							{/if}
							
							{if $system['system_favicon_default']}
								<img class="x_logo_mobi" src="{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png" alt="{__($system['system_title'])}"/>
							{elseif $system['system_favicon']}
								<img class="x_logo_mobi" src="{$system['system_uploads']}/{$system['system_favicon']}" alt="{__($system['system_title'])}"/>
							{/if}
						{else}
							{__($system['system_title'])}
						{/if}
					</a>
					<!-- logo -->
				</div>
				<!-- logo-wrapper -->
				
				<div class="card-header">
					<h4 class="card-title headline-font fw-bold mb-2">{__("Forgot your password?")}</h4>
					<p>{__("Enter the email address associated with your account and we will send you a link to reset your password.")}</p>
				</div>

				<div class="card-body pt0">
					<form class="js_ajax-forms" data-url="core/forget_password.php">
						<!-- email -->
						<div class="form-floating">
							<input name="email" type="email" class="form-control" placeholder='{__("Email")}' required>
							<label>{__("Email")}</label>
						</div>
						<!-- email -->

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

						<div class="mt-3">
							<input type="hidden" name="secret" value="{$secret}">
							<button type="submit" class="btn btn-primary w-100 btn-lg">
								{__("Continue")}
							</button>
						</div>

						<!-- error -->
						<div class="alert alert-danger x-hidden"></div>
						<!-- error -->
					</form>
					<div class="mt-4">
						<a href="{$system['system_url']}/signin" class="fw-medium">{__("Back to Signin")}</a>
					</div>
				</div>
			</div>
			<!-- reset form -->
		</div>
	</div>
</div>
<!-- page content -->

{include file='_footer.tpl'}