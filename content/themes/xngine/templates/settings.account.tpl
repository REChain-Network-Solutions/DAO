<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Account Settings")}
	</div>
</div>

<form class="js_ajax-forms p-3 pt-1" data-url="users/settings.php?edit=account">
    <div class="heading-small mb-1">
		{__("Email Address")}
    </div>
	
	{if !$user->_data['user_email_verified']}
        <div class="alert alert-danger">
			<div class="text">
				<strong>{__("Email Verification Required")}</strong><br>
				{__("Check your email inbox")} {__("to complete the verification process")}
				<button class="btn btn-sm btn-light mt-2" data-toggle="modal" data-url="core/activation_email_resend.php">{__("Resend Verification Email")}</button>
			</div>
        </div>
	{/if}

	<div class="form-floating">
		<input type="email" class="form-control" name="email" value="{$user->_data['user_email']}" placeholder=" ">
		<label class="form-label">{__("Email Address")}</label>
	</div>

    {if ($system['activation_enabled'] && $system['activation_type'] == "sms") || ($system['two_factor_enabled'] && $system['two_factor_type'] == "sms")}
		<div class="heading-small mb-1">
			{__("Phone Number")}
		</div>
        {if $user->_data['user_phone'] && !$user->_data['user_phone_verified']}
			<div class="alert alert-danger">
				<div class="text">
					<strong>{__("Phone Verification Required")}</strong><br>
					{__("Check your phone SMS")} {__("to complete phone verification process")}
					<button class="btn btn-sm btn-light mt-2" data-toggle="modal" data-url="#activation-phone">{__("Enter Code")}</button>
				</div>
          </div>
        {/if}
		
		<div class="form-floating">
			<input type="text" class="form-control" name="phone" value="{$user->_data['user_phone']}" placeholder=" ">
			<label class="form-label">{__("Phone Number")}</label>
			<div class="form-text">
				{__("Phone number (e.g: +1234567890)")}
            </div>
		</div>
    {/if}

    {if !$system['disable_username_changes']}
		<div class="heading-small mb-1">
			{__("Username")}
		</div>
	  
		{if $user->_data['user_verified']}
			<div class="alert alert-warning">
				<div class="text">
					<strong>{__("Attention")}</strong><br>
					{__("Your account is already verified if you changed your username you will lose the verification badge")}
				</div>
			</div>
		{/if}
		
		<div class="form-floating">
			<input type="text" class="form-control" name="username" value="{$user->_data['user_name']}" placeholder=" ">
			<label class="form-label">{__("Username")}</label>
			<div class="form-text">
				{__("Can only contain alphanumeric characters (A–Z, 0–9) and periods ('.')")}
            </div>
		</div>
    {/if}

    <!-- Secuirty Check -->
    <div class="js_hidden-section x-hidden">
		<div class="heading-small mb-1">
			{__("Secuirty Check")}
		</div>
		
		<div class="form-floating">
			<input type="password" class="form-control" name="password" placeholder=" ">
			<label class="form-label">{__("Current Password")}</label>
			<div class="form-text">
				{__("You need to enter your current password for security check")}
            </div>
		</div>
    </div>
    <!-- Secuirty Check -->

    <!-- success -->
    <div class="alert alert-success mt15 mb0 x-hidden"></div>
    <!-- success -->

    <!-- error -->
    <div class="alert alert-danger mt15 mb0 x-hidden"></div>
    <!-- error -->

	<hr class="hr-2">
	
	<div class="text-end">
		<button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
	</div>
</form>