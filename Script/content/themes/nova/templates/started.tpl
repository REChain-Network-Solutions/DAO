{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {include file='__page_header.tpl' _title=__("Getting Started") _text=__("This information will let us know more about you") _image="people.svg"}
  <!-- page heading -->

  <div class="mx-auto mt-6 max-w-4xl rounded-3xl border border-base-300 bg-base-100 p-4 sm:p-6">

    <!-- nav -->
    <ol class="js_wizard-steps grid gap-2 sm:grid-cols-3">
      <li>
        <a class="active group/step flex h-full items-center gap-3 rounded-2xl border border-base-300 p-3 text-base-content! transition-colors hover:bg-base-200 [&.active]:border-primary [&.active]:bg-primary/5 [&.disabled]:pointer-events-none [&.disabled]:opacity-50" href="#step-1">
          <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-full bg-base-200 text-sm font-bold group-[.active]/step:bg-primary group-[.active]/step:text-primary-content">1</span>
          <span class="min-w-0">
            <span class="block text-sm font-semibold">{__("Step 1")}</span>
            <span class="block truncate text-xs text-base-content/60" title='{__("Upload your photo")}'>{__("Upload your photo")}</span>
          </span>
        </a>
      </li>
      <li>
        <a class="disabled group/step flex h-full items-center gap-3 rounded-2xl border border-base-300 p-3 text-base-content! transition-colors hover:bg-base-200 [&.active]:border-primary [&.active]:bg-primary/5 [&.disabled]:pointer-events-none [&.disabled]:opacity-50" href="#step-2">
          <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-full bg-base-200 text-sm font-bold group-[.active]/step:bg-primary group-[.active]/step:text-primary-content">2</span>
          <span class="min-w-0">
            <span class="block text-sm font-semibold">{__("Step 2")}</span>
            <span class="block truncate text-xs text-base-content/60" title='{__("Update your info")}'>{__("Update your info")}</span>
          </span>
        </a>
      </li>
      <li>
        <a class="disabled group/step flex h-full items-center gap-3 rounded-2xl border border-base-300 p-3 text-base-content! transition-colors hover:bg-base-200 [&.active]:border-primary [&.active]:bg-primary/5 [&.disabled]:pointer-events-none [&.disabled]:opacity-50" href="#step-3">
          <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-full bg-base-200 text-sm font-bold group-[.active]/step:bg-primary group-[.active]/step:text-primary-content">3</span>
          <span class="min-w-0">
            <span class="block text-sm font-semibold">{__("Step 3")}</span>
            <span class="block truncate text-xs text-base-content/60" title='{if $friends || $followers || $pages || $groups}{__("Manage Connections")}{else}{__("Add Friends")}{/if}'>{if $friends || $followers || $pages || $groups}{__("Manage Connections")}{else}{__("Add Friends")}{/if}</span>
          </span>
        </a>
      </li>
    </ol>
    <!-- nav -->

    <!-- tabs -->
    <div class="js_wizard-content mt-8" id="step-1">
      <div class="text-center">
        <h2 class="text-xl font-bold">{__("Welcome")} <span class="text-primary">{$user->_data['user_fullname']}</span></h2>
        <p class="mt-1 text-sm text-base-content/60">{__("Let's start with your photo")}</p>
      </div>

      <!-- profile-avatar -->
      <div class="profile-avatar-wrapper group/avatar relative mx-auto mt-6 size-36 rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[3rem] bg-base-200 ring-1 ring-base-300 [&>img]:size-full [&>img]:rounded-[inherit] [&>img]:corner-squircle [&>img]:object-cover">
        <img src="{$user->_data['user_picture']}" alt="{$user->_data['user_fullname']}">

        <!-- buttons -->
        <div class="absolute end-2 bottom-2 z-20">
          <div class="profile-avatar-change dropdown relative inline-flex [--placement:bottom-start] [--strategy:fixed]">
            <button type="button" class="dropdown-toggle heroui button button--tertiary button--sm button--icon-only size-7.5 rounded-full border-transparent bg-base-100 text-base-content shadow-sm" aria-haspopup="menu" aria-expanded="false" aria-label='{__("Edit Picture")}' id="started-avatar-menu"><span class="icon-[tabler--camera] size-4" aria-hidden="true"></span></button>
            <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-60 max-w-[calc(100vw-2rem)] rounded-2xl border border-base-300 bg-base-100 p-2 shadow-lg [&_.x-uploader]:relative [&_.x-uploader:hover>.dropdown-item]:bg-neutral/10 [&_.x-uploader:focus-within>.dropdown-item]:bg-neutral/10 [&_.x-uploader]:cursor-pointer [&_.x-uploader]:overflow-hidden [&_.x-uploader>input[type=file]]:absolute [&_.x-uploader>input[type=file]]:inset-0 [&_.x-uploader>input[type=file]]:z-10 [&_.x-uploader>input[type=file]]:size-full [&_.x-uploader>input[type=file]]:cursor-pointer [&_.x-uploader>input[type=file]]:opacity-0" aria-labelledby="started-avatar-menu">
              <!-- upload -->
              <div class="dropdown-item flex h-11 cursor-pointer items-center gap-3 rounded-xl px-3 text-sm font-medium js_x-uploader" data-handle="picture-user">
                <span class="icon-[tabler--upload] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                <span>{__("Upload Photo")}</span>
              </div>
              <!-- upload -->
              <div class="profile-avatar-crop {if $user->_data['user_picture_default'] || !$user->_data['user_picture_id']}hidden{/if}">
                <button type="button" class="dropdown-item dropdown-close flex h-11 w-full items-center gap-3 rounded-xl px-3 text-start text-sm font-medium js_init-crop-picture" data-image="{$user->_data['user_picture_full']}" data-handle="user" data-id="{$user->_data['user_id']}">
                  <span class="icon-[tabler--crop] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                  <span>{__("Crop")}</span>
                </button>
              </div>
              <div class="profile-avatar-delete border-t border-base-300 pt-1 {if $user->_data['user_picture_default']}hidden{/if}">
                <button type="button" class="dropdown-item dropdown-close flex h-11 w-full items-center gap-3 rounded-xl px-3 text-start text-sm font-medium text-error! hover:bg-error/10! focus-visible:bg-error/10! js_delete-picture" data-handle="picture-user">
                  <span class="icon-[tabler--trash] size-5 shrink-0" aria-hidden="true"></span>
                  <span>{__("Delete")}</span>
                </button>
              </div>
            </div>
          </div>
        </div>
        <!-- buttons -->
        <!-- loaders -->
        <div class="profile-avatar-change-loader absolute inset-0 z-30 hidden rounded-[inherit] corner-squircle bg-base-100/80 px-3 pt-[45%]">
          <div class="progress x-progress h-2 w-full bg-base-300">
            <div class="progress-bar h-full rounded-full bg-primary" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
          </div>
        </div>
        <!-- loaders -->
      </div>
      <!-- profile-avatar -->

      <!-- buttons -->
      <div class="mt-8 flex justify-end border-t border-base-300 pt-6">
        <button type="button" id="activate-step-2" class="heroui button button--primary">{__("Next")}<span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span></button>
      </div>
      <!-- buttons -->
    </div>

    <div class="js_wizard-content mt-8 hidden" id="step-2">
      <div class="text-center">
        <h2 class="text-xl font-bold">{__("Update your info")}</h2>
        <p class="mt-1 text-sm text-base-content/60">{__("Share your information with our community")}</p>
      </div>

      <form class="js_ajax-forms mt-6" data-url="users/started.php?do=update">
        <div class="flex flex-col gap-6">
          <section class="flex flex-col gap-4">
            <h3 class="text-base font-semibold">{__("Location")}</h3>
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="country">{__("Country")}</label>
              <select class="select w-full" name="country" id="country">
                <option value="none">{__("Select Country")}</option>
                {foreach $countries as $country}
                  <option {if $user->_data['user_country'] == $country['country_id']}selected{/if} value="{$country['country_id']}">{$country['country_name_with_flag']}</option>
                {/foreach}
              </select>
            </div>
            {if $system['location_info_enabled']}
            <div class="grid gap-4 sm:grid-cols-2">
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="city">{__("Current City")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--map-pin] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow js_geocomplete" id="city" name="city" value="{$user->_data['user_current_city']}">
                </div>
              </div>
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="hometown">{__("Hometown")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--home] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow js_geocomplete" id="hometown" name="hometown" value="{$user->_data['user_hometown']}">
                </div>
              </div>
            </div>
            {/if}
          </section>

          {if $system['work_info_enabled']}
          <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
            <h3 class="text-base font-semibold">{__("Work")}</h3>
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="work_title">{__("Work Title")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--id-badge-2] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow" id="work_title" name="work_title" value="{$user->_data['user_work_title']}">
                </div>
              </div>
            <div class="grid gap-4 sm:grid-cols-2">
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="work_place">{__("Work Place")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--building] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow" id="work_place" name="work_place" value="{$user->_data['user_work_place']}">
                </div>
              </div>
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="work_url">{__("Work Website")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--link] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow" id="work_url" name="work_url" value="{$user->_data['user_work_url']}">
                </div>
              </div>
            </div>
          </section>
          {/if}

          {if $system['education_info_enabled']}
          <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
            <h3 class="text-base font-semibold">{__("Education")}</h3>
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="edu_major">{__("Major")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--book] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow" id="edu_major" name="edu_major" value="{$user->_data['user_edu_major']}">
                </div>
              </div>
            <div class="grid gap-4 sm:grid-cols-2">
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="edu_school">{__("School")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--building-community] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow" id="edu_school" name="edu_school" value="{$user->_data['user_edu_school']}">
                </div>
              </div>
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="edu_class">{__("Class")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--calendar] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow" id="edu_class" name="edu_class" value="{$user->_data['user_edu_class']}">
                </div>
              </div>
            </div>
          </section>
          {/if}

          <!-- success -->
          <div class="alert alert-success hidden items-center" role="status"></div>
          <!-- success -->

          <!-- error -->
          <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
          <!-- error -->
        </div>

        <!-- buttons -->
        <div class="mt-8 flex justify-end border-t border-base-300 pt-6">
          <button type="submit" class="heroui button button--primary">{__("Next")}<span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span></button>
        </div>
        <!-- buttons -->
      </form>
    </div>

    <div class="js_wizard-content mt-8 hidden" id="step-3">
      <div class="text-center">
        <h2 class="text-xl font-bold">
          {if $friends || $followers || $pages || $groups}
            {__("Manage Connections")}
          {else}
            {if $system['friends_enabled']}{__("Add Friends")}{else}{__("Add Followers")}{/if}
          {/if}
        </h2>
        <p class="mt-1 text-sm text-base-content/60">{__("Get latest activities from our popular users")}</p>
      </div>

      <form class="js_ajax-forms mt-6" data-url="users/started.php?do=finish">
        <div class="flex flex-col gap-6">
          {if $friends || $followers || $pages || $groups}
            <!-- friends -->
            {if $friends}
              <section class="flex flex-col gap-4">
                <h3 class="text-base font-semibold">{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}</h3>
                <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                  {foreach $friends as $_user}
                    {include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true}
                  {/foreach}
                </ul>
              </section>
            {/if}
            <!-- friends -->
            <!-- followers -->
            {if $followers}
              <section class="flex flex-col gap-4 border-t border-base-300 pt-6 first:border-t-0 first:pt-0">
                <h3 class="text-base font-semibold">{__("Followers")}</h3>
                <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                  {foreach $followers as $_user}
                    {include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true}
                  {/foreach}
                </ul>
              </section>
            {/if}
            <!-- followers -->
            <!-- pages -->
            {if $pages}
              <section class="flex flex-col gap-4 border-t border-base-300 pt-6 first:border-t-0 first:pt-0">
                <h3 class="text-base font-semibold">{__("Pages")}</h3>
                <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
                  {foreach $pages as $_page}
                    {include file='__pages_card.tpl' _darker=true}
                  {/foreach}
                </ul>
              </section>
            {/if}
            <!-- pages -->
            <!-- groups -->
            {if $groups}
              <section class="flex flex-col gap-4 border-t border-base-300 pt-6 first:border-t-0 first:pt-0">
                <h3 class="text-base font-semibold">{__("Groups")}</h3>
                <ul class="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4">
                  {foreach $groups as $_group}
                    {include file='__feeds_group.tpl' _tpl="box" _darker=true}
                  {/foreach}
                </ul>
              </section>
            {/if}
            <!-- groups -->
          {else}
            <!-- new people -->
            {if $new_people}
              <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {foreach $new_people as $_user}
                  {include file='__feeds_user.tpl' _tpl="box" _connection="add" _darker=true}
                {/foreach}
              </ul>
            {/if}
            <!-- new people -->
          {/if}

          <!-- success -->
          <div class="alert alert-success hidden items-center" role="status"></div>
          <!-- success -->

          <!-- error -->
          <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
          <!-- error -->
        </div>

        <!-- buttons -->
        <div class="mt-8 flex justify-end border-t border-base-300 pt-6">
          <button type="submit" class="heroui button button--primary"><span class="icon-[tabler--check] size-4" aria-hidden="true"></span>{__("Finish")}</button>
        </div>
        <!-- buttons -->
      </form>
    </div>
    <!-- tabs -->

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

  });
</script>