{if $sub_view == "password"}
	<div class="p-3 w-100">
		<div class="x-hidden x_menu_sidebar_back mb-3">
			<button type="button" class="btn btn-gray w-100">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
				{__("More Settings")}
			</button>
		</div>
		<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
			{__("Change Password")}
		</div>
	</div>

	<form class="js_ajax-forms p-3 pt-1" data-url="users/settings.php?edit=password">
		<div class="alert alert-warning">
			<div class="text pt5">
				{__("Changing password will log you out from all other sessions")}
			</div>
		</div>

		<div class="form-floating">
			<input type="password" class="form-control" name="current" placeholder=" ">
			<label class="form-label">{__("Confirm Current Password")}</label>
		</div>

        <div class="form-floating">
			<input type="password" class="form-control" name="new" placeholder=" ">
			<label class="form-label">{__("Your New Password")}</label>
        </div>
		
        <div class="form-floating">
			<input type="password" class="form-control" name="confirm" placeholder=" ">
			<label class="form-label">{__("Confirm New Password")}</label>
        </div>

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

{elseif $sub_view == "sessions"}
	<div class="p-3 w-100">
		<div class="x-hidden x_menu_sidebar_back mb-3">
			<button type="button" class="btn btn-gray w-100">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
				{__("More Settings")}
			</button>
		</div>
		<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3 mb-2">
			{__("Manage Sessions")}
		</div>
		
		<button class="btn btn-sm btn-danger js_session-delete-all">
			{__("Log Out Of All Sessions")}
		</button>
	</div>
	
	<div class="p-3 pt-1">
		<div class="table-responsive">
			<table class="table table-hover align-middle">
				<thead>
					<tr>
						<th class="fw-semibold bg-transparent">{__("ID")}</th>
						<th class="fw-semibold bg-transparent">{__("OS")}</th>
						<th class="fw-semibold bg-transparent">{__("Date")}</th>
						<th class="fw-semibold bg-transparent">{__("IP")}</th>
						<th class="fw-semibold bg-transparent"></th>
					</tr>
				</thead>
				<tbody>
					{if $sessions}
						{foreach $sessions as $session}
							<tr>
								<td class="bg-transparent">{$session@iteration}</td>
								<td class="bg-transparent">
									<div>{$session['user_os']}</div>
									<div class="text-muted small">{$session['user_browser']} {if $session['session_id'] == $user->_data['active_session_id']}<span class="badge rounded-pill bg-success">{__("Active Session")}</span>{/if}</div>
								</td>
								<td class="bg-transparent">
									<span class="js_moment" data-time="{$session['session_date']}">{$session['session_date']}</span>
								</td>
								<td class="bg-transparent">{$session['user_ip']}</td>
								<td class="bg-transparent text-end">
									<button data-bs-toggle="tooltip" title='{__("End Session")}' class="btn btn-gray border-0 p-2 rounded-circle lh-1 text-danger js_session-deleter" data-id="{$session['session_id']}" {if $session['session_id'] == $user->_data['active_session_id']} onclick="localStorage.clear();" {/if}>
										<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M19.5 5.5L18.8803 15.5251C18.7219 18.0864 18.6428 19.3671 18.0008 20.2879C17.6833 20.7431 17.2747 21.1273 16.8007 21.416C15.8421 22 14.559 22 11.9927 22C9.42312 22 8.1383 22 7.17905 21.4149C6.7048 21.1257 6.296 20.7408 5.97868 20.2848C5.33688 19.3626 5.25945 18.0801 5.10461 15.5152L4.5 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M3 5.5H21M16.0557 5.5L15.3731 4.09173C14.9196 3.15626 14.6928 2.68852 14.3017 2.39681C14.215 2.3321 14.1231 2.27454 14.027 2.2247C13.5939 2 13.0741 2 12.0345 2C10.9688 2 10.436 2 9.99568 2.23412C9.8981 2.28601 9.80498 2.3459 9.71729 2.41317C9.32164 2.7167 9.10063 3.20155 8.65861 4.17126L8.05292 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M9.5 16.5L9.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M14.5 16.5L14.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
									</button>
								</td>
							</tr>
						{/foreach}
					{else}
						<tr>
							<td colspan="5" class="text-center">
								{__("No data to show")}
							</td>
						</tr>
					{/if}
				</tbody>
			</table>
		</div>
	</div>

{elseif $sub_view == "two-factor"}
	<div class="p-3 w-100">
		<div class="x-hidden x_menu_sidebar_back mb-3">
			<button type="button" class="btn btn-gray w-100">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
				{__("More Settings")}
			</button>
		</div>
		<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
			{__("Two-Factor Authentication")}
		</div>
	</div>
	
	<form class="js_ajax-forms p-3 pt-1" data-url="users/settings.php?edit=two-factor">
		<div class="alert alert-info">
			<div class="text">
				<strong>{__("Two-Factor Authentication")}</strong><br>
				{__("Log in with a code from your")}
				{if $system['two_factor_type'] == "email"}{__("email")}{/if}
				{if $system['two_factor_type'] == "sms"}{__("phone")}{/if}
				{if $system['two_factor_type'] == "google"}{__("Google Authenticator App")}{/if}
				{__("as well as a password")}
			</div>
		</div>
		
		{if !$user->_data['user_two_factor_enabled'] && $system['two_factor_type'] == "google"}
			<div class="heading-small mb-1">
				{__("Configuring your authenticator")}
			</div>

			<ol class="mb-3">
				<li class="mb5">
					{__("You need to download Google Authenticator app for")} <a target="_blank" href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en">{__("Android")}</a> {__("or")} <a target="_blank" href="https://itunes.apple.com/eg/app/google-authenticator/id388497605?mt=8">{__("IOS")}</a>
				</li>
				<li>
					{__("In your app, add a new account using the details below")}:
				</li>
			</ol>

			<div class="row text-center">
				<div class="col-md-6 mb-3">
					<h6>{__("Scanning the QR code")}</h6>
					<img src="{$two_factor_QR}">
				</div>
				<div class="col-md-6 align-self-center mb-3">
					<h6>{__("Manually by entering this token")}</h6>
					<h3>
						<span class="badge bg-success">{$two_factor_gsecret}</span>
					</h3>
				</div>
			</div>

			<div class="heading-small mb-1">
				{__("Activate your authenticator")}
			</div>

			<div class="form-floating">
				<input name="gcode" type="text" class="form-control" placeholder="######" required autofocus>
				<label class="form-label">{__("Verification Code")}</label>
				<div class="form-text">
					{__("Enter the code shown on your app")}
				</div>
			</div>

			<!-- success -->
			<div class="alert alert-success mt15 mb0 x-hidden"></div>
			<!-- success -->

			<!-- error -->
			<div class="alert alert-danger mt15 mb0 x-hidden"></div>
			<!-- error -->

		{else}
			<div class="form-table-row mb-2 pb-1">
				<div>
					<div class="form-label mb0">{__("Two-Factor Authentication")}</div>
					<div class="form-text d-none d-sm-block mt0">{__("Enable two-factor authentication to log in with a code from your email/phone as well as a password")}</div>
				</div>
				<div class="text-end align-self-center flex-0">
					<label class="switch" for="two_factor_enabled">
						<input type="checkbox" name="two_factor_enabled" id="two_factor_enabled" {if $user->_data['user_two_factor_enabled']}checked{/if}>
						<span class="slider round"></span>
					</label>
				</div>
			</div>

			<!-- success -->
			<div class="alert alert-success mt15 mb0 x-hidden"></div>
			<!-- success -->

			<!-- error -->
			<div class="alert alert-danger mt15 mb0 x-hidden"></div>
			<!-- error -->
		{/if}
	  
		<hr class="hr-2">

		<div class="text-end">
			<input type="hidden" name="type" value="{$system['two_factor_type']}">
			<button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
		</div>
	</form>

{/if}