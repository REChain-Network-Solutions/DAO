{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
.search-wrapper-prnt {
display: none !important
}
</style>

<!-- page content -->
<div class="row x_content_row">
    <div class="col-lg-12 w-100">
		<div class="row m-0">
			<div class="col-md-6 col-lg-5 mx-md-auto">
				<div class="fr_auth_form">
					<div class="text-center my-4">
						<h2 class="m-0 fr_welcome_title">{__("Welcome")}, {$user_profile->displayName}</h2>
					</div>

					<div class="text-center my-4">
						<img class="img-thumbnail rounded-circle" src="{$user_profile->photoURL}" width="99" height="99">
					</div>

					<form class="js_ajax-forms" data-url="core/signup_social.php">
						{if $system['invitation_enabled']}
							<!-- invitation code -->
							<div class="form-floating">
								<input name="invitation_code" type="text" placeholder=' ' class="form-control" value="{$invitation_code}" required>
								<label class="form-label">{__("Invitation Code")}</label>
							</div>
							<!-- invitation code -->
						{/if}
						
						{if !$system['show_usernames_enabled']}
							<!-- first name -->
							<div class="form-floating">
								<input name="first_name" type="text" placeholder=' ' value="{$user_profile->firstName}" class="form-control" required>
								<label class="form-label">{__("First name")}</label>
							</div>
							<!-- first name -->

							<!-- last name -->
							<div class="form-floating">
								<input name="last_name" type="text" placeholder=' ' value="{$user_profile->lastName}" class="form-control" required>
								<label class="form-label">{__("Last name")}</label>
							</div>
							<!-- last name -->
						{/if}
				
						<div class="form-floating">
							<input name="username" type="text" class="form-control" placeholder=' ' required>
							<label class="form-label">{__("Username")}</label>
						</div>
					  
						<div class="form-floating">
							<input name="email" type="email" class="form-control" placeholder=' ' value="{$user_profile->email}" required>
							<label class="form-label">{__("Email")}</label>
						</div>
						
						{if $system['activation_enabled'] && $system['activation_type'] == "sms"}
							<!-- phone -->
							<div class="form-floating">
								<input name="phone" type="text" class="form-control" placeholder=' ' required>
								<label class="form-label">{__("Phone number")}</label>
							</div>
							<!-- phone -->
						{/if}
						
						<div class="form-floating">
							<input name="password" type="password" class="form-control" placeholder=' ' required>
							<label class="form-label">{__("Password")}</label>
						</div>
						
						<!-- custom fields -->
						{if $custom_fields}
							{include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true}
						{/if}
						<!-- custom fields -->
					  
						{if !$system['genders_disabled']}
							<div class="form-floating">
								<select class="form-select" name="gender" required>
									<option value="none">{__("Gender")}:</option>
									{foreach $genders as $gender}
										<option value="{$gender['gender_id']}">{$gender['gender_name']}</option>
									{/foreach}
								</select>
								<label class="form-label">{__("I am")}</label>
							</div>
						{/if}
						
						{if $system['age_restriction']}
							<!-- birthdate -->
							<div><label class="form-label">{__("Birthdate")}</label></div>
							<div class="row">
								<div class="col">
									<div class="form-floating">
										<select class="form-select" name="birth_month">
											<option value="none">{__("Month")}</option>
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
									</div>
								</div>
								<div class="col">
									<div class="form-floating">
										<select class="form-select" name="birth_day">
											<option value="none">{__("Day")}</option>
											{for $i=1 to 31}
												<option {if $user->_data['user_birthdate_parsed']['day'] == $i}selected{/if} value="{$i}">{$i}</option>
											{/for}
										</select>
									</div>
								</div>
								<div class="col">
									<div class="form-floating">
										<select class="form-select" name="birth_year">
											<option value="none">{__("Year")}</option>
											{for $i=1905 to 2023}
												<option {if $user->_data['user_birthdate_parsed']['year'] == $i}selected{/if} value="{$i}">{$i}</option>
											{/for}
										</select>
									</div>
								</div>
							</div>
							<!-- birthdate -->
						{/if}
						
						{if $system['select_user_group_enabled']}
							<!-- user group -->
							<div class="form-floating">
								<select class="form-select" name="custom_user_group">
									<option value="none">{__("User Group")}:</option>
									<option value="0">{__("Users")}</option>
									{foreach $user_groups as $user_group}
										<option value="{$user_group['user_group_id']}">{__($user_group['user_group_title'])}</option>
									{/foreach}
								</select>
								<label class="form-label">{__("User Group")}</label>
							</div>
							<!-- user group -->
						{/if}
						
						<!-- newsletter consent -->
						{if $system['newsletter_consent']}
							<div class="form-check mb10">
								<input type="checkbox" class="form-check-input" name="newsletter_agree" id="newsletter_agree">
								<label class="form-check-label" for="newsletter_agree">
									{__("I expressly agree to receive the newsletter")}
								</label>
							</div>
						{/if}
						<!-- newsletter consent -->
						
						<div class="form-check mb10">
							<input type="checkbox" class="form-check-input" name="privacy_agree" id="privacy_agree">
							<label class="form-check-label" for="privacy_agree">
								{__("By creating your account, you agree to our")} <a href="{$system['system_url']}/static/terms" target="_blank">{__("Terms")}</a> {__("and")} <a href="{$system['system_url']}/static/privacy" target="_blank">{__("Privacy Policy")}</a>
							</label>
						</div>
						
						<div class="my-4">
							<input value="{$user_profile->photoURL}" name="avatar" type="hidden">
							<input value="{$provider}" name="provider" type="hidden">
							<button type="submit" class="btn btn-primary d-block btn-lg w-100">{__("Sign Up")}</button>
						</div>
						
						<!-- error -->
						<div class="alert alert-danger mt15 mb0 x-hidden"></div>
						<!-- error -->
					</form>
				</div>
			</div>
		</div>
    </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}