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
		<div class="p-3">
			<div class="text-md">
				<h5 class="headline-font m-0">
					{__("Getting Started")}
				</h5>
			</div>
			
			<div class="mt-1 text-muted">
				{__("This information will let us know more about you")}
			</div>
			
			<hr class="my-3">
			
			<!-- nav -->
			<ul class="nav nav-pills nav-fill nav-started gap-3 js_wizard-steps">
				<li class="nav-item m-0">
					<a class="nav-link p-1 active" href="#step-1"></a>
				</li>
				<li class="nav-item m-0">
					<a class="nav-link p-1 disabled" href="#step-2"></a>
				</li>
				<li class="nav-item m-0">
					<a class="nav-link p-1 disabled" href="#step-3"></a>
				</li>
			</ul>
			<!-- nav -->

			<!-- tabs -->
			<div class="js_wizard-content" id="step-1">
				<h6 class="small mt-3 main">{__("Step 1")}/3</h6>
                <h3 class="headline-font">{__("Upload your photo")}</h3>
				
				<p class="">{__("Welcome")} <span class="fw-medium">{$user->_data['user_fullname']}</span>, {__("Let's start with your photo")}</p>

				<!-- profile-avatar -->
				<div class="d-flex align-items-center gap-3 pb-3">
					<div class="profile-avatar-wrapper rounded-circle bg-white p-1 position-relative mt-4">
						<img src="{$user->_data['user_picture']}" alt="">

						<!-- buttons -->
						<div class="profile-avatar-change position-absolute">
							<button type="button" class="btn bg-black text-white border-0 p-2 rounded-circle lh-1 flex-0 js_x-uploader" data-handle="picture-user">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M11.9256 1.5H12.0745H12.0745C14.2504 1.49998 15.9852 1.49996 17.3453 1.68282C18.7497 1.87164 19.9035 2.27175 20.8159 3.18414C21.7283 4.09653 22.1284 5.25033 22.3172 6.65471C22.5 8.01485 22.5 9.74959 22.5 11.9256V12.0744C22.5 14.2504 22.5 15.9852 22.3172 17.3453C22.1284 18.7497 21.7283 19.9035 20.8159 20.8159C19.9035 21.7283 18.7497 22.1284 17.3453 22.3172C15.9851 22.5 14.2504 22.5 12.0744 22.5H11.9256C9.74959 22.5 8.01485 22.5 6.65471 22.3172C5.25033 22.1284 4.09653 21.7283 3.18414 20.8159C2.27175 19.9035 1.87164 18.7497 1.68282 17.3453C1.49996 15.9852 1.49998 14.2504 1.5 12.0745V12.0745V11.9256V11.9255C1.49998 9.74958 1.49996 8.01484 1.68282 6.65471C1.87164 5.25033 2.27175 4.09653 3.18414 3.18414C4.09653 2.27175 5.25033 1.87164 6.65471 1.68282C8.01484 1.49996 9.74958 1.49998 11.9255 1.5H11.9256ZM14.5 7.5C14.5 6.39543 15.3954 5.5 16.5 5.5C17.6046 5.5 18.5 6.39543 18.5 7.5C18.5 8.60457 17.6046 9.5 16.5 9.5C15.3954 9.5 14.5 8.60457 14.5 7.5ZM18.3837 16.7501C19.0353 16.7494 19.692 16.8447 20.3408 17.0367L20.3352 17.0788C20.1762 18.2614 19.8807 18.9228 19.4019 19.4017C18.923 19.8805 18.2616 20.176 17.079 20.335C16.8154 20.3705 16.5334 20.3983 16.2302 20.4201C15.8204 19.4898 15.2721 18.615 14.6026 17.8175C15.8435 17.0978 17.1185 16.7451 18.3837 16.7501ZM3.51758 14.7603C3.537 15.6726 3.57813 16.4312 3.6652 17.0788C3.82419 18.2614 4.1197 18.9228 4.59856 19.4017C5.07741 19.8805 5.73881 20.176 6.92141 20.335C8.13278 20.4979 9.73277 20.5 12.0002 20.5C12.9843 20.5 13.8427 20.4996 14.5981 20.4858C13.8891 19.1287 12.8178 17.9128 11.4459 16.9476C9.36457 15.4832 6.73674 14.6994 4.03132 14.7525L4.01487 14.7527C3.849 14.7523 3.6832 14.7548 3.51758 14.7603Z" fill="currentColor"></path></svg>
							</button>
						</div>
						<div class="profile-avatar-change-loader position-absolute w-100 h-100 top-0 bottom-0 bg-black bg-opacity-50 rounded-circle">
							<div class="progress x-progress bg-white bg-opacity-50">
								<div class="progress-bar bg-white" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
							</div>
						</div>
						<!-- buttons -->
					</div>
				
					<div class="d-flex align-items-center gap-2">
						<div class="profile-avatar-crop {if $user->_data['user_picture_default'] || !$user->_data['user_picture_id']}x-hidden{/if}">
							<button type="button" class="btn bg-black text-white border-0 p-2 rounded-circle lh-1 flex-0 js_init-crop-picture" data-image="{$user->_data['user_picture_full']}" data-handle="user" data-id="{$user->_data['user_id']}">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M4 2V4M22 20H20M16.5 20H10C7.17157 20 5.75736 20 4.87868 19.1213C4 18.2426 4 16.8284 4 14V7.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 22L20 12C20 8.22877 20 6.34315 18.8284 5.17158C17.6569 4 15.7712 4 12 4L2 4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
							</button>
						</div>
						<div class="profile-avatar-delete {if $user->_data['user_picture_default']}x-hidden{/if}">
							<button type="button" class="btn bg-black text-white border-0 p-2 rounded-circle lh-1 flex-0 js_delete-picture" data-handle="picture-user">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.5 5.5L18.8803 15.5251C18.7219 18.0864 18.6428 19.3671 18.0008 20.2879C17.6833 20.7431 17.2747 21.1273 16.8007 21.416C15.8421 22 14.559 22 11.9927 22C9.42312 22 8.1383 22 7.17905 21.4149C6.7048 21.1257 6.296 20.7408 5.97868 20.2848C5.33688 19.3626 5.25945 18.0801 5.10461 15.5152L4.5 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M3 5.5H21M16.0557 5.5L15.3731 4.09173C14.9196 3.15626 14.6928 2.68852 14.3017 2.39681C14.215 2.3321 14.1231 2.27454 14.027 2.2247C13.5939 2 13.0741 2 12.0345 2C10.9688 2 10.436 2 9.99568 2.23412C9.8981 2.28601 9.80498 2.3459 9.71729 2.41317C9.32164 2.7167 9.10063 3.20155 8.65861 4.17126L8.05292 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M9.5 16.5L9.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M14.5 16.5L14.5 10.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
							</button>
						</div>
					</div>
				</div>
				<!-- profile-avatar -->
				
				<hr class="hr-2">

				<!-- buttons -->
				<div class="text-end">
					<button id="activate-step-2" class="btn btn-primary">{__("Next")}</button>
				</div>
				<!-- buttons -->
			</div>

			<div class="js_wizard-content x-hidden" id="step-2">
				<h6 class="small mt-3 main">{__("Step 2")}/3</h6>
                <h3 class="headline-font">{__("Update your info")}</h3>
				
				<p class="">{__("Share your information with our community")}</p>

				<form class="js_ajax-forms" data-url="users/started.php?do=update">
					<div class="heading-small mb-1">
						{__("Location")}
					</div>

					<div class="form-floating">
						<select class="form-select" name="country" id="country">
							<option value="none">{__("Select Country")}</option>
							{foreach $countries as $country}
								<option {if $user->_data['user_country'] == $country['country_id']}selected{/if} value="{$country['country_id']}">{$country['country_name']}</option>
							{/foreach}
						</select>
						<label class="form-label" for="country">{__("Country")}</label>
					</div>
					{if $system['location_info_enabled']}
						<div class="row">
							<div class="col-md-6">
								<div class="form-floating">
									<input type="text" class="form-control js_geocomplete" name="city" id="city" value="{$user->_data['user_current_city']}" placeholder=" ">
									<label class="form-label" for="city">{__("Current City")}</label>
								</div>
							</div>
							<div class="col-md-6">
								<div class="form-floating">
									<input type="text" class="form-control js_geocomplete" name="hometown" id="hometown" value="{$user->_data['user_hometown']}" placeholder=" ">
									<label class="form-label" for="hometown">{__("Hometown")}</label>
								</div>
							</div>
						</div>
					{/if}

					{if $system['work_info_enabled']}
						<div class="heading-small mb-1">
							{__("Work")}
						</div>
						<div class="form-floating">
							<input type="text" class="form-control" name="work_title" id="work_title" value="{$user->_data['user_work_title']}" placeholder=" ">
							<label class="form-label" for="work_title">{__("Work Title")}</label>
						</div>
						<div class="row">
							<div class="col-md-6">
								<div class="form-floating">
									<input type="text" class="form-control" name="work_place" id="work_place" value="{$user->_data['user_work_place']}" placeholder=" ">
									<label class="form-label" for="work_place">{__("Work Place")}</label>
								</div>
							</div>
							<div class="col-md-6">
								<div class="form-floating">
									<input type="text" class="form-control" name="work_url" id="work_url" value="{$user->_data['user_work_url']}" placeholder=" ">
									<label class="form-label" for="work_url">{__("Work Website")}</label>
								</div>
							</div>
						</div>
					{/if}

					{if $system['education_info_enabled']}
						<div class="heading-small mb-1">
							{__("Education")}
						</div>
						<div class="form-floating">
							<input type="text" class="form-control" name="edu_major" id="edu_major" value="{$user->_data['user_edu_major']}" placeholder=" ">
							<label class="form-label" for="edu_major">{__("Major")}</label>
						</div>
						<div class="row">
							<div class="col-md-6">
								<div class="form-floating">
									<input type="text" class="form-control" name="edu_school" id="edu_school" value="{$user->_data['user_edu_school']}" placeholder=" ">
									<label class="form-label" for="edu_school">{__("School")}</label>
								</div>
							</div>
							<div class="col-md-6">
								<div class="form-floating">
									<input type="text" class="form-control" name="edu_class" id="edu_class" value="{$user->_data['user_edu_class']}" placeholder=" ">
									<label class="form-label" for="edu_class">{__("Class")}</label>
								</div>
							</div>
						</div>
					{/if}

					<!-- success -->
					<div class="alert alert-success x-hidden"></div>
					<!-- success -->

					<!-- error -->
					<div class="alert alert-danger x-hidden"></div>
					<!-- error -->
					
					<hr class="hr-2 mt-0">

					<!-- buttons -->
					<div class="d-flex align-items-center justify-content-end flex-wrap gap-2">
						<button type="submit" class="btn btn-success">{__("Save Changes")}</button>
						<button type="button" class="btn btn-primary" id="activate-step-3">{__("Next")}</button>
					</div>
					<!-- buttons -->
				</form>
			</div>

			<div class="js_wizard-content x-hidden" id="step-3">
				<h6 class="small mt-3 main">{__("Step 3")}/3</h6>
                <h3 class="headline-font">
					{if $friends || $followers || $pages || $groups}
						{__("Manage Connections")}
					{else}
						{if $system['friends_enabled']}{__("Add Friends")}{else}{__("Add Followers")}{/if}
					{/if}
				</h3>
				
				<p class="">{__("Get latest activities from our popular users")}</p>

				<form class="js_ajax-forms" data-url="users/started.php?do=finish">
					{if $friends || $followers || $pages || $groups}
						<!-- friends -->
						{if $friends}
							<div class="heading-small mb-1">
								{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
							</div>
							<ul class="row">
								{foreach $friends as $_user}
									{include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true}
								{/foreach}
							</ul>
						{/if}
						<!-- friends -->
						<!-- followers -->
						{if $followers}
							<div class="heading-small mb-1">
								{__("Followers")}
							</div>
							<ul class="row">
								{foreach $followers as $_user}
									{include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true}
								{/foreach}
							</ul>
						{/if}
						<!-- followers -->
						<!-- pages -->
						{if $pages}
							<div class="heading-small mb-1">
								{__("Pages")}
							</div>
							<ul class="row">
								{foreach $pages as $_page}
									{include file='__feeds_page.tpl' _tpl="box" _darker=true}
								{/foreach}
							</ul>
						{/if}
						<!-- pages -->
						<!-- groups -->
						{if $groups}
							<div class="heading-small mb-1">
								{__("Groups")}
							</div>
							<ul class="row">
								{foreach $groups as $_group}
									{include file='__feeds_group.tpl' _tpl="box" _darker=true}
								{/foreach}
							</ul>
						{/if}
						<!-- groups -->
					{else}
						<!-- new people -->
						{if $new_people}
							<ul class="row">
								{foreach $new_people as $_user}
									{include file='__feeds_user.tpl' _tpl="box" _connection="add" _darker=true}
								{/foreach}
							</ul>
						{/if}
						<!-- new people -->
					{/if}

					<!-- success -->
					<div class="alert alert-success x-hidden"></div>
					<!-- success -->

					<!-- error -->
					<div class="alert alert-danger x-hidden"></div>
					<!-- error -->
					
					<hr class="hr-2 mt-0">

					<!-- buttons -->
					<div class="text-end">
						<button type="submit" class="btn btn-main">{__("Finish")}</button>
					</div>
					<!-- buttons -->
				</form>
			</div>
			<!-- tabs -->

		</div>
    </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}

<script>
  $(function() {

    var wizard_steps = $('.js_wizard-steps li a');
    var wizard_content = $('.js_wizard-content');

    wizard_content.hide();

    wizard_steps.click(function(e) {
      e.preventDefault();
      var $target = $($(this).attr('href'));
      if (!$(this).hasClass('disabled')) {
        wizard_steps.removeClass('active');
        $(this).addClass('active');
        wizard_content.hide();
        $target.show();
      }
    });

    $('.js_wizard-steps li a.active').trigger('click');

    $('#activate-step-2').on('click', function(e) {
      $('.js_wizard-steps li:eq(1) a').removeClass('disabled');
      $('.js_wizard-steps li a[href="#step-2"]').trigger('click');
    });

    $('#activate-step-3').on('click', function(e) {
      $('.js_wizard-steps li:eq(2) a').removeClass('disabled');
      $('.js_wizard-steps li a[href="#step-3"]').trigger('click');
    });

  });
</script>