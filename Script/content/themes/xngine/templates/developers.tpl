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
				{__("Developers")}
			</div>
			
			<div class="d-flex align-items-center justify-content-center">
				{if $system['developers_apps_enabled']}
					<div {if $view == ""}class="active fw-semibold"{/if}>
						<a href="{$system['system_url']}/developers" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Documentation")}</span>
						</a>
					</div>
				{/if}
				{if $user->_logged_in && $system['developers_apps_enabled']}
					<div {if $view == "apps" || $view == "new" || $view == "edit"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/developers/apps" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("My Apps")}</span>
						</a>
					</div>
				{/if}
				{if $system['developers_share_enabled']}
					<div {if $view == "share"}class="active fw-semibold" {/if}>
						<a href="{$system['system_url']}/developers/share" class="body-color side_item_hover w-100 text-center d-block">
							<span class="position-relative d-inline-block py-3">{__("Share Plugin")}</span>
						</a>
					</div>
				{/if}
			</div>
		</div>

		{if $view == ""}

			<!-- docs -->
			<div class="p-3">
				<div class="pb-2 headline-font fw-semibold h4 m-0">
					{__("Documentation")}
				</div>
				<p>
					<small>{__("API Version")} <span class="badge bg-secondary">1.1</span></small>
				</p>
				<p>
					{__("This documentation explain how to register, configure, and develop your app so you can successfully use our APIs")}
				</p>

				<h5 class="mt30 ">{__("Create App")}</h5>
				<p>
					{__("In order for your app to access our APIs, you must register your app using the")} <a href="{$system['system_url']}/developers/apps">{__("App Dashboard")}</a>. {__("Registration creates an App ID that lets us know who you are, helps us distinguish your app from other apps")}.
				</p>
				<ol>
					<li class="mb-2">
						{__("You will need to create a new App")}
						<a class="btn btn-sm btn-primary ml10" href="{$system['system_url']}/developers/new">
							{__("Create New App")}
						</a>
					</li>
					<li class="">
						{__("Once you created your App you will get your")} <span class="badge bg-primary">app_id</span> {__("and")} <span class="badge bg-primary">app_secret</span>
					</li>
				</ol>

				<h5 class="mt30">{__("Log in With")}</h5>
				<p>
					{__("Log in With system is a fast and convenient way for people to create accounts and log into your app. Our Log in With system enables two scenarios, authentication and asking for permissions to access people's data. You can use Login With system simply for authentication or for both authentication and data access")}.
				</p>
				<ol>
					<li class="mb20">
						{__("Starting the OAuth login process, You need to use a link for your app like this")}:
						<pre class="mtb10">&lt;a href="{$system['system_url']}/api/oauth?app_id=YOUR_APP_ID"&gt;Log in With {__($system['system_title'])}&lt;/a&gt;</pre>
						<p>
							{__("The user will be redirect to Log in With page like this")}
						</p>
						<div class="text-center">
							<img class="img-fluid" width="400" src="{$system['system_url']}/content/themes/{$system['theme']}/images/screenshots/login_with.png">
						</div>
					</li>
					<li class="mb20">
						{__("Once the user accpeted your app, the user will be redirected to your App Redirect URL with")} <span class="badge bg-info">auth_key</span> {__("like this")}:
						<pre class="mtb10">https://mydomain.com/my_redirect_url.php?auth_key=AUTH_KEY</pre>
						{__("This")} <span class="badge bg-info">auth_key</span> {__("valid only for one time usage, so once you used it you will not be able to use it again and generate new code you will need to redirect the user to the log in with link again")}.
					</li>
				</ol>

				<h5 class="mt30">{__("Access Token")}</h5>
				<p>
					{__("Once you get the user approval of your app Log in With window and returned with the")} <span class="badge bg-info">auth_key</span> {__("which means that now you are ready to retrive data from our APIs and to start this process you will need to authorize your app and get the")} <span class="badge bg-danger">access_token</span> {__("and you can follow our steps to learn how to get it")}.
				</p>
				<ol>
					<li class="mb20">
						{__("To get an access token, make an HTTP GET request to the following endpoint like this")}:
						<pre class="mtb10">
&lt;?php

$app_id = "YOUR_APP_ID"; // your app id
$app_secret = "YOUR_APP_SECRET"; // your app secret
$auth_key = $_GET['auth_key']; // the returned auth key from previous step

// Prepare the POST data
$postData = [
  'app_id' => $app_id,
  'app_secret' => $app_secret,
  'auth_key' => $auth_key
];

// Initialize cURL
$ch = curl_init('{$system['system_url']}/api/authorize');

// Set cURL options for POST
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($postData));

// Execute request
$response = curl_exec($ch);

// Check for cURL errors
if (curl_errno($ch)) {
  die('cURL error: ' . curl_error($ch));
}

curl_close($ch);

// Decode the JSON response
$json = json_decode($response, true);

// Use the access token if available
if (!empty($json['access_token'])) {
  $access_token = $json['access_token']; // your access token
}
?&gt;
</pre>
						{__("This")} <span class="badge bg-danger">access_token</span> {__("valid only for only one 1 hour, so once it got invalid you will need to genarte new one by redirect the user to the log in with link again")}.
					</li>
				</ol>

				<h5 class="mt30">{__("APIs")}</h5>
				<p>
					{__("Once you get your")} <span class="badge bg-danger">access_token</span> {__("Now you can retrieve informations from our system via HTTP GET requests which supports the following parameters")}
				</p>
				<div class="table-responsive">
					<table class="table table-striped table-bordered table-hover">
						<thead>
							<tr>
								<th>{__("Endpoint")}</th>
								<th>{__("Description")}</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>api/<span class="badge bg-warning">get_user_info</span></td>
								<td>{__("get user info")}</td>
							</tr>
						</tbody>
					</table>
				</div>
				<p>
					{__("You can retrive user info like this")}
				</p>
				<pre>
            if(!empty($json['access_token'])) {
                $access_token = $json['access_token']; // your access token
                $get = file_get_contents("{$system['system_url']}/api/get_user_info?access_token=$access_token");
            }
				</pre>
				<p>
					{__("The result will be")}:
				</p>
				<pre>
            {
              "user_info": {
              "user_id": "",
              "user_name": "",
              "user_email": "",
              "user_firstname": "",
              "user_lastname": "",
              "user_gender": "",
              "user_birthdate": "",
              "user_picture": "",
              "user_cover": "",
              "user_registered": "",
              "user_verified": "",
              "user_relationship": "",
              "user_biography": "",
              "user_website": ""
              }
            }
				</pre>
			</div>
			<!-- docs -->

		{elseif $view == "apps"}

			<!-- apps -->
			<div class="p-3">
				<div class="d-flex align-items-center justify-content-between gap-3 flex-wrap pb-3">
					<div class="headline-font fw-semibold h4 m-0">
						{__("My Apps")}
					</div>
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/developers/new">
						{__("Create New App")}
					</a>
				</div>

				{if $apps}
				<div class="table-responsive">
					<table class="table table-hover bg-transparent align-middle">
						<thead>
							<tr>
								<th class="fw-semibold bg-transparent">{__("ID")}</th>
								<th class="fw-semibold bg-transparent">{__("App Name")}</th>
								<th class="fw-semibold bg-transparent bg-transparent">{__("App ID")}</th>
								<th class="fw-semibold bg-transparent">{__("Created")}</th>
								<th class="fw-semibold bg-transparent"></th>
							</tr>
						</thead>
						<tbody>
							{foreach $apps as $app}
								<tr>
									<td class="bg-transparent">{$app@iteration}</td>
									<td class="bg-transparent">
										<a target="_blank" href="{$system['system_url']}/developers/edit/{$app['app_auth_id']}">
											<img class="tbl-image" src="{$system['system_uploads']}/{$app['app_icon']}">
											{$app['app_name']}
										</a>
									</td>
									<td class="bg-transparent">{$app['app_auth_id']}</td>
									<td class="bg-transparent">
										<span class="js_moment" data-time="{$app['app_date']}">{$app['app_date']}</span>
									</td>
									<td class="bg-transparent text-end">
										<a data-bs-toggle="tooltip" title='{__("Edit")}' href="{$system['system_url']}/developers/edit/{$app['app_auth_id']}" class="btn btn-gray border-0 p-2 rounded-circle lh-1">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M16.9459 3.17305C17.5332 2.58578 17.8268 2.29215 18.1521 2.15173C18.6208 1.94942 19.1521 1.94942 19.6208 2.15173C19.946 2.29215 20.2397 2.58578 20.8269 3.17305C21.4142 3.76032 21.7079 4.05395 21.8483 4.37925C22.0506 4.8479 22.0506 5.37924 21.8483 5.84789C21.7079 6.17319 21.4142 6.46682 20.8269 7.05409L15.8054 12.0757C14.5682 13.3129 13.9496 13.9315 13.1748 14.298C12.4 14.6645 11.5294 14.7504 9.78823 14.9222L9 15L9.07778 14.2118C9.24958 12.4706 9.33549 11.6 9.70201 10.8252C10.0685 10.0504 10.6871 9.43183 11.9243 8.19464L16.9459 3.17305Z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M6 15H3.75C2.7835 15 2 15.7835 2 16.75C2 17.7165 2.7835 18.5 3.75 18.5H13.25C14.2165 18.5 15 19.2835 15 20.25C15 21.2165 14.2165 22 13.25 22H11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
										</a>
										<button data-bs-toggle="tooltip" title='{__("Delete")}' class="btn btn-gray border-0 p-2 rounded-circle lh-1 text-danger js_developers-delete-app" data-id="{$app['app_auth_id']}">
											<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none"><path d="M19.5 5.5L18.8803 15.5251C18.7219 18.0864 18.6428 19.3671 18.0008 20.2879C17.6833 20.7431 17.2747 21.1273 16.8007 21.416C15.8421 22 14.559 22 11.9927 22C9.42312 22 8.1383 22 7.17905 21.4149C6.7048 21.1257 6.296 20.7408 5.97868 20.2848C5.33688 19.3626 5.25945 18.0801 5.10461 15.5152L4.5 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M3 5.5H21M16.0557 5.5L15.3731 4.09173C14.9196 3.15626 14.6928 2.68852 14.3017 2.39681C14.215 2.3321 14.1231 2.27454 14.027 2.2247C13.5939 2 13.0741 2 12.0345 2C10.9688 2 10.436 2 9.99568 2.23412C9.8981 2.28601 9.80498 2.3459 9.71729 2.41317C9.32164 2.7167 9.10063 3.20155 8.65861 4.17126L8.05292 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M9.5 16.5L9.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M14.5 16.5L14.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
										</button>
									</td>
								</tr>
							{/foreach}
						</tbody>
					</table>
				</div>
				{else}
					{include file='_no_data.tpl'}
				{/if}
			</div>
			<!-- apps -->

		{elseif $view == "new"}

			<!-- new app -->
			<div class="p-3">
				<div class="pb-3 headline-font fw-semibold h4 m-0">
					{__("Create New App")}
				</div>
				
				<form class="js_ajax-forms" data-url="developers/app.php?do=create">
					<div class="form-floating">
						<input type="text" class="form-control" name="app_name" placeholder=" ">
						<label class="form-label" for="app_name">{__("App Name")}</label>
						<div class="form-text">
							{__("Your App Name")}
						</div>
					</div>
					
					<div class="form-floating">
						<input type="text" class="form-control" name="app_domain" placeholder=" ">
						<label class="form-label" for="app_domain">{__("App Domain")}</label>
						<div class="form-text">
							{__("Your App domain (example: www.domain.com)")}
						</div>
					</div>
					
					<div class="form-floating">
						<input type="text" class="form-control" name="app_redirect_url" placeholder=" ">
						<label class="form-label" for="app_redirect_url">{__("Redirect URL")}</label>
						<div class="form-text">
							{__("Your App Redirect URL (example: https://www.domain.com/test.php)")}
						</div>
					</div>
					
					<div class="form-floating">
						<textarea class="form-control" name="app_description" rows="5" placeholder=" "></textarea>
						<label class="form-label" for="app_description">{__("App Description")}</label>
						<div class="form-text">
							{__("Set a description for your App (maximum 200 characters)")}
						</div>
					</div>
					
					<div class="form-floating">
						<select class="form-select" name="app_category" id="app_category">
							<option>{__("Select Category")}</option>
							{foreach $categories as $category}
								{include file='__categories.recursive_options.tpl'}
							{/foreach}
						</select>
						<label class="form-label" for="app_category">{__("Category")}</label>
						<div class="form-text">
							{__("Select a category for your App")}
						</div>
					</div>
					
					<div class="form-group">
						<label class="form-label" for="app_icon">{__("App Icon (1024 x 1024)")}</label>
						<div class="x-image">
							<button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
							<div class="x-image-loader">
								<div class="progress x-progress">
									<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
								</div>
							</div>
							<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
							<input type="hidden" class="js_x-image-input" name="app_icon">
						</div>
						<div class="form-text">
							{__("App Icon (1024 x 1024), supported formats (JPG, PNG)")}
						</div>
					</div>

					<!-- error -->
					<div class="alert alert-danger mt15 mb0 x-hidden"></div>
					<!-- error -->

					<hr class="hr-2">
					
					<div class="text-end">
						<button type="submit" class="btn btn-primary">
							{__("Create")}
						</button>
					</div>
				</form>
			</div>
			<!-- new app -->

		{elseif $view == "edit"}

			<!-- edit app -->
			<div class="p-3">
				<div class="pb-3 headline-font fw-semibold h4 m-0">
					{__("Edit App")}
				</div>
				
				<form class="js_ajax-forms" data-url="developers/app.php?do=edit&id={$app['app_auth_id']}">
					<div class="form-floating">
						<input disabled type="text" class="form-control" name="app_auth_id" value="{$app['app_auth_id']}" placeholder=" ">
						<label class="form-label" for="app_auth_id">{__("App ID")}</label>
					</div>
					
					<div class="form-floating">
						<input disabled type="text" class="form-control" name="app_auth_secret" value="{$app['app_auth_secret']}" placeholder=" ">
						<label class="form-label" for="app_auth_secret">{__("App Secret")}</label>
					</div>
					
					<div class="form-floating">
						<input type="text" class="form-control" name="app_name" value="{$app['app_name']}" placeholder=" ">
						<label class="form-label" for="app_name">{__("App Name")}</label>
						<div class="form-text">
							{__("Your App Name")}
						</div>
					</div>
				  
					<div class="form-floating">
						<input type="text" class="form-control" name="app_domain" value="{$app['app_domain']}" placeholder=" ">
						<label class="form-label" for="app_domain">{__("App Domain")}</label>
						<div class="form-text">
							{__("Your App domain (example: www.domain.com)")}
						</div>
					</div>
				  
					<div class="form-floating">
						<input type="text" class="form-control" name="app_redirect_url" value="{$app['app_redirect_url']}" placeholder=" ">
						<label class="form-label" for="app_redirect_url">{__("Redirect URL")}</label>
						<div class="form-text">
							{__("Your App Redirect URL (example: https://www.domain.com/test.php)")}
						</div>
					</div>
				  
					<div class="form-floating">
						<textarea class="form-control" name="app_description" rows="5" placeholder=" ">{$app['app_description']}</textarea>
						<label class="form-label" for="app_description">{__("App Description")}</label>
						<div class="form-text">
							{__("Set a description for your App (maximum 200 characters)")}
						</div>
					</div>
					
					<div class="form-floating">
						<select class="form-select" name="app_category" id="app_category">
							<option>{__("Select Category")}</option>
							{foreach $categories as $category}
								{include file='__categories.recursive_options.tpl' data_category=$app['app_category_id']}
							{/foreach}
						</select>
						<label class="form-label" for="app_category">{__("Category")}</label>
						<div class="form-text">
							{__("Select a category for your App")}
						</div>
					</div>
					
					<div class="form-group">
						<label class="form-label" for="app_icon">{__("App Icon (1024 x 1024)")}</label>

						{if $app['app_icon'] == ''}
							<div class="x-image">
								<button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
								<div class="x-image-loader">
									<div class="progress x-progress">
										<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
									</div>
								</div>
								<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
								<input type="hidden" class="js_x-image-input" name="app_icon">
							</div>
						{else}
							<div class="x-image" style="background-image: url('{$system['system_uploads']}/{$app['app_icon']}')">
								<button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'></button>
								<div class="x-image-loader">
									<div class="progress x-progress">
										<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
									</div>
								</div>
								<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
								<input type="hidden" class="js_x-image-input" name="app_icon" value="{$app['app_icon']}">
							</div>
						{/if}
						<div class="form-text">
							{__("App Icon (1024 x 1024), supported formats (JPG, PNG)")}
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
						<button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
					</div>
				</form>
			</div>
			<!-- edit app -->

		{elseif $view == "share"}

			<!-- share plugin -->
			<div class="p-3">
				<div class="pb-2 headline-font fw-semibold h4 m-0">
					{__("Share Plugin")}
				</div>

				<h6>
					{__("Add the following code in your site, inside the head tag")}:
				</h6>
				<pre>
&lt;script&gt;
 function SocialShare(url) {
  window.open('{$system['system_url']}/share?url=' + url, '', 'height=600,width=800');
 }
&lt;/script&gt;
				</pre>
				<h6>
					{__("Then place the share button after changing the URL you want to share to your page HTML")}:
				</h6>
				<pre>&lt;button onclick="SocialShare('http://yoursite.com/')"&gt;Share&lt;/button&gt;</pre>
				<h6>
					{__("Also you can use this code to share the current page")}:
				</h6>
				<pre>&lt;button onclick="SocialShare(window.location.href)"&gt;Share&lt;/button&gt;</pre>
				<h6>
					{__("Example")}:
				</h6>
				<script>
				function SocialShare(url) {
					window.open(site_path + '/share?url=' + url, '', 'height=600,width=800');
				}
				</script>
				<button class="btn btn-md btn-primary" onclick="SocialShare(window.location.href)">{__("Share")}</button>
			</div>
			<!-- share plugin -->

		{/if}
    </div>
    <!-- content panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}