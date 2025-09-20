{if $sub_view == ""}
	<div class="p-3 w-100">
		<div class="x-hidden x_menu_sidebar_back mb-3">
			<button type="button" class="btn btn-gray w-100">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
				{__("More Settings")}
			</button>
		</div>
		<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
			{__("Basic")} {__("Settings")}
		</div>
	</div>

	<form class="js_ajax-forms p-3 pt-1" data-url="users/settings.php?edit=basic">
		{if !$system['show_usernames_enabled'] && $user->_data['user_verified']}
			<div class="alert alert-warning">
				<div class="text">
					<strong>{__("Attention")}</strong><br>
					{__("Your account is already verified if you changed your name you will lose the verification badge")}
				</div>
			</div>
		{/if}
		
		<div class="row">
			{if !$system['show_usernames_enabled']}
				<div class="col-md-6">
					<div class="form-floating">
						<input type="text" class="form-control" name="firstname" value="{$user->_data['user_firstname']}" placeholder=" ">
						<label class="form-label">{__("First Name")}</label>
					</div>
				</div>
				<div class="col-md-6">
					<div class="form-floating">
						<input type="text" class="form-control" name="lastname" value="{$user->_data['user_lastname']}" placeholder=" ">
						<label class="form-label">{__("Last Name")}</label>
					</div>
				</div>
			{/if}
			{if !$system['genders_disabled']}
				<div class="col-md-6">
					<div class="form-floating">
						<select class="form-select" name="gender">
							<option value="none">{__("Select Sex")}</option>
							{foreach $genders as $gender}
								<option {if $user->_data['user_gender'] == $gender['gender_id']}selected{/if} value="{$gender['gender_id']}">{$gender['gender_name']}</option>
							{/foreach}
						</select>
						<label class="form-label">{__("I am")}</label>
					</div>
				</div>
			{/if}
			{if $system['relationship_info_enabled']}
				<div class="col-md-6">
					<div class="form-floating">
						<select class="form-select" name="relationship">
							<option value="none">{__("Select Relationship")}</option>
							<option {if $user->_data['user_relationship'] == "single"}selected{/if} value="single">{__("Single")}</option>
							<option {if $user->_data['user_relationship'] == "relationship"}selected{/if} value="relationship">{__("In a relationship")}</option>
							<option {if $user->_data['user_relationship'] == "married"}selected{/if} value="married">{__("Married")}</option>
							<option {if $user->_data['user_relationship'] == "complicated"}selected{/if} value="complicated">{__("It's complicated")}</option>
							<option {if $user->_data['user_relationship'] == "separated"}selected{/if} value="separated">{__("Separated")}</option>
							<option {if $user->_data['user_relationship'] == "divorced"}selected{/if} value="divorced">{__("Divorced")}</option>
							<option {if $user->_data['user_relationship'] == "widowed"}selected{/if} value="widowed">{__("Widowed")}</option>
						</select>	
						<label class="form-label">{__("Relationship Status")}</label>
					</div>
				</div>
			{/if}
		</div>
		
		<div class="form-floating">
			<select class="form-select" name="country">
				<option value="none">{__("Select Country")}</option>
				{foreach $countries as $country}
					<option {if $user->_data['user_country'] == $country['country_id']}selected{/if} value="{$country['country_id']}">{$country['country_name']}</option>
				{/foreach}
			</select>
			<label class="form-label">{__("Country")}</label>
		</div>
		
		{if $system['website_info_enabled']}
			<div class="form-floating">
				<input type="text" class="form-control" name="website" value="{$user->_data['user_website']}" placeholder=" ">
				<label class="form-label">{__("Website")}</label>
				<div class="form-text">
					{__("Website link must start with http:// or https://")}
				</div>
			</div>
        {/if}
		
		{if $system['biography_info_enabled']}
			<div class="form-floating">
				<textarea class="form-control" name="biography" placeholder=" " rows="4">{$user->_data['user_biography']}</textarea>
				<label class="form-label">{__("About Me")}</label>
			</div>
		{/if}
		
		<div><label class="form-label">{__("Birthdate")}</label></div>
		<div class="row">
			<div class="col">
				<div class="form-floating">
					<select class="form-select" name="birth_month">
						<option value="none">{__("Select Month")}</option>
						<option {if $user->_data['user_birthdate_parsed']['month'] == '1'}selected{/if} value="1">{__("Jan")}</option>
						<option {if $user->_data['user_birthdate_parsed']['month'] == '2'}selected{/if} value="2">{__("Feb")}</option>
						<option {if $user->_data['user_birthdate_parsed']['month'] == '3'}selected{/if} value="3">{__("Mar")}</option>
						<option {if $user->_data['user_birthdate_parsed']['month'] == '4'}selected{/if} value="4">{__("Apr")}</option>
						<option {if $user->_data['user_birthdate_parsed']['month'] == '5'}selected{/if} value="5">{__("May")}</option>
						<option {if $user->_data['user_birthdate_parsed']['month'] == '6'}selected{/if} value="6">{__("Jun")}</option>
						<option {if $user->_data['user_birthdate_parsed']['month'] == '7'}selected{/if} value="7">{__("Jul")}</option>
						<option {if $user->_data['user_birthdate_parsed']['month'] == '8'}selected{/if} value="8">{__("Aug")}</option>
						<option {if $user->_data['user_birthdate_parsed']['month'] == '9'}selected{/if} value="9">{__("Sep")}</option>
						<option {if $user->_data['user_birthdate_parsed']['month'] == '10'}selected{/if} value="10">{__("Oct")}</option>
						<option {if $user->_data['user_birthdate_parsed']['month'] == '11'}selected{/if} value="11">{__("Nov")}</option>
						<option {if $user->_data['user_birthdate_parsed']['month'] == '12'}selected{/if} value="12">{__("Dec")}</option>
					</select>
					<label class="form-label">{__("Select Month")}</label>
				</div>
			</div>
			<div class="col">
				<div class="form-floating">
					<select class="form-select" name="birth_day">
						<option value="none">{__("Select Day")}</option>
						{for $i=1 to 31}
							<option {if $user->_data['user_birthdate_parsed']['day'] == $i}selected{/if} value="{$i}">{$i}</option>
						{/for}
					</select>
					<label class="form-label">{__("Select Day")}</label>
				</div>
			</div>
			<div class="col">
				<div class="form-floating">
					<select class="form-select" name="birth_year">
						<option value="none">{__("Select Year")}</option>
						{for $i=1905 to 2023}
							<option {if $user->_data['user_birthdate_parsed']['year'] == $i}selected{/if} value="{$i}">{$i}</option>
						{/for}
					</select>
					<label class="form-label">{__("Select Year")}</label>
				</div>
			</div>
        </div>

		<!-- custom fields -->
		{if $custom_fields['basic']}
			{include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
		{/if}
		<!-- custom fields -->

		<!-- success -->
		<div class="alert alert-success mt15 x-hidden"></div>
		<!-- success -->

		<!-- error -->
		<div class="alert alert-danger mt15 x-hidden"></div>
		<!-- error -->
		
		<hr class="hr-2 mt-0">

		<div class="text-end">
			<button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
		</div>
	</form>

{elseif $sub_view == "work"}
	<div class="p-3 w-100">
		<div class="x-hidden x_menu_sidebar_back mb-3">
			<button type="button" class="btn btn-gray w-100">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
				{__("More Settings")}
			</button>
		</div>
		<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
			{__("Work")} {__("Settings")}
		</div>
	</div>
	
	<form class="js_ajax-forms p-3 pt-1" data-url="users/settings.php?edit=work">
		<div class="form-floating">
			<input type="text" class="form-control" name="work_title" value="{$user->_data['user_work_title']}" placeholder=" ">
			<label class="form-label">{__("Work Title")}</label>
		</div>

		<div class="form-floating">
			<input type="text" class="form-control" name="work_place" value="{$user->_data['user_work_place']}" placeholder=" ">
			<label class="form-label">{__("Work Place")}</label>
		</div>

		<div class="form-floating">
			<input type="text" class="form-control" name="work_url" value="{$user->_data['user_work_url']}" placeholder=" ">
			<label class="form-label">{__("Work Website")}</label>
			<div class="form-text">
				{__("Website link must start with http:// or https://")}
			</div>
		</div>

		<!-- custom fields -->
		{if $custom_fields['work']}
			{include file='__custom_fields.tpl' _custom_fields=$custom_fields['work'] _registration=false}
		{/if}
		<!-- custom fields -->
	
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

{elseif $sub_view == "location"}
	<div class="p-3 w-100">
		<div class="x-hidden x_menu_sidebar_back mb-3">
			<button type="button" class="btn btn-gray w-100">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
				{__("More Settings")}
			</button>
		</div>
		<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
			{__("Location")} {__("Settings")}
		</div>
	</div>
	
	<form class="js_ajax-forms p-3 pt-1" data-url="users/settings.php?edit=location">
		<div class="form-floating">
			<input type="text" class="form-control js_geocomplete" name="city" value="{$user->_data['user_current_city']}" placeholder=" ">
			<label class="form-label">{__("Current City")}</label>
		</div>

		<div class="form-floating">
			<input type="text" class="form-control js_geocomplete" name="hometown" value="{$user->_data['user_hometown']}" placeholder=" ">
			<label class="form-label">{__("Hometown")}</label>
		</div>

		<!-- custom fields -->
		{if $custom_fields['location']}
			{include file='__custom_fields.tpl' _custom_fields=$custom_fields['location'] _registration=false}
		{/if}
		<!-- custom fields -->

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

{elseif $sub_view == "education"}
	<div class="p-3 w-100">
		<div class="x-hidden x_menu_sidebar_back mb-3">
			<button type="button" class="btn btn-gray w-100">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
				{__("More Settings")}
			</button>
		</div>
		<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
			{__("Education")} {__("Settings")}
		</div>
	</div>
	
	<form class="js_ajax-forms p-3 pt-1" data-url="users/settings.php?edit=education">
		<div class="form-floating">
			<input type="text" class="form-control" name="edu_school" value="{$user->_data['user_edu_school']}" placeholder=" ">
			<label class="form-label">{__("School")}</label>
		</div>

		<div class="form-floating">
			<input type="text" class="form-control" name="edu_major" value="{$user->_data['user_edu_major']}" placeholder=" ">
			<label class="form-label">{__("Major")}</label>
		</div>

		<div class="form-floating">
			<input type="text" class="form-control" name="edu_class" value="{$user->_data['user_edu_class']}" placeholder=" ">
			<label class="form-label">{__("Class")}</label>
		</div>

		<!-- custom fields -->
		{if $custom_fields['education']}
			{include file='__custom_fields.tpl' _custom_fields=$custom_fields['education'] _registration=false}
		{/if}
		<!-- custom fields -->

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

{elseif $sub_view == "other"}
	<div class="p-3 w-100">
		<div class="x-hidden x_menu_sidebar_back mb-3">
			<button type="button" class="btn btn-gray w-100">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
				{__("More Settings")}
			</button>
		</div>
		<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
			{__("Other")} {__("Settings")}
		</div>
	</div>
	
	<form class="js_ajax-forms p-3 pt-1" data-url="users/settings.php?edit=other">
		<!-- custom fields -->
		{if $custom_fields['other']}
			{include file='__custom_fields.tpl' _custom_fields=$custom_fields['other'] _registration=false}
		{/if}
		<!-- custom fields -->

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

{elseif $sub_view == "social"}
	<div class="p-3 w-100">
		<div class="x-hidden x_menu_sidebar_back mb-3">
			<button type="button" class="btn btn-gray w-100">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
				{__("More Settings")}
			</button>
		</div>
		<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
			{__("Social Links")} {__("Settings")}
		</div>
	</div>
	
	<form class="js_ajax-forms p-3 pt-1" data-url="users/settings.php?edit=social">
		<div class="form-floating">
			<input type="text" class="form-control" name="facebook" value="{$user->_data['user_social_facebook']}" placeholder=" ">
			<label class="form-label">{__("Facebook Profile URL")}</label>
		</div>

		<div class="form-floating">
			<input type="text" class="form-control" name="twitter" value="{$user->_data['user_social_twitter']}" placeholder=" ">
			<label class="form-label">{__("X Profile URL")}</label>
		</div>

		<div class="form-floating">
			<input type="text" class="form-control" name="youtube" value="{$user->_data['user_social_youtube']}" placeholder=" ">
			<label class="form-label">{__("YouTube Profile URL")}</label>
		</div>

		<div class="form-floating">
			<input type="text" class="form-control" name="instagram" value="{$user->_data['user_social_instagram']}" placeholder=" ">
			<label class="form-label">{__("Instagram Profile URL")}</label>
		</div>

		<div class="form-floating">
			<input type="text" class="form-control" name="twitch" value="{$user->_data['user_social_twitch']}" placeholder=" ">
			<label class="form-label">{__("Twitch Profile URL")}</label>
		</div>

		<div class="form-floating">
			<input type="text" class="form-control" name="linkedin" value="{$user->_data['user_social_linkedin']}" placeholder=" ">
			<label class="form-label">{__("LinkedIn Profile URL")}</label>
		</div>

		<div class="form-floating">
			<input type="text" class="form-control" name="vkontakte" value="{$user->_data['user_social_vkontakte']}" placeholder=" ">
			<label class="form-label">{__("Vkontakte Profile URL")}</label>
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

{elseif $sub_view == "design"}
	<div class="p-3 w-100">
		<div class="x-hidden x_menu_sidebar_back mb-3">
			<button type="button" class="btn btn-gray w-100">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
				{__("More Settings")}
			</button>
		</div>
		<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
			{__("Design")} {__("Settings")}
		</div>
	</div>
	
	<form class="js_ajax-forms p-3 pt-1" data-url="users/settings.php?edit=design">
		<div>
			<label class="form-label">{__("Profile Background")}</label>
		</div>
		
		{if $user->_data['user_profile_background'] == ''}
            <div class="x-image">
				<button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
				<div class="x-image-loader">
					<div class="progress x-progress">
						<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				</div>
				<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
				<input type="hidden" class="js_x-image-input" name="user_profile_background" value="">
            </div>
		{else}
            <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$user->_data['user_profile_background']}')">
				<button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'></button>
				<div class="x-image-loader">
					<div class="progress x-progress">
						<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				</div>
				<i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
				<input type="hidden" class="js_x-image-input" name="user_profile_background" value="{$user->_data['user_profile_background']}">
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
			<button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
		</div>
	</form>
{/if}